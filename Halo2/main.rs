// Copyright (c) 2023 zkCollective, Celer Network

use criterion::{
    Criterion
};
//mod sha256::{Sha256Circuit, get_sha256_data};
mod sha_cir;
use sha_cir::{sha256};
use halo_utils::{read_file_from_env_var};

use rand::rngs::OsRng;
use halo2_proofs::{
    plonk::{keygen_vk, keygen_pk, create_proof, verify_proof, ProvingKey, VerifyingKey, Circuit},
    poly::{
        kzg::{
            commitment::{ParamsKZG, KZGCommitmentScheme}, 
            multiopen::{ProverGWC, VerifierGWC}, 
            strategy::SingleStrategy,
        }
    }, 
    halo2curves::bn256::{Bn256, G1Affine, Fr}, 
    transcript::{
        Blake2bRead, Blake2bWrite, Challenge255, TranscriptReadBuffer, TranscriptWriterBuffer,
    },
};
use std::{env, fs::File};
use std::io::{BufReader, Read, Write};
use std::process;
use psutil;
use std::fs;
use clap::Parser;
use serde::Serialize;

use halo2_proofs::poly::VerificationStrategy;
use halo2_proofs::SerdeFormat;

use criterion::{
    measurement::Measurement, BenchmarkGroup,
};

use std::convert;


fn bench_sha256(c: &mut Criterion, input_file_str: String) {
    let mut group = c.benchmark_group("sha256");
    let (k, sha_data) = sha256::get_sha256_data(input_file_str);
    let circuit = sha256::Sha256Circuit {
        sha_data: sha_data, 
    };
    let public_input: &[&[Fr]] = &[];
    //bench_circuit(&mut group, k, circuit, public_input);
    // setup
    let mut params: Option<ParamsKZG<Bn256>> = None;
    //let params = ParamsKZG::<Bn256>::setup(k, OsRng);
    let mut pk: Option<ProvingKey<G1Affine>> = None;
    let mut vk: Option<VerifyingKey<G1Affine>> = None;
    group.bench_function("setup", |b| {
        b.iter(|| { 
		params = Some(ParamsKZG::<Bn256>::setup(k, OsRng));
    		vk = Some(keygen_vk(params.as_ref().unwrap(), &circuit.clone()).unwrap());
    		pk = Some(keygen_pk(params.as_ref().unwrap(), vk.clone().unwrap(), &circuit).unwrap());
    	});
    });
    // prove
    let mut proof: Option<Vec<u8>> = None;
    group.bench_function("prove", |b| {
         b.iter(|| { 
    		let mut transcript = Blake2bWrite::<_, _, Challenge255<_>>::init(vec![]);
    		create_proof::<
        		KZGCommitmentScheme<Bn256>,
        		ProverGWC<'_, Bn256>,
        		Challenge255<G1Affine>,
        		_,
        		Blake2bWrite<Vec<u8>, G1Affine, Challenge255<_>>,
        		_,
    		>(
        		params.as_ref().unwrap(),
        		pk.as_ref().unwrap(),
        		&[circuit.clone()],
        		&[public_input],
        		OsRng,
        		&mut transcript,
    	)
    		.expect("prover should not fail");
    		proof = Some(transcript.finalize());
    	});
    });
    // verify
    group.bench_function("verify", |b| {
	let proof = proof.clone().unwrap();
	b.iter(|| {
    		let strategy = SingleStrategy::new(params.as_ref().unwrap(),);
    		let mut transcript = Blake2bRead::<_, _, Challenge255<_>>::init(&proof[..]);
    		let _strategy = verify_proof::<KZGCommitmentScheme<_>, VerifierGWC<_>, _, _, _>(
        		params.as_ref().unwrap(),
       			pk.as_ref().unwrap().get_vk(),
        		strategy,
        		&[public_input],
        		&mut transcript,
    		).unwrap();
	})
    });
}


fn main() {
    let mut criterion = Criterion::default().configure_from_args().sample_size(100);

    let input_file_str = read_file_from_env_var("INPUT_FILE".to_string());

    bench_sha256(&mut criterion, input_file_str);

    criterion.final_summary();
}

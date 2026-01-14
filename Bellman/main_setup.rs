// Copyright (c) 2023 zkCollective, Celer Network

// Extern crate declarations
extern crate rand;
extern crate criterion;

// Use statements
mod sha_circuit;
use sha_circuit::{sha256};
use rand::thread_rng;
use bellman::{Circuit, groth16};
use criterion::{Criterion, BenchmarkGroup};
use criterion::measurement::Measurement;
use sha2::{Digest, Sha256};
use bellman::gadgets::multipack;
use bellman_utils::{read_file_from_env_var, read_env_variable, BinaryArgs, f_setup, f_verify, f_prove, read_file_contents};
use bls12_381::{Bls12, Scalar};
use ff::PrimeField;
use bellman::gadgets::test::TestConstraintSystem;

fn main() {
    //let args = BinaryArgs::parse();

    //let input_str = read_file_contents(args.input);

    let mut criterion = Criterion::default()
        .configure_from_args()
        .sample_size(100);

    let input_file_str = read_file_from_env_var("INPUT_FILE".to_string());

    //let circuit_str = read_env_variable("CIRCUIT".to_string());

    bench_sha256(&mut criterion, input_file_str);
    criterion.final_summary();
}

// b.iter ... means benchmark


// Benchmark for SHA-256
fn bench_sha256(c: &mut Criterion, input_str: String) {
    let mut group = c.benchmark_group("sha256");
    let (preimage_length, preimage) = sha256::get_sha256_data(input_str);

    // Pre-Compute public inputs
    let hash = Sha256::digest(&preimage);
    let hash_bits = multipack::bytes_to_bits_le(&hash);
    let inputs = multipack::compute_multipacking(&hash_bits);

    // Define the circuit
    let circuit = sha256::Sha256Circuit {
        preimage: Some(preimage.clone()),
        preimage_length: preimage_length,
    };

    let params = groth16::generate_random_parameters::<Bls12, _, _>(circuit.clone(), &mut thread_rng()).unwrap();
    // Generate Parameters
    print!("generating the parameters!\n");
    group.bench_function("setup", |b| {
        b.iter(|| { 
    		let _ = groth16::generate_random_parameters::<Bls12, _, _>(circuit.clone(), &mut thread_rng()).unwrap();
	})
    });
    run_circ(&mut group, circuit, inputs, params);

    //let rng = &mut thread_rng();
    //let pvk = groth16::prepare_verifying_key(&params.vk);

    //let _ = groth16::generate_random_parameters::<Bls12, _, _>(circuit.clone(), rng).unwrap();

    //let proof = groth16::create_random_proof(circuit.clone(), &params, rng).unwrap();

    //let _ = groth16::verify_proof(&pvk, &proof, &inputs).unwrap();

}

pub fn run_circ<M: Measurement, C: Circuit<Scalar> + Clone + 'static>(
    c: &mut BenchmarkGroup<'_, M>,
    circuit: C,
    inputs: Vec<Scalar>,
    params: groth16::Parameters<Bls12>
) {

  //  let rng = &mut thread_rng();
  //  let pvk = groth16::prepare_verifying_key(&params.vk);

    //print!("generating random params");
    //let _ = groth16::generate_random_parameters::<Bls12, _, _>(circuit.clone(), rng).unwrap();

//    print!("generating the proof\n");
 //   c.bench_function("prove", |b| {
//        b.iter(|| { 
//    		let _ = groth16::create_random_proof(circuit.clone(), &params, rng).unwrap();
//    	})
//    });
//    let proof = groth16::create_random_proof(circuit.clone(), &params, rng).unwrap(); 
//    print!("verifying the proof\n");
//    c.bench_function("verify", |b| {
//        b.iter(|| {
//    		let _ = groth16::verify_proof(&pvk, &proof, &inputs).unwrap();
//	})
//    });
//    assert!(groth16::verify_proof(&pvk, &proof, &inputs).is_ok());
}

// Copyright (c) 2023 zkCollective, Celer Network

extern crate rand;
extern crate criterion;

use rand::thread_rng;
use bellman::{Circuit, groth16};
use criterion::{Criterion, BenchmarkGroup};
use criterion::measurement::Measurement;
use sha2::{Digest, Sha256};
use bellman::gadgets::multipack;
use bellman_utils::{read_file_from_env_var, read_env_variable};
use bls12_381::{Bls12, Scalar};
use ff::PrimeField;
use bellman::gadgets::test::TestConstraintSystem;
//use bellman_circuits::circuits::sha256;
use bellman::{
    gadgets::{
        boolean::{AllocatedBit, Boolean},
        sha256::sha256,
    },
    ConstraintSystem, SynthesisError,
};

use serde::{Serialize, Deserialize};
use serde_json;

#[derive(Clone)]
pub struct Sha256Circuit {
    /// The input to SHA-256d we are proving that we know. Set to `None` when we
    /// are verifying a proof (and do not have the witness data).
    pub preimage: Option<Vec<u8>>,
    pub preimage_length: usize,
}

impl<Scalar: PrimeField> Circuit<Scalar> for Sha256Circuit {
    fn synthesize<CS: ConstraintSystem<Scalar>>(self, cs: &mut CS) -> Result<(), SynthesisError> {
        // Compute the values for the bits of the preimage. If we are verifying a proof,
        // we still need to create the same constraints, so we return an equivalent-size
        // Vec of None (indicating that the value of each bit is unknown).
        let bit_values = if let Some(preimage) = self.preimage {
            assert_eq!(preimage.len(), self.preimage_length);
            preimage
                .into_iter()
                .map(|byte| (0..8).map(move |i| (byte >> i) & 1u8 == 1u8))
                .flatten()
                .map(|b| Some(b))
                .collect()
        } else {
            vec![None; self.preimage_length * 8]
        };
        assert_eq!(bit_values.len(), self.preimage_length * 8);

        // Witness the bits of the preimage.
        let preimage_bits = bit_values
            .into_iter()
            .enumerate()
            // Allocate each bit.
            .map(|(i, b)| {
                AllocatedBit::alloc(cs.namespace(|| format!("preimage bit {}", i)), b)
            })
            // Convert the AllocatedBits into Booleans (required for the sha256 gadget).
            .map(|b| b.map(Boolean::from))
            .collect::<Result<Vec<_>, _>>()?;

        // Compute hash = SHA-256d(preimage).
        let hash = sha256d(cs.namespace(|| "SHA-256d(preimage)"), &preimage_bits)?;

        // Expose the vector of 32 boolean variables as compact public inputs.
        multipack::pack_into_inputs(cs.namespace(|| "pack hash"), &hash)
    }
}

/// Our own SHA-256d gadget. Input and output are in little-endian bit order.
fn sha256d<Scalar: PrimeField, CS: ConstraintSystem<Scalar>>(
    mut cs: CS,
    data: &[Boolean],
) -> Result<Vec<Boolean>, SynthesisError> {
    // Flip endianness of each input byte
    let input: Vec<_> = data
        .chunks(8)
        .map(|c| c.iter().rev())
        .flatten()
        .cloned()
        .collect();

    let mid = sha256(cs.namespace(|| "SHA-256(input)"), &input)?;
    // let res = sha256(cs.namespace(|| "SHA-256(mid)"), &mid)?;

    // Flip endianness of each output byte
    Ok(mid
        .chunks(8)
        .map(|c| c.iter().rev())
        .flatten()
        .cloned()
        .collect())
}

#[derive(Debug, Deserialize, Serialize)]
pub struct SHA256Input {
    PreImage: String,
    Hash: String,
}

pub fn get_sha256_data (
    input_str: String
) -> (usize, Vec<u8> ){
    let input: SHA256Input = serde_json::from_str(&input_str)
        .expect("JSON was not well-formatted");
    let preimage = hex::decode(input.PreImage).unwrap();
    let preimage_length = preimage.len();
    return (preimage_length, preimage);
}



// Benchmark for SHA-256
fn bench_sha256(c: &mut Criterion, input_str: String) {
    let mut group = c.benchmark_group("sha256");
    let (preimage_length, preimage) = get_sha256_data(input_str);

    // Pre-Compute public inputs
    let hash = Sha256::digest(&preimage);
    let hash_bits = multipack::bytes_to_bits_le(&hash);
    let inputs = multipack::compute_multipacking(&hash_bits);

    // Define the circuit
    let circuit = Sha256Circuit {
        preimage: Some(preimage.clone()),
        preimage_length: preimage_length,
    };

    // Generate Parameters
    print!("generating the parameters!\n");
    let params = groth16::generate_random_parameters::<Bls12, _, _>(circuit.clone(), &mut thread_rng()).unwrap();

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

    let rng = &mut thread_rng();
    let pvk = groth16::prepare_verifying_key(&params.vk);

    //print!("generating random params");
    //let _ = groth16::generate_random_parameters::<Bls12, _, _>(circuit.clone(), rng).unwrap();

    print!("generating the proof\n");
    let proof = groth16::create_random_proof(circuit.clone(), &params, rng).unwrap();

    print!("verifying the proof\n");
    assert!(groth16::verify_proof(&pvk, &proof, &inputs).is_ok());
}

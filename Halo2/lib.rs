// Copyright (c) 2023 zkCollective, Celer Network

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
use halo2_proofs::poly::VerificationStrategy;
use halo2_proofs::SerdeFormat;
use criterion::{
    measurement::Measurement, BenchmarkGroup,
};
use serde::Serialize;
use std::{env, fs::File};
use std::io::{BufReader, Read, Write};
use std::process;
use psutil;
use std::fs;
use clap::Parser;

pub const DEFAULT_SERDE_FORMAT: SerdeFormat = SerdeFormat::RawBytesUnchecked;

pub fn read_file_contents(file_name: String) -> String {
    let mut file = File::open(file_name).expect("Cannot load file");
    let mut file_str = String::new();
    file.read_to_string(&mut file_str).expect("Cannot read file");
    return file_str;
}

pub fn read_file_from_env_var(env_var_name: String) -> String {
    let input_file = env::var(env_var_name.clone()).unwrap_or_else(|_| {
        println!("Please set the {} environment variable to point to the input file", env_var_name);
        process::exit(1);
    });
    return read_file_contents(input_file);
}


pub fn measure_size_in_bytes(data: &[u8]) -> usize {
    // TODO: Should we serialize the proof in another format?
    // Serialize data and save it to a temporary file
    let temp_file_path = "temp_file.bin";
    std::fs::write(
        temp_file_path,
        data
    ).expect("Could not write to temp file");

    // Measure the size of the file
    let file_size: usize = fs::metadata(&temp_file_path).expect("Cannot read the size of temp file").len() as usize;

    // Convert file size to MB
    let size_in_mb = file_size;

    // Remove the temporary file
    fs::remove_file(&temp_file_path).expect("Cannot remove temp file");

    return size_in_mb;
}


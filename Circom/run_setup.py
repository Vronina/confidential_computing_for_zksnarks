import subprocess
import sys
import time
import argparse

def run_command(command):
    start_time = time.perf_counter()
    try:
        subprocess.run(command, shell=True, check=True)
        end_time = time.perf_counter()
        execution_time = end_time - start_time
        print(f"Command '{command}' executed in {execution_time:.2f} seconds")
    except subprocess.CalledProcessError as e:
        print(f"Command '{command}' failed with error: {e}")
        execution_time = None
    return execution_time


def run_benchmark(input_file):
	with open("/root/time_consumption_benchmark_setup.txt", "w", encoding="utf-8") as file:
		file.write(f"Voting Circuit\n")

		for i in range(100):
			ex_time_setup = run_command(f"node --max_old_space_size=128000 /root/circomlib/node_modules/snarkjs/cli.js groth16 setup /root/circomlib/circuits/sha256/tmp/bytes.r1cs /root/circomlib/circuits/sha256/phase1/powersOfTau28_final.ptau /root/circomlib/circuits/sha256/tmp/bytes_0.zkey")
			file.write(f"Iteration {i}: setup: {ex_time_setup}\n")



def main():
	run_benchmark(sys.argv[1])

if __name__ == "__main__":
    main()

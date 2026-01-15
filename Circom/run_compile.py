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
	with open("time_consumption_benchmark_compile.txt", "w", encoding="utf-8") as file:
		file.write(f"Voting Circuit\n")

		for i in range(100):
			ex_time_compile = run_command(f"circom bytes.circom --r1cs --wasm --sym --c --output tmp | tee tmp/circom_output")
			file.write(f"Iteration {i}: compile: {ex_time_compile}\n")



def main():
	run_benchmark(sys.argv[1])

if __name__ == "__main__":
    main()

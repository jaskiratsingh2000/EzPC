import re
import numpy as np
import sys
import os
import parse_config


def convert_raw_output_to_np(filename, bitlength, scale):
    matcher = re.compile(r"[-]?[0-9]+")
    scaled_array = []
    with open(filename, "r") as f:
        for line in f:
            match = matcher.fullmatch(line.rstrip())
            if match:
                unsigned_number = int(match.group(0))
                number = (
                    unsigned_number
                    if (unsigned_number < 2 ** (bitlength - 1))
                    else unsigned_number - 2 ** bitlength
                )
                scaled_array.append(float(number) / (2 ** scale))
    return np.array(scaled_array)


if __name__ == "__main__":
    if len(sys.argv) < 3:
        print("Usage: python get_output.py mpc_output.txt config.json")
    output_fname = sys.argv[1]
    config_name = sys.argv[2]
    params = parse_config.get_params(config_name)
    scale = params["scale"]
    bitlength = params["bitlength"]
    bitlength = 64 if bitlength is None else bitlength
    model_name = os.path.splitext(params["model_name"])[0]
    np_arr = convert_raw_output_to_np(output_fname, bitlength, scale)
    np.save(model_name + "_output", np_arr)
    print("Output dumped as np array in " + model_name + "_output.npy")

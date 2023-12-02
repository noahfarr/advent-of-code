import re

DIGIT_MAPPING = {
    "one": "o1e",
    "two": "t2o",
    "three": "t3e",
    "four": "f4r",
    "five": "f5e",
    "six": "s6x",
    "seven": "s7n",
    "eight": "e8t",
    "nine": "n9e",
}

def parse_words_to_digits(line):
    for word, digit in DIGIT_MAPPING.items():
        line = line.replace(word, digit)
    return line


def main():
    calibration_values = []
    with open("/home/noah/Documents/advent-of-code/2023/day_1/input.txt") as f:
        lines = f.readlines()
    
    for line in lines:
        line = parse_words_to_digits(line)
        calibration_value = get_calibration_value(line)
        calibration_values.append(calibration_value)
    
    print(sum(calibration_values))

def get_calibration_value(line):
    line = re.sub(r"[A-z]", "", line).strip()
    return int(line[0] + line[-1])

main()
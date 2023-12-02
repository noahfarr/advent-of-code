import re, math

N_COLORS = {
    "red": 12,
    "green": 13,
    "blue": 14,
}

def main():
    lines = get_lines("/home/noah/Documents/advent-of-code/advent-of-code/src/2023/day_2/input.txt")
    print(part_1(lines))
    print(part_2(lines))
    print(part_1_regex(lines))
    print(part_2_regex(lines))

    
def get_lines(path: str):
    with open(path) as f:
        lines = f.readlines()
    return lines

# SOLUTION WITHOUT REGEX
    
def part_1(lines: str):
    valid_ids = []
    for line in lines:
        game_id, drawings = parse_line(line)
        if is_valid_game(drawings):
            valid_ids.append(game_id)   
            
    return sum(valid_ids)
    

def part_2(lines: str):
    powers = []
    for line in lines:
        max_counts = {"red": 0, "green": 0, "blue": 0}
        _, drawings = parse_line(line)
        for count, color in drawings:
            if count > max_counts[color]:
                max_counts[color] = count
        red, green, blue = max_counts.values()
        powers.append(red * green * blue)
    
    return sum(powers)
    
def is_valid_game(drawings):
    return all(count <= N_COLORS[color] for count, color in drawings)
     
def parse_line(line):
    drawings = []
    game_id, sets = line.split(":")
    game_id = game_id.split()[-1]
    for _set in sets.split(";"):
        for drawing in _set.split(","):
            count, color = drawing.split()
            drawings.append((int(count), color))
    return int(game_id), drawings
            
                    
def part_1_regex(lines):
    valid_ids = sum([game_id if all([int(count) <= N_COLORS[color] for count, color in re.findall("(\d+) ([a-zA-Z]*)", line)]) else 0 for game_id, line in enumerate(lines, 1)])
    return valid_ids

def part_2_regex(lines):
    minimum_set_of_cubes = sum([math.prod([max([int(match) for match in re.findall(f"(\d+) {color}", line)]) for color in ["red", "green", "blue"]]) for line in lines])
    return minimum_set_of_cubes
    
if __name__ == '__main__':
    main()
use std::fs::File;
use std::io::{BufRead, BufReader};

fn main() -> std::io::Result<()> {
    // Open the file for reading
    let file = File::open("/home/noah/Documents/advent-of-code/src/2023/day_1/input.txt")?;

    // Create a buffered reader to read the file
    let reader = BufReader::new(file);

    // Read the file line by line
    for line in reader.lines() {
        // Get the line
        let line = line.unwrap();

        // Get the first digit in the line
        for c in line {
            if c.isdigit(10) {
                
            }
        }

        // Print the line
        println!("{}", line);
    }



    Ok(())
}
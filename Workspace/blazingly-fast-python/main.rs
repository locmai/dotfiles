use std::time::Instant;

fn factorial(n: u64) -> u64 {
    match n {
        0 => 1,
        _ => n * factorial(n-1),
    }
}

fn main() {
    let start = Instant::now();
    factorial(20);
    let duration = start.elapsed();
    println!("Time taken in Rust: {:?}", duration);
}

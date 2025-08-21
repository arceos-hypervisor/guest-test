#![no_std]
#![no_main]

#[cfg(target_arch = "aarch64")]
extern crate axplat_aarch64_dyn;

#[cfg(target_arch = "x86_64")]
extern crate axplat_x86_pc;

#[macro_use]
extern crate axstd as std;

#[unsafe(no_mangle)]
fn main() {
    println!("Hello, world!");
}

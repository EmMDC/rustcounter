# rustcounter — a lockless, thread-safe atomic counter kernel module

_A Linux kernel module written in safe Rust that exposes a concurrent counter as a character device._

## Demo

Two terminals each firing 1,000 writes at `/dev/rustcounter` in parallel:

<table>
  <tr>
    <td><img src="rustcounter/vm1.gif" alt="VM 1 — 1,000 concurrent writes" width="100%"></td>
    <td><img src="rustcounter/vm2.gif" alt="VM 2 — 1,000 concurrent writes" width="100%"></td>
  </tr>
</table>

After both loops finish, `cat` returns exactly 2,000 every single time without any issue! The equivalent C code with `count++` and no synchronization would lose increments and would not have the guaranteed 2000 of this rust version.In fact Rust's type system would refuse to compile it.

## What this is

rustcounter is a Linux kernel module that shows off Rust's compiler-enforced data-race prevention. Concurrent writes to the device get aggregated by an `AtomicU64`, so thousands of parallel writes always produce the exact total with no locks involved. The same code in C without explicit synchronization would silently lose increments. Rust just won't let it compile.

## Build & run

You need a Rust-enabled kernel (`CONFIG_RUST=y`). Ubuntu 26.04 LTS ships with this out of the box. The toolchain expects `rustc-1.93` and matching kernel headers. The Rust for Linux [quick start](https://docs.kernel.org/rust/quick-start.html) covers it if you're starting from scratch.

Steps to install the toolchain inside your Multipass VM if that is how you are opting to run this:

```
sudo apt update
sudo apt install -y build-essential linux-headers-$(uname -r) kmod tree
sudo apt install -y rustc-1.93 rust-1.93-src bindgen
sudo update-alternatives --install /usr/bin/rustc rustc /usr/bin/rustc-1.93 100
```

Then install the Rust kernel support files:

```
sudo apt install -y linux-lib-rust-$(uname -r)
```

> **Note on the `linux-lib-rust` install.** On my Windows 11 + Multipass setup, running only apt commands without installing the Rust kernel support files gave me `error[E0463]: can't find crate for 'core'` when I tried to build a test skeleton module. Kernel Rust runs `no_std` and links against pre-compiled `core`, `alloc`, and `kernel` artifacts plus a custom `target.json` that describes the kernel's ABI. All of that lives at `/lib/modules/$(uname -r)/build/rust/`, and on my VM that directory was empty.
>
> The rustc error suggested `rustup target add ...`, but following that would install a second Rust toolchain and trigger the "compiler differs from the one used to build the kernel" error instead. I tracked down the real fix by running `apt-cache search "linux.*rust"`, which surfaced `linux-lib-rust-7.0.0-14-generic`, a package that wasn't installed through the initial toolchain. Installing it populated the missing directory with `core.o`, `alloc.o`, `kernel.o`, and `target.json`, and the build went through clean.
>
> Best guess at why it was missing: the 2024 to 2026 Rust-for-Linux API migration split the Rust artifacts out of `linux-headers-*` into their own package so C-only kernel devs don't have to download them, and the assignment's apt list didn't get updated to match. Nothing in the documented install line declares a dependency on `linux-lib-rust-*`, so apt has no reason to pull it in.

Confirm the Rust support files are actually there before building:

```
ls /lib/modules/$(uname -r)/build/rust
```

You should see `core.o`, `alloc.o`, `kernel.o`, and `target.json`.

Build the module:

> ** Note: Make sure you are within the rustcounter folder when doing this command

```
make
```

Load it and poke at it:

```
sudo insmod rustcounter.ko
sudo cat /dev/rustcounter                        # → 0
echo bump | sudo tee /dev/rustcounter > /dev/null
echo bump | sudo tee /dev/rustcounter > /dev/null
sudo cat /dev/rustcounter                        # → 2
sudo rmmod rustcounter
```

For the concurrent demo, open two `shell` sessions and run `for i in {1..1000}; do echo bump | sudo tee /dev/rustcounter > /dev/null; done` in each. The final `cat` always returns exactly 2000. Ensure that both sessions complete. If you run cat preemptively while one is still running this will not show the complete 2000 number.

Full command chain for the concurrent demo:

Session 1

```
sudo insmod rustcounter.ko
ls -la /dev/rustcounter
sudo cat /dev/rustcounter                       # → "0"
for i in {1..1000}; do echo bump | sudo tee /dev/rustcounter > /dev/null; done
```

Session 2

```
for i in {1..1000}; do echo bump | sudo tee /dev/rustcounter > /dev/null; done
```

After both sessions finish in either session run the following to get the counter results

```
sudo cat /dev/rustcounter                       # → "2000"
sudo rmmod rustcounter
```

## Code Tour

Start at init (line 27 of rustcounter.rs). The module's entry point logs a load message, registers a `MiscDeviceOptions` named `rustcounter`, and pins the registration into the module struct. The kernel creates the device node for you once the registration succeeds.

The interesting half is `write_iter`. The design of the code is so that any write counts as one increment, no matter what bytes were written, so the function `write_iter` does two jobs.

First, it drains the user's bytes into a local `KVec` via `iov.copy_from_iter_vec`. This isn't because we want the data, it's because the syscall's contract says the kernel consumed `n` bytes even though we don't want them. So by copying the input into the `kvec`, since it is a local variable, the `kvec` goes out of scope (and is freed) at end of function.

Second, it runs `COUNT.fetch_add(1, Ordering::SeqCst) + 1`. `fetch_add` is the atomic read-modify-write: it returns the _previous_ value and atomically adds 1 to the stored value. The `+ 1` on the outside gets the _new_ value back for the `pr_info!` log line. On x86 this compiles down to a single `LOCK XADD` instruction; on ARM64 it's `ldaddal`. After the increment, it clears the `CONSUMED` flag so the next reader sees the new value.

Finish at `read_iter`. The `CONSUMED.swap(true, SeqCst)` sets the flag to true and then returns the previous value. In the event that the flag was already true than the system returns Ok and ends the file. Without this, `cat` would loop forever on the same value. Below that, the count gets formatted into a `CString` and the `?`transmits any allocations error. `iov` copies the formatted bytes back to user space so multi-call reads complete the message cleanly.

## Design Notes

**Why `AtomicU64` instead of `Mutex<u64>`?**
A mutex would be correct but wasteful. The only operation needed is "fetch current value and add 1," which the CPU has a single instruction for (`LOCK XADD` on x86, `ldaddal` on ARM64). A mutex adds two memory fences plus potentially a scheduler interaction on contention. The cheapest synchronization that's still correct is the right one.

**Why `SeqCst` instead of `Relaxed`?**
A counter that only ever does `fetch_add` could technically use `Ordering::Relaxed` since the operation itself is atomic regardless of ordering. `SeqCst` is the safer default though, and the cost difference is negligible at this scale. The rule I follow: pick `SeqCst` unless you can articulate why a weaker ordering is correct.

**Why a separate `CONSUMED` flag instead of comparing `ki_pos` against the formatted length?**
Comparing against length would work for a single open, but the count's string length changes (`9` vs `10` vs `100`) and the flag generalizes more cleanly.

## Future Work

- A `/proc/rustcounter` entry that reads the count without consuming. Lets a sysadmin observe the counter without affecting subsequent `cat` behavior. (Course callback: LN23's `/proc` walkthrough.)
- A "RESET" command. When the user writes the literal string `RESET\n`, set the count to 0 instead of incrementing. Demonstrates parsing structured input.
- Per-process counts. Track a `HashMap<pid, u64>` keyed by the writing process's PID. Each PID sees its own count.
- Histogram of write rates. Track timestamps of recent writes (jiffies-based) and compute a rolling rate.
- Saturating counter. Wrap or clamp at `u64::MAX` instead of overflowing.
- Expose write rate as a module parameter.

## License

Licensed GPL-2.0 to match the Linux kernel.

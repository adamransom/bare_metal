@; Hangs the CPU for a specific number of microseconds using
@; the Sytem Timer
@;
@; Rust Signature: fn Wait(microseconds: u32)
.section .text
.global Wait
Wait:
  push {r4} @; Save the r4 register as we'll use it
  delay .req r0
  timer .req r1
  start .req r2
  ldr timer, =0x3f003000 @; Load the system timer base address
  ldr start, [timer, #0x4] @; Load the current counter (lowest 32-bits)

  loop$:
    elapsed .req r3
    now .req r4
    ldr now, [timer, #0x4] @; Load the current counter (lowest 32-bits)
    sub elapsed, now, start @; Subtract the current count from the start
    cmp elapsed, delay @; Compare elapsed with the requested delay
    .unreq elapsed
    bls loop$ @; Continue waiting if elapsed is less than delay

  pop {r4} @; Restore used register
  mov pc, lr @; Return from the function

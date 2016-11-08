@;
@; These are functions to aid communicating with the GPU via the mailbox
@; interface.

@; Mailbox base address: 0x3f00b880
@; Mailbox 0 read address:   [0x3f00b880, #0x0]
@; Mailbox 0 status address: [0x3f00b880, #0x18]
@; Mailbox 0 write address:  [0x3f00b880, #0x20]
@;
@; Note: The mailbox 0 write address is actually the mailbox 1 read address
@;

@; Write a message to the GPU's mailbox (1)
@;
@; Rust Signature: fn MailboxWrite(data: u32, channel: u32)
.section .text
.global MailboxWrite
MailboxWrite:
  message .req r0
  add message, r1 @; Add the channel to the message
  mailbox .req r2
  ldr mailbox, =0x3f00b880 @; Load the mailbox's base address into r2

  wait_write$:
    status .req r3
    ldr status, [mailbox, #0x18] @; Load the status of the mailbox (0)
    tst status, #0x80000000 @; Check the status against the FULL bit
    .unreq status
    bne wait_write$ @; Keep checking the mailbox until it isn't full

  str message, [mailbox, #0x20] @; Put the message in the mailbox (1)
  .unreq mailbox
  .unreq message
  mov pc, lr @; Return from the function

@; Read a message from the GPU's mailbox (0)
@;
@; Rust Signature: fn MailboxRead(channel: u32) -> u32
.global MailboxRead
MailboxRead:
  channel .req r0
  mailbox .req r1
  ldr mailbox, =0x3f00b880 @; Load the mailbox's base address into r1

  wait_read$:
    status .req r2;
    ldr status, [mailbox, #0x18] @; Load the mailbox (0) status address
    tst status, #0x40000000 @; Check the status against the EMPTY bit
    .unreq status
    bne wait_read$ @; Keep checking the mailbox until it isn't empty

    mail .req r2
    ldr mail, [mailbox] @; Load the address of the response data
    read_chan .req r3
    and read_chan, mail, #0b1111 @; Extract the channel (the lowest 4 bits)
    teq read_chan, channel @; Test if the channel we extracted is the same
                           @; as the channel we are watching
    .unreq read_chan
    bne wait_read$ @; Keep checking until its a message we are interested in

  mov r0, mail @; Move the mail's address to the function return value
  .unreq channel
  .unreq mail
  .unreq mailbox
  mov pc, lr @; Return from the function

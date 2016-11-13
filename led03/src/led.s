@;
@; This turns on the ACT LED for the Raspberry Pi 3 Model B v1.2
@;
@; The ACT LED is no longer wired directly to a GPIO pin and now belongs on
@; the GPIO expander, which is controlled by the GPU. In order to communicate
@; with the GPIO expander, we need to use the GPU's mailbox interface (in
@; particular, we need to send a message to the property tag channel).
@;
@; Property tag channel: 8
@; Property tag ID: 0x00038041 (SET_GPIO_STATE)
@; Property tag message: 130 1 (ACT_LED pin number followed by state)
@;

.section .data
.align 4 @; This ensures lowest 4 bits are 0 for the following label
PropertyInfo:
  @; = Message Header =
  .int PropertyInfoEnd - PropertyInfo @; Calculate buffer size
  .int 0 @; Request code: Process Request
  @; = Tag Header =
  .int 0x00038041 @; Tag ID (SET_GPIO_STATE)
  .int 8 @; Value buffer size
  .int 0 @; Request/response size
  @; = Tag Value Buffer =
  .int 130 @; ACT_LED pin number
  .int 1 @; Turn it on
  .int 0 @; End tag
PropertyInfoEnd:

@; Sets the state of the ACT LED
@;
@; state: 1 = on, 0 = off
@;
@; Rust Signature: fn SetActLEDState(state: u32)
.section .text
.global SetActLEDState
SetActLEDState:
  push {lr} @; Save the point the function should return to
  state .req r2
  mov state, r0 @; Move the state into temporary register
  message .req r0
  ldr message, =PropertyInfo @; Load r0 with address of our message buffer
  mov r3, #0
  str r3, [message, #0x4] @; Reset request code
  str r3, [message, #0x10] @; Reset request/response size
  mov r3, #130
  str r3, [message, #0x14] @; Reset pin number
  str state, [message, #0x18] @; Put the requested state in the tag value buffer
  mov r1, #8 @; Set the channel for the following function call
  .unreq message
  .unreq state
  bl MailboxWrite @; Write the message to the mailbox

  mov r0, #8
  bl MailboxRead @; Read from the response from the mailbox

  pop {pc} @; Pop the saved LR (return address) into the program counter to return

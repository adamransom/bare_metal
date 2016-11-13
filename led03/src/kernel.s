@;
@; This blinks the ACT LED on the Raspberry Pi 3 Model B v1.2 using the
@; GPU's mailbox interface.
@;

.section .init
.global _start @; Make _start available to the outside world

_start:
  mov sp, #0x8000 @; Set up the stack pointer
  b main @; Run main, which never returns

.section .text
main:
  ldr r0, =2000000 @; 2 seconds
  bl Wait @; Wait a bit

  mov r0, #1 @; Move 1 (= on) to the first argument
  bl SetActLEDState @; Call the SetActLEDState function

  ldr r0, =2000000 @; 2 seconds
  bl Wait @; Wait a bit

  mov r0, #0 @; Move 0 (= off) to the first argument
  bl SetActLEDState @; Call the SetActLEDState function

  b main @; Loop back to the top and keep flashing

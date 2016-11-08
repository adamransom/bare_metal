/*
 * Very simple linker script, combing the text and data sections
 * and putting them starting at address 0x800.
 */
SECTIONS {
  /* Put the code at 0x8000, leaving room for ARM and
   * the stack. It also conforms to the standard expecations.
   */
  .text 0x8000 : {
    *(.text)
  }

  /* Put the data after the code */
  .data : {
    *(.data)
  }
}

# SpringOS
---
**by SpringLoaded Tech**

SpringOS is a fork of the bootLogo interpreter by Oscar Toledo G., built to showcase the capabilities of compact software design in an operating system environment.

This lightweight OS fits within 512 bytes(or more depending on stuff like code changes), maintaining support for the Logo programming language while incorporating unique enhancements from SpringLoaded Tech.

---

## Key Features

- **Lightweight Design**: Entire OS and interpreter fit within a boot sector or `.COM` file.
- **Logo Programming**: Supports classic commands like `FD`, `BK`, `RT`, `LT`, `PU`, `PD`, `REPEAT`, `SETCOLOR`, and custom procedures with `TO`/`END`.
- **Custom Enhancements**: Additional features (TBD, based on your changes to bootLogo).
- **Compatibility**: Runs on 8088 processors and supports CGA/EGA/VGA video modes.
- **Customizable**: Parameters like `video_mode`, `color1`, and `color2` can be modified to suit your needs.

---

## Assembly Instructions

To build SpringOS, you’ll need the Netwide Assembler (NASM). Download it from [nasm.us](http://www.nasm.us).

Use the following commands to assemble:

```bash
nasm -f bin springOS.asm -Dcom_file=1 -o springOS.com
nasm -f bin springOS.asm -Dcom_file=0 -o springOS.img
```

---

## Running SpringOS

SpringOS can be tested in various environments:

- **QEMU**:  
  ```bash
  qemu-system-x86_64 -fda springOS.img
  ```

- **DOSBox**:  
  Run `springOS.com` from the DOSBox command line.

- **VirtualBox**:  
  Boot from `springOS.img`.

---

## Logo Commands in SpringOS

SpringOS retains compatibility with the following commands:

- **CLEARSCREEN**: Clears the screen, resets the turtle to the center, and points it north.
- **FD [pixels]**: Moves the turtle forward.
- **BK [pixels]**: Moves the turtle backward.
- **RT [degrees]**: Rotates the turtle clockwise.
- **LT [degrees]**: Rotates the turtle counterclockwise.
- **PU / PD**: Pen up/down to toggle drawing.
- **SETCOLOR [index]**: Sets the drawing color (0–3 for CGA, 0–15 for EGA/VGA).
- **REPEAT [n] [commands]**: Repeats a set of commands.
- **TO [name] [commands] END**: Defines custom procedures.

---

## Acknowledgments

This project is a fork of the original bootLogo by Oscar Toledo G, whose work is an inspiration in compact software design. Special thanks to:

- The open-source community for keeping retro programming alive.
- Oscar Toledo G. for the original design of bootLogo.

---

Enjoy exploring **SpringOS**, brought to you by **SpringLoaded Tech**. Feel free to contribute or suggest features!

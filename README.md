# **SpringOS**  
**by SpringLoaded Tech**

SpringOS is a minimalist operating system inspired by **bootLogo**, designed to fit within a boot sector (512 bytes) while providing a lightweight environment for experimentation with low-level system programming. SpringOS is perfect for developers who want to explore compact OS design and assembly language, while maintaining support for a basic interpreter.

---

## **Key Features**

- **Minimalist Design**: Entire OS fits within a boot sector (512 bytes) or `.COM` file.
- **Customizable Bootloader**: Includes an efficient bootloader for loading a small interpreter.
- **Lightweight Interpreter**: Runs simple commands and custom procedures in a minimal environment.
- **Cross-Platform Compatibility**: Works on real hardware (8088 processor or higher) and emulators like QEMU and DOSBox.
- **Configurable Parameters**: Modify parameters such as `video_mode` and colors for customization.

---

## **System Requirements**

- **Processor**: 8088 or higher.
- **Graphics**: CGA, EGA, or VGA compatible display.
- **Memory**: Minimal (fits within a 512-byte boot sector for the OS).
- **Supported Platforms**: QEMU, DOSBox, VirtualBox, and real 8088 hardware.

---

## **Assembly Instructions**

SpringOS is built using the **Netwide Assembler (NASM)**. You can download it from [nasm.us](http://www.nasm.us).

### Build Commands:
To assemble SpringOS, run the following commands:

1. **Create a `.COM` file for DOSBox or other DOS-compatible environments:**
   ```bash
   nasm -f bin springOS.asm -Dcom_file=1 -o springOS.com
   ```

2. **Create a bootable `.IMG` file for use in emulators or on real hardware:**
   ```bash
   nasm -f bin springOS.asm -Dcom_file=0 -o springOS.img
   ```

---

## **Running SpringOS**

SpringOS can be tested in several environments:

### **QEMU**:
Run SpringOS with QEMU using the following command:
```bash
qemu-system-x86_64 -fda springOS.img
```

### **DOSBox** (for `.COM` file):
Run the `.COM` file using:
```bash
springOS.com
```

### **VirtualBox** (for bootable `.IMG`):
1. Create a new virtual machine.
2. Set the storage to boot from `springOS.img`.
3. Start the VM.

---

## **How SpringOS Works**

SpringOS functions as a simple bootloader that initializes the system and loads the interpreter. The interpreter can execute simple commands in a minimalistic, yet functional environment.

**Boot Process**:
- The bootloader initializes the CPU and video mode.
- It loads and runs the interpreter from a small binary, allowing for basic output to the screen.
- SpringOS can be extended with custom commands, though it remains lightweight to demonstrate the principles of compact OS design.

---

## **Future Enhancements**

While SpringOS is minimal by design, future updates may include:
- **Enhanced Graphics**: Support for more video modes and graphical output.
- **User-defined Commands**: Extending the interpreter to allow for custom commands and more complex interactions.
- **Expanded OS Features**: Add more functionality such as file handling, additional hardware support, or a more powerful interpreter.

Feel free to contribute or suggest new features!

---

## **Acknowledgments**

This project is a fork of the **bootLogo** interpreter by **Oscar Toledo G.**. Special thanks to:
- **Oscar Toledo G.** for the original bootLogo design.
- The open-source community for their contributions to retro programming and system design.

---

## **Contributing**

We welcome contributions! To improve SpringOS:
1. Fork the repository.
2. Create a new branch for your changes.
3. Submit a pull request.

Feel free to open issues for suggestions or bugs.

---

Enjoy exploring **SpringOS**. Lightweight, fast, and perfect for low-level system programming. 🌱
loader design and basic OS features, while leaving out the Logo-specific commands. If you need any more changes or want to add other details, just let me know!

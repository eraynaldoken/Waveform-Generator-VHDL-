# Waveform Generator (VHDL)

This project is a **Waveform Generator** system implemented on an FPGA. It generates different types of waveforms and communicates with a PC via UART.

## Features

- **Waveform Types:** Saw-tooth, Square, Triangle
- **Frequency Control:** 10 different frequency levels
- **Communication:** UART interface for PC interaction
- **FPGA Compatibility:** Designed for Nexys 4 DDR with PMOD DA1

## Modules

- **Waveform Generator Module (`wave_gen_top`)**: Controls waveform type and frequency.
- **UART Interface (`uart_top`)**: Enables communication with a PC.
- **Command Handler (`cmd_handler`)**: Interprets user input.
- **Enable Generator (`en_gen`)**: Adjusts waveform frequency.
- **Synchronous Data Generator (`sync_data_gen`)**: Generates sync signals.

## Communication

- Uses **UART** to receive commands and send status updates.
- Supports **ASCII commands** for waveform selection and frequency adjustment.
- Version and baud rate information can be queried via UART.

## Installation

1. **Synthesize and Implement**: Use Vivado to generate the bitstream.
2. **Program the FPGA**: Load the generated bitstream onto the board.
3. **Connect via UART**: Use a terminal (e.g., Tera Term) to send commands.

## License

This project is open-source. Feel free to modify and expand.


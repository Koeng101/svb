// Code generated by command: go run asm.go -out svb_amd64.s -stubs stub_amd64.go. DO NOT EDIT.

#include "textflag.h"

// func Uint32Decode128(masks []byte, data []byte, out []uint32)
// Requires: AVX, SSSE3
TEXT ·Uint32Decode128(SB), NOSPLIT, $0-72
	// shuffleTable = &ShuffleTable[256][16]
	LEAQ ·ShuffleTable+0(SB), AX
	MOVQ masks_base+0(FP), CX
	MOVQ masks_len+8(FP), DX
	MOVQ data_base+24(FP), BX
	MOVQ out_base+48(FP), BP
	XORQ SI, SI
	XORQ R8, R8
	XORQ R9, R9
	JMP  condition

increment:
	// i++
	LEAQ 1(SI), SI

condition:
	// i < len(masks)
	CMPQ SI, DX

	// goto done if i >= len(masks)
	JGE done

	// m = masks[i]
	MOVBQZX (CX)(SI*1), R9

	// lookup = &ShuffleTable[m][16]
	SHLQ $0x04, R9
	LEAQ (AX)(R9*1), DI
	MOVQ SI, R10

	// step = i * 4 (4 integers)
	SHLQ    $0x02, R10
	VMOVDQU (BX)(R8*1), X0
	PSHUFB  (DI), X0
	VMOVDQU X0, (BP)(R10*4)

	// m >>= 6, note: m << 4 earlier
	SHRL $0x0a, R9

	// m += 12
	ADDL $0x0c, R9

	// lookup = ShuffleTable[m][12 + m >> 6]
	MOVBQZX (DI)(R9*1), DI

	// offset += ShuffleTable[m][12 + m >> 6] + 1
	LEAQ 1(R8)(DI*1), R8
	JMP  increment

done:
	RET

// func Uint32Decode256(masks []byte, data []byte, out []uint32)
// Requires: AVX, AVX2, SSSE3
TEXT ·Uint32Decode256(SB), NOSPLIT, $0-72
	// shuffleTable = &ShuffleTable[256][16]
	LEAQ ·ShuffleTable+0(SB), AX
	MOVQ masks_base+0(FP), CX
	MOVQ masks_len+8(FP), DX
	MOVQ data_base+24(FP), BX
	MOVQ out_base+48(FP), BP
	XORQ SI, SI
	XORQ R8, R8
	XORQ R9, R9
	JMP  condition_0

increment_0:
	// i += 2
	LEAQ 2(SI), SI

condition_0:
	MOVQ DX, DI
	SUBQ SI, DI
	CMPQ DI, $0x02

	// goto done if i >= len(masks)
	JLT  done_0
	MOVQ SI, R10

	// step = i * 4 (4 integers)
	SHLQ $0x02, R10

	// 0th DOUBLE QWORD
	// m = masks[i]
	MOVBQZX (CX)(SI*1), R9

	// lookup = &ShuffleTable[m][16]
	SHLQ $0x04, R9
	LEAQ (AX)(R9*1), DI

	// move 16 bytes from ShuffleTable[masks[0]] to 0 double qword
	VINSERTF128 $0x00, (DI), Y0, Y0

	// move 16 bytes from data[offset] to 0 double qword
	VINSERTF128 $0x00, (BX)(R8*1), Y1, Y1

	// m >>= 6, note: m << 4 earlier
	SHRL $0x0a, R9

	// m += 12
	ADDL $0x0c, R9

	// lookup = ShuffleTable[m][12 + m >> 6]
	MOVBQZX (DI)(R9*1), DI

	// offset += ShuffleTable[m][12 + m >> 6] + 1
	LEAQ 1(R8)(DI*1), R8

	// 1th DOUBLE QWORD
	// m = masks[i]
	MOVBQZX 1(CX)(SI*1), R9

	// lookup = &ShuffleTable[m][16]
	SHLQ $0x04, R9
	LEAQ (AX)(R9*1), DI

	// move 16 bytes from ShuffleTable[masks[1]] to 1 double qword
	VINSERTF128 $0x01, (DI), Y0, Y0

	// move 16 bytes from data[offset] to 1 double qword
	VINSERTF128 $0x01, (BX)(R8*1), Y1, Y1

	// m >>= 6, note: m << 4 earlier
	SHRL $0x0a, R9

	// m += 12
	ADDL $0x0c, R9

	// lookup = ShuffleTable[m][12 + m >> 6]
	MOVBQZX (DI)(R9*1), DI

	// offset += ShuffleTable[m][12 + m >> 6] + 1
	LEAQ 1(R8)(DI*1), R8

	// shuffle 8 uint32
	VPSHUFB Y0, Y1, Y2

	// move 8 uint32 to out
	VMOVDQU Y2, (BP)(R10*4)
	JMP     increment_0

done_0:
	JMP condition_1

increment_1:
	// i++
	LEAQ 1(SI), SI

condition_1:
	// i < len(masks)
	CMPQ SI, DX

	// goto done if i >= len(masks)
	JGE done_1

	// m = masks[i]
	MOVBQZX (CX)(SI*1), R9

	// lookup = &ShuffleTable[m][16]
	SHLQ $0x04, R9
	LEAQ (AX)(R9*1), DI
	MOVQ SI, R10

	// step = i * 4 (4 integers)
	SHLQ    $0x02, R10
	VMOVDQU (BX)(R8*1), X0
	PSHUFB  (DI), X0
	VMOVDQU X0, (BP)(R10*4)

	// m >>= 6, note: m << 4 earlier
	SHRL $0x0a, R9

	// m += 12
	ADDL $0x0c, R9

	// lookup = ShuffleTable[m][12 + m >> 6]
	MOVBQZX (DI)(R9*1), DI

	// offset += ShuffleTable[m][12 + m >> 6] + 1
	LEAQ 1(R8)(DI*1), R8
	JMP  increment_1

done_1:
	RET

// func Shuffle512(masks []byte, data []byte, out []uint32) byte
TEXT ·Shuffle512(SB), NOSPLIT, $0-73
	MOVQ masks_base+0(FP), AX
	MOVQ data_base+24(FP), BX
	MOVQ out_base+48(FP), CX

	// Clear data offset, R8
	XORQ R8, R8

	// init R9W expand mask 00000011
	MOVW $0x0003, R9

	// DX = &ShuffleTable[256][16]
	LEAQ ·ShuffleTable+0(SB), DX

	// 0th DOUBLE QWORD
	// AVX512, K1 = 00000011
	KMOVW R9, K1
	// AVX512, Move data[offset:] to Z0 with mask 00000011
	VPEXPANDQ (BX)(R8*1), K1, Z0
	// SI = masks[0]
	MOVBQZX (AX), SI

	// << 4 bits, 16 bytes offset, ShuffleTable[256][16]
	SHLQ $0x04, SI

	// R10 = ShuffleTable[mask[0]]
	LEAQ (DX)(SI*1), R10

	// AVX512, Move ShuffleTable[masks[0]] to Z1 with mask 00000011  
	VPEXPANDQ (R10), K1, Z1
	// SI >> 10, as m >> 6
	SHRQ $0x0a, SI

	// R11 = ShuffleTable[SI][12+SI>>6], SI = masks[0]
	MOVBQZX 12(R10)(SI*1), R11

	// data offset += R11 + 1
	LEAQ 1(R11)(R8*1), R8

	// 1th DOUBLE QWORD
	// expand mask R9 << 2, 00001100
	SHLW $0x02, R9

	// AVX512, K1 = 00001100
	KMOVW R9, K1
	// AVX512, Move data[offset:] to Z0 with mask 00001100
	VPEXPANDQ (BX)(R8*1), K1, Z0
	// SI = masks[1]
	MOVBQZX 1(AX), SI

	// << 4 bits, 16 bytes offset, ShuffleTable[256][16]
	SHLQ $0x04, SI

	// R10 = ShuffleTable[mask[1]]
	LEAQ (DX)(SI*1), R10

	// AVX512, Move ShuffleTable[masks[1]] to Z1 with mask 00001100  
	VPEXPANDQ (R10), K1, Z1
	// SI >> 10, as m >> 6
	SHRQ $0x0a, SI

	// R11 = ShuffleTable[SI][12+SI>>6], SI = masks[1]
	MOVBQZX 12(R10)(SI*1), R11

	// data offset += R11 + 1
	LEAQ 1(R11)(R8*1), R8

	// 2th DOUBLE QWORD
	// expand mask R9 << 2, 00110000
	SHLW $0x02, R9

	// AVX512, K1 = 00110000
	KMOVW R9, K1
	// AVX512, Move data[offset:] to Z0 with mask 00110000
	VPEXPANDQ (BX)(R8*1), K1, Z0
	// SI = masks[2]
	MOVBQZX 2(AX), SI

	// << 4 bits, 16 bytes offset, ShuffleTable[256][16]
	SHLQ $0x04, SI

	// R10 = ShuffleTable[mask[2]]
	LEAQ (DX)(SI*1), R10

	// AVX512, Move ShuffleTable[masks[2]] to Z1 with mask 00110000  
	VPEXPANDQ (R10), K1, Z1
	// SI >> 10, as m >> 6
	SHRQ $0x0a, SI

	// R11 = ShuffleTable[SI][12+SI>>6], SI = masks[2]
	MOVBQZX 12(R10)(SI*1), R11

	// data offset += R11 + 1
	LEAQ 1(R11)(R8*1), R8

	// 3th DOUBLE QWORD
	// expand mask R9 << 2, 11000000
	SHLW $0x02, R9

	// AVX512, K1 = 11000000
	KMOVW R9, K1
	// AVX512, Move data[offset:] to Z0 with mask 11000000
	VPEXPANDQ (BX)(R8*1), K1, Z0
	// SI = masks[3]
	MOVBQZX 3(AX), SI

	// << 4 bits, 16 bytes offset, ShuffleTable[256][16]
	SHLQ $0x04, SI

	// R10 = ShuffleTable[mask[3]]
	LEAQ (DX)(SI*1), R10

	// AVX512, Move ShuffleTable[masks[3]] to Z1 with mask 11000000  
	VPEXPANDQ (R10), K1, Z1
	// SI >> 10, as m >> 6
	SHRQ $0x0a, SI

	// R11 = ShuffleTable[SI][12+SI>>6], SI = masks[3]
	MOVBQZX 12(R10)(SI*1), R11

	// data offset += R11 + 1
	LEAQ 1(R11)(R8*1), R8

	// AVX512, shuffle 16 uint32
	VPSHUFB Z1, Z0, Z2
	// AVX512, Copy 16 uint32 to out
	VMOVDQU8 Z2, (CX)
	// Return processed data length
	MOVB R8, ret+72(FP)
	RET

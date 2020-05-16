// Code generated by command: go run asm.go -out svb_amd64.s -stubs stub_amd64.go. DO NOT EDIT.

#include "textflag.h"

// func Uint32Decode128(masks []byte, data []byte, out []uint32)
// Requires: AVX, SSSE3
TEXT ·Uint32Decode128(SB), NOSPLIT, $0-72
	MOVQ masks_base+0(FP), AX
	MOVQ masks_len+8(FP), CX
	MOVQ data_base+24(FP), DX
	MOVQ out_base+48(FP), BX

	// i := 0
	XORQ BP, BP

	// offset := 0
	XORQ SI, SI

	// shuffleTable = &ShuffleTable[256][16]
	LEAQ ·ShuffleTable+0(SB), DI

	// var lookup = &ShuffleTable[masks[i]]
	JMP condition

increment:
	// i++
	LEAQ 1(BP), BP

condition:
	// i < len(masks)
	CMPQ BP, CX

	// goto done if i >= len(masks)
	JGE done

	// body
	// m = masks[i]
	MOVBQZX (AX)(BP*1), R9

	// lookup = &ShuffleTable[m][16]
	SHLQ $0x04, R9
	LEAQ (DI)(R9*1), R8
	MOVQ BP, R10

	// step = i * 4 (4 integers)
	SHLQ    $0x04, R10
	VMOVDQU (DX)(SI*1), X0
	PSHUFB  (R8), X0
	VMOVDQU X0, (BX)(R10*1)

	// m >>= 6, note: m << 4 earlier
	SHRL $0x0a, R9

	// m += 12
	ADDW $0x0c, R9

	// lookup = ShuffleTable[m][12 + m >> 6]
	MOVBQZX (R8)(R9*1), R8

	// offset += ShuffleTable[m][12 + m >> 6] + 1
	LEAQ 1(SI)(R8*1), SI
	JMP  increment

done:
	RET

// func Shuffle128(shuffle []byte, data []byte, out []uint32)
// Requires: AVX, SSSE3
TEXT ·Shuffle128(SB), NOSPLIT, $0-72
	MOVQ    shuffle_base+0(FP), AX
	MOVQ    data_base+24(FP), CX
	MOVQ    out_base+48(FP), DX
	VMOVDQU (CX), X0
	PSHUFB  (AX), X0
	VMOVDQU X0, (DX)
	RET

// func Shuffle256(masks []byte, data []byte, out []uint32) byte
// Requires: AVX, AVX2
TEXT ·Shuffle256(SB), NOSPLIT, $0-73
	MOVQ masks_base+0(FP), AX
	MOVQ data_base+24(FP), CX
	MOVQ out_base+48(FP), DX

	// &ShuffleTable[256][16]
	LEAQ ·ShuffleTable+0(SB), BX

	// offset := 0
	XORQ BP, BP

	// 0th DOUBLE QWORD
	// r = masks[0] 
	MOVBQZX (AX), SI

	// shuffle table is [256][16], offset *= 16, left shift 4 bits
	SHLQ $0x04, SI

	// R = &ShuffleTable[masks[0]]
	LEAQ (BX)(SI*1), DI

	// move 16 bytes from ShuffleTable[masks[0]] to 0 double qword
	VINSERTF128 $0x00, (DI), Y0, Y0

	// move 16 bytes from data[offset] to 0 double qword
	VINSERTF128 $0x00, (CX)(BP*1), Y1, Y1

	// maskOffset >> 10, as m >> 6
	SHRQ $0x0a, SI

	// m += 12
	LEAQ 12(SI), SI

	// v = ShuffleTable[key][12 + key >> 6]
	MOVBQZX (DI)(SI*1), DI

	// data offset += v + 1
	LEAQ 1(DI)(BP*1), BP

	// 1th DOUBLE QWORD
	// r = masks[1] 
	MOVBQZX 1(AX), AX

	// shuffle table is [256][16], offset *= 16, left shift 4 bits
	SHLQ $0x04, AX

	// R = &ShuffleTable[masks[1]]
	LEAQ (BX)(AX*1), BX

	// move 16 bytes from ShuffleTable[masks[1]] to 1 double qword
	VINSERTF128 $0x01, (BX), Y0, Y0

	// move 16 bytes from data[offset] to 1 double qword
	VINSERTF128 $0x01, (CX)(BP*1), Y1, Y1

	// maskOffset >> 10, as m >> 6
	SHRQ $0x0a, AX

	// m += 12
	LEAQ 12(AX), AX

	// v = ShuffleTable[key][12 + key >> 6]
	MOVBQZX (BX)(AX*1), BX

	// data offset += v + 1
	LEAQ 1(BX)(BP*1), BP

	// shuffle 8 uint32
	VPSHUFB Y0, Y1, Y0

	// move 8 uint32 to out
	VMOVDQU Y0, (DX)
	MOVB    BP, ret+72(FP)
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

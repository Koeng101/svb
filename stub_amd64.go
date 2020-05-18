// Code generated by command: go run asm.go -out svb_amd64.s -stubs stub_amd64.go. DO NOT EDIT.

package svb

// Uint32Decode128 32 bits integer using XMM register, AVX
func Uint32Decode128(masks []byte, data []byte, out []uint32)

// Uint32Decode256 32 bits integer using YMM register, AVX2
func Uint32Decode256(masks []byte, data []byte, out []uint32)

// Shuffle 32 bits integer using ZMM register, AVX512
func Shuffle512(masks []byte, data []byte, out []uint32) byte

Return-Path: <SRS0=adZj=OO=vger.kernel.org=linux-crypto-owner@kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:41504 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726978AbeLEGVg (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 5 Dec 2018 01:21:36 -0500
From: Eric Biggers <ebiggers@kernel.org>
To: linux-crypto@vger.kernel.org
Cc: Paul Crowley <paulcrowley@google.com>,
        Martin Willi <martin@strongswan.org>,
        Milan Broz <gmazyland@gmail.com>,
        "Jason A . Donenfeld" <Jason@zx2c4.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH v3 4/6] crypto: x86/chacha20 - refactor to allow varying number of rounds
Date: Tue,  4 Dec 2018 22:20:03 -0800
Message-Id: <20181205062005.27727-5-ebiggers@kernel.org>
In-Reply-To: <20181205062005.27727-1-ebiggers@kernel.org>
References: <20181205062005.27727-1-ebiggers@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

From: Eric Biggers <ebiggers@google.com>

In preparation for adding XChaCha12 support, rename/refactor the x86_64
SIMD implementations of ChaCha20 to support different numbers of rounds.

Reviewed-by: Martin Willi <martin@strongswan.org>
Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 arch/x86/crypto/Makefile                      |   8 +-
 ...a20-avx2-x86_64.S => chacha-avx2-x86_64.S} |  33 ++--
 ...12vl-x86_64.S => chacha-avx512vl-x86_64.S} |  35 ++--
 ...0-ssse3-x86_64.S => chacha-ssse3-x86_64.S} |  41 ++---
 .../crypto/{chacha20_glue.c => chacha_glue.c} | 150 +++++++++---------
 5 files changed, 136 insertions(+), 131 deletions(-)
 rename arch/x86/crypto/{chacha20-avx2-x86_64.S => chacha-avx2-x86_64.S} (97%)
 rename arch/x86/crypto/{chacha20-avx512vl-x86_64.S => chacha-avx512vl-x86_64.S} (97%)
 rename arch/x86/crypto/{chacha20-ssse3-x86_64.S => chacha-ssse3-x86_64.S} (96%)
 rename arch/x86/crypto/{chacha20_glue.c => chacha_glue.c} (51%)

diff --git a/arch/x86/crypto/Makefile b/arch/x86/crypto/Makefile
index 0b31b16f49d8..45734e1cf967 100644
--- a/arch/x86/crypto/Makefile
+++ b/arch/x86/crypto/Makefile
@@ -24,7 +24,7 @@ obj-$(CONFIG_CRYPTO_CAMELLIA_X86_64) += camellia-x86_64.o
 obj-$(CONFIG_CRYPTO_BLOWFISH_X86_64) += blowfish-x86_64.o
 obj-$(CONFIG_CRYPTO_TWOFISH_X86_64) += twofish-x86_64.o
 obj-$(CONFIG_CRYPTO_TWOFISH_X86_64_3WAY) += twofish-x86_64-3way.o
-obj-$(CONFIG_CRYPTO_CHACHA20_X86_64) += chacha20-x86_64.o
+obj-$(CONFIG_CRYPTO_CHACHA20_X86_64) += chacha-x86_64.o
 obj-$(CONFIG_CRYPTO_SERPENT_SSE2_X86_64) += serpent-sse2-x86_64.o
 obj-$(CONFIG_CRYPTO_AES_NI_INTEL) += aesni-intel.o
 obj-$(CONFIG_CRYPTO_GHASH_CLMUL_NI_INTEL) += ghash-clmulni-intel.o
@@ -78,7 +78,7 @@ camellia-x86_64-y := camellia-x86_64-asm_64.o camellia_glue.o
 blowfish-x86_64-y := blowfish-x86_64-asm_64.o blowfish_glue.o
 twofish-x86_64-y := twofish-x86_64-asm_64.o twofish_glue.o
 twofish-x86_64-3way-y := twofish-x86_64-asm_64-3way.o twofish_glue_3way.o
-chacha20-x86_64-y := chacha20-ssse3-x86_64.o chacha20_glue.o
+chacha-x86_64-y := chacha-ssse3-x86_64.o chacha_glue.o
 serpent-sse2-x86_64-y := serpent-sse2-x86_64-asm_64.o serpent_sse2_glue.o
 
 aegis128-aesni-y := aegis128-aesni-asm.o aegis128-aesni-glue.o
@@ -103,7 +103,7 @@ endif
 
 ifeq ($(avx2_supported),yes)
 	camellia-aesni-avx2-y := camellia-aesni-avx2-asm_64.o camellia_aesni_avx2_glue.o
-	chacha20-x86_64-y += chacha20-avx2-x86_64.o
+	chacha-x86_64-y += chacha-avx2-x86_64.o
 	serpent-avx2-y := serpent-avx2-asm_64.o serpent_avx2_glue.o
 
 	morus1280-avx2-y := morus1280-avx2-asm.o morus1280-avx2-glue.o
@@ -112,7 +112,7 @@ ifeq ($(avx2_supported),yes)
 endif
 
 ifeq ($(avx512_supported),yes)
-	chacha20-x86_64-y += chacha20-avx512vl-x86_64.o
+	chacha-x86_64-y += chacha-avx512vl-x86_64.o
 endif
 
 aesni-intel-y := aesni-intel_asm.o aesni-intel_glue.o
diff --git a/arch/x86/crypto/chacha20-avx2-x86_64.S b/arch/x86/crypto/chacha-avx2-x86_64.S
similarity index 97%
rename from arch/x86/crypto/chacha20-avx2-x86_64.S
rename to arch/x86/crypto/chacha-avx2-x86_64.S
index b6ab082be657..32903fd450af 100644
--- a/arch/x86/crypto/chacha20-avx2-x86_64.S
+++ b/arch/x86/crypto/chacha-avx2-x86_64.S
@@ -1,5 +1,5 @@
 /*
- * ChaCha20 256-bit cipher algorithm, RFC7539, x64 AVX2 functions
+ * ChaCha 256-bit cipher algorithm, x64 AVX2 functions
  *
  * Copyright (C) 2015 Martin Willi
  *
@@ -38,13 +38,14 @@ CTR4BL:	.octa 0x00000000000000000000000000000002
 
 .text
 
-ENTRY(chacha20_2block_xor_avx2)
+ENTRY(chacha_2block_xor_avx2)
 	# %rdi: Input state matrix, s
 	# %rsi: up to 2 data blocks output, o
 	# %rdx: up to 2 data blocks input, i
 	# %rcx: input/output length in bytes
+	# %r8d: nrounds
 
-	# This function encrypts two ChaCha20 blocks by loading the state
+	# This function encrypts two ChaCha blocks by loading the state
 	# matrix twice across four AVX registers. It performs matrix operations
 	# on four words in each matrix in parallel, but requires shuffling to
 	# rearrange the words after each round.
@@ -68,7 +69,6 @@ ENTRY(chacha20_2block_xor_avx2)
 	vmovdqa		ROT16(%rip),%ymm5
 
 	mov		%rcx,%rax
-	mov		$10,%ecx
 
 .Ldoubleround:
 
@@ -138,7 +138,7 @@ ENTRY(chacha20_2block_xor_avx2)
 	# x3 = shuffle32(x3, MASK(0, 3, 2, 1))
 	vpshufd		$0x39,%ymm3,%ymm3
 
-	dec		%ecx
+	sub		$2,%r8d
 	jnz		.Ldoubleround
 
 	# o0 = i0 ^ (x0 + s0)
@@ -228,15 +228,16 @@ ENTRY(chacha20_2block_xor_avx2)
 	lea		-8(%r10),%rsp
 	jmp		.Ldone2
 
-ENDPROC(chacha20_2block_xor_avx2)
+ENDPROC(chacha_2block_xor_avx2)
 
-ENTRY(chacha20_4block_xor_avx2)
+ENTRY(chacha_4block_xor_avx2)
 	# %rdi: Input state matrix, s
 	# %rsi: up to 4 data blocks output, o
 	# %rdx: up to 4 data blocks input, i
 	# %rcx: input/output length in bytes
+	# %r8d: nrounds
 
-	# This function encrypts four ChaCha20 block by loading the state
+	# This function encrypts four ChaCha blocks by loading the state
 	# matrix four times across eight AVX registers. It performs matrix
 	# operations on four words in two matrices in parallel, sequentially
 	# to the operations on the four words of the other two matrices. The
@@ -269,7 +270,6 @@ ENTRY(chacha20_4block_xor_avx2)
 	vmovdqa		ROT16(%rip),%ymm9
 
 	mov		%rcx,%rax
-	mov		$10,%ecx
 
 .Ldoubleround4:
 
@@ -389,7 +389,7 @@ ENTRY(chacha20_4block_xor_avx2)
 	vpshufd		$0x39,%ymm3,%ymm3
 	vpshufd		$0x39,%ymm7,%ymm7
 
-	dec		%ecx
+	sub		$2,%r8d
 	jnz		.Ldoubleround4
 
 	# o0 = i0 ^ (x0 + s0), first block
@@ -533,15 +533,16 @@ ENTRY(chacha20_4block_xor_avx2)
 	lea		-8(%r10),%rsp
 	jmp		.Ldone4
 
-ENDPROC(chacha20_4block_xor_avx2)
+ENDPROC(chacha_4block_xor_avx2)
 
-ENTRY(chacha20_8block_xor_avx2)
+ENTRY(chacha_8block_xor_avx2)
 	# %rdi: Input state matrix, s
 	# %rsi: up to 8 data blocks output, o
 	# %rdx: up to 8 data blocks input, i
 	# %rcx: input/output length in bytes
+	# %r8d: nrounds
 
-	# This function encrypts eight consecutive ChaCha20 blocks by loading
+	# This function encrypts eight consecutive ChaCha blocks by loading
 	# the state matrix in AVX registers eight times. As we need some
 	# scratch registers, we save the first four registers on the stack. The
 	# algorithm performs each operation on the corresponding word of each
@@ -588,8 +589,6 @@ ENTRY(chacha20_8block_xor_avx2)
 	# x12 += counter values 0-3
 	vpaddd		%ymm1,%ymm12,%ymm12
 
-	mov		$10,%ecx
-
 .Ldoubleround8:
 	# x0 += x4, x12 = rotl32(x12 ^ x0, 16)
 	vpaddd		0x00(%rsp),%ymm4,%ymm0
@@ -775,7 +774,7 @@ ENTRY(chacha20_8block_xor_avx2)
 	vpsrld		$25,%ymm4,%ymm4
 	vpor		%ymm0,%ymm4,%ymm4
 
-	dec		%ecx
+	sub		$2,%r8d
 	jnz		.Ldoubleround8
 
 	# x0..15[0-3] += s[0..15]
@@ -1023,4 +1022,4 @@ ENTRY(chacha20_8block_xor_avx2)
 
 	jmp		.Ldone8
 
-ENDPROC(chacha20_8block_xor_avx2)
+ENDPROC(chacha_8block_xor_avx2)
diff --git a/arch/x86/crypto/chacha20-avx512vl-x86_64.S b/arch/x86/crypto/chacha-avx512vl-x86_64.S
similarity index 97%
rename from arch/x86/crypto/chacha20-avx512vl-x86_64.S
rename to arch/x86/crypto/chacha-avx512vl-x86_64.S
index 55d34de29e3e..848f9c75fd4f 100644
--- a/arch/x86/crypto/chacha20-avx512vl-x86_64.S
+++ b/arch/x86/crypto/chacha-avx512vl-x86_64.S
@@ -1,6 +1,6 @@
 /* SPDX-License-Identifier: GPL-2.0+ */
 /*
- * ChaCha20 256-bit cipher algorithm, RFC7539, x64 AVX-512VL functions
+ * ChaCha 256-bit cipher algorithm, x64 AVX-512VL functions
  *
  * Copyright (C) 2018 Martin Willi
  */
@@ -24,13 +24,14 @@ CTR8BL:	.octa 0x00000003000000020000000100000000
 
 .text
 
-ENTRY(chacha20_2block_xor_avx512vl)
+ENTRY(chacha_2block_xor_avx512vl)
 	# %rdi: Input state matrix, s
 	# %rsi: up to 2 data blocks output, o
 	# %rdx: up to 2 data blocks input, i
 	# %rcx: input/output length in bytes
+	# %r8d: nrounds
 
-	# This function encrypts two ChaCha20 blocks by loading the state
+	# This function encrypts two ChaCha blocks by loading the state
 	# matrix twice across four AVX registers. It performs matrix operations
 	# on four words in each matrix in parallel, but requires shuffling to
 	# rearrange the words after each round.
@@ -50,8 +51,6 @@ ENTRY(chacha20_2block_xor_avx512vl)
 	vmovdqa		%ymm2,%ymm10
 	vmovdqa		%ymm3,%ymm11
 
-	mov		$10,%rax
-
 .Ldoubleround:
 
 	# x0 += x1, x3 = rotl32(x3 ^ x0, 16)
@@ -108,7 +107,7 @@ ENTRY(chacha20_2block_xor_avx512vl)
 	# x3 = shuffle32(x3, MASK(0, 3, 2, 1))
 	vpshufd		$0x39,%ymm3,%ymm3
 
-	dec		%rax
+	sub		$2,%r8d
 	jnz		.Ldoubleround
 
 	# o0 = i0 ^ (x0 + s0)
@@ -188,15 +187,16 @@ ENTRY(chacha20_2block_xor_avx512vl)
 
 	jmp		.Ldone2
 
-ENDPROC(chacha20_2block_xor_avx512vl)
+ENDPROC(chacha_2block_xor_avx512vl)
 
-ENTRY(chacha20_4block_xor_avx512vl)
+ENTRY(chacha_4block_xor_avx512vl)
 	# %rdi: Input state matrix, s
 	# %rsi: up to 4 data blocks output, o
 	# %rdx: up to 4 data blocks input, i
 	# %rcx: input/output length in bytes
+	# %r8d: nrounds
 
-	# This function encrypts four ChaCha20 block by loading the state
+	# This function encrypts four ChaCha blocks by loading the state
 	# matrix four times across eight AVX registers. It performs matrix
 	# operations on four words in two matrices in parallel, sequentially
 	# to the operations on the four words of the other two matrices. The
@@ -225,8 +225,6 @@ ENTRY(chacha20_4block_xor_avx512vl)
 	vmovdqa		%ymm3,%ymm14
 	vmovdqa		%ymm7,%ymm15
 
-	mov		$10,%rax
-
 .Ldoubleround4:
 
 	# x0 += x1, x3 = rotl32(x3 ^ x0, 16)
@@ -321,7 +319,7 @@ ENTRY(chacha20_4block_xor_avx512vl)
 	vpshufd		$0x39,%ymm3,%ymm3
 	vpshufd		$0x39,%ymm7,%ymm7
 
-	dec		%rax
+	sub		$2,%r8d
 	jnz		.Ldoubleround4
 
 	# o0 = i0 ^ (x0 + s0), first block
@@ -455,15 +453,16 @@ ENTRY(chacha20_4block_xor_avx512vl)
 
 	jmp		.Ldone4
 
-ENDPROC(chacha20_4block_xor_avx512vl)
+ENDPROC(chacha_4block_xor_avx512vl)
 
-ENTRY(chacha20_8block_xor_avx512vl)
+ENTRY(chacha_8block_xor_avx512vl)
 	# %rdi: Input state matrix, s
 	# %rsi: up to 8 data blocks output, o
 	# %rdx: up to 8 data blocks input, i
 	# %rcx: input/output length in bytes
+	# %r8d: nrounds
 
-	# This function encrypts eight consecutive ChaCha20 blocks by loading
+	# This function encrypts eight consecutive ChaCha blocks by loading
 	# the state matrix in AVX registers eight times. Compared to AVX2, this
 	# mostly benefits from the new rotate instructions in VL and the
 	# additional registers.
@@ -508,8 +507,6 @@ ENTRY(chacha20_8block_xor_avx512vl)
 	vmovdqa64	%ymm14,%ymm30
 	vmovdqa64	%ymm15,%ymm31
 
-	mov		$10,%eax
-
 .Ldoubleround8:
 	# x0 += x4, x12 = rotl32(x12 ^ x0, 16)
 	vpaddd		%ymm0,%ymm4,%ymm0
@@ -647,7 +644,7 @@ ENTRY(chacha20_8block_xor_avx512vl)
 	vpxord		%ymm9,%ymm4,%ymm4
 	vprold		$7,%ymm4,%ymm4
 
-	dec		%eax
+	sub		$2,%r8d
 	jnz		.Ldoubleround8
 
 	# x0..15[0-3] += s[0..15]
@@ -836,4 +833,4 @@ ENTRY(chacha20_8block_xor_avx512vl)
 
 	jmp		.Ldone8
 
-ENDPROC(chacha20_8block_xor_avx512vl)
+ENDPROC(chacha_8block_xor_avx512vl)
diff --git a/arch/x86/crypto/chacha20-ssse3-x86_64.S b/arch/x86/crypto/chacha-ssse3-x86_64.S
similarity index 96%
rename from arch/x86/crypto/chacha20-ssse3-x86_64.S
rename to arch/x86/crypto/chacha-ssse3-x86_64.S
index f6792789f875..c05a7a963dc3 100644
--- a/arch/x86/crypto/chacha20-ssse3-x86_64.S
+++ b/arch/x86/crypto/chacha-ssse3-x86_64.S
@@ -1,5 +1,5 @@
 /*
- * ChaCha20 256-bit cipher algorithm, RFC7539, x64 SSSE3 functions
+ * ChaCha 256-bit cipher algorithm, x64 SSSE3 functions
  *
  * Copyright (C) 2015 Martin Willi
  *
@@ -25,7 +25,7 @@ CTRINC:	.octa 0x00000003000000020000000100000000
 .text
 
 /*
- * chacha20_permute - permute one block
+ * chacha_permute - permute one block
  *
  * Permute one 64-byte block where the state matrix is in %xmm0-%xmm3.  This
  * function performs matrix operations on four words in parallel, but requires
@@ -33,13 +33,14 @@ CTRINC:	.octa 0x00000003000000020000000100000000
  * done with the slightly better performing SSSE3 byte shuffling, 7/12-bit word
  * rotation uses traditional shift+OR.
  *
- * Clobbers: %ecx, %xmm4-%xmm7
+ * The round count is given in %r8d.
+ *
+ * Clobbers: %r8d, %xmm4-%xmm7
  */
-chacha20_permute:
+chacha_permute:
 
 	movdqa		ROT8(%rip),%xmm4
 	movdqa		ROT16(%rip),%xmm5
-	mov		$10,%ecx
 
 .Ldoubleround:
 	# x0 += x1, x3 = rotl32(x3 ^ x0, 16)
@@ -108,17 +109,18 @@ chacha20_permute:
 	# x3 = shuffle32(x3, MASK(0, 3, 2, 1))
 	pshufd		$0x39,%xmm3,%xmm3
 
-	dec		%ecx
+	sub		$2,%r8d
 	jnz		.Ldoubleround
 
 	ret
-ENDPROC(chacha20_permute)
+ENDPROC(chacha_permute)
 
-ENTRY(chacha20_block_xor_ssse3)
+ENTRY(chacha_block_xor_ssse3)
 	# %rdi: Input state matrix, s
 	# %rsi: up to 1 data block output, o
 	# %rdx: up to 1 data block input, i
 	# %rcx: input/output length in bytes
+	# %r8d: nrounds
 	FRAME_BEGIN
 
 	# x0..3 = s0..3
@@ -132,7 +134,7 @@ ENTRY(chacha20_block_xor_ssse3)
 	movdqa		%xmm3,%xmm11
 
 	mov		%rcx,%rax
-	call		chacha20_permute
+	call		chacha_permute
 
 	# o0 = i0 ^ (x0 + s0)
 	paddd		%xmm8,%xmm0
@@ -199,11 +201,12 @@ ENTRY(chacha20_block_xor_ssse3)
 	lea		-8(%r10),%rsp
 	jmp		.Ldone
 
-ENDPROC(chacha20_block_xor_ssse3)
+ENDPROC(chacha_block_xor_ssse3)
 
-ENTRY(hchacha20_block_ssse3)
+ENTRY(hchacha_block_ssse3)
 	# %rdi: Input state matrix, s
 	# %rsi: output (8 32-bit words)
+	# %edx: nrounds
 	FRAME_BEGIN
 
 	movdqa		0x00(%rdi),%xmm0
@@ -211,22 +214,24 @@ ENTRY(hchacha20_block_ssse3)
 	movdqa		0x20(%rdi),%xmm2
 	movdqa		0x30(%rdi),%xmm3
 
-	call		chacha20_permute
+	mov		%edx,%r8d
+	call		chacha_permute
 
 	movdqu		%xmm0,0x00(%rsi)
 	movdqu		%xmm3,0x10(%rsi)
 
 	FRAME_END
 	ret
-ENDPROC(hchacha20_block_ssse3)
+ENDPROC(hchacha_block_ssse3)
 
-ENTRY(chacha20_4block_xor_ssse3)
+ENTRY(chacha_4block_xor_ssse3)
 	# %rdi: Input state matrix, s
 	# %rsi: up to 4 data blocks output, o
 	# %rdx: up to 4 data blocks input, i
 	# %rcx: input/output length in bytes
+	# %r8d: nrounds
 
-	# This function encrypts four consecutive ChaCha20 blocks by loading the
+	# This function encrypts four consecutive ChaCha blocks by loading the
 	# the state matrix in SSE registers four times. As we need some scratch
 	# registers, we save the first four registers on the stack. The
 	# algorithm performs each operation on the corresponding word of each
@@ -279,8 +284,6 @@ ENTRY(chacha20_4block_xor_ssse3)
 	# x12 += counter values 0-3
 	paddd		%xmm1,%xmm12
 
-	mov		$10,%ecx
-
 .Ldoubleround4:
 	# x0 += x4, x12 = rotl32(x12 ^ x0, 16)
 	movdqa		0x00(%rsp),%xmm0
@@ -498,7 +501,7 @@ ENTRY(chacha20_4block_xor_ssse3)
 	psrld		$25,%xmm4
 	por		%xmm0,%xmm4
 
-	dec		%ecx
+	sub		$2,%r8d
 	jnz		.Ldoubleround4
 
 	# x0[0-3] += s0[0]
@@ -789,4 +792,4 @@ ENTRY(chacha20_4block_xor_ssse3)
 
 	jmp		.Ldone4
 
-ENDPROC(chacha20_4block_xor_ssse3)
+ENDPROC(chacha_4block_xor_ssse3)
diff --git a/arch/x86/crypto/chacha20_glue.c b/arch/x86/crypto/chacha_glue.c
similarity index 51%
rename from arch/x86/crypto/chacha20_glue.c
rename to arch/x86/crypto/chacha_glue.c
index 70d388e4a3a2..35fd02b50d27 100644
--- a/arch/x86/crypto/chacha20_glue.c
+++ b/arch/x86/crypto/chacha_glue.c
@@ -1,5 +1,6 @@
 /*
- * ChaCha20 256-bit cipher algorithm, RFC7539, SIMD glue code
+ * x64 SIMD accelerated ChaCha and XChaCha stream ciphers,
+ * including ChaCha20 (RFC7539)
  *
  * Copyright (C) 2015 Martin Willi
  *
@@ -17,120 +18,124 @@
 #include <asm/fpu/api.h>
 #include <asm/simd.h>
 
-#define CHACHA20_STATE_ALIGN 16
+#define CHACHA_STATE_ALIGN 16
 
-asmlinkage void chacha20_block_xor_ssse3(u32 *state, u8 *dst, const u8 *src,
-					 unsigned int len);
-asmlinkage void chacha20_4block_xor_ssse3(u32 *state, u8 *dst, const u8 *src,
-					  unsigned int len);
-asmlinkage void hchacha20_block_ssse3(const u32 *state, u32 *out);
+asmlinkage void chacha_block_xor_ssse3(u32 *state, u8 *dst, const u8 *src,
+				       unsigned int len, int nrounds);
+asmlinkage void chacha_4block_xor_ssse3(u32 *state, u8 *dst, const u8 *src,
+					unsigned int len, int nrounds);
+asmlinkage void hchacha_block_ssse3(const u32 *state, u32 *out, int nrounds);
 #ifdef CONFIG_AS_AVX2
-asmlinkage void chacha20_2block_xor_avx2(u32 *state, u8 *dst, const u8 *src,
-					 unsigned int len);
-asmlinkage void chacha20_4block_xor_avx2(u32 *state, u8 *dst, const u8 *src,
-					 unsigned int len);
-asmlinkage void chacha20_8block_xor_avx2(u32 *state, u8 *dst, const u8 *src,
-					 unsigned int len);
-static bool chacha20_use_avx2;
+asmlinkage void chacha_2block_xor_avx2(u32 *state, u8 *dst, const u8 *src,
+				       unsigned int len, int nrounds);
+asmlinkage void chacha_4block_xor_avx2(u32 *state, u8 *dst, const u8 *src,
+				       unsigned int len, int nrounds);
+asmlinkage void chacha_8block_xor_avx2(u32 *state, u8 *dst, const u8 *src,
+				       unsigned int len, int nrounds);
+static bool chacha_use_avx2;
 #ifdef CONFIG_AS_AVX512
-asmlinkage void chacha20_2block_xor_avx512vl(u32 *state, u8 *dst, const u8 *src,
-					     unsigned int len);
-asmlinkage void chacha20_4block_xor_avx512vl(u32 *state, u8 *dst, const u8 *src,
-					     unsigned int len);
-asmlinkage void chacha20_8block_xor_avx512vl(u32 *state, u8 *dst, const u8 *src,
-					     unsigned int len);
-static bool chacha20_use_avx512vl;
+asmlinkage void chacha_2block_xor_avx512vl(u32 *state, u8 *dst, const u8 *src,
+					   unsigned int len, int nrounds);
+asmlinkage void chacha_4block_xor_avx512vl(u32 *state, u8 *dst, const u8 *src,
+					   unsigned int len, int nrounds);
+asmlinkage void chacha_8block_xor_avx512vl(u32 *state, u8 *dst, const u8 *src,
+					   unsigned int len, int nrounds);
+static bool chacha_use_avx512vl;
 #endif
 #endif
 
-static unsigned int chacha20_advance(unsigned int len, unsigned int maxblocks)
+static unsigned int chacha_advance(unsigned int len, unsigned int maxblocks)
 {
 	len = min(len, maxblocks * CHACHA_BLOCK_SIZE);
 	return round_up(len, CHACHA_BLOCK_SIZE) / CHACHA_BLOCK_SIZE;
 }
 
-static void chacha20_dosimd(u32 *state, u8 *dst, const u8 *src,
-			    unsigned int bytes)
+static void chacha_dosimd(u32 *state, u8 *dst, const u8 *src,
+			  unsigned int bytes, int nrounds)
 {
 #ifdef CONFIG_AS_AVX2
 #ifdef CONFIG_AS_AVX512
-	if (chacha20_use_avx512vl) {
+	if (chacha_use_avx512vl) {
 		while (bytes >= CHACHA_BLOCK_SIZE * 8) {
-			chacha20_8block_xor_avx512vl(state, dst, src, bytes);
+			chacha_8block_xor_avx512vl(state, dst, src, bytes,
+						   nrounds);
 			bytes -= CHACHA_BLOCK_SIZE * 8;
 			src += CHACHA_BLOCK_SIZE * 8;
 			dst += CHACHA_BLOCK_SIZE * 8;
 			state[12] += 8;
 		}
 		if (bytes > CHACHA_BLOCK_SIZE * 4) {
-			chacha20_8block_xor_avx512vl(state, dst, src, bytes);
-			state[12] += chacha20_advance(bytes, 8);
+			chacha_8block_xor_avx512vl(state, dst, src, bytes,
+						   nrounds);
+			state[12] += chacha_advance(bytes, 8);
 			return;
 		}
 		if (bytes > CHACHA_BLOCK_SIZE * 2) {
-			chacha20_4block_xor_avx512vl(state, dst, src, bytes);
-			state[12] += chacha20_advance(bytes, 4);
+			chacha_4block_xor_avx512vl(state, dst, src, bytes,
+						   nrounds);
+			state[12] += chacha_advance(bytes, 4);
 			return;
 		}
 		if (bytes) {
-			chacha20_2block_xor_avx512vl(state, dst, src, bytes);
-			state[12] += chacha20_advance(bytes, 2);
+			chacha_2block_xor_avx512vl(state, dst, src, bytes,
+						   nrounds);
+			state[12] += chacha_advance(bytes, 2);
 			return;
 		}
 	}
 #endif
-	if (chacha20_use_avx2) {
+	if (chacha_use_avx2) {
 		while (bytes >= CHACHA_BLOCK_SIZE * 8) {
-			chacha20_8block_xor_avx2(state, dst, src, bytes);
+			chacha_8block_xor_avx2(state, dst, src, bytes, nrounds);
 			bytes -= CHACHA_BLOCK_SIZE * 8;
 			src += CHACHA_BLOCK_SIZE * 8;
 			dst += CHACHA_BLOCK_SIZE * 8;
 			state[12] += 8;
 		}
 		if (bytes > CHACHA_BLOCK_SIZE * 4) {
-			chacha20_8block_xor_avx2(state, dst, src, bytes);
-			state[12] += chacha20_advance(bytes, 8);
+			chacha_8block_xor_avx2(state, dst, src, bytes, nrounds);
+			state[12] += chacha_advance(bytes, 8);
 			return;
 		}
 		if (bytes > CHACHA_BLOCK_SIZE * 2) {
-			chacha20_4block_xor_avx2(state, dst, src, bytes);
-			state[12] += chacha20_advance(bytes, 4);
+			chacha_4block_xor_avx2(state, dst, src, bytes, nrounds);
+			state[12] += chacha_advance(bytes, 4);
 			return;
 		}
 		if (bytes > CHACHA_BLOCK_SIZE) {
-			chacha20_2block_xor_avx2(state, dst, src, bytes);
-			state[12] += chacha20_advance(bytes, 2);
+			chacha_2block_xor_avx2(state, dst, src, bytes, nrounds);
+			state[12] += chacha_advance(bytes, 2);
 			return;
 		}
 	}
 #endif
 	while (bytes >= CHACHA_BLOCK_SIZE * 4) {
-		chacha20_4block_xor_ssse3(state, dst, src, bytes);
+		chacha_4block_xor_ssse3(state, dst, src, bytes, nrounds);
 		bytes -= CHACHA_BLOCK_SIZE * 4;
 		src += CHACHA_BLOCK_SIZE * 4;
 		dst += CHACHA_BLOCK_SIZE * 4;
 		state[12] += 4;
 	}
 	if (bytes > CHACHA_BLOCK_SIZE) {
-		chacha20_4block_xor_ssse3(state, dst, src, bytes);
-		state[12] += chacha20_advance(bytes, 4);
+		chacha_4block_xor_ssse3(state, dst, src, bytes, nrounds);
+		state[12] += chacha_advance(bytes, 4);
 		return;
 	}
 	if (bytes) {
-		chacha20_block_xor_ssse3(state, dst, src, bytes);
+		chacha_block_xor_ssse3(state, dst, src, bytes, nrounds);
 		state[12]++;
 	}
 }
 
-static int chacha20_simd_stream_xor(struct skcipher_request *req,
-				    struct chacha_ctx *ctx, u8 *iv)
+static int chacha_simd_stream_xor(struct skcipher_request *req,
+				  struct chacha_ctx *ctx, u8 *iv)
 {
 	u32 *state, state_buf[16 + 2] __aligned(8);
 	struct skcipher_walk walk;
 	int err;
 
-	BUILD_BUG_ON(CHACHA20_STATE_ALIGN != 16);
-	state = PTR_ALIGN(state_buf + 0, CHACHA20_STATE_ALIGN);
+	BUILD_BUG_ON(CHACHA_STATE_ALIGN != 16);
+	state = PTR_ALIGN(state_buf + 0, CHACHA_STATE_ALIGN);
 
 	err = skcipher_walk_virt(&walk, req, true);
 
@@ -142,8 +147,8 @@ static int chacha20_simd_stream_xor(struct skcipher_request *req,
 		if (nbytes < walk.total)
 			nbytes = round_down(nbytes, walk.stride);
 
-		chacha20_dosimd(state, walk.dst.virt.addr, walk.src.virt.addr,
-				nbytes);
+		chacha_dosimd(state, walk.dst.virt.addr, walk.src.virt.addr,
+			      nbytes, ctx->nrounds);
 
 		err = skcipher_walk_done(&walk, walk.nbytes - nbytes);
 	}
@@ -151,7 +156,7 @@ static int chacha20_simd_stream_xor(struct skcipher_request *req,
 	return err;
 }
 
-static int chacha20_simd(struct skcipher_request *req)
+static int chacha_simd(struct skcipher_request *req)
 {
 	struct crypto_skcipher *tfm = crypto_skcipher_reqtfm(req);
 	struct chacha_ctx *ctx = crypto_skcipher_ctx(tfm);
@@ -161,12 +166,12 @@ static int chacha20_simd(struct skcipher_request *req)
 		return crypto_chacha_crypt(req);
 
 	kernel_fpu_begin();
-	err = chacha20_simd_stream_xor(req, ctx, req->iv);
+	err = chacha_simd_stream_xor(req, ctx, req->iv);
 	kernel_fpu_end();
 	return err;
 }
 
-static int xchacha20_simd(struct skcipher_request *req)
+static int xchacha_simd(struct skcipher_request *req)
 {
 	struct crypto_skcipher *tfm = crypto_skcipher_reqtfm(req);
 	struct chacha_ctx *ctx = crypto_skcipher_ctx(tfm);
@@ -178,17 +183,18 @@ static int xchacha20_simd(struct skcipher_request *req)
 	if (req->cryptlen <= CHACHA_BLOCK_SIZE || !irq_fpu_usable())
 		return crypto_xchacha_crypt(req);
 
-	BUILD_BUG_ON(CHACHA20_STATE_ALIGN != 16);
-	state = PTR_ALIGN(state_buf + 0, CHACHA20_STATE_ALIGN);
+	BUILD_BUG_ON(CHACHA_STATE_ALIGN != 16);
+	state = PTR_ALIGN(state_buf + 0, CHACHA_STATE_ALIGN);
 	crypto_chacha_init(state, ctx, req->iv);
 
 	kernel_fpu_begin();
 
-	hchacha20_block_ssse3(state, subctx.key);
+	hchacha_block_ssse3(state, subctx.key, ctx->nrounds);
+	subctx.nrounds = ctx->nrounds;
 
 	memcpy(&real_iv[0], req->iv + 24, 8);
 	memcpy(&real_iv[8], req->iv + 16, 8);
-	err = chacha20_simd_stream_xor(req, &subctx, real_iv);
+	err = chacha_simd_stream_xor(req, &subctx, real_iv);
 
 	kernel_fpu_end();
 
@@ -209,8 +215,8 @@ static struct skcipher_alg algs[] = {
 		.ivsize			= CHACHA_IV_SIZE,
 		.chunksize		= CHACHA_BLOCK_SIZE,
 		.setkey			= crypto_chacha20_setkey,
-		.encrypt		= chacha20_simd,
-		.decrypt		= chacha20_simd,
+		.encrypt		= chacha_simd,
+		.decrypt		= chacha_simd,
 	}, {
 		.base.cra_name		= "xchacha20",
 		.base.cra_driver_name	= "xchacha20-simd",
@@ -224,40 +230,40 @@ static struct skcipher_alg algs[] = {
 		.ivsize			= XCHACHA_IV_SIZE,
 		.chunksize		= CHACHA_BLOCK_SIZE,
 		.setkey			= crypto_chacha20_setkey,
-		.encrypt		= xchacha20_simd,
-		.decrypt		= xchacha20_simd,
+		.encrypt		= xchacha_simd,
+		.decrypt		= xchacha_simd,
 	},
 };
 
-static int __init chacha20_simd_mod_init(void)
+static int __init chacha_simd_mod_init(void)
 {
 	if (!boot_cpu_has(X86_FEATURE_SSSE3))
 		return -ENODEV;
 
 #ifdef CONFIG_AS_AVX2
-	chacha20_use_avx2 = boot_cpu_has(X86_FEATURE_AVX) &&
-			    boot_cpu_has(X86_FEATURE_AVX2) &&
-			    cpu_has_xfeatures(XFEATURE_MASK_SSE | XFEATURE_MASK_YMM, NULL);
+	chacha_use_avx2 = boot_cpu_has(X86_FEATURE_AVX) &&
+			  boot_cpu_has(X86_FEATURE_AVX2) &&
+			  cpu_has_xfeatures(XFEATURE_MASK_SSE | XFEATURE_MASK_YMM, NULL);
 #ifdef CONFIG_AS_AVX512
-	chacha20_use_avx512vl = chacha20_use_avx2 &&
-				boot_cpu_has(X86_FEATURE_AVX512VL) &&
-				boot_cpu_has(X86_FEATURE_AVX512BW); /* kmovq */
+	chacha_use_avx512vl = chacha_use_avx2 &&
+			      boot_cpu_has(X86_FEATURE_AVX512VL) &&
+			      boot_cpu_has(X86_FEATURE_AVX512BW); /* kmovq */
 #endif
 #endif
 	return crypto_register_skciphers(algs, ARRAY_SIZE(algs));
 }
 
-static void __exit chacha20_simd_mod_fini(void)
+static void __exit chacha_simd_mod_fini(void)
 {
 	crypto_unregister_skciphers(algs, ARRAY_SIZE(algs));
 }
 
-module_init(chacha20_simd_mod_init);
-module_exit(chacha20_simd_mod_fini);
+module_init(chacha_simd_mod_init);
+module_exit(chacha_simd_mod_fini);
 
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Martin Willi <martin@strongswan.org>");
-MODULE_DESCRIPTION("chacha20 cipher algorithm, SIMD accelerated");
+MODULE_DESCRIPTION("ChaCha and XChaCha stream ciphers (x64 SIMD accelerated)");
 MODULE_ALIAS_CRYPTO("chacha20");
 MODULE_ALIAS_CRYPTO("chacha20-simd");
 MODULE_ALIAS_CRYPTO("xchacha20");
-- 
2.19.2

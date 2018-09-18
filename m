From: "Jason A. Donenfeld" <Jason@zx2c4.com>
Subject: [PATCH net-next v5 17/20] crypto: port Poly1305 to Zinc
Date: Tue, 18 Sep 2018 18:16:43 +0200
Message-ID: <20180918161646.19105-18-Jason@zx2c4.com>
References: <20180918161646.19105-1-Jason@zx2c4.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Cc: "Jason A. Donenfeld" <Jason@zx2c4.com>,
        Samuel Neves <sneves@dei.uc.pt>,
        Andy Lutomirski <luto@kernel.org>,
        Jean-Philippe Aumasson <jeanphilippe.aumasson@gmail.com>,
        Eric Biggers <ebiggers@google.com>
To: linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        linux-crypto@vger.kernel.org, davem@davemloft.net,
        gregkh@linuxfoundation.org
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180918161646.19105-1-Jason@zx2c4.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Now that Poly1305 is in Zinc, we can have the crypto API code simply
call into it. We have to do a little bit of book keeping here, because
the crypto API receives the key in the first few calls to update.

Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>
Cc: Samuel Neves <sneves@dei.uc.pt>
Cc: Andy Lutomirski <luto@kernel.org>
Cc: Greg KH <gregkh@linuxfoundation.org>
Cc: Jean-Philippe Aumasson <jeanphilippe.aumasson@gmail.com>
Cc: Eric Biggers <ebiggers@google.com>
---
 arch/x86/crypto/Makefile               |   3 -
 arch/x86/crypto/poly1305-avx2-x86_64.S | 388 ----------------
 arch/x86/crypto/poly1305-sse2-x86_64.S | 584 -------------------------
 arch/x86/crypto/poly1305_glue.c        | 205 ---------
 crypto/Kconfig                         |  15 +-
 crypto/Makefile                        |   2 +-
 crypto/chacha20poly1305.c              |  12 +-
 crypto/poly1305_generic.c              | 304 -------------
 crypto/poly1305_zinc.c                 |  98 +++++
 include/crypto/poly1305.h              |  40 --
 10 files changed, 107 insertions(+), 1544 deletions(-)
 delete mode 100644 arch/x86/crypto/poly1305-avx2-x86_64.S
 delete mode 100644 arch/x86/crypto/poly1305-sse2-x86_64.S
 delete mode 100644 arch/x86/crypto/poly1305_glue.c
 delete mode 100644 crypto/poly1305_generic.c
 create mode 100644 crypto/poly1305_zinc.c
 delete mode 100644 include/crypto/poly1305.h

diff --git a/arch/x86/crypto/Makefile b/arch/x86/crypto/Makefile
index a450ad573dcb..cf830219846b 100644
--- a/arch/x86/crypto/Makefile
+++ b/arch/x86/crypto/Makefile
@@ -34,7 +34,6 @@ obj-$(CONFIG_CRYPTO_CRC32_PCLMUL) += crc32-pclmul.o
 obj-$(CONFIG_CRYPTO_SHA256_SSSE3) += sha256-ssse3.o
 obj-$(CONFIG_CRYPTO_SHA512_SSSE3) += sha512-ssse3.o
 obj-$(CONFIG_CRYPTO_CRCT10DIF_PCLMUL) += crct10dif-pclmul.o
-obj-$(CONFIG_CRYPTO_POLY1305_X86_64) += poly1305-x86_64.o
 
 obj-$(CONFIG_CRYPTO_AEGIS128_AESNI_SSE2) += aegis128-aesni.o
 obj-$(CONFIG_CRYPTO_AEGIS128L_AESNI_SSE2) += aegis128l-aesni.o
@@ -110,10 +109,8 @@ aesni-intel-y := aesni-intel_asm.o aesni-intel_glue.o fpu.o
 aesni-intel-$(CONFIG_64BIT) += aesni-intel_avx-x86_64.o aes_ctrby8_avx-x86_64.o
 ghash-clmulni-intel-y := ghash-clmulni-intel_asm.o ghash-clmulni-intel_glue.o
 sha1-ssse3-y := sha1_ssse3_asm.o sha1_ssse3_glue.o
-poly1305-x86_64-y := poly1305-sse2-x86_64.o poly1305_glue.o
 ifeq ($(avx2_supported),yes)
 sha1-ssse3-y += sha1_avx2_x86_64_asm.o
-poly1305-x86_64-y += poly1305-avx2-x86_64.o
 endif
 ifeq ($(sha1_ni_supported),yes)
 sha1-ssse3-y += sha1_ni_asm.o
diff --git a/arch/x86/crypto/poly1305-avx2-x86_64.S b/arch/x86/crypto/poly1305-avx2-x86_64.S
deleted file mode 100644
index 3b6e70d085da..000000000000
--- a/arch/x86/crypto/poly1305-avx2-x86_64.S
+++ /dev/null
@@ -1,388 +0,0 @@
-/*
- * Poly1305 authenticator algorithm, RFC7539, x64 AVX2 functions
- *
- * Copyright (C) 2015 Martin Willi
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License as published by
- * the Free Software Foundation; either version 2 of the License, or
- * (at your option) any later version.
- */
-
-#include <linux/linkage.h>
-
-.section	.rodata.cst32.ANMASK, "aM", @progbits, 32
-.align 32
-ANMASK:	.octa 0x0000000003ffffff0000000003ffffff
-	.octa 0x0000000003ffffff0000000003ffffff
-
-.section	.rodata.cst32.ORMASK, "aM", @progbits, 32
-.align 32
-ORMASK:	.octa 0x00000000010000000000000001000000
-	.octa 0x00000000010000000000000001000000
-
-.text
-
-#define h0 0x00(%rdi)
-#define h1 0x04(%rdi)
-#define h2 0x08(%rdi)
-#define h3 0x0c(%rdi)
-#define h4 0x10(%rdi)
-#define r0 0x00(%rdx)
-#define r1 0x04(%rdx)
-#define r2 0x08(%rdx)
-#define r3 0x0c(%rdx)
-#define r4 0x10(%rdx)
-#define u0 0x00(%r8)
-#define u1 0x04(%r8)
-#define u2 0x08(%r8)
-#define u3 0x0c(%r8)
-#define u4 0x10(%r8)
-#define w0 0x14(%r8)
-#define w1 0x18(%r8)
-#define w2 0x1c(%r8)
-#define w3 0x20(%r8)
-#define w4 0x24(%r8)
-#define y0 0x28(%r8)
-#define y1 0x2c(%r8)
-#define y2 0x30(%r8)
-#define y3 0x34(%r8)
-#define y4 0x38(%r8)
-#define m %rsi
-#define hc0 %ymm0
-#define hc1 %ymm1
-#define hc2 %ymm2
-#define hc3 %ymm3
-#define hc4 %ymm4
-#define hc0x %xmm0
-#define hc1x %xmm1
-#define hc2x %xmm2
-#define hc3x %xmm3
-#define hc4x %xmm4
-#define t1 %ymm5
-#define t2 %ymm6
-#define t1x %xmm5
-#define t2x %xmm6
-#define ruwy0 %ymm7
-#define ruwy1 %ymm8
-#define ruwy2 %ymm9
-#define ruwy3 %ymm10
-#define ruwy4 %ymm11
-#define ruwy0x %xmm7
-#define ruwy1x %xmm8
-#define ruwy2x %xmm9
-#define ruwy3x %xmm10
-#define ruwy4x %xmm11
-#define svxz1 %ymm12
-#define svxz2 %ymm13
-#define svxz3 %ymm14
-#define svxz4 %ymm15
-#define d0 %r9
-#define d1 %r10
-#define d2 %r11
-#define d3 %r12
-#define d4 %r13
-
-ENTRY(poly1305_4block_avx2)
-	# %rdi: Accumulator h[5]
-	# %rsi: 64 byte input block m
-	# %rdx: Poly1305 key r[5]
-	# %rcx: Quadblock count
-	# %r8:  Poly1305 derived key r^2 u[5], r^3 w[5], r^4 y[5],
-
-	# This four-block variant uses loop unrolled block processing. It
-	# requires 4 Poly1305 keys: r, r^2, r^3 and r^4:
-	# h = (h + m) * r  =>  h = (h + m1) * r^4 + m2 * r^3 + m3 * r^2 + m4 * r
-
-	vzeroupper
-	push		%rbx
-	push		%r12
-	push		%r13
-
-	# combine r0,u0,w0,y0
-	vmovd		y0,ruwy0x
-	vmovd		w0,t1x
-	vpunpcklqdq	t1,ruwy0,ruwy0
-	vmovd		u0,t1x
-	vmovd		r0,t2x
-	vpunpcklqdq	t2,t1,t1
-	vperm2i128	$0x20,t1,ruwy0,ruwy0
-
-	# combine r1,u1,w1,y1 and s1=r1*5,v1=u1*5,x1=w1*5,z1=y1*5
-	vmovd		y1,ruwy1x
-	vmovd		w1,t1x
-	vpunpcklqdq	t1,ruwy1,ruwy1
-	vmovd		u1,t1x
-	vmovd		r1,t2x
-	vpunpcklqdq	t2,t1,t1
-	vperm2i128	$0x20,t1,ruwy1,ruwy1
-	vpslld		$2,ruwy1,svxz1
-	vpaddd		ruwy1,svxz1,svxz1
-
-	# combine r2,u2,w2,y2 and s2=r2*5,v2=u2*5,x2=w2*5,z2=y2*5
-	vmovd		y2,ruwy2x
-	vmovd		w2,t1x
-	vpunpcklqdq	t1,ruwy2,ruwy2
-	vmovd		u2,t1x
-	vmovd		r2,t2x
-	vpunpcklqdq	t2,t1,t1
-	vperm2i128	$0x20,t1,ruwy2,ruwy2
-	vpslld		$2,ruwy2,svxz2
-	vpaddd		ruwy2,svxz2,svxz2
-
-	# combine r3,u3,w3,y3 and s3=r3*5,v3=u3*5,x3=w3*5,z3=y3*5
-	vmovd		y3,ruwy3x
-	vmovd		w3,t1x
-	vpunpcklqdq	t1,ruwy3,ruwy3
-	vmovd		u3,t1x
-	vmovd		r3,t2x
-	vpunpcklqdq	t2,t1,t1
-	vperm2i128	$0x20,t1,ruwy3,ruwy3
-	vpslld		$2,ruwy3,svxz3
-	vpaddd		ruwy3,svxz3,svxz3
-
-	# combine r4,u4,w4,y4 and s4=r4*5,v4=u4*5,x4=w4*5,z4=y4*5
-	vmovd		y4,ruwy4x
-	vmovd		w4,t1x
-	vpunpcklqdq	t1,ruwy4,ruwy4
-	vmovd		u4,t1x
-	vmovd		r4,t2x
-	vpunpcklqdq	t2,t1,t1
-	vperm2i128	$0x20,t1,ruwy4,ruwy4
-	vpslld		$2,ruwy4,svxz4
-	vpaddd		ruwy4,svxz4,svxz4
-
-.Ldoblock4:
-	# hc0 = [m[48-51] & 0x3ffffff, m[32-35] & 0x3ffffff,
-	#	 m[16-19] & 0x3ffffff, m[ 0- 3] & 0x3ffffff + h0]
-	vmovd		0x00(m),hc0x
-	vmovd		0x10(m),t1x
-	vpunpcklqdq	t1,hc0,hc0
-	vmovd		0x20(m),t1x
-	vmovd		0x30(m),t2x
-	vpunpcklqdq	t2,t1,t1
-	vperm2i128	$0x20,t1,hc0,hc0
-	vpand		ANMASK(%rip),hc0,hc0
-	vmovd		h0,t1x
-	vpaddd		t1,hc0,hc0
-	# hc1 = [(m[51-54] >> 2) & 0x3ffffff, (m[35-38] >> 2) & 0x3ffffff,
-	#	 (m[19-22] >> 2) & 0x3ffffff, (m[ 3- 6] >> 2) & 0x3ffffff + h1]
-	vmovd		0x03(m),hc1x
-	vmovd		0x13(m),t1x
-	vpunpcklqdq	t1,hc1,hc1
-	vmovd		0x23(m),t1x
-	vmovd		0x33(m),t2x
-	vpunpcklqdq	t2,t1,t1
-	vperm2i128	$0x20,t1,hc1,hc1
-	vpsrld		$2,hc1,hc1
-	vpand		ANMASK(%rip),hc1,hc1
-	vmovd		h1,t1x
-	vpaddd		t1,hc1,hc1
-	# hc2 = [(m[54-57] >> 4) & 0x3ffffff, (m[38-41] >> 4) & 0x3ffffff,
-	#	 (m[22-25] >> 4) & 0x3ffffff, (m[ 6- 9] >> 4) & 0x3ffffff + h2]
-	vmovd		0x06(m),hc2x
-	vmovd		0x16(m),t1x
-	vpunpcklqdq	t1,hc2,hc2
-	vmovd		0x26(m),t1x
-	vmovd		0x36(m),t2x
-	vpunpcklqdq	t2,t1,t1
-	vperm2i128	$0x20,t1,hc2,hc2
-	vpsrld		$4,hc2,hc2
-	vpand		ANMASK(%rip),hc2,hc2
-	vmovd		h2,t1x
-	vpaddd		t1,hc2,hc2
-	# hc3 = [(m[57-60] >> 6) & 0x3ffffff, (m[41-44] >> 6) & 0x3ffffff,
-	#	 (m[25-28] >> 6) & 0x3ffffff, (m[ 9-12] >> 6) & 0x3ffffff + h3]
-	vmovd		0x09(m),hc3x
-	vmovd		0x19(m),t1x
-	vpunpcklqdq	t1,hc3,hc3
-	vmovd		0x29(m),t1x
-	vmovd		0x39(m),t2x
-	vpunpcklqdq	t2,t1,t1
-	vperm2i128	$0x20,t1,hc3,hc3
-	vpsrld		$6,hc3,hc3
-	vpand		ANMASK(%rip),hc3,hc3
-	vmovd		h3,t1x
-	vpaddd		t1,hc3,hc3
-	# hc4 = [(m[60-63] >> 8) | (1<<24), (m[44-47] >> 8) | (1<<24),
-	#	 (m[28-31] >> 8) | (1<<24), (m[12-15] >> 8) | (1<<24) + h4]
-	vmovd		0x0c(m),hc4x
-	vmovd		0x1c(m),t1x
-	vpunpcklqdq	t1,hc4,hc4
-	vmovd		0x2c(m),t1x
-	vmovd		0x3c(m),t2x
-	vpunpcklqdq	t2,t1,t1
-	vperm2i128	$0x20,t1,hc4,hc4
-	vpsrld		$8,hc4,hc4
-	vpor		ORMASK(%rip),hc4,hc4
-	vmovd		h4,t1x
-	vpaddd		t1,hc4,hc4
-
-	# t1 = [ hc0[3] * r0, hc0[2] * u0, hc0[1] * w0, hc0[0] * y0 ]
-	vpmuludq	hc0,ruwy0,t1
-	# t1 += [ hc1[3] * s4, hc1[2] * v4, hc1[1] * x4, hc1[0] * z4 ]
-	vpmuludq	hc1,svxz4,t2
-	vpaddq		t2,t1,t1
-	# t1 += [ hc2[3] * s3, hc2[2] * v3, hc2[1] * x3, hc2[0] * z3 ]
-	vpmuludq	hc2,svxz3,t2
-	vpaddq		t2,t1,t1
-	# t1 += [ hc3[3] * s2, hc3[2] * v2, hc3[1] * x2, hc3[0] * z2 ]
-	vpmuludq	hc3,svxz2,t2
-	vpaddq		t2,t1,t1
-	# t1 += [ hc4[3] * s1, hc4[2] * v1, hc4[1] * x1, hc4[0] * z1 ]
-	vpmuludq	hc4,svxz1,t2
-	vpaddq		t2,t1,t1
-	# d0 = t1[0] + t1[1] + t[2] + t[3]
-	vpermq		$0xee,t1,t2
-	vpaddq		t2,t1,t1
-	vpsrldq		$8,t1,t2
-	vpaddq		t2,t1,t1
-	vmovq		t1x,d0
-
-	# t1 = [ hc0[3] * r1, hc0[2] * u1,hc0[1] * w1, hc0[0] * y1 ]
-	vpmuludq	hc0,ruwy1,t1
-	# t1 += [ hc1[3] * r0, hc1[2] * u0, hc1[1] * w0, hc1[0] * y0 ]
-	vpmuludq	hc1,ruwy0,t2
-	vpaddq		t2,t1,t1
-	# t1 += [ hc2[3] * s4, hc2[2] * v4, hc2[1] * x4, hc2[0] * z4 ]
-	vpmuludq	hc2,svxz4,t2
-	vpaddq		t2,t1,t1
-	# t1 += [ hc3[3] * s3, hc3[2] * v3, hc3[1] * x3, hc3[0] * z3 ]
-	vpmuludq	hc3,svxz3,t2
-	vpaddq		t2,t1,t1
-	# t1 += [ hc4[3] * s2, hc4[2] * v2, hc4[1] * x2, hc4[0] * z2 ]
-	vpmuludq	hc4,svxz2,t2
-	vpaddq		t2,t1,t1
-	# d1 = t1[0] + t1[1] + t1[3] + t1[4]
-	vpermq		$0xee,t1,t2
-	vpaddq		t2,t1,t1
-	vpsrldq		$8,t1,t2
-	vpaddq		t2,t1,t1
-	vmovq		t1x,d1
-
-	# t1 = [ hc0[3] * r2, hc0[2] * u2, hc0[1] * w2, hc0[0] * y2 ]
-	vpmuludq	hc0,ruwy2,t1
-	# t1 += [ hc1[3] * r1, hc1[2] * u1, hc1[1] * w1, hc1[0] * y1 ]
-	vpmuludq	hc1,ruwy1,t2
-	vpaddq		t2,t1,t1
-	# t1 += [ hc2[3] * r0, hc2[2] * u0, hc2[1] * w0, hc2[0] * y0 ]
-	vpmuludq	hc2,ruwy0,t2
-	vpaddq		t2,t1,t1
-	# t1 += [ hc3[3] * s4, hc3[2] * v4, hc3[1] * x4, hc3[0] * z4 ]
-	vpmuludq	hc3,svxz4,t2
-	vpaddq		t2,t1,t1
-	# t1 += [ hc4[3] * s3, hc4[2] * v3, hc4[1] * x3, hc4[0] * z3 ]
-	vpmuludq	hc4,svxz3,t2
-	vpaddq		t2,t1,t1
-	# d2 = t1[0] + t1[1] + t1[2] + t1[3]
-	vpermq		$0xee,t1,t2
-	vpaddq		t2,t1,t1
-	vpsrldq		$8,t1,t2
-	vpaddq		t2,t1,t1
-	vmovq		t1x,d2
-
-	# t1 = [ hc0[3] * r3, hc0[2] * u3, hc0[1] * w3, hc0[0] * y3 ]
-	vpmuludq	hc0,ruwy3,t1
-	# t1 += [ hc1[3] * r2, hc1[2] * u2, hc1[1] * w2, hc1[0] * y2 ]
-	vpmuludq	hc1,ruwy2,t2
-	vpaddq		t2,t1,t1
-	# t1 += [ hc2[3] * r1, hc2[2] * u1, hc2[1] * w1, hc2[0] * y1 ]
-	vpmuludq	hc2,ruwy1,t2
-	vpaddq		t2,t1,t1
-	# t1 += [ hc3[3] * r0, hc3[2] * u0, hc3[1] * w0, hc3[0] * y0 ]
-	vpmuludq	hc3,ruwy0,t2
-	vpaddq		t2,t1,t1
-	# t1 += [ hc4[3] * s4, hc4[2] * v4, hc4[1] * x4, hc4[0] * z4 ]
-	vpmuludq	hc4,svxz4,t2
-	vpaddq		t2,t1,t1
-	# d3 = t1[0] + t1[1] + t1[2] + t1[3]
-	vpermq		$0xee,t1,t2
-	vpaddq		t2,t1,t1
-	vpsrldq		$8,t1,t2
-	vpaddq		t2,t1,t1
-	vmovq		t1x,d3
-
-	# t1 = [ hc0[3] * r4, hc0[2] * u4, hc0[1] * w4, hc0[0] * y4 ]
-	vpmuludq	hc0,ruwy4,t1
-	# t1 += [ hc1[3] * r3, hc1[2] * u3, hc1[1] * w3, hc1[0] * y3 ]
-	vpmuludq	hc1,ruwy3,t2
-	vpaddq		t2,t1,t1
-	# t1 += [ hc2[3] * r2, hc2[2] * u2, hc2[1] * w2, hc2[0] * y2 ]
-	vpmuludq	hc2,ruwy2,t2
-	vpaddq		t2,t1,t1
-	# t1 += [ hc3[3] * r1, hc3[2] * u1, hc3[1] * w1, hc3[0] * y1 ]
-	vpmuludq	hc3,ruwy1,t2
-	vpaddq		t2,t1,t1
-	# t1 += [ hc4[3] * r0, hc4[2] * u0, hc4[1] * w0, hc4[0] * y0 ]
-	vpmuludq	hc4,ruwy0,t2
-	vpaddq		t2,t1,t1
-	# d4 = t1[0] + t1[1] + t1[2] + t1[3]
-	vpermq		$0xee,t1,t2
-	vpaddq		t2,t1,t1
-	vpsrldq		$8,t1,t2
-	vpaddq		t2,t1,t1
-	vmovq		t1x,d4
-
-	# d1 += d0 >> 26
-	mov		d0,%rax
-	shr		$26,%rax
-	add		%rax,d1
-	# h0 = d0 & 0x3ffffff
-	mov		d0,%rbx
-	and		$0x3ffffff,%ebx
-
-	# d2 += d1 >> 26
-	mov		d1,%rax
-	shr		$26,%rax
-	add		%rax,d2
-	# h1 = d1 & 0x3ffffff
-	mov		d1,%rax
-	and		$0x3ffffff,%eax
-	mov		%eax,h1
-
-	# d3 += d2 >> 26
-	mov		d2,%rax
-	shr		$26,%rax
-	add		%rax,d3
-	# h2 = d2 & 0x3ffffff
-	mov		d2,%rax
-	and		$0x3ffffff,%eax
-	mov		%eax,h2
-
-	# d4 += d3 >> 26
-	mov		d3,%rax
-	shr		$26,%rax
-	add		%rax,d4
-	# h3 = d3 & 0x3ffffff
-	mov		d3,%rax
-	and		$0x3ffffff,%eax
-	mov		%eax,h3
-
-	# h0 += (d4 >> 26) * 5
-	mov		d4,%rax
-	shr		$26,%rax
-	lea		(%eax,%eax,4),%eax
-	add		%eax,%ebx
-	# h4 = d4 & 0x3ffffff
-	mov		d4,%rax
-	and		$0x3ffffff,%eax
-	mov		%eax,h4
-
-	# h1 += h0 >> 26
-	mov		%ebx,%eax
-	shr		$26,%eax
-	add		%eax,h1
-	# h0 = h0 & 0x3ffffff
-	andl		$0x3ffffff,%ebx
-	mov		%ebx,h0
-
-	add		$0x40,m
-	dec		%rcx
-	jnz		.Ldoblock4
-
-	vzeroupper
-	pop		%r13
-	pop		%r12
-	pop		%rbx
-	ret
-ENDPROC(poly1305_4block_avx2)
diff --git a/arch/x86/crypto/poly1305-sse2-x86_64.S b/arch/x86/crypto/poly1305-sse2-x86_64.S
deleted file mode 100644
index c88c670cb5fc..000000000000
--- a/arch/x86/crypto/poly1305-sse2-x86_64.S
+++ /dev/null
@@ -1,584 +0,0 @@
-/*
- * Poly1305 authenticator algorithm, RFC7539, x64 SSE2 functions
- *
- * Copyright (C) 2015 Martin Willi
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License as published by
- * the Free Software Foundation; either version 2 of the License, or
- * (at your option) any later version.
- */
-
-#include <linux/linkage.h>
-
-.section	.rodata.cst16.ANMASK, "aM", @progbits, 16
-.align 16
-ANMASK:	.octa 0x0000000003ffffff0000000003ffffff
-
-.section	.rodata.cst16.ORMASK, "aM", @progbits, 16
-.align 16
-ORMASK:	.octa 0x00000000010000000000000001000000
-
-.text
-
-#define h0 0x00(%rdi)
-#define h1 0x04(%rdi)
-#define h2 0x08(%rdi)
-#define h3 0x0c(%rdi)
-#define h4 0x10(%rdi)
-#define r0 0x00(%rdx)
-#define r1 0x04(%rdx)
-#define r2 0x08(%rdx)
-#define r3 0x0c(%rdx)
-#define r4 0x10(%rdx)
-#define s1 0x00(%rsp)
-#define s2 0x04(%rsp)
-#define s3 0x08(%rsp)
-#define s4 0x0c(%rsp)
-#define m %rsi
-#define h01 %xmm0
-#define h23 %xmm1
-#define h44 %xmm2
-#define t1 %xmm3
-#define t2 %xmm4
-#define t3 %xmm5
-#define t4 %xmm6
-#define mask %xmm7
-#define d0 %r8
-#define d1 %r9
-#define d2 %r10
-#define d3 %r11
-#define d4 %r12
-
-ENTRY(poly1305_block_sse2)
-	# %rdi: Accumulator h[5]
-	# %rsi: 16 byte input block m
-	# %rdx: Poly1305 key r[5]
-	# %rcx: Block count
-
-	# This single block variant tries to improve performance by doing two
-	# multiplications in parallel using SSE instructions. There is quite
-	# some quardword packing involved, hence the speedup is marginal.
-
-	push		%rbx
-	push		%r12
-	sub		$0x10,%rsp
-
-	# s1..s4 = r1..r4 * 5
-	mov		r1,%eax
-	lea		(%eax,%eax,4),%eax
-	mov		%eax,s1
-	mov		r2,%eax
-	lea		(%eax,%eax,4),%eax
-	mov		%eax,s2
-	mov		r3,%eax
-	lea		(%eax,%eax,4),%eax
-	mov		%eax,s3
-	mov		r4,%eax
-	lea		(%eax,%eax,4),%eax
-	mov		%eax,s4
-
-	movdqa		ANMASK(%rip),mask
-
-.Ldoblock:
-	# h01 = [0, h1, 0, h0]
-	# h23 = [0, h3, 0, h2]
-	# h44 = [0, h4, 0, h4]
-	movd		h0,h01
-	movd		h1,t1
-	movd		h2,h23
-	movd		h3,t2
-	movd		h4,h44
-	punpcklqdq	t1,h01
-	punpcklqdq	t2,h23
-	punpcklqdq	h44,h44
-
-	# h01 += [ (m[3-6] >> 2) & 0x3ffffff, m[0-3] & 0x3ffffff ]
-	movd		0x00(m),t1
-	movd		0x03(m),t2
-	psrld		$2,t2
-	punpcklqdq	t2,t1
-	pand		mask,t1
-	paddd		t1,h01
-	# h23 += [ (m[9-12] >> 6) & 0x3ffffff, (m[6-9] >> 4) & 0x3ffffff ]
-	movd		0x06(m),t1
-	movd		0x09(m),t2
-	psrld		$4,t1
-	psrld		$6,t2
-	punpcklqdq	t2,t1
-	pand		mask,t1
-	paddd		t1,h23
-	# h44 += [ (m[12-15] >> 8) | (1 << 24), (m[12-15] >> 8) | (1 << 24) ]
-	mov		0x0c(m),%eax
-	shr		$8,%eax
-	or		$0x01000000,%eax
-	movd		%eax,t1
-	pshufd		$0xc4,t1,t1
-	paddd		t1,h44
-
-	# t1[0] = h0 * r0 + h2 * s3
-	# t1[1] = h1 * s4 + h3 * s2
-	movd		r0,t1
-	movd		s4,t2
-	punpcklqdq	t2,t1
-	pmuludq		h01,t1
-	movd		s3,t2
-	movd		s2,t3
-	punpcklqdq	t3,t2
-	pmuludq		h23,t2
-	paddq		t2,t1
-	# t2[0] = h0 * r1 + h2 * s4
-	# t2[1] = h1 * r0 + h3 * s3
-	movd		r1,t2
-	movd		r0,t3
-	punpcklqdq	t3,t2
-	pmuludq		h01,t2
-	movd		s4,t3
-	movd		s3,t4
-	punpcklqdq	t4,t3
-	pmuludq		h23,t3
-	paddq		t3,t2
-	# t3[0] = h4 * s1
-	# t3[1] = h4 * s2
-	movd		s1,t3
-	movd		s2,t4
-	punpcklqdq	t4,t3
-	pmuludq		h44,t3
-	# d0 = t1[0] + t1[1] + t3[0]
-	# d1 = t2[0] + t2[1] + t3[1]
-	movdqa		t1,t4
-	punpcklqdq	t2,t4
-	punpckhqdq	t2,t1
-	paddq		t4,t1
-	paddq		t3,t1
-	movq		t1,d0
-	psrldq		$8,t1
-	movq		t1,d1
-
-	# t1[0] = h0 * r2 + h2 * r0
-	# t1[1] = h1 * r1 + h3 * s4
-	movd		r2,t1
-	movd		r1,t2
-	punpcklqdq 	t2,t1
-	pmuludq		h01,t1
-	movd		r0,t2
-	movd		s4,t3
-	punpcklqdq	t3,t2
-	pmuludq		h23,t2
-	paddq		t2,t1
-	# t2[0] = h0 * r3 + h2 * r1
-	# t2[1] = h1 * r2 + h3 * r0
-	movd		r3,t2
-	movd		r2,t3
-	punpcklqdq	t3,t2
-	pmuludq		h01,t2
-	movd		r1,t3
-	movd		r0,t4
-	punpcklqdq	t4,t3
-	pmuludq		h23,t3
-	paddq		t3,t2
-	# t3[0] = h4 * s3
-	# t3[1] = h4 * s4
-	movd		s3,t3
-	movd		s4,t4
-	punpcklqdq	t4,t3
-	pmuludq		h44,t3
-	# d2 = t1[0] + t1[1] + t3[0]
-	# d3 = t2[0] + t2[1] + t3[1]
-	movdqa		t1,t4
-	punpcklqdq	t2,t4
-	punpckhqdq	t2,t1
-	paddq		t4,t1
-	paddq		t3,t1
-	movq		t1,d2
-	psrldq		$8,t1
-	movq		t1,d3
-
-	# t1[0] = h0 * r4 + h2 * r2
-	# t1[1] = h1 * r3 + h3 * r1
-	movd		r4,t1
-	movd		r3,t2
-	punpcklqdq	t2,t1
-	pmuludq		h01,t1
-	movd		r2,t2
-	movd		r1,t3
-	punpcklqdq	t3,t2
-	pmuludq		h23,t2
-	paddq		t2,t1
-	# t3[0] = h4 * r0
-	movd		r0,t3
-	pmuludq		h44,t3
-	# d4 = t1[0] + t1[1] + t3[0]
-	movdqa		t1,t4
-	psrldq		$8,t4
-	paddq		t4,t1
-	paddq		t3,t1
-	movq		t1,d4
-
-	# d1 += d0 >> 26
-	mov		d0,%rax
-	shr		$26,%rax
-	add		%rax,d1
-	# h0 = d0 & 0x3ffffff
-	mov		d0,%rbx
-	and		$0x3ffffff,%ebx
-
-	# d2 += d1 >> 26
-	mov		d1,%rax
-	shr		$26,%rax
-	add		%rax,d2
-	# h1 = d1 & 0x3ffffff
-	mov		d1,%rax
-	and		$0x3ffffff,%eax
-	mov		%eax,h1
-
-	# d3 += d2 >> 26
-	mov		d2,%rax
-	shr		$26,%rax
-	add		%rax,d3
-	# h2 = d2 & 0x3ffffff
-	mov		d2,%rax
-	and		$0x3ffffff,%eax
-	mov		%eax,h2
-
-	# d4 += d3 >> 26
-	mov		d3,%rax
-	shr		$26,%rax
-	add		%rax,d4
-	# h3 = d3 & 0x3ffffff
-	mov		d3,%rax
-	and		$0x3ffffff,%eax
-	mov		%eax,h3
-
-	# h0 += (d4 >> 26) * 5
-	mov		d4,%rax
-	shr		$26,%rax
-	lea		(%eax,%eax,4),%eax
-	add		%eax,%ebx
-	# h4 = d4 & 0x3ffffff
-	mov		d4,%rax
-	and		$0x3ffffff,%eax
-	mov		%eax,h4
-
-	# h1 += h0 >> 26
-	mov		%ebx,%eax
-	shr		$26,%eax
-	add		%eax,h1
-	# h0 = h0 & 0x3ffffff
-	andl		$0x3ffffff,%ebx
-	mov		%ebx,h0
-
-	add		$0x10,m
-	dec		%rcx
-	jnz		.Ldoblock
-
-	add		$0x10,%rsp
-	pop		%r12
-	pop		%rbx
-	ret
-ENDPROC(poly1305_block_sse2)
-
-
-#define u0 0x00(%r8)
-#define u1 0x04(%r8)
-#define u2 0x08(%r8)
-#define u3 0x0c(%r8)
-#define u4 0x10(%r8)
-#define hc0 %xmm0
-#define hc1 %xmm1
-#define hc2 %xmm2
-#define hc3 %xmm5
-#define hc4 %xmm6
-#define ru0 %xmm7
-#define ru1 %xmm8
-#define ru2 %xmm9
-#define ru3 %xmm10
-#define ru4 %xmm11
-#define sv1 %xmm12
-#define sv2 %xmm13
-#define sv3 %xmm14
-#define sv4 %xmm15
-#undef d0
-#define d0 %r13
-
-ENTRY(poly1305_2block_sse2)
-	# %rdi: Accumulator h[5]
-	# %rsi: 16 byte input block m
-	# %rdx: Poly1305 key r[5]
-	# %rcx: Doubleblock count
-	# %r8:  Poly1305 derived key r^2 u[5]
-
-	# This two-block variant further improves performance by using loop
-	# unrolled block processing. This is more straight forward and does
-	# less byte shuffling, but requires a second Poly1305 key r^2:
-	# h = (h + m) * r    =>    h = (h + m1) * r^2 + m2 * r
-
-	push		%rbx
-	push		%r12
-	push		%r13
-
-	# combine r0,u0
-	movd		u0,ru0
-	movd		r0,t1
-	punpcklqdq	t1,ru0
-
-	# combine r1,u1 and s1=r1*5,v1=u1*5
-	movd		u1,ru1
-	movd		r1,t1
-	punpcklqdq	t1,ru1
-	movdqa		ru1,sv1
-	pslld		$2,sv1
-	paddd		ru1,sv1
-
-	# combine r2,u2 and s2=r2*5,v2=u2*5
-	movd		u2,ru2
-	movd		r2,t1
-	punpcklqdq	t1,ru2
-	movdqa		ru2,sv2
-	pslld		$2,sv2
-	paddd		ru2,sv2
-
-	# combine r3,u3 and s3=r3*5,v3=u3*5
-	movd		u3,ru3
-	movd		r3,t1
-	punpcklqdq	t1,ru3
-	movdqa		ru3,sv3
-	pslld		$2,sv3
-	paddd		ru3,sv3
-
-	# combine r4,u4 and s4=r4*5,v4=u4*5
-	movd		u4,ru4
-	movd		r4,t1
-	punpcklqdq	t1,ru4
-	movdqa		ru4,sv4
-	pslld		$2,sv4
-	paddd		ru4,sv4
-
-.Ldoblock2:
-	# hc0 = [ m[16-19] & 0x3ffffff, h0 + m[0-3] & 0x3ffffff ]
-	movd		0x00(m),hc0
-	movd		0x10(m),t1
-	punpcklqdq	t1,hc0
-	pand		ANMASK(%rip),hc0
-	movd		h0,t1
-	paddd		t1,hc0
-	# hc1 = [ (m[19-22] >> 2) & 0x3ffffff, h1 + (m[3-6] >> 2) & 0x3ffffff ]
-	movd		0x03(m),hc1
-	movd		0x13(m),t1
-	punpcklqdq	t1,hc1
-	psrld		$2,hc1
-	pand		ANMASK(%rip),hc1
-	movd		h1,t1
-	paddd		t1,hc1
-	# hc2 = [ (m[22-25] >> 4) & 0x3ffffff, h2 + (m[6-9] >> 4) & 0x3ffffff ]
-	movd		0x06(m),hc2
-	movd		0x16(m),t1
-	punpcklqdq	t1,hc2
-	psrld		$4,hc2
-	pand		ANMASK(%rip),hc2
-	movd		h2,t1
-	paddd		t1,hc2
-	# hc3 = [ (m[25-28] >> 6) & 0x3ffffff, h3 + (m[9-12] >> 6) & 0x3ffffff ]
-	movd		0x09(m),hc3
-	movd		0x19(m),t1
-	punpcklqdq	t1,hc3
-	psrld		$6,hc3
-	pand		ANMASK(%rip),hc3
-	movd		h3,t1
-	paddd		t1,hc3
-	# hc4 = [ (m[28-31] >> 8) | (1<<24), h4 + (m[12-15] >> 8) | (1<<24) ]
-	movd		0x0c(m),hc4
-	movd		0x1c(m),t1
-	punpcklqdq	t1,hc4
-	psrld		$8,hc4
-	por		ORMASK(%rip),hc4
-	movd		h4,t1
-	paddd		t1,hc4
-
-	# t1 = [ hc0[1] * r0, hc0[0] * u0 ]
-	movdqa		ru0,t1
-	pmuludq		hc0,t1
-	# t1 += [ hc1[1] * s4, hc1[0] * v4 ]
-	movdqa		sv4,t2
-	pmuludq		hc1,t2
-	paddq		t2,t1
-	# t1 += [ hc2[1] * s3, hc2[0] * v3 ]
-	movdqa		sv3,t2
-	pmuludq		hc2,t2
-	paddq		t2,t1
-	# t1 += [ hc3[1] * s2, hc3[0] * v2 ]
-	movdqa		sv2,t2
-	pmuludq		hc3,t2
-	paddq		t2,t1
-	# t1 += [ hc4[1] * s1, hc4[0] * v1 ]
-	movdqa		sv1,t2
-	pmuludq		hc4,t2
-	paddq		t2,t1
-	# d0 = t1[0] + t1[1]
-	movdqa		t1,t2
-	psrldq		$8,t2
-	paddq		t2,t1
-	movq		t1,d0
-
-	# t1 = [ hc0[1] * r1, hc0[0] * u1 ]
-	movdqa		ru1,t1
-	pmuludq		hc0,t1
-	# t1 += [ hc1[1] * r0, hc1[0] * u0 ]
-	movdqa		ru0,t2
-	pmuludq		hc1,t2
-	paddq		t2,t1
-	# t1 += [ hc2[1] * s4, hc2[0] * v4 ]
-	movdqa		sv4,t2
-	pmuludq		hc2,t2
-	paddq		t2,t1
-	# t1 += [ hc3[1] * s3, hc3[0] * v3 ]
-	movdqa		sv3,t2
-	pmuludq		hc3,t2
-	paddq		t2,t1
-	# t1 += [ hc4[1] * s2, hc4[0] * v2 ]
-	movdqa		sv2,t2
-	pmuludq		hc4,t2
-	paddq		t2,t1
-	# d1 = t1[0] + t1[1]
-	movdqa		t1,t2
-	psrldq		$8,t2
-	paddq		t2,t1
-	movq		t1,d1
-
-	# t1 = [ hc0[1] * r2, hc0[0] * u2 ]
-	movdqa		ru2,t1
-	pmuludq		hc0,t1
-	# t1 += [ hc1[1] * r1, hc1[0] * u1 ]
-	movdqa		ru1,t2
-	pmuludq		hc1,t2
-	paddq		t2,t1
-	# t1 += [ hc2[1] * r0, hc2[0] * u0 ]
-	movdqa		ru0,t2
-	pmuludq		hc2,t2
-	paddq		t2,t1
-	# t1 += [ hc3[1] * s4, hc3[0] * v4 ]
-	movdqa		sv4,t2
-	pmuludq		hc3,t2
-	paddq		t2,t1
-	# t1 += [ hc4[1] * s3, hc4[0] * v3 ]
-	movdqa		sv3,t2
-	pmuludq		hc4,t2
-	paddq		t2,t1
-	# d2 = t1[0] + t1[1]
-	movdqa		t1,t2
-	psrldq		$8,t2
-	paddq		t2,t1
-	movq		t1,d2
-
-	# t1 = [ hc0[1] * r3, hc0[0] * u3 ]
-	movdqa		ru3,t1
-	pmuludq		hc0,t1
-	# t1 += [ hc1[1] * r2, hc1[0] * u2 ]
-	movdqa		ru2,t2
-	pmuludq		hc1,t2
-	paddq		t2,t1
-	# t1 += [ hc2[1] * r1, hc2[0] * u1 ]
-	movdqa		ru1,t2
-	pmuludq		hc2,t2
-	paddq		t2,t1
-	# t1 += [ hc3[1] * r0, hc3[0] * u0 ]
-	movdqa		ru0,t2
-	pmuludq		hc3,t2
-	paddq		t2,t1
-	# t1 += [ hc4[1] * s4, hc4[0] * v4 ]
-	movdqa		sv4,t2
-	pmuludq		hc4,t2
-	paddq		t2,t1
-	# d3 = t1[0] + t1[1]
-	movdqa		t1,t2
-	psrldq		$8,t2
-	paddq		t2,t1
-	movq		t1,d3
-
-	# t1 = [ hc0[1] * r4, hc0[0] * u4 ]
-	movdqa		ru4,t1
-	pmuludq		hc0,t1
-	# t1 += [ hc1[1] * r3, hc1[0] * u3 ]
-	movdqa		ru3,t2
-	pmuludq		hc1,t2
-	paddq		t2,t1
-	# t1 += [ hc2[1] * r2, hc2[0] * u2 ]
-	movdqa		ru2,t2
-	pmuludq		hc2,t2
-	paddq		t2,t1
-	# t1 += [ hc3[1] * r1, hc3[0] * u1 ]
-	movdqa		ru1,t2
-	pmuludq		hc3,t2
-	paddq		t2,t1
-	# t1 += [ hc4[1] * r0, hc4[0] * u0 ]
-	movdqa		ru0,t2
-	pmuludq		hc4,t2
-	paddq		t2,t1
-	# d4 = t1[0] + t1[1]
-	movdqa		t1,t2
-	psrldq		$8,t2
-	paddq		t2,t1
-	movq		t1,d4
-
-	# d1 += d0 >> 26
-	mov		d0,%rax
-	shr		$26,%rax
-	add		%rax,d1
-	# h0 = d0 & 0x3ffffff
-	mov		d0,%rbx
-	and		$0x3ffffff,%ebx
-
-	# d2 += d1 >> 26
-	mov		d1,%rax
-	shr		$26,%rax
-	add		%rax,d2
-	# h1 = d1 & 0x3ffffff
-	mov		d1,%rax
-	and		$0x3ffffff,%eax
-	mov		%eax,h1
-
-	# d3 += d2 >> 26
-	mov		d2,%rax
-	shr		$26,%rax
-	add		%rax,d3
-	# h2 = d2 & 0x3ffffff
-	mov		d2,%rax
-	and		$0x3ffffff,%eax
-	mov		%eax,h2
-
-	# d4 += d3 >> 26
-	mov		d3,%rax
-	shr		$26,%rax
-	add		%rax,d4
-	# h3 = d3 & 0x3ffffff
-	mov		d3,%rax
-	and		$0x3ffffff,%eax
-	mov		%eax,h3
-
-	# h0 += (d4 >> 26) * 5
-	mov		d4,%rax
-	shr		$26,%rax
-	lea		(%eax,%eax,4),%eax
-	add		%eax,%ebx
-	# h4 = d4 & 0x3ffffff
-	mov		d4,%rax
-	and		$0x3ffffff,%eax
-	mov		%eax,h4
-
-	# h1 += h0 >> 26
-	mov		%ebx,%eax
-	shr		$26,%eax
-	add		%eax,h1
-	# h0 = h0 & 0x3ffffff
-	andl		$0x3ffffff,%ebx
-	mov		%ebx,h0
-
-	add		$0x20,m
-	dec		%rcx
-	jnz		.Ldoblock2
-
-	pop		%r13
-	pop		%r12
-	pop		%rbx
-	ret
-ENDPROC(poly1305_2block_sse2)
diff --git a/arch/x86/crypto/poly1305_glue.c b/arch/x86/crypto/poly1305_glue.c
deleted file mode 100644
index f012b7e28ad1..000000000000
--- a/arch/x86/crypto/poly1305_glue.c
+++ /dev/null
@@ -1,205 +0,0 @@
-/*
- * Poly1305 authenticator algorithm, RFC7539, SIMD glue code
- *
- * Copyright (C) 2015 Martin Willi
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License as published by
- * the Free Software Foundation; either version 2 of the License, or
- * (at your option) any later version.
- */
-
-#include <crypto/algapi.h>
-#include <crypto/internal/hash.h>
-#include <crypto/poly1305.h>
-#include <linux/crypto.h>
-#include <linux/kernel.h>
-#include <linux/module.h>
-#include <asm/fpu/api.h>
-#include <asm/simd.h>
-
-struct poly1305_simd_desc_ctx {
-	struct poly1305_desc_ctx base;
-	/* derived key u set? */
-	bool uset;
-#ifdef CONFIG_AS_AVX2
-	/* derived keys r^3, r^4 set? */
-	bool wset;
-#endif
-	/* derived Poly1305 key r^2 */
-	u32 u[5];
-	/* ... silently appended r^3 and r^4 when using AVX2 */
-};
-
-asmlinkage void poly1305_block_sse2(u32 *h, const u8 *src,
-				    const u32 *r, unsigned int blocks);
-asmlinkage void poly1305_2block_sse2(u32 *h, const u8 *src, const u32 *r,
-				     unsigned int blocks, const u32 *u);
-#ifdef CONFIG_AS_AVX2
-asmlinkage void poly1305_4block_avx2(u32 *h, const u8 *src, const u32 *r,
-				     unsigned int blocks, const u32 *u);
-static bool poly1305_use_avx2;
-#endif
-
-static int poly1305_simd_init(struct shash_desc *desc)
-{
-	struct poly1305_simd_desc_ctx *sctx = shash_desc_ctx(desc);
-
-	sctx->uset = false;
-#ifdef CONFIG_AS_AVX2
-	sctx->wset = false;
-#endif
-
-	return crypto_poly1305_init(desc);
-}
-
-static void poly1305_simd_mult(u32 *a, const u32 *b)
-{
-	u8 m[POLY1305_BLOCK_SIZE];
-
-	memset(m, 0, sizeof(m));
-	/* The poly1305 block function adds a hi-bit to the accumulator which
-	 * we don't need for key multiplication; compensate for it. */
-	a[4] -= 1 << 24;
-	poly1305_block_sse2(a, m, b, 1);
-}
-
-static unsigned int poly1305_simd_blocks(struct poly1305_desc_ctx *dctx,
-					 const u8 *src, unsigned int srclen)
-{
-	struct poly1305_simd_desc_ctx *sctx;
-	unsigned int blocks, datalen;
-
-	BUILD_BUG_ON(offsetof(struct poly1305_simd_desc_ctx, base));
-	sctx = container_of(dctx, struct poly1305_simd_desc_ctx, base);
-
-	if (unlikely(!dctx->sset)) {
-		datalen = crypto_poly1305_setdesckey(dctx, src, srclen);
-		src += srclen - datalen;
-		srclen = datalen;
-	}
-
-#ifdef CONFIG_AS_AVX2
-	if (poly1305_use_avx2 && srclen >= POLY1305_BLOCK_SIZE * 4) {
-		if (unlikely(!sctx->wset)) {
-			if (!sctx->uset) {
-				memcpy(sctx->u, dctx->r, sizeof(sctx->u));
-				poly1305_simd_mult(sctx->u, dctx->r);
-				sctx->uset = true;
-			}
-			memcpy(sctx->u + 5, sctx->u, sizeof(sctx->u));
-			poly1305_simd_mult(sctx->u + 5, dctx->r);
-			memcpy(sctx->u + 10, sctx->u + 5, sizeof(sctx->u));
-			poly1305_simd_mult(sctx->u + 10, dctx->r);
-			sctx->wset = true;
-		}
-		blocks = srclen / (POLY1305_BLOCK_SIZE * 4);
-		poly1305_4block_avx2(dctx->h, src, dctx->r, blocks, sctx->u);
-		src += POLY1305_BLOCK_SIZE * 4 * blocks;
-		srclen -= POLY1305_BLOCK_SIZE * 4 * blocks;
-	}
-#endif
-	if (likely(srclen >= POLY1305_BLOCK_SIZE * 2)) {
-		if (unlikely(!sctx->uset)) {
-			memcpy(sctx->u, dctx->r, sizeof(sctx->u));
-			poly1305_simd_mult(sctx->u, dctx->r);
-			sctx->uset = true;
-		}
-		blocks = srclen / (POLY1305_BLOCK_SIZE * 2);
-		poly1305_2block_sse2(dctx->h, src, dctx->r, blocks, sctx->u);
-		src += POLY1305_BLOCK_SIZE * 2 * blocks;
-		srclen -= POLY1305_BLOCK_SIZE * 2 * blocks;
-	}
-	if (srclen >= POLY1305_BLOCK_SIZE) {
-		poly1305_block_sse2(dctx->h, src, dctx->r, 1);
-		srclen -= POLY1305_BLOCK_SIZE;
-	}
-	return srclen;
-}
-
-static int poly1305_simd_update(struct shash_desc *desc,
-				const u8 *src, unsigned int srclen)
-{
-	struct poly1305_desc_ctx *dctx = shash_desc_ctx(desc);
-	unsigned int bytes;
-
-	/* kernel_fpu_begin/end is costly, use fallback for small updates */
-	if (srclen <= 288 || !may_use_simd())
-		return crypto_poly1305_update(desc, src, srclen);
-
-	kernel_fpu_begin();
-
-	if (unlikely(dctx->buflen)) {
-		bytes = min(srclen, POLY1305_BLOCK_SIZE - dctx->buflen);
-		memcpy(dctx->buf + dctx->buflen, src, bytes);
-		src += bytes;
-		srclen -= bytes;
-		dctx->buflen += bytes;
-
-		if (dctx->buflen == POLY1305_BLOCK_SIZE) {
-			poly1305_simd_blocks(dctx, dctx->buf,
-					     POLY1305_BLOCK_SIZE);
-			dctx->buflen = 0;
-		}
-	}
-
-	if (likely(srclen >= POLY1305_BLOCK_SIZE)) {
-		bytes = poly1305_simd_blocks(dctx, src, srclen);
-		src += srclen - bytes;
-		srclen = bytes;
-	}
-
-	kernel_fpu_end();
-
-	if (unlikely(srclen)) {
-		dctx->buflen = srclen;
-		memcpy(dctx->buf, src, srclen);
-	}
-
-	return 0;
-}
-
-static struct shash_alg alg = {
-	.digestsize	= POLY1305_DIGEST_SIZE,
-	.init		= poly1305_simd_init,
-	.update		= poly1305_simd_update,
-	.final		= crypto_poly1305_final,
-	.descsize	= sizeof(struct poly1305_simd_desc_ctx),
-	.base		= {
-		.cra_name		= "poly1305",
-		.cra_driver_name	= "poly1305-simd",
-		.cra_priority		= 300,
-		.cra_blocksize		= POLY1305_BLOCK_SIZE,
-		.cra_module		= THIS_MODULE,
-	},
-};
-
-static int __init poly1305_simd_mod_init(void)
-{
-	if (!boot_cpu_has(X86_FEATURE_XMM2))
-		return -ENODEV;
-
-#ifdef CONFIG_AS_AVX2
-	poly1305_use_avx2 = boot_cpu_has(X86_FEATURE_AVX) &&
-			    boot_cpu_has(X86_FEATURE_AVX2) &&
-			    cpu_has_xfeatures(XFEATURE_MASK_SSE | XFEATURE_MASK_YMM, NULL);
-	alg.descsize = sizeof(struct poly1305_simd_desc_ctx);
-	if (poly1305_use_avx2)
-		alg.descsize += 10 * sizeof(u32);
-#endif
-	return crypto_register_shash(&alg);
-}
-
-static void __exit poly1305_simd_mod_exit(void)
-{
-	crypto_unregister_shash(&alg);
-}
-
-module_init(poly1305_simd_mod_init);
-module_exit(poly1305_simd_mod_exit);
-
-MODULE_LICENSE("GPL");
-MODULE_AUTHOR("Martin Willi <martin@strongswan.org>");
-MODULE_DESCRIPTION("Poly1305 authenticator");
-MODULE_ALIAS_CRYPTO("poly1305");
-MODULE_ALIAS_CRYPTO("poly1305-simd");
diff --git a/crypto/Kconfig b/crypto/Kconfig
index f3e40ac56d93..47859a0f8052 100644
--- a/crypto/Kconfig
+++ b/crypto/Kconfig
@@ -656,24 +656,13 @@ config CRYPTO_GHASH
 config CRYPTO_POLY1305
 	tristate "Poly1305 authenticator algorithm"
 	select CRYPTO_HASH
+	select ZINC_POLY1305
 	help
 	  Poly1305 authenticator algorithm, RFC7539.
 
 	  Poly1305 is an authenticator algorithm designed by Daniel J. Bernstein.
 	  It is used for the ChaCha20-Poly1305 AEAD, specified in RFC7539 for use
-	  in IETF protocols. This is the portable C implementation of Poly1305.
-
-config CRYPTO_POLY1305_X86_64
-	tristate "Poly1305 authenticator algorithm (x86_64/SSE2/AVX2)"
-	depends on X86 && 64BIT
-	select CRYPTO_POLY1305
-	help
-	  Poly1305 authenticator algorithm, RFC7539.
-
-	  Poly1305 is an authenticator algorithm designed by Daniel J. Bernstein.
-	  It is used for the ChaCha20-Poly1305 AEAD, specified in RFC7539 for use
-	  in IETF protocols. This is the x86_64 assembler implementation using SIMD
-	  instructions.
+	  in IETF protocols.
 
 config CRYPTO_MD4
 	tristate "MD4 digest algorithm"
diff --git a/crypto/Makefile b/crypto/Makefile
index 6d1d40eeb964..5e60348d02e2 100644
--- a/crypto/Makefile
+++ b/crypto/Makefile
@@ -118,7 +118,7 @@ obj-$(CONFIG_CRYPTO_SEED) += seed.o
 obj-$(CONFIG_CRYPTO_SPECK) += speck.o
 obj-$(CONFIG_CRYPTO_SALSA20) += salsa20_generic.o
 obj-$(CONFIG_CRYPTO_CHACHA20) += chacha20_generic.o
-obj-$(CONFIG_CRYPTO_POLY1305) += poly1305_generic.o
+obj-$(CONFIG_CRYPTO_POLY1305) += poly1305_zinc.o
 obj-$(CONFIG_CRYPTO_DEFLATE) += deflate.o
 obj-$(CONFIG_CRYPTO_MICHAEL_MIC) += michael_mic.o
 obj-$(CONFIG_CRYPTO_CRC32C) += crc32c_generic.o
diff --git a/crypto/chacha20poly1305.c b/crypto/chacha20poly1305.c
index 600afa99941f..bf523797bef3 100644
--- a/crypto/chacha20poly1305.c
+++ b/crypto/chacha20poly1305.c
@@ -14,7 +14,7 @@
 #include <crypto/internal/skcipher.h>
 #include <crypto/scatterwalk.h>
 #include <crypto/chacha20.h>
-#include <crypto/poly1305.h>
+#include <zinc/poly1305.h>
 #include <linux/err.h>
 #include <linux/init.h>
 #include <linux/kernel.h>
@@ -62,7 +62,7 @@ struct chachapoly_req_ctx {
 	/* the key we generate for Poly1305 using Chacha20 */
 	u8 key[POLY1305_KEY_SIZE];
 	/* calculated Poly1305 tag */
-	u8 tag[POLY1305_DIGEST_SIZE];
+	u8 tag[POLY1305_MAC_SIZE];
 	/* length of data to en/decrypt, without ICV */
 	unsigned int cryptlen;
 	/* Actual AD, excluding IV */
@@ -471,7 +471,7 @@ static int chachapoly_decrypt(struct aead_request *req)
 {
 	struct chachapoly_req_ctx *rctx = aead_request_ctx(req);
 
-	rctx->cryptlen = req->cryptlen - POLY1305_DIGEST_SIZE;
+	rctx->cryptlen = req->cryptlen - POLY1305_MAC_SIZE;
 
 	/* decrypt call chain:
 	 * - poly_genkey/done()
@@ -513,7 +513,7 @@ static int chachapoly_setkey(struct crypto_aead *aead, const u8 *key,
 static int chachapoly_setauthsize(struct crypto_aead *tfm,
 				  unsigned int authsize)
 {
-	if (authsize != POLY1305_DIGEST_SIZE)
+	if (authsize != POLY1305_MAC_SIZE)
 		return -EINVAL;
 
 	return 0;
@@ -613,7 +613,7 @@ static int chachapoly_create(struct crypto_template *tmpl, struct rtattr **tb,
 	poly_hash = __crypto_hash_alg_common(poly);
 
 	err = -EINVAL;
-	if (poly_hash->digestsize != POLY1305_DIGEST_SIZE)
+	if (poly_hash->digestsize != POLY1305_MAC_SIZE)
 		goto out_put_poly;
 
 	err = -ENOMEM;
@@ -666,7 +666,7 @@ static int chachapoly_create(struct crypto_template *tmpl, struct rtattr **tb,
 				     ctx->saltlen;
 	inst->alg.ivsize = ivsize;
 	inst->alg.chunksize = crypto_skcipher_alg_chunksize(chacha);
-	inst->alg.maxauthsize = POLY1305_DIGEST_SIZE;
+	inst->alg.maxauthsize = POLY1305_MAC_SIZE;
 	inst->alg.init = chachapoly_init;
 	inst->alg.exit = chachapoly_exit;
 	inst->alg.encrypt = chachapoly_encrypt;
diff --git a/crypto/poly1305_generic.c b/crypto/poly1305_generic.c
deleted file mode 100644
index 47d3a6b83931..000000000000
--- a/crypto/poly1305_generic.c
+++ /dev/null
@@ -1,304 +0,0 @@
-/*
- * Poly1305 authenticator algorithm, RFC7539
- *
- * Copyright (C) 2015 Martin Willi
- *
- * Based on public domain code by Andrew Moon and Daniel J. Bernstein.
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License as published by
- * the Free Software Foundation; either version 2 of the License, or
- * (at your option) any later version.
- */
-
-#include <crypto/algapi.h>
-#include <crypto/internal/hash.h>
-#include <crypto/poly1305.h>
-#include <linux/crypto.h>
-#include <linux/kernel.h>
-#include <linux/module.h>
-#include <asm/unaligned.h>
-
-static inline u64 mlt(u64 a, u64 b)
-{
-	return a * b;
-}
-
-static inline u32 sr(u64 v, u_char n)
-{
-	return v >> n;
-}
-
-static inline u32 and(u32 v, u32 mask)
-{
-	return v & mask;
-}
-
-int crypto_poly1305_init(struct shash_desc *desc)
-{
-	struct poly1305_desc_ctx *dctx = shash_desc_ctx(desc);
-
-	memset(dctx->h, 0, sizeof(dctx->h));
-	dctx->buflen = 0;
-	dctx->rset = false;
-	dctx->sset = false;
-
-	return 0;
-}
-EXPORT_SYMBOL_GPL(crypto_poly1305_init);
-
-static void poly1305_setrkey(struct poly1305_desc_ctx *dctx, const u8 *key)
-{
-	/* r &= 0xffffffc0ffffffc0ffffffc0fffffff */
-	dctx->r[0] = (get_unaligned_le32(key +  0) >> 0) & 0x3ffffff;
-	dctx->r[1] = (get_unaligned_le32(key +  3) >> 2) & 0x3ffff03;
-	dctx->r[2] = (get_unaligned_le32(key +  6) >> 4) & 0x3ffc0ff;
-	dctx->r[3] = (get_unaligned_le32(key +  9) >> 6) & 0x3f03fff;
-	dctx->r[4] = (get_unaligned_le32(key + 12) >> 8) & 0x00fffff;
-}
-
-static void poly1305_setskey(struct poly1305_desc_ctx *dctx, const u8 *key)
-{
-	dctx->s[0] = get_unaligned_le32(key +  0);
-	dctx->s[1] = get_unaligned_le32(key +  4);
-	dctx->s[2] = get_unaligned_le32(key +  8);
-	dctx->s[3] = get_unaligned_le32(key + 12);
-}
-
-/*
- * Poly1305 requires a unique key for each tag, which implies that we can't set
- * it on the tfm that gets accessed by multiple users simultaneously. Instead we
- * expect the key as the first 32 bytes in the update() call.
- */
-unsigned int crypto_poly1305_setdesckey(struct poly1305_desc_ctx *dctx,
-					const u8 *src, unsigned int srclen)
-{
-	if (!dctx->sset) {
-		if (!dctx->rset && srclen >= POLY1305_BLOCK_SIZE) {
-			poly1305_setrkey(dctx, src);
-			src += POLY1305_BLOCK_SIZE;
-			srclen -= POLY1305_BLOCK_SIZE;
-			dctx->rset = true;
-		}
-		if (srclen >= POLY1305_BLOCK_SIZE) {
-			poly1305_setskey(dctx, src);
-			src += POLY1305_BLOCK_SIZE;
-			srclen -= POLY1305_BLOCK_SIZE;
-			dctx->sset = true;
-		}
-	}
-	return srclen;
-}
-EXPORT_SYMBOL_GPL(crypto_poly1305_setdesckey);
-
-static unsigned int poly1305_blocks(struct poly1305_desc_ctx *dctx,
-				    const u8 *src, unsigned int srclen,
-				    u32 hibit)
-{
-	u32 r0, r1, r2, r3, r4;
-	u32 s1, s2, s3, s4;
-	u32 h0, h1, h2, h3, h4;
-	u64 d0, d1, d2, d3, d4;
-	unsigned int datalen;
-
-	if (unlikely(!dctx->sset)) {
-		datalen = crypto_poly1305_setdesckey(dctx, src, srclen);
-		src += srclen - datalen;
-		srclen = datalen;
-	}
-
-	r0 = dctx->r[0];
-	r1 = dctx->r[1];
-	r2 = dctx->r[2];
-	r3 = dctx->r[3];
-	r4 = dctx->r[4];
-
-	s1 = r1 * 5;
-	s2 = r2 * 5;
-	s3 = r3 * 5;
-	s4 = r4 * 5;
-
-	h0 = dctx->h[0];
-	h1 = dctx->h[1];
-	h2 = dctx->h[2];
-	h3 = dctx->h[3];
-	h4 = dctx->h[4];
-
-	while (likely(srclen >= POLY1305_BLOCK_SIZE)) {
-
-		/* h += m[i] */
-		h0 += (get_unaligned_le32(src +  0) >> 0) & 0x3ffffff;
-		h1 += (get_unaligned_le32(src +  3) >> 2) & 0x3ffffff;
-		h2 += (get_unaligned_le32(src +  6) >> 4) & 0x3ffffff;
-		h3 += (get_unaligned_le32(src +  9) >> 6) & 0x3ffffff;
-		h4 += (get_unaligned_le32(src + 12) >> 8) | hibit;
-
-		/* h *= r */
-		d0 = mlt(h0, r0) + mlt(h1, s4) + mlt(h2, s3) +
-		     mlt(h3, s2) + mlt(h4, s1);
-		d1 = mlt(h0, r1) + mlt(h1, r0) + mlt(h2, s4) +
-		     mlt(h3, s3) + mlt(h4, s2);
-		d2 = mlt(h0, r2) + mlt(h1, r1) + mlt(h2, r0) +
-		     mlt(h3, s4) + mlt(h4, s3);
-		d3 = mlt(h0, r3) + mlt(h1, r2) + mlt(h2, r1) +
-		     mlt(h3, r0) + mlt(h4, s4);
-		d4 = mlt(h0, r4) + mlt(h1, r3) + mlt(h2, r2) +
-		     mlt(h3, r1) + mlt(h4, r0);
-
-		/* (partial) h %= p */
-		d1 += sr(d0, 26);     h0 = and(d0, 0x3ffffff);
-		d2 += sr(d1, 26);     h1 = and(d1, 0x3ffffff);
-		d3 += sr(d2, 26);     h2 = and(d2, 0x3ffffff);
-		d4 += sr(d3, 26);     h3 = and(d3, 0x3ffffff);
-		h0 += sr(d4, 26) * 5; h4 = and(d4, 0x3ffffff);
-		h1 += h0 >> 26;       h0 = h0 & 0x3ffffff;
-
-		src += POLY1305_BLOCK_SIZE;
-		srclen -= POLY1305_BLOCK_SIZE;
-	}
-
-	dctx->h[0] = h0;
-	dctx->h[1] = h1;
-	dctx->h[2] = h2;
-	dctx->h[3] = h3;
-	dctx->h[4] = h4;
-
-	return srclen;
-}
-
-int crypto_poly1305_update(struct shash_desc *desc,
-			   const u8 *src, unsigned int srclen)
-{
-	struct poly1305_desc_ctx *dctx = shash_desc_ctx(desc);
-	unsigned int bytes;
-
-	if (unlikely(dctx->buflen)) {
-		bytes = min(srclen, POLY1305_BLOCK_SIZE - dctx->buflen);
-		memcpy(dctx->buf + dctx->buflen, src, bytes);
-		src += bytes;
-		srclen -= bytes;
-		dctx->buflen += bytes;
-
-		if (dctx->buflen == POLY1305_BLOCK_SIZE) {
-			poly1305_blocks(dctx, dctx->buf,
-					POLY1305_BLOCK_SIZE, 1 << 24);
-			dctx->buflen = 0;
-		}
-	}
-
-	if (likely(srclen >= POLY1305_BLOCK_SIZE)) {
-		bytes = poly1305_blocks(dctx, src, srclen, 1 << 24);
-		src += srclen - bytes;
-		srclen = bytes;
-	}
-
-	if (unlikely(srclen)) {
-		dctx->buflen = srclen;
-		memcpy(dctx->buf, src, srclen);
-	}
-
-	return 0;
-}
-EXPORT_SYMBOL_GPL(crypto_poly1305_update);
-
-int crypto_poly1305_final(struct shash_desc *desc, u8 *dst)
-{
-	struct poly1305_desc_ctx *dctx = shash_desc_ctx(desc);
-	u32 h0, h1, h2, h3, h4;
-	u32 g0, g1, g2, g3, g4;
-	u32 mask;
-	u64 f = 0;
-
-	if (unlikely(!dctx->sset))
-		return -ENOKEY;
-
-	if (unlikely(dctx->buflen)) {
-		dctx->buf[dctx->buflen++] = 1;
-		memset(dctx->buf + dctx->buflen, 0,
-		       POLY1305_BLOCK_SIZE - dctx->buflen);
-		poly1305_blocks(dctx, dctx->buf, POLY1305_BLOCK_SIZE, 0);
-	}
-
-	/* fully carry h */
-	h0 = dctx->h[0];
-	h1 = dctx->h[1];
-	h2 = dctx->h[2];
-	h3 = dctx->h[3];
-	h4 = dctx->h[4];
-
-	h2 += (h1 >> 26);     h1 = h1 & 0x3ffffff;
-	h3 += (h2 >> 26);     h2 = h2 & 0x3ffffff;
-	h4 += (h3 >> 26);     h3 = h3 & 0x3ffffff;
-	h0 += (h4 >> 26) * 5; h4 = h4 & 0x3ffffff;
-	h1 += (h0 >> 26);     h0 = h0 & 0x3ffffff;
-
-	/* compute h + -p */
-	g0 = h0 + 5;
-	g1 = h1 + (g0 >> 26);             g0 &= 0x3ffffff;
-	g2 = h2 + (g1 >> 26);             g1 &= 0x3ffffff;
-	g3 = h3 + (g2 >> 26);             g2 &= 0x3ffffff;
-	g4 = h4 + (g3 >> 26) - (1 << 26); g3 &= 0x3ffffff;
-
-	/* select h if h < p, or h + -p if h >= p */
-	mask = (g4 >> ((sizeof(u32) * 8) - 1)) - 1;
-	g0 &= mask;
-	g1 &= mask;
-	g2 &= mask;
-	g3 &= mask;
-	g4 &= mask;
-	mask = ~mask;
-	h0 = (h0 & mask) | g0;
-	h1 = (h1 & mask) | g1;
-	h2 = (h2 & mask) | g2;
-	h3 = (h3 & mask) | g3;
-	h4 = (h4 & mask) | g4;
-
-	/* h = h % (2^128) */
-	h0 = (h0 >>  0) | (h1 << 26);
-	h1 = (h1 >>  6) | (h2 << 20);
-	h2 = (h2 >> 12) | (h3 << 14);
-	h3 = (h3 >> 18) | (h4 <<  8);
-
-	/* mac = (h + s) % (2^128) */
-	f = (f >> 32) + h0 + dctx->s[0]; put_unaligned_le32(f, dst +  0);
-	f = (f >> 32) + h1 + dctx->s[1]; put_unaligned_le32(f, dst +  4);
-	f = (f >> 32) + h2 + dctx->s[2]; put_unaligned_le32(f, dst +  8);
-	f = (f >> 32) + h3 + dctx->s[3]; put_unaligned_le32(f, dst + 12);
-
-	return 0;
-}
-EXPORT_SYMBOL_GPL(crypto_poly1305_final);
-
-static struct shash_alg poly1305_alg = {
-	.digestsize	= POLY1305_DIGEST_SIZE,
-	.init		= crypto_poly1305_init,
-	.update		= crypto_poly1305_update,
-	.final		= crypto_poly1305_final,
-	.descsize	= sizeof(struct poly1305_desc_ctx),
-	.base		= {
-		.cra_name		= "poly1305",
-		.cra_driver_name	= "poly1305-generic",
-		.cra_priority		= 100,
-		.cra_blocksize		= POLY1305_BLOCK_SIZE,
-		.cra_module		= THIS_MODULE,
-	},
-};
-
-static int __init poly1305_mod_init(void)
-{
-	return crypto_register_shash(&poly1305_alg);
-}
-
-static void __exit poly1305_mod_exit(void)
-{
-	crypto_unregister_shash(&poly1305_alg);
-}
-
-module_init(poly1305_mod_init);
-module_exit(poly1305_mod_exit);
-
-MODULE_LICENSE("GPL");
-MODULE_AUTHOR("Martin Willi <martin@strongswan.org>");
-MODULE_DESCRIPTION("Poly1305 authenticator");
-MODULE_ALIAS_CRYPTO("poly1305");
-MODULE_ALIAS_CRYPTO("poly1305-generic");
diff --git a/crypto/poly1305_zinc.c b/crypto/poly1305_zinc.c
new file mode 100644
index 000000000000..4794442edf26
--- /dev/null
+++ b/crypto/poly1305_zinc.c
@@ -0,0 +1,98 @@
+/* SPDX-License-Identifier: GPL-2.0
+ *
+ * Copyright (C) 2018 Jason A. Donenfeld <Jason@zx2c4.com>. All Rights Reserved.
+ */
+
+#include <crypto/algapi.h>
+#include <crypto/internal/hash.h>
+#include <zinc/poly1305.h>
+#include <linux/crypto.h>
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/simd.h>
+
+struct poly1305_desc_ctx {
+	struct poly1305_ctx ctx;
+	u8 key[POLY1305_KEY_SIZE];
+	unsigned int rem_key_bytes;
+};
+
+static int crypto_poly1305_init(struct shash_desc *desc)
+{
+	struct poly1305_desc_ctx *dctx = shash_desc_ctx(desc);
+	dctx->rem_key_bytes = POLY1305_KEY_SIZE;
+	return 0;
+}
+
+static int crypto_poly1305_update(struct shash_desc *desc, const u8 *src,
+				  unsigned int srclen)
+{
+	struct poly1305_desc_ctx *dctx = shash_desc_ctx(desc);
+	simd_context_t simd_context;
+
+	if (unlikely(dctx->rem_key_bytes)) {
+		unsigned int key_bytes = min(srclen, dctx->rem_key_bytes);
+		memcpy(dctx->key + (POLY1305_KEY_SIZE - dctx->rem_key_bytes),
+		       src, key_bytes);
+		src += key_bytes;
+		srclen -= key_bytes;
+		dctx->rem_key_bytes -= key_bytes;
+		if (!dctx->rem_key_bytes) {
+			poly1305_init(&dctx->ctx, dctx->key);
+			memzero_explicit(dctx->key, sizeof(dctx->key));
+		}
+		if (!srclen)
+			return 0;
+	}
+
+	simd_get(&simd_context);
+	poly1305_update(&dctx->ctx, src, srclen, &simd_context);
+	simd_put(&simd_context);
+
+	return 0;
+}
+
+static int crypto_poly1305_final(struct shash_desc *desc, u8 *dst)
+{
+	struct poly1305_desc_ctx *dctx = shash_desc_ctx(desc);
+	simd_context_t simd_context;
+
+	simd_get(&simd_context);
+	poly1305_final(&dctx->ctx, dst, &simd_context);
+	simd_put(&simd_context);
+	return 0;
+}
+
+static struct shash_alg poly1305_alg = {
+	.digestsize	= POLY1305_MAC_SIZE,
+	.init		= crypto_poly1305_init,
+	.update		= crypto_poly1305_update,
+	.final		= crypto_poly1305_final,
+	.descsize	= sizeof(struct poly1305_desc_ctx),
+	.base		= {
+		.cra_name		= "poly1305",
+		.cra_driver_name	= "poly1305-software",
+		.cra_priority		= 100,
+		.cra_blocksize		= POLY1305_BLOCK_SIZE,
+		.cra_module		= THIS_MODULE,
+	},
+};
+
+static int __init poly1305_mod_init(void)
+{
+	return crypto_register_shash(&poly1305_alg);
+}
+
+static void __exit poly1305_mod_exit(void)
+{
+	crypto_unregister_shash(&poly1305_alg);
+}
+
+module_init(poly1305_mod_init);
+module_exit(poly1305_mod_exit);
+
+MODULE_LICENSE("GPL");
+MODULE_AUTHOR("Jason A. Donenfeld <Jason@zx2c4.com>");
+MODULE_DESCRIPTION("Poly1305 authenticator");
+MODULE_ALIAS_CRYPTO("poly1305");
+MODULE_ALIAS_CRYPTO("poly1305-software");
diff --git a/include/crypto/poly1305.h b/include/crypto/poly1305.h
deleted file mode 100644
index f718a19da82f..000000000000
--- a/include/crypto/poly1305.h
+++ /dev/null
@@ -1,40 +0,0 @@
-/* SPDX-License-Identifier: GPL-2.0 */
-/*
- * Common values for the Poly1305 algorithm
- */
-
-#ifndef _CRYPTO_POLY1305_H
-#define _CRYPTO_POLY1305_H
-
-#include <linux/types.h>
-#include <linux/crypto.h>
-
-#define POLY1305_BLOCK_SIZE	16
-#define POLY1305_KEY_SIZE	32
-#define POLY1305_DIGEST_SIZE	16
-
-struct poly1305_desc_ctx {
-	/* key */
-	u32 r[5];
-	/* finalize key */
-	u32 s[4];
-	/* accumulator */
-	u32 h[5];
-	/* partial buffer */
-	u8 buf[POLY1305_BLOCK_SIZE];
-	/* bytes used in partial buffer */
-	unsigned int buflen;
-	/* r key has been set */
-	bool rset;
-	/* s key has been set */
-	bool sset;
-};
-
-int crypto_poly1305_init(struct shash_desc *desc);
-unsigned int crypto_poly1305_setdesckey(struct poly1305_desc_ctx *dctx,
-					const u8 *src, unsigned int srclen);
-int crypto_poly1305_update(struct shash_desc *desc,
-			   const u8 *src, unsigned int srclen);
-int crypto_poly1305_final(struct shash_desc *desc, u8 *dst);
-
-#endif
-- 
2.19.0

From: Martin Willi <martin@strongswan.org>
Subject: [PATCH 10/10] crypto: poly1305 - Add a four block AVX2 variant for x86_64
Date: Tue,  7 Jul 2015 21:36:56 +0200
Message-ID: <1436297816-16414-11-git-send-email-martin@strongswan.org>
References: <1436297816-16414-1-git-send-email-martin@strongswan.org>
Cc: x86@kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>,
	linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from revosec.ch ([5.148.177.19]:44667 "EHLO revosec.ch"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933254AbbGGThY (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Tue, 7 Jul 2015 15:37:24 -0400
In-Reply-To: <1436297816-16414-1-git-send-email-martin@strongswan.org>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Extends the x86_64 Poly1305 authenticator by a function processing four
consecutive Poly1305 blocks in parallel using AVX2 instructions.

For large messages, throughput increases by ~15-45% compared to two
block SSE2:

testing speed of poly1305 (poly1305-simd)
test  0 (   96 byte blocks,   16 bytes per update,   6 updates): 3623907 opers/sec,  347895072 bytes/sec
test  1 (   96 byte blocks,   32 bytes per update,   3 updates): 5915244 opers/sec,  567863424 bytes/sec
test  2 (   96 byte blocks,   96 bytes per update,   1 updates): 9489525 opers/sec,  910994400 bytes/sec
test  3 (  288 byte blocks,   16 bytes per update,  18 updates): 1369657 opers/sec,  394461216 bytes/sec
test  4 (  288 byte blocks,   32 bytes per update,   9 updates): 2016000 opers/sec,  580608000 bytes/sec
test  5 (  288 byte blocks,  288 bytes per update,   1 updates): 3716146 opers/sec, 1070250048 bytes/sec
test  6 ( 1056 byte blocks,   32 bytes per update,  33 updates):  561913 opers/sec,  593380128 bytes/sec
test  7 ( 1056 byte blocks, 1056 bytes per update,   1 updates): 1635554 opers/sec, 1727145024 bytes/sec
test  8 ( 2080 byte blocks,   32 bytes per update,  65 updates):  286540 opers/sec,  596003200 bytes/sec
test  9 ( 2080 byte blocks, 2080 bytes per update,   1 updates):  935339 opers/sec, 1945505120 bytes/sec
test 10 ( 4128 byte blocks, 4128 bytes per update,   1 updates):  491810 opers/sec, 2030191680 bytes/sec
test 11 ( 8224 byte blocks, 8224 bytes per update,   1 updates):  252857 opers/sec, 2079495968 bytes/sec

testing speed of poly1305 (poly1305-simd)
test  0 (   96 byte blocks,   16 bytes per update,   6 updates): 3572538 opers/sec,  342963648 bytes/sec
test  1 (   96 byte blocks,   32 bytes per update,   3 updates): 5868291 opers/sec,  563355936 bytes/sec
test  2 (   96 byte blocks,   96 bytes per update,   1 updates): 9448599 opers/sec,  907065504 bytes/sec
test  3 (  288 byte blocks,   16 bytes per update,  18 updates): 1352271 opers/sec,  389454048 bytes/sec
test  4 (  288 byte blocks,   32 bytes per update,   9 updates): 1993268 opers/sec,  574061184 bytes/sec
test  5 (  288 byte blocks,  288 bytes per update,   1 updates): 3693984 opers/sec, 1063867392 bytes/sec
test  6 ( 1056 byte blocks,   32 bytes per update,  33 updates):  555095 opers/sec,  586180320 bytes/sec
test  7 ( 1056 byte blocks, 1056 bytes per update,   1 updates): 1909861 opers/sec, 2016813216 bytes/sec
test  8 ( 2080 byte blocks,   32 bytes per update,  65 updates):  282260 opers/sec,  587100800 bytes/sec
test  9 ( 2080 byte blocks, 2080 bytes per update,   1 updates): 1221476 opers/sec, 2540670080 bytes/sec
test 10 ( 4128 byte blocks, 4128 bytes per update,   1 updates):  677578 opers/sec, 2797041984 bytes/sec
test 11 ( 8224 byte blocks, 8224 bytes per update,   1 updates):  364094 opers/sec, 2994309056 bytes/sec

Benchmark results from a Core i5-4670T.

Signed-off-by: Martin Willi <martin@strongswan.org>
---
 arch/x86/crypto/Makefile               |   1 +
 arch/x86/crypto/poly1305-avx2-x86_64.S | 386 +++++++++++++++++++++++++++++++++
 arch/x86/crypto/poly1305_glue.c        |  40 ++++
 crypto/Kconfig                         |   2 +-
 4 files changed, 428 insertions(+), 1 deletion(-)
 create mode 100644 arch/x86/crypto/poly1305-avx2-x86_64.S

diff --git a/arch/x86/crypto/Makefile b/arch/x86/crypto/Makefile
index 5cf405c..9a2838c 100644
--- a/arch/x86/crypto/Makefile
+++ b/arch/x86/crypto/Makefile
@@ -89,6 +89,7 @@ sha1-ssse3-y := sha1_ssse3_asm.o sha1_ssse3_glue.o
 poly1305-x86_64-y := poly1305-sse2-x86_64.o poly1305_glue.o
 ifeq ($(avx2_supported),yes)
 sha1-ssse3-y += sha1_avx2_x86_64_asm.o
+poly1305-x86_64-y += poly1305-avx2-x86_64.o
 endif
 crc32c-intel-y := crc32c-intel_glue.o
 crc32c-intel-$(CONFIG_64BIT) += crc32c-pcl-intel-asm_64.o
diff --git a/arch/x86/crypto/poly1305-avx2-x86_64.S b/arch/x86/crypto/poly1305-avx2-x86_64.S
new file mode 100644
index 0000000..eff2f41
--- /dev/null
+++ b/arch/x86/crypto/poly1305-avx2-x86_64.S
@@ -0,0 +1,386 @@
+/*
+ * Poly1305 authenticator algorithm, RFC7539, x64 AVX2 functions
+ *
+ * Copyright (C) 2015 Martin Willi
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ */
+
+#include <linux/linkage.h>
+
+.data
+.align 32
+
+ANMASK:	.octa 0x0000000003ffffff0000000003ffffff
+	.octa 0x0000000003ffffff0000000003ffffff
+ORMASK:	.octa 0x00000000010000000000000001000000
+	.octa 0x00000000010000000000000001000000
+
+.text
+
+#define h0 0x00(%rdi)
+#define h1 0x04(%rdi)
+#define h2 0x08(%rdi)
+#define h3 0x0c(%rdi)
+#define h4 0x10(%rdi)
+#define r0 0x00(%rdx)
+#define r1 0x04(%rdx)
+#define r2 0x08(%rdx)
+#define r3 0x0c(%rdx)
+#define r4 0x10(%rdx)
+#define u0 0x00(%r8)
+#define u1 0x04(%r8)
+#define u2 0x08(%r8)
+#define u3 0x0c(%r8)
+#define u4 0x10(%r8)
+#define w0 0x14(%r8)
+#define w1 0x18(%r8)
+#define w2 0x1c(%r8)
+#define w3 0x20(%r8)
+#define w4 0x24(%r8)
+#define y0 0x28(%r8)
+#define y1 0x2c(%r8)
+#define y2 0x30(%r8)
+#define y3 0x34(%r8)
+#define y4 0x38(%r8)
+#define m %rsi
+#define hc0 %ymm0
+#define hc1 %ymm1
+#define hc2 %ymm2
+#define hc3 %ymm3
+#define hc4 %ymm4
+#define hc0x %xmm0
+#define hc1x %xmm1
+#define hc2x %xmm2
+#define hc3x %xmm3
+#define hc4x %xmm4
+#define t1 %ymm5
+#define t2 %ymm6
+#define t1x %xmm5
+#define t2x %xmm6
+#define ruwy0 %ymm7
+#define ruwy1 %ymm8
+#define ruwy2 %ymm9
+#define ruwy3 %ymm10
+#define ruwy4 %ymm11
+#define ruwy0x %xmm7
+#define ruwy1x %xmm8
+#define ruwy2x %xmm9
+#define ruwy3x %xmm10
+#define ruwy4x %xmm11
+#define svxz1 %ymm12
+#define svxz2 %ymm13
+#define svxz3 %ymm14
+#define svxz4 %ymm15
+#define d0 %r9
+#define d1 %r10
+#define d2 %r11
+#define d3 %r12
+#define d4 %r13
+
+ENTRY(poly1305_4block_avx2)
+	# %rdi: Accumulator h[5]
+	# %rsi: 64 byte input block m
+	# %rdx: Poly1305 key r[5]
+	# %rcx: Quadblock count
+	# %r8:  Poly1305 derived key r^2 u[5], r^3 w[5], r^4 y[5],
+
+	# This four-block variant uses loop unrolled block processing. It
+	# requires 4 Poly1305 keys: r, r^2, r^3 and r^4:
+	# h = (h + m) * r  =>  h = (h + m1) * r^4 + m2 * r^3 + m3 * r^2 + m4 * r
+
+	vzeroupper
+	push		%rbx
+	push		%r12
+	push		%r13
+
+	# combine r0,u0,w0,y0
+	vmovd		y0,ruwy0x
+	vmovd		w0,t1x
+	vpunpcklqdq	t1,ruwy0,ruwy0
+	vmovd		u0,t1x
+	vmovd		r0,t2x
+	vpunpcklqdq	t2,t1,t1
+	vperm2i128	$0x20,t1,ruwy0,ruwy0
+
+	# combine r1,u1,w1,y1 and s1=r1*5,v1=u1*5,x1=w1*5,z1=y1*5
+	vmovd		y1,ruwy1x
+	vmovd		w1,t1x
+	vpunpcklqdq	t1,ruwy1,ruwy1
+	vmovd		u1,t1x
+	vmovd		r1,t2x
+	vpunpcklqdq	t2,t1,t1
+	vperm2i128	$0x20,t1,ruwy1,ruwy1
+	vpslld		$2,ruwy1,svxz1
+	vpaddd		ruwy1,svxz1,svxz1
+
+	# combine r2,u2,w2,y2 and s2=r2*5,v2=u2*5,x2=w2*5,z2=y2*5
+	vmovd		y2,ruwy2x
+	vmovd		w2,t1x
+	vpunpcklqdq	t1,ruwy2,ruwy2
+	vmovd		u2,t1x
+	vmovd		r2,t2x
+	vpunpcklqdq	t2,t1,t1
+	vperm2i128	$0x20,t1,ruwy2,ruwy2
+	vpslld		$2,ruwy2,svxz2
+	vpaddd		ruwy2,svxz2,svxz2
+
+	# combine r3,u3,w3,y3 and s3=r3*5,v3=u3*5,x3=w3*5,z3=y3*5
+	vmovd		y3,ruwy3x
+	vmovd		w3,t1x
+	vpunpcklqdq	t1,ruwy3,ruwy3
+	vmovd		u3,t1x
+	vmovd		r3,t2x
+	vpunpcklqdq	t2,t1,t1
+	vperm2i128	$0x20,t1,ruwy3,ruwy3
+	vpslld		$2,ruwy3,svxz3
+	vpaddd		ruwy3,svxz3,svxz3
+
+	# combine r4,u4,w4,y4 and s4=r4*5,v4=u4*5,x4=w4*5,z4=y4*5
+	vmovd		y4,ruwy4x
+	vmovd		w4,t1x
+	vpunpcklqdq	t1,ruwy4,ruwy4
+	vmovd		u4,t1x
+	vmovd		r4,t2x
+	vpunpcklqdq	t2,t1,t1
+	vperm2i128	$0x20,t1,ruwy4,ruwy4
+	vpslld		$2,ruwy4,svxz4
+	vpaddd		ruwy4,svxz4,svxz4
+
+.Ldoblock4:
+	# hc0 = [m[48-51] & 0x3ffffff, m[32-35] & 0x3ffffff,
+	#	 m[16-19] & 0x3ffffff, m[ 0- 3] & 0x3ffffff + h0]
+	vmovd		0x00(m),hc0x
+	vmovd		0x10(m),t1x
+	vpunpcklqdq	t1,hc0,hc0
+	vmovd		0x20(m),t1x
+	vmovd		0x30(m),t2x
+	vpunpcklqdq	t2,t1,t1
+	vperm2i128	$0x20,t1,hc0,hc0
+	vpand		ANMASK(%rip),hc0,hc0
+	vmovd		h0,t1x
+	vpaddd		t1,hc0,hc0
+	# hc1 = [(m[51-54] >> 2) & 0x3ffffff, (m[35-38] >> 2) & 0x3ffffff,
+	#	 (m[19-22] >> 2) & 0x3ffffff, (m[ 3- 6] >> 2) & 0x3ffffff + h1]
+	vmovd		0x03(m),hc1x
+	vmovd		0x13(m),t1x
+	vpunpcklqdq	t1,hc1,hc1
+	vmovd		0x23(m),t1x
+	vmovd		0x33(m),t2x
+	vpunpcklqdq	t2,t1,t1
+	vperm2i128	$0x20,t1,hc1,hc1
+	vpsrld		$2,hc1,hc1
+	vpand		ANMASK(%rip),hc1,hc1
+	vmovd		h1,t1x
+	vpaddd		t1,hc1,hc1
+	# hc2 = [(m[54-57] >> 4) & 0x3ffffff, (m[38-41] >> 4) & 0x3ffffff,
+	#	 (m[22-25] >> 4) & 0x3ffffff, (m[ 6- 9] >> 4) & 0x3ffffff + h2]
+	vmovd		0x06(m),hc2x
+	vmovd		0x16(m),t1x
+	vpunpcklqdq	t1,hc2,hc2
+	vmovd		0x26(m),t1x
+	vmovd		0x36(m),t2x
+	vpunpcklqdq	t2,t1,t1
+	vperm2i128	$0x20,t1,hc2,hc2
+	vpsrld		$4,hc2,hc2
+	vpand		ANMASK(%rip),hc2,hc2
+	vmovd		h2,t1x
+	vpaddd		t1,hc2,hc2
+	# hc3 = [(m[57-60] >> 6) & 0x3ffffff, (m[41-44] >> 6) & 0x3ffffff,
+	#	 (m[25-28] >> 6) & 0x3ffffff, (m[ 9-12] >> 6) & 0x3ffffff + h3]
+	vmovd		0x09(m),hc3x
+	vmovd		0x19(m),t1x
+	vpunpcklqdq	t1,hc3,hc3
+	vmovd		0x29(m),t1x
+	vmovd		0x39(m),t2x
+	vpunpcklqdq	t2,t1,t1
+	vperm2i128	$0x20,t1,hc3,hc3
+	vpsrld		$6,hc3,hc3
+	vpand		ANMASK(%rip),hc3,hc3
+	vmovd		h3,t1x
+	vpaddd		t1,hc3,hc3
+	# hc4 = [(m[60-63] >> 8) | (1<<24), (m[44-47] >> 8) | (1<<24),
+	#	 (m[28-31] >> 8) | (1<<24), (m[12-15] >> 8) | (1<<24) + h4]
+	vmovd		0x0c(m),hc4x
+	vmovd		0x1c(m),t1x
+	vpunpcklqdq	t1,hc4,hc4
+	vmovd		0x2c(m),t1x
+	vmovd		0x3c(m),t2x
+	vpunpcklqdq	t2,t1,t1
+	vperm2i128	$0x20,t1,hc4,hc4
+	vpsrld		$8,hc4,hc4
+	vpor		ORMASK(%rip),hc4,hc4
+	vmovd		h4,t1x
+	vpaddd		t1,hc4,hc4
+
+	# t1 = [ hc0[3] * r0, hc0[2] * u0, hc0[1] * w0, hc0[0] * y0 ]
+	vpmuludq	hc0,ruwy0,t1
+	# t1 += [ hc1[3] * s4, hc1[2] * v4, hc1[1] * x4, hc1[0] * z4 ]
+	vpmuludq	hc1,svxz4,t2
+	vpaddq		t2,t1,t1
+	# t1 += [ hc2[3] * s3, hc2[2] * v3, hc2[1] * x3, hc2[0] * z3 ]
+	vpmuludq	hc2,svxz3,t2
+	vpaddq		t2,t1,t1
+	# t1 += [ hc3[3] * s2, hc3[2] * v2, hc3[1] * x2, hc3[0] * z2 ]
+	vpmuludq	hc3,svxz2,t2
+	vpaddq		t2,t1,t1
+	# t1 += [ hc4[3] * s1, hc4[2] * v1, hc4[1] * x1, hc4[0] * z1 ]
+	vpmuludq	hc4,svxz1,t2
+	vpaddq		t2,t1,t1
+	# d0 = t1[0] + t1[1] + t[2] + t[3]
+	vpermq		$0xee,t1,t2
+	vpaddq		t2,t1,t1
+	vpsrldq		$8,t1,t2
+	vpaddq		t2,t1,t1
+	vmovq		t1x,d0
+
+	# t1 = [ hc0[3] * r1, hc0[2] * u1,hc0[1] * w1, hc0[0] * y1 ]
+	vpmuludq	hc0,ruwy1,t1
+	# t1 += [ hc1[3] * r0, hc1[2] * u0, hc1[1] * w0, hc1[0] * y0 ]
+	vpmuludq	hc1,ruwy0,t2
+	vpaddq		t2,t1,t1
+	# t1 += [ hc2[3] * s4, hc2[2] * v4, hc2[1] * x4, hc2[0] * z4 ]
+	vpmuludq	hc2,svxz4,t2
+	vpaddq		t2,t1,t1
+	# t1 += [ hc3[3] * s3, hc3[2] * v3, hc3[1] * x3, hc3[0] * z3 ]
+	vpmuludq	hc3,svxz3,t2
+	vpaddq		t2,t1,t1
+	# t1 += [ hc4[3] * s2, hc4[2] * v2, hc4[1] * x2, hc4[0] * z2 ]
+	vpmuludq	hc4,svxz2,t2
+	vpaddq		t2,t1,t1
+	# d1 = t1[0] + t1[1] + t1[3] + t1[4]
+	vpermq		$0xee,t1,t2
+	vpaddq		t2,t1,t1
+	vpsrldq		$8,t1,t2
+	vpaddq		t2,t1,t1
+	vmovq		t1x,d1
+
+	# t1 = [ hc0[3] * r2, hc0[2] * u2, hc0[1] * w2, hc0[0] * y2 ]
+	vpmuludq	hc0,ruwy2,t1
+	# t1 += [ hc1[3] * r1, hc1[2] * u1, hc1[1] * w1, hc1[0] * y1 ]
+	vpmuludq	hc1,ruwy1,t2
+	vpaddq		t2,t1,t1
+	# t1 += [ hc2[3] * r0, hc2[2] * u0, hc2[1] * w0, hc2[0] * y0 ]
+	vpmuludq	hc2,ruwy0,t2
+	vpaddq		t2,t1,t1
+	# t1 += [ hc3[3] * s4, hc3[2] * v4, hc3[1] * x4, hc3[0] * z4 ]
+	vpmuludq	hc3,svxz4,t2
+	vpaddq		t2,t1,t1
+	# t1 += [ hc4[3] * s3, hc4[2] * v3, hc4[1] * x3, hc4[0] * z3 ]
+	vpmuludq	hc4,svxz3,t2
+	vpaddq		t2,t1,t1
+	# d2 = t1[0] + t1[1] + t1[2] + t1[3]
+	vpermq		$0xee,t1,t2
+	vpaddq		t2,t1,t1
+	vpsrldq		$8,t1,t2
+	vpaddq		t2,t1,t1
+	vmovq		t1x,d2
+
+	# t1 = [ hc0[3] * r3, hc0[2] * u3, hc0[1] * w3, hc0[0] * y3 ]
+	vpmuludq	hc0,ruwy3,t1
+	# t1 += [ hc1[3] * r2, hc1[2] * u2, hc1[1] * w2, hc1[0] * y2 ]
+	vpmuludq	hc1,ruwy2,t2
+	vpaddq		t2,t1,t1
+	# t1 += [ hc2[3] * r1, hc2[2] * u1, hc2[1] * w1, hc2[0] * y1 ]
+	vpmuludq	hc2,ruwy1,t2
+	vpaddq		t2,t1,t1
+	# t1 += [ hc3[3] * r0, hc3[2] * u0, hc3[1] * w0, hc3[0] * y0 ]
+	vpmuludq	hc3,ruwy0,t2
+	vpaddq		t2,t1,t1
+	# t1 += [ hc4[3] * s4, hc4[2] * v4, hc4[1] * x4, hc4[0] * z4 ]
+	vpmuludq	hc4,svxz4,t2
+	vpaddq		t2,t1,t1
+	# d3 = t1[0] + t1[1] + t1[2] + t1[3]
+	vpermq		$0xee,t1,t2
+	vpaddq		t2,t1,t1
+	vpsrldq		$8,t1,t2
+	vpaddq		t2,t1,t1
+	vmovq		t1x,d3
+
+	# t1 = [ hc0[3] * r4, hc0[2] * u4, hc0[1] * w4, hc0[0] * y4 ]
+	vpmuludq	hc0,ruwy4,t1
+	# t1 += [ hc1[3] * r3, hc1[2] * u3, hc1[1] * w3, hc1[0] * y3 ]
+	vpmuludq	hc1,ruwy3,t2
+	vpaddq		t2,t1,t1
+	# t1 += [ hc2[3] * r2, hc2[2] * u2, hc2[1] * w2, hc2[0] * y2 ]
+	vpmuludq	hc2,ruwy2,t2
+	vpaddq		t2,t1,t1
+	# t1 += [ hc3[3] * r1, hc3[2] * u1, hc3[1] * w1, hc3[0] * y1 ]
+	vpmuludq	hc3,ruwy1,t2
+	vpaddq		t2,t1,t1
+	# t1 += [ hc4[3] * r0, hc4[2] * u0, hc4[1] * w0, hc4[0] * y0 ]
+	vpmuludq	hc4,ruwy0,t2
+	vpaddq		t2,t1,t1
+	# d4 = t1[0] + t1[1] + t1[2] + t1[3]
+	vpermq		$0xee,t1,t2
+	vpaddq		t2,t1,t1
+	vpsrldq		$8,t1,t2
+	vpaddq		t2,t1,t1
+	vmovq		t1x,d4
+
+	# d1 += d0 >> 26
+	mov		d0,%rax
+	shr		$26,%rax
+	add		%rax,d1
+	# h0 = d0 & 0x3ffffff
+	mov		d0,%rbx
+	and		$0x3ffffff,%ebx
+
+	# d2 += d1 >> 26
+	mov		d1,%rax
+	shr		$26,%rax
+	add		%rax,d2
+	# h1 = d1 & 0x3ffffff
+	mov		d1,%rax
+	and		$0x3ffffff,%eax
+	mov		%eax,h1
+
+	# d3 += d2 >> 26
+	mov		d2,%rax
+	shr		$26,%rax
+	add		%rax,d3
+	# h2 = d2 & 0x3ffffff
+	mov		d2,%rax
+	and		$0x3ffffff,%eax
+	mov		%eax,h2
+
+	# d4 += d3 >> 26
+	mov		d3,%rax
+	shr		$26,%rax
+	add		%rax,d4
+	# h3 = d3 & 0x3ffffff
+	mov		d3,%rax
+	and		$0x3ffffff,%eax
+	mov		%eax,h3
+
+	# h0 += (d4 >> 26) * 5
+	mov		d4,%rax
+	shr		$26,%rax
+	lea		(%eax,%eax,4),%eax
+	add		%eax,%ebx
+	# h4 = d4 & 0x3ffffff
+	mov		d4,%rax
+	and		$0x3ffffff,%eax
+	mov		%eax,h4
+
+	# h1 += h0 >> 26
+	mov		%ebx,%eax
+	shr		$26,%eax
+	add		%eax,h1
+	# h0 = h0 & 0x3ffffff
+	andl		$0x3ffffff,%ebx
+	mov		%ebx,h0
+
+	add		$0x40,m
+	dec		%rcx
+	jnz		.Ldoblock4
+
+	vzeroupper
+	pop		%r13
+	pop		%r12
+	pop		%rbx
+	ret
+ENDPROC(poly1305_4block_avx2)
diff --git a/arch/x86/crypto/poly1305_glue.c b/arch/x86/crypto/poly1305_glue.c
index b7c33d0..f7170d7 100644
--- a/arch/x86/crypto/poly1305_glue.c
+++ b/arch/x86/crypto/poly1305_glue.c
@@ -22,20 +22,33 @@ struct poly1305_simd_desc_ctx {
 	struct poly1305_desc_ctx base;
 	/* derived key u set? */
 	bool uset;
+#ifdef CONFIG_AS_AVX2
+	/* derived keys r^3, r^4 set? */
+	bool wset;
+#endif
 	/* derived Poly1305 key r^2 */
 	u32 u[5];
+	/* ... silently appended r^3 and r^4 when using AVX2 */
 };
 
 asmlinkage void poly1305_block_sse2(u32 *h, const u8 *src,
 				    const u32 *r, unsigned int blocks);
 asmlinkage void poly1305_2block_sse2(u32 *h, const u8 *src, const u32 *r,
 				     unsigned int blocks, const u32 *u);
+#ifdef CONFIG_AS_AVX2
+asmlinkage void poly1305_4block_avx2(u32 *h, const u8 *src, const u32 *r,
+				     unsigned int blocks, const u32 *u);
+static bool poly1305_use_avx2;
+#endif
 
 static int poly1305_simd_init(struct shash_desc *desc)
 {
 	struct poly1305_simd_desc_ctx *sctx = shash_desc_ctx(desc);
 
 	sctx->uset = false;
+#ifdef CONFIG_AS_AVX2
+	sctx->wset = false;
+#endif
 
 	return crypto_poly1305_init(desc);
 }
@@ -66,6 +79,26 @@ static unsigned int poly1305_simd_blocks(struct poly1305_desc_ctx *dctx,
 		srclen = datalen;
 	}
 
+#ifdef CONFIG_AS_AVX2
+	if (poly1305_use_avx2 && srclen >= POLY1305_BLOCK_SIZE * 4) {
+		if (unlikely(!sctx->wset)) {
+			if (!sctx->uset) {
+				memcpy(sctx->u, dctx->r, sizeof(sctx->u));
+				poly1305_simd_mult(sctx->u, dctx->r);
+				sctx->uset = true;
+			}
+			memcpy(sctx->u + 5, sctx->u, sizeof(sctx->u));
+			poly1305_simd_mult(sctx->u + 5, dctx->r);
+			memcpy(sctx->u + 10, sctx->u + 5, sizeof(sctx->u));
+			poly1305_simd_mult(sctx->u + 10, dctx->r);
+			sctx->wset = true;
+		}
+		blocks = srclen / (POLY1305_BLOCK_SIZE * 4);
+		poly1305_4block_avx2(dctx->h, src, dctx->r, blocks, sctx->u);
+		src += POLY1305_BLOCK_SIZE * 4 * blocks;
+		srclen -= POLY1305_BLOCK_SIZE * 4 * blocks;
+	}
+#endif
 	if (likely(srclen >= POLY1305_BLOCK_SIZE * 2)) {
 		if (unlikely(!sctx->uset)) {
 			memcpy(sctx->u, dctx->r, sizeof(sctx->u));
@@ -149,6 +182,13 @@ static int __init poly1305_simd_mod_init(void)
 	if (!cpu_has_xmm2)
 		return -ENODEV;
 
+#ifdef CONFIG_AS_AVX2
+	poly1305_use_avx2 = cpu_has_avx && cpu_has_avx2 &&
+			    cpu_has_xfeatures(XSTATE_SSE | XSTATE_YMM, NULL);
+	alg.descsize = sizeof(struct poly1305_simd_desc_ctx);
+	if (poly1305_use_avx2)
+		alg.descsize += 10 * sizeof(u32);
+#endif
 	return crypto_register_shash(&alg);
 }
 
diff --git a/crypto/Kconfig b/crypto/Kconfig
index c57478c..354bb69 100644
--- a/crypto/Kconfig
+++ b/crypto/Kconfig
@@ -471,7 +471,7 @@ config CRYPTO_POLY1305
 	  in IETF protocols. This is the portable C implementation of Poly1305.
 
 config CRYPTO_POLY1305_X86_64
-	tristate "Poly1305 authenticator algorithm (x86_64/SSE2)"
+	tristate "Poly1305 authenticator algorithm (x86_64/SSE2/AVX2)"
 	depends on X86 && 64BIT
 	select CRYPTO_POLY1305
 	help
-- 
1.9.1

Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795415178;
	b=Vu6zulmD3TPtDCQcSQ6yni5O8eogZN4N0b4ZeXIPmCoenLlh/yJORHLf085zJ3i00BMz
	 AImjdsMS9blcMCsfXSs0mSI61vVz/j2sC1RkcQOSBNIhAXqZaoO8GGf8rbfDTQB+MJpeS
	 IrCxc/bkdBzylW2lmAHuj0WK0DDeaNeNxyNnq30OJHs6ZL1qlUBQ7CuPtafcy1636/BLo
	 xCWN5bDgPGawcZCCYR+nFaovu4Wwa5ghHqiWfUAYfmC3C7Yh/RCIU3yoFabNpkwbOIibV
	 z8LXEMmvzzCToqBpUrq/vCcBxAJXIw0qrVscgDkJ8CyyKmWNegGpJt7CagjmCznKpiQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795415178;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 MIME-Version:Content-Transfer-Encoding;
	bh=WSr/TPZdutPqpfjLwe6ZabBKa4Y7ZnybNNC7VEqxhoE=;
	b=gvNNrY021uc9IMg99NrGekpklTUu0nTaEOGsvfYIFXXdbNzNSGmIXi8/YYIaWd3N6RXo
	 7iEq3RlAHjZm/ifcMYcq194D34hXSYurrxrER/vJ3uNp8sUNHd8hRJ2JEQ//zTUGPblIs
	 BbQKGhi1vBMCKKABkw28h1bk4o5Llz1iCP5n9gVsJ9DkutxsbJcAf7kLrF8QGionWHTql
	 8umvZuYTJiaBJhjEsV2FqXlI80lL4d0OjDXGfdulboSV5Y/eo1Cp8Lly40hsu+4bc0+Rm
	 0crwfHCfe9EPLK8HYLRoCZ3pJm4zR4RFVq0lx0QTvpeODA9qkUycU/vrKLYKw7ZkjYw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=l89BvGbM;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7491C606A31A
	for <linux-crypto@vger.kernel.org>; Mon, 23 Nov 2026 06:26:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=l89BvGbM
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 629D81F000C4;
	Mon, 23 Nov 2026 06:26:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795415177;
	bh=WSr/TPZdutPqpfjLwe6ZabBKa4Y7ZnybNNC7VEqxhoE=;
	h=From:To:Cc:Subject:Date;
	b=l89BvGbM1hPwRtLpS4iTJdA5GBZvySFV0ZmB+k2k0tXvCoVCtl+NvwFOUzlathm5K
	 18lmYictW/cgc820RPciVeN90iyQJs5jF2bEm4TqPzCmrTyrRxS3TJES8O/3blIZpk
	 A63nVbIcWjl3v1Xmbln7g1sdu/rGBKQuX5PIXn9WUsc1lQ0Ybo2qjqeemJXr/P207T
	 Q7Qcidlc7iJa15Bpu6DbtKiXVftBTFgHtglhflnOtXHNztaLVm29SqpV0p1HStgMdX
	 h4zlZ6YGC0gQKVsxaT98jelgQVMFCXBJgI4u8ThfGeygtT+nfXHnFezYs1cGNsK6tR
	 8AF1NKUcOAZoQ==
From: Eric Biggers <ebiggers@kernel.org>
To: linux-crypto@vger.kernel.org
Cc: Ard Biesheuvel <ardb@kernel.org>,
	"Jason A . Donenfeld" <Jason@zx2c4.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	x86@kernel.org,
	Eric Biggers <ebiggers@kernel.org>
Subject: [PATCH] lib/crypto: x86/sm3: De-bloat sm3-avx-asm_64.S
Date: Sun, 22 Nov 2026 22:25:36 -0800
Message-ID: <20261123062536.154202-1-ebiggers@kernel.org>
X-Mailer: git-send-email 2.56.1
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Post: <mailto:linux-crypto@vger.kernel.org>
List-Help: <mailto:linux-crypto+help@vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-crypto+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

sm3_transform_avx() previously unrolled all 64 rounds, resulting in 9567
bytes of .text and making it currently the second largest object file in
lib/crypto/x86/.  Additionally, all 64 round constants were inlined as
immediates, despite the fact that all round 0-15 constants are rotations
of one value, and all round 16-63 constants are rotations of one value.

Therefore:

  - Roll up rounds 16-63 into 4 iterations, each doing 12 rounds.

    12 is chosen because it's the least common multiple of the 4-round
    rotation period of the scalar state registers and the 6-round
    alternation period of the two XW stack slots.

  - Generate the round constant for each of rounds 1-15 and 17-63 by
    just rotating the previous round constant.

This requires using two GPRs, one for the round constant and one for the
loop counter.  Get them by spilling RDATA and RNBLKS to the stack.  They
are accessed only once per block, so this is fine.

The .text of sm3-avx-asm_64.o shrinks from 9567 bytes to 4281 bytes, a
55% reduction.  Performance is unchanged to within 0.2% on AMD Ryzen 9
9950X (Zen 5), measured using the benchmark in sm3_kunit.

Signed-off-by: Eric Biggers <ebiggers@kernel.org>
---
 lib/crypto/x86/sm3-avx-asm_64.S | 236 ++++++++++----------------------
 1 file changed, 70 insertions(+), 166 deletions(-)

diff --git a/lib/crypto/x86/sm3-avx-asm_64.S b/lib/crypto/x86/sm3-avx-asm_64.S
index a1925b136010..337efc6de685 100644
--- a/lib/crypto/x86/sm3-avx-asm_64.S
+++ b/lib/crypto/x86/sm3-avx-asm_64.S
@@ -25,80 +25,13 @@
 #define state_h6 24
 #define state_h7 28
 
-/* Constants */
-
-/* Round constant macros */
-
-#define K0   2043430169  /* 0x79cc4519 */
-#define K1   -208106958  /* 0xf3988a32 */
-#define K2   -416213915  /* 0xe7311465 */
-#define K3   -832427829  /* 0xce6228cb */
-#define K4  -1664855657  /* 0x9cc45197 */
-#define K5    965255983  /* 0x3988a32f */
-#define K6   1930511966  /* 0x7311465e */
-#define K7   -433943364  /* 0xe6228cbc */
-#define K8   -867886727  /* 0xcc451979 */
-#define K9  -1735773453  /* 0x988a32f3 */
-#define K10   823420391  /* 0x311465e7 */
-#define K11  1646840782  /* 0x6228cbce */
-#define K12 -1001285732  /* 0xc451979c */
-#define K13 -2002571463  /* 0x88a32f39 */
-#define K14   289824371  /* 0x11465e73 */
-#define K15   579648742  /* 0x228cbce6 */
-#define K16 -1651869049  /* 0x9d8a7a87 */
-#define K17   991229199  /* 0x3b14f50f */
-#define K18  1982458398  /* 0x7629ea1e */
-#define K19  -330050500  /* 0xec53d43c */
-#define K20  -660100999  /* 0xd8a7a879 */
-#define K21 -1320201997  /* 0xb14f50f3 */
-#define K22  1654563303  /* 0x629ea1e7 */
-#define K23  -985840690  /* 0xc53d43ce */
-#define K24 -1971681379  /* 0x8a7a879d */
-#define K25   351604539  /* 0x14f50f3b */
-#define K26   703209078  /* 0x29ea1e76 */
-#define K27  1406418156  /* 0x53d43cec */
-#define K28 -1482130984  /* 0xa7a879d8 */
-#define K29  1330705329  /* 0x4f50f3b1 */
-#define K30 -1633556638  /* 0x9ea1e762 */
-#define K31  1027854021  /* 0x3d43cec5 */
-#define K32  2055708042  /* 0x7a879d8a */
-#define K33  -183551212  /* 0xf50f3b14 */
-#define K34  -367102423  /* 0xea1e7629 */
-#define K35  -734204845  /* 0xd43cec53 */
-#define K36 -1468409689  /* 0xa879d8a7 */
-#define K37  1358147919  /* 0x50f3b14f */
-#define K38 -1578671458  /* 0xa1e7629e */
-#define K39  1137624381  /* 0x43cec53d */
-#define K40 -2019718534  /* 0x879d8a7a */
-#define K41   255530229  /* 0x0f3b14f5 */
-#define K42   511060458  /* 0x1e7629ea */
-#define K43  1022120916  /* 0x3cec53d4 */
-#define K44  2044241832  /* 0x79d8a7a8 */
-#define K45  -206483632  /* 0xf3b14f50 */
-#define K46  -412967263  /* 0xe7629ea1 */
-#define K47  -825934525  /* 0xcec53d43 */
-#define K48 -1651869049  /* 0x9d8a7a87 */
-#define K49   991229199  /* 0x3b14f50f */
-#define K50  1982458398  /* 0x7629ea1e */
-#define K51  -330050500  /* 0xec53d43c */
-#define K52  -660100999  /* 0xd8a7a879 */
-#define K53 -1320201997  /* 0xb14f50f3 */
-#define K54  1654563303  /* 0x629ea1e7 */
-#define K55  -985840690  /* 0xc53d43ce */
-#define K56 -1971681379  /* 0x8a7a879d */
-#define K57   351604539  /* 0x14f50f3b */
-#define K58   703209078  /* 0x29ea1e76 */
-#define K59  1406418156  /* 0x53d43cec */
-#define K60 -1482130984  /* 0xa7a879d8 */
-#define K61  1330705329  /* 0x4f50f3b1 */
-#define K62 -1633556638  /* 0x9ea1e762 */
-#define K63  1027854021  /* 0x3d43cec5 */
-
 /* Register macros */
 
 #define RSTATE %rdi
-#define RDATA  %rsi
-#define RNBLKS %rdx
+#define RDATA   %rsi
+#define KREG    %esi /* aliases RDATA across rounds */
+#define RNBLKS  %rdx
+#define RLOOP   %edx /* aliases RNBLKS across rounds 16-63 */
 
 #define t0 %eax
 #define t1 %ebx
@@ -177,20 +110,22 @@
 	andl z, o;		\
 	xorl t, o;
 
-#define R(i, a, b, c, d, e, f, g, h, round, widx, wtype)		\
+#define R(i, a, b, c, d, e, f, g, h, woff, widx)			\
 	/* rol(a, 12) => t0 */						\
 	roll3mov(12, a, t0); /* rorxl here would reduce perf by 6% on zen3 */ \
-	/* rol (t0 + e + t), 7) => t1 */				\
-	leal K##round(t0, e, 1), t1;					\
+	/* rol(t0 + e + K[round], 7) => t1 */				\
+	leal (t0, KREG), t1;						\
+	roll $1, KREG;							\
+	addl e, t1;							\
 	roll2(7, t1);							\
 	/* h + w1 => h */						\
-	addl wtype##_W1_ADDR(round, widx), h;				\
+	addl ((woff) + (widx) * 4)(%rsp), h;				\
 	/* h + t1 => h */						\
 	addl2(t1, h);							\
 	/* t1 ^ t0 => t0 */						\
 	xorl t1, t0;							\
 	/* w1w2 + d => d */						\
-	addl wtype##_W1W2_ADDR(round, widx), d;				\
+	addl ((woff) + 32 + (widx) * 4)(%rsp), d;			\
 	/* FF##i(a,b,c) => t1 */					\
 	FF##i(a, b, c, t1, t2);						\
 	/* d + t1 => d */						\
@@ -211,21 +146,25 @@
 	xorl t2, h;							\
 	xorl t1, h;
 
-#define R1(a, b, c, d, e, f, g, h, round, widx, wtype) \
-	R(1, a, b, c, d, e, f, g, h, round, widx, wtype)
+#define R1(a, b, c, d, e, f, g, h, round, widx, wtype)			\
+	R(1, a, b, c, d, e, f, g, h, wtype##_W1_OFF(round), widx)
 
-#define R2(a, b, c, d, e, f, g, h, round, widx, wtype) \
-	R(2, a, b, c, d, e, f, g, h, round, widx, wtype)
+#define R2(a, b, c, d, e, f, g, h, wslot, widx)				\
+	R(2, a, b, c, d, e, f, g, h, STACK_W + (wslot) * 64, widx)
 
 /* Input expansion macros. */
 
-/* Byte-swapped input address. */
+/* Byte-swapped input offset and address. */
+#define IW_W1_OFF(round) \
+	(STACK_W + ((round) / 4) * 64)
 #define IW_W_ADDR(round, widx, offs) \
-	(STACK_W + ((round) / 4) * 64 + (offs) + ((widx) * 4))(%rsp)
+	(IW_W1_OFF(round) + (offs) + ((widx) * 4))(%rsp)
 
-/* Expanded input address. */
+/* Expanded input offset and address. */
+#define XW_W1_OFF(round) \
+	(STACK_W + ((((round) / 3) - 4) % 2) * 64)
 #define XW_W_ADDR(round, widx, offs) \
-	(STACK_W + ((((round) / 3) - 4) % 2) * 64 + (offs) + ((widx) * 4))(%rsp)
+	(XW_W1_OFF(round) + (offs) + ((widx) * 4))(%rsp)
 
 /* Rounds 1-12, byte-swapped input block addresses. */
 #define IW_W1_ADDR(round, widx)   IW_W_ADDR(round, widx, 0)
@@ -367,6 +306,9 @@ SYM_FUNC_START(sm3_transform_avx)
 	LOAD_W_XMM_1();
 
 	leaq -1(RNBLKS), RNBLKS;
+	movq RNBLKS, (STACK_REG_SAVE + 5 * 8)(%rsp);
+	movq RDATA, (STACK_REG_SAVE + 6 * 8)(%rsp);
+	movl $0x79cc4519, KREG;
 
 	/* Transform 0-3 + Load data part2. */
 	R1(a, b, c, d, e, f, g, h, 0, 0, IW); LOAD_W_XMM_2();
@@ -391,88 +333,50 @@ SYM_FUNC_START(sm3_transform_avx)
 	R1(d, a, b, c, h, e, f, g, 13, 1, XW); SCHED_W_1(18, W2, W3, W4, W5, W0, W1);
 	R1(c, d, a, b, g, h, e, f, 14, 2, XW); SCHED_W_2(18, W2, W3, W4, W5, W0, W1);
 
-	/* Transform 15-17 + Precalc 21-23 */
-	R1(b, c, d, a, f, g, h, e, 15, 0, XW); SCHED_W_0(21, W3, W4, W5, W0, W1, W2);
-	R2(a, b, c, d, e, f, g, h, 16, 1, XW); SCHED_W_1(21, W3, W4, W5, W0, W1, W2);
-	R2(d, a, b, c, h, e, f, g, 17, 2, XW); SCHED_W_2(21, W3, W4, W5, W0, W1, W2);
-
-	/* Transform 18-20 + Precalc 24-26 */
-	R2(c, d, a, b, g, h, e, f, 18, 0, XW); SCHED_W_0(24, W4, W5, W0, W1, W2, W3);
-	R2(b, c, d, a, f, g, h, e, 19, 1, XW); SCHED_W_1(24, W4, W5, W0, W1, W2, W3);
-	R2(a, b, c, d, e, f, g, h, 20, 2, XW); SCHED_W_2(24, W4, W5, W0, W1, W2, W3);
-
-	/* Transform 21-23 + Precalc 27-29 */
-	R2(d, a, b, c, h, e, f, g, 21, 0, XW); SCHED_W_0(27, W5, W0, W1, W2, W3, W4);
-	R2(c, d, a, b, g, h, e, f, 22, 1, XW); SCHED_W_1(27, W5, W0, W1, W2, W3, W4);
-	R2(b, c, d, a, f, g, h, e, 23, 2, XW); SCHED_W_2(27, W5, W0, W1, W2, W3, W4);
-
-	/* Transform 24-26 + Precalc 30-32 */
-	R2(a, b, c, d, e, f, g, h, 24, 0, XW); SCHED_W_0(30, W0, W1, W2, W3, W4, W5);
-	R2(d, a, b, c, h, e, f, g, 25, 1, XW); SCHED_W_1(30, W0, W1, W2, W3, W4, W5);
-	R2(c, d, a, b, g, h, e, f, 26, 2, XW); SCHED_W_2(30, W0, W1, W2, W3, W4, W5);
-
-	/* Transform 27-29 + Precalc 33-35 */
-	R2(b, c, d, a, f, g, h, e, 27, 0, XW); SCHED_W_0(33, W1, W2, W3, W4, W5, W0);
-	R2(a, b, c, d, e, f, g, h, 28, 1, XW); SCHED_W_1(33, W1, W2, W3, W4, W5, W0);
-	R2(d, a, b, c, h, e, f, g, 29, 2, XW); SCHED_W_2(33, W1, W2, W3, W4, W5, W0);
-
-	/* Transform 30-32 + Precalc 36-38 */
-	R2(c, d, a, b, g, h, e, f, 30, 0, XW); SCHED_W_0(36, W2, W3, W4, W5, W0, W1);
-	R2(b, c, d, a, f, g, h, e, 31, 1, XW); SCHED_W_1(36, W2, W3, W4, W5, W0, W1);
-	R2(a, b, c, d, e, f, g, h, 32, 2, XW); SCHED_W_2(36, W2, W3, W4, W5, W0, W1);
-
-	/* Transform 33-35 + Precalc 39-41 */
-	R2(d, a, b, c, h, e, f, g, 33, 0, XW); SCHED_W_0(39, W3, W4, W5, W0, W1, W2);
-	R2(c, d, a, b, g, h, e, f, 34, 1, XW); SCHED_W_1(39, W3, W4, W5, W0, W1, W2);
-	R2(b, c, d, a, f, g, h, e, 35, 2, XW); SCHED_W_2(39, W3, W4, W5, W0, W1, W2);
-
-	/* Transform 36-38 + Precalc 42-44 */
-	R2(a, b, c, d, e, f, g, h, 36, 0, XW); SCHED_W_0(42, W4, W5, W0, W1, W2, W3);
-	R2(d, a, b, c, h, e, f, g, 37, 1, XW); SCHED_W_1(42, W4, W5, W0, W1, W2, W3);
-	R2(c, d, a, b, g, h, e, f, 38, 2, XW); SCHED_W_2(42, W4, W5, W0, W1, W2, W3);
-
-	/* Transform 39-41 + Precalc 45-47 */
-	R2(b, c, d, a, f, g, h, e, 39, 0, XW); SCHED_W_0(45, W5, W0, W1, W2, W3, W4);
-	R2(a, b, c, d, e, f, g, h, 40, 1, XW); SCHED_W_1(45, W5, W0, W1, W2, W3, W4);
-	R2(d, a, b, c, h, e, f, g, 41, 2, XW); SCHED_W_2(45, W5, W0, W1, W2, W3, W4);
-
-	/* Transform 42-44 + Precalc 48-50 */
-	R2(c, d, a, b, g, h, e, f, 42, 0, XW); SCHED_W_0(48, W0, W1, W2, W3, W4, W5);
-	R2(b, c, d, a, f, g, h, e, 43, 1, XW); SCHED_W_1(48, W0, W1, W2, W3, W4, W5);
-	R2(a, b, c, d, e, f, g, h, 44, 2, XW); SCHED_W_2(48, W0, W1, W2, W3, W4, W5);
-
-	/* Transform 45-47 + Precalc 51-53 */
-	R2(d, a, b, c, h, e, f, g, 45, 0, XW); SCHED_W_0(51, W1, W2, W3, W4, W5, W0);
-	R2(c, d, a, b, g, h, e, f, 46, 1, XW); SCHED_W_1(51, W1, W2, W3, W4, W5, W0);
-	R2(b, c, d, a, f, g, h, e, 47, 2, XW); SCHED_W_2(51, W1, W2, W3, W4, W5, W0);
-
-	/* Transform 48-50 + Precalc 54-56 */
-	R2(a, b, c, d, e, f, g, h, 48, 0, XW); SCHED_W_0(54, W2, W3, W4, W5, W0, W1);
-	R2(d, a, b, c, h, e, f, g, 49, 1, XW); SCHED_W_1(54, W2, W3, W4, W5, W0, W1);
-	R2(c, d, a, b, g, h, e, f, 50, 2, XW); SCHED_W_2(54, W2, W3, W4, W5, W0, W1);
-
-	/* Transform 51-53 + Precalc 57-59 */
-	R2(b, c, d, a, f, g, h, e, 51, 0, XW); SCHED_W_0(57, W3, W4, W5, W0, W1, W2);
-	R2(a, b, c, d, e, f, g, h, 52, 1, XW); SCHED_W_1(57, W3, W4, W5, W0, W1, W2);
-	R2(d, a, b, c, h, e, f, g, 53, 2, XW); SCHED_W_2(57, W3, W4, W5, W0, W1, W2);
-
-	/* Transform 54-56 + Precalc 60-62 */
-	R2(c, d, a, b, g, h, e, f, 54, 0, XW); SCHED_W_0(60, W4, W5, W0, W1, W2, W3);
-	R2(b, c, d, a, f, g, h, e, 55, 1, XW); SCHED_W_1(60, W4, W5, W0, W1, W2, W3);
-	R2(a, b, c, d, e, f, g, h, 56, 2, XW); SCHED_W_2(60, W4, W5, W0, W1, W2, W3);
-
-	/* Transform 57-59 + Precalc 63 */
-	R2(d, a, b, c, h, e, f, g, 57, 0, XW); SCHED_W_0(63, W5, W0, W1, W2, W3, W4);
-	R2(c, d, a, b, g, h, e, f, 58, 1, XW);
-	R2(b, c, d, a, f, g, h, e, 59, 2, XW); SCHED_W_1(63, W5, W0, W1, W2, W3, W4);
-
-	/* Transform 60-62 + Precalc 63 */
-	R2(a, b, c, d, e, f, g, h, 60, 0, XW);
-	R2(d, a, b, c, h, e, f, g, 61, 1, XW); SCHED_W_2(63, W5, W0, W1, W2, W3, W4);
-	R2(c, d, a, b, g, h, e, f, 62, 2, XW);
-
-	/* Transform 63 */
-	R2(b, c, d, a, f, g, h, e, 63, 0, XW);
+	/* Transform 15 */
+	R1(b, c, d, a, f, g, h, e, 15, 0, XW);
+
+	/* Rounds 16-63: 4 iterations of 12 rounds. */
+	movl $0x9d8a7a87, KREG;
+	movl $4, RLOOP;
+
+.align 16
+.Lloop_r2:
+	/*
+	 * SCHED_W_* use iteration-0 round numbers (21..30); XW_W1_OFF(round)
+	 * alternates every 3 rounds and repeats every 6, which divides 12.
+	 */
+	R2(a, b, c, d, e, f, g, h, 1, 1); SCHED_W_0(21, W3, W4, W5, W0, W1, W2);
+	R2(d, a, b, c, h, e, f, g, 1, 2); SCHED_W_1(21, W3, W4, W5, W0, W1, W2);
+	R2(c, d, a, b, g, h, e, f, 0, 0); SCHED_W_2(21, W3, W4, W5, W0, W1, W2);
+
+	R2(b, c, d, a, f, g, h, e, 0, 1); SCHED_W_0(24, W4, W5, W0, W1, W2, W3);
+	R2(a, b, c, d, e, f, g, h, 0, 2); SCHED_W_1(24, W4, W5, W0, W1, W2, W3);
+	R2(d, a, b, c, h, e, f, g, 1, 0); SCHED_W_2(24, W4, W5, W0, W1, W2, W3);
+
+	R2(c, d, a, b, g, h, e, f, 1, 1); SCHED_W_0(27, W5, W0, W1, W2, W3, W4);
+	R2(b, c, d, a, f, g, h, e, 1, 2); SCHED_W_1(27, W5, W0, W1, W2, W3, W4);
+	R2(a, b, c, d, e, f, g, h, 0, 0); SCHED_W_2(27, W5, W0, W1, W2, W3, W4);
+
+	R2(d, a, b, c, h, e, f, g, 0, 1); SCHED_W_0(30, W0, W1, W2, W3, W4, W5);
+	R2(c, d, a, b, g, h, e, f, 0, 2); SCHED_W_1(30, W0, W1, W2, W3, W4, W5);
+	R2(b, c, d, a, f, g, h, e, 1, 0); SCHED_W_2(30, W0, W1, W2, W3, W4, W5);
+
+	/* Rotate W0..W5 by 4 positions: (W0..W5) <- (W4, W5, W0, W1, W2, W3). */
+	vmovdqa W0, XTMP0;
+	vmovdqa W1, XTMP1;
+	vmovdqa W4, W0;
+	vmovdqa W5, W1;
+	vmovdqa W2, W4;
+	vmovdqa W3, W5;
+	vmovdqa XTMP0, W2;
+	vmovdqa XTMP1, W3;
+
+	decl RLOOP;
+	jnz .Lloop_r2;
+
+	movq (STACK_REG_SAVE + 5 * 8)(%rsp), RNBLKS;
+	movq (STACK_REG_SAVE + 6 * 8)(%rsp), RDATA;
 
 	/* Update the chaining variables. */
 	xorl state_h0(RSTATE), a;

base-commit: b6a9fa34ce4187cb69d3c588a4bbffc31ce5db8f
-- 
2.56.1


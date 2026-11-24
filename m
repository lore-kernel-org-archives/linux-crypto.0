Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795509501;
	b=tQywA7Ip9LMDRfrvIJkA4p2E74i1Gdwx3ZbWkpLGEItXpkKs/rR0cQ1fKFPxkgklh3sS
	 yNGRKxQ+El6zVyfJ25OllmzSGGAzwugeQOE/DubIUAXRtkfkWBiYeiC2v9aMg5XKvdsjt
	 muNnJ0qs3Mn5fMp8f/O4PsUaUF3G+x/5ZIOCnb7v2Am335BSfL/7buC5fldT6Fp9hnEmE
	 ElI3GpGD0625aufLfeyIu8XkmMUTWk3NuPIKH95MYp7w+t0VdwXpmUUuILyNhmvmMgyTr
	 MLSlre/oKPyxe/8AfBSx/Dd7yoDOC/t7zp9p98bdn/avOSD2R55w9ryy17H4sQd4/RA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795509501;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 MIME-Version:Content-Transfer-Encoding;
	bh=93gQMISuhthRwWbiCC3Eme5lnXQuWDHq43SJmAA7Hzo=;
	b=l/S3mXyag7DH9Z2o/T2qbTKpJKdbERLY9cltkNoOyn9JUj5MSh8q+VCLtn7VzN1+RF1E
	 EqZxkzmzdlP/A116OSFJ7hMieOsEhdb67XJ0MAGiU6qRRKa78FTdiX1xP393Ifgyd5Rci
	 9rkptUN3vKX9Rp41HaozGfn8G5Q/Kb/DfRxfRGoyAmBNXvlJtAeib07nyBo57Ev+LPDUh
	 Nw5//fWw2531DCDYgKffxvVTxZZp6HUTbyUshfBJ1/Uq64Y/0syZt3Eu+aEqPOOaQmEiq
	 PrJjd7uj8pYxiFo3p7HSMweKkGQJoGaWRT6QPFkOjjxbWfY2f/N+2HBOO9OA+ecdJNw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Pvvrd37C;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B108C606A31E
	for <linux-crypto@vger.kernel.org>; Tue, 24 Nov 2026 08:38:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Pvvrd37C
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7FA811F000CA;
	Tue, 24 Nov 2026 08:38:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795509500;
	bh=93gQMISuhthRwWbiCC3Eme5lnXQuWDHq43SJmAA7Hzo=;
	h=From:To:Cc:Subject:Date;
	b=Pvvrd37CnPRr41pU3/3JU22/sgdALcA8gN0YYxPWyIVeFxOhNuJZRC45Wb9aWPYFX
	 BVaRM2Y1wh7NclrJB5mZZTVTjJhzu0itaildMpfdAK6adGZOE/5xAhKHJWnMwYWyEq
	 RGMzgcqWzlkZIxU9srydzc3TQqLuQaoI9Vvvs7NHjIpDzQ01Gv39LGd0fNLvSu5Q2c
	 gHwdCdiCXf26gk6+Spe34symHc0MHdNQNLCYDhX/1UA0USTUeHmUdbSxF3EwT72OiH
	 zmk/qlKE0AIa1PVR9HSum1ZsmzjlguYaxKdD0MLavv/WkKLdbUWPLx7m3G35kYw+ua
	 6GNVGjNX757bA==
From: Eric Biggers <ebiggers@kernel.org>
To: linux-crypto@vger.kernel.org
Cc: Ard Biesheuvel <ardb@kernel.org>,
	"Jason A . Donenfeld" <Jason@zx2c4.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	x86@kernel.org,
	Eric Biggers <ebiggers@kernel.org>
Subject: [PATCH v2] lib/crypto: x86/sm3: De-bloat sm3-avx-asm_64.S
Date: Tue, 24 Nov 2026 00:37:36 -0800
Message-ID: <20261124083736.247567-1-ebiggers@kernel.org>
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

This requires one extra GPR (KREG) for the round constant, which also
serves to terminate the rounds 16-63 loop when it reaches the "round 64"
value.  Free up %rdx for KREG by replacing RNBLKS with an end-of-data
pointer stored on the stack, terminating the block loop when RDATA
reaches it.

The .text of sm3-avx-asm_64.o shrinks from 9567 bytes to 4257 bytes, a
56% reduction.  Performance is unchanged to within 0.2% on AMD Ryzen 9
9950X (Zen 5), measured using the benchmark in sm3_kunit.

Signed-off-by: Eric Biggers <ebiggers@kernel.org>
---

v2: Avoided spilling RDATA and RNBLKS to the stack by using different
    methods to terminate the loops.

 lib/crypto/x86/sm3-avx-asm_64.S | 236 +++++++++-----------------------
 1 file changed, 68 insertions(+), 168 deletions(-)

diff --git a/lib/crypto/x86/sm3-avx-asm_64.S b/lib/crypto/x86/sm3-avx-asm_64.S
index a1925b1360101..c06aa1b1c5c41 100644
--- a/lib/crypto/x86/sm3-avx-asm_64.S
+++ b/lib/crypto/x86/sm3-avx-asm_64.S
@@ -25,80 +25,11 @@
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
 #define RDATA  %rsi
-#define RNBLKS %rdx
+#define KREG   %edx
 
 #define t0 %eax
 #define t1 %ebx
@@ -177,20 +108,22 @@
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
+	roll2(1, KREG);							\
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
@@ -212,20 +145,24 @@
 	xorl t1, h;
 
 #define R1(a, b, c, d, e, f, g, h, round, widx, wtype) \
-	R(1, a, b, c, d, e, f, g, h, round, widx, wtype)
+	R(1, a, b, c, d, e, f, g, h, wtype##_W1_OFF(round), widx)
 
-#define R2(a, b, c, d, e, f, g, h, round, widx, wtype) \
-	R(2, a, b, c, d, e, f, g, h, round, widx, wtype)
+#define R2(a, b, c, d, e, f, g, h, wslot, widx) \
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
@@ -338,8 +275,6 @@ SYM_FUNC_START(sm3_transform_avx)
 	pushq %rbp;
 	movq %rsp, %rbp;
 
-	movq %rdx, RNBLKS;
-
 	subq $STACK_SIZE, %rsp;
 	andq $(~63), %rsp;
 
@@ -349,6 +284,11 @@ SYM_FUNC_START(sm3_transform_avx)
 	movq %r13, (STACK_REG_SAVE + 3 * 8)(%rsp);
 	movq %r12, (STACK_REG_SAVE + 4 * 8)(%rsp);
 
+	/* Store pointer to the end of the data. */
+	shlq $6, %rdx;
+	addq RDATA, %rdx;
+	movq %rdx, (STACK_REG_SAVE + 5 * 8)(%rsp);
+
 	vmovdqa .Lbe32mask (%rip), BSWAP_REG;
 
 	/* Get the values of the chaining variables. */
@@ -366,7 +306,7 @@ SYM_FUNC_START(sm3_transform_avx)
 	/* Load data part1. */
 	LOAD_W_XMM_1();
 
-	leaq -1(RNBLKS), RNBLKS;
+	movl $0x79cc4519, KREG;
 
 	/* Transform 0-3 + Load data part2. */
 	R1(a, b, c, d, e, f, g, h, 0, 0, IW); LOAD_W_XMM_2();
@@ -391,88 +331,47 @@ SYM_FUNC_START(sm3_transform_avx)
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
+	/* Stop when KREG reaches the "round 64" value. */
+	cmpl $0x7a879d8a, KREG;
+	jne .Lloop_r2;
 
 	/* Update the chaining variables. */
 	xorl state_h0(RSTATE), a;
@@ -492,7 +391,8 @@ SYM_FUNC_START(sm3_transform_avx)
 	movl g, state_h6(RSTATE);
 	movl h, state_h7(RSTATE);
 
-	cmpq $0, RNBLKS;
+	/* Continue if there are more blocks to process. */
+	cmpq (STACK_REG_SAVE + 5 * 8)(%rsp), RDATA;
 	jne .Loop;
 
 	vzeroall;

base-commit: 7c5ec98f7bcf658cbc7d0094e4a762f6a9c2f159
-- 
2.56.1


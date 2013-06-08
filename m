From: Jussi Kivilinna <jussi.kivilinna@iki.fi>
Subject: [PATCH] crypto: camellia-aesni-avx2 - tune assembly code for more
 performance
Date: Sat, 08 Jun 2013 12:00:59 +0300
Message-ID: <20130608090059.5548.67430.stgit@localhost6.localdomain6>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>
To: linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from sypressi.dnainternet.net ([83.102.40.135]:41300 "EHLO
	sypressi.dnainternet.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751507Ab3FHJBG (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Sat, 8 Jun 2013 05:01:06 -0400
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Add implementation tuned for more performance on real hardware. Changes are
mostly around the part mixing 128-bit extract and insert instructions and
AES-NI instructions. Also 'vpbroadcastb' instructions have been change to
'vpshufb with zero mask'.

Tests on Intel Core i5-4570:

tcrypt ECB results, old-AVX2 vs new-AVX2:

size    128bit key      256bit key
        enc     dec     enc     dec
256     1.00x   1.00x   1.00x   1.00x
1k      1.08x   1.09x   1.05x   1.06x
8k      1.06x   1.06x   1.06x   1.06x

tcrypt ECB results, AVX vs new-AVX2:

size    128bit key      256bit key
        enc     dec     enc     dec
256     1.00x   1.00x   1.00x   1.00x
1k      1.51x   1.50x   1.52x   1.50x
8k      1.47x   1.48x   1.48x   1.48x

Signed-off-by: Jussi Kivilinna <jussi.kivilinna@iki.fi>
---
 arch/x86/crypto/camellia-aesni-avx2-asm_64.S |  160 ++++++++++++++------------
 1 file changed, 89 insertions(+), 71 deletions(-)

diff --git a/arch/x86/crypto/camellia-aesni-avx2-asm_64.S b/arch/x86/crypto/camellia-aesni-avx2-asm_64.S
index 91a1878..0e0b886 100644
--- a/arch/x86/crypto/camellia-aesni-avx2-asm_64.S
+++ b/arch/x86/crypto/camellia-aesni-avx2-asm_64.S
@@ -51,16 +51,6 @@
 #define ymm14_x xmm14
 #define ymm15_x xmm15
 
-/*
- * AES-NI instructions do not support ymmX registers, so we need splitting and
- * merging.
- */
-#define vaesenclast256(zero, yreg, tmp) \
-	vextracti128 $1, yreg, tmp##_x; \
-	vaesenclast zero##_x, yreg##_x, yreg##_x; \
-	vaesenclast zero##_x, tmp##_x, tmp##_x; \
-	vinserti128 $1, tmp##_x, yreg, yreg;
-
 /**********************************************************************
   32-way camellia
  **********************************************************************/
@@ -79,46 +69,70 @@
 	 * S-function with AES subbytes \
 	 */ \
 	vbroadcasti128 .Linv_shift_row, t4; \
-	vpbroadcastb .L0f0f0f0f, t7; \
-	vbroadcasti128 .Lpre_tf_lo_s1, t0; \
-	vbroadcasti128 .Lpre_tf_hi_s1, t1; \
+	vpbroadcastd .L0f0f0f0f, t7; \
+	vbroadcasti128 .Lpre_tf_lo_s1, t5; \
+	vbroadcasti128 .Lpre_tf_hi_s1, t6; \
+	vbroadcasti128 .Lpre_tf_lo_s4, t2; \
+	vbroadcasti128 .Lpre_tf_hi_s4, t3; \
 	\
 	/* AES inverse shift rows */ \
 	vpshufb t4, x0, x0; \
 	vpshufb t4, x7, x7; \
-	vpshufb t4, x1, x1; \
-	vpshufb t4, x4, x4; \
-	vpshufb t4, x2, x2; \
-	vpshufb t4, x5, x5; \
 	vpshufb t4, x3, x3; \
 	vpshufb t4, x6, x6; \
+	vpshufb t4, x2, x2; \
+	vpshufb t4, x5, x5; \
+	vpshufb t4, x1, x1; \
+	vpshufb t4, x4, x4; \
 	\
 	/* prefilter sboxes 1, 2 and 3 */ \
-	vbroadcasti128 .Lpre_tf_lo_s4, t2; \
-	vbroadcasti128 .Lpre_tf_hi_s4, t3; \
-	filter_8bit(x0, t0, t1, t7, t6); \
-	filter_8bit(x7, t0, t1, t7, t6); \
-	filter_8bit(x1, t0, t1, t7, t6); \
-	filter_8bit(x4, t0, t1, t7, t6); \
-	filter_8bit(x2, t0, t1, t7, t6); \
-	filter_8bit(x5, t0, t1, t7, t6); \
-	\
 	/* prefilter sbox 4 */ \
+	filter_8bit(x0, t5, t6, t7, t4); \
+	filter_8bit(x7, t5, t6, t7, t4); \
+	vextracti128 $1, x0, t0##_x; \
+	vextracti128 $1, x7, t1##_x; \
+	filter_8bit(x3, t2, t3, t7, t4); \
+	filter_8bit(x6, t2, t3, t7, t4); \
+	vextracti128 $1, x3, t3##_x; \
+	vextracti128 $1, x6, t2##_x; \
+	filter_8bit(x2, t5, t6, t7, t4); \
+	filter_8bit(x5, t5, t6, t7, t4); \
+	filter_8bit(x1, t5, t6, t7, t4); \
+	filter_8bit(x4, t5, t6, t7, t4); \
+	\
 	vpxor t4##_x, t4##_x, t4##_x; \
-	filter_8bit(x3, t2, t3, t7, t6); \
-	filter_8bit(x6, t2, t3, t7, t6); \
 	\
 	/* AES subbytes + AES shift rows */ \
+	vextracti128 $1, x2, t6##_x; \
+	vextracti128 $1, x5, t5##_x; \
+	vaesenclast t4##_x, x0##_x, x0##_x; \
+	vaesenclast t4##_x, t0##_x, t0##_x; \
+	vinserti128 $1, t0##_x, x0, x0; \
+	vaesenclast t4##_x, x7##_x, x7##_x; \
+	vaesenclast t4##_x, t1##_x, t1##_x; \
+	vinserti128 $1, t1##_x, x7, x7; \
+	vaesenclast t4##_x, x3##_x, x3##_x; \
+	vaesenclast t4##_x, t3##_x, t3##_x; \
+	vinserti128 $1, t3##_x, x3, x3; \
+	vaesenclast t4##_x, x6##_x, x6##_x; \
+	vaesenclast t4##_x, t2##_x, t2##_x; \
+	vinserti128 $1, t2##_x, x6, x6; \
+	vextracti128 $1, x1, t3##_x; \
+	vextracti128 $1, x4, t2##_x; \
 	vbroadcasti128 .Lpost_tf_lo_s1, t0; \
 	vbroadcasti128 .Lpost_tf_hi_s1, t1; \
-	vaesenclast256(t4, x0, t5); \
-	vaesenclast256(t4, x7, t5); \
-	vaesenclast256(t4, x1, t5); \
-	vaesenclast256(t4, x4, t5); \
-	vaesenclast256(t4, x2, t5); \
-	vaesenclast256(t4, x5, t5); \
-	vaesenclast256(t4, x3, t5); \
-	vaesenclast256(t4, x6, t5); \
+	vaesenclast t4##_x, x2##_x, x2##_x; \
+	vaesenclast t4##_x, t6##_x, t6##_x; \
+	vinserti128 $1, t6##_x, x2, x2; \
+	vaesenclast t4##_x, x5##_x, x5##_x; \
+	vaesenclast t4##_x, t5##_x, t5##_x; \
+	vinserti128 $1, t5##_x, x5, x5; \
+	vaesenclast t4##_x, x1##_x, x1##_x; \
+	vaesenclast t4##_x, t3##_x, t3##_x; \
+	vinserti128 $1, t3##_x, x1, x1; \
+	vaesenclast t4##_x, x4##_x, x4##_x; \
+	vaesenclast t4##_x, t2##_x, t2##_x; \
+	vinserti128 $1, t2##_x, x4, x4; \
 	\
 	/* postfilter sboxes 1 and 4 */ \
 	vbroadcasti128 .Lpost_tf_lo_s3, t2; \
@@ -139,22 +153,12 @@
 	/* postfilter sbox 2 */ \
 	filter_8bit(x1, t4, t5, t7, t2); \
 	filter_8bit(x4, t4, t5, t7, t2); \
+	vpxor t7, t7, t7; \
 	\
 	vpsrldq $1, t0, t1; \
 	vpsrldq $2, t0, t2; \
+	vpshufb t7, t1, t1; \
 	vpsrldq $3, t0, t3; \
-	vpsrldq $4, t0, t4; \
-	vpsrldq $5, t0, t5; \
-	vpsrldq $6, t0, t6; \
-	vpsrldq $7, t0, t7; \
-	vpbroadcastb t0##_x, t0; \
-	vpbroadcastb t1##_x, t1; \
-	vpbroadcastb t2##_x, t2; \
-	vpbroadcastb t3##_x, t3; \
-	vpbroadcastb t4##_x, t4; \
-	vpbroadcastb t6##_x, t6; \
-	vpbroadcastb t5##_x, t5; \
-	vpbroadcastb t7##_x, t7; \
 	\
 	/* P-function */ \
 	vpxor x5, x0, x0; \
@@ -162,11 +166,21 @@
 	vpxor x7, x2, x2; \
 	vpxor x4, x3, x3; \
 	\
+	vpshufb t7, t2, t2; \
+	vpsrldq $4, t0, t4; \
+	vpshufb t7, t3, t3; \
+	vpsrldq $5, t0, t5; \
+	vpshufb t7, t4, t4; \
+	\
 	vpxor x2, x4, x4; \
 	vpxor x3, x5, x5; \
 	vpxor x0, x6, x6; \
 	vpxor x1, x7, x7; \
 	\
+	vpsrldq $6, t0, t6; \
+	vpshufb t7, t5, t5; \
+	vpshufb t7, t6, t6; \
+	\
 	vpxor x7, x0, x0; \
 	vpxor x4, x1, x1; \
 	vpxor x5, x2, x2; \
@@ -179,12 +193,16 @@
 	\
 	/* Add key material and result to CD (x becomes new CD) */ \
 	\
-	vpxor t7, x0, x0; \
-	vpxor 4 * 32(mem_cd), x0, x0; \
-	\
 	vpxor t6, x1, x1; \
 	vpxor 5 * 32(mem_cd), x1, x1; \
 	\
+	vpsrldq $7, t0, t6; \
+	vpshufb t7, t0, t0; \
+	vpshufb t7, t6, t7; \
+	\
+	vpxor t7, x0, x0; \
+	vpxor 4 * 32(mem_cd), x0, x0; \
+	\
 	vpxor t5, x2, x2; \
 	vpxor 6 * 32(mem_cd), x2, x2; \
 	\
@@ -204,7 +222,7 @@
 	vpxor 3 * 32(mem_cd), x7, x7;
 
 /*
- * Size optimization... with inlined roundsm16 binary would be over 5 times
+ * Size optimization... with inlined roundsm32 binary would be over 5 times
  * larger and would only marginally faster.
  */
 .align 8
@@ -324,13 +342,13 @@ ENDPROC(roundsm32_x4_x5_x6_x7_x0_x1_x2_x3_y4_y5_y6_y7_y0_y1_y2_y3_ab)
 	 */ \
 	vpbroadcastd kll, t0; /* only lowest 32-bit used */ \
 	vpxor tt0, tt0, tt0; \
-	vpbroadcastb t0##_x, t3; \
+	vpshufb tt0, t0, t3; \
 	vpsrldq $1, t0, t0; \
-	vpbroadcastb t0##_x, t2; \
+	vpshufb tt0, t0, t2; \
 	vpsrldq $1, t0, t0; \
-	vpbroadcastb t0##_x, t1; \
+	vpshufb tt0, t0, t1; \
 	vpsrldq $1, t0, t0; \
-	vpbroadcastb t0##_x, t0; \
+	vpshufb tt0, t0, t0; \
 	\
 	vpand l0, t0, t0; \
 	vpand l1, t1, t1; \
@@ -340,6 +358,7 @@ ENDPROC(roundsm32_x4_x5_x6_x7_x0_x1_x2_x3_y4_y5_y6_y7_y0_y1_y2_y3_ab)
 	rol32_1_32(t3, t2, t1, t0, tt1, tt2, tt3, tt0); \
 	\
 	vpxor l4, t0, l4; \
+	vpbroadcastd krr, t0; /* only lowest 32-bit used */ \
 	vmovdqu l4, 4 * 32(l); \
 	vpxor l5, t1, l5; \
 	vmovdqu l5, 5 * 32(l); \
@@ -354,14 +373,13 @@ ENDPROC(roundsm32_x4_x5_x6_x7_x0_x1_x2_x3_y4_y5_y6_y7_y0_y1_y2_y3_ab)
 	 * rl ^= t2; \
 	 */ \
 	\
-	vpbroadcastd krr, t0; /* only lowest 32-bit used */ \
-	vpbroadcastb t0##_x, t3; \
+	vpshufb tt0, t0, t3; \
 	vpsrldq $1, t0, t0; \
-	vpbroadcastb t0##_x, t2; \
+	vpshufb tt0, t0, t2; \
 	vpsrldq $1, t0, t0; \
-	vpbroadcastb t0##_x, t1; \
+	vpshufb tt0, t0, t1; \
 	vpsrldq $1, t0, t0; \
-	vpbroadcastb t0##_x, t0; \
+	vpshufb tt0, t0, t0; \
 	\
 	vpor 4 * 32(r), t0, t0; \
 	vpor 5 * 32(r), t1, t1; \
@@ -373,6 +391,7 @@ ENDPROC(roundsm32_x4_x5_x6_x7_x0_x1_x2_x3_y4_y5_y6_y7_y0_y1_y2_y3_ab)
 	vpxor 2 * 32(r), t2, t2; \
 	vpxor 3 * 32(r), t3, t3; \
 	vmovdqu t0, 0 * 32(r); \
+	vpbroadcastd krl, t0; /* only lowest 32-bit used */ \
 	vmovdqu t1, 1 * 32(r); \
 	vmovdqu t2, 2 * 32(r); \
 	vmovdqu t3, 3 * 32(r); \
@@ -382,14 +401,13 @@ ENDPROC(roundsm32_x4_x5_x6_x7_x0_x1_x2_x3_y4_y5_y6_y7_y0_y1_y2_y3_ab)
 	 * t2 &= rl; \
 	 * rr ^= rol32(t2, 1); \
 	 */ \
-	vpbroadcastd krl, t0; /* only lowest 32-bit used */ \
-	vpbroadcastb t0##_x, t3; \
+	vpshufb tt0, t0, t3; \
 	vpsrldq $1, t0, t0; \
-	vpbroadcastb t0##_x, t2; \
+	vpshufb tt0, t0, t2; \
 	vpsrldq $1, t0, t0; \
-	vpbroadcastb t0##_x, t1; \
+	vpshufb tt0, t0, t1; \
 	vpsrldq $1, t0, t0; \
-	vpbroadcastb t0##_x, t0; \
+	vpshufb tt0, t0, t0; \
 	\
 	vpand 0 * 32(r), t0, t0; \
 	vpand 1 * 32(r), t1, t1; \
@@ -403,6 +421,7 @@ ENDPROC(roundsm32_x4_x5_x6_x7_x0_x1_x2_x3_y4_y5_y6_y7_y0_y1_y2_y3_ab)
 	vpxor 6 * 32(r), t2, t2; \
 	vpxor 7 * 32(r), t3, t3; \
 	vmovdqu t0, 4 * 32(r); \
+	vpbroadcastd klr, t0; /* only lowest 32-bit used */ \
 	vmovdqu t1, 5 * 32(r); \
 	vmovdqu t2, 6 * 32(r); \
 	vmovdqu t3, 7 * 32(r); \
@@ -413,14 +432,13 @@ ENDPROC(roundsm32_x4_x5_x6_x7_x0_x1_x2_x3_y4_y5_y6_y7_y0_y1_y2_y3_ab)
 	 * ll ^= t0; \
 	 */ \
 	\
-	vpbroadcastd klr, t0; /* only lowest 32-bit used */ \
-	vpbroadcastb t0##_x, t3; \
+	vpshufb tt0, t0, t3; \
 	vpsrldq $1, t0, t0; \
-	vpbroadcastb t0##_x, t2; \
+	vpshufb tt0, t0, t2; \
 	vpsrldq $1, t0, t0; \
-	vpbroadcastb t0##_x, t1; \
+	vpshufb tt0, t0, t1; \
 	vpsrldq $1, t0, t0; \
-	vpbroadcastb t0##_x, t0; \
+	vpshufb tt0, t0, t0; \
 	\
 	vpor l4, t0, t0; \
 	vpor l5, t1, t1; \

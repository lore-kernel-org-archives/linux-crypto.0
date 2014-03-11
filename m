From: Jason Cooper <jason@lakedaemon.net>
Subject: [RFC PATCH 18/22] staging: crypto: skein: wrap multi-line macros in do-while loops
Date: Tue, 11 Mar 2014 21:32:50 +0000
Message-ID: <c0c00d4abb6f3e138149fd5fd88568f90eef301e.1394570068.git.jason@lakedaemon.net>
References: <cover.1394570067.git.jason@lakedaemon.net>
Cc: devel@driverdev.osuosl.org, linux-crypto@vger.kernel.org,
	Jason Cooper <jason@lakedaemon.net>
To: Greg KH <gregkh@linuxfoundation.org>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mho-03-ewr.mailhop.org ([204.13.248.66]:52094 "EHLO
	mho-01-ewr.mailhop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755760AbaCKVzr (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 11 Mar 2014 17:55:47 -0400
In-Reply-To: <cover.1394570067.git.jason@lakedaemon.net>
In-Reply-To: <cover.1394570067.git.jason@lakedaemon.net>
References: <cover.1394570067.git.jason@lakedaemon.net>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Signed-off-by: Jason Cooper <jason@lakedaemon.net>
---
 drivers/staging/skein/skein_block.c | 66 ++++++++++++++++++++++++++++---------
 1 file changed, 51 insertions(+), 15 deletions(-)

diff --git a/drivers/staging/skein/skein_block.c b/drivers/staging/skein/skein_block.c
index 6e0f4a21aae3..707a21ae53c6 100644
--- a/drivers/staging/skein/skein_block.c
+++ b/drivers/staging/skein/skein_block.c
@@ -107,27 +107,36 @@ void Skein_256_Process_Block(struct skein_256_ctx *ctx, const u8 *blkPtr,
 		/* run the rounds */
 
 #define Round256(p0, p1, p2, p3, ROT, rNum)                              \
+do { \
 	X##p0 += X##p1; X##p1 = RotL_64(X##p1, ROT##_0); X##p1 ^= X##p0; \
 	X##p2 += X##p3; X##p3 = RotL_64(X##p3, ROT##_1); X##p3 ^= X##p2; \
+} while (0)
 
 #if SKEIN_UNROLL_256 == 0
 #define R256(p0, p1, p2, p3, ROT, rNum) /* fully unrolled */ \
+do { \
 	Round256(p0, p1, p2, p3, ROT, rNum) \
-	Skein_Show_R_Ptr(BLK_BITS, &ctx->h, rNum, Xptr);
+	Skein_Show_R_Ptr(BLK_BITS, &ctx->h, rNum, Xptr); \
+} while (0)
 
 #define I256(R) \
+do { \
 	/* inject the key schedule value */ \
 	X0   += ks[((R)+1) % 5]; \
 	X1   += ks[((R)+2) % 5] + ts[((R)+1) % 3]; \
 	X2   += ks[((R)+3) % 5] + ts[((R)+2) % 3]; \
 	X3   += ks[((R)+4) % 5] +     (R)+1;       \
-	Skein_Show_R_Ptr(BLK_BITS, &ctx->h, SKEIN_RND_KEY_INJECT, Xptr);
+	Skein_Show_R_Ptr(BLK_BITS, &ctx->h, SKEIN_RND_KEY_INJECT, Xptr); \
+} while (0)
 #else /* looping version */
 #define R256(p0, p1, p2, p3, ROT, rNum) \
+do { \
 	Round256(p0, p1, p2, p3, ROT, rNum) \
-	Skein_Show_R_Ptr(BLK_BITS, &ctx->h, 4 * (r - 1) + rNum, Xptr);
+	Skein_Show_R_Ptr(BLK_BITS, &ctx->h, 4 * (r - 1) + rNum, Xptr); \
+} while (0)
 
 #define I256(R) \
+do { \
 	/* inject the key schedule value */ \
 	X0   += ks[r+(R)+0]; \
 	X1   += ks[r+(R)+1] + ts[r+(R)+0]; \
@@ -136,12 +145,14 @@ void Skein_256_Process_Block(struct skein_256_ctx *ctx, const u8 *blkPtr,
 	/* rotate key schedule */ \
 	ks[r + (R) + 4]   = ks[r + (R) - 1]; \
 	ts[r + (R) + 2]   = ts[r + (R) - 1]; \
-	Skein_Show_R_Ptr(BLK_BITS, &ctx->h, SKEIN_RND_KEY_INJECT, Xptr);
+	Skein_Show_R_Ptr(BLK_BITS, &ctx->h, SKEIN_RND_KEY_INJECT, Xptr); \
+} while (0)
 
 	for (r = 1; r < 2 * RCNT; r += 2 * SKEIN_UNROLL_256)
 #endif
 		{
 #define R256_8_rounds(R)                  \
+do { \
 		R256(0, 1, 2, 3, R_256_0, 8 * (R) + 1);  \
 		R256(0, 3, 2, 1, R_256_1, 8 * (R) + 2);  \
 		R256(0, 1, 2, 3, R_256_2, 8 * (R) + 3);  \
@@ -151,7 +162,8 @@ void Skein_256_Process_Block(struct skein_256_ctx *ctx, const u8 *blkPtr,
 		R256(0, 3, 2, 1, R_256_5, 8 * (R) + 6);  \
 		R256(0, 1, 2, 3, R_256_6, 8 * (R) + 7);  \
 		R256(0, 3, 2, 1, R_256_7, 8 * (R) + 8);  \
-		I256(2 * (R) + 1);
+		I256(2 * (R) + 1); \
+} while (0)
 
 		R256_8_rounds(0);
 
@@ -311,17 +323,22 @@ void Skein_512_Process_Block(struct skein_512_ctx *ctx, const u8 *blkPtr,
 				 Xptr);
 		/* run the rounds */
 #define Round512(p0, p1, p2, p3, p4, p5, p6, p7, ROT, rNum) \
+do { \
 	X##p0 += X##p1; X##p1 = RotL_64(X##p1, ROT##_0); X##p1 ^= X##p0; \
 	X##p2 += X##p3; X##p3 = RotL_64(X##p3, ROT##_1); X##p3 ^= X##p2; \
 	X##p4 += X##p5; X##p5 = RotL_64(X##p5, ROT##_2); X##p5 ^= X##p4; \
 	X##p6 += X##p7; X##p7 = RotL_64(X##p7, ROT##_3); X##p7 ^= X##p6; \
+} while (0)
 
 #if SKEIN_UNROLL_512 == 0
 #define R512(p0, p1, p2, p3, p4, p5, p6, p7, ROT, rNum) /* unrolled */ \
+do { \
 	Round512(p0, p1, p2, p3, p4, p5, p6, p7, ROT, rNum) \
-	Skein_Show_R_Ptr(BLK_BITS, &ctx->h, rNum, Xptr);
+	Skein_Show_R_Ptr(BLK_BITS, &ctx->h, rNum, Xptr); \
+} while (0)
 
 #define I512(R) \
+do { \
 	/* inject the key schedule value */ \
 	X0   += ks[((R) + 1) % 9]; \
 	X1   += ks[((R) + 2) % 9]; \
@@ -331,13 +348,17 @@ void Skein_512_Process_Block(struct skein_512_ctx *ctx, const u8 *blkPtr,
 	X5   += ks[((R) + 6) % 9] + ts[((R) + 1) % 3]; \
 	X6   += ks[((R) + 7) % 9] + ts[((R) + 2) % 3]; \
 	X7   += ks[((R) + 8) % 9] +     (R) + 1;       \
-	Skein_Show_R_Ptr(BLK_BITS, &ctx->h, SKEIN_RND_KEY_INJECT, Xptr);
+	Skein_Show_R_Ptr(BLK_BITS, &ctx->h, SKEIN_RND_KEY_INJECT, Xptr); \
+} while (0)
 #else /* looping version */
 #define R512(p0, p1, p2, p3, p4, p5, p6, p7, ROT, rNum) \
+do { \
 	Round512(p0, p1, p2, p3, p4, p5, p6, p7, ROT, rNum) \
-	Skein_Show_R_Ptr(BLK_BITS, &ctx->h, 4 * (r - 1) + rNum, Xptr);
+	Skein_Show_R_Ptr(BLK_BITS, &ctx->h, 4 * (r - 1) + rNum, Xptr); \
+} while (0)
 
 #define I512(R) \
+do { \
 	/* inject the key schedule value */ \
 	X0   += ks[r + (R) + 0]; \
 	X1   += ks[r + (R) + 1]; \
@@ -350,12 +371,14 @@ void Skein_512_Process_Block(struct skein_512_ctx *ctx, const u8 *blkPtr,
 	/* rotate key schedule */ \
 	ks[r +         (R) + 8] = ks[r + (R) - 1]; \
 	ts[r +         (R) + 2] = ts[r + (R) - 1]; \
-	Skein_Show_R_Ptr(BLK_BITS, &ctx->h, SKEIN_RND_KEY_INJECT, Xptr);
+	Skein_Show_R_Ptr(BLK_BITS, &ctx->h, SKEIN_RND_KEY_INJECT, Xptr); \
+} while (0)
 
 		for (r = 1; r < 2 * RCNT; r += 2 * SKEIN_UNROLL_512)
 #endif /* end of looped code definitions */
 		{
 #define R512_8_rounds(R)  /* do 8 full rounds */  \
+do { \
 		R512(0, 1, 2, 3, 4, 5, 6, 7, R_512_0, 8 * (R) + 1);   \
 		R512(2, 1, 4, 7, 6, 5, 0, 3, R_512_1, 8 * (R) + 2);   \
 		R512(4, 1, 6, 3, 0, 5, 2, 7, R_512_2, 8 * (R) + 3);   \
@@ -365,7 +388,8 @@ void Skein_512_Process_Block(struct skein_512_ctx *ctx, const u8 *blkPtr,
 		R512(2, 1, 4, 7, 6, 5, 0, 3, R_512_5, 8 * (R) + 6);   \
 		R512(4, 1, 6, 3, 0, 5, 2, 7, R_512_6, 8 * (R) + 7);   \
 		R512(6, 1, 0, 7, 2, 5, 4, 3, R_512_7, 8 * (R) + 8);   \
-		I512(2 * (R) + 1);        /* and key injection */
+		I512(2 * (R) + 1);        /* and key injection */ \
+} while (0)
 
 			R512_8_rounds(0);
 
@@ -551,6 +575,7 @@ void Skein1024_Process_Block(struct skein1024_ctx *ctx, const u8 *blkPtr, \
 
 #define Round1024(p0, p1, p2, p3, p4, p5, p6, p7, p8, p9, pA, pB, pC, pD, pE, \
 			pF, ROT, rNum) \
+do { \
 	X##p0 += X##p1; X##p1 = RotL_64(X##p1, ROT##_0); X##p1 ^= X##p0;   \
 	X##p2 += X##p3; X##p3 = RotL_64(X##p3, ROT##_1); X##p3 ^= X##p2;   \
 	X##p4 += X##p5; X##p5 = RotL_64(X##p5, ROT##_2); X##p5 ^= X##p4;   \
@@ -559,15 +584,19 @@ void Skein1024_Process_Block(struct skein1024_ctx *ctx, const u8 *blkPtr, \
 	X##pA += X##pB; X##pB = RotL_64(X##pB, ROT##_5); X##pB ^= X##pA;   \
 	X##pC += X##pD; X##pD = RotL_64(X##pD, ROT##_6); X##pD ^= X##pC;   \
 	X##pE += X##pF; X##pF = RotL_64(X##pF, ROT##_7); X##pF ^= X##pE;   \
+} while (0)
 
 #if SKEIN_UNROLL_1024 == 0
 #define R1024(p0, p1, p2, p3, p4, p5, p6, p7, p8, p9, pA, pB, pC, pD, pE, pF, \
 		ROT, rn) \
+do { \
 	Round1024(p0, p1, p2, p3, p4, p5, p6, p7, p8, p9, pA, pB, pC, pD, pE, \
 			pF, ROT, rn) \
-	Skein_Show_R_Ptr(BLK_BITS, &ctx->h, rn, Xptr);
+	Skein_Show_R_Ptr(BLK_BITS, &ctx->h, rn, Xptr); \
+} while (0)
 
 #define I1024(R) \
+do { \
 	/* inject the key schedule value */ \
 	X00   += ks[((R) +  1) % 17]; \
 	X01   += ks[((R) +  2) % 17]; \
@@ -585,15 +614,19 @@ void Skein1024_Process_Block(struct skein1024_ctx *ctx, const u8 *blkPtr, \
 	X13   += ks[((R) + 14) % 17] + ts[((R) + 1) % 3]; \
 	X14   += ks[((R) + 15) % 17] + ts[((R) + 2) % 3]; \
 	X15   += ks[((R) + 16) % 17] +     (R) + 1;       \
-	Skein_Show_R_Ptr(BLK_BITS, &ctx->h, SKEIN_RND_KEY_INJECT, Xptr);
+	Skein_Show_R_Ptr(BLK_BITS, &ctx->h, SKEIN_RND_KEY_INJECT, Xptr); \
+} while (0)
 #else /* looping version */
 #define R1024(p0, p1, p2, p3, p4, p5, p6, p7, p8, p9, pA, pB, pC, pD, pE, pF, \
 		ROT, rn) \
+do { \
 	Round1024(p0, p1, p2, p3, p4, p5, p6, p7, p8, p9, pA, pB, pC, pD, pE, \
 			pF, ROT, rn) \
-	Skein_Show_R_Ptr(BLK_BITS, &ctx->h, 4 * (r - 1) + rn, Xptr);
+	Skein_Show_R_Ptr(BLK_BITS, &ctx->h, 4 * (r - 1) + rn, Xptr); \
+} while (0)
 
 #define I1024(R) \
+do { \
 	/* inject the key schedule value */ \
 	X00   += ks[r + (R) +  0]; \
 	X01   += ks[r + (R) +  1]; \
@@ -614,12 +647,14 @@ void Skein1024_Process_Block(struct skein1024_ctx *ctx, const u8 *blkPtr, \
 	/* rotate key schedule */ \
 	ks[r  +         (R) + 16] = ks[r + (R) - 1]; \
 	ts[r  +         (R) +  2] = ts[r + (R) - 1]; \
-	Skein_Show_R_Ptr(BLK_BITSi, &ctx->h, SKEIN_RND_KEY_INJECT, Xptr);
+	Skein_Show_R_Ptr(BLK_BITSi, &ctx->h, SKEIN_RND_KEY_INJECT, Xptr); \
+} while (0)
 
 		for (r = 1; r <= 2 * RCNT; r += 2 * SKEIN_UNROLL_1024)
 #endif
 		{
 #define R1024_8_rounds(R) \
+do { \
 	R1024(00, 01, 02, 03, 04, 05, 06, 07, 08, 09, 10, 11, 12, 13, 14, 15, \
 		R1024_0, 8*(R) + 1); \
 	R1024(00, 09, 02, 13, 06, 11, 04, 15, 10, 07, 12, 03, 14, 05, 08, 01, \
@@ -637,7 +672,8 @@ void Skein1024_Process_Block(struct skein1024_ctx *ctx, const u8 *blkPtr, \
 		R1024_6, 8*(R) + 7); \
 	R1024(00, 15, 02, 11, 06, 13, 04, 09, 14, 01, 08, 05, 10, 03, 12, 07, \
 		R1024_7, 8*(R) + 8); \
-	I1024(2*(R)+1);
+	I1024(2*(R)+1); \
+} while (0)
 
 			R1024_8_rounds(0);
 
-- 
1.9.0

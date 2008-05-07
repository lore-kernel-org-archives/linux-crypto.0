From: Adrian-Ken Rueegsegger <rueegsegger@swiss-it.ch>
Subject: [PATCH 2/5][CRYPTO] RIPEMD: put all common RIPEMD values in header file
Date: Wed,  7 May 2008 23:58:36 +0200
Message-ID: <1210197519-18432-3-git-send-email-rueegsegger@swiss-it.ch>
References: <>
 <1210197519-18432-1-git-send-email-rueegsegger@swiss-it.ch>
 <1210197519-18432-2-git-send-email-rueegsegger@swiss-it.ch>
Cc: linux-crypto@vger.kernel.org,
	Adrian-Ken Rueegsegger <rueegsegger@swiss-it.ch>
To: herbert@gondor.apana.org.au
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from zux006-004-203.adsl.green.ch ([81.6.4.203]:2369 "EHLO
	mailx.swiss-it.ch" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755796AbYEGV6o (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 7 May 2008 17:58:44 -0400
In-Reply-To: <1210197519-18432-2-git-send-email-rueegsegger@swiss-it.ch>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

This patch puts all common RIPEMD values in the
appropriate header file. Initial values and constants
are the same for all variants of RIPEMD.
---
 crypto/rmd128.c         |   16 ++++++++--------
 crypto/rmd160.c         |   20 ++++++++++----------
 include/crypto/ripemd.h |   17 +++++++++++++++++
 3 files changed, 35 insertions(+), 18 deletions(-)

diff --git a/crypto/rmd128.c b/crypto/rmd128.c
index 8f5e3c8..146a167 100644
--- a/crypto/rmd128.c
+++ b/crypto/rmd128.c
@@ -28,14 +28,14 @@ struct rmd128_ctx {
 	u32 buffer[16];
 };
 
-#define K1  0x00000000UL
-#define K2  0x5a827999UL
-#define K3  0x6ed9eba1UL
-#define K4  0x8f1bbcdcUL
-#define KK1 0x50a28be6UL
-#define KK2 0x5c4dd124UL
-#define KK3 0x6d703ef3UL
-#define KK4 0x00000000UL
+#define K1  RMD_K1
+#define K2  RMD_K2
+#define K3  RMD_K3
+#define K4  RMD_K4
+#define KK1 RMD_K6
+#define KK2 RMD_K7
+#define KK3 RMD_K8
+#define KK4 RMD_K1
 
 #define F1(x, y, z) (x ^ y ^ z)		/* XOR */
 #define F2(x, y, z) (z ^ (x & (y ^ z)))	/* x ? y : z */
diff --git a/crypto/rmd160.c b/crypto/rmd160.c
index 5860433..4248aaa 100644
--- a/crypto/rmd160.c
+++ b/crypto/rmd160.c
@@ -28,16 +28,16 @@ struct rmd160_ctx {
 	u32 buffer[16];
 };
 
-#define K1  0x00000000UL
-#define K2  0x5a827999UL
-#define K3  0x6ed9eba1UL
-#define K4  0x8f1bbcdcUL
-#define K5  0xa953fd4eUL
-#define KK1 0x50a28be6UL
-#define KK2 0x5c4dd124UL
-#define KK3 0x6d703ef3UL
-#define KK4 0x7a6d76e9UL
-#define KK5 0x00000000UL
+#define K1  RMD_K1
+#define K2  RMD_K2
+#define K3  RMD_K3
+#define K4  RMD_K4
+#define K5  RMD_K5
+#define KK1 RMD_K6
+#define KK2 RMD_K7
+#define KK3 RMD_K8
+#define KK4 RMD_K9
+#define KK5 RMD_K1
 
 #define F1(x, y, z) (x ^ y ^ z)		/* XOR */
 #define F2(x, y, z) (z ^ (x & (y ^ z)))	/* x ? y : z */
diff --git a/include/crypto/ripemd.h b/include/crypto/ripemd.h
index 2858e22..c57a2d4 100644
--- a/include/crypto/ripemd.h
+++ b/include/crypto/ripemd.h
@@ -17,10 +17,27 @@
 #define RMD320_DIGEST_SIZE      40
 #define RMD320_BLOCK_SIZE       64
 
+/* initial values  */
 #define RMD_H0  0x67452301UL
 #define RMD_H1  0xefcdab89UL
 #define RMD_H2  0x98badcfeUL
 #define RMD_H3  0x10325476UL
 #define RMD_H4  0xc3d2e1f0UL
+#define RMD_H5  0x76543210UL
+#define RMD_H6  0xfedcba98UL
+#define RMD_H7  0x89abcdefUL
+#define RMD_H8  0x01234567UL
+#define RMD_H9  0x3c2d1e0fUL
+
+/* constants */
+#define RMD_K1  0x00000000UL
+#define RMD_K2  0x5a827999UL
+#define RMD_K3  0x6ed9eba1UL
+#define RMD_K4  0x8f1bbcdcUL
+#define RMD_K5  0xa953fd4eUL
+#define RMD_K6  0x50a28be6UL
+#define RMD_K7  0x5c4dd124UL
+#define RMD_K8  0x6d703ef3UL
+#define RMD_K9  0x7a6d76e9UL
 
 #endif
-- 
1.5.2.5


From: Harald Freudenberger <freude@linux.vnet.ibm.com>
Subject: [PATCH] s390/crypto: Fix incorrect ghash icv buffer handling.
Date: Thu, 21 May 2015 10:01:11 +0200
Message-ID: <1432195271-3036-1-git-send-email-freude@linux.vnet.ibm.com>
Cc: linux-crypto@vger.kernel.org,
	Martin Schwidefsky <schwidefsky@de.ibm.com>,
	Ingo Tuchscherer <ingo.tuchscherer@linux.vnet.ibm.com>,
	Hendrik Brueckner <brueckner@de.ibm.com>,
	Gerald Schaefer <gerald.schaefer@de.ibm.com>,
	Harald Freudenberger <freude@de.ibm.com>,
	Harald Freudenberger <freude@linux.vnet.ibm.com>,
	Gerald Schaefer <geraldsc@linux.vnet.ibm.com>
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from e06smtp11.uk.ibm.com ([195.75.94.107]:51439 "EHLO
	e06smtp11.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751702AbbEUIBe (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 21 May 2015 04:01:34 -0400
Received: from /spool/local
	by e06smtp11.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-crypto@vger.kernel.org> from <freude@de.ibm.com>;
	Thu, 21 May 2015 09:01:32 +0100
Received: from b06cxnps3074.portsmouth.uk.ibm.com (d06relay09.portsmouth.uk.ibm.com [9.149.109.194])
	by d06dlp03.portsmouth.uk.ibm.com (Postfix) with ESMTP id 4B7531B08070
	for <linux-crypto@vger.kernel.org>; Thu, 21 May 2015 09:02:19 +0100 (BST)
Received: from d06av09.portsmouth.uk.ibm.com (d06av09.portsmouth.uk.ibm.com [9.149.37.250])
	by b06cxnps3074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id t4L81UXj61734940
	for <linux-crypto@vger.kernel.org>; Thu, 21 May 2015 08:01:30 GMT
Received: from d06av09.portsmouth.uk.ibm.com (localhost [127.0.0.1])
	by d06av09.portsmouth.uk.ibm.com (8.14.4/8.14.4/NCO v10.0 AVout) with ESMTP id t4L81TY9026579
	for <linux-crypto@vger.kernel.org>; Thu, 21 May 2015 02:01:29 -0600
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Multitheaded tests showed that the icv buffer in the current ghash
implementation is not handled correctly. A move of this working ghash
buffer value to the descriptor context fixed this. Code is tested and
verified with an multithreaded application via af_alg interface.

Signed-off-by: Harald Freudenberger <freude@linux.vnet.ibm.com>
Signed-off-by: Gerald Schaefer <geraldsc@linux.vnet.ibm.com>
Reported-by: Herbert Xu <herbert@gondor.apana.org.au>
---
 arch/s390/crypto/ghash_s390.c |   25 +++++++++++++------------
 1 file changed, 13 insertions(+), 12 deletions(-)

diff --git a/arch/s390/crypto/ghash_s390.c b/arch/s390/crypto/ghash_s390.c
index 7940dc9..b258110 100644
--- a/arch/s390/crypto/ghash_s390.c
+++ b/arch/s390/crypto/ghash_s390.c
@@ -16,11 +16,12 @@
 #define GHASH_DIGEST_SIZE	16
 
 struct ghash_ctx {
-	u8 icv[16];
-	u8 key[16];
+	u8 key[GHASH_BLOCK_SIZE];
 };
 
 struct ghash_desc_ctx {
+	u8 icv[GHASH_BLOCK_SIZE];
+	u8 key[GHASH_BLOCK_SIZE];
 	u8 buffer[GHASH_BLOCK_SIZE];
 	u32 bytes;
 };
@@ -28,8 +29,10 @@ struct ghash_desc_ctx {
 static int ghash_init(struct shash_desc *desc)
 {
 	struct ghash_desc_ctx *dctx = shash_desc_ctx(desc);
+	struct ghash_ctx *ctx = crypto_shash_ctx(desc->tfm);
 
 	memset(dctx, 0, sizeof(*dctx));
+	memcpy(dctx->key, ctx->key, GHASH_BLOCK_SIZE);
 
 	return 0;
 }
@@ -45,7 +48,6 @@ static int ghash_setkey(struct crypto_shash *tfm,
 	}
 
 	memcpy(ctx->key, key, GHASH_BLOCK_SIZE);
-	memset(ctx->icv, 0, GHASH_BLOCK_SIZE);
 
 	return 0;
 }
@@ -54,7 +56,6 @@ static int ghash_update(struct shash_desc *desc,
 			 const u8 *src, unsigned int srclen)
 {
 	struct ghash_desc_ctx *dctx = shash_desc_ctx(desc);
-	struct ghash_ctx *ctx = crypto_shash_ctx(desc->tfm);
 	unsigned int n;
 	u8 *buf = dctx->buffer;
 	int ret;
@@ -70,7 +71,7 @@ static int ghash_update(struct shash_desc *desc,
 		src += n;
 
 		if (!dctx->bytes) {
-			ret = crypt_s390_kimd(KIMD_GHASH, ctx, buf,
+			ret = crypt_s390_kimd(KIMD_GHASH, dctx, buf,
 					      GHASH_BLOCK_SIZE);
 			if (ret != GHASH_BLOCK_SIZE)
 				return -EIO;
@@ -79,7 +80,7 @@ static int ghash_update(struct shash_desc *desc,
 
 	n = srclen & ~(GHASH_BLOCK_SIZE - 1);
 	if (n) {
-		ret = crypt_s390_kimd(KIMD_GHASH, ctx, src, n);
+		ret = crypt_s390_kimd(KIMD_GHASH, dctx, src, n);
 		if (ret != n)
 			return -EIO;
 		src += n;
@@ -94,7 +95,7 @@ static int ghash_update(struct shash_desc *desc,
 	return 0;
 }
 
-static int ghash_flush(struct ghash_ctx *ctx, struct ghash_desc_ctx *dctx)
+static int ghash_flush(struct ghash_desc_ctx *dctx)
 {
 	u8 *buf = dctx->buffer;
 	int ret;
@@ -104,24 +105,24 @@ static int ghash_flush(struct ghash_ctx *ctx, struct ghash_desc_ctx *dctx)
 
 		memset(pos, 0, dctx->bytes);
 
-		ret = crypt_s390_kimd(KIMD_GHASH, ctx, buf, GHASH_BLOCK_SIZE);
+		ret = crypt_s390_kimd(KIMD_GHASH, dctx, buf, GHASH_BLOCK_SIZE);
 		if (ret != GHASH_BLOCK_SIZE)
 			return -EIO;
+
+		dctx->bytes = 0;
 	}
 
-	dctx->bytes = 0;
 	return 0;
 }
 
 static int ghash_final(struct shash_desc *desc, u8 *dst)
 {
 	struct ghash_desc_ctx *dctx = shash_desc_ctx(desc);
-	struct ghash_ctx *ctx = crypto_shash_ctx(desc->tfm);
 	int ret;
 
-	ret = ghash_flush(ctx, dctx);
+	ret = ghash_flush(dctx);
 	if (!ret)
-		memcpy(dst, ctx->icv, GHASH_BLOCK_SIZE);
+		memcpy(dst, dctx->icv, GHASH_BLOCK_SIZE);
 	return ret;
 }
 
-- 
1.7.9.5

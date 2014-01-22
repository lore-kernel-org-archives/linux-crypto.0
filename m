From: Harald Freudenberger <freude@linux.vnet.ibm.com>
Subject: [PATCH] crypto: s390 - fix des and des3_ede cbc concurrency issue
Date: Wed, 22 Jan 2014 13:00:04 +0100
Message-ID: <1390392004-4968-1-git-send-email-freude@linux.vnet.ibm.com>
Cc: linux-crypto@vger.kernel.org,
	Martin Schwidefsky <schwidefsky@de.ibm.com>,
	Ingo Tuchscherer <ingo.tuchscherer@linux.vnet.ibm.com>,
	Gerald Schaefer <gerald.schaefer@de.ibm.com>,
	Harald Freudenberger <freude@de.ibm.com>,
	Harald Freudenberger <freude@linux.vnet.ibm.com>
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from e06smtp14.uk.ibm.com ([195.75.94.110]:49273 "EHLO
	e06smtp14.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755161AbaAVMAG (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 22 Jan 2014 07:00:06 -0500
Received: from /spool/local
	by e06smtp14.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-crypto@vger.kernel.org> from <freude@de.ibm.com>;
	Wed, 22 Jan 2014 12:00:03 -0000
Received: from b06cxnps4076.portsmouth.uk.ibm.com (d06relay13.portsmouth.uk.ibm.com [9.149.109.198])
	by d06dlp02.portsmouth.uk.ibm.com (Postfix) with ESMTP id 6CEF5219005E
	for <linux-crypto@vger.kernel.org>; Wed, 22 Jan 2014 12:00:00 +0000 (GMT)
Received: from d06av01.portsmouth.uk.ibm.com (d06av01.portsmouth.uk.ibm.com [9.149.37.212])
	by b06cxnps4076.portsmouth.uk.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id s0MBxnYQ39845928
	for <linux-crypto@vger.kernel.org>; Wed, 22 Jan 2014 11:59:49 GMT
Received: from d06av01.portsmouth.uk.ibm.com (localhost [127.0.0.1])
	by d06av01.portsmouth.uk.ibm.com (8.14.4/8.14.4/NCO v10.0 AVout) with ESMTP id s0MC00Hc028583
	for <linux-crypto@vger.kernel.org>; Wed, 22 Jan 2014 05:00:01 -0700
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

In s390 des and des3_ede cbc mode the iv value is not protected
against concurrency access and modifications from another running
en/decrypt operation which is using the very same tfm struct
instance. This fix copies the iv to the local stack before
the crypto operation and stores the value back when done.

Cc: stable@vger.kernel.org
Signed-off-by: Harald Freudenberger <freude@linux.vnet.ibm.com>
---
 arch/s390/crypto/des_s390.c |   26 ++++++++++++++------------
 1 file changed, 14 insertions(+), 12 deletions(-)

diff --git a/arch/s390/crypto/des_s390.c b/arch/s390/crypto/des_s390.c
index 200f2a1..82a0a2a 100644
--- a/arch/s390/crypto/des_s390.c
+++ b/arch/s390/crypto/des_s390.c
@@ -105,29 +105,35 @@ static int ecb_desall_crypt(struct blkcipher_desc *desc, long func,
 }
 
 static int cbc_desall_crypt(struct blkcipher_desc *desc, long func,
-			    u8 *iv, struct blkcipher_walk *walk)
+			    struct blkcipher_walk *walk)
 {
+	struct s390_des_ctx *ctx = crypto_blkcipher_ctx(desc->tfm);
 	int ret = blkcipher_walk_virt(desc, walk);
 	unsigned int nbytes = walk->nbytes;
+	struct {
+		u8 iv[DES_BLOCK_SIZE];
+		u8 key[DES3_KEY_SIZE];
+	} param;
 
 	if (!nbytes)
 		goto out;
 
-	memcpy(iv, walk->iv, DES_BLOCK_SIZE);
+	memcpy(param.iv, walk->iv, DES_BLOCK_SIZE);
+	memcpy(param.key, ctx->key, DES3_KEY_SIZE);
 	do {
 		/* only use complete blocks */
 		unsigned int n = nbytes & ~(DES_BLOCK_SIZE - 1);
 		u8 *out = walk->dst.virt.addr;
 		u8 *in = walk->src.virt.addr;
 
-		ret = crypt_s390_kmc(func, iv, out, in, n);
+		ret = crypt_s390_kmc(func, &param, out, in, n);
 		if (ret < 0 || ret != n)
 			return -EIO;
 
 		nbytes &= DES_BLOCK_SIZE - 1;
 		ret = blkcipher_walk_done(desc, walk, nbytes);
 	} while ((nbytes = walk->nbytes));
-	memcpy(walk->iv, iv, DES_BLOCK_SIZE);
+	memcpy(walk->iv, param.iv, DES_BLOCK_SIZE);
 
 out:
 	return ret;
@@ -179,22 +185,20 @@ static int cbc_des_encrypt(struct blkcipher_desc *desc,
 			   struct scatterlist *dst, struct scatterlist *src,
 			   unsigned int nbytes)
 {
-	struct s390_des_ctx *ctx = crypto_blkcipher_ctx(desc->tfm);
 	struct blkcipher_walk walk;
 
 	blkcipher_walk_init(&walk, dst, src, nbytes);
-	return cbc_desall_crypt(desc, KMC_DEA_ENCRYPT, ctx->iv, &walk);
+	return cbc_desall_crypt(desc, KMC_DEA_ENCRYPT, &walk);
 }
 
 static int cbc_des_decrypt(struct blkcipher_desc *desc,
 			   struct scatterlist *dst, struct scatterlist *src,
 			   unsigned int nbytes)
 {
-	struct s390_des_ctx *ctx = crypto_blkcipher_ctx(desc->tfm);
 	struct blkcipher_walk walk;
 
 	blkcipher_walk_init(&walk, dst, src, nbytes);
-	return cbc_desall_crypt(desc, KMC_DEA_DECRYPT, ctx->iv, &walk);
+	return cbc_desall_crypt(desc, KMC_DEA_DECRYPT, &walk);
 }
 
 static struct crypto_alg cbc_des_alg = {
@@ -327,22 +331,20 @@ static int cbc_des3_encrypt(struct blkcipher_desc *desc,
 			    struct scatterlist *dst, struct scatterlist *src,
 			    unsigned int nbytes)
 {
-	struct s390_des_ctx *ctx = crypto_blkcipher_ctx(desc->tfm);
 	struct blkcipher_walk walk;
 
 	blkcipher_walk_init(&walk, dst, src, nbytes);
-	return cbc_desall_crypt(desc, KMC_TDEA_192_ENCRYPT, ctx->iv, &walk);
+	return cbc_desall_crypt(desc, KMC_TDEA_192_ENCRYPT, &walk);
 }
 
 static int cbc_des3_decrypt(struct blkcipher_desc *desc,
 			    struct scatterlist *dst, struct scatterlist *src,
 			    unsigned int nbytes)
 {
-	struct s390_des_ctx *ctx = crypto_blkcipher_ctx(desc->tfm);
 	struct blkcipher_walk walk;
 
 	blkcipher_walk_init(&walk, dst, src, nbytes);
-	return cbc_desall_crypt(desc, KMC_TDEA_192_DECRYPT, ctx->iv, &walk);
+	return cbc_desall_crypt(desc, KMC_TDEA_192_DECRYPT, &walk);
 }
 
 static struct crypto_alg cbc_des3_alg = {
-- 
1.7.9.5

From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: [v3 PATCH 2/16] crypto: aes-ce-ccm - Use skcipher walk interface
Date: Tue, 22 Nov 2016 20:08:14 +0800
Message-ID: <E1c99ry-00037A-KQ@gondobar>
References: <20161122120703.GA11911@gondor.apana.org.au>
To: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:32931 "EHLO
        helcar.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S932532AbcKVMI1 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 22 Nov 2016 07:08:27 -0500
Received: from [192.168.128.4] (helo=gondobar)
        by fornost.hengli.com.au with esmtp (Exim 4.80 #3 (Debian))
        id 1c99s6-00060M-Gm
        for <linux-crypto@vger.kernel.org>; Tue, 22 Nov 2016 23:08:24 +1100
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

This patch makes use of the new skcipher walk interface instead of
the obsolete blkcipher walk interface.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
---

 arch/arm64/crypto/aes-ce-ccm-glue.c |   50 +++++++++---------------------------
 1 file changed, 13 insertions(+), 37 deletions(-)

diff --git a/arch/arm64/crypto/aes-ce-ccm-glue.c b/arch/arm64/crypto/aes-ce-ccm-glue.c
index f4bf2f2..d4f3568 100644
--- a/arch/arm64/crypto/aes-ce-ccm-glue.c
+++ b/arch/arm64/crypto/aes-ce-ccm-glue.c
@@ -11,9 +11,9 @@
 #include <asm/neon.h>
 #include <asm/unaligned.h>
 #include <crypto/aes.h>
-#include <crypto/algapi.h>
 #include <crypto/scatterwalk.h>
 #include <crypto/internal/aead.h>
+#include <crypto/internal/skcipher.h>
 #include <linux/module.h>
 
 #include "aes-ce-setkey.h"
@@ -149,12 +149,7 @@ static int ccm_encrypt(struct aead_request *req)
 {
 	struct crypto_aead *aead = crypto_aead_reqtfm(req);
 	struct crypto_aes_ctx *ctx = crypto_aead_ctx(aead);
-	struct blkcipher_desc desc = { .info = req->iv };
-	struct blkcipher_walk walk;
-	struct scatterlist srcbuf[2];
-	struct scatterlist dstbuf[2];
-	struct scatterlist *src;
-	struct scatterlist *dst;
+	struct skcipher_walk walk;
 	u8 __aligned(8) mac[AES_BLOCK_SIZE];
 	u8 buf[AES_BLOCK_SIZE];
 	u32 len = req->cryptlen;
@@ -172,27 +167,19 @@ static int ccm_encrypt(struct aead_request *req)
 	/* preserve the original iv for the final round */
 	memcpy(buf, req->iv, AES_BLOCK_SIZE);
 
-	src = scatterwalk_ffwd(srcbuf, req->src, req->assoclen);
-	dst = src;
-	if (req->src != req->dst)
-		dst = scatterwalk_ffwd(dstbuf, req->dst, req->assoclen);
-
-	blkcipher_walk_init(&walk, dst, src, len);
-	err = blkcipher_aead_walk_virt_block(&desc, &walk, aead,
-					     AES_BLOCK_SIZE);
+	err = skcipher_walk_aead(&walk, req, true);
 
 	while (walk.nbytes) {
 		u32 tail = walk.nbytes % AES_BLOCK_SIZE;
 
-		if (walk.nbytes == len)
+		if (walk.nbytes == walk.total)
 			tail = 0;
 
 		ce_aes_ccm_encrypt(walk.dst.virt.addr, walk.src.virt.addr,
 				   walk.nbytes - tail, ctx->key_enc,
 				   num_rounds(ctx), mac, walk.iv);
 
-		len -= walk.nbytes - tail;
-		err = blkcipher_walk_done(&desc, &walk, tail);
+		err = skcipher_walk_done(&walk, tail);
 	}
 	if (!err)
 		ce_aes_ccm_final(mac, buf, ctx->key_enc, num_rounds(ctx));
@@ -203,7 +190,7 @@ static int ccm_encrypt(struct aead_request *req)
 		return err;
 
 	/* copy authtag to end of dst */
-	scatterwalk_map_and_copy(mac, dst, req->cryptlen,
+	scatterwalk_map_and_copy(mac, req->dst, req->assoclen + req->cryptlen,
 				 crypto_aead_authsize(aead), 1);
 
 	return 0;
@@ -214,12 +201,7 @@ static int ccm_decrypt(struct aead_request *req)
 	struct crypto_aead *aead = crypto_aead_reqtfm(req);
 	struct crypto_aes_ctx *ctx = crypto_aead_ctx(aead);
 	unsigned int authsize = crypto_aead_authsize(aead);
-	struct blkcipher_desc desc = { .info = req->iv };
-	struct blkcipher_walk walk;
-	struct scatterlist srcbuf[2];
-	struct scatterlist dstbuf[2];
-	struct scatterlist *src;
-	struct scatterlist *dst;
+	struct skcipher_walk walk;
 	u8 __aligned(8) mac[AES_BLOCK_SIZE];
 	u8 buf[AES_BLOCK_SIZE];
 	u32 len = req->cryptlen - authsize;
@@ -237,27 +219,19 @@ static int ccm_decrypt(struct aead_request *req)
 	/* preserve the original iv for the final round */
 	memcpy(buf, req->iv, AES_BLOCK_SIZE);
 
-	src = scatterwalk_ffwd(srcbuf, req->src, req->assoclen);
-	dst = src;
-	if (req->src != req->dst)
-		dst = scatterwalk_ffwd(dstbuf, req->dst, req->assoclen);
-
-	blkcipher_walk_init(&walk, dst, src, len);
-	err = blkcipher_aead_walk_virt_block(&desc, &walk, aead,
-					     AES_BLOCK_SIZE);
+	err = skcipher_walk_aead(&walk, req, true);
 
 	while (walk.nbytes) {
 		u32 tail = walk.nbytes % AES_BLOCK_SIZE;
 
-		if (walk.nbytes == len)
+		if (walk.nbytes == walk.total)
 			tail = 0;
 
 		ce_aes_ccm_decrypt(walk.dst.virt.addr, walk.src.virt.addr,
 				   walk.nbytes - tail, ctx->key_enc,
 				   num_rounds(ctx), mac, walk.iv);
 
-		len -= walk.nbytes - tail;
-		err = blkcipher_walk_done(&desc, &walk, tail);
+		err = skcipher_walk_done(&walk, tail);
 	}
 	if (!err)
 		ce_aes_ccm_final(mac, buf, ctx->key_enc, num_rounds(ctx));
@@ -268,7 +242,8 @@ static int ccm_decrypt(struct aead_request *req)
 		return err;
 
 	/* compare calculated auth tag with the stored one */
-	scatterwalk_map_and_copy(buf, src, req->cryptlen - authsize,
+	scatterwalk_map_and_copy(buf, req->src,
+				 req->assoclen + req->cryptlen - authsize,
 				 authsize, 0);
 
 	if (crypto_memneq(mac, buf, authsize))
@@ -287,6 +262,7 @@ static int ccm_decrypt(struct aead_request *req)
 		.cra_module		= THIS_MODULE,
 	},
 	.ivsize		= AES_BLOCK_SIZE,
+	.chunksize	= AES_BLOCK_SIZE,
 	.maxauthsize	= AES_BLOCK_SIZE,
 	.setkey		= ccm_setkey,
 	.setauthsize	= ccm_setauthsize,

Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C8D4BCD68F4
	for <linux-crypto@archiver.kernel.org>; Tue, 10 Oct 2023 06:00:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1442192AbjJJGAW (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 10 Oct 2023 02:00:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57282 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1442203AbjJJGAQ (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 10 Oct 2023 02:00:16 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6D379D3
        for <linux-crypto@vger.kernel.org>; Mon,  9 Oct 2023 23:00:13 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E0A6FC433C8
        for <linux-crypto@vger.kernel.org>; Tue, 10 Oct 2023 06:00:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1696917613;
        bh=9+EzdIMfmewHQc56uTm3af6Boi0nyCFJ6xrsJaR+hfE=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=KTkVqFopukJNAiK17oqIMmOXGU2G6ooJLPmvMV3QB4zw7iavmJGYIRuiNcjo3JuEO
         IFOFOUISDOvEzOzDAL3aN5Yn7c5EkL20dbs5rCx62mCKzUi+W3Qx2V+2qfXLr7ItzL
         a7+TP5g0euvE3S8UEoJZLAjGSXUB81kfW9OzoJoLAum6isyI/2GTGXsYC5xwWxt40U
         bYInRFTHhQYLolWRbYnQlNFttST0TXij39OxGVZWnr7Ka7d7TOqUqdkuVWYXi6HNDL
         H+Za7deyfRvBzxicU2kZPJIBbn1rIQ0IGHkUDgclVpu8/Uqps4KXzgKzqMYZwoz9oU
         USLp2OvvbbRRg==
From:   Eric Biggers <ebiggers@kernel.org>
To:     linux-crypto@vger.kernel.org
Subject: [PATCH 1/4] crypto: adiantum - add fast path for single-page messages
Date:   Mon,  9 Oct 2023 22:59:43 -0700
Message-ID: <20231010055946.263981-2-ebiggers@kernel.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231010055946.263981-1-ebiggers@kernel.org>
References: <20231010055946.263981-1-ebiggers@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

From: Eric Biggers <ebiggers@google.com>

When the source scatterlist is a single page, optimize the first hash
step of adiantum to use crypto_shash_digest() instead of
init/update/final, and use the same local kmap for both hashing the bulk
part and loading the narrow part of the source data.

Likewise, when the destination scatterlist is a single page, optimize
the second hash step of adiantum to use crypto_shash_digest() instead of
init/update/final, and use the same local kmap for both hashing the bulk
part and storing the narrow part of the destination data.

In some cases these optimizations improve performance significantly.

Note: ideally, for optimal performance each architecture should
implement the full "adiantum(xchacha12,aes)" algorithm and fully
optimize the contiguous buffer case to use no indirect calls.  That's
not something I've gotten around to doing, though.  This commit just
makes a relatively small change that provides some benefit with the
existing template-based approach.

Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 crypto/adiantum.c | 65 ++++++++++++++++++++++++++++++++++-------------
 1 file changed, 47 insertions(+), 18 deletions(-)

diff --git a/crypto/adiantum.c b/crypto/adiantum.c
index c33ba22a66389..cd2b8f5042dc9 100644
--- a/crypto/adiantum.c
+++ b/crypto/adiantum.c
@@ -238,39 +238,35 @@ static void adiantum_hash_header(struct skcipher_request *req)
 
 	BUILD_BUG_ON(TWEAK_SIZE % POLY1305_BLOCK_SIZE != 0);
 	poly1305_core_blocks(&state, &tctx->header_hash_key, req->iv,
 			     TWEAK_SIZE / POLY1305_BLOCK_SIZE, 1);
 
 	poly1305_core_emit(&state, NULL, &rctx->header_hash);
 }
 
 /* Hash the left-hand part (the "bulk") of the message using NHPoly1305 */
 static int adiantum_hash_message(struct skcipher_request *req,
-				 struct scatterlist *sgl, le128 *digest)
+				 struct scatterlist *sgl, unsigned int nents,
+				 le128 *digest)
 {
-	struct crypto_skcipher *tfm = crypto_skcipher_reqtfm(req);
-	const struct adiantum_tfm_ctx *tctx = crypto_skcipher_ctx(tfm);
 	struct adiantum_request_ctx *rctx = skcipher_request_ctx(req);
 	const unsigned int bulk_len = req->cryptlen - BLOCKCIPHER_BLOCK_SIZE;
 	struct shash_desc *hash_desc = &rctx->u.hash_desc;
 	struct sg_mapping_iter miter;
 	unsigned int i, n;
 	int err;
 
-	hash_desc->tfm = tctx->hash;
-
 	err = crypto_shash_init(hash_desc);
 	if (err)
 		return err;
 
-	sg_miter_start(&miter, sgl, sg_nents(sgl),
-		       SG_MITER_FROM_SG | SG_MITER_ATOMIC);
+	sg_miter_start(&miter, sgl, nents, SG_MITER_FROM_SG | SG_MITER_ATOMIC);
 	for (i = 0; i < bulk_len; i += n) {
 		sg_miter_next(&miter);
 		n = min_t(unsigned int, miter.length, bulk_len - i);
 		err = crypto_shash_update(hash_desc, miter.addr, n);
 		if (err)
 			break;
 	}
 	sg_miter_stop(&miter);
 	if (err)
 		return err;
@@ -278,80 +274,113 @@ static int adiantum_hash_message(struct skcipher_request *req,
 	return crypto_shash_final(hash_desc, (u8 *)digest);
 }
 
 /* Continue Adiantum encryption/decryption after the stream cipher step */
 static int adiantum_finish(struct skcipher_request *req)
 {
 	struct crypto_skcipher *tfm = crypto_skcipher_reqtfm(req);
 	const struct adiantum_tfm_ctx *tctx = crypto_skcipher_ctx(tfm);
 	struct adiantum_request_ctx *rctx = skcipher_request_ctx(req);
 	const unsigned int bulk_len = req->cryptlen - BLOCKCIPHER_BLOCK_SIZE;
+	struct scatterlist *dst = req->dst;
+	const unsigned int dst_nents = sg_nents(dst);
 	le128 digest;
 	int err;
 
 	/* If decrypting, decrypt C_M with the block cipher to get P_M */
 	if (!rctx->enc)
 		crypto_cipher_decrypt_one(tctx->blockcipher, rctx->rbuf.bytes,
 					  rctx->rbuf.bytes);
 
 	/*
 	 * Second hash step
 	 *	enc: C_R = C_M - H_{K_H}(T, C_L)
 	 *	dec: P_R = P_M - H_{K_H}(T, P_L)
 	 */
-	err = adiantum_hash_message(req, req->dst, &digest);
-	if (err)
-		return err;
-	le128_add(&digest, &digest, &rctx->header_hash);
-	le128_sub(&rctx->rbuf.bignum, &rctx->rbuf.bignum, &digest);
-	scatterwalk_map_and_copy(&rctx->rbuf.bignum, req->dst,
-				 bulk_len, BLOCKCIPHER_BLOCK_SIZE, 1);
+	rctx->u.hash_desc.tfm = tctx->hash;
+	le128_sub(&rctx->rbuf.bignum, &rctx->rbuf.bignum, &rctx->header_hash);
+	if (dst_nents == 1 && dst->offset + req->cryptlen <= PAGE_SIZE) {
+		/* Fast path for single-page destination */
+		void *virt = kmap_local_page(sg_page(dst)) + dst->offset;
+
+		err = crypto_shash_digest(&rctx->u.hash_desc, virt, bulk_len,
+					  (u8 *)&digest);
+		if (err) {
+			kunmap_local(virt);
+			return err;
+		}
+		le128_sub(&rctx->rbuf.bignum, &rctx->rbuf.bignum, &digest);
+		memcpy(virt + bulk_len, &rctx->rbuf.bignum, sizeof(le128));
+		kunmap_local(virt);
+	} else {
+		/* Slow path that works for any destination scatterlist */
+		err = adiantum_hash_message(req, dst, dst_nents, &digest);
+		if (err)
+			return err;
+		le128_sub(&rctx->rbuf.bignum, &rctx->rbuf.bignum, &digest);
+		scatterwalk_map_and_copy(&rctx->rbuf.bignum, dst,
+					 bulk_len, sizeof(le128), 1);
+	}
 	return 0;
 }
 
 static void adiantum_streamcipher_done(void *data, int err)
 {
 	struct skcipher_request *req = data;
 
 	if (!err)
 		err = adiantum_finish(req);
 
 	skcipher_request_complete(req, err);
 }
 
 static int adiantum_crypt(struct skcipher_request *req, bool enc)
 {
 	struct crypto_skcipher *tfm = crypto_skcipher_reqtfm(req);
 	const struct adiantum_tfm_ctx *tctx = crypto_skcipher_ctx(tfm);
 	struct adiantum_request_ctx *rctx = skcipher_request_ctx(req);
 	const unsigned int bulk_len = req->cryptlen - BLOCKCIPHER_BLOCK_SIZE;
+	struct scatterlist *src = req->src;
+	const unsigned int src_nents = sg_nents(src);
 	unsigned int stream_len;
 	le128 digest;
 	int err;
 
 	if (req->cryptlen < BLOCKCIPHER_BLOCK_SIZE)
 		return -EINVAL;
 
 	rctx->enc = enc;
 
 	/*
 	 * First hash step
 	 *	enc: P_M = P_R + H_{K_H}(T, P_L)
 	 *	dec: C_M = C_R + H_{K_H}(T, C_L)
 	 */
 	adiantum_hash_header(req);
-	err = adiantum_hash_message(req, req->src, &digest);
+	rctx->u.hash_desc.tfm = tctx->hash;
+	if (src_nents == 1 && src->offset + req->cryptlen <= PAGE_SIZE) {
+		/* Fast path for single-page source */
+		void *virt = kmap_local_page(sg_page(src)) + src->offset;
+
+		err = crypto_shash_digest(&rctx->u.hash_desc, virt, bulk_len,
+					  (u8 *)&digest);
+		memcpy(&rctx->rbuf.bignum, virt + bulk_len, sizeof(le128));
+		kunmap_local(virt);
+	} else {
+		/* Slow path that works for any source scatterlist */
+		err = adiantum_hash_message(req, src, src_nents, &digest);
+		scatterwalk_map_and_copy(&rctx->rbuf.bignum, src,
+					 bulk_len, sizeof(le128), 0);
+	}
 	if (err)
 		return err;
-	le128_add(&digest, &digest, &rctx->header_hash);
-	scatterwalk_map_and_copy(&rctx->rbuf.bignum, req->src,
-				 bulk_len, BLOCKCIPHER_BLOCK_SIZE, 0);
+	le128_add(&rctx->rbuf.bignum, &rctx->rbuf.bignum, &rctx->header_hash);
 	le128_add(&rctx->rbuf.bignum, &rctx->rbuf.bignum, &digest);
 
 	/* If encrypting, encrypt P_M with the block cipher to get C_M */
 	if (enc)
 		crypto_cipher_encrypt_one(tctx->blockcipher, rctx->rbuf.bytes,
 					  rctx->rbuf.bytes);
 
 	/* Initialize the rest of the XChaCha IV (first part is C_M) */
 	BUILD_BUG_ON(BLOCKCIPHER_BLOCK_SIZE != 16);
 	BUILD_BUG_ON(XCHACHA_IV_SIZE != 32);	/* nonce || stream position */
-- 
2.42.0


Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.0 required=3.0 tests=BAYES_00,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 43637C4361B
	for <linux-crypto@archiver.kernel.org>; Sat, 12 Dec 2020 10:04:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1937D207C9
	for <linux-crypto@archiver.kernel.org>; Sat, 12 Dec 2020 10:04:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2438551AbgLLKDU (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Sat, 12 Dec 2020 05:03:20 -0500
Received: from mail.kernel.org ([198.145.29.99]:58842 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2407231AbgLLJy2 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Sat, 12 Dec 2020 04:54:28 -0500
From:   Ard Biesheuvel <ardb@kernel.org>
Authentication-Results: mail.kernel.org; dkim=permerror (bad message/signature format)
To:     linux-crypto@vger.kernel.org
Cc:     Ard Biesheuvel <ardb@kernel.org>,
        Eric Biggers <ebiggers@google.com>,
        Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 4/4] crypto: x86/gcm-aes-ni - refactor scatterlist processing
Date:   Sat, 12 Dec 2020 10:17:00 +0100
Message-Id: <20201212091700.11776-5-ardb@kernel.org>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20201212091700.11776-1-ardb@kernel.org>
References: <20201212091700.11776-1-ardb@kernel.org>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Currently, the gcm(aes-ni) driver open codes the scatterlist handling
that is encapsulated by the skcipher walk API. So let's switch to that
instead.

Also, move the handling at the end of gcmaes_crypt_by_sg() that is
dependent on whether we are encrypting or decrypting into the callers,
which always do one or the other.

Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
---
 arch/x86/crypto/aesni-intel_glue.c | 144 ++++++++------------
 1 file changed, 58 insertions(+), 86 deletions(-)

diff --git a/arch/x86/crypto/aesni-intel_glue.c b/arch/x86/crypto/aesni-intel_glue.c
index e5c4d0cce828..b0a13ab2f70b 100644
--- a/arch/x86/crypto/aesni-intel_glue.c
+++ b/arch/x86/crypto/aesni-intel_glue.c
@@ -731,25 +731,18 @@ static int generic_gcmaes_set_authsize(struct crypto_aead *tfm,
 
 static int gcmaes_crypt_by_sg(bool enc, struct aead_request *req,
 			      unsigned int assoclen, u8 *hash_subkey,
-			      u8 *iv, void *aes_ctx)
+			      u8 *iv, void *aes_ctx, u8 *auth_tag,
+			      unsigned long auth_tag_len)
 {
-	struct crypto_aead *tfm = crypto_aead_reqtfm(req);
-	unsigned long auth_tag_len = crypto_aead_authsize(tfm);
 	const struct aesni_gcm_tfm_s *gcm_tfm = aesni_gcm_tfm;
 	u8 databuf[sizeof(struct gcm_context_data) + (AESNI_ALIGN - 8)] __aligned(8);
 	struct gcm_context_data *data = PTR_ALIGN((void *)databuf, AESNI_ALIGN);
-	struct scatter_walk dst_sg_walk = {};
 	unsigned long left = req->cryptlen;
-	unsigned long len, srclen, dstlen;
 	struct scatter_walk assoc_sg_walk;
-	struct scatter_walk src_sg_walk;
-	struct scatterlist src_start[2];
-	struct scatterlist dst_start[2];
-	struct scatterlist *src_sg;
-	struct scatterlist *dst_sg;
-	u8 *src, *dst, *assoc;
+	struct skcipher_walk walk;
 	u8 *assocmem = NULL;
-	u8 authTag[16];
+	u8 *assoc;
+	int err;
 
 	if (!enc)
 		left -= auth_tag_len;
@@ -776,61 +769,27 @@ static int gcmaes_crypt_by_sg(bool enc, struct aead_request *req,
 		scatterwalk_map_and_copy(assoc, req->src, 0, assoclen, 0);
 	}
 
-	if (left) {
-		src_sg = scatterwalk_ffwd(src_start, req->src, req->assoclen);
-		scatterwalk_start(&src_sg_walk, src_sg);
-		if (req->src != req->dst) {
-			dst_sg = scatterwalk_ffwd(dst_start, req->dst,
-						  req->assoclen);
-			scatterwalk_start(&dst_sg_walk, dst_sg);
-		}
-	}
+	err = enc ? skcipher_walk_aead_encrypt(&walk, req, false)
+		  : skcipher_walk_aead_decrypt(&walk, req, false);
+	if (err)
+		return err;
 
 	kernel_fpu_begin();
 	gcm_tfm->init(aes_ctx, data, iv, hash_subkey, assoc, assoclen);
-	if (req->src != req->dst) {
-		while (left) {
-			src = scatterwalk_map(&src_sg_walk);
-			dst = scatterwalk_map(&dst_sg_walk);
-			srclen = scatterwalk_clamp(&src_sg_walk, left);
-			dstlen = scatterwalk_clamp(&dst_sg_walk, left);
-			len = min(srclen, dstlen);
-			if (len) {
-				if (enc)
-					gcm_tfm->enc_update(aes_ctx, data,
-							     dst, src, len);
-				else
-					gcm_tfm->dec_update(aes_ctx, data,
-							     dst, src, len);
-			}
-			left -= len;
-
-			scatterwalk_unmap(src);
-			scatterwalk_unmap(dst);
-			scatterwalk_advance(&src_sg_walk, len);
-			scatterwalk_advance(&dst_sg_walk, len);
-			scatterwalk_done(&src_sg_walk, 0, left);
-			scatterwalk_done(&dst_sg_walk, 1, left);
-		}
-	} else {
-		while (left) {
-			dst = src = scatterwalk_map(&src_sg_walk);
-			len = scatterwalk_clamp(&src_sg_walk, left);
-			if (len) {
-				if (enc)
-					gcm_tfm->enc_update(aes_ctx, data,
-							     src, src, len);
-				else
-					gcm_tfm->dec_update(aes_ctx, data,
-							     src, src, len);
-			}
-			left -= len;
-			scatterwalk_unmap(src);
-			scatterwalk_advance(&src_sg_walk, len);
-			scatterwalk_done(&src_sg_walk, 1, left);
-		}
+
+	while (walk.nbytes > 0) {
+		(enc ? gcm_tfm->enc_update
+		     : gcm_tfm->dec_update)(aes_ctx, data, walk.dst.virt.addr,
+					    walk.src.virt.addr, walk.nbytes);
+		kernel_fpu_end();
+
+		err = skcipher_walk_done(&walk, 0);
+		if (err)
+			return err;
+
+		kernel_fpu_begin();
 	}
-	gcm_tfm->finalize(aes_ctx, data, authTag, auth_tag_len);
+	gcm_tfm->finalize(aes_ctx, data, auth_tag, auth_tag_len);
 	kernel_fpu_end();
 
 	if (!assocmem)
@@ -838,40 +797,53 @@ static int gcmaes_crypt_by_sg(bool enc, struct aead_request *req,
 	else
 		kfree(assocmem);
 
-	if (!enc) {
-		u8 authTagMsg[16];
-
-		/* Copy out original authTag */
-		scatterwalk_map_and_copy(authTagMsg, req->src,
-					 req->assoclen + req->cryptlen -
-					 auth_tag_len,
-					 auth_tag_len, 0);
-
-		/* Compare generated tag with passed in tag. */
-		return crypto_memneq(authTagMsg, authTag, auth_tag_len) ?
-			-EBADMSG : 0;
-	}
-
-	/* Copy in the authTag */
-	scatterwalk_map_and_copy(authTag, req->dst,
-				 req->assoclen + req->cryptlen,
-				 auth_tag_len, 1);
-
 	return 0;
 }
 
 static int gcmaes_encrypt(struct aead_request *req, unsigned int assoclen,
 			  u8 *hash_subkey, u8 *iv, void *aes_ctx)
 {
-	return gcmaes_crypt_by_sg(true, req, assoclen, hash_subkey, iv,
-				aes_ctx);
+	struct crypto_aead *tfm = crypto_aead_reqtfm(req);
+	unsigned long auth_tag_len = crypto_aead_authsize(tfm);
+	u8 auth_tag[16];
+	int err;
+
+	err = gcmaes_crypt_by_sg(true, req, assoclen, hash_subkey, iv, aes_ctx,
+				 auth_tag, auth_tag_len);
+	if (err)
+		return err;
+
+	scatterwalk_map_and_copy(auth_tag, req->dst,
+				 req->assoclen + req->cryptlen,
+				 auth_tag_len, 1);
+	return 0;
 }
 
 static int gcmaes_decrypt(struct aead_request *req, unsigned int assoclen,
 			  u8 *hash_subkey, u8 *iv, void *aes_ctx)
 {
-	return gcmaes_crypt_by_sg(false, req, assoclen, hash_subkey, iv,
-				aes_ctx);
+	struct crypto_aead *tfm = crypto_aead_reqtfm(req);
+	unsigned long auth_tag_len = crypto_aead_authsize(tfm);
+	u8 auth_tag_msg[16];
+	u8 auth_tag[16];
+	int err;
+
+	err = gcmaes_crypt_by_sg(false, req, assoclen, hash_subkey, iv, aes_ctx,
+				 auth_tag, auth_tag_len);
+	if (err)
+		return err;
+
+	/* Copy out original auth_tag */
+	scatterwalk_map_and_copy(auth_tag_msg, req->src,
+				 req->assoclen + req->cryptlen - auth_tag_len,
+				 auth_tag_len, 0);
+
+	/* Compare generated tag with passed in tag. */
+	if (crypto_memneq(auth_tag_msg, auth_tag, auth_tag_len)) {
+		memzero_explicit(auth_tag, sizeof(auth_tag));
+		return -EBADMSG;
+	}
+	return 0;
 }
 
 static int helper_rfc4106_encrypt(struct aead_request *req)
-- 
2.17.1


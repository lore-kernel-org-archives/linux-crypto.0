Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-19.2 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A4C16C433DB
	for <linux-crypto@archiver.kernel.org>; Mon,  4 Jan 2021 15:57:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 737F420757
	for <linux-crypto@archiver.kernel.org>; Mon,  4 Jan 2021 15:57:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727660AbhADP4w (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 4 Jan 2021 10:56:52 -0500
Received: from mail.kernel.org ([198.145.29.99]:35942 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727608AbhADP4v (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 4 Jan 2021 10:56:51 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7877F224D2;
        Mon,  4 Jan 2021 15:56:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1609775770;
        bh=7oWsuBpsZHeWCJM8qaYLobeZNgJLjLxgrqWFoLxJrVs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=j5erBpYNTohno9FpojfUyV1dlUVNV8HVWMfPAHGeUv7i8Gn4BsalRKjmXvdeoM+34
         bvtGYLDqxn/T+MNkdm8O+R1B5fSwTldcvXeN2RxRmo1GIAZiB6i2aQedHUqueXOy1h
         n5EQBGewCjBE7DgqrR6VVCIbLasIzWW572ec2vtXdolIQMADPbQVzmRW5KUgT2ap50
         8omHplGM4bxCUp+HOt1jQdtL1v7l1YcOO8xeQIg+eCQgpd+owQkB8y4o1Wf4ETI9Wj
         86YEjmiH0xktODiHt3bvd8Kbn3NbV2kNJgS8C2qukVSpnTsOwwRkrNHzP83kBBhIOM
         GrYgEwcaNXIEQ==
From:   Ard Biesheuvel <ardb@kernel.org>
To:     linux-crypto@vger.kernel.org
Cc:     Ard Biesheuvel <ardb@kernel.org>, Megha Dey <megha.dey@intel.com>,
        Eric Biggers <ebiggers@google.com>,
        Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH v2 4/5] crypto: x86/gcm-aes-ni - refactor scatterlist processing
Date:   Mon,  4 Jan 2021 16:55:49 +0100
Message-Id: <20210104155550.6359-5-ardb@kernel.org>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210104155550.6359-1-ardb@kernel.org>
References: <20210104155550.6359-1-ardb@kernel.org>
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
 arch/x86/crypto/aesni-intel_glue.c | 139 ++++++++------------
 1 file changed, 56 insertions(+), 83 deletions(-)

diff --git a/arch/x86/crypto/aesni-intel_glue.c b/arch/x86/crypto/aesni-intel_glue.c
index 26b012065701..d0b4fa7bd2d0 100644
--- a/arch/x86/crypto/aesni-intel_glue.c
+++ b/arch/x86/crypto/aesni-intel_glue.c
@@ -638,25 +638,18 @@ static int generic_gcmaes_set_authsize(struct crypto_aead *tfm,
 
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
@@ -683,61 +676,8 @@ static int gcmaes_crypt_by_sg(bool enc, struct aead_request *req,
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
-
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
-	}
-	gcm_tfm->finalize(aes_ctx, data, authTag, auth_tag_len);
 	kernel_fpu_end();
 
 	if (!assocmem)
@@ -745,24 +685,25 @@ static int gcmaes_crypt_by_sg(bool enc, struct aead_request *req,
 	else
 		kfree(assocmem);
 
-	if (!enc) {
-		u8 authTagMsg[16];
+	err = enc ? skcipher_walk_aead_encrypt(&walk, req, false)
+		  : skcipher_walk_aead_decrypt(&walk, req, false);
 
-		/* Copy out original authTag */
-		scatterwalk_map_and_copy(authTagMsg, req->src,
-					 req->assoclen + req->cryptlen -
-					 auth_tag_len,
-					 auth_tag_len, 0);
+	while (walk.nbytes > 0) {
+		kernel_fpu_begin();
+		(enc ? gcm_tfm->enc_update
+		     : gcm_tfm->dec_update)(aes_ctx, data, walk.dst.virt.addr,
+					    walk.src.virt.addr, walk.nbytes);
+		kernel_fpu_end();
 
-		/* Compare generated tag with passed in tag. */
-		return crypto_memneq(authTagMsg, authTag, auth_tag_len) ?
-			-EBADMSG : 0;
+		err = skcipher_walk_done(&walk, 0);
 	}
 
-	/* Copy in the authTag */
-	scatterwalk_map_and_copy(authTag, req->dst,
-				 req->assoclen + req->cryptlen,
-				 auth_tag_len, 1);
+	if (err)
+		return err;
+
+	kernel_fpu_begin();
+	gcm_tfm->finalize(aes_ctx, data, auth_tag, auth_tag_len);
+	kernel_fpu_end();
 
 	return 0;
 }
@@ -770,15 +711,47 @@ static int gcmaes_crypt_by_sg(bool enc, struct aead_request *req,
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


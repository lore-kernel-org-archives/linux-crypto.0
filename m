Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5B5DBC63697
	for <linux-crypto@archiver.kernel.org>; Tue, 17 Nov 2020 13:50:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id F403E24699
	for <linux-crypto@archiver.kernel.org>; Tue, 17 Nov 2020 13:50:48 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="XcH/5Ntl"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732663AbgKQNuR (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 17 Nov 2020 08:50:17 -0500
Received: from mail.kernel.org ([198.145.29.99]:42556 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731881AbgKQNcp (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 17 Nov 2020 08:32:45 -0500
Received: from e123331-lin.nice.arm.com (lfbn-nic-1-188-42.w2-15.abo.wanadoo.fr [2.15.37.42])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3246B21534;
        Tue, 17 Nov 2020 13:32:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605619964;
        bh=OV0VFiGCk8/dpDYsWACppJsvTGvmR1MzOzEu7Oxt4Yg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XcH/5Ntltc/B1+Hpl2KptxkHlc4KDjHW6rgTkn98fs5tXlVQ8vD01GzdzdhBMOD1y
         VN+RJhzMoRZCQWWeJUkBCHIaWSiW/xG1qlGAUdk9anfRneBcSxxuBUoid+8rW7EScR
         5LzVIuDXo8JbgRShFgE6cWSuRkVl7VRfaKadp7+g=
From:   Ard Biesheuvel <ardb@kernel.org>
To:     linux-crypto@vger.kernel.org
Cc:     herbert@gondor.apana.org.au, linux-arm-kernel@lists.infradead.org,
        Ard Biesheuvel <ardb@kernel.org>,
        Ondrej Mosnacek <omosnacek@gmail.com>,
        Eric Biggers <ebiggers@kernel.org>
Subject: [PATCH v3 4/4] crypto: aegis128 - expose SIMD code path as separate driver
Date:   Tue, 17 Nov 2020 14:32:14 +0100
Message-Id: <20201117133214.29114-5-ardb@kernel.org>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20201117133214.29114-1-ardb@kernel.org>
References: <20201117133214.29114-1-ardb@kernel.org>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Wiring the SIMD code into the generic driver has the unfortunate side
effect that the tcrypt testing code cannot distinguish them, and will
therefore not use the latter to fuzz test the former, as it does for
other algorithms.

So let's refactor the code a bit so we can register two implementations:
aegis128-generic and aegis128-simd.

Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
---
 crypto/aegis128-core.c | 220 +++++++++++++-------
 1 file changed, 143 insertions(+), 77 deletions(-)

diff --git a/crypto/aegis128-core.c b/crypto/aegis128-core.c
index 859c7b905618..2b05f79475d3 100644
--- a/crypto/aegis128-core.c
+++ b/crypto/aegis128-core.c
@@ -86,9 +86,10 @@ static void crypto_aegis128_update(struct aegis_state *state)
 }
 
 static void crypto_aegis128_update_a(struct aegis_state *state,
-				     const union aegis_block *msg)
+				     const union aegis_block *msg,
+				     bool do_simd)
 {
-	if (aegis128_do_simd()) {
+	if (do_simd) {
 		crypto_aegis128_update_simd(state, msg);
 		return;
 	}
@@ -97,9 +98,10 @@ static void crypto_aegis128_update_a(struct aegis_state *state,
 	crypto_aegis_block_xor(&state->blocks[0], msg);
 }
 
-static void crypto_aegis128_update_u(struct aegis_state *state, const void *msg)
+static void crypto_aegis128_update_u(struct aegis_state *state, const void *msg,
+				     bool do_simd)
 {
-	if (aegis128_do_simd()) {
+	if (do_simd) {
 		crypto_aegis128_update_simd(state, msg);
 		return;
 	}
@@ -128,27 +130,28 @@ static void crypto_aegis128_init(struct aegis_state *state,
 	crypto_aegis_block_xor(&state->blocks[4], &crypto_aegis_const[1]);
 
 	for (i = 0; i < 5; i++) {
-		crypto_aegis128_update_a(state, key);
-		crypto_aegis128_update_a(state, &key_iv);
+		crypto_aegis128_update_a(state, key, false);
+		crypto_aegis128_update_a(state, &key_iv, false);
 	}
 }
 
 static void crypto_aegis128_ad(struct aegis_state *state,
-			       const u8 *src, unsigned int size)
+			       const u8 *src, unsigned int size,
+			       bool do_simd)
 {
 	if (AEGIS_ALIGNED(src)) {
 		const union aegis_block *src_blk =
 				(const union aegis_block *)src;
 
 		while (size >= AEGIS_BLOCK_SIZE) {
-			crypto_aegis128_update_a(state, src_blk);
+			crypto_aegis128_update_a(state, src_blk, do_simd);
 
 			size -= AEGIS_BLOCK_SIZE;
 			src_blk++;
 		}
 	} else {
 		while (size >= AEGIS_BLOCK_SIZE) {
-			crypto_aegis128_update_u(state, src);
+			crypto_aegis128_update_u(state, src, do_simd);
 
 			size -= AEGIS_BLOCK_SIZE;
 			src += AEGIS_BLOCK_SIZE;
@@ -180,7 +183,7 @@ static void crypto_aegis128_encrypt_chunk(struct aegis_state *state, u8 *dst,
 			crypto_aegis_block_xor(&tmp, &state->blocks[1]);
 			crypto_aegis_block_xor(&tmp, src_blk);
 
-			crypto_aegis128_update_a(state, src_blk);
+			crypto_aegis128_update_a(state, src_blk, false);
 
 			*dst_blk = tmp;
 
@@ -196,7 +199,7 @@ static void crypto_aegis128_encrypt_chunk(struct aegis_state *state, u8 *dst,
 			crypto_aegis_block_xor(&tmp, &state->blocks[1]);
 			crypto_xor(tmp.bytes, src, AEGIS_BLOCK_SIZE);
 
-			crypto_aegis128_update_u(state, src);
+			crypto_aegis128_update_u(state, src, false);
 
 			memcpy(dst, tmp.bytes, AEGIS_BLOCK_SIZE);
 
@@ -215,7 +218,7 @@ static void crypto_aegis128_encrypt_chunk(struct aegis_state *state, u8 *dst,
 		crypto_aegis_block_xor(&tmp, &state->blocks[4]);
 		crypto_aegis_block_xor(&tmp, &state->blocks[1]);
 
-		crypto_aegis128_update_a(state, &msg);
+		crypto_aegis128_update_a(state, &msg, false);
 
 		crypto_aegis_block_xor(&msg, &tmp);
 
@@ -241,7 +244,7 @@ static void crypto_aegis128_decrypt_chunk(struct aegis_state *state, u8 *dst,
 			crypto_aegis_block_xor(&tmp, &state->blocks[1]);
 			crypto_aegis_block_xor(&tmp, src_blk);
 
-			crypto_aegis128_update_a(state, &tmp);
+			crypto_aegis128_update_a(state, &tmp, false);
 
 			*dst_blk = tmp;
 
@@ -257,7 +260,7 @@ static void crypto_aegis128_decrypt_chunk(struct aegis_state *state, u8 *dst,
 			crypto_aegis_block_xor(&tmp, &state->blocks[1]);
 			crypto_xor(tmp.bytes, src, AEGIS_BLOCK_SIZE);
 
-			crypto_aegis128_update_a(state, &tmp);
+			crypto_aegis128_update_a(state, &tmp, false);
 
 			memcpy(dst, tmp.bytes, AEGIS_BLOCK_SIZE);
 
@@ -279,7 +282,7 @@ static void crypto_aegis128_decrypt_chunk(struct aegis_state *state, u8 *dst,
 
 		memset(msg.bytes + size, 0, AEGIS_BLOCK_SIZE - size);
 
-		crypto_aegis128_update_a(state, &msg);
+		crypto_aegis128_update_a(state, &msg, false);
 
 		memcpy(dst, msg.bytes, size);
 	}
@@ -287,7 +290,8 @@ static void crypto_aegis128_decrypt_chunk(struct aegis_state *state, u8 *dst,
 
 static void crypto_aegis128_process_ad(struct aegis_state *state,
 				       struct scatterlist *sg_src,
-				       unsigned int assoclen)
+				       unsigned int assoclen,
+				       bool do_simd)
 {
 	struct scatter_walk walk;
 	union aegis_block buf;
@@ -304,13 +308,13 @@ static void crypto_aegis128_process_ad(struct aegis_state *state,
 			if (pos > 0) {
 				unsigned int fill = AEGIS_BLOCK_SIZE - pos;
 				memcpy(buf.bytes + pos, src, fill);
-				crypto_aegis128_update_a(state, &buf);
+				crypto_aegis128_update_a(state, &buf, do_simd);
 				pos = 0;
 				left -= fill;
 				src += fill;
 			}
 
-			crypto_aegis128_ad(state, src, left);
+			crypto_aegis128_ad(state, src, left, do_simd);
 			src += left & ~(AEGIS_BLOCK_SIZE - 1);
 			left &= AEGIS_BLOCK_SIZE - 1;
 		}
@@ -326,7 +330,7 @@ static void crypto_aegis128_process_ad(struct aegis_state *state,
 
 	if (pos > 0) {
 		memset(buf.bytes + pos, 0, AEGIS_BLOCK_SIZE - pos);
-		crypto_aegis128_update_a(state, &buf);
+		crypto_aegis128_update_a(state, &buf, do_simd);
 	}
 }
 
@@ -368,7 +372,7 @@ static void crypto_aegis128_final(struct aegis_state *state,
 	crypto_aegis_block_xor(&tmp, &state->blocks[3]);
 
 	for (i = 0; i < 7; i++)
-		crypto_aegis128_update_a(state, &tmp);
+		crypto_aegis128_update_a(state, &tmp, false);
 
 	for (i = 0; i < AEGIS128_STATE_BLOCKS; i++)
 		crypto_aegis_block_xor(tag_xor, &state->blocks[i]);
@@ -396,7 +400,7 @@ static int crypto_aegis128_setauthsize(struct crypto_aead *tfm,
 	return 0;
 }
 
-static int crypto_aegis128_encrypt(struct aead_request *req)
+static int crypto_aegis128_encrypt_generic(struct aead_request *req)
 {
 	struct crypto_aead *tfm = crypto_aead_reqtfm(req);
 	union aegis_block tag = {};
@@ -407,27 +411,18 @@ static int crypto_aegis128_encrypt(struct aead_request *req)
 	struct aegis_state state;
 
 	skcipher_walk_aead_encrypt(&walk, req, false);
-	if (aegis128_do_simd()) {
-		crypto_aegis128_init_simd(&state, &ctx->key, req->iv);
-		crypto_aegis128_process_ad(&state, req->src, req->assoclen);
-		crypto_aegis128_process_crypt(&state, &walk,
-					      crypto_aegis128_encrypt_chunk_simd);
-		crypto_aegis128_final_simd(&state, &tag, req->assoclen,
-					   cryptlen, 0);
-	} else {
-		crypto_aegis128_init(&state, &ctx->key, req->iv);
-		crypto_aegis128_process_ad(&state, req->src, req->assoclen);
-		crypto_aegis128_process_crypt(&state, &walk,
-					      crypto_aegis128_encrypt_chunk);
-		crypto_aegis128_final(&state, &tag, req->assoclen, cryptlen);
-	}
+	crypto_aegis128_init(&state, &ctx->key, req->iv);
+	crypto_aegis128_process_ad(&state, req->src, req->assoclen, false);
+	crypto_aegis128_process_crypt(&state, &walk,
+				      crypto_aegis128_encrypt_chunk);
+	crypto_aegis128_final(&state, &tag, req->assoclen, cryptlen);
 
 	scatterwalk_map_and_copy(tag.bytes, req->dst, req->assoclen + cryptlen,
 				 authsize, 1);
 	return 0;
 }
 
-static int crypto_aegis128_decrypt(struct aead_request *req)
+static int crypto_aegis128_decrypt_generic(struct aead_request *req)
 {
 	static const u8 zeros[AEGIS128_MAX_AUTH_SIZE] = {};
 	struct crypto_aead *tfm = crypto_aead_reqtfm(req);
@@ -442,27 +437,11 @@ static int crypto_aegis128_decrypt(struct aead_request *req)
 				 authsize, 0);
 
 	skcipher_walk_aead_decrypt(&walk, req, false);
-	if (aegis128_do_simd()) {
-		crypto_aegis128_init_simd(&state, &ctx->key, req->iv);
-		crypto_aegis128_process_ad(&state, req->src, req->assoclen);
-		crypto_aegis128_process_crypt(&state, &walk,
-					      crypto_aegis128_decrypt_chunk_simd);
-		if (unlikely(crypto_aegis128_final_simd(&state, &tag,
-							req->assoclen,
-							cryptlen, authsize))) {
-			skcipher_walk_aead_decrypt(&walk, req, false);
-			crypto_aegis128_process_crypt(NULL, req, &walk,
-						      crypto_aegis128_wipe_chunk);
-			return -EBADMSG;
-		}
-		return 0;
-	} else {
-		crypto_aegis128_init(&state, &ctx->key, req->iv);
-		crypto_aegis128_process_ad(&state, req->src, req->assoclen);
-		crypto_aegis128_process_crypt(&state, &walk,
-					      crypto_aegis128_decrypt_chunk);
-		crypto_aegis128_final(&state, &tag, req->assoclen, cryptlen);
-	}
+	crypto_aegis128_init(&state, &ctx->key, req->iv);
+	crypto_aegis128_process_ad(&state, req->src, req->assoclen, false);
+	crypto_aegis128_process_crypt(&state, &walk,
+				      crypto_aegis128_decrypt_chunk);
+	crypto_aegis128_final(&state, &tag, req->assoclen, cryptlen);
 
 	if (unlikely(crypto_memneq(tag.bytes, zeros, authsize))) {
 		/*
@@ -482,42 +461,128 @@ static int crypto_aegis128_decrypt(struct aead_request *req)
 	return 0;
 }
 
-static struct aead_alg crypto_aegis128_alg = {
-	.setkey = crypto_aegis128_setkey,
-	.setauthsize = crypto_aegis128_setauthsize,
-	.encrypt = crypto_aegis128_encrypt,
-	.decrypt = crypto_aegis128_decrypt,
+static int crypto_aegis128_encrypt_simd(struct aead_request *req)
+{
+	struct crypto_aead *tfm = crypto_aead_reqtfm(req);
+	union aegis_block tag = {};
+	unsigned int authsize = crypto_aead_authsize(tfm);
+	struct aegis_ctx *ctx = crypto_aead_ctx(tfm);
+	unsigned int cryptlen = req->cryptlen;
+	struct skcipher_walk walk;
+	struct aegis_state state;
 
-	.ivsize = AEGIS128_NONCE_SIZE,
-	.maxauthsize = AEGIS128_MAX_AUTH_SIZE,
-	.chunksize = AEGIS_BLOCK_SIZE,
+	if (!aegis128_do_simd())
+		return crypto_aegis128_encrypt_generic(req);
 
-	.base = {
-		.cra_blocksize = 1,
-		.cra_ctxsize = sizeof(struct aegis_ctx),
-		.cra_alignmask = 0,
+	skcipher_walk_aead_encrypt(&walk, req, false);
+	crypto_aegis128_init_simd(&state, &ctx->key, req->iv);
+	crypto_aegis128_process_ad(&state, req->src, req->assoclen, true);
+	crypto_aegis128_process_crypt(&state, &walk,
+				      crypto_aegis128_encrypt_chunk_simd);
+	crypto_aegis128_final_simd(&state, &tag, req->assoclen, cryptlen, 0);
 
-		.cra_priority = 100,
+	scatterwalk_map_and_copy(tag.bytes, req->dst, req->assoclen + cryptlen,
+				 authsize, 1);
+	return 0;
+}
 
-		.cra_name = "aegis128",
-		.cra_driver_name = "aegis128-generic",
+static int crypto_aegis128_decrypt_simd(struct aead_request *req)
+{
+	struct crypto_aead *tfm = crypto_aead_reqtfm(req);
+	union aegis_block tag;
+	unsigned int authsize = crypto_aead_authsize(tfm);
+	unsigned int cryptlen = req->cryptlen - authsize;
+	struct aegis_ctx *ctx = crypto_aead_ctx(tfm);
+	struct skcipher_walk walk;
+	struct aegis_state state;
 
-		.cra_module = THIS_MODULE,
+	if (!aegis128_do_simd())
+		return crypto_aegis128_decrypt_generic(req);
+
+	scatterwalk_map_and_copy(tag.bytes, req->src, req->assoclen + cryptlen,
+				 authsize, 0);
+
+	skcipher_walk_aead_decrypt(&walk, req, false);
+	crypto_aegis128_init_simd(&state, &ctx->key, req->iv);
+	crypto_aegis128_process_ad(&state, req->src, req->assoclen, true);
+	crypto_aegis128_process_crypt(&state, &walk,
+				      crypto_aegis128_decrypt_chunk_simd);
+
+	if (unlikely(crypto_aegis128_final_simd(&state, &tag, req->assoclen,
+						cryptlen, authsize))) {
+		skcipher_walk_aead_decrypt(&walk, req, false);
+		crypto_aegis128_process_crypt(NULL, &walk,
+					      crypto_aegis128_wipe_chunk);
+		return -EBADMSG;
 	}
+	return 0;
+}
+
+static struct aead_alg crypto_aegis128_alg_generic = {
+	.setkey			= crypto_aegis128_setkey,
+	.setauthsize		= crypto_aegis128_setauthsize,
+	.encrypt		= crypto_aegis128_encrypt_generic,
+	.decrypt		= crypto_aegis128_decrypt_generic,
+
+	.ivsize			= AEGIS128_NONCE_SIZE,
+	.maxauthsize		= AEGIS128_MAX_AUTH_SIZE,
+	.chunksize		= AEGIS_BLOCK_SIZE,
+
+	.base.cra_blocksize	= 1,
+	.base.cra_ctxsize	= sizeof(struct aegis_ctx),
+	.base.cra_alignmask	= 0,
+	.base.cra_priority	= 100,
+	.base.cra_name		= "aegis128",
+	.base.cra_driver_name	= "aegis128-generic",
+	.base.cra_module	= THIS_MODULE,
+};
+
+static struct aead_alg crypto_aegis128_alg_simd = {
+	.setkey			= crypto_aegis128_setkey,
+	.setauthsize		= crypto_aegis128_setauthsize,
+	.encrypt		= crypto_aegis128_encrypt_simd,
+	.decrypt		= crypto_aegis128_decrypt_simd,
+
+	.ivsize			= AEGIS128_NONCE_SIZE,
+	.maxauthsize		= AEGIS128_MAX_AUTH_SIZE,
+	.chunksize		= AEGIS_BLOCK_SIZE,
+
+	.base.cra_blocksize	= 1,
+	.base.cra_ctxsize	= sizeof(struct aegis_ctx),
+	.base.cra_alignmask	= 0,
+	.base.cra_priority	= 200,
+	.base.cra_name		= "aegis128",
+	.base.cra_driver_name	= "aegis128-simd",
+	.base.cra_module	= THIS_MODULE,
 };
 
 static int __init crypto_aegis128_module_init(void)
 {
+	int ret;
+
+	ret = crypto_register_aead(&crypto_aegis128_alg_generic);
+	if (ret)
+		return ret;
+
 	if (IS_ENABLED(CONFIG_CRYPTO_AEGIS128_SIMD) &&
-	    crypto_aegis128_have_simd())
+	    crypto_aegis128_have_simd()) {
+		ret = crypto_register_aead(&crypto_aegis128_alg_simd);
+		if (ret) {
+			crypto_unregister_aead(&crypto_aegis128_alg_generic);
+			return ret;
+		}
 		static_branch_enable(&have_simd);
-
-	return crypto_register_aead(&crypto_aegis128_alg);
+	}
+	return 0;
 }
 
 static void __exit crypto_aegis128_module_exit(void)
 {
-	crypto_unregister_aead(&crypto_aegis128_alg);
+	if (IS_ENABLED(CONFIG_CRYPTO_AEGIS128_SIMD) &&
+	    crypto_aegis128_have_simd())
+		crypto_unregister_aead(&crypto_aegis128_alg_simd);
+
+	crypto_unregister_aead(&crypto_aegis128_alg_generic);
 }
 
 subsys_initcall(crypto_aegis128_module_init);
@@ -528,3 +593,4 @@ MODULE_AUTHOR("Ondrej Mosnacek <omosnacek@gmail.com>");
 MODULE_DESCRIPTION("AEGIS-128 AEAD algorithm");
 MODULE_ALIAS_CRYPTO("aegis128");
 MODULE_ALIAS_CRYPTO("aegis128-generic");
+MODULE_ALIAS_CRYPTO("aegis128-simd");
-- 
2.17.1


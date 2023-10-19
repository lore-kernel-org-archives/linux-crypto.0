Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 81DC8CDB483
	for <linux-crypto@archiver.kernel.org>; Thu, 19 Oct 2023 05:54:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232767AbjJSFyd (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 19 Oct 2023 01:54:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55440 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232666AbjJSFyR (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 19 Oct 2023 01:54:17 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D6542113
        for <linux-crypto@vger.kernel.org>; Wed, 18 Oct 2023 22:54:14 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7A033C433C8
        for <linux-crypto@vger.kernel.org>; Thu, 19 Oct 2023 05:54:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1697694854;
        bh=QYH+cVmF4mkZ3rx5Xu98l2QE4+ZE4e0GOXnEh69pB8M=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=HR+1imBnJ/f0YwgnGNZomXZKAinNPw1MxD7OMlSJbQHsjBrhpjZCkl97MCsFcytQ1
         tKXnvvqtN4IId2VN9xNoNDevCWwuXMPg7rOP2DLNO1XBnV6CofKc7JQeGJfdywniw3
         KBMi1X80sYEJWzZyd1oWnzlhEwILQqflMGpdZzvggIRuhE1cXyThaICwZBdUGIy0zk
         KjiGDUdrCdvnVkVDSR6o3/KA0xovuEykyJZ9fhx3sl6kdh+FBJQZNWY7G/L+xLNrUG
         NMr3J6Wx3K6nUwTwElx0kdkGc6NjWzAjys5S/h0KMlBlLiZlYbyt2PHm1E3tUevise
         H2X2n6eG9wOaw==
From:   Eric Biggers <ebiggers@kernel.org>
To:     linux-crypto@vger.kernel.org
Subject: [PATCH 10/17] crypto: xcbc - remove unnecessary alignment logic
Date:   Wed, 18 Oct 2023 22:53:36 -0700
Message-ID: <20231019055343.588846-11-ebiggers@kernel.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231019055343.588846-1-ebiggers@kernel.org>
References: <20231019055343.588846-1-ebiggers@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

From: Eric Biggers <ebiggers@google.com>

The xcbc template is setting its alignmask to that of its underlying
'cipher'.  Yet, it doesn't care itself about how its inputs and outputs
are aligned, which is ostensibly the point of the alignmask.  Instead,
xcbc actually just uses its alignmask itself to runtime-align certain
fields in its tfm and desc contexts appropriately for its underlying
cipher.  That is almost entirely pointless too, though, since xcbc is
already using the cipher API functions that handle alignment themselves,
and few ciphers set a nonzero alignmask anyway.  Also, even without
runtime alignment, an alignment of at least 4 bytes can be guaranteed.

Thus, at best this code is optimizing for the rare case of ciphers that
set an alignmask >= 7, at the cost of hurting the common cases.

Therefore, this patch removes the manual alignment code from xcbc and
makes it stop setting an alignmask.

Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 crypto/xcbc.c | 32 ++++++++++----------------------
 1 file changed, 10 insertions(+), 22 deletions(-)

diff --git a/crypto/xcbc.c b/crypto/xcbc.c
index 6074c5c1da492..a9e8ee9c1949c 100644
--- a/crypto/xcbc.c
+++ b/crypto/xcbc.c
@@ -20,85 +20,82 @@ static u_int32_t ks[12] = {0x01010101, 0x01010101, 0x01010101, 0x01010101,
  * +------------------------
  * | <parent tfm>
  * +------------------------
  * | xcbc_tfm_ctx
  * +------------------------
  * | consts (block size * 2)
  * +------------------------
  */
 struct xcbc_tfm_ctx {
 	struct crypto_cipher *child;
-	u8 ctx[];
+	u8 consts[];
 };
 
 /*
  * +------------------------
  * | <shash desc>
  * +------------------------
  * | xcbc_desc_ctx
  * +------------------------
  * | odds (block size)
  * +------------------------
  * | prev (block size)
  * +------------------------
  */
 struct xcbc_desc_ctx {
 	unsigned int len;
-	u8 ctx[];
+	u8 odds[];
 };
 
 #define XCBC_BLOCKSIZE	16
 
 static int crypto_xcbc_digest_setkey(struct crypto_shash *parent,
 				     const u8 *inkey, unsigned int keylen)
 {
-	unsigned long alignmask = crypto_shash_alignmask(parent);
 	struct xcbc_tfm_ctx *ctx = crypto_shash_ctx(parent);
-	u8 *consts = PTR_ALIGN(&ctx->ctx[0], alignmask + 1);
+	u8 *consts = ctx->consts;
 	int err = 0;
 	u8 key1[XCBC_BLOCKSIZE];
 	int bs = sizeof(key1);
 
 	if ((err = crypto_cipher_setkey(ctx->child, inkey, keylen)))
 		return err;
 
 	crypto_cipher_encrypt_one(ctx->child, consts, (u8 *)ks + bs);
 	crypto_cipher_encrypt_one(ctx->child, consts + bs, (u8 *)ks + bs * 2);
 	crypto_cipher_encrypt_one(ctx->child, key1, (u8 *)ks);
 
 	return crypto_cipher_setkey(ctx->child, key1, bs);
 
 }
 
 static int crypto_xcbc_digest_init(struct shash_desc *pdesc)
 {
-	unsigned long alignmask = crypto_shash_alignmask(pdesc->tfm);
 	struct xcbc_desc_ctx *ctx = shash_desc_ctx(pdesc);
 	int bs = crypto_shash_blocksize(pdesc->tfm);
-	u8 *prev = PTR_ALIGN(&ctx->ctx[0], alignmask + 1) + bs;
+	u8 *prev = &ctx->odds[bs];
 
 	ctx->len = 0;
 	memset(prev, 0, bs);
 
 	return 0;
 }
 
 static int crypto_xcbc_digest_update(struct shash_desc *pdesc, const u8 *p,
 				     unsigned int len)
 {
 	struct crypto_shash *parent = pdesc->tfm;
-	unsigned long alignmask = crypto_shash_alignmask(parent);
 	struct xcbc_tfm_ctx *tctx = crypto_shash_ctx(parent);
 	struct xcbc_desc_ctx *ctx = shash_desc_ctx(pdesc);
 	struct crypto_cipher *tfm = tctx->child;
 	int bs = crypto_shash_blocksize(parent);
-	u8 *odds = PTR_ALIGN(&ctx->ctx[0], alignmask + 1);
+	u8 *odds = ctx->odds;
 	u8 *prev = odds + bs;
 
 	/* checking the data can fill the block */
 	if ((ctx->len + len) <= bs) {
 		memcpy(odds + ctx->len, p, len);
 		ctx->len += len;
 		return 0;
 	}
 
 	/* filling odds with new data and encrypting it */
@@ -125,46 +122,44 @@ static int crypto_xcbc_digest_update(struct shash_desc *pdesc, const u8 *p,
 		memcpy(odds, p, len);
 		ctx->len = len;
 	}
 
 	return 0;
 }
 
 static int crypto_xcbc_digest_final(struct shash_desc *pdesc, u8 *out)
 {
 	struct crypto_shash *parent = pdesc->tfm;
-	unsigned long alignmask = crypto_shash_alignmask(parent);
 	struct xcbc_tfm_ctx *tctx = crypto_shash_ctx(parent);
 	struct xcbc_desc_ctx *ctx = shash_desc_ctx(pdesc);
 	struct crypto_cipher *tfm = tctx->child;
 	int bs = crypto_shash_blocksize(parent);
-	u8 *consts = PTR_ALIGN(&tctx->ctx[0], alignmask + 1);
-	u8 *odds = PTR_ALIGN(&ctx->ctx[0], alignmask + 1);
+	u8 *odds = ctx->odds;
 	u8 *prev = odds + bs;
 	unsigned int offset = 0;
 
 	if (ctx->len != bs) {
 		unsigned int rlen;
 		u8 *p = odds + ctx->len;
 
 		*p = 0x80;
 		p++;
 
 		rlen = bs - ctx->len -1;
 		if (rlen)
 			memset(p, 0, rlen);
 
 		offset += bs;
 	}
 
 	crypto_xor(prev, odds, bs);
-	crypto_xor(prev, consts + offset, bs);
+	crypto_xor(prev, &tctx->consts[offset], bs);
 
 	crypto_cipher_encrypt_one(tfm, out, prev);
 
 	return 0;
 }
 
 static int xcbc_init_tfm(struct crypto_tfm *tfm)
 {
 	struct crypto_cipher *cipher;
 	struct crypto_instance *inst = (void *)tfm->__crt_alg;
@@ -184,21 +179,20 @@ static void xcbc_exit_tfm(struct crypto_tfm *tfm)
 {
 	struct xcbc_tfm_ctx *ctx = crypto_tfm_ctx(tfm);
 	crypto_free_cipher(ctx->child);
 }
 
 static int xcbc_create(struct crypto_template *tmpl, struct rtattr **tb)
 {
 	struct shash_instance *inst;
 	struct crypto_cipher_spawn *spawn;
 	struct crypto_alg *alg;
-	unsigned long alignmask;
 	u32 mask;
 	int err;
 
 	err = crypto_check_attr_type(tb, CRYPTO_ALG_TYPE_SHASH, &mask);
 	if (err)
 		return err;
 
 	inst = kzalloc(sizeof(*inst) + sizeof(*spawn), GFP_KERNEL);
 	if (!inst)
 		return -ENOMEM;
@@ -211,35 +205,29 @@ static int xcbc_create(struct crypto_template *tmpl, struct rtattr **tb)
 	alg = crypto_spawn_cipher_alg(spawn);
 
 	err = -EINVAL;
 	if (alg->cra_blocksize != XCBC_BLOCKSIZE)
 		goto err_free_inst;
 
 	err = crypto_inst_setname(shash_crypto_instance(inst), tmpl->name, alg);
 	if (err)
 		goto err_free_inst;
 
-	alignmask = alg->cra_alignmask | 3;
-	inst->alg.base.cra_alignmask = alignmask;
 	inst->alg.base.cra_priority = alg->cra_priority;
 	inst->alg.base.cra_blocksize = alg->cra_blocksize;
+	inst->alg.base.cra_ctxsize = sizeof(struct xcbc_tfm_ctx) +
+				     alg->cra_blocksize * 2;
 
 	inst->alg.digestsize = alg->cra_blocksize;
-	inst->alg.descsize = ALIGN(sizeof(struct xcbc_desc_ctx),
-				   crypto_tfm_ctx_alignment()) +
-			     (alignmask &
-			      ~(crypto_tfm_ctx_alignment() - 1)) +
+	inst->alg.descsize = sizeof(struct xcbc_desc_ctx) +
 			     alg->cra_blocksize * 2;
 
-	inst->alg.base.cra_ctxsize = ALIGN(sizeof(struct xcbc_tfm_ctx),
-					   alignmask + 1) +
-				     alg->cra_blocksize * 2;
 	inst->alg.base.cra_init = xcbc_init_tfm;
 	inst->alg.base.cra_exit = xcbc_exit_tfm;
 
 	inst->alg.init = crypto_xcbc_digest_init;
 	inst->alg.update = crypto_xcbc_digest_update;
 	inst->alg.final = crypto_xcbc_digest_final;
 	inst->alg.setkey = crypto_xcbc_digest_setkey;
 
 	inst->free = shash_free_singlespawn_instance;
 
-- 
2.42.0


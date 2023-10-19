Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 12C78CDB465
	for <linux-crypto@archiver.kernel.org>; Thu, 19 Oct 2023 05:54:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232712AbjJSFyZ (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 19 Oct 2023 01:54:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34340 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232650AbjJSFyQ (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 19 Oct 2023 01:54:16 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7C789121
        for <linux-crypto@vger.kernel.org>; Wed, 18 Oct 2023 22:54:14 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1DD3FC433D9
        for <linux-crypto@vger.kernel.org>; Thu, 19 Oct 2023 05:54:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1697694854;
        bh=6+5sfw+Im75F6oUY/EK7cod3GRqwQ5kxKGclEU/TThw=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=Pmgum+MM4XSJl+eBIpJ7y1BfVja+ZInJOoAR6Pd4mlsIDuND0+EA6tw1gXsijeh2g
         BskO5EhD/jaI+8xp+QGIwnOCXSFV10VPdUSLZcwVC7zJTtTaSOcNMhqePxdtBe85MR
         +mSpyGl5l9QPNSLBQx6WzvlggtPDFCUfccwFIXoCSfYSiIqD6jBYqU8BMorxIYroqe
         d5YZ++zoqBGNYc5SCkaiyUfvsmMc8poSA/uiwd215WosF8sCkF9HfcNYH98DAA98A1
         NRGOMFddLLeCPKWx6up37s6lzuS+eZeQKYyLfdy8txl9uSSO5ame6E9M2SKaPqMrxJ
         gzCtyAzjbTMwQ==
From:   Eric Biggers <ebiggers@kernel.org>
To:     linux-crypto@vger.kernel.org
Subject: [PATCH 08/17] crypto: hmac - remove unnecessary alignment logic
Date:   Wed, 18 Oct 2023 22:53:34 -0700
Message-ID: <20231019055343.588846-9-ebiggers@kernel.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231019055343.588846-1-ebiggers@kernel.org>
References: <20231019055343.588846-1-ebiggers@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

From: Eric Biggers <ebiggers@google.com>

The hmac template is setting its alignmask to that of its underlying
unkeyed hash algorithm, and it is aligning the ipad and opad fields in
its tfm context to that alignment.  However, hmac does not actually need
any sort of alignment itself, which makes this pointless except to keep
the pads aligned to what the underlying algorithm prefers.  But very few
shash algorithms actually set an alignmask, and it is being removed from
those remaining ones; also, after setkey, the pads are only passed to
crypto_shash_import and crypto_shash_export which ignore the alignmask.

Therefore, make the hmac template stop setting an alignmask and simply
use natural alignment for ipad and opad.  Note, this change also moves
the pads from the beginning of the tfm context to the end, which makes
much more sense; the variable-length fields should be at the end.

Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 crypto/hmac.c | 56 ++++++++++++++++++++-------------------------------
 1 file changed, 22 insertions(+), 34 deletions(-)

diff --git a/crypto/hmac.c b/crypto/hmac.c
index ea93f4c55f251..7cec25ff98891 100644
--- a/crypto/hmac.c
+++ b/crypto/hmac.c
@@ -17,45 +17,34 @@
 #include <linux/err.h>
 #include <linux/fips.h>
 #include <linux/init.h>
 #include <linux/kernel.h>
 #include <linux/module.h>
 #include <linux/scatterlist.h>
 #include <linux/string.h>
 
 struct hmac_ctx {
 	struct crypto_shash *hash;
+	/* Contains 'u8 ipad[statesize];', then 'u8 opad[statesize];' */
+	u8 pads[];
 };
 
-static inline void *align_ptr(void *p, unsigned int align)
-{
-	return (void *)ALIGN((unsigned long)p, align);
-}
-
-static inline struct hmac_ctx *hmac_ctx(struct crypto_shash *tfm)
-{
-	return align_ptr(crypto_shash_ctx_aligned(tfm) +
-			 crypto_shash_statesize(tfm) * 2,
-			 crypto_tfm_ctx_alignment());
-}
-
 static int hmac_setkey(struct crypto_shash *parent,
 		       const u8 *inkey, unsigned int keylen)
 {
 	int bs = crypto_shash_blocksize(parent);
 	int ds = crypto_shash_digestsize(parent);
 	int ss = crypto_shash_statesize(parent);
-	char *ipad = crypto_shash_ctx_aligned(parent);
-	char *opad = ipad + ss;
-	struct hmac_ctx *ctx = align_ptr(opad + ss,
-					 crypto_tfm_ctx_alignment());
-	struct crypto_shash *hash = ctx->hash;
+	struct hmac_ctx *tctx = crypto_shash_ctx(parent);
+	struct crypto_shash *hash = tctx->hash;
+	u8 *ipad = &tctx->pads[0];
+	u8 *opad = &tctx->pads[ss];
 	SHASH_DESC_ON_STACK(shash, hash);
 	unsigned int i;
 
 	if (fips_enabled && (keylen < 112 / 8))
 		return -EINVAL;
 
 	shash->tfm = hash;
 
 	if (keylen > bs) {
 		int err;
@@ -87,105 +76,109 @@ static int hmac_setkey(struct crypto_shash *parent,
 static int hmac_export(struct shash_desc *pdesc, void *out)
 {
 	struct shash_desc *desc = shash_desc_ctx(pdesc);
 
 	return crypto_shash_export(desc, out);
 }
 
 static int hmac_import(struct shash_desc *pdesc, const void *in)
 {
 	struct shash_desc *desc = shash_desc_ctx(pdesc);
-	struct hmac_ctx *ctx = hmac_ctx(pdesc->tfm);
+	const struct hmac_ctx *tctx = crypto_shash_ctx(pdesc->tfm);
 
-	desc->tfm = ctx->hash;
+	desc->tfm = tctx->hash;
 
 	return crypto_shash_import(desc, in);
 }
 
 static int hmac_init(struct shash_desc *pdesc)
 {
-	return hmac_import(pdesc, crypto_shash_ctx_aligned(pdesc->tfm));
+	const struct hmac_ctx *tctx = crypto_shash_ctx(pdesc->tfm);
+
+	return hmac_import(pdesc, &tctx->pads[0]);
 }
 
 static int hmac_update(struct shash_desc *pdesc,
 		       const u8 *data, unsigned int nbytes)
 {
 	struct shash_desc *desc = shash_desc_ctx(pdesc);
 
 	return crypto_shash_update(desc, data, nbytes);
 }
 
 static int hmac_final(struct shash_desc *pdesc, u8 *out)
 {
 	struct crypto_shash *parent = pdesc->tfm;
 	int ds = crypto_shash_digestsize(parent);
 	int ss = crypto_shash_statesize(parent);
-	char *opad = crypto_shash_ctx_aligned(parent) + ss;
+	const struct hmac_ctx *tctx = crypto_shash_ctx(parent);
+	const u8 *opad = &tctx->pads[ss];
 	struct shash_desc *desc = shash_desc_ctx(pdesc);
 
 	return crypto_shash_final(desc, out) ?:
 	       crypto_shash_import(desc, opad) ?:
 	       crypto_shash_finup(desc, out, ds, out);
 }
 
 static int hmac_finup(struct shash_desc *pdesc, const u8 *data,
 		      unsigned int nbytes, u8 *out)
 {
 
 	struct crypto_shash *parent = pdesc->tfm;
 	int ds = crypto_shash_digestsize(parent);
 	int ss = crypto_shash_statesize(parent);
-	char *opad = crypto_shash_ctx_aligned(parent) + ss;
+	const struct hmac_ctx *tctx = crypto_shash_ctx(parent);
+	const u8 *opad = &tctx->pads[ss];
 	struct shash_desc *desc = shash_desc_ctx(pdesc);
 
 	return crypto_shash_finup(desc, data, nbytes, out) ?:
 	       crypto_shash_import(desc, opad) ?:
 	       crypto_shash_finup(desc, out, ds, out);
 }
 
 static int hmac_init_tfm(struct crypto_shash *parent)
 {
 	struct crypto_shash *hash;
 	struct shash_instance *inst = shash_alg_instance(parent);
 	struct crypto_shash_spawn *spawn = shash_instance_ctx(inst);
-	struct hmac_ctx *ctx = hmac_ctx(parent);
+	struct hmac_ctx *tctx = crypto_shash_ctx(parent);
 
 	hash = crypto_spawn_shash(spawn);
 	if (IS_ERR(hash))
 		return PTR_ERR(hash);
 
 	parent->descsize = sizeof(struct shash_desc) +
 			   crypto_shash_descsize(hash);
 
-	ctx->hash = hash;
+	tctx->hash = hash;
 	return 0;
 }
 
 static int hmac_clone_tfm(struct crypto_shash *dst, struct crypto_shash *src)
 {
-	struct hmac_ctx *sctx = hmac_ctx(src);
-	struct hmac_ctx *dctx = hmac_ctx(dst);
+	struct hmac_ctx *sctx = crypto_shash_ctx(src);
+	struct hmac_ctx *dctx = crypto_shash_ctx(dst);
 	struct crypto_shash *hash;
 
 	hash = crypto_clone_shash(sctx->hash);
 	if (IS_ERR(hash))
 		return PTR_ERR(hash);
 
 	dctx->hash = hash;
 	return 0;
 }
 
 static void hmac_exit_tfm(struct crypto_shash *parent)
 {
-	struct hmac_ctx *ctx = hmac_ctx(parent);
+	struct hmac_ctx *tctx = crypto_shash_ctx(parent);
 
-	crypto_free_shash(ctx->hash);
+	crypto_free_shash(tctx->hash);
 }
 
 static int hmac_create(struct crypto_template *tmpl, struct rtattr **tb)
 {
 	struct shash_instance *inst;
 	struct crypto_shash_spawn *spawn;
 	struct crypto_alg *alg;
 	struct shash_alg *salg;
 	u32 mask;
 	int err;
@@ -218,29 +211,24 @@ static int hmac_create(struct crypto_template *tmpl, struct rtattr **tb)
 	if (ds > alg->cra_blocksize ||
 	    ss < alg->cra_blocksize)
 		goto err_free_inst;
 
 	err = crypto_inst_setname(shash_crypto_instance(inst), tmpl->name, alg);
 	if (err)
 		goto err_free_inst;
 
 	inst->alg.base.cra_priority = alg->cra_priority;
 	inst->alg.base.cra_blocksize = alg->cra_blocksize;
-	inst->alg.base.cra_alignmask = alg->cra_alignmask;
+	inst->alg.base.cra_ctxsize = sizeof(struct hmac_ctx) + (ss * 2);
 
-	ss = ALIGN(ss, alg->cra_alignmask + 1);
 	inst->alg.digestsize = ds;
 	inst->alg.statesize = ss;
-
-	inst->alg.base.cra_ctxsize = sizeof(struct hmac_ctx) +
-				     ALIGN(ss * 2, crypto_tfm_ctx_alignment());
-
 	inst->alg.init = hmac_init;
 	inst->alg.update = hmac_update;
 	inst->alg.final = hmac_final;
 	inst->alg.finup = hmac_finup;
 	inst->alg.export = hmac_export;
 	inst->alg.import = hmac_import;
 	inst->alg.setkey = hmac_setkey;
 	inst->alg.init_tfm = hmac_init_tfm;
 	inst->alg.clone_tfm = hmac_clone_tfm;
 	inst->alg.exit_tfm = hmac_exit_tfm;
-- 
2.42.0


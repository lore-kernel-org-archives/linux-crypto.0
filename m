Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 08A7FCDB486
	for <linux-crypto@archiver.kernel.org>; Thu, 19 Oct 2023 05:54:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232626AbjJSFyS (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 19 Oct 2023 01:54:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34382 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232638AbjJSFyQ (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 19 Oct 2023 01:54:16 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6156811D
        for <linux-crypto@vger.kernel.org>; Wed, 18 Oct 2023 22:54:14 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E46EEC433C7
        for <linux-crypto@vger.kernel.org>; Thu, 19 Oct 2023 05:54:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1697694854;
        bh=j82LtqYf1qqTubk8yZYGD7oFCwPaQRV4h4D9NiVEthc=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=PDOrKfes+20uuQZciieRY9PLBClcbLWX2KedBROqnAvNhqMMuKprX1y8B/zTR2glJ
         B6w3n7h5Ssy3u/o97lbp1XIl8/6SudCeJ8bY0jNPUS3xMURd8PmYfEjfhGE9wXpj4k
         DIu6BV26J6WgG3h2JVG40lsbsmVsn6CpfTbNUGEJryiVxAK6EupCftswC6TCFEvmrZ
         4Q7doVaMsTpnHXsaAT52e8MDthTYrgzEfxBbsca6Axu29dcXxJ65bGDCnpR3Hc0kKT
         lsK4Axf1SUOTmHtoc6+SZyPL9WR+UzV2UxcmLVSoJ9PcHq1LUYRDQZYZIYwNixDHCz
         Su1J7uzC+19CA==
From:   Eric Biggers <ebiggers@kernel.org>
To:     linux-crypto@vger.kernel.org
Subject: [PATCH 07/17] crypto: cmac - remove unnecessary alignment logic
Date:   Wed, 18 Oct 2023 22:53:33 -0700
Message-ID: <20231019055343.588846-8-ebiggers@kernel.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231019055343.588846-1-ebiggers@kernel.org>
References: <20231019055343.588846-1-ebiggers@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

From: Eric Biggers <ebiggers@google.com>

The cmac template is setting its alignmask to that of its underlying
'cipher'.  Yet, it doesn't care itself about how its inputs and outputs
are aligned, which is ostensibly the point of the alignmask.  Instead,
cmac actually just uses its alignmask itself to runtime-align certain
fields in its tfm and desc contexts appropriately for its underlying
cipher.  That is almost entirely pointless too, though, since cmac is
already using the cipher API functions that handle alignment themselves,
and few ciphers set a nonzero alignmask anyway.  Also, even without
runtime alignment, an alignment of at least 4 bytes can be guaranteed.

Thus, at best this code is optimizing for the rare case of ciphers that
set an alignmask >= 7, at the cost of hurting the common cases.

Therefore, this patch removes the manual alignment code from cmac and
makes it stop setting an alignmask.

Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 crypto/cmac.c | 39 +++++++++++----------------------------
 1 file changed, 11 insertions(+), 28 deletions(-)

diff --git a/crypto/cmac.c b/crypto/cmac.c
index fce6b0f58e88e..c7aa3665b076e 100644
--- a/crypto/cmac.c
+++ b/crypto/cmac.c
@@ -21,47 +21,45 @@
  * +------------------------
  * | <parent tfm>
  * +------------------------
  * | cmac_tfm_ctx
  * +------------------------
  * | consts (block size * 2)
  * +------------------------
  */
 struct cmac_tfm_ctx {
 	struct crypto_cipher *child;
-	u8 ctx[];
+	__be64 consts[];
 };
 
 /*
  * +------------------------
  * | <shash desc>
  * +------------------------
  * | cmac_desc_ctx
  * +------------------------
  * | odds (block size)
  * +------------------------
  * | prev (block size)
  * +------------------------
  */
 struct cmac_desc_ctx {
 	unsigned int len;
-	u8 ctx[];
+	u8 odds[];
 };
 
 static int crypto_cmac_digest_setkey(struct crypto_shash *parent,
 				     const u8 *inkey, unsigned int keylen)
 {
-	unsigned long alignmask = crypto_shash_alignmask(parent);
 	struct cmac_tfm_ctx *ctx = crypto_shash_ctx(parent);
 	unsigned int bs = crypto_shash_blocksize(parent);
-	__be64 *consts = PTR_ALIGN((void *)ctx->ctx,
-				   (alignmask | (__alignof__(__be64) - 1)) + 1);
+	__be64 *consts = ctx->consts;
 	u64 _const[2];
 	int i, err = 0;
 	u8 msb_mask, gfmask;
 
 	err = crypto_cipher_setkey(ctx->child, inkey, keylen);
 	if (err)
 		return err;
 
 	/* encrypt the zero block */
 	memset(consts, 0, bs);
@@ -97,41 +95,39 @@ static int crypto_cmac_digest_setkey(struct crypto_shash *parent,
 		}
 
 		break;
 	}
 
 	return 0;
 }
 
 static int crypto_cmac_digest_init(struct shash_desc *pdesc)
 {
-	unsigned long alignmask = crypto_shash_alignmask(pdesc->tfm);
 	struct cmac_desc_ctx *ctx = shash_desc_ctx(pdesc);
 	int bs = crypto_shash_blocksize(pdesc->tfm);
-	u8 *prev = PTR_ALIGN((void *)ctx->ctx, alignmask + 1) + bs;
+	u8 *prev = &ctx->odds[bs];
 
 	ctx->len = 0;
 	memset(prev, 0, bs);
 
 	return 0;
 }
 
 static int crypto_cmac_digest_update(struct shash_desc *pdesc, const u8 *p,
 				     unsigned int len)
 {
 	struct crypto_shash *parent = pdesc->tfm;
-	unsigned long alignmask = crypto_shash_alignmask(parent);
 	struct cmac_tfm_ctx *tctx = crypto_shash_ctx(parent);
 	struct cmac_desc_ctx *ctx = shash_desc_ctx(pdesc);
 	struct crypto_cipher *tfm = tctx->child;
 	int bs = crypto_shash_blocksize(parent);
-	u8 *odds = PTR_ALIGN((void *)ctx->ctx, alignmask + 1);
+	u8 *odds = ctx->odds;
 	u8 *prev = odds + bs;
 
 	/* checking the data can fill the block */
 	if ((ctx->len + len) <= bs) {
 		memcpy(odds + ctx->len, p, len);
 		ctx->len += len;
 		return 0;
 	}
 
 	/* filling odds with new data and encrypting it */
@@ -158,47 +154,44 @@ static int crypto_cmac_digest_update(struct shash_desc *pdesc, const u8 *p,
 		memcpy(odds, p, len);
 		ctx->len = len;
 	}
 
 	return 0;
 }
 
 static int crypto_cmac_digest_final(struct shash_desc *pdesc, u8 *out)
 {
 	struct crypto_shash *parent = pdesc->tfm;
-	unsigned long alignmask = crypto_shash_alignmask(parent);
 	struct cmac_tfm_ctx *tctx = crypto_shash_ctx(parent);
 	struct cmac_desc_ctx *ctx = shash_desc_ctx(pdesc);
 	struct crypto_cipher *tfm = tctx->child;
 	int bs = crypto_shash_blocksize(parent);
-	u8 *consts = PTR_ALIGN((void *)tctx->ctx,
-			       (alignmask | (__alignof__(__be64) - 1)) + 1);
-	u8 *odds = PTR_ALIGN((void *)ctx->ctx, alignmask + 1);
+	u8 *odds = ctx->odds;
 	u8 *prev = odds + bs;
 	unsigned int offset = 0;
 
 	if (ctx->len != bs) {
 		unsigned int rlen;
 		u8 *p = odds + ctx->len;
 
 		*p = 0x80;
 		p++;
 
 		rlen = bs - ctx->len - 1;
 		if (rlen)
 			memset(p, 0, rlen);
 
 		offset += bs;
 	}
 
 	crypto_xor(prev, odds, bs);
-	crypto_xor(prev, consts + offset, bs);
+	crypto_xor(prev, (const u8 *)tctx->consts + offset, bs);
 
 	crypto_cipher_encrypt_one(tfm, out, prev);
 
 	return 0;
 }
 
 static int cmac_init_tfm(struct crypto_shash *tfm)
 {
 	struct shash_instance *inst = shash_alg_instance(tfm);
 	struct cmac_tfm_ctx *ctx = crypto_shash_ctx(tfm);
@@ -234,21 +227,20 @@ static void cmac_exit_tfm(struct crypto_shash *tfm)
 {
 	struct cmac_tfm_ctx *ctx = crypto_shash_ctx(tfm);
 	crypto_free_cipher(ctx->child);
 }
 
 static int cmac_create(struct crypto_template *tmpl, struct rtattr **tb)
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
@@ -266,37 +258,28 @@ static int cmac_create(struct crypto_template *tmpl, struct rtattr **tb)
 		break;
 	default:
 		err = -EINVAL;
 		goto err_free_inst;
 	}
 
 	err = crypto_inst_setname(shash_crypto_instance(inst), tmpl->name, alg);
 	if (err)
 		goto err_free_inst;
 
-	alignmask = alg->cra_alignmask;
-	inst->alg.base.cra_alignmask = alignmask;
 	inst->alg.base.cra_priority = alg->cra_priority;
 	inst->alg.base.cra_blocksize = alg->cra_blocksize;
+	inst->alg.base.cra_ctxsize = sizeof(struct cmac_tfm_ctx) +
+				     alg->cra_blocksize * 2;
 
 	inst->alg.digestsize = alg->cra_blocksize;
-	inst->alg.descsize =
-		ALIGN(sizeof(struct cmac_desc_ctx), crypto_tfm_ctx_alignment())
-		+ (alignmask & ~(crypto_tfm_ctx_alignment() - 1))
-		+ alg->cra_blocksize * 2;
-
-	inst->alg.base.cra_ctxsize =
-		ALIGN(sizeof(struct cmac_tfm_ctx), crypto_tfm_ctx_alignment())
-		+ ((alignmask | (__alignof__(__be64) - 1)) &
-		   ~(crypto_tfm_ctx_alignment() - 1))
-		+ alg->cra_blocksize * 2;
-
+	inst->alg.descsize = sizeof(struct cmac_desc_ctx) +
+			     alg->cra_blocksize * 2;
 	inst->alg.init = crypto_cmac_digest_init;
 	inst->alg.update = crypto_cmac_digest_update;
 	inst->alg.final = crypto_cmac_digest_final;
 	inst->alg.setkey = crypto_cmac_digest_setkey;
 	inst->alg.init_tfm = cmac_init_tfm;
 	inst->alg.clone_tfm = cmac_clone_tfm;
 	inst->alg.exit_tfm = cmac_exit_tfm;
 
 	inst->free = shash_free_singlespawn_instance;
 
-- 
2.42.0


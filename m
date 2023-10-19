Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DC290CDB465
	for <linux-crypto@archiver.kernel.org>; Thu, 19 Oct 2023 05:54:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232583AbjJSFyR (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 19 Oct 2023 01:54:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34358 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232614AbjJSFyP (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 19 Oct 2023 01:54:15 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 23132B6
        for <linux-crypto@vger.kernel.org>; Wed, 18 Oct 2023 22:54:14 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B67E6C433CD
        for <linux-crypto@vger.kernel.org>; Thu, 19 Oct 2023 05:54:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1697694853;
        bh=i4wpB1M5Ma47I5Q4K7RKZN0PvPuyNWlMWM67kM5wTBU=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=G/XhY4obiqNb1dK1MTCBu7LtZgmEdkVoFecth8YTIGjjEG1n196WSO9lTjeO2QLL9
         fXJk2bBkPl9aln9s0u2MlnhXs5ER86XTrIP5NYezVPm1h7F2H1Y7sUITc2hyoKTRw8
         sPp5541d+tyBb5DYoraSSmAD7TtvUN96r8KLeAcJUGVkl5pBMGQ8CVgXOkNGZ6q/Gh
         oz2cIyxoOvXGhcB67Zweh8K1/ZnGcNmrRHheJeJCSbFd8OJA+VXSCbR6ip/caIDW29
         RQcF16WF4M+8IGFdSgOWOEngLCNZxx8cnLq3Wle3xNunreUxTZKdOiI+1Dm48/Tt+6
         C4MQBXR1UyjWw==
From:   Eric Biggers <ebiggers@kernel.org>
To:     linux-crypto@vger.kernel.org
Subject: [PATCH 06/17] crypto: cbcmac - remove unnecessary alignment logic
Date:   Wed, 18 Oct 2023 22:53:32 -0700
Message-ID: <20231019055343.588846-7-ebiggers@kernel.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231019055343.588846-1-ebiggers@kernel.org>
References: <20231019055343.588846-1-ebiggers@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

From: Eric Biggers <ebiggers@google.com>

The cbcmac template is aligning a field in its desc context to the
alignmask of its underlying 'cipher', at runtime.  This is almost
entirely pointless, since cbcmac is already using the cipher API
functions that handle alignment themselves, and few ciphers set a
nonzero alignmask anyway.  Also, even without runtime alignment, an
alignment of at least 4 bytes can be guaranteed.

Thus, at best this code is optimizing for the rare case of ciphers that
set an alignmask >= 7, at the cost of hurting the common cases.

Therefore, remove the manual alignment code from cbcmac.

Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 crypto/ccm.c | 17 +++++++----------
 1 file changed, 7 insertions(+), 10 deletions(-)

diff --git a/crypto/ccm.c b/crypto/ccm.c
index 7af89a5b745c4..dd7aed63efc93 100644
--- a/crypto/ccm.c
+++ b/crypto/ccm.c
@@ -49,20 +49,21 @@ struct crypto_ccm_req_priv_ctx {
 		struct skcipher_request skreq;
 	};
 };
 
 struct cbcmac_tfm_ctx {
 	struct crypto_cipher *child;
 };
 
 struct cbcmac_desc_ctx {
 	unsigned int len;
+	u8 dg[];
 };
 
 static inline struct crypto_ccm_req_priv_ctx *crypto_ccm_reqctx(
 	struct aead_request *req)
 {
 	unsigned long align = crypto_aead_alignmask(crypto_aead_reqtfm(req));
 
 	return (void *)PTR_ALIGN((u8 *)aead_request_ctx(req), align + 1);
 }
 
@@ -778,68 +779,65 @@ static int crypto_cbcmac_digest_setkey(struct crypto_shash *parent,
 {
 	struct cbcmac_tfm_ctx *ctx = crypto_shash_ctx(parent);
 
 	return crypto_cipher_setkey(ctx->child, inkey, keylen);
 }
 
 static int crypto_cbcmac_digest_init(struct shash_desc *pdesc)
 {
 	struct cbcmac_desc_ctx *ctx = shash_desc_ctx(pdesc);
 	int bs = crypto_shash_digestsize(pdesc->tfm);
-	u8 *dg = (u8 *)ctx + crypto_shash_descsize(pdesc->tfm) - bs;
 
 	ctx->len = 0;
-	memset(dg, 0, bs);
+	memset(ctx->dg, 0, bs);
 
 	return 0;
 }
 
 static int crypto_cbcmac_digest_update(struct shash_desc *pdesc, const u8 *p,
 				       unsigned int len)
 {
 	struct crypto_shash *parent = pdesc->tfm;
 	struct cbcmac_tfm_ctx *tctx = crypto_shash_ctx(parent);
 	struct cbcmac_desc_ctx *ctx = shash_desc_ctx(pdesc);
 	struct crypto_cipher *tfm = tctx->child;
 	int bs = crypto_shash_digestsize(parent);
-	u8 *dg = (u8 *)ctx + crypto_shash_descsize(parent) - bs;
 
 	while (len > 0) {
 		unsigned int l = min(len, bs - ctx->len);
 
-		crypto_xor(dg + ctx->len, p, l);
+		crypto_xor(&ctx->dg[ctx->len], p, l);
 		ctx->len +=l;
 		len -= l;
 		p += l;
 
 		if (ctx->len == bs) {
-			crypto_cipher_encrypt_one(tfm, dg, dg);
+			crypto_cipher_encrypt_one(tfm, ctx->dg, ctx->dg);
 			ctx->len = 0;
 		}
 	}
 
 	return 0;
 }
 
 static int crypto_cbcmac_digest_final(struct shash_desc *pdesc, u8 *out)
 {
 	struct crypto_shash *parent = pdesc->tfm;
 	struct cbcmac_tfm_ctx *tctx = crypto_shash_ctx(parent);
 	struct cbcmac_desc_ctx *ctx = shash_desc_ctx(pdesc);
 	struct crypto_cipher *tfm = tctx->child;
 	int bs = crypto_shash_digestsize(parent);
-	u8 *dg = (u8 *)ctx + crypto_shash_descsize(parent) - bs;
 
 	if (ctx->len)
-		crypto_cipher_encrypt_one(tfm, dg, dg);
+		crypto_cipher_encrypt_one(tfm, ctx->dg, ctx->dg);
 
-	memcpy(out, dg, bs);
+	memcpy(out, ctx->dg, bs);
 	return 0;
 }
 
 static int cbcmac_init_tfm(struct crypto_tfm *tfm)
 {
 	struct crypto_cipher *cipher;
 	struct crypto_instance *inst = (void *)tfm->__crt_alg;
 	struct crypto_cipher_spawn *spawn = crypto_instance_ctx(inst);
 	struct cbcmac_tfm_ctx *ctx = crypto_tfm_ctx(tfm);
 
@@ -882,22 +880,21 @@ static int cbcmac_create(struct crypto_template *tmpl, struct rtattr **tb)
 	alg = crypto_spawn_cipher_alg(spawn);
 
 	err = crypto_inst_setname(shash_crypto_instance(inst), tmpl->name, alg);
 	if (err)
 		goto err_free_inst;
 
 	inst->alg.base.cra_priority = alg->cra_priority;
 	inst->alg.base.cra_blocksize = 1;
 
 	inst->alg.digestsize = alg->cra_blocksize;
-	inst->alg.descsize = ALIGN(sizeof(struct cbcmac_desc_ctx),
-				   alg->cra_alignmask + 1) +
+	inst->alg.descsize = sizeof(struct cbcmac_desc_ctx) +
 			     alg->cra_blocksize;
 
 	inst->alg.base.cra_ctxsize = sizeof(struct cbcmac_tfm_ctx);
 	inst->alg.base.cra_init = cbcmac_init_tfm;
 	inst->alg.base.cra_exit = cbcmac_exit_tfm;
 
 	inst->alg.init = crypto_cbcmac_digest_init;
 	inst->alg.update = crypto_cbcmac_digest_update;
 	inst->alg.final = crypto_cbcmac_digest_final;
 	inst->alg.setkey = crypto_cbcmac_digest_setkey;
-- 
2.42.0


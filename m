Return-Path: <SRS0=t+Y3=BH=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.0 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E8FC2C4345C
	for <linux-crypto@archiver.kernel.org>; Tue, 28 Jul 2020 07:19:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C9BE9207E8
	for <linux-crypto@archiver.kernel.org>; Tue, 28 Jul 2020 07:19:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727908AbgG1HTZ (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 28 Jul 2020 03:19:25 -0400
Received: from helcar.hmeau.com ([216.24.177.18]:54870 "EHLO fornost.hmeau.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727852AbgG1HTZ (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 28 Jul 2020 03:19:25 -0400
Received: from gwarestrin.arnor.me.apana.org.au ([192.168.0.7])
        by fornost.hmeau.com with smtp (Exim 4.92 #5 (Debian))
        id 1k0JtR-0006Rx-Oq; Tue, 28 Jul 2020 17:19:22 +1000
Received: by gwarestrin.arnor.me.apana.org.au (sSMTP sendmail emulation); Tue, 28 Jul 2020 17:19:21 +1000
From:   "Herbert Xu" <herbert@gondor.apana.org.au>
Date:   Tue, 28 Jul 2020 17:19:21 +1000
Subject: [v3 PATCH 19/31] crypto: caam - Remove rfc3686 implementations
References: <20200728071746.GA22352@gondor.apana.org.au>
To:     Ard Biesheuvel <ardb@kernel.org>,
        Stephan Mueller <smueller@chronox.de>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        Eric Biggers <ebiggers@kernel.org>
Message-Id: <E1k0JtR-0006Rx-Oq@fornost.hmeau.com>
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

The rfc3686 implementations in caam are pretty much the same
as the generic rfc3686 wrapper.  So they can simply be removed
to reduce complexity.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
---

 drivers/crypto/caam/caamalg.c      |   54 +------------------------------------
 drivers/crypto/caam/caamalg_desc.c |   46 +------------------------------
 drivers/crypto/caam/caamalg_desc.h |    6 +---
 drivers/crypto/caam/caamalg_qi.c   |   52 +----------------------------------
 drivers/crypto/caam/caamalg_qi2.c  |   54 +------------------------------------
 5 files changed, 10 insertions(+), 202 deletions(-)

diff --git a/drivers/crypto/caam/caamalg.c b/drivers/crypto/caam/caamalg.c
index e94e7f27f1d0d..4a787f74ebf9c 100644
--- a/drivers/crypto/caam/caamalg.c
+++ b/drivers/crypto/caam/caamalg.c
@@ -725,13 +725,9 @@ static int skcipher_setkey(struct crypto_skcipher *skcipher, const u8 *key,
 			   unsigned int keylen, const u32 ctx1_iv_off)
 {
 	struct caam_ctx *ctx = crypto_skcipher_ctx(skcipher);
-	struct caam_skcipher_alg *alg =
-		container_of(crypto_skcipher_alg(skcipher), typeof(*alg),
-			     skcipher);
 	struct device *jrdev = ctx->jrdev;
 	unsigned int ivsize = crypto_skcipher_ivsize(skcipher);
 	u32 *desc;
-	const bool is_rfc3686 = alg->caam.rfc3686;
 
 	print_hex_dump_debug("key in @"__stringify(__LINE__)": ",
 			     DUMP_PREFIX_ADDRESS, 16, 4, key, keylen, 1);
@@ -742,15 +738,13 @@ static int skcipher_setkey(struct crypto_skcipher *skcipher, const u8 *key,
 
 	/* skcipher_encrypt shared descriptor */
 	desc = ctx->sh_desc_enc;
-	cnstr_shdsc_skcipher_encap(desc, &ctx->cdata, ivsize, is_rfc3686,
-				   ctx1_iv_off);
+	cnstr_shdsc_skcipher_encap(desc, &ctx->cdata, ivsize, ctx1_iv_off);
 	dma_sync_single_for_device(jrdev, ctx->sh_desc_enc_dma,
 				   desc_bytes(desc), ctx->dir);
 
 	/* skcipher_decrypt shared descriptor */
 	desc = ctx->sh_desc_dec;
-	cnstr_shdsc_skcipher_decap(desc, &ctx->cdata, ivsize, is_rfc3686,
-				   ctx1_iv_off);
+	cnstr_shdsc_skcipher_decap(desc, &ctx->cdata, ivsize, ctx1_iv_off);
 	dma_sync_single_for_device(jrdev, ctx->sh_desc_dec_dma,
 				   desc_bytes(desc), ctx->dir);
 
@@ -769,27 +763,6 @@ static int aes_skcipher_setkey(struct crypto_skcipher *skcipher,
 	return skcipher_setkey(skcipher, key, keylen, 0);
 }
 
-static int rfc3686_skcipher_setkey(struct crypto_skcipher *skcipher,
-				   const u8 *key, unsigned int keylen)
-{
-	u32 ctx1_iv_off;
-	int err;
-
-	/*
-	 * RFC3686 specific:
-	 *	| CONTEXT1[255:128] = {NONCE, IV, COUNTER}
-	 *	| *key = {KEY, NONCE}
-	 */
-	ctx1_iv_off = 16 + CTR_RFC3686_NONCE_SIZE;
-	keylen -= CTR_RFC3686_NONCE_SIZE;
-
-	err = aes_check_keylen(keylen);
-	if (err)
-		return err;
-
-	return skcipher_setkey(skcipher, key, keylen, ctx1_iv_off);
-}
-
 static int ctr_skcipher_setkey(struct crypto_skcipher *skcipher,
 			       const u8 *key, unsigned int keylen)
 {
@@ -1877,29 +1850,6 @@ static struct caam_skcipher_alg driver_algs[] = {
 		.caam.class1_alg_type = OP_ALG_ALGSEL_AES |
 					OP_ALG_AAI_CTR_MOD128,
 	},
-	{
-		.skcipher = {
-			.base = {
-				.cra_name = "rfc3686(ctr(aes))",
-				.cra_driver_name = "rfc3686-ctr-aes-caam",
-				.cra_blocksize = 1,
-			},
-			.setkey = rfc3686_skcipher_setkey,
-			.encrypt = skcipher_encrypt,
-			.decrypt = skcipher_decrypt,
-			.min_keysize = AES_MIN_KEY_SIZE +
-				       CTR_RFC3686_NONCE_SIZE,
-			.max_keysize = AES_MAX_KEY_SIZE +
-				       CTR_RFC3686_NONCE_SIZE,
-			.ivsize = CTR_RFC3686_IV_SIZE,
-			.chunksize = AES_BLOCK_SIZE,
-		},
-		.caam = {
-			.class1_alg_type = OP_ALG_ALGSEL_AES |
-					   OP_ALG_AAI_CTR_MOD128,
-			.rfc3686 = true,
-		},
-	},
 	{
 		.skcipher = {
 			.base = {
diff --git a/drivers/crypto/caam/caamalg_desc.c b/drivers/crypto/caam/caamalg_desc.c
index d6c58184bb57c..e9b32f151b0da 100644
--- a/drivers/crypto/caam/caamalg_desc.c
+++ b/drivers/crypto/caam/caamalg_desc.c
@@ -1371,12 +1371,10 @@ static inline void skcipher_append_src_dst(u32 *desc)
  *         with OP_ALG_AAI_CBC or OP_ALG_AAI_CTR_MOD128
  *                                - OP_ALG_ALGSEL_CHACHA20
  * @ivsize: initialization vector size
- * @is_rfc3686: true when ctr(aes) is wrapped by rfc3686 template
  * @ctx1_iv_off: IV offset in CONTEXT1 register
  */
 void cnstr_shdsc_skcipher_encap(u32 * const desc, struct alginfo *cdata,
-				unsigned int ivsize, const bool is_rfc3686,
-				const u32 ctx1_iv_off)
+				unsigned int ivsize, const u32 ctx1_iv_off)
 {
 	u32 *key_jump_cmd;
 	u32 options = cdata->algtype | OP_ALG_AS_INIT | OP_ALG_ENCRYPT;
@@ -1392,18 +1390,6 @@ void cnstr_shdsc_skcipher_encap(u32 * const desc, struct alginfo *cdata,
 	append_key_as_imm(desc, cdata->key_virt, cdata->keylen,
 			  cdata->keylen, CLASS_1 | KEY_DEST_CLASS_REG);
 
-	/* Load nonce into CONTEXT1 reg */
-	if (is_rfc3686) {
-		const u8 *nonce = cdata->key_virt + cdata->keylen;
-
-		append_load_as_imm(desc, nonce, CTR_RFC3686_NONCE_SIZE,
-				   LDST_CLASS_IND_CCB |
-				   LDST_SRCDST_BYTE_OUTFIFO | LDST_IMM);
-		append_move(desc, MOVE_WAITCOMP | MOVE_SRC_OUTFIFO |
-			    MOVE_DEST_CLASS1CTX | (16 << MOVE_OFFSET_SHIFT) |
-			    (CTR_RFC3686_NONCE_SIZE << MOVE_LEN_SHIFT));
-	}
-
 	set_jump_tgt_here(desc, key_jump_cmd);
 
 	/* Load IV, if there is one */
@@ -1412,13 +1398,6 @@ void cnstr_shdsc_skcipher_encap(u32 * const desc, struct alginfo *cdata,
 				LDST_CLASS_1_CCB | (ctx1_iv_off <<
 				LDST_OFFSET_SHIFT));
 
-	/* Load counter into CONTEXT1 reg */
-	if (is_rfc3686)
-		append_load_imm_be32(desc, 1, LDST_IMM | LDST_CLASS_1_CCB |
-				     LDST_SRCDST_BYTE_CONTEXT |
-				     ((ctx1_iv_off + CTR_RFC3686_IV_SIZE) <<
-				      LDST_OFFSET_SHIFT));
-
 	/* Load operation */
 	if (is_chacha20)
 		options |= OP_ALG_AS_FINALIZE;
@@ -1447,12 +1426,10 @@ EXPORT_SYMBOL(cnstr_shdsc_skcipher_encap);
  *         with OP_ALG_AAI_CBC or OP_ALG_AAI_CTR_MOD128
  *                                - OP_ALG_ALGSEL_CHACHA20
  * @ivsize: initialization vector size
- * @is_rfc3686: true when ctr(aes) is wrapped by rfc3686 template
  * @ctx1_iv_off: IV offset in CONTEXT1 register
  */
 void cnstr_shdsc_skcipher_decap(u32 * const desc, struct alginfo *cdata,
-				unsigned int ivsize, const bool is_rfc3686,
-				const u32 ctx1_iv_off)
+				unsigned int ivsize, const u32 ctx1_iv_off)
 {
 	u32 *key_jump_cmd;
 	bool is_chacha20 = ((cdata->algtype & OP_ALG_ALGSEL_MASK) ==
@@ -1467,18 +1444,6 @@ void cnstr_shdsc_skcipher_decap(u32 * const desc, struct alginfo *cdata,
 	append_key_as_imm(desc, cdata->key_virt, cdata->keylen,
 			  cdata->keylen, CLASS_1 | KEY_DEST_CLASS_REG);
 
-	/* Load nonce into CONTEXT1 reg */
-	if (is_rfc3686) {
-		const u8 *nonce = cdata->key_virt + cdata->keylen;
-
-		append_load_as_imm(desc, nonce, CTR_RFC3686_NONCE_SIZE,
-				   LDST_CLASS_IND_CCB |
-				   LDST_SRCDST_BYTE_OUTFIFO | LDST_IMM);
-		append_move(desc, MOVE_WAITCOMP | MOVE_SRC_OUTFIFO |
-			    MOVE_DEST_CLASS1CTX | (16 << MOVE_OFFSET_SHIFT) |
-			    (CTR_RFC3686_NONCE_SIZE << MOVE_LEN_SHIFT));
-	}
-
 	set_jump_tgt_here(desc, key_jump_cmd);
 
 	/* Load IV, if there is one */
@@ -1487,13 +1452,6 @@ void cnstr_shdsc_skcipher_decap(u32 * const desc, struct alginfo *cdata,
 				LDST_CLASS_1_CCB | (ctx1_iv_off <<
 				LDST_OFFSET_SHIFT));
 
-	/* Load counter into CONTEXT1 reg */
-	if (is_rfc3686)
-		append_load_imm_be32(desc, 1, LDST_IMM | LDST_CLASS_1_CCB |
-				     LDST_SRCDST_BYTE_CONTEXT |
-				     ((ctx1_iv_off + CTR_RFC3686_IV_SIZE) <<
-				      LDST_OFFSET_SHIFT));
-
 	/* Choose operation */
 	if (ctx1_iv_off)
 		append_operation(desc, cdata->algtype | OP_ALG_AS_INIT |
diff --git a/drivers/crypto/caam/caamalg_desc.h b/drivers/crypto/caam/caamalg_desc.h
index f2893393ba5e7..ac3d3ebc544e2 100644
--- a/drivers/crypto/caam/caamalg_desc.h
+++ b/drivers/crypto/caam/caamalg_desc.h
@@ -102,12 +102,10 @@ void cnstr_shdsc_chachapoly(u32 * const desc, struct alginfo *cdata,
 			    const bool is_qi);
 
 void cnstr_shdsc_skcipher_encap(u32 * const desc, struct alginfo *cdata,
-				unsigned int ivsize, const bool is_rfc3686,
-				const u32 ctx1_iv_off);
+				unsigned int ivsize, const u32 ctx1_iv_off);
 
 void cnstr_shdsc_skcipher_decap(u32 * const desc, struct alginfo *cdata,
-				unsigned int ivsize, const bool is_rfc3686,
-				const u32 ctx1_iv_off);
+				unsigned int ivsize, const u32 ctx1_iv_off);
 
 void cnstr_shdsc_xts_skcipher_encap(u32 * const desc, struct alginfo *cdata);
 
diff --git a/drivers/crypto/caam/caamalg_qi.c b/drivers/crypto/caam/caamalg_qi.c
index efe8f15a4a51a..a140e9090d244 100644
--- a/drivers/crypto/caam/caamalg_qi.c
+++ b/drivers/crypto/caam/caamalg_qi.c
@@ -610,12 +610,8 @@ static int skcipher_setkey(struct crypto_skcipher *skcipher, const u8 *key,
 			   unsigned int keylen, const u32 ctx1_iv_off)
 {
 	struct caam_ctx *ctx = crypto_skcipher_ctx(skcipher);
-	struct caam_skcipher_alg *alg =
-		container_of(crypto_skcipher_alg(skcipher), typeof(*alg),
-			     skcipher);
 	struct device *jrdev = ctx->jrdev;
 	unsigned int ivsize = crypto_skcipher_ivsize(skcipher);
-	const bool is_rfc3686 = alg->caam.rfc3686;
 	int ret = 0;
 
 	print_hex_dump_debug("key in @" __stringify(__LINE__)": ",
@@ -627,9 +623,9 @@ static int skcipher_setkey(struct crypto_skcipher *skcipher, const u8 *key,
 
 	/* skcipher encrypt, decrypt shared descriptors */
 	cnstr_shdsc_skcipher_encap(ctx->sh_desc_enc, &ctx->cdata, ivsize,
-				   is_rfc3686, ctx1_iv_off);
+				   ctx1_iv_off);
 	cnstr_shdsc_skcipher_decap(ctx->sh_desc_dec, &ctx->cdata, ivsize,
-				   is_rfc3686, ctx1_iv_off);
+				   ctx1_iv_off);
 
 	/* Now update the driver contexts with the new shared descriptor */
 	if (ctx->drv_ctx[ENCRYPT]) {
@@ -665,27 +661,6 @@ static int aes_skcipher_setkey(struct crypto_skcipher *skcipher,
 	return skcipher_setkey(skcipher, key, keylen, 0);
 }
 
-static int rfc3686_skcipher_setkey(struct crypto_skcipher *skcipher,
-				   const u8 *key, unsigned int keylen)
-{
-	u32 ctx1_iv_off;
-	int err;
-
-	/*
-	 * RFC3686 specific:
-	 *	| CONTEXT1[255:128] = {NONCE, IV, COUNTER}
-	 *	| *key = {KEY, NONCE}
-	 */
-	ctx1_iv_off = 16 + CTR_RFC3686_NONCE_SIZE;
-	keylen -= CTR_RFC3686_NONCE_SIZE;
-
-	err = aes_check_keylen(keylen);
-	if (err)
-		return err;
-
-	return skcipher_setkey(skcipher, key, keylen, ctx1_iv_off);
-}
-
 static int ctr_skcipher_setkey(struct crypto_skcipher *skcipher,
 			       const u8 *key, unsigned int keylen)
 {
@@ -1479,29 +1454,6 @@ static struct caam_skcipher_alg driver_algs[] = {
 		.caam.class1_alg_type = OP_ALG_ALGSEL_AES |
 					OP_ALG_AAI_CTR_MOD128,
 	},
-	{
-		.skcipher = {
-			.base = {
-				.cra_name = "rfc3686(ctr(aes))",
-				.cra_driver_name = "rfc3686-ctr-aes-caam-qi",
-				.cra_blocksize = 1,
-			},
-			.setkey = rfc3686_skcipher_setkey,
-			.encrypt = skcipher_encrypt,
-			.decrypt = skcipher_decrypt,
-			.min_keysize = AES_MIN_KEY_SIZE +
-				       CTR_RFC3686_NONCE_SIZE,
-			.max_keysize = AES_MAX_KEY_SIZE +
-				       CTR_RFC3686_NONCE_SIZE,
-			.ivsize = CTR_RFC3686_IV_SIZE,
-			.chunksize = AES_BLOCK_SIZE,
-		},
-		.caam = {
-			.class1_alg_type = OP_ALG_ALGSEL_AES |
-					   OP_ALG_AAI_CTR_MOD128,
-			.rfc3686 = true,
-		},
-	},
 	{
 		.skcipher = {
 			.base = {
diff --git a/drivers/crypto/caam/caamalg_qi2.c b/drivers/crypto/caam/caamalg_qi2.c
index 6294c104bf7a9..fd0f070fb9971 100644
--- a/drivers/crypto/caam/caamalg_qi2.c
+++ b/drivers/crypto/caam/caamalg_qi2.c
@@ -934,14 +934,10 @@ static int skcipher_setkey(struct crypto_skcipher *skcipher, const u8 *key,
 			   unsigned int keylen, const u32 ctx1_iv_off)
 {
 	struct caam_ctx *ctx = crypto_skcipher_ctx(skcipher);
-	struct caam_skcipher_alg *alg =
-		container_of(crypto_skcipher_alg(skcipher),
-			     struct caam_skcipher_alg, skcipher);
 	struct device *dev = ctx->dev;
 	struct caam_flc *flc;
 	unsigned int ivsize = crypto_skcipher_ivsize(skcipher);
 	u32 *desc;
-	const bool is_rfc3686 = alg->caam.rfc3686;
 
 	print_hex_dump_debug("key in @" __stringify(__LINE__)": ",
 			     DUMP_PREFIX_ADDRESS, 16, 4, key, keylen, 1);
@@ -953,8 +949,7 @@ static int skcipher_setkey(struct crypto_skcipher *skcipher, const u8 *key,
 	/* skcipher_encrypt shared descriptor */
 	flc = &ctx->flc[ENCRYPT];
 	desc = flc->sh_desc;
-	cnstr_shdsc_skcipher_encap(desc, &ctx->cdata, ivsize, is_rfc3686,
-				   ctx1_iv_off);
+	cnstr_shdsc_skcipher_encap(desc, &ctx->cdata, ivsize, ctx1_iv_off);
 	flc->flc[1] = cpu_to_caam32(desc_len(desc)); /* SDL */
 	dma_sync_single_for_device(dev, ctx->flc_dma[ENCRYPT],
 				   sizeof(flc->flc) + desc_bytes(desc),
@@ -963,8 +958,7 @@ static int skcipher_setkey(struct crypto_skcipher *skcipher, const u8 *key,
 	/* skcipher_decrypt shared descriptor */
 	flc = &ctx->flc[DECRYPT];
 	desc = flc->sh_desc;
-	cnstr_shdsc_skcipher_decap(desc, &ctx->cdata, ivsize, is_rfc3686,
-				   ctx1_iv_off);
+	cnstr_shdsc_skcipher_decap(desc, &ctx->cdata, ivsize, ctx1_iv_off);
 	flc->flc[1] = cpu_to_caam32(desc_len(desc)); /* SDL */
 	dma_sync_single_for_device(dev, ctx->flc_dma[DECRYPT],
 				   sizeof(flc->flc) + desc_bytes(desc),
@@ -985,27 +979,6 @@ static int aes_skcipher_setkey(struct crypto_skcipher *skcipher,
 	return skcipher_setkey(skcipher, key, keylen, 0);
 }
 
-static int rfc3686_skcipher_setkey(struct crypto_skcipher *skcipher,
-				   const u8 *key, unsigned int keylen)
-{
-	u32 ctx1_iv_off;
-	int err;
-
-	/*
-	 * RFC3686 specific:
-	 *	| CONTEXT1[255:128] = {NONCE, IV, COUNTER}
-	 *	| *key = {KEY, NONCE}
-	 */
-	ctx1_iv_off = 16 + CTR_RFC3686_NONCE_SIZE;
-	keylen -= CTR_RFC3686_NONCE_SIZE;
-
-	err = aes_check_keylen(keylen);
-	if (err)
-		return err;
-
-	return skcipher_setkey(skcipher, key, keylen, ctx1_iv_off);
-}
-
 static int ctr_skcipher_setkey(struct crypto_skcipher *skcipher,
 			       const u8 *key, unsigned int keylen)
 {
@@ -1637,29 +1610,6 @@ static struct caam_skcipher_alg driver_algs[] = {
 		.caam.class1_alg_type = OP_ALG_ALGSEL_AES |
 					OP_ALG_AAI_CTR_MOD128,
 	},
-	{
-		.skcipher = {
-			.base = {
-				.cra_name = "rfc3686(ctr(aes))",
-				.cra_driver_name = "rfc3686-ctr-aes-caam-qi2",
-				.cra_blocksize = 1,
-			},
-			.setkey = rfc3686_skcipher_setkey,
-			.encrypt = skcipher_encrypt,
-			.decrypt = skcipher_decrypt,
-			.min_keysize = AES_MIN_KEY_SIZE +
-				       CTR_RFC3686_NONCE_SIZE,
-			.max_keysize = AES_MAX_KEY_SIZE +
-				       CTR_RFC3686_NONCE_SIZE,
-			.ivsize = CTR_RFC3686_IV_SIZE,
-			.chunksize = AES_BLOCK_SIZE,
-		},
-		.caam = {
-			.class1_alg_type = OP_ALG_ALGSEL_AES |
-					   OP_ALG_AAI_CTR_MOD128,
-			.rfc3686 = true,
-		},
-	},
 	{
 		.skcipher = {
 			.base = {

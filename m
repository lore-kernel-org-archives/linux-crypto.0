Return-Path: <SRS0=t+Y3=BH=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.0 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7F7EBC433EC
	for <linux-crypto@archiver.kernel.org>; Tue, 28 Jul 2020 07:18:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 60859207F5
	for <linux-crypto@archiver.kernel.org>; Tue, 28 Jul 2020 07:18:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727907AbgG1HSy (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 28 Jul 2020 03:18:54 -0400
Received: from helcar.hmeau.com ([216.24.177.18]:54764 "EHLO fornost.hmeau.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727904AbgG1HSy (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 28 Jul 2020 03:18:54 -0400
Received: from gwarestrin.arnor.me.apana.org.au ([192.168.0.7])
        by fornost.hmeau.com with smtp (Exim 4.92 #5 (Debian))
        id 1k0Jsx-0006Jt-2z; Tue, 28 Jul 2020 17:18:52 +1000
Received: by gwarestrin.arnor.me.apana.org.au (sSMTP sendmail emulation); Tue, 28 Jul 2020 17:18:51 +1000
From:   "Herbert Xu" <herbert@gondor.apana.org.au>
Date:   Tue, 28 Jul 2020 17:18:51 +1000
Subject: [v3 PATCH 6/31] crypto: ccree - Add support for chaining CTS
References: <20200728071746.GA22352@gondor.apana.org.au>
To:     Ard Biesheuvel <ardb@kernel.org>,
        Stephan Mueller <smueller@chronox.de>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        Eric Biggers <ebiggers@kernel.org>
Message-Id: <E1k0Jsx-0006Jt-2z@fornost.hmeau.com>
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

As it stands cts cannot do chaining.  That is, it always performs
the cipher-text stealing at the end of a request.  This patch adds
support for chaining when the CRYPTO_TM_REQ_MORE flag is set.

It also sets the final_chunksize so that data can be withheld by
the caller to enable correct processing at the true end of a request.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
---

 drivers/crypto/ccree/cc_cipher.c |   72 +++++++++++++++++++++++++--------------
 1 file changed, 47 insertions(+), 25 deletions(-)

diff --git a/drivers/crypto/ccree/cc_cipher.c b/drivers/crypto/ccree/cc_cipher.c
index beeb283c3c949..83567b60d6908 100644
--- a/drivers/crypto/ccree/cc_cipher.c
+++ b/drivers/crypto/ccree/cc_cipher.c
@@ -61,9 +61,9 @@ struct cc_cipher_ctx {
 
 static void cc_cipher_complete(struct device *dev, void *cc_req, int err);
 
-static inline enum cc_key_type cc_key_type(struct crypto_tfm *tfm)
+static inline enum cc_key_type cc_key_type(struct crypto_skcipher *tfm)
 {
-	struct cc_cipher_ctx *ctx_p = crypto_tfm_ctx(tfm);
+	struct cc_cipher_ctx *ctx_p = crypto_skcipher_ctx(tfm);
 
 	return ctx_p->key_type;
 }
@@ -105,12 +105,26 @@ static int validate_keys_sizes(struct cc_cipher_ctx *ctx_p, u32 size)
 	return -EINVAL;
 }
 
-static int validate_data_size(struct cc_cipher_ctx *ctx_p,
+static inline int req_cipher_mode(struct skcipher_request *req)
+{
+	struct crypto_skcipher *tfm = crypto_skcipher_reqtfm(req);
+	struct cc_cipher_ctx *ctx_p = crypto_skcipher_ctx(tfm);
+	int cipher_mode = ctx_p->cipher_mode;
+
+	if (cipher_mode == DRV_CIPHER_CBC_CTS &&
+	    req->base.flags & CRYPTO_TFM_REQ_MORE)
+		cipher_mode = DRV_CIPHER_CBC;
+
+	return cipher_mode;
+}
+
+static int validate_data_size(struct skcipher_request *req,
+			      struct cc_cipher_ctx *ctx_p,
 			      unsigned int size)
 {
 	switch (ctx_p->flow_mode) {
 	case S_DIN_to_AES:
-		switch (ctx_p->cipher_mode) {
+		switch (req_cipher_mode(req)) {
 		case DRV_CIPHER_XTS:
 		case DRV_CIPHER_CBC_CTS:
 			if (size >= AES_BLOCK_SIZE)
@@ -508,17 +522,18 @@ static int cc_out_setup_mode(struct cc_cipher_ctx *ctx_p)
 	}
 }
 
-static void cc_setup_readiv_desc(struct crypto_tfm *tfm,
+static void cc_setup_readiv_desc(struct skcipher_request *req,
 				 struct cipher_req_ctx *req_ctx,
 				 unsigned int ivsize, struct cc_hw_desc desc[],
 				 unsigned int *seq_size)
 {
-	struct cc_cipher_ctx *ctx_p = crypto_tfm_ctx(tfm);
+	struct crypto_skcipher *tfm = crypto_skcipher_reqtfm(req);
+	struct cc_cipher_ctx *ctx_p = crypto_skcipher_ctx(tfm);
 	struct device *dev = drvdata_to_dev(ctx_p->drvdata);
-	int cipher_mode = ctx_p->cipher_mode;
 	int flow_mode = cc_out_setup_mode(ctx_p);
 	int direction = req_ctx->gen_ctx.op_type;
 	dma_addr_t iv_dma_addr = req_ctx->gen_ctx.iv_dma_addr;
+	int cipher_mode = req_cipher_mode(req);
 
 	if (ctx_p->key_type == CC_POLICY_PROTECTED_KEY)
 		return;
@@ -565,15 +580,16 @@ static void cc_setup_readiv_desc(struct crypto_tfm *tfm,
 }
 
 
-static void cc_setup_state_desc(struct crypto_tfm *tfm,
+static void cc_setup_state_desc(struct skcipher_request *req,
 				 struct cipher_req_ctx *req_ctx,
 				 unsigned int ivsize, unsigned int nbytes,
 				 struct cc_hw_desc desc[],
 				 unsigned int *seq_size)
 {
-	struct cc_cipher_ctx *ctx_p = crypto_tfm_ctx(tfm);
+	struct crypto_skcipher *tfm = crypto_skcipher_reqtfm(req);
+	struct cc_cipher_ctx *ctx_p = crypto_skcipher_ctx(tfm);
 	struct device *dev = drvdata_to_dev(ctx_p->drvdata);
-	int cipher_mode = ctx_p->cipher_mode;
+	int cipher_mode = req_cipher_mode(req);
 	int flow_mode = ctx_p->flow_mode;
 	int direction = req_ctx->gen_ctx.op_type;
 	dma_addr_t iv_dma_addr = req_ctx->gen_ctx.iv_dma_addr;
@@ -610,15 +626,16 @@ static void cc_setup_state_desc(struct crypto_tfm *tfm,
 }
 
 
-static void cc_setup_xex_state_desc(struct crypto_tfm *tfm,
+static void cc_setup_xex_state_desc(struct skcipher_request *req,
 				 struct cipher_req_ctx *req_ctx,
 				 unsigned int ivsize, unsigned int nbytes,
 				 struct cc_hw_desc desc[],
 				 unsigned int *seq_size)
 {
-	struct cc_cipher_ctx *ctx_p = crypto_tfm_ctx(tfm);
+	struct crypto_skcipher *tfm = crypto_skcipher_reqtfm(req);
+	struct cc_cipher_ctx *ctx_p = crypto_skcipher_ctx(tfm);
 	struct device *dev = drvdata_to_dev(ctx_p->drvdata);
-	int cipher_mode = ctx_p->cipher_mode;
+	int cipher_mode = req_cipher_mode(req);
 	int flow_mode = ctx_p->flow_mode;
 	int direction = req_ctx->gen_ctx.op_type;
 	dma_addr_t key_dma_addr = ctx_p->user.key_dma_addr;
@@ -628,8 +645,8 @@ static void cc_setup_xex_state_desc(struct crypto_tfm *tfm,
 	unsigned int key_offset = key_len;
 
 	struct cc_crypto_alg *cc_alg =
-		container_of(tfm->__crt_alg, struct cc_crypto_alg,
-			     skcipher_alg.base);
+		container_of(crypto_skcipher_alg(tfm), struct cc_crypto_alg,
+			     skcipher_alg);
 
 	if (cc_alg->data_unit)
 		du_size = cc_alg->data_unit;
@@ -697,14 +714,15 @@ static int cc_out_flow_mode(struct cc_cipher_ctx *ctx_p)
 	}
 }
 
-static void cc_setup_key_desc(struct crypto_tfm *tfm,
+static void cc_setup_key_desc(struct skcipher_request *req,
 			      struct cipher_req_ctx *req_ctx,
 			      unsigned int nbytes, struct cc_hw_desc desc[],
 			      unsigned int *seq_size)
 {
-	struct cc_cipher_ctx *ctx_p = crypto_tfm_ctx(tfm);
+	struct crypto_skcipher *tfm = crypto_skcipher_reqtfm(req);
+	struct cc_cipher_ctx *ctx_p = crypto_skcipher_ctx(tfm);
 	struct device *dev = drvdata_to_dev(ctx_p->drvdata);
-	int cipher_mode = ctx_p->cipher_mode;
+	int cipher_mode = req_cipher_mode(req);
 	int flow_mode = ctx_p->flow_mode;
 	int direction = req_ctx->gen_ctx.op_type;
 	dma_addr_t key_dma_addr = ctx_p->user.key_dma_addr;
@@ -912,7 +930,7 @@ static int cc_cipher_process(struct skcipher_request *req,
 
 	/* STAT_PHASE_0: Init and sanity checks */
 
-	if (validate_data_size(ctx_p, nbytes)) {
+	if (validate_data_size(req, ctx_p, nbytes)) {
 		dev_dbg(dev, "Unsupported data size %d.\n", nbytes);
 		rc = -EINVAL;
 		goto exit_process;
@@ -969,17 +987,17 @@ static int cc_cipher_process(struct skcipher_request *req,
 	/* STAT_PHASE_2: Create sequence */
 
 	/* Setup state (IV)  */
-	cc_setup_state_desc(tfm, req_ctx, ivsize, nbytes, desc, &seq_len);
+	cc_setup_state_desc(req, req_ctx, ivsize, nbytes, desc, &seq_len);
 	/* Setup MLLI line, if needed */
 	cc_setup_mlli_desc(tfm, req_ctx, dst, src, nbytes, req, desc, &seq_len);
 	/* Setup key */
-	cc_setup_key_desc(tfm, req_ctx, nbytes, desc, &seq_len);
+	cc_setup_key_desc(req, req_ctx, nbytes, desc, &seq_len);
 	/* Setup state (IV and XEX key)  */
-	cc_setup_xex_state_desc(tfm, req_ctx, ivsize, nbytes, desc, &seq_len);
+	cc_setup_xex_state_desc(req, req_ctx, ivsize, nbytes, desc, &seq_len);
 	/* Data processing */
 	cc_setup_flow_desc(tfm, req_ctx, dst, src, nbytes, desc, &seq_len);
 	/* Read next IV */
-	cc_setup_readiv_desc(tfm, req_ctx, ivsize, desc, &seq_len);
+	cc_setup_readiv_desc(req, req_ctx, ivsize, desc, &seq_len);
 
 	/* STAT_PHASE_3: Lock HW and push sequence */
 
@@ -1113,7 +1131,7 @@ static const struct cc_alg_template skcipher_algs[] = {
 	{
 		.name = "cts(cbc(paes))",
 		.driver_name = "cts-cbc-paes-ccree",
-		.blocksize = AES_BLOCK_SIZE,
+		.blocksize = 1,
 		.template_skcipher = {
 			.setkey = cc_cipher_sethkey,
 			.encrypt = cc_cipher_encrypt,
@@ -1121,6 +1139,8 @@ static const struct cc_alg_template skcipher_algs[] = {
 			.min_keysize = CC_HW_KEY_SIZE,
 			.max_keysize = CC_HW_KEY_SIZE,
 			.ivsize = AES_BLOCK_SIZE,
+			.chunksize = AES_BLOCK_SIZE,
+			.final_chunksize = 2 * AES_BLOCK_SIZE,
 			},
 		.cipher_mode = DRV_CIPHER_CBC_CTS,
 		.flow_mode = S_DIN_to_AES,
@@ -1238,7 +1258,7 @@ static const struct cc_alg_template skcipher_algs[] = {
 	{
 		.name = "cts(cbc(aes))",
 		.driver_name = "cts-cbc-aes-ccree",
-		.blocksize = AES_BLOCK_SIZE,
+		.blocksize = 1,
 		.template_skcipher = {
 			.setkey = cc_cipher_setkey,
 			.encrypt = cc_cipher_encrypt,
@@ -1246,6 +1266,8 @@ static const struct cc_alg_template skcipher_algs[] = {
 			.min_keysize = AES_MIN_KEY_SIZE,
 			.max_keysize = AES_MAX_KEY_SIZE,
 			.ivsize = AES_BLOCK_SIZE,
+			.chunksize = AES_BLOCK_SIZE,
+			.final_chunksize = 2 * AES_BLOCK_SIZE,
 			},
 		.cipher_mode = DRV_CIPHER_CBC_CTS,
 		.flow_mode = S_DIN_to_AES,

Return-Path: <SRS0=QXJz=CX=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,UNWANTED_LANGUAGE_BODY,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ADC78C433E2
	for <linux-crypto@archiver.kernel.org>; Mon, 14 Sep 2020 04:22:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7920E217BA
	for <linux-crypto@archiver.kernel.org>; Mon, 14 Sep 2020 04:22:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725995AbgINEW2 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 14 Sep 2020 00:22:28 -0400
Received: from helcar.hmeau.com ([216.24.177.18]:40910 "EHLO fornost.hmeau.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725974AbgINEW0 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 14 Sep 2020 00:22:26 -0400
Received: from gwarestrin.arnor.me.apana.org.au ([192.168.0.7])
        by fornost.hmeau.com with smtp (Exim 4.92 #5 (Debian))
        id 1kHg0J-0004sJ-SN; Mon, 14 Sep 2020 14:22:13 +1000
Received: by gwarestrin.arnor.me.apana.org.au (sSMTP sendmail emulation); Mon, 14 Sep 2020 14:22:11 +1000
From:   "Herbert Xu" <herbert@gondor.apana.org.au>
Date:   Mon, 14 Sep 2020 14:22:11 +1000
Subject: [PATCH 1/3] crypto: inside-secure - Move priv pointer into safexcel_context
References: <20200914042055.GA19691@gondor.apana.org.au>
To:     kernel test robot <lkp@intel.com>,
        Pascal van Leeuwen <pascalvanl@gmail.com>,
        kbuild-all@lists.01.org, linux-kernel@vger.kernel.org,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        Antoine Tenart <antoine.tenart@bootlin.com>
Message-Id: <E1kHg0J-0004sJ-SN@fornost.hmeau.com>
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

This patch moves the priv pointer into struct safexcel_context
because both structs that extend safexcel_context have that pointer
as well.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
---

 drivers/crypto/inside-secure/safexcel.h        |    1 
 drivers/crypto/inside-secure/safexcel_cipher.c |   42 ++++++++++++-------------
 drivers/crypto/inside-secure/safexcel_hash.c   |   17 ++++------
 3 files changed, 30 insertions(+), 30 deletions(-)

diff --git a/drivers/crypto/inside-secure/safexcel.h b/drivers/crypto/inside-secure/safexcel.h
index 7c5fe382d2720..77eb285b335f4 100644
--- a/drivers/crypto/inside-secure/safexcel.h
+++ b/drivers/crypto/inside-secure/safexcel.h
@@ -819,6 +819,7 @@ struct safexcel_context {
 			     struct crypto_async_request *req, bool *complete,
 			     int *ret);
 	struct safexcel_context_record *ctxr;
+	struct safexcel_crypto_priv *priv;
 	dma_addr_t ctxr_dma;
 
 	int ring;
diff --git a/drivers/crypto/inside-secure/safexcel_cipher.c b/drivers/crypto/inside-secure/safexcel_cipher.c
index 1ac3253b7903a..052df0da02f47 100644
--- a/drivers/crypto/inside-secure/safexcel_cipher.c
+++ b/drivers/crypto/inside-secure/safexcel_cipher.c
@@ -375,7 +375,7 @@ static int safexcel_skcipher_aes_setkey(struct crypto_skcipher *ctfm,
 {
 	struct crypto_tfm *tfm = crypto_skcipher_tfm(ctfm);
 	struct safexcel_cipher_ctx *ctx = crypto_tfm_ctx(tfm);
-	struct safexcel_crypto_priv *priv = ctx->priv;
+	struct safexcel_crypto_priv *priv = ctx->base.priv;
 	struct crypto_aes_ctx aes;
 	int ret, i;
 
@@ -407,7 +407,7 @@ static int safexcel_aead_setkey(struct crypto_aead *ctfm, const u8 *key,
 	struct crypto_tfm *tfm = crypto_aead_tfm(ctfm);
 	struct safexcel_cipher_ctx *ctx = crypto_tfm_ctx(tfm);
 	struct safexcel_ahash_export_state istate, ostate;
-	struct safexcel_crypto_priv *priv = ctx->priv;
+	struct safexcel_crypto_priv *priv = ctx->base.priv;
 	struct crypto_authenc_keys keys;
 	struct crypto_aes_ctx aes;
 	int err = -EINVAL, i;
@@ -525,7 +525,7 @@ static int safexcel_context_control(struct safexcel_cipher_ctx *ctx,
 				    struct safexcel_cipher_req *sreq,
 				    struct safexcel_command_desc *cdesc)
 {
-	struct safexcel_crypto_priv *priv = ctx->priv;
+	struct safexcel_crypto_priv *priv = ctx->base.priv;
 	int ctrl_size = ctx->key_len / sizeof(u32);
 
 	cdesc->control_data.control1 = ctx->mode;
@@ -692,7 +692,7 @@ static int safexcel_send_req(struct crypto_async_request *base, int ring,
 	struct skcipher_request *areq = skcipher_request_cast(base);
 	struct crypto_skcipher *skcipher = crypto_skcipher_reqtfm(areq);
 	struct safexcel_cipher_ctx *ctx = crypto_tfm_ctx(base->tfm);
-	struct safexcel_crypto_priv *priv = ctx->priv;
+	struct safexcel_crypto_priv *priv = ctx->base.priv;
 	struct safexcel_command_desc *cdesc;
 	struct safexcel_command_desc *first_cdesc = NULL;
 	struct safexcel_result_desc *rdesc, *first_rdesc = NULL;
@@ -1020,7 +1020,7 @@ static int safexcel_cipher_send_inv(struct crypto_async_request *base,
 				    int ring, int *commands, int *results)
 {
 	struct safexcel_cipher_ctx *ctx = crypto_tfm_ctx(base->tfm);
-	struct safexcel_crypto_priv *priv = ctx->priv;
+	struct safexcel_crypto_priv *priv = ctx->base.priv;
 	int ret;
 
 	ret = safexcel_invalidate_cache(base, priv, ctx->base.ctxr_dma, ring);
@@ -1039,7 +1039,7 @@ static int safexcel_skcipher_send(struct crypto_async_request *async, int ring,
 	struct skcipher_request *req = skcipher_request_cast(async);
 	struct safexcel_cipher_ctx *ctx = crypto_tfm_ctx(req->base.tfm);
 	struct safexcel_cipher_req *sreq = skcipher_request_ctx(req);
-	struct safexcel_crypto_priv *priv = ctx->priv;
+	struct safexcel_crypto_priv *priv = ctx->base.priv;
 	int ret;
 
 	BUG_ON(!(priv->flags & EIP197_TRC_CACHE) && sreq->needs_inv);
@@ -1072,7 +1072,7 @@ static int safexcel_aead_send(struct crypto_async_request *async, int ring,
 	struct crypto_aead *tfm = crypto_aead_reqtfm(req);
 	struct safexcel_cipher_ctx *ctx = crypto_tfm_ctx(req->base.tfm);
 	struct safexcel_cipher_req *sreq = aead_request_ctx(req);
-	struct safexcel_crypto_priv *priv = ctx->priv;
+	struct safexcel_crypto_priv *priv = ctx->base.priv;
 	int ret;
 
 	BUG_ON(!(priv->flags & EIP197_TRC_CACHE) && sreq->needs_inv);
@@ -1094,7 +1094,7 @@ static int safexcel_cipher_exit_inv(struct crypto_tfm *tfm,
 				    struct safexcel_inv_result *result)
 {
 	struct safexcel_cipher_ctx *ctx = crypto_tfm_ctx(tfm);
-	struct safexcel_crypto_priv *priv = ctx->priv;
+	struct safexcel_crypto_priv *priv = ctx->base.priv;
 	int ring = ctx->base.ring;
 
 	init_completion(&result->completion);
@@ -1157,7 +1157,7 @@ static int safexcel_queue_req(struct crypto_async_request *base,
 			enum safexcel_cipher_direction dir)
 {
 	struct safexcel_cipher_ctx *ctx = crypto_tfm_ctx(base->tfm);
-	struct safexcel_crypto_priv *priv = ctx->priv;
+	struct safexcel_crypto_priv *priv = ctx->base.priv;
 	int ret, ring;
 
 	sreq->needs_inv = false;
@@ -1211,7 +1211,7 @@ static int safexcel_skcipher_cra_init(struct crypto_tfm *tfm)
 	crypto_skcipher_set_reqsize(__crypto_skcipher_cast(tfm),
 				    sizeof(struct safexcel_cipher_req));
 
-	ctx->priv = tmpl->priv;
+	ctx->base.priv = tmpl->priv;
 
 	ctx->base.send = safexcel_skcipher_send;
 	ctx->base.handle_result = safexcel_skcipher_handle_result;
@@ -1237,7 +1237,7 @@ static int safexcel_cipher_cra_exit(struct crypto_tfm *tfm)
 static void safexcel_skcipher_cra_exit(struct crypto_tfm *tfm)
 {
 	struct safexcel_cipher_ctx *ctx = crypto_tfm_ctx(tfm);
-	struct safexcel_crypto_priv *priv = ctx->priv;
+	struct safexcel_crypto_priv *priv = ctx->base.priv;
 	int ret;
 
 	if (safexcel_cipher_cra_exit(tfm))
@@ -1257,7 +1257,7 @@ static void safexcel_skcipher_cra_exit(struct crypto_tfm *tfm)
 static void safexcel_aead_cra_exit(struct crypto_tfm *tfm)
 {
 	struct safexcel_cipher_ctx *ctx = crypto_tfm_ctx(tfm);
-	struct safexcel_crypto_priv *priv = ctx->priv;
+	struct safexcel_crypto_priv *priv = ctx->base.priv;
 	int ret;
 
 	if (safexcel_cipher_cra_exit(tfm))
@@ -1431,7 +1431,7 @@ static int safexcel_skcipher_aesctr_setkey(struct crypto_skcipher *ctfm,
 {
 	struct crypto_tfm *tfm = crypto_skcipher_tfm(ctfm);
 	struct safexcel_cipher_ctx *ctx = crypto_tfm_ctx(tfm);
-	struct safexcel_crypto_priv *priv = ctx->priv;
+	struct safexcel_crypto_priv *priv = ctx->base.priv;
 	struct crypto_aes_ctx aes;
 	int ret, i;
 	unsigned int keylen;
@@ -1505,7 +1505,7 @@ static int safexcel_des_setkey(struct crypto_skcipher *ctfm, const u8 *key,
 			       unsigned int len)
 {
 	struct safexcel_cipher_ctx *ctx = crypto_skcipher_ctx(ctfm);
-	struct safexcel_crypto_priv *priv = ctx->priv;
+	struct safexcel_crypto_priv *priv = ctx->base.priv;
 	int ret;
 
 	ret = verify_skcipher_des_key(ctfm, key);
@@ -1604,7 +1604,7 @@ static int safexcel_des3_ede_setkey(struct crypto_skcipher *ctfm,
 				   const u8 *key, unsigned int len)
 {
 	struct safexcel_cipher_ctx *ctx = crypto_skcipher_ctx(ctfm);
-	struct safexcel_crypto_priv *priv = ctx->priv;
+	struct safexcel_crypto_priv *priv = ctx->base.priv;
 	int err;
 
 	err = verify_skcipher_des3_key(ctfm, key);
@@ -1723,7 +1723,7 @@ static int safexcel_aead_cra_init(struct crypto_tfm *tfm)
 	crypto_aead_set_reqsize(__crypto_aead_cast(tfm),
 				sizeof(struct safexcel_cipher_req));
 
-	ctx->priv = tmpl->priv;
+	ctx->base.priv = tmpl->priv;
 
 	ctx->alg  = SAFEXCEL_AES; /* default */
 	ctx->blocksz = AES_BLOCK_SIZE;
@@ -2466,7 +2466,7 @@ static int safexcel_skcipher_aesxts_setkey(struct crypto_skcipher *ctfm,
 {
 	struct crypto_tfm *tfm = crypto_skcipher_tfm(ctfm);
 	struct safexcel_cipher_ctx *ctx = crypto_tfm_ctx(tfm);
-	struct safexcel_crypto_priv *priv = ctx->priv;
+	struct safexcel_crypto_priv *priv = ctx->base.priv;
 	struct crypto_aes_ctx aes;
 	int ret, i;
 	unsigned int keylen;
@@ -2580,7 +2580,7 @@ static int safexcel_aead_gcm_setkey(struct crypto_aead *ctfm, const u8 *key,
 {
 	struct crypto_tfm *tfm = crypto_aead_tfm(ctfm);
 	struct safexcel_cipher_ctx *ctx = crypto_tfm_ctx(tfm);
-	struct safexcel_crypto_priv *priv = ctx->priv;
+	struct safexcel_crypto_priv *priv = ctx->base.priv;
 	struct crypto_aes_ctx aes;
 	u32 hashkey[AES_BLOCK_SIZE >> 2];
 	int ret, i;
@@ -2693,7 +2693,7 @@ static int safexcel_aead_ccm_setkey(struct crypto_aead *ctfm, const u8 *key,
 {
 	struct crypto_tfm *tfm = crypto_aead_tfm(ctfm);
 	struct safexcel_cipher_ctx *ctx = crypto_tfm_ctx(tfm);
-	struct safexcel_crypto_priv *priv = ctx->priv;
+	struct safexcel_crypto_priv *priv = ctx->base.priv;
 	struct crypto_aes_ctx aes;
 	int ret, i;
 
@@ -2815,7 +2815,7 @@ struct safexcel_alg_template safexcel_alg_ccm = {
 static void safexcel_chacha20_setkey(struct safexcel_cipher_ctx *ctx,
 				     const u8 *key)
 {
-	struct safexcel_crypto_priv *priv = ctx->priv;
+	struct safexcel_crypto_priv *priv = ctx->base.priv;
 
 	if (priv->flags & EIP197_TRC_CACHE && ctx->base.ctxr_dma)
 		if (memcmp(ctx->key, key, CHACHA_KEY_SIZE))
@@ -3084,7 +3084,7 @@ static int safexcel_skcipher_sm4_setkey(struct crypto_skcipher *ctfm,
 {
 	struct crypto_tfm *tfm = crypto_skcipher_tfm(ctfm);
 	struct safexcel_cipher_ctx *ctx = crypto_tfm_ctx(tfm);
-	struct safexcel_crypto_priv *priv = ctx->priv;
+	struct safexcel_crypto_priv *priv = ctx->base.priv;
 
 	if (len != SM4_KEY_SIZE)
 		return -EINVAL;
diff --git a/drivers/crypto/inside-secure/safexcel_hash.c b/drivers/crypto/inside-secure/safexcel_hash.c
index 16a467969d8ed..cdedd7976f26b 100644
--- a/drivers/crypto/inside-secure/safexcel_hash.c
+++ b/drivers/crypto/inside-secure/safexcel_hash.c
@@ -20,7 +20,6 @@
 
 struct safexcel_ahash_ctx {
 	struct safexcel_context base;
-	struct safexcel_crypto_priv *priv;
 
 	u32 alg;
 	u8  key_sz;
@@ -111,7 +110,7 @@ static void safexcel_context_control(struct safexcel_ahash_ctx *ctx,
 				     struct safexcel_ahash_req *req,
 				     struct safexcel_command_desc *cdesc)
 {
-	struct safexcel_crypto_priv *priv = ctx->priv;
+	struct safexcel_crypto_priv *priv = ctx->base.priv;
 	u64 count = 0;
 
 	cdesc->control_data.control0 = ctx->alg;
@@ -316,7 +315,7 @@ static int safexcel_ahash_send_req(struct crypto_async_request *async, int ring,
 	struct ahash_request *areq = ahash_request_cast(async);
 	struct safexcel_ahash_req *req = ahash_request_ctx(areq);
 	struct safexcel_ahash_ctx *ctx = crypto_ahash_ctx(crypto_ahash_reqtfm(areq));
-	struct safexcel_crypto_priv *priv = ctx->priv;
+	struct safexcel_crypto_priv *priv = ctx->base.priv;
 	struct safexcel_command_desc *cdesc, *first_cdesc = NULL;
 	struct safexcel_result_desc *rdesc;
 	struct scatterlist *sg;
@@ -591,7 +590,7 @@ static int safexcel_ahash_send_inv(struct crypto_async_request *async,
 	struct safexcel_ahash_ctx *ctx = crypto_ahash_ctx(crypto_ahash_reqtfm(areq));
 	int ret;
 
-	ret = safexcel_invalidate_cache(async, ctx->priv,
+	ret = safexcel_invalidate_cache(async, ctx->base.priv,
 					ctx->base.ctxr_dma, ring);
 	if (unlikely(ret))
 		return ret;
@@ -620,7 +619,7 @@ static int safexcel_ahash_send(struct crypto_async_request *async,
 static int safexcel_ahash_exit_inv(struct crypto_tfm *tfm)
 {
 	struct safexcel_ahash_ctx *ctx = crypto_tfm_ctx(tfm);
-	struct safexcel_crypto_priv *priv = ctx->priv;
+	struct safexcel_crypto_priv *priv = ctx->base.priv;
 	EIP197_REQUEST_ON_STACK(req, ahash, EIP197_AHASH_REQ_SIZE);
 	struct safexcel_ahash_req *rctx = ahash_request_ctx(req);
 	struct safexcel_inv_result result = {};
@@ -688,7 +687,7 @@ static int safexcel_ahash_enqueue(struct ahash_request *areq)
 {
 	struct safexcel_ahash_ctx *ctx = crypto_ahash_ctx(crypto_ahash_reqtfm(areq));
 	struct safexcel_ahash_req *req = ahash_request_ctx(areq);
-	struct safexcel_crypto_priv *priv = ctx->priv;
+	struct safexcel_crypto_priv *priv = ctx->base.priv;
 	int ret, ring;
 
 	req->needs_inv = false;
@@ -917,7 +916,7 @@ static int safexcel_ahash_cra_init(struct crypto_tfm *tfm)
 		container_of(__crypto_ahash_alg(tfm->__crt_alg),
 			     struct safexcel_alg_template, alg.ahash);
 
-	ctx->priv = tmpl->priv;
+	ctx->base.priv = tmpl->priv;
 	ctx->base.send = safexcel_ahash_send;
 	ctx->base.handle_result = safexcel_handle_result;
 	ctx->fb_do_setkey = false;
@@ -956,7 +955,7 @@ static int safexcel_sha1_digest(struct ahash_request *areq)
 static void safexcel_ahash_cra_exit(struct crypto_tfm *tfm)
 {
 	struct safexcel_ahash_ctx *ctx = crypto_tfm_ctx(tfm);
-	struct safexcel_crypto_priv *priv = ctx->priv;
+	struct safexcel_crypto_priv *priv = ctx->base.priv;
 	int ret;
 
 	/* context not allocated, skip invalidation */
@@ -1190,7 +1189,7 @@ static int safexcel_hmac_alg_setkey(struct crypto_ahash *tfm, const u8 *key,
 				    unsigned int state_sz)
 {
 	struct safexcel_ahash_ctx *ctx = crypto_tfm_ctx(crypto_ahash_tfm(tfm));
-	struct safexcel_crypto_priv *priv = ctx->priv;
+	struct safexcel_crypto_priv *priv = ctx->base.priv;
 	struct safexcel_ahash_export_state istate, ostate;
 	int ret;
 

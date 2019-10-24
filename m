Return-Path: <SRS0=tzqc=YR=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8F857CA9EAF
	for <linux-crypto@archiver.kernel.org>; Thu, 24 Oct 2019 13:24:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 471472084C
	for <linux-crypto@archiver.kernel.org>; Thu, 24 Oct 2019 13:24:27 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="xAAuv74D"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2393568AbfJXNY0 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 24 Oct 2019 09:24:26 -0400
Received: from mail-wm1-f67.google.com ([209.85.128.67]:50217 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387516AbfJXNY0 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 24 Oct 2019 09:24:26 -0400
Received: by mail-wm1-f67.google.com with SMTP id q13so2845201wmj.0
        for <linux-crypto@vger.kernel.org>; Thu, 24 Oct 2019 06:24:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=dIBlYIM7JpanSQ8gUz4gqfgKYH0bGpfP4NHGwTwYVtE=;
        b=xAAuv74DGFbtuiS42g2b3ShMd+MW1t6cixbUTJR/hv1OSmwBV0220c9cbhq7VbH3Dv
         wRQQjhERHLexZTH3H6S3wyLnq+Pu0HwtdgRZYrL4K1A/2J8qTQm1s3U1qZRpCv2WwKgf
         1NjKTDT+yNYFf7xKYeMC+TS0y03QDTqyBgcC9NwHj4WDdIiH3QB21y6p2qsdPxl6WfvO
         rgu3Zj0ZjX4O0QoEcQwakNO9g7XM9tr/Xc8iHzCx21M7NCuvF8EMqOy6o+9b79Z6/xJd
         Ko40c0gRqeaZLXA9XIuePLPXV8byum7gs/PA23C1H84LnNqUgm/g+uOR/1clklywoc9S
         kJAQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=dIBlYIM7JpanSQ8gUz4gqfgKYH0bGpfP4NHGwTwYVtE=;
        b=dwptc8zqfeietHT56GsVE9F/4eUIm9Sjwo3TvSbeNOv9OLSkGFilcMiQCsOeN3ExsV
         l4CPEm3rBESAsuEPUPLUTATPqPWjzJGJO4Wk612S8vYn/yBqh4pYY7DAKLSYjMMGqvZV
         KuFfMjTJIKLUHLqMhO/UtBl54XYsSnifbfid+WaavCS8endooku/ZM5H0b+uU2konjcI
         ghUbJtTCxsE3tj58PLH2O5PiG4/4XTtuwVZx9A6W2RJsB2emi8LVY8A62Kogg0dMFxfT
         Is3KRUNAuyqm6H+ROKc5Y33Va0RPRwVwl1U7ca7vAc95iMFGBii4+y1fTZSOGeolkbaq
         UeqA==
X-Gm-Message-State: APjAAAWqmbMi8fYn58vidxZl9UEaT0V+9VXCLIXPhp+B9nYXwLHCayyk
        NNcqZQwL1c/7mqEZfkQGtNgUbl0MDRa8/E7I
X-Google-Smtp-Source: APXvYqyNjcrZ/x+Sbl16sipQ+/QJfg2XZ2SZAi8f02FaaS1hGEtzd+akqQfvZPajIwrMjxbuEldHwg==
X-Received: by 2002:a1c:49c2:: with SMTP id w185mr4782203wma.16.1571923460842;
        Thu, 24 Oct 2019 06:24:20 -0700 (PDT)
Received: from localhost.localdomain (laubervilliers-657-1-83-120.w92-154.abo.wanadoo.fr. [92.154.90.120])
        by smtp.gmail.com with ESMTPSA id e3sm2346310wme.36.2019.10.24.06.24.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 24 Oct 2019 06:24:19 -0700 (PDT)
From:   Ard Biesheuvel <ard.biesheuvel@linaro.org>
To:     linux-crypto@vger.kernel.org
Cc:     Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Biggers <ebiggers@google.com>,
        linux-arm-kernel@lists.infradead.org,
        Jamie Iles <jamie@jamieiles.com>
Subject: [PATCH v2 19/27] crypto: picoxcell - switch to skcipher API
Date:   Thu, 24 Oct 2019 15:23:37 +0200
Message-Id: <20191024132345.5236-20-ard.biesheuvel@linaro.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191024132345.5236-1-ard.biesheuvel@linaro.org>
References: <20191024132345.5236-1-ard.biesheuvel@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Commit 7a7ffe65c8c5 ("crypto: skcipher - Add top-level skcipher interface")
dated 20 august 2015 introduced the new skcipher API which is supposed to
replace both blkcipher and ablkcipher. While all consumers of the API have
been converted long ago, some producers of the ablkcipher remain, forcing
us to keep the ablkcipher support routines alive, along with the matching
code to expose [a]blkciphers via the skcipher API.

So switch this driver to the skcipher API, allowing us to finally drop the
blkcipher code in the near future.

Cc: Jamie Iles <jamie@jamieiles.com>
Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
---
 drivers/crypto/picoxcell_crypto.c | 386 ++++++++++----------
 1 file changed, 184 insertions(+), 202 deletions(-)

diff --git a/drivers/crypto/picoxcell_crypto.c b/drivers/crypto/picoxcell_crypto.c
index 3cbefb41b099..29da449b3e9e 100644
--- a/drivers/crypto/picoxcell_crypto.c
+++ b/drivers/crypto/picoxcell_crypto.c
@@ -134,7 +134,7 @@ struct spacc_engine {
 struct spacc_alg {
 	unsigned long			ctrl_default;
 	unsigned long			type;
-	struct crypto_alg		alg;
+	struct skcipher_alg		alg;
 	struct spacc_engine		*engine;
 	struct list_head		entry;
 	int				key_offs;
@@ -173,7 +173,7 @@ struct spacc_aead_ctx {
 
 static int spacc_ablk_submit(struct spacc_req *req);
 
-static inline struct spacc_alg *to_spacc_alg(struct crypto_alg *alg)
+static inline struct spacc_alg *to_spacc_skcipher(struct skcipher_alg *alg)
 {
 	return alg ? container_of(alg, struct spacc_alg, alg) : NULL;
 }
@@ -733,13 +733,13 @@ static void spacc_aead_cra_exit(struct crypto_aead *tfm)
  * Set the DES key for a block cipher transform. This also performs weak key
  * checking if the transform has requested it.
  */
-static int spacc_des_setkey(struct crypto_ablkcipher *cipher, const u8 *key,
+static int spacc_des_setkey(struct crypto_skcipher *cipher, const u8 *key,
 			    unsigned int len)
 {
-	struct spacc_ablk_ctx *ctx = crypto_ablkcipher_ctx(cipher);
+	struct spacc_ablk_ctx *ctx = crypto_skcipher_ctx(cipher);
 	int err;
 
-	err = verify_ablkcipher_des_key(cipher, key);
+	err = verify_skcipher_des_key(cipher, key);
 	if (err)
 		return err;
 
@@ -753,13 +753,13 @@ static int spacc_des_setkey(struct crypto_ablkcipher *cipher, const u8 *key,
  * Set the 3DES key for a block cipher transform. This also performs weak key
  * checking if the transform has requested it.
  */
-static int spacc_des3_setkey(struct crypto_ablkcipher *cipher, const u8 *key,
+static int spacc_des3_setkey(struct crypto_skcipher *cipher, const u8 *key,
 			     unsigned int len)
 {
-	struct spacc_ablk_ctx *ctx = crypto_ablkcipher_ctx(cipher);
+	struct spacc_ablk_ctx *ctx = crypto_skcipher_ctx(cipher);
 	int err;
 
-	err = verify_ablkcipher_des3_key(cipher, key);
+	err = verify_skcipher_des3_key(cipher, key);
 	if (err)
 		return err;
 
@@ -773,15 +773,15 @@ static int spacc_des3_setkey(struct crypto_ablkcipher *cipher, const u8 *key,
  * Set the key for an AES block cipher. Some key lengths are not supported in
  * hardware so this must also check whether a fallback is needed.
  */
-static int spacc_aes_setkey(struct crypto_ablkcipher *cipher, const u8 *key,
+static int spacc_aes_setkey(struct crypto_skcipher *cipher, const u8 *key,
 			    unsigned int len)
 {
-	struct crypto_tfm *tfm = crypto_ablkcipher_tfm(cipher);
+	struct crypto_tfm *tfm = crypto_skcipher_tfm(cipher);
 	struct spacc_ablk_ctx *ctx = crypto_tfm_ctx(tfm);
 	int err = 0;
 
 	if (len > AES_MAX_KEY_SIZE) {
-		crypto_ablkcipher_set_flags(cipher, CRYPTO_TFM_RES_BAD_KEY_LEN);
+		crypto_skcipher_set_flags(cipher, CRYPTO_TFM_RES_BAD_KEY_LEN);
 		return -EINVAL;
 	}
 
@@ -822,15 +822,15 @@ static int spacc_aes_setkey(struct crypto_ablkcipher *cipher, const u8 *key,
 	return err;
 }
 
-static int spacc_kasumi_f8_setkey(struct crypto_ablkcipher *cipher,
+static int spacc_kasumi_f8_setkey(struct crypto_skcipher *cipher,
 				  const u8 *key, unsigned int len)
 {
-	struct crypto_tfm *tfm = crypto_ablkcipher_tfm(cipher);
+	struct crypto_tfm *tfm = crypto_skcipher_tfm(cipher);
 	struct spacc_ablk_ctx *ctx = crypto_tfm_ctx(tfm);
 	int err = 0;
 
 	if (len > AES_MAX_KEY_SIZE) {
-		crypto_ablkcipher_set_flags(cipher, CRYPTO_TFM_RES_BAD_KEY_LEN);
+		crypto_skcipher_set_flags(cipher, CRYPTO_TFM_RES_BAD_KEY_LEN);
 		err = -EINVAL;
 		goto out;
 	}
@@ -844,12 +844,12 @@ static int spacc_kasumi_f8_setkey(struct crypto_ablkcipher *cipher,
 
 static int spacc_ablk_need_fallback(struct spacc_req *req)
 {
+	struct skcipher_request *ablk_req = skcipher_request_cast(req->req);
+	struct crypto_skcipher *tfm = crypto_skcipher_reqtfm(ablk_req);
+	struct spacc_alg *spacc_alg = to_spacc_skcipher(crypto_skcipher_alg(tfm));
 	struct spacc_ablk_ctx *ctx;
-	struct crypto_tfm *tfm = req->req->tfm;
-	struct crypto_alg *alg = req->req->tfm->__crt_alg;
-	struct spacc_alg *spacc_alg = to_spacc_alg(alg);
 
-	ctx = crypto_tfm_ctx(tfm);
+	ctx = crypto_skcipher_ctx(tfm);
 
 	return (spacc_alg->ctrl_default & SPACC_CRYPTO_ALG_MASK) ==
 			SPA_CTRL_CIPH_ALG_AES &&
@@ -859,39 +859,39 @@ static int spacc_ablk_need_fallback(struct spacc_req *req)
 
 static void spacc_ablk_complete(struct spacc_req *req)
 {
-	struct ablkcipher_request *ablk_req = ablkcipher_request_cast(req->req);
+	struct skcipher_request *ablk_req = skcipher_request_cast(req->req);
 
 	if (ablk_req->src != ablk_req->dst) {
 		spacc_free_ddt(req, req->src_ddt, req->src_addr, ablk_req->src,
-			       ablk_req->nbytes, DMA_TO_DEVICE);
+			       ablk_req->cryptlen, DMA_TO_DEVICE);
 		spacc_free_ddt(req, req->dst_ddt, req->dst_addr, ablk_req->dst,
-			       ablk_req->nbytes, DMA_FROM_DEVICE);
+			       ablk_req->cryptlen, DMA_FROM_DEVICE);
 	} else
 		spacc_free_ddt(req, req->dst_ddt, req->dst_addr, ablk_req->dst,
-			       ablk_req->nbytes, DMA_BIDIRECTIONAL);
+			       ablk_req->cryptlen, DMA_BIDIRECTIONAL);
 
 	req->req->complete(req->req, req->result);
 }
 
 static int spacc_ablk_submit(struct spacc_req *req)
 {
-	struct crypto_tfm *tfm = req->req->tfm;
-	struct spacc_ablk_ctx *ctx = crypto_tfm_ctx(tfm);
-	struct ablkcipher_request *ablk_req = ablkcipher_request_cast(req->req);
-	struct crypto_alg *alg = req->req->tfm->__crt_alg;
-	struct spacc_alg *spacc_alg = to_spacc_alg(alg);
+	struct skcipher_request *ablk_req = skcipher_request_cast(req->req);
+	struct crypto_skcipher *tfm = crypto_skcipher_reqtfm(ablk_req);
+	struct skcipher_alg *alg = crypto_skcipher_alg(tfm);
+	struct spacc_alg *spacc_alg = to_spacc_skcipher(alg);
+	struct spacc_ablk_ctx *ctx = crypto_skcipher_ctx(tfm);
 	struct spacc_engine *engine = ctx->generic.engine;
 	u32 ctrl;
 
 	req->ctx_id = spacc_load_ctx(&ctx->generic, ctx->key,
-		ctx->key_len, ablk_req->info, alg->cra_ablkcipher.ivsize,
+		ctx->key_len, ablk_req->iv, alg->ivsize,
 		NULL, 0);
 
 	writel(req->src_addr, engine->regs + SPA_SRC_PTR_REG_OFFSET);
 	writel(req->dst_addr, engine->regs + SPA_DST_PTR_REG_OFFSET);
 	writel(0, engine->regs + SPA_OFFSET_REG_OFFSET);
 
-	writel(ablk_req->nbytes, engine->regs + SPA_PROC_LEN_REG_OFFSET);
+	writel(ablk_req->cryptlen, engine->regs + SPA_PROC_LEN_REG_OFFSET);
 	writel(0, engine->regs + SPA_ICV_OFFSET_REG_OFFSET);
 	writel(0, engine->regs + SPA_AUX_INFO_REG_OFFSET);
 	writel(0, engine->regs + SPA_AAD_LEN_REG_OFFSET);
@@ -907,11 +907,11 @@ static int spacc_ablk_submit(struct spacc_req *req)
 	return -EINPROGRESS;
 }
 
-static int spacc_ablk_do_fallback(struct ablkcipher_request *req,
+static int spacc_ablk_do_fallback(struct skcipher_request *req,
 				  unsigned alg_type, bool is_encrypt)
 {
 	struct crypto_tfm *old_tfm =
-	    crypto_ablkcipher_tfm(crypto_ablkcipher_reqtfm(req));
+	    crypto_skcipher_tfm(crypto_skcipher_reqtfm(req));
 	struct spacc_ablk_ctx *ctx = crypto_tfm_ctx(old_tfm);
 	SYNC_SKCIPHER_REQUEST_ON_STACK(subreq, ctx->sw_cipher);
 	int err;
@@ -924,7 +924,7 @@ static int spacc_ablk_do_fallback(struct ablkcipher_request *req,
 	skcipher_request_set_sync_tfm(subreq, ctx->sw_cipher);
 	skcipher_request_set_callback(subreq, req->base.flags, NULL, NULL);
 	skcipher_request_set_crypt(subreq, req->src, req->dst,
-				   req->nbytes, req->info);
+				   req->cryptlen, req->iv);
 	err = is_encrypt ? crypto_skcipher_encrypt(subreq) :
 			   crypto_skcipher_decrypt(subreq);
 	skcipher_request_zero(subreq);
@@ -932,12 +932,13 @@ static int spacc_ablk_do_fallback(struct ablkcipher_request *req,
 	return err;
 }
 
-static int spacc_ablk_setup(struct ablkcipher_request *req, unsigned alg_type,
+static int spacc_ablk_setup(struct skcipher_request *req, unsigned alg_type,
 			    bool is_encrypt)
 {
-	struct crypto_alg *alg = req->base.tfm->__crt_alg;
-	struct spacc_engine *engine = to_spacc_alg(alg)->engine;
-	struct spacc_req *dev_req = ablkcipher_request_ctx(req);
+	struct crypto_skcipher *tfm = crypto_skcipher_reqtfm(req);
+	struct skcipher_alg *alg = crypto_skcipher_alg(tfm);
+	struct spacc_engine *engine = to_spacc_skcipher(alg)->engine;
+	struct spacc_req *dev_req = skcipher_request_ctx(req);
 	unsigned long flags;
 	int err = -ENOMEM;
 
@@ -956,17 +957,17 @@ static int spacc_ablk_setup(struct ablkcipher_request *req, unsigned alg_type,
 	 */
 	if (req->src != req->dst) {
 		dev_req->src_ddt = spacc_sg_to_ddt(engine, req->src,
-			req->nbytes, DMA_TO_DEVICE, &dev_req->src_addr);
+			req->cryptlen, DMA_TO_DEVICE, &dev_req->src_addr);
 		if (!dev_req->src_ddt)
 			goto out;
 
 		dev_req->dst_ddt = spacc_sg_to_ddt(engine, req->dst,
-			req->nbytes, DMA_FROM_DEVICE, &dev_req->dst_addr);
+			req->cryptlen, DMA_FROM_DEVICE, &dev_req->dst_addr);
 		if (!dev_req->dst_ddt)
 			goto out_free_src;
 	} else {
 		dev_req->dst_ddt = spacc_sg_to_ddt(engine, req->dst,
-			req->nbytes, DMA_BIDIRECTIONAL, &dev_req->dst_addr);
+			req->cryptlen, DMA_BIDIRECTIONAL, &dev_req->dst_addr);
 		if (!dev_req->dst_ddt)
 			goto out;
 
@@ -999,65 +1000,65 @@ static int spacc_ablk_setup(struct ablkcipher_request *req, unsigned alg_type,
 
 out_free_ddts:
 	spacc_free_ddt(dev_req, dev_req->dst_ddt, dev_req->dst_addr, req->dst,
-		       req->nbytes, req->src == req->dst ?
+		       req->cryptlen, req->src == req->dst ?
 		       DMA_BIDIRECTIONAL : DMA_FROM_DEVICE);
 out_free_src:
 	if (req->src != req->dst)
 		spacc_free_ddt(dev_req, dev_req->src_ddt, dev_req->src_addr,
-			       req->src, req->nbytes, DMA_TO_DEVICE);
+			       req->src, req->cryptlen, DMA_TO_DEVICE);
 out:
 	return err;
 }
 
-static int spacc_ablk_cra_init(struct crypto_tfm *tfm)
+static int spacc_ablk_init_tfm(struct crypto_skcipher *tfm)
 {
-	struct spacc_ablk_ctx *ctx = crypto_tfm_ctx(tfm);
-	struct crypto_alg *alg = tfm->__crt_alg;
-	struct spacc_alg *spacc_alg = to_spacc_alg(alg);
+	struct spacc_ablk_ctx *ctx = crypto_skcipher_ctx(tfm);
+	struct skcipher_alg *alg = crypto_skcipher_alg(tfm);
+	struct spacc_alg *spacc_alg = to_spacc_skcipher(alg);
 	struct spacc_engine *engine = spacc_alg->engine;
 
 	ctx->generic.flags = spacc_alg->type;
 	ctx->generic.engine = engine;
-	if (alg->cra_flags & CRYPTO_ALG_NEED_FALLBACK) {
+	if (alg->base.cra_flags & CRYPTO_ALG_NEED_FALLBACK) {
 		ctx->sw_cipher = crypto_alloc_sync_skcipher(
-			alg->cra_name, 0, CRYPTO_ALG_NEED_FALLBACK);
+			alg->base.cra_name, 0, CRYPTO_ALG_NEED_FALLBACK);
 		if (IS_ERR(ctx->sw_cipher)) {
 			dev_warn(engine->dev, "failed to allocate fallback for %s\n",
-				 alg->cra_name);
+				 alg->base.cra_name);
 			return PTR_ERR(ctx->sw_cipher);
 		}
 	}
 	ctx->generic.key_offs = spacc_alg->key_offs;
 	ctx->generic.iv_offs = spacc_alg->iv_offs;
 
-	tfm->crt_ablkcipher.reqsize = sizeof(struct spacc_req);
+	crypto_skcipher_set_reqsize(tfm, sizeof(struct spacc_req));
 
 	return 0;
 }
 
-static void spacc_ablk_cra_exit(struct crypto_tfm *tfm)
+static void spacc_ablk_exit_tfm(struct crypto_skcipher *tfm)
 {
-	struct spacc_ablk_ctx *ctx = crypto_tfm_ctx(tfm);
+	struct spacc_ablk_ctx *ctx = crypto_skcipher_ctx(tfm);
 
 	crypto_free_sync_skcipher(ctx->sw_cipher);
 }
 
-static int spacc_ablk_encrypt(struct ablkcipher_request *req)
+static int spacc_ablk_encrypt(struct skcipher_request *req)
 {
-	struct crypto_ablkcipher *cipher = crypto_ablkcipher_reqtfm(req);
-	struct crypto_tfm *tfm = crypto_ablkcipher_tfm(cipher);
-	struct spacc_alg *alg = to_spacc_alg(tfm->__crt_alg);
+	struct crypto_skcipher *cipher = crypto_skcipher_reqtfm(req);
+	struct skcipher_alg *alg = crypto_skcipher_alg(cipher);
+	struct spacc_alg *spacc_alg = to_spacc_skcipher(alg);
 
-	return spacc_ablk_setup(req, alg->type, 1);
+	return spacc_ablk_setup(req, spacc_alg->type, 1);
 }
 
-static int spacc_ablk_decrypt(struct ablkcipher_request *req)
+static int spacc_ablk_decrypt(struct skcipher_request *req)
 {
-	struct crypto_ablkcipher *cipher = crypto_ablkcipher_reqtfm(req);
-	struct crypto_tfm *tfm = crypto_ablkcipher_tfm(cipher);
-	struct spacc_alg *alg = to_spacc_alg(tfm->__crt_alg);
+	struct crypto_skcipher *cipher = crypto_skcipher_reqtfm(req);
+	struct skcipher_alg *alg = crypto_skcipher_alg(cipher);
+	struct spacc_alg *spacc_alg = to_spacc_skcipher(alg);
 
-	return spacc_ablk_setup(req, alg->type, 0);
+	return spacc_ablk_setup(req, spacc_alg->type, 0);
 }
 
 static inline int spacc_fifo_stat_empty(struct spacc_engine *engine)
@@ -1233,27 +1234,24 @@ static struct spacc_alg ipsec_engine_algs[] = {
 		.key_offs = 0,
 		.iv_offs = AES_MAX_KEY_SIZE,
 		.alg = {
-			.cra_name = "cbc(aes)",
-			.cra_driver_name = "cbc-aes-picoxcell",
-			.cra_priority = SPACC_CRYPTO_ALG_PRIORITY,
-			.cra_flags = CRYPTO_ALG_TYPE_ABLKCIPHER |
-				     CRYPTO_ALG_KERN_DRIVER_ONLY |
-				     CRYPTO_ALG_ASYNC |
-				     CRYPTO_ALG_NEED_FALLBACK,
-			.cra_blocksize = AES_BLOCK_SIZE,
-			.cra_ctxsize = sizeof(struct spacc_ablk_ctx),
-			.cra_type = &crypto_ablkcipher_type,
-			.cra_module = THIS_MODULE,
-			.cra_ablkcipher = {
-				.setkey = spacc_aes_setkey,
-				.encrypt = spacc_ablk_encrypt,
-				.decrypt = spacc_ablk_decrypt,
-				.min_keysize = AES_MIN_KEY_SIZE,
-				.max_keysize = AES_MAX_KEY_SIZE,
-				.ivsize = AES_BLOCK_SIZE,
-			},
-			.cra_init = spacc_ablk_cra_init,
-			.cra_exit = spacc_ablk_cra_exit,
+			.base.cra_name		= "cbc(aes)",
+			.base.cra_driver_name	= "cbc-aes-picoxcell",
+			.base.cra_priority	= SPACC_CRYPTO_ALG_PRIORITY,
+			.base.cra_flags		= CRYPTO_ALG_KERN_DRIVER_ONLY |
+						  CRYPTO_ALG_ASYNC |
+						  CRYPTO_ALG_NEED_FALLBACK,
+			.base.cra_blocksize	= AES_BLOCK_SIZE,
+			.base.cra_ctxsize	= sizeof(struct spacc_ablk_ctx),
+			.base.cra_module	= THIS_MODULE,
+
+			.setkey			= spacc_aes_setkey,
+			.encrypt 		= spacc_ablk_encrypt,
+			.decrypt 		= spacc_ablk_decrypt,
+			.min_keysize 		= AES_MIN_KEY_SIZE,
+			.max_keysize 		= AES_MAX_KEY_SIZE,
+			.ivsize			= AES_BLOCK_SIZE,
+			.init			= spacc_ablk_init_tfm,
+			.exit			= spacc_ablk_exit_tfm,
 		},
 	},
 	{
@@ -1261,25 +1259,23 @@ static struct spacc_alg ipsec_engine_algs[] = {
 		.iv_offs = AES_MAX_KEY_SIZE,
 		.ctrl_default = SPA_CTRL_CIPH_ALG_AES | SPA_CTRL_CIPH_MODE_ECB,
 		.alg = {
-			.cra_name = "ecb(aes)",
-			.cra_driver_name = "ecb-aes-picoxcell",
-			.cra_priority = SPACC_CRYPTO_ALG_PRIORITY,
-			.cra_flags = CRYPTO_ALG_TYPE_ABLKCIPHER |
-				CRYPTO_ALG_KERN_DRIVER_ONLY |
-				CRYPTO_ALG_ASYNC | CRYPTO_ALG_NEED_FALLBACK,
-			.cra_blocksize = AES_BLOCK_SIZE,
-			.cra_ctxsize = sizeof(struct spacc_ablk_ctx),
-			.cra_type = &crypto_ablkcipher_type,
-			.cra_module = THIS_MODULE,
-			.cra_ablkcipher = {
-				.setkey = spacc_aes_setkey,
-				.encrypt = spacc_ablk_encrypt,
-				.decrypt = spacc_ablk_decrypt,
-				.min_keysize = AES_MIN_KEY_SIZE,
-				.max_keysize = AES_MAX_KEY_SIZE,
-			},
-			.cra_init = spacc_ablk_cra_init,
-			.cra_exit = spacc_ablk_cra_exit,
+			.base.cra_name		= "ecb(aes)",
+			.base.cra_driver_name	= "ecb-aes-picoxcell",
+			.base.cra_priority	= SPACC_CRYPTO_ALG_PRIORITY,
+			.base.cra_flags		= CRYPTO_ALG_KERN_DRIVER_ONLY |
+						  CRYPTO_ALG_ASYNC |
+						  CRYPTO_ALG_NEED_FALLBACK,
+			.base.cra_blocksize	= AES_BLOCK_SIZE,
+			.base.cra_ctxsize	= sizeof(struct spacc_ablk_ctx),
+			.base.cra_module	= THIS_MODULE,
+
+			.setkey			= spacc_aes_setkey,
+			.encrypt 		= spacc_ablk_encrypt,
+			.decrypt 		= spacc_ablk_decrypt,
+			.min_keysize 		= AES_MIN_KEY_SIZE,
+			.max_keysize 		= AES_MAX_KEY_SIZE,
+			.init			= spacc_ablk_init_tfm,
+			.exit			= spacc_ablk_exit_tfm,
 		},
 	},
 	{
@@ -1287,26 +1283,23 @@ static struct spacc_alg ipsec_engine_algs[] = {
 		.iv_offs = 0,
 		.ctrl_default = SPA_CTRL_CIPH_ALG_DES | SPA_CTRL_CIPH_MODE_CBC,
 		.alg = {
-			.cra_name = "cbc(des)",
-			.cra_driver_name = "cbc-des-picoxcell",
-			.cra_priority = SPACC_CRYPTO_ALG_PRIORITY,
-			.cra_flags = CRYPTO_ALG_TYPE_ABLKCIPHER |
-					CRYPTO_ALG_ASYNC |
-					CRYPTO_ALG_KERN_DRIVER_ONLY,
-			.cra_blocksize = DES_BLOCK_SIZE,
-			.cra_ctxsize = sizeof(struct spacc_ablk_ctx),
-			.cra_type = &crypto_ablkcipher_type,
-			.cra_module = THIS_MODULE,
-			.cra_ablkcipher = {
-				.setkey = spacc_des_setkey,
-				.encrypt = spacc_ablk_encrypt,
-				.decrypt = spacc_ablk_decrypt,
-				.min_keysize = DES_KEY_SIZE,
-				.max_keysize = DES_KEY_SIZE,
-				.ivsize = DES_BLOCK_SIZE,
-			},
-			.cra_init = spacc_ablk_cra_init,
-			.cra_exit = spacc_ablk_cra_exit,
+			.base.cra_name		= "cbc(des)",
+			.base.cra_driver_name	= "cbc-des-picoxcell",
+			.base.cra_priority	= SPACC_CRYPTO_ALG_PRIORITY,
+			.base.cra_flags		= CRYPTO_ALG_KERN_DRIVER_ONLY |
+						  CRYPTO_ALG_ASYNC,
+			.base.cra_blocksize	= DES_BLOCK_SIZE,
+			.base.cra_ctxsize	= sizeof(struct spacc_ablk_ctx),
+			.base.cra_module	= THIS_MODULE,
+
+			.setkey			= spacc_des_setkey,
+			.encrypt		= spacc_ablk_encrypt,
+			.decrypt		= spacc_ablk_decrypt,
+			.min_keysize		= DES_KEY_SIZE,
+			.max_keysize		= DES_KEY_SIZE,
+			.ivsize			= DES_BLOCK_SIZE,
+			.init			= spacc_ablk_init_tfm,
+			.exit			= spacc_ablk_exit_tfm,
 		},
 	},
 	{
@@ -1314,25 +1307,22 @@ static struct spacc_alg ipsec_engine_algs[] = {
 		.iv_offs = 0,
 		.ctrl_default = SPA_CTRL_CIPH_ALG_DES | SPA_CTRL_CIPH_MODE_ECB,
 		.alg = {
-			.cra_name = "ecb(des)",
-			.cra_driver_name = "ecb-des-picoxcell",
-			.cra_priority = SPACC_CRYPTO_ALG_PRIORITY,
-			.cra_flags = CRYPTO_ALG_TYPE_ABLKCIPHER |
-					CRYPTO_ALG_ASYNC |
-					CRYPTO_ALG_KERN_DRIVER_ONLY,
-			.cra_blocksize = DES_BLOCK_SIZE,
-			.cra_ctxsize = sizeof(struct spacc_ablk_ctx),
-			.cra_type = &crypto_ablkcipher_type,
-			.cra_module = THIS_MODULE,
-			.cra_ablkcipher = {
-				.setkey = spacc_des_setkey,
-				.encrypt = spacc_ablk_encrypt,
-				.decrypt = spacc_ablk_decrypt,
-				.min_keysize = DES_KEY_SIZE,
-				.max_keysize = DES_KEY_SIZE,
-			},
-			.cra_init = spacc_ablk_cra_init,
-			.cra_exit = spacc_ablk_cra_exit,
+			.base.cra_name		= "ecb(des)",
+			.base.cra_driver_name	= "ecb-des-picoxcell",
+			.base.cra_priority	= SPACC_CRYPTO_ALG_PRIORITY,
+			.base.cra_flags		= CRYPTO_ALG_KERN_DRIVER_ONLY |
+						  CRYPTO_ALG_ASYNC,
+			.base.cra_blocksize	= DES_BLOCK_SIZE,
+			.base.cra_ctxsize	= sizeof(struct spacc_ablk_ctx),
+			.base.cra_module	= THIS_MODULE,
+
+			.setkey			= spacc_des_setkey,
+			.encrypt		= spacc_ablk_encrypt,
+			.decrypt		= spacc_ablk_decrypt,
+			.min_keysize		= DES_KEY_SIZE,
+			.max_keysize		= DES_KEY_SIZE,
+			.init			= spacc_ablk_init_tfm,
+			.exit			= spacc_ablk_exit_tfm,
 		},
 	},
 	{
@@ -1340,26 +1330,23 @@ static struct spacc_alg ipsec_engine_algs[] = {
 		.iv_offs = 0,
 		.ctrl_default = SPA_CTRL_CIPH_ALG_DES | SPA_CTRL_CIPH_MODE_CBC,
 		.alg = {
-			.cra_name = "cbc(des3_ede)",
-			.cra_driver_name = "cbc-des3-ede-picoxcell",
-			.cra_priority = SPACC_CRYPTO_ALG_PRIORITY,
-			.cra_flags = CRYPTO_ALG_TYPE_ABLKCIPHER |
-					CRYPTO_ALG_ASYNC |
-					CRYPTO_ALG_KERN_DRIVER_ONLY,
-			.cra_blocksize = DES3_EDE_BLOCK_SIZE,
-			.cra_ctxsize = sizeof(struct spacc_ablk_ctx),
-			.cra_type = &crypto_ablkcipher_type,
-			.cra_module = THIS_MODULE,
-			.cra_ablkcipher = {
-				.setkey = spacc_des3_setkey,
-				.encrypt = spacc_ablk_encrypt,
-				.decrypt = spacc_ablk_decrypt,
-				.min_keysize = DES3_EDE_KEY_SIZE,
-				.max_keysize = DES3_EDE_KEY_SIZE,
-				.ivsize = DES3_EDE_BLOCK_SIZE,
-			},
-			.cra_init = spacc_ablk_cra_init,
-			.cra_exit = spacc_ablk_cra_exit,
+			.base.cra_name		= "cbc(des3_ede)",
+			.base.cra_driver_name	= "cbc-des3-ede-picoxcell",
+			.base.cra_priority	= SPACC_CRYPTO_ALG_PRIORITY,
+			.base.cra_flags		= CRYPTO_ALG_ASYNC |
+						  CRYPTO_ALG_KERN_DRIVER_ONLY,
+			.base.cra_blocksize	= DES3_EDE_BLOCK_SIZE,
+			.base.cra_ctxsize	= sizeof(struct spacc_ablk_ctx),
+			.base.cra_module	= THIS_MODULE,
+
+			.setkey			= spacc_des3_setkey,
+			.encrypt		= spacc_ablk_encrypt,
+			.decrypt		= spacc_ablk_decrypt,
+			.min_keysize		= DES3_EDE_KEY_SIZE,
+			.max_keysize		= DES3_EDE_KEY_SIZE,
+			.ivsize			= DES3_EDE_BLOCK_SIZE,
+			.init			= spacc_ablk_init_tfm,
+			.exit			= spacc_ablk_exit_tfm,
 		},
 	},
 	{
@@ -1367,25 +1354,22 @@ static struct spacc_alg ipsec_engine_algs[] = {
 		.iv_offs = 0,
 		.ctrl_default = SPA_CTRL_CIPH_ALG_DES | SPA_CTRL_CIPH_MODE_ECB,
 		.alg = {
-			.cra_name = "ecb(des3_ede)",
-			.cra_driver_name = "ecb-des3-ede-picoxcell",
-			.cra_priority = SPACC_CRYPTO_ALG_PRIORITY,
-			.cra_flags = CRYPTO_ALG_TYPE_ABLKCIPHER |
-					CRYPTO_ALG_ASYNC |
-					CRYPTO_ALG_KERN_DRIVER_ONLY,
-			.cra_blocksize = DES3_EDE_BLOCK_SIZE,
-			.cra_ctxsize = sizeof(struct spacc_ablk_ctx),
-			.cra_type = &crypto_ablkcipher_type,
-			.cra_module = THIS_MODULE,
-			.cra_ablkcipher = {
-				.setkey = spacc_des3_setkey,
-				.encrypt = spacc_ablk_encrypt,
-				.decrypt = spacc_ablk_decrypt,
-				.min_keysize = DES3_EDE_KEY_SIZE,
-				.max_keysize = DES3_EDE_KEY_SIZE,
-			},
-			.cra_init = spacc_ablk_cra_init,
-			.cra_exit = spacc_ablk_cra_exit,
+			.base.cra_name		= "ecb(des3_ede)",
+			.base.cra_driver_name	= "ecb-des3-ede-picoxcell",
+			.base.cra_priority	= SPACC_CRYPTO_ALG_PRIORITY,
+			.base.cra_flags		= CRYPTO_ALG_ASYNC |
+						  CRYPTO_ALG_KERN_DRIVER_ONLY,
+			.base.cra_blocksize	= DES3_EDE_BLOCK_SIZE,
+			.base.cra_ctxsize	= sizeof(struct spacc_ablk_ctx),
+			.base.cra_module	= THIS_MODULE,
+
+			.setkey			= spacc_des3_setkey,
+			.encrypt		= spacc_ablk_encrypt,
+			.decrypt		= spacc_ablk_decrypt,
+			.min_keysize		= DES3_EDE_KEY_SIZE,
+			.max_keysize		= DES3_EDE_KEY_SIZE,
+			.init			= spacc_ablk_init_tfm,
+			.exit			= spacc_ablk_exit_tfm,
 		},
 	},
 };
@@ -1581,25 +1565,23 @@ static struct spacc_alg l2_engine_algs[] = {
 		.ctrl_default = SPA_CTRL_CIPH_ALG_KASUMI |
 				SPA_CTRL_CIPH_MODE_F8,
 		.alg = {
-			.cra_name = "f8(kasumi)",
-			.cra_driver_name = "f8-kasumi-picoxcell",
-			.cra_priority = SPACC_CRYPTO_ALG_PRIORITY,
-			.cra_flags = CRYPTO_ALG_ASYNC |
-					CRYPTO_ALG_KERN_DRIVER_ONLY,
-			.cra_blocksize = 8,
-			.cra_ctxsize = sizeof(struct spacc_ablk_ctx),
-			.cra_type = &crypto_ablkcipher_type,
-			.cra_module = THIS_MODULE,
-			.cra_ablkcipher = {
-				.setkey = spacc_kasumi_f8_setkey,
-				.encrypt = spacc_ablk_encrypt,
-				.decrypt = spacc_ablk_decrypt,
-				.min_keysize = 16,
-				.max_keysize = 16,
-				.ivsize = 8,
-			},
-			.cra_init = spacc_ablk_cra_init,
-			.cra_exit = spacc_ablk_cra_exit,
+			.base.cra_name		= "f8(kasumi)",
+			.base.cra_driver_name	= "f8-kasumi-picoxcell",
+			.base.cra_priority	= SPACC_CRYPTO_ALG_PRIORITY,
+			.base.cra_flags		= CRYPTO_ALG_ASYNC |
+						  CRYPTO_ALG_KERN_DRIVER_ONLY,
+			.base.cra_blocksize	= 8,
+			.base.cra_ctxsize	= sizeof(struct spacc_ablk_ctx),
+			.base.cra_module	= THIS_MODULE,
+
+			.setkey			= spacc_kasumi_f8_setkey,
+			.encrypt		= spacc_ablk_encrypt,
+			.decrypt		= spacc_ablk_decrypt,
+			.min_keysize		= 16,
+			.max_keysize		= 16,
+			.ivsize			= 8,
+			.init			= spacc_ablk_init_tfm,
+			.exit			= spacc_ablk_exit_tfm,
 		},
 	},
 };
@@ -1721,7 +1703,7 @@ static int spacc_probe(struct platform_device *pdev)
 	INIT_LIST_HEAD(&engine->registered_algs);
 	for (i = 0; i < engine->num_algs; ++i) {
 		engine->algs[i].engine = engine;
-		err = crypto_register_alg(&engine->algs[i].alg);
+		err = crypto_register_skcipher(&engine->algs[i].alg);
 		if (!err) {
 			list_add_tail(&engine->algs[i].entry,
 				      &engine->registered_algs);
@@ -1729,10 +1711,10 @@ static int spacc_probe(struct platform_device *pdev)
 		}
 		if (err)
 			dev_err(engine->dev, "failed to register alg \"%s\"\n",
-				engine->algs[i].alg.cra_name);
+				engine->algs[i].alg.base.cra_name);
 		else
 			dev_dbg(engine->dev, "registered alg \"%s\"\n",
-				engine->algs[i].alg.cra_name);
+				engine->algs[i].alg.base.cra_name);
 	}
 
 	INIT_LIST_HEAD(&engine->registered_aeads);
@@ -1781,7 +1763,7 @@ static int spacc_remove(struct platform_device *pdev)
 
 	list_for_each_entry_safe(alg, next, &engine->registered_algs, entry) {
 		list_del(&alg->entry);
-		crypto_unregister_alg(&alg->alg);
+		crypto_unregister_skcipher(&alg->alg);
 	}
 
 	clk_disable_unprepare(engine->clk);
-- 
2.20.1


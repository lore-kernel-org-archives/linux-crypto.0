Return-Path: <SRS0=VKJi=YH=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AE69BECE595
	for <linux-crypto@archiver.kernel.org>; Mon, 14 Oct 2019 12:20:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 895A5214AE
	for <linux-crypto@archiver.kernel.org>; Mon, 14 Oct 2019 12:20:15 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="pj7Xna9X"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729054AbfJNMUI (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 14 Oct 2019 08:20:08 -0400
Received: from mail-wr1-f67.google.com ([209.85.221.67]:33358 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730052AbfJNMUI (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 14 Oct 2019 08:20:08 -0400
Received: by mail-wr1-f67.google.com with SMTP id b9so19504952wrs.0
        for <linux-crypto@vger.kernel.org>; Mon, 14 Oct 2019 05:20:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=tDXktGakkFdb9+F7OiKF0EEQZztrzDB1iwmCsDinX4g=;
        b=pj7Xna9Xoad0/4olhQVLutHLa9qj9LbfWBMRj4HmREzvo2Ay3FodeB1THWtfGjzx3v
         2vw9LL/w8MqaLFjTxdUCLB81BTyezXmQwyEcjNzRITokug8PrF/Fq0TxXWdtN6N3pVuM
         9ef//HAWF+I6NWM/tSuGv3D47vk+L53sA8NcxWSHGLEaj44Y7j6SLFg1KERuZ36fId4b
         NWPiOcQHflvfWyjUAoVWk7oJ4VPsNNFCtJ71ItmYLjvOxL2DRDpu1Ct1tyakzjK2evlI
         r1ykcNp5Y2VFHUItvwbAfKNYdB6BXHc7EVMgPszXJfSSl5seNeYweYg2LzAMoTFi3BOt
         7eRw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=tDXktGakkFdb9+F7OiKF0EEQZztrzDB1iwmCsDinX4g=;
        b=OTO37G69Ic+G/ohIML/KQEOl9mphjoABOS/obinrmMJ47YHQqWtGC7KLs92YfzFqKV
         Dpm/VzlsgGDqcO4Dzjf3PUjSBBOMGtgzphvhaGJpsB31ObuS/YabQpg8o1/Bm4Y0Tvta
         DSoxGuFwDnJf801z6C5Sis26NSEgV1veXkiWUzXbJc7N04i6fg7eA1FtdBXSMkt9I9Hs
         YgCm+tIq9/aLQ/TzMEkXWgzn1UeVix8YDZ+hRcEgvsOvWGlMxwNktYv1mmhZlwkjpSQ+
         byUdNLHol3uL/Sze9Tx2ruEl/rc0v9bl4quKypRzwDGEsqpUFUQxtlYMU0zpnF5eYKvn
         Dm1Q==
X-Gm-Message-State: APjAAAU9WJjncG91fkFLalj6ZRE6gXOJQqiz+frpvhaNGzN0Iz7/hvRW
        Q+zajWtIzhXRGHzO1LXHEwX+5YozlISJbw==
X-Google-Smtp-Source: APXvYqzMiwqBOiDnneOCZYj0eDr8+ix1N1+HrfQ/ilwBWpcPnFYi9DjdSf1zuxjOv3penljTp9H+Kw==
X-Received: by 2002:adf:e4c2:: with SMTP id v2mr24522221wrm.324.1571055603322;
        Mon, 14 Oct 2019 05:20:03 -0700 (PDT)
Received: from localhost.localdomain (91-167-84-221.subs.proxad.net. [91.167.84.221])
        by smtp.gmail.com with ESMTPSA id i1sm20222470wmb.19.2019.10.14.05.20.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 14 Oct 2019 05:20:02 -0700 (PDT)
From:   Ard Biesheuvel <ard.biesheuvel@linaro.org>
To:     linux-crypto@vger.kernel.org
Cc:     Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Biggers <ebiggers@google.com>,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH 22/25] crypto: qce - switch to skcipher API
Date:   Mon, 14 Oct 2019 14:19:07 +0200
Message-Id: <20191014121910.7264-23-ard.biesheuvel@linaro.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191014121910.7264-1-ard.biesheuvel@linaro.org>
References: <20191014121910.7264-1-ard.biesheuvel@linaro.org>
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

Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
---
 drivers/crypto/qce/Makefile                     |   2 +-
 drivers/crypto/qce/cipher.h                     |   8 +-
 drivers/crypto/qce/common.c                     |  12 +-
 drivers/crypto/qce/common.h                     |   3 +-
 drivers/crypto/qce/core.c                       |   2 +-
 drivers/crypto/qce/{ablkcipher.c => skcipher.c} | 172 ++++++++++----------
 6 files changed, 100 insertions(+), 99 deletions(-)

diff --git a/drivers/crypto/qce/Makefile b/drivers/crypto/qce/Makefile
index 19a7f899acff..8caa04e1ec43 100644
--- a/drivers/crypto/qce/Makefile
+++ b/drivers/crypto/qce/Makefile
@@ -4,4 +4,4 @@ qcrypto-objs := core.o \
 		common.o \
 		dma.o \
 		sha.o \
-		ablkcipher.o
+		skcipher.o
diff --git a/drivers/crypto/qce/cipher.h b/drivers/crypto/qce/cipher.h
index 5cab8f0706a8..7770660bc853 100644
--- a/drivers/crypto/qce/cipher.h
+++ b/drivers/crypto/qce/cipher.h
@@ -45,12 +45,12 @@ struct qce_cipher_reqctx {
 	unsigned int cryptlen;
 };
 
-static inline struct qce_alg_template *to_cipher_tmpl(struct crypto_tfm *tfm)
+static inline struct qce_alg_template *to_cipher_tmpl(struct crypto_skcipher *tfm)
 {
-	struct crypto_alg *alg = tfm->__crt_alg;
-	return container_of(alg, struct qce_alg_template, alg.crypto);
+	struct skcipher_alg *alg = crypto_skcipher_alg(tfm);
+	return container_of(alg, struct qce_alg_template, alg.skcipher);
 }
 
-extern const struct qce_algo_ops ablkcipher_ops;
+extern const struct qce_algo_ops skcipher_ops;
 
 #endif /* _CIPHER_H_ */
diff --git a/drivers/crypto/qce/common.c b/drivers/crypto/qce/common.c
index 3fb510164326..da1188abc9ba 100644
--- a/drivers/crypto/qce/common.c
+++ b/drivers/crypto/qce/common.c
@@ -304,13 +304,13 @@ static int qce_setup_regs_ahash(struct crypto_async_request *async_req,
 	return 0;
 }
 
-static int qce_setup_regs_ablkcipher(struct crypto_async_request *async_req,
+static int qce_setup_regs_skcipher(struct crypto_async_request *async_req,
 				     u32 totallen, u32 offset)
 {
-	struct ablkcipher_request *req = ablkcipher_request_cast(async_req);
-	struct qce_cipher_reqctx *rctx = ablkcipher_request_ctx(req);
+	struct skcipher_request *req = skcipher_request_cast(async_req);
+	struct qce_cipher_reqctx *rctx = skcipher_request_ctx(req);
 	struct qce_cipher_ctx *ctx = crypto_tfm_ctx(async_req->tfm);
-	struct qce_alg_template *tmpl = to_cipher_tmpl(async_req->tfm);
+	struct qce_alg_template *tmpl = to_cipher_tmpl(crypto_skcipher_reqtfm(req));
 	struct qce_device *qce = tmpl->qce;
 	__be32 enckey[QCE_MAX_CIPHER_KEY_SIZE / sizeof(__be32)] = {0};
 	__be32 enciv[QCE_MAX_IV_SIZE / sizeof(__be32)] = {0};
@@ -389,8 +389,8 @@ int qce_start(struct crypto_async_request *async_req, u32 type, u32 totallen,
 	      u32 offset)
 {
 	switch (type) {
-	case CRYPTO_ALG_TYPE_ABLKCIPHER:
-		return qce_setup_regs_ablkcipher(async_req, totallen, offset);
+	case CRYPTO_ALG_TYPE_SKCIPHER:
+		return qce_setup_regs_skcipher(async_req, totallen, offset);
 	case CRYPTO_ALG_TYPE_AHASH:
 		return qce_setup_regs_ahash(async_req, totallen, offset);
 	default:
diff --git a/drivers/crypto/qce/common.h b/drivers/crypto/qce/common.h
index 47fb523357ac..282d4317470d 100644
--- a/drivers/crypto/qce/common.h
+++ b/drivers/crypto/qce/common.h
@@ -10,6 +10,7 @@
 #include <linux/types.h>
 #include <crypto/aes.h>
 #include <crypto/hash.h>
+#include <crypto/internal/skcipher.h>
 
 /* key size in bytes */
 #define QCE_SHA_HMAC_KEY_SIZE		64
@@ -79,7 +80,7 @@ struct qce_alg_template {
 	unsigned long alg_flags;
 	const u32 *std_iv;
 	union {
-		struct crypto_alg crypto;
+		struct skcipher_alg skcipher;
 		struct ahash_alg ahash;
 	} alg;
 	struct qce_device *qce;
diff --git a/drivers/crypto/qce/core.c b/drivers/crypto/qce/core.c
index 08d4ce3bfddf..0a44a6eeacf5 100644
--- a/drivers/crypto/qce/core.c
+++ b/drivers/crypto/qce/core.c
@@ -22,7 +22,7 @@
 #define QCE_QUEUE_LENGTH	1
 
 static const struct qce_algo_ops *qce_ops[] = {
-	&ablkcipher_ops,
+	&skcipher_ops,
 	&ahash_ops,
 };
 
diff --git a/drivers/crypto/qce/ablkcipher.c b/drivers/crypto/qce/skcipher.c
similarity index 61%
rename from drivers/crypto/qce/ablkcipher.c
rename to drivers/crypto/qce/skcipher.c
index f0b59a8bbed0..fee07323f8f9 100644
--- a/drivers/crypto/qce/ablkcipher.c
+++ b/drivers/crypto/qce/skcipher.c
@@ -12,14 +12,14 @@
 
 #include "cipher.h"
 
-static LIST_HEAD(ablkcipher_algs);
+static LIST_HEAD(skcipher_algs);
 
-static void qce_ablkcipher_done(void *data)
+static void qce_skcipher_done(void *data)
 {
 	struct crypto_async_request *async_req = data;
-	struct ablkcipher_request *req = ablkcipher_request_cast(async_req);
-	struct qce_cipher_reqctx *rctx = ablkcipher_request_ctx(req);
-	struct qce_alg_template *tmpl = to_cipher_tmpl(async_req->tfm);
+	struct skcipher_request *req = skcipher_request_cast(async_req);
+	struct qce_cipher_reqctx *rctx = skcipher_request_ctx(req);
+	struct qce_alg_template *tmpl = to_cipher_tmpl(crypto_skcipher_reqtfm(req));
 	struct qce_device *qce = tmpl->qce;
 	enum dma_data_direction dir_src, dir_dst;
 	u32 status;
@@ -32,7 +32,7 @@ static void qce_ablkcipher_done(void *data)
 
 	error = qce_dma_terminate_all(&qce->dma);
 	if (error)
-		dev_dbg(qce->dev, "ablkcipher dma termination error (%d)\n",
+		dev_dbg(qce->dev, "skcipher dma termination error (%d)\n",
 			error);
 
 	if (diff_dst)
@@ -43,18 +43,18 @@ static void qce_ablkcipher_done(void *data)
 
 	error = qce_check_status(qce, &status);
 	if (error < 0)
-		dev_dbg(qce->dev, "ablkcipher operation error (%x)\n", status);
+		dev_dbg(qce->dev, "skcipher operation error (%x)\n", status);
 
 	qce->async_req_done(tmpl->qce, error);
 }
 
 static int
-qce_ablkcipher_async_req_handle(struct crypto_async_request *async_req)
+qce_skcipher_async_req_handle(struct crypto_async_request *async_req)
 {
-	struct ablkcipher_request *req = ablkcipher_request_cast(async_req);
-	struct qce_cipher_reqctx *rctx = ablkcipher_request_ctx(req);
-	struct crypto_ablkcipher *ablkcipher = crypto_ablkcipher_reqtfm(req);
-	struct qce_alg_template *tmpl = to_cipher_tmpl(async_req->tfm);
+	struct skcipher_request *req = skcipher_request_cast(async_req);
+	struct qce_cipher_reqctx *rctx = skcipher_request_ctx(req);
+	struct crypto_skcipher *skcipher = crypto_skcipher_reqtfm(req);
+	struct qce_alg_template *tmpl = to_cipher_tmpl(crypto_skcipher_reqtfm(req));
 	struct qce_device *qce = tmpl->qce;
 	enum dma_data_direction dir_src, dir_dst;
 	struct scatterlist *sg;
@@ -62,17 +62,17 @@ qce_ablkcipher_async_req_handle(struct crypto_async_request *async_req)
 	gfp_t gfp;
 	int ret;
 
-	rctx->iv = req->info;
-	rctx->ivsize = crypto_ablkcipher_ivsize(ablkcipher);
-	rctx->cryptlen = req->nbytes;
+	rctx->iv = req->iv;
+	rctx->ivsize = crypto_skcipher_ivsize(skcipher);
+	rctx->cryptlen = req->cryptlen;
 
 	diff_dst = (req->src != req->dst) ? true : false;
 	dir_src = diff_dst ? DMA_TO_DEVICE : DMA_BIDIRECTIONAL;
 	dir_dst = diff_dst ? DMA_FROM_DEVICE : DMA_BIDIRECTIONAL;
 
-	rctx->src_nents = sg_nents_for_len(req->src, req->nbytes);
+	rctx->src_nents = sg_nents_for_len(req->src, req->cryptlen);
 	if (diff_dst)
-		rctx->dst_nents = sg_nents_for_len(req->dst, req->nbytes);
+		rctx->dst_nents = sg_nents_for_len(req->dst, req->cryptlen);
 	else
 		rctx->dst_nents = rctx->src_nents;
 	if (rctx->src_nents < 0) {
@@ -125,13 +125,13 @@ qce_ablkcipher_async_req_handle(struct crypto_async_request *async_req)
 
 	ret = qce_dma_prep_sgs(&qce->dma, rctx->src_sg, rctx->src_nents,
 			       rctx->dst_sg, rctx->dst_nents,
-			       qce_ablkcipher_done, async_req);
+			       qce_skcipher_done, async_req);
 	if (ret)
 		goto error_unmap_src;
 
 	qce_dma_issue_pending(&qce->dma);
 
-	ret = qce_start(async_req, tmpl->crypto_alg_type, req->nbytes, 0);
+	ret = qce_start(async_req, tmpl->crypto_alg_type, req->cryptlen, 0);
 	if (ret)
 		goto error_terminate;
 
@@ -149,10 +149,10 @@ qce_ablkcipher_async_req_handle(struct crypto_async_request *async_req)
 	return ret;
 }
 
-static int qce_ablkcipher_setkey(struct crypto_ablkcipher *ablk, const u8 *key,
+static int qce_skcipher_setkey(struct crypto_skcipher *ablk, const u8 *key,
 				 unsigned int keylen)
 {
-	struct crypto_tfm *tfm = crypto_ablkcipher_tfm(ablk);
+	struct crypto_tfm *tfm = crypto_skcipher_tfm(ablk);
 	struct qce_cipher_ctx *ctx = crypto_tfm_ctx(tfm);
 	int ret;
 
@@ -177,13 +177,13 @@ static int qce_ablkcipher_setkey(struct crypto_ablkcipher *ablk, const u8 *key,
 	return ret;
 }
 
-static int qce_des_setkey(struct crypto_ablkcipher *ablk, const u8 *key,
+static int qce_des_setkey(struct crypto_skcipher *ablk, const u8 *key,
 			  unsigned int keylen)
 {
-	struct qce_cipher_ctx *ctx = crypto_ablkcipher_ctx(ablk);
+	struct qce_cipher_ctx *ctx = crypto_skcipher_ctx(ablk);
 	int err;
 
-	err = verify_ablkcipher_des_key(ablk, key);
+	err = verify_skcipher_des_key(ablk, key);
 	if (err)
 		return err;
 
@@ -192,13 +192,13 @@ static int qce_des_setkey(struct crypto_ablkcipher *ablk, const u8 *key,
 	return 0;
 }
 
-static int qce_des3_setkey(struct crypto_ablkcipher *ablk, const u8 *key,
+static int qce_des3_setkey(struct crypto_skcipher *ablk, const u8 *key,
 			   unsigned int keylen)
 {
-	struct qce_cipher_ctx *ctx = crypto_ablkcipher_ctx(ablk);
+	struct qce_cipher_ctx *ctx = crypto_skcipher_ctx(ablk);
 	int err;
 
-	err = verify_ablkcipher_des3_key(ablk, key);
+	err = verify_skcipher_des3_key(ablk, key);
 	if (err)
 		return err;
 
@@ -207,12 +207,11 @@ static int qce_des3_setkey(struct crypto_ablkcipher *ablk, const u8 *key,
 	return 0;
 }
 
-static int qce_ablkcipher_crypt(struct ablkcipher_request *req, int encrypt)
+static int qce_skcipher_crypt(struct skcipher_request *req, int encrypt)
 {
-	struct crypto_tfm *tfm =
-			crypto_ablkcipher_tfm(crypto_ablkcipher_reqtfm(req));
-	struct qce_cipher_ctx *ctx = crypto_tfm_ctx(tfm);
-	struct qce_cipher_reqctx *rctx = ablkcipher_request_ctx(req);
+	struct crypto_skcipher *tfm = crypto_skcipher_reqtfm(req);
+	struct qce_cipher_ctx *ctx = crypto_skcipher_ctx(tfm);
+	struct qce_cipher_reqctx *rctx = skcipher_request_ctx(req);
 	struct qce_alg_template *tmpl = to_cipher_tmpl(tfm);
 	int ret;
 
@@ -227,7 +226,7 @@ static int qce_ablkcipher_crypt(struct ablkcipher_request *req, int encrypt)
 		skcipher_request_set_callback(subreq, req->base.flags,
 					      NULL, NULL);
 		skcipher_request_set_crypt(subreq, req->src, req->dst,
-					   req->nbytes, req->info);
+					   req->cryptlen, req->iv);
 		ret = encrypt ? crypto_skcipher_encrypt(subreq) :
 				crypto_skcipher_decrypt(subreq);
 		skcipher_request_zero(subreq);
@@ -237,36 +236,36 @@ static int qce_ablkcipher_crypt(struct ablkcipher_request *req, int encrypt)
 	return tmpl->qce->async_req_enqueue(tmpl->qce, &req->base);
 }
 
-static int qce_ablkcipher_encrypt(struct ablkcipher_request *req)
+static int qce_skcipher_encrypt(struct skcipher_request *req)
 {
-	return qce_ablkcipher_crypt(req, 1);
+	return qce_skcipher_crypt(req, 1);
 }
 
-static int qce_ablkcipher_decrypt(struct ablkcipher_request *req)
+static int qce_skcipher_decrypt(struct skcipher_request *req)
 {
-	return qce_ablkcipher_crypt(req, 0);
+	return qce_skcipher_crypt(req, 0);
 }
 
-static int qce_ablkcipher_init(struct crypto_tfm *tfm)
+static int qce_skcipher_init(struct crypto_skcipher *tfm)
 {
-	struct qce_cipher_ctx *ctx = crypto_tfm_ctx(tfm);
+	struct qce_cipher_ctx *ctx = crypto_skcipher_ctx(tfm);
 
 	memset(ctx, 0, sizeof(*ctx));
-	tfm->crt_ablkcipher.reqsize = sizeof(struct qce_cipher_reqctx);
+	crypto_skcipher_set_reqsize(tfm, sizeof(struct qce_cipher_reqctx));
 
-	ctx->fallback = crypto_alloc_sync_skcipher(crypto_tfm_alg_name(tfm),
+	ctx->fallback = crypto_alloc_sync_skcipher(crypto_tfm_alg_name(&tfm->base),
 						   0, CRYPTO_ALG_NEED_FALLBACK);
 	return PTR_ERR_OR_ZERO(ctx->fallback);
 }
 
-static void qce_ablkcipher_exit(struct crypto_tfm *tfm)
+static void qce_skcipher_exit(struct crypto_skcipher *tfm)
 {
-	struct qce_cipher_ctx *ctx = crypto_tfm_ctx(tfm);
+	struct qce_cipher_ctx *ctx = crypto_skcipher_ctx(tfm);
 
 	crypto_free_sync_skcipher(ctx->fallback);
 }
 
-struct qce_ablkcipher_def {
+struct qce_skcipher_def {
 	unsigned long flags;
 	const char *name;
 	const char *drv_name;
@@ -276,7 +275,7 @@ struct qce_ablkcipher_def {
 	unsigned int max_keysize;
 };
 
-static const struct qce_ablkcipher_def ablkcipher_def[] = {
+static const struct qce_skcipher_def skcipher_def[] = {
 	{
 		.flags		= QCE_ALG_AES | QCE_MODE_ECB,
 		.name		= "ecb(aes)",
@@ -351,90 +350,91 @@ static const struct qce_ablkcipher_def ablkcipher_def[] = {
 	},
 };
 
-static int qce_ablkcipher_register_one(const struct qce_ablkcipher_def *def,
+static int qce_skcipher_register_one(const struct qce_skcipher_def *def,
 				       struct qce_device *qce)
 {
 	struct qce_alg_template *tmpl;
-	struct crypto_alg *alg;
+	struct skcipher_alg *alg;
 	int ret;
 
 	tmpl = kzalloc(sizeof(*tmpl), GFP_KERNEL);
 	if (!tmpl)
 		return -ENOMEM;
 
-	alg = &tmpl->alg.crypto;
+	alg = &tmpl->alg.skcipher;
 
-	snprintf(alg->cra_name, CRYPTO_MAX_ALG_NAME, "%s", def->name);
-	snprintf(alg->cra_driver_name, CRYPTO_MAX_ALG_NAME, "%s",
+	snprintf(alg->base.cra_name, CRYPTO_MAX_ALG_NAME, "%s", def->name);
+	snprintf(alg->base.cra_driver_name, CRYPTO_MAX_ALG_NAME, "%s",
 		 def->drv_name);
 
-	alg->cra_blocksize = def->blocksize;
-	alg->cra_ablkcipher.ivsize = def->ivsize;
-	alg->cra_ablkcipher.min_keysize = def->min_keysize;
-	alg->cra_ablkcipher.max_keysize = def->max_keysize;
-	alg->cra_ablkcipher.setkey = IS_3DES(def->flags) ? qce_des3_setkey :
-				     IS_DES(def->flags) ? qce_des_setkey :
-				     qce_ablkcipher_setkey;
-	alg->cra_ablkcipher.encrypt = qce_ablkcipher_encrypt;
-	alg->cra_ablkcipher.decrypt = qce_ablkcipher_decrypt;
-
-	alg->cra_priority = 300;
-	alg->cra_flags = CRYPTO_ALG_TYPE_ABLKCIPHER | CRYPTO_ALG_ASYNC |
-			 CRYPTO_ALG_NEED_FALLBACK | CRYPTO_ALG_KERN_DRIVER_ONLY;
-	alg->cra_ctxsize = sizeof(struct qce_cipher_ctx);
-	alg->cra_alignmask = 0;
-	alg->cra_type = &crypto_ablkcipher_type;
-	alg->cra_module = THIS_MODULE;
-	alg->cra_init = qce_ablkcipher_init;
-	alg->cra_exit = qce_ablkcipher_exit;
+	alg->base.cra_blocksize		= def->blocksize;
+	alg->ivsize			= def->ivsize;
+	alg->min_keysize		= def->min_keysize;
+	alg->max_keysize		= def->max_keysize;
+	alg->setkey			= IS_3DES(def->flags) ? qce_des3_setkey :
+					  IS_DES(def->flags) ? qce_des_setkey :
+					  qce_skcipher_setkey;
+	alg->encrypt			= qce_skcipher_encrypt;
+	alg->decrypt			= qce_skcipher_decrypt;
+
+	alg->base.cra_priority		= 300;
+	alg->base.cra_flags		= CRYPTO_ALG_ASYNC |
+					  CRYPTO_ALG_NEED_FALLBACK |
+					  CRYPTO_ALG_KERN_DRIVER_ONLY;
+	alg->base.cra_ctxsize		= sizeof(struct qce_cipher_ctx);
+	alg->base.cra_alignmask		= 0;
+	alg->base.cra_module		= THIS_MODULE;
+
+	alg->init			= qce_skcipher_init;
+	alg->exit			= qce_skcipher_exit;
 
 	INIT_LIST_HEAD(&tmpl->entry);
-	tmpl->crypto_alg_type = CRYPTO_ALG_TYPE_ABLKCIPHER;
+	tmpl->crypto_alg_type = CRYPTO_ALG_TYPE_SKCIPHER;
 	tmpl->alg_flags = def->flags;
 	tmpl->qce = qce;
 
-	ret = crypto_register_alg(alg);
+	ret = crypto_register_skcipher(alg);
 	if (ret) {
 		kfree(tmpl);
-		dev_err(qce->dev, "%s registration failed\n", alg->cra_name);
+		dev_err(qce->dev, "%s registration failed\n", alg->base.cra_name);
 		return ret;
 	}
 
-	list_add_tail(&tmpl->entry, &ablkcipher_algs);
-	dev_dbg(qce->dev, "%s is registered\n", alg->cra_name);
+	list_add_tail(&tmpl->entry, &skcipher_algs);
+	dev_dbg(qce->dev, "%s is registered\n", alg->base.cra_name);
 	return 0;
 }
 
-static void qce_ablkcipher_unregister(struct qce_device *qce)
+static void qce_skcipher_unregister(struct qce_device *qce)
 {
 	struct qce_alg_template *tmpl, *n;
 
-	list_for_each_entry_safe(tmpl, n, &ablkcipher_algs, entry) {
-		crypto_unregister_alg(&tmpl->alg.crypto);
+	list_for_each_entry_safe(tmpl, n, &skcipher_algs, entry) {
+		crypto_unregister_skcipher(&tmpl->alg.skcipher);
 		list_del(&tmpl->entry);
 		kfree(tmpl);
 	}
 }
 
-static int qce_ablkcipher_register(struct qce_device *qce)
+static int qce_skcipher_register(struct qce_device *qce)
 {
 	int ret, i;
 
-	for (i = 0; i < ARRAY_SIZE(ablkcipher_def); i++) {
-		ret = qce_ablkcipher_register_one(&ablkcipher_def[i], qce);
+	for (i = 0; i < ARRAY_SIZE(skcipher_def); i++) {
+		ret = qce_skcipher_register_one(&skcipher_def[i], qce);
 		if (ret)
 			goto err;
 	}
 
 	return 0;
 err:
-	qce_ablkcipher_unregister(qce);
+	qce_skcipher_unregister(qce);
 	return ret;
 }
 
-const struct qce_algo_ops ablkcipher_ops = {
-	.type = CRYPTO_ALG_TYPE_ABLKCIPHER,
-	.register_algs = qce_ablkcipher_register,
-	.unregister_algs = qce_ablkcipher_unregister,
-	.async_req_handle = qce_ablkcipher_async_req_handle,
+const struct qce_algo_ops skcipher_ops = {
+	.type = CRYPTO_ALG_TYPE_SKCIPHER,
+	.register_algs = qce_skcipher_register,
+	.unregister_algs = qce_skcipher_unregister,
+	.async_req_handle = qce_skcipher_async_req_handle,
 };
-- 
2.20.1


Return-Path: <SRS0=tzqc=YR=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4C1C9CA9EBC
	for <linux-crypto@archiver.kernel.org>; Thu, 24 Oct 2019 13:24:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0A9052084C
	for <linux-crypto@archiver.kernel.org>; Thu, 24 Oct 2019 13:24:05 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="qAXKItv7"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2502541AbfJXNYE (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 24 Oct 2019 09:24:04 -0400
Received: from mail-wr1-f51.google.com ([209.85.221.51]:38885 "EHLO
        mail-wr1-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2502550AbfJXNYE (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 24 Oct 2019 09:24:04 -0400
Received: by mail-wr1-f51.google.com with SMTP id v9so14798681wrq.5
        for <linux-crypto@vger.kernel.org>; Thu, 24 Oct 2019 06:24:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=pvLxGTkuD+BMHjJIFxtXwHoyUp4V/EFW7euwv8EkRzY=;
        b=qAXKItv7KUeFPk1fXOh/B0uzUOKt1LHtg3qKMN06GgsogGhyXQMESfGKUQTqogc1Ab
         8RS+jl43z2+8utgq7FCMWt1tTILOTc9xTRxWLVLsasN/lJBoMhHbsu/zyKo5RkahdEMz
         xUD+JIJtt3/nlbJRARo4p7bFxFiOHOVZD12OtCiDDQAyy8LwY9hXN0Vkc6V8IyGCzTsb
         zHRHcIsUL+cSom1P1UlEHMDvfMYYKVwdznI+sUVhHpCMAsHFkIuceFMmrxIOLuFBeBP7
         TvGMODU56Yxj3PzNU4Ipch8Yw2j03gYOoFHOS272dEWU5elpnDsWmlyGAH1zQQN56U9e
         HYkA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=pvLxGTkuD+BMHjJIFxtXwHoyUp4V/EFW7euwv8EkRzY=;
        b=bOS32WX4xYEcsqUfane1TxIZl6dLnphQQUHG2nlH76bi6Rb//2MyeOeTBI2H/K75qp
         G28/9EL3iXbWeultXCQwvxHKOq6DMddlCiYOOZztM/DUFe2Ch4vKQmuPCUrwvuxc0uK9
         D1dNIANAC9lDYgYDy1q84QTa+/w1kO6H0xW/Sl65XGyhB+zuV/4tSE4h7Q7+IINp1tXi
         rKodYNMV4llLmaKJuhwAfOLzS2gphqzm7xqRW5kNn80LFaxyHjM1UGtysBGE1fldEjOF
         K6NRaEJeuAGi3jhmuKiKj1tCBCaVTUOwVUCuHClAYmK3NOvh7j9l7Sa+UWGb3MdqGySt
         UUFw==
X-Gm-Message-State: APjAAAUg3vc7uOW98ooS4gJrC8xk/d7cZ9YEouojmuMu/U/+vZ2NW/jU
        b15PgNtjLPfqC56HsQffRWu4bVUzMOITcJop
X-Google-Smtp-Source: APXvYqzQVmzqlZ6pbd7mxFu2xx4xPEZLCAMp4X5cSQYUPmHKniSFgq6nSrUyBFt5eBMT1UJEUzPgWA==
X-Received: by 2002:adf:a547:: with SMTP id j7mr3828429wrb.154.1571923439333;
        Thu, 24 Oct 2019 06:23:59 -0700 (PDT)
Received: from localhost.localdomain (laubervilliers-657-1-83-120.w92-154.abo.wanadoo.fr. [92.154.90.120])
        by smtp.gmail.com with ESMTPSA id e3sm2346310wme.36.2019.10.24.06.23.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 24 Oct 2019 06:23:58 -0700 (PDT)
From:   Ard Biesheuvel <ard.biesheuvel@linaro.org>
To:     linux-crypto@vger.kernel.org
Cc:     Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Biggers <ebiggers@google.com>,
        linux-arm-kernel@lists.infradead.org,
        Gary R Hook <gary.hook@amd.com>
Subject: [PATCH v2 04/27] crypto: ccp - switch from ablkcipher to skcipher
Date:   Thu, 24 Oct 2019 15:23:22 +0200
Message-Id: <20191024132345.5236-5-ard.biesheuvel@linaro.org>
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

Reviewed-by: Gary R Hook <gary.hook@amd.com>
Tested-by: Gary R Hook <gary.hook@amd.com>
Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
---
 drivers/crypto/ccp/ccp-crypto-aes-galois.c |   7 +-
 drivers/crypto/ccp/ccp-crypto-aes-xts.c    |  94 +++++------
 drivers/crypto/ccp/ccp-crypto-aes.c        | 169 +++++++++-----------
 drivers/crypto/ccp/ccp-crypto-des3.c       | 100 ++++++------
 drivers/crypto/ccp/ccp-crypto-main.c       |  14 +-
 drivers/crypto/ccp/ccp-crypto.h            |  13 +-
 6 files changed, 186 insertions(+), 211 deletions(-)

diff --git a/drivers/crypto/ccp/ccp-crypto-aes-galois.c b/drivers/crypto/ccp/ccp-crypto-aes-galois.c
index 94c1ad7eeddf..ff50ee80d223 100644
--- a/drivers/crypto/ccp/ccp-crypto-aes-galois.c
+++ b/drivers/crypto/ccp/ccp-crypto-aes-galois.c
@@ -172,14 +172,12 @@ static struct aead_alg ccp_aes_gcm_defaults = {
 	.ivsize = GCM_AES_IV_SIZE,
 	.maxauthsize = AES_BLOCK_SIZE,
 	.base = {
-		.cra_flags	= CRYPTO_ALG_TYPE_ABLKCIPHER |
-				  CRYPTO_ALG_ASYNC |
+		.cra_flags	= CRYPTO_ALG_ASYNC |
 				  CRYPTO_ALG_KERN_DRIVER_ONLY |
 				  CRYPTO_ALG_NEED_FALLBACK,
 		.cra_blocksize	= AES_BLOCK_SIZE,
 		.cra_ctxsize	= sizeof(struct ccp_ctx),
 		.cra_priority	= CCP_CRA_PRIORITY,
-		.cra_type	= &crypto_ablkcipher_type,
 		.cra_exit	= ccp_aes_gcm_cra_exit,
 		.cra_module	= THIS_MODULE,
 	},
@@ -229,11 +227,10 @@ static int ccp_register_aes_aead(struct list_head *head,
 	snprintf(alg->base.cra_driver_name, CRYPTO_MAX_ALG_NAME, "%s",
 		 def->driver_name);
 	alg->base.cra_blocksize = def->blocksize;
-	alg->base.cra_ablkcipher.ivsize = def->ivsize;
 
 	ret = crypto_register_aead(alg);
 	if (ret) {
-		pr_err("%s ablkcipher algorithm registration error (%d)\n",
+		pr_err("%s aead algorithm registration error (%d)\n",
 		       alg->base.cra_name, ret);
 		kfree(ccp_aead);
 		return ret;
diff --git a/drivers/crypto/ccp/ccp-crypto-aes-xts.c b/drivers/crypto/ccp/ccp-crypto-aes-xts.c
index 8e4a531f4f70..04b2517df955 100644
--- a/drivers/crypto/ccp/ccp-crypto-aes-xts.c
+++ b/drivers/crypto/ccp/ccp-crypto-aes-xts.c
@@ -24,7 +24,7 @@ struct ccp_aes_xts_def {
 	const char *drv_name;
 };
 
-static struct ccp_aes_xts_def aes_xts_algs[] = {
+static const struct ccp_aes_xts_def aes_xts_algs[] = {
 	{
 		.name		= "xts(aes)",
 		.drv_name	= "xts-aes-ccp",
@@ -61,26 +61,25 @@ static struct ccp_unit_size_map xts_unit_sizes[] = {
 
 static int ccp_aes_xts_complete(struct crypto_async_request *async_req, int ret)
 {
-	struct ablkcipher_request *req = ablkcipher_request_cast(async_req);
-	struct ccp_aes_req_ctx *rctx = ablkcipher_request_ctx(req);
+	struct skcipher_request *req = skcipher_request_cast(async_req);
+	struct ccp_aes_req_ctx *rctx = skcipher_request_ctx(req);
 
 	if (ret)
 		return ret;
 
-	memcpy(req->info, rctx->iv, AES_BLOCK_SIZE);
+	memcpy(req->iv, rctx->iv, AES_BLOCK_SIZE);
 
 	return 0;
 }
 
-static int ccp_aes_xts_setkey(struct crypto_ablkcipher *tfm, const u8 *key,
+static int ccp_aes_xts_setkey(struct crypto_skcipher *tfm, const u8 *key,
 			      unsigned int key_len)
 {
-	struct crypto_tfm *xfm = crypto_ablkcipher_tfm(tfm);
-	struct ccp_ctx *ctx = crypto_tfm_ctx(xfm);
+	struct ccp_ctx *ctx = crypto_skcipher_ctx(tfm);
 	unsigned int ccpversion = ccp_version();
 	int ret;
 
-	ret = xts_check_key(xfm, key, key_len);
+	ret = xts_verify_key(tfm, key, key_len);
 	if (ret)
 		return ret;
 
@@ -102,11 +101,12 @@ static int ccp_aes_xts_setkey(struct crypto_ablkcipher *tfm, const u8 *key,
 	return crypto_sync_skcipher_setkey(ctx->u.aes.tfm_skcipher, key, key_len);
 }
 
-static int ccp_aes_xts_crypt(struct ablkcipher_request *req,
+static int ccp_aes_xts_crypt(struct skcipher_request *req,
 			     unsigned int encrypt)
 {
-	struct ccp_ctx *ctx = crypto_tfm_ctx(req->base.tfm);
-	struct ccp_aes_req_ctx *rctx = ablkcipher_request_ctx(req);
+	struct crypto_skcipher *tfm = crypto_skcipher_reqtfm(req);
+	struct ccp_ctx *ctx = crypto_skcipher_ctx(tfm);
+	struct ccp_aes_req_ctx *rctx = skcipher_request_ctx(req);
 	unsigned int ccpversion = ccp_version();
 	unsigned int fallback = 0;
 	unsigned int unit;
@@ -116,7 +116,7 @@ static int ccp_aes_xts_crypt(struct ablkcipher_request *req,
 	if (!ctx->u.aes.key_len)
 		return -EINVAL;
 
-	if (!req->info)
+	if (!req->iv)
 		return -EINVAL;
 
 	/* Check conditions under which the CCP can fulfill a request. The
@@ -127,7 +127,7 @@ static int ccp_aes_xts_crypt(struct ablkcipher_request *req,
 	 */
 	unit_size = CCP_XTS_AES_UNIT_SIZE__LAST;
 	for (unit = 0; unit < ARRAY_SIZE(xts_unit_sizes); unit++) {
-		if (req->nbytes == xts_unit_sizes[unit].size) {
+		if (req->cryptlen == xts_unit_sizes[unit].size) {
 			unit_size = unit;
 			break;
 		}
@@ -155,14 +155,14 @@ static int ccp_aes_xts_crypt(struct ablkcipher_request *req,
 		skcipher_request_set_callback(subreq, req->base.flags,
 					      NULL, NULL);
 		skcipher_request_set_crypt(subreq, req->src, req->dst,
-					   req->nbytes, req->info);
+					   req->cryptlen, req->iv);
 		ret = encrypt ? crypto_skcipher_encrypt(subreq) :
 				crypto_skcipher_decrypt(subreq);
 		skcipher_request_zero(subreq);
 		return ret;
 	}
 
-	memcpy(rctx->iv, req->info, AES_BLOCK_SIZE);
+	memcpy(rctx->iv, req->iv, AES_BLOCK_SIZE);
 	sg_init_one(&rctx->iv_sg, rctx->iv, AES_BLOCK_SIZE);
 
 	memset(&rctx->cmd, 0, sizeof(rctx->cmd));
@@ -177,7 +177,7 @@ static int ccp_aes_xts_crypt(struct ablkcipher_request *req,
 	rctx->cmd.u.xts.iv = &rctx->iv_sg;
 	rctx->cmd.u.xts.iv_len = AES_BLOCK_SIZE;
 	rctx->cmd.u.xts.src = req->src;
-	rctx->cmd.u.xts.src_len = req->nbytes;
+	rctx->cmd.u.xts.src_len = req->cryptlen;
 	rctx->cmd.u.xts.dst = req->dst;
 
 	ret = ccp_crypto_enqueue_request(&req->base, &rctx->cmd);
@@ -185,19 +185,19 @@ static int ccp_aes_xts_crypt(struct ablkcipher_request *req,
 	return ret;
 }
 
-static int ccp_aes_xts_encrypt(struct ablkcipher_request *req)
+static int ccp_aes_xts_encrypt(struct skcipher_request *req)
 {
 	return ccp_aes_xts_crypt(req, 1);
 }
 
-static int ccp_aes_xts_decrypt(struct ablkcipher_request *req)
+static int ccp_aes_xts_decrypt(struct skcipher_request *req)
 {
 	return ccp_aes_xts_crypt(req, 0);
 }
 
-static int ccp_aes_xts_cra_init(struct crypto_tfm *tfm)
+static int ccp_aes_xts_init_tfm(struct crypto_skcipher *tfm)
 {
-	struct ccp_ctx *ctx = crypto_tfm_ctx(tfm);
+	struct ccp_ctx *ctx = crypto_skcipher_ctx(tfm);
 	struct crypto_sync_skcipher *fallback_tfm;
 
 	ctx->complete = ccp_aes_xts_complete;
@@ -212,14 +212,14 @@ static int ccp_aes_xts_cra_init(struct crypto_tfm *tfm)
 	}
 	ctx->u.aes.tfm_skcipher = fallback_tfm;
 
-	tfm->crt_ablkcipher.reqsize = sizeof(struct ccp_aes_req_ctx);
+	crypto_skcipher_set_reqsize(tfm, sizeof(struct ccp_aes_req_ctx));
 
 	return 0;
 }
 
-static void ccp_aes_xts_cra_exit(struct crypto_tfm *tfm)
+static void ccp_aes_xts_exit_tfm(struct crypto_skcipher *tfm)
 {
-	struct ccp_ctx *ctx = crypto_tfm_ctx(tfm);
+	struct ccp_ctx *ctx = crypto_skcipher_ctx(tfm);
 
 	crypto_free_sync_skcipher(ctx->u.aes.tfm_skcipher);
 }
@@ -227,8 +227,8 @@ static void ccp_aes_xts_cra_exit(struct crypto_tfm *tfm)
 static int ccp_register_aes_xts_alg(struct list_head *head,
 				    const struct ccp_aes_xts_def *def)
 {
-	struct ccp_crypto_ablkcipher_alg *ccp_alg;
-	struct crypto_alg *alg;
+	struct ccp_crypto_skcipher_alg *ccp_alg;
+	struct skcipher_alg *alg;
 	int ret;
 
 	ccp_alg = kzalloc(sizeof(*ccp_alg), GFP_KERNEL);
@@ -239,30 +239,30 @@ static int ccp_register_aes_xts_alg(struct list_head *head,
 
 	alg = &ccp_alg->alg;
 
-	snprintf(alg->cra_name, CRYPTO_MAX_ALG_NAME, "%s", def->name);
-	snprintf(alg->cra_driver_name, CRYPTO_MAX_ALG_NAME, "%s",
+	snprintf(alg->base.cra_name, CRYPTO_MAX_ALG_NAME, "%s", def->name);
+	snprintf(alg->base.cra_driver_name, CRYPTO_MAX_ALG_NAME, "%s",
 		 def->drv_name);
-	alg->cra_flags = CRYPTO_ALG_TYPE_ABLKCIPHER | CRYPTO_ALG_ASYNC |
-			 CRYPTO_ALG_KERN_DRIVER_ONLY |
-			 CRYPTO_ALG_NEED_FALLBACK;
-	alg->cra_blocksize = AES_BLOCK_SIZE;
-	alg->cra_ctxsize = sizeof(struct ccp_ctx);
-	alg->cra_priority = CCP_CRA_PRIORITY;
-	alg->cra_type = &crypto_ablkcipher_type;
-	alg->cra_ablkcipher.setkey = ccp_aes_xts_setkey;
-	alg->cra_ablkcipher.encrypt = ccp_aes_xts_encrypt;
-	alg->cra_ablkcipher.decrypt = ccp_aes_xts_decrypt;
-	alg->cra_ablkcipher.min_keysize = AES_MIN_KEY_SIZE * 2;
-	alg->cra_ablkcipher.max_keysize = AES_MAX_KEY_SIZE * 2;
-	alg->cra_ablkcipher.ivsize = AES_BLOCK_SIZE;
-	alg->cra_init = ccp_aes_xts_cra_init;
-	alg->cra_exit = ccp_aes_xts_cra_exit;
-	alg->cra_module = THIS_MODULE;
-
-	ret = crypto_register_alg(alg);
+	alg->base.cra_flags	= CRYPTO_ALG_ASYNC |
+				  CRYPTO_ALG_KERN_DRIVER_ONLY |
+				  CRYPTO_ALG_NEED_FALLBACK;
+	alg->base.cra_blocksize	= AES_BLOCK_SIZE;
+	alg->base.cra_ctxsize	= sizeof(struct ccp_ctx);
+	alg->base.cra_priority	= CCP_CRA_PRIORITY;
+	alg->base.cra_module	= THIS_MODULE;
+
+	alg->setkey		= ccp_aes_xts_setkey;
+	alg->encrypt		= ccp_aes_xts_encrypt;
+	alg->decrypt		= ccp_aes_xts_decrypt;
+	alg->min_keysize	= AES_MIN_KEY_SIZE * 2;
+	alg->max_keysize	= AES_MAX_KEY_SIZE * 2;
+	alg->ivsize		= AES_BLOCK_SIZE;
+	alg->init		= ccp_aes_xts_init_tfm;
+	alg->exit		= ccp_aes_xts_exit_tfm;
+
+	ret = crypto_register_skcipher(alg);
 	if (ret) {
-		pr_err("%s ablkcipher algorithm registration error (%d)\n",
-		       alg->cra_name, ret);
+		pr_err("%s skcipher algorithm registration error (%d)\n",
+		       alg->base.cra_name, ret);
 		kfree(ccp_alg);
 		return ret;
 	}
diff --git a/drivers/crypto/ccp/ccp-crypto-aes.c b/drivers/crypto/ccp/ccp-crypto-aes.c
index 58c6dddfc5e1..33328a153225 100644
--- a/drivers/crypto/ccp/ccp-crypto-aes.c
+++ b/drivers/crypto/ccp/ccp-crypto-aes.c
@@ -21,25 +21,24 @@
 
 static int ccp_aes_complete(struct crypto_async_request *async_req, int ret)
 {
-	struct ablkcipher_request *req = ablkcipher_request_cast(async_req);
+	struct skcipher_request *req = skcipher_request_cast(async_req);
 	struct ccp_ctx *ctx = crypto_tfm_ctx(req->base.tfm);
-	struct ccp_aes_req_ctx *rctx = ablkcipher_request_ctx(req);
+	struct ccp_aes_req_ctx *rctx = skcipher_request_ctx(req);
 
 	if (ret)
 		return ret;
 
 	if (ctx->u.aes.mode != CCP_AES_MODE_ECB)
-		memcpy(req->info, rctx->iv, AES_BLOCK_SIZE);
+		memcpy(req->iv, rctx->iv, AES_BLOCK_SIZE);
 
 	return 0;
 }
 
-static int ccp_aes_setkey(struct crypto_ablkcipher *tfm, const u8 *key,
+static int ccp_aes_setkey(struct crypto_skcipher *tfm, const u8 *key,
 			  unsigned int key_len)
 {
-	struct ccp_ctx *ctx = crypto_tfm_ctx(crypto_ablkcipher_tfm(tfm));
-	struct ccp_crypto_ablkcipher_alg *alg =
-		ccp_crypto_ablkcipher_alg(crypto_ablkcipher_tfm(tfm));
+	struct ccp_crypto_skcipher_alg *alg = ccp_crypto_skcipher_alg(tfm);
+	struct ccp_ctx *ctx = crypto_skcipher_ctx(tfm);
 
 	switch (key_len) {
 	case AES_KEYSIZE_128:
@@ -52,7 +51,7 @@ static int ccp_aes_setkey(struct crypto_ablkcipher *tfm, const u8 *key,
 		ctx->u.aes.type = CCP_AES_TYPE_256;
 		break;
 	default:
-		crypto_ablkcipher_set_flags(tfm, CRYPTO_TFM_RES_BAD_KEY_LEN);
+		crypto_skcipher_set_flags(tfm, CRYPTO_TFM_RES_BAD_KEY_LEN);
 		return -EINVAL;
 	}
 	ctx->u.aes.mode = alg->mode;
@@ -64,10 +63,11 @@ static int ccp_aes_setkey(struct crypto_ablkcipher *tfm, const u8 *key,
 	return 0;
 }
 
-static int ccp_aes_crypt(struct ablkcipher_request *req, bool encrypt)
+static int ccp_aes_crypt(struct skcipher_request *req, bool encrypt)
 {
-	struct ccp_ctx *ctx = crypto_tfm_ctx(req->base.tfm);
-	struct ccp_aes_req_ctx *rctx = ablkcipher_request_ctx(req);
+	struct crypto_skcipher *tfm = crypto_skcipher_reqtfm(req);
+	struct ccp_ctx *ctx = crypto_skcipher_ctx(tfm);
+	struct ccp_aes_req_ctx *rctx = skcipher_request_ctx(req);
 	struct scatterlist *iv_sg = NULL;
 	unsigned int iv_len = 0;
 	int ret;
@@ -77,14 +77,14 @@ static int ccp_aes_crypt(struct ablkcipher_request *req, bool encrypt)
 
 	if (((ctx->u.aes.mode == CCP_AES_MODE_ECB) ||
 	     (ctx->u.aes.mode == CCP_AES_MODE_CBC)) &&
-	    (req->nbytes & (AES_BLOCK_SIZE - 1)))
+	    (req->cryptlen & (AES_BLOCK_SIZE - 1)))
 		return -EINVAL;
 
 	if (ctx->u.aes.mode != CCP_AES_MODE_ECB) {
-		if (!req->info)
+		if (!req->iv)
 			return -EINVAL;
 
-		memcpy(rctx->iv, req->info, AES_BLOCK_SIZE);
+		memcpy(rctx->iv, req->iv, AES_BLOCK_SIZE);
 		iv_sg = &rctx->iv_sg;
 		iv_len = AES_BLOCK_SIZE;
 		sg_init_one(iv_sg, rctx->iv, iv_len);
@@ -102,7 +102,7 @@ static int ccp_aes_crypt(struct ablkcipher_request *req, bool encrypt)
 	rctx->cmd.u.aes.iv = iv_sg;
 	rctx->cmd.u.aes.iv_len = iv_len;
 	rctx->cmd.u.aes.src = req->src;
-	rctx->cmd.u.aes.src_len = req->nbytes;
+	rctx->cmd.u.aes.src_len = req->cryptlen;
 	rctx->cmd.u.aes.dst = req->dst;
 
 	ret = ccp_crypto_enqueue_request(&req->base, &rctx->cmd);
@@ -110,48 +110,44 @@ static int ccp_aes_crypt(struct ablkcipher_request *req, bool encrypt)
 	return ret;
 }
 
-static int ccp_aes_encrypt(struct ablkcipher_request *req)
+static int ccp_aes_encrypt(struct skcipher_request *req)
 {
 	return ccp_aes_crypt(req, true);
 }
 
-static int ccp_aes_decrypt(struct ablkcipher_request *req)
+static int ccp_aes_decrypt(struct skcipher_request *req)
 {
 	return ccp_aes_crypt(req, false);
 }
 
-static int ccp_aes_cra_init(struct crypto_tfm *tfm)
+static int ccp_aes_init_tfm(struct crypto_skcipher *tfm)
 {
-	struct ccp_ctx *ctx = crypto_tfm_ctx(tfm);
+	struct ccp_ctx *ctx = crypto_skcipher_ctx(tfm);
 
 	ctx->complete = ccp_aes_complete;
 	ctx->u.aes.key_len = 0;
 
-	tfm->crt_ablkcipher.reqsize = sizeof(struct ccp_aes_req_ctx);
+	crypto_skcipher_set_reqsize(tfm, sizeof(struct ccp_aes_req_ctx));
 
 	return 0;
 }
 
-static void ccp_aes_cra_exit(struct crypto_tfm *tfm)
-{
-}
-
 static int ccp_aes_rfc3686_complete(struct crypto_async_request *async_req,
 				    int ret)
 {
-	struct ablkcipher_request *req = ablkcipher_request_cast(async_req);
-	struct ccp_aes_req_ctx *rctx = ablkcipher_request_ctx(req);
+	struct skcipher_request *req = skcipher_request_cast(async_req);
+	struct ccp_aes_req_ctx *rctx = skcipher_request_ctx(req);
 
 	/* Restore the original pointer */
-	req->info = rctx->rfc3686_info;
+	req->iv = rctx->rfc3686_info;
 
 	return ccp_aes_complete(async_req, ret);
 }
 
-static int ccp_aes_rfc3686_setkey(struct crypto_ablkcipher *tfm, const u8 *key,
+static int ccp_aes_rfc3686_setkey(struct crypto_skcipher *tfm, const u8 *key,
 				  unsigned int key_len)
 {
-	struct ccp_ctx *ctx = crypto_tfm_ctx(crypto_ablkcipher_tfm(tfm));
+	struct ccp_ctx *ctx = crypto_skcipher_ctx(tfm);
 
 	if (key_len < CTR_RFC3686_NONCE_SIZE)
 		return -EINVAL;
@@ -162,10 +158,11 @@ static int ccp_aes_rfc3686_setkey(struct crypto_ablkcipher *tfm, const u8 *key,
 	return ccp_aes_setkey(tfm, key, key_len);
 }
 
-static int ccp_aes_rfc3686_crypt(struct ablkcipher_request *req, bool encrypt)
+static int ccp_aes_rfc3686_crypt(struct skcipher_request *req, bool encrypt)
 {
-	struct ccp_ctx *ctx = crypto_tfm_ctx(req->base.tfm);
-	struct ccp_aes_req_ctx *rctx = ablkcipher_request_ctx(req);
+	struct crypto_skcipher *tfm = crypto_skcipher_reqtfm(req);
+	struct ccp_ctx *ctx = crypto_skcipher_ctx(tfm);
+	struct ccp_aes_req_ctx *rctx = skcipher_request_ctx(req);
 	u8 *iv;
 
 	/* Initialize the CTR block */
@@ -173,84 +170,72 @@ static int ccp_aes_rfc3686_crypt(struct ablkcipher_request *req, bool encrypt)
 	memcpy(iv, ctx->u.aes.nonce, CTR_RFC3686_NONCE_SIZE);
 
 	iv += CTR_RFC3686_NONCE_SIZE;
-	memcpy(iv, req->info, CTR_RFC3686_IV_SIZE);
+	memcpy(iv, req->iv, CTR_RFC3686_IV_SIZE);
 
 	iv += CTR_RFC3686_IV_SIZE;
 	*(__be32 *)iv = cpu_to_be32(1);
 
 	/* Point to the new IV */
-	rctx->rfc3686_info = req->info;
-	req->info = rctx->rfc3686_iv;
+	rctx->rfc3686_info = req->iv;
+	req->iv = rctx->rfc3686_iv;
 
 	return ccp_aes_crypt(req, encrypt);
 }
 
-static int ccp_aes_rfc3686_encrypt(struct ablkcipher_request *req)
+static int ccp_aes_rfc3686_encrypt(struct skcipher_request *req)
 {
 	return ccp_aes_rfc3686_crypt(req, true);
 }
 
-static int ccp_aes_rfc3686_decrypt(struct ablkcipher_request *req)
+static int ccp_aes_rfc3686_decrypt(struct skcipher_request *req)
 {
 	return ccp_aes_rfc3686_crypt(req, false);
 }
 
-static int ccp_aes_rfc3686_cra_init(struct crypto_tfm *tfm)
+static int ccp_aes_rfc3686_init_tfm(struct crypto_skcipher *tfm)
 {
-	struct ccp_ctx *ctx = crypto_tfm_ctx(tfm);
+	struct ccp_ctx *ctx = crypto_skcipher_ctx(tfm);
 
 	ctx->complete = ccp_aes_rfc3686_complete;
 	ctx->u.aes.key_len = 0;
 
-	tfm->crt_ablkcipher.reqsize = sizeof(struct ccp_aes_req_ctx);
+	crypto_skcipher_set_reqsize(tfm, sizeof(struct ccp_aes_req_ctx));
 
 	return 0;
 }
 
-static void ccp_aes_rfc3686_cra_exit(struct crypto_tfm *tfm)
-{
-}
-
-static struct crypto_alg ccp_aes_defaults = {
-	.cra_flags	= CRYPTO_ALG_TYPE_ABLKCIPHER |
-			  CRYPTO_ALG_ASYNC |
-			  CRYPTO_ALG_KERN_DRIVER_ONLY |
-			  CRYPTO_ALG_NEED_FALLBACK,
-	.cra_blocksize	= AES_BLOCK_SIZE,
-	.cra_ctxsize	= sizeof(struct ccp_ctx),
-	.cra_priority	= CCP_CRA_PRIORITY,
-	.cra_type	= &crypto_ablkcipher_type,
-	.cra_init	= ccp_aes_cra_init,
-	.cra_exit	= ccp_aes_cra_exit,
-	.cra_module	= THIS_MODULE,
-	.cra_ablkcipher	= {
-		.setkey		= ccp_aes_setkey,
-		.encrypt	= ccp_aes_encrypt,
-		.decrypt	= ccp_aes_decrypt,
-		.min_keysize	= AES_MIN_KEY_SIZE,
-		.max_keysize	= AES_MAX_KEY_SIZE,
-	},
+static const struct skcipher_alg ccp_aes_defaults = {
+	.setkey			= ccp_aes_setkey,
+	.encrypt		= ccp_aes_encrypt,
+	.decrypt		= ccp_aes_decrypt,
+	.min_keysize		= AES_MIN_KEY_SIZE,
+	.max_keysize		= AES_MAX_KEY_SIZE,
+	.init			= ccp_aes_init_tfm,
+
+	.base.cra_flags		= CRYPTO_ALG_ASYNC |
+				  CRYPTO_ALG_KERN_DRIVER_ONLY |
+				  CRYPTO_ALG_NEED_FALLBACK,
+	.base.cra_blocksize	= AES_BLOCK_SIZE,
+	.base.cra_ctxsize	= sizeof(struct ccp_ctx),
+	.base.cra_priority	= CCP_CRA_PRIORITY,
+	.base.cra_module	= THIS_MODULE,
 };
 
-static struct crypto_alg ccp_aes_rfc3686_defaults = {
-	.cra_flags	= CRYPTO_ALG_TYPE_ABLKCIPHER |
-			   CRYPTO_ALG_ASYNC |
-			   CRYPTO_ALG_KERN_DRIVER_ONLY |
-			   CRYPTO_ALG_NEED_FALLBACK,
-	.cra_blocksize	= CTR_RFC3686_BLOCK_SIZE,
-	.cra_ctxsize	= sizeof(struct ccp_ctx),
-	.cra_priority	= CCP_CRA_PRIORITY,
-	.cra_type	= &crypto_ablkcipher_type,
-	.cra_init	= ccp_aes_rfc3686_cra_init,
-	.cra_exit	= ccp_aes_rfc3686_cra_exit,
-	.cra_module	= THIS_MODULE,
-	.cra_ablkcipher	= {
-		.setkey		= ccp_aes_rfc3686_setkey,
-		.encrypt	= ccp_aes_rfc3686_encrypt,
-		.decrypt	= ccp_aes_rfc3686_decrypt,
-		.min_keysize	= AES_MIN_KEY_SIZE + CTR_RFC3686_NONCE_SIZE,
-		.max_keysize	= AES_MAX_KEY_SIZE + CTR_RFC3686_NONCE_SIZE,
-	},
+static const struct skcipher_alg ccp_aes_rfc3686_defaults = {
+	.setkey			= ccp_aes_rfc3686_setkey,
+	.encrypt		= ccp_aes_rfc3686_encrypt,
+	.decrypt		= ccp_aes_rfc3686_decrypt,
+	.min_keysize		= AES_MIN_KEY_SIZE + CTR_RFC3686_NONCE_SIZE,
+	.max_keysize		= AES_MAX_KEY_SIZE + CTR_RFC3686_NONCE_SIZE,
+	.init			= ccp_aes_rfc3686_init_tfm,
+
+	.base.cra_flags		= CRYPTO_ALG_ASYNC |
+				  CRYPTO_ALG_KERN_DRIVER_ONLY |
+				  CRYPTO_ALG_NEED_FALLBACK,
+	.base.cra_blocksize	= CTR_RFC3686_BLOCK_SIZE,
+	.base.cra_ctxsize	= sizeof(struct ccp_ctx),
+	.base.cra_priority	= CCP_CRA_PRIORITY,
+	.base.cra_module	= THIS_MODULE,
 };
 
 struct ccp_aes_def {
@@ -260,7 +245,7 @@ struct ccp_aes_def {
 	const char *driver_name;
 	unsigned int blocksize;
 	unsigned int ivsize;
-	struct crypto_alg *alg_defaults;
+	const struct skcipher_alg *alg_defaults;
 };
 
 static struct ccp_aes_def aes_algs[] = {
@@ -323,8 +308,8 @@ static struct ccp_aes_def aes_algs[] = {
 static int ccp_register_aes_alg(struct list_head *head,
 				const struct ccp_aes_def *def)
 {
-	struct ccp_crypto_ablkcipher_alg *ccp_alg;
-	struct crypto_alg *alg;
+	struct ccp_crypto_skcipher_alg *ccp_alg;
+	struct skcipher_alg *alg;
 	int ret;
 
 	ccp_alg = kzalloc(sizeof(*ccp_alg), GFP_KERNEL);
@@ -338,16 +323,16 @@ static int ccp_register_aes_alg(struct list_head *head,
 	/* Copy the defaults and override as necessary */
 	alg = &ccp_alg->alg;
 	*alg = *def->alg_defaults;
-	snprintf(alg->cra_name, CRYPTO_MAX_ALG_NAME, "%s", def->name);
-	snprintf(alg->cra_driver_name, CRYPTO_MAX_ALG_NAME, "%s",
+	snprintf(alg->base.cra_name, CRYPTO_MAX_ALG_NAME, "%s", def->name);
+	snprintf(alg->base.cra_driver_name, CRYPTO_MAX_ALG_NAME, "%s",
 		 def->driver_name);
-	alg->cra_blocksize = def->blocksize;
-	alg->cra_ablkcipher.ivsize = def->ivsize;
+	alg->base.cra_blocksize = def->blocksize;
+	alg->ivsize = def->ivsize;
 
-	ret = crypto_register_alg(alg);
+	ret = crypto_register_skcipher(alg);
 	if (ret) {
-		pr_err("%s ablkcipher algorithm registration error (%d)\n",
-		       alg->cra_name, ret);
+		pr_err("%s skcipher algorithm registration error (%d)\n",
+		       alg->base.cra_name, ret);
 		kfree(ccp_alg);
 		return ret;
 	}
diff --git a/drivers/crypto/ccp/ccp-crypto-des3.c b/drivers/crypto/ccp/ccp-crypto-des3.c
index d2c49b2f0323..9c129defdb50 100644
--- a/drivers/crypto/ccp/ccp-crypto-des3.c
+++ b/drivers/crypto/ccp/ccp-crypto-des3.c
@@ -20,28 +20,27 @@
 
 static int ccp_des3_complete(struct crypto_async_request *async_req, int ret)
 {
-	struct ablkcipher_request *req = ablkcipher_request_cast(async_req);
+	struct skcipher_request *req = skcipher_request_cast(async_req);
 	struct ccp_ctx *ctx = crypto_tfm_ctx(req->base.tfm);
-	struct ccp_des3_req_ctx *rctx = ablkcipher_request_ctx(req);
+	struct ccp_des3_req_ctx *rctx = skcipher_request_ctx(req);
 
 	if (ret)
 		return ret;
 
 	if (ctx->u.des3.mode != CCP_DES3_MODE_ECB)
-		memcpy(req->info, rctx->iv, DES3_EDE_BLOCK_SIZE);
+		memcpy(req->iv, rctx->iv, DES3_EDE_BLOCK_SIZE);
 
 	return 0;
 }
 
-static int ccp_des3_setkey(struct crypto_ablkcipher *tfm, const u8 *key,
+static int ccp_des3_setkey(struct crypto_skcipher *tfm, const u8 *key,
 		unsigned int key_len)
 {
-	struct ccp_ctx *ctx = crypto_tfm_ctx(crypto_ablkcipher_tfm(tfm));
-	struct ccp_crypto_ablkcipher_alg *alg =
-		ccp_crypto_ablkcipher_alg(crypto_ablkcipher_tfm(tfm));
+	struct ccp_crypto_skcipher_alg *alg = ccp_crypto_skcipher_alg(tfm);
+	struct ccp_ctx *ctx = crypto_skcipher_ctx(tfm);
 	int err;
 
-	err = verify_ablkcipher_des3_key(tfm, key);
+	err = verify_skcipher_des3_key(tfm, key);
 	if (err)
 		return err;
 
@@ -58,10 +57,11 @@ static int ccp_des3_setkey(struct crypto_ablkcipher *tfm, const u8 *key,
 	return 0;
 }
 
-static int ccp_des3_crypt(struct ablkcipher_request *req, bool encrypt)
+static int ccp_des3_crypt(struct skcipher_request *req, bool encrypt)
 {
-	struct ccp_ctx *ctx = crypto_tfm_ctx(req->base.tfm);
-	struct ccp_des3_req_ctx *rctx = ablkcipher_request_ctx(req);
+	struct crypto_skcipher *tfm = crypto_skcipher_reqtfm(req);
+	struct ccp_ctx *ctx = crypto_skcipher_ctx(tfm);
+	struct ccp_des3_req_ctx *rctx = skcipher_request_ctx(req);
 	struct scatterlist *iv_sg = NULL;
 	unsigned int iv_len = 0;
 	int ret;
@@ -71,14 +71,14 @@ static int ccp_des3_crypt(struct ablkcipher_request *req, bool encrypt)
 
 	if (((ctx->u.des3.mode == CCP_DES3_MODE_ECB) ||
 	     (ctx->u.des3.mode == CCP_DES3_MODE_CBC)) &&
-	    (req->nbytes & (DES3_EDE_BLOCK_SIZE - 1)))
+	    (req->cryptlen & (DES3_EDE_BLOCK_SIZE - 1)))
 		return -EINVAL;
 
 	if (ctx->u.des3.mode != CCP_DES3_MODE_ECB) {
-		if (!req->info)
+		if (!req->iv)
 			return -EINVAL;
 
-		memcpy(rctx->iv, req->info, DES3_EDE_BLOCK_SIZE);
+		memcpy(rctx->iv, req->iv, DES3_EDE_BLOCK_SIZE);
 		iv_sg = &rctx->iv_sg;
 		iv_len = DES3_EDE_BLOCK_SIZE;
 		sg_init_one(iv_sg, rctx->iv, iv_len);
@@ -97,7 +97,7 @@ static int ccp_des3_crypt(struct ablkcipher_request *req, bool encrypt)
 	rctx->cmd.u.des3.iv = iv_sg;
 	rctx->cmd.u.des3.iv_len = iv_len;
 	rctx->cmd.u.des3.src = req->src;
-	rctx->cmd.u.des3.src_len = req->nbytes;
+	rctx->cmd.u.des3.src_len = req->cryptlen;
 	rctx->cmd.u.des3.dst = req->dst;
 
 	ret = ccp_crypto_enqueue_request(&req->base, &rctx->cmd);
@@ -105,51 +105,43 @@ static int ccp_des3_crypt(struct ablkcipher_request *req, bool encrypt)
 	return ret;
 }
 
-static int ccp_des3_encrypt(struct ablkcipher_request *req)
+static int ccp_des3_encrypt(struct skcipher_request *req)
 {
 	return ccp_des3_crypt(req, true);
 }
 
-static int ccp_des3_decrypt(struct ablkcipher_request *req)
+static int ccp_des3_decrypt(struct skcipher_request *req)
 {
 	return ccp_des3_crypt(req, false);
 }
 
-static int ccp_des3_cra_init(struct crypto_tfm *tfm)
+static int ccp_des3_init_tfm(struct crypto_skcipher *tfm)
 {
-	struct ccp_ctx *ctx = crypto_tfm_ctx(tfm);
+	struct ccp_ctx *ctx = crypto_skcipher_ctx(tfm);
 
 	ctx->complete = ccp_des3_complete;
 	ctx->u.des3.key_len = 0;
 
-	tfm->crt_ablkcipher.reqsize = sizeof(struct ccp_des3_req_ctx);
+	crypto_skcipher_set_reqsize(tfm, sizeof(struct ccp_des3_req_ctx));
 
 	return 0;
 }
 
-static void ccp_des3_cra_exit(struct crypto_tfm *tfm)
-{
-}
-
-static struct crypto_alg ccp_des3_defaults = {
-	.cra_flags	= CRYPTO_ALG_TYPE_ABLKCIPHER |
-		CRYPTO_ALG_ASYNC |
-		CRYPTO_ALG_KERN_DRIVER_ONLY |
-		CRYPTO_ALG_NEED_FALLBACK,
-	.cra_blocksize	= DES3_EDE_BLOCK_SIZE,
-	.cra_ctxsize	= sizeof(struct ccp_ctx),
-	.cra_priority	= CCP_CRA_PRIORITY,
-	.cra_type	= &crypto_ablkcipher_type,
-	.cra_init	= ccp_des3_cra_init,
-	.cra_exit	= ccp_des3_cra_exit,
-	.cra_module	= THIS_MODULE,
-	.cra_ablkcipher	= {
-		.setkey		= ccp_des3_setkey,
-		.encrypt	= ccp_des3_encrypt,
-		.decrypt	= ccp_des3_decrypt,
-		.min_keysize	= DES3_EDE_KEY_SIZE,
-		.max_keysize	= DES3_EDE_KEY_SIZE,
-	},
+static const struct skcipher_alg ccp_des3_defaults = {
+	.setkey			= ccp_des3_setkey,
+	.encrypt		= ccp_des3_encrypt,
+	.decrypt		= ccp_des3_decrypt,
+	.min_keysize		= DES3_EDE_KEY_SIZE,
+	.max_keysize		= DES3_EDE_KEY_SIZE,
+	.init			= ccp_des3_init_tfm,
+
+	.base.cra_flags		= CRYPTO_ALG_ASYNC |
+				  CRYPTO_ALG_KERN_DRIVER_ONLY |
+				  CRYPTO_ALG_NEED_FALLBACK,
+	.base.cra_blocksize	= DES3_EDE_BLOCK_SIZE,
+	.base.cra_ctxsize	= sizeof(struct ccp_ctx),
+	.base.cra_priority	= CCP_CRA_PRIORITY,
+	.base.cra_module	= THIS_MODULE,
 };
 
 struct ccp_des3_def {
@@ -159,10 +151,10 @@ struct ccp_des3_def {
 	const char *driver_name;
 	unsigned int blocksize;
 	unsigned int ivsize;
-	struct crypto_alg *alg_defaults;
+	const struct skcipher_alg *alg_defaults;
 };
 
-static struct ccp_des3_def des3_algs[] = {
+static const struct ccp_des3_def des3_algs[] = {
 	{
 		.mode		= CCP_DES3_MODE_ECB,
 		.version	= CCP_VERSION(5, 0),
@@ -186,8 +178,8 @@ static struct ccp_des3_def des3_algs[] = {
 static int ccp_register_des3_alg(struct list_head *head,
 				 const struct ccp_des3_def *def)
 {
-	struct ccp_crypto_ablkcipher_alg *ccp_alg;
-	struct crypto_alg *alg;
+	struct ccp_crypto_skcipher_alg *ccp_alg;
+	struct skcipher_alg *alg;
 	int ret;
 
 	ccp_alg = kzalloc(sizeof(*ccp_alg), GFP_KERNEL);
@@ -201,16 +193,16 @@ static int ccp_register_des3_alg(struct list_head *head,
 	/* Copy the defaults and override as necessary */
 	alg = &ccp_alg->alg;
 	*alg = *def->alg_defaults;
-	snprintf(alg->cra_name, CRYPTO_MAX_ALG_NAME, "%s", def->name);
-	snprintf(alg->cra_driver_name, CRYPTO_MAX_ALG_NAME, "%s",
+	snprintf(alg->base.cra_name, CRYPTO_MAX_ALG_NAME, "%s", def->name);
+	snprintf(alg->base.cra_driver_name, CRYPTO_MAX_ALG_NAME, "%s",
 			def->driver_name);
-	alg->cra_blocksize = def->blocksize;
-	alg->cra_ablkcipher.ivsize = def->ivsize;
+	alg->base.cra_blocksize = def->blocksize;
+	alg->ivsize = def->ivsize;
 
-	ret = crypto_register_alg(alg);
+	ret = crypto_register_skcipher(alg);
 	if (ret) {
-		pr_err("%s ablkcipher algorithm registration error (%d)\n",
-				alg->cra_name, ret);
+		pr_err("%s skcipher algorithm registration error (%d)\n",
+				alg->base.cra_name, ret);
 		kfree(ccp_alg);
 		return ret;
 	}
diff --git a/drivers/crypto/ccp/ccp-crypto-main.c b/drivers/crypto/ccp/ccp-crypto-main.c
index 8ee4cb45a3f3..88275b4867ea 100644
--- a/drivers/crypto/ccp/ccp-crypto-main.c
+++ b/drivers/crypto/ccp/ccp-crypto-main.c
@@ -41,7 +41,7 @@ MODULE_PARM_DESC(rsa_disable, "Disable use of RSA - any non-zero value");
 
 /* List heads for the supported algorithms */
 static LIST_HEAD(hash_algs);
-static LIST_HEAD(cipher_algs);
+static LIST_HEAD(skcipher_algs);
 static LIST_HEAD(aead_algs);
 static LIST_HEAD(akcipher_algs);
 
@@ -330,7 +330,7 @@ static int ccp_register_algs(void)
 	int ret;
 
 	if (!aes_disable) {
-		ret = ccp_register_aes_algs(&cipher_algs);
+		ret = ccp_register_aes_algs(&skcipher_algs);
 		if (ret)
 			return ret;
 
@@ -338,7 +338,7 @@ static int ccp_register_algs(void)
 		if (ret)
 			return ret;
 
-		ret = ccp_register_aes_xts_algs(&cipher_algs);
+		ret = ccp_register_aes_xts_algs(&skcipher_algs);
 		if (ret)
 			return ret;
 
@@ -348,7 +348,7 @@ static int ccp_register_algs(void)
 	}
 
 	if (!des3_disable) {
-		ret = ccp_register_des3_algs(&cipher_algs);
+		ret = ccp_register_des3_algs(&skcipher_algs);
 		if (ret)
 			return ret;
 	}
@@ -371,7 +371,7 @@ static int ccp_register_algs(void)
 static void ccp_unregister_algs(void)
 {
 	struct ccp_crypto_ahash_alg *ahash_alg, *ahash_tmp;
-	struct ccp_crypto_ablkcipher_alg *ablk_alg, *ablk_tmp;
+	struct ccp_crypto_skcipher_alg *ablk_alg, *ablk_tmp;
 	struct ccp_crypto_aead *aead_alg, *aead_tmp;
 	struct ccp_crypto_akcipher_alg *akc_alg, *akc_tmp;
 
@@ -381,8 +381,8 @@ static void ccp_unregister_algs(void)
 		kfree(ahash_alg);
 	}
 
-	list_for_each_entry_safe(ablk_alg, ablk_tmp, &cipher_algs, entry) {
-		crypto_unregister_alg(&ablk_alg->alg);
+	list_for_each_entry_safe(ablk_alg, ablk_tmp, &skcipher_algs, entry) {
+		crypto_unregister_skcipher(&ablk_alg->alg);
 		list_del(&ablk_alg->entry);
 		kfree(ablk_alg);
 	}
diff --git a/drivers/crypto/ccp/ccp-crypto.h b/drivers/crypto/ccp/ccp-crypto.h
index 9015b5da6ba3..90a009e6b5c1 100644
--- a/drivers/crypto/ccp/ccp-crypto.h
+++ b/drivers/crypto/ccp/ccp-crypto.h
@@ -21,6 +21,7 @@
 #include <crypto/hash.h>
 #include <crypto/sha.h>
 #include <crypto/akcipher.h>
+#include <crypto/skcipher.h>
 #include <crypto/internal/rsa.h>
 
 /* We want the module name in front of our messages */
@@ -31,12 +32,12 @@
 
 #define CCP_CRA_PRIORITY	300
 
-struct ccp_crypto_ablkcipher_alg {
+struct ccp_crypto_skcipher_alg {
 	struct list_head entry;
 
 	u32 mode;
 
-	struct crypto_alg alg;
+	struct skcipher_alg alg;
 };
 
 struct ccp_crypto_aead {
@@ -66,12 +67,12 @@ struct ccp_crypto_akcipher_alg {
 	struct akcipher_alg alg;
 };
 
-static inline struct ccp_crypto_ablkcipher_alg *
-	ccp_crypto_ablkcipher_alg(struct crypto_tfm *tfm)
+static inline struct ccp_crypto_skcipher_alg *
+	ccp_crypto_skcipher_alg(struct crypto_skcipher *tfm)
 {
-	struct crypto_alg *alg = tfm->__crt_alg;
+	struct skcipher_alg *alg = crypto_skcipher_alg(tfm);
 
-	return container_of(alg, struct ccp_crypto_ablkcipher_alg, alg);
+	return container_of(alg, struct ccp_crypto_skcipher_alg, alg);
 }
 
 static inline struct ccp_crypto_ahash_alg *
-- 
2.20.1


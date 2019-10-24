Return-Path: <SRS0=tzqc=YR=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3C4EECA9EBB
	for <linux-crypto@archiver.kernel.org>; Thu, 24 Oct 2019 13:24:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id F0BBA2084C
	for <linux-crypto@archiver.kernel.org>; Thu, 24 Oct 2019 13:24:14 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="K0HTc66R"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733101AbfJXNYO (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 24 Oct 2019 09:24:14 -0400
Received: from mail-wr1-f66.google.com ([209.85.221.66]:35401 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387516AbfJXNYO (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 24 Oct 2019 09:24:14 -0400
Received: by mail-wr1-f66.google.com with SMTP id l10so25653862wrb.2
        for <linux-crypto@vger.kernel.org>; Thu, 24 Oct 2019 06:24:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=KCy1T3O5xm/Iv0blzz4frawvkZXFTldGpWRPBR9LMG8=;
        b=K0HTc66RMFKKcblerbuFtxf3Z30TCZ43CUyiGNBSQcQnVCF90vSt/3xq0c2dbWR7Yr
         7RARN75sRzTwPSmYZiWKRTpPJ8qEhL/S8+DXjzd6SbNLBkINUkKQWd2qeKLUdq23vplb
         D4tk89yQhmYDKI1Ci+eZeBTn2lJ3hCORx/Q9CHG7kFmki8xj5NciC2T8D03c3ppFSFpC
         e7iE4aH/QpFCNsXgEC3A4hg52ir29eFaavoQHPC2Qx3X4qPOBAD/gKHb7ALx0cRixugN
         83qLtpCdd0H6jR2Cavh90oJPlwTMp4iH808wJ+SP86nCihzNdSe+QiDFdIxtWYFk0l4G
         W+qg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=KCy1T3O5xm/Iv0blzz4frawvkZXFTldGpWRPBR9LMG8=;
        b=tQYpvcPEY68o85Rt5JJ9h1g29Chf/5ICGzJtJFxXk2nvpzt5J8XKV5fX8gMzHlvX3H
         870BR0M5OgOM1Qw8fPJzpuUn9nsqZxcFwUvmAIQVUE7PCKVCzlHMMh+0mONcVZPq82Oc
         ZD5dplgNXKavTGEgZbHITsRjD32llW1UL0Czpm1joN1jfxpea2sEDhYiwEHUirbCfkES
         1nDA2XtyK7C0HpYiza2YvRDK/2/kSsGQWAHyMTaqNIMFlbnegF53VfyO7zZfqHkQGJVV
         cpIqSU1WxHDKY3FG5QK4K6fzM1zyFjAX5rvjMc7LKOyOC43s55qLHUldH06TaNcs8LWp
         xFKA==
X-Gm-Message-State: APjAAAWvIZ7/beZFjaOsoqttvly7ovxvS57sTM8cdxW2gLDanZGwt+PL
        2TKUFFqTEHH4OumutvytJL9E+U3Af6otm4or
X-Google-Smtp-Source: APXvYqxT0Ljlgl+6s2g7lIyUfXJl5ooLVGuStQMmF8zl6k6A9mFqY80bk5FLreLkTAZitD7xH58i4g==
X-Received: by 2002:adf:fe90:: with SMTP id l16mr3814992wrr.81.1571923450374;
        Thu, 24 Oct 2019 06:24:10 -0700 (PDT)
Received: from localhost.localdomain (laubervilliers-657-1-83-120.w92-154.abo.wanadoo.fr. [92.154.90.120])
        by smtp.gmail.com with ESMTPSA id e3sm2346310wme.36.2019.10.24.06.24.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 24 Oct 2019 06:24:09 -0700 (PDT)
From:   Ard Biesheuvel <ard.biesheuvel@linaro.org>
To:     linux-crypto@vger.kernel.org
Cc:     Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Biggers <ebiggers@google.com>,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH v2 12/27] crypto: cavium/cpt - switch to skcipher API
Date:   Thu, 24 Oct 2019 15:23:30 +0200
Message-Id: <20191024132345.5236-13-ard.biesheuvel@linaro.org>
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

Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
---
 drivers/crypto/cavium/cpt/cptvf_algs.c | 292 +++++++++-----------
 1 file changed, 134 insertions(+), 158 deletions(-)

diff --git a/drivers/crypto/cavium/cpt/cptvf_algs.c b/drivers/crypto/cavium/cpt/cptvf_algs.c
index 596ce28b957d..1ad66677d88e 100644
--- a/drivers/crypto/cavium/cpt/cptvf_algs.c
+++ b/drivers/crypto/cavium/cpt/cptvf_algs.c
@@ -92,15 +92,15 @@ static inline void update_output_data(struct cpt_request_info *req_info,
 	}
 }
 
-static inline u32 create_ctx_hdr(struct ablkcipher_request *req, u32 enc,
+static inline u32 create_ctx_hdr(struct skcipher_request *req, u32 enc,
 				 u32 *argcnt)
 {
-	struct crypto_ablkcipher *tfm = crypto_ablkcipher_reqtfm(req);
-	struct cvm_enc_ctx *ctx = crypto_ablkcipher_ctx(tfm);
-	struct cvm_req_ctx *rctx = ablkcipher_request_ctx(req);
+	struct crypto_skcipher *tfm = crypto_skcipher_reqtfm(req);
+	struct cvm_enc_ctx *ctx = crypto_skcipher_ctx(tfm);
+	struct cvm_req_ctx *rctx = skcipher_request_ctx(req);
 	struct fc_context *fctx = &rctx->fctx;
 	u64 *offset_control = &rctx->control_word;
-	u32 enc_iv_len = crypto_ablkcipher_ivsize(tfm);
+	u32 enc_iv_len = crypto_skcipher_ivsize(tfm);
 	struct cpt_request_info *req_info = &rctx->cpt_req;
 	u64 *ctrl_flags = NULL;
 
@@ -115,7 +115,7 @@ static inline u32 create_ctx_hdr(struct ablkcipher_request *req, u32 enc,
 	else
 		req_info->req.opcode.s.minor = 3;
 
-	req_info->req.param1 = req->nbytes; /* Encryption Data length */
+	req_info->req.param1 = req->cryptlen; /* Encryption Data length */
 	req_info->req.param2 = 0; /*Auth data length */
 
 	fctx->enc.enc_ctrl.e.enc_cipher = ctx->cipher_type;
@@ -147,32 +147,32 @@ static inline u32 create_ctx_hdr(struct ablkcipher_request *req, u32 enc,
 	return 0;
 }
 
-static inline u32 create_input_list(struct ablkcipher_request  *req, u32 enc,
+static inline u32 create_input_list(struct skcipher_request  *req, u32 enc,
 				    u32 enc_iv_len)
 {
-	struct cvm_req_ctx *rctx = ablkcipher_request_ctx(req);
+	struct cvm_req_ctx *rctx = skcipher_request_ctx(req);
 	struct cpt_request_info *req_info = &rctx->cpt_req;
 	u32 argcnt =  0;
 
 	create_ctx_hdr(req, enc, &argcnt);
-	update_input_iv(req_info, req->info, enc_iv_len, &argcnt);
-	update_input_data(req_info, req->src, req->nbytes, &argcnt);
+	update_input_iv(req_info, req->iv, enc_iv_len, &argcnt);
+	update_input_data(req_info, req->src, req->cryptlen, &argcnt);
 	req_info->incnt = argcnt;
 
 	return 0;
 }
 
-static inline void store_cb_info(struct ablkcipher_request *req,
+static inline void store_cb_info(struct skcipher_request *req,
 				 struct cpt_request_info *req_info)
 {
 	req_info->callback = (void *)cvm_callback;
 	req_info->callback_arg = (void *)&req->base;
 }
 
-static inline void create_output_list(struct ablkcipher_request *req,
+static inline void create_output_list(struct skcipher_request *req,
 				      u32 enc_iv_len)
 {
-	struct cvm_req_ctx *rctx = ablkcipher_request_ctx(req);
+	struct cvm_req_ctx *rctx = skcipher_request_ctx(req);
 	struct cpt_request_info *req_info = &rctx->cpt_req;
 	u32 argcnt = 0;
 
@@ -184,16 +184,16 @@ static inline void create_output_list(struct ablkcipher_request *req,
 	 * [ 16 Bytes/     [   Request Enc/Dec/ DATA Len AES CBC ]
 	 */
 	/* Reading IV information */
-	update_output_iv(req_info, req->info, enc_iv_len, &argcnt);
-	update_output_data(req_info, req->dst, req->nbytes, &argcnt);
+	update_output_iv(req_info, req->iv, enc_iv_len, &argcnt);
+	update_output_data(req_info, req->dst, req->cryptlen, &argcnt);
 	req_info->outcnt = argcnt;
 }
 
-static inline int cvm_enc_dec(struct ablkcipher_request *req, u32 enc)
+static inline int cvm_enc_dec(struct skcipher_request *req, u32 enc)
 {
-	struct crypto_ablkcipher *tfm = crypto_ablkcipher_reqtfm(req);
-	struct cvm_req_ctx *rctx = ablkcipher_request_ctx(req);
-	u32 enc_iv_len = crypto_ablkcipher_ivsize(tfm);
+	struct crypto_skcipher *tfm = crypto_skcipher_reqtfm(req);
+	struct cvm_req_ctx *rctx = skcipher_request_ctx(req);
+	u32 enc_iv_len = crypto_skcipher_ivsize(tfm);
 	struct fc_context *fctx = &rctx->fctx;
 	struct cpt_request_info *req_info = &rctx->cpt_req;
 	void *cdev = NULL;
@@ -217,20 +217,20 @@ static inline int cvm_enc_dec(struct ablkcipher_request *req, u32 enc)
 		return -EINPROGRESS;
 }
 
-static int cvm_encrypt(struct ablkcipher_request *req)
+static int cvm_encrypt(struct skcipher_request *req)
 {
 	return cvm_enc_dec(req, true);
 }
 
-static int cvm_decrypt(struct ablkcipher_request *req)
+static int cvm_decrypt(struct skcipher_request *req)
 {
 	return cvm_enc_dec(req, false);
 }
 
-static int cvm_xts_setkey(struct crypto_ablkcipher *cipher, const u8 *key,
+static int cvm_xts_setkey(struct crypto_skcipher *cipher, const u8 *key,
 		   u32 keylen)
 {
-	struct crypto_tfm *tfm = crypto_ablkcipher_tfm(cipher);
+	struct crypto_tfm *tfm = crypto_skcipher_tfm(cipher);
 	struct cvm_enc_ctx *ctx = crypto_tfm_ctx(tfm);
 	int err;
 	const u8 *key1 = key;
@@ -284,10 +284,10 @@ static int cvm_validate_keylen(struct cvm_enc_ctx *ctx, u32 keylen)
 	return -EINVAL;
 }
 
-static int cvm_setkey(struct crypto_ablkcipher *cipher, const u8 *key,
+static int cvm_setkey(struct crypto_skcipher *cipher, const u8 *key,
 		      u32 keylen, u8 cipher_type)
 {
-	struct crypto_tfm *tfm = crypto_ablkcipher_tfm(cipher);
+	struct crypto_tfm *tfm = crypto_skcipher_tfm(cipher);
 	struct cvm_enc_ctx *ctx = crypto_tfm_ctx(tfm);
 
 	ctx->cipher_type = cipher_type;
@@ -295,183 +295,159 @@ static int cvm_setkey(struct crypto_ablkcipher *cipher, const u8 *key,
 		memcpy(ctx->enc_key, key, keylen);
 		return 0;
 	} else {
-		crypto_ablkcipher_set_flags(cipher,
+		crypto_skcipher_set_flags(cipher,
 					    CRYPTO_TFM_RES_BAD_KEY_LEN);
 		return -EINVAL;
 	}
 }
 
-static int cvm_cbc_aes_setkey(struct crypto_ablkcipher *cipher, const u8 *key,
+static int cvm_cbc_aes_setkey(struct crypto_skcipher *cipher, const u8 *key,
 			      u32 keylen)
 {
 	return cvm_setkey(cipher, key, keylen, AES_CBC);
 }
 
-static int cvm_ecb_aes_setkey(struct crypto_ablkcipher *cipher, const u8 *key,
+static int cvm_ecb_aes_setkey(struct crypto_skcipher *cipher, const u8 *key,
 			      u32 keylen)
 {
 	return cvm_setkey(cipher, key, keylen, AES_ECB);
 }
 
-static int cvm_cfb_aes_setkey(struct crypto_ablkcipher *cipher, const u8 *key,
+static int cvm_cfb_aes_setkey(struct crypto_skcipher *cipher, const u8 *key,
 			      u32 keylen)
 {
 	return cvm_setkey(cipher, key, keylen, AES_CFB);
 }
 
-static int cvm_cbc_des3_setkey(struct crypto_ablkcipher *cipher, const u8 *key,
+static int cvm_cbc_des3_setkey(struct crypto_skcipher *cipher, const u8 *key,
 			       u32 keylen)
 {
-	return verify_ablkcipher_des3_key(cipher, key) ?:
+	return verify_skcipher_des3_key(cipher, key) ?:
 	       cvm_setkey(cipher, key, keylen, DES3_CBC);
 }
 
-static int cvm_ecb_des3_setkey(struct crypto_ablkcipher *cipher, const u8 *key,
+static int cvm_ecb_des3_setkey(struct crypto_skcipher *cipher, const u8 *key,
 			       u32 keylen)
 {
-	return verify_ablkcipher_des3_key(cipher, key) ?:
+	return verify_skcipher_des3_key(cipher, key) ?:
 	       cvm_setkey(cipher, key, keylen, DES3_ECB);
 }
 
-static int cvm_enc_dec_init(struct crypto_tfm *tfm)
+static int cvm_enc_dec_init(struct crypto_skcipher *tfm)
 {
-	tfm->crt_ablkcipher.reqsize = sizeof(struct cvm_req_ctx);
+	crypto_skcipher_set_reqsize(tfm, sizeof(struct cvm_req_ctx));
+
 	return 0;
 }
 
-static struct crypto_alg algs[] = { {
-	.cra_flags = CRYPTO_ALG_TYPE_ABLKCIPHER | CRYPTO_ALG_ASYNC,
-	.cra_blocksize = AES_BLOCK_SIZE,
-	.cra_ctxsize = sizeof(struct cvm_enc_ctx),
-	.cra_alignmask = 7,
-	.cra_priority = 4001,
-	.cra_name = "xts(aes)",
-	.cra_driver_name = "cavium-xts-aes",
-	.cra_type = &crypto_ablkcipher_type,
-	.cra_u = {
-		.ablkcipher = {
-			.ivsize = AES_BLOCK_SIZE,
-			.min_keysize = 2 * AES_MIN_KEY_SIZE,
-			.max_keysize = 2 * AES_MAX_KEY_SIZE,
-			.setkey = cvm_xts_setkey,
-			.encrypt = cvm_encrypt,
-			.decrypt = cvm_decrypt,
-		},
-	},
-	.cra_init = cvm_enc_dec_init,
-	.cra_module = THIS_MODULE,
+static struct skcipher_alg algs[] = { {
+	.base.cra_flags		= CRYPTO_ALG_ASYNC,
+	.base.cra_blocksize	= AES_BLOCK_SIZE,
+	.base.cra_ctxsize	= sizeof(struct cvm_enc_ctx),
+	.base.cra_alignmask	= 7,
+	.base.cra_priority	= 4001,
+	.base.cra_name		= "xts(aes)",
+	.base.cra_driver_name	= "cavium-xts-aes",
+	.base.cra_module	= THIS_MODULE,
+
+	.ivsize			= AES_BLOCK_SIZE,
+	.min_keysize		= 2 * AES_MIN_KEY_SIZE,
+	.max_keysize		= 2 * AES_MAX_KEY_SIZE,
+	.setkey			= cvm_xts_setkey,
+	.encrypt		= cvm_encrypt,
+	.decrypt		= cvm_decrypt,
+	.init			= cvm_enc_dec_init,
 }, {
-	.cra_flags = CRYPTO_ALG_TYPE_ABLKCIPHER | CRYPTO_ALG_ASYNC,
-	.cra_blocksize = AES_BLOCK_SIZE,
-	.cra_ctxsize = sizeof(struct cvm_enc_ctx),
-	.cra_alignmask = 7,
-	.cra_priority = 4001,
-	.cra_name = "cbc(aes)",
-	.cra_driver_name = "cavium-cbc-aes",
-	.cra_type = &crypto_ablkcipher_type,
-	.cra_u = {
-		.ablkcipher = {
-			.ivsize = AES_BLOCK_SIZE,
-			.min_keysize = AES_MIN_KEY_SIZE,
-			.max_keysize = AES_MAX_KEY_SIZE,
-			.setkey = cvm_cbc_aes_setkey,
-			.encrypt = cvm_encrypt,
-			.decrypt = cvm_decrypt,
-		},
-	},
-	.cra_init = cvm_enc_dec_init,
-	.cra_module = THIS_MODULE,
+	.base.cra_flags		= CRYPTO_ALG_ASYNC,
+	.base.cra_blocksize	= AES_BLOCK_SIZE,
+	.base.cra_ctxsize	= sizeof(struct cvm_enc_ctx),
+	.base.cra_alignmask	= 7,
+	.base.cra_priority	= 4001,
+	.base.cra_name		= "cbc(aes)",
+	.base.cra_driver_name	= "cavium-cbc-aes",
+	.base.cra_module	= THIS_MODULE,
+
+	.ivsize			= AES_BLOCK_SIZE,
+	.min_keysize		= AES_MIN_KEY_SIZE,
+	.max_keysize		= AES_MAX_KEY_SIZE,
+	.setkey			= cvm_cbc_aes_setkey,
+	.encrypt		= cvm_encrypt,
+	.decrypt		= cvm_decrypt,
+	.init			= cvm_enc_dec_init,
 }, {
-	.cra_flags = CRYPTO_ALG_TYPE_ABLKCIPHER | CRYPTO_ALG_ASYNC,
-	.cra_blocksize = AES_BLOCK_SIZE,
-	.cra_ctxsize = sizeof(struct cvm_enc_ctx),
-	.cra_alignmask = 7,
-	.cra_priority = 4001,
-	.cra_name = "ecb(aes)",
-	.cra_driver_name = "cavium-ecb-aes",
-	.cra_type = &crypto_ablkcipher_type,
-	.cra_u = {
-		.ablkcipher = {
-			.ivsize = AES_BLOCK_SIZE,
-			.min_keysize = AES_MIN_KEY_SIZE,
-			.max_keysize = AES_MAX_KEY_SIZE,
-			.setkey = cvm_ecb_aes_setkey,
-			.encrypt = cvm_encrypt,
-			.decrypt = cvm_decrypt,
-		},
-	},
-	.cra_init = cvm_enc_dec_init,
-	.cra_module = THIS_MODULE,
+	.base.cra_flags		= CRYPTO_ALG_ASYNC,
+	.base.cra_blocksize	= AES_BLOCK_SIZE,
+	.base.cra_ctxsize	= sizeof(struct cvm_enc_ctx),
+	.base.cra_alignmask	= 7,
+	.base.cra_priority	= 4001,
+	.base.cra_name		= "ecb(aes)",
+	.base.cra_driver_name	= "cavium-ecb-aes",
+	.base.cra_module	= THIS_MODULE,
+
+	.min_keysize		= AES_MIN_KEY_SIZE,
+	.max_keysize		= AES_MAX_KEY_SIZE,
+	.setkey			= cvm_ecb_aes_setkey,
+	.encrypt		= cvm_encrypt,
+	.decrypt		= cvm_decrypt,
+	.init			= cvm_enc_dec_init,
 }, {
-	.cra_flags = CRYPTO_ALG_TYPE_ABLKCIPHER | CRYPTO_ALG_ASYNC,
-	.cra_blocksize = AES_BLOCK_SIZE,
-	.cra_ctxsize = sizeof(struct cvm_enc_ctx),
-	.cra_alignmask = 7,
-	.cra_priority = 4001,
-	.cra_name = "cfb(aes)",
-	.cra_driver_name = "cavium-cfb-aes",
-	.cra_type = &crypto_ablkcipher_type,
-	.cra_u = {
-		.ablkcipher = {
-			.ivsize = AES_BLOCK_SIZE,
-			.min_keysize = AES_MIN_KEY_SIZE,
-			.max_keysize = AES_MAX_KEY_SIZE,
-			.setkey = cvm_cfb_aes_setkey,
-			.encrypt = cvm_encrypt,
-			.decrypt = cvm_decrypt,
-		},
-	},
-	.cra_init = cvm_enc_dec_init,
-	.cra_module = THIS_MODULE,
+	.base.cra_flags		= CRYPTO_ALG_ASYNC,
+	.base.cra_blocksize	= AES_BLOCK_SIZE,
+	.base.cra_ctxsize	= sizeof(struct cvm_enc_ctx),
+	.base.cra_alignmask	= 7,
+	.base.cra_priority	= 4001,
+	.base.cra_name		= "cfb(aes)",
+	.base.cra_driver_name	= "cavium-cfb-aes",
+	.base.cra_module	= THIS_MODULE,
+
+	.ivsize			= AES_BLOCK_SIZE,
+	.min_keysize		= AES_MIN_KEY_SIZE,
+	.max_keysize		= AES_MAX_KEY_SIZE,
+	.setkey			= cvm_cfb_aes_setkey,
+	.encrypt		= cvm_encrypt,
+	.decrypt		= cvm_decrypt,
+	.init			= cvm_enc_dec_init,
 }, {
-	.cra_flags = CRYPTO_ALG_TYPE_ABLKCIPHER | CRYPTO_ALG_ASYNC,
-	.cra_blocksize = DES3_EDE_BLOCK_SIZE,
-	.cra_ctxsize = sizeof(struct cvm_des3_ctx),
-	.cra_alignmask = 7,
-	.cra_priority = 4001,
-	.cra_name = "cbc(des3_ede)",
-	.cra_driver_name = "cavium-cbc-des3_ede",
-	.cra_type = &crypto_ablkcipher_type,
-	.cra_u = {
-		.ablkcipher = {
-			.min_keysize = DES3_EDE_KEY_SIZE,
-			.max_keysize = DES3_EDE_KEY_SIZE,
-			.ivsize = DES_BLOCK_SIZE,
-			.setkey = cvm_cbc_des3_setkey,
-			.encrypt = cvm_encrypt,
-			.decrypt = cvm_decrypt,
-		},
-	},
-	.cra_init = cvm_enc_dec_init,
-	.cra_module = THIS_MODULE,
+	.base.cra_flags		= CRYPTO_ALG_ASYNC,
+	.base.cra_blocksize	= DES3_EDE_BLOCK_SIZE,
+	.base.cra_ctxsize	= sizeof(struct cvm_des3_ctx),
+	.base.cra_alignmask	= 7,
+	.base.cra_priority	= 4001,
+	.base.cra_name		= "cbc(des3_ede)",
+	.base.cra_driver_name	= "cavium-cbc-des3_ede",
+	.base.cra_module	= THIS_MODULE,
+
+	.min_keysize		= DES3_EDE_KEY_SIZE,
+	.max_keysize		= DES3_EDE_KEY_SIZE,
+	.ivsize			= DES_BLOCK_SIZE,
+	.setkey			= cvm_cbc_des3_setkey,
+	.encrypt		= cvm_encrypt,
+	.decrypt		= cvm_decrypt,
+	.init			= cvm_enc_dec_init,
 }, {
-	.cra_flags = CRYPTO_ALG_TYPE_ABLKCIPHER | CRYPTO_ALG_ASYNC,
-	.cra_blocksize = DES3_EDE_BLOCK_SIZE,
-	.cra_ctxsize = sizeof(struct cvm_des3_ctx),
-	.cra_alignmask = 7,
-	.cra_priority = 4001,
-	.cra_name = "ecb(des3_ede)",
-	.cra_driver_name = "cavium-ecb-des3_ede",
-	.cra_type = &crypto_ablkcipher_type,
-	.cra_u = {
-		.ablkcipher = {
-			.min_keysize = DES3_EDE_KEY_SIZE,
-			.max_keysize = DES3_EDE_KEY_SIZE,
-			.ivsize = DES_BLOCK_SIZE,
-			.setkey = cvm_ecb_des3_setkey,
-			.encrypt = cvm_encrypt,
-			.decrypt = cvm_decrypt,
-		},
-	},
-	.cra_init = cvm_enc_dec_init,
-	.cra_module = THIS_MODULE,
+	.base.cra_flags		= CRYPTO_ALG_ASYNC,
+	.base.cra_blocksize	= DES3_EDE_BLOCK_SIZE,
+	.base.cra_ctxsize	= sizeof(struct cvm_des3_ctx),
+	.base.cra_alignmask	= 7,
+	.base.cra_priority	= 4001,
+	.base.cra_name		= "ecb(des3_ede)",
+	.base.cra_driver_name	= "cavium-ecb-des3_ede",
+	.base.cra_module	= THIS_MODULE,
+
+	.min_keysize		= DES3_EDE_KEY_SIZE,
+	.max_keysize		= DES3_EDE_KEY_SIZE,
+	.ivsize			= DES_BLOCK_SIZE,
+	.setkey			= cvm_ecb_des3_setkey,
+	.encrypt		= cvm_encrypt,
+	.decrypt		= cvm_decrypt,
+	.init			= cvm_enc_dec_init,
 } };
 
 static inline int cav_register_algs(void)
 {
 	int err = 0;
 
-	err = crypto_register_algs(algs, ARRAY_SIZE(algs));
+	err = crypto_register_skciphers(algs, ARRAY_SIZE(algs));
 	if (err)
 		return err;
 
@@ -480,7 +456,7 @@ static inline int cav_register_algs(void)
 
 static inline void cav_unregister_algs(void)
 {
-	crypto_unregister_algs(algs, ARRAY_SIZE(algs));
+	crypto_unregister_skciphers(algs, ARRAY_SIZE(algs));
 }
 
 int cvm_crypto_init(struct cpt_vf *cptvf)
-- 
2.20.1


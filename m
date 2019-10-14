Return-Path: <SRS0=VKJi=YH=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E5DF8ECE587
	for <linux-crypto@archiver.kernel.org>; Mon, 14 Oct 2019 12:19:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id AFD6C206A3
	for <linux-crypto@archiver.kernel.org>; Mon, 14 Oct 2019 12:19:55 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="GU3DD6sX"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730126AbfJNMTz (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 14 Oct 2019 08:19:55 -0400
Received: from mail-wr1-f66.google.com ([209.85.221.66]:41619 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729858AbfJNMTy (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 14 Oct 2019 08:19:54 -0400
Received: by mail-wr1-f66.google.com with SMTP id p4so3595550wrm.8
        for <linux-crypto@vger.kernel.org>; Mon, 14 Oct 2019 05:19:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=KCy1T3O5xm/Iv0blzz4frawvkZXFTldGpWRPBR9LMG8=;
        b=GU3DD6sXqtzdFPeGYjVEkJG1XRQarkV2r+vpcwlb0xMnjGhtLrvyItiDy9vfMIaAR2
         2KNrc7c6A2rH/PrYlQ77HLwaYS2UbNLvZS6ZxeeKa+Bj4haqWoHjaRHKy+rWpxkcD9Ys
         hCaimmr8MHWD+nllfeUDBr5n0hGv6KF379Wlw0SzDnQopTfUWGOe7ZEByXvZMhlVwZFK
         pDSLAKZsLCZFZhqqV1hmLdSDhPqc8ES99D1PKL+l1ek98afLJ18vvsWaoB/sG5N7GQtn
         Txfyt2+lfizrZ2WGWRidmidodwE0daFJNOa5GcF3AaXXXmABprOAI6LVEXFlYez5twnS
         BICQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=KCy1T3O5xm/Iv0blzz4frawvkZXFTldGpWRPBR9LMG8=;
        b=M55UpmSz3vHknDj3Pv5Piu+x9MAmpjV6NOQ47jK7AGnFI4SmGiP9YygUrjzG0V9OK9
         pZxUiyXWkXyas/+5eXg91OCR1QUyN20yCS7wxQ8bP+Uger+sdFb4UCAD+GvEDbwYz+FB
         3lFF5Y1A3P5G15165+363nufwxWvIxegzw5BnNqhyEJlyZBz3d5ymcZSE2lMSgoqhRza
         mvT135CaCgeUYJI8xm6dtoGhctTtVIwigSr+z+9O0LKJnWOmXIybG3FGx7JZYsQIcWMA
         oep4VArRelqE/kE1l7uZxaxwngggSp0Sh5kOZZ+GDAx72mVW45f0t0BPvqoHKZWrUyax
         l96g==
X-Gm-Message-State: APjAAAWGgqUv5ihEhFWrm8rYfL0E+JBBHhFOYFVIUROKGyHg9HLgoTJN
        lFixHiDNfdSbh2KJwa0s/DUFgXZDAktqIw==
X-Google-Smtp-Source: APXvYqwYD8Jzkg08JO9z1hO3lexxyrkiH6dmSMp7HjZcNvHP6i9jbexifMyewO+UEplffe+bHBthLw==
X-Received: by 2002:a5d:4302:: with SMTP id h2mr16070824wrq.35.1571055591123;
        Mon, 14 Oct 2019 05:19:51 -0700 (PDT)
Received: from localhost.localdomain (91-167-84-221.subs.proxad.net. [91.167.84.221])
        by smtp.gmail.com with ESMTPSA id i1sm20222470wmb.19.2019.10.14.05.19.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 14 Oct 2019 05:19:50 -0700 (PDT)
From:   Ard Biesheuvel <ard.biesheuvel@linaro.org>
To:     linux-crypto@vger.kernel.org
Cc:     Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Biggers <ebiggers@google.com>,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH 12/25] crypto: cavium/cpt - switch to skcipher API
Date:   Mon, 14 Oct 2019 14:18:57 +0200
Message-Id: <20191014121910.7264-13-ard.biesheuvel@linaro.org>
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


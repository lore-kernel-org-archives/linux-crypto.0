Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E8336C636C8
	for <linux-crypto@archiver.kernel.org>; Tue, 20 Jul 2021 08:57:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CF9C661221
	for <linux-crypto@archiver.kernel.org>; Tue, 20 Jul 2021 08:57:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234772AbhGTIRI (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 20 Jul 2021 04:17:08 -0400
Received: from esa.microchip.iphmx.com ([68.232.153.233]:24894 "EHLO
        esa.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235185AbhGTIPX (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 20 Jul 2021 04:15:23 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1626771363; x=1658307363;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=6okpyKayPNfv5CWGaMmRljBALKEZq5fiLqgkdNmsZkc=;
  b=yfZex7Aop+Z9Yd/MnJl2w1D+W0uq2Dbz8xKnabhYaAcUDXLVDaaGuXQZ
   ta09HAtlKrHw1Z7JwDYjP7Y4rawSpjVGm3lfmoa5pd6j88t9ABOVRe5PR
   wOskNdEkZjolNjoKy9gFpUnkHVWxL8J+nq0WWo7XCYZ43RmuQAfKVhouN
   gyPC8FAPgM00duQVMvVHnfYNSvl6sbri2d23xNovxDI1PKuMWdkI+2LHx
   jD3oSdzR3hbCUZnhHu79ujdXBCXlSINj3GQzszWUtVhYa8eTYA0izaO6t
   wp61i7soMC3ptKrIvkTfe6iU+3/DZaGiom17WO3nreqalO7Mmnrtg03J6
   g==;
IronPort-SDR: ZFrbeC1aqkfdUG1aHUGKSs3E3Bc6KiXwpUFz18HJEL99UqQ8cemYIS1clXLJyMGVFF7D/slSVK
 Uy9x8DzM0rUuCuKy5TOLUPouwnB8xgoH6RF2WnqTMweyivNZHXlCGG41Nz5X64ePri9GaHX60y
 f4hPhFZ4jvWgtCTK+GLaUW6gElvv01KZ2C4C3Bi4W16POaENkapDrPRhinhjCdYwY3wGoP1PUE
 YBvSzHEDTiJ++pfeH6LFlRMiEWRz+djmRIcPoGq8hMN5KMV4pGa9Ak1XLjaDT2QFK7t2dnkfJI
 qbCiyK4vX5Q1Jqah0Jwz1m0u
X-IronPort-AV: E=Sophos;i="5.84,254,1620716400"; 
   d="scan'208";a="128973649"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa5.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 20 Jul 2021 01:56:02 -0700
Received: from chn-vm-ex03.mchp-main.com (10.10.85.151) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Tue, 20 Jul 2021 01:56:01 -0700
Received: from ROB-ULT-M18064N.mchp-main.com (10.10.115.15) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server id
 15.1.2176.2 via Frontend Transport; Tue, 20 Jul 2021 01:55:59 -0700
From:   Tudor Ambarus <tudor.ambarus@microchip.com>
To:     <herbert@gondor.apana.org.au>
CC:     <nicolas.ferre@microchip.com>, <alexandre.belloni@bootlin.com>,
        <ludovic.desroches@microchip.com>, <linux-crypto@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>,
        "Tudor Ambarus" <tudor.ambarus@microchip.com>
Subject: [PATCH 9/9] crypto: atmel-aes: Allocate aes dev at tfm init time
Date:   Tue, 20 Jul 2021 11:55:35 +0300
Message-ID: <20210720085535.141486-10-tudor.ambarus@microchip.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210720085535.141486-1-tudor.ambarus@microchip.com>
References: <20210720085535.141486-1-tudor.ambarus@microchip.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Allocate the atmel_aes_dev data at tfm init time, and not for
each crypt request.
There's a single AES IP per SoC, clarify that in the code.

Signed-off-by: Tudor Ambarus <tudor.ambarus@microchip.com>
---
 drivers/crypto/atmel-aes.c | 76 +++++++++++++++++++++-----------------
 1 file changed, 43 insertions(+), 33 deletions(-)

diff --git a/drivers/crypto/atmel-aes.c b/drivers/crypto/atmel-aes.c
index e74fcaac551e..d0f387674d32 100644
--- a/drivers/crypto/atmel-aes.c
+++ b/drivers/crypto/atmel-aes.c
@@ -420,24 +420,15 @@ static inline size_t atmel_aes_padlen(size_t len, size_t block_size)
 	return len ? block_size - len : 0;
 }
 
-static struct atmel_aes_dev *atmel_aes_find_dev(struct atmel_aes_base_ctx *ctx)
+static struct atmel_aes_dev *atmel_aes_dev_alloc(struct atmel_aes_base_ctx *ctx)
 {
-	struct atmel_aes_dev *aes_dd = NULL;
-	struct atmel_aes_dev *tmp;
+	struct atmel_aes_dev *aes_dd;
 
 	spin_lock_bh(&atmel_aes.lock);
-	if (!ctx->dd) {
-		list_for_each_entry(tmp, &atmel_aes.dev_list, list) {
-			aes_dd = tmp;
-			break;
-		}
-		ctx->dd = aes_dd;
-	} else {
-		aes_dd = ctx->dd;
-	}
-
+	/* One AES IP per SoC. */
+	aes_dd = list_first_entry_or_null(&atmel_aes.dev_list,
+					  struct atmel_aes_dev, list);
 	spin_unlock_bh(&atmel_aes.lock);
-
 	return aes_dd;
 }
 
@@ -969,7 +960,6 @@ static int atmel_aes_handle_queue(struct atmel_aes_dev *dd,
 	ctx = crypto_tfm_ctx(areq->tfm);
 
 	dd->areq = areq;
-	dd->ctx = ctx;
 	start_async = (areq != new_areq);
 	dd->is_async = start_async;
 
@@ -1106,7 +1096,6 @@ static int atmel_aes_crypt(struct skcipher_request *req, unsigned long mode)
 	struct crypto_skcipher *skcipher = crypto_skcipher_reqtfm(req);
 	struct atmel_aes_base_ctx *ctx = crypto_skcipher_ctx(skcipher);
 	struct atmel_aes_reqctx *rctx;
-	struct atmel_aes_dev *dd;
 	u32 opmode = mode & AES_FLAGS_OPMODE_MASK;
 
 	if (opmode == AES_FLAGS_XTS) {
@@ -1152,10 +1141,6 @@ static int atmel_aes_crypt(struct skcipher_request *req, unsigned long mode)
 	}
 	ctx->is_aead = false;
 
-	dd = atmel_aes_find_dev(ctx);
-	if (!dd)
-		return -ENODEV;
-
 	rctx = skcipher_request_ctx(req);
 	rctx->mode = mode;
 
@@ -1169,7 +1154,7 @@ static int atmel_aes_crypt(struct skcipher_request *req, unsigned long mode)
 						 ivsize, 0);
 	}
 
-	return atmel_aes_handle_queue(dd, &req->base);
+	return atmel_aes_handle_queue(ctx->dd, &req->base);
 }
 
 static int atmel_aes_setkey(struct crypto_skcipher *tfm, const u8 *key,
@@ -1281,8 +1266,15 @@ static int atmel_aes_ctr_decrypt(struct skcipher_request *req)
 static int atmel_aes_init_tfm(struct crypto_skcipher *tfm)
 {
 	struct atmel_aes_ctx *ctx = crypto_skcipher_ctx(tfm);
+	struct atmel_aes_dev *dd;
+
+	dd = atmel_aes_dev_alloc(&ctx->base);
+	if (!dd)
+		return -ENODEV;
 
 	crypto_skcipher_set_reqsize(tfm, sizeof(struct atmel_aes_reqctx));
+	ctx->base.dd = dd;
+	ctx->base.dd->ctx = &ctx->base;
 	ctx->base.start = atmel_aes_start;
 
 	return 0;
@@ -1291,8 +1283,15 @@ static int atmel_aes_init_tfm(struct crypto_skcipher *tfm)
 static int atmel_aes_ctr_init_tfm(struct crypto_skcipher *tfm)
 {
 	struct atmel_aes_ctx *ctx = crypto_skcipher_ctx(tfm);
+	struct atmel_aes_dev *dd;
+
+	dd = atmel_aes_dev_alloc(&ctx->base);
+	if (!dd)
+		return -ENODEV;
 
 	crypto_skcipher_set_reqsize(tfm, sizeof(struct atmel_aes_reqctx));
+	ctx->base.dd = dd;
+	ctx->base.dd->ctx = &ctx->base;
 	ctx->base.start = atmel_aes_ctr_start;
 
 	return 0;
@@ -1730,20 +1729,15 @@ static int atmel_aes_gcm_crypt(struct aead_request *req,
 {
 	struct atmel_aes_base_ctx *ctx;
 	struct atmel_aes_reqctx *rctx;
-	struct atmel_aes_dev *dd;
 
 	ctx = crypto_aead_ctx(crypto_aead_reqtfm(req));
 	ctx->block_size = AES_BLOCK_SIZE;
 	ctx->is_aead = true;
 
-	dd = atmel_aes_find_dev(ctx);
-	if (!dd)
-		return -ENODEV;
-
 	rctx = aead_request_ctx(req);
 	rctx->mode = AES_FLAGS_GCM | mode;
 
-	return atmel_aes_handle_queue(dd, &req->base);
+	return atmel_aes_handle_queue(ctx->dd, &req->base);
 }
 
 static int atmel_aes_gcm_setkey(struct crypto_aead *tfm, const u8 *key,
@@ -1781,8 +1775,15 @@ static int atmel_aes_gcm_decrypt(struct aead_request *req)
 static int atmel_aes_gcm_init(struct crypto_aead *tfm)
 {
 	struct atmel_aes_gcm_ctx *ctx = crypto_aead_ctx(tfm);
+	struct atmel_aes_dev *dd;
+
+	dd = atmel_aes_dev_alloc(&ctx->base);
+	if (!dd)
+		return -ENODEV;
 
 	crypto_aead_set_reqsize(tfm, sizeof(struct atmel_aes_reqctx));
+	ctx->base.dd = dd;
+	ctx->base.dd->ctx = &ctx->base;
 	ctx->base.start = atmel_aes_gcm_start;
 
 	return 0;
@@ -1915,8 +1916,13 @@ static int atmel_aes_xts_decrypt(struct skcipher_request *req)
 static int atmel_aes_xts_init_tfm(struct crypto_skcipher *tfm)
 {
 	struct atmel_aes_xts_ctx *ctx = crypto_skcipher_ctx(tfm);
+	struct atmel_aes_dev *dd;
 	const char *tfm_name = crypto_tfm_alg_name(&tfm->base);
 
+	dd = atmel_aes_dev_alloc(&ctx->base);
+	if (!dd)
+		return -ENODEV;
+
 	ctx->fallback_tfm = crypto_alloc_skcipher(tfm_name, 0,
 						  CRYPTO_ALG_NEED_FALLBACK);
 	if (IS_ERR(ctx->fallback_tfm))
@@ -1924,6 +1930,8 @@ static int atmel_aes_xts_init_tfm(struct crypto_skcipher *tfm)
 
 	crypto_skcipher_set_reqsize(tfm, sizeof(struct atmel_aes_reqctx) +
 				    crypto_skcipher_reqsize(ctx->fallback_tfm));
+	ctx->base.dd = dd;
+	ctx->base.dd->ctx = &ctx->base;
 	ctx->base.start = atmel_aes_xts_start;
 
 	return 0;
@@ -2137,6 +2145,11 @@ static int atmel_aes_authenc_init_tfm(struct crypto_aead *tfm,
 {
 	struct atmel_aes_authenc_ctx *ctx = crypto_aead_ctx(tfm);
 	unsigned int auth_reqsize = atmel_sha_authenc_get_reqsize();
+	struct atmel_aes_dev *dd;
+
+	dd = atmel_aes_dev_alloc(&ctx->base);
+	if (!dd)
+		return -ENODEV;
 
 	ctx->auth = atmel_sha_authenc_spawn(auth_mode);
 	if (IS_ERR(ctx->auth))
@@ -2144,6 +2157,8 @@ static int atmel_aes_authenc_init_tfm(struct crypto_aead *tfm,
 
 	crypto_aead_set_reqsize(tfm, (sizeof(struct atmel_aes_authenc_reqctx) +
 				      auth_reqsize));
+	ctx->base.dd = dd;
+	ctx->base.dd->ctx = &ctx->base;
 	ctx->base.start = atmel_aes_authenc_start;
 
 	return 0;
@@ -2189,7 +2204,6 @@ static int atmel_aes_authenc_crypt(struct aead_request *req,
 	struct atmel_aes_base_ctx *ctx = crypto_aead_ctx(tfm);
 	u32 authsize = crypto_aead_authsize(tfm);
 	bool enc = (mode & AES_FLAGS_ENCRYPT);
-	struct atmel_aes_dev *dd;
 
 	/* Compute text length. */
 	if (!enc && req->cryptlen < authsize)
@@ -2208,11 +2222,7 @@ static int atmel_aes_authenc_crypt(struct aead_request *req,
 	ctx->block_size = AES_BLOCK_SIZE;
 	ctx->is_aead = true;
 
-	dd = atmel_aes_find_dev(ctx);
-	if (!dd)
-		return -ENODEV;
-
-	return atmel_aes_handle_queue(dd, &req->base);
+	return atmel_aes_handle_queue(ctx->dd, &req->base);
 }
 
 static int atmel_aes_authenc_cbc_aes_encrypt(struct aead_request *req)
-- 
2.25.1


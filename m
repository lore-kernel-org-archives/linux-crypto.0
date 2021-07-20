Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AF777C636C8
	for <linux-crypto@archiver.kernel.org>; Tue, 20 Jul 2021 08:58:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9C57A61209
	for <linux-crypto@archiver.kernel.org>; Tue, 20 Jul 2021 08:58:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235117AbhGTIRd (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 20 Jul 2021 04:17:33 -0400
Received: from esa.microchip.iphmx.com ([68.232.153.233]:24912 "EHLO
        esa.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234058AbhGTIPV (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 20 Jul 2021 04:15:21 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1626771360; x=1658307360;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=4vs92dErEkqT06ejYtxZZUUoTA4haPP+vsh9ZG/Z/OU=;
  b=oct6rO8vJwVEhWcJGvxZKoKqw0axjcAnA/x5QhaLTl+n5+vOFRwkYN6z
   cOK2q/E7Yl4Fr4rllnReVjHLjR2PKKQEraxC8I/wIZE3KWvsw53dDL0YB
   zBK71ZAMJYhx6iVh3QckYLLM5CoXBI2QPXNsv7TR85ve89gqJdIxtYaab
   C+ClnEe44MzS+TcXkvq2ryAHr7CzetBe3TgQLhdMzW/xvCHbj9t+byLx7
   kLbzufN4TNmMOFIX3MS+KmUkvUzGTpv/ABCpCdJh1AhWlvE3CJWXwkVo7
   9YkJsitgiDyVvxHsRMTG/QQ633DZZ0MJNeUbiqAM9jV7Ph5lrHbycA1oh
   g==;
IronPort-SDR: /Vt9weeYmd5XHN/VBv1wBQ2g9IWE3AXMuLzlFephUFNj4fHlvhc3BKGQOeyM6FWDXChX1SVWX4
 3Ns5sboOHa/NtgYgt2rffJhH6XR1NnBaujL7Gvrulj+TkMKPkxaJJE7XtVuPYFaronk7JmXSUn
 WiHrWOqCDOd67yvJMoRjS5hjgpLWM8mCY+YsgffKL2I4l3LQ83X+PAYcJNIc8PxHMVBaTnbhTU
 g/pHHoj1QoacmM37wDA1sQiI5Wc3+P5BzAivQ58Vhsaa0MbwwornGSrl/mHNxM7Owbm10tr1B0
 VnJiWBei5fYku+qM2J9XCj0a
X-IronPort-AV: E=Sophos;i="5.84,254,1620716400"; 
   d="scan'208";a="128973647"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa5.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 20 Jul 2021 01:56:00 -0700
Received: from chn-vm-ex03.mchp-main.com (10.10.85.151) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Tue, 20 Jul 2021 01:55:59 -0700
Received: from ROB-ULT-M18064N.mchp-main.com (10.10.115.15) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server id
 15.1.2176.2 via Frontend Transport; Tue, 20 Jul 2021 01:55:57 -0700
From:   Tudor Ambarus <tudor.ambarus@microchip.com>
To:     <herbert@gondor.apana.org.au>
CC:     <nicolas.ferre@microchip.com>, <alexandre.belloni@bootlin.com>,
        <ludovic.desroches@microchip.com>, <linux-crypto@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>,
        "Tudor Ambarus" <tudor.ambarus@microchip.com>
Subject: [PATCH 8/9] crypto: atmel-aes: Add fallback to XTS software implementation
Date:   Tue, 20 Jul 2021 11:55:34 +0300
Message-ID: <20210720085535.141486-9-tudor.ambarus@microchip.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210720085535.141486-1-tudor.ambarus@microchip.com>
References: <20210720085535.141486-1-tudor.ambarus@microchip.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

XTS is supported just for input lengths with data units of 128-bit blocks.
Add a fallback to software implementation when the last block is shorter
than 128 bits.

Signed-off-by: Tudor Ambarus <tudor.ambarus@microchip.com>
---
 drivers/crypto/atmel-aes.c | 55 +++++++++++++++++++++++++++++++++++---
 1 file changed, 51 insertions(+), 4 deletions(-)

diff --git a/drivers/crypto/atmel-aes.c b/drivers/crypto/atmel-aes.c
index 9ec007b4f8fc..e74fcaac551e 100644
--- a/drivers/crypto/atmel-aes.c
+++ b/drivers/crypto/atmel-aes.c
@@ -143,6 +143,7 @@ struct atmel_aes_xts_ctx {
 	struct atmel_aes_base_ctx	base;
 
 	u32			key2[AES_KEYSIZE_256 / sizeof(u32)];
+	struct crypto_skcipher *fallback_tfm;
 };
 
 #if IS_ENABLED(CONFIG_CRYPTO_DEV_ATMEL_AUTHENC)
@@ -155,6 +156,7 @@ struct atmel_aes_authenc_ctx {
 struct atmel_aes_reqctx {
 	unsigned long		mode;
 	u8			lastc[AES_BLOCK_SIZE];
+	struct skcipher_request fallback_req;
 };
 
 #if IS_ENABLED(CONFIG_CRYPTO_DEV_ATMEL_AUTHENC)
@@ -1083,6 +1085,22 @@ static int atmel_aes_ctr_start(struct atmel_aes_dev *dd)
 	return atmel_aes_ctr_transfer(dd);
 }
 
+static int atmel_aes_xts_fallback(struct skcipher_request *req, bool enc)
+{
+	struct atmel_aes_reqctx *rctx = skcipher_request_ctx(req);
+	struct atmel_aes_xts_ctx *ctx = crypto_skcipher_ctx(
+			crypto_skcipher_reqtfm(req));
+
+	skcipher_request_set_tfm(&rctx->fallback_req, ctx->fallback_tfm);
+	skcipher_request_set_callback(&rctx->fallback_req, req->base.flags,
+				      req->base.complete, req->base.data);
+	skcipher_request_set_crypt(&rctx->fallback_req, req->src, req->dst,
+				   req->cryptlen, req->iv);
+
+	return enc ? crypto_skcipher_encrypt(&rctx->fallback_req) :
+		     crypto_skcipher_decrypt(&rctx->fallback_req);
+}
+
 static int atmel_aes_crypt(struct skcipher_request *req, unsigned long mode)
 {
 	struct crypto_skcipher *skcipher = crypto_skcipher_reqtfm(req);
@@ -1091,8 +1109,14 @@ static int atmel_aes_crypt(struct skcipher_request *req, unsigned long mode)
 	struct atmel_aes_dev *dd;
 	u32 opmode = mode & AES_FLAGS_OPMODE_MASK;
 
-	if (opmode == AES_FLAGS_XTS && req->cryptlen < XTS_BLOCK_SIZE)
-		return -EINVAL;
+	if (opmode == AES_FLAGS_XTS) {
+		if (req->cryptlen < XTS_BLOCK_SIZE)
+			return -EINVAL;
+
+		if (!IS_ALIGNED(req->cryptlen, XTS_BLOCK_SIZE))
+			return atmel_aes_xts_fallback(req,
+						      mode & AES_FLAGS_ENCRYPT);
+	}
 
 	/*
 	 * ECB, CBC, CFB, OFB or CTR mode require the plaintext and ciphertext
@@ -1864,6 +1888,13 @@ static int atmel_aes_xts_setkey(struct crypto_skcipher *tfm, const u8 *key,
 	if (err)
 		return err;
 
+	crypto_skcipher_clear_flags(ctx->fallback_tfm, CRYPTO_TFM_REQ_MASK);
+	crypto_skcipher_set_flags(ctx->fallback_tfm, tfm->base.crt_flags &
+				  CRYPTO_TFM_REQ_MASK);
+	err = crypto_skcipher_setkey(ctx->fallback_tfm, key, keylen);
+	if (err)
+		return err;
+
 	memcpy(ctx->base.key, key, keylen/2);
 	memcpy(ctx->key2, key + keylen/2, keylen/2);
 	ctx->base.keylen = keylen/2;
@@ -1884,18 +1915,33 @@ static int atmel_aes_xts_decrypt(struct skcipher_request *req)
 static int atmel_aes_xts_init_tfm(struct crypto_skcipher *tfm)
 {
 	struct atmel_aes_xts_ctx *ctx = crypto_skcipher_ctx(tfm);
+	const char *tfm_name = crypto_tfm_alg_name(&tfm->base);
 
-	crypto_skcipher_set_reqsize(tfm, sizeof(struct atmel_aes_reqctx));
+	ctx->fallback_tfm = crypto_alloc_skcipher(tfm_name, 0,
+						  CRYPTO_ALG_NEED_FALLBACK);
+	if (IS_ERR(ctx->fallback_tfm))
+		return PTR_ERR(ctx->fallback_tfm);
+
+	crypto_skcipher_set_reqsize(tfm, sizeof(struct atmel_aes_reqctx) +
+				    crypto_skcipher_reqsize(ctx->fallback_tfm));
 	ctx->base.start = atmel_aes_xts_start;
 
 	return 0;
 }
 
+static void atmel_aes_xts_exit_tfm(struct crypto_skcipher *tfm)
+{
+	struct atmel_aes_xts_ctx *ctx = crypto_skcipher_ctx(tfm);
+
+	crypto_free_skcipher(ctx->fallback_tfm);
+}
+
 static struct skcipher_alg aes_xts_alg = {
 	.base.cra_name		= "xts(aes)",
 	.base.cra_driver_name	= "atmel-xts-aes",
 	.base.cra_blocksize	= AES_BLOCK_SIZE,
 	.base.cra_ctxsize	= sizeof(struct atmel_aes_xts_ctx),
+	.base.cra_flags		= CRYPTO_ALG_NEED_FALLBACK,
 
 	.min_keysize		= 2 * AES_MIN_KEY_SIZE,
 	.max_keysize		= 2 * AES_MAX_KEY_SIZE,
@@ -1904,6 +1950,7 @@ static struct skcipher_alg aes_xts_alg = {
 	.encrypt		= atmel_aes_xts_encrypt,
 	.decrypt		= atmel_aes_xts_decrypt,
 	.init			= atmel_aes_xts_init_tfm,
+	.exit			= atmel_aes_xts_exit_tfm,
 };
 
 #if IS_ENABLED(CONFIG_CRYPTO_DEV_ATMEL_AUTHENC)
@@ -2373,7 +2420,7 @@ static void atmel_aes_unregister_algs(struct atmel_aes_dev *dd)
 
 static void atmel_aes_crypto_alg_init(struct crypto_alg *alg)
 {
-	alg->cra_flags = CRYPTO_ALG_ASYNC;
+	alg->cra_flags |= CRYPTO_ALG_ASYNC;
 	alg->cra_alignmask = 0xf;
 	alg->cra_priority = ATMEL_AES_PRIORITY;
 	alg->cra_module = THIS_MODULE;
-- 
2.25.1


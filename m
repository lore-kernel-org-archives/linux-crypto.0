Return-Path: <SRS0=QWZk=Y5=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 15CCBC5DF62
	for <linux-crypto@archiver.kernel.org>; Tue,  5 Nov 2019 15:14:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B60DF214D8
	for <linux-crypto@archiver.kernel.org>; Tue,  5 Nov 2019 15:14:18 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="G7oERnDw"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389822AbfKEPOG (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 5 Nov 2019 10:14:06 -0500
Received: from mail-pg1-f195.google.com ([209.85.215.195]:38452 "EHLO
        mail-pg1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389815AbfKEPOF (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 5 Nov 2019 10:14:05 -0500
Received: by mail-pg1-f195.google.com with SMTP id 15so1237714pgh.5;
        Tue, 05 Nov 2019 07:14:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=cXNw2/pBK27VTIUjTVGq79R/uQuigsaUhqr9eLPJLpg=;
        b=G7oERnDwhAsi/YW1s6w95ef/5gmzmZZFTuXFjiNisL5OTTeczZE+ZsCb7ZAh13mQ1a
         OkWJ+JViez4YkG7/GYDU6iNRKQJpOqybOAhmK1FhRPeVie53iiZsx2F25XcMydyDtjEQ
         wNR66On+9czPgnrFDh/2Aiu8qexJeJsLF5wpXHGdCNuX+vL6xOiZ7l5sQANIqa8KE1jN
         Tl2KheTe9PBTpP7kmdmb9UzZDL5jOAFLxa2RdqO0MWF8C3Uk0ruH5iwWRPtAxPL82c/x
         mJzaSkPCVZ/RlFpWfZiCQq2phTi62rGCXpo5cdK145AwAc6vv5oLjKwnExUB8kyn63gT
         dF6g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=cXNw2/pBK27VTIUjTVGq79R/uQuigsaUhqr9eLPJLpg=;
        b=jUcb0409ZO/JUNv6WkZ7bq4NRTx8EVws05COMh+gUitgUPKMUdO0uxRHfz7T1tjjnP
         epbwZnUIlOZcKjsi5TMeZ4aYj/MQ+krovM+6sx4RldxbpGEZtlCBSMdKElul89+xKW9E
         sxIii3cGH7ZJHNcQ4iquC222M3oNcTlMU6A1+Ii5aRg97BPlcU9JgrSdT09Na4s81lzo
         0MborqlCTX91JO1tAhJp+aqyz76h4BKQCXp5SQuMxgE6uAm5gisDtMKCzxuDhq4TAL8Q
         IKHyEl4wBIJtKBbkzcs73lqsI/W30X95+FNxrnX886bl30/BUDJs1Pm1KtfJsmzPuWXv
         skbQ==
X-Gm-Message-State: APjAAAXQZ7Bo04YUzTu+6SZye4tz4EnBL0Tf7+e2KsHP7VouR5l6chv1
        MIbRWSHsAdoERtyssUdszMiCj6tV
X-Google-Smtp-Source: APXvYqxApW7qHnwbV/Q4lO+uyKMGBsQSUUd/UgGI4e/nUpBASJaTZFbITFzZ9KkrFRqAprcf6zF8zA==
X-Received: by 2002:a63:81:: with SMTP id 123mr37793284pga.47.1572966843321;
        Tue, 05 Nov 2019 07:14:03 -0800 (PST)
Received: from localhost.lan (c-67-185-54-80.hsd1.wa.comcast.net. [67.185.54.80])
        by smtp.gmail.com with ESMTPSA id f7sm23120691pfa.150.2019.11.05.07.14.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 05 Nov 2019 07:14:02 -0800 (PST)
From:   Andrey Smirnov <andrew.smirnov@gmail.com>
To:     linux-crypto@vger.kernel.org
Cc:     Andrey Smirnov <andrew.smirnov@gmail.com>,
        Chris Healy <cphealy@gmail.com>,
        Lucas Stach <l.stach@pengutronix.de>,
        =?UTF-8?q?Horia=20Geant=C4=83?= <horia.geanta@nxp.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Iuliana Prodan <iuliana.prodan@nxp.com>, linux-imx@nxp.com,
        linux-kernel@vger.kernel.org
Subject: [PATCH 3/5] crypto: caam - convert JR API to use struct caam_drv_private_jr
Date:   Tue,  5 Nov 2019 07:13:51 -0800
Message-Id: <20191105151353.6522-4-andrew.smirnov@gmail.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20191105151353.6522-1-andrew.smirnov@gmail.com>
References: <20191105151353.6522-1-andrew.smirnov@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

As a first step of detaching JR object from underlying 'struct device'
convert all of the API in jr.h to operate on 'struct
caam_drv_private_jr' instead of 'struct device' and adjust the rest of
the code accordingly.

Signed-off-by: Andrey Smirnov <andrew.smirnov@gmail.com>
Cc: Chris Healy <cphealy@gmail.com>
Cc: Lucas Stach <l.stach@pengutronix.de>
Cc: Horia Geantă <horia.geanta@nxp.com>
Cc: Herbert Xu <herbert@gondor.apana.org.au>
Cc: Iuliana Prodan <iuliana.prodan@nxp.com>
Cc: linux-imx@nxp.com
Cc: linux-crypto@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
---
 drivers/crypto/caam/caamalg.c    | 108 +++++++++++++++--------------
 drivers/crypto/caam/caamalg_qi.c |   8 +--
 drivers/crypto/caam/caamhash.c   | 115 ++++++++++++++++---------------
 drivers/crypto/caam/caampkc.c    |  67 +++++++++---------
 drivers/crypto/caam/caampkc.h    |   2 +-
 drivers/crypto/caam/caamrng.c    |  41 ++++++-----
 drivers/crypto/caam/jr.c         |  23 +++----
 drivers/crypto/caam/jr.h         |  12 ++--
 drivers/crypto/caam/key_gen.c    |  11 +--
 drivers/crypto/caam/key_gen.h    |   5 +-
 10 files changed, 207 insertions(+), 185 deletions(-)

diff --git a/drivers/crypto/caam/caamalg.c b/drivers/crypto/caam/caamalg.c
index 2912006b946b..4cb7d5b281cc 100644
--- a/drivers/crypto/caam/caamalg.c
+++ b/drivers/crypto/caam/caamalg.c
@@ -108,7 +108,7 @@ struct caam_ctx {
 	dma_addr_t sh_desc_dec_dma;
 	dma_addr_t key_dma;
 	enum dma_data_direction dir;
-	struct device *jrdev;
+	struct caam_drv_private_jr *jr;
 	struct alginfo adata;
 	struct alginfo cdata;
 	unsigned int authsize;
@@ -117,7 +117,7 @@ struct caam_ctx {
 static int aead_null_set_sh_desc(struct crypto_aead *aead)
 {
 	struct caam_ctx *ctx = crypto_aead_ctx(aead);
-	struct device *jrdev = ctx->jrdev;
+	struct device *jrdev = ctx->jr->dev;
 	struct caam_drv_private *ctrlpriv = dev_get_drvdata(jrdev->parent);
 	u32 *desc;
 	int rem_bytes = CAAM_DESC_BYTES_MAX - AEAD_DESC_JOB_IO_LEN -
@@ -170,7 +170,7 @@ static int aead_set_sh_desc(struct crypto_aead *aead)
 						 struct caam_aead_alg, aead);
 	unsigned int ivsize = crypto_aead_ivsize(aead);
 	struct caam_ctx *ctx = crypto_aead_ctx(aead);
-	struct device *jrdev = ctx->jrdev;
+	struct device *jrdev = ctx->jr->dev;
 	struct caam_drv_private *ctrlpriv = dev_get_drvdata(jrdev->parent);
 	u32 ctx1_iv_off = 0;
 	u32 *desc, *nonce = NULL;
@@ -308,7 +308,7 @@ static int aead_setauthsize(struct crypto_aead *authenc,
 static int gcm_set_sh_desc(struct crypto_aead *aead)
 {
 	struct caam_ctx *ctx = crypto_aead_ctx(aead);
-	struct device *jrdev = ctx->jrdev;
+	struct device *jrdev = ctx->jr->dev;
 	unsigned int ivsize = crypto_aead_ivsize(aead);
 	u32 *desc;
 	int rem_bytes = CAAM_DESC_BYTES_MAX - GCM_DESC_JOB_IO_LEN -
@@ -373,7 +373,7 @@ static int gcm_setauthsize(struct crypto_aead *authenc, unsigned int authsize)
 static int rfc4106_set_sh_desc(struct crypto_aead *aead)
 {
 	struct caam_ctx *ctx = crypto_aead_ctx(aead);
-	struct device *jrdev = ctx->jrdev;
+	struct device *jrdev = ctx->jr->dev;
 	unsigned int ivsize = crypto_aead_ivsize(aead);
 	u32 *desc;
 	int rem_bytes = CAAM_DESC_BYTES_MAX - GCM_DESC_JOB_IO_LEN -
@@ -441,7 +441,7 @@ static int rfc4106_setauthsize(struct crypto_aead *authenc,
 static int rfc4543_set_sh_desc(struct crypto_aead *aead)
 {
 	struct caam_ctx *ctx = crypto_aead_ctx(aead);
-	struct device *jrdev = ctx->jrdev;
+	struct device *jrdev = ctx->jr->dev;
 	unsigned int ivsize = crypto_aead_ivsize(aead);
 	u32 *desc;
 	int rem_bytes = CAAM_DESC_BYTES_MAX - GCM_DESC_JOB_IO_LEN -
@@ -507,7 +507,7 @@ static int rfc4543_setauthsize(struct crypto_aead *authenc,
 static int chachapoly_set_sh_desc(struct crypto_aead *aead)
 {
 	struct caam_ctx *ctx = crypto_aead_ctx(aead);
-	struct device *jrdev = ctx->jrdev;
+	struct device *jrdev = ctx->jr->dev;
 	unsigned int ivsize = crypto_aead_ivsize(aead);
 	u32 *desc;
 
@@ -563,7 +563,7 @@ static int aead_setkey(struct crypto_aead *aead,
 			       const u8 *key, unsigned int keylen)
 {
 	struct caam_ctx *ctx = crypto_aead_ctx(aead);
-	struct device *jrdev = ctx->jrdev;
+	struct device *jrdev = ctx->jr->dev;
 	struct caam_drv_private *ctrlpriv = dev_get_drvdata(jrdev->parent);
 	struct crypto_authenc_keys keys;
 	int ret = 0;
@@ -598,7 +598,7 @@ static int aead_setkey(struct crypto_aead *aead,
 		goto skip_split_key;
 	}
 
-	ret = gen_split_key(ctx->jrdev, ctx->key, &ctx->adata, keys.authkey,
+	ret = gen_split_key(ctx->jr, ctx->key, &ctx->adata, keys.authkey,
 			    keys.authkeylen, CAAM_MAX_KEY_SIZE -
 			    keys.enckeylen);
 	if (ret) {
@@ -645,7 +645,7 @@ static int gcm_setkey(struct crypto_aead *aead,
 		      const u8 *key, unsigned int keylen)
 {
 	struct caam_ctx *ctx = crypto_aead_ctx(aead);
-	struct device *jrdev = ctx->jrdev;
+	struct device *jrdev = ctx->jr->dev;
 	int err;
 
 	err = aes_check_keylen(keylen);
@@ -668,7 +668,7 @@ static int rfc4106_setkey(struct crypto_aead *aead,
 			  const u8 *key, unsigned int keylen)
 {
 	struct caam_ctx *ctx = crypto_aead_ctx(aead);
-	struct device *jrdev = ctx->jrdev;
+	struct device *jrdev = ctx->jr->dev;
 	int err;
 
 	err = aes_check_keylen(keylen - 4);
@@ -696,7 +696,7 @@ static int rfc4543_setkey(struct crypto_aead *aead,
 			  const u8 *key, unsigned int keylen)
 {
 	struct caam_ctx *ctx = crypto_aead_ctx(aead);
-	struct device *jrdev = ctx->jrdev;
+	struct device *jrdev = ctx->jr->dev;
 	int err;
 
 	err = aes_check_keylen(keylen - 4);
@@ -727,7 +727,7 @@ static int skcipher_setkey(struct crypto_skcipher *skcipher, const u8 *key,
 	struct caam_skcipher_alg *alg =
 		container_of(crypto_skcipher_alg(skcipher), typeof(*alg),
 			     skcipher);
-	struct device *jrdev = ctx->jrdev;
+	struct device *jrdev = ctx->jr->dev;
 	unsigned int ivsize = crypto_skcipher_ivsize(skcipher);
 	u32 *desc;
 	const bool is_rfc3686 = alg->caam.rfc3686;
@@ -842,7 +842,7 @@ static int xts_skcipher_setkey(struct crypto_skcipher *skcipher, const u8 *key,
 			       unsigned int keylen)
 {
 	struct caam_ctx *ctx = crypto_skcipher_ctx(skcipher);
-	struct device *jrdev = ctx->jrdev;
+	struct device *jrdev = ctx->jr->dev;
 	u32 *desc;
 
 	if (keylen != 2 * AES_MIN_KEY_SIZE  && keylen != 2 * AES_MAX_KEY_SIZE) {
@@ -960,10 +960,11 @@ static void skcipher_unmap(struct device *dev, struct skcipher_edesc *edesc,
 		   edesc->sec4_sg_dma, edesc->sec4_sg_bytes);
 }
 
-static void aead_encrypt_done(struct device *jrdev, u32 *desc, u32 err,
-				   void *context)
+static void aead_encrypt_done(struct caam_drv_private_jr *jr, u32 *desc,
+			      u32 err, void *context)
 {
 	struct aead_request *req = context;
+	struct device *jrdev = jr->dev;
 	struct aead_edesc *edesc;
 	int ecode = 0;
 
@@ -981,10 +982,11 @@ static void aead_encrypt_done(struct device *jrdev, u32 *desc, u32 err,
 	aead_request_complete(req, ecode);
 }
 
-static void aead_decrypt_done(struct device *jrdev, u32 *desc, u32 err,
-				   void *context)
+static void aead_decrypt_done(struct caam_drv_private_jr *jr, u32 *desc,
+			      u32 err, void *context)
 {
 	struct aead_request *req = context;
+	struct device *jrdev = jr->dev;
 	struct aead_edesc *edesc;
 	int ecode = 0;
 
@@ -1002,13 +1004,14 @@ static void aead_decrypt_done(struct device *jrdev, u32 *desc, u32 err,
 	aead_request_complete(req, ecode);
 }
 
-static void skcipher_encrypt_done(struct device *jrdev, u32 *desc, u32 err,
-				  void *context)
+static void skcipher_encrypt_done(struct caam_drv_private_jr *jr, u32 *desc,
+				  u32 err, void *context)
 {
 	struct skcipher_request *req = context;
 	struct skcipher_edesc *edesc;
 	struct crypto_skcipher *skcipher = crypto_skcipher_reqtfm(req);
 	int ivsize = crypto_skcipher_ivsize(skcipher);
+	struct device *jrdev = jr->dev;
 	int ecode = 0;
 
 	dev_dbg(jrdev, "%s %d: err 0x%x\n", __func__, __LINE__, err);
@@ -1042,13 +1045,14 @@ static void skcipher_encrypt_done(struct device *jrdev, u32 *desc, u32 err,
 	skcipher_request_complete(req, ecode);
 }
 
-static void skcipher_decrypt_done(struct device *jrdev, u32 *desc, u32 err,
-				  void *context)
+static void skcipher_decrypt_done(struct caam_drv_private_jr *jr, u32 *desc,
+				  u32 err, void *context)
 {
 	struct skcipher_request *req = context;
 	struct skcipher_edesc *edesc;
 	struct crypto_skcipher *skcipher = crypto_skcipher_reqtfm(req);
 	int ivsize = crypto_skcipher_ivsize(skcipher);
+	struct device *jrdev = jr->dev;
 	int ecode = 0;
 
 	dev_dbg(jrdev, "%s %d: err 0x%x\n", __func__, __LINE__, err);
@@ -1219,7 +1223,7 @@ static void init_authenc_job(struct aead_request *req,
 						 struct caam_aead_alg, aead);
 	unsigned int ivsize = crypto_aead_ivsize(aead);
 	struct caam_ctx *ctx = crypto_aead_ctx(aead);
-	struct caam_drv_private *ctrlpriv = dev_get_drvdata(ctx->jrdev->parent);
+	struct caam_drv_private *ctrlpriv = dev_get_drvdata(ctx->jr->dev->parent);
 	const bool ctr_mode = ((ctx->cdata.algtype & OP_ALG_AAI_MASK) ==
 			       OP_ALG_AAI_CTR_MOD128);
 	const bool is_rfc3686 = alg->caam.rfc3686;
@@ -1268,7 +1272,7 @@ static void init_skcipher_job(struct skcipher_request *req,
 {
 	struct crypto_skcipher *skcipher = crypto_skcipher_reqtfm(req);
 	struct caam_ctx *ctx = crypto_skcipher_ctx(skcipher);
-	struct device *jrdev = ctx->jrdev;
+	struct device *jrdev = ctx->jr->dev;
 	int ivsize = crypto_skcipher_ivsize(skcipher);
 	u32 *desc = edesc->hw_desc;
 	u32 *sh_desc;
@@ -1324,7 +1328,7 @@ static struct aead_edesc *aead_edesc_alloc(struct aead_request *req,
 {
 	struct crypto_aead *aead = crypto_aead_reqtfm(req);
 	struct caam_ctx *ctx = crypto_aead_ctx(aead);
-	struct device *jrdev = ctx->jrdev;
+	struct device *jrdev = ctx->jr->dev;
 	gfp_t flags = (req->base.flags & CRYPTO_TFM_REQ_MAY_SLEEP) ?
 		       GFP_KERNEL : GFP_ATOMIC;
 	int src_nents, mapped_src_nents, dst_nents = 0, mapped_dst_nents = 0;
@@ -1460,7 +1464,7 @@ static int gcm_encrypt(struct aead_request *req)
 	struct aead_edesc *edesc;
 	struct crypto_aead *aead = crypto_aead_reqtfm(req);
 	struct caam_ctx *ctx = crypto_aead_ctx(aead);
-	struct device *jrdev = ctx->jrdev;
+	struct device *jrdev = ctx->jr->dev;
 	bool all_contig;
 	u32 *desc;
 	int ret = 0;
@@ -1478,7 +1482,7 @@ static int gcm_encrypt(struct aead_request *req)
 			     desc_bytes(edesc->hw_desc), 1);
 
 	desc = edesc->hw_desc;
-	ret = caam_jr_enqueue(jrdev, desc, aead_encrypt_done, req);
+	ret = caam_jr_enqueue(ctx->jr, desc, aead_encrypt_done, req);
 	if (!ret) {
 		ret = -EINPROGRESS;
 	} else {
@@ -1494,7 +1498,7 @@ static int chachapoly_encrypt(struct aead_request *req)
 	struct aead_edesc *edesc;
 	struct crypto_aead *aead = crypto_aead_reqtfm(req);
 	struct caam_ctx *ctx = crypto_aead_ctx(aead);
-	struct device *jrdev = ctx->jrdev;
+	struct device *jrdev = ctx->jr->dev;
 	bool all_contig;
 	u32 *desc;
 	int ret;
@@ -1511,7 +1515,7 @@ static int chachapoly_encrypt(struct aead_request *req)
 			     DUMP_PREFIX_ADDRESS, 16, 4, desc, desc_bytes(desc),
 			     1);
 
-	ret = caam_jr_enqueue(jrdev, desc, aead_encrypt_done, req);
+	ret = caam_jr_enqueue(ctx->jr, desc, aead_encrypt_done, req);
 	if (!ret) {
 		ret = -EINPROGRESS;
 	} else {
@@ -1527,7 +1531,7 @@ static int chachapoly_decrypt(struct aead_request *req)
 	struct aead_edesc *edesc;
 	struct crypto_aead *aead = crypto_aead_reqtfm(req);
 	struct caam_ctx *ctx = crypto_aead_ctx(aead);
-	struct device *jrdev = ctx->jrdev;
+	struct device *jrdev = ctx->jr->dev;
 	bool all_contig;
 	u32 *desc;
 	int ret;
@@ -1544,7 +1548,7 @@ static int chachapoly_decrypt(struct aead_request *req)
 			     DUMP_PREFIX_ADDRESS, 16, 4, desc, desc_bytes(desc),
 			     1);
 
-	ret = caam_jr_enqueue(jrdev, desc, aead_decrypt_done, req);
+	ret = caam_jr_enqueue(ctx->jr, desc, aead_decrypt_done, req);
 	if (!ret) {
 		ret = -EINPROGRESS;
 	} else {
@@ -1565,7 +1569,7 @@ static int aead_encrypt(struct aead_request *req)
 	struct aead_edesc *edesc;
 	struct crypto_aead *aead = crypto_aead_reqtfm(req);
 	struct caam_ctx *ctx = crypto_aead_ctx(aead);
-	struct device *jrdev = ctx->jrdev;
+	struct device *jrdev = ctx->jr->dev;
 	bool all_contig;
 	u32 *desc;
 	int ret = 0;
@@ -1584,7 +1588,7 @@ static int aead_encrypt(struct aead_request *req)
 			     desc_bytes(edesc->hw_desc), 1);
 
 	desc = edesc->hw_desc;
-	ret = caam_jr_enqueue(jrdev, desc, aead_encrypt_done, req);
+	ret = caam_jr_enqueue(ctx->jr, desc, aead_encrypt_done, req);
 	if (!ret) {
 		ret = -EINPROGRESS;
 	} else {
@@ -1600,7 +1604,7 @@ static int gcm_decrypt(struct aead_request *req)
 	struct aead_edesc *edesc;
 	struct crypto_aead *aead = crypto_aead_reqtfm(req);
 	struct caam_ctx *ctx = crypto_aead_ctx(aead);
-	struct device *jrdev = ctx->jrdev;
+	struct device *jrdev = ctx->jr->dev;
 	bool all_contig;
 	u32 *desc;
 	int ret = 0;
@@ -1618,7 +1622,7 @@ static int gcm_decrypt(struct aead_request *req)
 			     desc_bytes(edesc->hw_desc), 1);
 
 	desc = edesc->hw_desc;
-	ret = caam_jr_enqueue(jrdev, desc, aead_decrypt_done, req);
+	ret = caam_jr_enqueue(ctx->jr, desc, aead_decrypt_done, req);
 	if (!ret) {
 		ret = -EINPROGRESS;
 	} else {
@@ -1639,7 +1643,7 @@ static int aead_decrypt(struct aead_request *req)
 	struct aead_edesc *edesc;
 	struct crypto_aead *aead = crypto_aead_reqtfm(req);
 	struct caam_ctx *ctx = crypto_aead_ctx(aead);
-	struct device *jrdev = ctx->jrdev;
+	struct device *jrdev = ctx->jr->dev;
 	bool all_contig;
 	u32 *desc;
 	int ret = 0;
@@ -1662,7 +1666,7 @@ static int aead_decrypt(struct aead_request *req)
 			     desc_bytes(edesc->hw_desc), 1);
 
 	desc = edesc->hw_desc;
-	ret = caam_jr_enqueue(jrdev, desc, aead_decrypt_done, req);
+	ret = caam_jr_enqueue(ctx->jr, desc, aead_decrypt_done, req);
 	if (!ret) {
 		ret = -EINPROGRESS;
 	} else {
@@ -1681,7 +1685,7 @@ static struct skcipher_edesc *skcipher_edesc_alloc(struct skcipher_request *req,
 {
 	struct crypto_skcipher *skcipher = crypto_skcipher_reqtfm(req);
 	struct caam_ctx *ctx = crypto_skcipher_ctx(skcipher);
-	struct device *jrdev = ctx->jrdev;
+	struct device *jrdev = ctx->jr->dev;
 	gfp_t flags = (req->base.flags & CRYPTO_TFM_REQ_MAY_SLEEP) ?
 		       GFP_KERNEL : GFP_ATOMIC;
 	int src_nents, mapped_src_nents, dst_nents = 0, mapped_dst_nents = 0;
@@ -1839,7 +1843,7 @@ static int skcipher_encrypt(struct skcipher_request *req)
 	struct skcipher_edesc *edesc;
 	struct crypto_skcipher *skcipher = crypto_skcipher_reqtfm(req);
 	struct caam_ctx *ctx = crypto_skcipher_ctx(skcipher);
-	struct device *jrdev = ctx->jrdev;
+	struct device *jrdev = ctx->jr->dev;
 	u32 *desc;
 	int ret = 0;
 
@@ -1859,7 +1863,7 @@ static int skcipher_encrypt(struct skcipher_request *req)
 			     desc_bytes(edesc->hw_desc), 1);
 
 	desc = edesc->hw_desc;
-	ret = caam_jr_enqueue(jrdev, desc, skcipher_encrypt_done, req);
+	ret = caam_jr_enqueue(ctx->jr, desc, skcipher_encrypt_done, req);
 
 	if (!ret) {
 		ret = -EINPROGRESS;
@@ -1876,7 +1880,7 @@ static int skcipher_decrypt(struct skcipher_request *req)
 	struct skcipher_edesc *edesc;
 	struct crypto_skcipher *skcipher = crypto_skcipher_reqtfm(req);
 	struct caam_ctx *ctx = crypto_skcipher_ctx(skcipher);
-	struct device *jrdev = ctx->jrdev;
+	struct device *jrdev = ctx->jr->dev;
 	u32 *desc;
 	int ret = 0;
 
@@ -1896,7 +1900,7 @@ static int skcipher_decrypt(struct skcipher_request *req)
 			     DUMP_PREFIX_ADDRESS, 16, 4, edesc->hw_desc,
 			     desc_bytes(edesc->hw_desc), 1);
 
-	ret = caam_jr_enqueue(jrdev, desc, skcipher_decrypt_done, req);
+	ret = caam_jr_enqueue(ctx->jr, desc, skcipher_decrypt_done, req);
 	if (!ret) {
 		ret = -EINPROGRESS;
 	} else {
@@ -3411,25 +3415,25 @@ static int caam_init_common(struct caam_ctx *ctx, struct caam_alg_entry *caam,
 	dma_addr_t dma_addr;
 	struct caam_drv_private *priv;
 
-	ctx->jrdev = caam_jr_alloc();
-	if (IS_ERR(ctx->jrdev)) {
+	ctx->jr = caam_jr_alloc();
+	if (IS_ERR(ctx->jr)) {
 		pr_err("Job Ring Device allocation for transform failed\n");
-		return PTR_ERR(ctx->jrdev);
+		return PTR_ERR(ctx->jr);
 	}
 
-	priv = dev_get_drvdata(ctx->jrdev->parent);
+	priv = dev_get_drvdata(ctx->jr->dev->parent);
 	if (priv->era >= 6 && uses_dkp)
 		ctx->dir = DMA_BIDIRECTIONAL;
 	else
 		ctx->dir = DMA_TO_DEVICE;
 
-	dma_addr = dma_map_single_attrs(ctx->jrdev, ctx->sh_desc_enc,
+	dma_addr = dma_map_single_attrs(ctx->jr->dev, ctx->sh_desc_enc,
 					offsetof(struct caam_ctx,
 						 sh_desc_enc_dma),
 					ctx->dir, DMA_ATTR_SKIP_CPU_SYNC);
-	if (dma_mapping_error(ctx->jrdev, dma_addr)) {
-		dev_err(ctx->jrdev, "unable to map key, shared descriptors\n");
-		caam_jr_free(ctx->jrdev);
+	if (dma_mapping_error(ctx->jr->dev, dma_addr)) {
+		dev_err(ctx->jr->dev, "unable to map key, shared descriptors\n");
+		caam_jr_free(ctx->jr);
 		return -ENOMEM;
 	}
 
@@ -3467,10 +3471,10 @@ static int caam_aead_init(struct crypto_aead *tfm)
 
 static void caam_exit_common(struct caam_ctx *ctx)
 {
-	dma_unmap_single_attrs(ctx->jrdev, ctx->sh_desc_enc_dma,
+	dma_unmap_single_attrs(ctx->jr->dev, ctx->sh_desc_enc_dma,
 			       offsetof(struct caam_ctx, sh_desc_enc_dma),
 			       ctx->dir, DMA_ATTR_SKIP_CPU_SYNC);
-	caam_jr_free(ctx->jrdev);
+	caam_jr_free(ctx->jr);
 }
 
 static void caam_cra_exit(struct crypto_skcipher *tfm)
diff --git a/drivers/crypto/caam/caamalg_qi.c b/drivers/crypto/caam/caamalg_qi.c
index 8e3449670d2f..31bee401f9e5 100644
--- a/drivers/crypto/caam/caamalg_qi.c
+++ b/drivers/crypto/caam/caamalg_qi.c
@@ -55,7 +55,7 @@ struct caam_skcipher_alg {
  * per-session context
  */
 struct caam_ctx {
-	struct device *jrdev;
+	struct caam_drv_private_jr *jr;
 	u32 sh_desc_enc[DESC_MAX_USED_LEN];
 	u32 sh_desc_dec[DESC_MAX_USED_LEN];
 	u8 key[CAAM_MAX_KEY_SIZE];
@@ -2423,10 +2423,10 @@ static int caam_init_common(struct caam_ctx *ctx, struct caam_alg_entry *caam,
 	 * distribute tfms across job rings to ensure in-order
 	 * crypto request processing per tfm
 	 */
-	ctx->jrdev = caam_jr_alloc();
-	if (IS_ERR(ctx->jrdev)) {
+	ctx->jr = caam_jr_alloc();
+	if (IS_ERR(ctx->jr)) {
 		pr_err("Job Ring Device allocation for transform failed\n");
-		return PTR_ERR(ctx->jrdev);
+		return PTR_ERR(ctx->jr);
 	}
 
 	dev = ctx->jrdev->parent;
diff --git a/drivers/crypto/caam/caamhash.c b/drivers/crypto/caam/caamhash.c
index 65399cb2a770..6e4fd5eb833a 100644
--- a/drivers/crypto/caam/caamhash.c
+++ b/drivers/crypto/caam/caamhash.c
@@ -97,7 +97,7 @@ struct caam_hash_ctx {
 	dma_addr_t sh_desc_digest_dma;
 	enum dma_data_direction dir;
 	enum dma_data_direction key_dir;
-	struct device *jrdev;
+	struct caam_drv_private_jr *jr;
 	int ctx_len;
 	struct alginfo adata;
 };
@@ -223,7 +223,7 @@ static int ahash_set_sh_desc(struct crypto_ahash *ahash)
 {
 	struct caam_hash_ctx *ctx = crypto_ahash_ctx(ahash);
 	int digestsize = crypto_ahash_digestsize(ahash);
-	struct device *jrdev = ctx->jrdev;
+	struct device *jrdev = ctx->jr->dev;
 	struct caam_drv_private *ctrlpriv = dev_get_drvdata(jrdev->parent);
 	u32 *desc;
 
@@ -279,7 +279,7 @@ static int axcbc_set_sh_desc(struct crypto_ahash *ahash)
 {
 	struct caam_hash_ctx *ctx = crypto_ahash_ctx(ahash);
 	int digestsize = crypto_ahash_digestsize(ahash);
-	struct device *jrdev = ctx->jrdev;
+	struct device *jrdev = ctx->jr->dev;
 	u32 *desc;
 
 	/* shared descriptor for ahash_update */
@@ -331,7 +331,7 @@ static int acmac_set_sh_desc(struct crypto_ahash *ahash)
 {
 	struct caam_hash_ctx *ctx = crypto_ahash_ctx(ahash);
 	int digestsize = crypto_ahash_digestsize(ahash);
-	struct device *jrdev = ctx->jrdev;
+	struct device *jrdev = ctx->jr->dev;
 	u32 *desc;
 
 	/* shared descriptor for ahash_update */
@@ -381,7 +381,7 @@ static int acmac_set_sh_desc(struct crypto_ahash *ahash)
 static int hash_digest_key(struct caam_hash_ctx *ctx, u32 *keylen, u8 *key,
 			   u32 digestsize)
 {
-	struct device *jrdev = ctx->jrdev;
+	struct device *jrdev = ctx->jr->dev;
 	u32 *desc;
 	struct split_key_result result;
 	dma_addr_t key_dma;
@@ -421,7 +421,7 @@ static int hash_digest_key(struct caam_hash_ctx *ctx, u32 *keylen, u8 *key,
 	result.err = 0;
 	init_completion(&result.completion);
 
-	ret = caam_jr_enqueue(jrdev, desc, split_key_done, &result);
+	ret = caam_jr_enqueue(ctx->jr, desc, split_key_done, &result);
 	if (!ret) {
 		/* in progress */
 		wait_for_completion(&result.completion);
@@ -444,10 +444,10 @@ static int ahash_setkey(struct crypto_ahash *ahash,
 			const u8 *key, unsigned int keylen)
 {
 	struct caam_hash_ctx *ctx = crypto_ahash_ctx(ahash);
-	struct device *jrdev = ctx->jrdev;
+	struct device *jrdev = ctx->jr->dev;
 	int blocksize = crypto_tfm_alg_blocksize(&ahash->base);
 	int digestsize = crypto_ahash_digestsize(ahash);
-	struct caam_drv_private *ctrlpriv = dev_get_drvdata(ctx->jrdev->parent);
+	struct caam_drv_private *ctrlpriv = dev_get_drvdata(jrdev->parent);
 	int ret;
 	u8 *hashed_key = NULL;
 
@@ -485,12 +485,12 @@ static int ahash_setkey(struct crypto_ahash *ahash,
 		 * virtual and dma key addresses are needed.
 		 */
 		if (keylen > ctx->adata.keylen_pad)
-			dma_sync_single_for_device(ctx->jrdev,
+			dma_sync_single_for_device(jrdev,
 						   ctx->adata.key_dma,
 						   ctx->adata.keylen_pad,
 						   DMA_TO_DEVICE);
 	} else {
-		ret = gen_split_key(ctx->jrdev, ctx->key, &ctx->adata, key,
+		ret = gen_split_key(ctx->jr, ctx->key, &ctx->adata, key,
 				    keylen, CAAM_MAX_HASH_KEY_SIZE);
 		if (ret)
 			goto bad_free_key;
@@ -508,7 +508,7 @@ static int axcbc_setkey(struct crypto_ahash *ahash, const u8 *key,
 			unsigned int keylen)
 {
 	struct caam_hash_ctx *ctx = crypto_ahash_ctx(ahash);
-	struct device *jrdev = ctx->jrdev;
+	struct device *jrdev = ctx->jr->dev;
 
 	if (keylen != AES_KEYSIZE_128) {
 		crypto_ahash_set_flags(ahash, CRYPTO_TFM_RES_BAD_KEY_LEN);
@@ -597,9 +597,10 @@ static inline void ahash_unmap_ctx(struct device *dev,
 	ahash_unmap(dev, edesc, req, dst_len);
 }
 
-static void ahash_done(struct device *jrdev, u32 *desc, u32 err,
+static void ahash_done(struct caam_drv_private_jr *jr, u32 *desc, u32 err,
 		       void *context)
 {
+	struct device *jrdev = jr->dev;
 	struct ahash_request *req = context;
 	struct ahash_edesc *edesc;
 	struct crypto_ahash *ahash = crypto_ahash_reqtfm(req);
@@ -625,8 +626,8 @@ static void ahash_done(struct device *jrdev, u32 *desc, u32 err,
 	req->base.complete(&req->base, ecode);
 }
 
-static void ahash_done_bi(struct device *jrdev, u32 *desc, u32 err,
-			    void *context)
+static void ahash_done_bi(struct caam_drv_private_jr *jr, u32 *desc, u32 err,
+			  void *context)
 {
 	struct ahash_request *req = context;
 	struct ahash_edesc *edesc;
@@ -634,6 +635,7 @@ static void ahash_done_bi(struct device *jrdev, u32 *desc, u32 err,
 	struct caam_hash_ctx *ctx = crypto_ahash_ctx(ahash);
 	struct caam_hash_state *state = ahash_request_ctx(req);
 	int digestsize = crypto_ahash_digestsize(ahash);
+	struct device *jrdev = jr->dev;
 	int ecode = 0;
 
 	dev_dbg(jrdev, "%s %d: err 0x%x\n", __func__, __LINE__, err);
@@ -657,8 +659,8 @@ static void ahash_done_bi(struct device *jrdev, u32 *desc, u32 err,
 	req->base.complete(&req->base, ecode);
 }
 
-static void ahash_done_ctx_src(struct device *jrdev, u32 *desc, u32 err,
-			       void *context)
+static void ahash_done_ctx_src(struct caam_drv_private_jr *jr, u32 *desc,
+			       u32 err, void *context)
 {
 	struct ahash_request *req = context;
 	struct ahash_edesc *edesc;
@@ -666,6 +668,7 @@ static void ahash_done_ctx_src(struct device *jrdev, u32 *desc, u32 err,
 	int digestsize = crypto_ahash_digestsize(ahash);
 	struct caam_hash_state *state = ahash_request_ctx(req);
 	struct caam_hash_ctx *ctx = crypto_ahash_ctx(ahash);
+	struct device *jrdev = jr->dev;
 	int ecode = 0;
 
 	dev_dbg(jrdev, "%s %d: err 0x%x\n", __func__, __LINE__, err);
@@ -685,8 +688,8 @@ static void ahash_done_ctx_src(struct device *jrdev, u32 *desc, u32 err,
 	req->base.complete(&req->base, ecode);
 }
 
-static void ahash_done_ctx_dst(struct device *jrdev, u32 *desc, u32 err,
-			       void *context)
+static void ahash_done_ctx_dst(struct caam_drv_private_jr *jr, u32 *desc,
+			       u32 err, void *context)
 {
 	struct ahash_request *req = context;
 	struct ahash_edesc *edesc;
@@ -694,6 +697,7 @@ static void ahash_done_ctx_dst(struct device *jrdev, u32 *desc, u32 err,
 	struct caam_hash_ctx *ctx = crypto_ahash_ctx(ahash);
 	struct caam_hash_state *state = ahash_request_ctx(req);
 	int digestsize = crypto_ahash_digestsize(ahash);
+	struct device *jrdev = jr->dev;
 	int ecode = 0;
 
 	dev_dbg(jrdev, "%s %d: err 0x%x\n", __func__, __LINE__, err);
@@ -731,7 +735,7 @@ static struct ahash_edesc *ahash_edesc_alloc(struct caam_hash_ctx *ctx,
 
 	edesc = kzalloc(sizeof(*edesc) + sg_size, GFP_DMA | flags);
 	if (!edesc) {
-		dev_err(ctx->jrdev, "could not allocate extended descriptor\n");
+		dev_err(ctx->jr->dev, "could not allocate extended descriptor\n");
 		return NULL;
 	}
 
@@ -747,6 +751,7 @@ static int ahash_edesc_add_src(struct caam_hash_ctx *ctx,
 			       unsigned int first_sg,
 			       unsigned int first_bytes, size_t to_hash)
 {
+	struct device *jrdev = ctx->jr->dev;
 	dma_addr_t src_dma;
 	u32 options;
 
@@ -757,9 +762,9 @@ static int ahash_edesc_add_src(struct caam_hash_ctx *ctx,
 
 		sg_to_sec4_sg_last(req->src, to_hash, sg + first_sg, 0);
 
-		src_dma = dma_map_single(ctx->jrdev, sg, sgsize, DMA_TO_DEVICE);
-		if (dma_mapping_error(ctx->jrdev, src_dma)) {
-			dev_err(ctx->jrdev, "unable to map S/G table\n");
+		src_dma = dma_map_single(jrdev, sg, sgsize, DMA_TO_DEVICE);
+		if (dma_mapping_error(jrdev, src_dma)) {
+			dev_err(jrdev, "unable to map S/G table\n");
 			return -ENOMEM;
 		}
 
@@ -783,7 +788,7 @@ static int ahash_update_ctx(struct ahash_request *req)
 	struct crypto_ahash *ahash = crypto_ahash_reqtfm(req);
 	struct caam_hash_ctx *ctx = crypto_ahash_ctx(ahash);
 	struct caam_hash_state *state = ahash_request_ctx(req);
-	struct device *jrdev = ctx->jrdev;
+	struct device *jrdev = ctx->jr->dev;
 	gfp_t flags = (req->base.flags & CRYPTO_TFM_REQ_MAY_SLEEP) ?
 		       GFP_KERNEL : GFP_ATOMIC;
 	u8 *buf = current_buf(state);
@@ -892,7 +897,7 @@ static int ahash_update_ctx(struct ahash_request *req)
 				     DUMP_PREFIX_ADDRESS, 16, 4, desc,
 				     desc_bytes(desc), 1);
 
-		ret = caam_jr_enqueue(jrdev, desc, ahash_done_bi, req);
+		ret = caam_jr_enqueue(ctx->jr, desc, ahash_done_bi, req);
 		if (ret)
 			goto unmap_ctx;
 
@@ -922,7 +927,7 @@ static int ahash_final_ctx(struct ahash_request *req)
 	struct crypto_ahash *ahash = crypto_ahash_reqtfm(req);
 	struct caam_hash_ctx *ctx = crypto_ahash_ctx(ahash);
 	struct caam_hash_state *state = ahash_request_ctx(req);
-	struct device *jrdev = ctx->jrdev;
+	struct device *jrdev = ctx->jr->dev;
 	gfp_t flags = (req->base.flags & CRYPTO_TFM_REQ_MAY_SLEEP) ?
 		       GFP_KERNEL : GFP_ATOMIC;
 	int buflen = *current_buflen(state);
@@ -972,7 +977,7 @@ static int ahash_final_ctx(struct ahash_request *req)
 			     DUMP_PREFIX_ADDRESS, 16, 4, desc, desc_bytes(desc),
 			     1);
 
-	ret = caam_jr_enqueue(jrdev, desc, ahash_done_ctx_src, req);
+	ret = caam_jr_enqueue(ctx->jr, desc, ahash_done_ctx_src, req);
 	if (ret)
 		goto unmap_ctx;
 
@@ -988,7 +993,7 @@ static int ahash_finup_ctx(struct ahash_request *req)
 	struct crypto_ahash *ahash = crypto_ahash_reqtfm(req);
 	struct caam_hash_ctx *ctx = crypto_ahash_ctx(ahash);
 	struct caam_hash_state *state = ahash_request_ctx(req);
-	struct device *jrdev = ctx->jrdev;
+	struct device *jrdev = ctx->jr->dev;
 	gfp_t flags = (req->base.flags & CRYPTO_TFM_REQ_MAY_SLEEP) ?
 		       GFP_KERNEL : GFP_ATOMIC;
 	int buflen = *current_buflen(state);
@@ -1052,7 +1057,7 @@ static int ahash_finup_ctx(struct ahash_request *req)
 			     DUMP_PREFIX_ADDRESS, 16, 4, desc, desc_bytes(desc),
 			     1);
 
-	ret = caam_jr_enqueue(jrdev, desc, ahash_done_ctx_src, req);
+	ret = caam_jr_enqueue(ctx->jr, desc, ahash_done_ctx_src, req);
 	if (ret)
 		goto unmap_ctx;
 
@@ -1068,7 +1073,7 @@ static int ahash_digest(struct ahash_request *req)
 	struct crypto_ahash *ahash = crypto_ahash_reqtfm(req);
 	struct caam_hash_ctx *ctx = crypto_ahash_ctx(ahash);
 	struct caam_hash_state *state = ahash_request_ctx(req);
-	struct device *jrdev = ctx->jrdev;
+	struct device *jrdev = ctx->jr->dev;
 	gfp_t flags = (req->base.flags & CRYPTO_TFM_REQ_MAY_SLEEP) ?
 		       GFP_KERNEL : GFP_ATOMIC;
 	u32 *desc;
@@ -1128,7 +1133,7 @@ static int ahash_digest(struct ahash_request *req)
 			     DUMP_PREFIX_ADDRESS, 16, 4, desc, desc_bytes(desc),
 			     1);
 
-	ret = caam_jr_enqueue(jrdev, desc, ahash_done, req);
+	ret = caam_jr_enqueue(ctx->jr, desc, ahash_done, req);
 	if (!ret) {
 		ret = -EINPROGRESS;
 	} else {
@@ -1145,7 +1150,7 @@ static int ahash_final_no_ctx(struct ahash_request *req)
 	struct crypto_ahash *ahash = crypto_ahash_reqtfm(req);
 	struct caam_hash_ctx *ctx = crypto_ahash_ctx(ahash);
 	struct caam_hash_state *state = ahash_request_ctx(req);
-	struct device *jrdev = ctx->jrdev;
+	struct device *jrdev = ctx->jr->dev;
 	gfp_t flags = (req->base.flags & CRYPTO_TFM_REQ_MAY_SLEEP) ?
 		       GFP_KERNEL : GFP_ATOMIC;
 	u8 *buf = current_buf(state);
@@ -1182,7 +1187,7 @@ static int ahash_final_no_ctx(struct ahash_request *req)
 			     DUMP_PREFIX_ADDRESS, 16, 4, desc, desc_bytes(desc),
 			     1);
 
-	ret = caam_jr_enqueue(jrdev, desc, ahash_done, req);
+	ret = caam_jr_enqueue(ctx->jr, desc, ahash_done, req);
 	if (!ret) {
 		ret = -EINPROGRESS;
 	} else {
@@ -1204,7 +1209,7 @@ static int ahash_update_no_ctx(struct ahash_request *req)
 	struct crypto_ahash *ahash = crypto_ahash_reqtfm(req);
 	struct caam_hash_ctx *ctx = crypto_ahash_ctx(ahash);
 	struct caam_hash_state *state = ahash_request_ctx(req);
-	struct device *jrdev = ctx->jrdev;
+	struct device *jrdev = ctx->jr->dev;
 	gfp_t flags = (req->base.flags & CRYPTO_TFM_REQ_MAY_SLEEP) ?
 		       GFP_KERNEL : GFP_ATOMIC;
 	u8 *buf = current_buf(state);
@@ -1305,7 +1310,7 @@ static int ahash_update_no_ctx(struct ahash_request *req)
 				     DUMP_PREFIX_ADDRESS, 16, 4, desc,
 				     desc_bytes(desc), 1);
 
-		ret = caam_jr_enqueue(jrdev, desc, ahash_done_ctx_dst, req);
+		ret = caam_jr_enqueue(ctx->jr, desc, ahash_done_ctx_dst, req);
 		if (ret)
 			goto unmap_ctx;
 
@@ -1339,7 +1344,7 @@ static int ahash_finup_no_ctx(struct ahash_request *req)
 	struct crypto_ahash *ahash = crypto_ahash_reqtfm(req);
 	struct caam_hash_ctx *ctx = crypto_ahash_ctx(ahash);
 	struct caam_hash_state *state = ahash_request_ctx(req);
-	struct device *jrdev = ctx->jrdev;
+	struct device *jrdev = ctx->jr->dev;
 	gfp_t flags = (req->base.flags & CRYPTO_TFM_REQ_MAY_SLEEP) ?
 		       GFP_KERNEL : GFP_ATOMIC;
 	int buflen = *current_buflen(state);
@@ -1403,7 +1408,7 @@ static int ahash_finup_no_ctx(struct ahash_request *req)
 			     DUMP_PREFIX_ADDRESS, 16, 4, desc, desc_bytes(desc),
 			     1);
 
-	ret = caam_jr_enqueue(jrdev, desc, ahash_done, req);
+	ret = caam_jr_enqueue(ctx->jr, desc, ahash_done, req);
 	if (!ret) {
 		ret = -EINPROGRESS;
 	} else {
@@ -1425,7 +1430,7 @@ static int ahash_update_first(struct ahash_request *req)
 	struct crypto_ahash *ahash = crypto_ahash_reqtfm(req);
 	struct caam_hash_ctx *ctx = crypto_ahash_ctx(ahash);
 	struct caam_hash_state *state = ahash_request_ctx(req);
-	struct device *jrdev = ctx->jrdev;
+	struct device *jrdev = ctx->jr->dev;
 	gfp_t flags = (req->base.flags & CRYPTO_TFM_REQ_MAY_SLEEP) ?
 		       GFP_KERNEL : GFP_ATOMIC;
 	u8 *next_buf = alt_buf(state);
@@ -1505,7 +1510,7 @@ static int ahash_update_first(struct ahash_request *req)
 				     DUMP_PREFIX_ADDRESS, 16, 4, desc,
 				     desc_bytes(desc), 1);
 
-		ret = caam_jr_enqueue(jrdev, desc, ahash_done_ctx_dst, req);
+		ret = caam_jr_enqueue(ctx->jr, desc, ahash_done_ctx_dst, req);
 		if (ret)
 			goto unmap_ctx;
 
@@ -1828,13 +1833,13 @@ static int caam_hash_cra_init(struct crypto_tfm *tfm)
 	 * Get a Job ring from Job Ring driver to ensure in-order
 	 * crypto request processing per tfm
 	 */
-	ctx->jrdev = caam_jr_alloc();
-	if (IS_ERR(ctx->jrdev)) {
+	ctx->jr = caam_jr_alloc();
+	if (IS_ERR(ctx->jr)) {
 		pr_err("Job Ring Device allocation for transform failed\n");
-		return PTR_ERR(ctx->jrdev);
+		return PTR_ERR(ctx->jr);
 	}
 
-	priv = dev_get_drvdata(ctx->jrdev->parent);
+	priv = dev_get_drvdata(ctx->jr->dev->parent);
 
 	if (is_xcbc_aes(caam_hash->alg_type)) {
 		ctx->dir = DMA_TO_DEVICE;
@@ -1861,30 +1866,32 @@ static int caam_hash_cra_init(struct crypto_tfm *tfm)
 	}
 
 	if (ctx->key_dir != DMA_NONE) {
-		ctx->adata.key_dma = dma_map_single_attrs(ctx->jrdev, ctx->key,
+		ctx->adata.key_dma = dma_map_single_attrs(ctx->jr->dev,
+							  ctx->key,
 							  ARRAY_SIZE(ctx->key),
 							  ctx->key_dir,
 							  DMA_ATTR_SKIP_CPU_SYNC);
-		if (dma_mapping_error(ctx->jrdev, ctx->adata.key_dma)) {
-			dev_err(ctx->jrdev, "unable to map key\n");
-			caam_jr_free(ctx->jrdev);
+		if (dma_mapping_error(ctx->jr->dev, ctx->adata.key_dma)) {
+			dev_err(ctx->jr->dev, "unable to map key\n");
+			caam_jr_free(ctx->jr);
 			return -ENOMEM;
 		}
 	}
 
-	dma_addr = dma_map_single_attrs(ctx->jrdev, ctx->sh_desc_update,
+	dma_addr = dma_map_single_attrs(ctx->jr->dev, ctx->sh_desc_update,
 					offsetof(struct caam_hash_ctx, key),
 					ctx->dir, DMA_ATTR_SKIP_CPU_SYNC);
-	if (dma_mapping_error(ctx->jrdev, dma_addr)) {
-		dev_err(ctx->jrdev, "unable to map shared descriptors\n");
+	if (dma_mapping_error(ctx->jr->dev, dma_addr)) {
+		dev_err(ctx->jr->dev, "unable to map shared descriptors\n");
 
 		if (ctx->key_dir != DMA_NONE)
-			dma_unmap_single_attrs(ctx->jrdev, ctx->adata.key_dma,
+			dma_unmap_single_attrs(ctx->jr->dev,
+					       ctx->adata.key_dma,
 					       ARRAY_SIZE(ctx->key),
 					       ctx->key_dir,
 					       DMA_ATTR_SKIP_CPU_SYNC);
 
-		caam_jr_free(ctx->jrdev);
+		caam_jr_free(ctx->jr);
 		return -ENOMEM;
 	}
 
@@ -1911,14 +1918,14 @@ static void caam_hash_cra_exit(struct crypto_tfm *tfm)
 {
 	struct caam_hash_ctx *ctx = crypto_tfm_ctx(tfm);
 
-	dma_unmap_single_attrs(ctx->jrdev, ctx->sh_desc_update_dma,
+	dma_unmap_single_attrs(ctx->jr->dev, ctx->sh_desc_update_dma,
 			       offsetof(struct caam_hash_ctx, key),
 			       ctx->dir, DMA_ATTR_SKIP_CPU_SYNC);
 	if (ctx->key_dir != DMA_NONE)
-		dma_unmap_single_attrs(ctx->jrdev, ctx->adata.key_dma,
+		dma_unmap_single_attrs(ctx->jr->dev, ctx->adata.key_dma,
 				       ARRAY_SIZE(ctx->key), ctx->key_dir,
 				       DMA_ATTR_SKIP_CPU_SYNC);
-	caam_jr_free(ctx->jrdev);
+	caam_jr_free(ctx->jr);
 }
 
 void caam_algapi_hash_exit(void)
diff --git a/drivers/crypto/caam/caampkc.c b/drivers/crypto/caam/caampkc.c
index 6619c512ef1a..8f2abd636aff 100644
--- a/drivers/crypto/caam/caampkc.c
+++ b/drivers/crypto/caam/caampkc.c
@@ -114,8 +114,10 @@ static void rsa_priv_f3_unmap(struct device *dev, struct rsa_edesc *edesc,
 }
 
 /* RSA Job Completion handler */
-static void rsa_pub_done(struct device *dev, u32 *desc, u32 err, void *context)
+static void rsa_pub_done(struct caam_drv_private_jr *jr, u32 *desc, u32 err,
+			 void *context)
 {
+	struct device *dev = jr->dev;
 	struct akcipher_request *req = context;
 	struct rsa_edesc *edesc;
 	int ecode = 0;
@@ -132,9 +134,10 @@ static void rsa_pub_done(struct device *dev, u32 *desc, u32 err, void *context)
 	akcipher_request_complete(req, ecode);
 }
 
-static void rsa_priv_f1_done(struct device *dev, u32 *desc, u32 err,
-			     void *context)
+static void rsa_priv_f1_done(struct caam_drv_private_jr *jr, u32 *desc,
+			     u32 err, void *context)
 {
+	struct device *dev = jr->dev;
 	struct akcipher_request *req = context;
 	struct rsa_edesc *edesc;
 	int ecode = 0;
@@ -151,9 +154,10 @@ static void rsa_priv_f1_done(struct device *dev, u32 *desc, u32 err,
 	akcipher_request_complete(req, ecode);
 }
 
-static void rsa_priv_f2_done(struct device *dev, u32 *desc, u32 err,
-			     void *context)
+static void rsa_priv_f2_done(struct caam_drv_private_jr *jr, u32 *desc,
+			     u32 err, void *context)
 {
+	struct device *dev = jr->dev;
 	struct akcipher_request *req = context;
 	struct rsa_edesc *edesc;
 	int ecode = 0;
@@ -170,9 +174,10 @@ static void rsa_priv_f2_done(struct device *dev, u32 *desc, u32 err,
 	akcipher_request_complete(req, ecode);
 }
 
-static void rsa_priv_f3_done(struct device *dev, u32 *desc, u32 err,
-			     void *context)
+static void rsa_priv_f3_done(struct caam_drv_private_jr *jr, u32 *desc,
+			     u32 err, void *context)
 {
+	struct device *dev = jr->dev;
 	struct akcipher_request *req = context;
 	struct rsa_edesc *edesc;
 	int ecode = 0;
@@ -245,7 +250,7 @@ static struct rsa_edesc *rsa_edesc_alloc(struct akcipher_request *req,
 {
 	struct crypto_akcipher *tfm = crypto_akcipher_reqtfm(req);
 	struct caam_rsa_ctx *ctx = akcipher_tfm_ctx(tfm);
-	struct device *dev = ctx->dev;
+	struct device *dev = ctx->jr->dev;
 	struct caam_rsa_req_ctx *req_ctx = akcipher_request_ctx(req);
 	struct caam_rsa_key *key = &ctx->key;
 	struct rsa_edesc *edesc;
@@ -371,7 +376,7 @@ static int set_rsa_pub_pdb(struct akcipher_request *req,
 	struct caam_rsa_req_ctx *req_ctx = akcipher_request_ctx(req);
 	struct caam_rsa_ctx *ctx = akcipher_tfm_ctx(tfm);
 	struct caam_rsa_key *key = &ctx->key;
-	struct device *dev = ctx->dev;
+	struct device *dev = ctx->jr->dev;
 	struct rsa_pub_pdb *pdb = &edesc->pdb.pub;
 	int sec4_sg_index = 0;
 
@@ -416,7 +421,7 @@ static int set_rsa_priv_f1_pdb(struct akcipher_request *req,
 	struct crypto_akcipher *tfm = crypto_akcipher_reqtfm(req);
 	struct caam_rsa_ctx *ctx = akcipher_tfm_ctx(tfm);
 	struct caam_rsa_key *key = &ctx->key;
-	struct device *dev = ctx->dev;
+	struct device *dev = ctx->jr->dev;
 	struct rsa_priv_f1_pdb *pdb = &edesc->pdb.priv_f1;
 	int sec4_sg_index = 0;
 
@@ -463,7 +468,7 @@ static int set_rsa_priv_f2_pdb(struct akcipher_request *req,
 	struct crypto_akcipher *tfm = crypto_akcipher_reqtfm(req);
 	struct caam_rsa_ctx *ctx = akcipher_tfm_ctx(tfm);
 	struct caam_rsa_key *key = &ctx->key;
-	struct device *dev = ctx->dev;
+	struct device *dev = ctx->jr->dev;
 	struct rsa_priv_f2_pdb *pdb = &edesc->pdb.priv_f2;
 	int sec4_sg_index = 0;
 	size_t p_sz = key->p_sz;
@@ -540,7 +545,7 @@ static int set_rsa_priv_f3_pdb(struct akcipher_request *req,
 	struct crypto_akcipher *tfm = crypto_akcipher_reqtfm(req);
 	struct caam_rsa_ctx *ctx = akcipher_tfm_ctx(tfm);
 	struct caam_rsa_key *key = &ctx->key;
-	struct device *dev = ctx->dev;
+	struct device *dev = ctx->jr->dev;
 	struct rsa_priv_f3_pdb *pdb = &edesc->pdb.priv_f3;
 	int sec4_sg_index = 0;
 	size_t p_sz = key->p_sz;
@@ -632,7 +637,7 @@ static int caam_rsa_enc(struct akcipher_request *req)
 	struct crypto_akcipher *tfm = crypto_akcipher_reqtfm(req);
 	struct caam_rsa_ctx *ctx = akcipher_tfm_ctx(tfm);
 	struct caam_rsa_key *key = &ctx->key;
-	struct device *jrdev = ctx->dev;
+	struct device *jrdev = ctx->jr->dev;
 	struct rsa_edesc *edesc;
 	int ret;
 
@@ -658,7 +663,7 @@ static int caam_rsa_enc(struct akcipher_request *req)
 	/* Initialize Job Descriptor */
 	init_rsa_pub_desc(edesc->hw_desc, &edesc->pdb.pub);
 
-	ret = caam_jr_enqueue(jrdev, edesc->hw_desc, rsa_pub_done, req);
+	ret = caam_jr_enqueue(ctx->jr, edesc->hw_desc, rsa_pub_done, req);
 	if (!ret)
 		return -EINPROGRESS;
 
@@ -674,7 +679,7 @@ static int caam_rsa_dec_priv_f1(struct akcipher_request *req)
 {
 	struct crypto_akcipher *tfm = crypto_akcipher_reqtfm(req);
 	struct caam_rsa_ctx *ctx = akcipher_tfm_ctx(tfm);
-	struct device *jrdev = ctx->dev;
+	struct device *jrdev = ctx->jr->dev;
 	struct rsa_edesc *edesc;
 	int ret;
 
@@ -691,7 +696,7 @@ static int caam_rsa_dec_priv_f1(struct akcipher_request *req)
 	/* Initialize Job Descriptor */
 	init_rsa_priv_f1_desc(edesc->hw_desc, &edesc->pdb.priv_f1);
 
-	ret = caam_jr_enqueue(jrdev, edesc->hw_desc, rsa_priv_f1_done, req);
+	ret = caam_jr_enqueue(ctx->jr, edesc->hw_desc, rsa_priv_f1_done, req);
 	if (!ret)
 		return -EINPROGRESS;
 
@@ -707,7 +712,7 @@ static int caam_rsa_dec_priv_f2(struct akcipher_request *req)
 {
 	struct crypto_akcipher *tfm = crypto_akcipher_reqtfm(req);
 	struct caam_rsa_ctx *ctx = akcipher_tfm_ctx(tfm);
-	struct device *jrdev = ctx->dev;
+	struct device *jrdev = ctx->jr->dev;
 	struct rsa_edesc *edesc;
 	int ret;
 
@@ -724,7 +729,7 @@ static int caam_rsa_dec_priv_f2(struct akcipher_request *req)
 	/* Initialize Job Descriptor */
 	init_rsa_priv_f2_desc(edesc->hw_desc, &edesc->pdb.priv_f2);
 
-	ret = caam_jr_enqueue(jrdev, edesc->hw_desc, rsa_priv_f2_done, req);
+	ret = caam_jr_enqueue(ctx->jr, edesc->hw_desc, rsa_priv_f2_done, req);
 	if (!ret)
 		return -EINPROGRESS;
 
@@ -740,7 +745,7 @@ static int caam_rsa_dec_priv_f3(struct akcipher_request *req)
 {
 	struct crypto_akcipher *tfm = crypto_akcipher_reqtfm(req);
 	struct caam_rsa_ctx *ctx = akcipher_tfm_ctx(tfm);
-	struct device *jrdev = ctx->dev;
+	struct device *jrdev = ctx->jr->dev;
 	struct rsa_edesc *edesc;
 	int ret;
 
@@ -757,7 +762,7 @@ static int caam_rsa_dec_priv_f3(struct akcipher_request *req)
 	/* Initialize Job Descriptor */
 	init_rsa_priv_f3_desc(edesc->hw_desc, &edesc->pdb.priv_f3);
 
-	ret = caam_jr_enqueue(jrdev, edesc->hw_desc, rsa_priv_f3_done, req);
+	ret = caam_jr_enqueue(ctx->jr, edesc->hw_desc, rsa_priv_f3_done, req);
 	if (!ret)
 		return -EINPROGRESS;
 
@@ -781,7 +786,7 @@ static int caam_rsa_dec(struct akcipher_request *req)
 
 	if (req->dst_len < key->n_sz) {
 		req->dst_len = key->n_sz;
-		dev_err(ctx->dev, "Output buffer length less than parameter n\n");
+		dev_err(ctx->jr->dev, "Output buffer length less than parameter n\n");
 		return -EOVERFLOW;
 	}
 
@@ -1038,19 +1043,19 @@ static int caam_rsa_init_tfm(struct crypto_akcipher *tfm)
 {
 	struct caam_rsa_ctx *ctx = akcipher_tfm_ctx(tfm);
 
-	ctx->dev = caam_jr_alloc();
+	ctx->jr = caam_jr_alloc();
 
-	if (IS_ERR(ctx->dev)) {
+	if (IS_ERR(ctx->jr)) {
 		pr_err("Job Ring Device allocation for transform failed\n");
-		return PTR_ERR(ctx->dev);
+		return PTR_ERR(ctx->jr);
 	}
 
-	ctx->padding_dma = dma_map_single(ctx->dev, zero_buffer,
+	ctx->padding_dma = dma_map_single(ctx->jr->dev, zero_buffer,
 					  CAAM_RSA_MAX_INPUT_SIZE - 1,
 					  DMA_TO_DEVICE);
-	if (dma_mapping_error(ctx->dev, ctx->padding_dma)) {
-		dev_err(ctx->dev, "unable to map padding\n");
-		caam_jr_free(ctx->dev);
+	if (dma_mapping_error(ctx->jr->dev, ctx->padding_dma)) {
+		dev_err(ctx->jr->dev, "unable to map padding\n");
+		caam_jr_free(ctx->jr);
 		return -ENOMEM;
 	}
 
@@ -1063,10 +1068,10 @@ static void caam_rsa_exit_tfm(struct crypto_akcipher *tfm)
 	struct caam_rsa_ctx *ctx = akcipher_tfm_ctx(tfm);
 	struct caam_rsa_key *key = &ctx->key;
 
-	dma_unmap_single(ctx->dev, ctx->padding_dma, CAAM_RSA_MAX_INPUT_SIZE -
-			 1, DMA_TO_DEVICE);
+	dma_unmap_single(ctx->jr->dev, ctx->padding_dma,
+			 CAAM_RSA_MAX_INPUT_SIZE - 1, DMA_TO_DEVICE);
 	caam_rsa_free_key(key);
-	caam_jr_free(ctx->dev);
+	caam_jr_free(ctx->jr);
 }
 
 static struct caam_akcipher_alg caam_rsa = {
diff --git a/drivers/crypto/caam/caampkc.h b/drivers/crypto/caam/caampkc.h
index c68fb4c03ee6..5cbb4ea31ce8 100644
--- a/drivers/crypto/caam/caampkc.h
+++ b/drivers/crypto/caam/caampkc.h
@@ -93,7 +93,7 @@ struct caam_rsa_key {
  */
 struct caam_rsa_ctx {
 	struct caam_rsa_key key;
-	struct device *dev;
+	struct caam_drv_private_jr *jr;
 	dma_addr_t padding_dma;
 
 };
diff --git a/drivers/crypto/caam/caamrng.c b/drivers/crypto/caam/caamrng.c
index e8baacaabe07..2527b593707b 100644
--- a/drivers/crypto/caam/caamrng.c
+++ b/drivers/crypto/caam/caamrng.c
@@ -70,7 +70,7 @@ struct buf_data {
 
 /* rng per-device context */
 struct caam_rng_ctx {
-	struct device *jrdev;
+	struct caam_drv_private_jr *jr;
 	dma_addr_t sh_desc_dma;
 	u32 sh_desc[DESC_RNG_LEN];
 	unsigned int cur_buf_idx;
@@ -95,7 +95,7 @@ static inline void rng_unmap_buf(struct device *jrdev, struct buf_data *bd)
 
 static inline void rng_unmap_ctx(struct caam_rng_ctx *ctx)
 {
-	struct device *jrdev = ctx->jrdev;
+	struct device *jrdev = ctx->jr->dev;
 
 	if (ctx->sh_desc_dma)
 		dma_unmap_single(jrdev, ctx->sh_desc_dma,
@@ -104,8 +104,10 @@ static inline void rng_unmap_ctx(struct caam_rng_ctx *ctx)
 	rng_unmap_buf(jrdev, &ctx->bufs[1]);
 }
 
-static void rng_done(struct device *jrdev, u32 *desc, u32 err, void *context)
+static void rng_done(struct caam_drv_private_jr *jr, u32 *desc, u32 err,
+		     void *context)
 {
+	struct device *jrdev = jr->dev;
 	struct buf_data *bd;
 
 	bd = container_of(desc, struct buf_data, hw_desc[0]);
@@ -126,13 +128,13 @@ static void rng_done(struct device *jrdev, u32 *desc, u32 err, void *context)
 static inline int submit_job(struct caam_rng_ctx *ctx, int to_current)
 {
 	struct buf_data *bd = &ctx->bufs[!(to_current ^ ctx->current_buf)];
-	struct device *jrdev = ctx->jrdev;
+	struct device *jrdev = ctx->jr->dev;
 	u32 *desc = bd->hw_desc;
 	int err;
 
 	dev_dbg(jrdev, "submitting job %d\n", !(to_current ^ ctx->current_buf));
 	init_completion(&bd->filled);
-	err = caam_jr_enqueue(jrdev, desc, rng_done, ctx);
+	err = caam_jr_enqueue(ctx->jr, desc, rng_done, ctx);
 	if (err)
 		complete(&bd->filled); /* don't wait on failed job*/
 	else
@@ -166,7 +168,7 @@ static int caam_read(struct hwrng *rng, void *data, size_t max, bool wait)
 	}
 
 	next_buf_idx = ctx->cur_buf_idx + max;
-	dev_dbg(ctx->jrdev, "%s: start reading at buffer %d, idx %d\n",
+	dev_dbg(ctx->jr->dev, "%s: start reading at buffer %d, idx %d\n",
 		 __func__, ctx->current_buf, ctx->cur_buf_idx);
 
 	/* if enough data in current buffer */
@@ -187,7 +189,7 @@ static int caam_read(struct hwrng *rng, void *data, size_t max, bool wait)
 
 	/* and use next buffer */
 	ctx->current_buf = !ctx->current_buf;
-	dev_dbg(ctx->jrdev, "switched to buffer %d\n", ctx->current_buf);
+	dev_dbg(ctx->jr->dev, "switched to buffer %d\n", ctx->current_buf);
 
 	/* since there already is some data read, don't wait */
 	return copied_idx + caam_read(rng, data + copied_idx,
@@ -196,7 +198,7 @@ static int caam_read(struct hwrng *rng, void *data, size_t max, bool wait)
 
 static inline int rng_create_sh_desc(struct caam_rng_ctx *ctx)
 {
-	struct device *jrdev = ctx->jrdev;
+	struct device *jrdev = ctx->jr->dev;
 	u32 *desc = ctx->sh_desc;
 
 	init_sh_desc(desc, HDR_SHARE_SERIAL);
@@ -222,7 +224,7 @@ static inline int rng_create_sh_desc(struct caam_rng_ctx *ctx)
 
 static inline int rng_create_job_desc(struct caam_rng_ctx *ctx, int buf_id)
 {
-	struct device *jrdev = ctx->jrdev;
+	struct device *jrdev = ctx->jr->dev;
 	struct buf_data *bd = &ctx->bufs[buf_id];
 	u32 *desc = bd->hw_desc;
 	int sh_len = desc_len(ctx->sh_desc);
@@ -274,11 +276,12 @@ static int caam_init_buf(struct caam_rng_ctx *ctx, int buf_id)
 	return 0;
 }
 
-static int caam_init_rng(struct caam_rng_ctx *ctx, struct device *jrdev)
+static int caam_init_rng(struct caam_rng_ctx *ctx,
+			 struct caam_drv_private_jr *jr)
 {
 	int err;
 
-	ctx->jrdev = jrdev;
+	ctx->jr = jr;
 
 	err = rng_create_sh_desc(ctx);
 	if (err)
@@ -305,14 +308,14 @@ void caam_rng_exit(void)
 	if (!init_done)
 		return;
 
-	caam_jr_free(rng_ctx->jrdev);
+	caam_jr_free(rng_ctx->jr);
 	hwrng_unregister(&caam_rng);
 	kfree(rng_ctx);
 }
 
 int caam_rng_init(struct device *ctrldev)
 {
-	struct device *dev;
+	struct caam_drv_private_jr *jr;
 	u32 rng_inst;
 	struct caam_drv_private *priv = dev_get_drvdata(ctrldev);
 	int err;
@@ -328,21 +331,21 @@ int caam_rng_init(struct device *ctrldev)
 	if (!rng_inst)
 		return 0;
 
-	dev = caam_jr_alloc();
-	if (IS_ERR(dev)) {
+	jr = caam_jr_alloc();
+	if (IS_ERR(jr)) {
 		pr_err("Job Ring Device allocation for transform failed\n");
-		return PTR_ERR(dev);
+		return PTR_ERR(jr);
 	}
 	rng_ctx = kmalloc(sizeof(*rng_ctx), GFP_DMA | GFP_KERNEL);
 	if (!rng_ctx) {
 		err = -ENOMEM;
 		goto free_caam_alloc;
 	}
-	err = caam_init_rng(rng_ctx, dev);
+	err = caam_init_rng(rng_ctx, jr);
 	if (err)
 		goto free_rng_ctx;
 
-	dev_info(dev, "registering rng-caam\n");
+	dev_info(jr->dev, "registering rng-caam\n");
 
 	err = hwrng_register(&caam_rng);
 	if (!err) {
@@ -353,6 +356,6 @@ int caam_rng_init(struct device *ctrldev)
 free_rng_ctx:
 	kfree(rng_ctx);
 free_caam_alloc:
-	caam_jr_free(dev);
+	caam_jr_free(jr);
 	return err;
 }
diff --git a/drivers/crypto/caam/jr.c b/drivers/crypto/caam/jr.c
index 3e78fedeea30..1e2929b7c6b9 100644
--- a/drivers/crypto/caam/jr.c
+++ b/drivers/crypto/caam/jr.c
@@ -265,7 +265,7 @@ static void caam_jr_dequeue(unsigned long devarg)
 		}
 
 		/* Finally, execute user's callback */
-		usercall(dev, userdesc, userstatus, userarg);
+		usercall(jrp, userdesc, userstatus, userarg);
 		outring_used--;
 	}
 
@@ -279,10 +279,9 @@ static void caam_jr_dequeue(unsigned long devarg)
  * returns :  pointer to the newly allocated physical
  *	      JobR dev can be written to if successful.
  **/
-struct device *caam_jr_alloc(void)
+struct caam_drv_private_jr *caam_jr_alloc(void)
 {
-	struct caam_drv_private_jr *jrpriv, *min_jrpriv = NULL;
-	struct device *dev = ERR_PTR(-ENODEV);
+	struct caam_drv_private_jr *jrpriv, *min_jrpriv = ERR_PTR(-ENODEV);
 	int min_tfm_cnt	= INT_MAX;
 	int tfm_cnt;
 
@@ -303,13 +302,12 @@ struct device *caam_jr_alloc(void)
 			break;
 	}
 
-	if (min_jrpriv) {
+	if (!IS_ERR(min_jrpriv))
 		atomic_inc(&min_jrpriv->tfm_count);
-		dev = min_jrpriv->dev;
-	}
+
 	spin_unlock(&driver_data.jr_alloc_lock);
 
-	return dev;
+	return min_jrpriv;
 }
 EXPORT_SYMBOL(caam_jr_alloc);
 
@@ -318,10 +316,8 @@ EXPORT_SYMBOL(caam_jr_alloc);
  * @rdev     - points to the dev that identifies the Job ring to
  *             be released.
  **/
-void caam_jr_free(struct device *rdev)
+void caam_jr_free(struct caam_drv_private_jr *jrpriv)
 {
-	struct caam_drv_private_jr *jrpriv = dev_get_drvdata(rdev);
-
 	atomic_dec(&jrpriv->tfm_count);
 }
 EXPORT_SYMBOL(caam_jr_free);
@@ -354,9 +350,10 @@ EXPORT_SYMBOL(caam_jr_free);
  * @areq: optional pointer to a user argument for use at callback
  *        time.
  **/
-int caam_jr_enqueue(struct device *dev, u32 *desc, caam_jr_cbk cbk, void *areq)
+int caam_jr_enqueue(struct caam_drv_private_jr *jrp, u32 *desc,
+		    caam_jr_cbk cbk, void *areq)
 {
-	struct caam_drv_private_jr *jrp = dev_get_drvdata(dev);
+	struct device *dev = jrp->dev;
 	struct caam_jrentry_info *head_entry;
 	int head, tail, desc_size;
 	dma_addr_t desc_dma;
diff --git a/drivers/crypto/caam/jr.h b/drivers/crypto/caam/jr.h
index 81acc6a6909f..f49caa0ac0ff 100644
--- a/drivers/crypto/caam/jr.h
+++ b/drivers/crypto/caam/jr.h
@@ -8,13 +8,15 @@
 #ifndef JR_H
 #define JR_H
 
+struct caam_drv_private_jr;
+
 /* Prototypes for backend-level services exposed to APIs */
-typedef void (*caam_jr_cbk)(struct device *dev, u32 *desc, u32 status,
-			    void *areq);
+typedef void (*caam_jr_cbk)(struct caam_drv_private_jr *jr, u32 *desc,
+			    u32 status, void *areq);
 
-struct device *caam_jr_alloc(void);
-void caam_jr_free(struct device *rdev);
-int caam_jr_enqueue(struct device *dev, u32 *desc, caam_jr_cbk cbk,
+struct caam_drv_private_jr *caam_jr_alloc(void);
+void caam_jr_free(struct caam_drv_private_jr *jr);
+int caam_jr_enqueue(struct caam_drv_private_jr *jr, u32 *desc, caam_jr_cbk cbk,
 		    void *areq);
 
 #endif /* JR_H */
diff --git a/drivers/crypto/caam/key_gen.c b/drivers/crypto/caam/key_gen.c
index 5a851ddc48fb..cabd39821176 100644
--- a/drivers/crypto/caam/key_gen.c
+++ b/drivers/crypto/caam/key_gen.c
@@ -9,12 +9,14 @@
 #include "jr.h"
 #include "error.h"
 #include "desc_constr.h"
+#include "intern.h"
 #include "key_gen.h"
 
-void split_key_done(struct device *dev, u32 *desc, u32 err,
-			   void *context)
+void split_key_done(struct caam_drv_private_jr *jr, u32 *desc, u32 err,
+		    void *context)
 {
 	struct split_key_result *res = context;
+	struct device *dev = jr->dev;
 	int ecode = 0;
 
 	dev_dbg(dev, "%s %d: err 0x%x\n", __func__, __LINE__, err);
@@ -41,11 +43,12 @@ Split key generation-----------------------------------------------
 [06] 0x64260028    fifostr: class2 mdsplit-jdk len=40
 			@0xffe04000
 */
-int gen_split_key(struct device *jrdev, u8 *key_out,
+int gen_split_key(struct caam_drv_private_jr *jr, u8 *key_out,
 		  struct alginfo * const adata, const u8 *key_in, u32 keylen,
 		  int max_keylen)
 {
 	u32 *desc;
+	struct device *jrdev = jr->dev;
 	struct split_key_result result;
 	dma_addr_t dma_addr;
 	unsigned int local_max;
@@ -107,7 +110,7 @@ int gen_split_key(struct device *jrdev, u8 *key_out,
 	result.err = 0;
 	init_completion(&result.completion);
 
-	ret = caam_jr_enqueue(jrdev, desc, split_key_done, &result);
+	ret = caam_jr_enqueue(jr, desc, split_key_done, &result);
 	if (!ret) {
 		/* in progress */
 		wait_for_completion(&result.completion);
diff --git a/drivers/crypto/caam/key_gen.h b/drivers/crypto/caam/key_gen.h
index 818f78f6fc1a..10275080f969 100644
--- a/drivers/crypto/caam/key_gen.h
+++ b/drivers/crypto/caam/key_gen.h
@@ -41,8 +41,9 @@ struct split_key_result {
 	int err;
 };
 
-void split_key_done(struct device *dev, u32 *desc, u32 err, void *context);
+void split_key_done(struct caam_drv_private_jr *jr, u32 *desc, u32 err,
+		    void *context);
 
-int gen_split_key(struct device *jrdev, u8 *key_out,
+int gen_split_key(struct caam_drv_private_jr *jr, u8 *key_out,
 		  struct alginfo * const adata, const u8 *key_in, u32 keylen,
 		  int max_keylen);
-- 
2.21.0


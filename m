Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DE8CAC4332D
	for <linux-crypto@archiver.kernel.org>; Mon,  8 Mar 2021 20:24:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B37F96527B
	for <linux-crypto@archiver.kernel.org>; Mon,  8 Mar 2021 20:24:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230486AbhCHUYD (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 8 Mar 2021 15:24:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49794 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230521AbhCHUXi (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 8 Mar 2021 15:23:38 -0500
Received: from mail-pf1-x42a.google.com (mail-pf1-x42a.google.com [IPv6:2607:f8b0:4864:20::42a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1C7BCC06174A;
        Mon,  8 Mar 2021 12:23:38 -0800 (PST)
Received: by mail-pf1-x42a.google.com with SMTP id x7so4504171pfi.7;
        Mon, 08 Mar 2021 12:23:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=UNnD5A2xjf0DDevYifsPJ2VYuM0wT2W9sk6dcoHUNL4=;
        b=LpwQa9N/yrh7ph45kpJzOFeqgEfDzUOdvwyjtcf82/ddol7mIDrDCBIllmLqXtDb6q
         +I0RU7eWMJJRKKXZlouggedcFx251KknXI8IGe2VOsSwpw4IJx71pO8CbmdfmLmHHc5n
         DLkhsQ0fjU8kq9WsMyZp3wuW128KkAHLcU153ESDVQiBpYBjN/Jr+QH1EWmPivTRjk9W
         Vxb3jtAp6MkvhS2LejNoNPYgyRzuA6NJ2on5C1OED1/ap5Z7TcbZ5LfEBJ7NDlkxxJuA
         rd1lvLokqQ5slLfGRERuImfTCRYZ+JS2ygCX423bAqDcXIqQIO8QF6Fb+eUAWadwqdX0
         yFTQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=UNnD5A2xjf0DDevYifsPJ2VYuM0wT2W9sk6dcoHUNL4=;
        b=ZmGKgdjxmuR2qH6EbCVHdvwfJqkOif+l7VLVLV/jrM/jnHHilNwWX1lVtewvFsoWt6
         9mgA8hbjJqnPopj/Z+vpoKnvgGC9nxk1FwU7hYDU+eM7pKNNuCvd5NIcPs+MuDWn/iV6
         zh+ZpOLIwbA8VBBv1TUl0HzilumuQy/PUUwamccU8MDhqrNpdk6DhnBJxESn9l0fUk77
         kQ24Ju1KgJ5RdYE02whAUm8BpHP+dDo96Tncj0uFlGiFTOqEXvH8dgq9NeJ0RnvaKz/6
         6iLiXn+BjBgFg44uN1qzPvE+txxsvFqCZMndvTH2nAL8z6PS1zPuyQZymHd/EDb2X6hC
         0n8A==
X-Gm-Message-State: AOAM530IjHjQhm1fcFsHFQ5MQiwcG0wMFEljCSih8A4h3cwPZ3uSOQrW
        6RguGhbxwK23BOd+l5RTMLI=
X-Google-Smtp-Source: ABdhPJzJs0YFonUz8B6M79/Lgl6ZyC8uw4DmtKpWHeBc1bsE7aDkR9C1DRSbwyCxmJEh6N8ya72cIQ==
X-Received: by 2002:a65:5a0a:: with SMTP id y10mr21573341pgs.122.1615235017666;
        Mon, 08 Mar 2021 12:23:37 -0800 (PST)
Received: from varodek.localdomain ([223.233.103.31])
        by smtp.gmail.com with ESMTPSA id m3sm10262962pgk.47.2021.03.08.12.23.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 08 Mar 2021 12:23:37 -0800 (PST)
From:   Vaibhav Gupta <vaibhavgupta40@gmail.com>
To:     Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Rob Herring <robh+dt@kernel.org>
Cc:     Kishon Vijay Abraham <kishon@ti.com>, Sekhar Nori <nsekhar@ti.com>,
        Lokesh Vutla <lokeshvutla@ti.com>,
        Praneeth Bajjuri <praneeth@ti.com>,
        Gowtham Tammana <g-tammana@ti.com>,
        linux-crypto@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Peter Ujfalusi <peter.ujfalusi@ti.com>,
        Vaibhav Gupta <v_gupta@ti.com>
Subject: [PATCH v1 3/3] crypto: sa2ul: Add support for AM64
Date:   Tue,  9 Mar 2021 01:50:05 +0530
Message-Id: <20210308202005.243228-4-vaibhavgupta40@gmail.com>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210308202005.243228-1-vaibhavgupta40@gmail.com>
References: <20210308202005.243228-1-vaibhavgupta40@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

From: Peter Ujfalusi <peter.ujfalusi@ti.com>

The sa2ul module in am64 have limited support for algorithms, and the
priv and priv_id used on the platform is different compared to AM654 or
j721e.

Use match data to get the SoC specific information and use it throughout
the driver.

Signed-off-by: Peter Ujfalusi <peter.ujfalusi@ti.com>
Signed-off-by: Vaibhav Gupta <v_gupta@ti.com>
---
 drivers/crypto/sa2ul.c | 131 +++++++++++++++++++++++++++++------------
 drivers/crypto/sa2ul.h |   4 ++
 2 files changed, 96 insertions(+), 39 deletions(-)

diff --git a/drivers/crypto/sa2ul.c b/drivers/crypto/sa2ul.c
index 6107bfea862d..8a17ab8af444 100644
--- a/drivers/crypto/sa2ul.c
+++ b/drivers/crypto/sa2ul.c
@@ -69,8 +69,24 @@
 /* Max Authentication tag size */
 #define SA_MAX_AUTH_TAG_SZ 64
 
-#define PRIV_ID	0x1
-#define PRIV	0x1
+enum sa_algo_id {
+	SA_ALG_CBC_AES = 0,
+	SA_ALG_EBC_AES,
+	SA_ALG_CBC_DES3,
+	SA_ALG_ECB_DES3,
+	SA_ALG_SHA1,
+	SA_ALG_SHA256,
+	SA_ALG_SHA512,
+	SA_ALG_AUTHENC_SHA1_AES,
+	SA_ALG_AUTHENC_SHA256_AES,
+};
+
+struct sa_match_data {
+	u8 priv;
+	u8 priv_id;
+	u32 supported_algos;
+	bool skip_engine_control;
+};
 
 static struct device *sa_k3_dev;
 
@@ -696,8 +712,9 @@ static void sa_dump_sc(u8 *buf, dma_addr_t dma_addr)
 }
 
 static
-int sa_init_sc(struct sa_ctx_info *ctx, const u8 *enc_key,
-	       u16 enc_key_sz, const u8 *auth_key, u16 auth_key_sz,
+int sa_init_sc(struct sa_ctx_info *ctx, const struct sa_match_data *match_data,
+	       const u8 *enc_key, u16 enc_key_sz,
+	       const u8 *auth_key, u16 auth_key_sz,
 	       struct algo_data *ad, u8 enc, u32 *swinfo)
 {
 	int enc_sc_offset = 0;
@@ -732,8 +749,8 @@ int sa_init_sc(struct sa_ctx_info *ctx, const u8 *enc_key,
 	sc_buf[SA_CTX_SCCTL_OWNER_OFFSET] = 0;
 	memcpy(&sc_buf[2], &sc_id, 2);
 	sc_buf[4] = 0x0;
-	sc_buf[5] = PRIV_ID;
-	sc_buf[6] = PRIV;
+	sc_buf[5] = match_data->priv_id;
+	sc_buf[6] = match_data->priv;
 	sc_buf[7] = 0x0;
 
 	/* Prepare context for encryption engine */
@@ -892,8 +909,8 @@ static int sa_cipher_setkey(struct crypto_skcipher *tfm, const u8 *key,
 		return ret;
 
 	/* Setup Encryption Security Context & Command label template */
-	if (sa_init_sc(&ctx->enc, key, keylen, NULL, 0, ad, 1,
-		       &ctx->enc.epib[1]))
+	if (sa_init_sc(&ctx->enc, ctx->dev_data->match_data, key, keylen, NULL, 0,
+		       ad, 1, &ctx->enc.epib[1]))
 		goto badkey;
 
 	cmdl_len = sa_format_cmdl_gen(&cfg,
@@ -905,8 +922,8 @@ static int sa_cipher_setkey(struct crypto_skcipher *tfm, const u8 *key,
 	ctx->enc.cmdl_size = cmdl_len;
 
 	/* Setup Decryption Security Context & Command label template */
-	if (sa_init_sc(&ctx->dec, key, keylen, NULL, 0, ad, 0,
-		       &ctx->dec.epib[1]))
+	if (sa_init_sc(&ctx->dec, ctx->dev_data->match_data, key, keylen, NULL, 0,
+		       ad, 0, &ctx->dec.epib[1]))
 		goto badkey;
 
 	cfg.enc_eng_id = ad->enc_eng.eng_id;
@@ -1446,9 +1463,10 @@ static int sa_sha_setup(struct sa_tfm_ctx *ctx, struct  algo_data *ad)
 	cfg.akey = NULL;
 	cfg.akey_len = 0;
 
+	ctx->dev_data = dev_get_drvdata(sa_k3_dev);
 	/* Setup Encryption Security Context & Command label template */
-	if (sa_init_sc(&ctx->enc, NULL, 0, NULL, 0, ad, 0,
-		       &ctx->enc.epib[1]))
+	if (sa_init_sc(&ctx->enc, ctx->dev_data->match_data, NULL, 0, NULL, 0,
+		       ad, 0, &ctx->enc.epib[1]))
 		goto badkey;
 
 	cmdl_len = sa_format_cmdl_gen(&cfg,
@@ -1716,6 +1734,7 @@ static int sa_cra_init_aead(struct crypto_aead *tfm, const char *hash,
 	int ret;
 
 	memzero_explicit(ctx, sizeof(*ctx));
+	ctx->dev_data = data;
 
 	ctx->shash = crypto_alloc_shash(hash, 0, CRYPTO_ALG_NEED_FALLBACK);
 	if (IS_ERR(ctx->shash)) {
@@ -1817,8 +1836,8 @@ static int sa_aead_setkey(struct crypto_aead *authenc,
 	cfg.akey_len = keys.authkeylen;
 
 	/* Setup Encryption Security Context & Command label template */
-	if (sa_init_sc(&ctx->enc, keys.enckey, keys.enckeylen,
-		       keys.authkey, keys.authkeylen,
+	if (sa_init_sc(&ctx->enc, ctx->dev_data->match_data, keys.enckey,
+		       keys.enckeylen, keys.authkey, keys.authkeylen,
 		       ad, 1, &ctx->enc.epib[1]))
 		return -EINVAL;
 
@@ -1831,8 +1850,8 @@ static int sa_aead_setkey(struct crypto_aead *authenc,
 	ctx->enc.cmdl_size = cmdl_len;
 
 	/* Setup Decryption Security Context & Command label template */
-	if (sa_init_sc(&ctx->dec, keys.enckey, keys.enckeylen,
-		       keys.authkey, keys.authkeylen,
+	if (sa_init_sc(&ctx->dec, ctx->dev_data->match_data, keys.enckey,
+		       keys.enckeylen, keys.authkey, keys.authkeylen,
 		       ad, 0, &ctx->dec.epib[1]))
 		return -EINVAL;
 
@@ -1950,7 +1969,7 @@ static int sa_aead_decrypt(struct aead_request *req)
 }
 
 static struct sa_alg_tmpl sa_algs[] = {
-	{
+	[SA_ALG_CBC_AES] = {
 		.type = CRYPTO_ALG_TYPE_SKCIPHER,
 		.alg.skcipher = {
 			.base.cra_name		= "cbc(aes)",
@@ -1973,7 +1992,7 @@ static struct sa_alg_tmpl sa_algs[] = {
 			.decrypt		= sa_decrypt,
 		}
 	},
-	{
+	[SA_ALG_EBC_AES] = {
 		.type = CRYPTO_ALG_TYPE_SKCIPHER,
 		.alg.skcipher = {
 			.base.cra_name		= "ecb(aes)",
@@ -1995,7 +2014,7 @@ static struct sa_alg_tmpl sa_algs[] = {
 			.decrypt		= sa_decrypt,
 		}
 	},
-	{
+	[SA_ALG_CBC_DES3] = {
 		.type = CRYPTO_ALG_TYPE_SKCIPHER,
 		.alg.skcipher = {
 			.base.cra_name		= "cbc(des3_ede)",
@@ -2018,7 +2037,7 @@ static struct sa_alg_tmpl sa_algs[] = {
 			.decrypt		= sa_decrypt,
 		}
 	},
-	{
+	[SA_ALG_ECB_DES3] = {
 		.type = CRYPTO_ALG_TYPE_SKCIPHER,
 		.alg.skcipher = {
 			.base.cra_name		= "ecb(des3_ede)",
@@ -2040,7 +2059,7 @@ static struct sa_alg_tmpl sa_algs[] = {
 			.decrypt		= sa_decrypt,
 		}
 	},
-	{
+	[SA_ALG_SHA1] = {
 		.type = CRYPTO_ALG_TYPE_AHASH,
 		.alg.ahash = {
 			.halg.base = {
@@ -2069,7 +2088,7 @@ static struct sa_alg_tmpl sa_algs[] = {
 			.import			= sa_sha_import,
 		},
 	},
-	{
+	[SA_ALG_SHA256] = {
 		.type = CRYPTO_ALG_TYPE_AHASH,
 		.alg.ahash = {
 			.halg.base = {
@@ -2098,7 +2117,7 @@ static struct sa_alg_tmpl sa_algs[] = {
 			.import			= sa_sha_import,
 		},
 	},
-	{
+	[SA_ALG_SHA512] = {
 		.type = CRYPTO_ALG_TYPE_AHASH,
 		.alg.ahash = {
 			.halg.base = {
@@ -2127,7 +2146,7 @@ static struct sa_alg_tmpl sa_algs[] = {
 			.import			= sa_sha_import,
 		},
 	},
-	{
+	[SA_ALG_AUTHENC_SHA1_AES] = {
 		.type	= CRYPTO_ALG_TYPE_AEAD,
 		.alg.aead = {
 			.base = {
@@ -2154,7 +2173,7 @@ static struct sa_alg_tmpl sa_algs[] = {
 			.decrypt = sa_aead_decrypt,
 		},
 	},
-	{
+	[SA_ALG_AUTHENC_SHA256_AES] = {
 		.type	= CRYPTO_ALG_TYPE_AEAD,
 		.alg.aead = {
 			.base = {
@@ -2185,13 +2204,19 @@ static struct sa_alg_tmpl sa_algs[] = {
 };
 
 /* Register the algorithms in crypto framework */
-static void sa_register_algos(const struct device *dev)
+static void sa_register_algos(struct sa_crypto_data *dev_data)
 {
+	const struct sa_match_data *match_data = dev_data->match_data;
+	struct device *dev = dev_data->dev;
 	char *alg_name;
 	u32 type;
 	int i, err;
 
 	for (i = 0; i < ARRAY_SIZE(sa_algs); i++) {
+		/* Skip unsupported algos */
+		if (!(match_data->supported_algos & BIT(i)))
+			continue;
+
 		type = sa_algs[i].type;
 		if (type == CRYPTO_ALG_TYPE_SKCIPHER) {
 			alg_name = sa_algs[i].alg.skcipher.base.cra_name;
@@ -2329,14 +2354,39 @@ static int sa_link_child(struct device *dev, void *data)
 	return 0;
 }
 
+static struct sa_match_data am654_match_data = {
+	.priv = 1,
+	.priv_id = 1,
+	.supported_algos = GENMASK(SA_ALG_AUTHENC_SHA256_AES, 0),
+};
+
+static struct sa_match_data am64_match_data = {
+	.priv = 0,
+	.priv_id = 0,
+	.supported_algos = BIT(SA_ALG_CBC_AES) |
+			   BIT(SA_ALG_EBC_AES) |
+			   BIT(SA_ALG_SHA256) |
+			   BIT(SA_ALG_SHA512) |
+			   BIT(SA_ALG_AUTHENC_SHA256_AES),
+	.skip_engine_control = true,
+};
+
+static const struct of_device_id of_match[] = {
+	{ .compatible = "ti,j721e-sa2ul", .data = &am654_match_data, },
+	{ .compatible = "ti,am654-sa2ul", .data = &am654_match_data, },
+	{ .compatible = "ti,am64-sa2ul", .data = &am64_match_data, },
+	{},
+};
+MODULE_DEVICE_TABLE(of, of_match);
+
 static int sa_ul_probe(struct platform_device *pdev)
 {
+	const struct of_device_id *match;
 	struct device *dev = &pdev->dev;
 	struct device_node *node = dev->of_node;
 	struct resource *res;
 	static void __iomem *saul_base;
 	struct sa_crypto_data *dev_data;
-	u32 val;
 	int ret;
 
 	dev_data = devm_kzalloc(dev, sizeof(*dev_data), GFP_KERNEL);
@@ -2362,18 +2412,28 @@ static int sa_ul_probe(struct platform_device *pdev)
 	if (ret)
 		goto disable_pm_runtime;
 
+	match = of_match_node(of_match, dev->of_node);
+	if (!match) {
+		dev_err(dev, "No compatible match found\n");
+		return -ENODEV;
+	}
+	dev_data->match_data = match->data;
+
 	spin_lock_init(&dev_data->scid_lock);
 	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
 	saul_base = devm_ioremap_resource(dev, res);
 
 	dev_data->base = saul_base;
-	val = SA_EEC_ENCSS_EN | SA_EEC_AUTHSS_EN | SA_EEC_CTXCACH_EN |
-	    SA_EEC_CPPI_PORT_IN_EN | SA_EEC_CPPI_PORT_OUT_EN |
-	    SA_EEC_TRNG_EN;
 
-	writel_relaxed(val, saul_base + SA_ENGINE_ENABLE_CONTROL);
+	if (!dev_data->match_data->skip_engine_control) {
+		u32 val = SA_EEC_ENCSS_EN | SA_EEC_AUTHSS_EN | SA_EEC_CTXCACH_EN |
+			  SA_EEC_CPPI_PORT_IN_EN | SA_EEC_CPPI_PORT_OUT_EN |
+			  SA_EEC_TRNG_EN;
 
-	sa_register_algos(dev);
+		writel_relaxed(val, saul_base + SA_ENGINE_ENABLE_CONTROL);
+	}
+
+	sa_register_algos(dev_data);
 
 	ret = of_platform_populate(node, NULL, NULL, &pdev->dev);
 	if (ret)
@@ -2419,13 +2479,6 @@ static int sa_ul_remove(struct platform_device *pdev)
 	return 0;
 }
 
-static const struct of_device_id of_match[] = {
-	{.compatible = "ti,j721e-sa2ul",},
-	{.compatible = "ti,am654-sa2ul",},
-	{},
-};
-MODULE_DEVICE_TABLE(of, of_match);
-
 static struct platform_driver sa_ul_driver = {
 	.probe = sa_ul_probe,
 	.remove = sa_ul_remove,
diff --git a/drivers/crypto/sa2ul.h b/drivers/crypto/sa2ul.h
index f597ddecde34..ed66d1f111db 100644
--- a/drivers/crypto/sa2ul.h
+++ b/drivers/crypto/sa2ul.h
@@ -171,9 +171,12 @@ struct sa_tfm_ctx;
 #define SA_UNSAFE_DATA_SZ_MIN	240
 #define SA_UNSAFE_DATA_SZ_MAX	256
 
+struct sa_match_data;
+
 /**
  * struct sa_crypto_data - Crypto driver instance data
  * @base: Base address of the register space
+ * @soc_data: Pointer to SoC specific data
  * @pdev: Platform device pointer
  * @sc_pool: security context pool
  * @dev: Device pointer
@@ -189,6 +192,7 @@ struct sa_tfm_ctx;
  */
 struct sa_crypto_data {
 	void __iomem *base;
+	const struct sa_match_data *match_data;
 	struct platform_device	*pdev;
 	struct dma_pool		*sc_pool;
 	struct device *dev;
-- 
2.30.1


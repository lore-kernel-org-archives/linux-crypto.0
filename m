Return-Path: <SRS0=bUM2=WR=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 93601C41514
	for <linux-crypto@archiver.kernel.org>; Wed, 21 Aug 2019 14:33:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6024B216F4
	for <linux-crypto@archiver.kernel.org>; Wed, 21 Aug 2019 14:33:16 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="kh0lP5zW"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728822AbfHUOdP (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 21 Aug 2019 10:33:15 -0400
Received: from mail-wm1-f68.google.com ([209.85.128.68]:33529 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728763AbfHUOdP (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 21 Aug 2019 10:33:15 -0400
Received: by mail-wm1-f68.google.com with SMTP id p77so4916062wme.0
        for <linux-crypto@vger.kernel.org>; Wed, 21 Aug 2019 07:33:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=LWz788qVRg8VvOU54DLOD0vDhiGV6LnBrRgMkVFGK/8=;
        b=kh0lP5zWQCmIej/pzRW7hJEdUZP13UY2aQP5NxCMeJcCIz3aryKYV+Kuimjonw6ytk
         0/mOIRXkileb2okTU3kRfbQQGphAeLvbF8djfn+IIfpneCRXjaBYa0MQSFPEXZ19WyM5
         S1fUeJAGJht4SYzXBaXxMHL/Si/1+PuN8TYGXSOdq+DDpWq6YGSor6Qf20AU4ZR7kFxv
         KDIDuMTDINYG7GUmG9gvslINTNaQSCW6UFqHoQWuskWuUol0ZP+roC81Qcyxa/tSqCcz
         1wi7N8yT9mVMr0TTTr2rCf93YJXtAR8ET1UvWRU4/sx4HD91kp5U41Cew/Y+sV4e2t7T
         dosw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=LWz788qVRg8VvOU54DLOD0vDhiGV6LnBrRgMkVFGK/8=;
        b=lmpku8CQ812SRylPIUZoHcKE1x5qn8MgCy3j6FjFteOL+Gz8qWT/yVHgr5wl+k5VKf
         w1jDwh4Ohfqwmfqn3/5tOq5BJ12B5OuUoxpP7Z6hp8qNn82oEY6BF31vKgqMT6gnyyIw
         9cyYxidQ6/M9n+WeZJz5/c2UjWJTHnYuA72Xfb7soGUlnZ3KkgsWY3Sa3/RRGOOweQJ2
         KjysWuy0hFVbLw2OTyPucnyeqhnDbhqO4WCZnDGyKStzDpO3OkEEJEsnNCggu63SCjw2
         PNs66phlnJQsa1ZfLA/4J51sTdkM8lQK2udQm+DpM0eO0k7tuOfBiG+SWtZuLsN1fFtP
         /M4Q==
X-Gm-Message-State: APjAAAVt/Yz7UVGBiZ6WhU5l4K2d2ps3ChSwza3pG/DVrSqnaZDkCmRX
        swJzz14AVWVoXJ6iQzJmdzjDKfT2WHIJyQ==
X-Google-Smtp-Source: APXvYqx1QDIFFcyQvx5UmwsE0hid9Gxw7ZLJo9eT1YozzpKMqYXThKxB1uktxljneceOlkVFOmIGQQ==
X-Received: by 2002:a1c:6145:: with SMTP id v66mr428480wmb.42.1566397991198;
        Wed, 21 Aug 2019 07:33:11 -0700 (PDT)
Received: from mba13.lan (adsl-103.109.242.1.tellas.gr. [109.242.1.103])
        by smtp.gmail.com with ESMTPSA id 16sm181427wmx.45.2019.08.21.07.33.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 21 Aug 2019 07:33:10 -0700 (PDT)
From:   Ard Biesheuvel <ard.biesheuvel@linaro.org>
To:     linux-crypto@vger.kernel.org
Cc:     herbert@gondor.apana.org.au, ebiggers@kernel.org,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: [PATCH 07/17] crypto: arm64/aes-neon - limit exposed routines if faster driver is enabled
Date:   Wed, 21 Aug 2019 17:32:43 +0300
Message-Id: <20190821143253.30209-8-ard.biesheuvel@linaro.org>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190821143253.30209-1-ard.biesheuvel@linaro.org>
References: <20190821143253.30209-1-ard.biesheuvel@linaro.org>
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

The pure NEON AES implementation predates the bit-slicing one, and is
generally slower, unless the algorithm in question can only execute
sequentially.

So advertising the skciphers that the bit-slicing driver implements as
well serves no real purpose, and we can just disable them. Note that the
bit-slicing driver also has a link time dependency on the pure NEON
driver, for CBC encryption and for XTS tweak calculation, so we still
need both drivers on systems that do not implement the Crypto Extensions.

At the same time, expose those modaliases for the AES instruction based
driver. This is necessary since otherwise, we may end up loading the
wrong driver when any of the skciphers are instantiated before the CPU
capability based module loading has completed.

Finally, add the missing modalias for cts(cbc(aes)) so requests for
this algorithm will autoload the correct module.

Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
---
 arch/arm64/crypto/aes-glue.c | 112 +++++++++++---------
 1 file changed, 59 insertions(+), 53 deletions(-)

diff --git a/arch/arm64/crypto/aes-glue.c b/arch/arm64/crypto/aes-glue.c
index ca0c84d56cba..4154bb93a85b 100644
--- a/arch/arm64/crypto/aes-glue.c
+++ b/arch/arm64/crypto/aes-glue.c
@@ -54,15 +54,18 @@ MODULE_DESCRIPTION("AES-ECB/CBC/CTR/XTS using ARMv8 Crypto Extensions");
 #define aes_xts_decrypt		neon_aes_xts_decrypt
 #define aes_mac_update		neon_aes_mac_update
 MODULE_DESCRIPTION("AES-ECB/CBC/CTR/XTS using ARMv8 NEON");
+#endif
+#if defined(USE_V8_CRYPTO_EXTENSIONS) || !defined(CONFIG_CRYPTO_AES_ARM64_BS)
 MODULE_ALIAS_CRYPTO("ecb(aes)");
 MODULE_ALIAS_CRYPTO("cbc(aes)");
-MODULE_ALIAS_CRYPTO("essiv(cbc(aes),sha256)");
 MODULE_ALIAS_CRYPTO("ctr(aes)");
 MODULE_ALIAS_CRYPTO("xts(aes)");
+#endif
+MODULE_ALIAS_CRYPTO("cts(cbc(aes))");
+MODULE_ALIAS_CRYPTO("essiv(cbc(aes),sha256)");
 MODULE_ALIAS_CRYPTO("cmac(aes)");
 MODULE_ALIAS_CRYPTO("xcbc(aes)");
 MODULE_ALIAS_CRYPTO("cbcmac(aes)");
-#endif
 
 MODULE_AUTHOR("Ard Biesheuvel <ard.biesheuvel@linaro.org>");
 MODULE_LICENSE("GPL v2");
@@ -144,8 +147,8 @@ static int skcipher_aes_setkey(struct crypto_skcipher *tfm, const u8 *in_key,
 	return ret;
 }
 
-static int xts_set_key(struct crypto_skcipher *tfm, const u8 *in_key,
-		       unsigned int key_len)
+static int __maybe_unused xts_set_key(struct crypto_skcipher *tfm,
+				      const u8 *in_key, unsigned int key_len)
 {
 	struct crypto_aes_xts_ctx *ctx = crypto_skcipher_ctx(tfm);
 	int ret;
@@ -165,8 +168,9 @@ static int xts_set_key(struct crypto_skcipher *tfm, const u8 *in_key,
 	return -EINVAL;
 }
 
-static int essiv_cbc_set_key(struct crypto_skcipher *tfm, const u8 *in_key,
-			     unsigned int key_len)
+static int __maybe_unused essiv_cbc_set_key(struct crypto_skcipher *tfm,
+					    const u8 *in_key,
+					    unsigned int key_len)
 {
 	struct crypto_aes_essiv_cbc_ctx *ctx = crypto_skcipher_ctx(tfm);
 	SHASH_DESC_ON_STACK(desc, ctx->hash);
@@ -190,7 +194,7 @@ static int essiv_cbc_set_key(struct crypto_skcipher *tfm, const u8 *in_key,
 	return -EINVAL;
 }
 
-static int ecb_encrypt(struct skcipher_request *req)
+static int __maybe_unused ecb_encrypt(struct skcipher_request *req)
 {
 	struct crypto_skcipher *tfm = crypto_skcipher_reqtfm(req);
 	struct crypto_aes_ctx *ctx = crypto_skcipher_ctx(tfm);
@@ -210,7 +214,7 @@ static int ecb_encrypt(struct skcipher_request *req)
 	return err;
 }
 
-static int ecb_decrypt(struct skcipher_request *req)
+static int __maybe_unused ecb_decrypt(struct skcipher_request *req)
 {
 	struct crypto_skcipher *tfm = crypto_skcipher_reqtfm(req);
 	struct crypto_aes_ctx *ctx = crypto_skcipher_ctx(tfm);
@@ -248,7 +252,7 @@ static int cbc_encrypt_walk(struct skcipher_request *req,
 	return err;
 }
 
-static int cbc_encrypt(struct skcipher_request *req)
+static int __maybe_unused cbc_encrypt(struct skcipher_request *req)
 {
 	struct skcipher_walk walk;
 	int err;
@@ -277,7 +281,7 @@ static int cbc_decrypt_walk(struct skcipher_request *req,
 	return err;
 }
 
-static int cbc_decrypt(struct skcipher_request *req)
+static int __maybe_unused cbc_decrypt(struct skcipher_request *req)
 {
 	struct skcipher_walk walk;
 	int err;
@@ -404,7 +408,7 @@ static int cts_cbc_decrypt(struct skcipher_request *req)
 	return skcipher_walk_done(&walk, 0);
 }
 
-static int essiv_cbc_init_tfm(struct crypto_skcipher *tfm)
+static int __maybe_unused essiv_cbc_init_tfm(struct crypto_skcipher *tfm)
 {
 	struct crypto_aes_essiv_cbc_ctx *ctx = crypto_skcipher_ctx(tfm);
 
@@ -415,14 +419,14 @@ static int essiv_cbc_init_tfm(struct crypto_skcipher *tfm)
 	return 0;
 }
 
-static void essiv_cbc_exit_tfm(struct crypto_skcipher *tfm)
+static void __maybe_unused essiv_cbc_exit_tfm(struct crypto_skcipher *tfm)
 {
 	struct crypto_aes_essiv_cbc_ctx *ctx = crypto_skcipher_ctx(tfm);
 
 	crypto_free_shash(ctx->hash);
 }
 
-static int essiv_cbc_encrypt(struct skcipher_request *req)
+static int __maybe_unused essiv_cbc_encrypt(struct skcipher_request *req)
 {
 	struct crypto_skcipher *tfm = crypto_skcipher_reqtfm(req);
 	struct crypto_aes_essiv_cbc_ctx *ctx = crypto_skcipher_ctx(tfm);
@@ -444,7 +448,7 @@ static int essiv_cbc_encrypt(struct skcipher_request *req)
 	return err ?: cbc_encrypt_walk(req, &walk);
 }
 
-static int essiv_cbc_decrypt(struct skcipher_request *req)
+static int __maybe_unused essiv_cbc_decrypt(struct skcipher_request *req)
 {
 	struct crypto_skcipher *tfm = crypto_skcipher_reqtfm(req);
 	struct crypto_aes_essiv_cbc_ctx *ctx = crypto_skcipher_ctx(tfm);
@@ -520,7 +524,7 @@ static void ctr_encrypt_one(struct crypto_skcipher *tfm, const u8 *src, u8 *dst)
 	local_irq_restore(flags);
 }
 
-static int ctr_encrypt_sync(struct skcipher_request *req)
+static int __maybe_unused ctr_encrypt_sync(struct skcipher_request *req)
 {
 	if (!crypto_simd_usable())
 		return crypto_ctr_encrypt_walk(req, ctr_encrypt_one);
@@ -528,7 +532,7 @@ static int ctr_encrypt_sync(struct skcipher_request *req)
 	return ctr_encrypt(req);
 }
 
-static int xts_encrypt(struct skcipher_request *req)
+static int __maybe_unused xts_encrypt(struct skcipher_request *req)
 {
 	struct crypto_skcipher *tfm = crypto_skcipher_reqtfm(req);
 	struct crypto_aes_xts_ctx *ctx = crypto_skcipher_ctx(tfm);
@@ -550,7 +554,7 @@ static int xts_encrypt(struct skcipher_request *req)
 	return err;
 }
 
-static int xts_decrypt(struct skcipher_request *req)
+static int __maybe_unused xts_decrypt(struct skcipher_request *req)
 {
 	struct crypto_skcipher *tfm = crypto_skcipher_reqtfm(req);
 	struct crypto_aes_xts_ctx *ctx = crypto_skcipher_ctx(tfm);
@@ -573,6 +577,7 @@ static int xts_decrypt(struct skcipher_request *req)
 }
 
 static struct skcipher_alg aes_algs[] = { {
+#if defined(USE_V8_CRYPTO_EXTENSIONS) || !defined(CONFIG_CRYPTO_AES_ARM64_BS)
 	.base = {
 		.cra_name		= "__ecb(aes)",
 		.cra_driver_name	= "__ecb-aes-" MODE,
@@ -603,42 +608,6 @@ static struct skcipher_alg aes_algs[] = { {
 	.setkey		= skcipher_aes_setkey,
 	.encrypt	= cbc_encrypt,
 	.decrypt	= cbc_decrypt,
-}, {
-	.base = {
-		.cra_name		= "__cts(cbc(aes))",
-		.cra_driver_name	= "__cts-cbc-aes-" MODE,
-		.cra_priority		= PRIO,
-		.cra_flags		= CRYPTO_ALG_INTERNAL,
-		.cra_blocksize		= AES_BLOCK_SIZE,
-		.cra_ctxsize		= sizeof(struct crypto_aes_ctx),
-		.cra_module		= THIS_MODULE,
-	},
-	.min_keysize	= AES_MIN_KEY_SIZE,
-	.max_keysize	= AES_MAX_KEY_SIZE,
-	.ivsize		= AES_BLOCK_SIZE,
-	.walksize	= 2 * AES_BLOCK_SIZE,
-	.setkey		= skcipher_aes_setkey,
-	.encrypt	= cts_cbc_encrypt,
-	.decrypt	= cts_cbc_decrypt,
-	.init		= cts_cbc_init_tfm,
-}, {
-	.base = {
-		.cra_name		= "__essiv(cbc(aes),sha256)",
-		.cra_driver_name	= "__essiv-cbc-aes-sha256-" MODE,
-		.cra_priority		= PRIO + 1,
-		.cra_flags		= CRYPTO_ALG_INTERNAL,
-		.cra_blocksize		= AES_BLOCK_SIZE,
-		.cra_ctxsize		= sizeof(struct crypto_aes_essiv_cbc_ctx),
-		.cra_module		= THIS_MODULE,
-	},
-	.min_keysize	= AES_MIN_KEY_SIZE,
-	.max_keysize	= AES_MAX_KEY_SIZE,
-	.ivsize		= AES_BLOCK_SIZE,
-	.setkey		= essiv_cbc_set_key,
-	.encrypt	= essiv_cbc_encrypt,
-	.decrypt	= essiv_cbc_decrypt,
-	.init		= essiv_cbc_init_tfm,
-	.exit		= essiv_cbc_exit_tfm,
 }, {
 	.base = {
 		.cra_name		= "__ctr(aes)",
@@ -688,6 +657,43 @@ static struct skcipher_alg aes_algs[] = { {
 	.setkey		= xts_set_key,
 	.encrypt	= xts_encrypt,
 	.decrypt	= xts_decrypt,
+}, {
+#endif
+	.base = {
+		.cra_name		= "__cts(cbc(aes))",
+		.cra_driver_name	= "__cts-cbc-aes-" MODE,
+		.cra_priority		= PRIO,
+		.cra_flags		= CRYPTO_ALG_INTERNAL,
+		.cra_blocksize		= AES_BLOCK_SIZE,
+		.cra_ctxsize		= sizeof(struct crypto_aes_ctx),
+		.cra_module		= THIS_MODULE,
+	},
+	.min_keysize	= AES_MIN_KEY_SIZE,
+	.max_keysize	= AES_MAX_KEY_SIZE,
+	.ivsize		= AES_BLOCK_SIZE,
+	.walksize	= 2 * AES_BLOCK_SIZE,
+	.setkey		= skcipher_aes_setkey,
+	.encrypt	= cts_cbc_encrypt,
+	.decrypt	= cts_cbc_decrypt,
+	.init		= cts_cbc_init_tfm,
+}, {
+	.base = {
+		.cra_name		= "__essiv(cbc(aes),sha256)",
+		.cra_driver_name	= "__essiv-cbc-aes-sha256-" MODE,
+		.cra_priority		= PRIO + 1,
+		.cra_flags		= CRYPTO_ALG_INTERNAL,
+		.cra_blocksize		= AES_BLOCK_SIZE,
+		.cra_ctxsize		= sizeof(struct crypto_aes_essiv_cbc_ctx),
+		.cra_module		= THIS_MODULE,
+	},
+	.min_keysize	= AES_MIN_KEY_SIZE,
+	.max_keysize	= AES_MAX_KEY_SIZE,
+	.ivsize		= AES_BLOCK_SIZE,
+	.setkey		= essiv_cbc_set_key,
+	.encrypt	= essiv_cbc_encrypt,
+	.decrypt	= essiv_cbc_decrypt,
+	.init		= essiv_cbc_init_tfm,
+	.exit		= essiv_cbc_exit_tfm,
 } };
 
 static int cbcmac_setkey(struct crypto_shash *tfm, const u8 *in_key,
-- 
2.17.1


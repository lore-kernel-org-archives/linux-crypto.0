Return-Path: <SRS0=X5ob=U7=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BD71EC06513
	for <linux-crypto@archiver.kernel.org>; Tue,  2 Jul 2019 19:42:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9811B21850
	for <linux-crypto@archiver.kernel.org>; Tue,  2 Jul 2019 19:42:49 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="EERhzbs2"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727103AbfGBTmq (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 2 Jul 2019 15:42:46 -0400
Received: from mail-lj1-f195.google.com ([209.85.208.195]:37814 "EHLO
        mail-lj1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727094AbfGBTmp (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 2 Jul 2019 15:42:45 -0400
Received: by mail-lj1-f195.google.com with SMTP id 131so18176823ljf.4
        for <linux-crypto@vger.kernel.org>; Tue, 02 Jul 2019 12:42:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=n5l3F17uXNQenDSvhlR5E0fuSKbS0aVchlvnJvykzg4=;
        b=EERhzbs2UHUCyBRzT2cFOtGhmJ+RKgtq244yJuVTRXkE8UxD/VtbE8nRMvbUiSIQuH
         moKG/y6WoFwOG0I3PTOOyrJUb70sOSCT04quKkU/fMp/dMetea/EnG9tt2uepbm2FFry
         D8fS0PueVm81/oiqsGenEaZmngLw2KZPCI6TPIiSPWOjxg+9H0OC6xlLiiEIayy6VXJL
         Ue+jdpAe8mY/dMThZXqbgZIus4ZnUnvLNq13V7y5/Q+tllqIpyeyb2s0mev6DVV5NNwU
         +sSmFzaQfZO/FWMLRHF5urCZSywC6RyrlDAebo3OeOC4+FtZmPfftOHekaClwu+aJBbI
         eKrQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=n5l3F17uXNQenDSvhlR5E0fuSKbS0aVchlvnJvykzg4=;
        b=ZjY8zPZupxWP5yyPpxFB2DkjNfYTx//L8qaBcVmBE45HkqbpXsPwrjukHTqkaRfyY1
         7z2+osjHHjGvh6QgxMuUoazGgDpeEsDyg7wgRfsjZkB3wNDQ+eRxLgkNSd+PHcv+jHpk
         FMHVfd3WHs+5mD7mNuhSfqJx6MCQyST5YN+VFPBUV1BQBhfRpZ1tUAv9zXer861hiFmX
         nlMvqhOJ1gjfi852ZTqiHKNj09GwI3xzWf5hb67yIecguVJhEiR++ReBxPgZFRZHbNIR
         8cX7YMoehMIeSev3E9O87t4+bZlRd8LCJf3PRXeapYdbp1F/vDpnWbQ21md5tWvUC/m1
         hWMQ==
X-Gm-Message-State: APjAAAWxhYbrNvAqDoRmpyFkg0DFZIETQ3jMtpyZM+0rgrjnsM5lUqeu
        9b9ndkCoCVZEOZq0tvRQdjJ2uL6XvsglJH2D
X-Google-Smtp-Source: APXvYqx6Xf4+eCgB1IpokvvGui9mz6UIUGxwxqFgxkGOHFk7DoRmRs1PEuZhbDm7iNCCTwKaMqt/9A==
X-Received: by 2002:a2e:7614:: with SMTP id r20mr18761048ljc.42.1562096563562;
        Tue, 02 Jul 2019 12:42:43 -0700 (PDT)
Received: from e111045-lin.arm.com (89-212-78-239.static.t-2.net. [89.212.78.239])
        by smtp.gmail.com with ESMTPSA id 24sm4475163ljs.63.2019.07.02.12.42.42
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Tue, 02 Jul 2019 12:42:42 -0700 (PDT)
From:   Ard Biesheuvel <ard.biesheuvel@linaro.org>
To:     linux-crypto@vger.kernel.org
Cc:     herbert@gondor.apana.org.au, ebiggers@google.com,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: [PATCH v4 25/32] crypto: ccp - move to AES library for CMAC key derivation
Date:   Tue,  2 Jul 2019 21:41:43 +0200
Message-Id: <20190702194150.10405-26-ard.biesheuvel@linaro.org>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190702194150.10405-1-ard.biesheuvel@linaro.org>
References: <20190702194150.10405-1-ard.biesheuvel@linaro.org>
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Use the AES library instead of the cipher interface to perform
the single block of AES processing involved in updating the key
of the cmac(aes) hash.

Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
---
 drivers/crypto/ccp/Kconfig               |  1 +
 drivers/crypto/ccp/ccp-crypto-aes-cmac.c | 25 ++++----------------
 drivers/crypto/ccp/ccp-crypto.h          |  3 ---
 3 files changed, 5 insertions(+), 24 deletions(-)

diff --git a/drivers/crypto/ccp/Kconfig b/drivers/crypto/ccp/Kconfig
index b9dfae47aefd..ee06d0fccdb5 100644
--- a/drivers/crypto/ccp/Kconfig
+++ b/drivers/crypto/ccp/Kconfig
@@ -29,6 +29,7 @@ config CRYPTO_DEV_CCP_CRYPTO
 	select CRYPTO_BLKCIPHER
 	select CRYPTO_AUTHENC
 	select CRYPTO_RSA
+	select CRYPTO_LIB_AES
 	help
 	  Support for using the cryptographic API with the AMD Cryptographic
 	  Coprocessor. This module supports offload of SHA and AES algorithms.
diff --git a/drivers/crypto/ccp/ccp-crypto-aes-cmac.c b/drivers/crypto/ccp/ccp-crypto-aes-cmac.c
index f6e252c1d6fb..c8f4b29bf044 100644
--- a/drivers/crypto/ccp/ccp-crypto-aes-cmac.c
+++ b/drivers/crypto/ccp/ccp-crypto-aes-cmac.c
@@ -264,6 +264,7 @@ static int ccp_aes_cmac_setkey(struct crypto_ahash *tfm, const u8 *key,
 		ccp_crypto_ahash_alg(crypto_ahash_tfm(tfm));
 	u64 k0_hi, k0_lo, k1_hi, k1_lo, k2_hi, k2_lo;
 	u64 rb_hi = 0x00, rb_lo = 0x87;
+	struct crypto_aes_ctx aes;
 	__be64 *gk;
 	int ret;
 
@@ -287,14 +288,14 @@ static int ccp_aes_cmac_setkey(struct crypto_ahash *tfm, const u8 *key,
 	ctx->u.aes.key_len = 0;
 
 	/* Set the key for the AES cipher used to generate the keys */
-	ret = crypto_cipher_setkey(ctx->u.aes.tfm_cipher, key, key_len);
+	ret = aes_expandkey(&aes, key, key_len);
 	if (ret)
 		return ret;
 
 	/* Encrypt a block of zeroes - use key area in context */
 	memset(ctx->u.aes.key, 0, sizeof(ctx->u.aes.key));
-	crypto_cipher_encrypt_one(ctx->u.aes.tfm_cipher, ctx->u.aes.key,
-				  ctx->u.aes.key);
+	aes_encrypt(&aes, ctx->u.aes.key, ctx->u.aes.key);
+	memzero_explicit(&aes, sizeof(aes));
 
 	/* Generate K1 and K2 */
 	k0_hi = be64_to_cpu(*((__be64 *)ctx->u.aes.key));
@@ -339,32 +340,15 @@ static int ccp_aes_cmac_cra_init(struct crypto_tfm *tfm)
 {
 	struct ccp_ctx *ctx = crypto_tfm_ctx(tfm);
 	struct crypto_ahash *ahash = __crypto_ahash_cast(tfm);
-	struct crypto_cipher *cipher_tfm;
 
 	ctx->complete = ccp_aes_cmac_complete;
 	ctx->u.aes.key_len = 0;
 
 	crypto_ahash_set_reqsize(ahash, sizeof(struct ccp_aes_cmac_req_ctx));
 
-	cipher_tfm = crypto_alloc_cipher("aes", 0, CRYPTO_ALG_NEED_FALLBACK);
-	if (IS_ERR(cipher_tfm)) {
-		pr_warn("could not load aes cipher driver\n");
-		return PTR_ERR(cipher_tfm);
-	}
-	ctx->u.aes.tfm_cipher = cipher_tfm;
-
 	return 0;
 }
 
-static void ccp_aes_cmac_cra_exit(struct crypto_tfm *tfm)
-{
-	struct ccp_ctx *ctx = crypto_tfm_ctx(tfm);
-
-	if (ctx->u.aes.tfm_cipher)
-		crypto_free_cipher(ctx->u.aes.tfm_cipher);
-	ctx->u.aes.tfm_cipher = NULL;
-}
-
 int ccp_register_aes_cmac_algs(struct list_head *head)
 {
 	struct ccp_crypto_ahash_alg *ccp_alg;
@@ -404,7 +388,6 @@ int ccp_register_aes_cmac_algs(struct list_head *head)
 	base->cra_ctxsize = sizeof(struct ccp_ctx);
 	base->cra_priority = CCP_CRA_PRIORITY;
 	base->cra_init = ccp_aes_cmac_cra_init;
-	base->cra_exit = ccp_aes_cmac_cra_exit;
 	base->cra_module = THIS_MODULE;
 
 	ret = crypto_register_ahash(alg);
diff --git a/drivers/crypto/ccp/ccp-crypto.h b/drivers/crypto/ccp/ccp-crypto.h
index 28819e11db96..9100df77a7b3 100644
--- a/drivers/crypto/ccp/ccp-crypto.h
+++ b/drivers/crypto/ccp/ccp-crypto.h
@@ -90,9 +90,6 @@ struct ccp_aes_ctx {
 	/* Fallback cipher for XTS with unsupported unit sizes */
 	struct crypto_sync_skcipher *tfm_skcipher;
 
-	/* Cipher used to generate CMAC K1/K2 keys */
-	struct crypto_cipher *tfm_cipher;
-
 	enum ccp_engine engine;
 	enum ccp_aes_type type;
 	enum ccp_aes_mode mode;
-- 
2.17.1


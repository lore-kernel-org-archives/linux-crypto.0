Return-Path: <SRS0=RljO=UV=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D8502C48BE7
	for <linux-crypto@archiver.kernel.org>; Sat, 22 Jun 2019 19:35:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id AE42B20657
	for <linux-crypto@archiver.kernel.org>; Sat, 22 Jun 2019 19:35:10 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="cQa5bBNH"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726373AbfFVTfK (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Sat, 22 Jun 2019 15:35:10 -0400
Received: from mail-wr1-f65.google.com ([209.85.221.65]:35981 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726396AbfFVTfJ (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sat, 22 Jun 2019 15:35:09 -0400
Received: by mail-wr1-f65.google.com with SMTP id n4so8517508wrs.3
        for <linux-crypto@vger.kernel.org>; Sat, 22 Jun 2019 12:35:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Fm4ramXN1vd7JQGliUbSFSJzkgKkgIE9Zzs9yUh/C1k=;
        b=cQa5bBNHUb9giayw2fJSuMPHtlyBny32MYddKn3/NiDaWpOUGAYFyv5J1BcRXqCvW8
         2477L3mzeFfASZPC3G6dOWtEp35PFuN9GF4Cn6uIoNX+4QamMsPb5OSuhC1EG221IHlA
         NBAiP0UbPpmxoYN40gRdGM34rCEbdiXwa5kGkF72nNYEEHgFiiSN352P8PvO3WZmBLgF
         tZOMuMDBmTI+AAIkZWq1QRdUFQb+/SeCYK8/o9lmlaUGM+E+caSV3n46ULkIFbpVi347
         y16YTPI1kczNKwlp8q1wtSSd4xt0racCk//mY8YJNJMe9FM5rpGKlQ6fIr4EiOY0tYxf
         o+Wg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Fm4ramXN1vd7JQGliUbSFSJzkgKkgIE9Zzs9yUh/C1k=;
        b=CoWz1WsLx1uVFoJOwrvy3Q1PsX5a9J8Z4+msdvysPuuxmAvP325McOZJDVtCjVwFs8
         Aqa3u8szxBVY6D9CThmfGCoZIH4/33j/oUvSWN2QdcINkc74v8a8SuuKOhCtSgMwmd+B
         cz/PRI2uGe586+gxaBhd97/cs23dqWCcD/K5+YJm3Yw4rAfKdWu/+W3FMm6wZDuGVQs/
         5sl3GTJQqCoETGFNmrq8dV1tv/8dkFOol2W11UbIvcWzZilYlIqRLC2dzoV5YiezNEnY
         e7aDk5o+XfF8s+1lcGtvLMgl/n8u4xeV/GmEyyExoIyXLG5944tmdy7IpcQYTG7OBeEW
         DFXQ==
X-Gm-Message-State: APjAAAVHjLTBBXAsmmc6kegfo9RCpQBLLoUGpJRqHu7VGgtTYFJPmTd8
        B2wxw5FP3jx/YWeUSkHWsExLgTGe67T0qjzA
X-Google-Smtp-Source: APXvYqxsAF9W2sOz7Nj1iafIqL4GuM52LErDetdJxF8ZK6rokb/R2GiUkkbaWNKU31H34Tl1oDn/BQ==
X-Received: by 2002:adf:ff84:: with SMTP id j4mr23369809wrr.71.1561232106710;
        Sat, 22 Jun 2019 12:35:06 -0700 (PDT)
Received: from sudo.home ([2a01:cb1d:112:6f00:4bd:3f91:4ef8:ae7e])
        by smtp.gmail.com with ESMTPSA id h8sm4814494wmf.12.2019.06.22.12.35.05
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 22 Jun 2019 12:35:06 -0700 (PDT)
From:   Ard Biesheuvel <ard.biesheuvel@linaro.org>
To:     linux-crypto@vger.kernel.org
Cc:     herbert@gondor.apana.org.au, ebiggers@google.com,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: [PATCH v2 25/26] crypto: ccp - move to AES library for CMAC key derivation
Date:   Sat, 22 Jun 2019 21:34:26 +0200
Message-Id: <20190622193427.20336-26-ard.biesheuvel@linaro.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190622193427.20336-1-ard.biesheuvel@linaro.org>
References: <20190622193427.20336-1-ard.biesheuvel@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
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
2.20.1


Return-Path: <SRS0=X5ob=U7=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 348A1C06513
	for <linux-crypto@archiver.kernel.org>; Tue,  2 Jul 2019 19:42:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 136A821850
	for <linux-crypto@archiver.kernel.org>; Tue,  2 Jul 2019 19:42:32 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="PbegUQsr"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727049AbfGBTmb (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 2 Jul 2019 15:42:31 -0400
Received: from mail-lj1-f195.google.com ([209.85.208.195]:42977 "EHLO
        mail-lj1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727069AbfGBTmb (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 2 Jul 2019 15:42:31 -0400
Received: by mail-lj1-f195.google.com with SMTP id t28so18176753lje.9
        for <linux-crypto@vger.kernel.org>; Tue, 02 Jul 2019 12:42:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=VJ8dT+03h95rj29GtE59SlVplLQkYEqzcrRrbYuxp50=;
        b=PbegUQsrlKcn6CxE553AjHD/kRwxIvh7GkW9LBBOqfLlZfAmDEavHpLWOExPDshaRH
         I//3CADJbdzJ1pJbFS5QdbAdKoG9R7cKBZW8qSQfV36aKZUy2MhPSn+Avn5449g9ox4W
         Qh21rHXr0l81nlMZms5K9ICP1MYFu9BorR/W3xY1e1zlWPi5T57mySIVtmXY0p2uicwY
         +cUhT1vd91uS6xDJCDhQPzSusFyptLBtQ4J0MFEGqOqjL4ZgROCti+qbDbn1bi+6gGVr
         YccK0OhDCsfwb1sRAso7yc8fG27JuHWtL4CApz/nSyaPnrcH4WMbxf8xMRdfV3RiIfys
         DooQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=VJ8dT+03h95rj29GtE59SlVplLQkYEqzcrRrbYuxp50=;
        b=gbqHcMFmGF42sbCaTX0z9kP1c81N6AP0d1ulHG6GLe/f6bM1mwZXMgKnC4nGM5pY4W
         ZtE+QiKmxEyHk67r2juTYplwrZ5T+XwvwldsGaqIiQGQLItfK+u8rwIpox6RofNapwBJ
         xy/T1QBstFWBGHvnQgzovy8sq0hJP+zRRb016OH/9s8oEByr5mAwk95ck719dgdtRHUu
         IouAPanKhbqnlRy7IGY3iyKITUERdaKsFmnccj8yB2pxs10KAeWxeXJFS6KX0sN9kMpV
         LIoIO8egOqqTbiV+5yv8bC0W9whu7WcIDKyMoOjQ5OdfD3c+j9sRHLN6kH6ty4YK3uDE
         /kLw==
X-Gm-Message-State: APjAAAUtVkkBaOmfUozFWjrc5B+PpTIgOCckgHMs388b7IYWKZlWIInP
        BkM/2F+ctm8Jl+H0wHd4ES0bw8lXuaPMmYiM
X-Google-Smtp-Source: APXvYqw/0Dy93jfJtC1sMQlrNLgnxXFtwV+PYhsoIZqvIrahWEZxdQ4DdAmv2SWMDzQnv2FwiHKH9w==
X-Received: by 2002:a2e:894a:: with SMTP id b10mr3036421ljk.99.1562096549392;
        Tue, 02 Jul 2019 12:42:29 -0700 (PDT)
Received: from e111045-lin.arm.com (89-212-78-239.static.t-2.net. [89.212.78.239])
        by smtp.gmail.com with ESMTPSA id 24sm4475163ljs.63.2019.07.02.12.42.28
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Tue, 02 Jul 2019 12:42:28 -0700 (PDT)
From:   Ard Biesheuvel <ard.biesheuvel@linaro.org>
To:     linux-crypto@vger.kernel.org
Cc:     herbert@gondor.apana.org.au, ebiggers@google.com,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: [PATCH v4 14/32] crypto: arm64/aes-ce - switch to library version of key expansion routine
Date:   Tue,  2 Jul 2019 21:41:32 +0200
Message-Id: <20190702194150.10405-15-ard.biesheuvel@linaro.org>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190702194150.10405-1-ard.biesheuvel@linaro.org>
References: <20190702194150.10405-1-ard.biesheuvel@linaro.org>
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Switch to the new AES library that also provides an implementation of
the AES key expansion routine. This removes the dependency on the
generic AES cipher, allowing it to be omitted entirely in the future.

While at it, remove some references to the table based arm64 version
of AES and replace them with AES library calls as well.

Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
---
 arch/arm64/crypto/Kconfig    |  2 +-
 arch/arm64/crypto/aes-glue.c | 17 ++++++++++-------
 2 files changed, 11 insertions(+), 8 deletions(-)

diff --git a/arch/arm64/crypto/Kconfig b/arch/arm64/crypto/Kconfig
index 17bf5dc10aad..66dea518221c 100644
--- a/arch/arm64/crypto/Kconfig
+++ b/arch/arm64/crypto/Kconfig
@@ -96,7 +96,7 @@ config CRYPTO_AES_ARM64_NEON_BLK
 	depends on KERNEL_MODE_NEON
 	select CRYPTO_BLKCIPHER
 	select CRYPTO_AES_ARM64
-	select CRYPTO_AES
+	select CRYPTO_LIB_AES
 	select CRYPTO_SIMD
 
 config CRYPTO_CHACHA20_NEON
diff --git a/arch/arm64/crypto/aes-glue.c b/arch/arm64/crypto/aes-glue.c
index f0ceb545bd1e..3c80345d914f 100644
--- a/arch/arm64/crypto/aes-glue.c
+++ b/arch/arm64/crypto/aes-glue.c
@@ -26,7 +26,6 @@
 #ifdef USE_V8_CRYPTO_EXTENSIONS
 #define MODE			"ce"
 #define PRIO			300
-#define aes_setkey		ce_aes_setkey
 #define aes_expandkey		ce_aes_expandkey
 #define aes_ecb_encrypt		ce_aes_ecb_encrypt
 #define aes_ecb_decrypt		ce_aes_ecb_decrypt
@@ -42,8 +41,6 @@ MODULE_DESCRIPTION("AES-ECB/CBC/CTR/XTS using ARMv8 Crypto Extensions");
 #else
 #define MODE			"neon"
 #define PRIO			200
-#define aes_setkey		crypto_aes_set_key
-#define aes_expandkey		crypto_aes_expand_key
 #define aes_ecb_encrypt		neon_aes_ecb_encrypt
 #define aes_ecb_decrypt		neon_aes_ecb_decrypt
 #define aes_cbc_encrypt		neon_aes_cbc_encrypt
@@ -121,7 +118,14 @@ struct mac_desc_ctx {
 static int skcipher_aes_setkey(struct crypto_skcipher *tfm, const u8 *in_key,
 			       unsigned int key_len)
 {
-	return aes_setkey(crypto_skcipher_tfm(tfm), in_key, key_len);
+	struct crypto_aes_ctx *ctx = crypto_skcipher_ctx(tfm);
+	int ret;
+
+	ret = aes_expandkey(ctx, in_key, key_len);
+	if (ret)
+		crypto_skcipher_set_flags(tfm, CRYPTO_TFM_RES_BAD_KEY_LEN);
+
+	return ret;
 }
 
 static int xts_set_key(struct crypto_skcipher *tfm, const u8 *in_key,
@@ -649,15 +653,14 @@ static void mac_do_update(struct crypto_aes_ctx *ctx, u8 const in[], int blocks,
 		kernel_neon_end();
 	} else {
 		if (enc_before)
-			__aes_arm64_encrypt(ctx->key_enc, dg, dg, rounds);
+			aes_encrypt(ctx, dg, dg);
 
 		while (blocks--) {
 			crypto_xor(dg, in, AES_BLOCK_SIZE);
 			in += AES_BLOCK_SIZE;
 
 			if (blocks || enc_after)
-				__aes_arm64_encrypt(ctx->key_enc, dg, dg,
-						    rounds);
+				aes_encrypt(ctx, dg, dg);
 		}
 	}
 }
-- 
2.17.1


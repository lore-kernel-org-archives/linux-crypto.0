Return-Path: <SRS0=RljO=UV=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 24019C43613
	for <linux-crypto@archiver.kernel.org>; Sat, 22 Jun 2019 19:34:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id EB4E520657
	for <linux-crypto@archiver.kernel.org>; Sat, 22 Jun 2019 19:34:57 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="E9syHCVT"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726372AbfFVTe5 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Sat, 22 Jun 2019 15:34:57 -0400
Received: from mail-wm1-f68.google.com ([209.85.128.68]:39674 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726368AbfFVTe5 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sat, 22 Jun 2019 15:34:57 -0400
Received: by mail-wm1-f68.google.com with SMTP id z23so9601914wma.4
        for <linux-crypto@vger.kernel.org>; Sat, 22 Jun 2019 12:34:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=MzqBn3zXqdqT5rykfpJWuWfbyyxJXTIyDmCZ4k6FneI=;
        b=E9syHCVTDPMLucp3RnHYQY+qNyIRICSrZTsJqEdZrKZuMfKt3+rLxR8wHsUFgFIZWf
         pO6ESMNs4KklPu6xy8TI0JkA/eaG9YXQH9RGWVPtfNDP0TAarTi+NO2LNrQG/V/DDwHL
         YiScaHnLm0FE3ujt6oUYT4vsSWF0OK90rYRAgVHfx2uXxol+cm0MnR4bpY70TgQqOboY
         +Spm9I5Gb96zoOvkVBnAJIG4WVi72ZNpGfxOSKyrILQJkFtnqo0B/dU4DTRWIFzR6wtP
         LyeTY+AqYgDNzyqEtkj2yIEX4x8zf34dwPEFeUIqfZe2G3LSFAoU32h02rt+3i0Rv3IR
         B4DQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=MzqBn3zXqdqT5rykfpJWuWfbyyxJXTIyDmCZ4k6FneI=;
        b=PDZ6jtx0QTQ1ycK5vqhIwlZ/1BKr5iKnfIxVwDEPrDjAQe7e+IR+6Dn/tFJPGiRY/l
         ffPbCvR1wwos6NnkOzGEU9oeUeOsCOKHZVuwdE+cbHo7kdgnZuGxMKLn42mtu6dVRnls
         x77c/h26rkbV/Egx2K+SxlDCsvGPEmmLSeFPCKK++C1wfm+au2fiQJdTI8cz2xAK2TyY
         iV8VZ/UD23nvvpNrPnwVyNwALv7bq8w0dFW7ITEfXj9N+sIU3iLk+J1kFSgG/65jljz1
         f2kwjhtozu0T8GkbLC2/IbdCIe8222FTfVyUNbNUs4SsVzSEb8oZEz+Bw8UOveV1Mrj+
         J4ow==
X-Gm-Message-State: APjAAAW4P46PgLeadGQQqG+OtT17WiuioFn2qY24wg03qrJKjWOL5N7K
        8nmHLXzQgRBAqaoeqtcxYHA9k9fCmZicuzNh
X-Google-Smtp-Source: APXvYqyopogrUaQ2/5eKKmfxxD1CoUu7HIEjS5qvAoW5Wzo5a4mW5w/S71IP/U8c2M5pT16cpMJCwA==
X-Received: by 2002:a7b:cf27:: with SMTP id m7mr8911315wmg.7.1561232095024;
        Sat, 22 Jun 2019 12:34:55 -0700 (PDT)
Received: from sudo.home ([2a01:cb1d:112:6f00:4bd:3f91:4ef8:ae7e])
        by smtp.gmail.com with ESMTPSA id h8sm4814494wmf.12.2019.06.22.12.34.54
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 22 Jun 2019 12:34:54 -0700 (PDT)
From:   Ard Biesheuvel <ard.biesheuvel@linaro.org>
To:     linux-crypto@vger.kernel.org
Cc:     herbert@gondor.apana.org.au, ebiggers@google.com,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: [PATCH v2 14/26] crypto: arm64/aes-ce - switch to library version of key expansion routine
Date:   Sat, 22 Jun 2019 21:34:15 +0200
Message-Id: <20190622193427.20336-15-ard.biesheuvel@linaro.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190622193427.20336-1-ard.biesheuvel@linaro.org>
References: <20190622193427.20336-1-ard.biesheuvel@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
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
2.20.1


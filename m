Return-Path: <SRS0=CUNG=U2=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 21776C48BD7
	for <linux-crypto@archiver.kernel.org>; Thu, 27 Jun 2019 10:28:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id EFC462086D
	for <linux-crypto@archiver.kernel.org>; Thu, 27 Jun 2019 10:28:09 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="lHyUdSKe"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726675AbfF0K2J (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 27 Jun 2019 06:28:09 -0400
Received: from mail-wm1-f67.google.com ([209.85.128.67]:52168 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726669AbfF0K2H (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 27 Jun 2019 06:28:07 -0400
Received: by mail-wm1-f67.google.com with SMTP id 207so5186408wma.1
        for <linux-crypto@vger.kernel.org>; Thu, 27 Jun 2019 03:28:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=MzqBn3zXqdqT5rykfpJWuWfbyyxJXTIyDmCZ4k6FneI=;
        b=lHyUdSKe1Lk4pZMIN7FFIlIwZlX62h6Y1D9LbZs1h2DKVMvn94II8Uq4bnkgX+YZ0v
         B55cG8ghG/UxT5BEEOodD0MeIoi1USJWDmgUUMqBZ+C52oXiwjlMXncuUtesY2pVgXvn
         bPLE2EKwzfnOvvuUl75A4NfbEXnCPfsUqUc4hbjznDd4LmIRqQtYAyHOHLfAtPw27JJj
         3czkG3oW+9SyzYDAu77W+SIsSJovDedQKYNu+J+d+nw9g8XHrhhAH2+HMCGaIlOeEVcB
         CefOdjmQvXMViw2+eveNANXaGDLE1QkiTJFR87NCiuW5CKF5N/wFHCJQItcW5o17Fs43
         29YQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=MzqBn3zXqdqT5rykfpJWuWfbyyxJXTIyDmCZ4k6FneI=;
        b=O13YD+0maXkRKUfTHB24Qc5JLNTsk4Epmbfce19iwld4rhHH7f5QM04Vi1So090rKo
         7FF/dZU0peOoLHInSKeAc9ls+TrzbeH3w3n/GImyVLZXhnBlnXEFVOQ9vMCI+g7y5/+3
         XwUM308WUibUmYP4hG2M91111/qYhY1FiBemwr9wBGDTSclei1plinCkuL/X7PdVelDH
         gXzrlCCh7eqihOrbgkQn7+g7fDZ95KSUGW2M2kNSflO34Q4p93HPJZcv9dNQek6gJ11t
         6ZHqgWBrBt7HktE+MviOC4v7Zbp7+BaIRaNj0243OCNtPszKwjunFXPFXAERZk4hs7WO
         F6vg==
X-Gm-Message-State: APjAAAUDD9j7u3vlxtSLOppzSqzO6VUi9BSgZaTvwUj7+P6coE9/Wzja
        J2s83eRouZeXvUMS/kqqBmDtrSZC0k4=
X-Google-Smtp-Source: APXvYqyeCXmgcZEFG1jwS7h4lvpPRFRkCxBuGQKehyVqtJafl3tlKdH+3HiV3QvAOLn8eVjJ3rDtIA==
X-Received: by 2002:a1c:1bc1:: with SMTP id b184mr2926031wmb.42.1561631285978;
        Thu, 27 Jun 2019 03:28:05 -0700 (PDT)
Received: from localhost.localdomain (aaubervilliers-681-1-8-173.w90-88.abo.wanadoo.fr. [90.88.13.173])
        by smtp.gmail.com with ESMTPSA id g2sm5584533wmh.0.2019.06.27.03.28.04
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Thu, 27 Jun 2019 03:28:05 -0700 (PDT)
From:   Ard Biesheuvel <ard.biesheuvel@linaro.org>
To:     linux-crypto@vger.kernel.org
Cc:     herbert@gondor.apana.org.au, ebiggers@kernel.org,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: [PATCH v3 14/32] crypto: arm64/aes-ce - switch to library version of key expansion routine
Date:   Thu, 27 Jun 2019 12:26:29 +0200
Message-Id: <20190627102647.2992-15-ard.biesheuvel@linaro.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190627102647.2992-1-ard.biesheuvel@linaro.org>
References: <20190627102647.2992-1-ard.biesheuvel@linaro.org>
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


Return-Path: <SRS0=CUNG=U2=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3A4D7C48BDB
	for <linux-crypto@archiver.kernel.org>; Thu, 27 Jun 2019 10:28:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 146DA208CB
	for <linux-crypto@archiver.kernel.org>; Thu, 27 Jun 2019 10:28:23 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="bY+OLwCR"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726462AbfF0K2V (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 27 Jun 2019 06:28:21 -0400
Received: from mail-wr1-f68.google.com ([209.85.221.68]:38343 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726682AbfF0K2S (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 27 Jun 2019 06:28:18 -0400
Received: by mail-wr1-f68.google.com with SMTP id d18so1923029wrs.5
        for <linux-crypto@vger.kernel.org>; Thu, 27 Jun 2019 03:28:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=h9xdExBrqYFWsuLQCJksPQkQTr4z/marqcQjFd4StkE=;
        b=bY+OLwCRpBmnowhgehO5dqYTwvrIIXAtSeaPTWQypdaJtfTLWdzos7Shnt5ZWRSLT3
         HqUEYEnmcXzXLOVxxOdef9ETkAF3VOxK0o697B90/JL4GyxGDQ86vPY4707hnY+TFH1D
         mx6cvKlM2dySCzI2ilc0FTXHPzkjnB1A/cjNoe/emKsOYcGDzhtPLDXm4jmLc89LRcvB
         hqh9cbVU7QEdJtC7998ZiFohjsFGLpa2rEr9sRYe/LhXiXwvKaKgK3CqpCEqSdFln3ht
         l3mQWZ+dfLWGkGNUuUlexCwMTx6S/QEclc1Sm/hMKlx9b4LatfP73dNpY2PkvA1m7qYN
         RVFQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=h9xdExBrqYFWsuLQCJksPQkQTr4z/marqcQjFd4StkE=;
        b=EsWnWoNC+5VfjpZUUKEjePKV2y5/g1vYi1u0E4yfVDStkoObAX75YLq3VCW9LUvuSr
         6A6QZrBnG5n44PswheGYTWMDivpsPKLCNBwYM5Z5+AEaRafwGidP5yiCQv4FX7/7Oz6j
         9G1lxzTtIbcvrn1Firr9FxP7jAMwI0WXIlKRCfcfVEB0BNS32hPN/A54q/uRudOYf0XH
         znP7jXj+JjBpzk2RBVeKSr41zpgP7r7VK/dW1H2AgKtUMgCmAvReWx5pNcBtvtoaGiIY
         KaKhNR/fdk9BL0sXzEl3oUq8GTYcArBtWIdFxd9lLX6iM51EphD05xJQiNDPbFa6BnGk
         fmTg==
X-Gm-Message-State: APjAAAWXp7gL/HEOdltPaGWTuhNpHO9ey3C+yKCpJ7xE8YHObGK5GTc8
        kkP/gSFw9pZQm/kbes6E0ecwyzo1Slk=
X-Google-Smtp-Source: APXvYqxmlzY6WJqXcm+jusuE50s3ZHygVT+MisEpqk6Tz/DRcXaVD0xeJFT6qMg1lvk1TPfpz1BttQ==
X-Received: by 2002:a5d:4647:: with SMTP id j7mr2804360wrs.334.1561631296694;
        Thu, 27 Jun 2019 03:28:16 -0700 (PDT)
Received: from localhost.localdomain (aaubervilliers-681-1-8-173.w90-88.abo.wanadoo.fr. [90.88.13.173])
        by smtp.gmail.com with ESMTPSA id g2sm5584533wmh.0.2019.06.27.03.28.15
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Thu, 27 Jun 2019 03:28:16 -0700 (PDT)
From:   Ard Biesheuvel <ard.biesheuvel@linaro.org>
To:     linux-crypto@vger.kernel.org
Cc:     herbert@gondor.apana.org.au, ebiggers@kernel.org,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: [PATCH v3 24/32] crypto: amcc/aes - switch to AES library for GCM key derivation
Date:   Thu, 27 Jun 2019 12:26:39 +0200
Message-Id: <20190627102647.2992-25-ard.biesheuvel@linaro.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190627102647.2992-1-ard.biesheuvel@linaro.org>
References: <20190627102647.2992-1-ard.biesheuvel@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

The AMCC code for GCM key derivation allocates a AES cipher to
perform a single block encryption. So let's switch to the new
and more lightweight AES library instead.

Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
---
 drivers/crypto/Kconfig              |  2 +-
 drivers/crypto/amcc/crypto4xx_alg.c | 24 +++++++-------------
 2 files changed, 9 insertions(+), 17 deletions(-)

diff --git a/drivers/crypto/Kconfig b/drivers/crypto/Kconfig
index b30b84089d11..c7ac1e6d23d4 100644
--- a/drivers/crypto/Kconfig
+++ b/drivers/crypto/Kconfig
@@ -311,7 +311,7 @@ config CRYPTO_DEV_PPC4XX
 	depends on PPC && 4xx
 	select CRYPTO_HASH
 	select CRYPTO_AEAD
-	select CRYPTO_AES
+	select CRYPTO_LIB_AES
 	select CRYPTO_CCM
 	select CRYPTO_CTR
 	select CRYPTO_GCM
diff --git a/drivers/crypto/amcc/crypto4xx_alg.c b/drivers/crypto/amcc/crypto4xx_alg.c
index 26f86fd7532b..d3660703a36c 100644
--- a/drivers/crypto/amcc/crypto4xx_alg.c
+++ b/drivers/crypto/amcc/crypto4xx_alg.c
@@ -536,28 +536,20 @@ static int crypto4xx_aes_gcm_validate_keylen(unsigned int keylen)
 static int crypto4xx_compute_gcm_hash_key_sw(__le32 *hash_start, const u8 *key,
 					     unsigned int keylen)
 {
-	struct crypto_cipher *aes_tfm = NULL;
+	struct crypto_aes_ctx ctx;
 	uint8_t src[16] = { 0 };
-	int rc = 0;
-
-	aes_tfm = crypto_alloc_cipher("aes", 0, CRYPTO_ALG_NEED_FALLBACK);
-	if (IS_ERR(aes_tfm)) {
-		rc = PTR_ERR(aes_tfm);
-		pr_warn("could not load aes cipher driver: %d\n", rc);
-		return rc;
-	}
+	int rc;
 
-	rc = crypto_cipher_setkey(aes_tfm, key, keylen);
+	rc = aes_expandkey(&ctx, key, keylen);
 	if (rc) {
-		pr_err("setkey() failed: %d\n", rc);
-		goto out;
+		pr_err("aes_expandkey() failed: %d\n", rc);
+		return rc;
 	}
 
-	crypto_cipher_encrypt_one(aes_tfm, src, src);
+	aes_encrypt(&ctx, src, src);
 	crypto4xx_memcpy_to_le32(hash_start, src, 16);
-out:
-	crypto_free_cipher(aes_tfm);
-	return rc;
+	memzero_explicit(&ctx, sizeof(ctx));
+	return 0;
 }
 
 int crypto4xx_setkey_aes_gcm(struct crypto_aead *cipher,
-- 
2.20.1


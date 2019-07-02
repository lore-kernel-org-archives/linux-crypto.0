Return-Path: <SRS0=X5ob=U7=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4D9A9C06513
	for <linux-crypto@archiver.kernel.org>; Tue,  2 Jul 2019 19:42:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2C08521850
	for <linux-crypto@archiver.kernel.org>; Tue,  2 Jul 2019 19:42:45 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="a5jJXAy9"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727077AbfGBTmo (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 2 Jul 2019 15:42:44 -0400
Received: from mail-lj1-f196.google.com ([209.85.208.196]:33804 "EHLO
        mail-lj1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727069AbfGBTmo (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 2 Jul 2019 15:42:44 -0400
Received: by mail-lj1-f196.google.com with SMTP id p17so18207336ljg.1
        for <linux-crypto@vger.kernel.org>; Tue, 02 Jul 2019 12:42:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=VQ3v2advvdDgCgxLjFb+IrRE2Pm4FCw8P9b47+HGrWM=;
        b=a5jJXAy92Km3JOrJb1aLFv81FKj0y0B7GbXDsQYA6S9sCF7LQ+4cgq2FzJ0aWjb2IO
         jOC4O2jvHItRVgMr6MNswrwrvMeThRyJahksL6CaXzHKeidi9tS7FIKY4h3euKKm/rd1
         AUJAzD7foHXEnzcD+8KF52+idI7CA6Hz/8vLNgFRqVVl/lzqVGyCewaS0qcIxxCYJjJx
         zD2m5wvm8N7E8CJK8tXItzf1VH2gYxsMOQsiCuldxQFSA3lQHMqbfjxFT2YzO9u0uY3v
         37Nu9xVjcQ0RARCYxPPpwBZzW+y5eCXS3+S8hS/QSgdJURoYc6EF6LTtSXb5R089xFuj
         8kuw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=VQ3v2advvdDgCgxLjFb+IrRE2Pm4FCw8P9b47+HGrWM=;
        b=tcLadTcVuxirM7gylzF7BfQ5uv9xD/Ct6Fq8wqey1cYWxFWctC0RnNEbUbl9ZEz8dh
         u2FK8UlYsMDqLpK+auuuIxIuW+MDTvRHeGXdDQt1B3bFmzySdbwLkl3rftWyjRaTBGmQ
         XLd5kEEyctybCBwRotKDF74wZ2zjPL70O3+G0Gn2KSZUDl3gxydlTP9OAJH0pVXEEOxJ
         u0AT9bBTPK1klFbjgHkPUHyZSU3bnw3YFWKOdiKcIOeKl6Fe1ND3e4mNwzAut4Xhwgos
         5t5nvct7FqGLCh+lcNhkRA1ajMISsYYEf6Fv9qmXwfozlnHy8EtmFoFcUIxrVJRjisxt
         3byw==
X-Gm-Message-State: APjAAAUYb3Dgw2B5XDTH4IWlIJsCIzCpW/KL/SE5PLXe0Rtblri3EYNs
        sVvKJfgEY3nweM7ip4UWHFSkrd9AVjzVuIdj
X-Google-Smtp-Source: APXvYqww2aSSG6JkCf1FZIfm2ad3PlfnzS/q/TkLolj0bkyOPQTLjF2m0NGGswBR5sj/MrKIp+mqQw==
X-Received: by 2002:a2e:3c1a:: with SMTP id j26mr18680446lja.230.1562096562363;
        Tue, 02 Jul 2019 12:42:42 -0700 (PDT)
Received: from e111045-lin.arm.com (89-212-78-239.static.t-2.net. [89.212.78.239])
        by smtp.gmail.com with ESMTPSA id 24sm4475163ljs.63.2019.07.02.12.42.40
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Tue, 02 Jul 2019 12:42:41 -0700 (PDT)
From:   Ard Biesheuvel <ard.biesheuvel@linaro.org>
To:     linux-crypto@vger.kernel.org
Cc:     herbert@gondor.apana.org.au, ebiggers@google.com,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: [PATCH v4 24/32] crypto: amcc/aes - switch to AES library for GCM key derivation
Date:   Tue,  2 Jul 2019 21:41:42 +0200
Message-Id: <20190702194150.10405-25-ard.biesheuvel@linaro.org>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190702194150.10405-1-ard.biesheuvel@linaro.org>
References: <20190702194150.10405-1-ard.biesheuvel@linaro.org>
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
2.17.1


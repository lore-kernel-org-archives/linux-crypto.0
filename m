Return-Path: <SRS0=xlya=UL=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BD253C31E46
	for <linux-crypto@archiver.kernel.org>; Wed, 12 Jun 2019 12:49:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 932CB20684
	for <linux-crypto@archiver.kernel.org>; Wed, 12 Jun 2019 12:49:04 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="QQVIHwG+"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2439221AbfFLMtE (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 12 Jun 2019 08:49:04 -0400
Received: from mail-wr1-f67.google.com ([209.85.221.67]:33321 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2439227AbfFLMtD (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 12 Jun 2019 08:49:03 -0400
Received: by mail-wr1-f67.google.com with SMTP id n9so16819986wru.0
        for <linux-crypto@vger.kernel.org>; Wed, 12 Jun 2019 05:49:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=0+abpCskFH64uUUzWz6MrJWQeWRPxd08F5mJmqOJSaY=;
        b=QQVIHwG+58pKXs93jYTMJMczRFAiZL6Osuf0fx9Pjt7dZUy4dQChhWMUhYfFvg7pxs
         9BGqIDU/W51lXSWRCmpOTUpeKjNKQTTqZwtZmBloToenu9UQCO8ntGIQ9KZ7q3Hu0BkT
         t6C3vaBcpqxkn6eYbJWda9Qj18jzYaVseMnPS0tB9NF1/BpN7NPRcsTk4Q4aAQEW4FaL
         5npBgrH+mtyv5bDOOLYLRvy1pyE1FKdf340PRXY42yOqQFlTp/AfIpGmhZzURAVbtPXt
         rmHdOi2UWHK6jOcFKjhOdmXjErwtWLZGQkM5S0FqBxPsD7T1yIcnGpxZOu3/7iTOI8Qk
         W8JQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=0+abpCskFH64uUUzWz6MrJWQeWRPxd08F5mJmqOJSaY=;
        b=PloMp0R5RsmwBSnlAeypGMTCOFO29t4EDaWlZJ4URusc+WxpyXrNYyCgDVhniFUNHi
         AAWuOsvv4YHHMUjx1QNu9nPkaBEt8mhgXnzorWQM+YCaN7tHvP+v8ZfB6d763/WcDzOQ
         bYbcJpUUoL8n3HUc2CJJYWedVWPsOZGHL1DKrvHa9w+T7cUJ44upg3U/qToubBPM+7Vu
         kPv9zJDVPw51h+RY5ucF+0hu/ix5FKkzuGs3HH+QJYcQzsxeBGyaPRpeixnp3EMYsN/v
         V6inSFo4nMscLacLncOz0JtJCdj6K37xzWFLqkeXlxbuBr4CzN3oKMOaayRXqEnbdDWo
         PubQ==
X-Gm-Message-State: APjAAAUtqGt+G3Gj0pOIj2Ti6+/Ji8XMuHdUR+gcH5tgNZdusO0uL/46
        /1M/Vj+eY2Z/a+VgMm9/xHTvZaUtQ5INOQ==
X-Google-Smtp-Source: APXvYqwDvJjTphhGVfRVAXKf2dTT6/qcC6XV+OpUvl+k25P9W6KERVmuTVVakLLVagc8CNQDvo247w==
X-Received: by 2002:a5d:43c9:: with SMTP id v9mr53672758wrr.70.1560343741335;
        Wed, 12 Jun 2019 05:49:01 -0700 (PDT)
Received: from sudo.home ([2a01:cb1d:112:6f00:353a:f33a:a393:3ada])
        by smtp.gmail.com with ESMTPSA id s8sm28505480wra.55.2019.06.12.05.49.00
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 12 Jun 2019 05:49:00 -0700 (PDT)
From:   Ard Biesheuvel <ard.biesheuvel@linaro.org>
To:     linux-crypto@vger.kernel.org
Cc:     herbert@gondor.apana.org.au, ebiggers@kernel.org,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: [RFC PATCH 13/20] crypto: arm64/aes-neonbs - switch to library version of key expansion routine
Date:   Wed, 12 Jun 2019 14:48:31 +0200
Message-Id: <20190612124838.2492-14-ard.biesheuvel@linaro.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190612124838.2492-1-ard.biesheuvel@linaro.org>
References: <20190612124838.2492-1-ard.biesheuvel@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Switch to the new AES library that also provides an implementation of
the AES key expansion routine. This removes the dependency on the
generic AES cipher, allowing it to be omitted entirely in the future.

Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
---
 arch/arm64/crypto/Kconfig           | 1 +
 arch/arm64/crypto/aes-neonbs-glue.c | 8 ++++----
 2 files changed, 5 insertions(+), 4 deletions(-)

diff --git a/arch/arm64/crypto/Kconfig b/arch/arm64/crypto/Kconfig
index c6032bfb44fb..17bf5dc10aad 100644
--- a/arch/arm64/crypto/Kconfig
+++ b/arch/arm64/crypto/Kconfig
@@ -116,6 +116,7 @@ config CRYPTO_AES_ARM64_BS
 	select CRYPTO_BLKCIPHER
 	select CRYPTO_AES_ARM64_NEON_BLK
 	select CRYPTO_AES_ARM64
+	select CRYPTO_LIB_AES
 	select CRYPTO_SIMD
 
 endif
diff --git a/arch/arm64/crypto/aes-neonbs-glue.c b/arch/arm64/crypto/aes-neonbs-glue.c
index 02b65d9eb947..cb8d90f795a0 100644
--- a/arch/arm64/crypto/aes-neonbs-glue.c
+++ b/arch/arm64/crypto/aes-neonbs-glue.c
@@ -77,7 +77,7 @@ static int aesbs_setkey(struct crypto_skcipher *tfm, const u8 *in_key,
 	struct crypto_aes_ctx rk;
 	int err;
 
-	err = crypto_aes_expand_key(&rk, in_key, key_len);
+	err = aes_expandkey(&rk, in_key, key_len);
 	if (err)
 		return err;
 
@@ -136,7 +136,7 @@ static int aesbs_cbc_setkey(struct crypto_skcipher *tfm, const u8 *in_key,
 	struct crypto_aes_ctx rk;
 	int err;
 
-	err = crypto_aes_expand_key(&rk, in_key, key_len);
+	err = aes_expandkey(&rk, in_key, key_len);
 	if (err)
 		return err;
 
@@ -208,7 +208,7 @@ static int aesbs_ctr_setkey_sync(struct crypto_skcipher *tfm, const u8 *in_key,
 	struct aesbs_ctr_ctx *ctx = crypto_skcipher_ctx(tfm);
 	int err;
 
-	err = crypto_aes_expand_key(&ctx->fallback, in_key, key_len);
+	err = aes_expandkey(&ctx->fallback, in_key, key_len);
 	if (err)
 		return err;
 
@@ -274,7 +274,7 @@ static int aesbs_xts_setkey(struct crypto_skcipher *tfm, const u8 *in_key,
 		return err;
 
 	key_len /= 2;
-	err = crypto_aes_expand_key(&rk, in_key + key_len, key_len);
+	err = aes_expandkey(&rk, in_key + key_len, key_len);
 	if (err)
 		return err;
 
-- 
2.20.1


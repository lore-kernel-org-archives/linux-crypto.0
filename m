Return-Path: <SRS0=xlya=UL=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B9C7FC31E48
	for <linux-crypto@archiver.kernel.org>; Wed, 12 Jun 2019 12:49:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9446E20684
	for <linux-crypto@archiver.kernel.org>; Wed, 12 Jun 2019 12:49:05 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="fqMYY52G"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2439230AbfFLMtF (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 12 Jun 2019 08:49:05 -0400
Received: from mail-wm1-f68.google.com ([209.85.128.68]:36706 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2439229AbfFLMtE (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 12 Jun 2019 08:49:04 -0400
Received: by mail-wm1-f68.google.com with SMTP id u8so6408977wmm.1
        for <linux-crypto@vger.kernel.org>; Wed, 12 Jun 2019 05:49:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=mCCXO8E7dxoAfZNPGu9MWapyiMaDRiD0qXpOpKK9sPY=;
        b=fqMYY52GJRSJB7nqoddTnyp+yHfTI4dqn1gGxnvbszw1xwXLpymiUOIvsEFUqtxu83
         fQread8hii0ShQ9ZUt0SZGprEoruVA1ff2dNsbTw4RwhxHZd6421rgtPir31C+yCEkMA
         udlT8SXMf/1FVfEtypI30iKKpOj8TCOG7nsu3/mj4jRfYl8Gi00jCNYqTaACz20+9aRU
         YcV+79O433Gzyiz/XeFGnmEmCBtjzXd15OOEpRBtDc2nxOQ17Q9iz/Yc9rDEeZii3WPw
         SrfK0zS5RXjo7u3jCzWgrsG8IhdT1UJrnKaKjU9lXpwBZhvzBEWntV04Mhbm+keYn6CH
         PbHQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=mCCXO8E7dxoAfZNPGu9MWapyiMaDRiD0qXpOpKK9sPY=;
        b=becOtEKy9cH4+/vK1lHSzhRlkD4FA8E87WqqYZiJKveUGtHhBBDhFmiZgqJ5quc+7w
         YYVMKmX4OJMS+YhVJgigJkfhI8XWgaL4R9mCFpMJZ+2yOE/UKU9XJWNAH0lZzoPrFvkG
         4N9u5dfNugBCre6pTpnmWXbeVXaq73wHHbdXNl8f0nn0QAgAGIcdfymj2LJ5OW0t8mjp
         jLG2LlEDa9YWiNiTZ8tfA2uwAInJHsSQYOqtVjh4kwyqu/rLCgzuzehv0dfXtNlTqewt
         CYoCQ/E2NQWNh/y0Dz3yskyrIzF8vqrd2D3tC3bT3B3Kq6pcakPI6fo1TX/8bGobECpc
         HIww==
X-Gm-Message-State: APjAAAX/rSS6jOFrxYEy6EuEdniiiJ3S08ay6/bYr20np/GE9KE1S2+p
        Lho/7KcgbpzMaW+Pxb1JhGo5dHBwNZCB1w==
X-Google-Smtp-Source: APXvYqwdxVdPmO4Y4CaMxhkX0EkIeu+J3Lqpzi3pJpPoHcmWYZO/DJrER87cgEzDVOz687H5gdo01A==
X-Received: by 2002:a1c:2c41:: with SMTP id s62mr22013608wms.8.1560343742297;
        Wed, 12 Jun 2019 05:49:02 -0700 (PDT)
Received: from sudo.home ([2a01:cb1d:112:6f00:353a:f33a:a393:3ada])
        by smtp.gmail.com with ESMTPSA id s8sm28505480wra.55.2019.06.12.05.49.01
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 12 Jun 2019 05:49:01 -0700 (PDT)
From:   Ard Biesheuvel <ard.biesheuvel@linaro.org>
To:     linux-crypto@vger.kernel.org
Cc:     herbert@gondor.apana.org.au, ebiggers@kernel.org,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: [RFC PATCH 14/20] crypto: arm64/aes-ce - switch to library version of key expansion routine
Date:   Wed, 12 Jun 2019 14:48:32 +0200
Message-Id: <20190612124838.2492-15-ard.biesheuvel@linaro.org>
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
 arch/arm64/crypto/Kconfig    |  2 +-
 arch/arm64/crypto/aes-glue.c | 12 ++++++++----
 2 files changed, 9 insertions(+), 5 deletions(-)

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
index f0ceb545bd1e..8fa17a764802 100644
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
-- 
2.20.1


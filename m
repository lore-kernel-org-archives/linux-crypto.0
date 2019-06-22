Return-Path: <SRS0=RljO=UV=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 539ADC43613
	for <linux-crypto@archiver.kernel.org>; Sat, 22 Jun 2019 00:32:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 28C4A2084E
	for <linux-crypto@archiver.kernel.org>; Sat, 22 Jun 2019 00:32:12 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="VISEf18Q"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726250AbfFVAcL (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 21 Jun 2019 20:32:11 -0400
Received: from mail-wr1-f66.google.com ([209.85.221.66]:40829 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726212AbfFVAcK (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 21 Jun 2019 20:32:10 -0400
Received: by mail-wr1-f66.google.com with SMTP id p11so8100477wre.7
        for <linux-crypto@vger.kernel.org>; Fri, 21 Jun 2019 17:32:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=8ECamVGrenRrFvw0EKJFpRTvGkUBrF3jVsxmqTaUFNc=;
        b=VISEf18QwcsCpnpxGjFbR3q7mDOPmNA/ZtZ14P/RgS2SnOGoJ/MqIHKwpl8YCWaepm
         +YdcjYANEv5+lHp+k/EYrTRRNH8he5iBVgHgy0qIIuQjTuNM4mzHqVZwmgLUTo3vmY4c
         8Jsc5GsLp+eU+AW3Dyoq3zQ54rbcE22GhPvoRMR8AWTaHbBtLa8Z6U+heezqmVIoDxiq
         3vx0b4XPWkX8IxlowU6e36Cd/wNKIpCX4g+de++znJpUs5yYdMLYijcDIkSggg4j9NV+
         JsQiq0bDan1AxjEWThfjmdA38cN7SNtxuWkEeZJyVA2TLMcmZPlQ3KQKLfgUhmveQyes
         P2IQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=8ECamVGrenRrFvw0EKJFpRTvGkUBrF3jVsxmqTaUFNc=;
        b=Y7DDmViR9A1Ge4nXZK6z7bA+86+/qilTnM6rCguD7lpK8gl6yw6G3vJzemdHbGUqKk
         eham0dPlqj9sMokNpkpukySx2JvwaBWX6E4Yy2x9HP+hEys30C+MmL/fGCNKOE8H4g3X
         X9GreKMIqiO+fXYUNXUW8bMXxDQDAvRgpzOBRbLhfM5n8gfL1QH4MyyolBzQo4YPVsHE
         QysfONWygz29Ro97kHbkxYAE6y7GIgkI51KeBkDalbxX8e2EPxJwlxYF0q0V7cD5kpD7
         JIFBc+Q0BXPGddyagvpORrrKTBnpJGUhQhBv4QON5GhX4EmDyBzF1ptye4KIwooyiqv1
         UDeg==
X-Gm-Message-State: APjAAAXJVUxym2Im7L3Jcab4HAU3xRlKGeCMzQ2G+MYqFFm4TefqX5Hu
        K9cgmalXjTFujasrVjh+jK41o0xz3qD6fR29
X-Google-Smtp-Source: APXvYqxE9Rq3t5KkdDQEkMWwGJ3KZFQ2jUZAGDR8Y1KV+aD8D03VlNZ5l/Sksuj7Oy3LBS5vv5L/Ag==
X-Received: by 2002:a5d:4992:: with SMTP id r18mr7274973wrq.107.1561163528517;
        Fri, 21 Jun 2019 17:32:08 -0700 (PDT)
Received: from sudo.home ([2a01:cb1d:112:6f00:99d4:1ff0:ed6:dfbb])
        by smtp.gmail.com with ESMTPSA id v18sm4792019wrd.51.2019.06.21.17.32.07
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 21 Jun 2019 17:32:07 -0700 (PDT)
From:   Ard Biesheuvel <ard.biesheuvel@linaro.org>
To:     linux-crypto@vger.kernel.org
Cc:     herbert@gondor.apana.org.au, ebiggers@google.com,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: [RFC PATCH 23/30] crypto: talitos/des - switch to new verification routines
Date:   Sat, 22 Jun 2019 02:31:05 +0200
Message-Id: <20190622003112.31033-24-ard.biesheuvel@linaro.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190622003112.31033-1-ard.biesheuvel@linaro.org>
References: <20190622003112.31033-1-ard.biesheuvel@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
---
 drivers/crypto/talitos.c | 33 +++++++-------------
 1 file changed, 11 insertions(+), 22 deletions(-)

diff --git a/drivers/crypto/talitos.c b/drivers/crypto/talitos.c
index c865f5d5eaba..ec759576ebd3 100644
--- a/drivers/crypto/talitos.c
+++ b/drivers/crypto/talitos.c
@@ -30,7 +30,7 @@
 
 #include <crypto/algapi.h>
 #include <crypto/aes.h>
-#include <crypto/des.h>
+#include <crypto/internal/des.h>
 #include <crypto/sha.h>
 #include <crypto/md5.h>
 #include <crypto/internal/aead.h>
@@ -920,16 +920,11 @@ static int aead_des3_setkey(struct crypto_aead *authenc,
 	if (keys.authkeylen + keys.enckeylen > TALITOS_MAX_KEY_SIZE)
 		goto badkey;
 
-	if (keys.enckeylen != DES3_EDE_KEY_SIZE)
+	err = crypto_des3_ede_verify_key(crypto_aead_tfm(authenc), keys.enckey,
+					 keys.enckeylen);
+	if (unlikely(err))
 		goto badkey;
 
-	flags = crypto_aead_get_flags(authenc);
-	err = __des3_verify_key(&flags, keys.enckey);
-	if (unlikely(err)) {
-		crypto_aead_set_flags(authenc, flags);
-		goto out;
-	}
-
 	if (ctx->keylen)
 		dma_unmap_single(dev, ctx->dma_key, ctx->keylen, DMA_TO_DEVICE);
 
@@ -1538,14 +1533,11 @@ static int ablkcipher_setkey(struct crypto_ablkcipher *cipher,
 static int ablkcipher_des_setkey(struct crypto_ablkcipher *cipher,
 				 const u8 *key, unsigned int keylen)
 {
-	u32 tmp[DES_EXPKEY_WORDS];
+	int err;
 
-	if (unlikely(crypto_ablkcipher_get_flags(cipher) &
-		     CRYPTO_TFM_REQ_FORBID_WEAK_KEYS) &&
-	    !des_ekey(tmp, key)) {
-		crypto_ablkcipher_set_flags(cipher, CRYPTO_TFM_RES_WEAK_KEY);
-		return -EINVAL;
-	}
+	err = crypto_des_verify_key(crypto_ablkcipher_tfm(cipher), key, keylen);
+	if (unlikely(err))
+		return err;
 
 	return ablkcipher_setkey(cipher, key, keylen);
 }
@@ -1553,15 +1545,12 @@ static int ablkcipher_des_setkey(struct crypto_ablkcipher *cipher,
 static int ablkcipher_des3_setkey(struct crypto_ablkcipher *cipher,
 				  const u8 *key, unsigned int keylen)
 {
-	u32 flags;
 	int err;
 
-	flags = crypto_ablkcipher_get_flags(cipher);
-	err = __des3_verify_key(&flags, key);
-	if (unlikely(err)) {
-		crypto_ablkcipher_set_flags(cipher, flags);
+	err = crypto_des3_ede_verify_key(crypto_ablkcipher_tfm(cipher), key,
+					 keylen);
+	if (unlikely(err))
 		return err;
-	}
 
 	return ablkcipher_setkey(cipher, key, keylen);
 }
-- 
2.20.1


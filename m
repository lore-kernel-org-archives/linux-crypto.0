Return-Path: <SRS0=RljO=UV=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 07C80C43613
	for <linux-crypto@archiver.kernel.org>; Sat, 22 Jun 2019 00:32:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D16D72084E
	for <linux-crypto@archiver.kernel.org>; Sat, 22 Jun 2019 00:32:05 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="tE4G1zc5"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726215AbfFVAcF (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 21 Jun 2019 20:32:05 -0400
Received: from mail-wm1-f68.google.com ([209.85.128.68]:37724 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726141AbfFVAcD (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 21 Jun 2019 20:32:03 -0400
Received: by mail-wm1-f68.google.com with SMTP id f17so8103112wme.2
        for <linux-crypto@vger.kernel.org>; Fri, 21 Jun 2019 17:32:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=43iFQu78wgoaNu64Kv3t6cejeLFkzXhBymZ9nsSNkdI=;
        b=tE4G1zc5hed7KbunYdBx4wC+eNX1jJMbadxhiSRX1qMXE5nqp7CxnrItOFhfotVQp3
         txelMVliEP5U9VPQA0R3Q7ChIfEB/x2zLQJ20ikHcG6UFcuRFCcJ9rCrjccxl7KvNtEb
         Tnf7oc73Rm3A2AH5oQN0GAbriJOGsxVq3n4DBmcuvBOtjd0eXibTbfB6lbfZC6RS2UX7
         hq6frp1e9wGChQTFqMnn9RlxwUKthDJxarzn7S9U6XJv09VShXboi1jde92eeKcYaM6R
         Jo9DqLfGoI9s/xrNnmiB1JvSOHIk03DrX407bjagrqu5Ym9Jpg74ScQRmsasr75S3SiR
         sH4g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=43iFQu78wgoaNu64Kv3t6cejeLFkzXhBymZ9nsSNkdI=;
        b=kvGqT9P4DULcGZjBE5gWiFPKE+ARXVGHdCeI/GieN0mzlLK1/tvb2SmmCigzr96b83
         aOE7VN/TrXDhGTPauchTG9MrGlHpUoGE6Am5BQ0YpleiNE8AMNA/N6S0PoJ+RchY/MRF
         vlk0X/uydnEpFzBM4FYgHTc4ddU+TYVaUa1EjmVXd6cfzIpXSHitQrqqY2i/Omtvdjzd
         Gj5XSJPN2hmFN9kkxoSDHwTIyt3yeAAKXFKoqySdSY07/H7jDpS6YNdkgc35xg+0FWOt
         R7EllmKdrYawka63uwWNIEhAOyRJ2MdAHbhPJL+vLIH10WPmbhU27DHnBk1RbAdmw86M
         3aAQ==
X-Gm-Message-State: APjAAAUvKDwZCGDLUpvTc/b7o+gOnRE/cZGvQkuKFql+/uFIwlZCNxiY
        qEVL4DD9LTxVHYlJPTeHNjeJ+hDAWoFVvYJS
X-Google-Smtp-Source: APXvYqywIuVzqnsxZ64X55/3DildWkVRR9rET58J3Dy+9FFcFWNqZ3BdLUoyNv30hVl7ml1Ro1lmnA==
X-Received: by 2002:a7b:c215:: with SMTP id x21mr5663657wmi.38.1561163521055;
        Fri, 21 Jun 2019 17:32:01 -0700 (PDT)
Received: from sudo.home ([2a01:cb1d:112:6f00:99d4:1ff0:ed6:dfbb])
        by smtp.gmail.com with ESMTPSA id v18sm4792019wrd.51.2019.06.21.17.32.00
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 21 Jun 2019 17:32:00 -0700 (PDT)
From:   Ard Biesheuvel <ard.biesheuvel@linaro.org>
To:     linux-crypto@vger.kernel.org
Cc:     herbert@gondor.apana.org.au, ebiggers@google.com,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: [RFC PATCH 16/30] crypto: n2/des - switch to new verification routines
Date:   Sat, 22 Jun 2019 02:30:58 +0200
Message-Id: <20190622003112.31033-17-ard.biesheuvel@linaro.org>
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
 drivers/crypto/n2_core.c | 26 ++++++--------------
 1 file changed, 7 insertions(+), 19 deletions(-)

diff --git a/drivers/crypto/n2_core.c b/drivers/crypto/n2_core.c
index 0d5d3d8eb680..132961a33b6d 100644
--- a/drivers/crypto/n2_core.c
+++ b/drivers/crypto/n2_core.c
@@ -16,7 +16,7 @@
 #include <crypto/md5.h>
 #include <crypto/sha.h>
 #include <crypto/aes.h>
-#include <crypto/des.h>
+#include <crypto/internal/des.h>
 #include <linux/mutex.h>
 #include <linux/delay.h>
 #include <linux/sched.h>
@@ -759,21 +759,13 @@ static int n2_des_setkey(struct crypto_ablkcipher *cipher, const u8 *key,
 	struct crypto_tfm *tfm = crypto_ablkcipher_tfm(cipher);
 	struct n2_cipher_context *ctx = crypto_tfm_ctx(tfm);
 	struct n2_cipher_alg *n2alg = n2_cipher_alg(tfm);
-	u32 tmp[DES_EXPKEY_WORDS];
 	int err;
 
-	ctx->enc_type = n2alg->enc_type;
-
-	if (keylen != DES_KEY_SIZE) {
-		crypto_ablkcipher_set_flags(cipher, CRYPTO_TFM_RES_BAD_KEY_LEN);
-		return -EINVAL;
-	}
+	err = crypto_des_verify_key(tfm, key, keylen);
+	if (unlikely(err))
+		return err;
 
-	err = des_ekey(tmp, key);
-	if (err == 0 && (tfm->crt_flags & CRYPTO_TFM_REQ_FORBID_WEAK_KEYS)) {
-		tfm->crt_flags |= CRYPTO_TFM_RES_WEAK_KEY;
-		return -EINVAL;
-	}
+	ctx->enc_type = n2alg->enc_type;
 
 	ctx->key_len = keylen;
 	memcpy(ctx->key.des, key, keylen);
@@ -786,15 +778,11 @@ static int n2_3des_setkey(struct crypto_ablkcipher *cipher, const u8 *key,
 	struct crypto_tfm *tfm = crypto_ablkcipher_tfm(cipher);
 	struct n2_cipher_context *ctx = crypto_tfm_ctx(tfm);
 	struct n2_cipher_alg *n2alg = n2_cipher_alg(tfm);
-	u32 flags;
 	int err;
 
-	flags = crypto_ablkcipher_get_flags(cipher);
-	err = __des3_verify_key(&flags, key);
-	if (unlikely(err)) {
-		crypto_ablkcipher_set_flags(cipher, flags);
+	err = crypto_des3_ede_verify_key(tfm, key, keylen);
+	if (unlikely(err))
 		return err;
-	}
 
 	ctx->enc_type = n2alg->enc_type;
 
-- 
2.20.1


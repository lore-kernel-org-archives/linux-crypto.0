Return-Path: <SRS0=RljO=UV=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5A0A6C48BE0
	for <linux-crypto@archiver.kernel.org>; Sat, 22 Jun 2019 00:32:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2CE232084E
	for <linux-crypto@archiver.kernel.org>; Sat, 22 Jun 2019 00:32:03 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="z0Qg4wX3"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726196AbfFVAcC (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 21 Jun 2019 20:32:02 -0400
Received: from mail-wr1-f65.google.com ([209.85.221.65]:45172 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726049AbfFVAcC (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 21 Jun 2019 20:32:02 -0400
Received: by mail-wr1-f65.google.com with SMTP id f9so8073460wre.12
        for <linux-crypto@vger.kernel.org>; Fri, 21 Jun 2019 17:32:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=7KbUq/Neoi/+vA9jXPmf0VHExg0kIN5TmhcZN+HEmk4=;
        b=z0Qg4wX3eLbrweXds6GqhNJCh00BrwySg4SULPG3XMzVQsHlbojj3i5h8sG4s4ZZFh
         c9CTi0f75YLltwOAoHinKCvAQqgQmy2Xr/+CcGIhu05d7UQUo6b7i6yc6vf4Ryz/Hf1p
         iIiC7EvxF51YYRGC3YA9YvISDo8M97b5xf2Jjr3KOw4caOHMxn4Oj+FY8eXMa1AS6qTh
         mGDTVG2QU5uXWXrhh9VKn1FEJ4WfLnGG9+YkYtf9Si6d7k6qwOtJZOdTQXOMZ+HuOfeC
         55rNdsc/ZevGbW+aQXICDcLw8IcmAUY3tHfo+9Mtf3ByBN1ybdxT42PLZ9RZF4VmMoRp
         sfhg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=7KbUq/Neoi/+vA9jXPmf0VHExg0kIN5TmhcZN+HEmk4=;
        b=CrUDa+FJXJxIJBrlJJUCSZUH1jElIdy8jOgYLP0aTTHzCafHQI6s2BscovTRPJSgwq
         5u1BuMqLJMyk7t5v5udS844M972a1WBsaDY/6Pf4s+FV2Y256t+Kxe4C6Ac8b5OsI+ei
         z5RlkDXVntrfxq9CMfziOoKXx4CZlLkRI8P3A2ndarBpeAaGQrmA+ZBhpQc8fKyvCgW8
         QHSDcJcwm6C6IkNGRlLBwlOK48UiJDZNUFin71vFmP6f4tpyb5iTnbfD6zVh1Swze5HT
         OacQeNSRgvSsvL0ZECssxN6CrbR2NEqGkf9K5O4UCtTAuv/G4uGsaBy4O/BW27JRpe0A
         C9LA==
X-Gm-Message-State: APjAAAUEY7oX2fCm1s2jEmkFm7+CTrkbvFgtpUOpi8EeP6Oxct+xMY+Z
        9iPbaVzPkACCv97WzFQ/953e8jiv0ghYlnDl
X-Google-Smtp-Source: APXvYqyEPjAIcy8BHaPpUP1/OOmUy7EY0b0iJdcmeYdr8ryYb86yAIRnFoS6ohaV4+O15SInBPmfmw==
X-Received: by 2002:a5d:488b:: with SMTP id g11mr22072217wrq.72.1561163519950;
        Fri, 21 Jun 2019 17:31:59 -0700 (PDT)
Received: from sudo.home ([2a01:cb1d:112:6f00:99d4:1ff0:ed6:dfbb])
        by smtp.gmail.com with ESMTPSA id v18sm4792019wrd.51.2019.06.21.17.31.59
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 21 Jun 2019 17:31:59 -0700 (PDT)
From:   Ard Biesheuvel <ard.biesheuvel@linaro.org>
To:     linux-crypto@vger.kernel.org
Cc:     herbert@gondor.apana.org.au, ebiggers@google.com,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: [RFC PATCH 15/30] crypto: cesa/des - switch to new verification routines
Date:   Sat, 22 Jun 2019 02:30:57 +0200
Message-Id: <20190622003112.31033-16-ard.biesheuvel@linaro.org>
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
 drivers/crypto/marvell/cipher.c | 20 ++++++--------------
 1 file changed, 6 insertions(+), 14 deletions(-)

diff --git a/drivers/crypto/marvell/cipher.c b/drivers/crypto/marvell/cipher.c
index 2fd936b19c6d..68d26a573f71 100644
--- a/drivers/crypto/marvell/cipher.c
+++ b/drivers/crypto/marvell/cipher.c
@@ -13,7 +13,7 @@
  */
 
 #include <crypto/aes.h>
-#include <crypto/des.h>
+#include <crypto/internal/des.h>
 
 #include "cesa.h"
 
@@ -277,19 +277,11 @@ static int mv_cesa_des_setkey(struct crypto_skcipher *cipher, const u8 *key,
 {
 	struct crypto_tfm *tfm = crypto_skcipher_tfm(cipher);
 	struct mv_cesa_des_ctx *ctx = crypto_tfm_ctx(tfm);
-	u32 tmp[DES_EXPKEY_WORDS];
-	int ret;
-
-	if (len != DES_KEY_SIZE) {
-		crypto_skcipher_set_flags(cipher, CRYPTO_TFM_RES_BAD_KEY_LEN);
-		return -EINVAL;
-	}
+	int err;
 
-	ret = des_ekey(tmp, key);
-	if (!ret && (tfm->crt_flags & CRYPTO_TFM_REQ_FORBID_WEAK_KEYS)) {
-		tfm->crt_flags |= CRYPTO_TFM_RES_WEAK_KEY;
-		return -EINVAL;
-	}
+	err = crypto_des_verify_key(tfm, key, len);
+	if (unlikely(err))
+		return err;
 
 	memcpy(ctx->key, key, DES_KEY_SIZE);
 
@@ -302,7 +294,7 @@ static int mv_cesa_des3_ede_setkey(struct crypto_skcipher *cipher,
 	struct mv_cesa_des_ctx *ctx = crypto_skcipher_ctx(cipher);
 	int err;
 
-	err = des3_verify_key(cipher, key);
+	err = crypto_des3_ede_verify_key(crypto_skcipher_tfm(cipher), key, len);
 	if (unlikely(err))
 		return err;
 
-- 
2.20.1


Return-Path: <SRS0=RljO=UV=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7CF65C48BE0
	for <linux-crypto@archiver.kernel.org>; Sat, 22 Jun 2019 00:31:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4FC682084E
	for <linux-crypto@archiver.kernel.org>; Sat, 22 Jun 2019 00:31:49 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="EoEaND7b"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726080AbfFVAbs (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 21 Jun 2019 20:31:48 -0400
Received: from mail-wm1-f66.google.com ([209.85.128.66]:35470 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726101AbfFVAbs (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 21 Jun 2019 20:31:48 -0400
Received: by mail-wm1-f66.google.com with SMTP id c6so8124448wml.0
        for <linux-crypto@vger.kernel.org>; Fri, 21 Jun 2019 17:31:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=4hQd7PYcG7QjLZcDV8BoskodbCYNzyoRKq3CDodt/Bs=;
        b=EoEaND7b/eAEOtojEsscB8w98xj0f+GMvyWTT/Tfm6cXGNd2d+QBTd95BivBKekLLx
         TNSzwjLjlGbVq1bVih4315iEcrz14x6fLQglLvvcG6Li/2RaT2tgpTfUc57xaZ5sBQsO
         ZkNZy/Mc3EO8zFvXGuSA5qxQ6nHXQRfRdAd7ci9ogCg8bc8RDAbzVfZ9PuS8Y78X2Mfz
         kdDE5RleU1UXcw2uuWamkwzgy1tGlozw/vsfN45kddieYjWmo66f/CcBNtYkhvgzK4LA
         p2T6U6pDu2cxnSanndDXm+ggpg3E2LWB5vKjhZdjdi9UwmExBXpvqmOobhpBtpFDf0l4
         5kjg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=4hQd7PYcG7QjLZcDV8BoskodbCYNzyoRKq3CDodt/Bs=;
        b=WX+1pX8d2+KaARFeBIwhHn/J/3zI4k2CMSosoXYcnSxn25lLRsIGzUpCYawJkcje0S
         rzdDkT+sP0Jl1XTTwqoiAWhO2OSNgHqMROWE3tddTdAI+qmKKW/iiN1d7juAdE6fgn8F
         iOadHlmmDFwRz9/F4oX1Hnw3zXVgSsoo4SibXxp0EhUqoc4hPDS0pBXl6jBmtpILQw3f
         wwZBct4mKKi+1m/+3SaGF45hGCVOPUP6T9NmMN2XHVXZzLwhd16VWnqJWGZJe5q4GE0Z
         4DCrrH5rFa5GyAXNPALKZ79VD3VzLcW0zj7BPzGzaebFNktH4dqFQ0rkJALutbaFYT8N
         2uew==
X-Gm-Message-State: APjAAAX2geKjKA21jnwa1OLodQiRt5qlt9wbWnI/ixbWmqBWQNHAPLU/
        +aXEvKoIT8fy+F/8wBZDaZiB1+6GrYrtRhtR
X-Google-Smtp-Source: APXvYqxcGOBhRi1Oln8frUARsZpeJWSGyW3bsCb0lGdtF+el980pmGmym7lPRge44GnsRXIgwck5UA==
X-Received: by 2002:a1c:a00f:: with SMTP id j15mr5950679wme.167.1561163506166;
        Fri, 21 Jun 2019 17:31:46 -0700 (PDT)
Received: from sudo.home ([2a01:cb1d:112:6f00:99d4:1ff0:ed6:dfbb])
        by smtp.gmail.com with ESMTPSA id v18sm4792019wrd.51.2019.06.21.17.31.45
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 21 Jun 2019 17:31:45 -0700 (PDT)
From:   Ard Biesheuvel <ard.biesheuvel@linaro.org>
To:     linux-crypto@vger.kernel.org
Cc:     herbert@gondor.apana.org.au, ebiggers@google.com,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: [RFC PATCH 02/30] crypto: s390/des - switch to new verification routines
Date:   Sat, 22 Jun 2019 02:30:44 +0200
Message-Id: <20190622003112.31033-3-ard.biesheuvel@linaro.org>
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
 arch/s390/crypto/des_s390.c | 15 ++++++---------
 1 file changed, 6 insertions(+), 9 deletions(-)

diff --git a/arch/s390/crypto/des_s390.c b/arch/s390/crypto/des_s390.c
index 1f9ab24dc048..4e4061885b0d 100644
--- a/arch/s390/crypto/des_s390.c
+++ b/arch/s390/crypto/des_s390.c
@@ -15,7 +15,7 @@
 #include <linux/crypto.h>
 #include <linux/fips.h>
 #include <crypto/algapi.h>
-#include <crypto/des.h>
+#include <crypto/internal/des.h>
 #include <asm/cpacf.h>
 
 #define DES3_KEY_SIZE	(3 * DES_KEY_SIZE)
@@ -34,14 +34,11 @@ static int des_setkey(struct crypto_tfm *tfm, const u8 *key,
 		      unsigned int key_len)
 {
 	struct s390_des_ctx *ctx = crypto_tfm_ctx(tfm);
-	u32 tmp[DES_EXPKEY_WORDS];
+	int err;
 
-	/* check for weak keys */
-	if (!des_ekey(tmp, key) &&
-	    (tfm->crt_flags & CRYPTO_TFM_REQ_FORBID_WEAK_KEYS)) {
-		tfm->crt_flags |= CRYPTO_TFM_RES_WEAK_KEY;
-		return -EINVAL;
-	}
+	err = des_verify_key(tfm, key, key_len);
+	if (unlikely(err))
+		return err;
 
 	memcpy(ctx->key, key, key_len);
 	return 0;
@@ -226,7 +223,7 @@ static int des3_setkey(struct crypto_tfm *tfm, const u8 *key,
 	struct s390_des_ctx *ctx = crypto_tfm_ctx(tfm);
 	int err;
 
-	err = __des3_verify_key(&tfm->crt_flags, key);
+	err = crypto_des3_ede_verify_key(tfm, key, key_len);
 	if (unlikely(err))
 		return err;
 
-- 
2.20.1


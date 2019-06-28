Return-Path: <SRS0=Fqdl=U3=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4CCB3C5B57B
	for <linux-crypto@archiver.kernel.org>; Fri, 28 Jun 2019 09:36:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 225E32133F
	for <linux-crypto@archiver.kernel.org>; Fri, 28 Jun 2019 09:36:05 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="u0YiHDiQ"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726702AbfF1JgE (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 28 Jun 2019 05:36:04 -0400
Received: from mail-wm1-f67.google.com ([209.85.128.67]:37838 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726603AbfF1JgD (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 28 Jun 2019 05:36:03 -0400
Received: by mail-wm1-f67.google.com with SMTP id f17so8303872wme.2
        for <linux-crypto@vger.kernel.org>; Fri, 28 Jun 2019 02:36:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=vwaL2yVe7/AKlyXh+T/GXc8ok7UKbj/+xTW1NBqnpb4=;
        b=u0YiHDiQaaomNI6u1pcoD8swbgBPyeG6v1G34oq7OgmUZlCuiPro/PemYVF+Utpch3
         nSREYEzQOTRdmYEWeZQPtYj1E8TccrqCQTX9kb6KGPcVZuTAEWlansinybtY6M7ORmPc
         BIH3CORthIIpx4pif9qHJHOwHgA0pK5QMfawy5+zaCAifQY3ykDPZBwyEvYjZ37kn/U5
         Y8gMuW4OwcBYXU11T9P0l9llcLN3HEUarzAAHEvQ9QAqoA+pWFdWLA6GZIP8Zzsj4BBJ
         9VYZuvGTWBTB+saiZ49w7eTJN+0DdolF0D9x4FYLDSOczLBMXcznCLIs8kIcb83pRqt+
         kzkA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=vwaL2yVe7/AKlyXh+T/GXc8ok7UKbj/+xTW1NBqnpb4=;
        b=NyXlYe9XZFBy6c9DiEnz9dnm6b+aZaERdFyZk7vVlLQUHnV5RuXAgHulubEql+ZrIs
         Bsa2oMlN/HmVOfV0dumd+FYC78pqeQqTMOZS1SeXA0n60TKp6DcDwCi/YPofcCpkrjOK
         SuU4yxJX0MjM4eazjbLtvVOb1DkAsyjMDRzI0CO2pIAPAIErBSc2tLbTIkOwkdFAOgHR
         9ylA3D/UVwmE10vXBuIcFz86rXMI7JurcEbvA66rFNWk7Ayucoc5i8js4tuq1w4zmyvg
         M+is6luoOg/YgNctM5q/7GZaqWaVbqBbc4v3ixa3pAO4oGAJ97NcItawz3SW4DogUGE2
         vs+Q==
X-Gm-Message-State: APjAAAWkkUFKByPrtPJMGndmfQGCkpeMEpPWb9onGETu+4hGlQGEdJ8+
        bLFbzf3k0x3bcvmUT8Fv1kar7+CyXNdGiQ==
X-Google-Smtp-Source: APXvYqxx6erIATW1gisLQJEI5qePz5Nh5FcreyPCuNf2UGSlD5yDWExoxPQuitrgKWOqlULciW/FwQ==
X-Received: by 2002:a1c:a6d1:: with SMTP id p200mr6774382wme.169.1561714561074;
        Fri, 28 Jun 2019 02:36:01 -0700 (PDT)
Received: from localhost.localdomain (laubervilliers-657-1-83-120.w92-154.abo.wanadoo.fr. [92.154.90.120])
        by smtp.gmail.com with ESMTPSA id m24sm1709910wmi.39.2019.06.28.02.36.00
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Fri, 28 Jun 2019 02:36:00 -0700 (PDT)
From:   Ard Biesheuvel <ard.biesheuvel@linaro.org>
To:     linux-crypto@vger.kernel.org
Cc:     herbert@gondor.apana.org.au, ebiggers@kernel.org,
        horia.geanta@nxp.com, Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: [PATCH v3 21/30] crypto: stm32/des - switch to new verification routines
Date:   Fri, 28 Jun 2019 11:35:20 +0200
Message-Id: <20190628093529.12281-22-ard.biesheuvel@linaro.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190628093529.12281-1-ard.biesheuvel@linaro.org>
References: <20190628093529.12281-1-ard.biesheuvel@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
---
 drivers/crypto/stm32/stm32-cryp.c | 30 ++++----------------
 1 file changed, 5 insertions(+), 25 deletions(-)

diff --git a/drivers/crypto/stm32/stm32-cryp.c b/drivers/crypto/stm32/stm32-cryp.c
index cddcc97875b2..377d7f9ad470 100644
--- a/drivers/crypto/stm32/stm32-cryp.c
+++ b/drivers/crypto/stm32/stm32-cryp.c
@@ -15,7 +15,7 @@
 #include <linux/reset.h>
 
 #include <crypto/aes.h>
-#include <crypto/des.h>
+#include <crypto/internal/des.h>
 #include <crypto/engine.h>
 #include <crypto/scatterwalk.h>
 #include <crypto/internal/aead.h>
@@ -767,35 +767,15 @@ static int stm32_cryp_aes_setkey(struct crypto_ablkcipher *tfm, const u8 *key,
 static int stm32_cryp_des_setkey(struct crypto_ablkcipher *tfm, const u8 *key,
 				 unsigned int keylen)
 {
-	u32 tmp[DES_EXPKEY_WORDS];
-
-	if (keylen != DES_KEY_SIZE)
-		return -EINVAL;
-
-	if ((crypto_ablkcipher_get_flags(tfm) &
-	     CRYPTO_TFM_REQ_FORBID_WEAK_KEYS) &&
-	    unlikely(!des_ekey(tmp, key))) {
-		crypto_ablkcipher_set_flags(tfm, CRYPTO_TFM_RES_WEAK_KEY);
-		return -EINVAL;
-	}
-
-	return stm32_cryp_setkey(tfm, key, keylen);
+	return crypto_des_verify_key(crypto_ablkcipher_tfm(tfm), key) ?:
+	       stm32_cryp_setkey(tfm, key, keylen);
 }
 
 static int stm32_cryp_tdes_setkey(struct crypto_ablkcipher *tfm, const u8 *key,
 				  unsigned int keylen)
 {
-	u32 flags;
-	int err;
-
-	flags = crypto_ablkcipher_get_flags(tfm);
-	err = __des3_verify_key(&flags, key);
-	if (unlikely(err)) {
-		crypto_ablkcipher_set_flags(tfm, flags);
-		return err;
-	}
-
-	return stm32_cryp_setkey(tfm, key, keylen);
+	return crypto_des3_ede_verify_key(crypto_ablkcipher_tfm(tfm), key) ?:
+	       stm32_cryp_setkey(tfm, key, keylen);
 }
 
 static int stm32_cryp_aes_aead_setkey(struct crypto_aead *tfm, const u8 *key,
-- 
2.20.1


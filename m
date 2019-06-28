Return-Path: <SRS0=Fqdl=U3=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D23FBC4321A
	for <linux-crypto@archiver.kernel.org>; Fri, 28 Jun 2019 09:35:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id AA45220665
	for <linux-crypto@archiver.kernel.org>; Fri, 28 Jun 2019 09:35:54 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="lRlNEV/2"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726686AbfF1Jfy (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 28 Jun 2019 05:35:54 -0400
Received: from mail-wr1-f68.google.com ([209.85.221.68]:44123 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726632AbfF1Jfy (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 28 Jun 2019 05:35:54 -0400
Received: by mail-wr1-f68.google.com with SMTP id r16so3671806wrl.11
        for <linux-crypto@vger.kernel.org>; Fri, 28 Jun 2019 02:35:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=gU5XdhRzqh4V0nFMyqKcG3tn/WS8nvCNXfGNVcUotfs=;
        b=lRlNEV/2sRpjhiJeMx2zbCYFRDJrVrCUoAOTiplP2+y8lRfQOJiZfphcDrfEnJA4gJ
         sUrOZTSmP7VxnnKbJ+/AD6Kfwp4sdggkbe1/ubgXsI9vSuYGphY6ck8FGHzK1KHGBJhx
         Rsf2ZVoDbcIrs8m8EJkiY1jRm8HeuliCwX+Ct5nHtP+0erln8+45qfGbsLaG7dpOHUmi
         ArvUnGWQ/E9v5jVzkhjZ8kbPd96Urp1sbyUhUKa6EeAh3G61s9qAS/aMaSUdW9m/nWz2
         VJitbroa30lxft527cdaILMHYAHyupN9jCuC/rGMUnUbt5AeQ4a49iUtFGjYiOJUTxHi
         BQwg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=gU5XdhRzqh4V0nFMyqKcG3tn/WS8nvCNXfGNVcUotfs=;
        b=axWAsW745Nn2Jkvg72XV8Lsgr51GTVEn7tshnCGkr7K3t4ypcGFAcfQKGA5YEFdhrm
         hKEM+XqjiZG9PTgrl+OMGG2WDBlY8XqJJulc5CGOeO9D4DeZ0o8GAcEiIvV/vgtzzUvR
         WuhBzI2NavWqzn0C1CDP/BbXa63Or3ARcdPpYQ++chFP1F3lsG5mFv4W/Y97+b+Qj89m
         R3dVXHaFEJQujJrJv+tgz25jdk9w1nMlM/U7SHlCWegHpbmsZPYZLhvqeGAI3u8fD8E1
         Oq0edh/NHIusH++LzboGtA3qdwV0S8rLwj0Cbzyi+JJyIFfzt8VfrC+76CCAkqP9zUqo
         v+bA==
X-Gm-Message-State: APjAAAXpfHfeGbVbMVCBxr5xY9s7lV0+MfM30QZmCrsfMmXkURLpr7hj
        e7ixgEv+zFKWskvK4D9Ets10YjyK/6z1vQ==
X-Google-Smtp-Source: APXvYqxulqJA3pShfn2thjJdYqYpcKPC0iVf4xQagg/8mcu9bQx3ZGrH+0xprTrpYJ6Kx2CcSipXzA==
X-Received: by 2002:a5d:5342:: with SMTP id t2mr7653990wrv.126.1561714551541;
        Fri, 28 Jun 2019 02:35:51 -0700 (PDT)
Received: from localhost.localdomain (laubervilliers-657-1-83-120.w92-154.abo.wanadoo.fr. [92.154.90.120])
        by smtp.gmail.com with ESMTPSA id m24sm1709910wmi.39.2019.06.28.02.35.50
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Fri, 28 Jun 2019 02:35:50 -0700 (PDT)
From:   Ard Biesheuvel <ard.biesheuvel@linaro.org>
To:     linux-crypto@vger.kernel.org
Cc:     herbert@gondor.apana.org.au, ebiggers@kernel.org,
        horia.geanta@nxp.com, Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: [PATCH v3 12/30] crypto: hisilicon/des - switch to new verification routines
Date:   Fri, 28 Jun 2019 11:35:11 +0200
Message-Id: <20190628093529.12281-13-ard.biesheuvel@linaro.org>
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
 drivers/crypto/hisilicon/sec/sec_algs.c | 18 +++++++-----------
 1 file changed, 7 insertions(+), 11 deletions(-)

diff --git a/drivers/crypto/hisilicon/sec/sec_algs.c b/drivers/crypto/hisilicon/sec/sec_algs.c
index 02768af0dccd..4a9fae297b0f 100644
--- a/drivers/crypto/hisilicon/sec/sec_algs.c
+++ b/drivers/crypto/hisilicon/sec/sec_algs.c
@@ -9,7 +9,7 @@
 
 #include <crypto/aes.h>
 #include <crypto/algapi.h>
-#include <crypto/des.h>
+#include <crypto/internal/des.h>
 #include <crypto/skcipher.h>
 #include <crypto/xts.h>
 #include <crypto/internal/skcipher.h>
@@ -347,25 +347,21 @@ static int sec_alg_skcipher_setkey_aes_xts(struct crypto_skcipher *tfm,
 static int sec_alg_skcipher_setkey_des_ecb(struct crypto_skcipher *tfm,
 					   const u8 *key, unsigned int keylen)
 {
-	if (keylen != DES_KEY_SIZE)
-		return -EINVAL;
-
-	return sec_alg_skcipher_setkey(tfm, key, keylen, SEC_C_DES_ECB_64);
+	return crypto_des_verify_key(crypto_skcipher_tfm(tfm), key) ?:
+	       sec_alg_skcipher_setkey(tfm, key, keylen, SEC_C_DES_ECB_64);
 }
 
 static int sec_alg_skcipher_setkey_des_cbc(struct crypto_skcipher *tfm,
 					   const u8 *key, unsigned int keylen)
 {
-	if (keylen != DES_KEY_SIZE)
-		return -EINVAL;
-
-	return sec_alg_skcipher_setkey(tfm, key, keylen, SEC_C_DES_CBC_64);
+	return crypto_des_verify_key(crypto_skcipher_tfm(tfm), key) ?:
+	       sec_alg_skcipher_setkey(tfm, key, keylen, SEC_C_DES_CBC_64);
 }
 
 static int sec_alg_skcipher_setkey_3des_ecb(struct crypto_skcipher *tfm,
 					    const u8 *key, unsigned int keylen)
 {
-	return unlikely(des3_verify_key(tfm, key)) ?:
+	return crypto_des3_ede_verify_key(crypto_skcipher_tfm(tfm), key) ?:
 	       sec_alg_skcipher_setkey(tfm, key, keylen,
 				       SEC_C_3DES_ECB_192_3KEY);
 }
@@ -373,7 +369,7 @@ static int sec_alg_skcipher_setkey_3des_ecb(struct crypto_skcipher *tfm,
 static int sec_alg_skcipher_setkey_3des_cbc(struct crypto_skcipher *tfm,
 					    const u8 *key, unsigned int keylen)
 {
-	return unlikely(des3_verify_key(tfm, key)) ?:
+	return crypto_des3_ede_verify_key(crypto_skcipher_tfm(tfm), key) ?:
 	       sec_alg_skcipher_setkey(tfm, key, keylen,
 				       SEC_C_3DES_CBC_192_3KEY);
 }
-- 
2.20.1


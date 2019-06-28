Return-Path: <SRS0=Fqdl=U3=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4D33AC4321A
	for <linux-crypto@archiver.kernel.org>; Fri, 28 Jun 2019 09:35:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 216C220665
	for <linux-crypto@archiver.kernel.org>; Fri, 28 Jun 2019 09:35:47 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="dx9zGs36"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726664AbfF1Jfq (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 28 Jun 2019 05:35:46 -0400
Received: from mail-wm1-f67.google.com ([209.85.128.67]:38830 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726656AbfF1Jfq (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 28 Jun 2019 05:35:46 -0400
Received: by mail-wm1-f67.google.com with SMTP id s15so8294442wmj.3
        for <linux-crypto@vger.kernel.org>; Fri, 28 Jun 2019 02:35:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Yx4YWquoX+LfjASs0AKiOHlXM1JrCIj00PEwIb+JOi0=;
        b=dx9zGs36dWERe93FgKmClYwUO4Ir0sRrwrEea77DHmzt61gpUX1k0E9OXZ8pNv0fzG
         Z7fOpDVKVTyipqMEwqDRACYl28fOMJaEJG/mKHm426X+vpURfFagZd30kNl87BxZRl6S
         p8LDjcAcehpwIzJTwNMp7ZrNFPiGhmB8m/4gVbIQqOCk1k1C2cGDg3h7Tuldx+CzPgaM
         8tvPLq42RcJSHBV2mmmzvThvuC4Cfh8DLRMq9LaW8ud9GlvWbmQoerVLPMMmDV6VoAJ3
         ZBDqPKEN/NI931aBfz2/NcCGugcb8BFXzL/teMBifKskmsxFbwVwuwtBT1ig2NLlGiqh
         8qTg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Yx4YWquoX+LfjASs0AKiOHlXM1JrCIj00PEwIb+JOi0=;
        b=YdkPXC8sGl/YtqaowA3sJcz4V1kxqR9aO84aQTRe9eKyhtWjh5Ajw4oABM6x6zWVmr
         rPmH58hf2Lwp6E32nE8S5bvZ4UBNYhuR9/P+SvGtiY5S7udnINvZdPz/7Yy93flfUnAg
         1iNYZKczR7BqpP0kK9EbHcOp73Nbp5a0rv9WYTOngtBoMH48tt5UDneZFZYBgnm2yXzT
         Isb1YhHDMfocEIwcbFLq7KSA4Egqf255eKZBdJowceibUKgV38R+m/AYp4/U3ZwVxCpM
         gDKSt9bVa9bzk/2o9zhYWpBoJ1y0ylAHNcCVcThk+EoDI9wR7q3zqcIdk/zxCod7/muH
         5XkA==
X-Gm-Message-State: APjAAAXVrxieQP+HaCUN3xIkXwLZPmNCiRwfsIZDJ7B6Z5WYPvcGXpim
        aukdzcC9FR33CrQB0wJMTLL9SWLgfslPpg==
X-Google-Smtp-Source: APXvYqwQKeEFCauEfeHSuIdngIe5Ro03n02GjzjvWqgDF34BMMNNUvd2wQ9CM0QsDBbd8X6cGbxeeA==
X-Received: by 2002:a1c:3:: with SMTP id 3mr6681916wma.6.1561714543646;
        Fri, 28 Jun 2019 02:35:43 -0700 (PDT)
Received: from localhost.localdomain (laubervilliers-657-1-83-120.w92-154.abo.wanadoo.fr. [92.154.90.120])
        by smtp.gmail.com with ESMTPSA id m24sm1709910wmi.39.2019.06.28.02.35.42
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Fri, 28 Jun 2019 02:35:43 -0700 (PDT)
From:   Ard Biesheuvel <ard.biesheuvel@linaro.org>
To:     linux-crypto@vger.kernel.org
Cc:     herbert@gondor.apana.org.au, ebiggers@kernel.org,
        horia.geanta@nxp.com, Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: [PATCH v3 05/30] crypto: bcm/des - switch to new verification routines
Date:   Fri, 28 Jun 2019 11:35:04 +0200
Message-Id: <20190628093529.12281-6-ard.biesheuvel@linaro.org>
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
 drivers/crypto/bcm/cipher.c | 82 +++++---------------
 1 file changed, 20 insertions(+), 62 deletions(-)

diff --git a/drivers/crypto/bcm/cipher.c b/drivers/crypto/bcm/cipher.c
index d972ffac779d..ca28b9ff21aa 100644
--- a/drivers/crypto/bcm/cipher.c
+++ b/drivers/crypto/bcm/cipher.c
@@ -35,7 +35,7 @@
 #include <crypto/aead.h>
 #include <crypto/internal/aead.h>
 #include <crypto/aes.h>
-#include <crypto/des.h>
+#include <crypto/internal/des.h>
 #include <crypto/hmac.h>
 #include <crypto/sha.h>
 #include <crypto/md5.h>
@@ -1813,24 +1813,13 @@ static int des_setkey(struct crypto_ablkcipher *cipher, const u8 *key,
 		      unsigned int keylen)
 {
 	struct iproc_ctx_s *ctx = crypto_ablkcipher_ctx(cipher);
-	u32 tmp[DES_EXPKEY_WORDS];
-
-	if (keylen == DES_KEY_SIZE) {
-		if (des_ekey(tmp, key) == 0) {
-			if (crypto_ablkcipher_get_flags(cipher) &
-			    CRYPTO_TFM_REQ_FORBID_WEAK_KEYS) {
-				u32 flags = CRYPTO_TFM_RES_WEAK_KEY;
+	int err;
 
-				crypto_ablkcipher_set_flags(cipher, flags);
-				return -EINVAL;
-			}
-		}
+	err = crypto_des_verify_key(crypto_ablkcipher_tfm(cipher), key);
+	if (err)
+		return err;
 
-		ctx->cipher_type = CIPHER_TYPE_DES;
-	} else {
-		crypto_ablkcipher_set_flags(cipher, CRYPTO_TFM_RES_BAD_KEY_LEN);
-		return -EINVAL;
-	}
+	ctx->cipher_type = CIPHER_TYPE_DES;
 	return 0;
 }
 
@@ -1838,23 +1827,13 @@ static int threedes_setkey(struct crypto_ablkcipher *cipher, const u8 *key,
 			   unsigned int keylen)
 {
 	struct iproc_ctx_s *ctx = crypto_ablkcipher_ctx(cipher);
+	int err;
 
-	if (keylen == (DES_KEY_SIZE * 3)) {
-		u32 flags;
-		int ret;
-
-		flags = crypto_ablkcipher_get_flags(cipher);
-		ret = __des3_verify_key(&flags, key);
-		if (unlikely(ret)) {
-			crypto_ablkcipher_set_flags(cipher, flags);
-			return ret;
-		}
+	err = crypto_des3_ede_verify_key(crypto_ablkcipher_tfm(cipher), key);
+	if (err)
+		return err;
 
-		ctx->cipher_type = CIPHER_TYPE_3DES;
-	} else {
-		crypto_ablkcipher_set_flags(cipher, CRYPTO_TFM_RES_BAD_KEY_LEN);
-		return -EINVAL;
-	}
+	ctx->cipher_type = CIPHER_TYPE_3DES;
 	return 0;
 }
 
@@ -2866,40 +2845,19 @@ static int aead_authenc_setkey(struct crypto_aead *cipher,
 
 	switch (ctx->alg->cipher_info.alg) {
 	case CIPHER_ALG_DES:
-		if (ctx->enckeylen == DES_KEY_SIZE) {
-			u32 tmp[DES_EXPKEY_WORDS];
-			u32 flags = CRYPTO_TFM_RES_WEAK_KEY;
-
-			if (des_ekey(tmp, keys.enckey) == 0) {
-				if (crypto_aead_get_flags(cipher) &
-				    CRYPTO_TFM_REQ_FORBID_WEAK_KEYS) {
-					crypto_aead_set_flags(cipher, flags);
-					return -EINVAL;
-				}
-			}
+		if (keys.enckeylen != DES_KEY_SIZE ||
+		    crypto_des_verify_key(crypto_aead_tfm(cipher), keys.enckey))
+			return -EINVAL;
 
-			ctx->cipher_type = CIPHER_TYPE_DES;
-		} else {
-			goto badkey;
-		}
+		ctx->cipher_type = CIPHER_TYPE_DES;
 		break;
 	case CIPHER_ALG_3DES:
-		if (ctx->enckeylen == (DES_KEY_SIZE * 3)) {
-			u32 flags;
-
-			flags = crypto_aead_get_flags(cipher);
-			ret = __des3_verify_key(&flags, keys.enckey);
-			if (unlikely(ret)) {
-				crypto_aead_set_flags(cipher, flags);
-				return ret;
-			}
-
-			ctx->cipher_type = CIPHER_TYPE_3DES;
-		} else {
-			crypto_aead_set_flags(cipher,
-					      CRYPTO_TFM_RES_BAD_KEY_LEN);
+		if (keys.enckeylen != DES3_EDE_KEY_SIZE ||
+		    crypto_des3_ede_verify_key(crypto_aead_tfm(cipher),
+					       keys.enckey))
 			return -EINVAL;
-		}
+
+		ctx->cipher_type = CIPHER_TYPE_3DES;
 		break;
 	case CIPHER_ALG_AES:
 		switch (ctx->enckeylen) {
-- 
2.20.1


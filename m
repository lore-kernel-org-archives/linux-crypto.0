Return-Path: <SRS0=Fqdl=U3=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C4E5FC5B57A
	for <linux-crypto@archiver.kernel.org>; Fri, 28 Jun 2019 09:36:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9CC9B2147A
	for <linux-crypto@archiver.kernel.org>; Fri, 28 Jun 2019 09:36:01 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="dwApxGdI"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726731AbfF1JgA (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 28 Jun 2019 05:36:00 -0400
Received: from mail-wr1-f68.google.com ([209.85.221.68]:35036 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726702AbfF1JgA (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 28 Jun 2019 05:36:00 -0400
Received: by mail-wr1-f68.google.com with SMTP id f15so5565180wrp.2
        for <linux-crypto@vger.kernel.org>; Fri, 28 Jun 2019 02:35:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=vSQKZ3bzm1shSM3hwnkO5Kh0qutNPZoosKVcwtVkCKc=;
        b=dwApxGdIMeRWCQPnK9QMIwCVpxtwWcg/gyJWUQD24kAEAMRDsc23dI2iINEl5dD3nD
         qV2ROnFp5P+K1P5ns8vVwI3D5zTa2QWBTNipvG0HI4jVKVY6G6GVAzx0NvOLNR8TcJ/S
         bExIGNBzUa4Zd8jiHvC0MHrcpF5JahsYnW9nwNP2Lyx1iN/EsSTxPJ3sQKRm9hPX8/YK
         YwqChbnrOEDPrFBRiCl4vlp4Z0IQECc9KGMrZLQa2CUR1eMxkpRRtmCxz+wtYyCp8tp6
         yUJnSDCF24fT7Xot4Afjqv/FmW3f3//bsaXIcxLzUZMmTTHzAHYtUkXXwTSBuql40dvk
         gEsQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=vSQKZ3bzm1shSM3hwnkO5Kh0qutNPZoosKVcwtVkCKc=;
        b=b0DRPZ9Jiow/lhYgNI+EpdSd3p677q15dpbu+jVpSl4aQiLsvqVHIwVKViCk99WWOX
         6/cTb7GG5PSr576SDsyw1So5+JqRCdXs5wu/0241jlXNJfBExPpnb+IBsxuvtxWlhJlH
         zTCpVvzaI4/hBpR5OaZmNT7VHbxs3BcDrZddweEAbOmDjxiVrLuBYiThcMIeto4HDj00
         grgMv168K5HMyBR3vttz9uG4wzj5QyySX3/Uul509v5Swt+fUgb1rxwoTIxwcZO20CYS
         4DqD2c9efwLjMFBvH/K3Hjhp9OqA1I5L+6gMNi64OQ02zRbZmqOXVCmk8KGBqC4IOqMq
         GIJg==
X-Gm-Message-State: APjAAAWuzWdPsY7bM680PiS/BzPQSzq5aK3/TJT6KEI9RKCg0mchNHuF
        nsaOp6ZeF0qZrq4n3ucm3Hm2DQhKnOMzEQ==
X-Google-Smtp-Source: APXvYqxrIe0pKr09Fo9gPDWhmg2HLIe4JlqHRUgWm/dioKxb/2AWlX33GtTsOPp6VKtunhkbt+InzQ==
X-Received: by 2002:adf:ec12:: with SMTP id x18mr7038797wrn.145.1561714557693;
        Fri, 28 Jun 2019 02:35:57 -0700 (PDT)
Received: from localhost.localdomain (laubervilliers-657-1-83-120.w92-154.abo.wanadoo.fr. [92.154.90.120])
        by smtp.gmail.com with ESMTPSA id m24sm1709910wmi.39.2019.06.28.02.35.56
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Fri, 28 Jun 2019 02:35:57 -0700 (PDT)
From:   Ard Biesheuvel <ard.biesheuvel@linaro.org>
To:     linux-crypto@vger.kernel.org
Cc:     herbert@gondor.apana.org.au, ebiggers@kernel.org,
        horia.geanta@nxp.com, Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: [PATCH v3 18/30] crypto: picoxcell/des - switch to new verification routines
Date:   Fri, 28 Jun 2019 11:35:17 +0200
Message-Id: <20190628093529.12281-19-ard.biesheuvel@linaro.org>
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
 drivers/crypto/picoxcell_crypto.c | 21 +++++++-------------
 1 file changed, 7 insertions(+), 14 deletions(-)

diff --git a/drivers/crypto/picoxcell_crypto.c b/drivers/crypto/picoxcell_crypto.c
index 05b89e703903..842b413cbe60 100644
--- a/drivers/crypto/picoxcell_crypto.c
+++ b/drivers/crypto/picoxcell_crypto.c
@@ -19,7 +19,7 @@
 #include <crypto/aes.h>
 #include <crypto/algapi.h>
 #include <crypto/authenc.h>
-#include <crypto/des.h>
+#include <crypto/internal/des.h>
 #include <crypto/md5.h>
 #include <crypto/sha.h>
 #include <crypto/internal/skcipher.h>
@@ -751,14 +751,11 @@ static int spacc_des_setkey(struct crypto_ablkcipher *cipher, const u8 *key,
 {
 	struct crypto_tfm *tfm = crypto_ablkcipher_tfm(cipher);
 	struct spacc_ablk_ctx *ctx = crypto_tfm_ctx(tfm);
-	u32 tmp[DES_EXPKEY_WORDS];
+	int err;
 
-	if (unlikely(!des_ekey(tmp, key)) &&
-	    (crypto_ablkcipher_get_flags(cipher) &
-	     CRYPTO_TFM_REQ_FORBID_WEAK_KEYS)) {
-		tfm->crt_flags |= CRYPTO_TFM_RES_WEAK_KEY;
-		return -EINVAL;
-	}
+	err = crypto_des_verify_key(tfm, key);
+	if (err)
+		return err;
 
 	memcpy(ctx->key, key, len);
 	ctx->key_len = len;
@@ -774,15 +771,11 @@ static int spacc_des3_setkey(struct crypto_ablkcipher *cipher, const u8 *key,
 			     unsigned int len)
 {
 	struct spacc_ablk_ctx *ctx = crypto_ablkcipher_ctx(cipher);
-	u32 flags;
 	int err;
 
-	flags = crypto_ablkcipher_get_flags(cipher);
-	err = __des3_verify_key(&flags, key);
-	if (unlikely(err)) {
-		crypto_ablkcipher_set_flags(cipher, flags);
+	err = crypto_des3_ede_verify_key(crypto_ablkcipher_tfm(cipher), key);
+	if (err)
 		return err;
-	}
 
 	memcpy(ctx->key, key, len);
 	ctx->key_len = len;
-- 
2.20.1


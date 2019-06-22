Return-Path: <SRS0=RljO=UV=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BEE3EC43613
	for <linux-crypto@archiver.kernel.org>; Sat, 22 Jun 2019 00:32:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 90ED12084E
	for <linux-crypto@archiver.kernel.org>; Sat, 22 Jun 2019 00:32:00 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="ElYHiGYq"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726202AbfFVAcA (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 21 Jun 2019 20:32:00 -0400
Received: from mail-wr1-f68.google.com ([209.85.221.68]:35811 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726049AbfFVAb7 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 21 Jun 2019 20:31:59 -0400
Received: by mail-wr1-f68.google.com with SMTP id m3so8142294wrv.2
        for <linux-crypto@vger.kernel.org>; Fri, 21 Jun 2019 17:31:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=I5vcNvV5pKsNXmEt0eCjUJ4deAdaj9PR1+fxGr7yxD8=;
        b=ElYHiGYqrNfyG5oAsejxiKcl1Cs/6X2b/n4a6+SidJfAxwyxZqMHLd0TtMy4xYFBKN
         8YoeRfAqLH7nzSQzrnKCn3Bizunten2kEwvLaAZFMcAjxcSfKMSVx9Kfjle3vcV2XaQ2
         RqWI6xiuIyFUBaydP43880AMd/Xahd5UqGx0XiADRK7MXManUlo8ECbMPBEyPrT+XY4b
         0EukO1IjSFIMV48CbgHImjT5PJjwdg8zkqFdCqRJhQav+g1fZ+91hVAMRgUsNGclO+JO
         tEtZy08USEBHJgosNBs2pMn4WTFij+hhMD+FEKwy4wggItVVH+2oYst1jf7GrWaoP1ur
         egZA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=I5vcNvV5pKsNXmEt0eCjUJ4deAdaj9PR1+fxGr7yxD8=;
        b=iETuGDt1JahI3CbEPU40hxQxS2A9fm/dpXc1eeNAlVTW1X7cyE7IQhAs29CQ1Bpmzo
         yGMKUkXwAks9xOUxSrV9i4bcDtikLBMUYi39nVg1TKD8CtiRtudQv73NngUDpONbHwHC
         r4z1P9wEyiK5oKpq68C9e9CYIAT7G5crOuvbEKK8ulopL2KL+zKcRmkoAG6ixlF5MgbK
         P2CNxKA7d1lJrjV1frmI2qCxRSZABjhVeajtHkDVDZxP/ta7pZwc6OTwoJ0Mq/M8QMJE
         Rt7wOCeIsscQJ+EZVb7pZNCx8rA1M6F+bCMvGNIbhhtZkVy1nqg9lvLXsdQk01RUhwWm
         cZ4g==
X-Gm-Message-State: APjAAAVq55EKB7np1U0Di15J0uYvGVxPg1Su7NO3oJGyirISs74t6TFc
        W/68Ls4vtt+FPwK60YLt4O+4zBXVQmafiSba
X-Google-Smtp-Source: APXvYqxiRddzyHSjzQD9JZMeg8Ay7AuRf+plvcdUThPmHz6Xd4dmEQJy7WGwFxc/QT7qxUR2Tb/dfg==
X-Received: by 2002:adf:f181:: with SMTP id h1mr2508620wro.18.1561163516946;
        Fri, 21 Jun 2019 17:31:56 -0700 (PDT)
Received: from sudo.home ([2a01:cb1d:112:6f00:99d4:1ff0:ed6:dfbb])
        by smtp.gmail.com with ESMTPSA id v18sm4792019wrd.51.2019.06.21.17.31.56
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 21 Jun 2019 17:31:56 -0700 (PDT)
From:   Ard Biesheuvel <ard.biesheuvel@linaro.org>
To:     linux-crypto@vger.kernel.org
Cc:     herbert@gondor.apana.org.au, ebiggers@google.com,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: [RFC PATCH 12/30] crypto: hisilicon/des - switch to new verification routines
Date:   Sat, 22 Jun 2019 02:30:54 +0200
Message-Id: <20190622003112.31033-13-ard.biesheuvel@linaro.org>
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
 drivers/crypto/hisilicon/sec/sec_algs.c | 34 ++++++++++++++------
 1 file changed, 25 insertions(+), 9 deletions(-)

diff --git a/drivers/crypto/hisilicon/sec/sec_algs.c b/drivers/crypto/hisilicon/sec/sec_algs.c
index 02768af0dccd..7d563188d80c 100644
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
@@ -347,8 +347,11 @@ static int sec_alg_skcipher_setkey_aes_xts(struct crypto_skcipher *tfm,
 static int sec_alg_skcipher_setkey_des_ecb(struct crypto_skcipher *tfm,
 					   const u8 *key, unsigned int keylen)
 {
-	if (keylen != DES_KEY_SIZE)
-		return -EINVAL;
+	int err;
+
+	err = crypto_des_verify_key(crypto_skcipher_tfm(tfm), key, keylen);
+	if (unlikely(err))
+		return err;
 
 	return sec_alg_skcipher_setkey(tfm, key, keylen, SEC_C_DES_ECB_64);
 }
@@ -356,8 +359,11 @@ static int sec_alg_skcipher_setkey_des_ecb(struct crypto_skcipher *tfm,
 static int sec_alg_skcipher_setkey_des_cbc(struct crypto_skcipher *tfm,
 					   const u8 *key, unsigned int keylen)
 {
-	if (keylen != DES_KEY_SIZE)
-		return -EINVAL;
+	int err;
+
+	err = crypto_des_verify_key(crypto_skcipher_tfm(tfm), key, keylen);
+	if (unlikely(err))
+		return err;
 
 	return sec_alg_skcipher_setkey(tfm, key, keylen, SEC_C_DES_CBC_64);
 }
@@ -365,16 +371,26 @@ static int sec_alg_skcipher_setkey_des_cbc(struct crypto_skcipher *tfm,
 static int sec_alg_skcipher_setkey_3des_ecb(struct crypto_skcipher *tfm,
 					    const u8 *key, unsigned int keylen)
 {
-	return unlikely(des3_verify_key(tfm, key)) ?:
-	       sec_alg_skcipher_setkey(tfm, key, keylen,
+	int err;
+
+	err = crypto_des3_ede_verify_key(crypto_skcipher_tfm(tfm), key, keylen);
+	if (unlikely(err))
+		return err;
+
+	return sec_alg_skcipher_setkey(tfm, key, keylen,
 				       SEC_C_3DES_ECB_192_3KEY);
 }
 
 static int sec_alg_skcipher_setkey_3des_cbc(struct crypto_skcipher *tfm,
 					    const u8 *key, unsigned int keylen)
 {
-	return unlikely(des3_verify_key(tfm, key)) ?:
-	       sec_alg_skcipher_setkey(tfm, key, keylen,
+	int err;
+
+	err = crypto_des3_ede_verify_key(crypto_skcipher_tfm(tfm), key, keylen);
+	if (unlikely(err))
+		return err;
+
+	return sec_alg_skcipher_setkey(tfm, key, keylen,
 				       SEC_C_3DES_CBC_192_3KEY);
 }
 
-- 
2.20.1


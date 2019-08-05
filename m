Return-Path: <SRS0=2Ix1=WB=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 13C9FC433FF
	for <linux-crypto@archiver.kernel.org>; Mon,  5 Aug 2019 17:01:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id DC5652054F
	for <linux-crypto@archiver.kernel.org>; Mon,  5 Aug 2019 17:01:56 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="o7vVTgzE"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729882AbfHERBz (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 5 Aug 2019 13:01:55 -0400
Received: from mail-wm1-f68.google.com ([209.85.128.68]:51046 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729780AbfHERBy (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 5 Aug 2019 13:01:54 -0400
Received: by mail-wm1-f68.google.com with SMTP id v15so75463953wml.0
        for <linux-crypto@vger.kernel.org>; Mon, 05 Aug 2019 10:01:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=WC3A3IO1SDn1jU7zjFN6JA5UEhD6hCSAXMtuWmVsFZY=;
        b=o7vVTgzE/5LzN9VPuGrusL6KDb9nCeJKy46BD4YaR9yg/sO5wleM46K0KM27h/ZN8J
         E+C6u+dKuesfWdHwVw8+RFxI4BWuDRMIDgHAckN2KhKirdxGFE9q0heB4KL2AV5wkhUp
         ISItX1KD6C31qJ0DZ2wdFqsQbuCbMR19iMFxnw3tPyEhipRmYvLlLR11BhDZTZ7/F9k5
         LXiS9/pmIvk9zP71NYwZtNOOJ8L7cUwqbrszmMLIujJSICBaP333cxJvFuDLNDEbL9k2
         pWZYGDhOHSwIJZIDB5T8z09nteJyzkGnVO+w+iKowiUzElXs8AqJOHjCg1JJw8K4TPkp
         Tmsw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=WC3A3IO1SDn1jU7zjFN6JA5UEhD6hCSAXMtuWmVsFZY=;
        b=IhY1zlIezYOblfmRvvTe5pR5lCgvSCJCopf1mQmDgJJF9iM9e73IqrsgnjW+NMht8/
         A5z9n/qNi/Qr0VOa2vDsGteGpTygUHe5Nkvj0wcek4I8PrnCJQbNu8ZGpGxBlwQfNSGs
         5Dnt551fbwUuaPYkmScb2yec25w4ElpkF517hgKgOluv64fzg2U5f+Vl9njEc9LXDQsq
         R8ga1XswJa+XnVOizWPn3nQAnSrMXq18zJvScSBzpvY9Wa6BhhDeqQAcyYcGwtU2E7Ee
         wof1YlPSrRj3cDviudDOGQM5jEMBCMlmAasM+LvtEzlIc9goTO/6We+5jO8rXKMZcFPv
         GSaQ==
X-Gm-Message-State: APjAAAWdUTD3PmHIK54b3VlvX7+r0AKYKImIRuN2rdltjOJh02mreSB0
        N5ZrfCHkDqbYF2pl641y4wn2ubMPKKEj/Q==
X-Google-Smtp-Source: APXvYqz6tp0xz58YSdRQ/zTII1jO7M9BiF0IuSOMvKa4mqU74n4JmB9SqLtjiq677DZ4y2heeAkg6Q==
X-Received: by 2002:a7b:c745:: with SMTP id w5mr19156972wmk.21.1565024512948;
        Mon, 05 Aug 2019 10:01:52 -0700 (PDT)
Received: from localhost.localdomain ([2a02:587:a407:da00:582f:8334:9cd9:7241])
        by smtp.gmail.com with ESMTPSA id j9sm95669383wrn.81.2019.08.05.10.01.51
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 05 Aug 2019 10:01:52 -0700 (PDT)
From:   Ard Biesheuvel <ard.biesheuvel@linaro.org>
To:     linux-crypto@vger.kernel.org
Cc:     herbert@gondor.apana.org.au, ebiggers@kernel.org,
        horia.geanta@nxp.com, Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: [PATCH v4 15/30] crypto: cesa/des - switch to new verification routines
Date:   Mon,  5 Aug 2019 20:00:22 +0300
Message-Id: <20190805170037.31330-16-ard.biesheuvel@linaro.org>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190805170037.31330-1-ard.biesheuvel@linaro.org>
References: <20190805170037.31330-1-ard.biesheuvel@linaro.org>
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
---
 drivers/crypto/marvell/cipher.c | 22 +++++++-------------
 1 file changed, 7 insertions(+), 15 deletions(-)

diff --git a/drivers/crypto/marvell/cipher.c b/drivers/crypto/marvell/cipher.c
index fa1997e70b63..6e9c390314d7 100644
--- a/drivers/crypto/marvell/cipher.c
+++ b/drivers/crypto/marvell/cipher.c
@@ -10,7 +10,7 @@
  */
 
 #include <crypto/aes.h>
-#include <crypto/des.h>
+#include <crypto/internal/des.h>
 
 #include "cesa.h"
 
@@ -274,19 +274,11 @@ static int mv_cesa_des_setkey(struct crypto_skcipher *cipher, const u8 *key,
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
+	err = crypto_des_verify_key(tfm, key);
+	if (err)
+		return err;
 
 	memcpy(ctx->key, key, DES_KEY_SIZE);
 
@@ -299,8 +291,8 @@ static int mv_cesa_des3_ede_setkey(struct crypto_skcipher *cipher,
 	struct mv_cesa_des_ctx *ctx = crypto_skcipher_ctx(cipher);
 	int err;
 
-	err = des3_verify_key(cipher, key);
-	if (unlikely(err))
+	err = crypto_des3_ede_verify_key(crypto_skcipher_tfm(cipher), key);
+	if (err)
 		return err;
 
 	memcpy(ctx->key, key, DES3_EDE_KEY_SIZE);
-- 
2.17.1


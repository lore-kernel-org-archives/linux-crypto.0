Return-Path: <SRS0=pRBs=WL=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DF027C31E40
	for <linux-crypto@archiver.kernel.org>; Thu, 15 Aug 2019 09:02:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B604E218A6
	for <linux-crypto@archiver.kernel.org>; Thu, 15 Aug 2019 09:02:05 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="ouTa8Jts"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730811AbfHOJCF (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 15 Aug 2019 05:02:05 -0400
Received: from mail-wm1-f68.google.com ([209.85.128.68]:34583 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730806AbfHOJCE (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 15 Aug 2019 05:02:04 -0400
Received: by mail-wm1-f68.google.com with SMTP id e8so589920wme.1
        for <linux-crypto@vger.kernel.org>; Thu, 15 Aug 2019 02:02:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=XLJnIIvmW4SzkEyV1uIEA40FVVu0pdhDcedX5nqwoBk=;
        b=ouTa8JtsfJZaISvVI6BDVEtCiXUWdEm76zb+FfXH0X1oW/RjIVMnu+kPsDdLHgtjH7
         cThk2l+89bjCGW41VLvEbnZDIs4jRm39njIFF2e+K8OrmVDeto9JP/wdXktqO2bZmVO2
         loxvAwtk/AA+McxxLWFfZnHEwLNiGFR1I+BO6ObJKkLAvubjX1dPrtP2FaD4AaN/GTk8
         fIEQUFqUbZ9PxNfcxjk3FhAbuqWeeNLjlbe2SYELV2YEmU76r27T8Lbx4SOZEXv1Ixjk
         QOwltCNYLFNQBGCBzx3rdWhbqkuzq8dF5zxT8f1U41gAEHzJAWwVvYK585wB2phY6S00
         IVjQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=XLJnIIvmW4SzkEyV1uIEA40FVVu0pdhDcedX5nqwoBk=;
        b=TATZ9jfhPH1NMYAcg3ne3RyAgsOxMramsgQdKVKwR/CkBmp+A/mo7Grik8vtr8ZtCp
         BVCdEa2XSwv/WH2wKZXkVMDhTHEaijvc7z2m7X4jxkRnvGzpV0EAf8uC6w1adbY0+Lo3
         c2vNJd2pXwf0DxjSJ65DnLwshYbOKTDLqikiSwtj0RNzpiu3S6KqnGcU5+mJ95YwswNh
         0Vne9Jb0uFd895GNv6tnuCgERoOgiV3qJ5PRw3ktkjvIBNb2Ynq9v102T2A4gbDKI+hP
         u3hJqeNV5sbEupjkosNjKTIIDZxG8Gv6pjAYv+7p+rAxvy8Xy1EXyCbmT02kmvem9Sfs
         HMuQ==
X-Gm-Message-State: APjAAAW/I9t8S8Pqhyvuk/1NfXI4VcL+Z3ZWUiBm7LYKIE1I/iS46oc/
        qXw7jS3cheQ/KcYrgbXwdKVQrQPcOvKhKrOD
X-Google-Smtp-Source: APXvYqxYlhDX7iECwt6axMRA+PI+LCM0iIiRqOTk6uRWaIOPrEm2O2mcAI1wrIjgo2sElRFisArgIA==
X-Received: by 2002:a1c:ed06:: with SMTP id l6mr1646070wmh.128.1565859722865;
        Thu, 15 Aug 2019 02:02:02 -0700 (PDT)
Received: from localhost.localdomain ([2a02:587:a407:da00:f1b5:e68c:5f7f:79e7])
        by smtp.gmail.com with ESMTPSA id x20sm3857533wrg.10.2019.08.15.02.02.00
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 15 Aug 2019 02:02:02 -0700 (PDT)
From:   Ard Biesheuvel <ard.biesheuvel@linaro.org>
To:     linux-crypto@vger.kernel.org
Cc:     herbert@gondor.apana.org.au,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        Corentin Labbe <clabbe.montjoie@gmail.com>
Subject: [PATCH v5 22/30] crypto: sun4i/des - switch to new verification routines
Date:   Thu, 15 Aug 2019 12:01:04 +0300
Message-Id: <20190815090112.9377-23-ard.biesheuvel@linaro.org>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190815090112.9377-1-ard.biesheuvel@linaro.org>
References: <20190815090112.9377-1-ard.biesheuvel@linaro.org>
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Cc: Corentin Labbe <clabbe.montjoie@gmail.com>
Acked-by: Corentin Labbe <clabbe.montjoie@gmail.com>
Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
---
 drivers/crypto/sunxi-ss/sun4i-ss-cipher.c | 26 +++++---------------
 drivers/crypto/sunxi-ss/sun4i-ss.h        |  2 +-
 2 files changed, 7 insertions(+), 21 deletions(-)

diff --git a/drivers/crypto/sunxi-ss/sun4i-ss-cipher.c b/drivers/crypto/sunxi-ss/sun4i-ss-cipher.c
index 6f7cbf6c2b55..6536fd4bee65 100644
--- a/drivers/crypto/sunxi-ss/sun4i-ss-cipher.c
+++ b/drivers/crypto/sunxi-ss/sun4i-ss-cipher.c
@@ -542,25 +542,11 @@ int sun4i_ss_des_setkey(struct crypto_skcipher *tfm, const u8 *key,
 			unsigned int keylen)
 {
 	struct sun4i_tfm_ctx *op = crypto_skcipher_ctx(tfm);
-	struct sun4i_ss_ctx *ss = op->ss;
-	u32 flags;
-	u32 tmp[DES_EXPKEY_WORDS];
-	int ret;
-
-	if (unlikely(keylen != DES_KEY_SIZE)) {
-		dev_err(ss->dev, "Invalid keylen %u\n", keylen);
-		crypto_skcipher_set_flags(tfm, CRYPTO_TFM_RES_BAD_KEY_LEN);
-		return -EINVAL;
-	}
-
-	flags = crypto_skcipher_get_flags(tfm);
+	int err;
 
-	ret = des_ekey(tmp, key);
-	if (unlikely(!ret) && (flags & CRYPTO_TFM_REQ_FORBID_WEAK_KEYS)) {
-		crypto_skcipher_set_flags(tfm, CRYPTO_TFM_RES_WEAK_KEY);
-		dev_dbg(ss->dev, "Weak key %u\n", keylen);
-		return -EINVAL;
-	}
+	err = verify_skcipher_des_key(tfm, key);
+	if (err)
+		return err;
 
 	op->keylen = keylen;
 	memcpy(op->key, key, keylen);
@@ -578,8 +564,8 @@ int sun4i_ss_des3_setkey(struct crypto_skcipher *tfm, const u8 *key,
 	struct sun4i_tfm_ctx *op = crypto_skcipher_ctx(tfm);
 	int err;
 
-	err = des3_verify_key(tfm, key);
-	if (unlikely(err))
+	err = verify_skcipher_des3_key(tfm, key);
+	if (err)
 		return err;
 
 	op->keylen = keylen;
diff --git a/drivers/crypto/sunxi-ss/sun4i-ss.h b/drivers/crypto/sunxi-ss/sun4i-ss.h
index 8654d48aedc0..35a27a7145f8 100644
--- a/drivers/crypto/sunxi-ss/sun4i-ss.h
+++ b/drivers/crypto/sunxi-ss/sun4i-ss.h
@@ -29,7 +29,7 @@
 #include <crypto/internal/hash.h>
 #include <crypto/internal/skcipher.h>
 #include <crypto/aes.h>
-#include <crypto/des.h>
+#include <crypto/internal/des.h>
 #include <crypto/internal/rng.h>
 #include <crypto/rng.h>
 
-- 
2.17.1


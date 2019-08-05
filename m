Return-Path: <SRS0=2Ix1=WB=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1EBCCC32751
	for <linux-crypto@archiver.kernel.org>; Mon,  5 Aug 2019 17:02:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E3167216B7
	for <linux-crypto@archiver.kernel.org>; Mon,  5 Aug 2019 17:01:59 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="wdhJ4M/x"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729282AbfHERB7 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 5 Aug 2019 13:01:59 -0400
Received: from mail-wm1-f65.google.com ([209.85.128.65]:38281 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729780AbfHERB5 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 5 Aug 2019 13:01:57 -0400
Received: by mail-wm1-f65.google.com with SMTP id s15so52371407wmj.3
        for <linux-crypto@vger.kernel.org>; Mon, 05 Aug 2019 10:01:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=l75t/dMwz3Dca4AbndWnCxvkr19XiVvwzyPSZ/AWGvQ=;
        b=wdhJ4M/xV309R2I1BFf4/mRxDKTvOSlu8QUOhnv6Dmto7U3n8JCQ6m/++Dc/ERZW6t
         DlquOvzZ5ZCeJhfAwxo33KAz+WBpV/iC+nWuFPx9AeUC9d/qYVdcozIOrsoxW5XyrdtG
         1YVNxvylN8qpOy997nyAeOIJro6jVFWNQ1WR7N8tVg9ZLAK3n+3BlwfDrF6FEuXssAZL
         bDfVhI/h5xB627NsZl1xG3dSWw4iGTqRn1UJUa7eO1j2N9wLAyy+b8k5RVIBJAGHsL9L
         drI849vdYaTaUjOB3rqYbtyV5g9AkbrPJy9LJj2D307aYyEpOBArX7iTgMP5pFwu/urQ
         RUHg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=l75t/dMwz3Dca4AbndWnCxvkr19XiVvwzyPSZ/AWGvQ=;
        b=fx+SE5dDg/80XWMQ7hq3VUfi6z50Ff83Epy62lH2eGTfdCTwweqI6E/DPxAYzYCzMm
         RHLMGxDrVD8C5RPxWtB3S0nDi1KJXsX57r4XWBtB6HVKQMCwtFH4VczdlD0KMB6mArDF
         A6vSViEQ1u5Z1Lm0PktQRVcvch+MP9XkfEtglAobJhi3kGAYm5uYOKGj287co5lLqad+
         /gqaznueGrHlLEVRZ/K0/h+pSIcb6pwS9q/nlBeLonV32X5C3KuqhlFkA7fTlobDrOUW
         ESCiqCb4ZD/NEodRAcSKJGy+z2sB+LS/9bjs2CYfzWoGLWO909apGIVblyThuARmPH8D
         0JOA==
X-Gm-Message-State: APjAAAVJ/ofSFBbDXpyIonBbi84SYW7Arpy+s82WhJr+lC8Jf/mccIMl
        LrmLQx4SSxhiv2ZN5pobnAwgDJ9bX1/R9A==
X-Google-Smtp-Source: APXvYqydgY2N4T1JDENleto1GAELpr7e7VvRaSnzzXs4w9y1YxA6Z3wFgBcZeMbxNfgCq37LuEtgJQ==
X-Received: by 2002:a05:600c:114f:: with SMTP id z15mr19376097wmz.131.1565024515571;
        Mon, 05 Aug 2019 10:01:55 -0700 (PDT)
Received: from localhost.localdomain ([2a02:587:a407:da00:582f:8334:9cd9:7241])
        by smtp.gmail.com with ESMTPSA id j9sm95669383wrn.81.2019.08.05.10.01.53
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 05 Aug 2019 10:01:54 -0700 (PDT)
From:   Ard Biesheuvel <ard.biesheuvel@linaro.org>
To:     linux-crypto@vger.kernel.org
Cc:     herbert@gondor.apana.org.au, ebiggers@kernel.org,
        horia.geanta@nxp.com, Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: [PATCH v4 16/30] crypto: n2/des - switch to new verification routines
Date:   Mon,  5 Aug 2019 20:00:23 +0300
Message-Id: <20190805170037.31330-17-ard.biesheuvel@linaro.org>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190805170037.31330-1-ard.biesheuvel@linaro.org>
References: <20190805170037.31330-1-ard.biesheuvel@linaro.org>
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
---
 drivers/crypto/n2_core.c | 26 ++++++--------------
 1 file changed, 7 insertions(+), 19 deletions(-)

diff --git a/drivers/crypto/n2_core.c b/drivers/crypto/n2_core.c
index 760e72a5893b..bad1719a902f 100644
--- a/drivers/crypto/n2_core.c
+++ b/drivers/crypto/n2_core.c
@@ -17,7 +17,7 @@
 #include <crypto/md5.h>
 #include <crypto/sha.h>
 #include <crypto/aes.h>
-#include <crypto/des.h>
+#include <crypto/internal/des.h>
 #include <linux/mutex.h>
 #include <linux/delay.h>
 #include <linux/sched.h>
@@ -760,21 +760,13 @@ static int n2_des_setkey(struct crypto_ablkcipher *cipher, const u8 *key,
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
+	err = crypto_des_verify_key(tfm, key);
+	if (err)
+		return err;
 
-	err = des_ekey(tmp, key);
-	if (err == 0 && (tfm->crt_flags & CRYPTO_TFM_REQ_FORBID_WEAK_KEYS)) {
-		tfm->crt_flags |= CRYPTO_TFM_RES_WEAK_KEY;
-		return -EINVAL;
-	}
+	ctx->enc_type = n2alg->enc_type;
 
 	ctx->key_len = keylen;
 	memcpy(ctx->key.des, key, keylen);
@@ -787,15 +779,11 @@ static int n2_3des_setkey(struct crypto_ablkcipher *cipher, const u8 *key,
 	struct crypto_tfm *tfm = crypto_ablkcipher_tfm(cipher);
 	struct n2_cipher_context *ctx = crypto_tfm_ctx(tfm);
 	struct n2_cipher_alg *n2alg = n2_cipher_alg(tfm);
-	u32 flags;
 	int err;
 
-	flags = crypto_ablkcipher_get_flags(cipher);
-	err = __des3_verify_key(&flags, key);
-	if (unlikely(err)) {
-		crypto_ablkcipher_set_flags(cipher, flags);
+	err = crypto_des3_ede_verify_key(tfm, key);
+	if (err)
 		return err;
-	}
 
 	ctx->enc_type = n2alg->enc_type;
 
-- 
2.17.1


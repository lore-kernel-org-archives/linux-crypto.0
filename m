Return-Path: <SRS0=CUNG=U2=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BA56CC48BD7
	for <linux-crypto@archiver.kernel.org>; Thu, 27 Jun 2019 12:03:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 927FA20656
	for <linux-crypto@archiver.kernel.org>; Thu, 27 Jun 2019 12:03:44 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="LAQBgYmw"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726807AbfF0MDn (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 27 Jun 2019 08:03:43 -0400
Received: from mail-wm1-f65.google.com ([209.85.128.65]:38011 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726748AbfF0MDm (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 27 Jun 2019 08:03:42 -0400
Received: by mail-wm1-f65.google.com with SMTP id s15so5396678wmj.3
        for <linux-crypto@vger.kernel.org>; Thu, 27 Jun 2019 05:03:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=1NLX7Ssyb/ZRxNU0BkyKxeA/jE2yVM/zXDvF/QseuEc=;
        b=LAQBgYmwtP4sWR8noB3cdXUnjN20iabZXLL0X6sYXdfj5VetQoLy2EiVY3kAr0YcpT
         wIbaMxQBhESZ8wXt75FZ+FOfSFNqLyHze/yHqT38qSHM9YV2Ctjre40+7XOMcMCjwkrf
         ZokHTBB5saMNSpfmoZXu2ndC1Rr0cwVxrtUl+O0JMZ8Uc86GOK5cGGjOFgLPoF3FKbnf
         rn707bfGaf9tpDN7HwamTuPOisWjdd6o7KCdj0hZZesJbfniSElbQDaQjSOeEEKoLgaG
         mVoV/oLN+tUexz7eeg6AorIipjkDjNj/zGpbPKwBAfPEUpdHls4lkAAMblZxMQJf36dm
         upcQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=1NLX7Ssyb/ZRxNU0BkyKxeA/jE2yVM/zXDvF/QseuEc=;
        b=NLcVsswUDLNOYgUbX1zxo17bTeTvTmO6uuXWs3Zp7LYrJN6OXuoYRCo+qU+PeKMKTd
         ZJY3EWViu0aGkKslyFnB71paISjJmkRefv1L+93REwN6ZtRFjETkaKD8bcTMkPpT2DhX
         1oJ4NVpGXsYW2iMm+x3OipANsVk7sKY8RpwQDHdLb2udlGOx9tuox9nF4JZhamlJQmWj
         ftaZ1AwmIF7a2D0ks0F7qduYzLDV0I8XUZpfDJSN6ujtmCv3EScfpWvxZJjrpC/EagND
         QPRx5F83ExzkLxuuBVVVJwTjQ/4Ib8pcf8d8+Vnsjsxxkt/zr9ykK2VLSgplpsgz8HBB
         RRAA==
X-Gm-Message-State: APjAAAXXrrXF8EqTYM6ceWMUEU1qs36nzsER0O+WAFgZTeghASGYTtgq
        rK2we2j6kMoXsAaGHu1Wjkh/xBeBW0k6Dw==
X-Google-Smtp-Source: APXvYqynk9nTkM0lO6v3Y59Hqf2Pn/VFi9zwL6/ejoKgAYBMAX9GUYCFeHQbVgOQOMQSqgBeIguCiQ==
X-Received: by 2002:a1c:b146:: with SMTP id a67mr2951463wmf.124.1561637020766;
        Thu, 27 Jun 2019 05:03:40 -0700 (PDT)
Received: from localhost.localdomain (laubervilliers-657-1-83-120.w92-154.abo.wanadoo.fr. [92.154.90.120])
        by smtp.gmail.com with ESMTPSA id z126sm7732431wmb.32.2019.06.27.05.03.39
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Thu, 27 Jun 2019 05:03:39 -0700 (PDT)
From:   Ard Biesheuvel <ard.biesheuvel@linaro.org>
To:     linux-crypto@vger.kernel.org
Cc:     herbert@gondor.apana.org.au, ebiggers@kernel.org,
        horia.geanta@nxp.com, Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: [PATCH v2 13/30] crypto: safexcel/des - switch to new verification routines
Date:   Thu, 27 Jun 2019 14:02:57 +0200
Message-Id: <20190627120314.7197-14-ard.biesheuvel@linaro.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190627120314.7197-1-ard.biesheuvel@linaro.org>
References: <20190627120314.7197-1-ard.biesheuvel@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
---
 drivers/crypto/inside-secure/safexcel_cipher.c | 16 ++++------------
 1 file changed, 4 insertions(+), 12 deletions(-)

diff --git a/drivers/crypto/inside-secure/safexcel_cipher.c b/drivers/crypto/inside-secure/safexcel_cipher.c
index 8cdbdbe35681..e6f00b56f063 100644
--- a/drivers/crypto/inside-secure/safexcel_cipher.c
+++ b/drivers/crypto/inside-secure/safexcel_cipher.c
@@ -963,19 +963,11 @@ static int safexcel_des_setkey(struct crypto_skcipher *ctfm, const u8 *key,
 {
 	struct crypto_tfm *tfm = crypto_skcipher_tfm(ctfm);
 	struct safexcel_cipher_ctx *ctx = crypto_tfm_ctx(tfm);
-	u32 tmp[DES_EXPKEY_WORDS];
 	int ret;
 
-	if (len != DES_KEY_SIZE) {
-		crypto_skcipher_set_flags(ctfm, CRYPTO_TFM_RES_BAD_KEY_LEN);
-		return -EINVAL;
-	}
-
-	ret = des_ekey(tmp, key);
-	if (!ret && (tfm->crt_flags & CRYPTO_TFM_REQ_FORBID_WEAK_KEYS)) {
-		tfm->crt_flags |= CRYPTO_TFM_RES_WEAK_KEY;
-		return -EINVAL;
-	}
+	ret = crypto_des_verify_key(tfm, key);
+	if (unlikely(ret))
+		return ret;
 
 	/* if context exits and key changed, need to invalidate it */
 	if (ctx->base.ctxr_dma)
@@ -1074,7 +1066,7 @@ static int safexcel_des3_ede_setkey(struct crypto_skcipher *ctfm,
 	struct safexcel_cipher_ctx *ctx = crypto_skcipher_ctx(ctfm);
 	int err;
 
-	err = des3_verify_key(ctfm, key);
+	err = crypto_des3_ede_verify_key(crypto_skcipher_tfm(ctfm), key);
 	if (unlikely(err))
 		return err;
 
-- 
2.20.1


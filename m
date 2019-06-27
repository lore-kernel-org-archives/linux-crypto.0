Return-Path: <SRS0=CUNG=U2=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DF470C48BDA
	for <linux-crypto@archiver.kernel.org>; Thu, 27 Jun 2019 12:03:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B821520656
	for <linux-crypto@archiver.kernel.org>; Thu, 27 Jun 2019 12:03:53 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="KdfJVun+"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726816AbfF0MDw (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 27 Jun 2019 08:03:52 -0400
Received: from mail-wr1-f67.google.com ([209.85.221.67]:42826 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726867AbfF0MDw (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 27 Jun 2019 08:03:52 -0400
Received: by mail-wr1-f67.google.com with SMTP id x17so2242081wrl.9
        for <linux-crypto@vger.kernel.org>; Thu, 27 Jun 2019 05:03:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=T/RYEPQWF2x5irsNjj88sVD+R/k06WJQGdA2A6mcj7A=;
        b=KdfJVun+quBw9qR4nnbl3wKtXzuyxIXQwcGvKS41w51CnAbrVpOafWkopLjSzh/Vfr
         U2aohhPdP605iXjBgOH9ufQpojNiTHQ1ITv4JUqnRek1pq+FOosn2EUkojqan9Yvfr2a
         WUmGy3zl1iosLZIv13192esmORPRPdx6ua2AigC7mYu1yZUOm1Yl6wuY1LoIJszO7e/9
         7OjTdeUZhoFeEyESJYNCKSzyRoUGkgbYpNpPvuRbuvj5vh/7yaEMzGTE4ZkHwJO/mG+C
         8xCQpmZv2wS78ynWlEVVcmm27DcsUQRHcjaY/zxjOPglYROh7hpUj17SCjQlPqxe2DuS
         Mfqw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=T/RYEPQWF2x5irsNjj88sVD+R/k06WJQGdA2A6mcj7A=;
        b=PEuIrRg15Y00NtsS80ikXVNv95h85s05zqym3eCm74TfdgdTkx2KjY/jR6HxJaURgQ
         IASzvtYvkwKPDA5rkzZBwFDpgDKDfM8zhAC5Xot3up2zYgDtqlYUlPnsqDM4a1S/sS8Q
         4Vkasa28i5AycFC5dADt+CiAssj+eQEwha+cWSp8ydezReEsrmWW43/KUZR6njWiFqBq
         kH8v7rXikhDnhEeBU3sB96/Q2xkF7JbIAyJRT/kox0gNh6X1r80G42Fm01Yc7OAYEBOe
         lkYW60dyc6WXHU6kFxoR2AydZx6jCSVqBSVlajjHshMhMSta7GdvHdtNx29tBIgk5O6V
         RJuA==
X-Gm-Message-State: APjAAAWvmnwPpOkopez4J/jJgTjIhJDrXsJevgX29AJ0c6gfDRczXZG8
        dSi4yHw16JxXQsplUBVjrukwjo02cx0HWw==
X-Google-Smtp-Source: APXvYqwKXvFsn0uy44vcMaxOuKzOgHEhm9DNp6fP3YzpffHPbCv5lPCs5gtPawcivFp6w6H/xT+EtQ==
X-Received: by 2002:adf:f649:: with SMTP id x9mr2787180wrp.86.1561637030056;
        Thu, 27 Jun 2019 05:03:50 -0700 (PDT)
Received: from localhost.localdomain (laubervilliers-657-1-83-120.w92-154.abo.wanadoo.fr. [92.154.90.120])
        by smtp.gmail.com with ESMTPSA id z126sm7732431wmb.32.2019.06.27.05.03.49
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Thu, 27 Jun 2019 05:03:49 -0700 (PDT)
From:   Ard Biesheuvel <ard.biesheuvel@linaro.org>
To:     linux-crypto@vger.kernel.org
Cc:     herbert@gondor.apana.org.au, ebiggers@kernel.org,
        horia.geanta@nxp.com, Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: [PATCH v2 22/30] crypto: sun4i/des - switch to new verification routines
Date:   Thu, 27 Jun 2019 14:03:06 +0200
Message-Id: <20190627120314.7197-23-ard.biesheuvel@linaro.org>
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
 drivers/crypto/sunxi-ss/sun4i-ss-cipher.c | 22 ++++----------------
 drivers/crypto/sunxi-ss/sun4i-ss.h        |  2 +-
 2 files changed, 5 insertions(+), 19 deletions(-)

diff --git a/drivers/crypto/sunxi-ss/sun4i-ss-cipher.c b/drivers/crypto/sunxi-ss/sun4i-ss-cipher.c
index b060a0810934..93b383654af0 100644
--- a/drivers/crypto/sunxi-ss/sun4i-ss-cipher.c
+++ b/drivers/crypto/sunxi-ss/sun4i-ss-cipher.c
@@ -533,25 +533,11 @@ int sun4i_ss_des_setkey(struct crypto_skcipher *tfm, const u8 *key,
 			unsigned int keylen)
 {
 	struct sun4i_tfm_ctx *op = crypto_skcipher_ctx(tfm);
-	struct sun4i_ss_ctx *ss = op->ss;
-	u32 flags;
-	u32 tmp[DES_EXPKEY_WORDS];
 	int ret;
 
-	if (unlikely(keylen != DES_KEY_SIZE)) {
-		dev_err(ss->dev, "Invalid keylen %u\n", keylen);
-		crypto_skcipher_set_flags(tfm, CRYPTO_TFM_RES_BAD_KEY_LEN);
-		return -EINVAL;
-	}
-
-	flags = crypto_skcipher_get_flags(tfm);
-
-	ret = des_ekey(tmp, key);
-	if (unlikely(!ret) && (flags & CRYPTO_TFM_REQ_FORBID_WEAK_KEYS)) {
-		crypto_skcipher_set_flags(tfm, CRYPTO_TFM_RES_WEAK_KEY);
-		dev_dbg(ss->dev, "Weak key %u\n", keylen);
-		return -EINVAL;
-	}
+	err = crypto_des_verify_key(crypto_skcipher_tfm(tfm), key);
+	if (unlikely(err))
+		return err;
 
 	op->keylen = keylen;
 	memcpy(op->key, key, keylen);
@@ -569,7 +555,7 @@ int sun4i_ss_des3_setkey(struct crypto_skcipher *tfm, const u8 *key,
 	struct sun4i_tfm_ctx *op = crypto_skcipher_ctx(tfm);
 	int err;
 
-	err = des3_verify_key(tfm, key);
+	err = crypto_des3_ede_verify_key(crypto_skcipher_tfm(tfm), key);
 	if (unlikely(err))
 		return err;
 
diff --git a/drivers/crypto/sunxi-ss/sun4i-ss.h b/drivers/crypto/sunxi-ss/sun4i-ss.h
index 8c4ec9e93565..3c62624d8faa 100644
--- a/drivers/crypto/sunxi-ss/sun4i-ss.h
+++ b/drivers/crypto/sunxi-ss/sun4i-ss.h
@@ -30,7 +30,7 @@
 #include <crypto/internal/hash.h>
 #include <crypto/internal/skcipher.h>
 #include <crypto/aes.h>
-#include <crypto/des.h>
+#include <crypto/internal/des.h>
 #include <crypto/internal/rng.h>
 #include <crypto/rng.h>
 
-- 
2.20.1


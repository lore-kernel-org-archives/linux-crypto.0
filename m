Return-Path: <SRS0=Fqdl=U3=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 435B0C5B579
	for <linux-crypto@archiver.kernel.org>; Fri, 28 Jun 2019 09:36:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1819F2147A
	for <linux-crypto@archiver.kernel.org>; Fri, 28 Jun 2019 09:36:06 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="LEoOcOlV"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726706AbfF1JgF (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 28 Jun 2019 05:36:05 -0400
Received: from mail-wm1-f67.google.com ([209.85.128.67]:53618 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726707AbfF1JgE (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 28 Jun 2019 05:36:04 -0400
Received: by mail-wm1-f67.google.com with SMTP id x15so8414954wmj.3
        for <linux-crypto@vger.kernel.org>; Fri, 28 Jun 2019 02:36:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=rVlh1Yczl6sEDbe95/BJ5uyaoNfIyJkGyJuhu4iyLn8=;
        b=LEoOcOlV3MBIF5uJSvChY6dqUdWsQ2mTxr/mCy7kEUfroHNmwHpI8Z+TXC3QqNCFtI
         ZnUoqIOanuaJVV95EZAMi+obJzNe838yU5c9wF+dVmzJq6c1y9QZA+/Mz3DBydxf68zN
         k16Ch/qNAoLxjQkWrGP+IoKWEMrN6sfcLa5zbfobGm30VF3L8pin+y6YXqb7GQSVKvG6
         +2YeacTP6P/OEk7u44SDrCfo815IB5RLVgujd+eHsx1E19aG03sECCpe962skvDq7AS9
         2Rpxdc/Eg8mK5kKTvhZU736uCytrZb7XR/9QgXzSwOkmKbdETL/8K8ZwhktC1FsLv1OC
         rPIA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=rVlh1Yczl6sEDbe95/BJ5uyaoNfIyJkGyJuhu4iyLn8=;
        b=JTPkgYc4Er+3O60LRLzBfPmOBKHZs/yrX6IPg0QyIIq/s2fABePQU5pejaSdIMAtPw
         scP6/owj5/idnCDYXjKEC29dzPMMf2HGEPUR+JeNsEvKo5bpjPpIAV3GKNiAbwcmaC9F
         8YS9VQfZZiYsYYofU5awyBh11XMKNibNgqFxFo9rkgyokPVpvYCMXPGWhy55aSnp+tHG
         dHQY6C2hnX2mpKYg/6dX8u12BuE2osbuYZCgi4qlgoH4EVsCE8e0X4Jdc13Y8bQ1E2HL
         nVFgH/4ZakXO5uMrFSrkSFxJFkkdcT82zIQN+aIZTkbrNhUQJJ44EJY8gDTSQTJQxFgY
         F0tA==
X-Gm-Message-State: APjAAAVY0gLLw2t46Ob+JLR2E7B5EPgPzsG2rjlSDRWhE+w+ZNF2bbuj
        7cZ6av846wm8CHlycUrYmYeUpvQgK0nhcQ==
X-Google-Smtp-Source: APXvYqzUSXa60a8oS/eIVEYhvswzhdPZVaq3oRxyGNqJUuOf7b9uyj+JKrBKsvLI6rbr84Wkg1xJ3w==
X-Received: by 2002:a7b:ce8a:: with SMTP id q10mr6140646wmj.109.1561714562029;
        Fri, 28 Jun 2019 02:36:02 -0700 (PDT)
Received: from localhost.localdomain (laubervilliers-657-1-83-120.w92-154.abo.wanadoo.fr. [92.154.90.120])
        by smtp.gmail.com with ESMTPSA id m24sm1709910wmi.39.2019.06.28.02.36.01
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Fri, 28 Jun 2019 02:36:01 -0700 (PDT)
From:   Ard Biesheuvel <ard.biesheuvel@linaro.org>
To:     linux-crypto@vger.kernel.org
Cc:     herbert@gondor.apana.org.au, ebiggers@kernel.org,
        horia.geanta@nxp.com, Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: [PATCH v3 22/30] crypto: sun4i/des - switch to new verification routines
Date:   Fri, 28 Jun 2019 11:35:21 +0200
Message-Id: <20190628093529.12281-23-ard.biesheuvel@linaro.org>
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
 drivers/crypto/sunxi-ss/sun4i-ss-cipher.c | 26 +++++---------------
 drivers/crypto/sunxi-ss/sun4i-ss.h        |  2 +-
 2 files changed, 7 insertions(+), 21 deletions(-)

diff --git a/drivers/crypto/sunxi-ss/sun4i-ss-cipher.c b/drivers/crypto/sunxi-ss/sun4i-ss-cipher.c
index b060a0810934..a1942850913e 100644
--- a/drivers/crypto/sunxi-ss/sun4i-ss-cipher.c
+++ b/drivers/crypto/sunxi-ss/sun4i-ss-cipher.c
@@ -533,25 +533,11 @@ int sun4i_ss_des_setkey(struct crypto_skcipher *tfm, const u8 *key,
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
+	err = crypto_des_verify_key(crypto_skcipher_tfm(tfm), key);
+	if (err)
+		return err;
 
 	op->keylen = keylen;
 	memcpy(op->key, key, keylen);
@@ -569,8 +555,8 @@ int sun4i_ss_des3_setkey(struct crypto_skcipher *tfm, const u8 *key,
 	struct sun4i_tfm_ctx *op = crypto_skcipher_ctx(tfm);
 	int err;
 
-	err = des3_verify_key(tfm, key);
-	if (unlikely(err))
+	err = crypto_des3_ede_verify_key(crypto_skcipher_tfm(tfm), key);
+	if (err)
 		return err;
 
 	op->keylen = keylen;
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


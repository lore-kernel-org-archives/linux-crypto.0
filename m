Return-Path: <SRS0=Fqdl=U3=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 14B45C4321A
	for <linux-crypto@archiver.kernel.org>; Fri, 28 Jun 2019 09:35:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E0C9A20665
	for <linux-crypto@archiver.kernel.org>; Fri, 28 Jun 2019 09:35:58 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="zsRlaaMn"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726708AbfF1Jf6 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 28 Jun 2019 05:35:58 -0400
Received: from mail-wm1-f65.google.com ([209.85.128.65]:34551 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726702AbfF1Jf6 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 28 Jun 2019 05:35:58 -0400
Received: by mail-wm1-f65.google.com with SMTP id w9so8925610wmd.1
        for <linux-crypto@vger.kernel.org>; Fri, 28 Jun 2019 02:35:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=4e2vCsDLC/D+HtFHHDcivLxV8v5dwxrs/R/yXpuJqQM=;
        b=zsRlaaMn8QpdkCWBEuPLhk91f/IG1UyceM1ZPzL8dPCR81LoV/UJ3YAm8vvgVlk/2g
         rppWPjoq1L2lXsvvU9rENpkvFap4FryBD2E1R0MyPgFIe+hFXu4R3zQ1b0LIQI/9Xw/E
         8Gww3qh3f1v0KcHL+aR5epYfBuAO6hZd8ixwvvXMkcL/tgW9Ivk7HSs/PD2Cu8vQyWBA
         VSS2/Otkg7TXrOkMbRznuUxeMz9d9RazzpMSBuCIv0WBRGHsXXyU0dJzqO6MaxpVUGlv
         LgmYMun6Vt3XwhLXBqycdNw7JCnuuPkGMIV3ERbWn1Ej3L43H8Gd7lc9o7DfyiCThWj+
         pq2w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=4e2vCsDLC/D+HtFHHDcivLxV8v5dwxrs/R/yXpuJqQM=;
        b=hl3VPMYmpEkiFgcVjR9dKjRZfgKnvebcTjaEERS10El1mRGzkm1pJEz8ELC9Me67DW
         qJId/hkPHNYUvTX/ut9lbp3e3S35PEzwOPf2+ZslD58/+2rRGObfQUuT7QmvPPXFgtXJ
         pNPQfybXAyw9dxkdZwbN0gxnRanJEDMWis6UGZDfyrGcByLfmUL3ig1R3TV//XgNmaBe
         ndebzFYf0HfHBsetom+/Kbe3as8LjfEguR+W+FE0kmWi1E1aYCXFsLCT6NSeFz26pr7S
         kTH42lpJSykEM5d1NuaDLLs0biWQAPNoSmTRUR8Ri8TO2xhVB0FSSibkKH1JK1pLdi2F
         lvXA==
X-Gm-Message-State: APjAAAUvnoLYzwGOfgDtjFqibtZE/2oNYW0+ZxE84x4BCU1RQi4V7Aic
        1gd9EEfEWIgwnrZBixEtEAHueuifHqdUrQ==
X-Google-Smtp-Source: APXvYqzcenq5TYmGLM1n0LhfacRzRccuX8DXc2IYr1YU5I6KpibTnWvG3+tRpMdT0WZJGoSDq2gExw==
X-Received: by 2002:a1c:c706:: with SMTP id x6mr6466496wmf.162.1561714555772;
        Fri, 28 Jun 2019 02:35:55 -0700 (PDT)
Received: from localhost.localdomain (laubervilliers-657-1-83-120.w92-154.abo.wanadoo.fr. [92.154.90.120])
        by smtp.gmail.com with ESMTPSA id m24sm1709910wmi.39.2019.06.28.02.35.54
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Fri, 28 Jun 2019 02:35:55 -0700 (PDT)
From:   Ard Biesheuvel <ard.biesheuvel@linaro.org>
To:     linux-crypto@vger.kernel.org
Cc:     herbert@gondor.apana.org.au, ebiggers@kernel.org,
        horia.geanta@nxp.com, Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: [PATCH v3 16/30] crypto: n2/des - switch to new verification routines
Date:   Fri, 28 Jun 2019 11:35:15 +0200
Message-Id: <20190628093529.12281-17-ard.biesheuvel@linaro.org>
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
 drivers/crypto/n2_core.c | 26 ++++++--------------
 1 file changed, 7 insertions(+), 19 deletions(-)

diff --git a/drivers/crypto/n2_core.c b/drivers/crypto/n2_core.c
index 0d5d3d8eb680..de48512d054c 100644
--- a/drivers/crypto/n2_core.c
+++ b/drivers/crypto/n2_core.c
@@ -16,7 +16,7 @@
 #include <crypto/md5.h>
 #include <crypto/sha.h>
 #include <crypto/aes.h>
-#include <crypto/des.h>
+#include <crypto/internal/des.h>
 #include <linux/mutex.h>
 #include <linux/delay.h>
 #include <linux/sched.h>
@@ -759,21 +759,13 @@ static int n2_des_setkey(struct crypto_ablkcipher *cipher, const u8 *key,
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
@@ -786,15 +778,11 @@ static int n2_3des_setkey(struct crypto_ablkcipher *cipher, const u8 *key,
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
2.20.1


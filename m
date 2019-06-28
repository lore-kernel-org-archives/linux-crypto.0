Return-Path: <SRS0=Fqdl=U3=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0042BC4321A
	for <linux-crypto@archiver.kernel.org>; Fri, 28 Jun 2019 09:35:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id CC2EE20665
	for <linux-crypto@archiver.kernel.org>; Fri, 28 Jun 2019 09:35:55 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="LtkkTQna"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726694AbfF1Jfz (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 28 Jun 2019 05:35:55 -0400
Received: from mail-wm1-f67.google.com ([209.85.128.67]:53597 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726681AbfF1Jfz (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 28 Jun 2019 05:35:55 -0400
Received: by mail-wm1-f67.google.com with SMTP id x15so8414456wmj.3
        for <linux-crypto@vger.kernel.org>; Fri, 28 Jun 2019 02:35:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=opCK7nFY8V0KaYYnEjmOqVTHZQ6Vla/hvfg5QkTQ77U=;
        b=LtkkTQnaPEbq+VBhZF4Z1SF9q9wCnTx4FXLXDJSoONW1vptaqni7edW2bdaX357Mj8
         0gcdu/dSS2zxDoUGOAN106eu13nxmZDqKaYpKXB6jsS6HUXTWOrSykQFZY/JygCkTCY5
         E/eYwA/rqme1VJdNDHYoC+xFpFN+TygtO1+lz13zfTmo1GJZ1tNx0hTF/omFKczFDdga
         1JlFS4Wk4H4gUGJQEbVd7uPzB26V4grAW/zUCa1adfaRJRjk9h821yCsjuBPmlkjGwzs
         9Eu7ztxRu17fY1FU3pIuzFSivl80870HGlrtd2XdzVAvOANLlZYXRCj5BvLetq6HlnZ1
         DpOQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=opCK7nFY8V0KaYYnEjmOqVTHZQ6Vla/hvfg5QkTQ77U=;
        b=XzDGPA3Uvp8LR+1d1YmdtxCNnlCfH0ugjo22VR7zIF3jab6eipmENL5K3DOTNfQgXY
         pc/F7IAwIjKvxYw09fItBrFYfFyFdLtF15d++aBklrzzwDjoelh5KHnIldtewNL/y5uQ
         LTK8k+C5Lf/9ELITepHEiOYE8sqPZ/FlkCd1+TyP9ypFtNMECfYNlF3nuLEEAZ9ssnOh
         qoUvBLsLGqS/WKb0XNmtqNSnC7as1IHxgc6mpaW/ZevoIFXn5f67wSM93WyP0eIKD2C7
         QhKZOTXjTAa6xyd6h5i85OvhRbYz0yUVTR6QRHA1IX/tmiWbFVN3+eU+pUOK5NxXHsww
         oP+w==
X-Gm-Message-State: APjAAAWO2xWGY6dXEvHhiBDxFqS/0hTpgRcLdxKzFqOsgQwW4PMZLpu9
        DtD0sA9i4fE8WGgT8iPIaRnN7hRMuh3Z+g==
X-Google-Smtp-Source: APXvYqwfM1XbsD+b1A8QwXYV3C/AknMVKhWZCTHBLtwre1rEBnWkwzeWR0gXO74XoaO0rC5hUuWyVA==
X-Received: by 2002:a1c:4b1a:: with SMTP id y26mr6561464wma.105.1561714552496;
        Fri, 28 Jun 2019 02:35:52 -0700 (PDT)
Received: from localhost.localdomain (laubervilliers-657-1-83-120.w92-154.abo.wanadoo.fr. [92.154.90.120])
        by smtp.gmail.com with ESMTPSA id m24sm1709910wmi.39.2019.06.28.02.35.51
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Fri, 28 Jun 2019 02:35:51 -0700 (PDT)
From:   Ard Biesheuvel <ard.biesheuvel@linaro.org>
To:     linux-crypto@vger.kernel.org
Cc:     herbert@gondor.apana.org.au, ebiggers@kernel.org,
        horia.geanta@nxp.com, Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: [PATCH v3 13/30] crypto: safexcel/des - switch to new verification routines
Date:   Fri, 28 Jun 2019 11:35:12 +0200
Message-Id: <20190628093529.12281-14-ard.biesheuvel@linaro.org>
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
 drivers/crypto/inside-secure/safexcel_cipher.c | 18 +++++-------------
 1 file changed, 5 insertions(+), 13 deletions(-)

diff --git a/drivers/crypto/inside-secure/safexcel_cipher.c b/drivers/crypto/inside-secure/safexcel_cipher.c
index 8cdbdbe35681..7593b99c948c 100644
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
+	if (ret)
+		return ret;
 
 	/* if context exits and key changed, need to invalidate it */
 	if (ctx->base.ctxr_dma)
@@ -1074,8 +1066,8 @@ static int safexcel_des3_ede_setkey(struct crypto_skcipher *ctfm,
 	struct safexcel_cipher_ctx *ctx = crypto_skcipher_ctx(ctfm);
 	int err;
 
-	err = des3_verify_key(ctfm, key);
-	if (unlikely(err))
+	err = crypto_des3_ede_verify_key(crypto_skcipher_tfm(ctfm), key);
+	if (err)
 		return err;
 
 	/* if context exits and key changed, need to invalidate it */
-- 
2.20.1


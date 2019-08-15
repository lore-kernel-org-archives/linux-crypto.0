Return-Path: <SRS0=pRBs=WL=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0443BC31E40
	for <linux-crypto@archiver.kernel.org>; Thu, 15 Aug 2019 09:01:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id CF4B4218A6
	for <linux-crypto@archiver.kernel.org>; Thu, 15 Aug 2019 09:01:50 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="xdnyBaXv"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730797AbfHOJBu (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 15 Aug 2019 05:01:50 -0400
Received: from mail-wm1-f65.google.com ([209.85.128.65]:55952 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726120AbfHOJBu (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 15 Aug 2019 05:01:50 -0400
Received: by mail-wm1-f65.google.com with SMTP id f72so673374wmf.5
        for <linux-crypto@vger.kernel.org>; Thu, 15 Aug 2019 02:01:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=TcK6DnEUHoFqNwmgqurEfwn1kW0ngDG/2DCrPdXKlHo=;
        b=xdnyBaXvZFRUSkPBqMMhcgroGSy7l+VQT5/Nb0ww1JMeJAwUJ11FEwSGvxqhb3soD7
         3eBfF/vm3S90Fj3iKvX1vMgOJVvwpuW91b4dAzm4YXNPO0LVrl1ncan5KXfKL2GxV+A/
         SVIjCWdfwXPqd6j10hXAyZ3f2Sz4v1PBzVCbmDb7waQZq9fvQ/V3GwYgfhDECZwK42v/
         SCujl0P7Fly70pjg5kUNdyGODAiQnFcJRzlDYPhDIrc4CmZ4AQCqrvSTjSxyoGXOrvAw
         jjMDpVt0v8iZaQcheHHECw231+oVvjY+YWi6BWPUAvZRITpgOjZ953IWuvnms1OihXek
         iv9A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=TcK6DnEUHoFqNwmgqurEfwn1kW0ngDG/2DCrPdXKlHo=;
        b=R30ejyR0OgS9maADevfBnxdMDJN2K88ItDJp+O1kNH/X2CEKPuDHnLjJKEps64WSQB
         kkGa/cueGCuGn+S+xV8TdcJPEOey+eIwSqfwby2/t7+nsVlZxB0i0Cr0ScU4DOIcHPc5
         9VtnfQv6kVHU8VitiU4DH/Ph1ACqFJMzFMhW6ktCxggSZ31iBUhgSMaaGTMF75Lt3ofa
         6Na9DT5VbgkU0EIgOWDWhbgKe5Ou/vI70NMGHDb+bupGMhkEqOyRm/vlmPrV4rZwiD+4
         mgyd7DGoHDkFLyhLiriv2MMDyg2DWw+pp2xquhPQPM6J5vvcyng9zGrgyqmNYOKNDOiq
         AR0A==
X-Gm-Message-State: APjAAAVWYF5Sz6BUCP56gpg/7RQLWNxB/sIqGqYtVzqe9vWOkCz02w4T
        kflJzzRdZvfeYcdLD6JKemQs0Gx1isjW4Zq8
X-Google-Smtp-Source: APXvYqwVaELpImb8RJmJaHI47n237AsmyRQsb6DnJsTPglJ/LY9AXOfbgZCoRiGZKRBkSmYRo9UYYQ==
X-Received: by 2002:a05:600c:2056:: with SMTP id p22mr1550852wmg.159.1565859707282;
        Thu, 15 Aug 2019 02:01:47 -0700 (PDT)
Received: from localhost.localdomain ([2a02:587:a407:da00:f1b5:e68c:5f7f:79e7])
        by smtp.gmail.com with ESMTPSA id x20sm3857533wrg.10.2019.08.15.02.01.46
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 15 Aug 2019 02:01:46 -0700 (PDT)
From:   Ard Biesheuvel <ard.biesheuvel@linaro.org>
To:     linux-crypto@vger.kernel.org
Cc:     herbert@gondor.apana.org.au,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: [PATCH v5 13/30] crypto: safexcel/des - switch to new verification routines
Date:   Thu, 15 Aug 2019 12:00:55 +0300
Message-Id: <20190815090112.9377-14-ard.biesheuvel@linaro.org>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190815090112.9377-1-ard.biesheuvel@linaro.org>
References: <20190815090112.9377-1-ard.biesheuvel@linaro.org>
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
---
 drivers/crypto/inside-secure/safexcel_cipher.c | 24 ++++++--------------
 1 file changed, 7 insertions(+), 17 deletions(-)

diff --git a/drivers/crypto/inside-secure/safexcel_cipher.c b/drivers/crypto/inside-secure/safexcel_cipher.c
index 5682fe8b606e..16c4d5460334 100644
--- a/drivers/crypto/inside-secure/safexcel_cipher.c
+++ b/drivers/crypto/inside-secure/safexcel_cipher.c
@@ -220,7 +220,6 @@ static int safexcel_aead_setkey(struct crypto_aead *ctfm, const u8 *key,
 	struct safexcel_crypto_priv *priv = ctx->priv;
 	struct crypto_authenc_keys keys;
 	struct crypto_aes_ctx aes;
-	u32 flags;
 	int err = -EINVAL;
 
 	if (crypto_authenc_extractkeys(&keys, key, len) != 0)
@@ -241,12 +240,7 @@ static int safexcel_aead_setkey(struct crypto_aead *ctfm, const u8 *key,
 	/* Encryption key */
 	switch (ctx->alg) {
 	case SAFEXCEL_3DES:
-		if (keys.enckeylen != DES3_EDE_KEY_SIZE)
-			goto badkey;
-		flags = crypto_aead_get_flags(ctfm);
-		err = __des3_verify_key(&flags, keys.enckey);
-		crypto_aead_set_flags(ctfm, flags);
-
+		err = verify_aead_des3_key(ctfm, keys.enckey, keys.enckeylen);
 		if (unlikely(err))
 			goto badkey_expflags;
 		break;
@@ -1192,16 +1186,12 @@ static int safexcel_cbc_des_decrypt(struct skcipher_request *req)
 static int safexcel_des_setkey(struct crypto_skcipher *ctfm, const u8 *key,
 			       unsigned int len)
 {
-	struct crypto_tfm *tfm = crypto_skcipher_tfm(ctfm);
-	struct safexcel_cipher_ctx *ctx = crypto_tfm_ctx(tfm);
-	u32 tmp[DES_EXPKEY_WORDS];
+	struct safexcel_cipher_ctx *ctx = crypto_skcipher_ctx(ctfm);
 	int ret;
 
-	ret = des_ekey(tmp, key);
-	if (!ret && (tfm->crt_flags & CRYPTO_TFM_REQ_FORBID_WEAK_KEYS)) {
-		tfm->crt_flags |= CRYPTO_TFM_RES_WEAK_KEY;
-		return -EINVAL;
-	}
+	ret = verify_skcipher_des_key(ctfm, key);
+	if (ret)
+		return ret;
 
 	/* if context exits and key changed, need to invalidate it */
 	if (ctx->base.ctxr_dma)
@@ -1299,8 +1289,8 @@ static int safexcel_des3_ede_setkey(struct crypto_skcipher *ctfm,
 	struct safexcel_cipher_ctx *ctx = crypto_skcipher_ctx(ctfm);
 	int err;
 
-	err = des3_verify_key(ctfm, key);
-	if (unlikely(err))
+	err = verify_skcipher_des3_key(ctfm, key);
+	if (err)
 		return err;
 
 	/* if context exits and key changed, need to invalidate it */
-- 
2.17.1


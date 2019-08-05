Return-Path: <SRS0=2Ix1=WB=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D4398C433FF
	for <linux-crypto@archiver.kernel.org>; Mon,  5 Aug 2019 17:01:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A7C952054F
	for <linux-crypto@archiver.kernel.org>; Mon,  5 Aug 2019 17:01:50 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="hE16ffik"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728871AbfHERBu (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 5 Aug 2019 13:01:50 -0400
Received: from mail-wm1-f67.google.com ([209.85.128.67]:51817 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729780AbfHERBt (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 5 Aug 2019 13:01:49 -0400
Received: by mail-wm1-f67.google.com with SMTP id 207so75474062wma.1
        for <linux-crypto@vger.kernel.org>; Mon, 05 Aug 2019 10:01:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=ebKJGCN9vei2NZ41HobpihwjzZEEneemyNbb+2I2Vi4=;
        b=hE16ffikpFg5KluY4EIhjXP1l87Zw8OlUUUbZDkhnOyQeav0oqhK63QK8ewWaXCsHG
         41P4UCw1fNC5kYtkMuJf932qYoefI47AoA6jo1uoZDVleFuCjq1KD/aA/0ZmyayNev3s
         DS7HXI8GI4BWldcx04nZr0p78/fLsF1BBak3K83zpyAQX0H32vKxuOCwugbc8e6a5vaF
         SP6r2nwOEj1j+9uZ/JzsRrjtLSCTiIa6ispJS1K8VYf7KTIKz+7QGdNWQxX09/hWAMhd
         fAbovueVdmYMm8lshk2ES/LXaFBjKChNqeUnfaiHO4MLkCPwUaunBv1GV1R3OgR7sY7C
         F3Bw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=ebKJGCN9vei2NZ41HobpihwjzZEEneemyNbb+2I2Vi4=;
        b=CYcUUtzJzG/qzCpLONxrdYdoF5K7jqu66O5YFTMfVnAqtzkVlOFydbjdLiW178dJiW
         HqEChVNsrqO/UPtP4dHFzCP94UAHv9SEVJQe8cTzGc+Z2RYVKiyJgYVoajnbwTYKKF6n
         ZLlKo6M2EiZgFzCquG3lt6NoRl+PgnKQduT6fFDOwsyNPOEEpUWniwaYHo0pCfInD8bO
         8Jl7sKAA7bCCTAQzqTN9K127yfOsNCPj+5Rrbm9IyTvxIWrmCh+maicw56WgCc8x8DdW
         asC90GbDK8zdwxCNRyUiuu6vj5IviAVq9/PJYqnUXDQRQPwWoz6SyAz2QsE9wb7FIniS
         C03A==
X-Gm-Message-State: APjAAAUV1rNU86Yju+iwSX4H36ve+PuRDxfagalMiYAV2r3FZez9RYdF
        nsVBn1J7Z0ynhs6w1iMDZQkRSakP72ydYQ==
X-Google-Smtp-Source: APXvYqwr13nl5oOj5fffjZVnFR7G2VpPp+jUCPz+zM+pU/Ja1XTInk5q5A22dX0gnZX1PVAPDdJA5Q==
X-Received: by 2002:a1c:5f87:: with SMTP id t129mr20677270wmb.150.1565024508294;
        Mon, 05 Aug 2019 10:01:48 -0700 (PDT)
Received: from localhost.localdomain ([2a02:587:a407:da00:582f:8334:9cd9:7241])
        by smtp.gmail.com with ESMTPSA id j9sm95669383wrn.81.2019.08.05.10.01.45
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 05 Aug 2019 10:01:47 -0700 (PDT)
From:   Ard Biesheuvel <ard.biesheuvel@linaro.org>
To:     linux-crypto@vger.kernel.org
Cc:     herbert@gondor.apana.org.au, ebiggers@kernel.org,
        horia.geanta@nxp.com, Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: [PATCH v4 13/30] crypto: safexcel/des - switch to new verification routines
Date:   Mon,  5 Aug 2019 20:00:20 +0300
Message-Id: <20190805170037.31330-14-ard.biesheuvel@linaro.org>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190805170037.31330-1-ard.biesheuvel@linaro.org>
References: <20190805170037.31330-1-ard.biesheuvel@linaro.org>
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
---
 drivers/crypto/inside-secure/safexcel_cipher.c | 27 ++++++--------------
 1 file changed, 8 insertions(+), 19 deletions(-)

diff --git a/drivers/crypto/inside-secure/safexcel_cipher.c b/drivers/crypto/inside-secure/safexcel_cipher.c
index 477e0ec35f45..b49e7587ba07 100644
--- a/drivers/crypto/inside-secure/safexcel_cipher.c
+++ b/drivers/crypto/inside-secure/safexcel_cipher.c
@@ -219,7 +219,6 @@ static int safexcel_aead_setkey(struct crypto_aead *ctfm, const u8 *key,
 	struct safexcel_crypto_priv *priv = ctx->priv;
 	struct crypto_authenc_keys keys;
 	struct crypto_aes_ctx aes;
-	u32 flags;
 	int err = -EINVAL;
 
 	if (crypto_authenc_extractkeys(&keys, key, len) != 0)
@@ -238,12 +237,10 @@ static int safexcel_aead_setkey(struct crypto_aead *ctfm, const u8 *key,
 	/* Encryption key */
 	switch (ctx->alg) {
 	case SAFEXCEL_3DES:
-		if (keys.enckeylen != 24)
+		if (keys.enckeylen != DES3_EDE_KEY_SIZE)
 			goto badkey;
-		flags = crypto_aead_get_flags(ctfm);
-		err = __des3_verify_key(&flags, keys.enckey);
-		crypto_aead_set_flags(ctfm, flags);
-
+		err = crypto_des3_ede_verify_key(crypto_aead_tfm(ctfm),
+						 keys.enckey);
 		if (unlikely(err))
 			goto badkey_expflags;
 		break;
@@ -1191,19 +1188,11 @@ static int safexcel_des_setkey(struct crypto_skcipher *ctfm, const u8 *key,
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
@@ -1301,8 +1290,8 @@ static int safexcel_des3_ede_setkey(struct crypto_skcipher *ctfm,
 	struct safexcel_cipher_ctx *ctx = crypto_skcipher_ctx(ctfm);
 	int err;
 
-	err = des3_verify_key(ctfm, key);
-	if (unlikely(err))
+	err = crypto_des3_ede_verify_key(crypto_skcipher_tfm(ctfm), key);
+	if (err)
 		return err;
 
 	/* if context exits and key changed, need to invalidate it */
-- 
2.17.1


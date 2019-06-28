Return-Path: <SRS0=Fqdl=U3=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D1823C5B579
	for <linux-crypto@archiver.kernel.org>; Fri, 28 Jun 2019 09:36:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id AA0F52133F
	for <linux-crypto@archiver.kernel.org>; Fri, 28 Jun 2019 09:36:08 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="sAcWFWKu"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726750AbfF1JgH (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 28 Jun 2019 05:36:07 -0400
Received: from mail-wr1-f65.google.com ([209.85.221.65]:38542 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726596AbfF1JgH (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 28 Jun 2019 05:36:07 -0400
Received: by mail-wr1-f65.google.com with SMTP id d18so5547289wrs.5
        for <linux-crypto@vger.kernel.org>; Fri, 28 Jun 2019 02:36:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=mVr3GoJIY9k3V5AjmsEshtajgyAmfjEoLBpibvf8QC0=;
        b=sAcWFWKuJ7fXkTu+ReSdp0tphDtZM/xbQcgp7XxytaBrAIcivRRo/7vb2svQiAWKjC
         CEZZ2sB9OhDSbTvMu7nodVbcD3QcqwFLSc4tuX810t3+7dCHyaqiSpP0lOeaH2o+8spW
         /3/C9nTXaWWsjr40hx/f4CfQ9eM6zLke8QsO2fF/N6RugZe2g/RKgBRUtNY2s/ZAzP8m
         qzEusQI0dGDS36Zn0i/EXOD30GSDfHf4YV40Sj1053Xc66X+zP85G6TaTtncIIjD0zhp
         wvFb9CgWk0fpia22L+4/dSEqJsEqgsqta+XEuQhTDTqw53nlMMbht5REGgrmfi44D/RU
         XehA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=mVr3GoJIY9k3V5AjmsEshtajgyAmfjEoLBpibvf8QC0=;
        b=bCzTS6le9vQ5nXzJFlBvYWnxbGYjcvVgUsXbrCiPIM187S+aOu5P48msyty/vl7fTT
         LfJmq9fHbG0i3RIqXmDsevOVn3JrlWFRikex981SITSEDd+9Hh8mN9WlKkhrZvzagolJ
         /OGOppvEZU91F70BrIMqM6tioSIZWm6lszquhwAWzIb31GJzwy3Ow3Vn6M6ypdxCfNB5
         bL6Qi2ZOdG4zg0E7yufcMn6UeGDBzz/in/jNRfWolNvUBW3yGtAne9/UTy0c6pWwxDPj
         XADFMEuuTE5Es8zygwMYM+8hsr6v+k5D5lJPQ3TNfipNv2oZD3KPrhjvUzzb2zZr2/B7
         E+jw==
X-Gm-Message-State: APjAAAVpegwAnyCoCc/fgtaFZGBrsTfWN7OUrLk9gmPoylc7bFF3xJoS
        PmiZ25NNnk/m0C/ssg/azt8baXvUypMnHg==
X-Google-Smtp-Source: APXvYqw2BSd+ICrgNt7gFHP++SGNBxlI9Y2uP+5HIU/Sk5wbgda5RHubq7snLiR7EiuWlcsjM++ocQ==
X-Received: by 2002:adf:ea8b:: with SMTP id s11mr598774wrm.100.1561714565259;
        Fri, 28 Jun 2019 02:36:05 -0700 (PDT)
Received: from localhost.localdomain (laubervilliers-657-1-83-120.w92-154.abo.wanadoo.fr. [92.154.90.120])
        by smtp.gmail.com with ESMTPSA id m24sm1709910wmi.39.2019.06.28.02.36.04
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Fri, 28 Jun 2019 02:36:04 -0700 (PDT)
From:   Ard Biesheuvel <ard.biesheuvel@linaro.org>
To:     linux-crypto@vger.kernel.org
Cc:     herbert@gondor.apana.org.au, ebiggers@kernel.org,
        horia.geanta@nxp.com, Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: [PATCH v3 25/30] crypto: 3des - move verification out of exported routine
Date:   Fri, 28 Jun 2019 11:35:24 +0200
Message-Id: <20190628093529.12281-26-ard.biesheuvel@linaro.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190628093529.12281-1-ard.biesheuvel@linaro.org>
References: <20190628093529.12281-1-ard.biesheuvel@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

In preparation of moving the shared key expansion routine into the
DES library, move the verification done by __des3_ede_setkey() into
its callers.

Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
---
 arch/x86/crypto/des3_ede_glue.c |  4 ++++
 crypto/des_generic.c            | 10 +++++-----
 2 files changed, 9 insertions(+), 5 deletions(-)

diff --git a/arch/x86/crypto/des3_ede_glue.c b/arch/x86/crypto/des3_ede_glue.c
index 5c610d4ef9fc..0a7da05994df 100644
--- a/arch/x86/crypto/des3_ede_glue.c
+++ b/arch/x86/crypto/des3_ede_glue.c
@@ -358,6 +358,10 @@ static int des3_ede_x86_setkey(struct crypto_tfm *tfm, const u8 *key,
 	u32 i, j, tmp;
 	int err;
 
+	err = crypto_des3_ede_verify_key(tfm, key);
+	if (err)
+		return err;
+
 	/* Generate encryption context using generic implementation. */
 	err = __des3_ede_setkey(ctx->enc_expkey, &tfm->crt_flags, key, keylen);
 	if (err < 0)
diff --git a/crypto/des_generic.c b/crypto/des_generic.c
index c94a303da4dd..271cc689c0cc 100644
--- a/crypto/des_generic.c
+++ b/crypto/des_generic.c
@@ -851,10 +851,6 @@ int __des3_ede_setkey(u32 *expkey, u32 *flags, const u8 *key,
 {
 	int err;
 
-	err = __des3_verify_key(flags, key);
-	if (unlikely(err))
-		return err;
-
 	des_ekey(expkey, key); expkey += DES_EXPKEY_WORDS; key += DES_KEY_SIZE;
 	dkey(expkey, key); expkey += DES_EXPKEY_WORDS; key += DES_KEY_SIZE;
 	des_ekey(expkey, key);
@@ -867,8 +863,12 @@ static int des3_ede_setkey(struct crypto_tfm *tfm, const u8 *key,
 			   unsigned int keylen)
 {
 	struct des3_ede_ctx *dctx = crypto_tfm_ctx(tfm);
-	u32 *flags = &tfm->crt_flags;
 	u32 *expkey = dctx->expkey;
+	int err;
+
+	err = crypto_des3_ede_verify_key(crypto_skcipher_tfm(skcipher), key);
+	if (err)
+		return err;
 
 	return __des3_ede_setkey(expkey, flags, key, keylen);
 }
-- 
2.20.1


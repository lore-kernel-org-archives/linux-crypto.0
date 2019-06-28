Return-Path: <SRS0=Fqdl=U3=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9145AC5B57A
	for <linux-crypto@archiver.kernel.org>; Fri, 28 Jun 2019 09:36:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 69DA2208E3
	for <linux-crypto@archiver.kernel.org>; Fri, 28 Jun 2019 09:36:13 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="hkJMEkt+"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726596AbfF1JgM (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 28 Jun 2019 05:36:12 -0400
Received: from mail-wm1-f66.google.com ([209.85.128.66]:55736 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726774AbfF1JgM (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 28 Jun 2019 05:36:12 -0400
Received: by mail-wm1-f66.google.com with SMTP id a15so8407873wmj.5
        for <linux-crypto@vger.kernel.org>; Fri, 28 Jun 2019 02:36:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=HMxEFfI7tJ6A3Lxij+jWi/muPaKRgiRph4XGCcI4O/0=;
        b=hkJMEkt+H6i2GmbO0KSCljhk9WVAf2BXDctigWeQ1kzI9sUe9awEpQyg9L36u4NDYM
         MrNtMjMo/8jgjhiLzauGPpOFXGbtnEH4X6RAZtvCoHm57z88aOMc/JSic8oYds5TFSx9
         RgcSBof/gCpKR6G/+SQEp1SDAVGjIM7Zo2uvuFVGyq5Ui3xfAct9YlZUWOgo2CxzVXb6
         YHgVjS1hx4BJlCfjtvmnqvztz5Z5sgWHNOzg0RB0fNcSpoAGVShjLXVArkCVyR05BHnE
         1KJzpKItbZe9VrwZuI/8sYRAQ44hoTqQuYDTz+U3BEJZmfR6QSEHlr1L8D090O5meDk+
         59WA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=HMxEFfI7tJ6A3Lxij+jWi/muPaKRgiRph4XGCcI4O/0=;
        b=JpZp68CpvH25cmyqc1J8Dl/GKpaRtJ+FCNT3Dh7UmDEqqtY+kHTqRn+60YXPCgzsB5
         lAvW8571DjDsruy2rD3WqVEbQOJ6UExEFg0d2qdt6VuNI9JPPJojdJ90yS/HmJHOvMU7
         ZayPZafH1Y1JpGvgFlQad9TlOTSdRxL5xjku7737Of/mUPmvCdnVkmpolSkb8xDi94QM
         FI79n66s1CC8ddMU4hJEW+S2mAWKYEq2RqISmVG7S2GA2/W589T9xQapArDAgGb0zPsZ
         Ibm0bQPWPo8iiaDJaBoxKyotbzHToeIyXwEOSOgM8qSQTefxOgZ5ftyyqZRVhgEytFfM
         NM2w==
X-Gm-Message-State: APjAAAWC+eXKxUi3l0UkPfmTKGF65wCe1VNizRE579HFye84LMmLS2Wc
        jqsoBv/i2lyj0sxtGsB187214OEu0AWQOg==
X-Google-Smtp-Source: APXvYqysnT+pisP7+7Ui8QI31xggDvo2Djldvm32BLgbC22XhAA+bO9GpfjzcOpKJG/e4vVKgi6k2w==
X-Received: by 2002:a1c:f009:: with SMTP id a9mr6285584wmb.32.1561714569805;
        Fri, 28 Jun 2019 02:36:09 -0700 (PDT)
Received: from localhost.localdomain (laubervilliers-657-1-83-120.w92-154.abo.wanadoo.fr. [92.154.90.120])
        by smtp.gmail.com with ESMTPSA id m24sm1709910wmi.39.2019.06.28.02.36.08
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Fri, 28 Jun 2019 02:36:08 -0700 (PDT)
From:   Ard Biesheuvel <ard.biesheuvel@linaro.org>
To:     linux-crypto@vger.kernel.org
Cc:     herbert@gondor.apana.org.au, ebiggers@kernel.org,
        horia.geanta@nxp.com, Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: [PATCH v3 29/30] crypto: des - remove now unused __des3_ede_setkey()
Date:   Fri, 28 Jun 2019 11:35:28 +0200
Message-Id: <20190628093529.12281-30-ard.biesheuvel@linaro.org>
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
 crypto/des_generic.c | 13 -------------
 include/crypto/des.h |  3 ---
 2 files changed, 16 deletions(-)

diff --git a/crypto/des_generic.c b/crypto/des_generic.c
index 8669423886aa..201caf22b881 100644
--- a/crypto/des_generic.c
+++ b/crypto/des_generic.c
@@ -56,19 +56,6 @@ static void crypto_des_decrypt(struct crypto_tfm *tfm, u8 *dst, const u8 *src)
 	des_decrypt(dctx, dst, src);
 }
 
-int __des3_ede_setkey(u32 *expkey, u32 *flags, const u8 *key,
-		      unsigned int keylen)
-{
-	int err;
-
-	des_ekey(expkey, key); expkey += DES_EXPKEY_WORDS; key += DES_KEY_SIZE;
-	dkey(expkey, key); expkey += DES_EXPKEY_WORDS; key += DES_KEY_SIZE;
-	des_ekey(expkey, key);
-
-	return 0;
-}
-EXPORT_SYMBOL_GPL(__des3_ede_setkey);
-
 static int des3_ede_setkey(struct crypto_tfm *tfm, const u8 *key,
 			   unsigned int keylen)
 {
diff --git a/include/crypto/des.h b/include/crypto/des.h
index 2c864a4e6707..7812b4331ae4 100644
--- a/include/crypto/des.h
+++ b/include/crypto/des.h
@@ -54,7 +54,4 @@ int des_expand_key(struct des_ctx *ctx, const u8 *key, unsigned int keylen);
 int des3_ede_expand_key(struct des3_ede_ctx *ctx, const u8 *key,
 			unsigned int keylen);
 
-extern int __des3_ede_setkey(u32 *expkey, u32 *flags, const u8 *key,
-			     unsigned int keylen);
-
 #endif /* __CRYPTO_DES_H */
-- 
2.20.1


Return-Path: <SRS0=Fqdl=U3=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8AD46C4321A
	for <linux-crypto@archiver.kernel.org>; Fri, 28 Jun 2019 09:36:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5E8442133F
	for <linux-crypto@archiver.kernel.org>; Fri, 28 Jun 2019 09:36:04 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="T2hnnsKi"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726711AbfF1Jf7 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 28 Jun 2019 05:35:59 -0400
Received: from mail-wm1-f68.google.com ([209.85.128.68]:33740 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726706AbfF1Jf7 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 28 Jun 2019 05:35:59 -0400
Received: by mail-wm1-f68.google.com with SMTP id h19so8944790wme.0
        for <linux-crypto@vger.kernel.org>; Fri, 28 Jun 2019 02:35:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=YLuTTtiKRyCVvfmrDVvWYJE+BPuMYbTux/RG3Fg6dG4=;
        b=T2hnnsKiFBhVqlqjJQAykzzaY6ENcJmb8BWc4K5qKsV0iFMNrpftCeQfJbkAgSHZLn
         JUX6rEBxIGIq1+Z3Hnu8DxJRX8xg5t93770g38V/2BqqgtAOi7vG5lgyje8BdFt3MPsZ
         wFuQxIxzHzf2S6c6KAWn2HkQjRhSYCBEEV5jhh2AQyFYwSjquNRHh5zIRxpqGLvzzUqB
         luF5t8C/4H/4W/4zzOOmjXz2lKtqIVPuKSvlpm0hND/L1/LODnsw1Hga6uidPfkhb2Z+
         DgoFkHfDVugoVXYpUifYUv44RHVzSIYm/E/BO2d0zsS+m7c3HQC+JnVlfsCh0tpv5hye
         H1ag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=YLuTTtiKRyCVvfmrDVvWYJE+BPuMYbTux/RG3Fg6dG4=;
        b=P4QVmyS2jQimCuYCyvbx4xy/CBbXaBA43/CNw0fxzm8vZBuyEFecIbyZEo+9H5nJjS
         qAcSvEP+G04ck5VFSpIIzvJodLQbR4Ik2DIP/SyyMmNx4EBTxZNY4cP08cxiBbE0Q7/Z
         WSknt/M0WmFAjM2RX4oJwCiA5jDMGW/dnLWj+hxIHEoGspMAEd7Fe6gK2L1FVxbvvdNU
         MQr2/zTULMl3Aypzee2mC/joDsQKho2BtaUYP2ddbj0fqjdlYkaid0ZxFpF6ITP+FHjD
         M2ZvamOeC8FUM+p4eRf50GEpOMvkMVM//9Y4jOWmV2Lz+wyA8wxY3l1PDCCorHWbqRUu
         fqGA==
X-Gm-Message-State: APjAAAWomsYVkKnaxLmaPEdElAJF/pJuEWkggy8MFIpsEJxRa/0YVA4N
        HqTErUFoBWAbOmP6uTR6cPCkL2fIddXV0w==
X-Google-Smtp-Source: APXvYqyWpO8g/2sh5Xr7419Mkw3BYShpCcZqO1A7m4eH3H2vvQ03HJpuXoS3uwH1H3LGH6w7qmkB+A==
X-Received: by 2002:a1c:f61a:: with SMTP id w26mr7002457wmc.75.1561714556674;
        Fri, 28 Jun 2019 02:35:56 -0700 (PDT)
Received: from localhost.localdomain (laubervilliers-657-1-83-120.w92-154.abo.wanadoo.fr. [92.154.90.120])
        by smtp.gmail.com with ESMTPSA id m24sm1709910wmi.39.2019.06.28.02.35.55
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Fri, 28 Jun 2019 02:35:56 -0700 (PDT)
From:   Ard Biesheuvel <ard.biesheuvel@linaro.org>
To:     linux-crypto@vger.kernel.org
Cc:     herbert@gondor.apana.org.au, ebiggers@kernel.org,
        horia.geanta@nxp.com, Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: [PATCH v3 17/30] crypto: omap/des - switch to new verification routines
Date:   Fri, 28 Jun 2019 11:35:16 +0200
Message-Id: <20190628093529.12281-18-ard.biesheuvel@linaro.org>
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
 drivers/crypto/omap-des.c | 25 ++++++--------------
 1 file changed, 7 insertions(+), 18 deletions(-)

diff --git a/drivers/crypto/omap-des.c b/drivers/crypto/omap-des.c
index 3d82d18ff810..ebbe7b532aa5 100644
--- a/drivers/crypto/omap-des.c
+++ b/drivers/crypto/omap-des.c
@@ -37,7 +37,7 @@
 #include <linux/crypto.h>
 #include <linux/interrupt.h>
 #include <crypto/scatterwalk.h>
-#include <crypto/des.h>
+#include <crypto/internal/des.h>
 #include <crypto/algapi.h>
 #include <crypto/engine.h>
 
@@ -654,20 +654,13 @@ static int omap_des_setkey(struct crypto_ablkcipher *cipher, const u8 *key,
 			   unsigned int keylen)
 {
 	struct omap_des_ctx *ctx = crypto_ablkcipher_ctx(cipher);
-	struct crypto_tfm *tfm = crypto_ablkcipher_tfm(cipher);
+	int err;
 
 	pr_debug("enter, keylen: %d\n", keylen);
 
-	/* Do we need to test against weak key? */
-	if (tfm->crt_flags & CRYPTO_TFM_REQ_FORBID_WEAK_KEYS) {
-		u32 tmp[DES_EXPKEY_WORDS];
-		int ret = des_ekey(tmp, key);
-
-		if (!ret) {
-			tfm->crt_flags |= CRYPTO_TFM_RES_WEAK_KEY;
-			return -EINVAL;
-		}
-	}
+	err = crypto_des_verify_key(crypto_ablkcipher_tfm(cipher), key);
+	if (err)
+		return err;
 
 	memcpy(ctx->key, key, keylen);
 	ctx->keylen = keylen;
@@ -679,17 +672,13 @@ static int omap_des3_setkey(struct crypto_ablkcipher *cipher, const u8 *key,
 			   unsigned int keylen)
 {
 	struct omap_des_ctx *ctx = crypto_ablkcipher_ctx(cipher);
-	u32 flags;
 	int err;
 
 	pr_debug("enter, keylen: %d\n", keylen);
 
-	flags = crypto_ablkcipher_get_flags(cipher);
-	err = __des3_verify_key(&flags, key);
-	if (unlikely(err)) {
-		crypto_ablkcipher_set_flags(cipher, flags);
+	err = crypto_des3_ede_verify_key(crypto_ablkcipher_tfm(cipher), key);
+	if (err)
 		return err;
-	}
 
 	memcpy(ctx->key, key, keylen);
 	ctx->keylen = keylen;
-- 
2.20.1


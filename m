Return-Path: <SRS0=CUNG=U2=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0AE3BC48BD9
	for <linux-crypto@archiver.kernel.org>; Thu, 27 Jun 2019 12:03:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D2FB721670
	for <linux-crypto@archiver.kernel.org>; Thu, 27 Jun 2019 12:03:56 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="z23P99xO"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726874AbfF0MDz (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 27 Jun 2019 08:03:55 -0400
Received: from mail-wr1-f66.google.com ([209.85.221.66]:42832 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726876AbfF0MDy (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 27 Jun 2019 08:03:54 -0400
Received: by mail-wr1-f66.google.com with SMTP id x17so2242216wrl.9
        for <linux-crypto@vger.kernel.org>; Thu, 27 Jun 2019 05:03:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=3jS478ttYwvYZg/uCBgId5hMyypjMuzMWsJAXYXWARw=;
        b=z23P99xOEKsqgIO0KRsNTbwiDdIHkrmLdA2iLWUL0VM5xiw1ilEG8X4BN2mPi9DOZ4
         QpRyupsaBG3plICWP+HXIm9CN5mqfKrZ9CHxs/+c0DfIfLyKnlmMmFvbHheDgkq8or73
         8Ea4JxNQhhQsJSTer7k/6A3yZgDOsP93L84zKFU7oi1VjMViCEyZONQ/mkeHUohVQBrv
         SVmgHYjgnUfBrdVFgUP8sB+uODvbK2Wp5Z8vCIjxbZAqIdRy7U1TpmT+As8Lx7c/V6nK
         lSYoKs33j7MApU0zi+O61y8BGuCbpFq/bnesF3P2kVsFUftt3cR5VsRxThbkqMwYl605
         Ny+g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=3jS478ttYwvYZg/uCBgId5hMyypjMuzMWsJAXYXWARw=;
        b=ufVX64meYjIjpViSNoUI5g9wW2NJUqESyl/tql5vESM3tnxGLTl7q+VrW0tUfVHjlo
         HMrYJD2g6Y8FRGOiWTMe/7pwJO02Hv8/emvZhJI6KECI9KxcfbLt6emtQzNL+Mii5aHW
         65A/w6QTm7IxDv50WH/tw2ScAVDZz6e6j6i4p5DAgYrSumO4ZHIC5oJhHnS0SMazHMGz
         0zjtJPst73XBle3qoXHgWYy8W1WcXQ8b0/WF1nwXwQ0VCiP8D7CiU+pAAtvY9j3HYCKc
         DHDSuM63bC0evNEcs2WBNdjlqhdDdoScLpVM+6AKAV6Ggndmg2ncgYjaK+1FM3Xew/Gj
         APBQ==
X-Gm-Message-State: APjAAAUzfc3jEjjtt9xQkfPv3efsTMNC+n1xrtYBsf7wdxHzaLiAlETl
        3c6ijYNbMX8pQDM7Um4lCx/0l/6VET8qKQ==
X-Google-Smtp-Source: APXvYqx05HU2ybnijeDYT+EwtvsCu0/RTdUvfN7IT3GDgedf0faamqRupbJpaa2Kg1/dO8xMSAv/Eg==
X-Received: by 2002:adf:ea88:: with SMTP id s8mr2919766wrm.68.1561637032419;
        Thu, 27 Jun 2019 05:03:52 -0700 (PDT)
Received: from localhost.localdomain (laubervilliers-657-1-83-120.w92-154.abo.wanadoo.fr. [92.154.90.120])
        by smtp.gmail.com with ESMTPSA id z126sm7732431wmb.32.2019.06.27.05.03.51
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Thu, 27 Jun 2019 05:03:51 -0700 (PDT)
From:   Ard Biesheuvel <ard.biesheuvel@linaro.org>
To:     linux-crypto@vger.kernel.org
Cc:     herbert@gondor.apana.org.au, ebiggers@kernel.org,
        horia.geanta@nxp.com, Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: [PATCH v2 24/30] crypto: ux500/des - switch to new verification routines
Date:   Thu, 27 Jun 2019 14:03:08 +0200
Message-Id: <20190627120314.7197-25-ard.biesheuvel@linaro.org>
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
 drivers/crypto/ux500/cryp/cryp_core.c | 31 +++++---------------
 1 file changed, 7 insertions(+), 24 deletions(-)

diff --git a/drivers/crypto/ux500/cryp/cryp_core.c b/drivers/crypto/ux500/cryp/cryp_core.c
index 7a93cba0877f..447bddd72fe7 100644
--- a/drivers/crypto/ux500/cryp/cryp_core.c
+++ b/drivers/crypto/ux500/cryp/cryp_core.c
@@ -29,7 +29,7 @@
 #include <crypto/aes.h>
 #include <crypto/algapi.h>
 #include <crypto/ctr.h>
-#include <crypto/des.h>
+#include <crypto/internal/des.h>
 #include <crypto/scatterwalk.h>
 
 #include <linux/platform_data/crypto-ux500.h>
@@ -987,26 +987,13 @@ static int des_ablkcipher_setkey(struct crypto_ablkcipher *cipher,
 				 const u8 *key, unsigned int keylen)
 {
 	struct cryp_ctx *ctx = crypto_ablkcipher_ctx(cipher);
-	u32 *flags = &cipher->base.crt_flags;
-	u32 tmp[DES_EXPKEY_WORDS];
-	int ret;
+	int err;
 
 	pr_debug(DEV_DBG_NAME " [%s]", __func__);
-	if (keylen != DES_KEY_SIZE) {
-		*flags |= CRYPTO_TFM_RES_BAD_KEY_LEN;
-		pr_debug(DEV_DBG_NAME " [%s]: CRYPTO_TFM_RES_BAD_KEY_LEN",
-				__func__);
-		return -EINVAL;
-	}
 
-	ret = des_ekey(tmp, key);
-	if (unlikely(ret == 0) &&
-	    (*flags & CRYPTO_TFM_REQ_FORBID_WEAK_KEYS)) {
-		*flags |= CRYPTO_TFM_RES_WEAK_KEY;
-		pr_debug(DEV_DBG_NAME " [%s]: CRYPTO_TFM_RES_WEAK_KEY",
-			 __func__);
-		return -EINVAL;
-	}
+	err = crypto_des_verify_key(crypto_ablkcipher_tfm(cipher), key);
+	if (unlikely(err))
+		return err;
 
 	memcpy(ctx->key, key, keylen);
 	ctx->keylen = keylen;
@@ -1019,17 +1006,13 @@ static int des3_ablkcipher_setkey(struct crypto_ablkcipher *cipher,
 				  const u8 *key, unsigned int keylen)
 {
 	struct cryp_ctx *ctx = crypto_ablkcipher_ctx(cipher);
-	u32 flags;
 	int err;
 
 	pr_debug(DEV_DBG_NAME " [%s]", __func__);
 
-	flags = crypto_ablkcipher_get_flags(cipher);
-	err = __des3_verify_key(&flags, key);
-	if (unlikely(err)) {
-		crypto_ablkcipher_set_flags(cipher, flags);
+	err = crypto_des3_ede_verify_key(crypto_ablkcipher_tfm(cipher), key);
+	if (unlikely(err))
 		return err;
-	}
 
 	memcpy(ctx->key, key, keylen);
 	ctx->keylen = keylen;
-- 
2.20.1


Return-Path: <SRS0=RljO=UV=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8873CC48BE0
	for <linux-crypto@archiver.kernel.org>; Sat, 22 Jun 2019 00:32:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5E9952084E
	for <linux-crypto@archiver.kernel.org>; Sat, 22 Jun 2019 00:32:06 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="dHIp3gjX"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726141AbfFVAcF (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 21 Jun 2019 20:32:05 -0400
Received: from mail-wm1-f66.google.com ([209.85.128.66]:53124 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726219AbfFVAcE (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 21 Jun 2019 20:32:04 -0400
Received: by mail-wm1-f66.google.com with SMTP id s3so7718125wms.2
        for <linux-crypto@vger.kernel.org>; Fri, 21 Jun 2019 17:32:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=O7DR5C/lWiSweuqmSJBPrK6JFLnDeOwIB42xolmC51s=;
        b=dHIp3gjX/z7+mIYEOuoLvCOZyhf2x5f+wfiTkWOmMoFBidLm8ShD2jXDNHxtHJkoFH
         /pFxc5PNQx6rc3j4dXWqe4pHns+Rm+p83YzbxLW3i5Dga3YuuomAxoAJxN279rLkObs3
         GEJ9kHGiv9GBNmhldAfcMiSAiIU/14uFG3z/tNbjRFQv9F2fs15Pbm459rX+redPSeUH
         Y0S8yZl1rxXr6a+ZbYZibGVnnfokFvFkBItTqveIFkbrZNkii4Hoew7h3XEWnvFTJtGE
         8xjIdndoyf/f1O4BnddjM2rG4DM/VzKw2kYnuN/2gjKWtP7idkbHYq6pzZfHdHhE+H0W
         vwzA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=O7DR5C/lWiSweuqmSJBPrK6JFLnDeOwIB42xolmC51s=;
        b=NyPWRYDuJ1JFEtbS4/uMDPMgO9hYjT5DGOuMY83WPYsROaOanJmyA5M/oVCFC1eMBx
         0BxLtrM/9Q4+JWE4XFT4684LJrCAAgHSHBBHuaD20khXxqET5SHDzhlg3zazfRO8vU7H
         DPwoXXHVy+QFoHwJiqCpU2KwVmF5OywJ60vDEpMyJI2p3Uh4K1fjO+4vylCuuwY+AFFN
         lMo/FXtK9MP9cfkmRDjSGKPSg1Es4MCsnchpwjPvMBDNLqPKoqaZdCT3TtcsNRI3OBnx
         oVa4oqblfErmk6DCT97bWet5j/ARIYdpv7VqKyFB5g/xhVXNoBrezsHzsbgjUTqy38Uc
         hD0g==
X-Gm-Message-State: APjAAAVlDHExTEOl6KzcbHSof3K2C6MFFLuuSrwHMAbb49dXATWsJMSg
        rC7R3OMQS6zNCoaTcFzVA+4EgiWt3mCTLJ0/
X-Google-Smtp-Source: APXvYqyF8NkDodW1Hy6DqmcdZQxc6Au+mk2182h2NqmTE+QOmbPSVJRtjo4uGMAL68Rb9uHdPm4KRg==
X-Received: by 2002:a1c:7408:: with SMTP id p8mr5305899wmc.161.1561163522048;
        Fri, 21 Jun 2019 17:32:02 -0700 (PDT)
Received: from sudo.home ([2a01:cb1d:112:6f00:99d4:1ff0:ed6:dfbb])
        by smtp.gmail.com with ESMTPSA id v18sm4792019wrd.51.2019.06.21.17.32.01
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 21 Jun 2019 17:32:01 -0700 (PDT)
From:   Ard Biesheuvel <ard.biesheuvel@linaro.org>
To:     linux-crypto@vger.kernel.org
Cc:     herbert@gondor.apana.org.au, ebiggers@google.com,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: [RFC PATCH 17/30] crypto: omap/des - switch to new verification routines
Date:   Sat, 22 Jun 2019 02:30:59 +0200
Message-Id: <20190622003112.31033-18-ard.biesheuvel@linaro.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190622003112.31033-1-ard.biesheuvel@linaro.org>
References: <20190622003112.31033-1-ard.biesheuvel@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
---
 drivers/crypto/omap-des.c | 26 ++++++--------------
 1 file changed, 8 insertions(+), 18 deletions(-)

diff --git a/drivers/crypto/omap-des.c b/drivers/crypto/omap-des.c
index 3d82d18ff810..260fe83b8a7b 100644
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
+	err = crypto_des_verify_key(crypto_ablkcipher_tfm(cipher), key, keylen);
+	if (unlikely(err))
+		return err;
 
 	memcpy(ctx->key, key, keylen);
 	ctx->keylen = keylen;
@@ -679,17 +672,14 @@ static int omap_des3_setkey(struct crypto_ablkcipher *cipher, const u8 *key,
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
+	err = crypto_des3_ede_verify_key(crypto_ablkcipher_tfm(cipher), key,
+					 keylen);
+	if (unlikely(err))
 		return err;
-	}
 
 	memcpy(ctx->key, key, keylen);
 	ctx->keylen = keylen;
-- 
2.20.1


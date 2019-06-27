Return-Path: <SRS0=CUNG=U2=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ED5D7C48BD7
	for <linux-crypto@archiver.kernel.org>; Thu, 27 Jun 2019 12:03:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C617A20656
	for <linux-crypto@archiver.kernel.org>; Thu, 27 Jun 2019 12:03:45 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="qjTNGrzP"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726748AbfF0MDp (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 27 Jun 2019 08:03:45 -0400
Received: from mail-wm1-f68.google.com ([209.85.128.68]:34048 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726801AbfF0MDo (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 27 Jun 2019 08:03:44 -0400
Received: by mail-wm1-f68.google.com with SMTP id w9so6904525wmd.1
        for <linux-crypto@vger.kernel.org>; Thu, 27 Jun 2019 05:03:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Etn4shY5XiZq8od7GrHPK2vvKa6M5pcmxZ0giOOWz20=;
        b=qjTNGrzPjTtuzb/QCfw+Oyux3V8GyRR95w4QWt++x527g9L9iLBtrZJoR3wWyhg1lI
         oMDgDn5teZTAa1GMYPfWMUx+80saTcbuYWSXc6eEnl7AOIshWY09Nnxt9lPtVjL/8eo7
         Yel1T5MsZOJSLYzubqeHWQdxz/tgka5LKZ/flf7w47Sqv0PRC0vgJ7uGPnfAEG3frkg1
         1WSF/M7yKp6RE4hDndlvlxeoWSHZm0S6ri01jPT2nqkd31UBy57b7IEYpQe+azo1reWG
         i1UTNL4JJDKaoHPMGlQRZIdajbePavAdKnznz+U5cU9FabdbFeUtyDgtqXhcHl5A3xLL
         JgQQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Etn4shY5XiZq8od7GrHPK2vvKa6M5pcmxZ0giOOWz20=;
        b=t8DSs0NPSKGF38ZuMpGAv+1iC0yV8xat3crhvsQTaIsX+f1b5uamasEJyxIuKp8Hv5
         hCc4toUFNsKH3kKyOtAFjFAlmmsaUYv3yR6c2o+V+rlq1yaP1JRhiEd6gs5fqOWytqRK
         hBKa6SEXuSIYEoQPwnJSQs6FbcZ5hGwpa0Au/LCJUMy8L2rICIOI9eDrV/K/13rh5U4G
         tNubejSizN5bL++O6MFvTKCPLEhp7a7MVvER14D1YBB8npfdSlsgqWrTLUsGJLm3xjdV
         CYIOTyjsBL6Tvd19J+AgaO1ibX2B6615CbrqxrzojaD5XM6iga3VUQOcD7T3js3K08lj
         xpeA==
X-Gm-Message-State: APjAAAVSD49lcj29tKjYoQiDWneCWwttH+MiqDhaw0Vhy8iRxq/2Nphk
        WbscSIsd/gSFRe41YDB7LgcEnFAcHOngwg==
X-Google-Smtp-Source: APXvYqzBxJ+8fjyyAIkkTyC68Oi2rikntxvcgCvIsVJMxGr2RbyilbVG0/S7Y8327mh5yU9t6b83nA==
X-Received: by 2002:a1c:eb0a:: with SMTP id j10mr3226971wmh.1.1561637022720;
        Thu, 27 Jun 2019 05:03:42 -0700 (PDT)
Received: from localhost.localdomain (laubervilliers-657-1-83-120.w92-154.abo.wanadoo.fr. [92.154.90.120])
        by smtp.gmail.com with ESMTPSA id z126sm7732431wmb.32.2019.06.27.05.03.41
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Thu, 27 Jun 2019 05:03:42 -0700 (PDT)
From:   Ard Biesheuvel <ard.biesheuvel@linaro.org>
To:     linux-crypto@vger.kernel.org
Cc:     herbert@gondor.apana.org.au, ebiggers@kernel.org,
        horia.geanta@nxp.com, Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: [PATCH v2 15/30] crypto: cesa/des - switch to new verification routines
Date:   Thu, 27 Jun 2019 14:02:59 +0200
Message-Id: <20190627120314.7197-16-ard.biesheuvel@linaro.org>
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
 drivers/crypto/marvell/cipher.c | 20 ++++++--------------
 1 file changed, 6 insertions(+), 14 deletions(-)

diff --git a/drivers/crypto/marvell/cipher.c b/drivers/crypto/marvell/cipher.c
index 2fd936b19c6d..718b51675638 100644
--- a/drivers/crypto/marvell/cipher.c
+++ b/drivers/crypto/marvell/cipher.c
@@ -13,7 +13,7 @@
  */
 
 #include <crypto/aes.h>
-#include <crypto/des.h>
+#include <crypto/internal/des.h>
 
 #include "cesa.h"
 
@@ -277,19 +277,11 @@ static int mv_cesa_des_setkey(struct crypto_skcipher *cipher, const u8 *key,
 {
 	struct crypto_tfm *tfm = crypto_skcipher_tfm(cipher);
 	struct mv_cesa_des_ctx *ctx = crypto_tfm_ctx(tfm);
-	u32 tmp[DES_EXPKEY_WORDS];
-	int ret;
-
-	if (len != DES_KEY_SIZE) {
-		crypto_skcipher_set_flags(cipher, CRYPTO_TFM_RES_BAD_KEY_LEN);
-		return -EINVAL;
-	}
+	int err;
 
-	ret = des_ekey(tmp, key);
-	if (!ret && (tfm->crt_flags & CRYPTO_TFM_REQ_FORBID_WEAK_KEYS)) {
-		tfm->crt_flags |= CRYPTO_TFM_RES_WEAK_KEY;
-		return -EINVAL;
-	}
+	err = crypto_des_verify_key(tfm, key);
+	if (unlikely(err))
+		return err;
 
 	memcpy(ctx->key, key, DES_KEY_SIZE);
 
@@ -302,7 +294,7 @@ static int mv_cesa_des3_ede_setkey(struct crypto_skcipher *cipher,
 	struct mv_cesa_des_ctx *ctx = crypto_skcipher_ctx(cipher);
 	int err;
 
-	err = des3_verify_key(cipher, key);
+	err = crypto_des3_ede_verify_key(crypto_skcipher_tfm(cipher), key);
 	if (unlikely(err))
 		return err;
 
-- 
2.20.1


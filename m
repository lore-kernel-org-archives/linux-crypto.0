Return-Path: <SRS0=pRBs=WL=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BE08FC31E40
	for <linux-crypto@archiver.kernel.org>; Thu, 15 Aug 2019 09:01:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 87E6C218A6
	for <linux-crypto@archiver.kernel.org>; Thu, 15 Aug 2019 09:01:40 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="Q1hGRZPa"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730774AbfHOJBk (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 15 Aug 2019 05:01:40 -0400
Received: from mail-wm1-f68.google.com ([209.85.128.68]:33064 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726120AbfHOJBj (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 15 Aug 2019 05:01:39 -0400
Received: by mail-wm1-f68.google.com with SMTP id p77so591983wme.0
        for <linux-crypto@vger.kernel.org>; Thu, 15 Aug 2019 02:01:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=BOt7PVw9lWqBCV/+RL+9xpeVpvumzg35vFF4tN3Fxn0=;
        b=Q1hGRZPa6MRZjoPqKHWUGdpI7Q5tqXwYt0eUeNtFXgtbmAP+3ZtZs9IejBKZZtwBG4
         w2YnHDcj2Kl/htWCg5En5YEgXSC1dT/iv4r3wmMD3kUFHRKAZX2txkAGMpQBQJpOK2J1
         eBSQkYVVh8Q37ZJiQoMrbX3UNzlVGfetZ7CALx6+xLxOi9Al49CF+jNXii6/0bVFLu2e
         /KPQBQsiAiU3JStCN9am/r7Ce8kGLNGULdYHHjaDkovis63wHi4wrAGPrdzmKeOWAhqp
         23Ug43NOxQPs98WFtq76VVholamwkwtzbMz7VUe1yb2LZMg+rVOnGSlKCbnC7EtNp8Ig
         LlbQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=BOt7PVw9lWqBCV/+RL+9xpeVpvumzg35vFF4tN3Fxn0=;
        b=nHn0M4CO1YH47KlloVganH+/wDohngGTjmHhh4Fg1j23oK24QjOmUAQy1O64g3CTKY
         g5QZK+rhRxHTxVpE6AHraqVRvsUEQbhXS0OpoNjj1y5xJZ3Shw/GcHjyfnWZ91w+MZyl
         fRr5ZMd8R3TwQ3axuTPOBxP6LfN9MmtfjR/V69pUF173nxh9QhLnflNrgWu86emSA/3k
         B1wxufeVCOqEt8Cg1PcsVSt1dW4AScV/Pd/Z35tQf8MO8oqmlNNCMTd21Xr9BfJQngxa
         Woa+Kmh6LoDlftia9YdiJWlEU3lGjzkCX9UmrCagUBUIG1UP3g9sOXKnmzL4yfO2bswk
         /gEA==
X-Gm-Message-State: APjAAAV4jtKYLoC400aAmuDX7qZVFM/7rcLcTTe4x3GmmFQDrDVGqNWA
        6lV/znZRiCPC6EatbMGOcjhJnIpP7nWUTbCz
X-Google-Smtp-Source: APXvYqz70HeX1ci6D5CXl6CWzb2/9etDbF3OsaUVmKE20ysIEbgUExBXRhq2ezaFxQNuwk1LJrKS5w==
X-Received: by 2002:a7b:c157:: with SMTP id z23mr1696966wmi.104.1565859697490;
        Thu, 15 Aug 2019 02:01:37 -0700 (PDT)
Received: from localhost.localdomain ([2a02:587:a407:da00:f1b5:e68c:5f7f:79e7])
        by smtp.gmail.com with ESMTPSA id x20sm3857533wrg.10.2019.08.15.02.01.35
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 15 Aug 2019 02:01:36 -0700 (PDT)
From:   Ard Biesheuvel <ard.biesheuvel@linaro.org>
To:     linux-crypto@vger.kernel.org
Cc:     herbert@gondor.apana.org.au,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: [PATCH v5 07/30] crypto: cpt/des - switch to new verification routines
Date:   Thu, 15 Aug 2019 12:00:49 +0300
Message-Id: <20190815090112.9377-8-ard.biesheuvel@linaro.org>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190815090112.9377-1-ard.biesheuvel@linaro.org>
References: <20190815090112.9377-1-ard.biesheuvel@linaro.org>
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
---
 drivers/crypto/cavium/cpt/cptvf_algs.c | 26 ++++----------------
 1 file changed, 5 insertions(+), 21 deletions(-)

diff --git a/drivers/crypto/cavium/cpt/cptvf_algs.c b/drivers/crypto/cavium/cpt/cptvf_algs.c
index ff3cb1f8f2b6..596ce28b957d 100644
--- a/drivers/crypto/cavium/cpt/cptvf_algs.c
+++ b/drivers/crypto/cavium/cpt/cptvf_algs.c
@@ -7,7 +7,7 @@
 #include <crypto/aes.h>
 #include <crypto/algapi.h>
 #include <crypto/authenc.h>
-#include <crypto/des.h>
+#include <crypto/internal/des.h>
 #include <crypto/xts.h>
 #include <linux/crypto.h>
 #include <linux/err.h>
@@ -322,31 +322,15 @@ static int cvm_cfb_aes_setkey(struct crypto_ablkcipher *cipher, const u8 *key,
 static int cvm_cbc_des3_setkey(struct crypto_ablkcipher *cipher, const u8 *key,
 			       u32 keylen)
 {
-	u32 flags = crypto_ablkcipher_get_flags(cipher);
-	int err;
-
-	err = __des3_verify_key(&flags, key);
-	if (unlikely(err)) {
-		crypto_ablkcipher_set_flags(cipher, flags);
-		return err;
-	}
-
-	return cvm_setkey(cipher, key, keylen, DES3_CBC);
+	return verify_ablkcipher_des3_key(cipher, key) ?:
+	       cvm_setkey(cipher, key, keylen, DES3_CBC);
 }
 
 static int cvm_ecb_des3_setkey(struct crypto_ablkcipher *cipher, const u8 *key,
 			       u32 keylen)
 {
-	u32 flags = crypto_ablkcipher_get_flags(cipher);
-	int err;
-
-	err = __des3_verify_key(&flags, key);
-	if (unlikely(err)) {
-		crypto_ablkcipher_set_flags(cipher, flags);
-		return err;
-	}
-
-	return cvm_setkey(cipher, key, keylen, DES3_ECB);
+	return verify_ablkcipher_des3_key(cipher, key) ?:
+	       cvm_setkey(cipher, key, keylen, DES3_ECB);
 }
 
 static int cvm_enc_dec_init(struct crypto_tfm *tfm)
-- 
2.17.1


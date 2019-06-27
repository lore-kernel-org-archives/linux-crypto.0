Return-Path: <SRS0=CUNG=U2=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E5E3CC48BD9
	for <linux-crypto@archiver.kernel.org>; Thu, 27 Jun 2019 12:03:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id BEBDC20656
	for <linux-crypto@archiver.kernel.org>; Thu, 27 Jun 2019 12:03:46 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="OibWrrWJ"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726827AbfF0MDq (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 27 Jun 2019 08:03:46 -0400
Received: from mail-wm1-f68.google.com ([209.85.128.68]:53961 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726441AbfF0MDp (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 27 Jun 2019 08:03:45 -0400
Received: by mail-wm1-f68.google.com with SMTP id x15so5471747wmj.3
        for <linux-crypto@vger.kernel.org>; Thu, 27 Jun 2019 05:03:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=oG9DTc9EahpQGLRdj2tQuSEAjZr8slfDrgTwwpr3SnQ=;
        b=OibWrrWJc4eJTybBU/L/T5IjE3SEoyzhROe0PHfBSbZ0BGN/SKA6TC36DmtSZvxTah
         nHWrEVHbJPZLsXz0o2TLwV164IP5dOCCPInAmH4kkL4NtCG0HBJawbHEaeSWKhf30pIb
         85WnRLV/v4q6opXspSDF09Y83eWEk3o2A82J2xkbuMMph52Ja4BE4yYvmhNX+A4lvKX6
         CiZ2CvUAl0ty+MWENzla4YcHaDcVstf03ucBm2ev0O5YB40WUXkeU51veafg3Fi5siVK
         jP2dzfmyDb53dVxBE9G/Pjrtavii2d1Of3ugOczYzPsrBL2Y2xfNS/tT/ubYcZeHX5Jh
         KTAA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=oG9DTc9EahpQGLRdj2tQuSEAjZr8slfDrgTwwpr3SnQ=;
        b=Bqr+ZWdjxCv0pLGRIxAvRVJs1FkKheSjOFD19XamdG5HNn4nECoFP03H/iTDrTs5j6
         aUPRFYiQOi9WbPF3vyR0SCrgvDL377XndMgmphU2NQF7cOm0fkH57ljeG661wNGDzNsv
         n/34GOK4N0VaStRASge96S82E4O+VO8gpS8Jw9qQ8MbUTwWNJviskQrM8MuYLmCAdrOW
         lO9dVhGKS7cWG9zI0JWrakBJknJWLXKl2/xgmoPIkkT+w7Xxq8j7Eqi33fyy/0JAsPJg
         TnwEJI8la3hMDH7z9XKkpIMCQ186ErhVcleN1SuUBUBmqBvSjfCanmAT7wSy+hvHjlsJ
         xFvA==
X-Gm-Message-State: APjAAAX5zyjLfWA7c0aaP+CCziKnm24qx+0KbUa9BkD7l1xwGKZ4RlR+
        ARLb1I4cwPCdj7k4Xal+iUgaBrYgyh62PA==
X-Google-Smtp-Source: APXvYqxad7ifWqHhu5cCVJAkfwmc5QbZL6UaZ+Ez67NRJT76K32yHqu0r1Q0L61AmkxdPfz7ra4I0g==
X-Received: by 2002:a1c:e90f:: with SMTP id q15mr3162485wmc.89.1561637023784;
        Thu, 27 Jun 2019 05:03:43 -0700 (PDT)
Received: from localhost.localdomain (laubervilliers-657-1-83-120.w92-154.abo.wanadoo.fr. [92.154.90.120])
        by smtp.gmail.com with ESMTPSA id z126sm7732431wmb.32.2019.06.27.05.03.42
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Thu, 27 Jun 2019 05:03:43 -0700 (PDT)
From:   Ard Biesheuvel <ard.biesheuvel@linaro.org>
To:     linux-crypto@vger.kernel.org
Cc:     herbert@gondor.apana.org.au, ebiggers@kernel.org,
        horia.geanta@nxp.com, Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: [PATCH v2 16/30] crypto: n2/des - switch to new verification routines
Date:   Thu, 27 Jun 2019 14:03:00 +0200
Message-Id: <20190627120314.7197-17-ard.biesheuvel@linaro.org>
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
 drivers/crypto/n2_core.c | 26 ++++++--------------
 1 file changed, 7 insertions(+), 19 deletions(-)

diff --git a/drivers/crypto/n2_core.c b/drivers/crypto/n2_core.c
index 0d5d3d8eb680..d313958d09a9 100644
--- a/drivers/crypto/n2_core.c
+++ b/drivers/crypto/n2_core.c
@@ -16,7 +16,7 @@
 #include <crypto/md5.h>
 #include <crypto/sha.h>
 #include <crypto/aes.h>
-#include <crypto/des.h>
+#include <crypto/internal/des.h>
 #include <linux/mutex.h>
 #include <linux/delay.h>
 #include <linux/sched.h>
@@ -759,21 +759,13 @@ static int n2_des_setkey(struct crypto_ablkcipher *cipher, const u8 *key,
 	struct crypto_tfm *tfm = crypto_ablkcipher_tfm(cipher);
 	struct n2_cipher_context *ctx = crypto_tfm_ctx(tfm);
 	struct n2_cipher_alg *n2alg = n2_cipher_alg(tfm);
-	u32 tmp[DES_EXPKEY_WORDS];
 	int err;
 
-	ctx->enc_type = n2alg->enc_type;
-
-	if (keylen != DES_KEY_SIZE) {
-		crypto_ablkcipher_set_flags(cipher, CRYPTO_TFM_RES_BAD_KEY_LEN);
-		return -EINVAL;
-	}
+	err = crypto_des_verify_key(tfm, key);
+	if (unlikely(err))
+		return err;
 
-	err = des_ekey(tmp, key);
-	if (err == 0 && (tfm->crt_flags & CRYPTO_TFM_REQ_FORBID_WEAK_KEYS)) {
-		tfm->crt_flags |= CRYPTO_TFM_RES_WEAK_KEY;
-		return -EINVAL;
-	}
+	ctx->enc_type = n2alg->enc_type;
 
 	ctx->key_len = keylen;
 	memcpy(ctx->key.des, key, keylen);
@@ -786,15 +778,11 @@ static int n2_3des_setkey(struct crypto_ablkcipher *cipher, const u8 *key,
 	struct crypto_tfm *tfm = crypto_ablkcipher_tfm(cipher);
 	struct n2_cipher_context *ctx = crypto_tfm_ctx(tfm);
 	struct n2_cipher_alg *n2alg = n2_cipher_alg(tfm);
-	u32 flags;
 	int err;
 
-	flags = crypto_ablkcipher_get_flags(cipher);
-	err = __des3_verify_key(&flags, key);
-	if (unlikely(err)) {
-		crypto_ablkcipher_set_flags(cipher, flags);
+	err = crypto_des3_ede_verify_key(tfm, key);
+	if (unlikely(err))
 		return err;
-	}
 
 	ctx->enc_type = n2alg->enc_type;
 
-- 
2.20.1


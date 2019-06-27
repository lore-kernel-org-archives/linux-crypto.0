Return-Path: <SRS0=CUNG=U2=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 71141C48BDA
	for <linux-crypto@archiver.kernel.org>; Thu, 27 Jun 2019 12:03:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 49C2E2086D
	for <linux-crypto@archiver.kernel.org>; Thu, 27 Jun 2019 12:03:33 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="dCAg21RO"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726678AbfF0MDc (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 27 Jun 2019 08:03:32 -0400
Received: from mail-wr1-f67.google.com ([209.85.221.67]:34713 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726542AbfF0MDc (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 27 Jun 2019 08:03:32 -0400
Received: by mail-wr1-f67.google.com with SMTP id k11so2278825wrl.1
        for <linux-crypto@vger.kernel.org>; Thu, 27 Jun 2019 05:03:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Lqk2F1dMPirsNvZjMWj5/SEiKrPeSORVLu9mfIy1Vdg=;
        b=dCAg21ROvSB+gknzp2em+sIH7Qb46ioBPLXj3s/pE+23NZo1Oeo7mSr9bXa4ht15TS
         xFMXeknkgvT41TmduNY4HqrUzH+rU1krh6BinBibDKhZv++cEhQUo2ER0V0XQjcXPmnz
         nl+63nkOhLKXIC00B+sR2hSdO9X62FgqaAcT6wJPMpqjJeMPs7qPx3vAy670keL/hFWr
         vCCMWRht2MO3K63u6+U1t7mP/Gugjjmsmth8KX5ocYwwy2PfTlAvNBjJNqJVIILJh/Ub
         gi+anl5cTe0npLRhtwSO+fLhjOhOkPRTAp3L/V2mUKi7h+cIFYx2rqrzngr6kBqagAKo
         BfnQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Lqk2F1dMPirsNvZjMWj5/SEiKrPeSORVLu9mfIy1Vdg=;
        b=PFOzx0g30IjT1RVHnAZ+2olCNXSff57Z74wU6XHITHHA3mRfQodcrCMF8t142GriqH
         hx8mV1X2Qv986nLUAurACNDOejuB02V3zNlZHrU92tG9zY3h20TYU4E8qpAttk9p2JiG
         qPSHSc5qOvnQsZpxA0q4zZkjawtQ2vc5fJ4uH1FABJmAqsalVmcc/Ei1du/M38beJu8E
         YND8GmXdVUJxYHVkADaJ3WOrDaH/7O3AetsCZZlFkzEN7mVs2fj18QvfO5O9a36hpIRr
         qtSiKhuqqmqizhiH3VteGx/3EaFnKg9upMG+Alw/73xj0yCJAhPBEarHdesn/ryiXNXR
         o9Eg==
X-Gm-Message-State: APjAAAUdqp0JwC/bhEM/wk440RmrDXYSAvBLpTtUHK6B0Dh5hwKA3Ud+
        RaBjmzv4RoB5jq8FG+K3XqoGSN0CRBbxzw==
X-Google-Smtp-Source: APXvYqzojlRWooX93vCsgwxRcVp001hYHal0rBR3l/yp0acIwAFi6okesXJMPXNh68L+XwfjezUZOA==
X-Received: by 2002:adf:e2c7:: with SMTP id d7mr2918197wrj.272.1561637009242;
        Thu, 27 Jun 2019 05:03:29 -0700 (PDT)
Received: from localhost.localdomain (laubervilliers-657-1-83-120.w92-154.abo.wanadoo.fr. [92.154.90.120])
        by smtp.gmail.com with ESMTPSA id z126sm7732431wmb.32.2019.06.27.05.03.28
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Thu, 27 Jun 2019 05:03:28 -0700 (PDT)
From:   Ard Biesheuvel <ard.biesheuvel@linaro.org>
To:     linux-crypto@vger.kernel.org
Cc:     herbert@gondor.apana.org.au, ebiggers@kernel.org,
        horia.geanta@nxp.com, Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: [PATCH v2 03/30] crypto: sparc/des - switch to new verification routines
Date:   Thu, 27 Jun 2019 14:02:47 +0200
Message-Id: <20190627120314.7197-4-ard.biesheuvel@linaro.org>
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
 arch/sparc/crypto/des_glue.c | 35 +++++++++-----------
 1 file changed, 15 insertions(+), 20 deletions(-)

diff --git a/arch/sparc/crypto/des_glue.c b/arch/sparc/crypto/des_glue.c
index 453a4cf5492a..8a35491d6656 100644
--- a/arch/sparc/crypto/des_glue.c
+++ b/arch/sparc/crypto/des_glue.c
@@ -11,7 +11,7 @@
 #include <linux/mm.h>
 #include <linux/types.h>
 #include <crypto/algapi.h>
-#include <crypto/des.h>
+#include <crypto/internal/des.h>
 
 #include <asm/fpumacro.h>
 #include <asm/pstate.h>
@@ -44,19 +44,15 @@ static int des_set_key(struct crypto_tfm *tfm, const u8 *key,
 		       unsigned int keylen)
 {
 	struct des_sparc64_ctx *dctx = crypto_tfm_ctx(tfm);
-	u32 *flags = &tfm->crt_flags;
-	u32 tmp[DES_EXPKEY_WORDS];
-	int ret;
+	int err;
 
 	/* Even though we have special instructions for key expansion,
-	 * we call des_ekey() so that we don't have to write our own
+	 * we call des_verify_key() so that we don't have to write our own
 	 * weak key detection code.
 	 */
-	ret = des_ekey(tmp, key);
-	if (unlikely(ret == 0) && (*flags & CRYPTO_TFM_REQ_FORBID_WEAK_KEYS)) {
-		*flags |= CRYPTO_TFM_RES_WEAK_KEY;
-		return -EINVAL;
-	}
+	err = crypto_des_verify_key(tfm, key);
+	if (unlikely(err))
+		return err;
 
 	des_sparc64_key_expand((const u32 *) key, &dctx->encrypt_expkey[0]);
 	encrypt_to_decrypt(&dctx->decrypt_expkey[0], &dctx->encrypt_expkey[0]);
@@ -67,7 +63,7 @@ static int des_set_key(struct crypto_tfm *tfm, const u8 *key,
 extern void des_sparc64_crypt(const u64 *key, const u64 *input,
 			      u64 *output);
 
-static void des_encrypt(struct crypto_tfm *tfm, u8 *dst, const u8 *src)
+static void crypto_des_encrypt(struct crypto_tfm *tfm, u8 *dst, const u8 *src)
 {
 	struct des_sparc64_ctx *ctx = crypto_tfm_ctx(tfm);
 	const u64 *K = ctx->encrypt_expkey;
@@ -75,7 +71,7 @@ static void des_encrypt(struct crypto_tfm *tfm, u8 *dst, const u8 *src)
 	des_sparc64_crypt(K, (const u64 *) src, (u64 *) dst);
 }
 
-static void des_decrypt(struct crypto_tfm *tfm, u8 *dst, const u8 *src)
+static void crypto_des_decrypt(struct crypto_tfm *tfm, u8 *dst, const u8 *src)
 {
 	struct des_sparc64_ctx *ctx = crypto_tfm_ctx(tfm);
 	const u64 *K = ctx->decrypt_expkey;
@@ -201,13 +197,12 @@ static int des3_ede_set_key(struct crypto_tfm *tfm, const u8 *key,
 			    unsigned int keylen)
 {
 	struct des3_ede_sparc64_ctx *dctx = crypto_tfm_ctx(tfm);
-	u32 *flags = &tfm->crt_flags;
 	u64 k1[DES_EXPKEY_WORDS / 2];
 	u64 k2[DES_EXPKEY_WORDS / 2];
 	u64 k3[DES_EXPKEY_WORDS / 2];
 	int err;
 
-	err = __des3_verify_key(flags, key);
+	err = crypto_des3_ede_verify_key(tfm, key);
 	if (unlikely(err))
 		return err;
 
@@ -234,7 +229,7 @@ static int des3_ede_set_key(struct crypto_tfm *tfm, const u8 *key,
 extern void des3_ede_sparc64_crypt(const u64 *key, const u64 *input,
 				   u64 *output);
 
-static void des3_ede_encrypt(struct crypto_tfm *tfm, u8 *dst, const u8 *src)
+static void crypto_des3_ede_encrypt(struct crypto_tfm *tfm, u8 *dst, const u8 *src)
 {
 	struct des3_ede_sparc64_ctx *ctx = crypto_tfm_ctx(tfm);
 	const u64 *K = ctx->encrypt_expkey;
@@ -242,7 +237,7 @@ static void des3_ede_encrypt(struct crypto_tfm *tfm, u8 *dst, const u8 *src)
 	des3_ede_sparc64_crypt(K, (const u64 *) src, (u64 *) dst);
 }
 
-static void des3_ede_decrypt(struct crypto_tfm *tfm, u8 *dst, const u8 *src)
+static void crypto_des3_ede_decrypt(struct crypto_tfm *tfm, u8 *dst, const u8 *src)
 {
 	struct des3_ede_sparc64_ctx *ctx = crypto_tfm_ctx(tfm);
 	const u64 *K = ctx->decrypt_expkey;
@@ -389,8 +384,8 @@ static struct crypto_alg algs[] = { {
 			.cia_min_keysize	= DES_KEY_SIZE,
 			.cia_max_keysize	= DES_KEY_SIZE,
 			.cia_setkey		= des_set_key,
-			.cia_encrypt		= des_encrypt,
-			.cia_decrypt		= des_decrypt
+			.cia_encrypt		= crypto_des_encrypt,
+			.cia_decrypt		= crypto_des_decrypt
 		}
 	}
 }, {
@@ -446,8 +441,8 @@ static struct crypto_alg algs[] = { {
 			.cia_min_keysize	= DES3_EDE_KEY_SIZE,
 			.cia_max_keysize	= DES3_EDE_KEY_SIZE,
 			.cia_setkey		= des3_ede_set_key,
-			.cia_encrypt		= des3_ede_encrypt,
-			.cia_decrypt		= des3_ede_decrypt
+			.cia_encrypt		= crypto_des3_ede_encrypt,
+			.cia_decrypt		= crypto_des3_ede_decrypt
 		}
 	}
 }, {
-- 
2.20.1


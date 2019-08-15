Return-Path: <SRS0=pRBs=WL=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 63F68C31E40
	for <linux-crypto@archiver.kernel.org>; Thu, 15 Aug 2019 09:01:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3B61C218A6
	for <linux-crypto@archiver.kernel.org>; Thu, 15 Aug 2019 09:01:32 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="kwL3DwGm"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730787AbfHOJBb (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 15 Aug 2019 05:01:31 -0400
Received: from mail-wm1-f67.google.com ([209.85.128.67]:39189 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730775AbfHOJBb (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 15 Aug 2019 05:01:31 -0400
Received: by mail-wm1-f67.google.com with SMTP id i63so676043wmg.4
        for <linux-crypto@vger.kernel.org>; Thu, 15 Aug 2019 02:01:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=Er+86N+2cIZoohxTF9t6iACtueSxaqn6lRZ33S62JII=;
        b=kwL3DwGmEiYfTPsqBIEpCPTFvQxO2oS+c5ZwwQKE/bi1v9nndMErM3vAXZ15Ndaa/x
         w69jA9loiu+jMhVHiXkLG00NPXsZznelGbaAYp0n+cvFED3p5wFw/5J9Aod73/V9tyYD
         U2wbmC6Z2TQziCK9+LzDNaG7u4FIzroRIg+lzmEK607L8FfPnqWwSC6YJU0eVlTlPZZI
         5Doq+YOYJ8OyOqokdd/6J2fUGgB51vvdvT0IazwKM0L9/HU0cS9EaMgl+80ZHb432OzV
         u7nGAtQu8qdc9R4xqG0COuFVvd0xYNRWQOBWZh2U9hPX9MVo53IsTm6QSX1Wz1yBoI4R
         PXTA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=Er+86N+2cIZoohxTF9t6iACtueSxaqn6lRZ33S62JII=;
        b=UOMfOQPDeuQDpti70AlaBA/SFvGB8hVJlIeaxh05kI6yQOT4zzFZsLAFB3T1nwg6iI
         bS5uUmQPoXMHZLBkAiF3Y+B76g/rMoAeYE9mpz0HYpBtnHS6FaXbAL8vriJaCM8N/P0c
         njJeGEpUo1iPsXZH2Y8shclar2Ow704RJuMr9kL5VJkNObjVoqMTq3GmrpyHYA0Iparl
         nwN1j6FNFt7uIWpyKybO9Nx7sG1hakB7tfvBu6aqHcj7aiym44Zg41v7+tSXeaPG+35f
         9NzruIuHZKyRbCOeCeEXooPZK6lXVcr7M+3JoH2ZnBWWTsMbQNk9az/tOw8Ba+UTnql6
         3K5Q==
X-Gm-Message-State: APjAAAWIz7JK/WzIIUjKb5xtWie+B8ICisuUrALRC2z0p8VuZMl55gz7
        cOc57iyIbJr9u7DLecq7tu7TA96HUFNduMC6
X-Google-Smtp-Source: APXvYqxglgAx5H+qaPx0O0xRN6pM1hNsdOf89/6u2weevSDphqhoSg3zhmLeF+vNNqknwr1MJNQ7ww==
X-Received: by 2002:a7b:c157:: with SMTP id z23mr1696307wmi.104.1565859688695;
        Thu, 15 Aug 2019 02:01:28 -0700 (PDT)
Received: from localhost.localdomain ([2a02:587:a407:da00:f1b5:e68c:5f7f:79e7])
        by smtp.gmail.com with ESMTPSA id x20sm3857533wrg.10.2019.08.15.02.01.27
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 15 Aug 2019 02:01:28 -0700 (PDT)
From:   Ard Biesheuvel <ard.biesheuvel@linaro.org>
To:     linux-crypto@vger.kernel.org
Cc:     herbert@gondor.apana.org.au,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: [PATCH v5 03/30] crypto: sparc/des - switch to new verification routines
Date:   Thu, 15 Aug 2019 12:00:45 +0300
Message-Id: <20190815090112.9377-4-ard.biesheuvel@linaro.org>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190815090112.9377-1-ard.biesheuvel@linaro.org>
References: <20190815090112.9377-1-ard.biesheuvel@linaro.org>
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Switch to the refactored DES key verification routines. While at it,
rename the DES encrypt/decrypt routines so they will not conflict with
the DES library later on.

Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
---
 arch/sparc/crypto/des_glue.c | 37 +++++++++-----------
 1 file changed, 16 insertions(+), 21 deletions(-)

diff --git a/arch/sparc/crypto/des_glue.c b/arch/sparc/crypto/des_glue.c
index 281448f72c90..db6010b4e52e 100644
--- a/arch/sparc/crypto/des_glue.c
+++ b/arch/sparc/crypto/des_glue.c
@@ -12,7 +12,7 @@
 #include <linux/mm.h>
 #include <linux/types.h>
 #include <crypto/algapi.h>
-#include <crypto/des.h>
+#include <crypto/internal/des.h>
 
 #include <asm/fpumacro.h>
 #include <asm/pstate.h>
@@ -45,19 +45,15 @@ static int des_set_key(struct crypto_tfm *tfm, const u8 *key,
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
+	if (err)
+		return err;
 
 	des_sparc64_key_expand((const u32 *) key, &dctx->encrypt_expkey[0]);
 	encrypt_to_decrypt(&dctx->decrypt_expkey[0], &dctx->encrypt_expkey[0]);
@@ -68,7 +64,7 @@ static int des_set_key(struct crypto_tfm *tfm, const u8 *key,
 extern void des_sparc64_crypt(const u64 *key, const u64 *input,
 			      u64 *output);
 
-static void des_encrypt(struct crypto_tfm *tfm, u8 *dst, const u8 *src)
+static void sparc_des_encrypt(struct crypto_tfm *tfm, u8 *dst, const u8 *src)
 {
 	struct des_sparc64_ctx *ctx = crypto_tfm_ctx(tfm);
 	const u64 *K = ctx->encrypt_expkey;
@@ -76,7 +72,7 @@ static void des_encrypt(struct crypto_tfm *tfm, u8 *dst, const u8 *src)
 	des_sparc64_crypt(K, (const u64 *) src, (u64 *) dst);
 }
 
-static void des_decrypt(struct crypto_tfm *tfm, u8 *dst, const u8 *src)
+static void sparc_des_decrypt(struct crypto_tfm *tfm, u8 *dst, const u8 *src)
 {
 	struct des_sparc64_ctx *ctx = crypto_tfm_ctx(tfm);
 	const u64 *K = ctx->decrypt_expkey;
@@ -202,14 +198,13 @@ static int des3_ede_set_key(struct crypto_tfm *tfm, const u8 *key,
 			    unsigned int keylen)
 {
 	struct des3_ede_sparc64_ctx *dctx = crypto_tfm_ctx(tfm);
-	u32 *flags = &tfm->crt_flags;
 	u64 k1[DES_EXPKEY_WORDS / 2];
 	u64 k2[DES_EXPKEY_WORDS / 2];
 	u64 k3[DES_EXPKEY_WORDS / 2];
 	int err;
 
-	err = __des3_verify_key(flags, key);
-	if (unlikely(err))
+	err = crypto_des3_ede_verify_key(tfm, key);
+	if (err)
 		return err;
 
 	des_sparc64_key_expand((const u32 *)key, k1);
@@ -235,7 +230,7 @@ static int des3_ede_set_key(struct crypto_tfm *tfm, const u8 *key,
 extern void des3_ede_sparc64_crypt(const u64 *key, const u64 *input,
 				   u64 *output);
 
-static void des3_ede_encrypt(struct crypto_tfm *tfm, u8 *dst, const u8 *src)
+static void sparc_des3_ede_encrypt(struct crypto_tfm *tfm, u8 *dst, const u8 *src)
 {
 	struct des3_ede_sparc64_ctx *ctx = crypto_tfm_ctx(tfm);
 	const u64 *K = ctx->encrypt_expkey;
@@ -243,7 +238,7 @@ static void des3_ede_encrypt(struct crypto_tfm *tfm, u8 *dst, const u8 *src)
 	des3_ede_sparc64_crypt(K, (const u64 *) src, (u64 *) dst);
 }
 
-static void des3_ede_decrypt(struct crypto_tfm *tfm, u8 *dst, const u8 *src)
+static void sparc_des3_ede_decrypt(struct crypto_tfm *tfm, u8 *dst, const u8 *src)
 {
 	struct des3_ede_sparc64_ctx *ctx = crypto_tfm_ctx(tfm);
 	const u64 *K = ctx->decrypt_expkey;
@@ -390,8 +385,8 @@ static struct crypto_alg algs[] = { {
 			.cia_min_keysize	= DES_KEY_SIZE,
 			.cia_max_keysize	= DES_KEY_SIZE,
 			.cia_setkey		= des_set_key,
-			.cia_encrypt		= des_encrypt,
-			.cia_decrypt		= des_decrypt
+			.cia_encrypt		= sparc_des_encrypt,
+			.cia_decrypt		= sparc_des_decrypt
 		}
 	}
 }, {
@@ -447,8 +442,8 @@ static struct crypto_alg algs[] = { {
 			.cia_min_keysize	= DES3_EDE_KEY_SIZE,
 			.cia_max_keysize	= DES3_EDE_KEY_SIZE,
 			.cia_setkey		= des3_ede_set_key,
-			.cia_encrypt		= des3_ede_encrypt,
-			.cia_decrypt		= des3_ede_decrypt
+			.cia_encrypt		= sparc_des3_ede_encrypt,
+			.cia_decrypt		= sparc_des3_ede_decrypt
 		}
 	}
 }, {
-- 
2.17.1


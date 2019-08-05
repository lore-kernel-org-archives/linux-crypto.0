Return-Path: <SRS0=2Ix1=WB=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CBF0EC0650F
	for <linux-crypto@archiver.kernel.org>; Mon,  5 Aug 2019 17:01:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A09202147A
	for <linux-crypto@archiver.kernel.org>; Mon,  5 Aug 2019 17:01:08 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="bG96f0ys"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728851AbfHERBI (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 5 Aug 2019 13:01:08 -0400
Received: from mail-wr1-f67.google.com ([209.85.221.67]:35644 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726693AbfHERBI (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 5 Aug 2019 13:01:08 -0400
Received: by mail-wr1-f67.google.com with SMTP id y4so85151490wrm.2
        for <linux-crypto@vger.kernel.org>; Mon, 05 Aug 2019 10:01:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=0olW9Dc75sxTuyqPpnPJsPbpEsG79ZHgzibe3D5v6gk=;
        b=bG96f0ysp5ezYCORy9z9sQml6o3D8NnAXnTpohUhhQ6nwnHPzBFueMTmQAEhKTYFVr
         8dSm7+w+X9HAwampfTXpvmR0uLHeIgFPtQQTJ6nfDlfNOTUeKrRs4syxZ9l7ChmfeW8Z
         1+30/JloBeE1AOiZnUg8GSkUiYkQDCG3ZEVDDRD0pG4olB52DkVG0e45SFQjCGrcE0Wo
         F3OzVmrsptANayy9MnJCvglzrs+/g2qTBrmWa59k+rW+E73f/pPL9o10ZrVOIgyWDqaA
         Mq0wTw9mvugH8l5eWjxoVOlTEGA/ZxP/lBD6C+QJJ/tYXMdwf5PIiKxD3vFnMZk2jI6T
         mAyw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=0olW9Dc75sxTuyqPpnPJsPbpEsG79ZHgzibe3D5v6gk=;
        b=KMT383WniQUyV9Ku6G3xPA46kVXO0JBSvYS6inWt8GniFfiBvfDjGDxO+vbH7MON+8
         pXWT4Qt8m1wCb9ecSs54NJDvVwuGaCkhwJOpnKWzOmpl2eG9hpviVPJzBdGlJKEKxCNW
         RlfdH8Rn4NKnEVSeiYOIeiMcbmLmjcagrO9yW9u2KU1ffdJuJUJZsZ28dl/r2sx7eFzr
         zB99W2dRjiQncGn9Uzn2gBhGqrGLnPb/pYMn2bvaOH0zzv7NCN80uy1pqikgRR+yfnBW
         6ER1UC9NcP7PpkKPixCZOA2KfK/oXAgXFMXlId8OnVYB+xPs6yRDxGEc0EwaCI1IFjJa
         SM4w==
X-Gm-Message-State: APjAAAXzL4aaH2oPLUkTHMs+P1Vivh7QyWesuElQdPd9VgRq0LdUViiE
        JdSJX5dE67qqCUH8Gu/UTrPYOAqL9ylHbg==
X-Google-Smtp-Source: APXvYqx9dBf/brMJ2c/hgmKkIOdgkMi/cqLGkIJSRdRw/OEmBZsGLr3H/NGXYyzuBpcQYcKQPIcKwg==
X-Received: by 2002:adf:e343:: with SMTP id n3mr125254624wrj.103.1565024464805;
        Mon, 05 Aug 2019 10:01:04 -0700 (PDT)
Received: from localhost.localdomain ([2a02:587:a407:da00:582f:8334:9cd9:7241])
        by smtp.gmail.com with ESMTPSA id j9sm95669383wrn.81.2019.08.05.10.01.01
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 05 Aug 2019 10:01:04 -0700 (PDT)
From:   Ard Biesheuvel <ard.biesheuvel@linaro.org>
To:     linux-crypto@vger.kernel.org
Cc:     herbert@gondor.apana.org.au, ebiggers@kernel.org,
        horia.geanta@nxp.com, Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: [PATCH v4 03/30] crypto: sparc/des - switch to new verification routines
Date:   Mon,  5 Aug 2019 20:00:10 +0300
Message-Id: <20190805170037.31330-4-ard.biesheuvel@linaro.org>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190805170037.31330-1-ard.biesheuvel@linaro.org>
References: <20190805170037.31330-1-ard.biesheuvel@linaro.org>
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
---
 arch/sparc/crypto/des_glue.c | 37 +++++++++-----------
 1 file changed, 16 insertions(+), 21 deletions(-)

diff --git a/arch/sparc/crypto/des_glue.c b/arch/sparc/crypto/des_glue.c
index 281448f72c90..5b631dc31497 100644
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
+static void crypto_des_encrypt(struct crypto_tfm *tfm, u8 *dst, const u8 *src)
 {
 	struct des_sparc64_ctx *ctx = crypto_tfm_ctx(tfm);
 	const u64 *K = ctx->encrypt_expkey;
@@ -76,7 +72,7 @@ static void des_encrypt(struct crypto_tfm *tfm, u8 *dst, const u8 *src)
 	des_sparc64_crypt(K, (const u64 *) src, (u64 *) dst);
 }
 
-static void des_decrypt(struct crypto_tfm *tfm, u8 *dst, const u8 *src)
+static void crypto_des_decrypt(struct crypto_tfm *tfm, u8 *dst, const u8 *src)
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
+static void crypto_des3_ede_encrypt(struct crypto_tfm *tfm, u8 *dst, const u8 *src)
 {
 	struct des3_ede_sparc64_ctx *ctx = crypto_tfm_ctx(tfm);
 	const u64 *K = ctx->encrypt_expkey;
@@ -243,7 +238,7 @@ static void des3_ede_encrypt(struct crypto_tfm *tfm, u8 *dst, const u8 *src)
 	des3_ede_sparc64_crypt(K, (const u64 *) src, (u64 *) dst);
 }
 
-static void des3_ede_decrypt(struct crypto_tfm *tfm, u8 *dst, const u8 *src)
+static void crypto_des3_ede_decrypt(struct crypto_tfm *tfm, u8 *dst, const u8 *src)
 {
 	struct des3_ede_sparc64_ctx *ctx = crypto_tfm_ctx(tfm);
 	const u64 *K = ctx->decrypt_expkey;
@@ -390,8 +385,8 @@ static struct crypto_alg algs[] = { {
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
@@ -447,8 +442,8 @@ static struct crypto_alg algs[] = { {
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
2.17.1


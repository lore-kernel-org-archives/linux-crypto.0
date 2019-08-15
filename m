Return-Path: <SRS0=pRBs=WL=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E32CCC433FF
	for <linux-crypto@archiver.kernel.org>; Thu, 15 Aug 2019 09:01:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A44DB218A6
	for <linux-crypto@archiver.kernel.org>; Thu, 15 Aug 2019 09:01:39 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="H3SVR/0O"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730768AbfHOJBj (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 15 Aug 2019 05:01:39 -0400
Received: from mail-wm1-f68.google.com ([209.85.128.68]:54480 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730786AbfHOJBi (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 15 Aug 2019 05:01:38 -0400
Received: by mail-wm1-f68.google.com with SMTP id p74so676850wme.4
        for <linux-crypto@vger.kernel.org>; Thu, 15 Aug 2019 02:01:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=OyPLTRp7SD/P3UDM/yCJek9q3VCge2ponsh/WCLUGJA=;
        b=H3SVR/0OmMet5MikolGAKkVhKuOiI6R7SSRrG8Gh7zx1Z3hYadvOh1rWVJnPl2yBvf
         TyxDYATF+BNU3D/OnGzkgnIvKVb/XNCbswWQ6q091Aj4s4IOjB/zPdDOpkVtU1QSotOU
         TIHF99l3Z1bndtSSgy3UDAUUJ4w8HsnHsoHc9HfngC6QPIxslP6ZG3mxgDQmSJ3C7jdZ
         8E2f5Uvdaiwi9ShRXfh5Al0+qrH0Iz27aXHmFE0xtRcmNRLb1ubNGIL7A3Sby7/Z/zwk
         ogjLaKEk5LVvzh+Bx0sVWbujEAKtVz3ZMemFPhBbtTqkiCu2DGuqOX+hIpBJpNlxs0qw
         xw4A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=OyPLTRp7SD/P3UDM/yCJek9q3VCge2ponsh/WCLUGJA=;
        b=QrljstHgscUgXuuPZlXuj29GMuIT+rckkXy0Y6U9I6hq0LvMzI8VbOB/+WzJm3cZXi
         ZiP0Md7ZdYTevFe9m/BQPLnnwgrxiThizwZUpDCmv0foDkjepQ1xwBBPqbFLB2HP3Drp
         Bb7h/eJaNx71z06p8T5mjwjdEiw9mp+5rk0vdbr30KzfxCtswc0uYvWrW3jZYrvMf28a
         qm9StrxLsAfyzbsnt8hU7Es0Exi7eI17jSR9Dg7YZCmIvhF7gTs3DiBvJSl6g7ObnkSg
         PjeWordKvReHmsG2OG6PKGjY+oKVTytKQct84z7sCnkbHqubYwZmmPcaaawVQyLzDIWk
         Y6+A==
X-Gm-Message-State: APjAAAUhJZCxfYU3w7faV6NG9NxXe/X/8kxCH/qcDJ+Btt/ZCXurfWmY
        yYFg3VQYBLzzEsut54lMk5XMBdVIWblj6Vca
X-Google-Smtp-Source: APXvYqykKUwRkBJUkI5NSnMnBZ9AAhwDy41aOQKf8KadMVBf3yFkCLuvahPWrMYSHViNegSEiKNG/w==
X-Received: by 2002:a7b:ca54:: with SMTP id m20mr705434wml.102.1565859695217;
        Thu, 15 Aug 2019 02:01:35 -0700 (PDT)
Received: from localhost.localdomain ([2a02:587:a407:da00:f1b5:e68c:5f7f:79e7])
        by smtp.gmail.com with ESMTPSA id x20sm3857533wrg.10.2019.08.15.02.01.33
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 15 Aug 2019 02:01:34 -0700 (PDT)
From:   Ard Biesheuvel <ard.biesheuvel@linaro.org>
To:     linux-crypto@vger.kernel.org
Cc:     herbert@gondor.apana.org.au,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        Horia Geanta <horia.geanta@nxp.com>
Subject: [PATCH v5 06/30] crypto: caam/des - switch to new verification routines
Date:   Thu, 15 Aug 2019 12:00:48 +0300
Message-Id: <20190815090112.9377-7-ard.biesheuvel@linaro.org>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190815090112.9377-1-ard.biesheuvel@linaro.org>
References: <20190815090112.9377-1-ard.biesheuvel@linaro.org>
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Cc: Horia Geanta <horia.geanta@nxp.com>
Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
---
 drivers/crypto/caam/caamalg.c     | 49 ++++++--------------
 drivers/crypto/caam/caamalg_qi.c  | 36 +++-----------
 drivers/crypto/caam/caamalg_qi2.c | 36 +++++---------
 drivers/crypto/caam/compat.h      |  2 +-
 4 files changed, 31 insertions(+), 92 deletions(-)

diff --git a/drivers/crypto/caam/caamalg.c b/drivers/crypto/caam/caamalg.c
index 947ba8ef487a..3e2662cda9fd 100644
--- a/drivers/crypto/caam/caamalg.c
+++ b/drivers/crypto/caam/caamalg.c
@@ -628,33 +628,17 @@ static int des3_aead_setkey(struct crypto_aead *aead, const u8 *key,
 			    unsigned int keylen)
 {
 	struct crypto_authenc_keys keys;
-	u32 flags;
 	int err;
 
 	err = crypto_authenc_extractkeys(&keys, key, keylen);
 	if (unlikely(err))
-		goto badkey;
-
-	err = -EINVAL;
-	if (keys.enckeylen != DES3_EDE_KEY_SIZE)
-		goto badkey;
-
-	flags = crypto_aead_get_flags(aead);
-	err = __des3_verify_key(&flags, keys.enckey);
-	if (unlikely(err)) {
-		crypto_aead_set_flags(aead, flags);
-		goto out;
-	}
+		return err;
 
-	err = aead_setkey(aead, key, keylen);
+	err = verify_aead_des3_key(aead, keys.enckey, keys.enckeylen) ?:
+	      aead_setkey(aead, key, keylen);
 
-out:
 	memzero_explicit(&keys, sizeof(keys));
 	return err;
-
-badkey:
-	crypto_aead_set_flags(aead, CRYPTO_TFM_RES_BAD_KEY_LEN);
-	goto out;
 }
 
 static int gcm_setkey(struct crypto_aead *aead,
@@ -843,22 +827,15 @@ static int arc4_skcipher_setkey(struct crypto_skcipher *skcipher,
 static int des_skcipher_setkey(struct crypto_skcipher *skcipher,
 			       const u8 *key, unsigned int keylen)
 {
-	u32 tmp[DES3_EDE_EXPKEY_WORDS];
-	struct crypto_tfm *tfm = crypto_skcipher_tfm(skcipher);
-
-	if (keylen == DES3_EDE_KEY_SIZE &&
-	    __des3_ede_setkey(tmp, &tfm->crt_flags, key, DES3_EDE_KEY_SIZE)) {
-		return -EINVAL;
-	}
-
-	if (!des_ekey(tmp, key) && (crypto_skcipher_get_flags(skcipher) &
-	    CRYPTO_TFM_REQ_FORBID_WEAK_KEYS)) {
-		crypto_skcipher_set_flags(skcipher,
-					  CRYPTO_TFM_RES_WEAK_KEY);
-		return -EINVAL;
-	}
+	return verify_skcipher_des_key(skcipher, key) ?:
+	       skcipher_setkey(skcipher, key, keylen, 0);
+}
 
-	return skcipher_setkey(skcipher, key, keylen, 0);
+static int des3_skcipher_setkey(struct crypto_skcipher *skcipher,
+				const u8 *key, unsigned int keylen)
+{
+	return verify_skcipher_des3_key(skcipher, key) ?:
+	       skcipher_setkey(skcipher, key, keylen, 0);
 }
 
 static int xts_skcipher_setkey(struct crypto_skcipher *skcipher, const u8 *key,
@@ -1954,7 +1931,7 @@ static struct caam_skcipher_alg driver_algs[] = {
 				.cra_driver_name = "cbc-3des-caam",
 				.cra_blocksize = DES3_EDE_BLOCK_SIZE,
 			},
-			.setkey = des_skcipher_setkey,
+			.setkey = des3_skcipher_setkey,
 			.encrypt = skcipher_encrypt,
 			.decrypt = skcipher_decrypt,
 			.min_keysize = DES3_EDE_KEY_SIZE,
@@ -2073,7 +2050,7 @@ static struct caam_skcipher_alg driver_algs[] = {
 				.cra_driver_name = "ecb-des3-caam",
 				.cra_blocksize = DES3_EDE_BLOCK_SIZE,
 			},
-			.setkey = des_skcipher_setkey,
+			.setkey = des3_skcipher_setkey,
 			.encrypt = skcipher_encrypt,
 			.decrypt = skcipher_decrypt,
 			.min_keysize = DES3_EDE_KEY_SIZE,
diff --git a/drivers/crypto/caam/caamalg_qi.c b/drivers/crypto/caam/caamalg_qi.c
index 59b59f5e9550..23dfdbc1d30f 100644
--- a/drivers/crypto/caam/caamalg_qi.c
+++ b/drivers/crypto/caam/caamalg_qi.c
@@ -278,33 +278,17 @@ static int des3_aead_setkey(struct crypto_aead *aead, const u8 *key,
 			    unsigned int keylen)
 {
 	struct crypto_authenc_keys keys;
-	u32 flags;
 	int err;
 
 	err = crypto_authenc_extractkeys(&keys, key, keylen);
 	if (unlikely(err))
-		goto badkey;
-
-	err = -EINVAL;
-	if (keys.enckeylen != DES3_EDE_KEY_SIZE)
-		goto badkey;
-
-	flags = crypto_aead_get_flags(aead);
-	err = __des3_verify_key(&flags, keys.enckey);
-	if (unlikely(err)) {
-		crypto_aead_set_flags(aead, flags);
-		goto out;
-	}
+		return err;
 
-	err = aead_setkey(aead, key, keylen);
+	err = verify_aead_des3_key(aead, keys.enckey, keys.enckeylen) ?:
+	      aead_setkey(aead, key, keylen);
 
-out:
 	memzero_explicit(&keys, sizeof(keys));
 	return err;
-
-badkey:
-	crypto_aead_set_flags(aead, CRYPTO_TFM_RES_BAD_KEY_LEN);
-	goto out;
 }
 
 static int gcm_set_sh_desc(struct crypto_aead *aead)
@@ -745,23 +729,15 @@ static int ctr_skcipher_setkey(struct crypto_skcipher *skcipher,
 static int des3_skcipher_setkey(struct crypto_skcipher *skcipher,
 				const u8 *key, unsigned int keylen)
 {
-	return unlikely(des3_verify_key(skcipher, key)) ?:
+	return verify_skcipher_des3_key(skcipher, key) ?:
 	       skcipher_setkey(skcipher, key, keylen, 0);
 }
 
 static int des_skcipher_setkey(struct crypto_skcipher *skcipher,
 			       const u8 *key, unsigned int keylen)
 {
-	u32 tmp[DES_EXPKEY_WORDS];
-
-	if (!des_ekey(tmp, key) && (crypto_skcipher_get_flags(skcipher) &
-	    CRYPTO_TFM_REQ_FORBID_WEAK_KEYS)) {
-		crypto_skcipher_set_flags(skcipher,
-					  CRYPTO_TFM_RES_WEAK_KEY);
-		return -EINVAL;
-	}
-
-	return skcipher_setkey(skcipher, key, keylen, 0);
+	return verify_skcipher_des_key(skcipher, key) ?:
+	       skcipher_setkey(skcipher, key, keylen, 0);
 }
 
 static int xts_skcipher_setkey(struct crypto_skcipher *skcipher, const u8 *key,
diff --git a/drivers/crypto/caam/caamalg_qi2.c b/drivers/crypto/caam/caamalg_qi2.c
index bd01bcd799e8..3443f6d6dd83 100644
--- a/drivers/crypto/caam/caamalg_qi2.c
+++ b/drivers/crypto/caam/caamalg_qi2.c
@@ -322,7 +322,6 @@ static int des3_aead_setkey(struct crypto_aead *aead, const u8 *key,
 			    unsigned int keylen)
 {
 	struct crypto_authenc_keys keys;
-	u32 flags;
 	int err;
 
 	err = crypto_authenc_extractkeys(&keys, key, keylen);
@@ -333,14 +332,8 @@ static int des3_aead_setkey(struct crypto_aead *aead, const u8 *key,
 	if (keys.enckeylen != DES3_EDE_KEY_SIZE)
 		goto badkey;
 
-	flags = crypto_aead_get_flags(aead);
-	err = __des3_verify_key(&flags, keys.enckey);
-	if (unlikely(err)) {
-		crypto_aead_set_flags(aead, flags);
-		goto out;
-	}
-
-	err = aead_setkey(aead, key, keylen);
+	err = crypto_des3_ede_verify_key(crypto_aead_tfm(aead), keys.enckey) ?:
+	      aead_setkey(aead, key, keylen);
 
 out:
 	memzero_explicit(&keys, sizeof(keys));
@@ -1070,22 +1063,15 @@ static int chacha20_skcipher_setkey(struct crypto_skcipher *skcipher,
 static int des_skcipher_setkey(struct crypto_skcipher *skcipher,
 			       const u8 *key, unsigned int keylen)
 {
-	u32 tmp[DES3_EDE_EXPKEY_WORDS];
-	struct crypto_tfm *tfm = crypto_skcipher_tfm(skcipher);
-
-	if (keylen == DES3_EDE_KEY_SIZE &&
-	    __des3_ede_setkey(tmp, &tfm->crt_flags, key, DES3_EDE_KEY_SIZE)) {
-		return -EINVAL;
-	}
-
-	if (!des_ekey(tmp, key) && (crypto_skcipher_get_flags(skcipher) &
-	    CRYPTO_TFM_REQ_FORBID_WEAK_KEYS)) {
-		crypto_skcipher_set_flags(skcipher,
-					  CRYPTO_TFM_RES_WEAK_KEY);
-		return -EINVAL;
-	}
+	return verify_skcipher_des_key(skcipher, key) ?:
+	       skcipher_setkey(skcipher, key, keylen, 0);
+}
 
-	return skcipher_setkey(skcipher, key, keylen, 0);
+static int des3_skcipher_setkey(struct crypto_skcipher *skcipher,
+			        const u8 *key, unsigned int keylen)
+{
+	return verify_skcipher_des3_key(skcipher, key) ?:
+	       skcipher_setkey(skcipher, key, keylen, 0);
 }
 
 static int xts_skcipher_setkey(struct crypto_skcipher *skcipher, const u8 *key,
@@ -1634,7 +1620,7 @@ static struct caam_skcipher_alg driver_algs[] = {
 				.cra_driver_name = "cbc-3des-caam-qi2",
 				.cra_blocksize = DES3_EDE_BLOCK_SIZE,
 			},
-			.setkey = des_skcipher_setkey,
+			.setkey = des3_skcipher_setkey,
 			.encrypt = skcipher_encrypt,
 			.decrypt = skcipher_decrypt,
 			.min_keysize = DES3_EDE_KEY_SIZE,
diff --git a/drivers/crypto/caam/compat.h b/drivers/crypto/caam/compat.h
index 8639b2df0371..60e2a54c19f1 100644
--- a/drivers/crypto/caam/compat.h
+++ b/drivers/crypto/caam/compat.h
@@ -32,7 +32,7 @@
 #include <crypto/null.h>
 #include <crypto/aes.h>
 #include <crypto/ctr.h>
-#include <crypto/des.h>
+#include <crypto/internal/des.h>
 #include <crypto/gcm.h>
 #include <crypto/sha.h>
 #include <crypto/md5.h>
-- 
2.17.1


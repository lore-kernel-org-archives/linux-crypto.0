Return-Path: <SRS0=2Ix1=WB=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2E366C433FF
	for <linux-crypto@archiver.kernel.org>; Mon,  5 Aug 2019 17:01:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id EC8182147A
	for <linux-crypto@archiver.kernel.org>; Mon,  5 Aug 2019 17:01:20 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="AhBzHp5W"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726693AbfHERBU (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 5 Aug 2019 13:01:20 -0400
Received: from mail-wr1-f68.google.com ([209.85.221.68]:43140 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728837AbfHERBU (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 5 Aug 2019 13:01:20 -0400
Received: by mail-wr1-f68.google.com with SMTP id p13so10569775wru.10
        for <linux-crypto@vger.kernel.org>; Mon, 05 Aug 2019 10:01:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=aIqb06WnXywRgFtmsJq9WcxVFMYjcVLwHYMd8Hx3xAQ=;
        b=AhBzHp5W+qL03ZU5fpGSbBLYOjrH/keJ/5u+CdncRrvMuvD+uGH3KTTj/ZYYcYApdo
         VtpqjQmuMIiT48AT4InUpBjQwABJXggb9igeRxtogjeAw1AcJSUsbW0D6kznPf5nzS62
         urKv7tWY0xQI9PTVggr3EYmtcfR8rzktx6pa/FzXsoGh5U0gudBlTX3jNYqwDSw/NLdg
         cTa88B5WmnLilUCbM0KrEtLyNFgxuqWw9+kDLwlcRdqKHGetL3RMt0RlCv/JryJM2/0T
         wx+QEtot2NxHvrTIkOkKI+J+m8NTgPVYVmTr5I6EzfBq0PBCrYrV/JojWGJN68WuUwQb
         4KIA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=aIqb06WnXywRgFtmsJq9WcxVFMYjcVLwHYMd8Hx3xAQ=;
        b=KLtD59danDIjwSurv+PQmapUC1mVbHliMxdq9Dr8Je9G9aN/b1EKqSoMAYXs9QHgFn
         A8RTKk9h4m9vwCPGhd5X1Jwf+ap2QfBdLM16JgOxefL5j+S4Plk1dD/OImxV6jZr5AY0
         KzhnGluwItu1WLvRUWAVM+pbfJinINnM+nvUEsJ80a/e8S0n+GTKFAOO2W4c2tVWclbK
         dsQUWJT3arj/WDFeHNR9OHr4bUjZbqJ6VywRYHI9f1j14GqqzdDbECTMurZklVtUkrUM
         DJ9rekqxvJ4Sy2TIIeYNphRlqMv0WU8NBDTE/wu+iJ09OrXIpGGFvSS9729lM2fjxRAT
         W9MA==
X-Gm-Message-State: APjAAAUFtXqfTw8O3mFfIIiGG7LXpUuKT9MNG18LaCogn07vBfxxK5/a
        cPE7X8FkpTda3A9S4V0csB0gW748E0wuNw==
X-Google-Smtp-Source: APXvYqySSFIM4IyIMQgBWzNtHaQwsjEEI0+esxhKhpw48uTyly27c1kztCM88iOK7yt4qQgxOF4/7Q==
X-Received: by 2002:adf:e343:: with SMTP id n3mr125255358wrj.103.1565024477186;
        Mon, 05 Aug 2019 10:01:17 -0700 (PDT)
Received: from localhost.localdomain ([2a02:587:a407:da00:582f:8334:9cd9:7241])
        by smtp.gmail.com with ESMTPSA id j9sm95669383wrn.81.2019.08.05.10.01.13
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 05 Aug 2019 10:01:16 -0700 (PDT)
From:   Ard Biesheuvel <ard.biesheuvel@linaro.org>
To:     linux-crypto@vger.kernel.org
Cc:     herbert@gondor.apana.org.au, ebiggers@kernel.org,
        horia.geanta@nxp.com, Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: [PATCH v4 06/30] crypto: caam/des - switch to new verification routines
Date:   Mon,  5 Aug 2019 20:00:13 +0300
Message-Id: <20190805170037.31330-7-ard.biesheuvel@linaro.org>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190805170037.31330-1-ard.biesheuvel@linaro.org>
References: <20190805170037.31330-1-ard.biesheuvel@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Tested-by: Horia Geantă <horia.geanta@nxp.com>
Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
---
 drivers/crypto/caam/caamalg.c     | 38 +++++++-------------
 drivers/crypto/caam/caamalg_qi.c  | 13 ++-----
 drivers/crypto/caam/caamalg_qi2.c | 13 ++-----
 drivers/crypto/caam/compat.h      |  2 +-
 4 files changed, 19 insertions(+), 47 deletions(-)

diff --git a/drivers/crypto/caam/caamalg.c b/drivers/crypto/caam/caamalg.c
index 43f18253e5b6..9a9a55263b17 100644
--- a/drivers/crypto/caam/caamalg.c
+++ b/drivers/crypto/caam/caamalg.c
@@ -633,7 +633,6 @@ static int des3_aead_setkey(struct crypto_aead *aead, const u8 *key,
 			    unsigned int keylen)
 {
 	struct crypto_authenc_keys keys;
-	u32 flags;
 	int err;
 
 	err = crypto_authenc_extractkeys(&keys, key, keylen);
@@ -644,14 +643,8 @@ static int des3_aead_setkey(struct crypto_aead *aead, const u8 *key,
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
@@ -785,22 +778,15 @@ static int skcipher_setkey(struct crypto_skcipher *skcipher, const u8 *key,
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
+	return crypto_des_verify_key(crypto_skcipher_tfm(skcipher), key) ?:
+	       skcipher_setkey(skcipher, key, keylen);
+}
 
-	return skcipher_setkey(skcipher, key, keylen);
+static int des3_skcipher_setkey(struct crypto_skcipher *skcipher,
+				const u8 *key, unsigned int keylen)
+{
+	return crypto_des3_ede_verify_key(crypto_skcipher_tfm(skcipher), key) ?:
+	       skcipher_setkey(skcipher, key, keylen);
 }
 
 static int xts_skcipher_setkey(struct crypto_skcipher *skcipher, const u8 *key,
@@ -1899,7 +1885,7 @@ static struct caam_skcipher_alg driver_algs[] = {
 				.cra_driver_name = "cbc-3des-caam",
 				.cra_blocksize = DES3_EDE_BLOCK_SIZE,
 			},
-			.setkey = des_skcipher_setkey,
+			.setkey = des3_skcipher_setkey,
 			.encrypt = skcipher_encrypt,
 			.decrypt = skcipher_decrypt,
 			.min_keysize = DES3_EDE_KEY_SIZE,
@@ -2018,7 +2004,7 @@ static struct caam_skcipher_alg driver_algs[] = {
 				.cra_driver_name = "ecb-des3-caam",
 				.cra_blocksize = DES3_EDE_BLOCK_SIZE,
 			},
-			.setkey = des_skcipher_setkey,
+			.setkey = des3_skcipher_setkey,
 			.encrypt = skcipher_encrypt,
 			.decrypt = skcipher_decrypt,
 			.min_keysize = DES3_EDE_KEY_SIZE,
diff --git a/drivers/crypto/caam/caamalg_qi.c b/drivers/crypto/caam/caamalg_qi.c
index 32f0f8a72067..b3868c996af8 100644
--- a/drivers/crypto/caam/caamalg_qi.c
+++ b/drivers/crypto/caam/caamalg_qi.c
@@ -296,7 +296,6 @@ static int des3_aead_setkey(struct crypto_aead *aead, const u8 *key,
 			    unsigned int keylen)
 {
 	struct crypto_authenc_keys keys;
-	u32 flags;
 	int err;
 
 	err = crypto_authenc_extractkeys(&keys, key, keylen);
@@ -307,14 +306,8 @@ static int des3_aead_setkey(struct crypto_aead *aead, const u8 *key,
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
@@ -697,7 +690,7 @@ static int skcipher_setkey(struct crypto_skcipher *skcipher, const u8 *key,
 static int des3_skcipher_setkey(struct crypto_skcipher *skcipher,
 				const u8 *key, unsigned int keylen)
 {
-	return unlikely(des3_verify_key(skcipher, key)) ?:
+	return crypto_des3_ede_verify_key(crypto_skcipher_tfm(skcipher), key) ?:
 	       skcipher_setkey(skcipher, key, keylen);
 }
 
diff --git a/drivers/crypto/caam/caamalg_qi2.c b/drivers/crypto/caam/caamalg_qi2.c
index a78a36dfa7b9..66a11ef7fd96 100644
--- a/drivers/crypto/caam/caamalg_qi2.c
+++ b/drivers/crypto/caam/caamalg_qi2.c
@@ -330,7 +330,6 @@ static int des3_aead_setkey(struct crypto_aead *aead, const u8 *key,
 			    unsigned int keylen)
 {
 	struct crypto_authenc_keys keys;
-	u32 flags;
 	int err;
 
 	err = crypto_authenc_extractkeys(&keys, key, keylen);
@@ -341,14 +340,8 @@ static int des3_aead_setkey(struct crypto_aead *aead, const u8 *key,
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
@@ -1000,7 +993,7 @@ static int skcipher_setkey(struct crypto_skcipher *skcipher, const u8 *key,
 static int des3_skcipher_setkey(struct crypto_skcipher *skcipher,
 				const u8 *key, unsigned int keylen)
 {
-	return unlikely(des3_verify_key(skcipher, key)) ?:
+	return crypto_des3_ede_verify_key(crypto_skcipher_tfm(skcipher), key) ?:
 	       skcipher_setkey(skcipher, key, keylen);
 }
 
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


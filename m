Return-Path: <SRS0=RljO=UV=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BDFD5C48BE3
	for <linux-crypto@archiver.kernel.org>; Sat, 22 Jun 2019 00:31:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 89C792084E
	for <linux-crypto@archiver.kernel.org>; Sat, 22 Jun 2019 00:31:54 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="EDjNFtut"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726147AbfFVAby (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 21 Jun 2019 20:31:54 -0400
Received: from mail-wr1-f68.google.com ([209.85.221.68]:41549 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726101AbfFVAbx (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 21 Jun 2019 20:31:53 -0400
Received: by mail-wr1-f68.google.com with SMTP id c2so8100406wrm.8
        for <linux-crypto@vger.kernel.org>; Fri, 21 Jun 2019 17:31:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Px2Laz9uqyJKRzB3E2oP9MkftSsMAPig3kr3f5zcU1g=;
        b=EDjNFtutREH1DmcAqkCwjBX7nI9qAIkpsKYWQa+zHqTmiiWqwQAN3apYIosgS6sGRt
         UjZWuUgOSwu/AtUnLh/bzz8zXCq+ggBneQ8R0mRbG72gVfeM+FMVOHl4luomR7cIEVRK
         4pchiBalyXTxVjbWPgVWSIfUhpr7GotSsjJffDYXPzrB3pGtwpXsRgItkstsRhJR2yV2
         SU5VZKlryEVfOJ+h98aRo4u+dqpTHmsyfnh2T7It6R0IPipAhh7UG0meQ9NByacXa9dL
         jZpj5Fe6Sfq9XQJpVKxHja3AvEBDSxUTE+fVSTsVhqtbsHB1qLfORbWBnkxlhK426QzC
         AFFQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Px2Laz9uqyJKRzB3E2oP9MkftSsMAPig3kr3f5zcU1g=;
        b=sekG4dpUADPkV5QAk6HTOiwPWchdK09YEIhZBpi1JbPkOa6NsRGkVbNA2P1EjCA5vg
         E/nbepKKEv9woCbCzVsA1Jy82u5A56+jd/A6x6cVNNVptRj6NNi1MbXqhUlhHwa6udbK
         8fnJqRhFJuSqZf/v1dUA5nyA9jte3oUuvfjYxqLisugyWAGKNXVCibuc7WVsFUP2jpT1
         dkWU71GMpDORrtl7WyH+g7BCDDCvPLKJMKy1hy1El21iRByn8Jd9lqhMoQcatXqd+nev
         052PsdftV9iG/lvDExyxslnneNoT9QbTfP4UqGgFZdq4kLlbVp9fOnZWLctQJnCa4Dxq
         qZGg==
X-Gm-Message-State: APjAAAVl9R1094tC38oSl0TXptSq93xLGJZa/tM7HixsPRUsD68voaoO
        w23jV+2bkA1hs9oPPoE5pN4n2OzLvztyh5Vw
X-Google-Smtp-Source: APXvYqwCOlPGhwpN595nds5U14LRFkMj5jK4G2xHaGJ9oQX8rHP0ovo8HoUN1HBT276yxRFzQJ27/g==
X-Received: by 2002:a5d:6a05:: with SMTP id m5mr1801942wru.161.1561163510711;
        Fri, 21 Jun 2019 17:31:50 -0700 (PDT)
Received: from sudo.home ([2a01:cb1d:112:6f00:99d4:1ff0:ed6:dfbb])
        by smtp.gmail.com with ESMTPSA id v18sm4792019wrd.51.2019.06.21.17.31.49
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 21 Jun 2019 17:31:49 -0700 (PDT)
From:   Ard Biesheuvel <ard.biesheuvel@linaro.org>
To:     linux-crypto@vger.kernel.org
Cc:     herbert@gondor.apana.org.au, ebiggers@google.com,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: [RFC PATCH 06/30] crypto: caam/des - switch to new verification routines
Date:   Sat, 22 Jun 2019 02:30:48 +0200
Message-Id: <20190622003112.31033-7-ard.biesheuvel@linaro.org>
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
 drivers/crypto/caam/caamalg.c     | 13 +++--------
 drivers/crypto/caam/caamalg_qi.c  | 23 ++++++++++----------
 drivers/crypto/caam/caamalg_qi2.c | 23 ++++++++++----------
 drivers/crypto/caam/compat.h      |  2 +-
 4 files changed, 26 insertions(+), 35 deletions(-)

diff --git a/drivers/crypto/caam/caamalg.c b/drivers/crypto/caam/caamalg.c
index 5d4fa65a015f..b4ab64146b21 100644
--- a/drivers/crypto/caam/caamalg.c
+++ b/drivers/crypto/caam/caamalg.c
@@ -633,23 +633,16 @@ static int des3_aead_setkey(struct crypto_aead *aead, const u8 *key,
 			    unsigned int keylen)
 {
 	struct crypto_authenc_keys keys;
-	u32 flags;
 	int err;
 
 	err = crypto_authenc_extractkeys(&keys, key, keylen);
 	if (unlikely(err))
 		goto badkey;
 
-	err = -EINVAL;
-	if (keys.enckeylen != DES3_EDE_KEY_SIZE)
-		goto badkey;
-
-	flags = crypto_aead_get_flags(aead);
-	err = __des3_verify_key(&flags, keys.enckey);
-	if (unlikely(err)) {
-		crypto_aead_set_flags(aead, flags);
+	err = crypto_des3_ede_verify_key(crypto_aead_tfm(tfm), keys.enckey,
+					 keys.enckeylen);
+	if (unlikely(err))
 		goto out;
-	}
 
 	err = aead_setkey(aead, key, keylen);
 
diff --git a/drivers/crypto/caam/caamalg_qi.c b/drivers/crypto/caam/caamalg_qi.c
index 32f0f8a72067..01d92ef0142a 100644
--- a/drivers/crypto/caam/caamalg_qi.c
+++ b/drivers/crypto/caam/caamalg_qi.c
@@ -296,23 +296,16 @@ static int des3_aead_setkey(struct crypto_aead *aead, const u8 *key,
 			    unsigned int keylen)
 {
 	struct crypto_authenc_keys keys;
-	u32 flags;
 	int err;
 
 	err = crypto_authenc_extractkeys(&keys, key, keylen);
 	if (unlikely(err))
 		goto badkey;
 
-	err = -EINVAL;
-	if (keys.enckeylen != DES3_EDE_KEY_SIZE)
-		goto badkey;
-
-	flags = crypto_aead_get_flags(aead);
-	err = __des3_verify_key(&flags, keys.enckey);
-	if (unlikely(err)) {
-		crypto_aead_set_flags(aead, flags);
+	err = crypto_des3_ede_verify_key(crypto_aead_tfm(aead), keys.enckey,
+					 keys.enckeylen);
+	if (unlikely(err))
 		goto out;
-	}
 
 	err = aead_setkey(aead, key, keylen);
 
@@ -697,8 +690,14 @@ static int skcipher_setkey(struct crypto_skcipher *skcipher, const u8 *key,
 static int des3_skcipher_setkey(struct crypto_skcipher *skcipher,
 				const u8 *key, unsigned int keylen)
 {
-	return unlikely(des3_verify_key(skcipher, key)) ?:
-	       skcipher_setkey(skcipher, key, keylen);
+	int err;
+
+	err = crypto_des3_ede_verify_key(crypto_skcipher_tfm(skcipher), key,
+					 keylen);
+	if (unlikely(err))
+		return err;
+
+	return skcipher_setkey(skcipher, key, keylen);
 }
 
 static int xts_skcipher_setkey(struct crypto_skcipher *skcipher, const u8 *key,
diff --git a/drivers/crypto/caam/caamalg_qi2.c b/drivers/crypto/caam/caamalg_qi2.c
index 06bf32c32cbd..074fbb8356e5 100644
--- a/drivers/crypto/caam/caamalg_qi2.c
+++ b/drivers/crypto/caam/caamalg_qi2.c
@@ -329,23 +329,16 @@ static int des3_aead_setkey(struct crypto_aead *aead, const u8 *key,
 			    unsigned int keylen)
 {
 	struct crypto_authenc_keys keys;
-	u32 flags;
 	int err;
 
 	err = crypto_authenc_extractkeys(&keys, key, keylen);
 	if (unlikely(err))
 		goto badkey;
 
-	err = -EINVAL;
-	if (keys.enckeylen != DES3_EDE_KEY_SIZE)
-		goto badkey;
-
-	flags = crypto_aead_get_flags(aead);
-	err = __des3_verify_key(&flags, keys.enckey);
-	if (unlikely(err)) {
-		crypto_aead_set_flags(aead, flags);
+	err = crypto_des3_ede_verify_key(crypto_aead_tfm(aead), keys.enckey,
+					 keys.enckeylen);
+	if (unlikely(err))
 		goto out;
-	}
 
 	err = aead_setkey(aead, key, keylen);
 
@@ -999,8 +992,14 @@ static int skcipher_setkey(struct crypto_skcipher *skcipher, const u8 *key,
 static int des3_skcipher_setkey(struct crypto_skcipher *skcipher,
 				const u8 *key, unsigned int keylen)
 {
-	return unlikely(des3_verify_key(skcipher, key)) ?:
-	       skcipher_setkey(skcipher, key, keylen);
+	int err;
+
+	err = crypto_des3_ede_verify_key(crypto_skcipher_tfm(skcipher), key,
+					 keylen);
+	if (unlikely(err))
+		return err;
+
+	return skcipher_setkey(skcipher, key, keylen);
 }
 
 static int xts_skcipher_setkey(struct crypto_skcipher *skcipher, const u8 *key,
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
2.20.1


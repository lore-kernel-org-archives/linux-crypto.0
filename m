Return-Path: <SRS0=me0G=UN=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 84893C31E4B
	for <linux-crypto@archiver.kernel.org>; Fri, 14 Jun 2019 08:34:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 530FB20851
	for <linux-crypto@archiver.kernel.org>; Fri, 14 Jun 2019 08:34:20 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="RMnBvrrG"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726429AbfFNIeT (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 14 Jun 2019 04:34:19 -0400
Received: from mail-wr1-f68.google.com ([209.85.221.68]:34154 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726530AbfFNIeT (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 14 Jun 2019 04:34:19 -0400
Received: by mail-wr1-f68.google.com with SMTP id k11so1591624wrl.1
        for <linux-crypto@vger.kernel.org>; Fri, 14 Jun 2019 01:34:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=dQGze1de3iuv2PgR54rqY+1G9v4+tWZHityhL+j8Two=;
        b=RMnBvrrGKo2YiaFFi80CITYkCrIZGN2v6ztzF87/44+XA+mL7doQXJq9Fu11FRAMVM
         ZA45RbDgsGNGTFrSDk98a50fNrx1yHF2/EWqBz9/P+gSLgSv54smG3QZpYcbfQkMBIqo
         JPxN8S0rSQagFHF762GaIhcxdATr8K+lQ+gMuq1nyRswAwD/bHaGzOAvJ3z98L9svLA8
         EdNb8m5haWCGn7yWu/445PBY7KcovQzEiobkd1mmuKmOj+E/IO8SF9mYE/mcSBJAV3DT
         6F1FG+GXS+UDQTKBFm43F1o+NWPzQFF34AS7YqShteWjBAFejXR9CvTWZqbWtC5ChAZD
         UXaA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=dQGze1de3iuv2PgR54rqY+1G9v4+tWZHityhL+j8Two=;
        b=BfrQirFOS/CYnRcHB6lmutD9fMNikOhHCcADxwbFOX26Hlj4EGvvEwdzEJ6yrR8vOs
         3ytR648H2Il/KtGfOh9ylNf6Vxw5b+QPt9lAbhq5by1MC7hOMZa2iOq4CgczKS0xDynw
         4DN4CtzPFhU91PPSW23p1yyOT7qwpQwTiaps6RWWYmm7GDn6aGsEnMvBS8YnoRXXpGhy
         PTAStapYa58gch/yLykANhoPDGiVrcx+3x/UJRplhnznPDUQ6ogQK2jbY3yXZnOjYx15
         HhK4iEp4vhamyt4a8JDK75/wenMAIOKIbfCdlc9U7YKI136e9SenkqCkZ2A3gF9mKIdT
         WN/Q==
X-Gm-Message-State: APjAAAW/t+Kmt+CedR9+271hyt+djRwq+sxTkqcTuSlLOTJXD6mY9h8v
        NY40gJFiUGHu3PRMmx3TgRQvcB1b46H3dQ==
X-Google-Smtp-Source: APXvYqz4+WLmDL683bb+Hi0IhjLYQTrFwTMl2MxTXKJE4R+vpJkUW2HCIi7mk9Dm0i5uwgqXB2+Log==
X-Received: by 2002:adf:f84a:: with SMTP id d10mr4185071wrq.319.1560501256818;
        Fri, 14 Jun 2019 01:34:16 -0700 (PDT)
Received: from sudo.home ([2a01:cb1d:112:6f00:8d0e:a5b1:c005:e3b5])
        by smtp.gmail.com with ESMTPSA id f3sm1710802wre.93.2019.06.14.01.34.15
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 14 Jun 2019 01:34:16 -0700 (PDT)
From:   Ard Biesheuvel <ard.biesheuvel@linaro.org>
To:     linux-crypto@vger.kernel.org
Cc:     Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Eric Biggers <ebiggers@google.com>
Subject: [RFC PATCH 3/3] fscrypt: switch to ESSIV shash
Date:   Fri, 14 Jun 2019 10:34:04 +0200
Message-Id: <20190614083404.20514-4-ard.biesheuvel@linaro.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190614083404.20514-1-ard.biesheuvel@linaro.org>
References: <20190614083404.20514-1-ard.biesheuvel@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Instead of open coding the shash and cipher operations that make up
the ESSIV transform, switch to the new ESSIV shash template that
encapsulates all of this. Using this more abstract interface provides
more flexibility for the crypto subsystem to do refactoring, and
permits better testing.

Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
---
 fs/crypto/Kconfig           |  1 +
 fs/crypto/crypto.c          | 11 ++--
 fs/crypto/fscrypt_private.h |  4 +-
 fs/crypto/keyinfo.c         | 64 +++-----------------
 4 files changed, 18 insertions(+), 62 deletions(-)

diff --git a/fs/crypto/Kconfig b/fs/crypto/Kconfig
index 24ed99e2eca0..b0292da8613c 100644
--- a/fs/crypto/Kconfig
+++ b/fs/crypto/Kconfig
@@ -5,6 +5,7 @@ config FS_ENCRYPTION
 	select CRYPTO_AES
 	select CRYPTO_CBC
 	select CRYPTO_ECB
+	select CRYPTO_ESSIV
 	select CRYPTO_XTS
 	select CRYPTO_CTS
 	select CRYPTO_SHA256
diff --git a/fs/crypto/crypto.c b/fs/crypto/crypto.c
index 335a362ee446..93d33b55c2fa 100644
--- a/fs/crypto/crypto.c
+++ b/fs/crypto/crypto.c
@@ -137,8 +137,13 @@ void fscrypt_generate_iv(union fscrypt_iv *iv, u64 lblk_num,
 	if (ci->ci_flags & FS_POLICY_FLAG_DIRECT_KEY)
 		memcpy(iv->nonce, ci->ci_nonce, FS_KEY_DERIVATION_NONCE_SIZE);
 
-	if (ci->ci_essiv_tfm != NULL)
-		crypto_cipher_encrypt_one(ci->ci_essiv_tfm, iv->raw, iv->raw);
+	if (ci->ci_essiv_tfm != NULL) {
+		SHASH_DESC_ON_STACK(desc, ci->ci_essiv_tfm);
+
+		desc->tfm = ci->ci_essiv_tfm;
+		crypto_shash_digest(desc, (u8 *)&iv->lblk_num,
+				    sizeof(iv->lblk_num), iv->raw);
+	}
 }
 
 int fscrypt_do_page_crypto(const struct inode *inode, fscrypt_direction_t rw,
@@ -492,8 +497,6 @@ static void __exit fscrypt_exit(void)
 		destroy_workqueue(fscrypt_read_workqueue);
 	kmem_cache_destroy(fscrypt_ctx_cachep);
 	kmem_cache_destroy(fscrypt_info_cachep);
-
-	fscrypt_essiv_cleanup();
 }
 module_exit(fscrypt_exit);
 
diff --git a/fs/crypto/fscrypt_private.h b/fs/crypto/fscrypt_private.h
index 7da276159593..67ea4ca11474 100644
--- a/fs/crypto/fscrypt_private.h
+++ b/fs/crypto/fscrypt_private.h
@@ -62,10 +62,10 @@ struct fscrypt_info {
 	struct crypto_skcipher *ci_ctfm;
 
 	/*
-	 * Cipher for ESSIV IV generation.  Only set for CBC contents
+	 * Shash for ESSIV IV generation.  Only set for CBC contents
 	 * encryption, otherwise is NULL.
 	 */
-	struct crypto_cipher *ci_essiv_tfm;
+	struct crypto_shash *ci_essiv_tfm;
 
 	/*
 	 * Encryption mode used for this inode.  It corresponds to either
diff --git a/fs/crypto/keyinfo.c b/fs/crypto/keyinfo.c
index dcd91a3fbe49..c3d38f72506c 100644
--- a/fs/crypto/keyinfo.c
+++ b/fs/crypto/keyinfo.c
@@ -15,12 +15,10 @@
 #include <linux/ratelimit.h>
 #include <crypto/aes.h>
 #include <crypto/algapi.h>
+#include <crypto/hash.h>
 #include <crypto/sha.h>
-#include <crypto/skcipher.h>
 #include "fscrypt_private.h"
 
-static struct crypto_shash *essiv_hash_tfm;
-
 /* Table of keys referenced by FS_POLICY_FLAG_DIRECT_KEY policies */
 static DEFINE_HASHTABLE(fscrypt_master_keys, 6); /* 6 bits = 64 buckets */
 static DEFINE_SPINLOCK(fscrypt_master_keys_lock);
@@ -377,70 +375,24 @@ fscrypt_get_master_key(const struct fscrypt_info *ci, struct fscrypt_mode *mode,
 	return ERR_PTR(err);
 }
 
-static int derive_essiv_salt(const u8 *key, int keysize, u8 *salt)
-{
-	struct crypto_shash *tfm = READ_ONCE(essiv_hash_tfm);
-
-	/* init hash transform on demand */
-	if (unlikely(!tfm)) {
-		struct crypto_shash *prev_tfm;
-
-		tfm = crypto_alloc_shash("sha256", 0, 0);
-		if (IS_ERR(tfm)) {
-			fscrypt_warn(NULL,
-				     "error allocating SHA-256 transform: %ld",
-				     PTR_ERR(tfm));
-			return PTR_ERR(tfm);
-		}
-		prev_tfm = cmpxchg(&essiv_hash_tfm, NULL, tfm);
-		if (prev_tfm) {
-			crypto_free_shash(tfm);
-			tfm = prev_tfm;
-		}
-	}
-
-	{
-		SHASH_DESC_ON_STACK(desc, tfm);
-		desc->tfm = tfm;
-
-		return crypto_shash_digest(desc, key, keysize, salt);
-	}
-}
-
 static int init_essiv_generator(struct fscrypt_info *ci, const u8 *raw_key,
 				int keysize)
 {
 	int err;
-	struct crypto_cipher *essiv_tfm;
-	u8 salt[SHA256_DIGEST_SIZE];
-
-	essiv_tfm = crypto_alloc_cipher("aes", 0, 0);
-	if (IS_ERR(essiv_tfm))
-		return PTR_ERR(essiv_tfm);
-
-	ci->ci_essiv_tfm = essiv_tfm;
-
-	err = derive_essiv_salt(raw_key, keysize, salt);
-	if (err)
-		goto out;
+	struct crypto_shash *essiv_tfm;
 
 	/*
 	 * Using SHA256 to derive the salt/key will result in AES-256 being
 	 * used for IV generation. File contents encryption will still use the
 	 * configured keysize (AES-128) nevertheless.
 	 */
-	err = crypto_cipher_setkey(essiv_tfm, salt, sizeof(salt));
-	if (err)
-		goto out;
+	essiv_tfm = crypto_alloc_shash("essiv(aes,sha256)", 0, 0);
+	if (IS_ERR(essiv_tfm))
+		return PTR_ERR(essiv_tfm);
 
-out:
-	memzero_explicit(salt, sizeof(salt));
-	return err;
-}
+	ci->ci_essiv_tfm = essiv_tfm;
 
-void __exit fscrypt_essiv_cleanup(void)
-{
-	crypto_free_shash(essiv_hash_tfm);
+	return crypto_shash_setkey(essiv_tfm, raw_key, keysize);
 }
 
 /*
@@ -495,7 +447,7 @@ static void put_crypt_info(struct fscrypt_info *ci)
 		put_master_key(ci->ci_master_key);
 	} else {
 		crypto_free_skcipher(ci->ci_ctfm);
-		crypto_free_cipher(ci->ci_essiv_tfm);
+		crypto_free_shash(ci->ci_essiv_tfm);
 	}
 	kmem_cache_free(fscrypt_info_cachep, ci);
 }
-- 
2.20.1


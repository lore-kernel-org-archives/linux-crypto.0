Return-Path: <SRS0=1/ZA=UZ=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 44147C48BD6
	for <linux-crypto@archiver.kernel.org>; Wed, 26 Jun 2019 20:40:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 104D4208E3
	for <linux-crypto@archiver.kernel.org>; Wed, 26 Jun 2019 20:40:58 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="XrnuWSNN"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726440AbfFZUk5 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 26 Jun 2019 16:40:57 -0400
Received: from mail-wr1-f68.google.com ([209.85.221.68]:40347 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726359AbfFZUk5 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 26 Jun 2019 16:40:57 -0400
Received: by mail-wr1-f68.google.com with SMTP id p11so4269354wre.7
        for <linux-crypto@vger.kernel.org>; Wed, 26 Jun 2019 13:40:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=EdwcyrYKvFlRQfInLeYh/Y96ip8pVuH6VkdGJzNxS+E=;
        b=XrnuWSNNkW08C74+DGwDRNN3HBQvCzxpgTYZasn4brh9daF9IptDFD5eyDvkrAEqyM
         rQe+sGEnGTDz9rneK2BmCzOy9yxCueqMDWXXws68+JkbkAip/vQJhpLZlzMs3//K2KfL
         WJQyOWmGEyesXOx4z6d/HV2ML2aEZQ26KJxMlh7bT4YtSE9b1O8GHHmPVNzL7X8HZaiF
         Js5xYwLpUkMb+3uINqGwa5VwmSfgZ2CQ4+JMmUdvdLFh31HGHokLCSxnYQt9Bdc2ViDe
         qamnOr/Z+xc0UvLw8RKxGpbE3zbcebrmLl4MCIeRQA0vOKs3eY5oNEqDlrX/CJrBSv+m
         tz2A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=EdwcyrYKvFlRQfInLeYh/Y96ip8pVuH6VkdGJzNxS+E=;
        b=PMEH3Zn+OcWkpb7n9X1Q92fRXK4Vwl14mddD/KuJVVXpZzzVikHnA2A0X9U9VQIeur
         X2eMMKUNl0JHLg4o1L1u8CnNoe4UZE2BKacNnZOFWjgEiAQXzGhrTo7ri5wkU37RiiN9
         yFn1IP3auBdWMZqluz2vDiEnKV5v4bZPNFIol6YasqrxAgToUCb85x8cR3grGHSBgXlm
         tFpRdyxSyF7h1clztm8iTGSpxsKL7ekh3dI7mt2tPlHpF/4S4g6e6ZDBJoBwKuawe9nb
         AWv5u0BIhQiHt8wAmmSmSzI90KcMVBSsAF0kcnR9cy7Ky4XgB6K5iGy4n/Y1IPu7B+PB
         SAig==
X-Gm-Message-State: APjAAAXdwk1ZlU0dDqFAr1O6+ahUY94PNG3UjZ7CCSvrHFyzjywUHBBb
        ZhoC3Hzao9CVBanvtRTm/3kD3aMsVFnR2w==
X-Google-Smtp-Source: APXvYqzCFmBc+5O1mjQ1vVozCOpx2h6TXOgYwrbQsDwIasxDQgqlV9mgNBYJKBbZ1M8qFLv1b3o9ZA==
X-Received: by 2002:a5d:5303:: with SMTP id e3mr4937859wrv.239.1561581654177;
        Wed, 26 Jun 2019 13:40:54 -0700 (PDT)
Received: from sudo.home ([2a01:cb1d:112:6f00:9c7f:f574:ee94:7dec])
        by smtp.gmail.com with ESMTPSA id 32sm35164587wra.35.2019.06.26.13.40.52
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 26 Jun 2019 13:40:53 -0700 (PDT)
From:   Ard Biesheuvel <ard.biesheuvel@linaro.org>
To:     linux-crypto@vger.kernel.org
Cc:     linux-arm-kernel@lists.infradead.org,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Eric Biggers <ebiggers@google.com>, dm-devel@redhat.com,
        linux-fscrypt@vger.kernel.org,
        Gilad Ben-Yossef <gilad@benyossef.com>,
        Milan Broz <gmazyland@gmail.com>
Subject: [PATCH v5 2/7] fs: crypto: invoke crypto API for ESSIV handling
Date:   Wed, 26 Jun 2019 22:40:42 +0200
Message-Id: <20190626204047.32131-3-ard.biesheuvel@linaro.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190626204047.32131-1-ard.biesheuvel@linaro.org>
References: <20190626204047.32131-1-ard.biesheuvel@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Instead of open coding the calculations for ESSIV handling, use a
ESSIV skcipher which does all of this under the hood.

Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
---
 fs/crypto/Kconfig           |  1 +
 fs/crypto/crypto.c          |  5 --
 fs/crypto/fscrypt_private.h |  9 --
 fs/crypto/keyinfo.c         | 88 +-------------------
 4 files changed, 3 insertions(+), 100 deletions(-)

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
index 335a362ee446..c53ce262a06c 100644
--- a/fs/crypto/crypto.c
+++ b/fs/crypto/crypto.c
@@ -136,9 +136,6 @@ void fscrypt_generate_iv(union fscrypt_iv *iv, u64 lblk_num,
 
 	if (ci->ci_flags & FS_POLICY_FLAG_DIRECT_KEY)
 		memcpy(iv->nonce, ci->ci_nonce, FS_KEY_DERIVATION_NONCE_SIZE);
-
-	if (ci->ci_essiv_tfm != NULL)
-		crypto_cipher_encrypt_one(ci->ci_essiv_tfm, iv->raw, iv->raw);
 }
 
 int fscrypt_do_page_crypto(const struct inode *inode, fscrypt_direction_t rw,
@@ -492,8 +489,6 @@ static void __exit fscrypt_exit(void)
 		destroy_workqueue(fscrypt_read_workqueue);
 	kmem_cache_destroy(fscrypt_ctx_cachep);
 	kmem_cache_destroy(fscrypt_info_cachep);
-
-	fscrypt_essiv_cleanup();
 }
 module_exit(fscrypt_exit);
 
diff --git a/fs/crypto/fscrypt_private.h b/fs/crypto/fscrypt_private.h
index 7da276159593..59d0cba9cfb9 100644
--- a/fs/crypto/fscrypt_private.h
+++ b/fs/crypto/fscrypt_private.h
@@ -61,12 +61,6 @@ struct fscrypt_info {
 	/* The actual crypto transform used for encryption and decryption */
 	struct crypto_skcipher *ci_ctfm;
 
-	/*
-	 * Cipher for ESSIV IV generation.  Only set for CBC contents
-	 * encryption, otherwise is NULL.
-	 */
-	struct crypto_cipher *ci_essiv_tfm;
-
 	/*
 	 * Encryption mode used for this inode.  It corresponds to either
 	 * ci_data_mode or ci_filename_mode, depending on the inode type.
@@ -166,9 +160,6 @@ struct fscrypt_mode {
 	int keysize;
 	int ivsize;
 	bool logged_impl_name;
-	bool needs_essiv;
 };
 
-extern void __exit fscrypt_essiv_cleanup(void);
-
 #endif /* _FSCRYPT_PRIVATE_H */
diff --git a/fs/crypto/keyinfo.c b/fs/crypto/keyinfo.c
index dcd91a3fbe49..82c7eb86ca00 100644
--- a/fs/crypto/keyinfo.c
+++ b/fs/crypto/keyinfo.c
@@ -19,8 +19,6 @@
 #include <crypto/skcipher.h>
 #include "fscrypt_private.h"
 
-static struct crypto_shash *essiv_hash_tfm;
-
 /* Table of keys referenced by FS_POLICY_FLAG_DIRECT_KEY policies */
 static DEFINE_HASHTABLE(fscrypt_master_keys, 6); /* 6 bits = 64 buckets */
 static DEFINE_SPINLOCK(fscrypt_master_keys_lock);
@@ -144,10 +142,9 @@ static struct fscrypt_mode available_modes[] = {
 	},
 	[FS_ENCRYPTION_MODE_AES_128_CBC] = {
 		.friendly_name = "AES-128-CBC",
-		.cipher_str = "cbc(aes)",
+		.cipher_str = "essiv(cbc(aes),aes,sha256)",
 		.keysize = 16,
-		.ivsize = 16,
-		.needs_essiv = true,
+		.ivsize = 8,
 	},
 	[FS_ENCRYPTION_MODE_AES_128_CTS] = {
 		.friendly_name = "AES-128-CTS-CBC",
@@ -377,72 +374,6 @@ fscrypt_get_master_key(const struct fscrypt_info *ci, struct fscrypt_mode *mode,
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
-static int init_essiv_generator(struct fscrypt_info *ci, const u8 *raw_key,
-				int keysize)
-{
-	int err;
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
-
-	/*
-	 * Using SHA256 to derive the salt/key will result in AES-256 being
-	 * used for IV generation. File contents encryption will still use the
-	 * configured keysize (AES-128) nevertheless.
-	 */
-	err = crypto_cipher_setkey(essiv_tfm, salt, sizeof(salt));
-	if (err)
-		goto out;
-
-out:
-	memzero_explicit(salt, sizeof(salt));
-	return err;
-}
-
-void __exit fscrypt_essiv_cleanup(void)
-{
-	crypto_free_shash(essiv_hash_tfm);
-}
-
 /*
  * Given the encryption mode and key (normally the derived key, but for
  * FS_POLICY_FLAG_DIRECT_KEY mode it's the master key), set up the inode's
@@ -454,7 +385,6 @@ static int setup_crypto_transform(struct fscrypt_info *ci,
 {
 	struct fscrypt_master_key *mk;
 	struct crypto_skcipher *ctfm;
-	int err;
 
 	if (ci->ci_flags & FS_POLICY_FLAG_DIRECT_KEY) {
 		mk = fscrypt_get_master_key(ci, mode, raw_key, inode);
@@ -470,19 +400,6 @@ static int setup_crypto_transform(struct fscrypt_info *ci,
 	ci->ci_master_key = mk;
 	ci->ci_ctfm = ctfm;
 
-	if (mode->needs_essiv) {
-		/* ESSIV implies 16-byte IVs which implies !DIRECT_KEY */
-		WARN_ON(mode->ivsize != AES_BLOCK_SIZE);
-		WARN_ON(ci->ci_flags & FS_POLICY_FLAG_DIRECT_KEY);
-
-		err = init_essiv_generator(ci, raw_key, mode->keysize);
-		if (err) {
-			fscrypt_warn(inode->i_sb,
-				     "error initializing ESSIV generator for inode %lu: %d",
-				     inode->i_ino, err);
-			return err;
-		}
-	}
 	return 0;
 }
 
@@ -495,7 +412,6 @@ static void put_crypt_info(struct fscrypt_info *ci)
 		put_master_key(ci->ci_master_key);
 	} else {
 		crypto_free_skcipher(ci->ci_ctfm);
-		crypto_free_cipher(ci->ci_essiv_tfm);
 	}
 	kmem_cache_free(fscrypt_info_cachep, ci);
 }
-- 
2.20.1


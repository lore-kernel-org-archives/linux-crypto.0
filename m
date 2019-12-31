Return-Path: <SRS0=jNyN=2V=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 142AFC2D0DC
	for <linux-crypto@archiver.kernel.org>; Tue, 31 Dec 2019 03:21:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id DEE4520748
	for <linux-crypto@archiver.kernel.org>; Tue, 31 Dec 2019 03:21:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1577762485;
	bh=HuS67dJlGNjeBkFLzuCUK6my+S2jRf9JaAkb6bPGDuY=;
	h=From:To:Subject:Date:In-Reply-To:References:List-ID:From;
	b=DTE/lHX7jmuh6m2lhONk6yzCgotOlg46rqCPl2yDhlUZSLKZmkFyNwiqT91/hknpl
	 vqmUVLd3vLkwNmhmKlvlDIZ+2dZiNjJkQapveVj16FdJiIlQ1Zk6YJvi4b3JVuNYI/
	 SLj6IKo+z73eCfkvWx6RbIWTAT3YqFdp/IidUgjU=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726442AbfLaDU7 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 30 Dec 2019 22:20:59 -0500
Received: from mail.kernel.org ([198.145.29.99]:59196 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725813AbfLaDU7 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 30 Dec 2019 22:20:59 -0500
Received: from zzz.tds (h75-100-12-111.burkwi.broadband.dynamic.tds.net [75.100.12.111])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9718A2071E
        for <linux-crypto@vger.kernel.org>; Tue, 31 Dec 2019 03:20:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1577762458;
        bh=HuS67dJlGNjeBkFLzuCUK6my+S2jRf9JaAkb6bPGDuY=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=mzOpdfTuYyoH5Ptnl209aQtC4F9llayUbCYs8JYOcshUiIGzMnBX5nBMS4b7VS4N3
         kaSPLdJJNx6EoInnIhGVLZ4swgRHPcfIo0BH2J8MDKQQW1VF1+Xhyxyw3wwpnV2RAy
         1hy2knHy5UwGyKPqS1wEm1c9nhhHMqK0TI8BmuQU=
From:   Eric Biggers <ebiggers@kernel.org>
To:     linux-crypto@vger.kernel.org
Subject: [PATCH 7/8] crypto: remove CRYPTO_TFM_RES_WEAK_KEY
Date:   Mon, 30 Dec 2019 21:19:37 -0600
Message-Id: <20191231031938.241705-8-ebiggers@kernel.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20191231031938.241705-1-ebiggers@kernel.org>
References: <20191231031938.241705-1-ebiggers@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

From: Eric Biggers <ebiggers@google.com>

The CRYPTO_TFM_RES_WEAK_KEY flag was apparently meant as a way to make
the ->setkey() functions provide more information about errors.

However, no one actually checks for this flag, which makes it pointless.
There are also no tests that verify that all algorithms actually set (or
don't set) it correctly.

This is also the last remaining CRYPTO_TFM_RES_* flag, which means that
it's the only thing still needing all the boilerplate code which
propagates these flags around from child => parent tfms.

And if someone ever needs to distinguish this error in the future (which
is somewhat unlikely, as it's been unneeded for a long time), it would
be much better to just define a new return value like -EKEYREJECTED.
That would be much simpler, less error-prone, and easier to test.

So just remove this flag.

Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 crypto/des_generic.c           | 10 ++--------
 drivers/crypto/ixp4xx_crypto.c | 28 ++++------------------------
 include/crypto/internal/des.h  | 15 +++------------
 include/crypto/xts.h           | 11 ++---------
 include/linux/crypto.h         |  1 -
 5 files changed, 11 insertions(+), 54 deletions(-)

diff --git a/crypto/des_generic.c b/crypto/des_generic.c
index 6e13a4a29ecb..c85354a5e94c 100644
--- a/crypto/des_generic.c
+++ b/crypto/des_generic.c
@@ -29,11 +29,8 @@ static int des_setkey(struct crypto_tfm *tfm, const u8 *key,
 		else
 			err = 0;
 	}
-
-	if (err) {
+	if (err)
 		memset(dctx, 0, sizeof(*dctx));
-		crypto_tfm_set_flags(tfm, CRYPTO_TFM_RES_WEAK_KEY);
-	}
 	return err;
 }
 
@@ -64,11 +61,8 @@ static int des3_ede_setkey(struct crypto_tfm *tfm, const u8 *key,
 		else
 			err = 0;
 	}
-
-	if (err) {
+	if (err)
 		memset(dctx, 0, sizeof(*dctx));
-		crypto_tfm_set_flags(tfm, CRYPTO_TFM_RES_WEAK_KEY);
-	}
 	return err;
 }
 
diff --git a/drivers/crypto/ixp4xx_crypto.c b/drivers/crypto/ixp4xx_crypto.c
index f64bde506ae8..ad73fc946682 100644
--- a/drivers/crypto/ixp4xx_crypto.c
+++ b/drivers/crypto/ixp4xx_crypto.c
@@ -740,6 +740,7 @@ static int setup_cipher(struct crypto_tfm *tfm, int encrypt,
 	u32 keylen_cfg = 0;
 	struct ix_sa_dir *dir;
 	struct ixp_ctx *ctx = crypto_tfm_ctx(tfm);
+	int err;
 
 	dir = encrypt ? &ctx->encrypt : &ctx->decrypt;
 	cinfo = dir->npe_ctx;
@@ -760,7 +761,9 @@ static int setup_cipher(struct crypto_tfm *tfm, int encrypt,
 		}
 		cipher_cfg |= keylen_cfg;
 	} else {
-		crypto_des_verify_key(tfm, key);
+		err = crypto_des_verify_key(tfm, key);
+		if (err)
+			return err;
 	}
 	/* write cfg word to cryptinfo */
 	*(u32*)cinfo = cpu_to_be32(cipher_cfg);
@@ -817,7 +820,6 @@ static int ablk_setkey(struct crypto_skcipher *tfm, const u8 *key,
 			unsigned int key_len)
 {
 	struct ixp_ctx *ctx = crypto_skcipher_ctx(tfm);
-	u32 *flags = &tfm->base.crt_flags;
 	int ret;
 
 	init_completion(&ctx->completion);
@@ -833,16 +835,6 @@ static int ablk_setkey(struct crypto_skcipher *tfm, const u8 *key,
 	if (ret)
 		goto out;
 	ret = setup_cipher(&tfm->base, 1, key, key_len);
-	if (ret)
-		goto out;
-
-	if (*flags & CRYPTO_TFM_RES_WEAK_KEY) {
-		if (*flags & CRYPTO_TFM_REQ_FORBID_WEAK_KEYS) {
-			ret = -EINVAL;
-		} else {
-			*flags &= ~CRYPTO_TFM_RES_WEAK_KEY;
-		}
-	}
 out:
 	if (!atomic_dec_and_test(&ctx->configuring))
 		wait_for_completion(&ctx->completion);
@@ -1094,7 +1086,6 @@ static int aead_perform(struct aead_request *req, int encrypt,
 static int aead_setup(struct crypto_aead *tfm, unsigned int authsize)
 {
 	struct ixp_ctx *ctx = crypto_aead_ctx(tfm);
-	u32 *flags = &tfm->base.crt_flags;
 	unsigned digest_len = crypto_aead_maxauthsize(tfm);
 	int ret;
 
@@ -1118,17 +1109,6 @@ static int aead_setup(struct crypto_aead *tfm, unsigned int authsize)
 		goto out;
 	ret = setup_auth(&tfm->base, 1, authsize,  ctx->authkey,
 			ctx->authkey_len, digest_len);
-	if (ret)
-		goto out;
-
-	if (*flags & CRYPTO_TFM_RES_WEAK_KEY) {
-		if (*flags & CRYPTO_TFM_REQ_FORBID_WEAK_KEYS) {
-			ret = -EINVAL;
-			goto out;
-		} else {
-			*flags &= ~CRYPTO_TFM_RES_WEAK_KEY;
-		}
-	}
 out:
 	if (!atomic_dec_and_test(&ctx->configuring))
 		wait_for_completion(&ctx->completion);
diff --git a/include/crypto/internal/des.h b/include/crypto/internal/des.h
index 355ddaae3806..723fe5bf16da 100644
--- a/include/crypto/internal/des.h
+++ b/include/crypto/internal/des.h
@@ -35,10 +35,6 @@ static inline int crypto_des_verify_key(struct crypto_tfm *tfm, const u8 *key)
 		else
 			err = 0;
 	}
-
-	if (err)
-		crypto_tfm_set_flags(tfm, CRYPTO_TFM_RES_WEAK_KEY);
-
 	memzero_explicit(&tmp, sizeof(tmp));
 	return err;
 }
@@ -95,14 +91,9 @@ static inline int des3_ede_verify_key(const u8 *key, unsigned int key_len,
 static inline int crypto_des3_ede_verify_key(struct crypto_tfm *tfm,
 					     const u8 *key)
 {
-	int err;
-
-	err = des3_ede_verify_key(key, DES3_EDE_KEY_SIZE,
-				  crypto_tfm_get_flags(tfm) &
-				  CRYPTO_TFM_REQ_FORBID_WEAK_KEYS);
-	if (err)
-		crypto_tfm_set_flags(tfm, CRYPTO_TFM_RES_WEAK_KEY);
-	return err;
+	return des3_ede_verify_key(key, DES3_EDE_KEY_SIZE,
+				   crypto_tfm_get_flags(tfm) &
+				   CRYPTO_TFM_REQ_FORBID_WEAK_KEYS);
 }
 
 static inline int verify_skcipher_des_key(struct crypto_skcipher *tfm,
diff --git a/include/crypto/xts.h b/include/crypto/xts.h
index 57b2c52928db..0f8dba69feb4 100644
--- a/include/crypto/xts.h
+++ b/include/crypto/xts.h
@@ -11,8 +11,6 @@
 static inline int xts_check_key(struct crypto_tfm *tfm,
 				const u8 *key, unsigned int keylen)
 {
-	u32 *flags = &tfm->crt_flags;
-
 	/*
 	 * key consists of keys of equal size concatenated, therefore
 	 * the length must be even.
@@ -21,11 +19,8 @@ static inline int xts_check_key(struct crypto_tfm *tfm,
 		return -EINVAL;
 
 	/* ensure that the AES and tweak key are not identical */
-	if (fips_enabled &&
-	    !crypto_memneq(key, key + (keylen / 2), keylen / 2)) {
-		*flags |= CRYPTO_TFM_RES_WEAK_KEY;
+	if (fips_enabled && !crypto_memneq(key, key + (keylen / 2), keylen / 2))
 		return -EINVAL;
-	}
 
 	return 0;
 }
@@ -43,10 +38,8 @@ static inline int xts_verify_key(struct crypto_skcipher *tfm,
 	/* ensure that the AES and tweak key are not identical */
 	if ((fips_enabled || (crypto_skcipher_get_flags(tfm) &
 			      CRYPTO_TFM_REQ_FORBID_WEAK_KEYS)) &&
-	    !crypto_memneq(key, key + (keylen / 2), keylen / 2)) {
-		crypto_skcipher_set_flags(tfm, CRYPTO_TFM_RES_WEAK_KEY);
+	    !crypto_memneq(key, key + (keylen / 2), keylen / 2))
 		return -EINVAL;
-	}
 
 	return 0;
 }
diff --git a/include/linux/crypto.h b/include/linux/crypto.h
index 61fccc7d0efb..accd0c8038fd 100644
--- a/include/linux/crypto.h
+++ b/include/linux/crypto.h
@@ -112,7 +112,6 @@
 #define CRYPTO_TFM_REQ_FORBID_WEAK_KEYS	0x00000100
 #define CRYPTO_TFM_REQ_MAY_SLEEP	0x00000200
 #define CRYPTO_TFM_REQ_MAY_BACKLOG	0x00000400
-#define CRYPTO_TFM_RES_WEAK_KEY		0x00100000
 
 /*
  * Miscellaneous stuff.
-- 
2.24.1


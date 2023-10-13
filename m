Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9F37ECDB47E
	for <linux-crypto@archiver.kernel.org>; Fri, 13 Oct 2023 05:56:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229718AbjJMF4s (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 13 Oct 2023 01:56:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47694 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229736AbjJMF4q (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 13 Oct 2023 01:56:46 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B57C5C9
        for <linux-crypto@vger.kernel.org>; Thu, 12 Oct 2023 22:56:43 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 21667C433C7
        for <linux-crypto@vger.kernel.org>; Fri, 13 Oct 2023 05:56:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1697176603;
        bh=iuwpuM9eMNsMMdjTbJxgYBaL1uKvyOlATOHTxCMo2e8=;
        h=From:To:Subject:Date:From;
        b=d3uadPa6aTnmxbUW9meQIdXSUfI/vsJJKSuWify+I9vwm8Xmwe89cgIkqNetKU/2c
         YxLHMhG7jSUKLsW2VIU/zkb+M0MvNtVnI0dyiQR3UQUP3esnAsBGAbwQ0CF03H4pnx
         XiGkBKDFj4KS/SMi5uWttNE534BjJtuZav1F7y/qaSqDiqIcgpeS+PpyTWE/Fwlf59
         LCiuPCrJ09ZS13M1a6PD94Y2tyy2bdIZutkwVf7ej3gzhOWZTCWR5/M7/oXygg9a1b
         caqCLybt2t7igzDAdQP6bFmC5i4rpocvARMUgWE+1IGu+Cr4vg0H9Xw3drrWXGrtKP
         mdX4H8VmPQnnQ==
From:   Eric Biggers <ebiggers@kernel.org>
To:     linux-crypto@vger.kernel.org
Subject: [PATCH v2] crypto: skcipher - fix weak key check for lskciphers
Date:   Thu, 12 Oct 2023 22:56:13 -0700
Message-ID: <20231013055613.39655-1-ebiggers@kernel.org>
X-Mailer: git-send-email 2.42.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

From: Eric Biggers <ebiggers@google.com>

When an algorithm of the new "lskcipher" type is exposed through the
"skcipher" API, calls to crypto_skcipher_setkey() don't pass on the
CRYPTO_TFM_REQ_FORBID_WEAK_KEYS flag to the lskcipher.  This causes
self-test failures for ecb(des), as weak keys are not rejected anymore.
Fix this.

Fixes: 31865c4c4db2 ("crypto: skcipher - Add lskcipher")
Signed-off-by: Eric Biggers <ebiggers@google.com>
---

v2: remove prototype for crypto_lskcipher_setkey_sg()

 crypto/lskcipher.c | 8 --------
 crypto/skcipher.c  | 8 +++++++-
 crypto/skcipher.h  | 2 --
 3 files changed, 7 insertions(+), 11 deletions(-)

diff --git a/crypto/lskcipher.c b/crypto/lskcipher.c
index 9be3c04bc62a3..6e11badaa1035 100644
--- a/crypto/lskcipher.c
+++ b/crypto/lskcipher.c
@@ -187,28 +187,20 @@ int crypto_lskcipher_decrypt(struct crypto_lskcipher *tfm, const u8 *src,
 		struct crypto_istat_cipher *istat = lskcipher_get_stat(alg);
 
 		atomic64_inc(&istat->decrypt_cnt);
 		atomic64_add(len, &istat->decrypt_tlen);
 	}
 
 	return crypto_lskcipher_crypt(tfm, src, dst, len, iv, alg->decrypt);
 }
 EXPORT_SYMBOL_GPL(crypto_lskcipher_decrypt);
 
-int crypto_lskcipher_setkey_sg(struct crypto_skcipher *tfm, const u8 *key,
-			       unsigned int keylen)
-{
-	struct crypto_lskcipher **ctx = crypto_skcipher_ctx(tfm);
-
-	return crypto_lskcipher_setkey(*ctx, key, keylen);
-}
-
 static int crypto_lskcipher_crypt_sg(struct skcipher_request *req,
 				     int (*crypt)(struct crypto_lskcipher *tfm,
 						  const u8 *src, u8 *dst,
 						  unsigned len, u8 *iv,
 						  bool final))
 {
 	struct crypto_skcipher *skcipher = crypto_skcipher_reqtfm(req);
 	struct crypto_lskcipher **ctx = crypto_skcipher_ctx(skcipher);
 	struct crypto_lskcipher *tfm = *ctx;
 	struct skcipher_walk walk;
diff --git a/crypto/skcipher.c b/crypto/skcipher.c
index b9496dc8a609f..ac8b8c0426542 100644
--- a/crypto/skcipher.c
+++ b/crypto/skcipher.c
@@ -614,21 +614,27 @@ static int skcipher_setkey_unaligned(struct crypto_skcipher *tfm,
 }
 
 int crypto_skcipher_setkey(struct crypto_skcipher *tfm, const u8 *key,
 			   unsigned int keylen)
 {
 	struct skcipher_alg *cipher = crypto_skcipher_alg(tfm);
 	unsigned long alignmask = crypto_skcipher_alignmask(tfm);
 	int err;
 
 	if (cipher->co.base.cra_type != &crypto_skcipher_type) {
-		err = crypto_lskcipher_setkey_sg(tfm, key, keylen);
+		struct crypto_lskcipher **ctx = crypto_skcipher_ctx(tfm);
+
+		crypto_lskcipher_clear_flags(*ctx, CRYPTO_TFM_REQ_MASK);
+		crypto_lskcipher_set_flags(*ctx,
+					   crypto_skcipher_get_flags(tfm) &
+					   CRYPTO_TFM_REQ_MASK);
+		err = crypto_lskcipher_setkey(*ctx, key, keylen);
 		goto out;
 	}
 
 	if (keylen < cipher->min_keysize || keylen > cipher->max_keysize)
 		return -EINVAL;
 
 	if ((unsigned long)key & alignmask)
 		err = skcipher_setkey_unaligned(tfm, key, keylen);
 	else
 		err = cipher->setkey(tfm, key, keylen);
diff --git a/crypto/skcipher.h b/crypto/skcipher.h
index 6f1295f0fef24..16c9484360dab 100644
--- a/crypto/skcipher.h
+++ b/crypto/skcipher.h
@@ -13,18 +13,16 @@
 static inline struct crypto_istat_cipher *skcipher_get_stat_common(
 	struct skcipher_alg_common *alg)
 {
 #ifdef CONFIG_CRYPTO_STATS
 	return &alg->stat;
 #else
 	return NULL;
 #endif
 }
 
-int crypto_lskcipher_setkey_sg(struct crypto_skcipher *tfm, const u8 *key,
-			       unsigned int keylen);
 int crypto_lskcipher_encrypt_sg(struct skcipher_request *req);
 int crypto_lskcipher_decrypt_sg(struct skcipher_request *req);
 int crypto_init_lskcipher_ops_sg(struct crypto_tfm *tfm);
 int skcipher_prepare_alg_common(struct skcipher_alg_common *alg);
 
 #endif	/* _LOCAL_CRYPTO_SKCIPHER_H */

base-commit: 30febae71c6182e0762dc7744737012b4f8e6a6d
-- 
2.42.0


Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 213B2E95A8D
	for <linux-crypto@archiver.kernel.org>; Mon,  9 Oct 2023 03:38:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344903AbjJIDiL (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Sun, 8 Oct 2023 23:38:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45166 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344883AbjJIDiK (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sun, 8 Oct 2023 23:38:10 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C5002A6
        for <linux-crypto@vger.kernel.org>; Sun,  8 Oct 2023 20:38:08 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 37565C433C7
        for <linux-crypto@vger.kernel.org>; Mon,  9 Oct 2023 03:38:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1696822688;
        bh=ssIT4Vm/KGYqFgJZJ1yWO0WqF3j4d8xmTaeaMKMJaXA=;
        h=From:To:Subject:Date:From;
        b=XBlQ9vqeED7qU6NxsEbkpKcZRVe7NXzzOrPmyvRh54qH+9KNn6XjZI5rc/mA+T8qV
         dIkb2y8BW/KqINdnJ/5FjaSzEZGfj1iB3sUn+03DV0jfFaP64Mg0fxDYCvkcsCsAYX
         ayyl9VXvjwgAIA23Xwv1ih2M9XXPaTlBkwu3zSFcRf55fG5fJKoZN+ZdYV8L7VC3nd
         X+eHKnlfsP7XFwewk/barvwbE6paoPHrurLlAsmBI+9lC8FHgrCCHC7LaO4ugb/g1Q
         SoCV7wA9Yka0RKij8+e5UDO9BGfgzBe6+YQin353rPoAT6Kn+yp1WIKou2/v6S+ap3
         4KPSWlg+Xyu2w==
From:   Eric Biggers <ebiggers@kernel.org>
To:     linux-crypto@vger.kernel.org
Subject: [PATCH] crypto: skcipher - fix weak key check for lskciphers
Date:   Sun,  8 Oct 2023 20:37:50 -0700
Message-ID: <20231009033750.279307-1-ebiggers@kernel.org>
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
 crypto/lskcipher.c | 8 --------
 crypto/skcipher.c  | 8 +++++++-
 2 files changed, 7 insertions(+), 9 deletions(-)

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

base-commit: 8468516f9f93a41dc65158b6428a1a1039c68f20
-- 
2.42.0


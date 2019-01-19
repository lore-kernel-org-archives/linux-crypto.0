Return-Path: <SRS0=s5hs=P3=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F2632C61CE8
	for <linux-crypto@archiver.kernel.org>; Sat, 19 Jan 2019 06:50:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A13EC2087E
	for <linux-crypto@archiver.kernel.org>; Sat, 19 Jan 2019 06:50:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1547880604;
	bh=WSv1XKzNLU4wg/55PFzCiP9xF1YlwqHt66YCBMIDcOo=;
	h=From:To:Subject:Date:List-ID:From;
	b=Dkr5PHV7uaMa3SElampwHNh9ChzJjLDx75jonHkYuXrkkwgzMG8frgdRbMkiGNtfM
	 QTcvCiof28QPIm5Xmsk9/0hwwlTc+gqjKeDH36pITnIavLjUCWW7uZJWjJE1Z7WzM8
	 IqFIZvkM8hlPHTnfLra/C3HGs/Fgg/boq7ecL6bE=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727260AbfASGuE (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Sat, 19 Jan 2019 01:50:04 -0500
Received: from mail.kernel.org ([198.145.29.99]:58712 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727239AbfASGuD (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Sat, 19 Jan 2019 01:50:03 -0500
Received: from sol.localdomain (c-24-23-143-129.hsd1.ca.comcast.net [24.23.143.129])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 354662086D;
        Sat, 19 Jan 2019 06:50:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1547880602;
        bh=WSv1XKzNLU4wg/55PFzCiP9xF1YlwqHt66YCBMIDcOo=;
        h=From:To:Subject:Date:From;
        b=TFYN2k9Y2PzuJzW5dBpst6VF1EjzgPutcZGk/bo8f+jlycj3x9G9N1xYCq5KJmfwU
         DGoC4ZqBuEZy2+x0WoCZiJuN4+kJr6VkCrH41MfaCd2sjhCEoE5vMAKmX9HHTLX32g
         FJzdOkBFkOHj3pLGM+bK8dmS4QteFGUhh0OdMFJg=
From:   Eric Biggers <ebiggers@kernel.org>
To:     linux-crypto@vger.kernel.org,
        Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH] crypto: clarify name of WEAK_KEY request flag
Date:   Fri, 18 Jan 2019 22:48:00 -0800
Message-Id: <20190119064800.6713-1-ebiggers@kernel.org>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

From: Eric Biggers <ebiggers@google.com>

CRYPTO_TFM_REQ_WEAK_KEY confuses newcomers to the crypto API because it
sounds like it is requesting a weak key.  Actually, it is requesting
that weak keys be forbidden (for algorithms that have the notion of
"weak keys"; currently only DES and XTS do).

Also it is only one letter away from CRYPTO_TFM_RES_WEAK_KEY, with which
it can be easily confused.  (This in fact happened in the UX500 driver,
though just in some debugging messages.)

Therefore, make the intent clear by renaming it to
CRYPTO_TFM_REQ_FORBID_WEAK_KEYS.

Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 arch/s390/crypto/des_s390.c                   |  4 ++--
 arch/sparc/crypto/des_glue.c                  |  4 ++--
 crypto/des_generic.c                          |  4 ++--
 crypto/testmgr.c                              | 14 ++++++-------
 crypto/testmgr.h                              |  4 ++--
 drivers/crypto/atmel-tdes.c                   |  2 +-
 drivers/crypto/bcm/cipher.c                   |  4 ++--
 drivers/crypto/ccp/ccp-crypto-des3.c          |  2 +-
 drivers/crypto/ccree/cc_cipher.c              |  3 ++-
 drivers/crypto/hifn_795x.c                    |  3 ++-
 .../crypto/inside-secure/safexcel_cipher.c    |  2 +-
 drivers/crypto/ixp4xx_crypto.c                |  4 ++--
 drivers/crypto/marvell/cipher.c               |  2 +-
 drivers/crypto/n2_core.c                      |  2 +-
 drivers/crypto/omap-des.c                     |  2 +-
 drivers/crypto/picoxcell_crypto.c             |  3 ++-
 drivers/crypto/qce/ablkcipher.c               |  4 ++--
 .../rockchip/rk3288_crypto_ablkcipher.c       |  2 +-
 drivers/crypto/sunxi-ss/sun4i-ss-cipher.c     |  2 +-
 drivers/crypto/talitos.c                      |  2 +-
 drivers/crypto/ux500/cryp/cryp_core.c         | 20 ++++++++++---------
 fs/crypto/keyinfo.c                           |  4 ++--
 fs/ecryptfs/crypto.c                          |  5 +++--
 include/crypto/xts.h                          |  4 ++--
 include/linux/crypto.h                        |  2 +-
 25 files changed, 55 insertions(+), 49 deletions(-)

diff --git a/arch/s390/crypto/des_s390.c b/arch/s390/crypto/des_s390.c
index 5346b5a80bb6c..0d15383d0ff1b 100644
--- a/arch/s390/crypto/des_s390.c
+++ b/arch/s390/crypto/des_s390.c
@@ -38,7 +38,7 @@ static int des_setkey(struct crypto_tfm *tfm, const u8 *key,
 
 	/* check for weak keys */
 	if (!des_ekey(tmp, key) &&
-	    (tfm->crt_flags & CRYPTO_TFM_REQ_WEAK_KEY)) {
+	    (tfm->crt_flags & CRYPTO_TFM_REQ_FORBID_WEAK_KEYS)) {
 		tfm->crt_flags |= CRYPTO_TFM_RES_WEAK_KEY;
 		return -EINVAL;
 	}
@@ -228,7 +228,7 @@ static int des3_setkey(struct crypto_tfm *tfm, const u8 *key,
 	if (!(crypto_memneq(key, &key[DES_KEY_SIZE], DES_KEY_SIZE) &&
 	    crypto_memneq(&key[DES_KEY_SIZE], &key[DES_KEY_SIZE * 2],
 			  DES_KEY_SIZE)) &&
-	    (tfm->crt_flags & CRYPTO_TFM_REQ_WEAK_KEY)) {
+	    (tfm->crt_flags & CRYPTO_TFM_REQ_FORBID_WEAK_KEYS)) {
 		tfm->crt_flags |= CRYPTO_TFM_RES_WEAK_KEY;
 		return -EINVAL;
 	}
diff --git a/arch/sparc/crypto/des_glue.c b/arch/sparc/crypto/des_glue.c
index 56499ea39fd36..4884315daff4a 100644
--- a/arch/sparc/crypto/des_glue.c
+++ b/arch/sparc/crypto/des_glue.c
@@ -53,7 +53,7 @@ static int des_set_key(struct crypto_tfm *tfm, const u8 *key,
 	 * weak key detection code.
 	 */
 	ret = des_ekey(tmp, key);
-	if (unlikely(ret == 0) && (*flags & CRYPTO_TFM_REQ_WEAK_KEY)) {
+	if (unlikely(ret == 0) && (*flags & CRYPTO_TFM_REQ_FORBID_WEAK_KEYS)) {
 		*flags |= CRYPTO_TFM_RES_WEAK_KEY;
 		return -EINVAL;
 	}
@@ -209,7 +209,7 @@ static int des3_ede_set_key(struct crypto_tfm *tfm, const u8 *key,
 
 	if (unlikely(!((K[0] ^ K[2]) | (K[1] ^ K[3])) ||
 		     !((K[2] ^ K[4]) | (K[3] ^ K[5]))) &&
-		     (*flags & CRYPTO_TFM_REQ_WEAK_KEY)) {
+		     (*flags & CRYPTO_TFM_REQ_FORBID_WEAK_KEYS)) {
 		*flags |= CRYPTO_TFM_RES_WEAK_KEY;
 		return -EINVAL;
 	}
diff --git a/crypto/des_generic.c b/crypto/des_generic.c
index a71720544d118..1e6621665dd92 100644
--- a/crypto/des_generic.c
+++ b/crypto/des_generic.c
@@ -789,7 +789,7 @@ static int des_setkey(struct crypto_tfm *tfm, const u8 *key,
 	/* Expand to tmp */
 	ret = des_ekey(tmp, key);
 
-	if (unlikely(ret == 0) && (*flags & CRYPTO_TFM_REQ_WEAK_KEY)) {
+	if (unlikely(ret == 0) && (*flags & CRYPTO_TFM_REQ_FORBID_WEAK_KEYS)) {
 		*flags |= CRYPTO_TFM_RES_WEAK_KEY;
 		return -EINVAL;
 	}
@@ -866,7 +866,7 @@ int __des3_ede_setkey(u32 *expkey, u32 *flags, const u8 *key,
 
 	if (unlikely(!((K[0] ^ K[2]) | (K[1] ^ K[3])) ||
 		     !((K[2] ^ K[4]) | (K[3] ^ K[5]))) &&
-		     (*flags & CRYPTO_TFM_REQ_WEAK_KEY)) {
+		     (*flags & CRYPTO_TFM_REQ_FORBID_WEAK_KEYS)) {
 		*flags |= CRYPTO_TFM_RES_WEAK_KEY;
 		return -EINVAL;
 	}
diff --git a/crypto/testmgr.c b/crypto/testmgr.c
index e4f3f5f688e7d..4ac3d22256c36 100644
--- a/crypto/testmgr.c
+++ b/crypto/testmgr.c
@@ -706,7 +706,8 @@ static int __test_aead(struct crypto_aead *tfm, int enc,
 
 		crypto_aead_clear_flags(tfm, ~0);
 		if (template[i].wk)
-			crypto_aead_set_flags(tfm, CRYPTO_TFM_REQ_WEAK_KEY);
+			crypto_aead_set_flags(tfm,
+					      CRYPTO_TFM_REQ_FORBID_WEAK_KEYS);
 
 		if (template[i].klen > MAX_KEYLEN) {
 			pr_err("alg: aead%s: setkey failed on test %d for %s: key size %d > %d\n",
@@ -820,7 +821,8 @@ static int __test_aead(struct crypto_aead *tfm, int enc,
 
 		crypto_aead_clear_flags(tfm, ~0);
 		if (template[i].wk)
-			crypto_aead_set_flags(tfm, CRYPTO_TFM_REQ_WEAK_KEY);
+			crypto_aead_set_flags(tfm,
+					      CRYPTO_TFM_REQ_FORBID_WEAK_KEYS);
 		if (template[i].klen > MAX_KEYLEN) {
 			pr_err("alg: aead%s: setkey failed on test %d for %s: key size %d > %d\n",
 			       d, j, algo, template[i].klen, MAX_KEYLEN);
@@ -1078,7 +1080,7 @@ static int test_cipher(struct crypto_cipher *tfm, int enc,
 
 		crypto_cipher_clear_flags(tfm, ~0);
 		if (template[i].wk)
-			crypto_cipher_set_flags(tfm, CRYPTO_TFM_REQ_WEAK_KEY);
+			crypto_cipher_set_flags(tfm, CRYPTO_TFM_REQ_FORBID_WEAK_KEYS);
 
 		ret = crypto_cipher_setkey(tfm, template[i].key,
 					   template[i].klen);
@@ -1194,8 +1196,7 @@ static int __test_skcipher(struct crypto_skcipher *tfm, int enc,
 
 		crypto_skcipher_clear_flags(tfm, ~0);
 		if (template[i].wk)
-			crypto_skcipher_set_flags(tfm,
-						  CRYPTO_TFM_REQ_WEAK_KEY);
+			crypto_skcipher_set_flags(tfm, CRYPTO_TFM_REQ_FORBID_WEAK_KEYS);
 
 		ret = crypto_skcipher_setkey(tfm, template[i].key,
 					     template[i].klen);
@@ -1265,8 +1266,7 @@ static int __test_skcipher(struct crypto_skcipher *tfm, int enc,
 		j++;
 		crypto_skcipher_clear_flags(tfm, ~0);
 		if (template[i].wk)
-			crypto_skcipher_set_flags(tfm,
-						  CRYPTO_TFM_REQ_WEAK_KEY);
+			crypto_skcipher_set_flags(tfm, CRYPTO_TFM_REQ_FORBID_WEAK_KEYS);
 
 		ret = crypto_skcipher_setkey(tfm, template[i].key,
 					     template[i].klen);
diff --git a/crypto/testmgr.h b/crypto/testmgr.h
index 95297240b0f1c..d8f6035c7ff25 100644
--- a/crypto/testmgr.h
+++ b/crypto/testmgr.h
@@ -50,7 +50,7 @@ struct hash_testvec {
  * @ctext:	Pointer to ciphertext
  * @len:	Length of @ptext and @ctext in bytes
  * @fail:	If set to one, the test need to fail
- * @wk:		Does the test need CRYPTO_TFM_REQ_WEAK_KEY
+ * @wk:		Does the test need CRYPTO_TFM_REQ_FORBID_WEAK_KEYS?
  * 		( e.g. test needs to fail due to a weak key )
  * @np: 	numbers of SG to distribute data in (from 1 to MAX_TAP)
  * @tap:	How to distribute data in @np SGs
@@ -91,7 +91,7 @@ struct cipher_testvec {
  * @anp:	Numbers of SG to distribute assoc data in
  * @fail:	setkey() failure expected?
  * @novrfy:	Decryption verification failure expected?
- * @wk:		Does the test need CRYPTO_TFM_REQ_WEAK_KEY?
+ * @wk:		Does the test need CRYPTO_TFM_REQ_FORBID_WEAK_KEYS?
  *		(e.g. setkey() needs to fail due to a weak key)
  * @klen:	Length of @key in bytes
  * @plen:	Length of @ptext in bytes
diff --git a/drivers/crypto/atmel-tdes.c b/drivers/crypto/atmel-tdes.c
index 438e1ffb2ec0b..65bf1a2995620 100644
--- a/drivers/crypto/atmel-tdes.c
+++ b/drivers/crypto/atmel-tdes.c
@@ -785,7 +785,7 @@ static int atmel_des_setkey(struct crypto_ablkcipher *tfm, const u8 *key,
 	}
 
 	err = des_ekey(tmp, key);
-	if (err == 0 && (ctfm->crt_flags & CRYPTO_TFM_REQ_WEAK_KEY)) {
+	if (err == 0 && (ctfm->crt_flags & CRYPTO_TFM_REQ_FORBID_WEAK_KEYS)) {
 		ctfm->crt_flags |= CRYPTO_TFM_RES_WEAK_KEY;
 		return -EINVAL;
 	}
diff --git a/drivers/crypto/bcm/cipher.c b/drivers/crypto/bcm/cipher.c
index 2099d7bcfd448..28f592f7e1b7a 100644
--- a/drivers/crypto/bcm/cipher.c
+++ b/drivers/crypto/bcm/cipher.c
@@ -1818,7 +1818,7 @@ static int des_setkey(struct crypto_ablkcipher *cipher, const u8 *key,
 	if (keylen == DES_KEY_SIZE) {
 		if (des_ekey(tmp, key) == 0) {
 			if (crypto_ablkcipher_get_flags(cipher) &
-			    CRYPTO_TFM_REQ_WEAK_KEY) {
+			    CRYPTO_TFM_REQ_FORBID_WEAK_KEYS) {
 				u32 flags = CRYPTO_TFM_RES_WEAK_KEY;
 
 				crypto_ablkcipher_set_flags(cipher, flags);
@@ -2872,7 +2872,7 @@ static int aead_authenc_setkey(struct crypto_aead *cipher,
 
 			if (des_ekey(tmp, keys.enckey) == 0) {
 				if (crypto_aead_get_flags(cipher) &
-				    CRYPTO_TFM_REQ_WEAK_KEY) {
+				    CRYPTO_TFM_REQ_FORBID_WEAK_KEYS) {
 					crypto_aead_set_flags(cipher, flags);
 					return -EINVAL;
 				}
diff --git a/drivers/crypto/ccp/ccp-crypto-des3.c b/drivers/crypto/ccp/ccp-crypto-des3.c
index ae87b741f9d57..c2ff551d215b5 100644
--- a/drivers/crypto/ccp/ccp-crypto-des3.c
+++ b/drivers/crypto/ccp/ccp-crypto-des3.c
@@ -57,7 +57,7 @@ static int ccp_des3_setkey(struct crypto_ablkcipher *tfm, const u8 *key,
 
 	if (unlikely(!((K[0] ^ K[2]) | (K[1] ^ K[3])) ||
 		     !((K[2] ^ K[4]) | (K[3] ^ K[5]))) &&
-		     (*flags & CRYPTO_TFM_REQ_WEAK_KEY)) {
+		     (*flags & CRYPTO_TFM_REQ_FORBID_WEAK_KEYS)) {
 		*flags |= CRYPTO_TFM_RES_WEAK_KEY;
 		return -EINVAL;
 	}
diff --git a/drivers/crypto/ccree/cc_cipher.c b/drivers/crypto/ccree/cc_cipher.c
index cc92b031fad11..0cbc60e0a0869 100644
--- a/drivers/crypto/ccree/cc_cipher.c
+++ b/drivers/crypto/ccree/cc_cipher.c
@@ -352,7 +352,8 @@ static int cc_cipher_setkey(struct crypto_skcipher *sktfm, const u8 *key,
 			dev_dbg(dev, "weak 3DES key");
 			return -EINVAL;
 		} else if (!des_ekey(tmp, key) &&
-		    (crypto_tfm_get_flags(tfm) & CRYPTO_TFM_REQ_WEAK_KEY)) {
+			   (crypto_tfm_get_flags(tfm) &
+			    CRYPTO_TFM_REQ_FORBID_WEAK_KEYS)) {
 			tfm->crt_flags |= CRYPTO_TFM_RES_WEAK_KEY;
 			dev_dbg(dev, "weak DES key");
 			return -EINVAL;
diff --git a/drivers/crypto/hifn_795x.c b/drivers/crypto/hifn_795x.c
index a5a36fe7bf2cb..dad212cabe63b 100644
--- a/drivers/crypto/hifn_795x.c
+++ b/drivers/crypto/hifn_795x.c
@@ -1961,7 +1961,8 @@ static int hifn_setkey(struct crypto_ablkcipher *cipher, const u8 *key,
 		u32 tmp[DES_EXPKEY_WORDS];
 		int ret = des_ekey(tmp, key);
 
-		if (unlikely(ret == 0) && (tfm->crt_flags & CRYPTO_TFM_REQ_WEAK_KEY)) {
+		if (unlikely(ret == 0) &&
+		    (tfm->crt_flags & CRYPTO_TFM_REQ_FORBID_WEAK_KEYS)) {
 			tfm->crt_flags |= CRYPTO_TFM_RES_WEAK_KEY;
 			return -EINVAL;
 		}
diff --git a/drivers/crypto/inside-secure/safexcel_cipher.c b/drivers/crypto/inside-secure/safexcel_cipher.c
index d531c14020dcb..7ef30a98cb24b 100644
--- a/drivers/crypto/inside-secure/safexcel_cipher.c
+++ b/drivers/crypto/inside-secure/safexcel_cipher.c
@@ -940,7 +940,7 @@ static int safexcel_des_setkey(struct crypto_skcipher *ctfm, const u8 *key,
 	}
 
 	ret = des_ekey(tmp, key);
-	if (!ret && (tfm->crt_flags & CRYPTO_TFM_REQ_WEAK_KEY)) {
+	if (!ret && (tfm->crt_flags & CRYPTO_TFM_REQ_FORBID_WEAK_KEYS)) {
 		tfm->crt_flags |= CRYPTO_TFM_RES_WEAK_KEY;
 		return -EINVAL;
 	}
diff --git a/drivers/crypto/ixp4xx_crypto.c b/drivers/crypto/ixp4xx_crypto.c
index 19fba998b86b4..95c1af227bd5d 100644
--- a/drivers/crypto/ixp4xx_crypto.c
+++ b/drivers/crypto/ixp4xx_crypto.c
@@ -847,7 +847,7 @@ static int ablk_setkey(struct crypto_ablkcipher *tfm, const u8 *key,
 		goto out;
 
 	if (*flags & CRYPTO_TFM_RES_WEAK_KEY) {
-		if (*flags & CRYPTO_TFM_REQ_WEAK_KEY) {
+		if (*flags & CRYPTO_TFM_REQ_FORBID_WEAK_KEYS) {
 			ret = -EINVAL;
 		} else {
 			*flags &= ~CRYPTO_TFM_RES_WEAK_KEY;
@@ -1125,7 +1125,7 @@ static int aead_setup(struct crypto_aead *tfm, unsigned int authsize)
 		goto out;
 
 	if (*flags & CRYPTO_TFM_RES_WEAK_KEY) {
-		if (*flags & CRYPTO_TFM_REQ_WEAK_KEY) {
+		if (*flags & CRYPTO_TFM_REQ_FORBID_WEAK_KEYS) {
 			ret = -EINVAL;
 			goto out;
 		} else {
diff --git a/drivers/crypto/marvell/cipher.c b/drivers/crypto/marvell/cipher.c
index 0ae84ec9e21c0..066830dcc53e3 100644
--- a/drivers/crypto/marvell/cipher.c
+++ b/drivers/crypto/marvell/cipher.c
@@ -286,7 +286,7 @@ static int mv_cesa_des_setkey(struct crypto_skcipher *cipher, const u8 *key,
 	}
 
 	ret = des_ekey(tmp, key);
-	if (!ret && (tfm->crt_flags & CRYPTO_TFM_REQ_WEAK_KEY)) {
+	if (!ret && (tfm->crt_flags & CRYPTO_TFM_REQ_FORBID_WEAK_KEYS)) {
 		tfm->crt_flags |= CRYPTO_TFM_RES_WEAK_KEY;
 		return -EINVAL;
 	}
diff --git a/drivers/crypto/n2_core.c b/drivers/crypto/n2_core.c
index 55f34cfc43ff6..9450c41211b28 100644
--- a/drivers/crypto/n2_core.c
+++ b/drivers/crypto/n2_core.c
@@ -772,7 +772,7 @@ static int n2_des_setkey(struct crypto_ablkcipher *cipher, const u8 *key,
 	}
 
 	err = des_ekey(tmp, key);
-	if (err == 0 && (tfm->crt_flags & CRYPTO_TFM_REQ_WEAK_KEY)) {
+	if (err == 0 && (tfm->crt_flags & CRYPTO_TFM_REQ_FORBID_WEAK_KEYS)) {
 		tfm->crt_flags |= CRYPTO_TFM_RES_WEAK_KEY;
 		return -EINVAL;
 	}
diff --git a/drivers/crypto/omap-des.c b/drivers/crypto/omap-des.c
index 6369019219d44..1ba2633e90d66 100644
--- a/drivers/crypto/omap-des.c
+++ b/drivers/crypto/omap-des.c
@@ -662,7 +662,7 @@ static int omap_des_setkey(struct crypto_ablkcipher *cipher, const u8 *key,
 	pr_debug("enter, keylen: %d\n", keylen);
 
 	/* Do we need to test against weak key? */
-	if (tfm->crt_flags & CRYPTO_TFM_REQ_WEAK_KEY) {
+	if (tfm->crt_flags & CRYPTO_TFM_REQ_FORBID_WEAK_KEYS) {
 		u32 tmp[DES_EXPKEY_WORDS];
 		int ret = des_ekey(tmp, key);
 
diff --git a/drivers/crypto/picoxcell_crypto.c b/drivers/crypto/picoxcell_crypto.c
index 17068b55fea53..1b3acdeffede4 100644
--- a/drivers/crypto/picoxcell_crypto.c
+++ b/drivers/crypto/picoxcell_crypto.c
@@ -759,7 +759,8 @@ static int spacc_des_setkey(struct crypto_ablkcipher *cipher, const u8 *key,
 	}
 
 	if (unlikely(!des_ekey(tmp, key)) &&
-	    (crypto_ablkcipher_get_flags(cipher) & CRYPTO_TFM_REQ_WEAK_KEY)) {
+	    (crypto_ablkcipher_get_flags(cipher) &
+	     CRYPTO_TFM_REQ_FORBID_WEAK_KEYS)) {
 		tfm->crt_flags |= CRYPTO_TFM_RES_WEAK_KEY;
 		return -EINVAL;
 	}
diff --git a/drivers/crypto/qce/ablkcipher.c b/drivers/crypto/qce/ablkcipher.c
index 25c13e26d0128..154b6baa124ed 100644
--- a/drivers/crypto/qce/ablkcipher.c
+++ b/drivers/crypto/qce/ablkcipher.c
@@ -180,8 +180,8 @@ static int qce_ablkcipher_setkey(struct crypto_ablkcipher *ablk, const u8 *key,
 		u32 tmp[DES_EXPKEY_WORDS];
 
 		ret = des_ekey(tmp, key);
-		if (!ret && crypto_ablkcipher_get_flags(ablk) &
-		    CRYPTO_TFM_REQ_WEAK_KEY)
+		if (!ret && (crypto_ablkcipher_get_flags(ablk) &
+			     CRYPTO_TFM_REQ_FORBID_WEAK_KEYS))
 			goto weakkey;
 	}
 
diff --git a/drivers/crypto/rockchip/rk3288_crypto_ablkcipher.c b/drivers/crypto/rockchip/rk3288_crypto_ablkcipher.c
index 639c15c5364b4..87dd571466c1a 100644
--- a/drivers/crypto/rockchip/rk3288_crypto_ablkcipher.c
+++ b/drivers/crypto/rockchip/rk3288_crypto_ablkcipher.c
@@ -60,7 +60,7 @@ static int rk_tdes_setkey(struct crypto_ablkcipher *cipher,
 
 	if (keylen == DES_KEY_SIZE) {
 		if (!des_ekey(tmp, key) &&
-		    (tfm->crt_flags & CRYPTO_TFM_REQ_WEAK_KEY)) {
+		    (tfm->crt_flags & CRYPTO_TFM_REQ_FORBID_WEAK_KEYS)) {
 			tfm->crt_flags |= CRYPTO_TFM_RES_WEAK_KEY;
 			return -EINVAL;
 		}
diff --git a/drivers/crypto/sunxi-ss/sun4i-ss-cipher.c b/drivers/crypto/sunxi-ss/sun4i-ss-cipher.c
index 5cf64746731a3..54fd714d53cae 100644
--- a/drivers/crypto/sunxi-ss/sun4i-ss-cipher.c
+++ b/drivers/crypto/sunxi-ss/sun4i-ss-cipher.c
@@ -517,7 +517,7 @@ int sun4i_ss_des_setkey(struct crypto_skcipher *tfm, const u8 *key,
 	flags = crypto_skcipher_get_flags(tfm);
 
 	ret = des_ekey(tmp, key);
-	if (unlikely(!ret) && (flags & CRYPTO_TFM_REQ_WEAK_KEY)) {
+	if (unlikely(!ret) && (flags & CRYPTO_TFM_REQ_FORBID_WEAK_KEYS)) {
 		crypto_skcipher_set_flags(tfm, CRYPTO_TFM_RES_WEAK_KEY);
 		dev_dbg(ss->dev, "Weak key %u\n", keylen);
 		return -EINVAL;
diff --git a/drivers/crypto/talitos.c b/drivers/crypto/talitos.c
index f8e2c5c3f4eb1..de78b54bcfb12 100644
--- a/drivers/crypto/talitos.c
+++ b/drivers/crypto/talitos.c
@@ -1535,7 +1535,7 @@ static int ablkcipher_setkey(struct crypto_ablkcipher *cipher,
 	}
 
 	if (unlikely(crypto_ablkcipher_get_flags(cipher) &
-		     CRYPTO_TFM_REQ_WEAK_KEY) &&
+		     CRYPTO_TFM_REQ_FORBID_WEAK_KEYS) &&
 	    !des_ekey(tmp, key)) {
 		crypto_ablkcipher_set_flags(cipher, CRYPTO_TFM_RES_WEAK_KEY);
 		return -EINVAL;
diff --git a/drivers/crypto/ux500/cryp/cryp_core.c b/drivers/crypto/ux500/cryp/cryp_core.c
index db94f89d8d113..3235611928f20 100644
--- a/drivers/crypto/ux500/cryp/cryp_core.c
+++ b/drivers/crypto/ux500/cryp/cryp_core.c
@@ -1000,10 +1000,11 @@ static int des_ablkcipher_setkey(struct crypto_ablkcipher *cipher,
 	}
 
 	ret = des_ekey(tmp, key);
-	if (unlikely(ret == 0) && (*flags & CRYPTO_TFM_REQ_WEAK_KEY)) {
+	if (unlikely(ret == 0) &&
+	    (*flags & CRYPTO_TFM_REQ_FORBID_WEAK_KEYS)) {
 		*flags |= CRYPTO_TFM_RES_WEAK_KEY;
-		pr_debug(DEV_DBG_NAME " [%s]: CRYPTO_TFM_REQ_WEAK_KEY",
-				__func__);
+		pr_debug(DEV_DBG_NAME " [%s]: CRYPTO_TFM_RES_WEAK_KEY",
+			 __func__);
 		return -EINVAL;
 	}
 
@@ -1034,18 +1035,19 @@ static int des3_ablkcipher_setkey(struct crypto_ablkcipher *cipher,
 	/* Checking key interdependency for weak key detection. */
 	if (unlikely(!((K[0] ^ K[2]) | (K[1] ^ K[3])) ||
 				!((K[2] ^ K[4]) | (K[3] ^ K[5]))) &&
-			(*flags & CRYPTO_TFM_REQ_WEAK_KEY)) {
+			(*flags & CRYPTO_TFM_REQ_FORBID_WEAK_KEYS)) {
 		*flags |= CRYPTO_TFM_RES_WEAK_KEY;
-		pr_debug(DEV_DBG_NAME " [%s]: CRYPTO_TFM_REQ_WEAK_KEY",
-				__func__);
+		pr_debug(DEV_DBG_NAME " [%s]: CRYPTO_TFM_RES_WEAK_KEY",
+			 __func__);
 		return -EINVAL;
 	}
 	for (i = 0; i < 3; i++) {
 		ret = des_ekey(tmp, key + i*DES_KEY_SIZE);
-		if (unlikely(ret == 0) && (*flags & CRYPTO_TFM_REQ_WEAK_KEY)) {
+		if (unlikely(ret == 0) &&
+		    (*flags & CRYPTO_TFM_REQ_FORBID_WEAK_KEYS)) {
 			*flags |= CRYPTO_TFM_RES_WEAK_KEY;
-			pr_debug(DEV_DBG_NAME " [%s]: "
-					"CRYPTO_TFM_REQ_WEAK_KEY", __func__);
+			pr_debug(DEV_DBG_NAME " [%s]: CRYPTO_TFM_RES_WEAK_KEY",
+				 __func__);
 			return -EINVAL;
 		}
 	}
diff --git a/fs/crypto/keyinfo.c b/fs/crypto/keyinfo.c
index 1e11a683f63df..322ce9686bdba 100644
--- a/fs/crypto/keyinfo.c
+++ b/fs/crypto/keyinfo.c
@@ -47,7 +47,7 @@ static int derive_key_aes(const u8 *master_key,
 		tfm = NULL;
 		goto out;
 	}
-	crypto_skcipher_set_flags(tfm, CRYPTO_TFM_REQ_WEAK_KEY);
+	crypto_skcipher_set_flags(tfm, CRYPTO_TFM_REQ_FORBID_WEAK_KEYS);
 	req = skcipher_request_alloc(tfm, GFP_NOFS);
 	if (!req) {
 		res = -ENOMEM;
@@ -257,7 +257,7 @@ allocate_skcipher_for_mode(struct fscrypt_mode *mode, const u8 *raw_key,
 			mode->friendly_name,
 			crypto_skcipher_alg(tfm)->base.cra_driver_name);
 	}
-	crypto_skcipher_set_flags(tfm, CRYPTO_TFM_REQ_WEAK_KEY);
+	crypto_skcipher_set_flags(tfm, CRYPTO_TFM_REQ_FORBID_WEAK_KEYS);
 	err = crypto_skcipher_setkey(tfm, raw_key, mode->keysize);
 	if (err)
 		goto err_free_tfm;
diff --git a/fs/ecryptfs/crypto.c b/fs/ecryptfs/crypto.c
index 4dd842f728465..f664da55234e9 100644
--- a/fs/ecryptfs/crypto.c
+++ b/fs/ecryptfs/crypto.c
@@ -610,7 +610,8 @@ int ecryptfs_init_crypt_ctx(struct ecryptfs_crypt_stat *crypt_stat)
 				full_alg_name);
 		goto out_free;
 	}
-	crypto_skcipher_set_flags(crypt_stat->tfm, CRYPTO_TFM_REQ_WEAK_KEY);
+	crypto_skcipher_set_flags(crypt_stat->tfm,
+				  CRYPTO_TFM_REQ_FORBID_WEAK_KEYS);
 	rc = 0;
 out_free:
 	kfree(full_alg_name);
@@ -1590,7 +1591,7 @@ ecryptfs_process_key_cipher(struct crypto_skcipher **key_tfm,
 		       "[%s]; rc = [%d]\n", full_alg_name, rc);
 		goto out;
 	}
-	crypto_skcipher_set_flags(*key_tfm, CRYPTO_TFM_REQ_WEAK_KEY);
+	crypto_skcipher_set_flags(*key_tfm, CRYPTO_TFM_REQ_FORBID_WEAK_KEYS);
 	if (*key_size == 0)
 		*key_size = crypto_skcipher_default_keysize(*key_tfm);
 	get_random_bytes(dummy_key, *key_size);
diff --git a/include/crypto/xts.h b/include/crypto/xts.h
index 34d94c95445a5..75fd96ff976b7 100644
--- a/include/crypto/xts.h
+++ b/include/crypto/xts.h
@@ -47,8 +47,8 @@ static inline int xts_verify_key(struct crypto_skcipher *tfm,
 	}
 
 	/* ensure that the AES and tweak key are not identical */
-	if ((fips_enabled || crypto_skcipher_get_flags(tfm) &
-			     CRYPTO_TFM_REQ_WEAK_KEY) &&
+	if ((fips_enabled || (crypto_skcipher_get_flags(tfm) &
+			      CRYPTO_TFM_REQ_FORBID_WEAK_KEYS)) &&
 	    !crypto_memneq(key, key + (keylen / 2), keylen / 2)) {
 		crypto_skcipher_set_flags(tfm, CRYPTO_TFM_RES_WEAK_KEY);
 		return -EINVAL;
diff --git a/include/linux/crypto.h b/include/linux/crypto.h
index c3c98a62e503b..f2565a1031584 100644
--- a/include/linux/crypto.h
+++ b/include/linux/crypto.h
@@ -118,7 +118,7 @@
 #define CRYPTO_TFM_REQ_MASK		0x000fff00
 #define CRYPTO_TFM_RES_MASK		0xfff00000
 
-#define CRYPTO_TFM_REQ_WEAK_KEY		0x00000100
+#define CRYPTO_TFM_REQ_FORBID_WEAK_KEYS	0x00000100
 #define CRYPTO_TFM_REQ_MAY_SLEEP	0x00000200
 #define CRYPTO_TFM_REQ_MAY_BACKLOG	0x00000400
 #define CRYPTO_TFM_RES_WEAK_KEY		0x00100000
-- 
2.20.1


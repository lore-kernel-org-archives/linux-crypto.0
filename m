From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 6/15] crypto: rng - Mark crypto_rng_reset seed as const
Date: Mon, 20 Apr 2015 13:39:05 +0800
Message-ID: <E1Yk4QD-0004q0-Rn@gondolin.me.apana.org.au>
References: <20150420053515.GA18444@gondor.apana.org.au>
To: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:42925 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751684AbbDTFjJ (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 20 Apr 2015 01:39:09 -0400
Received: from gondolin.me.apana.org.au ([192.168.0.6])
	by norbury.hengli.com.au with esmtp (Exim 4.80 #3 (Debian))
	id 1Yk4QE-0003D6-Aj
	for <linux-crypto@vger.kernel.org>; Mon, 20 Apr 2015 15:39:06 +1000
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

There is no reason why crypto_rng_reset should modify the seed
so this patch marks it as const.  Since our algorithms don't
export a const seed function yet we have to go through some
contortions for now.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
---

 crypto/rng.c         |   27 +++++++++++++++++++++++++--
 include/crypto/rng.h |    9 +++------
 2 files changed, 28 insertions(+), 8 deletions(-)

diff --git a/crypto/rng.c b/crypto/rng.c
index 4514d37..618fa4d 100644
--- a/crypto/rng.c
+++ b/crypto/rng.c
@@ -42,7 +42,29 @@ static int generate(struct crypto_rng *tfm, const u8 *src, unsigned int slen,
 	return crypto_rng_alg(tfm)->rng_make_random(tfm, dst, dlen);
 }
 
-static int rngapi_reset(struct crypto_rng *tfm, u8 *seed, unsigned int slen)
+static int rngapi_reset(struct crypto_rng *tfm, const u8 *seed,
+			unsigned int slen)
+{
+	u8 *buf = NULL;
+	u8 *src = (u8 *)seed;
+	int err;
+
+	if (slen) {
+		buf = kmalloc(slen, GFP_KERNEL);
+		if (!buf)
+			return -ENOMEM;
+
+		memcpy(buf, seed, slen);
+		src = buf;
+	}
+
+	err = crypto_rng_alg(tfm)->rng_reset(tfm, src, slen);
+
+	kfree(buf);
+	return err;
+}
+
+int crypto_rng_reset(struct crypto_rng *tfm, const u8 *seed, unsigned int slen)
 {
 	u8 *buf = NULL;
 	int err;
@@ -56,11 +78,12 @@ static int rngapi_reset(struct crypto_rng *tfm, u8 *seed, unsigned int slen)
 		seed = buf;
 	}
 
-	err = crypto_rng_alg(tfm)->rng_reset(tfm, seed, slen);
+	err = tfm->seed(tfm, seed, slen);
 
 	kfree(buf);
 	return err;
 }
+EXPORT_SYMBOL_GPL(crypto_rng_reset);
 
 static int crypto_rng_init_tfm(struct crypto_tfm *tfm)
 {
diff --git a/include/crypto/rng.h b/include/crypto/rng.h
index f20f068..7fca371 100644
--- a/include/crypto/rng.h
+++ b/include/crypto/rng.h
@@ -19,7 +19,7 @@ struct crypto_rng {
 	int (*generate)(struct crypto_rng *tfm,
 			const u8 *src, unsigned int slen,
 			u8 *dst, unsigned int dlen);
-	int (*seed)(struct crypto_rng *tfm, u8 *seed, unsigned int slen);
+	int (*seed)(struct crypto_rng *tfm, const u8 *seed, unsigned int slen);
 	struct crypto_tfm base;
 };
 
@@ -139,11 +139,8 @@ static inline int crypto_rng_get_bytes(struct crypto_rng *tfm,
  *
  * Return: 0 if the setting of the key was successful; < 0 if an error occurred
  */
-static inline int crypto_rng_reset(struct crypto_rng *tfm,
-				   u8 *seed, unsigned int slen)
-{
-	return tfm->seed(tfm, seed, slen);
-}
+int crypto_rng_reset(struct crypto_rng *tfm, const u8 *seed,
+		     unsigned int slen);
 
 /**
  * crypto_rng_seedsize() - obtain seed size of RNG

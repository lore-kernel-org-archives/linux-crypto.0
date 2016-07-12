From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 3/30] crypto: aead - Add chunk size
Date: Tue, 12 Jul 2016 13:17:33 +0800
Message-ID: <E1bMq4b-0007Ob-NP@gondolin.me.apana.org.au>
References: <20160712051554.GA28324@gondor.apana.org.au>
To: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:56953 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753152AbcGLFRg (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 12 Jul 2016 01:17:36 -0400
Received: from gondolin.me.apana.org.au ([192.168.0.6])
	by norbury.hengli.com.au with esmtp (Exim 4.80 #3 (Debian))
	id 1bMq4b-0004YD-SE
	for <linux-crypto@vger.kernel.org>; Tue, 12 Jul 2016 15:17:33 +1000
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

This patch adds a chunk size parameter to aead algorithms, just
like the chunk size for skcipher algorithms.

However, unlike skcipher we do not currently export this to AEAD
users.  It is only meant to be used by AEAD implementors for now.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
---

 crypto/aead.c                  |    6 +++++-
 include/crypto/aead.h          |   12 +++++++-----
 include/crypto/internal/aead.h |   21 +++++++++++++++++++++
 3 files changed, 33 insertions(+), 6 deletions(-)

diff --git a/crypto/aead.c b/crypto/aead.c
index 9b18a1e..b155cbc 100644
--- a/crypto/aead.c
+++ b/crypto/aead.c
@@ -346,9 +346,13 @@ static int aead_prepare_alg(struct aead_alg *alg)
 {
 	struct crypto_alg *base = &alg->base;
 
-	if (max(alg->maxauthsize, alg->ivsize) > PAGE_SIZE / 8)
+	if (max3(alg->maxauthsize, alg->ivsize, alg->chunksize) >
+	    PAGE_SIZE / 8)
 		return -EINVAL;
 
+	if (!alg->chunksize)
+		alg->chunksize = base->cra_blocksize;
+
 	base->cra_type = &crypto_aead_type;
 	base->cra_flags &= ~CRYPTO_ALG_TYPE_MASK;
 	base->cra_flags |= CRYPTO_ALG_TYPE_AEAD;
diff --git a/include/crypto/aead.h b/include/crypto/aead.h
index 75174f8..12f8432 100644
--- a/include/crypto/aead.h
+++ b/include/crypto/aead.h
@@ -112,11 +112,12 @@ struct aead_request {
  *		 supplied during the decryption operation. This function is also
  *		 responsible for checking the authentication tag size for
  *		 validity.
- * @setkey: see struct ablkcipher_alg
- * @encrypt: see struct ablkcipher_alg
- * @decrypt: see struct ablkcipher_alg
- * @geniv: see struct ablkcipher_alg
- * @ivsize: see struct ablkcipher_alg
+ * @setkey: see struct skcipher_alg
+ * @encrypt: see struct skcipher_alg
+ * @decrypt: see struct skcipher_alg
+ * @geniv: see struct skcipher_alg
+ * @ivsize: see struct skcipher_alg
+ * @chunksize: see struct skcipher_alg
  * @init: Initialize the cryptographic transformation object. This function
  *	  is used to initialize the cryptographic transformation object.
  *	  This function is called only once at the instantiation time, right
@@ -145,6 +146,7 @@ struct aead_alg {
 
 	unsigned int ivsize;
 	unsigned int maxauthsize;
+	unsigned int chunksize;
 
 	struct crypto_alg base;
 };
diff --git a/include/crypto/internal/aead.h b/include/crypto/internal/aead.h
index da38649..6ad8e31 100644
--- a/include/crypto/internal/aead.h
+++ b/include/crypto/internal/aead.h
@@ -159,6 +159,27 @@ static inline struct aead_request *aead_get_backlog(struct aead_queue *queue)
 	return req ? container_of(req, struct aead_request, base) : NULL;
 }
 
+static inline unsigned int crypto_aead_alg_chunksize(struct aead_alg *alg)
+{
+	return alg->chunksize;
+}
+
+/**
+ * crypto_aead_chunksize() - obtain chunk size
+ * @tfm: cipher handle
+ *
+ * The block size is set to one for ciphers such as CCM.  However,
+ * you still need to provide incremental updates in multiples of
+ * the underlying block size as the IV does not have sub-block
+ * granularity.  This is known in this API as the chunk size.
+ *
+ * Return: chunk size in bytes
+ */
+static inline unsigned int crypto_aead_chunksize(struct crypto_aead *tfm)
+{
+	return crypto_aead_alg_chunksize(crypto_aead_alg(tfm));
+}
+
 int crypto_register_aead(struct aead_alg *alg);
 void crypto_unregister_aead(struct aead_alg *alg);
 int crypto_register_aeads(struct aead_alg *algs, int count);

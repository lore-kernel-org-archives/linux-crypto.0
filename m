From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 3/4] [CRYPTO] skcipher: Fix givcrypt on zero IV ciphers
Date: Fri, 14 Dec 2007 16:39:45 +0800
Message-ID: <E1J365B-000475-00@gondolin.me.apana.org.au>
References: <20071214083909.GA15726@gondor.apana.org.au>
To: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from rhun.apana.org.au ([64.62.148.172]:4703 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757139AbXLNIjs (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Fri, 14 Dec 2007 03:39:48 -0500
Received: from gondolin.me.apana.org.au ([192.168.0.6] ident=mail)
	by arnor.apana.org.au with esmtp (Exim 4.50 #1 (Debian))
	id 1J365B-000095-RV
	for <linux-crypto@vger.kernel.org>; Fri, 14 Dec 2007 19:39:46 +1100
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

[CRYPTO] skcipher: Fix givcrypt on zero IV ciphers

We need to set the givencrypt/givdecrypt on zero IV ciphers to the
encrypt/decrypt functions.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
---

 crypto/ablkcipher.c                |   14 ++++++++++++++
 crypto/aead.c                      |   14 ++++++++++++++
 crypto/blkcipher.c                 |    4 ++++
 include/crypto/internal/skcipher.h |    2 ++
 4 files changed, 34 insertions(+)

diff --git a/crypto/ablkcipher.c b/crypto/ablkcipher.c
index 0bfc01f..ca08290 100644
--- a/crypto/ablkcipher.c
+++ b/crypto/ablkcipher.c
@@ -70,6 +70,16 @@ static unsigned int crypto_ablkcipher_ctxsize(struct crypto_alg *alg, u32 type,
 	return alg->cra_ctxsize;
 }
 
+int skcipher_null_givencrypt(struct skcipher_givcrypt_request *req)
+{
+	return crypto_ablkcipher_encrypt(&req->creq);
+}
+
+int skcipher_null_givdecrypt(struct skcipher_givcrypt_request *req)
+{
+	return crypto_ablkcipher_decrypt(&req->creq);
+}
+
 static int crypto_init_ablkcipher_ops(struct crypto_tfm *tfm, u32 type,
 				      u32 mask)
 {
@@ -82,6 +92,10 @@ static int crypto_init_ablkcipher_ops(struct crypto_tfm *tfm, u32 type,
 	crt->setkey = setkey;
 	crt->encrypt = alg->encrypt;
 	crt->decrypt = alg->decrypt;
+	if (!alg->ivsize) {
+		crt->givencrypt = skcipher_null_givencrypt;
+		crt->givdecrypt = skcipher_null_givdecrypt;
+	}
 	crt->base = __crypto_ablkcipher_cast(tfm);
 	crt->ivsize = alg->ivsize;
 
diff --git a/crypto/aead.c b/crypto/aead.c
index 68fa3d2..2bf039b 100644
--- a/crypto/aead.c
+++ b/crypto/aead.c
@@ -130,6 +130,16 @@ const struct crypto_type crypto_aead_type = {
 };
 EXPORT_SYMBOL_GPL(crypto_aead_type);
 
+static int aead_null_givencrypt(struct aead_givcrypt_request *req)
+{
+	return crypto_aead_encrypt(&req->areq);
+}
+
+static int aead_null_givdecrypt(struct aead_givcrypt_request *req)
+{
+	return crypto_aead_decrypt(&req->areq);
+}
+
 static int crypto_init_nivaead_ops(struct crypto_tfm *tfm, u32 type, u32 mask)
 {
 	struct aead_alg *alg = &tfm->__crt_alg->cra_aead;
@@ -141,6 +151,10 @@ static int crypto_init_nivaead_ops(struct crypto_tfm *tfm, u32 type, u32 mask)
 	crt->setkey = setkey;
 	crt->encrypt = alg->encrypt;
 	crt->decrypt = alg->decrypt;
+	if (!alg->ivsize) {
+		crt->givencrypt = aead_null_givencrypt;
+		crt->givdecrypt = aead_null_givdecrypt;
+	}
 	crt->base = __crypto_aead_cast(tfm);
 	crt->ivsize = alg->ivsize;
 	crt->authsize = alg->maxauthsize;
diff --git a/crypto/blkcipher.c b/crypto/blkcipher.c
index 6f84481..88407e5 100644
--- a/crypto/blkcipher.c
+++ b/crypto/blkcipher.c
@@ -450,6 +450,10 @@ static int crypto_init_blkcipher_ops_async(struct crypto_tfm *tfm)
 	crt->setkey = async_setkey;
 	crt->encrypt = async_encrypt;
 	crt->decrypt = async_decrypt;
+	if (!alg->ivsize) {
+		crt->givencrypt = skcipher_null_givencrypt;
+		crt->givdecrypt = skcipher_null_givdecrypt;
+	}
 	crt->base = __crypto_ablkcipher_cast(tfm);
 	crt->ivsize = alg->ivsize;
 
diff --git a/include/crypto/internal/skcipher.h b/include/crypto/internal/skcipher.h
index ecf2c8d..0053f34 100644
--- a/include/crypto/internal/skcipher.h
+++ b/include/crypto/internal/skcipher.h
@@ -53,6 +53,8 @@ static inline struct crypto_ablkcipher *crypto_spawn_skcipher(
 				 crypto_skcipher_mask(0)));
 }
 
+int skcipher_null_givencrypt(struct skcipher_givcrypt_request *req);
+int skcipher_null_givdecrypt(struct skcipher_givcrypt_request *req);
 const char *crypto_default_geniv(const struct crypto_alg *alg);
 
 struct crypto_instance *skcipher_geniv_alloc(struct crypto_template *tmpl,

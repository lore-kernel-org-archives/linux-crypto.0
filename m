From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 1/2] crypto: hash - Add crypto_ahash_has_setkey
Date: Fri, 8 Jan 2016 21:28:26 +0800
Message-ID: <20160108132826.GA5808@gondor.apana.org.au>
References: <CACT4Y+YOwOfRHOwJ=FA9aaL2cZ-PRhTvd_mCzxx2nnN_L3tygw@mail.gmail.com>
 <5687BA0F.3020104@gmail.com>
 <5687E19E.2070801@gmail.com>
 <1647086.cdlVYfuqk1@myon.chronox.de>
 <56883096.1020009@gmail.com>
 <20160103013126.GA30385@gondor.apana.org.au>
 <5688ED04.4090802@gmail.com>
 <20160104043518.GA4411@gondor.apana.org.au>
 <568A66B2.4090307@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Stephan Mueller <smueller@chronox.de>,
	Dmitry Vyukov <dvyukov@google.com>, syzkaller@googlegroups.com,
	davem@davemloft.net, linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org, kcc@google.com, glider@google.com,
	edumazet@google.com, sasha.levin@oracle.com, keescook@google.com,
	Ondrej Kozina <okozina@redhat.com>
To: Milan Broz <gmazyland@gmail.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:43383 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752349AbcAHN2l (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Fri, 8 Jan 2016 08:28:41 -0500
Content-Disposition: inline
In-Reply-To: <568A66B2.4090307@gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

This patch adds a way for ahash users to determine whether a key
is required by a crypto_ahash transform.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>

diff --git a/crypto/ahash.c b/crypto/ahash.c
index 9c1dc8d..d19b523 100644
--- a/crypto/ahash.c
+++ b/crypto/ahash.c
@@ -451,6 +451,7 @@ static int crypto_ahash_init_tfm(struct crypto_tfm *tfm)
 	struct ahash_alg *alg = crypto_ahash_alg(hash);
 
 	hash->setkey = ahash_nosetkey;
+	hash->has_setkey = false;
 	hash->export = ahash_no_export;
 	hash->import = ahash_no_import;
 
@@ -463,8 +464,10 @@ static int crypto_ahash_init_tfm(struct crypto_tfm *tfm)
 	hash->finup = alg->finup ?: ahash_def_finup;
 	hash->digest = alg->digest;
 
-	if (alg->setkey)
+	if (alg->setkey) {
 		hash->setkey = alg->setkey;
+		hash->has_setkey = true;
+	}
 	if (alg->export)
 		hash->export = alg->export;
 	if (alg->import)
diff --git a/crypto/shash.c b/crypto/shash.c
index ecb1e3d..88a27de 100644
--- a/crypto/shash.c
+++ b/crypto/shash.c
@@ -355,8 +355,10 @@ int crypto_init_shash_ops_async(struct crypto_tfm *tfm)
 	crt->finup = shash_async_finup;
 	crt->digest = shash_async_digest;
 
-	if (alg->setkey)
+	if (alg->setkey) {
 		crt->setkey = shash_async_setkey;
+		crt->has_setkey = true;
+	}
 	if (alg->export)
 		crt->export = shash_async_export;
 	if (alg->import)
diff --git a/include/crypto/hash.h b/include/crypto/hash.h
index 3d69c93..6361892 100644
--- a/include/crypto/hash.h
+++ b/include/crypto/hash.h
@@ -204,6 +204,7 @@ struct crypto_ahash {
 		      unsigned int keylen);
 
 	unsigned int reqsize;
+	bool has_setkey;
 	struct crypto_tfm base;
 };
 
@@ -375,6 +376,11 @@ static inline void *ahash_request_ctx(struct ahash_request *req)
 int crypto_ahash_setkey(struct crypto_ahash *tfm, const u8 *key,
 			unsigned int keylen);
 
+static inline bool crypto_ahash_has_setkey(struct crypto_ahash *tfm)
+{
+	return tfm->has_setkey;
+}
+
 /**
  * crypto_ahash_finup() - update and finalize message digest
  * @req: reference to the ahash_request handle that holds all information
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt

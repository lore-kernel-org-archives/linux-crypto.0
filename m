From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 3/4] [CRYPTO] ablkcipher: Add distinct ABLKCIPHER type
Date: Sun, 18 Nov 2007 21:32:01 +0800
Message-ID: <E1ItkFl-0007T1-00@gondolin.me.apana.org.au>
References: <20071118133054.GA28619@gondor.apana.org.au>
To: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from rhun.apana.org.au ([64.62.148.172]:4580 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752223AbXKRNcE (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Sun, 18 Nov 2007 08:32:04 -0500
Received: from gondolin.me.apana.org.au ([192.168.0.6] ident=mail)
	by arnor.apana.org.au with esmtp (Exim 4.50 #1 (Debian))
	id 1ItkFl-00073X-SL
	for <linux-crypto@vger.kernel.org>; Mon, 19 Nov 2007 00:32:02 +1100
Sender: linux-crypto-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

[CRYPTO] ablkcipher: Add distinct ABLKCIPHER type

Up until now we have ablkcipher algorithms have been identified as
type BLKCIPHER with the ASYNC bit set.  This is suboptimal because
ablkcipher refers to two things.  On the one hand it refers to the
top-level ablkcipher interface with requests.  On the other hand it
refers to and algorithm type underneath.

As it is you cannot request a synchronous block cipher algorithm
with the ablkcipher interface on top.  This is a problem because
we want to be able to eventually phase out the blkcipher top-level
interface.

This patch fixes this by making ABLKCIPHER its own type, just as
we have distinct types for HASH and DIGEST.  The type it associated
with the algorithm implementation only.

Which top-level interface is used for synchronous block ciphers is
then determined by the mask that's used.  If it's a specific mask
then the old blkcipher interface is given, otherwise we go with the
new ablkcipher interface.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
---

 crypto/authenc.c           |    2 +-
 crypto/blkcipher.c         |    9 +++------
 crypto/cryptd.c            |    4 ++--
 drivers/crypto/hifn_795x.c |    2 +-
 include/crypto/algapi.h    |    4 ++--
 include/linux/crypto.h     |   18 ++++++++++--------
 6 files changed, 19 insertions(+), 20 deletions(-)

diff --git a/crypto/authenc.c b/crypto/authenc.c
index 126a529..bc4e608 100644
--- a/crypto/authenc.c
+++ b/crypto/authenc.c
@@ -292,7 +292,7 @@ static struct crypto_instance *crypto_authenc_alloc(struct rtattr **tb)
 		goto out_put_auth;
 
 	enc = crypto_attr_alg(tb[3], CRYPTO_ALG_TYPE_BLKCIPHER,
-			      CRYPTO_ALG_TYPE_MASK);
+			      CRYPTO_ALG_TYPE_BLKCIPHER_MASK);
 	inst = ERR_PTR(PTR_ERR(enc));
 	if (IS_ERR(enc))
 		goto out_put_auth;
diff --git a/crypto/blkcipher.c b/crypto/blkcipher.c
index f6c67f9..180d914 100644
--- a/crypto/blkcipher.c
+++ b/crypto/blkcipher.c
@@ -433,9 +433,8 @@ static unsigned int crypto_blkcipher_ctxsize(struct crypto_alg *alg, u32 type,
 	struct blkcipher_alg *cipher = &alg->cra_blkcipher;
 	unsigned int len = alg->cra_ctxsize;
 
-	type ^= CRYPTO_ALG_ASYNC;
-	mask &= CRYPTO_ALG_ASYNC;
-	if ((type & mask) && cipher->ivsize) {
+	if ((mask & CRYPTO_ALG_TYPE_MASK) == CRYPTO_ALG_TYPE_MASK &&
+	    cipher->ivsize) {
 		len = ALIGN(len, (unsigned long)alg->cra_alignmask + 1);
 		len += cipher->ivsize;
 	}
@@ -482,9 +481,7 @@ static int crypto_init_blkcipher_ops(struct crypto_tfm *tfm, u32 type, u32 mask)
 	if (alg->ivsize > PAGE_SIZE / 8)
 		return -EINVAL;
 
-	type ^= CRYPTO_ALG_ASYNC;
-	mask &= CRYPTO_ALG_ASYNC;
-	if (type & mask)
+	if ((mask & CRYPTO_ALG_TYPE_MASK) == CRYPTO_ALG_TYPE_MASK)
 		return crypto_init_blkcipher_ops_sync(tfm);
 	else
 		return crypto_init_blkcipher_ops_async(tfm);
diff --git a/crypto/cryptd.c b/crypto/cryptd.c
index 8bf2da8..1a5c45b 100644
--- a/crypto/cryptd.c
+++ b/crypto/cryptd.c
@@ -228,7 +228,7 @@ static struct crypto_instance *cryptd_alloc_blkcipher(
 	struct crypto_alg *alg;
 
 	alg = crypto_get_attr_alg(tb, CRYPTO_ALG_TYPE_BLKCIPHER,
-				  CRYPTO_ALG_TYPE_MASK | CRYPTO_ALG_ASYNC);
+				  CRYPTO_ALG_TYPE_MASK);
 	if (IS_ERR(alg))
 		return ERR_PTR(PTR_ERR(alg));
 
@@ -236,7 +236,7 @@ static struct crypto_instance *cryptd_alloc_blkcipher(
 	if (IS_ERR(inst))
 		goto out_put_alg;
 
-	inst->alg.cra_flags = CRYPTO_ALG_TYPE_BLKCIPHER | CRYPTO_ALG_ASYNC;
+	inst->alg.cra_flags = CRYPTO_ALG_TYPE_ABLKCIPHER | CRYPTO_ALG_ASYNC;
 	inst->alg.cra_type = &crypto_ablkcipher_type;
 
 	inst->alg.cra_ablkcipher.ivsize = alg->cra_blkcipher.ivsize;
diff --git a/drivers/crypto/hifn_795x.c b/drivers/crypto/hifn_795x.c
index fec32aa..bf817d4 100644
--- a/drivers/crypto/hifn_795x.c
+++ b/drivers/crypto/hifn_795x.c
@@ -2361,7 +2361,7 @@ static int hifn_alg_alloc(struct hifn_device *dev, struct hifn_alg_template *t)
 	snprintf(alg->alg.cra_driver_name, CRYPTO_MAX_ALG_NAME, "%s", t->drv_name);
 
 	alg->alg.cra_priority = 300;
-	alg->alg.cra_flags = CRYPTO_ALG_TYPE_BLKCIPHER | CRYPTO_ALG_ASYNC;
+	alg->alg.cra_flags = CRYPTO_ALG_TYPE_ABLKCIPHER | CRYPTO_ALG_ASYNC;
 	alg->alg.cra_blocksize = t->bsize;
 	alg->alg.cra_ctxsize = sizeof(struct hifn_context);
 	alg->alg.cra_alignmask = 15;
diff --git a/include/crypto/algapi.h b/include/crypto/algapi.h
index b9b05d3..88619f9 100644
--- a/include/crypto/algapi.h
+++ b/include/crypto/algapi.h
@@ -191,7 +191,7 @@ static inline struct crypto_ablkcipher *crypto_spawn_ablkcipher(
 	struct crypto_spawn *spawn)
 {
 	u32 type = CRYPTO_ALG_TYPE_BLKCIPHER;
-	u32 mask = CRYPTO_ALG_TYPE_MASK;
+	u32 mask = CRYPTO_ALG_TYPE_BLKCIPHER_MASK;
 
 	return __crypto_ablkcipher_cast(crypto_spawn_tfm(spawn, type, mask));
 }
@@ -200,7 +200,7 @@ static inline struct crypto_blkcipher *crypto_spawn_blkcipher(
 	struct crypto_spawn *spawn)
 {
 	u32 type = CRYPTO_ALG_TYPE_BLKCIPHER;
-	u32 mask = CRYPTO_ALG_TYPE_MASK | CRYPTO_ALG_ASYNC;
+	u32 mask = CRYPTO_ALG_TYPE_MASK;
 
 	return __crypto_blkcipher_cast(crypto_spawn_tfm(spawn, type, mask));
 }
diff --git a/include/linux/crypto.h b/include/linux/crypto.h
index f3110eb..f56ae87 100644
--- a/include/linux/crypto.h
+++ b/include/linux/crypto.h
@@ -33,10 +33,12 @@
 #define CRYPTO_ALG_TYPE_DIGEST		0x00000002
 #define CRYPTO_ALG_TYPE_HASH		0x00000003
 #define CRYPTO_ALG_TYPE_BLKCIPHER	0x00000004
-#define CRYPTO_ALG_TYPE_COMPRESS	0x00000005
-#define CRYPTO_ALG_TYPE_AEAD		0x00000006
+#define CRYPTO_ALG_TYPE_ABLKCIPHER	0x00000005
+#define CRYPTO_ALG_TYPE_COMPRESS	0x00000008
+#define CRYPTO_ALG_TYPE_AEAD		0x00000009
 
 #define CRYPTO_ALG_TYPE_HASH_MASK	0x0000000e
+#define CRYPTO_ALG_TYPE_BLKCIPHER_MASK	0x0000000c
 
 #define CRYPTO_ALG_LARVAL		0x00000010
 #define CRYPTO_ALG_DEAD			0x00000020
@@ -530,7 +532,7 @@ static inline struct crypto_ablkcipher *crypto_alloc_ablkcipher(
 {
 	type &= ~CRYPTO_ALG_TYPE_MASK;
 	type |= CRYPTO_ALG_TYPE_BLKCIPHER;
-	mask |= CRYPTO_ALG_TYPE_MASK;
+	mask |= CRYPTO_ALG_TYPE_BLKCIPHER_MASK;
 
 	return __crypto_ablkcipher_cast(
 		crypto_alloc_base(alg_name, type, mask));
@@ -552,7 +554,7 @@ static inline int crypto_has_ablkcipher(const char *alg_name, u32 type,
 {
 	type &= ~CRYPTO_ALG_TYPE_MASK;
 	type |= CRYPTO_ALG_TYPE_BLKCIPHER;
-	mask |= CRYPTO_ALG_TYPE_MASK;
+	mask |= CRYPTO_ALG_TYPE_BLKCIPHER_MASK;
 
 	return crypto_has_alg(alg_name, type, mask);
 }
@@ -841,9 +843,9 @@ static inline struct crypto_blkcipher *crypto_blkcipher_cast(
 static inline struct crypto_blkcipher *crypto_alloc_blkcipher(
 	const char *alg_name, u32 type, u32 mask)
 {
-	type &= ~(CRYPTO_ALG_TYPE_MASK | CRYPTO_ALG_ASYNC);
+	type &= ~CRYPTO_ALG_TYPE_MASK;
 	type |= CRYPTO_ALG_TYPE_BLKCIPHER;
-	mask |= CRYPTO_ALG_TYPE_MASK | CRYPTO_ALG_ASYNC;
+	mask |= CRYPTO_ALG_TYPE_MASK;
 
 	return __crypto_blkcipher_cast(crypto_alloc_base(alg_name, type, mask));
 }
@@ -861,9 +863,9 @@ static inline void crypto_free_blkcipher(struct crypto_blkcipher *tfm)
 
 static inline int crypto_has_blkcipher(const char *alg_name, u32 type, u32 mask)
 {
-	type &= ~(CRYPTO_ALG_TYPE_MASK | CRYPTO_ALG_ASYNC);
+	type &= ~CRYPTO_ALG_TYPE_MASK;
 	type |= CRYPTO_ALG_TYPE_BLKCIPHER;
-	mask |= CRYPTO_ALG_TYPE_MASK | CRYPTO_ALG_ASYNC;
+	mask |= CRYPTO_ALG_TYPE_MASK;
 
 	return crypto_has_alg(alg_name, type, mask);
 }

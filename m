From: Stephan Mueller <smueller@chronox.de>
Subject: [PATCH v2 03/20] crypto: cryptd to process CRYPTO_ALG_INTERNAL
Date: Fri, 27 Mar 2015 23:51:28 +0100
Message-ID: <40789392.jrG7B6nBYt@tachyon.chronox.de>
References: <1746748.uPZFXamDiM@tachyon.chronox.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
To: 'Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1746748.uPZFXamDiM@tachyon.chronox.de>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

The cryptd is used as a wrapper around internal ciphers. Therefore, the
cryptd must process the internal cipher by marking cryptd as internal if
the underlying cipher is an internal cipher.

Signed-off-by: Stephan Mueller <smueller@chronox.de>
---
 crypto/ablk_helper.c |  3 ++-
 crypto/cryptd.c      | 49 +++++++++++++++++++++++++++++++++++++++++--------
 2 files changed, 43 insertions(+), 9 deletions(-)

diff --git a/crypto/ablk_helper.c b/crypto/ablk_helper.c
index ffe7278..e1fcf53 100644
--- a/crypto/ablk_helper.c
+++ b/crypto/ablk_helper.c
@@ -124,7 +124,8 @@ int ablk_init_common(struct crypto_tfm *tfm, const char *drv_name)
 	struct async_helper_ctx *ctx = crypto_tfm_ctx(tfm);
 	struct cryptd_ablkcipher *cryptd_tfm;
 
-	cryptd_tfm = cryptd_alloc_ablkcipher(drv_name, 0, 0);
+	cryptd_tfm = cryptd_alloc_ablkcipher(drv_name, CRYPTO_ALG_INTERNAL,
+					     CRYPTO_ALG_INTERNAL);
 	if (IS_ERR(cryptd_tfm))
 		return PTR_ERR(cryptd_tfm);
 
diff --git a/crypto/cryptd.c b/crypto/cryptd.c
index 650afac1..b0602ba 100644
--- a/crypto/cryptd.c
+++ b/crypto/cryptd.c
@@ -168,6 +168,20 @@ static inline struct cryptd_queue *cryptd_get_queue(struct crypto_tfm *tfm)
 	return ictx->queue;
 }
 
+static inline void cryptd_check_internal(struct rtattr **tb, u32 *type,
+					 u32 *mask)
+{
+	struct crypto_attr_type *algt;
+
+	algt = crypto_get_attr_type(tb);
+	if (IS_ERR(algt))
+		return;
+	if ((algt->type & CRYPTO_ALG_INTERNAL))
+		*type |= CRYPTO_ALG_INTERNAL;
+	if ((algt->mask & CRYPTO_ALG_INTERNAL))
+		*mask |= CRYPTO_ALG_INTERNAL;
+}
+
 static int cryptd_blkcipher_setkey(struct crypto_ablkcipher *parent,
 				   const u8 *key, unsigned int keylen)
 {
@@ -321,10 +335,13 @@ static int cryptd_create_blkcipher(struct crypto_template *tmpl,
 	struct cryptd_instance_ctx *ctx;
 	struct crypto_instance *inst;
 	struct crypto_alg *alg;
+	u32 type = CRYPTO_ALG_TYPE_BLKCIPHER;
+	u32 mask = CRYPTO_ALG_TYPE_MASK;
 	int err;
 
-	alg = crypto_get_attr_alg(tb, CRYPTO_ALG_TYPE_BLKCIPHER,
-				  CRYPTO_ALG_TYPE_MASK);
+	cryptd_check_internal(tb, &type, &mask);
+
+	alg = crypto_get_attr_alg(tb, type, mask);
 	if (IS_ERR(alg))
 		return PTR_ERR(alg);
 
@@ -341,7 +358,10 @@ static int cryptd_create_blkcipher(struct crypto_template *tmpl,
 	if (err)
 		goto out_free_inst;
 
-	inst->alg.cra_flags = CRYPTO_ALG_TYPE_ABLKCIPHER | CRYPTO_ALG_ASYNC;
+	type = CRYPTO_ALG_TYPE_ABLKCIPHER | CRYPTO_ALG_ASYNC;
+	if (alg->cra_flags & CRYPTO_ALG_INTERNAL)
+		type |= CRYPTO_ALG_INTERNAL;
+	inst->alg.cra_flags = type;
 	inst->alg.cra_type = &crypto_ablkcipher_type;
 
 	inst->alg.cra_ablkcipher.ivsize = alg->cra_blkcipher.ivsize;
@@ -577,9 +597,13 @@ static int cryptd_create_hash(struct crypto_template *tmpl, struct rtattr **tb,
 	struct ahash_instance *inst;
 	struct shash_alg *salg;
 	struct crypto_alg *alg;
+	u32 type = 0;
+	u32 mask = 0;
 	int err;
 
-	salg = shash_attr_alg(tb[1], 0, 0);
+	cryptd_check_internal(tb, &type, &mask);
+
+	salg = shash_attr_alg(tb[1], type, mask);
 	if (IS_ERR(salg))
 		return PTR_ERR(salg);
 
@@ -598,7 +622,10 @@ static int cryptd_create_hash(struct crypto_template *tmpl, struct rtattr **tb,
 	if (err)
 		goto out_free_inst;
 
-	inst->alg.halg.base.cra_flags = CRYPTO_ALG_ASYNC;
+	type = CRYPTO_ALG_ASYNC;
+	if (alg->cra_flags & CRYPTO_ALG_INTERNAL)
+		type |= CRYPTO_ALG_INTERNAL;
+	inst->alg.halg.base.cra_flags = type;
 
 	inst->alg.halg.digestsize = salg->digestsize;
 	inst->alg.halg.base.cra_ctxsize = sizeof(struct cryptd_hash_ctx);
@@ -719,10 +746,13 @@ static int cryptd_create_aead(struct crypto_template *tmpl,
 	struct aead_instance_ctx *ctx;
 	struct crypto_instance *inst;
 	struct crypto_alg *alg;
+	u32 type = CRYPTO_ALG_TYPE_AEAD;
+	u32 mask = CRYPTO_ALG_TYPE_MASK;
 	int err;
 
-	alg = crypto_get_attr_alg(tb, CRYPTO_ALG_TYPE_AEAD,
-				CRYPTO_ALG_TYPE_MASK);
+	cryptd_check_internal(tb, &type, &mask);
+
+	alg = crypto_get_attr_alg(tb, type, mask);
         if (IS_ERR(alg))
 		return PTR_ERR(alg);
 
@@ -739,7 +769,10 @@ static int cryptd_create_aead(struct crypto_template *tmpl,
 	if (err)
 		goto out_free_inst;
 
-	inst->alg.cra_flags = CRYPTO_ALG_TYPE_AEAD | CRYPTO_ALG_ASYNC;
+	type = CRYPTO_ALG_TYPE_AEAD | CRYPTO_ALG_ASYNC;
+	if (alg->cra_flags & CRYPTO_ALG_INTERNAL)
+		type |= CRYPTO_ALG_INTERNAL;
+	inst->alg.cra_flags = type;
 	inst->alg.cra_type = alg->cra_type;
 	inst->alg.cra_ctxsize = sizeof(struct cryptd_aead_ctx);
 	inst->alg.cra_init = cryptd_aead_init_tfm;
-- 
2.1.0

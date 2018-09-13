From: Kees Cook <keescook@chromium.org>
Subject: [PATCH][RFC] crypto: skcipher: Remove VLA usage
Date: Thu, 13 Sep 2018 11:23:28 -0700
Message-ID: <20180913182328.GA9812@beast>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        Eric Biggers <ebiggers@google.com>,
        Gilad Ben-Yossef <gilad@benyossef.com>,
        Alexander Stein <alexander.stein@systec-electronic.com>,
        Antoine Tenart <antoine.tenart@bootlin.com>,
        Boris Brezillon <boris.brezillon@bootlin.com>,
        Arnaud Ebalard <arno@natisbad.org>,
        Corentin Labbe <clabbe.montjoie@gmail.com>,
        Maxime Ripard <maxime.ripard@bootlin.com>,
        Chen-Yu Tsai <wens@csie.org>,
        Christian Lamparter <chunkeey@gmail.com>,
        Philippe Ombredanne <pombredanne@nexb.com>,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>,
        linux-crypto@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

RFC follow-up to https://lkml.kernel.org/r/CAGXu5j+bpLK=EQ9LHkO8V=sdaQwt==6fbGhgn2Vi1E9_WxSGRQ@mail.gmail.com

The core API changes:

	struct crypto_sync_skcipher
	crypto_alloc_sync_skcipher()
	crypto_free_sync_skcipher()
	crypto_sync_skcipher_setkey()
	skcipher_request_set_sync_tfm()
	SKCIPHER_REQUEST_ON_STACK type check

and a single user's refactoring as an example:

	drivers/crypto/ccp/ccp-crypto.h
	drivers/crypto/ccp/ccp-crypto-aes-xts.c

Does this look correct? If so, I can continue and do the other 60
instances of SKCIPHER_REQUEST_ON_STACK().

Signed-off-by: Kees Cook <keescook@chromium.org>
---
 crypto/skcipher.c                       | 24 +++++++++++++++++
 drivers/crypto/ccp/ccp-crypto-aes-xts.c | 10 ++++----
 drivers/crypto/ccp/ccp-crypto.h         |  2 +-
 include/crypto/skcipher.h               | 34 ++++++++++++++++++++++++-
 4 files changed, 63 insertions(+), 7 deletions(-)

diff --git a/crypto/skcipher.c b/crypto/skcipher.c
index 0bd8c6caa498..4caab81d2d02 100644
--- a/crypto/skcipher.c
+++ b/crypto/skcipher.c
@@ -949,6 +949,30 @@ struct crypto_skcipher *crypto_alloc_skcipher(const char *alg_name,
 }
 EXPORT_SYMBOL_GPL(crypto_alloc_skcipher);
 
+struct crypto_sync_skcipher *crypto_alloc_sync_skcipher(
+				const char *alg_name, u32 type, u32 mask)
+{
+	struct crypto_skcipher *tfm;
+
+	/* Only sync algorithms allowed. */
+	mask |= CRYPTO_ALG_ASYNC;
+
+	tfm = crypto_alloc_tfm(alg_name, &crypto_skcipher_type2, type, mask);
+
+	/*
+	 * Make sure we do not allocate something that might get used with
+	 * an on-stack request: check the request size.
+	 */
+	if (!IS_ERR(tfm) && WARN_ON(crypto_skcipher_reqsize(tfm) >
+				    MAX_SYNC_SKCIPHER_REQSIZE)) {
+		crypto_free_skcipher(tfm);
+		return ERR_PTR(-EINVAL);
+	}
+
+	return (struct crypto_sync_skcipher *)tfm;
+}
+EXPORT_SYMBOL_GPL(crypto_alloc_sync_skcipher);
+
 int crypto_has_skcipher2(const char *alg_name, u32 type, u32 mask)
 {
 	return crypto_type_has_alg(alg_name, &crypto_skcipher_type2,
diff --git a/drivers/crypto/ccp/ccp-crypto-aes-xts.c b/drivers/crypto/ccp/ccp-crypto-aes-xts.c
index 94b5bcf5b628..983c921736b4 100644
--- a/drivers/crypto/ccp/ccp-crypto-aes-xts.c
+++ b/drivers/crypto/ccp/ccp-crypto-aes-xts.c
@@ -102,7 +102,7 @@ static int ccp_aes_xts_setkey(struct crypto_ablkcipher *tfm, const u8 *key,
 	ctx->u.aes.key_len = key_len / 2;
 	sg_init_one(&ctx->u.aes.key_sg, ctx->u.aes.key, key_len);
 
-	return crypto_skcipher_setkey(ctx->u.aes.tfm_skcipher, key, key_len);
+	return crypto_sync_skcipher_setkey(ctx->u.aes.tfm_skcipher, key, key_len);
 }
 
 static int ccp_aes_xts_crypt(struct ablkcipher_request *req,
@@ -156,7 +156,7 @@ static int ccp_aes_xts_crypt(struct ablkcipher_request *req,
 		/* Use the fallback to process the request for any
 		 * unsupported unit sizes or key sizes
 		 */
-		skcipher_request_set_tfm(subreq, ctx->u.aes.tfm_skcipher);
+		skcipher_request_set_sync_tfm(subreq, ctx->u.aes.tfm_skcipher);
 		skcipher_request_set_callback(subreq, req->base.flags,
 					      NULL, NULL);
 		skcipher_request_set_crypt(subreq, req->src, req->dst,
@@ -203,12 +203,12 @@ static int ccp_aes_xts_decrypt(struct ablkcipher_request *req)
 static int ccp_aes_xts_cra_init(struct crypto_tfm *tfm)
 {
 	struct ccp_ctx *ctx = crypto_tfm_ctx(tfm);
-	struct crypto_skcipher *fallback_tfm;
+	struct crypto_sync_skcipher *fallback_tfm;
 
 	ctx->complete = ccp_aes_xts_complete;
 	ctx->u.aes.key_len = 0;
 
-	fallback_tfm = crypto_alloc_skcipher("xts(aes)", 0,
+	fallback_tfm = crypto_alloc_sync_skcipher("xts(aes)", 0,
 					     CRYPTO_ALG_ASYNC |
 					     CRYPTO_ALG_NEED_FALLBACK);
 	if (IS_ERR(fallback_tfm)) {
@@ -226,7 +226,7 @@ static void ccp_aes_xts_cra_exit(struct crypto_tfm *tfm)
 {
 	struct ccp_ctx *ctx = crypto_tfm_ctx(tfm);
 
-	crypto_free_skcipher(ctx->u.aes.tfm_skcipher);
+	crypto_free_sync_skcipher(ctx->u.aes.tfm_skcipher);
 }
 
 static int ccp_register_aes_xts_alg(struct list_head *head,
diff --git a/drivers/crypto/ccp/ccp-crypto.h b/drivers/crypto/ccp/ccp-crypto.h
index b9fd090c46c2..28819e11db96 100644
--- a/drivers/crypto/ccp/ccp-crypto.h
+++ b/drivers/crypto/ccp/ccp-crypto.h
@@ -88,7 +88,7 @@ static inline struct ccp_crypto_ahash_alg *
 /***** AES related defines *****/
 struct ccp_aes_ctx {
 	/* Fallback cipher for XTS with unsupported unit sizes */
-	struct crypto_skcipher *tfm_skcipher;
+	struct crypto_sync_skcipher *tfm_skcipher;
 
 	/* Cipher used to generate CMAC K1/K2 keys */
 	struct crypto_cipher *tfm_cipher;
diff --git a/include/crypto/skcipher.h b/include/crypto/skcipher.h
index 2f327f090c3e..4435f3a3d621 100644
--- a/include/crypto/skcipher.h
+++ b/include/crypto/skcipher.h
@@ -65,6 +65,10 @@ struct crypto_skcipher {
 	struct crypto_tfm base;
 };
 
+struct crypto_sync_skcipher {
+	struct crypto_skcipher base;
+};
+
 /**
  * struct skcipher_alg - symmetric key cipher definition
  * @min_keysize: Minimum key size supported by the transformation. This is the
@@ -139,9 +143,17 @@ struct skcipher_alg {
 	struct crypto_alg base;
 };
 
+#define MAX_SYNC_SKCIPHER_REQSIZE      384
+/*
+ * This performs a type-check against the "tfm" argument to make sure
+ * all users have the correct skcipher tfm for doing on-stack requests.
+ */
 #define SKCIPHER_REQUEST_ON_STACK(name, tfm) \
 	char __##name##_desc[sizeof(struct skcipher_request) + \
-		crypto_skcipher_reqsize(tfm)] CRYPTO_MINALIGN_ATTR; \
+			     MAX_SYNC_SKCIPHER_REQSIZE + \
+			     (!(sizeof((struct crypto_sync_skcipher *)1 == \
+				       (typeof(tfm))1))) \
+			    ] CRYPTO_MINALIGN_ATTR; \
 	struct skcipher_request *name = (void *)__##name##_desc
 
 /**
@@ -197,6 +209,9 @@ static inline struct crypto_skcipher *__crypto_skcipher_cast(
 struct crypto_skcipher *crypto_alloc_skcipher(const char *alg_name,
 					      u32 type, u32 mask);
 
+struct crypto_sync_skcipher *crypto_alloc_sync_skcipher(const char *alg_name,
+					      u32 type, u32 mask);
+
 static inline struct crypto_tfm *crypto_skcipher_tfm(
 	struct crypto_skcipher *tfm)
 {
@@ -212,6 +227,11 @@ static inline void crypto_free_skcipher(struct crypto_skcipher *tfm)
 	crypto_destroy_tfm(tfm, crypto_skcipher_tfm(tfm));
 }
 
+static inline void crypto_free_sync_skcipher(struct crypto_sync_skcipher *tfm)
+{
+	crypto_free_skcipher(&tfm->base);
+}
+
 /**
  * crypto_has_skcipher() - Search for the availability of an skcipher.
  * @alg_name: is the cra_name / name or cra_driver_name / driver name of the
@@ -401,6 +421,12 @@ static inline int crypto_skcipher_setkey(struct crypto_skcipher *tfm,
 	return tfm->setkey(tfm, key, keylen);
 }
 
+static inline int crypto_sync_skcipher_setkey(struct crypto_sync_skcipher *tfm,
+					 const u8 *key, unsigned int keylen)
+{
+	return crypto_skcipher_setkey(&tfm->base, key, keylen);
+}
+
 static inline unsigned int crypto_skcipher_default_keysize(
 	struct crypto_skcipher *tfm)
 {
@@ -500,6 +526,12 @@ static inline void skcipher_request_set_tfm(struct skcipher_request *req,
 	req->base.tfm = crypto_skcipher_tfm(tfm);
 }
 
+static inline void skcipher_request_set_sync_tfm(struct skcipher_request *req,
+					    struct crypto_sync_skcipher *tfm)
+{
+	skcipher_request_set_tfm(req, &tfm->base);
+}
+
 static inline struct skcipher_request *skcipher_request_cast(
 	struct crypto_async_request *req)
 {
-- 
2.17.1


-- 
Kees Cook
Pixel Security

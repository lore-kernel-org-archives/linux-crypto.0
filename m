From: Binoy Jayan <binoy.jayan@linaro.org>
Subject: [RFC PATCH v4] crypto: Add IV generation algorithms
Date: Tue,  7 Feb 2017 16:05:31 +0530
Message-ID: <1486463731-6224-2-git-send-email-binoy.jayan@linaro.org>
References: <1486463731-6224-1-git-send-email-binoy.jayan@linaro.org>
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        linux-crypto@vger.kernel.org, Mark Brown <broonie@kernel.org>,
        Arnd Bergmann <arnd@arndb.de>, linux-kernel@vger.kernel.org,
        Alasdair Kergon <agk@redhat.com>,
        Mike Snitzer <snitzer@redhat.com>, dm-devel@redhat.com,
        Shaohua Li <shli@kernel.org>, linux-raid@vger.kernel.org,
        Rajendra <rnayak@codeaurora.org>,
        Milan Broz <gmazyland@gmail.com>, Gilad <gilad@benyossef.com>,
        Binoy Jayan <binoy.jayan@linaro.org>
To: Oded <oded.golombek@arm.com>, Ofir <Ofir.Drang@arm.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1486463731-6224-1-git-send-email-binoy.jayan@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Currently, the iv generation algorithms are implemented in dm-crypt.c.
The goal is to move these algorithms from the dm layer to the kernel
crypto layer by implementing them as template ciphers so they can be
implemented in hardware for performance. As part of this patchset, the
iv-generation code is moved from the dm layer to the crypto layer and
adapt the dm-layer to send a whole 'bio' (as defined in the block layer)
at a time. Each bio contains an in memory representation of physically
contiguous disk blocks. The dm layer sets up a chained scatterlist of
these blocks split into physically contiguous segments in memory so that
DMA can be performed. Also, the key management code is moved from dm layer
to the cryto layer since the key selection for encrypting neighboring
sectors depend on the keycount.

Synchronous crypto requests to encrypt/decrypt a sector are processed
sequentially. Asynchronous requests if processed in parallel, are freed
in the async callback. The dm layer allocates space for iv. The hardware
implementations can choose to make use of this space to generate their IVs
sequentially or allocate it on their own.
Interface to the crypto layer - include/crypto/geniv.h

Signed-off-by: Binoy Jayan <binoy.jayan@linaro.org>
---
 drivers/md/dm-crypt.c  | 1894 ++++++++++++++++++++++++++++++++++--------------
 include/crypto/geniv.h |   47 ++
 2 files changed, 1402 insertions(+), 539 deletions(-)
 create mode 100644 include/crypto/geniv.h

diff --git a/drivers/md/dm-crypt.c b/drivers/md/dm-crypt.c
index 7c6c572..8540c0f 100644
--- a/drivers/md/dm-crypt.c
+++ b/drivers/md/dm-crypt.c
@@ -32,170 +32,113 @@
 #include <crypto/algapi.h>
 #include <crypto/skcipher.h>
 #include <keys/user-type.h>
-
 #include <linux/device-mapper.h>
-
-#define DM_MSG_PREFIX "crypt"
-
-/*
- * context holding the current state of a multi-part conversion
- */
-struct convert_context {
-	struct completion restart;
-	struct bio *bio_in;
-	struct bio *bio_out;
-	struct bvec_iter iter_in;
-	struct bvec_iter iter_out;
-	sector_t cc_sector;
-	atomic_t cc_pending;
-	struct skcipher_request *req;
+#include <crypto/internal/skcipher.h>
+#include <linux/backing-dev.h>
+#include <linux/log2.h>
+#include <crypto/geniv.h>
+
+#define DM_MSG_PREFIX		"crypt"
+#define MAX_SG_LIST		(BIO_MAX_PAGES * 8)
+#define MIN_IOS			64
+#define LMK_SEED_SIZE		64 /* hash + 0 */
+#define TCW_WHITENING_SIZE	16
+
+struct geniv_ctx;
+struct geniv_req_ctx;
+
+/* Sub request for each of the skcipher_request's for a segment */
+struct geniv_subreq {
+	struct scatterlist src;
+	struct scatterlist dst;
+	int n;
+	struct geniv_req_ctx *rctx;
+	struct skcipher_request req CRYPTO_MINALIGN_ATTR;
 };
 
-/*
- * per bio private data
- */
-struct dm_crypt_io {
-	struct crypt_config *cc;
-	struct bio *base_bio;
-	struct work_struct work;
-
-	struct convert_context ctx;
-
-	atomic_t io_pending;
-	int error;
-	sector_t sector;
-
-	struct rb_node rb_node;
-} CRYPTO_MINALIGN_ATTR;
-
-struct dm_crypt_request {
-	struct convert_context *ctx;
-	struct scatterlist sg_in;
-	struct scatterlist sg_out;
+struct geniv_req_ctx {
+	struct geniv_subreq *subreq;
+	bool is_write;
 	sector_t iv_sector;
+	unsigned int nents;
+	u8 *iv;
+	struct completion restart;
+	atomic_t req_pending;
+	struct skcipher_request *req;
 };
 
-struct crypt_config;
-
 struct crypt_iv_operations {
-	int (*ctr)(struct crypt_config *cc, struct dm_target *ti,
-		   const char *opts);
-	void (*dtr)(struct crypt_config *cc);
-	int (*init)(struct crypt_config *cc);
-	int (*wipe)(struct crypt_config *cc);
-	int (*generator)(struct crypt_config *cc, u8 *iv,
-			 struct dm_crypt_request *dmreq);
-	int (*post)(struct crypt_config *cc, u8 *iv,
-		    struct dm_crypt_request *dmreq);
+	int (*ctr)(struct geniv_ctx *ctx);
+	void (*dtr)(struct geniv_ctx *ctx);
+	int (*init)(struct geniv_ctx *ctx);
+	int (*wipe)(struct geniv_ctx *ctx);
+	int (*generator)(struct geniv_ctx *ctx,
+			 struct geniv_req_ctx *rctx,
+			 struct geniv_subreq *subreq);
+	int (*post)(struct geniv_ctx *ctx,
+		    struct geniv_req_ctx *rctx,
+		    struct geniv_subreq *subreq);
 };
 
-struct iv_essiv_private {
+struct geniv_essiv_private {
 	struct crypto_ahash *hash_tfm;
 	u8 *salt;
 };
 
-struct iv_benbi_private {
+struct geniv_benbi_private {
 	int shift;
 };
 
-#define LMK_SEED_SIZE 64 /* hash + 0 */
-struct iv_lmk_private {
+struct geniv_lmk_private {
 	struct crypto_shash *hash_tfm;
 	u8 *seed;
 };
 
-#define TCW_WHITENING_SIZE 16
-struct iv_tcw_private {
+struct geniv_tcw_private {
 	struct crypto_shash *crc32_tfm;
 	u8 *iv_seed;
 	u8 *whitening;
 };
 
-/*
- * Crypt: maps a linear range of a block device
- * and encrypts / decrypts at the same time.
- */
-enum flags { DM_CRYPT_SUSPENDED, DM_CRYPT_KEY_VALID,
-	     DM_CRYPT_SAME_CPU, DM_CRYPT_NO_OFFLOAD };
-
-/*
- * The fields in here must be read only after initialization.
- */
-struct crypt_config {
-	struct dm_dev *dev;
-	sector_t start;
-
-	/*
-	 * pool for per bio private data, crypto requests and
-	 * encryption requeusts/buffer pages
-	 */
-	mempool_t *req_pool;
-	mempool_t *page_pool;
-	struct bio_set *bs;
-	struct mutex bio_alloc_lock;
-
-	struct workqueue_struct *io_queue;
-	struct workqueue_struct *crypt_queue;
-
-	struct task_struct *write_thread;
-	wait_queue_head_t write_thread_wait;
-	struct rb_root write_tree;
-
+struct geniv_ctx {
+	unsigned int tfms_count;
+	struct crypto_skcipher *child;
+	struct crypto_skcipher **tfms;
+	char *ivmode;
+	unsigned int iv_size;
+	char *ivopts;
 	char *cipher;
-	char *cipher_string;
-	char *key_string;
-
+	char *ciphermode;
 	const struct crypt_iv_operations *iv_gen_ops;
 	union {
-		struct iv_essiv_private essiv;
-		struct iv_benbi_private benbi;
-		struct iv_lmk_private lmk;
-		struct iv_tcw_private tcw;
+		struct geniv_essiv_private essiv;
+		struct geniv_benbi_private benbi;
+		struct geniv_lmk_private lmk;
+		struct geniv_tcw_private tcw;
 	} iv_gen_private;
-	sector_t iv_offset;
-	unsigned int iv_size;
-
-	/* ESSIV: struct crypto_cipher *essiv_tfm */
 	void *iv_private;
-	struct crypto_skcipher **tfms;
-	unsigned tfms_count;
-
-	/*
-	 * Layout of each crypto request:
-	 *
-	 *   struct skcipher_request
-	 *      context
-	 *      padding
-	 *   struct dm_crypt_request
-	 *      padding
-	 *   IV
-	 *
-	 * The padding is added so that dm_crypt_request and the IV are
-	 * correctly aligned.
-	 */
-	unsigned int dmreq_start;
-
-	unsigned int per_bio_data_size;
-
-	unsigned long flags;
+	struct crypto_skcipher *tfm;
+	mempool_t *subreq_pool;
 	unsigned int key_size;
+	unsigned int key_extra_size;
 	unsigned int key_parts;      /* independent parts in key buffer */
-	unsigned int key_extra_size; /* additional keys length */
-	u8 key[0];
+	enum setkey_op keyop;
+	char *msg;
+	u8 *key;
 };
 
-#define MIN_IOS        64
-
-static void clone_init(struct dm_crypt_io *, struct bio *);
-static void kcryptd_queue_crypt(struct dm_crypt_io *io);
-static u8 *iv_of_dmreq(struct crypt_config *cc, struct dm_crypt_request *dmreq);
+static struct crypto_skcipher *any_tfm(struct geniv_ctx *ctx)
+{
+	return ctx->tfms[0];
+}
 
-/*
- * Use this to access cipher attributes that are the same for each CPU.
- */
-static struct crypto_skcipher *any_tfm(struct crypt_config *cc)
+static inline
+struct geniv_req_ctx *geniv_req_ctx(struct skcipher_request *req)
 {
-	return cc->tfms[0];
+	struct crypto_skcipher *tfm = crypto_skcipher_reqtfm(req);
+	unsigned long align = crypto_skcipher_alignmask(tfm);
+
+	return (void *) PTR_ALIGN((u8 *) skcipher_request_ctx(req), align + 1);
 }
 
 /*
@@ -245,44 +188,50 @@ static struct crypto_skcipher *any_tfm(struct crypt_config *cc)
  * http://article.gmane.org/gmane.linux.kernel.device-mapper.dm-crypt/454
  */
 
-static int crypt_iv_plain_gen(struct crypt_config *cc, u8 *iv,
-			      struct dm_crypt_request *dmreq)
+static int crypt_iv_plain_gen(struct geniv_ctx *ctx,
+			      struct geniv_req_ctx *rctx,
+			      struct geniv_subreq *subreq)
 {
-	memset(iv, 0, cc->iv_size);
-	*(__le32 *)iv = cpu_to_le32(dmreq->iv_sector & 0xffffffff);
+	u8 *iv = rctx->iv;
+
+	memset(iv, 0, ctx->iv_size);
+	*(__le32 *)iv = cpu_to_le32(rctx->iv_sector & 0xffffffff);
 
 	return 0;
 }
 
-static int crypt_iv_plain64_gen(struct crypt_config *cc, u8 *iv,
-				struct dm_crypt_request *dmreq)
+static int crypt_iv_plain64_gen(struct geniv_ctx *ctx,
+				struct geniv_req_ctx *rctx,
+				struct geniv_subreq *subreq)
 {
-	memset(iv, 0, cc->iv_size);
-	*(__le64 *)iv = cpu_to_le64(dmreq->iv_sector);
+	u8 *iv = rctx->iv;
+
+	memset(iv, 0, ctx->iv_size);
+	*(__le64 *)iv = cpu_to_le64(rctx->iv_sector);
 
 	return 0;
 }
 
 /* Initialise ESSIV - compute salt but no local memory allocations */
-static int crypt_iv_essiv_init(struct crypt_config *cc)
+static int crypt_iv_essiv_init(struct geniv_ctx *ctx)
 {
-	struct iv_essiv_private *essiv = &cc->iv_gen_private.essiv;
-	AHASH_REQUEST_ON_STACK(req, essiv->hash_tfm);
+	struct geniv_essiv_private *essiv = &ctx->iv_gen_private.essiv;
 	struct scatterlist sg;
 	struct crypto_cipher *essiv_tfm;
 	int err;
+	AHASH_REQUEST_ON_STACK(req, essiv->hash_tfm);
 
-	sg_init_one(&sg, cc->key, cc->key_size);
+	sg_init_one(&sg, ctx->key, ctx->key_size);
 	ahash_request_set_tfm(req, essiv->hash_tfm);
 	ahash_request_set_callback(req, CRYPTO_TFM_REQ_MAY_SLEEP, NULL, NULL);
-	ahash_request_set_crypt(req, &sg, essiv->salt, cc->key_size);
+	ahash_request_set_crypt(req, &sg, essiv->salt, ctx->key_size);
 
 	err = crypto_ahash_digest(req);
 	ahash_request_zero(req);
 	if (err)
 		return err;
 
-	essiv_tfm = cc->iv_private;
+	essiv_tfm = ctx->iv_private;
 
 	err = crypto_cipher_setkey(essiv_tfm, essiv->salt,
 			    crypto_ahash_digestsize(essiv->hash_tfm));
@@ -293,16 +242,16 @@ static int crypt_iv_essiv_init(struct crypt_config *cc)
 }
 
 /* Wipe salt and reset key derived from volume key */
-static int crypt_iv_essiv_wipe(struct crypt_config *cc)
+static int crypt_iv_essiv_wipe(struct geniv_ctx *ctx)
 {
-	struct iv_essiv_private *essiv = &cc->iv_gen_private.essiv;
-	unsigned salt_size = crypto_ahash_digestsize(essiv->hash_tfm);
+	struct geniv_essiv_private *essiv = &ctx->iv_gen_private.essiv;
+	unsigned int salt_size = crypto_ahash_digestsize(essiv->hash_tfm);
 	struct crypto_cipher *essiv_tfm;
 	int r, err = 0;
 
 	memset(essiv->salt, 0, salt_size);
 
-	essiv_tfm = cc->iv_private;
+	essiv_tfm = ctx->iv_private;
 	r = crypto_cipher_setkey(essiv_tfm, essiv->salt, salt_size);
 	if (r)
 		err = r;
@@ -311,42 +260,40 @@ static int crypt_iv_essiv_wipe(struct crypt_config *cc)
 }
 
 /* Set up per cpu cipher state */
-static struct crypto_cipher *setup_essiv_cpu(struct crypt_config *cc,
-					     struct dm_target *ti,
-					     u8 *salt, unsigned saltsize)
+static struct crypto_cipher *setup_essiv_cpu(struct geniv_ctx *ctx,
+					     u8 *salt, unsigned int saltsize)
 {
 	struct crypto_cipher *essiv_tfm;
 	int err;
 
 	/* Setup the essiv_tfm with the given salt */
-	essiv_tfm = crypto_alloc_cipher(cc->cipher, 0, CRYPTO_ALG_ASYNC);
+	essiv_tfm = crypto_alloc_cipher(ctx->cipher, 0, CRYPTO_ALG_ASYNC);
+
 	if (IS_ERR(essiv_tfm)) {
-		ti->error = "Error allocating crypto tfm for ESSIV";
+		DMERR("Error allocating crypto tfm for ESSIV\n");
 		return essiv_tfm;
 	}
 
 	if (crypto_cipher_blocksize(essiv_tfm) !=
-	    crypto_skcipher_ivsize(any_tfm(cc))) {
-		ti->error = "Block size of ESSIV cipher does "
-			    "not match IV size of block cipher";
+	    crypto_skcipher_ivsize(any_tfm(ctx))) {
+		DMERR("Block size of ESSIV cipher does not match IV size of block cipher\n");
 		crypto_free_cipher(essiv_tfm);
 		return ERR_PTR(-EINVAL);
 	}
 
 	err = crypto_cipher_setkey(essiv_tfm, salt, saltsize);
 	if (err) {
-		ti->error = "Failed to set key for ESSIV cipher";
+		DMERR("Failed to set key for ESSIV cipher\n");
 		crypto_free_cipher(essiv_tfm);
 		return ERR_PTR(err);
 	}
-
 	return essiv_tfm;
 }
 
-static void crypt_iv_essiv_dtr(struct crypt_config *cc)
+static void crypt_iv_essiv_dtr(struct geniv_ctx *ctx)
 {
 	struct crypto_cipher *essiv_tfm;
-	struct iv_essiv_private *essiv = &cc->iv_gen_private.essiv;
+	struct geniv_essiv_private *essiv = &ctx->iv_gen_private.essiv;
 
 	crypto_free_ahash(essiv->hash_tfm);
 	essiv->hash_tfm = NULL;
@@ -354,52 +301,50 @@ static void crypt_iv_essiv_dtr(struct crypt_config *cc)
 	kzfree(essiv->salt);
 	essiv->salt = NULL;
 
-	essiv_tfm = cc->iv_private;
+	essiv_tfm = ctx->iv_private;
 
 	if (essiv_tfm)
 		crypto_free_cipher(essiv_tfm);
 
-	cc->iv_private = NULL;
+	ctx->iv_private = NULL;
 }
 
-static int crypt_iv_essiv_ctr(struct crypt_config *cc, struct dm_target *ti,
-			      const char *opts)
+static int crypt_iv_essiv_ctr(struct geniv_ctx *ctx)
 {
 	struct crypto_cipher *essiv_tfm = NULL;
 	struct crypto_ahash *hash_tfm = NULL;
 	u8 *salt = NULL;
 	int err;
 
-	if (!opts) {
-		ti->error = "Digest algorithm missing for ESSIV mode";
+	if (!ctx->ivopts) {
+		DMERR("Digest algorithm missing for ESSIV mode\n");
 		return -EINVAL;
 	}
 
 	/* Allocate hash algorithm */
-	hash_tfm = crypto_alloc_ahash(opts, 0, CRYPTO_ALG_ASYNC);
+	hash_tfm = crypto_alloc_ahash(ctx->ivopts, 0, CRYPTO_ALG_ASYNC);
 	if (IS_ERR(hash_tfm)) {
-		ti->error = "Error initializing ESSIV hash";
 		err = PTR_ERR(hash_tfm);
+		DMERR("Error initializing ESSIV hash. err=%d\n", err);
 		goto bad;
 	}
 
 	salt = kzalloc(crypto_ahash_digestsize(hash_tfm), GFP_KERNEL);
 	if (!salt) {
-		ti->error = "Error kmallocing salt storage in ESSIV";
 		err = -ENOMEM;
 		goto bad;
 	}
 
-	cc->iv_gen_private.essiv.salt = salt;
-	cc->iv_gen_private.essiv.hash_tfm = hash_tfm;
+	ctx->iv_gen_private.essiv.salt = salt;
+	ctx->iv_gen_private.essiv.hash_tfm = hash_tfm;
 
-	essiv_tfm = setup_essiv_cpu(cc, ti, salt,
+	essiv_tfm = setup_essiv_cpu(ctx, salt,
 				crypto_ahash_digestsize(hash_tfm));
 	if (IS_ERR(essiv_tfm)) {
-		crypt_iv_essiv_dtr(cc);
+		crypt_iv_essiv_dtr(ctx);
 		return PTR_ERR(essiv_tfm);
 	}
-	cc->iv_private = essiv_tfm;
+	ctx->iv_private = essiv_tfm;
 
 	return 0;
 
@@ -410,70 +355,73 @@ static int crypt_iv_essiv_ctr(struct crypt_config *cc, struct dm_target *ti,
 	return err;
 }
 
-static int crypt_iv_essiv_gen(struct crypt_config *cc, u8 *iv,
-			      struct dm_crypt_request *dmreq)
+static int crypt_iv_essiv_gen(struct geniv_ctx *ctx,
+			      struct geniv_req_ctx *rctx,
+			      struct geniv_subreq *subreq)
 {
-	struct crypto_cipher *essiv_tfm = cc->iv_private;
+	u8 *iv = rctx->iv;
+	struct crypto_cipher *essiv_tfm = ctx->iv_private;
 
-	memset(iv, 0, cc->iv_size);
-	*(__le64 *)iv = cpu_to_le64(dmreq->iv_sector);
+	memset(iv, 0, ctx->iv_size);
+	*(__le64 *)iv = cpu_to_le64(rctx->iv_sector);
 	crypto_cipher_encrypt_one(essiv_tfm, iv, iv);
 
 	return 0;
 }
 
-static int crypt_iv_benbi_ctr(struct crypt_config *cc, struct dm_target *ti,
-			      const char *opts)
+static int crypt_iv_benbi_ctr(struct geniv_ctx *ctx)
 {
-	unsigned bs = crypto_skcipher_blocksize(any_tfm(cc));
+	unsigned int bs = crypto_skcipher_blocksize(any_tfm(ctx));
 	int log = ilog2(bs);
 
 	/* we need to calculate how far we must shift the sector count
-	 * to get the cipher block count, we use this shift in _gen */
+	 * to get the cipher block count, we use this shift in _gen
+	 */
 
 	if (1 << log != bs) {
-		ti->error = "cypher blocksize is not a power of 2";
+		DMERR("cypher blocksize is not a power of 2\n");
 		return -EINVAL;
 	}
 
 	if (log > 9) {
-		ti->error = "cypher blocksize is > 512";
+		DMERR("cypher blocksize is > 512\n");
 		return -EINVAL;
 	}
 
-	cc->iv_gen_private.benbi.shift = 9 - log;
+	ctx->iv_gen_private.benbi.shift = 9 - log;
 
 	return 0;
 }
 
-static void crypt_iv_benbi_dtr(struct crypt_config *cc)
-{
-}
-
-static int crypt_iv_benbi_gen(struct crypt_config *cc, u8 *iv,
-			      struct dm_crypt_request *dmreq)
+static int crypt_iv_benbi_gen(struct geniv_ctx *ctx,
+			      struct geniv_req_ctx *rctx,
+			      struct geniv_subreq *subreq)
 {
+	u8 *iv = rctx->iv;
 	__be64 val;
 
-	memset(iv, 0, cc->iv_size - sizeof(u64)); /* rest is cleared below */
+	memset(iv, 0, ctx->iv_size - sizeof(u64)); /* rest is cleared below */
 
-	val = cpu_to_be64(((u64)dmreq->iv_sector << cc->iv_gen_private.benbi.shift) + 1);
-	put_unaligned(val, (__be64 *)(iv + cc->iv_size - sizeof(u64)));
+	val = cpu_to_be64(((u64) rctx->iv_sector <<
+			  ctx->iv_gen_private.benbi.shift) + 1);
+	put_unaligned(val, (__be64 *)(iv + ctx->iv_size - sizeof(u64)));
 
 	return 0;
 }
 
-static int crypt_iv_null_gen(struct crypt_config *cc, u8 *iv,
-			     struct dm_crypt_request *dmreq)
+static int crypt_iv_null_gen(struct geniv_ctx *ctx,
+			     struct geniv_req_ctx *rctx,
+			     struct geniv_subreq *subreq)
 {
-	memset(iv, 0, cc->iv_size);
+	u8 *iv = rctx->iv;
 
+	memset(iv, 0, ctx->iv_size);
 	return 0;
 }
 
-static void crypt_iv_lmk_dtr(struct crypt_config *cc)
+static void crypt_iv_lmk_dtr(struct geniv_ctx *ctx)
 {
-	struct iv_lmk_private *lmk = &cc->iv_gen_private.lmk;
+	struct geniv_lmk_private *lmk = &ctx->iv_gen_private.lmk;
 
 	if (lmk->hash_tfm && !IS_ERR(lmk->hash_tfm))
 		crypto_free_shash(lmk->hash_tfm);
@@ -483,49 +431,49 @@ static void crypt_iv_lmk_dtr(struct crypt_config *cc)
 	lmk->seed = NULL;
 }
 
-static int crypt_iv_lmk_ctr(struct crypt_config *cc, struct dm_target *ti,
-			    const char *opts)
+static int crypt_iv_lmk_ctr(struct geniv_ctx *ctx)
 {
-	struct iv_lmk_private *lmk = &cc->iv_gen_private.lmk;
+	struct geniv_lmk_private *lmk = &ctx->iv_gen_private.lmk;
 
 	lmk->hash_tfm = crypto_alloc_shash("md5", 0, 0);
 	if (IS_ERR(lmk->hash_tfm)) {
-		ti->error = "Error initializing LMK hash";
+		DMERR("Error initializing LMK hash; err=%ld\n",
+		      PTR_ERR(lmk->hash_tfm));
 		return PTR_ERR(lmk->hash_tfm);
 	}
 
 	/* No seed in LMK version 2 */
-	if (cc->key_parts == cc->tfms_count) {
+	if (ctx->key_parts == ctx->tfms_count) {
 		lmk->seed = NULL;
 		return 0;
 	}
 
 	lmk->seed = kzalloc(LMK_SEED_SIZE, GFP_KERNEL);
 	if (!lmk->seed) {
-		crypt_iv_lmk_dtr(cc);
-		ti->error = "Error kmallocing seed storage in LMK";
+		crypt_iv_lmk_dtr(ctx);
+		DMERR("Error kmallocing seed storage in LMK\n");
 		return -ENOMEM;
 	}
 
 	return 0;
 }
 
-static int crypt_iv_lmk_init(struct crypt_config *cc)
+static int crypt_iv_lmk_init(struct geniv_ctx *ctx)
 {
-	struct iv_lmk_private *lmk = &cc->iv_gen_private.lmk;
-	int subkey_size = cc->key_size / cc->key_parts;
+	struct geniv_lmk_private *lmk = &ctx->iv_gen_private.lmk;
+	int subkey_size = ctx->key_size / ctx->key_parts;
 
 	/* LMK seed is on the position of LMK_KEYS + 1 key */
 	if (lmk->seed)
-		memcpy(lmk->seed, cc->key + (cc->tfms_count * subkey_size),
+		memcpy(lmk->seed, ctx->key + (ctx->tfms_count * subkey_size),
 		       crypto_shash_digestsize(lmk->hash_tfm));
 
 	return 0;
 }
 
-static int crypt_iv_lmk_wipe(struct crypt_config *cc)
+static int crypt_iv_lmk_wipe(struct geniv_ctx *ctx)
 {
-	struct iv_lmk_private *lmk = &cc->iv_gen_private.lmk;
+	struct geniv_lmk_private *lmk = &ctx->iv_gen_private.lmk;
 
 	if (lmk->seed)
 		memset(lmk->seed, 0, LMK_SEED_SIZE);
@@ -533,15 +481,14 @@ static int crypt_iv_lmk_wipe(struct crypt_config *cc)
 	return 0;
 }
 
-static int crypt_iv_lmk_one(struct crypt_config *cc, u8 *iv,
-			    struct dm_crypt_request *dmreq,
-			    u8 *data)
+static int crypt_iv_lmk_one(struct geniv_ctx *ctx, u8 *iv,
+			    struct geniv_req_ctx *rctx, u8 *data)
 {
-	struct iv_lmk_private *lmk = &cc->iv_gen_private.lmk;
-	SHASH_DESC_ON_STACK(desc, lmk->hash_tfm);
+	struct geniv_lmk_private *lmk = &ctx->iv_gen_private.lmk;
 	struct md5_state md5state;
 	__le32 buf[4];
 	int i, r;
+	SHASH_DESC_ON_STACK(desc, lmk->hash_tfm);
 
 	desc->tfm = lmk->hash_tfm;
 	desc->flags = CRYPTO_TFM_REQ_MAY_SLEEP;
@@ -562,8 +509,9 @@ static int crypt_iv_lmk_one(struct crypt_config *cc, u8 *iv,
 		return r;
 
 	/* Sector is cropped to 56 bits here */
-	buf[0] = cpu_to_le32(dmreq->iv_sector & 0xFFFFFFFF);
-	buf[1] = cpu_to_le32((((u64)dmreq->iv_sector >> 32) & 0x00FFFFFF) | 0x80000000);
+	buf[0] = cpu_to_le32(rctx->iv_sector & 0xFFFFFFFF);
+	buf[1] = cpu_to_le32((((u64)rctx->iv_sector >> 32) & 0x00FFFFFF)
+			     | 0x80000000);
 	buf[2] = cpu_to_le32(4024);
 	buf[3] = 0;
 	r = crypto_shash_update(desc, (u8 *)buf, sizeof(buf));
@@ -577,50 +525,54 @@ static int crypt_iv_lmk_one(struct crypt_config *cc, u8 *iv,
 
 	for (i = 0; i < MD5_HASH_WORDS; i++)
 		__cpu_to_le32s(&md5state.hash[i]);
-	memcpy(iv, &md5state.hash, cc->iv_size);
+	memcpy(iv, &md5state.hash, ctx->iv_size);
 
 	return 0;
 }
 
-static int crypt_iv_lmk_gen(struct crypt_config *cc, u8 *iv,
-			    struct dm_crypt_request *dmreq)
+static int crypt_iv_lmk_gen(struct geniv_ctx *ctx,
+			    struct geniv_req_ctx *rctx,
+			    struct geniv_subreq *subreq)
 {
 	u8 *src;
+	u8 *iv = rctx->iv;
 	int r = 0;
 
-	if (bio_data_dir(dmreq->ctx->bio_in) == WRITE) {
-		src = kmap_atomic(sg_page(&dmreq->sg_in));
-		r = crypt_iv_lmk_one(cc, iv, dmreq, src + dmreq->sg_in.offset);
+	if (rctx->is_write) {
+		src = kmap_atomic(sg_page(&subreq->src));
+		r = crypt_iv_lmk_one(ctx, iv, rctx, src + subreq->src.offset);
 		kunmap_atomic(src);
 	} else
-		memset(iv, 0, cc->iv_size);
+		memset(iv, 0, ctx->iv_size);
 
 	return r;
 }
 
-static int crypt_iv_lmk_post(struct crypt_config *cc, u8 *iv,
-			     struct dm_crypt_request *dmreq)
+static int crypt_iv_lmk_post(struct geniv_ctx *ctx,
+			     struct geniv_req_ctx *rctx,
+			     struct geniv_subreq *subreq)
 {
 	u8 *dst;
+	u8 *iv = rctx->iv;
 	int r;
 
-	if (bio_data_dir(dmreq->ctx->bio_in) == WRITE)
+	if (rctx->is_write)
 		return 0;
 
-	dst = kmap_atomic(sg_page(&dmreq->sg_out));
-	r = crypt_iv_lmk_one(cc, iv, dmreq, dst + dmreq->sg_out.offset);
+	dst = kmap_atomic(sg_page(&subreq->dst));
+	r = crypt_iv_lmk_one(ctx, iv, rctx, dst + subreq->dst.offset);
 
 	/* Tweak the first block of plaintext sector */
 	if (!r)
-		crypto_xor(dst + dmreq->sg_out.offset, iv, cc->iv_size);
+		crypto_xor(dst + subreq->dst.offset, iv, ctx->iv_size);
 
 	kunmap_atomic(dst);
 	return r;
 }
 
-static void crypt_iv_tcw_dtr(struct crypt_config *cc)
+static void crypt_iv_tcw_dtr(struct geniv_ctx *ctx)
 {
-	struct iv_tcw_private *tcw = &cc->iv_gen_private.tcw;
+	struct geniv_tcw_private *tcw = &ctx->iv_gen_private.tcw;
 
 	kzfree(tcw->iv_seed);
 	tcw->iv_seed = NULL;
@@ -632,64 +584,65 @@ static void crypt_iv_tcw_dtr(struct crypt_config *cc)
 	tcw->crc32_tfm = NULL;
 }
 
-static int crypt_iv_tcw_ctr(struct crypt_config *cc, struct dm_target *ti,
-			    const char *opts)
+static int crypt_iv_tcw_ctr(struct geniv_ctx *ctx)
 {
-	struct iv_tcw_private *tcw = &cc->iv_gen_private.tcw;
+	struct geniv_tcw_private *tcw = &ctx->iv_gen_private.tcw;
 
-	if (cc->key_size <= (cc->iv_size + TCW_WHITENING_SIZE)) {
-		ti->error = "Wrong key size for TCW";
+	if (ctx->key_size <= (ctx->iv_size + TCW_WHITENING_SIZE)) {
+		DMERR("Wrong key size (%d) for TCW. Choose a value > %d bytes\n",
+			ctx->key_size,
+			ctx->iv_size + TCW_WHITENING_SIZE);
 		return -EINVAL;
 	}
 
 	tcw->crc32_tfm = crypto_alloc_shash("crc32", 0, 0);
 	if (IS_ERR(tcw->crc32_tfm)) {
-		ti->error = "Error initializing CRC32 in TCW";
+		DMERR("Error initializing CRC32 in TCW; err=%ld\n",
+			PTR_ERR(tcw->crc32_tfm));
 		return PTR_ERR(tcw->crc32_tfm);
 	}
 
-	tcw->iv_seed = kzalloc(cc->iv_size, GFP_KERNEL);
+	tcw->iv_seed = kzalloc(ctx->iv_size, GFP_KERNEL);
 	tcw->whitening = kzalloc(TCW_WHITENING_SIZE, GFP_KERNEL);
 	if (!tcw->iv_seed || !tcw->whitening) {
-		crypt_iv_tcw_dtr(cc);
-		ti->error = "Error allocating seed storage in TCW";
+		crypt_iv_tcw_dtr(ctx);
+		DMERR("Error allocating seed storage in TCW\n");
 		return -ENOMEM;
 	}
 
 	return 0;
 }
 
-static int crypt_iv_tcw_init(struct crypt_config *cc)
+static int crypt_iv_tcw_init(struct geniv_ctx *ctx)
 {
-	struct iv_tcw_private *tcw = &cc->iv_gen_private.tcw;
-	int key_offset = cc->key_size - cc->iv_size - TCW_WHITENING_SIZE;
+	struct geniv_tcw_private *tcw = &ctx->iv_gen_private.tcw;
+	int key_offset = ctx->key_size - ctx->iv_size - TCW_WHITENING_SIZE;
 
-	memcpy(tcw->iv_seed, &cc->key[key_offset], cc->iv_size);
-	memcpy(tcw->whitening, &cc->key[key_offset + cc->iv_size],
+	memcpy(tcw->iv_seed, &ctx->key[key_offset], ctx->iv_size);
+	memcpy(tcw->whitening, &ctx->key[key_offset + ctx->iv_size],
 	       TCW_WHITENING_SIZE);
 
 	return 0;
 }
 
-static int crypt_iv_tcw_wipe(struct crypt_config *cc)
+static int crypt_iv_tcw_wipe(struct geniv_ctx *ctx)
 {
-	struct iv_tcw_private *tcw = &cc->iv_gen_private.tcw;
+	struct geniv_tcw_private *tcw = &ctx->iv_gen_private.tcw;
 
-	memset(tcw->iv_seed, 0, cc->iv_size);
+	memset(tcw->iv_seed, 0, ctx->iv_size);
 	memset(tcw->whitening, 0, TCW_WHITENING_SIZE);
 
 	return 0;
 }
 
-static int crypt_iv_tcw_whitening(struct crypt_config *cc,
-				  struct dm_crypt_request *dmreq,
-				  u8 *data)
+static int crypt_iv_tcw_whitening(struct geniv_ctx *ctx,
+				  struct geniv_req_ctx *rctx, u8 *data)
 {
-	struct iv_tcw_private *tcw = &cc->iv_gen_private.tcw;
-	__le64 sector = cpu_to_le64(dmreq->iv_sector);
+	struct geniv_tcw_private *tcw = &ctx->iv_gen_private.tcw;
+	__le64 sector = cpu_to_le64(rctx->iv_sector);
 	u8 buf[TCW_WHITENING_SIZE];
-	SHASH_DESC_ON_STACK(desc, tcw->crc32_tfm);
 	int i, r;
+	SHASH_DESC_ON_STACK(desc, tcw->crc32_tfm);
 
 	/* xor whitening with sector number */
 	memcpy(buf, tcw->whitening, TCW_WHITENING_SIZE);
@@ -713,99 +666,1009 @@ static int crypt_iv_tcw_whitening(struct crypt_config *cc,
 	crypto_xor(&buf[0], &buf[12], 4);
 	crypto_xor(&buf[4], &buf[8], 4);
 
-	/* apply whitening (8 bytes) to whole sector */
-	for (i = 0; i < ((1 << SECTOR_SHIFT) / 8); i++)
-		crypto_xor(data + i * 8, buf, 8);
-out:
-	memzero_explicit(buf, sizeof(buf));
-	return r;
-}
+	/* apply whitening (8 bytes) to whole sector */
+	for (i = 0; i < (SECTOR_SIZE / 8); i++)
+		crypto_xor(data + i * 8, buf, 8);
+out:
+	memzero_explicit(buf, sizeof(buf));
+	return r;
+}
+
+static int crypt_iv_tcw_gen(struct geniv_ctx *ctx,
+			    struct geniv_req_ctx *rctx,
+			    struct geniv_subreq *subreq)
+{
+	u8 *iv = rctx->iv;
+	struct geniv_tcw_private *tcw = &ctx->iv_gen_private.tcw;
+	__le64 sector = cpu_to_le64(rctx->iv_sector);
+	u8 *src;
+	int r = 0;
+
+	/* Remove whitening from ciphertext */
+	if (!rctx->is_write) {
+		src = kmap_atomic(sg_page(&subreq->src));
+		r = crypt_iv_tcw_whitening(ctx, rctx,
+					   src + subreq->src.offset);
+		kunmap_atomic(src);
+	}
+
+	/* Calculate IV */
+	memcpy(iv, tcw->iv_seed, ctx->iv_size);
+	crypto_xor(iv, (u8 *)&sector, 8);
+	if (ctx->iv_size > 8)
+		crypto_xor(&iv[8], (u8 *)&sector, ctx->iv_size - 8);
+
+	return r;
+}
+
+static int crypt_iv_tcw_post(struct geniv_ctx *ctx,
+			     struct geniv_req_ctx *rctx,
+			     struct geniv_subreq *subreq)
+{
+	u8 *dst;
+	int r;
+
+	if (!rctx->is_write)
+		return 0;
+
+	/* Apply whitening on ciphertext */
+	dst = kmap_atomic(sg_page(&subreq->dst));
+	r = crypt_iv_tcw_whitening(ctx, rctx, dst + subreq->dst.offset);
+	kunmap_atomic(dst);
+
+	return r;
+}
+
+static const struct crypt_iv_operations crypt_iv_plain_ops = {
+	.generator = crypt_iv_plain_gen
+};
+
+static const struct crypt_iv_operations crypt_iv_plain64_ops = {
+	.generator = crypt_iv_plain64_gen
+};
+
+static const struct crypt_iv_operations crypt_iv_essiv_ops = {
+	.ctr       = crypt_iv_essiv_ctr,
+	.dtr       = crypt_iv_essiv_dtr,
+	.init      = crypt_iv_essiv_init,
+	.wipe      = crypt_iv_essiv_wipe,
+	.generator = crypt_iv_essiv_gen
+};
+
+static const struct crypt_iv_operations crypt_iv_benbi_ops = {
+	.ctr	   = crypt_iv_benbi_ctr,
+	.generator = crypt_iv_benbi_gen
+};
+
+static const struct crypt_iv_operations crypt_iv_null_ops = {
+	.generator = crypt_iv_null_gen
+};
+
+static const struct crypt_iv_operations crypt_iv_lmk_ops = {
+	.ctr	   = crypt_iv_lmk_ctr,
+	.dtr	   = crypt_iv_lmk_dtr,
+	.init	   = crypt_iv_lmk_init,
+	.wipe	   = crypt_iv_lmk_wipe,
+	.generator = crypt_iv_lmk_gen,
+	.post	   = crypt_iv_lmk_post
+};
+
+static const struct crypt_iv_operations crypt_iv_tcw_ops = {
+	.ctr	   = crypt_iv_tcw_ctr,
+	.dtr	   = crypt_iv_tcw_dtr,
+	.init	   = crypt_iv_tcw_init,
+	.wipe	   = crypt_iv_tcw_wipe,
+	.generator = crypt_iv_tcw_gen,
+	.post	   = crypt_iv_tcw_post
+};
+
+static int geniv_setkey_set(struct geniv_ctx *ctx)
+{
+	int ret = 0;
+
+	if (ctx->iv_gen_ops && ctx->iv_gen_ops->init)
+		ret = ctx->iv_gen_ops->init(ctx);
+	return ret;
+}
+
+static int geniv_setkey_wipe(struct geniv_ctx *ctx)
+{
+	int ret = 0;
+
+	if (ctx->iv_gen_ops && ctx->iv_gen_ops->wipe) {
+		ret = ctx->iv_gen_ops->wipe(ctx);
+		if (ret)
+			return ret;
+	}
+	return ret;
+}
+
+static int geniv_init_iv(struct geniv_ctx *ctx)
+{
+	int ret = -EINVAL;
+
+	DMDEBUG("IV Generation algorithm : %s\n", ctx->ivmode);
+
+	if (ctx->ivmode == NULL)
+		ctx->iv_gen_ops = NULL;
+	else if (strcmp(ctx->ivmode, "plain") == 0)
+		ctx->iv_gen_ops = &crypt_iv_plain_ops;
+	else if (strcmp(ctx->ivmode, "plain64") == 0)
+		ctx->iv_gen_ops = &crypt_iv_plain64_ops;
+	else if (strcmp(ctx->ivmode, "essiv") == 0)
+		ctx->iv_gen_ops = &crypt_iv_essiv_ops;
+	else if (strcmp(ctx->ivmode, "benbi") == 0)
+		ctx->iv_gen_ops = &crypt_iv_benbi_ops;
+	else if (strcmp(ctx->ivmode, "null") == 0)
+		ctx->iv_gen_ops = &crypt_iv_null_ops;
+	else if (strcmp(ctx->ivmode, "lmk") == 0)
+		ctx->iv_gen_ops = &crypt_iv_lmk_ops;
+	else if (strcmp(ctx->ivmode, "tcw") == 0) {
+		ctx->iv_gen_ops = &crypt_iv_tcw_ops;
+		ctx->key_parts += 2; /* IV + whitening */
+		ctx->key_extra_size = ctx->iv_size + TCW_WHITENING_SIZE;
+	} else {
+		ret = -EINVAL;
+		DMERR("Invalid IV mode %s\n", ctx->ivmode);
+		goto end;
+	}
+
+	/* Allocate IV */
+	if (ctx->iv_gen_ops && ctx->iv_gen_ops->ctr) {
+		ret = ctx->iv_gen_ops->ctr(ctx);
+		if (ret < 0) {
+			DMERR("Error creating IV for %s\n", ctx->ivmode);
+			goto end;
+		}
+	}
+
+	/* Initialize IV (set keys for ESSIV etc) */
+	if (ctx->iv_gen_ops && ctx->iv_gen_ops->init) {
+		ret = ctx->iv_gen_ops->init(ctx);
+		if (ret < 0)
+			DMERR("Error creating IV for %s\n", ctx->ivmode);
+	}
+	ret = 0;
+end:
+	return ret;
+}
+
+static void geniv_free_tfms(struct geniv_ctx *ctx)
+{
+	unsigned int i;
+
+	if (!ctx->tfms)
+		return;
+
+	for (i = 0; i < ctx->tfms_count; i++)
+		if (ctx->tfms[i] && !IS_ERR(ctx->tfms[i])) {
+			crypto_free_skcipher(ctx->tfms[i]);
+			ctx->tfms[i] = NULL;
+		}
+
+	kfree(ctx->tfms);
+	ctx->tfms = NULL;
+}
+
+/* Allocate memory for the underlying cipher algorithm. Ex: cbc(aes)
+ */
+
+static int geniv_alloc_tfms(struct crypto_skcipher *parent,
+			    struct geniv_ctx *ctx)
+{
+	unsigned int i, reqsize, align;
+	int err = 0;
+
+	ctx->tfms = kcalloc(ctx->tfms_count, sizeof(struct crypto_skcipher *),
+			   GFP_KERNEL);
+	if (!ctx->tfms) {
+		err = -ENOMEM;
+		goto end;
+	}
+
+	/* First instance is already allocated in geniv_init_tfm */
+	ctx->tfms[0] = ctx->child;
+	for (i = 1; i < ctx->tfms_count; i++) {
+		ctx->tfms[i] = crypto_alloc_skcipher(ctx->ciphermode, 0, 0);
+		if (IS_ERR(ctx->tfms[i])) {
+			err = PTR_ERR(ctx->tfms[i]);
+			geniv_free_tfms(ctx);
+			goto end;
+		}
+
+		/* Setup the current cipher's request structure */
+		align = crypto_skcipher_alignmask(parent);
+		align &= ~(crypto_tfm_ctx_alignment() - 1);
+		reqsize = align + sizeof(struct geniv_req_ctx) +
+			  crypto_skcipher_reqsize(ctx->tfms[i]);
+		crypto_skcipher_set_reqsize(parent, reqsize);
+	}
+
+end:
+	return err;
+}
+
+/* Initialize the cipher's context with the key, ivmode and other parameters.
+ * Also allocate IV generation template ciphers and initialize them.
+ */
+
+static int geniv_setkey_init(struct crypto_skcipher *parent,
+			     struct geniv_key_info *info)
+{
+	struct geniv_ctx *ctx = crypto_skcipher_ctx(parent);
+	int ret = -ENOMEM;
+
+	ctx->iv_size = crypto_skcipher_ivsize(parent);
+	ctx->tfms_count = info->tfms_count;
+	ctx->key = info->key;
+	ctx->key_size = info->key_size;
+	ctx->key_parts = info->key_parts;
+	ctx->ivopts = info->ivopts;
+
+	ret = geniv_alloc_tfms(parent, ctx);
+	if (ret)
+		goto end;
+
+	ret = geniv_init_iv(ctx);
+
+end:
+	return ret;
+}
+
+static int geniv_setkey_tfms(struct crypto_skcipher *parent,
+			     struct geniv_ctx *ctx,
+			     struct geniv_key_info *info)
+{
+	unsigned int subkey_size;
+	int ret = 0, i;
+
+	/* Ignore extra keys (which are used for IV etc) */
+	subkey_size = (ctx->key_size - ctx->key_extra_size)
+		      >> ilog2(ctx->tfms_count);
+
+	for (i = 0; i < ctx->tfms_count; i++) {
+		struct crypto_skcipher *child = ctx->tfms[i];
+		char *subkey = ctx->key + (subkey_size) * i;
+
+		crypto_skcipher_clear_flags(child, CRYPTO_TFM_REQ_MASK);
+		crypto_skcipher_set_flags(child,
+					  crypto_skcipher_get_flags(parent) &
+					  CRYPTO_TFM_REQ_MASK);
+		ret = crypto_skcipher_setkey(child, subkey, subkey_size);
+		if (ret) {
+			DMERR("Error setting key for tfms[%d]\n", i);
+			break;
+		}
+		crypto_skcipher_set_flags(parent,
+					  crypto_skcipher_get_flags(child) &
+					  CRYPTO_TFM_RES_MASK);
+	}
+
+	return ret;
+}
+
+static int geniv_setkey(struct crypto_skcipher *parent,
+			const u8 *key, unsigned int keylen)
+{
+	int err = 0;
+	struct geniv_ctx *ctx = crypto_skcipher_ctx(parent);
+	struct geniv_key_info *info = (struct geniv_key_info *) key;
+
+	DMDEBUG("SETKEY Operation : %d\n", info->keyop);
+
+	switch (info->keyop) {
+	case SETKEY_OP_INIT:
+		err = geniv_setkey_init(parent, info);
+		break;
+	case SETKEY_OP_SET:
+		err = geniv_setkey_set(ctx);
+		break;
+	case SETKEY_OP_WIPE:
+		err = geniv_setkey_wipe(ctx);
+		break;
+	}
+
+	if (err)
+		goto end;
+
+	err = geniv_setkey_tfms(parent, ctx, info);
+
+end:
+	return err;
+}
+
+static void geniv_async_done(struct crypto_async_request *async_req, int error);
+
+static int geniv_alloc_subreq(struct skcipher_request *req,
+			      struct geniv_ctx *ctx,
+			      struct geniv_req_ctx *rctx)
+{
+	int key_index, r = 0;
+	struct skcipher_request *sreq;
+
+	if (!rctx->subreq) {
+		rctx->subreq = mempool_alloc(ctx->subreq_pool, GFP_NOIO);
+		if (!rctx->subreq)
+			r = -ENOMEM;
+	}
+
+	sreq = &rctx->subreq->req;
+	rctx->subreq->rctx = rctx;
+
+	key_index = rctx->iv_sector & (ctx->tfms_count - 1);
+
+	skcipher_request_set_tfm(sreq, ctx->tfms[key_index]);
+	skcipher_request_set_callback(sreq, req->base.flags,
+				      geniv_async_done, rctx->subreq);
+	return r;
+}
+
+/* Asynchronous IO completion callback for each sector in a segment. When all
+ * pending i/o are completed the parent cipher's async function is called.
+ */
+
+static void geniv_async_done(struct crypto_async_request *async_req, int error)
+{
+	struct geniv_subreq *subreq =
+		(struct geniv_subreq *) async_req->data;
+	struct geniv_req_ctx *rctx = subreq->rctx;
+	struct skcipher_request *req = rctx->req;
+	struct crypto_skcipher *tfm = crypto_skcipher_reqtfm(req);
+	struct geniv_ctx *ctx = crypto_skcipher_ctx(tfm);
+
+	/*
+	 * A request from crypto driver backlog is going to be processed now,
+	 * finish the completion and continue in crypt_convert().
+	 * (Callback will be called for the second time for this request.)
+	 */
+
+	if (error == -EINPROGRESS) {
+		complete(&rctx->restart);
+		return;
+	}
+
+	if (!error && ctx->iv_gen_ops && ctx->iv_gen_ops->post)
+		error = ctx->iv_gen_ops->post(ctx, rctx, subreq);
+
+	mempool_free(subreq, ctx->subreq_pool);
+
+	/* req_pending needs to be checked before req->base.complete is called
+	 * as we need 'req_pending' to be equal to 1 to ensure all subrequests
+	 * are processed.
+	 */
+	if (!atomic_dec_and_test(&rctx->req_pending)) {
+		/* Call the parent cipher's completion function */
+		skcipher_request_complete(req, error);
+	}
+}
+
+static unsigned int geniv_get_sectors(struct scatterlist *sg1,
+				      struct scatterlist *sg2,
+				      unsigned int segments)
+{
+	unsigned int i, n1, n2, nents;
+
+	n1 = n2 = 0;
+	for (i = 0; i < segments ; i++)
+		n1 += sg1[i].length >> SECTOR_SHIFT;
+
+	for (i = 0; i < segments ; i++)
+		n2 += sg2[i].length >> SECTOR_SHIFT;
+
+	nents = n1 > n2 ? n1 : n2;
+	return nents;
+}
+
+/* Iterate scatterlist of segments to retrieve the 512-byte sectors so that
+ * unique IVs could be generated for each 512-byte sector. This split may not
+ * be necessary e.g. when these ciphers are modelled in hardware, where it can
+ * make use of the hardware's IV generation capabilities.
+ */
+
+static int geniv_iter_block(struct skcipher_request *req,
+			    struct geniv_subreq *subreq,
+			    struct geniv_req_ctx *rctx,
+			    unsigned int *seg_no,
+			    unsigned int *done)
+
+{
+	unsigned int srcoff, dstoff, len, rem;
+	struct scatterlist *src1, *dst1, *src2, *dst2;
+
+	if (unlikely(*seg_no >= rctx->nents))
+		return 0; /* done */
+
+	src1 = &req->src[*seg_no];
+	dst1 = &req->dst[*seg_no];
+	src2 = &subreq->src;
+	dst2 = &subreq->dst;
+
+	if (*done >= src1->length) {
+		(*seg_no)++;
+
+		if (*seg_no >= rctx->nents)
+			return 0; /* done */
+
+		src1 = &req->src[*seg_no];
+		dst1 = &req->dst[*seg_no];
+		*done = 0;
+	}
+
+	srcoff = src1->offset + *done;
+	dstoff = dst1->offset + *done;
+	rem = src1->length - *done;
+
+	len = rem > SECTOR_SIZE ? SECTOR_SIZE : rem;
+
+	DMDEBUG("segment:(%d/%u), srcoff:%d, dstoff:%d, done:%d, rem:%d\n",
+		*seg_no + 1, rctx->nents, srcoff, dstoff, *done, rem);
+
+	sg_init_table(src2, 1);
+	sg_set_page(src2, sg_page(src1), len, srcoff);
+	sg_init_table(dst2, 1);
+	sg_set_page(dst2, sg_page(dst1), len, dstoff);
+
+	*done += len;
+
+	return len; /* bytes returned */
+}
+
+/* Common encryt/decrypt function for geniv template cipher. Before the crypto
+ * operation, it splits the memory segments (in the scatterlist) into 512 byte
+ * sectors. The initialization vector(IV) used is based on a unique sector
+ * number which is generated here.
+ */
+static int geniv_crypt(struct skcipher_request *req, bool encrypt)
+{
+	struct crypto_skcipher *tfm = crypto_skcipher_reqtfm(req);
+	struct geniv_ctx *ctx = crypto_skcipher_ctx(tfm);
+	struct geniv_req_ctx *rctx = geniv_req_ctx(req);
+	struct geniv_req_info *rinfo = (struct geniv_req_info *) req->iv;
+	int i, bytes, cryptlen, ret = 0;
+	unsigned int sectors, segno = 0, done = 0;
+	char *str __maybe_unused = encrypt ? "encrypt" : "decrypt";
+
+	/* Instance of 'struct geniv_req_info' is stored in IV ptr */
+	rctx->is_write = rinfo->is_write;
+	rctx->iv_sector = rinfo->iv_sector;
+	rctx->nents = rinfo->nents;
+	rctx->iv = rinfo->iv;
+	rctx->req = req;
+	rctx->subreq = NULL;
+	cryptlen = req->cryptlen;
+
+	DMDEBUG("geniv:%s: starting sector=%d, #segments=%u\n", str,
+		(unsigned int) rctx->iv_sector, rctx->nents);
+
+	sectors = geniv_get_sectors(req->src, req->dst, rctx->nents);
+
+	init_completion(&rctx->restart);
+	atomic_set(&rctx->req_pending, 1);
+
+	for (i = 0; i < sectors; i++) {
+		struct geniv_subreq *subreq;
+
+		ret = geniv_alloc_subreq(req, ctx, rctx);
+		if (ret)
+			goto end;
+
+		subreq = rctx->subreq;
+		subreq->rctx = rctx;
+
+		atomic_inc(&rctx->req_pending);
+		bytes = geniv_iter_block(req, subreq, rctx, &segno, &done);
+
+		if (bytes == 0)
+			break;
+
+		cryptlen -= bytes;
+
+		if (ctx->iv_gen_ops)
+			ret = ctx->iv_gen_ops->generator(ctx, rctx, subreq);
+
+		if (ret < 0) {
+			DMERR("Error in generating IV ret: %d\n", ret);
+			goto end;
+		}
+
+		skcipher_request_set_crypt(&subreq->req, &subreq->src,
+					   &subreq->dst, bytes, rctx->iv);
+
+		if (encrypt)
+			ret = crypto_skcipher_encrypt(&subreq->req);
+
+		else
+			ret = crypto_skcipher_decrypt(&subreq->req);
+
+		if (!ret && ctx->iv_gen_ops && ctx->iv_gen_ops->post)
+			ret = ctx->iv_gen_ops->post(ctx, rctx, subreq);
+
+		switch (ret) {
+		/*
+		 * The request was queued by a crypto driver
+		 * but the driver request queue is full, let's wait.
+		 */
+		case -EBUSY:
+			wait_for_completion(&rctx->restart);
+			reinit_completion(&rctx->restart);
+			/* fall through */
+		/*
+		 * The request is queued and processed asynchronously,
+		 * completion function geniv_async_done() is called.
+		 */
+		case -EINPROGRESS:
+			/* Marking this NULL lets the creation of a new sub-
+			 * request when 'geniv_alloc_subreq' is called.
+			 */
+			rctx->subreq = NULL;
+			rctx->iv_sector++;
+			cond_resched();
+			break;
+		/*
+		 * The request was already processed (synchronously).
+		 */
+		case 0:
+			atomic_dec(&rctx->req_pending);
+			rctx->iv_sector++;
+			cond_resched();
+			continue;
+
+		/* There was an error while processing the request. */
+		default:
+			atomic_dec(&rctx->req_pending);
+			return ret;
+		}
+
+		if (ret)
+			break;
+	}
+
+	if (rctx->subreq && atomic_read(&rctx->req_pending) == 1) {
+		DMDEBUG("geniv:%s: Freeing sub request\n", str);
+		mempool_free(rctx->subreq, ctx->subreq_pool);
+	}
+
+end:
+	return ret;
+}
+
+static int geniv_encrypt(struct skcipher_request *req)
+{
+	return geniv_crypt(req, true);
+}
+
+static int geniv_decrypt(struct skcipher_request *req)
+{
+	return geniv_crypt(req, false);
+}
+
+static int geniv_init_tfm(struct crypto_skcipher *tfm)
+{
+	struct geniv_ctx *ctx = crypto_skcipher_ctx(tfm);
+	unsigned int reqsize, align;
+	char *algname, *chainmode;
+	int psize, ret = 0;
+
+	algname = (char *) crypto_tfm_alg_name(crypto_skcipher_tfm(tfm));
+	ctx->ciphermode = kmalloc(CRYPTO_MAX_ALG_NAME, GFP_KERNEL);
+	if (!ctx->ciphermode) {
+		ret = -ENOMEM;
+		goto end;
+	}
+
+	/* Parse algorithm name 'ivmode(chainmode(cipher))' */
+	ctx->ivmode	= strsep(&algname, "(");
+	chainmode	= strsep(&algname, "(");
+	ctx->cipher	= strsep(&algname, ")");
+
+	snprintf(ctx->ciphermode, CRYPTO_MAX_ALG_NAME, "%s(%s)",
+		 chainmode, ctx->cipher);
+
+	DMDEBUG("ciphermode=%s, ivmode=%s\n", ctx->ciphermode, ctx->ivmode);
+
+	/*
+	 * Usually the underlying cipher instances are spawned here, but since
+	 * the value of tfms_count (which is equal to the key_count) is not
+	 * known yet, create only one instance and delay the creation of the
+	 * rest of the instances of the underlying cipher 'cbc(aes)' until
+	 * the setkey operation is invoked.
+	 * The first instance created i.e. ctx->child will later be assigned as
+	 * the 1st element in the array ctx->tfms. Creation of atleast one
+	 * instance of the cipher is necessary to be created here to uncover
+	 * any errors earlier than during the setkey operation later where the
+	 * remaining instances are created.
+	 */
+	ctx->child = crypto_alloc_skcipher(ctx->ciphermode, 0, 0);
+	if (IS_ERR(ctx->child)) {
+		ret = PTR_ERR(ctx->child);
+		DMERR("Failed to create skcipher %s. err %d\n",
+		      ctx->ciphermode, ret);
+		goto end;
+	}
+
+	/* Setup the current cipher's request structure */
+	align = crypto_skcipher_alignmask(tfm);
+	align &= ~(crypto_tfm_ctx_alignment() - 1);
+	reqsize = align + sizeof(struct geniv_req_ctx)
+			+ crypto_skcipher_reqsize(ctx->child);
+	crypto_skcipher_set_reqsize(tfm, reqsize);
+
+	/* create memory pool for sub-request structure */
+	psize = sizeof(struct geniv_subreq)
+			+ crypto_skcipher_reqsize(ctx->child);
+	ctx->subreq_pool = mempool_create_kmalloc_pool(MIN_IOS, psize);
+	if (!ctx->subreq_pool) {
+		ret = -ENOMEM;
+		DMERR("Could not allocate crypt sub-request mempool\n");
+	}
+end:
+	return ret;
+}
+
+static void geniv_exit_tfm(struct crypto_skcipher *tfm)
+{
+	struct geniv_ctx *ctx = crypto_skcipher_ctx(tfm);
+
+	if (ctx->iv_gen_ops && ctx->iv_gen_ops->dtr)
+		ctx->iv_gen_ops->dtr(ctx);
+
+	mempool_destroy(ctx->subreq_pool);
+	geniv_free_tfms(ctx);
+	kfree(ctx->ciphermode);
+}
+
+static void geniv_free(struct skcipher_instance *inst)
+{
+	struct crypto_skcipher_spawn *spawn = skcipher_instance_ctx(inst);
+
+	crypto_drop_skcipher(spawn);
+	kfree(inst);
+}
+
+static int geniv_create(struct crypto_template *tmpl,
+			struct rtattr **tb, char *algname)
+{
+	struct crypto_attr_type *algt;
+	struct skcipher_instance *inst;
+	struct skcipher_alg *alg;
+	struct crypto_skcipher_spawn *spawn;
+	const char *cipher_name;
+	int err;
+
+	algt = crypto_get_attr_type(tb);
+
+	if (IS_ERR(algt))
+		return PTR_ERR(algt);
+
+	if ((algt->type ^ CRYPTO_ALG_TYPE_SKCIPHER) & algt->mask)
+		return -EINVAL;
+
+	cipher_name = crypto_attr_alg_name(tb[1]);
+
+	if (IS_ERR(cipher_name))
+		return PTR_ERR(cipher_name);
+
+	inst = kzalloc(sizeof(*inst) + sizeof(*spawn), GFP_KERNEL);
+	if (!inst)
+		return -ENOMEM;
+
+	spawn = skcipher_instance_ctx(inst);
+
+	crypto_set_skcipher_spawn(spawn, skcipher_crypto_instance(inst));
+	err = crypto_grab_skcipher(spawn, cipher_name, 0,
+				    crypto_requires_sync(algt->type,
+							 algt->mask));
+
+	if (err)
+		goto err_free_inst;
+
+	alg = crypto_spawn_skcipher_alg(spawn);
+
+	err = -EINVAL;
+
+	/* Only support blocks of size which is of a power of 2 */
+	if (!is_power_of_2(alg->base.cra_blocksize))
+		goto err_drop_spawn;
+
+	/* algname: essiv, base.cra_name: cbc(aes) */
+	err = -ENAMETOOLONG;
+	if (snprintf(inst->alg.base.cra_name, CRYPTO_MAX_ALG_NAME, "%s(%s)",
+		     algname, alg->base.cra_name) >= CRYPTO_MAX_ALG_NAME)
+		goto err_drop_spawn;
+	if (snprintf(inst->alg.base.cra_driver_name, CRYPTO_MAX_ALG_NAME,
+		     "%s(%s)", algname, alg->base.cra_driver_name) >=
+	    CRYPTO_MAX_ALG_NAME)
+		goto err_drop_spawn;
+
+	inst->alg.base.cra_flags = CRYPTO_ALG_TYPE_BLKCIPHER;
+	inst->alg.base.cra_priority = alg->base.cra_priority;
+	inst->alg.base.cra_blocksize = alg->base.cra_blocksize;
+	inst->alg.base.cra_alignmask = alg->base.cra_alignmask;
+	inst->alg.base.cra_flags = alg->base.cra_flags & CRYPTO_ALG_ASYNC;
+	inst->alg.ivsize = alg->base.cra_blocksize;
+	inst->alg.chunksize = crypto_skcipher_alg_chunksize(alg);
+	inst->alg.min_keysize = crypto_skcipher_alg_min_keysize(alg);
+	inst->alg.max_keysize = crypto_skcipher_alg_max_keysize(alg);
+
+	inst->alg.setkey = geniv_setkey;
+	inst->alg.encrypt = geniv_encrypt;
+	inst->alg.decrypt = geniv_decrypt;
+
+	inst->alg.base.cra_ctxsize = sizeof(struct geniv_ctx);
+
+	inst->alg.init = geniv_init_tfm;
+	inst->alg.exit = geniv_exit_tfm;
+
+	inst->free = geniv_free;
+
+	err = skcipher_register_instance(tmpl, inst);
+	if (err)
+		goto err_drop_spawn;
+
+out:
+	return err;
+
+err_drop_spawn:
+	crypto_drop_skcipher(spawn);
+err_free_inst:
+	kfree(inst);
+	goto out;
+}
+
+static int crypto_plain_create(struct crypto_template *tmpl,
+			       struct rtattr **tb)
+{
+	return geniv_create(tmpl, tb, "plain");
+}
+
+static int crypto_plain64_create(struct crypto_template *tmpl,
+				 struct rtattr **tb)
+{
+	return geniv_create(tmpl, tb, "plain64");
+}
+
+static int crypto_essiv_create(struct crypto_template *tmpl,
+			       struct rtattr **tb)
+{
+	return geniv_create(tmpl, tb, "essiv");
+}
+
+static int crypto_benbi_create(struct crypto_template *tmpl,
+			       struct rtattr **tb)
+{
+	return geniv_create(tmpl, tb, "benbi");
+}
+
+static int crypto_null_create(struct crypto_template *tmpl,
+			      struct rtattr **tb)
+{
+	return geniv_create(tmpl, tb, "null");
+}
+
+static int crypto_lmk_create(struct crypto_template *tmpl,
+			     struct rtattr **tb)
+{
+	return geniv_create(tmpl, tb, "lmk");
+}
+
+static int crypto_tcw_create(struct crypto_template *tmpl,
+			     struct rtattr **tb)
+{
+	return geniv_create(tmpl, tb, "tcw");
+}
+
+static struct crypto_template crypto_plain_tmpl = {
+	.name   = "plain",
+	.create = crypto_plain_create,
+	.module = THIS_MODULE,
+};
+
+static struct crypto_template crypto_plain64_tmpl = {
+	.name   = "plain64",
+	.create = crypto_plain64_create,
+	.module = THIS_MODULE,
+};
+
+static struct crypto_template crypto_essiv_tmpl = {
+	.name   = "essiv",
+	.create = crypto_essiv_create,
+	.module = THIS_MODULE,
+};
+
+static struct crypto_template crypto_benbi_tmpl = {
+	.name   = "benbi",
+	.create = crypto_benbi_create,
+	.module = THIS_MODULE,
+};
+
+static struct crypto_template crypto_null_tmpl = {
+	.name   = "null",
+	.create = crypto_null_create,
+	.module = THIS_MODULE,
+};
+
+static struct crypto_template crypto_lmk_tmpl = {
+	.name   = "lmk",
+	.create = crypto_lmk_create,
+	.module = THIS_MODULE,
+};
+
+static struct crypto_template crypto_tcw_tmpl = {
+	.name   = "tcw",
+	.create = crypto_tcw_create,
+	.module = THIS_MODULE,
+};
+
+static int __init geniv_register_algs(void)
+{
+	int err;
+
+	err = crypto_register_template(&crypto_plain_tmpl);
+	if (err)
+		goto out;
+
+	err = crypto_register_template(&crypto_plain64_tmpl);
+	if (err)
+		goto out_undo_plain;
+
+	err = crypto_register_template(&crypto_essiv_tmpl);
+	if (err)
+		goto out_undo_plain64;
+
+	err = crypto_register_template(&crypto_benbi_tmpl);
+	if (err)
+		goto out_undo_essiv;
+
+	err = crypto_register_template(&crypto_null_tmpl);
+	if (err)
+		goto out_undo_benbi;
+
+	err = crypto_register_template(&crypto_lmk_tmpl);
+	if (err)
+		goto out_undo_null;
+
+	err = crypto_register_template(&crypto_tcw_tmpl);
+	if (!err)
+		goto out;
+
+	crypto_unregister_template(&crypto_lmk_tmpl);
+out_undo_null:
+	crypto_unregister_template(&crypto_null_tmpl);
+out_undo_benbi:
+	crypto_unregister_template(&crypto_benbi_tmpl);
+out_undo_essiv:
+	crypto_unregister_template(&crypto_essiv_tmpl);
+out_undo_plain64:
+	crypto_unregister_template(&crypto_plain64_tmpl);
+out_undo_plain:
+	crypto_unregister_template(&crypto_plain_tmpl);
+out:
+	return err;
+}
+
+static void __exit geniv_deregister_algs(void)
+{
+	crypto_unregister_template(&crypto_plain_tmpl);
+	crypto_unregister_template(&crypto_plain64_tmpl);
+	crypto_unregister_template(&crypto_essiv_tmpl);
+	crypto_unregister_template(&crypto_benbi_tmpl);
+	crypto_unregister_template(&crypto_null_tmpl);
+	crypto_unregister_template(&crypto_lmk_tmpl);
+	crypto_unregister_template(&crypto_tcw_tmpl);
+}
+
+/* End of geniv template cipher algorithms */
+
+/*
+ * context holding the current state of a multi-part conversion
+ */
+struct convert_context {
+	struct completion restart;
+	struct bio *bio_in;
+	struct bio *bio_out;
+	struct bvec_iter iter_in;
+	struct bvec_iter iter_out;
+	sector_t cc_sector;
+	atomic_t cc_pending;
+	struct skcipher_request *req;
+};
+
+/*
+ * per bio private data
+ */
+struct dm_crypt_io {
+	struct crypt_config *cc;
+	struct bio *base_bio;
+	struct work_struct work;
+
+	struct convert_context ctx;
 
-static int crypt_iv_tcw_gen(struct crypt_config *cc, u8 *iv,
-			    struct dm_crypt_request *dmreq)
-{
-	struct iv_tcw_private *tcw = &cc->iv_gen_private.tcw;
-	__le64 sector = cpu_to_le64(dmreq->iv_sector);
-	u8 *src;
-	int r = 0;
+	atomic_t io_pending;
+	int error;
+	sector_t sector;
 
-	/* Remove whitening from ciphertext */
-	if (bio_data_dir(dmreq->ctx->bio_in) != WRITE) {
-		src = kmap_atomic(sg_page(&dmreq->sg_in));
-		r = crypt_iv_tcw_whitening(cc, dmreq, src + dmreq->sg_in.offset);
-		kunmap_atomic(src);
-	}
+	struct rb_node rb_node;
+} CRYPTO_MINALIGN_ATTR;
 
-	/* Calculate IV */
-	memcpy(iv, tcw->iv_seed, cc->iv_size);
-	crypto_xor(iv, (u8 *)&sector, 8);
-	if (cc->iv_size > 8)
-		crypto_xor(&iv[8], (u8 *)&sector, cc->iv_size - 8);
+struct dm_crypt_request {
+	struct convert_context *ctx;
+	struct scatterlist *sg_in;
+	struct scatterlist *sg_out;
+	sector_t iv_sector;
+};
 
-	return r;
-}
+struct crypt_config;
 
-static int crypt_iv_tcw_post(struct crypt_config *cc, u8 *iv,
-			     struct dm_crypt_request *dmreq)
-{
-	u8 *dst;
-	int r;
+/*
+ * Crypt: maps a linear range of a block device
+ * and encrypts / decrypts at the same time.
+ */
+enum flags { DM_CRYPT_SUSPENDED, DM_CRYPT_KEY_VALID,
+	     DM_CRYPT_SAME_CPU, DM_CRYPT_NO_OFFLOAD };
 
-	if (bio_data_dir(dmreq->ctx->bio_in) != WRITE)
-		return 0;
+/*
+ * The fields in here must be read only after initialization.
+ */
+struct crypt_config {
+	struct dm_dev *dev;
+	sector_t start;
 
-	/* Apply whitening on ciphertext */
-	dst = kmap_atomic(sg_page(&dmreq->sg_out));
-	r = crypt_iv_tcw_whitening(cc, dmreq, dst + dmreq->sg_out.offset);
-	kunmap_atomic(dst);
+	/*
+	 * pool for per bio private data, crypto requests and
+	 * encryption requeusts/buffer pages
+	 */
+	mempool_t *req_pool;
+	mempool_t *page_pool;
+	struct bio_set *bs;
+	struct mutex bio_alloc_lock;
 
-	return r;
-}
+	struct workqueue_struct *io_queue;
+	struct workqueue_struct *crypt_queue;
 
-static const struct crypt_iv_operations crypt_iv_plain_ops = {
-	.generator = crypt_iv_plain_gen
-};
+	struct task_struct *write_thread;
+	wait_queue_head_t write_thread_wait;
+	struct rb_root write_tree;
 
-static const struct crypt_iv_operations crypt_iv_plain64_ops = {
-	.generator = crypt_iv_plain64_gen
-};
+	char *cipher;
+	char *cipher_string;
+	char *key_string;
 
-static const struct crypt_iv_operations crypt_iv_essiv_ops = {
-	.ctr       = crypt_iv_essiv_ctr,
-	.dtr       = crypt_iv_essiv_dtr,
-	.init      = crypt_iv_essiv_init,
-	.wipe      = crypt_iv_essiv_wipe,
-	.generator = crypt_iv_essiv_gen
-};
+	sector_t iv_offset;
+	unsigned int iv_size;
 
-static const struct crypt_iv_operations crypt_iv_benbi_ops = {
-	.ctr	   = crypt_iv_benbi_ctr,
-	.dtr	   = crypt_iv_benbi_dtr,
-	.generator = crypt_iv_benbi_gen
-};
+	/* ESSIV: struct crypto_cipher *essiv_tfm */
+	void *iv_private;
+	struct crypto_skcipher *tfm;
+	unsigned int tfms_count;
 
-static const struct crypt_iv_operations crypt_iv_null_ops = {
-	.generator = crypt_iv_null_gen
-};
+	/*
+	 * Layout of each crypto request:
+	 *
+	 *   struct skcipher_request
+	 *      context
+	 *      padding
+	 *   struct dm_crypt_request
+	 *      padding
+	 *   IV
+	 *
+	 * The padding is added so that dm_crypt_request and the IV are
+	 * correctly aligned.
+	 */
+	unsigned int dmreq_start;
 
-static const struct crypt_iv_operations crypt_iv_lmk_ops = {
-	.ctr	   = crypt_iv_lmk_ctr,
-	.dtr	   = crypt_iv_lmk_dtr,
-	.init	   = crypt_iv_lmk_init,
-	.wipe	   = crypt_iv_lmk_wipe,
-	.generator = crypt_iv_lmk_gen,
-	.post	   = crypt_iv_lmk_post
-};
+	unsigned int per_bio_data_size;
 
-static const struct crypt_iv_operations crypt_iv_tcw_ops = {
-	.ctr	   = crypt_iv_tcw_ctr,
-	.dtr	   = crypt_iv_tcw_dtr,
-	.init	   = crypt_iv_tcw_init,
-	.wipe	   = crypt_iv_tcw_wipe,
-	.generator = crypt_iv_tcw_gen,
-	.post	   = crypt_iv_tcw_post
+	unsigned long flags;
+	unsigned int key_size;
+	unsigned int key_parts;      /* independent parts in key buffer */
+	unsigned int key_extra_size; /* additional keys length */
+	u8 key[0];
 };
 
+static void clone_init(struct dm_crypt_io *, struct bio *);
+static void kcryptd_queue_crypt(struct dm_crypt_io *io);
+static u8 *iv_of_dmreq(struct crypt_config *cc, struct dm_crypt_request *dmreq);
+
 static void crypt_convert_init(struct crypt_config *cc,
 			       struct convert_context *ctx,
 			       struct bio *bio_out, struct bio *bio_in,
@@ -837,53 +1700,7 @@ static u8 *iv_of_dmreq(struct crypt_config *cc,
 		       struct dm_crypt_request *dmreq)
 {
 	return (u8 *)ALIGN((unsigned long)(dmreq + 1),
-		crypto_skcipher_alignmask(any_tfm(cc)) + 1);
-}
-
-static int crypt_convert_block(struct crypt_config *cc,
-			       struct convert_context *ctx,
-			       struct skcipher_request *req)
-{
-	struct bio_vec bv_in = bio_iter_iovec(ctx->bio_in, ctx->iter_in);
-	struct bio_vec bv_out = bio_iter_iovec(ctx->bio_out, ctx->iter_out);
-	struct dm_crypt_request *dmreq;
-	u8 *iv;
-	int r;
-
-	dmreq = dmreq_of_req(cc, req);
-	iv = iv_of_dmreq(cc, dmreq);
-
-	dmreq->iv_sector = ctx->cc_sector;
-	dmreq->ctx = ctx;
-	sg_init_table(&dmreq->sg_in, 1);
-	sg_set_page(&dmreq->sg_in, bv_in.bv_page, 1 << SECTOR_SHIFT,
-		    bv_in.bv_offset);
-
-	sg_init_table(&dmreq->sg_out, 1);
-	sg_set_page(&dmreq->sg_out, bv_out.bv_page, 1 << SECTOR_SHIFT,
-		    bv_out.bv_offset);
-
-	bio_advance_iter(ctx->bio_in, &ctx->iter_in, 1 << SECTOR_SHIFT);
-	bio_advance_iter(ctx->bio_out, &ctx->iter_out, 1 << SECTOR_SHIFT);
-
-	if (cc->iv_gen_ops) {
-		r = cc->iv_gen_ops->generator(cc, iv, dmreq);
-		if (r < 0)
-			return r;
-	}
-
-	skcipher_request_set_crypt(req, &dmreq->sg_in, &dmreq->sg_out,
-				   1 << SECTOR_SHIFT, iv);
-
-	if (bio_data_dir(ctx->bio_in) == WRITE)
-		r = crypto_skcipher_encrypt(req);
-	else
-		r = crypto_skcipher_decrypt(req);
-
-	if (!r && cc->iv_gen_ops && cc->iv_gen_ops->post)
-		r = cc->iv_gen_ops->post(cc, iv, dmreq);
-
-	return r;
+		crypto_skcipher_alignmask(cc->tfm) + 1);
 }
 
 static void kcryptd_async_done(struct crypto_async_request *async_req,
@@ -892,12 +1709,10 @@ static void kcryptd_async_done(struct crypto_async_request *async_req,
 static void crypt_alloc_req(struct crypt_config *cc,
 			    struct convert_context *ctx)
 {
-	unsigned key_index = ctx->cc_sector & (cc->tfms_count - 1);
-
 	if (!ctx->req)
 		ctx->req = mempool_alloc(cc->req_pool, GFP_NOIO);
 
-	skcipher_request_set_tfm(ctx->req, cc->tfms[key_index]);
+	skcipher_request_set_tfm(ctx->req, cc->tfm);
 
 	/*
 	 * Use REQ_MAY_BACKLOG so a cipher driver internally backlogs
@@ -920,57 +1735,98 @@ static void crypt_free_req(struct crypt_config *cc,
 /*
  * Encrypt / decrypt data from one bio to another one (can be the same one)
  */
-static int crypt_convert(struct crypt_config *cc,
-			 struct convert_context *ctx)
+
+static int crypt_convert_bio(struct crypt_config *cc,
+			     struct convert_context *ctx)
 {
+	unsigned int cryptlen, n1, n2, nents, i = 0, bytes = 0;
+	struct skcipher_request *req;
+	struct dm_crypt_request *dmreq;
+	struct geniv_req_info rinfo;
+	struct bio_vec bv_in, bv_out;
 	int r;
+	u8 *iv;
 
 	atomic_set(&ctx->cc_pending, 1);
+	crypt_alloc_req(cc, ctx);
+
+	req = ctx->req;
+	dmreq = dmreq_of_req(cc, req);
+	iv = iv_of_dmreq(cc, dmreq);
 
-	while (ctx->iter_in.bi_size && ctx->iter_out.bi_size) {
+	n1 = bio_segments(ctx->bio_in);
+	n2 = bio_segments(ctx->bio_out);
+	nents = n1 > n2 ? n1 : n2;
+	nents = nents > MAX_SG_LIST ? MAX_SG_LIST : nents;
+	cryptlen = ctx->iter_in.bi_size;
 
-		crypt_alloc_req(cc, ctx);
+	DMDEBUG("dm-crypt:%s: segments:[in=%u, out=%u] bi_size=%u\n",
+		bio_data_dir(ctx->bio_in) == WRITE ? "write" : "read",
+		n1, n2, cryptlen);
 
-		atomic_inc(&ctx->cc_pending);
+	dmreq->sg_in  = kcalloc(nents, sizeof(struct scatterlist), GFP_KERNEL);
+	dmreq->sg_out = kcalloc(nents, sizeof(struct scatterlist), GFP_KERNEL);
+	if (!dmreq->sg_in || !dmreq->sg_out) {
+		DMERR("dm-crypt: Failed to allocate scatterlist\n");
+		r = -ENOMEM;
+		goto end;
+	}
+	dmreq->ctx = ctx;
 
-		r = crypt_convert_block(cc, ctx, ctx->req);
+	sg_init_table(dmreq->sg_in, nents);
+	sg_init_table(dmreq->sg_out, nents);
 
-		switch (r) {
-		/*
-		 * The request was queued by a crypto driver
-		 * but the driver request queue is full, let's wait.
-		 */
-		case -EBUSY:
-			wait_for_completion(&ctx->restart);
-			reinit_completion(&ctx->restart);
-			/* fall through */
-		/*
-		 * The request is queued and processed asynchronously,
-		 * completion function kcryptd_async_done() will be called.
-		 */
-		case -EINPROGRESS:
-			ctx->req = NULL;
-			ctx->cc_sector++;
-			continue;
-		/*
-		 * The request was already processed (synchronously).
-		 */
-		case 0:
-			atomic_dec(&ctx->cc_pending);
-			ctx->cc_sector++;
-			cond_resched();
-			continue;
+	while (ctx->iter_in.bi_size && ctx->iter_out.bi_size && i < nents) {
+		bv_in = bio_iter_iovec(ctx->bio_in, ctx->iter_in);
+		bv_out = bio_iter_iovec(ctx->bio_out, ctx->iter_out);
 
-		/* There was an error while processing the request. */
-		default:
-			atomic_dec(&ctx->cc_pending);
-			return r;
-		}
+		sg_set_page(&dmreq->sg_in[i], bv_in.bv_page, bv_in.bv_len,
+			    bv_in.bv_offset);
+		sg_set_page(&dmreq->sg_out[i], bv_out.bv_page, bv_out.bv_len,
+			    bv_out.bv_offset);
+
+		bio_advance_iter(ctx->bio_in, &ctx->iter_in, bv_in.bv_len);
+		bio_advance_iter(ctx->bio_out, &ctx->iter_out, bv_out.bv_len);
+
+		bytes += bv_in.bv_len;
+		i++;
 	}
 
-	return 0;
+	DMDEBUG("dm-crypt: Processed %u of %u bytes\n", bytes, cryptlen);
+
+	rinfo.is_write = (bio_data_dir(ctx->bio_in) == WRITE);
+	rinfo.iv_sector = ctx->cc_sector;
+	rinfo.nents = nents;
+	rinfo.iv = iv;
+
+	skcipher_request_set_crypt(req, dmreq->sg_in, dmreq->sg_out,
+				   bytes, &rinfo);
+
+	if (bio_data_dir(ctx->bio_in) == WRITE)
+		r = crypto_skcipher_encrypt(req);
+	else
+		r = crypto_skcipher_decrypt(req);
+
+	switch (r) {
+	/* The request was queued so wait. */
+	case -EBUSY:
+		wait_for_completion(&ctx->restart);
+		reinit_completion(&ctx->restart);
+		/* fall through */
+	/*
+	 * The request is queued and processed asynchronously,
+	 * completion function kcryptd_async_done() is called.
+	 */
+	case -EINPROGRESS:
+		ctx->req = NULL;
+		cond_resched();
+		break;
+	}
+end:
+	return r;
 }
 
+
 static void crypt_free_buffer_pages(struct crypt_config *cc, struct bio *clone);
 
 /*
@@ -1070,11 +1926,17 @@ static void crypt_dec_pending(struct dm_crypt_io *io)
 {
 	struct crypt_config *cc = io->cc;
 	struct bio *base_bio = io->base_bio;
+	struct dm_crypt_request *dmreq;
 	int error = io->error;
 
 	if (!atomic_dec_and_test(&io->io_pending))
 		return;
 
+	dmreq = dmreq_of_req(cc, io->ctx.req);
+	DMDEBUG("dm-crypt: Freeing scatterlists [sync]\n");
+	kfree(dmreq->sg_in);
+	kfree(dmreq->sg_out);
+
 	if (io->ctx.req)
 		crypt_free_req(cc, io->ctx.req, base_bio);
 
@@ -1313,7 +2175,7 @@ static void kcryptd_crypt_write_convert(struct dm_crypt_io *io)
 	sector += bio_sectors(clone);
 
 	crypt_inc_pending(io);
-	r = crypt_convert(cc, &io->ctx);
+	r = crypt_convert_bio(cc, &io->ctx);
 	if (r)
 		io->error = -EIO;
 	crypt_finished = atomic_dec_and_test(&io->ctx.cc_pending);
@@ -1343,7 +2205,8 @@ static void kcryptd_crypt_read_convert(struct dm_crypt_io *io)
 	crypt_convert_init(cc, &io->ctx, io->base_bio, io->base_bio,
 			   io->sector);
 
-	r = crypt_convert(cc, &io->ctx);
+	r = crypt_convert_bio(cc, &io->ctx);
+
 	if (r < 0)
 		io->error = -EIO;
 
@@ -1371,12 +2234,13 @@ static void kcryptd_async_done(struct crypto_async_request *async_req,
 		return;
 	}
 
-	if (!error && cc->iv_gen_ops && cc->iv_gen_ops->post)
-		error = cc->iv_gen_ops->post(cc, iv_of_dmreq(cc, dmreq), dmreq);
-
 	if (error < 0)
 		io->error = -EIO;
 
+	DMDEBUG("dm-crypt: Freeing scatterlists and request struct [async]\n");
+	kfree(dmreq->sg_in);
+	kfree(dmreq->sg_out);
+
 	crypt_free_req(cc, req_of_dmreq(cc, dmreq), io->base_bio);
 
 	if (!atomic_dec_and_test(&ctx->cc_pending))
@@ -1430,62 +2294,38 @@ static int crypt_decode_key(u8 *key, char *hex, unsigned int size)
 	return 0;
 }
 
-static void crypt_free_tfms(struct crypt_config *cc)
+static void crypt_free_tfm(struct crypt_config *cc)
 {
-	unsigned i;
-
-	if (!cc->tfms)
+	if (!cc->tfm)
 		return;
 
-	for (i = 0; i < cc->tfms_count; i++)
-		if (cc->tfms[i] && !IS_ERR(cc->tfms[i])) {
-			crypto_free_skcipher(cc->tfms[i]);
-			cc->tfms[i] = NULL;
-		}
+	if (cc->tfm && !IS_ERR(cc->tfm))
+		crypto_free_skcipher(cc->tfm);
 
-	kfree(cc->tfms);
-	cc->tfms = NULL;
+	cc->tfm = NULL;
 }
 
-static int crypt_alloc_tfms(struct crypt_config *cc, char *ciphermode)
+static int crypt_alloc_tfm(struct crypt_config *cc, char *ciphermode)
 {
-	unsigned i;
 	int err;
 
-	cc->tfms = kzalloc(cc->tfms_count * sizeof(struct crypto_skcipher *),
-			   GFP_KERNEL);
-	if (!cc->tfms)
-		return -ENOMEM;
-
-	for (i = 0; i < cc->tfms_count; i++) {
-		cc->tfms[i] = crypto_alloc_skcipher(ciphermode, 0, 0);
-		if (IS_ERR(cc->tfms[i])) {
-			err = PTR_ERR(cc->tfms[i]);
-			crypt_free_tfms(cc);
-			return err;
-		}
+	cc->tfm = crypto_alloc_skcipher(ciphermode, 0, 0);
+	if (IS_ERR(cc->tfm)) {
+		err = PTR_ERR(cc->tfm);
+		crypt_free_tfm(cc);
+		return err;
 	}
 
 	return 0;
 }
 
-static int crypt_setkey(struct crypt_config *cc)
+static inline int crypt_setkey(struct crypt_config *cc, enum setkey_op keyop,
+			       char *ivopts)
 {
-	unsigned subkey_size;
-	int err = 0, i, r;
-
-	/* Ignore extra keys (which are used for IV etc) */
-	subkey_size = (cc->key_size - cc->key_extra_size) >> ilog2(cc->tfms_count);
-
-	for (i = 0; i < cc->tfms_count; i++) {
-		r = crypto_skcipher_setkey(cc->tfms[i],
-					   cc->key + (i * subkey_size),
-					   subkey_size);
-		if (r)
-			err = r;
-	}
+	DECLARE_GENIV_KEY(kinfo, keyop, cc->tfms_count, cc->key, cc->key_size,
+			  cc->key_parts, ivopts);
 
-	return err;
+	return crypto_skcipher_setkey(cc->tfm, (u8 *) &kinfo, sizeof(kinfo));
 }
 
 #ifdef CONFIG_KEYS
@@ -1498,7 +2338,9 @@ static bool contains_whitespace(const char *str)
 	return false;
 }
 
-static int crypt_set_keyring_key(struct crypt_config *cc, const char *key_string)
+static int crypt_set_keyring_key(struct crypt_config *cc,
+				 const char *key_string,
+				 enum setkey_op keyop, char *ivopts)
 {
 	char *new_key_string, *key_desc;
 	int ret;
@@ -1559,7 +2401,7 @@ static int crypt_set_keyring_key(struct crypt_config *cc, const char *key_string
 	/* clear the flag since following operations may invalidate previously valid key */
 	clear_bit(DM_CRYPT_KEY_VALID, &cc->flags);
 
-	ret = crypt_setkey(cc);
+	ret = crypt_setkey(cc, keyop, ivopts);
 
 	/* wipe the kernel key payload copy in each case */
 	memset(cc->key, 0, cc->key_size * sizeof(u8));
@@ -1599,7 +2441,9 @@ static int get_key_size(char **key_string)
 
 #else
 
-static int crypt_set_keyring_key(struct crypt_config *cc, const char *key_string)
+static int crypt_set_keyring_key(struct crypt_config *cc,
+				 const char *key_string,
+				 enum setkey_op keyop, char *ivopts)
 {
 	return -EINVAL;
 }
@@ -1611,7 +2455,8 @@ static int get_key_size(char **key_string)
 
 #endif
 
-static int crypt_set_key(struct crypt_config *cc, char *key)
+static int crypt_set_key(struct crypt_config *cc, enum setkey_op keyop,
+			 char *key, char *ivopts)
 {
 	int r = -EINVAL;
 	int key_string_len = strlen(key);
@@ -1622,7 +2467,7 @@ static int crypt_set_key(struct crypt_config *cc, char *key)
 
 	/* ':' means the key is in kernel keyring, short-circuit normal key processing */
 	if (key[0] == ':') {
-		r = crypt_set_keyring_key(cc, key + 1);
+		r = crypt_set_keyring_key(cc, key + 1, keyop, ivopts);
 		goto out;
 	}
 
@@ -1636,7 +2481,7 @@ static int crypt_set_key(struct crypt_config *cc, char *key)
 	if (cc->key_size && crypt_decode_key(cc->key, key, cc->key_size) < 0)
 		goto out;
 
-	r = crypt_setkey(cc);
+	r = crypt_setkey(cc, keyop, ivopts);
 	if (!r)
 		set_bit(DM_CRYPT_KEY_VALID, &cc->flags);
 
@@ -1647,6 +2492,17 @@ static int crypt_set_key(struct crypt_config *cc, char *key)
 	return r;
 }
 
+static int crypt_init_key(struct dm_target *ti, char *key, char *ivopts)
+{
+	struct crypt_config *cc = ti->private;
+	int ret;
+
+	ret = crypt_set_key(cc, SETKEY_OP_INIT, key, ivopts);
+	if (ret < 0)
+		ti->error = "Error decoding and setting key";
+	return ret;
+}
+
 static int crypt_wipe_key(struct crypt_config *cc)
 {
 	clear_bit(DM_CRYPT_KEY_VALID, &cc->flags);
@@ -1654,7 +2510,7 @@ static int crypt_wipe_key(struct crypt_config *cc)
 	kzfree(cc->key_string);
 	cc->key_string = NULL;
 
-	return crypt_setkey(cc);
+	return crypt_setkey(cc, SETKEY_OP_WIPE, NULL);
 }
 
 static void crypt_dtr(struct dm_target *ti)
@@ -1674,7 +2530,7 @@ static void crypt_dtr(struct dm_target *ti)
 	if (cc->crypt_queue)
 		destroy_workqueue(cc->crypt_queue);
 
-	crypt_free_tfms(cc);
+	crypt_free_tfm(cc);
 
 	if (cc->bs)
 		bioset_free(cc->bs);
@@ -1682,9 +2538,6 @@ static void crypt_dtr(struct dm_target *ti)
 	mempool_destroy(cc->page_pool);
 	mempool_destroy(cc->req_pool);
 
-	if (cc->iv_gen_ops && cc->iv_gen_ops->dtr)
-		cc->iv_gen_ops->dtr(cc);
-
 	if (cc->dev)
 		dm_put_device(ti, cc->dev);
 
@@ -1762,22 +2615,30 @@ static int crypt_ctr_cipher(struct dm_target *ti,
 	if (!cipher_api)
 		goto bad_mem;
 
-	ret = snprintf(cipher_api, CRYPTO_MAX_ALG_NAME,
-		       "%s(%s)", chainmode, cipher);
+create_cipher:
+	/* For those ciphers which do not support IVs,
+	 * use the 'null' template cipher
+	 */
+
+	if (!ivmode)
+		ivmode = "null";
+
+	ret = snprintf(cipher_api, CRYPTO_MAX_ALG_NAME, "%s(%s(%s))",
+		       ivmode, chainmode, cipher);
 	if (ret < 0) {
 		kfree(cipher_api);
 		goto bad_mem;
 	}
 
 	/* Allocate cipher */
-	ret = crypt_alloc_tfms(cc, cipher_api);
+	ret = crypt_alloc_tfm(cc, cipher_api);
 	if (ret < 0) {
 		ti->error = "Error allocating crypto tfm";
 		goto bad;
 	}
 
 	/* Initialize IV */
-	cc->iv_size = crypto_skcipher_ivsize(any_tfm(cc));
+	cc->iv_size = crypto_skcipher_ivsize(cc->tfm);
 	if (cc->iv_size)
 		/* at least a 64 bit sector number should fit in our buffer */
 		cc->iv_size = max(cc->iv_size,
@@ -1785,23 +2646,10 @@ static int crypt_ctr_cipher(struct dm_target *ti,
 	else if (ivmode) {
 		DMWARN("Selected cipher does not support IVs");
 		ivmode = NULL;
+		goto create_cipher;
 	}
 
-	/* Choose ivmode, see comments at iv code. */
-	if (ivmode == NULL)
-		cc->iv_gen_ops = NULL;
-	else if (strcmp(ivmode, "plain") == 0)
-		cc->iv_gen_ops = &crypt_iv_plain_ops;
-	else if (strcmp(ivmode, "plain64") == 0)
-		cc->iv_gen_ops = &crypt_iv_plain64_ops;
-	else if (strcmp(ivmode, "essiv") == 0)
-		cc->iv_gen_ops = &crypt_iv_essiv_ops;
-	else if (strcmp(ivmode, "benbi") == 0)
-		cc->iv_gen_ops = &crypt_iv_benbi_ops;
-	else if (strcmp(ivmode, "null") == 0)
-		cc->iv_gen_ops = &crypt_iv_null_ops;
-	else if (strcmp(ivmode, "lmk") == 0) {
-		cc->iv_gen_ops = &crypt_iv_lmk_ops;
+	if (strcmp(ivmode, "lmk") == 0) {
 		/*
 		 * Version 2 and 3 is recognised according
 		 * to length of provided multi-key string.
@@ -1813,39 +2661,14 @@ static int crypt_ctr_cipher(struct dm_target *ti,
 			cc->key_extra_size = cc->key_size / cc->key_parts;
 		}
 	} else if (strcmp(ivmode, "tcw") == 0) {
-		cc->iv_gen_ops = &crypt_iv_tcw_ops;
 		cc->key_parts += 2; /* IV + whitening */
 		cc->key_extra_size = cc->iv_size + TCW_WHITENING_SIZE;
-	} else {
-		ret = -EINVAL;
-		ti->error = "Invalid IV mode";
-		goto bad;
 	}
 
 	/* Initialize and set key */
-	ret = crypt_set_key(cc, key);
-	if (ret < 0) {
-		ti->error = "Error decoding and setting key";
+	ret = crypt_init_key(ti, key, ivopts);
+	if (ret < 0)
 		goto bad;
-	}
-
-	/* Allocate IV */
-	if (cc->iv_gen_ops && cc->iv_gen_ops->ctr) {
-		ret = cc->iv_gen_ops->ctr(cc, ti, ivopts);
-		if (ret < 0) {
-			ti->error = "Error creating IV";
-			goto bad;
-		}
-	}
-
-	/* Initialize IV (set keys for ESSIV etc) */
-	if (cc->iv_gen_ops && cc->iv_gen_ops->init) {
-		ret = cc->iv_gen_ops->init(cc);
-		if (ret < 0) {
-			ti->error = "Error initialising IV";
-			goto bad;
-		}
-	}
 
 	ret = 0;
 bad:
@@ -1901,20 +2724,20 @@ static int crypt_ctr(struct dm_target *ti, unsigned int argc, char **argv)
 		goto bad;
 
 	cc->dmreq_start = sizeof(struct skcipher_request);
-	cc->dmreq_start += crypto_skcipher_reqsize(any_tfm(cc));
+	cc->dmreq_start += crypto_skcipher_reqsize(cc->tfm);
 	cc->dmreq_start = ALIGN(cc->dmreq_start, __alignof__(struct dm_crypt_request));
 
-	if (crypto_skcipher_alignmask(any_tfm(cc)) < CRYPTO_MINALIGN) {
+	if (crypto_skcipher_alignmask(cc->tfm) < CRYPTO_MINALIGN) {
 		/* Allocate the padding exactly */
 		iv_size_padding = -(cc->dmreq_start + sizeof(struct dm_crypt_request))
-				& crypto_skcipher_alignmask(any_tfm(cc));
+				& crypto_skcipher_alignmask(cc->tfm);
 	} else {
 		/*
 		 * If the cipher requires greater alignment than kmalloc
 		 * alignment, we don't know the exact position of the
 		 * initialization vector. We must assume worst case.
 		 */
-		iv_size_padding = crypto_skcipher_alignmask(any_tfm(cc));
+		iv_size_padding = crypto_skcipher_alignmask(cc->tfm);
 	}
 
 	ret = -ENOMEM;
@@ -2072,8 +2895,9 @@ static int crypt_map(struct dm_target *ti, struct bio *bio)
 	if (bio_data_dir(io->base_bio) == READ) {
 		if (kcryptd_io_read(io, GFP_NOWAIT))
 			kcryptd_queue_read(io);
-	} else
+	} else {
 		kcryptd_queue_crypt(io);
+	}
 
 	return DM_MAPIO_SUBMITTED;
 }
@@ -2155,7 +2979,7 @@ static void crypt_resume(struct dm_target *ti)
 static int crypt_message(struct dm_target *ti, unsigned argc, char **argv)
 {
 	struct crypt_config *cc = ti->private;
-	int key_size, ret = -EINVAL;
+	int key_size;
 
 	if (argc < 2)
 		goto error;
@@ -2173,19 +2997,9 @@ static int crypt_message(struct dm_target *ti, unsigned argc, char **argv)
 				return -EINVAL;
 			}
 
-			ret = crypt_set_key(cc, argv[2]);
-			if (ret)
-				return ret;
-			if (cc->iv_gen_ops && cc->iv_gen_ops->init)
-				ret = cc->iv_gen_ops->init(cc);
-			return ret;
+			return crypt_set_key(cc, SETKEY_OP_SET, argv[2], NULL);
 		}
 		if (argc == 2 && !strcasecmp(argv[1], "wipe")) {
-			if (cc->iv_gen_ops && cc->iv_gen_ops->wipe) {
-				ret = cc->iv_gen_ops->wipe(cc);
-				if (ret)
-					return ret;
-			}
 			return crypt_wipe_key(cc);
 		}
 	}
@@ -2216,7 +3030,7 @@ static void crypt_io_hints(struct dm_target *ti, struct queue_limits *limits)
 
 static struct target_type crypt_target = {
 	.name   = "crypt",
-	.version = {1, 15, 0},
+	.version = {1, 16, 0},
 	.module = THIS_MODULE,
 	.ctr    = crypt_ctr,
 	.dtr    = crypt_dtr,
@@ -2234,6 +3048,7 @@ static int __init dm_crypt_init(void)
 {
 	int r;
 
+	geniv_register_algs();
 	r = dm_register_target(&crypt_target);
 	if (r < 0)
 		DMERR("register failed %d", r);
@@ -2244,6 +3059,7 @@ static int __init dm_crypt_init(void)
 static void __exit dm_crypt_exit(void)
 {
 	dm_unregister_target(&crypt_target);
+	geniv_deregister_algs();
 }
 
 module_init(dm_crypt_init);
diff --git a/include/crypto/geniv.h b/include/crypto/geniv.h
new file mode 100644
index 0000000..b472507
--- /dev/null
+++ b/include/crypto/geniv.h
@@ -0,0 +1,47 @@
+/*
+ * geniv: common interface for IV generation algorithms
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms of the GNU General Public License as published by the Free
+ * Software Foundation; either version 2 of the License, or (at your option)
+ * any later version.
+ *
+ */
+#ifndef _CRYPTO_GENIV_
+#define _CRYPTO_GENIV_
+
+#define SECTOR_SIZE		(1 << SECTOR_SHIFT)
+
+enum setkey_op {
+	SETKEY_OP_INIT,
+	SETKEY_OP_SET,
+	SETKEY_OP_WIPE,
+};
+
+struct geniv_key_info {
+	enum setkey_op keyop;
+	unsigned int tfms_count;
+	u8 *key;
+	unsigned int key_size;
+	unsigned int key_parts;
+	char *ivopts;
+};
+
+#define DECLARE_GENIV_KEY(c, op, n, k, sz, kp, opts)	\
+	struct geniv_key_info c = {			\
+		.keyop = op,				\
+		.tfms_count = n,			\
+		.key = k,				\
+		.key_size = sz,				\
+		.key_parts = kp,			\
+		.ivopts = opts,				\
+	}
+
+struct geniv_req_info {
+	bool is_write;
+	sector_t iv_sector;
+	unsigned int nents;
+	u8 *iv;
+};
+
+#endif
-- 
Binoy Jayan

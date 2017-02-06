From: Gilad Ben-Yossef <gilad@benyossef.com>
Subject: [PATCH v2] dm: switch dm-verity to async hash crypto API
Date: Mon,  6 Feb 2017 15:58:02 +0200
Message-ID: <1486389482-26992-1-git-send-email-gilad@benyossef.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Cc: linux-crypto@vger.kernel.org, gilad.benyossef@arm.com,
        ofir.drang@arm.com, Eric Biggers <ebiggers3@gmail.com>,
        =?UTF-8?q?Ondrej=20Mosn=C3=A1=C4=8Dek?=
        <omosnacek+linux-crypto@gmail.com>
To: dm-devel@redhat.com, Alasdair Kergon <agk@redhat.com>,
        Mike Snitzer <snitzer@redhat.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from foss.arm.com ([217.140.101.70]:58486 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752310AbdBFN6P (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 6 Feb 2017 08:58:15 -0500
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Use of the synchronous digest API limits dm-verity to using pure
CPU based algorithm providers and rules out the use of off CPU
algorithm providers which are normally asynchronous by nature,
potentially freeing CPU cycles.

This can reduce performance per Watt in situations such as during
boot time when a lot of concurrent file accesses are made to the
protected volume.

Move DM_VERITY to the asynchronous hash API.

Signed-off-by: Gilad Ben-Yossef <gilad@benyossef.com>
CC: Eric Biggers <ebiggers3@gmail.com>
CC: Ondrej Mosnáček <omosnacek+linux-crypto@gmail.com>
---

The patch was tested on an Armv7 based dual core Zynq ZC706 development
board with SHA256-asm, SHA256-neon synchronous providers with no visible
degradation of performance and with off tree Arm CryptoCell asynchronous
provider.

Changes from v1:

- Use a 0 mask to allocate crypto alg indicating we welcome async algo 
  providers, as suggested by Ondrej Mosnáček.
- Fix use of un-initialized completion when using async provider for IO
  blocks hashing
- Pass flag indicating we are OK with crypto provider backlog
- Re-factor checking for need to wait into a common function

 drivers/md/dm-verity-fec.c    |   4 +-
 drivers/md/dm-verity-target.c | 202 +++++++++++++++++++++++++++++-------------
 drivers/md/dm-verity.h        |  23 +++--
 3 files changed, 158 insertions(+), 71 deletions(-)

diff --git a/drivers/md/dm-verity-fec.c b/drivers/md/dm-verity-fec.c
index 0f0eb8a..dab98fe 100644
--- a/drivers/md/dm-verity-fec.c
+++ b/drivers/md/dm-verity-fec.c
@@ -188,7 +188,7 @@ static int fec_decode_bufs(struct dm_verity *v, struct dm_verity_fec_io *fio,
 static int fec_is_erasure(struct dm_verity *v, struct dm_verity_io *io,
 			  u8 *want_digest, u8 *data)
 {
-	if (unlikely(verity_hash(v, verity_io_hash_desc(v, io),
+	if (unlikely(verity_hash(v, verity_io_hash_req(v, io),
 				 data, 1 << v->data_dev_block_bits,
 				 verity_io_real_digest(v, io))))
 		return 0;
@@ -397,7 +397,7 @@ static int fec_decode_rsb(struct dm_verity *v, struct dm_verity_io *io,
 	}
 
 	/* Always re-validate the corrected block against the expected hash */
-	r = verity_hash(v, verity_io_hash_desc(v, io), fio->output,
+	r = verity_hash(v, verity_io_hash_req(v, io), fio->output,
 			1 << v->data_dev_block_bits,
 			verity_io_real_digest(v, io));
 	if (unlikely(r < 0))
diff --git a/drivers/md/dm-verity-target.c b/drivers/md/dm-verity-target.c
index 7335d8a..f0b24cc 100644
--- a/drivers/md/dm-verity-target.c
+++ b/drivers/md/dm-verity-target.c
@@ -93,81 +93,124 @@ static sector_t verity_position_at_level(struct dm_verity *v, sector_t block,
 }
 
 /*
- * Wrapper for crypto_shash_init, which handles verity salting.
+ * Callback function for asynchrnous crypto API completion notification
  */
-static int verity_hash_init(struct dm_verity *v, struct shash_desc *desc)
+static void verity_op_done(struct crypto_async_request *base, int err)
 {
-	int r;
+	struct verity_result *res = (struct verity_result *)base->data;
 
-	desc->tfm = v->tfm;
-	desc->flags = CRYPTO_TFM_REQ_MAY_SLEEP;
+	if (err == -EINPROGRESS)
+		return;
 
-	r = crypto_shash_init(desc);
+	res->err = err;
+	complete(&res->completion);
+}
 
-	if (unlikely(r < 0)) {
-		DMERR("crypto_shash_init failed: %d", r);
-		return r;
-	}
+/*
+ * Wait for async crypto API callback
+ */
+static inline int verity_complete_op(struct verity_result *res, int ret)
+{
+	switch (ret) {
+	case 0:
+		break;
 
-	if (likely(v->version >= 1)) {
-		r = crypto_shash_update(desc, v->salt, v->salt_size);
+	case -EINPROGRESS:
+	case -EBUSY:
+		ret = wait_for_completion_interruptible(&res->completion);
+		if (!ret)
+			ret = res->err;
+		reinit_completion(&res->completion);
+		break;
 
-		if (unlikely(r < 0)) {
-			DMERR("crypto_shash_update failed: %d", r);
-			return r;
-		}
+	default:
+		DMERR("verity_wait_hash: crypto op submission failed: %d", ret);
 	}
 
-	return 0;
+	if (unlikely(ret < 0))
+		DMERR("verity_wait_hash: crypto op failed: %d", ret);
+
+	return ret;
 }
 
-static int verity_hash_update(struct dm_verity *v, struct shash_desc *desc,
-			      const u8 *data, size_t len)
+static int verity_hash_update(struct dm_verity *v, struct ahash_request *req,
+				const u8 *data, size_t len,
+				struct verity_result *res)
 {
-	int r = crypto_shash_update(desc, data, len);
+	struct scatterlist sg;
 
-	if (unlikely(r < 0))
-		DMERR("crypto_shash_update failed: %d", r);
+	sg_init_table(&sg, 1);
+	sg_set_buf(&sg, data, len);
+	ahash_request_set_crypt(req, &sg, NULL, len);
+
+	return verity_complete_op(res, crypto_ahash_update(req));
+}
+
+/*
+ * Wrapper for crypto_ahash_init, which handles verity salting.
+ */
+static int verity_hash_init(struct dm_verity *v, struct ahash_request *req,
+				struct verity_result *res)
+{
+	int r;
+
+	ahash_request_set_tfm(req, v->tfm);
+	ahash_request_set_callback(req, CRYPTO_TFM_REQ_MAY_SLEEP |
+					CRYPTO_TFM_REQ_MAY_BACKLOG,
+					verity_op_done, (void *)res);
+	init_completion(&res->completion);
+
+	r = crypto_ahash_init(req);
+
+	if (unlikely(r < 0)) {
+		DMERR("crypto_ahash_init failed: %d", r);
+		return r;
+	}
+
+	if (likely(v->version >= 1))
+		r = verity_hash_update(v, req, v->salt, v->salt_size, res);
 
 	return r;
 }
 
-static int verity_hash_final(struct dm_verity *v, struct shash_desc *desc,
-			     u8 *digest)
+static int verity_hash_final(struct dm_verity *v, struct ahash_request *req,
+			     u8 *digest, struct verity_result *res)
 {
 	int r;
 
 	if (unlikely(!v->version)) {
-		r = crypto_shash_update(desc, v->salt, v->salt_size);
+		r = verity_hash_update(v, req, v->salt, v->salt_size, res);
 
 		if (r < 0) {
-			DMERR("crypto_shash_update failed: %d", r);
-			return r;
+			DMERR("verity_hash_final failed updating salt: %d", r);
+			goto out;
 		}
 	}
 
-	r = crypto_shash_final(desc, digest);
-
-	if (unlikely(r < 0))
-		DMERR("crypto_shash_final failed: %d", r);
-
+	ahash_request_set_crypt(req, NULL, digest, 0);
+	r = verity_complete_op(res, crypto_ahash_final(req));
+out:
 	return r;
 }
 
-int verity_hash(struct dm_verity *v, struct shash_desc *desc,
+int verity_hash(struct dm_verity *v, struct ahash_request *req,
 		const u8 *data, size_t len, u8 *digest)
 {
 	int r;
+	struct verity_result res;
 
-	r = verity_hash_init(v, desc);
+	r = verity_hash_init(v, req, &res);
 	if (unlikely(r < 0))
-		return r;
+		goto out;
 
-	r = verity_hash_update(v, desc, data, len);
+	r = verity_hash_update(v, req, data, len, &res);
 	if (unlikely(r < 0))
-		return r;
+		goto out;
+
+	r = verity_hash_final(v, req, digest, &res);
 
-	return verity_hash_final(v, desc, digest);
+out:
+	return r;
 }
 
 static void verity_hash_at_level(struct dm_verity *v, sector_t block, int level,
@@ -275,7 +318,7 @@ static int verity_verify_level(struct dm_verity *v, struct dm_verity_io *io,
 			goto release_ret_r;
 		}
 
-		r = verity_hash(v, verity_io_hash_desc(v, io),
+		r = verity_hash(v, verity_io_hash_req(v, io),
 				data, 1 << v->hash_dev_block_bits,
 				verity_io_real_digest(v, io));
 		if (unlikely(r < 0))
@@ -344,6 +387,49 @@ int verity_hash_for_block(struct dm_verity *v, struct dm_verity_io *io,
 }
 
 /*
+ * Calculates the digest for the given bio
+ */
+int verity_for_io_block(struct dm_verity *v, struct dm_verity_io *io,
+			struct bvec_iter *iter, struct verity_result *res)
+{
+	unsigned int todo = 1 << v->data_dev_block_bits;
+	struct bio *bio = dm_bio_from_per_bio_data(io, v->ti->per_io_data_size);
+	struct scatterlist sg;
+	struct ahash_request *req = verity_io_hash_req(v, io);
+
+	do {
+		int r;
+		unsigned int len;
+		struct bio_vec bv = bio_iter_iovec(bio, *iter);
+
+		sg_init_table(&sg, 1);
+
+		len = bv.bv_len;
+
+		if (likely(len >= todo))
+			len = todo;
+		/*
+		 * Operating on a single page at a time looks suboptimal
+		 * until you consider the typical block size is 4,096B.
+		 * Going through this loops twice should be very rare.
+		 */
+		sg_set_page(&sg, bv.bv_page, len, bv.bv_offset);
+		ahash_request_set_crypt(req, &sg, NULL, len);
+		r = verity_complete_op(res, crypto_ahash_update(req));
+
+		if (unlikely(r < 0)) {
+			DMERR("verity_for_io_block crypto op failed: %d", r);
+			return r;
+		}
+
+		bio_advance_iter(bio, iter, len);
+		todo -= len;
+	} while (todo);
+
+	return 0;
+}
+
+/*
  * Calls function process for 1 << v->data_dev_block_bits bytes in the bio_vec
  * starting from iter.
  */
@@ -381,12 +467,6 @@ int verity_for_bv_block(struct dm_verity *v, struct dm_verity_io *io,
 	return 0;
 }
 
-static int verity_bv_hash_update(struct dm_verity *v, struct dm_verity_io *io,
-				 u8 *data, size_t len)
-{
-	return verity_hash_update(v, verity_io_hash_desc(v, io), data, len);
-}
-
 static int verity_bv_zero(struct dm_verity *v, struct dm_verity_io *io,
 			  u8 *data, size_t len)
 {
@@ -403,10 +483,11 @@ static int verity_verify_io(struct dm_verity_io *io)
 	struct dm_verity *v = io->v;
 	struct bvec_iter start;
 	unsigned b;
+	struct verity_result res;
 
 	for (b = 0; b < io->n_blocks; b++) {
 		int r;
-		struct shash_desc *desc = verity_io_hash_desc(v, io);
+		struct ahash_request *req = verity_io_hash_req(v, io);
 
 		r = verity_hash_for_block(v, io, io->block + b,
 					  verity_io_want_digest(v, io),
@@ -427,16 +508,17 @@ static int verity_verify_io(struct dm_verity_io *io)
 			continue;
 		}
 
-		r = verity_hash_init(v, desc);
+		r = verity_hash_init(v, req, &res);
 		if (unlikely(r < 0))
 			return r;
 
 		start = io->iter;
-		r = verity_for_bv_block(v, io, &io->iter, verity_bv_hash_update);
+		r = verity_for_io_block(v, io, &io->iter, &res);
 		if (unlikely(r < 0))
 			return r;
 
-		r = verity_hash_final(v, desc, verity_io_real_digest(v, io));
+		r = verity_hash_final(v, req, verity_io_real_digest(v, io),
+					&res);
 		if (unlikely(r < 0))
 			return r;
 
@@ -705,7 +787,7 @@ static void verity_dtr(struct dm_target *ti)
 	kfree(v->zero_digest);
 
 	if (v->tfm)
-		crypto_free_shash(v->tfm);
+		crypto_free_ahash(v->tfm);
 
 	kfree(v->alg_name);
 
@@ -723,7 +805,7 @@ static void verity_dtr(struct dm_target *ti)
 static int verity_alloc_zero_digest(struct dm_verity *v)
 {
 	int r = -ENOMEM;
-	struct shash_desc *desc;
+	struct ahash_request *req;
 	u8 *zero_data;
 
 	v->zero_digest = kmalloc(v->digest_size, GFP_KERNEL);
@@ -731,9 +813,9 @@ static int verity_alloc_zero_digest(struct dm_verity *v)
 	if (!v->zero_digest)
 		return r;
 
-	desc = kmalloc(v->shash_descsize, GFP_KERNEL);
+	req = kmalloc(v->ahash_reqsize, GFP_KERNEL);
 
-	if (!desc)
+	if (!req)
 		return r; /* verity_dtr will free zero_digest */
 
 	zero_data = kzalloc(1 << v->data_dev_block_bits, GFP_KERNEL);
@@ -741,11 +823,11 @@ static int verity_alloc_zero_digest(struct dm_verity *v)
 	if (!zero_data)
 		goto out;
 
-	r = verity_hash(v, desc, zero_data, 1 << v->data_dev_block_bits,
+	r = verity_hash(v, req, zero_data, 1 << v->data_dev_block_bits,
 			v->zero_digest);
 
 out:
-	kfree(desc);
+	kfree(req);
 	kfree(zero_data);
 
 	return r;
@@ -923,21 +1005,21 @@ static int verity_ctr(struct dm_target *ti, unsigned argc, char **argv)
 		goto bad;
 	}
 
-	v->tfm = crypto_alloc_shash(v->alg_name, 0, 0);
+	v->tfm = crypto_alloc_ahash(v->alg_name, 0, 0);
 	if (IS_ERR(v->tfm)) {
 		ti->error = "Cannot initialize hash function";
 		r = PTR_ERR(v->tfm);
 		v->tfm = NULL;
 		goto bad;
 	}
-	v->digest_size = crypto_shash_digestsize(v->tfm);
+	v->digest_size = crypto_ahash_digestsize(v->tfm);
 	if ((1 << v->hash_dev_block_bits) < v->digest_size * 2) {
 		ti->error = "Digest size too big";
 		r = -EINVAL;
 		goto bad;
 	}
-	v->shash_descsize =
-		sizeof(struct shash_desc) + crypto_shash_descsize(v->tfm);
+	v->ahash_reqsize = sizeof(struct ahash_request) +
+		crypto_ahash_reqsize(v->tfm);
 
 	v->root_digest = kmalloc(v->digest_size, GFP_KERNEL);
 	if (!v->root_digest) {
@@ -1037,7 +1119,7 @@ static int verity_ctr(struct dm_target *ti, unsigned argc, char **argv)
 	}
 
 	ti->per_io_data_size = sizeof(struct dm_verity_io) +
-				v->shash_descsize + v->digest_size * 2;
+				v->ahash_reqsize + v->digest_size * 2;
 
 	r = verity_fec_ctr(v);
 	if (r)
diff --git a/drivers/md/dm-verity.h b/drivers/md/dm-verity.h
index fb419f4..a59e0ad 100644
--- a/drivers/md/dm-verity.h
+++ b/drivers/md/dm-verity.h
@@ -37,7 +37,7 @@ struct dm_verity {
 	struct dm_target *ti;
 	struct dm_bufio_client *bufio;
 	char *alg_name;
-	struct crypto_shash *tfm;
+	struct crypto_ahash *tfm;
 	u8 *root_digest;	/* digest of the root block */
 	u8 *salt;		/* salt: its size is salt_size */
 	u8 *zero_digest;	/* digest for a zero block */
@@ -52,7 +52,7 @@ struct dm_verity {
 	unsigned char levels;	/* the number of tree levels */
 	unsigned char version;
 	unsigned digest_size;	/* digest size for the current hash algorithm */
-	unsigned shash_descsize;/* the size of temporary space for crypto */
+	unsigned int ahash_reqsize;/* the size of temporary space for crypto */
 	int hash_failed;	/* set to 1 if hash of any block failed */
 	enum verity_mode mode;	/* mode for handling verification errors */
 	unsigned corrupted_errs;/* Number of errors for corrupted blocks */
@@ -81,31 +81,36 @@ struct dm_verity_io {
 	/*
 	 * Three variably-size fields follow this struct:
 	 *
-	 * u8 hash_desc[v->shash_descsize];
+	 * u8 hash_req[v->ahash_reqsize];
 	 * u8 real_digest[v->digest_size];
 	 * u8 want_digest[v->digest_size];
 	 *
-	 * To access them use: verity_io_hash_desc(), verity_io_real_digest()
+	 * To access them use: verity_io_hash_req(), verity_io_real_digest()
 	 * and verity_io_want_digest().
 	 */
 };
 
-static inline struct shash_desc *verity_io_hash_desc(struct dm_verity *v,
+struct verity_result {
+	struct completion completion;
+	int err;
+};
+
+static inline struct ahash_request *verity_io_hash_req(struct dm_verity *v,
 						     struct dm_verity_io *io)
 {
-	return (struct shash_desc *)(io + 1);
+	return (struct ahash_request *)(io + 1);
 }
 
 static inline u8 *verity_io_real_digest(struct dm_verity *v,
 					struct dm_verity_io *io)
 {
-	return (u8 *)(io + 1) + v->shash_descsize;
+	return (u8 *)(io + 1) + v->ahash_reqsize;
 }
 
 static inline u8 *verity_io_want_digest(struct dm_verity *v,
 					struct dm_verity_io *io)
 {
-	return (u8 *)(io + 1) + v->shash_descsize + v->digest_size;
+	return (u8 *)(io + 1) + v->ahash_reqsize + v->digest_size;
 }
 
 static inline u8 *verity_io_digest_end(struct dm_verity *v,
@@ -120,7 +125,7 @@ extern int verity_for_bv_block(struct dm_verity *v, struct dm_verity_io *io,
 					      struct dm_verity_io *io,
 					      u8 *data, size_t len));
 
-extern int verity_hash(struct dm_verity *v, struct shash_desc *desc,
+extern int verity_hash(struct dm_verity *v, struct ahash_request *req,
 		       const u8 *data, size_t len, u8 *digest);
 
 extern int verity_hash_for_block(struct dm_verity *v, struct dm_verity_io *io,
-- 
2.1.4

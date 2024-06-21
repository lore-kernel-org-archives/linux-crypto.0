Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 062BA172BBE;
	Fri, 21 Jun 2024 17:00:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718989223; cv=none; b=mZy2FnepYcbq0xXnVIEnYaIWcBj8JRCN6kYNH6QbqXgP7DRtNt/NjlDSI5UD6KoJjUXAWHV9gVZfleHsTuvpFcJo9r5no2m2eGzJjwjFM9AoCHHdZqcTf6awWy3OOrxtr5MzCNkmol1Tr48lBqzl/h6/gdFSt0Qc/fB8Kcaovkg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718989223; c=relaxed/simple;
	bh=zflnXarlsAz1kc4aqNG2o4Ia4e5L2b5skffcwOmm1Lc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=I9u9HVX/mfTRCvN4mCTlzhuSyatfMRu4lNzXVfZZ3fLdnNmzTbnX3zUJSlHC+qwS3A+V00N24aXMCh0AEgmZ2kVS0xOfbsisEQzgAjOGppf14Mp47xfiKlvN5GOps04TvdUKykHTEDcyoB2MGc07Su5cDmhyHIO6Xktzh9IRnyI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=WpMS9HF2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="WpMS9HF2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 33FBFC2BBFC;
	Fri, 21 Jun 2024 17:00:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1718989222;
	bh=zflnXarlsAz1kc4aqNG2o4Ia4e5L2b5skffcwOmm1Lc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WpMS9HF22BRCbWMmTrIBjH5S6oycm3JFIEUdyIKPJrbL8OT70RTVcMKOm397GUMIu
	 Rb+TvThSm/CNEmT723Ji+JgctwoYSEzht0ouH5QZufNqUse0wh/o588oyaPpKHpMIQ
	 Thx3JEjhVzDyn1Q+Eq1FjXTlQZhTJK5MtTh7vSHHZ7pYTpBgs9oBKKLHcWPHR3ITfl
	 bAUR6EGLQSKCIgwQZ2NFRN5Dzqdb1zvNaO+j96JI53f9sgrviV6xAzdm+JhNIhAQcr
	 J9P9TFbkd4t/3YrToyl9isarkSgSuDRrUghHZdmT/e0xIv0XTaqZJzPh5WYbvtkpuj
	 w4PmYUwARbYxg==
From: Eric Biggers <ebiggers@kernel.org>
To: linux-crypto@vger.kernel.org,
	fsverity@lists.linux.dev,
	dm-devel@lists.linux.dev
Cc: x86@kernel.org,
	linux-arm-kernel@lists.infradead.org,
	Ard Biesheuvel <ardb@kernel.org>,
	Sami Tolvanen <samitolvanen@google.com>,
	Bart Van Assche <bvanassche@acm.org>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Alasdair Kergon <agk@redhat.com>,
	Mike Snitzer <snitzer@kernel.org>,
	Mikulas Patocka <mpatocka@redhat.com>
Subject: [PATCH v6 13/15] dm-verity: hash blocks with shash import+finup when possible
Date: Fri, 21 Jun 2024 09:59:20 -0700
Message-ID: <20240621165922.77672-14-ebiggers@kernel.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240621165922.77672-1-ebiggers@kernel.org>
References: <20240621165922.77672-1-ebiggers@kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Eric Biggers <ebiggers@google.com>

Currently dm-verity computes the hash of each block by using multiple
calls to the "ahash" crypto API.  While the exact sequence depends on
the chosen dm-verity settings, in the vast majority of cases it is:

    1. crypto_ahash_init()
    2. crypto_ahash_update() [salt]
    3. crypto_ahash_update() [data]
    4. crypto_ahash_final()

This is inefficient for two main reasons:

- It makes multiple indirect calls, which is expensive on modern CPUs
  especially when mitigations for CPU vulnerabilities are enabled.

  Since the salt is the same across all blocks on a given dm-verity
  device, a much more efficient sequence would be to do an import of the
  pre-salted state, then a finup.

- It uses the ahash (asynchronous hash) API, despite the fact that
  CPU-based hashing is almost always used in practice, and therefore it
  experiences the overhead of the ahash-based wrapper for shash.

  Because dm-verity was intentionally converted to ahash to support
  off-CPU crypto accelerators, a full reversion to shash might not be
  acceptable.  Yet, we should still provide a fast path for shash with
  the most common dm-verity settings.

  Another reason for shash over ahash is that the upcoming multibuffer
  hashing support, which is specific to CPU-based hashing, is much
  better suited for shash than for ahash.  Supporting it via ahash would
  add significant complexity and overhead.  And it's not possible for
  the "same" code to properly support both multibuffer hashing and HW
  accelerators at the same time anyway, given the different computation
  models.  Unfortunately there will always be code specific to each
  model needed (for users who want to support both).

Therefore, this patch adds a new shash import+finup based fast path to
dm-verity.  It is used automatically when appropriate.  This makes
dm-verity optimized for what the vast majority of users want: CPU-based
hashing with the most common settings, while still retaining support for
rarer settings and off-CPU crypto accelerators.

In benchmarks with veritysetup's default parameters (SHA-256, 4K data
and hash block sizes, 32-byte salt), which also match the parameters
that Android currently uses, this patch improves block hashing
performance by about 15% on x86_64 using the SHA-NI instructions, or by
about 5% on arm64 using the ARMv8 SHA2 instructions.  On x86_64 roughly
two-thirds of the improvement comes from the use of import and finup,
while the remaining third comes from the switch from ahash to shash.

Note that another benefit of using "import" to handle the salt is that
if the salt size is equal to the input size of the hash algorithm's
compression function, e.g. 64 bytes for SHA-256, then the performance is
exactly the same as no salt.  This doesn't seem to be much better than
veritysetup's current default of 32-byte salts, due to the way SHA-256's
finalization padding works, but it should be marginally better.

Reviewed-by: Sami Tolvanen <samitolvanen@google.com>
Acked-by: Ard Biesheuvel <ardb@kernel.org>
Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 drivers/md/dm-verity-target.c | 169 ++++++++++++++++++++++++----------
 drivers/md/dm-verity.h        |  18 ++--
 2 files changed, 130 insertions(+), 57 deletions(-)

diff --git a/drivers/md/dm-verity-target.c b/drivers/md/dm-verity-target.c
index 4aa140751166..d16c51958465 100644
--- a/drivers/md/dm-verity-target.c
+++ b/drivers/md/dm-verity-target.c
@@ -46,10 +46,13 @@ static unsigned int dm_verity_prefetch_cluster = DM_VERITY_DEFAULT_PREFETCH_SIZE
 
 module_param_named(prefetch_cluster, dm_verity_prefetch_cluster, uint, 0644);
 
 static DEFINE_STATIC_KEY_FALSE(use_bh_wq_enabled);
 
+/* Is at least one dm-verity instance using ahash_tfm instead of shash_tfm? */
+static DEFINE_STATIC_KEY_FALSE(ahash_enabled);
+
 struct dm_verity_prefetch_work {
 	struct work_struct work;
 	struct dm_verity *v;
 	unsigned short ioprio;
 	sector_t block;
@@ -100,11 +103,11 @@ static sector_t verity_position_at_level(struct dm_verity *v, sector_t block,
 					 int level)
 {
 	return block >> (level * v->hash_per_block_bits);
 }
 
-static int verity_hash_update(struct dm_verity *v, struct ahash_request *req,
+static int verity_ahash_update(struct dm_verity *v, struct ahash_request *req,
 				const u8 *data, size_t len,
 				struct crypto_wait *wait)
 {
 	struct scatterlist sg;
 
@@ -133,16 +136,16 @@ static int verity_hash_update(struct dm_verity *v, struct ahash_request *req,
 }
 
 /*
  * Wrapper for crypto_ahash_init, which handles verity salting.
  */
-static int verity_hash_init(struct dm_verity *v, struct ahash_request *req,
+static int verity_ahash_init(struct dm_verity *v, struct ahash_request *req,
 				struct crypto_wait *wait, bool may_sleep)
 {
 	int r;
 
-	ahash_request_set_tfm(req, v->tfm);
+	ahash_request_set_tfm(req, v->ahash_tfm);
 	ahash_request_set_callback(req,
 		may_sleep ? CRYPTO_TFM_REQ_MAY_SLEEP | CRYPTO_TFM_REQ_MAY_BACKLOG : 0,
 		crypto_req_done, (void *)wait);
 	crypto_init_wait(wait);
 
@@ -153,22 +156,22 @@ static int verity_hash_init(struct dm_verity *v, struct ahash_request *req,
 			DMERR("crypto_ahash_init failed: %d", r);
 		return r;
 	}
 
 	if (likely(v->salt_size && (v->version >= 1)))
-		r = verity_hash_update(v, req, v->salt, v->salt_size, wait);
+		r = verity_ahash_update(v, req, v->salt, v->salt_size, wait);
 
 	return r;
 }
 
-static int verity_hash_final(struct dm_verity *v, struct ahash_request *req,
-			     u8 *digest, struct crypto_wait *wait)
+static int verity_ahash_final(struct dm_verity *v, struct ahash_request *req,
+			      u8 *digest, struct crypto_wait *wait)
 {
 	int r;
 
 	if (unlikely(v->salt_size && (!v->version))) {
-		r = verity_hash_update(v, req, v->salt, v->salt_size, wait);
+		r = verity_ahash_update(v, req, v->salt, v->salt_size, wait);
 
 		if (r < 0) {
 			DMERR("%s failed updating salt: %d", __func__, r);
 			goto out;
 		}
@@ -181,25 +184,28 @@ static int verity_hash_final(struct dm_verity *v, struct ahash_request *req,
 }
 
 int verity_hash(struct dm_verity *v, struct dm_verity_io *io,
 		const u8 *data, size_t len, u8 *digest, bool may_sleep)
 {
-	struct ahash_request *req = verity_io_hash_req(v, io);
 	int r;
-	struct crypto_wait wait;
-
-	r = verity_hash_init(v, req, &wait, may_sleep);
-	if (unlikely(r < 0))
-		goto out;
 
-	r = verity_hash_update(v, req, data, len, &wait);
-	if (unlikely(r < 0))
-		goto out;
+	if (static_branch_unlikely(&ahash_enabled) && !v->shash_tfm) {
+		struct ahash_request *req = verity_io_hash_req(v, io);
+		struct crypto_wait wait;
 
-	r = verity_hash_final(v, req, digest, &wait);
+		r = verity_ahash_init(v, req, &wait, may_sleep) ?:
+		    verity_ahash_update(v, req, data, len, &wait) ?:
+		    verity_ahash_final(v, req, digest, &wait);
+	} else {
+		struct shash_desc *desc = verity_io_hash_req(v, io);
 
-out:
+		desc->tfm = v->shash_tfm;
+		r = crypto_shash_import(desc, v->initial_hashstate) ?:
+		    crypto_shash_finup(desc, data, len, digest);
+	}
+	if (unlikely(r))
+		DMERR("Error hashing block: %d", r);
 	return r;
 }
 
 static void verity_hash_at_level(struct dm_verity *v, sector_t block, int level,
 				 sector_t *hash_block, unsigned int *offset)
@@ -932,15 +938,20 @@ static void verity_dtr(struct dm_target *ti)
 	if (v->bufio)
 		dm_bufio_client_destroy(v->bufio);
 
 	kvfree(v->validated_blocks);
 	kfree(v->salt);
+	kfree(v->initial_hashstate);
 	kfree(v->root_digest);
 	kfree(v->zero_digest);
 
-	if (v->tfm)
-		crypto_free_ahash(v->tfm);
+	if (v->ahash_tfm) {
+		static_branch_dec(&ahash_enabled);
+		crypto_free_ahash(v->ahash_tfm);
+	} else {
+		crypto_free_shash(v->shash_tfm);
+	}
 
 	kfree(v->alg_name);
 
 	if (v->hash_dev)
 		dm_put_device(ti, v->hash_dev);
@@ -990,11 +1001,11 @@ static int verity_alloc_zero_digest(struct dm_verity *v)
 	v->zero_digest = kmalloc(v->digest_size, GFP_KERNEL);
 
 	if (!v->zero_digest)
 		return r;
 
-	io = kmalloc(sizeof(*io) + v->ahash_reqsize, GFP_KERNEL);
+	io = kmalloc(sizeof(*io) + v->hash_reqsize, GFP_KERNEL);
 
 	if (!io)
 		return r; /* verity_dtr will free zero_digest */
 
 	zero_data = kzalloc(1 << v->data_dev_block_bits, GFP_KERNEL);
@@ -1129,40 +1140,110 @@ static int verity_parse_opt_args(struct dm_arg_set *as, struct dm_verity *v,
 
 static int verity_setup_hash_alg(struct dm_verity *v, const char *alg_name)
 {
 	struct dm_target *ti = v->ti;
 	struct crypto_ahash *ahash;
+	struct crypto_shash *shash = NULL;
+	const char *driver_name;
 
 	v->alg_name = kstrdup(alg_name, GFP_KERNEL);
 	if (!v->alg_name) {
 		ti->error = "Cannot allocate algorithm name";
 		return -ENOMEM;
 	}
 
+	/*
+	 * Allocate the hash transformation object that this dm-verity instance
+	 * will use.  The vast majority of dm-verity users use CPU-based
+	 * hashing, so when possible use the shash API to minimize the crypto
+	 * API overhead.  If the ahash API resolves to a different driver
+	 * (likely an off-CPU hardware offload), use ahash instead.  Also use
+	 * ahash if the obsolete dm-verity format with the appended salt is
+	 * being used, so that quirk only needs to be handled in one place.
+	 */
 	ahash = crypto_alloc_ahash(alg_name, 0,
 				   v->use_bh_wq ? CRYPTO_ALG_ASYNC : 0);
 	if (IS_ERR(ahash)) {
 		ti->error = "Cannot initialize hash function";
 		return PTR_ERR(ahash);
 	}
-	v->tfm = ahash;
-
-	/*
-	 * dm-verity performance can vary greatly depending on which hash
-	 * algorithm implementation is used.  Help people debug performance
-	 * problems by logging the ->cra_driver_name.
-	 */
-	DMINFO("%s using implementation \"%s\"", alg_name,
-	       crypto_hash_alg_common(ahash)->base.cra_driver_name);
-
-	v->digest_size = crypto_ahash_digestsize(ahash);
+	driver_name = crypto_ahash_driver_name(ahash);
+	if (v->version >= 1 /* salt prepended, not appended? */) {
+		shash = crypto_alloc_shash(alg_name, 0, 0);
+		if (!IS_ERR(shash) &&
+		    strcmp(crypto_shash_driver_name(shash), driver_name) != 0) {
+			/*
+			 * ahash gave a different driver than shash, so probably
+			 * this is a case of real hardware offload.  Use ahash.
+			 */
+			crypto_free_shash(shash);
+			shash = NULL;
+		}
+	}
+	if (!IS_ERR_OR_NULL(shash)) {
+		crypto_free_ahash(ahash);
+		ahash = NULL;
+		v->shash_tfm = shash;
+		v->digest_size = crypto_shash_digestsize(shash);
+		v->hash_reqsize = sizeof(struct shash_desc) +
+				  crypto_shash_descsize(shash);
+		DMINFO("%s using shash \"%s\"", alg_name, driver_name);
+	} else {
+		v->ahash_tfm = ahash;
+		static_branch_inc(&ahash_enabled);
+		v->digest_size = crypto_ahash_digestsize(ahash);
+		v->hash_reqsize = sizeof(struct ahash_request) +
+				  crypto_ahash_reqsize(ahash);
+		DMINFO("%s using ahash \"%s\"", alg_name, driver_name);
+	}
 	if ((1 << v->hash_dev_block_bits) < v->digest_size * 2) {
 		ti->error = "Digest size too big";
 		return -EINVAL;
 	}
-	v->ahash_reqsize = sizeof(struct ahash_request) +
-			   crypto_ahash_reqsize(ahash);
+	return 0;
+}
+
+static int verity_setup_salt_and_hashstate(struct dm_verity *v, const char *arg)
+{
+	struct dm_target *ti = v->ti;
+
+	if (strcmp(arg, "-") != 0) {
+		v->salt_size = strlen(arg) / 2;
+		v->salt = kmalloc(v->salt_size, GFP_KERNEL);
+		if (!v->salt) {
+			ti->error = "Cannot allocate salt";
+			return -ENOMEM;
+		}
+		if (strlen(arg) != v->salt_size * 2 ||
+		    hex2bin(v->salt, arg, v->salt_size)) {
+			ti->error = "Invalid salt";
+			return -EINVAL;
+		}
+	}
+	if (v->shash_tfm) {
+		SHASH_DESC_ON_STACK(desc, v->shash_tfm);
+		int r;
+
+		/*
+		 * Compute the pre-salted hash state that can be passed to
+		 * crypto_shash_import() for each block later.
+		 */
+		v->initial_hashstate = kmalloc(
+			crypto_shash_statesize(v->shash_tfm), GFP_KERNEL);
+		if (!v->initial_hashstate) {
+			ti->error = "Cannot allocate initial hash state";
+			return -ENOMEM;
+		}
+		desc->tfm = v->shash_tfm;
+		r = crypto_shash_init(desc) ?:
+		    crypto_shash_update(desc, v->salt, v->salt_size) ?:
+		    crypto_shash_export(desc, v->initial_hashstate);
+		if (r) {
+			ti->error = "Cannot set up initial hash state";
+			return r;
+		}
+	}
 	return 0;
 }
 
 /*
  * Target parameters:
@@ -1304,25 +1385,13 @@ static int verity_ctr(struct dm_target *ti, unsigned int argc, char **argv)
 		r = -EINVAL;
 		goto bad;
 	}
 	root_hash_digest_to_validate = argv[8];
 
-	if (strcmp(argv[9], "-")) {
-		v->salt_size = strlen(argv[9]) / 2;
-		v->salt = kmalloc(v->salt_size, GFP_KERNEL);
-		if (!v->salt) {
-			ti->error = "Cannot allocate salt";
-			r = -ENOMEM;
-			goto bad;
-		}
-		if (strlen(argv[9]) != v->salt_size * 2 ||
-		    hex2bin(v->salt, argv[9], v->salt_size)) {
-			ti->error = "Invalid salt";
-			r = -EINVAL;
-			goto bad;
-		}
-	}
+	r = verity_setup_salt_and_hashstate(v, argv[9]);
+	if (r)
+		goto bad;
 
 	argv += 10;
 	argc -= 10;
 
 	/* Optional parameters */
@@ -1420,11 +1489,11 @@ static int verity_ctr(struct dm_target *ti, unsigned int argc, char **argv)
 		ti->error = "Cannot allocate workqueue";
 		r = -ENOMEM;
 		goto bad;
 	}
 
-	ti->per_io_data_size = sizeof(struct dm_verity_io) + v->ahash_reqsize;
+	ti->per_io_data_size = sizeof(struct dm_verity_io) + v->hash_reqsize;
 
 	r = verity_fec_ctr(v);
 	if (r)
 		goto bad;
 
diff --git a/drivers/md/dm-verity.h b/drivers/md/dm-verity.h
index 0e1dd02a916f..aac3a1b1d94a 100644
--- a/drivers/md/dm-verity.h
+++ b/drivers/md/dm-verity.h
@@ -37,13 +37,15 @@ struct dm_verity {
 	struct dm_dev *data_dev;
 	struct dm_dev *hash_dev;
 	struct dm_target *ti;
 	struct dm_bufio_client *bufio;
 	char *alg_name;
-	struct crypto_ahash *tfm;
+	struct crypto_ahash *ahash_tfm; /* either this or shash_tfm is set */
+	struct crypto_shash *shash_tfm; /* either this or ahash_tfm is set */
 	u8 *root_digest;	/* digest of the root block */
 	u8 *salt;		/* salt: its size is salt_size */
+	u8 *initial_hashstate;	/* salted initial state, if shash_tfm is set */
 	u8 *zero_digest;	/* digest for a zero block */
 	unsigned int salt_size;
 	sector_t data_start;	/* data offset in 512-byte sectors */
 	sector_t hash_start;	/* hash start in blocks */
 	sector_t data_blocks;	/* the number of data blocks */
@@ -54,11 +56,11 @@ struct dm_verity {
 	unsigned char levels;	/* the number of tree levels */
 	unsigned char version;
 	bool hash_failed:1;	/* set if hash of any block failed */
 	bool use_bh_wq:1;	/* try to verify in BH wq before normal work-queue */
 	unsigned int digest_size;	/* digest size for the current hash algorithm */
-	unsigned int ahash_reqsize;/* the size of temporary space for crypto */
+	unsigned int hash_reqsize; /* the size of temporary space for crypto */
 	enum verity_mode mode;	/* mode for handling verification errors */
 	unsigned int corrupted_errs;/* Number of errors for corrupted blocks */
 
 	struct workqueue_struct *verify_wq;
 
@@ -91,19 +93,21 @@ struct dm_verity_io {
 
 	u8 real_digest[HASH_MAX_DIGESTSIZE];
 	u8 want_digest[HASH_MAX_DIGESTSIZE];
 
 	/*
-	 * This struct is followed by a variable-sized struct ahash_request of
-	 * size v->ahash_reqsize.  To access it, use verity_io_hash_req().
+	 * This struct is followed by a variable-sized hash request of size
+	 * v->hash_reqsize, either a struct ahash_request or a struct shash_desc
+	 * (depending on whether ahash_tfm or shash_tfm is being used).  To
+	 * access it, use verity_io_hash_req().
 	 */
 };
 
-static inline struct ahash_request *verity_io_hash_req(struct dm_verity *v,
-						     struct dm_verity_io *io)
+static inline void *verity_io_hash_req(struct dm_verity *v,
+				       struct dm_verity_io *io)
 {
-	return (struct ahash_request *)(io + 1);
+	return io + 1;
 }
 
 static inline u8 *verity_io_real_digest(struct dm_verity *v,
 					struct dm_verity_io *io)
 {
-- 
2.45.2


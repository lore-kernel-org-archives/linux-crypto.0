Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B113A175554;
	Fri, 21 Jun 2024 17:00:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718989223; cv=none; b=eX+TvmVaXcwk9FdwYJDjtHDi0pdAJlFU9z+4FQcduz/yqFDFGQGgTNX3RwBjh5f6k7L2K90dZtH6Lq5K4upmRsKzme4W8e9yvDr4flyo/GgmwGAT+dMI+tRFvRoUGeocdN1vT36lTcI5cIQYREWCVGUFOHauIMSkn/66BSRIiPk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718989223; c=relaxed/simple;
	bh=fNLe52TPOxjgLpo59slUZdXGoIEJCK+i4EGVq9NPfPk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TXMHtMAiXYY46qt0XTFF3PJy1IgSawpQyknRZQvjN3SpPmIfKGP+Cg239+380GwTtiEBN3UBFawv1Y8vOkguvW7SJMyL53jjnCJQynIEh8cWA/BKSntgAY2fLGrvrtj1T+oQ7oz6xZsjwhCKoBhe5736QOyB0CJpjdbiqkAojtI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=i2d5eAYN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="i2d5eAYN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3CBA2C4AF08;
	Fri, 21 Jun 2024 17:00:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1718989223;
	bh=fNLe52TPOxjgLpo59slUZdXGoIEJCK+i4EGVq9NPfPk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=i2d5eAYNbel8tNFaas0Y2Zbntn3EsMrJFceSmw8a+H/FjQZo8soMdzNBqFL7ITnsI
	 QtbzcJMq9G2hFe4d/DBjWDvypthFeyDQAxWdpjlTLCwer35MFy7vFk0aoXrs/gNMlr
	 sxKVV7PoILNJV5kx3ZRphMuLayzZptgF2ZLvRj8Su3Ch8d239rUyR19NFMYxbhmloS
	 l0Jw8LWf6aXBAqSPowrlGo/m8sMdVk3MksDfgAdYdEbZulKCN7WGq+wOLfJqokArVe
	 HE/V59d+lXfN/cNr9cfvriHVeiIspLlkBbBdadbBcaMA0uuE4fiVVE3LRFzBxnRs2R
	 tdfh+UGfARpDw==
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
Subject: [PATCH v6 15/15] dm-verity: improve performance by using multibuffer hashing
Date: Fri, 21 Jun 2024 09:59:22 -0700
Message-ID: <20240621165922.77672-16-ebiggers@kernel.org>
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

When supported by the hash algorithm, use crypto_shash_finup_mb() to
interleave the hashing of pairs of data blocks.  On some CPUs this
nearly doubles hashing performance.  The increase in overall throughput
of cold-cache dm-verity reads that I'm seeing on arm64 and x86_64 is
roughly 35% (though this metric is hard to measure as it jumps around a
lot).

For now this is only done on data blocks, not Merkle tree blocks.  We
could use finup_mb on Merkle tree blocks too, but that is less important
as there aren't as many Merkle tree blocks as data blocks, and that
would require some additional code restructuring.

Reviewed-by: Sami Tolvanen <samitolvanen@google.com>
Acked-by: Ard Biesheuvel <ardb@kernel.org>
Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 drivers/md/dm-verity-target.c | 166 ++++++++++++++++++++++++++--------
 drivers/md/dm-verity.h        |  33 ++++---
 2 files changed, 147 insertions(+), 52 deletions(-)

diff --git a/drivers/md/dm-verity-target.c b/drivers/md/dm-verity-target.c
index 1f23354256d3..ff91bfa40302 100644
--- a/drivers/md/dm-verity-target.c
+++ b/drivers/md/dm-verity-target.c
@@ -181,22 +181,28 @@ static int verity_ahash_final(struct dm_verity *v, struct ahash_request *req,
 	r = crypto_wait_req(crypto_ahash_final(req), wait);
 out:
 	return r;
 }
 
+static int verity_ahash(struct dm_verity *v, struct dm_verity_io *io,
+			const u8 *data, size_t len, u8 *digest, bool may_sleep)
+{
+	struct ahash_request *req = verity_io_hash_req(v, io);
+	struct crypto_wait wait;
+
+	return verity_ahash_init(v, req, &wait, may_sleep) ?:
+	       verity_ahash_update(v, req, data, len, &wait) ?:
+	       verity_ahash_final(v, req, digest, &wait);
+}
+
 int verity_hash(struct dm_verity *v, struct dm_verity_io *io,
 		const u8 *data, size_t len, u8 *digest, bool may_sleep)
 {
 	int r;
 
 	if (static_branch_unlikely(&ahash_enabled) && !v->shash_tfm) {
-		struct ahash_request *req = verity_io_hash_req(v, io);
-		struct crypto_wait wait;
-
-		r = verity_ahash_init(v, req, &wait, may_sleep) ?:
-		    verity_ahash_update(v, req, data, len, &wait) ?:
-		    verity_ahash_final(v, req, digest, &wait);
+		r = verity_ahash(v, io, data, len, digest, may_sleep);
 	} else {
 		struct shash_desc *desc = verity_io_hash_req(v, io);
 
 		desc->tfm = v->shash_tfm;
 		r = crypto_shash_import(desc, v->initial_hashstate) ?:
@@ -205,10 +211,38 @@ int verity_hash(struct dm_verity *v, struct dm_verity_io *io,
 	if (unlikely(r))
 		DMERR("Error hashing block: %d", r);
 	return r;
 }
 
+static int verity_hash_mb(struct dm_verity *v, struct dm_verity_io *io,
+			  const u8 *data[], size_t len, u8 *digests[],
+			  int num_blocks)
+{
+	int r = 0;
+
+	if (static_branch_unlikely(&ahash_enabled) && !v->shash_tfm) {
+		int i;
+
+		/* Note: in practice num_blocks is always 1 in this case. */
+		for (i = 0; i < num_blocks; i++) {
+			r = verity_ahash(v, io, data[i], len, digests[i],
+					 !io->in_bh);
+			if (r)
+				break;
+		}
+	} else {
+		struct shash_desc *desc = verity_io_hash_req(v, io);
+
+		desc->tfm = v->shash_tfm;
+		r = crypto_shash_import(desc, v->initial_hashstate) ?:
+		    crypto_shash_finup_mb(desc, data, len, digests, num_blocks);
+	}
+	if (unlikely(r))
+		DMERR("Error hashing blocks: %d", r);
+	return r;
+}
+
 static void verity_hash_at_level(struct dm_verity *v, sector_t block, int level,
 				 sector_t *hash_block, unsigned int *offset)
 {
 	sector_t position = verity_position_at_level(v, block, level);
 	unsigned int idx;
@@ -454,13 +488,16 @@ static noinline int verity_recheck(struct dm_verity *v, struct dm_verity_io *io,
 }
 
 static int verity_handle_data_hash_mismatch(struct dm_verity *v,
 					    struct dm_verity_io *io,
 					    struct bio *bio,
-					    const u8 *want_digest,
-					    sector_t blkno, u8 *data)
+					    struct pending_block *block)
 {
+	const u8 *want_digest = block->want_digest;
+	sector_t blkno = block->blkno;
+	u8 *data = block->data;
+
 	if (static_branch_unlikely(&use_bh_wq_enabled) && io->in_bh) {
 		/*
 		 * Error handling code (FEC included) cannot be run in the
 		 * BH workqueue, so fallback to a standard workqueue.
 		 */
@@ -484,10 +521,57 @@ static int verity_handle_data_hash_mismatch(struct dm_verity *v,
 		return -EIO;
 	}
 	return 0;
 }
 
+static void verity_clear_pending_blocks(struct dm_verity_io *io)
+{
+	int i;
+
+	for (i = io->num_pending - 1; i >= 0; i--) {
+		kunmap_local(io->pending_blocks[i].data);
+		io->pending_blocks[i].data = NULL;
+	}
+	io->num_pending = 0;
+}
+
+static int verity_verify_pending_blocks(struct dm_verity *v,
+					struct dm_verity_io *io,
+					struct bio *bio)
+{
+	const u8 *data[DM_VERITY_MAX_PENDING_DATA_BLOCKS];
+	u8 *real_digests[DM_VERITY_MAX_PENDING_DATA_BLOCKS];
+	int i;
+	int r;
+
+	for (i = 0; i < io->num_pending; i++) {
+		data[i] = io->pending_blocks[i].data;
+		real_digests[i] = io->pending_blocks[i].real_digest;
+	}
+
+	r = verity_hash_mb(v, io, data, 1 << v->data_dev_block_bits,
+			   real_digests, io->num_pending);
+	if (unlikely(r))
+		return r;
+
+	for (i = 0; i < io->num_pending; i++) {
+		struct pending_block *block = &io->pending_blocks[i];
+
+		if (likely(memcmp(block->real_digest, block->want_digest,
+				  v->digest_size) == 0)) {
+			if (v->validated_blocks)
+				set_bit(block->blkno, v->validated_blocks);
+		} else {
+			r = verity_handle_data_hash_mismatch(v, io, bio, block);
+			if (unlikely(r))
+				return r;
+		}
+	}
+	verity_clear_pending_blocks(io);
+	return 0;
+}
+
 /*
  * Verify one "dm_verity_io" structure.
  */
 static int verity_verify_io(struct dm_verity_io *io)
 {
@@ -495,10 +579,13 @@ static int verity_verify_io(struct dm_verity_io *io)
 	const unsigned int block_size = 1 << v->data_dev_block_bits;
 	struct bvec_iter iter_copy;
 	struct bvec_iter *iter;
 	struct bio *bio = dm_bio_from_per_bio_data(io, v->ti->per_io_data_size);
 	unsigned int b;
+	int r;
+
+	io->num_pending = 0;
 
 	if (static_branch_unlikely(&use_bh_wq_enabled) && io->in_bh) {
 		/*
 		 * Copy the iterator in case we need to restart
 		 * verification in a work-queue.
@@ -508,36 +595,38 @@ static int verity_verify_io(struct dm_verity_io *io)
 	} else
 		iter = &io->iter;
 
 	for (b = 0; b < io->n_blocks;
 	     b++, bio_advance_iter(bio, iter, block_size)) {
-		int r;
-		sector_t cur_block = io->block + b;
+		sector_t blkno = io->block + b;
+		struct pending_block *block;
 		bool is_zero;
 		struct bio_vec bv;
 		void *data;
 
 		if (v->validated_blocks && bio->bi_status == BLK_STS_OK &&
-		    likely(test_bit(cur_block, v->validated_blocks)))
+		    likely(test_bit(blkno, v->validated_blocks)))
 			continue;
 
-		r = verity_hash_for_block(v, io, cur_block,
-					  verity_io_want_digest(v, io),
+		block = &io->pending_blocks[io->num_pending];
+
+		r = verity_hash_for_block(v, io, blkno, block->want_digest,
 					  &is_zero);
 		if (unlikely(r < 0))
-			return r;
+			goto error;
 
 		bv = bio_iter_iovec(bio, *iter);
 		if (unlikely(bv.bv_len < block_size)) {
 			/*
 			 * Data block spans pages.  This should not happen,
 			 * since dm-verity sets dma_alignment to the data block
 			 * size minus 1, and dm-verity also doesn't allow the
 			 * data block size to be greater than PAGE_SIZE.
 			 */
 			DMERR_LIMIT("unaligned io (data block spans pages)");
-			return -EIO;
+			r = -EIO;
+			goto error;
 		}
 
 		data = bvec_kmap_local(&bv);
 
 		if (is_zero) {
@@ -547,34 +636,30 @@ static int verity_verify_io(struct dm_verity_io *io)
 			 */
 			memset(data, 0, block_size);
 			kunmap_local(data);
 			continue;
 		}
-
-		r = verity_hash(v, io, data, block_size,
-				verity_io_real_digest(v, io), !io->in_bh);
-		if (unlikely(r < 0)) {
-			kunmap_local(data);
-			return r;
+		block->data = data;
+		block->blkno = blkno;
+		if (++io->num_pending == v->mb_max_msgs) {
+			r = verity_verify_pending_blocks(v, io, bio);
+			if (unlikely(r))
+				goto error;
 		}
+	}
 
-		if (likely(memcmp(verity_io_real_digest(v, io),
-				  verity_io_want_digest(v, io), v->digest_size) == 0)) {
-			if (v->validated_blocks)
-				set_bit(cur_block, v->validated_blocks);
-			kunmap_local(data);
-			continue;
-		}
-		r = verity_handle_data_hash_mismatch(v, io, bio,
-						     verity_io_want_digest(v, io),
-						     cur_block, data);
-		kunmap_local(data);
+	if (io->num_pending) {
+		r = verity_verify_pending_blocks(v, io, bio);
 		if (unlikely(r))
-			return r;
+			goto error;
 	}
 
 	return 0;
+
+error:
+	verity_clear_pending_blocks(io);
+	return r;
 }
 
 /*
  * Skip verity work in response to I/O error when system is shutting down.
  */
@@ -1155,14 +1240,15 @@ static int verity_setup_hash_alg(struct dm_verity *v, const char *alg_name)
 
 	/*
 	 * Allocate the hash transformation object that this dm-verity instance
 	 * will use.  The vast majority of dm-verity users use CPU-based
 	 * hashing, so when possible use the shash API to minimize the crypto
-	 * API overhead.  If the ahash API resolves to a different driver
-	 * (likely an off-CPU hardware offload), use ahash instead.  Also use
-	 * ahash if the obsolete dm-verity format with the appended salt is
-	 * being used, so that quirk only needs to be handled in one place.
+	 * API overhead, especially when multibuffer hashing is used.  If the
+	 * ahash API resolves to a different driver (likely an off-CPU hardware
+	 * offload), use ahash instead.  Also use ahash if the obsolete
+	 * dm-verity format with the appended salt is being used, so that quirk
+	 * only needs to be handled in one place.
 	 */
 	ahash = crypto_alloc_ahash(alg_name, 0,
 				   v->use_bh_wq ? CRYPTO_ALG_ASYNC : 0);
 	if (IS_ERR(ahash)) {
 		ti->error = "Cannot initialize hash function";
@@ -1186,17 +1272,21 @@ static int verity_setup_hash_alg(struct dm_verity *v, const char *alg_name)
 		ahash = NULL;
 		v->shash_tfm = shash;
 		v->digest_size = crypto_shash_digestsize(shash);
 		v->hash_reqsize = sizeof(struct shash_desc) +
 				  crypto_shash_descsize(shash);
-		DMINFO("%s using shash \"%s\"", alg_name, driver_name);
+		v->mb_max_msgs = min(crypto_shash_mb_max_msgs(shash),
+				     DM_VERITY_MAX_PENDING_DATA_BLOCKS);
+		DMINFO("%s using shash \"%s\"%s", alg_name, driver_name,
+		       v->mb_max_msgs > 1 ? " (multibuffer)" : "");
 	} else {
 		v->ahash_tfm = ahash;
 		static_branch_inc(&ahash_enabled);
 		v->digest_size = crypto_ahash_digestsize(ahash);
 		v->hash_reqsize = sizeof(struct ahash_request) +
 				  crypto_ahash_reqsize(ahash);
+		v->mb_max_msgs = 1;
 		DMINFO("%s using ahash \"%s\"", alg_name, driver_name);
 	}
 	if ((1 << v->hash_dev_block_bits) < v->digest_size * 2) {
 		ti->error = "Digest size too big";
 		return -EINVAL;
diff --git a/drivers/md/dm-verity.h b/drivers/md/dm-verity.h
index 3951e5a4a156..85f4f40f3645 100644
--- a/drivers/md/dm-verity.h
+++ b/drivers/md/dm-verity.h
@@ -55,10 +55,11 @@ struct dm_verity {
 	unsigned char hash_per_block_bits;	/* log2(hashes in hash block) */
 	unsigned char levels;	/* the number of tree levels */
 	unsigned char version;
 	bool hash_failed:1;	/* set if hash of any block failed */
 	bool use_bh_wq:1;	/* try to verify in BH wq before normal work-queue */
+	unsigned char mb_max_msgs; /* max multibuffer hashing interleaving factor */
 	unsigned int digest_size;	/* digest size for the current hash algorithm */
 	unsigned int hash_reqsize; /* the size of temporary space for crypto */
 	enum verity_mode mode;	/* mode for handling verification errors */
 	unsigned int corrupted_errs;/* Number of errors for corrupted blocks */
 
@@ -74,10 +75,19 @@ struct dm_verity {
 
 	struct dm_io_client *io;
 	mempool_t recheck_pool;
 };
 
+#define DM_VERITY_MAX_PENDING_DATA_BLOCKS	HASH_MAX_MB_MSGS
+
+struct pending_block {
+	void *data;
+	sector_t blkno;
+	u8 want_digest[HASH_MAX_DIGESTSIZE];
+	u8 real_digest[HASH_MAX_DIGESTSIZE];
+};
+
 struct dm_verity_io {
 	struct dm_verity *v;
 
 	/* original value of bio->bi_end_io */
 	bio_end_io_t *orig_bi_end_io;
@@ -90,12 +100,19 @@ struct dm_verity_io {
 
 	struct work_struct work;
 	struct work_struct bh_work;
 
 	u8 tmp_digest[HASH_MAX_DIGESTSIZE];
-	u8 real_digest[HASH_MAX_DIGESTSIZE];
-	u8 want_digest[HASH_MAX_DIGESTSIZE];
+
+	/*
+	 * This is the queue of data blocks that are pending verification.  We
+	 * allow multiple blocks to be queued up in order to support multibuffer
+	 * hashing, i.e. interleaving the hashing of multiple messages.  On many
+	 * CPUs this improves performance significantly.
+	 */
+	int num_pending;
+	struct pending_block pending_blocks[DM_VERITY_MAX_PENDING_DATA_BLOCKS];
 
 	/*
 	 * This struct is followed by a variable-sized hash request of size
 	 * v->hash_reqsize, either a struct ahash_request or a struct shash_desc
 	 * (depending on whether ahash_tfm or shash_tfm is being used).  To
@@ -107,22 +124,10 @@ static inline void *verity_io_hash_req(struct dm_verity *v,
 				       struct dm_verity_io *io)
 {
 	return io + 1;
 }
 
-static inline u8 *verity_io_real_digest(struct dm_verity *v,
-					struct dm_verity_io *io)
-{
-	return io->real_digest;
-}
-
-static inline u8 *verity_io_want_digest(struct dm_verity *v,
-					struct dm_verity_io *io)
-{
-	return io->want_digest;
-}
-
 extern int verity_hash(struct dm_verity *v, struct dm_verity_io *io,
 		       const u8 *data, size_t len, u8 *digest, bool may_sleep);
 
 extern int verity_hash_for_block(struct dm_verity *v, struct dm_verity_io *io,
 				 sector_t block, u8 *digest, bool *is_zero);
-- 
2.45.2


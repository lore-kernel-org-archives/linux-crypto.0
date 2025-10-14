Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B18230CD9D;
	Tue, 14 Oct 2025 21:17:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760476628; cv=none; b=UG0VKIh5tdqn1KZ5DCj/aWkaab5L+8iF8j9nk9ljodJJ49cOQMPSXn3iMkl+cEFJyX9hfdq174ypg+rpakLhvkVitIruYWZc9MG1ohkdpevzKEB4AYU6HZbRwQPrlmCss1VmsBbIuaolDnTrytd0tzQCc0GYpWd9su09w/PbdxM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760476628; c=relaxed/simple;
	bh=AsD+K6Tz1SNkUsB2bzSk83Agm6cOe/4T3mebAUB300E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GKS+AQuHkyauLO0gWRXsL3yDebIcDFyFHr202HKuyyjcnzBvCpNRuHUfCq1XQjAV1npWhSs1B0ZQNwM0sOBhf+hfSuCHD0/R/nFkDyLlL6XiEzrYTgN4h81sPlEcBJU+MkmSrWaZcT3In6gaXgKU4MsXW2711OmbZ+q4dTKcNoY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ZIGHXHfV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ZIGHXHfV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E4465C19422;
	Tue, 14 Oct 2025 21:17:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1760476628;
	bh=AsD+K6Tz1SNkUsB2bzSk83Agm6cOe/4T3mebAUB300E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZIGHXHfVIC4tj4hvBV1PRedK7h3SH6aBBEg/KYZ1cQNDCYg+Lgr7pMfTyHCj30Jny
	 8xdCjCxNYQNy6XY8PRY/26dAgAqR62RZhnrWvuY04wjx6zEsGcftxuqbKSa9DQ/dKT
	 w8yfmFW0mgefbRvvVxba20XgnRwAIUjV03EEg9a6XT4TEpRyFB5I4yY+utmVZwYBVJ
	 EKU+KCEIcHrlEmuIJagUGC3HGpyWi1YC8GqZs4g6PRTsODK/kFBS7IQJBiL7+C5vUy
	 tcYo9RNFUZ5qECi8oVQUcVNVOmRRcKHsytksoqAMjF6AYsWW20vmpEh3SL54prhdET
	 BExLsxeGzYoiQ==
From: Eric Biggers <ebiggers@kernel.org>
To: dm-devel@lists.linux.dev,
	Alasdair Kergon <agk@redhat.com>,
	Mike Snitzer <snitzer@kernel.org>,
	Mikulas Patocka <mpatocka@redhat.com>
Cc: linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Eric Biggers <ebiggers@kernel.org>
Subject: [PATCH 4/4] dm-verity: use 2-way interleaved SHA-256 hashing when supported
Date: Tue, 14 Oct 2025 14:16:57 -0700
Message-ID: <20251014211657.113603-5-ebiggers@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251014211657.113603-1-ebiggers@kernel.org>
References: <20251014211657.113603-1-ebiggers@kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

When the crypto library provides an optimized implementation of
sha256_finup_2x(), use it to interleave the hashing of pairs of data
blocks.  On some CPUs this nearly doubles hashing performance.  The
increase in overall throughput of cold-cache dm-verity reads that I'm
seeing on arm64 and x86_64 is roughly 35% (though this metric is hard to
measure as it jumps around a lot).

For now this is done only on data blocks, not Merkle tree blocks.  We
could use sha256_finup_2x() on Merkle tree blocks too, but that is less
important as there aren't as many Merkle tree blocks as data blocks, and
that would require some additional code restructuring.

Signed-off-by: Eric Biggers <ebiggers@kernel.org>
---
 drivers/md/dm-verity-target.c | 113 ++++++++++++++++++++++++++--------
 drivers/md/dm-verity.h        |  31 +++++-----
 2 files changed, 103 insertions(+), 41 deletions(-)

diff --git a/drivers/md/dm-verity-target.c b/drivers/md/dm-verity-target.c
index af9f1544af3ea..bf0aee73b074c 100644
--- a/drivers/md/dm-verity-target.c
+++ b/drivers/md/dm-verity-target.c
@@ -415,13 +415,16 @@ static noinline int verity_recheck(struct dm_verity *v, struct dm_verity_io *io,
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
@@ -446,21 +449,77 @@ static int verity_handle_data_hash_mismatch(struct dm_verity *v,
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
+	const unsigned int block_size = 1 << v->data_dev_block_bits;
+	int i, r;
+
+	if (io->num_pending == 2) {
+		/* num_pending == 2 implies that the algorithm is SHA-256 */
+		sha256_finup_2x(v->initial_hashstate.sha256,
+				io->pending_blocks[0].data,
+				io->pending_blocks[1].data, block_size,
+				io->pending_blocks[0].real_digest,
+				io->pending_blocks[1].real_digest);
+	} else {
+		for (i = 0; i < io->num_pending; i++) {
+			r = verity_hash(v, io, io->pending_blocks[i].data,
+					block_size,
+					io->pending_blocks[i].real_digest);
+			if (unlikely(r))
+				return r;
+		}
+	}
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
 	struct dm_verity *v = io->v;
 	const unsigned int block_size = 1 << v->data_dev_block_bits;
+	const int max_pending = v->use_sha256_finup_2x ? 2 : 1;
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
@@ -470,36 +529,38 @@ static int verity_verify_io(struct dm_verity_io *io)
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
@@ -509,34 +570,30 @@ static int verity_verify_io(struct dm_verity_io *io)
 			 */
 			memset(data, 0, block_size);
 			kunmap_local(data);
 			continue;
 		}
-
-		r = verity_hash(v, io, data, block_size,
-				verity_io_real_digest(v, io));
-		if (unlikely(r < 0)) {
-			kunmap_local(data);
-			return r;
+		block->data = data;
+		block->blkno = blkno;
+		if (++io->num_pending == max_pending) {
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
@@ -1275,10 +1332,12 @@ static int verity_setup_hash_alg(struct dm_verity *v, const char *alg_name)
 		/*
 		 * Fast path: use the library API for reduced overhead and
 		 * interleaved hashing support.
 		 */
 		v->use_sha256_lib = true;
+		if (sha256_finup_2x_is_optimized())
+			v->use_sha256_finup_2x = true;
 		ti->per_io_data_size =
 			offsetofend(struct dm_verity_io, hash_ctx.sha256);
 	} else {
 		/* Fallback case: use the generic crypto API. */
 		ti->per_io_data_size =
diff --git a/drivers/md/dm-verity.h b/drivers/md/dm-verity.h
index cf7973ed30596..f975a9e5c5d6b 100644
--- a/drivers/md/dm-verity.h
+++ b/drivers/md/dm-verity.h
@@ -62,10 +62,11 @@ struct dm_verity {
 	unsigned char levels;	/* the number of tree levels */
 	unsigned char version;
 	bool hash_failed:1;	/* set if hash of any block failed */
 	bool use_bh_wq:1;	/* try to verify in BH wq before normal work-queue */
 	bool use_sha256_lib:1;	/* use SHA-256 library instead of generic crypto API */
+	bool use_sha256_finup_2x:1; /* use interleaved hashing optimization */
 	unsigned int digest_size;	/* digest size for the current hash algorithm */
 	enum verity_mode mode;	/* mode for handling verification errors */
 	enum verity_mode error_mode;/* mode for handling I/O errors */
 	unsigned int corrupted_errs;/* Number of errors for corrupted blocks */
 
@@ -81,10 +82,17 @@ struct dm_verity {
 
 	struct dm_io_client *io;
 	mempool_t recheck_pool;
 };
 
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
@@ -98,12 +106,19 @@ struct dm_verity_io {
 
 	struct work_struct work;
 	struct work_struct bh_work;
 
 	u8 tmp_digest[HASH_MAX_DIGESTSIZE];
-	u8 real_digest[HASH_MAX_DIGESTSIZE];
-	u8 want_digest[HASH_MAX_DIGESTSIZE];
+
+	/*
+	 * This is the queue of data blocks that are pending verification.  When
+	 * the crypto layer supports interleaved hashing, we allow multiple
+	 * blocks to be queued up in order to utilize it.  This can improve
+	 * performance significantly vs. sequential hashing of each block.
+	 */
+	int num_pending;
+	struct pending_block pending_blocks[2];
 
 	/*
 	 * Temporary space for hashing.  Either sha256 or shash is used,
 	 * depending on the value of use_sha256_lib.  If shash is used,
 	 * then this field is variable-length, with total size
@@ -114,22 +129,10 @@ struct dm_verity_io {
 		struct sha256_ctx sha256;
 		struct shash_desc shash;
 	} hash_ctx;
 };
 
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
 		       const u8 *data, size_t len, u8 *digest);
 
 extern int verity_hash_for_block(struct dm_verity *v, struct dm_verity_io *io,
 				 sector_t block, u8 *digest, bool *is_zero);
-- 
2.51.0


Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 69F514C90;
	Tue,  7 May 2024 00:25:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715041519; cv=none; b=mzPVUVUK+QVT5yvjAX96vy4Qq457XmGy2dDEwHK0qCSbrnGlfnUY+R7oCYZ8xyZU4V6Nrm0Dj5OGRJAdUc1VEGlYYMrwVd4PpZtttYuy0n9TncG5+Vx1AS2uDG34Gz84+1/uKFRgQKV7fm18PPbMcmEruMi9jUMABXJxntPsqlU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715041519; c=relaxed/simple;
	bh=ggpP8ELjDjuehtJRJqVh1Cgwh7DRdNe18MMGOo6UHag=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hS5eDSdUSE0xZa1k8fy7ny0Blssgf1ISS4QdSBTIVCf7MS14xrNMUIokPG5QKSN0F+PDO5R0otbS+r3vDVbTWvCReJt455Z/eewI7s0tT8F3wrhKtHM9lvwlfEdBUJuUmtQZN2P+dWJuS+z3j8qOr3SVyrwKRiiUYCThzDM7Rc8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ABeR4caK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ABeR4caK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CA0BCC3277B;
	Tue,  7 May 2024 00:25:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1715041519;
	bh=ggpP8ELjDjuehtJRJqVh1Cgwh7DRdNe18MMGOo6UHag=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ABeR4caKI8c3bQ6W26j2RIhsguQaSO7jNQXAZPRseYuCyE7mlMNGrJ/Wcd2np3Bua
	 zwWTiXePgx/SBmpywuUMbtHtLs9te3orikJ31qD8rhfVU62LtmGidhX2tCD5S3vIS1
	 HkaUwZm3HJIbmoKs6v9iTXLx55E218GnP88se/uxFh4InhZE4lDNuluRbUVqfD07rX
	 sC0W/rsJHZ35oiJicOvWwd2LKO0Lcah/6YrDhHx257EEY2EtVRNvrOBtN21OyZVKZa
	 r6KR2wTHvrYSdm0XH4uVech2YZBKiVxczzGQ/BfvKW9sP+DbnhqKNugpY5i13Mmq9h
	 ECVz5UWsxoghw==
From: Eric Biggers <ebiggers@kernel.org>
To: linux-crypto@vger.kernel.org,
	fsverity@lists.linux.dev,
	dm-devel@lists.linux.dev
Cc: x86@kernel.org,
	linux-arm-kernel@lists.infradead.org,
	Ard Biesheuvel <ardb@kernel.org>,
	Sami Tolvanen <samitolvanen@google.com>,
	Bart Van Assche <bvanassche@acm.org>
Subject: [PATCH v3 8/8] dm-verity: improve performance by using multibuffer hashing
Date: Mon,  6 May 2024 17:23:43 -0700
Message-ID: <20240507002343.239552-9-ebiggers@kernel.org>
X-Mailer: git-send-email 2.45.0
In-Reply-To: <20240507002343.239552-1-ebiggers@kernel.org>
References: <20240507002343.239552-1-ebiggers@kernel.org>
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

Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 drivers/md/dm-verity-fec.c    |  24 +--
 drivers/md/dm-verity-fec.h    |   7 +-
 drivers/md/dm-verity-target.c | 363 +++++++++++++++++++++++-----------
 drivers/md/dm-verity.h        |  28 +--
 4 files changed, 264 insertions(+), 158 deletions(-)

diff --git a/drivers/md/dm-verity-fec.c b/drivers/md/dm-verity-fec.c
index b436b8e4d750..c1677137a682 100644
--- a/drivers/md/dm-verity-fec.c
+++ b/drivers/md/dm-verity-fec.c
@@ -184,18 +184,18 @@ static int fec_decode_bufs(struct dm_verity *v, struct dm_verity_io *io,
  * Locate data block erasures using verity hashes.
  */
 static int fec_is_erasure(struct dm_verity *v, struct dm_verity_io *io,
 			  u8 *want_digest, u8 *data)
 {
+	u8 real_digest[HASH_MAX_DIGESTSIZE];
+
 	if (unlikely(verity_compute_hash_virt(v, io, data,
 					      1 << v->data_dev_block_bits,
-					      verity_io_real_digest(v, io),
-					      true)))
+					      real_digest, true)))
 		return 0;
 
-	return memcmp(verity_io_real_digest(v, io), want_digest,
-		      v->digest_size) != 0;
+	return memcmp(real_digest, want_digest, v->digest_size) != 0;
 }
 
 /*
  * Read data blocks that are part of the RS block and deinterleave as much as
  * fits into buffers. Check for erasure locations if @neras is non-NULL.
@@ -362,14 +362,15 @@ static void fec_init_bufs(struct dm_verity *v, struct dm_verity_fec_io *fio)
  * (indicated by @offset) in fio->output. If @use_erasures is non-zero, uses
  * hashes to locate erasures.
  */
 static int fec_decode_rsb(struct dm_verity *v, struct dm_verity_io *io,
 			  struct dm_verity_fec_io *fio, u64 rsb, u64 offset,
-			  bool use_erasures)
+			  const u8 *want_digest, bool use_erasures)
 {
 	int r, neras = 0;
 	unsigned int pos;
+	u8 real_digest[HASH_MAX_DIGESTSIZE];
 
 	r = fec_alloc_bufs(v, fio);
 	if (unlikely(r < 0))
 		return r;
 
@@ -389,16 +390,15 @@ static int fec_decode_rsb(struct dm_verity *v, struct dm_verity_io *io,
 	}
 
 	/* Always re-validate the corrected block against the expected hash */
 	r = verity_compute_hash_virt(v, io, fio->output,
 				     1 << v->data_dev_block_bits,
-				     verity_io_real_digest(v, io), true);
+				     real_digest, true);
 	if (unlikely(r < 0))
 		return r;
 
-	if (memcmp(verity_io_real_digest(v, io), verity_io_want_digest(v, io),
-		   v->digest_size)) {
+	if (memcmp(real_digest, want_digest, v->digest_size)) {
 		DMERR_LIMIT("%s: FEC %llu: failed to correct (%d erasures)",
 			    v->data_dev->name, (unsigned long long)rsb, neras);
 		return -EILSEQ;
 	}
 
@@ -419,12 +419,12 @@ static int fec_bv_copy(struct dm_verity *v, struct dm_verity_io *io, u8 *data,
 /*
  * Correct errors in a block. Copies corrected block to dest if non-NULL,
  * otherwise to a bio_vec starting from iter.
  */
 int verity_fec_decode(struct dm_verity *v, struct dm_verity_io *io,
-		      enum verity_block_type type, sector_t block, u8 *dest,
-		      struct bvec_iter *iter)
+		      enum verity_block_type type, sector_t block,
+		      const u8 *want_digest, u8 *dest, struct bvec_iter *iter)
 {
 	int r;
 	struct dm_verity_fec_io *fio = fec_io(io);
 	u64 offset, res, rsb;
 
@@ -463,13 +463,13 @@ int verity_fec_decode(struct dm_verity *v, struct dm_verity_io *io,
 	/*
 	 * Locating erasures is slow, so attempt to recover the block without
 	 * them first. Do a second attempt with erasures if the corruption is
 	 * bad enough.
 	 */
-	r = fec_decode_rsb(v, io, fio, rsb, offset, false);
+	r = fec_decode_rsb(v, io, fio, rsb, offset, want_digest, false);
 	if (r < 0) {
-		r = fec_decode_rsb(v, io, fio, rsb, offset, true);
+		r = fec_decode_rsb(v, io, fio, rsb, offset, want_digest, true);
 		if (r < 0)
 			goto done;
 	}
 
 	if (dest)
diff --git a/drivers/md/dm-verity-fec.h b/drivers/md/dm-verity-fec.h
index 8454070d2824..57c3f674cae9 100644
--- a/drivers/md/dm-verity-fec.h
+++ b/drivers/md/dm-verity-fec.h
@@ -68,11 +68,12 @@ struct dm_verity_fec_io {
 
 extern bool verity_fec_is_enabled(struct dm_verity *v);
 
 extern int verity_fec_decode(struct dm_verity *v, struct dm_verity_io *io,
 			     enum verity_block_type type, sector_t block,
-			     u8 *dest, struct bvec_iter *iter);
+			     const u8 *want_digest, u8 *dest,
+			     struct bvec_iter *iter);
 
 extern unsigned int verity_fec_status_table(struct dm_verity *v, unsigned int sz,
 					char *result, unsigned int maxlen);
 
 extern void verity_fec_finish_io(struct dm_verity_io *io);
@@ -97,12 +98,12 @@ static inline bool verity_fec_is_enabled(struct dm_verity *v)
 	return false;
 }
 
 static inline int verity_fec_decode(struct dm_verity *v,
 				    struct dm_verity_io *io,
-				    enum verity_block_type type,
-				    sector_t block, u8 *dest,
+				    enum verity_block_type type, sector_t block,
+				    const u8 *want_digest, u8 *dest,
 				    struct bvec_iter *iter)
 {
 	return -EOPNOTSUPP;
 }
 
diff --git a/drivers/md/dm-verity-target.c b/drivers/md/dm-verity-target.c
index 2dd15f5e91b7..d367198aefe7 100644
--- a/drivers/md/dm-verity-target.c
+++ b/drivers/md/dm-verity-target.c
@@ -300,16 +300,16 @@ static int verity_handle_err(struct dm_verity *v, enum verity_block_type type,
 
 /*
  * Verify hash of a metadata block pertaining to the specified data block
  * ("block" argument) at a specified level ("level" argument).
  *
- * On successful return, verity_io_want_digest(v, io) contains the hash value
- * for a lower tree level or for the data block (if we're at the lowest level).
+ * On successful return, want_digest contains the hash value for a lower tree
+ * level or for the data block (if we're at the lowest level).
  *
  * If "skip_unverified" is true, unverified buffer is skipped and 1 is returned.
  * If "skip_unverified" is false, unverified buffer is hashed and verified
- * against current value of verity_io_want_digest(v, io).
+ * against current value of want_digest.
  */
 static int verity_verify_level(struct dm_verity *v, struct dm_verity_io *io,
 			       sector_t block, int level, bool skip_unverified,
 			       u8 *want_digest)
 {
@@ -318,10 +318,11 @@ static int verity_verify_level(struct dm_verity *v, struct dm_verity_io *io,
 	u8 *data;
 	int r;
 	sector_t hash_block;
 	unsigned int offset;
 	struct bio *bio = dm_bio_from_per_bio_data(io, v->ti->per_io_data_size);
+	u8 real_digest[HASH_MAX_DIGESTSIZE];
 
 	verity_hash_at_level(v, block, level, &hash_block, &offset);
 
 	if (static_branch_unlikely(&use_bh_wq_enabled) && io->in_bh) {
 		data = dm_bufio_get(v->bufio, hash_block, &buf);
@@ -349,27 +350,26 @@ static int verity_verify_level(struct dm_verity *v, struct dm_verity_io *io,
 			goto release_ret_r;
 		}
 
 		r = verity_compute_hash_virt(v, io, data,
 					     1 << v->hash_dev_block_bits,
-					     verity_io_real_digest(v, io),
-					     !io->in_bh);
+					     real_digest, !io->in_bh);
 		if (unlikely(r < 0))
 			goto release_ret_r;
 
-		if (likely(memcmp(verity_io_real_digest(v, io), want_digest,
-				  v->digest_size) == 0))
+		if (likely(!memcmp(real_digest, want_digest, v->digest_size)))
 			aux->hash_verified = 1;
 		else if (static_branch_unlikely(&use_bh_wq_enabled) && io->in_bh) {
 			/*
 			 * Error handling code (FEC included) cannot be run in a
 			 * tasklet since it may sleep, so fallback to work-queue.
 			 */
 			r = -EAGAIN;
 			goto release_ret_r;
 		} else if (verity_fec_decode(v, io, DM_VERITY_BLOCK_TYPE_METADATA,
-					     hash_block, data, NULL) == 0)
+					     hash_block, want_digest,
+					     data, NULL) == 0)
 			aux->hash_verified = 1;
 		else if (verity_handle_err(v,
 					   DM_VERITY_BLOCK_TYPE_METADATA,
 					   hash_block)) {
 			struct bio *bio =
@@ -473,71 +473,10 @@ static int verity_ahash_update_block(struct dm_verity *v,
 	} while (todo);
 
 	return 0;
 }
 
-static int verity_compute_hash(struct dm_verity *v, struct dm_verity_io *io,
-			       struct bvec_iter *iter, u8 *digest,
-			       bool may_sleep)
-{
-	int r;
-
-	if (static_branch_unlikely(&ahash_enabled) && !v->shash_tfm) {
-		struct ahash_request *req = verity_io_hash_req(v, io);
-		struct crypto_wait wait;
-
-		r = verity_ahash_init(v, req, &wait, may_sleep);
-		if (unlikely(r))
-			goto error;
-
-		r = verity_ahash_update_block(v, io, iter, &wait);
-		if (unlikely(r))
-			goto error;
-
-		r = verity_ahash_final(v, req, digest, &wait);
-		if (unlikely(r))
-			goto error;
-	} else {
-		struct shash_desc *desc = verity_io_hash_req(v, io);
-		struct bio *bio =
-			dm_bio_from_per_bio_data(io, v->ti->per_io_data_size);
-		struct bio_vec bv = bio_iter_iovec(bio, *iter);
-		const unsigned int len = 1 << v->data_dev_block_bits;
-		const void *virt;
-
-		if (unlikely(len > bv.bv_len)) {
-			/*
-			 * Data block spans pages.  This should not happen,
-			 * since this code path is not used if the data block
-			 * size is greater than the page size, and all I/O
-			 * should be data block aligned because dm-verity sets
-			 * logical_block_size to the data block size.
-			 */
-			DMERR_LIMIT("unaligned io (data block spans pages)");
-			return -EIO;
-		}
-
-		desc->tfm = v->shash_tfm;
-		r = crypto_shash_import(desc, v->initial_hashstate);
-		if (unlikely(r))
-			goto error;
-
-		virt = bvec_kmap_local(&bv);
-		r = crypto_shash_finup(desc, virt, len, digest);
-		kunmap_local(virt);
-		if (unlikely(r))
-			goto error;
-
-		bio_advance_iter(bio, iter, len);
-	}
-	return 0;
-
-error:
-	DMERR("Error hashing block from bio iter: %d", r);
-	return r;
-}
-
 /*
  * Calls function process for 1 << v->data_dev_block_bits bytes in the bio_vec
  * starting from iter.
  */
 int verity_for_bv_block(struct dm_verity *v, struct dm_verity_io *io,
@@ -581,41 +520,42 @@ static int verity_recheck_copy(struct dm_verity *v, struct dm_verity_io *io,
 	io->recheck_buffer += len;
 
 	return 0;
 }
 
-static noinline int verity_recheck(struct dm_verity *v, struct dm_verity_io *io,
-				   struct bvec_iter start, sector_t cur_block)
+static int verity_recheck(struct dm_verity *v, struct dm_verity_io *io,
+			  struct bvec_iter start, sector_t blkno,
+			  const u8 *want_digest)
 {
 	struct page *page;
 	void *buffer;
 	int r;
 	struct dm_io_request io_req;
 	struct dm_io_region io_loc;
+	u8 real_digest[HASH_MAX_DIGESTSIZE];
 
 	page = mempool_alloc(&v->recheck_pool, GFP_NOIO);
 	buffer = page_to_virt(page);
 
 	io_req.bi_opf = REQ_OP_READ;
 	io_req.mem.type = DM_IO_KMEM;
 	io_req.mem.ptr.addr = buffer;
 	io_req.notify.fn = NULL;
 	io_req.client = v->io;
 	io_loc.bdev = v->data_dev->bdev;
-	io_loc.sector = cur_block << (v->data_dev_block_bits - SECTOR_SHIFT);
+	io_loc.sector = blkno << (v->data_dev_block_bits - SECTOR_SHIFT);
 	io_loc.count = 1 << (v->data_dev_block_bits - SECTOR_SHIFT);
 	r = dm_io(&io_req, 1, &io_loc, NULL, IOPRIO_DEFAULT);
 	if (unlikely(r))
 		goto free_ret;
 
 	r = verity_compute_hash_virt(v, io, buffer, 1 << v->data_dev_block_bits,
-				     verity_io_real_digest(v, io), true);
+				     real_digest, true);
 	if (unlikely(r))
 		goto free_ret;
 
-	if (memcmp(verity_io_real_digest(v, io),
-		   verity_io_want_digest(v, io), v->digest_size)) {
+	if (memcmp(real_digest, want_digest, v->digest_size)) {
 		r = -EIO;
 		goto free_ret;
 	}
 
 	io->recheck_buffer = buffer;
@@ -647,22 +587,84 @@ static inline void verity_bv_skip_block(struct dm_verity *v,
 	struct bio *bio = dm_bio_from_per_bio_data(io, v->ti->per_io_data_size);
 
 	bio_advance_iter(bio, iter, 1 << v->data_dev_block_bits);
 }
 
+static noinline int
+__verity_handle_data_hash_mismatch(struct dm_verity *v, struct dm_verity_io *io,
+				   struct bio *bio, struct bvec_iter *start,
+				   sector_t blkno, const u8 *want_digest)
+{
+	if (static_branch_unlikely(&use_bh_wq_enabled) && io->in_bh) {
+		/*
+		 * Error handling code (FEC included) cannot be run in the
+		 * BH workqueue, so fallback to a standard workqueue.
+		 */
+		return -EAGAIN;
+	}
+	if (verity_recheck(v, io, *start, blkno, want_digest) == 0) {
+		if (v->validated_blocks)
+			set_bit(blkno, v->validated_blocks);
+		return 0;
+	}
+#if defined(CONFIG_DM_VERITY_FEC)
+	if (verity_fec_decode(v, io, DM_VERITY_BLOCK_TYPE_DATA, blkno,
+			      want_digest, NULL, start) == 0)
+		return 0;
+#endif
+	if (bio->bi_status)
+		return -EIO; /* Error correction failed; Just return error */
+
+	if (verity_handle_err(v, DM_VERITY_BLOCK_TYPE_DATA, blkno)) {
+		dm_audit_log_bio(DM_MSG_PREFIX, "verify-data", bio, blkno, 0);
+		return -EIO;
+	}
+	return 0;
+}
+
+static __always_inline int
+verity_check_data_block_hash(struct dm_verity *v, struct dm_verity_io *io,
+			     struct bio *bio, struct bvec_iter *start,
+			     sector_t blkno,
+			     const u8 *real_digest, const u8 *want_digest)
+{
+	if (likely(memcmp(real_digest, want_digest, v->digest_size) == 0)) {
+		if (v->validated_blocks)
+			set_bit(blkno, v->validated_blocks);
+		return 0;
+	}
+	return __verity_handle_data_hash_mismatch(v, io, bio, start, blkno,
+						  want_digest);
+}
+
 /*
  * Verify one "dm_verity_io" structure.
  */
 static int verity_verify_io(struct dm_verity_io *io)
 {
-	bool is_zero;
 	struct dm_verity *v = io->v;
+	const unsigned int block_size = 1 << v->data_dev_block_bits;
+	struct bio *bio = dm_bio_from_per_bio_data(io, v->ti->per_io_data_size);
+	u8 want_digest[HASH_MAX_DIGESTSIZE];
+	u8 real_digest[HASH_MAX_DIGESTSIZE];
 	struct bvec_iter start;
 	struct bvec_iter iter_copy;
 	struct bvec_iter *iter;
-	struct bio *bio = dm_bio_from_per_bio_data(io, v->ti->per_io_data_size);
+	/*
+	 * The pending_* variables are used when the selected hash algorithm
+	 * supports multibuffer hashing.  They're used to temporarily store the
+	 * virtual address and position of a mapped data block that needs to be
+	 * verified.  If we then see another data block, we hash the two blocks
+	 * simultaneously using the fast multibuffer hashing method.
+	 */
+	const void *pending_data = NULL;
+	sector_t pending_blkno;
+	struct bvec_iter pending_start;
+	u8 pending_want_digest[HASH_MAX_DIGESTSIZE];
+	u8 pending_real_digest[HASH_MAX_DIGESTSIZE];
 	unsigned int b;
+	int r;
 
 	if (static_branch_unlikely(&use_bh_wq_enabled) && io->in_bh) {
 		/*
 		 * Copy the iterator in case we need to restart
 		 * verification in a work-queue.
@@ -671,82 +673,177 @@ static int verity_verify_io(struct dm_verity_io *io)
 		iter = &iter_copy;
 	} else
 		iter = &io->iter;
 
 	for (b = 0; b < io->n_blocks; b++) {
-		int r;
-		sector_t cur_block = io->block + b;
+		sector_t blkno = io->block + b;
+		bool is_zero;
 
 		if (v->validated_blocks && bio->bi_status == BLK_STS_OK &&
-		    likely(test_bit(cur_block, v->validated_blocks))) {
+		    likely(test_bit(blkno, v->validated_blocks))) {
 			verity_bv_skip_block(v, io, iter);
 			continue;
 		}
 
-		r = verity_hash_for_block(v, io, cur_block,
-					  verity_io_want_digest(v, io),
-					  &is_zero);
+		r = verity_hash_for_block(v, io, blkno, want_digest, &is_zero);
 		if (unlikely(r < 0))
-			return r;
+			goto error;
 
 		if (is_zero) {
 			/*
 			 * If we expect a zero block, don't validate, just
 			 * return zeros.
 			 */
 			r = verity_for_bv_block(v, io, iter,
 						verity_bv_zero);
 			if (unlikely(r < 0))
-				return r;
+				goto error;
 
 			continue;
 		}
 
 		start = *iter;
-		r = verity_compute_hash(v, io, iter,
-					verity_io_real_digest(v, io),
-					!io->in_bh);
-		if (unlikely(r < 0))
-			return r;
-
-		if (likely(memcmp(verity_io_real_digest(v, io),
-				  verity_io_want_digest(v, io), v->digest_size) == 0)) {
-			if (v->validated_blocks)
-				set_bit(cur_block, v->validated_blocks);
-			continue;
-		} else if (static_branch_unlikely(&use_bh_wq_enabled) && io->in_bh) {
-			/*
-			 * Error handling code (FEC included) cannot be run in a
-			 * tasklet since it may sleep, so fallback to work-queue.
-			 */
-			return -EAGAIN;
-		} else if (verity_recheck(v, io, start, cur_block) == 0) {
-			if (v->validated_blocks)
-				set_bit(cur_block, v->validated_blocks);
-			continue;
-#if defined(CONFIG_DM_VERITY_FEC)
-		} else if (verity_fec_decode(v, io, DM_VERITY_BLOCK_TYPE_DATA,
-					     cur_block, NULL, &start) == 0) {
-			continue;
-#endif
+		if (static_branch_unlikely(&ahash_enabled) && !v->shash_tfm) {
+			/* Hash and verify one data block using ahash. */
+			struct ahash_request *req = verity_io_hash_req(v, io);
+			struct crypto_wait wait;
+
+			r = verity_ahash_init(v, req, &wait, !io->in_bh);
+			if (unlikely(r))
+				goto hash_error;
+
+			r = verity_ahash_update_block(v, io, iter, &wait);
+			if (unlikely(r))
+				goto hash_error;
+
+			r = verity_ahash_final(v, req, real_digest, &wait);
+			if (unlikely(r))
+				goto hash_error;
+
+			r = verity_check_data_block_hash(v, io, bio, &start,
+							 blkno, real_digest,
+							 want_digest);
+			if (unlikely(r))
+				goto error;
 		} else {
-			if (bio->bi_status) {
+			struct shash_desc *desc = verity_io_hash_req(v, io);
+			struct bio_vec bv = bio_iter_iovec(bio, *iter);
+			const void *data;
+
+			if (unlikely(bv.bv_len < block_size)) {
 				/*
-				 * Error correction failed; Just return error
+				 * Data block spans pages.  This should not
+				 * happen, since this code path is not used if
+				 * the data block size is greater than the page
+				 * size, and all I/O should be data block
+				 * aligned because dm-verity sets
+				 * logical_block_size to the data block size.
 				 */
-				return -EIO;
+				DMERR_LIMIT("unaligned io (data block spans pages)");
+				r = -EIO;
+				goto error;
 			}
-			if (verity_handle_err(v, DM_VERITY_BLOCK_TYPE_DATA,
-					      cur_block)) {
-				dm_audit_log_bio(DM_MSG_PREFIX, "verify-data",
-						 bio, cur_block, 0);
-				return -EIO;
+
+			data = bvec_kmap_local(&bv);
+
+			if (v->use_finup_mb) {
+				if (pending_data) {
+					const u8 *datas[2] = { pending_data,
+							       data };
+					u8 *outs[2] = { pending_real_digest,
+							real_digest };
+					/* Hash and verify two data blocks. */
+					desc->tfm = v->shash_tfm;
+					r = crypto_shash_import(desc,
+								v->initial_hashstate) ?:
+					    crypto_shash_finup_mb(desc,
+								  datas,
+								  block_size,
+								  outs,
+								  2);
+					kunmap_local(data);
+					kunmap_local(pending_data);
+					pending_data = NULL;
+					if (unlikely(r))
+						goto hash_error;
+					r = verity_check_data_block_hash(
+							v, io, bio,
+							&pending_start,
+							pending_blkno,
+							pending_real_digest,
+							pending_want_digest);
+					if (unlikely(r))
+						goto error;
+					r = verity_check_data_block_hash(
+							v, io, bio,
+							&start,
+							blkno,
+							real_digest,
+							want_digest);
+					if (unlikely(r))
+						goto error;
+				} else {
+					/* Wait and see if there's another block. */
+					pending_data = data;
+					pending_blkno = blkno;
+					pending_start = start;
+					memcpy(pending_want_digest, want_digest,
+					       v->digest_size);
+				}
+			} else {
+				/* Hash and verify one data block. */
+				desc->tfm = v->shash_tfm;
+				r = crypto_shash_import(desc,
+							v->initial_hashstate) ?:
+				    crypto_shash_finup(desc, data, block_size,
+						       real_digest);
+				kunmap_local(data);
+				if (unlikely(r))
+					goto hash_error;
+				r = verity_check_data_block_hash(
+						v, io, bio, &start, blkno,
+						real_digest, want_digest);
+				if (unlikely(r))
+					goto error;
 			}
+
+			bio_advance_iter(bio, iter, block_size);
 		}
 	}
 
+	if (pending_data) {
+		/*
+		 * Multibuffer hashing is enabled but there was an odd number of
+		 * data blocks.  Hash and verify the last block by itself.
+		 */
+		struct shash_desc *desc = verity_io_hash_req(v, io);
+
+		desc->tfm = v->shash_tfm;
+		r = crypto_shash_import(desc, v->initial_hashstate) ?:
+		    crypto_shash_finup(desc, pending_data, block_size,
+				       pending_real_digest);
+		kunmap_local(pending_data);
+		pending_data = NULL;
+		if (unlikely(r))
+			goto hash_error;
+		r = verity_check_data_block_hash(v, io, bio,
+						 &pending_start,
+						 pending_blkno,
+						 pending_real_digest,
+						 pending_want_digest);
+		if (unlikely(r))
+			goto error;
+	}
+
 	return 0;
+
+hash_error:
+	DMERR("Error hashing block from bio iter: %d", r);
+error:
+	if (pending_data)
+		kunmap_local(pending_data);
+	return r;
 }
 
 /*
  * Skip verity work in response to I/O error when system is shutting down.
  */
@@ -1321,10 +1418,34 @@ static int verity_setup_hash_alg(struct dm_verity *v, const char *alg_name)
 	if (!v->alg_name) {
 		ti->error = "Cannot allocate algorithm name";
 		return -ENOMEM;
 	}
 
+	/*
+	 * Allocate the hash transformation object that this dm-verity instance
+	 * will use.  We have a choice of two APIs: shash and ahash.  Most
+	 * dm-verity users use CPU-based hashing, and for this shash is optimal
+	 * since it matches the underlying algorithm implementations and also
+	 * allows the use of fast multibuffer hashing (crypto_shash_finup_mb()).
+	 * ahash adds support for off-CPU hash offloading.  It also provides
+	 * access to shash algorithms, but does so less efficiently.
+	 *
+	 * Meanwhile, hashing a block in dm-verity in general requires an
+	 * init+update+final sequence with multiple updates.  However, usually
+	 * the salt is prepended to the block rather than appended, and the data
+	 * block size is not greater than the page size.  In this very common
+	 * case, the sequence can be optimized to import+finup, where the first
+	 * step imports the pre-computed state after init+update(salt).  This
+	 * can reduce the crypto API overhead significantly.
+	 *
+	 * To provide optimal performance for the vast majority of dm-verity
+	 * users while still supporting off-CPU hash offloading and the rarer
+	 * dm-verity settings, we therefore have two code paths: one using shash
+	 * where we use import+finup or import+finup_mb, and one using ahash
+	 * where we use init+update(s)+final.  We use the former code path when
+	 * it's possible to use and shash gives the same algorithm as ahash.
+	 */
 	ahash = crypto_alloc_ahash(alg_name, 0,
 				   v->use_bh_wq ? CRYPTO_ALG_ASYNC : 0);
 	if (IS_ERR(ahash)) {
 		ti->error = "Cannot initialize hash function";
 		return PTR_ERR(ahash);
@@ -1345,14 +1466,16 @@ static int verity_setup_hash_alg(struct dm_verity *v, const char *alg_name)
 	}
 	if (!IS_ERR_OR_NULL(shash)) {
 		crypto_free_ahash(ahash);
 		ahash = NULL;
 		v->shash_tfm = shash;
+		v->use_finup_mb = crypto_shash_mb_max_msgs(shash);
 		v->digest_size = crypto_shash_digestsize(shash);
 		v->hash_reqsize = sizeof(struct shash_desc) +
 				  crypto_shash_descsize(shash);
-		DMINFO("%s using shash \"%s\"", alg_name, driver_name);
+		DMINFO("%s using shash \"%s\"%s", alg_name, driver_name,
+		       v->use_finup_mb ? " (multibuffer)" : "");
 	} else {
 		v->ahash_tfm = ahash;
 		static_branch_inc(&ahash_enabled);
 		v->digest_size = crypto_ahash_digestsize(ahash);
 		v->hash_reqsize = sizeof(struct ahash_request) +
diff --git a/drivers/md/dm-verity.h b/drivers/md/dm-verity.h
index 15ffb0881cc9..d5f659e1bdef 100644
--- a/drivers/md/dm-verity.h
+++ b/drivers/md/dm-verity.h
@@ -55,10 +55,11 @@ struct dm_verity {
 	unsigned char hash_per_block_bits;	/* log2(hashes in hash block) */
 	unsigned char levels;	/* the number of tree levels */
 	unsigned char version;
 	bool hash_failed:1;	/* set if hash of any block failed */
 	bool use_bh_wq:1;	/* try to verify in BH wq before normal work-queue */
+	bool use_finup_mb:1;	/* use crypto_shash_finup_mb() */
 	unsigned int digest_size;	/* digest size for the current hash algorithm */
 	unsigned int hash_reqsize; /* the size of temporary space for crypto */
 	enum verity_mode mode;	/* mode for handling verification errors */
 	unsigned int corrupted_errs;/* Number of errors for corrupted blocks */
 
@@ -92,42 +93,23 @@ struct dm_verity_io {
 	struct work_struct bh_work;
 
 	char *recheck_buffer;
 
 	/*
-	 * Three variably-size fields follow this struct:
-	 *
-	 * u8 hash_req[v->hash_reqsize];
-	 * u8 real_digest[v->digest_size];
-	 * u8 want_digest[v->digest_size];
-	 *
-	 * To access them use: verity_io_hash_req(), verity_io_real_digest()
-	 * and verity_io_want_digest().
-	 *
-	 * hash_req is either a struct ahash_request or a struct shash_desc,
-	 * depending on whether ahash_tfm or shash_tfm is being used.
+	 * This struct is followed by a variable-sized hash request of size
+	 * v->hash_reqsize, either a struct ahash_request or a struct shash_desc
+	 * (depending on whether ahash_tfm or shash_tfm is being used).  To
+	 * access it, use verity_io_hash_req().
 	 */
 };
 
 static inline void *verity_io_hash_req(struct dm_verity *v,
 				       struct dm_verity_io *io)
 {
 	return io + 1;
 }
 
-static inline u8 *verity_io_real_digest(struct dm_verity *v,
-					struct dm_verity_io *io)
-{
-	return (u8 *)(io + 1) + v->hash_reqsize;
-}
-
-static inline u8 *verity_io_want_digest(struct dm_verity *v,
-					struct dm_verity_io *io)
-{
-	return (u8 *)(io + 1) + v->hash_reqsize + v->digest_size;
-}
-
 extern int verity_for_bv_block(struct dm_verity *v, struct dm_verity_io *io,
 			       struct bvec_iter *iter,
 			       int (*process)(struct dm_verity *v,
 					      struct dm_verity_io *io,
 					      u8 *data, size_t len));
-- 
2.45.0


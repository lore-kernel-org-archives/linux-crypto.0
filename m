Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 69B7D171095;
	Tue, 11 Jun 2024 03:49:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718077755; cv=none; b=EK9neIIRSH9V+L9p3aaPsNDGQAfB1peQfoS1SrX4RH8CagilqxiDoWChPUixFw3SB44ica6KrJMryUe7vEGRiV1FRSaOIKJTlsM26nFThIZxMVAi+r9pMuYa9j7xKMN+s/4cVsTbICvTV2VJrvsil/xJwg+crTngCoyTOENXDuk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718077755; c=relaxed/simple;
	bh=rAxcshtLtTT/M3q+BHiyIxTJAimCNzEDCElsy9iR8gE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BHqXJ55a3/lkf7Q2RRGMZms3LoWN9x0fWP434fVaAZipdiGkLvYXl7kJdYSuBw/Xa0aslBZYRfOVGuw9A9iGHNYJj8N3YKLMIJt5tQnBZyySuXIwQlWBlxJIPjWI3yXsW6OTW/oJJ2oaQjg3aj9YMe6yt9m2MVYzbI3x0rdBJxc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=RKwGcWXl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="RKwGcWXl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0BCC0C4AF4D;
	Tue, 11 Jun 2024 03:49:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1718077755;
	bh=rAxcshtLtTT/M3q+BHiyIxTJAimCNzEDCElsy9iR8gE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RKwGcWXljvnZoQXB0nTX1+CwQFWYlZJR7gojdYk5Ua4nv+uRN0Yz+rhLoAuD/FKYM
	 fsySElK82K8Cw29RgQhX3D1aBSJytZ/BcwY9Dh6w4G9jQvZwgiikPxiX2TNf0B4cDv
	 eH6R+b2OUR3P++Ba6zzquYauoyiu2w5+hXPk8BsPr5vWeGTHCgCTEvNc3cvzcf9u1y
	 R1t1EOhhSlvX6I1voqPyyXf7CKuV3otgFzM7aLLwRKXvcOiFElYdAWKR+lFY5qQsht
	 WXRoEArS4YfzesbTvM4lCM1B9mFwYEdUoZVXe55hL9cCpfWwHt+lSpTupVk8WcMj/b
	 NTqDKS0F48InA==
From: Eric Biggers <ebiggers@kernel.org>
To: linux-crypto@vger.kernel.org,
	fsverity@lists.linux.dev,
	dm-devel@lists.linux.dev
Cc: x86@kernel.org,
	linux-arm-kernel@lists.infradead.org,
	Ard Biesheuvel <ardb@kernel.org>,
	Sami Tolvanen <samitolvanen@google.com>,
	Bart Van Assche <bvanassche@acm.org>,
	Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH v5 11/15] dm-verity: always "map" the data blocks
Date: Mon, 10 Jun 2024 20:48:18 -0700
Message-ID: <20240611034822.36603-12-ebiggers@kernel.org>
X-Mailer: git-send-email 2.45.1
In-Reply-To: <20240611034822.36603-1-ebiggers@kernel.org>
References: <20240611034822.36603-1-ebiggers@kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Eric Biggers <ebiggers@google.com>

dm-verity needs to access data blocks by virtual address in three
different cases (zeroization, recheck, and forward error correction),
and one more case (shash support) is coming.  Since it's guaranteed that
dm-verity data blocks never cross pages, and kmap_local_page and
kunmap_local are no-ops on modern platforms anyway, just unconditionally
"map" every data block's page and work with the virtual buffer directly.
This simplifies the code and eliminates unnecessary overhead.

Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 drivers/md/dm-verity-fec.c    |  26 +----
 drivers/md/dm-verity-fec.h    |   6 +-
 drivers/md/dm-verity-target.c | 182 +++++++---------------------------
 drivers/md/dm-verity.h        |   8 --
 4 files changed, 42 insertions(+), 180 deletions(-)

diff --git a/drivers/md/dm-verity-fec.c b/drivers/md/dm-verity-fec.c
index e46aee6f932e..b838d21183b5 100644
--- a/drivers/md/dm-verity-fec.c
+++ b/drivers/md/dm-verity-fec.c
@@ -402,28 +402,13 @@ static int fec_decode_rsb(struct dm_verity *v, struct dm_verity_io *io,
 	}
 
 	return 0;
 }
 
-static int fec_bv_copy(struct dm_verity *v, struct dm_verity_io *io, u8 *data,
-		       size_t len)
-{
-	struct dm_verity_fec_io *fio = fec_io(io);
-
-	memcpy(data, &fio->output[fio->output_pos], len);
-	fio->output_pos += len;
-
-	return 0;
-}
-
-/*
- * Correct errors in a block. Copies corrected block to dest if non-NULL,
- * otherwise to a bio_vec starting from iter.
- */
+/* Correct errors in a block. Copies corrected block to dest. */
 int verity_fec_decode(struct dm_verity *v, struct dm_verity_io *io,
-		      enum verity_block_type type, sector_t block, u8 *dest,
-		      struct bvec_iter *iter)
+		      enum verity_block_type type, sector_t block, u8 *dest)
 {
 	int r;
 	struct dm_verity_fec_io *fio = fec_io(io);
 	u64 offset, res, rsb;
 
@@ -469,16 +454,11 @@ int verity_fec_decode(struct dm_verity *v, struct dm_verity_io *io,
 		r = fec_decode_rsb(v, io, fio, rsb, offset, true);
 		if (r < 0)
 			goto done;
 	}
 
-	if (dest)
-		memcpy(dest, fio->output, 1 << v->data_dev_block_bits);
-	else if (iter) {
-		fio->output_pos = 0;
-		r = verity_for_bv_block(v, io, iter, fec_bv_copy);
-	}
+	memcpy(dest, fio->output, 1 << v->data_dev_block_bits);
 
 done:
 	fio->level--;
 	return r;
 }
diff --git a/drivers/md/dm-verity-fec.h b/drivers/md/dm-verity-fec.h
index 8454070d2824..09123a612953 100644
--- a/drivers/md/dm-verity-fec.h
+++ b/drivers/md/dm-verity-fec.h
@@ -55,11 +55,10 @@ struct dm_verity_fec_io {
 	struct rs_control *rs;	/* Reed-Solomon state */
 	int erasures[DM_VERITY_FEC_MAX_RSN];	/* erasures for decode_rs8 */
 	u8 *bufs[DM_VERITY_FEC_BUF_MAX];	/* bufs for deinterleaving */
 	unsigned int nbufs;		/* number of buffers allocated */
 	u8 *output;		/* buffer for corrected output */
-	size_t output_pos;
 	unsigned int level;		/* recursion level */
 };
 
 #ifdef CONFIG_DM_VERITY_FEC
 
@@ -68,11 +67,11 @@ struct dm_verity_fec_io {
 
 extern bool verity_fec_is_enabled(struct dm_verity *v);
 
 extern int verity_fec_decode(struct dm_verity *v, struct dm_verity_io *io,
 			     enum verity_block_type type, sector_t block,
-			     u8 *dest, struct bvec_iter *iter);
+			     u8 *dest);
 
 extern unsigned int verity_fec_status_table(struct dm_verity *v, unsigned int sz,
 					char *result, unsigned int maxlen);
 
 extern void verity_fec_finish_io(struct dm_verity_io *io);
@@ -98,12 +97,11 @@ static inline bool verity_fec_is_enabled(struct dm_verity *v)
 }
 
 static inline int verity_fec_decode(struct dm_verity *v,
 				    struct dm_verity_io *io,
 				    enum verity_block_type type,
-				    sector_t block, u8 *dest,
-				    struct bvec_iter *iter)
+				    sector_t block, u8 *dest)
 {
 	return -EOPNOTSUPP;
 }
 
 static inline unsigned int verity_fec_status_table(struct dm_verity *v,
diff --git a/drivers/md/dm-verity-target.c b/drivers/md/dm-verity-target.c
index c6a0e3280e39..3e2e4f41714c 100644
--- a/drivers/md/dm-verity-target.c
+++ b/drivers/md/dm-verity-target.c
@@ -340,11 +340,11 @@ static int verity_verify_level(struct dm_verity *v, struct dm_verity_io *io,
 			 * tasklet since it may sleep, so fallback to work-queue.
 			 */
 			r = -EAGAIN;
 			goto release_ret_r;
 		} else if (verity_fec_decode(v, io, DM_VERITY_BLOCK_TYPE_METADATA,
-					     hash_block, data, NULL) == 0)
+					     hash_block, data) == 0)
 			aux->hash_verified = 1;
 		else if (verity_handle_err(v,
 					   DM_VERITY_BLOCK_TYPE_METADATA,
 					   hash_block)) {
 			struct bio *bio =
@@ -402,102 +402,12 @@ int verity_hash_for_block(struct dm_verity *v, struct dm_verity_io *io,
 		*is_zero = false;
 
 	return r;
 }
 
-/*
- * Calculates the digest for the given bio
- */
-static int verity_for_io_block(struct dm_verity *v, struct dm_verity_io *io,
-			       struct bvec_iter *iter, struct crypto_wait *wait)
-{
-	unsigned int todo = 1 << v->data_dev_block_bits;
-	struct bio *bio = dm_bio_from_per_bio_data(io, v->ti->per_io_data_size);
-	struct scatterlist sg;
-	struct ahash_request *req = verity_io_hash_req(v, io);
-
-	do {
-		int r;
-		unsigned int len;
-		struct bio_vec bv = bio_iter_iovec(bio, *iter);
-
-		sg_init_table(&sg, 1);
-
-		len = bv.bv_len;
-
-		if (likely(len >= todo))
-			len = todo;
-		/*
-		 * Operating on a single page at a time looks suboptimal
-		 * until you consider the typical block size is 4,096B.
-		 * Going through this loops twice should be very rare.
-		 */
-		sg_set_page(&sg, bv.bv_page, len, bv.bv_offset);
-		ahash_request_set_crypt(req, &sg, NULL, len);
-		r = crypto_wait_req(crypto_ahash_update(req), wait);
-
-		if (unlikely(r < 0)) {
-			DMERR("%s crypto op failed: %d", __func__, r);
-			return r;
-		}
-
-		bio_advance_iter(bio, iter, len);
-		todo -= len;
-	} while (todo);
-
-	return 0;
-}
-
-/*
- * Calls function process for 1 << v->data_dev_block_bits bytes in the bio_vec
- * starting from iter.
- */
-int verity_for_bv_block(struct dm_verity *v, struct dm_verity_io *io,
-			struct bvec_iter *iter,
-			int (*process)(struct dm_verity *v,
-				       struct dm_verity_io *io, u8 *data,
-				       size_t len))
-{
-	unsigned int todo = 1 << v->data_dev_block_bits;
-	struct bio *bio = dm_bio_from_per_bio_data(io, v->ti->per_io_data_size);
-
-	do {
-		int r;
-		u8 *page;
-		unsigned int len;
-		struct bio_vec bv = bio_iter_iovec(bio, *iter);
-
-		page = bvec_kmap_local(&bv);
-		len = bv.bv_len;
-
-		if (likely(len >= todo))
-			len = todo;
-
-		r = process(v, io, page, len);
-		kunmap_local(page);
-
-		if (r < 0)
-			return r;
-
-		bio_advance_iter(bio, iter, len);
-		todo -= len;
-	} while (todo);
-
-	return 0;
-}
-
-static int verity_recheck_copy(struct dm_verity *v, struct dm_verity_io *io,
-			       u8 *data, size_t len)
-{
-	memcpy(data, io->recheck_buffer, len);
-	io->recheck_buffer += len;
-
-	return 0;
-}
-
 static noinline int verity_recheck(struct dm_verity *v, struct dm_verity_io *io,
-				   struct bvec_iter start, sector_t cur_block)
+				   sector_t cur_block, u8 *dest)
 {
 	struct page *page;
 	void *buffer;
 	int r;
 	struct dm_io_request io_req;
@@ -528,42 +438,38 @@ static noinline int verity_recheck(struct dm_verity *v, struct dm_verity_io *io,
 		   verity_io_want_digest(v, io), v->digest_size)) {
 		r = -EIO;
 		goto free_ret;
 	}
 
-	io->recheck_buffer = buffer;
-	r = verity_for_bv_block(v, io, &start, verity_recheck_copy);
-	if (unlikely(r))
-		goto free_ret;
-
+	memcpy(dest, buffer, 1 << v->data_dev_block_bits);
 	r = 0;
 free_ret:
 	mempool_free(page, &v->recheck_pool);
 
 	return r;
 }
 
 static int verity_handle_data_hash_mismatch(struct dm_verity *v,
 					    struct dm_verity_io *io,
 					    struct bio *bio, sector_t blkno,
-					    struct bvec_iter *start)
+					    u8 *data)
 {
 	if (static_branch_unlikely(&use_bh_wq_enabled) && io->in_bh) {
 		/*
 		 * Error handling code (FEC included) cannot be run in the
 		 * BH workqueue, so fallback to a standard workqueue.
 		 */
 		return -EAGAIN;
 	}
-	if (verity_recheck(v, io, *start, blkno) == 0) {
+	if (verity_recheck(v, io, blkno, data) == 0) {
 		if (v->validated_blocks)
 			set_bit(blkno, v->validated_blocks);
 		return 0;
 	}
 #if defined(CONFIG_DM_VERITY_FEC)
 	if (verity_fec_decode(v, io, DM_VERITY_BLOCK_TYPE_DATA, blkno,
-			      NULL, start) == 0)
+			      data) == 0)
 		return 0;
 #endif
 	if (bio->bi_status)
 		return -EIO; /* Error correction failed; Just return error */
 
@@ -572,40 +478,19 @@ static int verity_handle_data_hash_mismatch(struct dm_verity *v,
 		return -EIO;
 	}
 	return 0;
 }
 
-static int verity_bv_zero(struct dm_verity *v, struct dm_verity_io *io,
-			  u8 *data, size_t len)
-{
-	memset(data, 0, len);
-	return 0;
-}
-
-/*
- * Moves the bio iter one data block forward.
- */
-static inline void verity_bv_skip_block(struct dm_verity *v,
-					struct dm_verity_io *io,
-					struct bvec_iter *iter)
-{
-	struct bio *bio = dm_bio_from_per_bio_data(io, v->ti->per_io_data_size);
-
-	bio_advance_iter(bio, iter, 1 << v->data_dev_block_bits);
-}
-
 /*
  * Verify one "dm_verity_io" structure.
  */
 static int verity_verify_io(struct dm_verity_io *io)
 {
-	bool is_zero;
 	struct dm_verity *v = io->v;
-	struct bvec_iter start;
+	const unsigned int block_size = 1 << v->data_dev_block_bits;
 	struct bvec_iter iter_copy;
 	struct bvec_iter *iter;
-	struct crypto_wait wait;
 	struct bio *bio = dm_bio_from_per_bio_data(io, v->ti->per_io_data_size);
 	unsigned int b;
 
 	if (static_branch_unlikely(&use_bh_wq_enabled) && io->in_bh) {
 		/*
@@ -615,62 +500,69 @@ static int verity_verify_io(struct dm_verity_io *io)
 		iter_copy = io->iter;
 		iter = &iter_copy;
 	} else
 		iter = &io->iter;
 
-	for (b = 0; b < io->n_blocks; b++) {
+	for (b = 0; b < io->n_blocks;
+	     b++, bio_advance_iter(bio, iter, block_size)) {
 		int r;
 		sector_t cur_block = io->block + b;
-		struct ahash_request *req = verity_io_hash_req(v, io);
+		bool is_zero;
+		struct bio_vec bv;
+		void *data;
 
 		if (v->validated_blocks && bio->bi_status == BLK_STS_OK &&
-		    likely(test_bit(cur_block, v->validated_blocks))) {
-			verity_bv_skip_block(v, io, iter);
+		    likely(test_bit(cur_block, v->validated_blocks)))
 			continue;
-		}
 
 		r = verity_hash_for_block(v, io, cur_block,
 					  verity_io_want_digest(v, io),
 					  &is_zero);
 		if (unlikely(r < 0))
 			return r;
 
+		bv = bio_iter_iovec(bio, *iter);
+		if (unlikely(bv.bv_len < block_size)) {
+			/*
+			 * Data block spans pages.  This should not happen,
+			 * since dm-verity sets dma_alignment to the data block
+			 * size minus 1, and dm-verity also doesn't allow the
+			 * data block size to be greater than PAGE_SIZE.
+			 */
+			DMERR_LIMIT("unaligned io (data block spans pages)");
+			return -EIO;
+		}
+
+		data = bvec_kmap_local(&bv);
+
 		if (is_zero) {
 			/*
 			 * If we expect a zero block, don't validate, just
 			 * return zeros.
 			 */
-			r = verity_for_bv_block(v, io, iter,
-						verity_bv_zero);
-			if (unlikely(r < 0))
-				return r;
-
+			memset(data, 0, block_size);
+			kunmap_local(data);
 			continue;
 		}
 
-		r = verity_hash_init(v, req, &wait, !io->in_bh);
-		if (unlikely(r < 0))
-			return r;
-
-		start = *iter;
-		r = verity_for_io_block(v, io, iter, &wait);
-		if (unlikely(r < 0))
-			return r;
-
-		r = verity_hash_final(v, req, verity_io_real_digest(v, io),
-					&wait);
-		if (unlikely(r < 0))
+		r = verity_hash(v, verity_io_hash_req(v, io), data, block_size,
+				verity_io_real_digest(v, io), !io->in_bh);
+		if (unlikely(r < 0)) {
+			kunmap_local(data);
 			return r;
+		}
 
 		if (likely(memcmp(verity_io_real_digest(v, io),
 				  verity_io_want_digest(v, io), v->digest_size) == 0)) {
 			if (v->validated_blocks)
 				set_bit(cur_block, v->validated_blocks);
+			kunmap_local(data);
 			continue;
 		}
 		r = verity_handle_data_hash_mismatch(v, io, bio, cur_block,
-						     &start);
+						     data);
+		kunmap_local(data);
 		if (unlikely(r))
 			return r;
 	}
 
 	return 0;
diff --git a/drivers/md/dm-verity.h b/drivers/md/dm-verity.h
index 5d3da9f5fc95..bd461c28b710 100644
--- a/drivers/md/dm-verity.h
+++ b/drivers/md/dm-verity.h
@@ -87,12 +87,10 @@ struct dm_verity_io {
 	bool in_bh;
 
 	struct work_struct work;
 	struct work_struct bh_work;
 
-	char *recheck_buffer;
-
 	u8 real_digest[HASH_MAX_DIGESTSIZE];
 	u8 want_digest[HASH_MAX_DIGESTSIZE];
 
 	/*
 	 * This struct is followed by a variable-sized struct ahash_request of
@@ -116,16 +114,10 @@ static inline u8 *verity_io_want_digest(struct dm_verity *v,
 					struct dm_verity_io *io)
 {
 	return io->want_digest;
 }
 
-extern int verity_for_bv_block(struct dm_verity *v, struct dm_verity_io *io,
-			       struct bvec_iter *iter,
-			       int (*process)(struct dm_verity *v,
-					      struct dm_verity_io *io,
-					      u8 *data, size_t len));
-
 extern int verity_hash(struct dm_verity *v, struct ahash_request *req,
 		       const u8 *data, size_t len, u8 *digest, bool may_sleep);
 
 extern int verity_hash_for_block(struct dm_verity *v, struct dm_verity_io *io,
 				 sector_t block, u8 *digest, bool *is_zero);
-- 
2.45.1


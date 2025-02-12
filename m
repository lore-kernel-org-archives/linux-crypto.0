Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA4D4265601;
	Wed, 12 Feb 2025 15:48:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739375303; cv=none; b=aok74lIoLBeTMn4jrtSzDEb00HhEN8DBlyXM2hqo+X4kOlUwzG/k+B/4bKg3c0qnJZAlk3ngllSFIk2epuWUqHt4sHNUfnWU1Qv+7X6s2etR+ffLo4lbtkIt8eEPFFCCuoCuHFgOAn2Mbk32YeG5cf7cOMwtOeTJZ03pnXSA07M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739375303; c=relaxed/simple;
	bh=ZOAWTttlvhZOogTtj2jDDebvQskR/T5DkhBmxEUyOQA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Bw/S/AXiSro9N01YGi/ePOn+QlmK7wE+MaueVc/+K+h8fEgmXLhh3uILFwWSYB+1nOxr5tGCRJD/ZoFKN8UwZIqpfAavYmSjGM/7VeJQOUus2ycrdvqqyfhz2Ag06CWXdpbBHSHjrANbbZWMyA/Mdf337/EeVgLW7Ef4Xf4ptic=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=TZBvUZ/N; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="TZBvUZ/N"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 029F1C4CEEB;
	Wed, 12 Feb 2025 15:48:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1739375302;
	bh=ZOAWTttlvhZOogTtj2jDDebvQskR/T5DkhBmxEUyOQA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TZBvUZ/NiNkU/PuRKJeLxlGuYKgfv/REqh/cSZNVSsbo33URY8qan9yQb3DJbJ2IW
	 ceGPT78SpqWwm7K21s3zmcdp0NRDqhtxa2G4OjLGwfjdJ5GrFvfZNAM4C8l67hOpwT
	 TrEt0X+7XIMY88wHtwequmm+qhE+D2CImo/YulOQsSjKMikcLPdQsr2BaIakLR47RM
	 fT6LnddqKdW3qsxBEc+FOxqM0xixnEDMv2x6JwHRXGXOosk0JN4Txj5l94P75k7Zik
	 gtW3Z2DsNYjKYLfXYCeYEKFPZiD84q40FkTNFiZkVRAHdt7kpYz3lYB0+wrW6jqPjU
	 x9krLqlNFIoBA==
From: Eric Biggers <ebiggers@kernel.org>
To: fsverity@lists.linux.dev
Cc: linux-crypto@vger.kernel.org,
	dm-devel@lists.linux.dev,
	x86@kernel.org,
	linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org,
	Ard Biesheuvel <ardb@kernel.org>,
	Sami Tolvanen <samitolvanen@google.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Alasdair Kergon <agk@redhat.com>,
	Mike Snitzer <snitzer@kernel.org>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Mikulas Patocka <mpatocka@redhat.com>
Subject: [PATCH v8 6/7] dm-verity: reduce scope of real and wanted digests
Date: Wed, 12 Feb 2025 07:47:17 -0800
Message-ID: <20250212154718.44255-7-ebiggers@kernel.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250212154718.44255-1-ebiggers@kernel.org>
References: <20250212154718.44255-1-ebiggers@kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Eric Biggers <ebiggers@google.com>

In preparation for supporting multibuffer hashing where dm-verity will
need to keep track of the real and wanted digests for multiple data
blocks simultaneously, stop using the want_digest and real_digest fields
of struct dm_verity_io from so many different places.  Specifically:

- Make various functions take want_digest as a parameter rather than
  having it be implicitly passed via the struct dm_verity_io.

- Add a new tmp_digest field, and use this instead of real_digest when
  computing a hash solely for the purpose of immediately checking it.

The result is that real_digest and want_digest are used only by
verity_verify_io().

Reviewed-by: Sami Tolvanen <samitolvanen@google.com>
Acked-by: Ard Biesheuvel <ardb@kernel.org>
Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 drivers/md/dm-verity-fec.c    | 19 +++++++++---------
 drivers/md/dm-verity-fec.h    |  5 +++--
 drivers/md/dm-verity-target.c | 36 ++++++++++++++++++-----------------
 drivers/md/dm-verity.h        |  1 +
 4 files changed, 32 insertions(+), 29 deletions(-)

diff --git a/drivers/md/dm-verity-fec.c b/drivers/md/dm-verity-fec.c
index 0c41949db784b..bce88e8a8389e 100644
--- a/drivers/md/dm-verity-fec.c
+++ b/drivers/md/dm-verity-fec.c
@@ -189,15 +189,14 @@ static int fec_decode_bufs(struct dm_verity *v, struct dm_verity_io *io,
  */
 static int fec_is_erasure(struct dm_verity *v, struct dm_verity_io *io,
 			  u8 *want_digest, u8 *data)
 {
 	if (unlikely(verity_hash(v, io, data, 1 << v->data_dev_block_bits,
-				 verity_io_real_digest(v, io), true)))
+				 io->tmp_digest, true)))
 		return 0;
 
-	return memcmp(verity_io_real_digest(v, io), want_digest,
-		      v->digest_size) != 0;
+	return memcmp(io->tmp_digest, want_digest, v->digest_size) != 0;
 }
 
 /*
  * Read data blocks that are part of the RS block and deinterleave as much as
  * fits into buffers. Check for erasure locations if @neras is non-NULL.
@@ -364,11 +363,11 @@ static void fec_init_bufs(struct dm_verity *v, struct dm_verity_fec_io *fio)
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
 
 	r = fec_alloc_bufs(v, fio);
@@ -390,27 +389,27 @@ static int fec_decode_rsb(struct dm_verity *v, struct dm_verity_io *io,
 		pos += fio->nbufs << DM_VERITY_FEC_BUF_RS_BITS;
 	}
 
 	/* Always re-validate the corrected block against the expected hash */
 	r = verity_hash(v, io, fio->output, 1 << v->data_dev_block_bits,
-			verity_io_real_digest(v, io), true);
+			io->tmp_digest, true);
 	if (unlikely(r < 0))
 		return r;
 
-	if (memcmp(verity_io_real_digest(v, io), verity_io_want_digest(v, io),
-		   v->digest_size)) {
+	if (memcmp(io->tmp_digest, want_digest, v->digest_size)) {
 		DMERR_LIMIT("%s: FEC %llu: failed to correct (%d erasures)",
 			    v->data_dev->name, (unsigned long long)rsb, neras);
 		return -EILSEQ;
 	}
 
 	return 0;
 }
 
 /* Correct errors in a block. Copies corrected block to dest. */
 int verity_fec_decode(struct dm_verity *v, struct dm_verity_io *io,
-		      enum verity_block_type type, sector_t block, u8 *dest)
+		      enum verity_block_type type, const u8 *want_digest,
+		      sector_t block, u8 *dest)
 {
 	int r;
 	struct dm_verity_fec_io *fio = fec_io(io);
 	u64 offset, res, rsb;
 
@@ -449,13 +448,13 @@ int verity_fec_decode(struct dm_verity *v, struct dm_verity_io *io,
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
 
 	memcpy(dest, fio->output, 1 << v->data_dev_block_bits);
diff --git a/drivers/md/dm-verity-fec.h b/drivers/md/dm-verity-fec.h
index 09123a6129538..a6689cdc489db 100644
--- a/drivers/md/dm-verity-fec.h
+++ b/drivers/md/dm-verity-fec.h
@@ -66,12 +66,12 @@ struct dm_verity_fec_io {
 #define DM_VERITY_OPTS_FEC	8
 
 extern bool verity_fec_is_enabled(struct dm_verity *v);
 
 extern int verity_fec_decode(struct dm_verity *v, struct dm_verity_io *io,
-			     enum verity_block_type type, sector_t block,
-			     u8 *dest);
+			     enum verity_block_type type, const u8 *want_digest,
+			     sector_t block, u8 *dest);
 
 extern unsigned int verity_fec_status_table(struct dm_verity *v, unsigned int sz,
 					char *result, unsigned int maxlen);
 
 extern void verity_fec_finish_io(struct dm_verity_io *io);
@@ -97,10 +97,11 @@ static inline bool verity_fec_is_enabled(struct dm_verity *v)
 }
 
 static inline int verity_fec_decode(struct dm_verity *v,
 				    struct dm_verity_io *io,
 				    enum verity_block_type type,
+				    const u8 *want_digest,
 				    sector_t block, u8 *dest)
 {
 	return -EOPNOTSUPP;
 }
 
diff --git a/drivers/md/dm-verity-target.c b/drivers/md/dm-verity-target.c
index e86c1431b108f..f7c9edbb1a575 100644
--- a/drivers/md/dm-verity-target.c
+++ b/drivers/md/dm-verity-target.c
@@ -286,16 +286,16 @@ static int verity_handle_err(struct dm_verity *v, enum verity_block_type type,
 
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
@@ -334,26 +334,26 @@ static int verity_verify_level(struct dm_verity *v, struct dm_verity_io *io,
 			r = 1;
 			goto release_ret_r;
 		}
 
 		r = verity_hash(v, io, data, 1 << v->hash_dev_block_bits,
-				verity_io_real_digest(v, io), !io->in_bh);
+				io->tmp_digest, !io->in_bh);
 		if (unlikely(r < 0))
 			goto release_ret_r;
 
-		if (likely(memcmp(verity_io_real_digest(v, io), want_digest,
+		if (likely(memcmp(io->tmp_digest, want_digest,
 				  v->digest_size) == 0))
 			aux->hash_verified = 1;
 		else if (static_branch_unlikely(&use_bh_wq_enabled) && io->in_bh) {
 			/*
 			 * Error handling code (FEC included) cannot be run in a
 			 * tasklet since it may sleep, so fallback to work-queue.
 			 */
 			r = -EAGAIN;
 			goto release_ret_r;
 		} else if (verity_fec_decode(v, io, DM_VERITY_BLOCK_TYPE_METADATA,
-					     hash_block, data) == 0)
+					     want_digest, hash_block, data) == 0)
 			aux->hash_verified = 1;
 		else if (verity_handle_err(v,
 					   DM_VERITY_BLOCK_TYPE_METADATA,
 					   hash_block)) {
 			struct bio *bio;
@@ -412,11 +412,12 @@ int verity_hash_for_block(struct dm_verity *v, struct dm_verity_io *io,
 
 	return r;
 }
 
 static noinline int verity_recheck(struct dm_verity *v, struct dm_verity_io *io,
-				   sector_t cur_block, u8 *dest)
+				   const u8 *want_digest, sector_t cur_block,
+				   u8 *dest)
 {
 	struct page *page;
 	void *buffer;
 	int r;
 	struct dm_io_request io_req;
@@ -436,16 +437,15 @@ static noinline int verity_recheck(struct dm_verity *v, struct dm_verity_io *io,
 	r = dm_io(&io_req, 1, &io_loc, NULL, IOPRIO_DEFAULT);
 	if (unlikely(r))
 		goto free_ret;
 
 	r = verity_hash(v, io, buffer, 1 << v->data_dev_block_bits,
-			verity_io_real_digest(v, io), true);
+			io->tmp_digest, true);
 	if (unlikely(r))
 		goto free_ret;
 
-	if (memcmp(verity_io_real_digest(v, io),
-		   verity_io_want_digest(v, io), v->digest_size)) {
+	if (memcmp(io->tmp_digest, want_digest, v->digest_size)) {
 		r = -EIO;
 		goto free_ret;
 	}
 
 	memcpy(dest, buffer, 1 << v->data_dev_block_bits);
@@ -456,28 +456,29 @@ static noinline int verity_recheck(struct dm_verity *v, struct dm_verity_io *io,
 	return r;
 }
 
 static int verity_handle_data_hash_mismatch(struct dm_verity *v,
 					    struct dm_verity_io *io,
-					    struct bio *bio, sector_t blkno,
-					    u8 *data)
+					    struct bio *bio,
+					    const u8 *want_digest,
+					    sector_t blkno, u8 *data)
 {
 	if (static_branch_unlikely(&use_bh_wq_enabled) && io->in_bh) {
 		/*
 		 * Error handling code (FEC included) cannot be run in the
 		 * BH workqueue, so fallback to a standard workqueue.
 		 */
 		return -EAGAIN;
 	}
-	if (verity_recheck(v, io, blkno, data) == 0) {
+	if (verity_recheck(v, io, want_digest, blkno, data) == 0) {
 		if (v->validated_blocks)
 			set_bit(blkno, v->validated_blocks);
 		return 0;
 	}
 #if defined(CONFIG_DM_VERITY_FEC)
-	if (verity_fec_decode(v, io, DM_VERITY_BLOCK_TYPE_DATA, blkno,
-			      data) == 0)
+	if (verity_fec_decode(v, io, DM_VERITY_BLOCK_TYPE_DATA, want_digest,
+			      blkno, data) == 0)
 		return 0;
 #endif
 	if (bio->bi_status)
 		return -EIO; /* Error correction failed; Just return error */
 
@@ -565,12 +566,13 @@ static int verity_verify_io(struct dm_verity_io *io)
 			if (v->validated_blocks)
 				set_bit(cur_block, v->validated_blocks);
 			kunmap_local(data);
 			continue;
 		}
-		r = verity_handle_data_hash_mismatch(v, io, bio, cur_block,
-						     data);
+		r = verity_handle_data_hash_mismatch(v, io, bio,
+						     verity_io_want_digest(v, io),
+						     cur_block, data);
 		kunmap_local(data);
 		if (unlikely(r))
 			return r;
 	}
 
diff --git a/drivers/md/dm-verity.h b/drivers/md/dm-verity.h
index 8cbb57862ae19..17d1d271e076a 100644
--- a/drivers/md/dm-verity.h
+++ b/drivers/md/dm-verity.h
@@ -94,10 +94,11 @@ struct dm_verity_io {
 	bool had_mismatch;
 
 	struct work_struct work;
 	struct work_struct bh_work;
 
+	u8 tmp_digest[HASH_MAX_DIGESTSIZE];
 	u8 real_digest[HASH_MAX_DIGESTSIZE];
 	u8 want_digest[HASH_MAX_DIGESTSIZE];
 
 	/*
 	 * This struct is followed by a variable-sized hash request of size
-- 
2.48.1


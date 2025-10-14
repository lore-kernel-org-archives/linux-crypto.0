Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F55730DD2D;
	Tue, 14 Oct 2025 21:17:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760476629; cv=none; b=o+r6pL09oloKT2pcTlYfyr2/dL5Zvb94NunWkN03EFVhftLaDrfs6/WG55Hy7iGHKFcVGwVWzo0ldALhH8zQVRySK801k8gErJr87Ni1ejTnr9HQ4ZC1CwnCYtIv+r2VUSVl0DcoTdx9reWwQ2SL+NkHajTlyR+U2ApZIzcLawc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760476629; c=relaxed/simple;
	bh=/TaMyu5mhL4eunfPi8oKYPCNqauO86fOaF1faU2YeqY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GZILQsxxWjU12RW9jpG33Kd3j4PlglwXXO0j66B8WHxV7dJEjBMiCCk4akYmANz2ZyNG1fJxiekMVAECpDtSxMcPmRHrwQec7xsZJBS9QmW67amHT8L9Iaxf1FMOkVbqAUhk0TPk1qBwz8QXIHnhe9tfjC7jUK7NKI7OBAURRIM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=rG1lQ7Ez; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="rG1lQ7Ez"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 72DC4C19421;
	Tue, 14 Oct 2025 21:17:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1760476627;
	bh=/TaMyu5mhL4eunfPi8oKYPCNqauO86fOaF1faU2YeqY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rG1lQ7EzxWWf1c4mIVxguslNvogLJFZQ3+j2soeftimw25j+XSOiKobIudY61RIwu
	 aLrmGMLmrVTs90T/l23pBxmRo/hMyhyq78mBvkDPYrCb+XX4JC9sIRTlS57zV2nlV4
	 78csn0CFuxrhfvCxsILb6xwrHhqO9XYACzopa4BEKsjBzquydsPhn/BTydGl0S3Rmt
	 MLj9/Pp81mlDmcCqIT5bhAsF1yRswj08D135RES8gIlPVvirvfjFBxawvxwbGIThyI
	 9+Pv3wULR5OKmkUr01e8KRL6jEKZE46Rp7qwj9QKtS210pGdVBl8ZQy9DvQnlqZFp6
	 BZkSHK0kKWvug==
From: Eric Biggers <ebiggers@kernel.org>
To: dm-devel@lists.linux.dev,
	Alasdair Kergon <agk@redhat.com>,
	Mike Snitzer <snitzer@kernel.org>,
	Mikulas Patocka <mpatocka@redhat.com>
Cc: linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Eric Biggers <ebiggers@kernel.org>
Subject: [PATCH 3/4] dm-verity: reduce scope of real and wanted digests
Date: Tue, 14 Oct 2025 14:16:56 -0700
Message-ID: <20251014211657.113603-4-ebiggers@kernel.org>
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

In preparation for supporting interleaved hashing where dm-verity will
need to keep track of the real and wanted digests for multiple data
blocks simultaneously, stop using the want_digest and real_digest fields
of struct dm_verity_io from so many different places.  Specifically:

- Make various functions take want_digest as a parameter rather than
  having it be implicitly passed via the struct dm_verity_io.

- Add a new tmp_digest field, and use this instead of real_digest when
  computing a digest solely for the purpose of immediately checking it.

The result is that real_digest and want_digest are used only by
verity_verify_io().

Signed-off-by: Eric Biggers <ebiggers@kernel.org>
---
 drivers/md/dm-verity-fec.c    | 21 +++++++++----------
 drivers/md/dm-verity-fec.h    |  5 +++--
 drivers/md/dm-verity-target.c | 38 ++++++++++++++++++-----------------
 drivers/md/dm-verity.h        |  1 +
 4 files changed, 34 insertions(+), 31 deletions(-)

diff --git a/drivers/md/dm-verity-fec.c b/drivers/md/dm-verity-fec.c
index d382a390d39ab..301a9c01bf865 100644
--- a/drivers/md/dm-verity-fec.c
+++ b/drivers/md/dm-verity-fec.c
@@ -186,18 +186,17 @@ static int fec_decode_bufs(struct dm_verity *v, struct dm_verity_io *io,
 
 /*
  * Locate data block erasures using verity hashes.
  */
 static int fec_is_erasure(struct dm_verity *v, struct dm_verity_io *io,
-			  u8 *want_digest, u8 *data)
+			  const u8 *want_digest, const u8 *data)
 {
 	if (unlikely(verity_hash(v, io, data, 1 << v->data_dev_block_bits,
-				 verity_io_real_digest(v, io))))
+				 io->tmp_digest)))
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
-			verity_io_real_digest(v, io));
+			io->tmp_digest);
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
index bba9810805631..af9f1544af3ea 100644
--- a/drivers/md/dm-verity-target.c
+++ b/drivers/md/dm-verity-target.c
@@ -227,16 +227,16 @@ static int verity_handle_err(struct dm_verity *v, enum verity_block_type type,
 
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
@@ -271,11 +271,11 @@ static int verity_verify_level(struct dm_verity *v, struct dm_verity_io *io,
 		r = PTR_ERR(data);
 		data = dm_bufio_new(v->bufio, hash_block, &buf);
 		if (IS_ERR(data))
 			return r;
 		if (verity_fec_decode(v, io, DM_VERITY_BLOCK_TYPE_METADATA,
-				      hash_block, data) == 0) {
+				      want_digest, hash_block, data) == 0) {
 			aux = dm_bufio_get_aux_data(buf);
 			aux->hash_verified = 1;
 			goto release_ok;
 		} else {
 			dm_bufio_release(buf);
@@ -291,26 +291,26 @@ static int verity_verify_level(struct dm_verity *v, struct dm_verity_io *io,
 			r = 1;
 			goto release_ret_r;
 		}
 
 		r = verity_hash(v, io, data, 1 << v->hash_dev_block_bits,
-				verity_io_real_digest(v, io));
+				io->tmp_digest);
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
@@ -370,11 +370,12 @@ int verity_hash_for_block(struct dm_verity *v, struct dm_verity_io *io,
 
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
@@ -394,16 +395,15 @@ static noinline int verity_recheck(struct dm_verity *v, struct dm_verity_io *io,
 	r = dm_io(&io_req, 1, &io_loc, NULL, IOPRIO_DEFAULT);
 	if (unlikely(r))
 		goto free_ret;
 
 	r = verity_hash(v, io, buffer, 1 << v->data_dev_block_bits,
-			verity_io_real_digest(v, io));
+			io->tmp_digest);
 	if (unlikely(r))
 		goto free_ret;
 
-	if (memcmp(verity_io_real_digest(v, io),
-		   verity_io_want_digest(v, io), v->digest_size)) {
+	if (memcmp(io->tmp_digest, want_digest, v->digest_size)) {
 		r = -EIO;
 		goto free_ret;
 	}
 
 	memcpy(dest, buffer, 1 << v->data_dev_block_bits);
@@ -414,28 +414,29 @@ static noinline int verity_recheck(struct dm_verity *v, struct dm_verity_io *io,
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
 
@@ -523,12 +524,13 @@ static int verity_verify_io(struct dm_verity_io *io)
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
index cdcee68a4bc0a..cf7973ed30596 100644
--- a/drivers/md/dm-verity.h
+++ b/drivers/md/dm-verity.h
@@ -97,10 +97,11 @@ struct dm_verity_io {
 	bool had_mismatch;
 
 	struct work_struct work;
 	struct work_struct bh_work;
 
+	u8 tmp_digest[HASH_MAX_DIGESTSIZE];
 	u8 real_digest[HASH_MAX_DIGESTSIZE];
 	u8 want_digest[HASH_MAX_DIGESTSIZE];
 
 	/*
 	 * Temporary space for hashing.  Either sha256 or shash is used,
-- 
2.51.0


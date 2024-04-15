Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 86024158871;
	Mon, 15 Apr 2024 21:38:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713217131; cv=none; b=NBWNrNHmE6XdZrtNJK3Vv1qICmfHepk3xipCe7jKra6Og62nIsbbtOraK3Voo9fDAq9Pn2iqpS/ohNWZ2kXOj3iTzx4lYZtE+yC8aR7YIowBFIuVaUsfnrfIxUvoYRLVf3I5iuvyGg3hDEyJ5wN4DRWhtwoHFJ6hWwVhcwHZieU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713217131; c=relaxed/simple;
	bh=Lmr7ntSF7F2Uq9SDrut1jIQ5oTs6nnvHinkQVqQx9/4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kKC01dSf3/5/3TSqDY0174/WPrIace1PO8lTwMJlDqFbmxyyYsjIhI+XrWB03+NTUqxCNMAzilrpNFIEOMhQmxooHmGKI5OfQtaWHYSdk271TReyTeM/qMRLTfSdyU3akRvsssyL8wRL4TBEYPAK/w+RQ9BUGV3w5WDCCyAjC10=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=lJUtoVdN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="lJUtoVdN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 26F60C113CC;
	Mon, 15 Apr 2024 21:38:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1713217131;
	bh=Lmr7ntSF7F2Uq9SDrut1jIQ5oTs6nnvHinkQVqQx9/4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lJUtoVdNghIWs3U2FYutWsvpr4y0DVGwUt/XRPy3TOowyBDiy+9ikK6UYn/w8jJXY
	 w8rSTbsDCfxWgaR5N69mjfjtiiNtqgoPrvmXOOhC7LU2zl0A0c1lAu3474eG0qN5El
	 9+kHhVPo0GBLzn2NlK7CFE8Znm05f/TcNzslObN88neHjfnRFY6C2GzIxBgm9srd9U
	 tkmuv00fcThtGWxrOvPVNroySPcJCMnM3z/GuJHAwgJmAHXxAUICcTzD2f5aVEs/Rr
	 o6iM5FFcbPeIKKixLKjJRRK5dQdz9V5H0IoNmO2TRQ7u8WrlOrETsC5IBqddxT9Qo0
	 HGm5lnV9JGwHQ==
From: Eric Biggers <ebiggers@kernel.org>
To: linux-crypto@vger.kernel.org,
	fsverity@lists.linux.dev,
	dm-devel@lists.linux.dev
Cc: x86@kernel.org,
	linux-arm-kernel@lists.infradead.org,
	Ard Biesheuvel <ardb@kernel.org>,
	Sami Tolvanen <samitolvanen@google.com>,
	Bart Van Assche <bvanassche@acm.org>
Subject: [RFC PATCH 7/8] dm-verity: hash blocks with shash import+finup when possible
Date: Mon, 15 Apr 2024 14:37:18 -0700
Message-ID: <20240415213719.120673-8-ebiggers@kernel.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240415213719.120673-1-ebiggers@kernel.org>
References: <20240415213719.120673-1-ebiggers@kernel.org>
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
  experiences the overhead of the ahash-based wrapper for shash.  This
  also means that the new function crypto_shash_finup2x(), which is
  specifically designed for fast CPU-based hashing, is unavailable.

  Since dm-verity was intentionally converted to ahash to support
  off-CPU crypto accelerators, wholesale conversion to shash (reverting
  that change) might not be acceptable.  Yet, we should still provide a
  fast path for shash with the most common dm-verity settings.

Therefore, this patch adds a new shash import+finup based fast path to
dm-verity.  It is used automatically when appropriate, i.e. when the
ahash API and shash APIs resolve to the same underlying algorithm, the
dm-verity version is not 0 (so that the salt is hashed before the data),
and the data block size is not greater than the page size.

This makes dm-verity optimized for what the vast majority of users want:
CPU-based hashing with the most common settings, while still retaining
support for rarer settings and off-CPU crypto accelerators.

In benchmarks with veritysetup's default parameters (SHA-256, 4K data
and hash block sizes, 32-byte salt), which also match the parameters
that Android currently uses, this patch improves block hashing
performance by about 15% on an x86_64 system that supports the SHA-NI
instructions, or by about 5% on an arm64 system that supports the ARMv8
SHA2 instructions.  This was with CONFIG_CRYPTO_STATS disabled; an even
larger improvement can be expected if that option is enabled.

Note that another benefit of using "import" to handle the salt is that
if the salt size is equal to the input size of the hash algorithm's
compression function, e.g. 64 bytes for SHA-256, then the performance is
exactly the same as no salt.  (This doesn't seem to be much better than
veritysetup's current default of 32-byte salts, due to the way SHA-256's
finalization padding works, but it should be marginally better.)

In addition to the benchmarks mentioned above, I've tested this patch
with cryptsetup's 'verity-compat-test' script.  I've also lightly tested
this patch with Android, where the new shash-based code gets used.

Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 drivers/md/dm-verity-fec.c    |  13 +-
 drivers/md/dm-verity-target.c | 336 ++++++++++++++++++++++++----------
 drivers/md/dm-verity.h        |  27 ++-
 3 files changed, 263 insertions(+), 113 deletions(-)

diff --git a/drivers/md/dm-verity-fec.c b/drivers/md/dm-verity-fec.c
index e46aee6f932ee..b436b8e4d7507 100644
--- a/drivers/md/dm-verity-fec.c
+++ b/drivers/md/dm-verity-fec.c
@@ -184,13 +184,14 @@ static int fec_decode_bufs(struct dm_verity *v, struct dm_verity_io *io,
  * Locate data block erasures using verity hashes.
  */
 static int fec_is_erasure(struct dm_verity *v, struct dm_verity_io *io,
 			  u8 *want_digest, u8 *data)
 {
-	if (unlikely(verity_hash(v, verity_io_hash_req(v, io),
-				 data, 1 << v->data_dev_block_bits,
-				 verity_io_real_digest(v, io), true)))
+	if (unlikely(verity_compute_hash_virt(v, io, data,
+					      1 << v->data_dev_block_bits,
+					      verity_io_real_digest(v, io),
+					      true)))
 		return 0;
 
 	return memcmp(verity_io_real_digest(v, io), want_digest,
 		      v->digest_size) != 0;
 }
@@ -386,13 +387,13 @@ static int fec_decode_rsb(struct dm_verity *v, struct dm_verity_io *io,
 
 		pos += fio->nbufs << DM_VERITY_FEC_BUF_RS_BITS;
 	}
 
 	/* Always re-validate the corrected block against the expected hash */
-	r = verity_hash(v, verity_io_hash_req(v, io), fio->output,
-			1 << v->data_dev_block_bits,
-			verity_io_real_digest(v, io), true);
+	r = verity_compute_hash_virt(v, io, fio->output,
+				     1 << v->data_dev_block_bits,
+				     verity_io_real_digest(v, io), true);
 	if (unlikely(r < 0))
 		return r;
 
 	if (memcmp(verity_io_real_digest(v, io), verity_io_want_digest(v, io),
 		   v->digest_size)) {
diff --git a/drivers/md/dm-verity-target.c b/drivers/md/dm-verity-target.c
index bb5da66da4c17..2dd15f5e91b7d 100644
--- a/drivers/md/dm-verity-target.c
+++ b/drivers/md/dm-verity-target.c
@@ -44,12 +44,16 @@
 
 static unsigned int dm_verity_prefetch_cluster = DM_VERITY_DEFAULT_PREFETCH_SIZE;
 
 module_param_named(prefetch_cluster, dm_verity_prefetch_cluster, uint, 0644);
 
+/* Is at least one dm-verity instance using the bh workqueue? */
 static DEFINE_STATIC_KEY_FALSE(use_bh_wq_enabled);
 
+/* Is at least one dm-verity instance using ahash_tfm instead of shash_tfm? */
+static DEFINE_STATIC_KEY_FALSE(ahash_enabled);
+
 struct dm_verity_prefetch_work {
 	struct work_struct work;
 	struct dm_verity *v;
 	unsigned short ioprio;
 	sector_t block;
@@ -100,13 +104,13 @@ static sector_t verity_position_at_level(struct dm_verity *v, sector_t block,
 					 int level)
 {
 	return block >> (level * v->hash_per_block_bits);
 }
 
-static int verity_hash_update(struct dm_verity *v, struct ahash_request *req,
-				const u8 *data, size_t len,
-				struct crypto_wait *wait)
+static int verity_ahash_update(struct dm_verity *v, struct ahash_request *req,
+			       const u8 *data, size_t len,
+			       struct crypto_wait *wait)
 {
 	struct scatterlist sg;
 
 	if (likely(!is_vmalloc_addr(data))) {
 		sg_init_one(&sg, data, len);
@@ -133,16 +137,16 @@ static int verity_hash_update(struct dm_verity *v, struct ahash_request *req,
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
 
@@ -153,22 +157,22 @@ static int verity_hash_init(struct dm_verity *v, struct ahash_request *req,
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
@@ -178,27 +182,47 @@ static int verity_hash_final(struct dm_verity *v, struct ahash_request *req,
 	r = crypto_wait_req(crypto_ahash_final(req), wait);
 out:
 	return r;
 }
 
-int verity_hash(struct dm_verity *v, struct ahash_request *req,
-		const u8 *data, size_t len, u8 *digest, bool may_sleep)
+int verity_compute_hash_virt(struct dm_verity *v, struct dm_verity_io *io,
+			     const u8 *data, size_t len, u8 *digest,
+			     bool may_sleep)
 {
 	int r;
-	struct crypto_wait wait;
 
-	r = verity_hash_init(v, req, &wait, may_sleep);
-	if (unlikely(r < 0))
-		goto out;
+	if (static_branch_unlikely(&ahash_enabled) && !v->shash_tfm) {
+		struct ahash_request *req = verity_io_hash_req(v, io);
+		struct crypto_wait wait;
 
-	r = verity_hash_update(v, req, data, len, &wait);
-	if (unlikely(r < 0))
-		goto out;
+		r = verity_ahash_init(v, req, &wait, may_sleep);
+		if (unlikely(r))
+			goto error;
 
-	r = verity_hash_final(v, req, digest, &wait);
+		r = verity_ahash_update(v, req, data, len, &wait);
+		if (unlikely(r))
+			goto error;
 
-out:
+		r = verity_ahash_final(v, req, digest, &wait);
+		if (unlikely(r))
+			goto error;
+	} else {
+		struct shash_desc *desc = verity_io_hash_req(v, io);
+
+		desc->tfm = v->shash_tfm;
+		r = crypto_shash_import(desc, v->initial_hashstate);
+		if (unlikely(r))
+			goto error;
+
+		r = crypto_shash_finup(desc, data, len, digest);
+		if (unlikely(r))
+			goto error;
+	}
+	return 0;
+
+error:
+	DMERR("Error hashing block from virt buffer: %d", r);
 	return r;
 }
 
 static void verity_hash_at_level(struct dm_verity *v, sector_t block, int level,
 				 sector_t *hash_block, unsigned int *offset)
@@ -323,13 +347,14 @@ static int verity_verify_level(struct dm_verity *v, struct dm_verity_io *io,
 		if (skip_unverified) {
 			r = 1;
 			goto release_ret_r;
 		}
 
-		r = verity_hash(v, verity_io_hash_req(v, io),
-				data, 1 << v->hash_dev_block_bits,
-				verity_io_real_digest(v, io), !io->in_bh);
+		r = verity_compute_hash_virt(v, io, data,
+					     1 << v->hash_dev_block_bits,
+					     verity_io_real_digest(v, io),
+					     !io->in_bh);
 		if (unlikely(r < 0))
 			goto release_ret_r;
 
 		if (likely(memcmp(verity_io_real_digest(v, io), want_digest,
 				  v->digest_size) == 0))
@@ -403,14 +428,17 @@ int verity_hash_for_block(struct dm_verity *v, struct dm_verity_io *io,
 
 	return r;
 }
 
 /*
- * Calculates the digest for the given bio
+ * Update the ahash_request of @io with the next data block from @iter, and
+ * advance @iter accordingly.
  */
-static int verity_for_io_block(struct dm_verity *v, struct dm_verity_io *io,
-			       struct bvec_iter *iter, struct crypto_wait *wait)
+static int verity_ahash_update_block(struct dm_verity *v,
+				     struct dm_verity_io *io,
+				     struct bvec_iter *iter,
+				     struct crypto_wait *wait)
 {
 	unsigned int todo = 1 << v->data_dev_block_bits;
 	struct bio *bio = dm_bio_from_per_bio_data(io, v->ti->per_io_data_size);
 	struct scatterlist sg;
 	struct ahash_request *req = verity_io_hash_req(v, io);
@@ -445,10 +473,71 @@ static int verity_for_io_block(struct dm_verity *v, struct dm_verity_io *io,
 	} while (todo);
 
 	return 0;
 }
 
+static int verity_compute_hash(struct dm_verity *v, struct dm_verity_io *io,
+			       struct bvec_iter *iter, u8 *digest,
+			       bool may_sleep)
+{
+	int r;
+
+	if (static_branch_unlikely(&ahash_enabled) && !v->shash_tfm) {
+		struct ahash_request *req = verity_io_hash_req(v, io);
+		struct crypto_wait wait;
+
+		r = verity_ahash_init(v, req, &wait, may_sleep);
+		if (unlikely(r))
+			goto error;
+
+		r = verity_ahash_update_block(v, io, iter, &wait);
+		if (unlikely(r))
+			goto error;
+
+		r = verity_ahash_final(v, req, digest, &wait);
+		if (unlikely(r))
+			goto error;
+	} else {
+		struct shash_desc *desc = verity_io_hash_req(v, io);
+		struct bio *bio =
+			dm_bio_from_per_bio_data(io, v->ti->per_io_data_size);
+		struct bio_vec bv = bio_iter_iovec(bio, *iter);
+		const unsigned int len = 1 << v->data_dev_block_bits;
+		const void *virt;
+
+		if (unlikely(len > bv.bv_len)) {
+			/*
+			 * Data block spans pages.  This should not happen,
+			 * since this code path is not used if the data block
+			 * size is greater than the page size, and all I/O
+			 * should be data block aligned because dm-verity sets
+			 * logical_block_size to the data block size.
+			 */
+			DMERR_LIMIT("unaligned io (data block spans pages)");
+			return -EIO;
+		}
+
+		desc->tfm = v->shash_tfm;
+		r = crypto_shash_import(desc, v->initial_hashstate);
+		if (unlikely(r))
+			goto error;
+
+		virt = bvec_kmap_local(&bv);
+		r = crypto_shash_finup(desc, virt, len, digest);
+		kunmap_local(virt);
+		if (unlikely(r))
+			goto error;
+
+		bio_advance_iter(bio, iter, len);
+	}
+	return 0;
+
+error:
+	DMERR("Error hashing block from bio iter: %d", r);
+	return r;
+}
+
 /*
  * Calls function process for 1 << v->data_dev_block_bits bytes in the bio_vec
  * starting from iter.
  */
 int verity_for_bv_block(struct dm_verity *v, struct dm_verity_io *io,
@@ -516,13 +605,12 @@ static noinline int verity_recheck(struct dm_verity *v, struct dm_verity_io *io,
 	io_loc.count = 1 << (v->data_dev_block_bits - SECTOR_SHIFT);
 	r = dm_io(&io_req, 1, &io_loc, NULL, IOPRIO_DEFAULT);
 	if (unlikely(r))
 		goto free_ret;
 
-	r = verity_hash(v, verity_io_hash_req(v, io), buffer,
-			1 << v->data_dev_block_bits,
-			verity_io_real_digest(v, io), true);
+	r = verity_compute_hash_virt(v, io, buffer, 1 << v->data_dev_block_bits,
+				     verity_io_real_digest(v, io), true);
 	if (unlikely(r))
 		goto free_ret;
 
 	if (memcmp(verity_io_real_digest(v, io),
 		   verity_io_want_digest(v, io), v->digest_size)) {
@@ -569,11 +657,10 @@ static int verity_verify_io(struct dm_verity_io *io)
 	bool is_zero;
 	struct dm_verity *v = io->v;
 	struct bvec_iter start;
 	struct bvec_iter iter_copy;
 	struct bvec_iter *iter;
-	struct crypto_wait wait;
 	struct bio *bio = dm_bio_from_per_bio_data(io, v->ti->per_io_data_size);
 	unsigned int b;
 
 	if (static_branch_unlikely(&use_bh_wq_enabled) && io->in_bh) {
 		/*
@@ -586,11 +673,10 @@ static int verity_verify_io(struct dm_verity_io *io)
 		iter = &io->iter;
 
 	for (b = 0; b < io->n_blocks; b++) {
 		int r;
 		sector_t cur_block = io->block + b;
-		struct ahash_request *req = verity_io_hash_req(v, io);
 
 		if (v->validated_blocks && bio->bi_status == BLK_STS_OK &&
 		    likely(test_bit(cur_block, v->validated_blocks))) {
 			verity_bv_skip_block(v, io, iter);
 			continue;
@@ -613,21 +699,14 @@ static int verity_verify_io(struct dm_verity_io *io)
 				return r;
 
 			continue;
 		}
 
-		r = verity_hash_init(v, req, &wait, !io->in_bh);
-		if (unlikely(r < 0))
-			return r;
-
 		start = *iter;
-		r = verity_for_io_block(v, io, iter, &wait);
-		if (unlikely(r < 0))
-			return r;
-
-		r = verity_hash_final(v, req, verity_io_real_digest(v, io),
-					&wait);
+		r = verity_compute_hash(v, io, iter,
+					verity_io_real_digest(v, io),
+					!io->in_bh);
 		if (unlikely(r < 0))
 			return r;
 
 		if (likely(memcmp(verity_io_real_digest(v, io),
 				  verity_io_want_digest(v, io), v->digest_size) == 0)) {
@@ -1031,15 +1110,20 @@ static void verity_dtr(struct dm_target *ti)
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
@@ -1081,33 +1165,33 @@ static int verity_alloc_most_once(struct dm_verity *v)
 }
 
 static int verity_alloc_zero_digest(struct dm_verity *v)
 {
 	int r = -ENOMEM;
-	struct ahash_request *req;
+	struct dm_verity_io *io;
 	u8 *zero_data;
 
 	v->zero_digest = kmalloc(v->digest_size, GFP_KERNEL);
 
 	if (!v->zero_digest)
 		return r;
 
-	req = kmalloc(v->ahash_reqsize, GFP_KERNEL);
+	io = kmalloc(sizeof(*io) + v->hash_reqsize, GFP_KERNEL);
 
-	if (!req)
+	if (!io)
 		return r; /* verity_dtr will free zero_digest */
 
 	zero_data = kzalloc(1 << v->data_dev_block_bits, GFP_KERNEL);
 
 	if (!zero_data)
 		goto out;
 
-	r = verity_hash(v, req, zero_data, 1 << v->data_dev_block_bits,
-			v->zero_digest, true);
-
+	r = verity_compute_hash_virt(v, io, zero_data,
+				     1 << v->data_dev_block_bits,
+				     v->zero_digest, true);
 out:
-	kfree(req);
+	kfree(io);
 	kfree(zero_data);
 
 	return r;
 }
 
@@ -1224,10 +1308,109 @@ static int verity_parse_opt_args(struct dm_arg_set *as, struct dm_verity *v,
 	} while (argc && !r);
 
 	return r;
 }
 
+static int verity_setup_hash_alg(struct dm_verity *v, const char *alg_name)
+{
+	struct dm_target *ti = v->ti;
+	struct crypto_ahash *ahash;
+	struct crypto_shash *shash = NULL;
+	const char *driver_name;
+
+	v->alg_name = kstrdup(alg_name, GFP_KERNEL);
+	if (!v->alg_name) {
+		ti->error = "Cannot allocate algorithm name";
+		return -ENOMEM;
+	}
+
+	ahash = crypto_alloc_ahash(alg_name, 0,
+				   v->use_bh_wq ? CRYPTO_ALG_ASYNC : 0);
+	if (IS_ERR(ahash)) {
+		ti->error = "Cannot initialize hash function";
+		return PTR_ERR(ahash);
+	}
+	driver_name = crypto_ahash_driver_name(ahash);
+	if (v->version >= 1 /* salt prepended, not appended? */ &&
+	    1 << v->data_dev_block_bits <= PAGE_SIZE) {
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
+	if ((1 << v->hash_dev_block_bits) < v->digest_size * 2) {
+		ti->error = "Digest size too big";
+		return -EINVAL;
+	}
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
+	/*
+	 * If the "shash with import+finup sequence" method has been selected
+	 * (see verity_setup_hash_alg()), then create the initial hash state.
+	 */
+	if (v->shash_tfm) {
+		SHASH_DESC_ON_STACK(desc, v->shash_tfm);
+		int r;
+
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
+	return 0;
+}
+
 /*
  * Target parameters:
  *	<version>	The current format is version 1.
  *			Vsn 0 is compatible with original Chromium OS releases.
  *	<data device>
@@ -1348,42 +1531,13 @@ static int verity_ctr(struct dm_target *ti, unsigned int argc, char **argv)
 		r = -EINVAL;
 		goto bad;
 	}
 	v->hash_start = num_ll;
 
-	v->alg_name = kstrdup(argv[7], GFP_KERNEL);
-	if (!v->alg_name) {
-		ti->error = "Cannot allocate algorithm name";
-		r = -ENOMEM;
-		goto bad;
-	}
-
-	v->tfm = crypto_alloc_ahash(v->alg_name, 0,
-				    v->use_bh_wq ? CRYPTO_ALG_ASYNC : 0);
-	if (IS_ERR(v->tfm)) {
-		ti->error = "Cannot initialize hash function";
-		r = PTR_ERR(v->tfm);
-		v->tfm = NULL;
-		goto bad;
-	}
-
-	/*
-	 * dm-verity performance can vary greatly depending on which hash
-	 * algorithm implementation is used.  Help people debug performance
-	 * problems by logging the ->cra_driver_name.
-	 */
-	DMINFO("%s using implementation \"%s\"", v->alg_name,
-	       crypto_hash_alg_common(v->tfm)->base.cra_driver_name);
-
-	v->digest_size = crypto_ahash_digestsize(v->tfm);
-	if ((1 << v->hash_dev_block_bits) < v->digest_size * 2) {
-		ti->error = "Digest size too big";
-		r = -EINVAL;
+	r = verity_setup_hash_alg(v, argv[7]);
+	if (r)
 		goto bad;
-	}
-	v->ahash_reqsize = sizeof(struct ahash_request) +
-		crypto_ahash_reqsize(v->tfm);
 
 	v->root_digest = kmalloc(v->digest_size, GFP_KERNEL);
 	if (!v->root_digest) {
 		ti->error = "Cannot allocate root digest";
 		r = -ENOMEM;
@@ -1395,25 +1549,13 @@ static int verity_ctr(struct dm_target *ti, unsigned int argc, char **argv)
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
@@ -1512,11 +1654,11 @@ static int verity_ctr(struct dm_target *ti, unsigned int argc, char **argv)
 		r = -ENOMEM;
 		goto bad;
 	}
 
 	ti->per_io_data_size = sizeof(struct dm_verity_io) +
-				v->ahash_reqsize + v->digest_size * 2;
+				v->hash_reqsize + v->digest_size * 2;
 
 	r = verity_fec_ctr(v);
 	if (r)
 		goto bad;
 
diff --git a/drivers/md/dm-verity.h b/drivers/md/dm-verity.h
index 20b1bcf034742..15ffb0881cc9c 100644
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
 
@@ -92,45 +94,50 @@ struct dm_verity_io {
 	char *recheck_buffer;
 
 	/*
 	 * Three variably-size fields follow this struct:
 	 *
-	 * u8 hash_req[v->ahash_reqsize];
+	 * u8 hash_req[v->hash_reqsize];
 	 * u8 real_digest[v->digest_size];
 	 * u8 want_digest[v->digest_size];
 	 *
 	 * To access them use: verity_io_hash_req(), verity_io_real_digest()
 	 * and verity_io_want_digest().
+	 *
+	 * hash_req is either a struct ahash_request or a struct shash_desc,
+	 * depending on whether ahash_tfm or shash_tfm is being used.
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
-	return (u8 *)(io + 1) + v->ahash_reqsize;
+	return (u8 *)(io + 1) + v->hash_reqsize;
 }
 
 static inline u8 *verity_io_want_digest(struct dm_verity *v,
 					struct dm_verity_io *io)
 {
-	return (u8 *)(io + 1) + v->ahash_reqsize + v->digest_size;
+	return (u8 *)(io + 1) + v->hash_reqsize + v->digest_size;
 }
 
 extern int verity_for_bv_block(struct dm_verity *v, struct dm_verity_io *io,
 			       struct bvec_iter *iter,
 			       int (*process)(struct dm_verity *v,
 					      struct dm_verity_io *io,
 					      u8 *data, size_t len));
 
-extern int verity_hash(struct dm_verity *v, struct ahash_request *req,
-		       const u8 *data, size_t len, u8 *digest, bool may_sleep);
+extern int verity_compute_hash_virt(struct dm_verity *v,
+				    struct dm_verity_io *io,
+				    const u8 *data, size_t len, u8 *digest,
+				    bool may_sleep);
 
 extern int verity_hash_for_block(struct dm_verity *v, struct dm_verity_io *io,
 				 sector_t block, u8 *digest, bool *is_zero);
 
 extern bool dm_is_verity_target(struct dm_target *ti);
-- 
2.44.0


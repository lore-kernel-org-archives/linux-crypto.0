Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2B47BC4332F
	for <linux-crypto@archiver.kernel.org>; Mon, 30 Oct 2023 02:34:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229563AbjJ3Cek (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Sun, 29 Oct 2023 22:34:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49726 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229510AbjJ3Cej (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sun, 29 Oct 2023 22:34:39 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7A154BE
        for <linux-crypto@vger.kernel.org>; Sun, 29 Oct 2023 19:34:35 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CE5ADC433C7;
        Mon, 30 Oct 2023 02:34:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1698633275;
        bh=LOveOeQ/ovkJXe58Ym/iZONp0SSUVDHm6em6yyXLxqM=;
        h=From:To:Cc:Subject:Date:From;
        b=nTxzOyaoLn2SPDeN/6DJEHP9Ke+ZjrbfWXTSAtyPVUCqWTrz/EBoiYMv/aLGu2rQc
         thz9GknT4bz23vWHfRRTfqtAFbBKGSq7g5N63W6Mar0XdAmHmBWKHhs1zI39VpTEvo
         f/tvhOODso/c8KOijsQe9dqdVByMb4X3LWrFYTf1ZIjxTkXaXfVw7g7lcf7NPknvx6
         Qj2j5Z29K8lG9JacQ1SVO5YKS+rdZgBLKz6mGeOEclUOmxUdQQ5xlDpFNDjF4Z6Vxy
         DBIpGkwnuq/jS0Xifa1DnVBTaEN7QEOdSEdB8Qoj2HfFLxmW3k3UurlMXL4zLx1DEX
         XEh7yPnIDo5dA==
From:   Eric Biggers <ebiggers@kernel.org>
To:     Alasdair Kergon <agk@redhat.com>,
        Mike Snitzer <snitzer@kernel.org>, dm-devel@lists.linux.dev
Cc:     linux-crypto@vger.kernel.org,
        Gilad Ben-Yossef <gilad@benyossef.com>,
        Sami Tolvanen <samitolvanen@google.com>
Subject: [PATCH] dm-verity: hash blocks with shash import+finup when possible
Date:   Sun, 29 Oct 2023 19:33:51 -0700
Message-ID: <20231030023351.6041-1-ebiggers@kernel.org>
X-Mailer: git-send-email 2.42.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

From: Eric Biggers <ebiggers@google.com>

Commit d1ac3ff008fb ("dm verity: switch to using asynchronous hash
crypto API"), from Linux v4.12, made dm-verity do its hashing using the
ahash API instead of the shash API.  While this added support for
hardware (off-CPU) hashing offload, it slightly hurt performance for
everyone else due to additional crypto API overhead.  This API overhead
is becoming increasingly significant as I/O speeds increase and CPUs
achieve increasingly high SHA-2 speeds using native SHA-2 instructions.

Recent crypto API patches
(https://lore.kernel.org/linux-crypto/20231022081100.123613-1-ebiggers@kernel.org)
are reducing that overhead.  However, it cannot be eliminated.

Meanwhile, another crypto API related sub-optimality of how dm-verity
currently implements block hashing is that it always computes each hash
using multiple calls to the crypto API.  The most common case is:

    1. crypto_ahash_init()
    2. crypto_ahash_update() [salt]
    3. crypto_ahash_update() [data]
    4. crypto_ahash_final()

With less common dm-verity settings, the update of the salt can happen
after the data, or the data can require multiple updates.

Regardless, each call adds some API overhead.  Again, that's being
reduced by recent crypto API patches, but it cannot be eliminated; each
init, update, or final step necessarily involves an indirect call to the
actual "algorithm", which is expensive on modern CPUs, especially when
mitigations for speculative execution vulnerabilities are enabled.

A significantly more optimal sequence for the common case is to do an
import (crypto_ahash_import(), then a finup (crypto_ahash_finup()).
This results in as few as one indirect call, the one for finup.

Implementing the shash and import+finup optimizations independently
would result in 4 code paths, which seems a bit excessive.  This patch
therefore takes a slightly simpler approach.  It implements both
optimizations, but only together.  So, dm-verity now chooses either the
existing, fully general ahash method; or it chooses the new shash
import+finup method which is optimized for what most dm-verity users
want: CPU-based hashing with the most common dm-verity settings.

The new method is used automatically when appropriate, i.e. when the
ahash API and shash APIs resolve to the same underlying algorithm, the
dm-verity version is not 0 (so that the salt is hashed before the data),
and the data block size is not greater than the page size.

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
 drivers/md/dm-verity-fec.c    |  12 +-
 drivers/md/dm-verity-target.c | 354 +++++++++++++++++++++++++---------
 drivers/md/dm-verity.h        |  26 ++-
 3 files changed, 281 insertions(+), 111 deletions(-)

diff --git a/drivers/md/dm-verity-fec.c b/drivers/md/dm-verity-fec.c
index 3ef9f018da60..0781bfba9dbd 100644
--- a/drivers/md/dm-verity-fec.c
+++ b/drivers/md/dm-verity-fec.c
@@ -176,23 +176,23 @@ static int fec_decode_bufs(struct dm_verity *v, struct dm_verity_fec_io *fio,
 
 	return r;
 }
 
 /*
  * Locate data block erasures using verity hashes.
  */
 static int fec_is_erasure(struct dm_verity *v, struct dm_verity_io *io,
 			  u8 *want_digest, u8 *data)
 {
-	if (unlikely(verity_hash(v, verity_io_hash_req(v, io),
-				 data, 1 << v->data_dev_block_bits,
-				 verity_io_real_digest(v, io))))
+	if (unlikely(verity_compute_hash_virt(v, io, data,
+					      1 << v->data_dev_block_bits,
+					      verity_io_real_digest(v, io))))
 		return 0;
 
 	return memcmp(verity_io_real_digest(v, io), want_digest,
 		      v->digest_size) != 0;
 }
 
 /*
  * Read data blocks that are part of the RS block and deinterleave as much as
  * fits into buffers. Check for erasure locations if @neras is non-NULL.
  */
@@ -377,23 +377,23 @@ static int fec_decode_rsb(struct dm_verity *v, struct dm_verity_io *io,
 			return r;
 
 		r = fec_decode_bufs(v, fio, rsb, r, pos, neras);
 		if (r < 0)
 			return r;
 
 		pos += fio->nbufs << DM_VERITY_FEC_BUF_RS_BITS;
 	}
 
 	/* Always re-validate the corrected block against the expected hash */
-	r = verity_hash(v, verity_io_hash_req(v, io), fio->output,
-			1 << v->data_dev_block_bits,
-			verity_io_real_digest(v, io));
+	r = verity_compute_hash_virt(v, io, fio->output,
+				     1 << v->data_dev_block_bits,
+				     verity_io_real_digest(v, io));
 	if (unlikely(r < 0))
 		return r;
 
 	if (memcmp(verity_io_real_digest(v, io), verity_io_want_digest(v, io),
 		   v->digest_size)) {
 		DMERR_LIMIT("%s: FEC %llu: failed to correct (%d erasures)",
 			    v->data_dev->name, (unsigned long long)rsb, neras);
 		return -EILSEQ;
 	}
 
diff --git a/drivers/md/dm-verity-target.c b/drivers/md/dm-verity-target.c
index 26adcfea0302..1e6aa116be9b 100644
--- a/drivers/md/dm-verity-target.c
+++ b/drivers/md/dm-verity-target.c
@@ -39,22 +39,26 @@
 #define DM_VERITY_OPT_AT_MOST_ONCE	"check_at_most_once"
 #define DM_VERITY_OPT_TASKLET_VERIFY	"try_verify_in_tasklet"
 
 #define DM_VERITY_OPTS_MAX		(4 + DM_VERITY_OPTS_FEC + \
 					 DM_VERITY_ROOT_HASH_VERIFICATION_OPTS)
 
 static unsigned int dm_verity_prefetch_cluster = DM_VERITY_DEFAULT_PREFETCH_SIZE;
 
 module_param_named(prefetch_cluster, dm_verity_prefetch_cluster, uint, 0644);
 
+/* Is at least one dm-verity instance using the try_verify_in_tasklet option? */
 static DEFINE_STATIC_KEY_FALSE(use_tasklet_enabled);
 
+/* Is at least one dm-verity instance using ahash_tfm instead of shash_tfm? */
+static DEFINE_STATIC_KEY_FALSE(ahash_enabled);
+
 struct dm_verity_prefetch_work {
 	struct work_struct work;
 	struct dm_verity *v;
 	sector_t block;
 	unsigned int n_blocks;
 };
 
 /*
  * Auxiliary structure appended to each dm-bufio buffer. If the value
  * hash_verified is nonzero, hash of the block has been verified.
@@ -94,23 +98,23 @@ static sector_t verity_map_sector(struct dm_verity *v, sector_t bi_sector)
  * (0 is the lowest level).
  * The lowest "hash_per_block_bits"-bits of the result denote hash position
  * inside a hash block. The remaining bits denote location of the hash block.
  */
 static sector_t verity_position_at_level(struct dm_verity *v, sector_t block,
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
 		ahash_request_set_crypt(req, &sg, NULL, len);
 		return crypto_wait_req(crypto_ahash_update(req), wait);
 	}
 
 	do {
@@ -127,81 +131,100 @@ static int verity_hash_update(struct dm_verity *v, struct ahash_request *req,
 		data += this_step;
 		len -= this_step;
 	} while (len);
 
 	return 0;
 }
 
 /*
  * Wrapper for crypto_ahash_init, which handles verity salting.
  */
-static int verity_hash_init(struct dm_verity *v, struct ahash_request *req,
-				struct crypto_wait *wait)
+static int verity_ahash_init(struct dm_verity *v, struct ahash_request *req,
+			     struct crypto_wait *wait)
 {
 	int r;
 
-	ahash_request_set_tfm(req, v->tfm);
+	ahash_request_set_tfm(req, v->ahash_tfm);
 	ahash_request_set_callback(req, CRYPTO_TFM_REQ_MAY_SLEEP |
 					CRYPTO_TFM_REQ_MAY_BACKLOG,
 					crypto_req_done, (void *)wait);
 	crypto_init_wait(wait);
 
 	r = crypto_wait_req(crypto_ahash_init(req), wait);
 
 	if (unlikely(r < 0)) {
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
 	}
 
 	ahash_request_set_crypt(req, NULL, digest, 0);
 	r = crypto_wait_req(crypto_ahash_final(req), wait);
 out:
 	return r;
 }
 
-int verity_hash(struct dm_verity *v, struct ahash_request *req,
-		const u8 *data, size_t len, u8 *digest)
+int verity_compute_hash_virt(struct dm_verity *v, struct dm_verity_io *io,
+			     const u8 *data, size_t len, u8 *digest)
 {
 	int r;
-	struct crypto_wait wait;
 
-	r = verity_hash_init(v, req, &wait);
-	if (unlikely(r < 0))
-		goto out;
+	if (static_branch_unlikely(&ahash_enabled) && !v->shash_tfm) {
+		struct ahash_request *req = verity_io_hash_req(v, io);
+		struct crypto_wait wait;
 
-	r = verity_hash_update(v, req, data, len, &wait);
-	if (unlikely(r < 0))
-		goto out;
+		r = verity_ahash_init(v, req, &wait);
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
 {
 	sector_t position = verity_position_at_level(v, block, level);
 	unsigned int idx;
 
 	*hash_block = v->hash_level_block[level] + (position >> v->hash_per_block_bits);
@@ -313,23 +336,23 @@ static int verity_verify_level(struct dm_verity *v, struct dm_verity_io *io,
 		return PTR_ERR(data);
 
 	aux = dm_bufio_get_aux_data(buf);
 
 	if (!aux->hash_verified) {
 		if (skip_unverified) {
 			r = 1;
 			goto release_ret_r;
 		}
 
-		r = verity_hash(v, verity_io_hash_req(v, io),
-				data, 1 << v->hash_dev_block_bits,
-				verity_io_real_digest(v, io));
+		r = verity_compute_hash_virt(v, io, data,
+					     1 << v->hash_dev_block_bits,
+					     verity_io_real_digest(v, io));
 		if (unlikely(r < 0))
 			goto release_ret_r;
 
 		if (likely(memcmp(verity_io_real_digest(v, io), want_digest,
 				  v->digest_size) == 0))
 			aux->hash_verified = 1;
 		else if (static_branch_unlikely(&use_tasklet_enabled) &&
 			 io->in_tasklet) {
 			/*
 			 * Error handling code (FEC included) cannot be run in a
@@ -394,24 +417,27 @@ int verity_hash_for_block(struct dm_verity *v, struct dm_verity_io *io,
 out:
 	if (!r && v->zero_digest)
 		*is_zero = !memcmp(v->zero_digest, digest, v->digest_size);
 	else
 		*is_zero = false;
 
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
 
 	do {
 		int r;
 		unsigned int len;
 		struct bio_vec bv = bio_iter_iovec(bio, *iter);
@@ -436,20 +462,80 @@ static int verity_for_io_block(struct dm_verity *v, struct dm_verity_io *io,
 			return r;
 		}
 
 		bio_advance_iter(bio, iter, len);
 		todo -= len;
 	} while (todo);
 
 	return 0;
 }
 
+static int verity_compute_hash(struct dm_verity *v, struct dm_verity_io *io,
+			       struct bvec_iter *iter, u8 *digest)
+{
+	int r;
+
+	if (static_branch_unlikely(&ahash_enabled) && !v->shash_tfm) {
+		struct ahash_request *req = verity_io_hash_req(v, io);
+		struct crypto_wait wait;
+
+		r = verity_ahash_init(v, req, &wait);
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
 			struct bvec_iter *iter,
 			int (*process)(struct dm_verity *v,
 				       struct dm_verity_io *io, u8 *data,
 				       size_t len))
 {
@@ -505,38 +591,36 @@ static inline void verity_bv_skip_block(struct dm_verity *v,
  */
 static int verity_verify_io(struct dm_verity_io *io)
 {
 	bool is_zero;
 	struct dm_verity *v = io->v;
 #if defined(CONFIG_DM_VERITY_FEC)
 	struct bvec_iter start;
 #endif
 	struct bvec_iter iter_copy;
 	struct bvec_iter *iter;
-	struct crypto_wait wait;
 	struct bio *bio = dm_bio_from_per_bio_data(io, v->ti->per_io_data_size);
 	unsigned int b;
 
 	if (static_branch_unlikely(&use_tasklet_enabled) && io->in_tasklet) {
 		/*
 		 * Copy the iterator in case we need to restart
 		 * verification in a work-queue.
 		 */
 		iter_copy = io->iter;
 		iter = &iter_copy;
 	} else
 		iter = &io->iter;
 
 	for (b = 0; b < io->n_blocks; b++) {
 		int r;
 		sector_t cur_block = io->block + b;
-		struct ahash_request *req = verity_io_hash_req(v, io);
 
 		if (v->validated_blocks && bio->bi_status == BLK_STS_OK &&
 		    likely(test_bit(cur_block, v->validated_blocks))) {
 			verity_bv_skip_block(v, io, iter);
 			continue;
 		}
 
 		r = verity_hash_for_block(v, io, cur_block,
 					  verity_io_want_digest(v, io),
 					  &is_zero);
@@ -549,34 +633,26 @@ static int verity_verify_io(struct dm_verity_io *io)
 			 * return zeros.
 			 */
 			r = verity_for_bv_block(v, io, iter,
 						verity_bv_zero);
 			if (unlikely(r < 0))
 				return r;
 
 			continue;
 		}
 
-		r = verity_hash_init(v, req, &wait);
-		if (unlikely(r < 0))
-			return r;
-
 #if defined(CONFIG_DM_VERITY_FEC)
 		if (verity_fec_is_enabled(v))
 			start = *iter;
 #endif
-		r = verity_for_io_block(v, io, iter, &wait);
-		if (unlikely(r < 0))
-			return r;
-
-		r = verity_hash_final(v, req, verity_io_real_digest(v, io),
-					&wait);
+		r = verity_compute_hash(v, io, iter,
+					verity_io_real_digest(v, io));
 		if (unlikely(r < 0))
 			return r;
 
 		if (likely(memcmp(verity_io_real_digest(v, io),
 				  verity_io_want_digest(v, io), v->digest_size) == 0)) {
 			if (v->validated_blocks)
 				set_bit(cur_block, v->validated_blocks);
 			continue;
 		} else if (static_branch_unlikely(&use_tasklet_enabled) &&
 			   io->in_tasklet) {
@@ -957,25 +1033,30 @@ static void verity_dtr(struct dm_target *ti)
 	struct dm_verity *v = ti->private;
 
 	if (v->verify_wq)
 		destroy_workqueue(v->verify_wq);
 
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
 
 	if (v->data_dev)
 		dm_put_device(ti, v->data_dev);
 
 	verity_fec_dtr(v);
@@ -1007,43 +1088,43 @@ static int verity_alloc_most_once(struct dm_verity *v)
 		ti->error = "failed to allocate bitset for check_at_most_once";
 		return -ENOMEM;
 	}
 
 	return 0;
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
-			v->zero_digest);
-
+	r = verity_compute_hash_virt(v, io, zero_data,
+				     1 << v->data_dev_block_bits,
+				     v->zero_digest);
 out:
-	kfree(req);
+	kfree(io);
 	kfree(zero_data);
 
 	return r;
 }
 
 static inline bool verity_is_verity_mode(const char *arg_name)
 {
 	return (!strcasecmp(arg_name, DM_VERITY_OPT_LOGGING) ||
 		!strcasecmp(arg_name, DM_VERITY_OPT_RESTART) ||
 		!strcasecmp(arg_name, DM_VERITY_OPT_PANIC));
@@ -1150,20 +1231,144 @@ static int verity_parse_opt_args(struct dm_arg_set *as, struct dm_verity *v,
 		}
 
 		DMERR("Unrecognized verity feature request: %s", arg_name);
 		ti->error = "Unrecognized verity feature request";
 		return -EINVAL;
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
+	/*
+	 * Allocate the hash transformation object that this dm-verity instance
+	 * will use.  We have a choice of two APIs: shash and ahash.  Most
+	 * dm-verity users use CPU-based hashing, and for this the shash API is
+	 * optimal since it matches the underlying algorithm implementations.
+	 * Using ahash adds support for hardware (off-CPU) hashing offload.
+	 * Unfortunately, ahash is harmful for everyone not actually using that
+	 * feature, as the ahash => shash translation that the crypto API has to
+	 * do is slightly slower than just using shash directly.
+	 *
+	 * Meanwhile, hashing a block in dm-verity in general requires an
+	 * init+update+final sequence with multiple updates.  However, usually
+	 * the salt is prepended to the block rather than appended, and the data
+	 * block size is not greater than the page size.  In this very common
+	 * case, the sequence can be optimized to import+finup, where the first
+	 * step imports the pre-computed state after init+update(salt).  This
+	 * can reduce the crypto API overhead significantly.
+	 *
+	 * In summary, for optimal performance we potentially need the 4
+	 * combinations of (ahash, shash) x (init+update+final, import+finup).
+	 * However, to keep things more manageable, we currently just implement
+	 * two: ahash with init+update+final, and shash with import+finup.  This
+	 * gives optimal performance for *most* dm-verity users, while still
+	 * supporting hardware offload and all dm-verity settings.
+	 */
+	ahash = crypto_alloc_ahash(alg_name, 0,
+				   v->use_tasklet ? CRYPTO_ALG_ASYNC : 0);
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
  *	<hash device>
  *	<data block size>
  *	<hash block size>
  *	<the number of data blocks>
  *	<hash start block>
@@ -1274,82 +1479,41 @@ static int verity_ctr(struct dm_target *ti, unsigned int argc, char **argv)
 
 	if (sscanf(argv[6], "%llu%c", &num_ll, &dummy) != 1 ||
 	    (sector_t)(num_ll << (v->hash_dev_block_bits - SECTOR_SHIFT))
 	    >> (v->hash_dev_block_bits - SECTOR_SHIFT) != num_ll) {
 		ti->error = "Invalid hash start";
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
-				    v->use_tasklet ? CRYPTO_ALG_ASYNC : 0);
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
 		goto bad;
 	}
 	if (strlen(argv[8]) != v->digest_size * 2 ||
 	    hex2bin(v->root_digest, argv[8], v->digest_size)) {
 		ti->error = "Invalid root digest";
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
 	if (argc) {
 		as.argc = argc;
 		as.argv = argv;
 		r = verity_parse_opt_args(&as, v, &verify_args, false);
 		if (r < 0)
@@ -1424,21 +1588,21 @@ static int verity_ctr(struct dm_target *ti, unsigned int argc, char **argv)
 	 * doesn't have required hashes).
 	 */
 	v->verify_wq = alloc_workqueue("kverityd", WQ_MEM_RECLAIM | WQ_HIGHPRI, 0);
 	if (!v->verify_wq) {
 		ti->error = "Cannot allocate workqueue";
 		r = -ENOMEM;
 		goto bad;
 	}
 
 	ti->per_io_data_size = sizeof(struct dm_verity_io) +
-				v->ahash_reqsize + v->digest_size * 2;
+				v->hash_reqsize + v->digest_size * 2;
 
 	r = verity_fec_ctr(v);
 	if (r)
 		goto bad;
 
 	ti->per_io_data_size = roundup(ti->per_io_data_size,
 				       __alignof__(struct dm_verity_io));
 
 	verity_verify_sig_opts_cleanup(&verify_args);
 
diff --git a/drivers/md/dm-verity.h b/drivers/md/dm-verity.h
index 2f555b420367..0134cce4246c 100644
--- a/drivers/md/dm-verity.h
+++ b/drivers/md/dm-verity.h
@@ -31,38 +31,40 @@ enum verity_block_type {
 };
 
 struct dm_verity_fec;
 
 struct dm_verity {
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
 	sector_t hash_blocks;	/* the number of hash blocks */
 	unsigned char data_dev_block_bits;	/* log2(data blocksize) */
 	unsigned char hash_dev_block_bits;	/* log2(hash blocksize) */
 	unsigned char hash_per_block_bits;	/* log2(hashes in hash block) */
 	unsigned char levels;	/* the number of tree levels */
 	unsigned char version;
 	bool hash_failed:1;	/* set if hash of any block failed */
 	bool use_tasklet:1;	/* try to verify in tasklet before work-queue */
 	unsigned int digest_size;	/* digest size for the current hash algorithm */
-	unsigned int ahash_reqsize;/* the size of temporary space for crypto */
+	unsigned int hash_reqsize; /* the size of temporary space for crypto */
 	enum verity_mode mode;	/* mode for handling verification errors */
 	unsigned int corrupted_errs;/* Number of errors for corrupted blocks */
 
 	struct workqueue_struct *verify_wq;
 
 	/* starting blocks for each tree level. 0 is the lowest level. */
 	sector_t hash_level_block[DM_VERITY_MAX_LEVELS];
 
 	struct dm_verity_fec *fec;	/* forward error correction */
 	unsigned long *validated_blocks; /* bitset blocks validated */
@@ -81,61 +83,65 @@ struct dm_verity_io {
 	bool in_tasklet;
 
 	struct bvec_iter iter;
 
 	struct work_struct work;
 	struct tasklet_struct tasklet;
 
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
 
 static inline u8 *verity_io_digest_end(struct dm_verity *v,
 				       struct dm_verity_io *io)
 {
 	return verity_io_want_digest(v, io) + v->digest_size;
 }
 
 extern int verity_for_bv_block(struct dm_verity *v, struct dm_verity_io *io,
 			       struct bvec_iter *iter,
 			       int (*process)(struct dm_verity *v,
 					      struct dm_verity_io *io,
 					      u8 *data, size_t len));
 
-extern int verity_hash(struct dm_verity *v, struct ahash_request *req,
-		       const u8 *data, size_t len, u8 *digest);
+extern int verity_compute_hash_virt(struct dm_verity *v,
+				    struct dm_verity_io *io,
+				    const u8 *data, size_t len, u8 *digest);
 
 extern int verity_hash_for_block(struct dm_verity *v, struct dm_verity_io *io,
 				 sector_t block, u8 *digest, bool *is_zero);
 
 extern bool dm_is_verity_target(struct dm_target *ti);
 extern int dm_verity_get_mode(struct dm_target *ti);
 extern int dm_verity_get_root_digest(struct dm_target *ti, u8 **root_digest,
 				     unsigned int *digest_size);
 
 #endif /* DM_VERITY_H */

base-commit: 2af9b20dbb39f6ebf9b9b6c090271594627d818e
-- 
2.42.0


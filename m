Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 99E033C39;
	Tue,  7 May 2024 00:25:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715041518; cv=none; b=GXoxl5f+OlfckmzftMidvonDg1pjGwUiEtpxlk46axdTjUTvrsrpTjJAwNXvrcFaQeW2r+Of2lVj4gz5dug5L21LmhPmludNg9jDKLBAZ2fXa6tZbM45mronyjlgcwQfai3Unf0oiEcyDSrBitxfU4Lp1lsK5rjAZZEGo79BzK8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715041518; c=relaxed/simple;
	bh=TZLgF8hgmB4ShgK1PTPmmpVgUZNDlY044WPe7DEdI1U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iq4197fJR+cOBnIGzWGlgCQy+vyPjw9W+2A7xHKCOJiIxWMKZReF0EMHBIOP/UMJG7sK94EVqErZpxZqW4Vm382Efd8L1sMVo3LzfdyfL742bMdne2GUEdTDPP/7RdngYkKQyqVBnL4XNdFcqbFemjbj9tLQsgm8d3EJG8P7CUo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=AzNbri2O; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="AzNbri2O"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 05A14C4AF68;
	Tue,  7 May 2024 00:25:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1715041518;
	bh=TZLgF8hgmB4ShgK1PTPmmpVgUZNDlY044WPe7DEdI1U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=AzNbri2OoJ+OJ085gg3j+mfKnAjH2r+MA/VtEXiOEij0jG0KXNNJIOeIvsEOBHlYN
	 BUMgsc8Jr+kwde4WdZT5HbrNN63KVNNZJWhdNfu0UJw8oYAHK6v/kMJEgYQUoVnUIZ
	 RooGdCN6JsKGCrL0UDtV/HTj4ScuNw7zmMcr3wS5977tTVG5sWy3+9Ii45k9AJXa6F
	 YWB3PHk1vVxt5vTbI+h6juVR2QKGpqGLon4pPzptFCY1jB1Ub5bWqhqOVa3BuFiu+i
	 Ai6jZaSIsiNZEVhpw1C0ePcwHXVtpwyUgFT2w0oCsyTRmXzE78Uutr9yHcNptRRpy2
	 81YxM4NahJPeQ==
From: Eric Biggers <ebiggers@kernel.org>
To: linux-crypto@vger.kernel.org,
	fsverity@lists.linux.dev,
	dm-devel@lists.linux.dev
Cc: x86@kernel.org,
	linux-arm-kernel@lists.infradead.org,
	Ard Biesheuvel <ardb@kernel.org>,
	Sami Tolvanen <samitolvanen@google.com>,
	Bart Van Assche <bvanassche@acm.org>
Subject: [PATCH v3 6/8] fsverity: improve performance by using multibuffer hashing
Date: Mon,  6 May 2024 17:23:41 -0700
Message-ID: <20240507002343.239552-7-ebiggers@kernel.org>
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
of cold-cache fsverity reads that I'm seeing on arm64 and x86_64 is
roughly 35% (though this metric is hard to measure as it jumps around a
lot).

For now this is only done on the verification path, and only for data
blocks, not Merkle tree blocks.  We could use finup_mb on Merkle tree
blocks too, but that is less important as there aren't as many Merkle
tree blocks as data blocks, and that would require some additional code
restructuring.  We could also use finup_mb to accelerate building the
Merkle tree, but verification performance is more important.

Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 fs/verity/fsverity_private.h |   5 +
 fs/verity/hash_algs.c        |  32 ++++++-
 fs/verity/open.c             |   6 ++
 fs/verity/verify.c           | 177 +++++++++++++++++++++++++++++------
 4 files changed, 187 insertions(+), 33 deletions(-)

diff --git a/fs/verity/fsverity_private.h b/fs/verity/fsverity_private.h
index b3506f56e180..9fe1633f15d6 100644
--- a/fs/verity/fsverity_private.h
+++ b/fs/verity/fsverity_private.h
@@ -27,10 +27,11 @@ struct fsverity_hash_alg {
 	/*
 	 * The HASH_ALGO_* constant for this algorithm.  This is different from
 	 * FS_VERITY_HASH_ALG_*, which uses a different numbering scheme.
 	 */
 	enum hash_algo algo_id;
+	bool supports_multibuffer;  /* crypto_shash_mb_max_msgs(tfm) >= 2 */
 };
 
 /* Merkle tree parameters: hash algorithm, initial hash state, and topology */
 struct merkle_tree_params {
 	const struct fsverity_hash_alg *hash_alg; /* the hash algorithm */
@@ -65,10 +66,11 @@ struct merkle_tree_params {
  */
 struct fsverity_info {
 	struct merkle_tree_params tree_params;
 	u8 root_hash[FS_VERITY_MAX_DIGEST_SIZE];
 	u8 file_digest[FS_VERITY_MAX_DIGEST_SIZE];
+	u8 zero_block_hash[FS_VERITY_MAX_DIGEST_SIZE];
 	const struct inode *inode;
 	unsigned long *hash_block_verified;
 };
 
 #define FS_VERITY_MAX_SIGNATURE_SIZE	(FS_VERITY_MAX_DESCRIPTOR_SIZE - \
@@ -82,10 +84,13 @@ const struct fsverity_hash_alg *fsverity_get_hash_alg(const struct inode *inode,
 						      unsigned int num);
 const u8 *fsverity_prepare_hash_state(const struct fsverity_hash_alg *alg,
 				      const u8 *salt, size_t salt_size);
 int fsverity_hash_block(const struct merkle_tree_params *params,
 			const struct inode *inode, const void *data, u8 *out);
+int fsverity_hash_2_blocks(const struct merkle_tree_params *params,
+			   const struct inode *inode, const void *data1,
+			   const void *data2, u8 *out1, u8 *out2);
 int fsverity_hash_buffer(const struct fsverity_hash_alg *alg,
 			 const void *data, size_t size, u8 *out);
 void __init fsverity_check_hash_algs(void);
 
 /* init.c */
diff --git a/fs/verity/hash_algs.c b/fs/verity/hash_algs.c
index 6b08b1d9a7d7..71b6f74aaacd 100644
--- a/fs/verity/hash_algs.c
+++ b/fs/verity/hash_algs.c
@@ -82,12 +82,15 @@ const struct fsverity_hash_alg *fsverity_get_hash_alg(const struct inode *inode,
 	if (WARN_ON_ONCE(alg->digest_size != crypto_shash_digestsize(tfm)))
 		goto err_free_tfm;
 	if (WARN_ON_ONCE(alg->block_size != crypto_shash_blocksize(tfm)))
 		goto err_free_tfm;
 
-	pr_info("%s using implementation \"%s\"\n",
-		alg->name, crypto_shash_driver_name(tfm));
+	alg->supports_multibuffer = (crypto_shash_mb_max_msgs(tfm) >= 2);
+
+	pr_info("%s using implementation \"%s\"%s\n",
+		alg->name, crypto_shash_driver_name(tfm),
+		alg->supports_multibuffer ? " (multibuffer)" : "");
 
 	/* pairs with smp_load_acquire() above */
 	smp_store_release(&alg->tfm, tfm);
 	goto out_unlock;
 
@@ -195,10 +198,35 @@ int fsverity_hash_block(const struct merkle_tree_params *params,
 	if (err)
 		fsverity_err(inode, "Error %d computing block hash", err);
 	return err;
 }
 
+int fsverity_hash_2_blocks(const struct merkle_tree_params *params,
+			   const struct inode *inode, const void *data1,
+			   const void *data2, u8 *out1, u8 *out2)
+{
+	const u8 *data[2] = { data1, data2 };
+	u8 *outs[2] = { out1, out2 };
+	SHASH_DESC_ON_STACK(desc, params->hash_alg->tfm);
+	int err;
+
+	desc->tfm = params->hash_alg->tfm;
+
+	if (params->hashstate)
+		err = crypto_shash_import(desc, params->hashstate);
+	else
+		err = crypto_shash_init(desc);
+	if (err) {
+		fsverity_err(inode, "Error %d importing hash state", err);
+		return err;
+	}
+	err = crypto_shash_finup_mb(desc, data, params->block_size, outs, 2);
+	if (err)
+		fsverity_err(inode, "Error %d computing block hashes", err);
+	return err;
+}
+
 /**
  * fsverity_hash_buffer() - hash some data
  * @alg: the hash algorithm to use
  * @data: the data to hash
  * @size: size of data to hash, in bytes
diff --git a/fs/verity/open.c b/fs/verity/open.c
index fdeb95eca3af..4ae07c689c56 100644
--- a/fs/verity/open.c
+++ b/fs/verity/open.c
@@ -206,10 +206,16 @@ struct fsverity_info *fsverity_create_info(const struct inode *inode,
 	if (err) {
 		fsverity_err(inode, "Error %d computing file digest", err);
 		goto fail;
 	}
 
+	err = fsverity_hash_block(&vi->tree_params, inode,
+				  page_address(ZERO_PAGE(0)),
+				  vi->zero_block_hash);
+	if (err)
+		goto fail;
+
 	err = fsverity_verify_signature(vi, desc->signature,
 					le32_to_cpu(desc->sig_size));
 	if (err)
 		goto fail;
 
diff --git a/fs/verity/verify.c b/fs/verity/verify.c
index 4fcad0825a12..38f1eb3dbd8e 100644
--- a/fs/verity/verify.c
+++ b/fs/verity/verify.c
@@ -77,29 +77,33 @@ static bool is_hash_block_verified(struct fsverity_info *vi, struct page *hpage,
 	SetPageChecked(hpage);
 	return false;
 }
 
 /*
- * Verify a single data block against the file's Merkle tree.
+ * Verify the hash of a single data block against the file's Merkle tree.
+ *
+ * @real_dblock_hash specifies the hash of the data block, and @data_pos
+ * specifies the byte position of the data block within the file.
  *
  * In principle, we need to verify the entire path to the root node.  However,
  * for efficiency the filesystem may cache the hash blocks.  Therefore we need
  * only ascend the tree until an already-verified hash block is seen, and then
  * verify the path to that block.
  *
  * Return: %true if the data block is valid, else %false.
  */
 static bool
 verify_data_block(struct inode *inode, struct fsverity_info *vi,
-		  const void *data, u64 data_pos, unsigned long max_ra_pages)
+		  const u8 *real_dblock_hash, u64 data_pos,
+		  unsigned long max_ra_pages)
 {
 	const struct merkle_tree_params *params = &vi->tree_params;
 	const unsigned int hsize = params->digest_size;
 	int level;
 	u8 _want_hash[FS_VERITY_MAX_DIGEST_SIZE];
 	const u8 *want_hash;
-	u8 real_hash[FS_VERITY_MAX_DIGEST_SIZE];
+	u8 real_hblock_hash[FS_VERITY_MAX_DIGEST_SIZE];
 	/* The hash blocks that are traversed, indexed by level */
 	struct {
 		/* Page containing the hash block */
 		struct page *page;
 		/* Mapped address of the hash block (will be within @page) */
@@ -125,11 +129,12 @@ verify_data_block(struct inode *inode, struct fsverity_info *vi,
 		 * doesn't cover data blocks fully past EOF.  But the entire
 		 * page spanning EOF can be visible to userspace via a mmap, and
 		 * any part past EOF should be all zeroes.  Therefore, we need
 		 * to verify that any data blocks fully past EOF are all zeroes.
 		 */
-		if (memchr_inv(data, 0, params->block_size)) {
+		if (memcmp(vi->zero_block_hash, real_dblock_hash,
+			   params->block_size) != 0) {
 			fsverity_err(inode,
 				     "FILE CORRUPTED!  Data past EOF is not zeroed");
 			return false;
 		}
 		return true;
@@ -200,13 +205,14 @@ verify_data_block(struct inode *inode, struct fsverity_info *vi,
 		struct page *hpage = hblocks[level - 1].page;
 		const void *haddr = hblocks[level - 1].addr;
 		unsigned long hblock_idx = hblocks[level - 1].index;
 		unsigned int hoffset = hblocks[level - 1].hoffset;
 
-		if (fsverity_hash_block(params, inode, haddr, real_hash) != 0)
+		if (fsverity_hash_block(params, inode, haddr,
+					real_hblock_hash) != 0)
 			goto error;
-		if (memcmp(want_hash, real_hash, hsize) != 0)
+		if (memcmp(want_hash, real_hblock_hash, hsize) != 0)
 			goto corrupted;
 		/*
 		 * Mark the hash block as verified.  This must be atomic and
 		 * idempotent, as the same hash block might be verified by
 		 * multiple threads concurrently.
@@ -219,55 +225,145 @@ verify_data_block(struct inode *inode, struct fsverity_info *vi,
 		want_hash = _want_hash;
 		kunmap_local(haddr);
 		put_page(hpage);
 	}
 
-	/* Finally, verify the data block. */
-	if (fsverity_hash_block(params, inode, data, real_hash) != 0)
-		goto error;
-	if (memcmp(want_hash, real_hash, hsize) != 0)
+	/* Finally, verify the hash of the data block. */
+	if (memcmp(want_hash, real_dblock_hash, hsize) != 0)
 		goto corrupted;
 	return true;
 
 corrupted:
 	fsverity_err(inode,
 		     "FILE CORRUPTED! pos=%llu, level=%d, want_hash=%s:%*phN, real_hash=%s:%*phN",
 		     data_pos, level - 1,
 		     params->hash_alg->name, hsize, want_hash,
-		     params->hash_alg->name, hsize, real_hash);
+		     params->hash_alg->name, hsize,
+		     level == 0 ? real_dblock_hash : real_hblock_hash);
 error:
 	for (; level > 0; level--) {
 		kunmap_local(hblocks[level - 1].addr);
 		put_page(hblocks[level - 1].page);
 	}
 	return false;
 }
 
+struct fsverity_verification_context {
+	struct inode *inode;
+	struct fsverity_info *vi;
+	unsigned long max_ra_pages;
+
+	/*
+	 * pending_data and pending_pos are used when the selected hash
+	 * algorithm supports multibuffer hashing.  They're used to temporarily
+	 * store the virtual address and position of a mapped data block that
+	 * needs to be verified.  If we then see another data block, we hash the
+	 * two blocks simultaneously using the fast multibuffer hashing method.
+	 */
+	const void *pending_data;
+	u64 pending_pos;
+
+	/* Buffers to temporarily store the calculated data block hashes */
+	u8 hash1[FS_VERITY_MAX_DIGEST_SIZE];
+	u8 hash2[FS_VERITY_MAX_DIGEST_SIZE];
+};
+
+static inline void
+fsverity_init_verification_context(struct fsverity_verification_context *ctx,
+				   struct inode *inode,
+				   unsigned long max_ra_pages)
+{
+	ctx->inode = inode;
+	ctx->vi = inode->i_verity_info;
+	ctx->max_ra_pages = max_ra_pages;
+	ctx->pending_data = NULL;
+}
+
+static bool
+fsverity_finish_verification(struct fsverity_verification_context *ctx)
+{
+	int err;
+
+	if (ctx->pending_data == NULL)
+		return true;
+	/*
+	 * Multibuffer hashing is enabled but there was an odd number of data
+	 * blocks.  Hash and verify the last block by itself.
+	 */
+	err = fsverity_hash_block(&ctx->vi->tree_params, ctx->inode,
+				  ctx->pending_data, ctx->hash1);
+	kunmap_local(ctx->pending_data);
+	ctx->pending_data = NULL;
+	return err == 0 &&
+	       verify_data_block(ctx->inode, ctx->vi, ctx->hash1,
+				 ctx->pending_pos, ctx->max_ra_pages);
+}
+
+static inline void
+fsverity_abort_verification(struct fsverity_verification_context *ctx)
+{
+	if (ctx->pending_data) {
+		kunmap_local(ctx->pending_data);
+		ctx->pending_data = NULL;
+	}
+}
+
 static bool
-verify_data_blocks(struct folio *data_folio, size_t len, size_t offset,
-		   unsigned long max_ra_pages)
+fsverity_add_data_blocks(struct fsverity_verification_context *ctx,
+			 struct folio *data_folio, size_t len, size_t offset)
 {
-	struct inode *inode = data_folio->mapping->host;
-	struct fsverity_info *vi = inode->i_verity_info;
-	const unsigned int block_size = vi->tree_params.block_size;
-	u64 pos = (u64)data_folio->index << PAGE_SHIFT;
+	struct inode *inode = ctx->inode;
+	struct fsverity_info *vi = ctx->vi;
+	const struct merkle_tree_params *params = &vi->tree_params;
+	const unsigned int block_size = params->block_size;
+	const bool multibuffer = params->hash_alg->supports_multibuffer;
+	u64 pos = ((u64)data_folio->index << PAGE_SHIFT) + offset;
 
 	if (WARN_ON_ONCE(len <= 0 || !IS_ALIGNED(len | offset, block_size)))
 		return false;
 	if (WARN_ON_ONCE(!folio_test_locked(data_folio) ||
 			 folio_test_uptodate(data_folio)))
 		return false;
 	do {
-		void *data;
-		bool valid;
-
-		data = kmap_local_folio(data_folio, offset);
-		valid = verify_data_block(inode, vi, data, pos + offset,
-					  max_ra_pages);
-		kunmap_local(data);
-		if (!valid)
-			return false;
+		const void *data = kmap_local_folio(data_folio, offset);
+		int err;
+
+		if (multibuffer) {
+			if (ctx->pending_data) {
+				/* Hash and verify two data blocks. */
+				err = fsverity_hash_2_blocks(params,
+							     inode,
+							     ctx->pending_data,
+							     data,
+							     ctx->hash1,
+							     ctx->hash2);
+				kunmap_local(data);
+				kunmap_local(ctx->pending_data);
+				ctx->pending_data = NULL;
+				if (err != 0 ||
+				    !verify_data_block(inode, vi, ctx->hash1,
+						       ctx->pending_pos,
+						       ctx->max_ra_pages) ||
+				    !verify_data_block(inode, vi, ctx->hash2,
+						       pos, ctx->max_ra_pages))
+					return false;
+			} else {
+				/* Wait and see if there's another block. */
+				ctx->pending_data = data;
+				ctx->pending_pos = pos;
+			}
+		} else {
+			/* Hash and verify one data block. */
+			err = fsverity_hash_block(params, inode, data,
+						  ctx->hash1);
+			kunmap_local(data);
+			if (err != 0 ||
+			    !verify_data_block(inode, vi, ctx->hash1,
+					       pos, ctx->max_ra_pages))
+				return false;
+		}
+		pos += block_size;
 		offset += block_size;
 		len -= block_size;
 	} while (len);
 	return true;
 }
@@ -284,11 +380,19 @@ verify_data_blocks(struct folio *data_folio, size_t len, size_t offset,
  *
  * Return: %true if the data is valid, else %false.
  */
 bool fsverity_verify_blocks(struct folio *folio, size_t len, size_t offset)
 {
-	return verify_data_blocks(folio, len, offset, 0);
+	struct fsverity_verification_context ctx;
+
+	fsverity_init_verification_context(&ctx, folio->mapping->host, 0);
+
+	if (!fsverity_add_data_blocks(&ctx, folio, len, offset)) {
+		fsverity_abort_verification(&ctx);
+		return false;
+	}
+	return fsverity_finish_verification(&ctx);
 }
 EXPORT_SYMBOL_GPL(fsverity_verify_blocks);
 
 #ifdef CONFIG_BLOCK
 /**
@@ -305,10 +409,12 @@ EXPORT_SYMBOL_GPL(fsverity_verify_blocks);
  * filesystems) must instead call fsverity_verify_page() directly on each page.
  * All filesystems must also call fsverity_verify_page() on holes.
  */
 void fsverity_verify_bio(struct bio *bio)
 {
+	struct inode *inode = bio_first_folio_all(bio)->mapping->host;
+	struct fsverity_verification_context ctx;
 	struct folio_iter fi;
 	unsigned long max_ra_pages = 0;
 
 	if (bio->bi_opf & REQ_RAHEAD) {
 		/*
@@ -321,17 +427,26 @@ void fsverity_verify_bio(struct bio *bio)
 		 * reduces the number of I/O requests made to the Merkle tree.
 		 */
 		max_ra_pages = bio->bi_iter.bi_size >> (PAGE_SHIFT + 2);
 	}
 
+	fsverity_init_verification_context(&ctx, inode, max_ra_pages);
+
 	bio_for_each_folio_all(fi, bio) {
-		if (!verify_data_blocks(fi.folio, fi.length, fi.offset,
-					max_ra_pages)) {
-			bio->bi_status = BLK_STS_IOERR;
-			break;
+		if (!fsverity_add_data_blocks(&ctx, fi.folio, fi.length,
+					      fi.offset)) {
+			fsverity_abort_verification(&ctx);
+			goto ioerr;
 		}
 	}
+
+	if (!fsverity_finish_verification(&ctx))
+		goto ioerr;
+	return;
+
+ioerr:
+	bio->bi_status = BLK_STS_IOERR;
 }
 EXPORT_SYMBOL_GPL(fsverity_verify_bio);
 #endif /* CONFIG_BLOCK */
 
 /**
-- 
2.45.0


Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D95A828B501;
	Tue,  9 Sep 2025 23:16:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757459789; cv=none; b=kmXdpdclavVD4DgRLAyUUqTle3mw0Q1r8p28YhCU6KncdoIZ9YHMTBo+iffAo0tSsWtNlpF0gmo+PLKZ3LxIK+pv5xhkzy3Jihed3HjeB2XAYGVKf6quNfPPj9ZKGhiKme5psYW8xU9y3qHI81lue1GZAGx2vG1Mvl/VJA3ZmW0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757459789; c=relaxed/simple;
	bh=yOte++q8p6jqC8tT4uRqUh3/T6hbvaXSszTlzpMDbXE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=omJMfYC9t4cUvZPoVYzJ1rwvvugfo4YbQU2t4qg6hHSDKrMLHKeMUqOF+viYc35LEkmh5SE5byhFnCTLzh+kFS704w2Ya+qzWm9TSBiAvUB6lLnbsCBlQxIYUnqddNplYYlKjsw4iu2asfOGEzZxlaUOxCiSHzkxDnoGynhShWU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=qbnG4BZm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="qbnG4BZm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6FD76C4CEF8;
	Tue,  9 Sep 2025 23:16:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1757459788;
	bh=yOte++q8p6jqC8tT4uRqUh3/T6hbvaXSszTlzpMDbXE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qbnG4BZmy4Gd9CqiZ0/4goByTkMc81NLzxpH5RO5d77rJlwvJtBIuqLpfMArscktQ
	 GH/Z8hkZPB+AeDzS2LcPlG1BDczphjAcf2zw9x/iIPAburg54ImTeN+qekb9WAVGol
	 1iLndTVEDJ/QQwYmEw0VENiaMg4cHIwzGhT78vQ40LdFLw+VrwPPVCkeEoRFMdjHkM
	 3ymXEPLartqtb1FUiSGe8eW8xiPAxdPQA7pyYKRgKYDDx1PSKce2nYjtkrn3zqWNB/
	 bEBVCHg3Px6XdhTeQT1SIvBTZ69EXi8soBRYz0mHrETQphHrtU7mFB7z0Jcxwj1YDp
	 MzS4tfChwsKdw==
From: Eric Biggers <ebiggers@kernel.org>
To: linux-crypto@vger.kernel.org,
	fsverity@lists.linux.dev
Cc: linux-kernel@vger.kernel.org,
	Ard Biesheuvel <ardb@kernel.org>,
	"Jason A . Donenfeld" <Jason@zx2c4.com>,
	x86@kernel.org,
	Sami Tolvanen <samitolvanen@google.com>,
	Mikulas Patocka <mpatocka@redhat.com>,
	linux-arm-kernel@lists.infradead.org,
	Eric Biggers <ebiggers@kernel.org>
Subject: [PATCH 6/6] fsverity: Use 2-way interleaved SHA-256 hashing when supported
Date: Tue,  9 Sep 2025 16:13:26 -0700
Message-ID: <20250909231326.1074672-7-ebiggers@kernel.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250909231326.1074672-1-ebiggers@kernel.org>
References: <20250909231326.1074672-1-ebiggers@kernel.org>
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
increase in overall throughput of cold-cache fsverity reads that I'm
seeing on arm64 and x86_64 is roughly 35% (though this metric is hard to
measure as it jumps around a lot).

For now this is only done on the verification path, and only for data
blocks, not Merkle tree blocks.  We could use sha256_finup_2x() on
Merkle tree blocks too, but that is less important as there aren't as
many Merkle tree blocks as data blocks, and that would require some
additional code restructuring.  We could also use sha256_finup_2x() to
accelerate building the Merkle tree, but verification performance is
more important.

Signed-off-by: Eric Biggers <ebiggers@kernel.org>
---
 fs/verity/verify.c | 173 ++++++++++++++++++++++++++++++++++++---------
 1 file changed, 139 insertions(+), 34 deletions(-)

diff --git a/fs/verity/verify.c b/fs/verity/verify.c
index d7d5f65700b03..6dd03468e2a26 100644
--- a/fs/verity/verify.c
+++ b/fs/verity/verify.c
@@ -8,10 +8,35 @@
 #include "fsverity_private.h"
 
 #include <linux/bio.h>
 #include <linux/export.h>
 
+#define FS_VERITY_MAX_PENDING_BLOCKS 2
+
+struct fsverity_pending_block {
+	const void *data;
+	u64 pos;
+	u8 real_hash[FS_VERITY_MAX_DIGEST_SIZE];
+};
+
+struct fsverity_verification_context {
+	struct inode *inode;
+	struct fsverity_info *vi;
+	unsigned long max_ra_pages;
+
+	/*
+	 * This is the queue of data blocks that are pending verification.  When
+	 * the crypto layer supports interleaved hashing, we allow multiple
+	 * blocks to be queued up in order to utilize it.  This can improve
+	 * performance significantly vs. sequential hashing of each block.
+	 */
+	int num_pending;
+	int max_pending;
+	struct fsverity_pending_block
+		pending_blocks[FS_VERITY_MAX_PENDING_BLOCKS];
+};
+
 static struct workqueue_struct *fsverity_read_workqueue;
 
 /*
  * Returns true if the hash block with index @hblock_idx in the tree, located in
  * @hpage, has already been verified.
@@ -77,23 +102,24 @@ static bool is_hash_block_verified(struct fsverity_info *vi, struct page *hpage,
 	SetPageChecked(hpage);
 	return false;
 }
 
 /*
- * Verify a single data block against the file's Merkle tree.
+ * Verify the hash of a single data block against the file's Merkle tree.
  *
  * In principle, we need to verify the entire path to the root node.  However,
  * for efficiency the filesystem may cache the hash blocks.  Therefore we need
  * only ascend the tree until an already-verified hash block is seen, and then
  * verify the path to that block.
  *
  * Return: %true if the data block is valid, else %false.
  */
-static bool
-verify_data_block(struct inode *inode, struct fsverity_info *vi,
-		  const void *data, u64 data_pos, unsigned long max_ra_pages)
+static bool verify_data_block(struct inode *inode, struct fsverity_info *vi,
+			      const struct fsverity_pending_block *dblock,
+			      unsigned long max_ra_pages)
 {
+	const u64 data_pos = dblock->pos;
 	const struct merkle_tree_params *params = &vi->tree_params;
 	const unsigned int hsize = params->digest_size;
 	int level;
 	u8 _want_hash[FS_VERITY_MAX_DIGEST_SIZE];
 	const u8 *want_hash;
@@ -113,23 +139,27 @@ verify_data_block(struct inode *inode, struct fsverity_info *vi,
 	 * The index of the previous level's block within that level; also the
 	 * index of that block's hash within the current level.
 	 */
 	u64 hidx = data_pos >> params->log_blocksize;
 
-	/* Up to 1 + FS_VERITY_MAX_LEVELS pages may be mapped at once */
-	BUILD_BUG_ON(1 + FS_VERITY_MAX_LEVELS > KM_MAX_IDX);
+	/*
+	 * Up to FS_VERITY_MAX_PENDING_BLOCKS + FS_VERITY_MAX_LEVELS pages may
+	 * be mapped at once.
+	 */
+	static_assert(FS_VERITY_MAX_PENDING_BLOCKS + FS_VERITY_MAX_LEVELS <=
+		      KM_MAX_IDX);
 
 	if (unlikely(data_pos >= inode->i_size)) {
 		/*
 		 * This can happen in the data page spanning EOF when the Merkle
 		 * tree block size is less than the page size.  The Merkle tree
 		 * doesn't cover data blocks fully past EOF.  But the entire
 		 * page spanning EOF can be visible to userspace via a mmap, and
 		 * any part past EOF should be all zeroes.  Therefore, we need
 		 * to verify that any data blocks fully past EOF are all zeroes.
 		 */
-		if (memchr_inv(data, 0, params->block_size)) {
+		if (memchr_inv(dblock->data, 0, params->block_size)) {
 			fsverity_err(inode,
 				     "FILE CORRUPTED!  Data past EOF is not zeroed");
 			return false;
 		}
 		return true;
@@ -218,53 +248,110 @@ verify_data_block(struct inode *inode, struct fsverity_info *vi,
 		want_hash = _want_hash;
 		kunmap_local(haddr);
 		put_page(hpage);
 	}
 
-	/* Finally, verify the data block. */
-	fsverity_hash_block(params, data, real_hash);
-	if (memcmp(want_hash, real_hash, hsize) != 0)
+	/* Finally, verify the hash of the data block. */
+	if (memcmp(want_hash, dblock->real_hash, hsize) != 0)
 		goto corrupted;
 	return true;
 
 corrupted:
-	fsverity_err(inode,
-		     "FILE CORRUPTED! pos=%llu, level=%d, want_hash=%s:%*phN, real_hash=%s:%*phN",
-		     data_pos, level - 1,
-		     params->hash_alg->name, hsize, want_hash,
-		     params->hash_alg->name, hsize, real_hash);
+	fsverity_err(
+		inode,
+		"FILE CORRUPTED! pos=%llu, level=%d, want_hash=%s:%*phN, real_hash=%s:%*phN",
+		data_pos, level - 1, params->hash_alg->name, hsize, want_hash,
+		params->hash_alg->name, hsize,
+		level == 0 ? dblock->real_hash : real_hash);
 error:
 	for (; level > 0; level--) {
 		kunmap_local(hblocks[level - 1].addr);
 		put_page(hblocks[level - 1].page);
 	}
 	return false;
 }
 
-static bool
-verify_data_blocks(struct folio *data_folio, size_t len, size_t offset,
-		   unsigned long max_ra_pages)
+static void
+fsverity_init_verification_context(struct fsverity_verification_context *ctx,
+				   struct inode *inode,
+				   unsigned long max_ra_pages)
 {
-	struct inode *inode = data_folio->mapping->host;
 	struct fsverity_info *vi = inode->i_verity_info;
-	const unsigned int block_size = vi->tree_params.block_size;
+
+	ctx->inode = inode;
+	ctx->vi = vi;
+	ctx->max_ra_pages = max_ra_pages;
+	ctx->num_pending = 0;
+	if (vi->tree_params.hash_alg->algo_id == HASH_ALGO_SHA256 &&
+	    sha256_finup_2x_is_optimized())
+		ctx->max_pending = 2;
+	else
+		ctx->max_pending = 1;
+}
+
+static void
+fsverity_clear_pending_blocks(struct fsverity_verification_context *ctx)
+{
+	int i;
+
+	for (i = ctx->num_pending - 1; i >= 0; i--) {
+		kunmap_local(ctx->pending_blocks[i].data);
+		ctx->pending_blocks[i].data = NULL;
+	}
+	ctx->num_pending = 0;
+}
+
+static bool
+fsverity_verify_pending_blocks(struct fsverity_verification_context *ctx)
+{
+	struct fsverity_info *vi = ctx->vi;
+	const struct merkle_tree_params *params = &vi->tree_params;
+	int i;
+
+	if (ctx->num_pending == 2) {
+		/* Implies algo_id == HASH_ALGO_SHA256 */
+		sha256_finup_2x(params->hashstate ? &params->hashstate->sha256 :
+						    NULL,
+				ctx->pending_blocks[0].data,
+				ctx->pending_blocks[1].data, params->block_size,
+				ctx->pending_blocks[0].real_hash,
+				ctx->pending_blocks[1].real_hash);
+	} else {
+		for (i = 0; i < ctx->num_pending; i++)
+			fsverity_hash_block(params, ctx->pending_blocks[i].data,
+					    ctx->pending_blocks[i].real_hash);
+	}
+
+	for (i = 0; i < ctx->num_pending; i++) {
+		if (!verify_data_block(ctx->inode, vi, &ctx->pending_blocks[i],
+				       ctx->max_ra_pages))
+			return false;
+	}
+	fsverity_clear_pending_blocks(ctx);
+	return true;
+}
+
+static bool fsverity_add_data_blocks(struct fsverity_verification_context *ctx,
+				     struct folio *data_folio, size_t len,
+				     size_t offset)
+{
+	struct fsverity_info *vi = ctx->vi;
+	const struct merkle_tree_params *params = &vi->tree_params;
+	const unsigned int block_size = params->block_size;
 	u64 pos = (u64)data_folio->index << PAGE_SHIFT;
 
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
+		ctx->pending_blocks[ctx->num_pending].data =
+			kmap_local_folio(data_folio, offset);
+		ctx->pending_blocks[ctx->num_pending].pos = pos + offset;
+		if (++ctx->num_pending == ctx->max_pending &&
+		    !fsverity_verify_pending_blocks(ctx))
 			return false;
 		offset += block_size;
 		len -= block_size;
 	} while (len);
 	return true;
@@ -282,11 +369,19 @@ verify_data_blocks(struct folio *data_folio, size_t len, size_t offset,
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
+	if (fsverity_add_data_blocks(&ctx, folio, len, offset) &&
+	    fsverity_verify_pending_blocks(&ctx))
+		return true;
+	fsverity_clear_pending_blocks(&ctx);
+	return false;
 }
 EXPORT_SYMBOL_GPL(fsverity_verify_blocks);
 
 #ifdef CONFIG_BLOCK
 /**
@@ -303,10 +398,12 @@ EXPORT_SYMBOL_GPL(fsverity_verify_blocks);
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
@@ -319,17 +416,25 @@ void fsverity_verify_bio(struct bio *bio)
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
-		}
+		if (!fsverity_add_data_blocks(&ctx, fi.folio, fi.length,
+					      fi.offset))
+			goto ioerr;
 	}
+
+	if (!fsverity_verify_pending_blocks(&ctx))
+		goto ioerr;
+	return;
+
+ioerr:
+	fsverity_clear_pending_blocks(&ctx);
+	bio->bi_status = BLK_STS_IOERR;
 }
 EXPORT_SYMBOL_GPL(fsverity_verify_bio);
 #endif /* CONFIG_BLOCK */
 
 /**
-- 
2.50.1


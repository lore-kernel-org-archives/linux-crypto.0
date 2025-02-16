Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8711018027
	for <linux-crypto@vger.kernel.org>; Sun, 16 Feb 2025 03:07:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739675261; cv=none; b=DYDC7hcmhPncEcRb/WNNHaNFcWBN1ZfYopQi6E32yfjWSiHgb+Y7xcn2I6iCrAD8hhoSlRoi1Fr1LXpnsubNid4VEwdCxRCJKbVpr/Bw/YRifFdDbVO82KtkY3mkCt+5Xa4DH9SpXfdhg/Rvw/W8wmI8fBhOkjtDIO+SZyOMJw0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739675261; c=relaxed/simple;
	bh=Rjy/TlZfCvvivByd7aDUZlNoawUqdRePD1fCzBywmIQ=;
	h=Date:Message-Id:In-Reply-To:References:From:Subject:To:Cc; b=Ox3mOz0dWK07x8q9kdBivBeVXdBkQOB519xkb2rgPgoML9ZCGT1TwiyO3qrcwq5ChLSe6yGv45uox1lAMBgCFBhQ7m3+sDp9eh1iNCUDI5HKr+4VzsBQsRxH4QlB0h3Ezq57dFh18YgBs3Ng3/Z4po2oh3W35txHEtr+xleG//4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=aEcSeJwf; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="aEcSeJwf"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=Cc:To:Subject:From:References:In-Reply-To:Message-Id:Date:
	Sender:Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:
	Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
	Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
	List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=rvcAqMKpJHp+/RooV/oWQbv8bhWfOMn+9E9F8T+I0nE=; b=aEcSeJwfh7+ksuP0nyge7+J6VP
	RxOj9wYlmn4763vRR9EnAblPQJKeUMYH9+g9uDZ5v2KfwkVrFG8ifdYhxoIPiLQRxYonJO7XqKGN3
	5XxTlVVcs7sZn8yywQB6X1yLhJRciOcu7jtC7PL16+r3G84hWMO8EsiwuQMihJeht56xekaDUWnoM
	qJCxV3AjBQFT/rQp75y/jbNRROfLf77uATESTb5IiYUuZCPR1LvBhxLnzk8uriOdKJ01sy2b1xITx
	FarBhmw1ZWm7FQbEgYflK0fhAuOqaj9x1eSCgHdRJNruRha7Vz6Btpkqocedx2UjtNo5TJ/N8TjcC
	Xwww7qbw==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1tjUnP-000gaN-0b;
	Sun, 16 Feb 2025 11:07:36 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Sun, 16 Feb 2025 11:07:35 +0800
Date: Sun, 16 Feb 2025 11:07:35 +0800
Message-Id: <dd11ea3e7231fb46f68d902ba38a5b688e378bfe.1739674648.git.herbert@gondor.apana.org.au>
In-Reply-To: <cover.1739674648.git.herbert@gondor.apana.org.au>
References: <cover.1739674648.git.herbert@gondor.apana.org.au>
From: Eric Biggers <ebiggers@google.com>
Subject: [v2 PATCH 11/11] fsverity: improve performance by using multibuffer
 hashing
To: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Cc: Eric Biggers <ebiggers@kernel.org>, Ard Biesheuvel <ardb@kernel.org>, Megha Dey <megha.dey@linux.intel.com>, Tim Chen <tim.c.chen@linux.intel.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>

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

Reviewed-by: Sami Tolvanen <samitolvanen@google.com>
Acked-by: Ard Biesheuvel <ardb@kernel.org>
Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 fs/verity/fsverity_private.h |   2 +
 fs/verity/verify.c           | 179 +++++++++++++++++++++++++++++------
 2 files changed, 151 insertions(+), 30 deletions(-)

diff --git a/fs/verity/fsverity_private.h b/fs/verity/fsverity_private.h
index aecc221daf8b..3d03fb1e41f0 100644
--- a/fs/verity/fsverity_private.h
+++ b/fs/verity/fsverity_private.h
@@ -152,6 +152,8 @@ static inline void fsverity_init_signature(void)
 
 /* verify.c */
 
+#define FS_VERITY_MAX_PENDING_DATA_BLOCKS	2
+
 void __init fsverity_init_workqueue(void);
 
 #endif /* _FSVERITY_PRIVATE_H */
diff --git a/fs/verity/verify.c b/fs/verity/verify.c
index 4fcad0825a12..15bf0887a827 100644
--- a/fs/verity/verify.c
+++ b/fs/verity/verify.c
@@ -10,6 +10,27 @@
 #include <crypto/hash.h>
 #include <linux/bio.h>
 
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
+	 * This is the queue of data blocks that are pending verification.  We
+	 * allow multiple blocks to be queued up in order to support multibuffer
+	 * hashing, i.e. interleaving the hashing of multiple messages.  On many
+	 * CPUs this improves performance significantly.
+	 */
+	int num_pending;
+	struct fsverity_pending_block pending_blocks[FS_VERITY_MAX_PENDING_DATA_BLOCKS];
+};
+
 static struct workqueue_struct *fsverity_read_workqueue;
 
 /*
@@ -79,7 +100,7 @@ static bool is_hash_block_verified(struct fsverity_info *vi, struct page *hpage,
 }
 
 /*
- * Verify a single data block against the file's Merkle tree.
+ * Verify the hash of a single data block against the file's Merkle tree.
  *
  * In principle, we need to verify the entire path to the root node.  However,
  * for efficiency the filesystem may cache the hash blocks.  Therefore we need
@@ -90,8 +111,10 @@ static bool is_hash_block_verified(struct fsverity_info *vi, struct page *hpage,
  */
 static bool
 verify_data_block(struct inode *inode, struct fsverity_info *vi,
-		  const void *data, u64 data_pos, unsigned long max_ra_pages)
+		  const struct fsverity_pending_block *dblock,
+		  unsigned long max_ra_pages)
 {
+	const u64 data_pos = dblock->pos;
 	const struct merkle_tree_params *params = &vi->tree_params;
 	const unsigned int hsize = params->digest_size;
 	int level;
@@ -115,8 +138,12 @@ verify_data_block(struct inode *inode, struct fsverity_info *vi,
 	 */
 	u64 hidx = data_pos >> params->log_blocksize;
 
-	/* Up to 1 + FS_VERITY_MAX_LEVELS pages may be mapped at once */
-	BUILD_BUG_ON(1 + FS_VERITY_MAX_LEVELS > KM_MAX_IDX);
+	/*
+	 * Up to FS_VERITY_MAX_PENDING_DATA_BLOCKS + FS_VERITY_MAX_LEVELS pages
+	 * may be mapped at once.
+	 */
+	BUILD_BUG_ON(FS_VERITY_MAX_PENDING_DATA_BLOCKS +
+		     FS_VERITY_MAX_LEVELS > KM_MAX_IDX);
 
 	if (unlikely(data_pos >= inode->i_size)) {
 		/*
@@ -127,7 +154,7 @@ verify_data_block(struct inode *inode, struct fsverity_info *vi,
 		 * any part past EOF should be all zeroes.  Therefore, we need
 		 * to verify that any data blocks fully past EOF are all zeroes.
 		 */
-		if (memchr_inv(data, 0, params->block_size)) {
+		if (memchr_inv(dblock->data, 0, params->block_size)) {
 			fsverity_err(inode,
 				     "FILE CORRUPTED!  Data past EOF is not zeroed");
 			return false;
@@ -221,10 +248,8 @@ verify_data_block(struct inode *inode, struct fsverity_info *vi,
 		put_page(hpage);
 	}
 
-	/* Finally, verify the data block. */
-	if (fsverity_hash_block(params, inode, data, real_hash) != 0)
-		goto error;
-	if (memcmp(want_hash, real_hash, hsize) != 0)
+	/* Finally, verify the hash of the data block. */
+	if (memcmp(want_hash, dblock->real_hash, hsize) != 0)
 		goto corrupted;
 	return true;
 
@@ -233,7 +258,8 @@ verify_data_block(struct inode *inode, struct fsverity_info *vi,
 		     "FILE CORRUPTED! pos=%llu, level=%d, want_hash=%s:%*phN, real_hash=%s:%*phN",
 		     data_pos, level - 1,
 		     params->hash_alg->name, hsize, want_hash,
-		     params->hash_alg->name, hsize, real_hash);
+		     params->hash_alg->name, hsize,
+		     level == 0 ? dblock->real_hash : real_hash);
 error:
 	for (; level > 0; level--) {
 		kunmap_local(hblocks[level - 1].addr);
@@ -242,13 +268,91 @@ verify_data_block(struct inode *inode, struct fsverity_info *vi,
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
-	struct fsverity_info *vi = inode->i_verity_info;
-	const unsigned int block_size = vi->tree_params.block_size;
+	ctx->inode = inode;
+	ctx->vi = inode->i_verity_info;
+	ctx->max_ra_pages = max_ra_pages;
+	ctx->num_pending = 0;
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
+	struct inode *inode = ctx->inode;
+	struct fsverity_info *vi = ctx->vi;
+	const struct merkle_tree_params *params = &vi->tree_params;
+	SYNC_HASH_REQUESTS_ON_STACK(reqs, FS_VERITY_MAX_PENDING_DATA_BLOCKS, params->hash_alg->tfm);
+	struct ahash_request *req;
+	int i;
+	int err;
+
+	if (ctx->num_pending == 0)
+		return true;
+
+	req = sync_hash_requests(reqs, 0);
+	for (i = 0; i < ctx->num_pending; i++) {
+		struct ahash_request *reqi = sync_hash_requests(reqs, i);
+
+		ahash_request_set_callback(reqi, CRYPTO_TFM_REQ_MAY_SLEEP,
+					   NULL, NULL);
+		ahash_request_set_virt(reqi, ctx->pending_blocks[i].data,
+				       ctx->pending_blocks[i].real_hash,
+				       params->block_size);
+		if (i)
+			ahash_request_chain(reqi, req);
+		if (!params->hashstate)
+			continue;
+
+		err = crypto_ahash_import(reqi, params->hashstate);
+		if (err) {
+			fsverity_err(inode, "Error %d importing hash state", err);
+			return false;
+		}
+	}
+
+	if (params->hashstate)
+		err = crypto_ahash_finup(req);
+	else
+		err = crypto_ahash_digest(req);
+	if (err) {
+		fsverity_err(inode, "Error %d computing block hashes", err);
+		return false;
+	}
+
+	for (i = 0; i < ctx->num_pending; i++) {
+		if (!verify_data_block(inode, vi, &ctx->pending_blocks[i],
+				       ctx->max_ra_pages))
+			return false;
+	}
+
+	fsverity_clear_pending_blocks(ctx);
+	return true;
+}
+
+static bool
+fsverity_add_data_blocks(struct fsverity_verification_context *ctx,
+			 struct folio *data_folio, size_t len, size_t offset)
+{
+	struct fsverity_info *vi = ctx->vi;
+	const struct merkle_tree_params *params = &vi->tree_params;
+	const unsigned int block_size = params->block_size;
+	const int mb_max_msgs = FS_VERITY_MAX_PENDING_DATA_BLOCKS;
 	u64 pos = (u64)data_folio->index << PAGE_SHIFT;
 
 	if (WARN_ON_ONCE(len <= 0 || !IS_ALIGNED(len | offset, block_size)))
@@ -257,14 +361,11 @@ verify_data_blocks(struct folio *data_folio, size_t len, size_t offset,
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
+		if (++ctx->num_pending == mb_max_msgs &&
+		    !fsverity_verify_pending_blocks(ctx))
 			return false;
 		offset += block_size;
 		len -= block_size;
@@ -286,7 +387,15 @@ verify_data_blocks(struct folio *data_folio, size_t len, size_t offset,
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
 
@@ -307,6 +416,8 @@ EXPORT_SYMBOL_GPL(fsverity_verify_blocks);
  */
 void fsverity_verify_bio(struct bio *bio)
 {
+	struct inode *inode = bio_first_folio_all(bio)->mapping->host;
+	struct fsverity_verification_context ctx;
 	struct folio_iter fi;
 	unsigned long max_ra_pages = 0;
 
@@ -323,13 +434,21 @@ void fsverity_verify_bio(struct bio *bio)
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
-- 
2.39.5


Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D85223027C
	for <linux-crypto@vger.kernel.org>; Tue, 18 Feb 2025 10:10:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739873445; cv=none; b=F5BfoSM2XLdsqeJYTQh6VcX6lCl+opKe0e0S30rGivpydrAwWWNMnHVkxxwP5S469yvt9hBO/y9phK5/hcTdQEBs1j5XDzBmn/gfcinRoehGR3tvY5vxG60bJJJ0KyWL3fOK8kqCz2rj6vi3e9zgw0aSw7kiCe2eELtX4UKaiTY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739873445; c=relaxed/simple;
	bh=MKNeE3FPikUlhjXNSwj0Z/PRMxxidh3XBkGKOoG/MXM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=tF3A59wIneG54ku6usSAYCPUiuhuCWKTsQoJuuEJXScCpR1FNYTl9h2xGsYLp1UNf1X/ar7Uq85zQ6jo/qJftMFbSz0V6H+ClbSpapJEx5ng36dWHgAPkWP9wnm1zVexkn6TCOeBYF4F1+la41LBf6MuRIa/mNtrJvQtlDdwfb8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=c+eTvZPe; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="c+eTvZPe"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=gGj7nNCwiJC3DwbWjX4YCqT2DB/cJ+iWi/xYa+wezME=; b=c+eTvZPeU/SElRKbi4zGd2uYfJ
	zOVfw3+fxRgLZy4R8rU5VJ1iP+uVzc9EwSNqu8CEoWx/nE/GiHl4YxhO+XfIs+b19BM33HjdpmpZ+
	KpsPAKzEk/cWleWsXl578YSBJjcKrxuiZMxEKGxrE4rXIyC5JsNDch8WnIPzB1fiLifz1dRNxEdLm
	bYMQep9gfrLEF7fP/CNC9w3kdWuquFZGycy2D4MPDf9X0onpzOk1eiABwDkuxF6yWiwH1lsGPJbQv
	Lb3fe5csLFXuAM7gffDTmq0lOZHxFBSkgD1gOqkFu7YscwgJcqo+xjfs010WCf8+g3y17YmdtPM/8
	xwETYJJQ==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1tkKLs-001Dhi-0W;
	Tue, 18 Feb 2025 18:10:37 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Tue, 18 Feb 2025 18:10:36 +0800
Date: Tue, 18 Feb 2025 18:10:36 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Eric Biggers <ebiggers@kernel.org>
Cc: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
	Ard Biesheuvel <ardb@kernel.org>,
	Megha Dey <megha.dey@linux.intel.com>,
	Tim Chen <tim.c.chen@linux.intel.com>
Subject: Re: [v2 PATCH 00/11] Multibuffer hashing take two
Message-ID: <Z7RcnKGNGP50mdb-@gondor.apana.org.au>
References: <cover.1739674648.git.herbert@gondor.apana.org.au>
 <20250216033816.GB90952@quark.localdomain>
 <Z7HHhWZI4Nb_-sJh@gondor.apana.org.au>
 <20250216195129.GB2404@sol.localdomain>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250216195129.GB2404@sol.localdomain>

On Sun, Feb 16, 2025 at 11:51:29AM -0800, Eric Biggers wrote:
>
> But of course, there is no need to go there in the first place.  Cryptographic
> APIs should be simple and not include unnecessary edge cases.  It seems you
> still have a misconception that your more complex API would make my work useful
> for IPsec, but again that is still incorrect, as I've explained many times.  The
> latest bogus claims that you've been making, like that GHASH is not
> parallelizable, don't exactly inspire confidence either.

Sure, everyone hates complexity.  But you're not removing it.
You're simply pushing the complexity into the algorithm implementation
and more importantly, the user.  With your interface the user has to
jump through unnecessary hoops to get multiple requests going, which
is probably why you limited it to just 2.

If anything we should be pushing the complexity into the API code
itself and away from the algorithm implementation.  Why? Because
it's shared and therefore the test coverage works much better.

Look over the years at how many buggy edge cases such as block
left-overs we have had in arch crypto code.  Now if those edge
cases were moved into shared API code it would be much better.
Sure it could still be buggy, but it would affect everyone
equally and that means it's much easier to catch.

It's much easier for the fuzz tests to catch a bug in shared API
code than individual assembly code.

Here is an example the new hash interface looks like when used
in fsverity.  It allows unlimited chaining, without holding all
those unnecessary kmap's:

commit 0a0be692829c3e69a14b7b10ed412250da458825
Author: Herbert Xu <herbert@gondor.apana.org.au>
Date:   Tue Feb 18 17:46:20 2025 +0800

    fsverity: restore ahash support and remove chaining limit
    
    Use the hash interface instead of shash.  This allows the chaining
    limit to be removed as the request no longer has to be allocated on
    the stack.
    
    Memory allocations can always fail, but they *rarely* do.  Resolve
    the OOM case by using a stack request as a fallback.
    
    Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>

diff --git a/fs/verity/fsverity_private.h b/fs/verity/fsverity_private.h
index 3d03fb1e41f0..9aae3381ef92 100644
--- a/fs/verity/fsverity_private.h
+++ b/fs/verity/fsverity_private.h
@@ -20,7 +20,7 @@
 
 /* A hash algorithm supported by fs-verity */
 struct fsverity_hash_alg {
-	struct crypto_sync_hash *tfm; /* hash tfm, allocated on demand */
+	struct crypto_hash *tfm; /* hash tfm, allocated on demand */
 	const char *name;	  /* crypto API name, e.g. sha256 */
 	unsigned int digest_size; /* digest size in bytes, e.g. 32 for SHA-256 */
 	unsigned int block_size;  /* block size in bytes, e.g. 64 for SHA-256 */
diff --git a/fs/verity/hash_algs.c b/fs/verity/hash_algs.c
index e088bcfe5ed1..8c625ddee43b 100644
--- a/fs/verity/hash_algs.c
+++ b/fs/verity/hash_algs.c
@@ -43,7 +43,7 @@ const struct fsverity_hash_alg *fsverity_get_hash_alg(const struct inode *inode,
 						      unsigned int num)
 {
 	struct fsverity_hash_alg *alg;
-	struct crypto_sync_hash *tfm;
+	struct crypto_hash *tfm;
 	int err;
 
 	if (num >= ARRAY_SIZE(fsverity_hash_algs) ||
@@ -62,7 +62,7 @@ const struct fsverity_hash_alg *fsverity_get_hash_alg(const struct inode *inode,
 	if (alg->tfm != NULL)
 		goto out_unlock;
 
-	tfm = crypto_alloc_sync_hash(alg->name, 0, 0);
+	tfm = crypto_alloc_hash(alg->name, 0, 0);
 	if (IS_ERR(tfm)) {
 		if (PTR_ERR(tfm) == -ENOENT) {
 			fsverity_warn(inode,
@@ -79,20 +79,20 @@ const struct fsverity_hash_alg *fsverity_get_hash_alg(const struct inode *inode,
 	}
 
 	err = -EINVAL;
-	if (WARN_ON_ONCE(alg->digest_size != crypto_sync_hash_digestsize(tfm)))
+	if (WARN_ON_ONCE(alg->digest_size != crypto_hash_digestsize(tfm)))
 		goto err_free_tfm;
-	if (WARN_ON_ONCE(alg->block_size != crypto_sync_hash_blocksize(tfm)))
+	if (WARN_ON_ONCE(alg->block_size != crypto_hash_blocksize(tfm)))
 		goto err_free_tfm;
 
 	pr_info("%s using implementation \"%s\"\n",
-		alg->name, crypto_sync_hash_driver_name(tfm));
+		alg->name, crypto_hash_driver_name(tfm));
 
 	/* pairs with smp_load_acquire() above */
 	smp_store_release(&alg->tfm, tfm);
 	goto out_unlock;
 
 err_free_tfm:
-	crypto_free_sync_hash(tfm);
+	crypto_free_hash(tfm);
 	alg = ERR_PTR(err);
 out_unlock:
 	mutex_unlock(&fsverity_hash_alg_init_mutex);
@@ -112,7 +112,7 @@ const u8 *fsverity_prepare_hash_state(const struct fsverity_hash_alg *alg,
 				      const u8 *salt, size_t salt_size)
 {
 	u8 *hashstate = NULL;
-	SYNC_HASH_REQUEST_ON_STACK(req, alg->tfm);
+	HASH_REQUEST_ON_STACK(req, alg->tfm);
 	u8 *padded_salt = NULL;
 	size_t padded_salt_size;
 	int err;
@@ -120,7 +120,7 @@ const u8 *fsverity_prepare_hash_state(const struct fsverity_hash_alg *alg,
 	if (salt_size == 0)
 		return NULL;
 
-	hashstate = kmalloc(crypto_sync_hash_statesize(alg->tfm), GFP_KERNEL);
+	hashstate = kmalloc(crypto_hash_statesize(alg->tfm), GFP_KERNEL);
 	if (!hashstate)
 		return ERR_PTR(-ENOMEM);
 
@@ -178,7 +178,7 @@ const u8 *fsverity_prepare_hash_state(const struct fsverity_hash_alg *alg,
 int fsverity_hash_block(const struct merkle_tree_params *params,
 			const struct inode *inode, const void *data, u8 *out)
 {
-	SYNC_HASH_REQUEST_ON_STACK(req, params->hash_alg->tfm);
+	HASH_REQUEST_ON_STACK(req, params->hash_alg->tfm);
 	int err;
 
 	ahash_request_set_callback(req, CRYPTO_TFM_REQ_MAY_SLEEP, NULL, NULL);
@@ -212,7 +212,7 @@ int fsverity_hash_block(const struct merkle_tree_params *params,
 int fsverity_hash_buffer(const struct fsverity_hash_alg *alg,
 			 const void *data, size_t size, u8 *out)
 {
-	return crypto_sync_hash_digest(alg->tfm, data, size, out);
+	return crypto_hash_digest(alg->tfm, data, size, out);
 }
 
 void __init fsverity_check_hash_algs(void)
diff --git a/fs/verity/verify.c b/fs/verity/verify.c
index 15bf0887a827..092f20704a92 100644
--- a/fs/verity/verify.c
+++ b/fs/verity/verify.c
@@ -9,26 +9,21 @@
 
 #include <crypto/hash.h>
 #include <linux/bio.h>
+#include <linux/scatterlist.h>
 
 struct fsverity_pending_block {
-	const void *data;
-	u64 pos;
 	u8 real_hash[FS_VERITY_MAX_DIGEST_SIZE];
+	u64 pos;
+	struct scatterlist sg;
 };
 
 struct fsverity_verification_context {
 	struct inode *inode;
 	struct fsverity_info *vi;
 	unsigned long max_ra_pages;
-
-	/*
-	 * This is the queue of data blocks that are pending verification.  We
-	 * allow multiple blocks to be queued up in order to support multibuffer
-	 * hashing, i.e. interleaving the hashing of multiple messages.  On many
-	 * CPUs this improves performance significantly.
-	 */
-	int num_pending;
-	struct fsverity_pending_block pending_blocks[FS_VERITY_MAX_PENDING_DATA_BLOCKS];
+	struct crypto_wait wait;
+	struct ahash_request *req;
+	struct ahash_request *fbreq;
 };
 
 static struct workqueue_struct *fsverity_read_workqueue;
@@ -111,9 +106,10 @@ static bool is_hash_block_verified(struct fsverity_info *vi, struct page *hpage,
  */
 static bool
 verify_data_block(struct inode *inode, struct fsverity_info *vi,
-		  const struct fsverity_pending_block *dblock,
+		  struct ahash_request *req,
 		  unsigned long max_ra_pages)
 {
+	struct fsverity_pending_block *dblock = container_of(req->src, struct fsverity_pending_block, sg);
 	const u64 data_pos = dblock->pos;
 	const struct merkle_tree_params *params = &vi->tree_params;
 	const unsigned int hsize = params->digest_size;
@@ -138,14 +134,14 @@ verify_data_block(struct inode *inode, struct fsverity_info *vi,
 	 */
 	u64 hidx = data_pos >> params->log_blocksize;
 
-	/*
-	 * Up to FS_VERITY_MAX_PENDING_DATA_BLOCKS + FS_VERITY_MAX_LEVELS pages
-	 * may be mapped at once.
-	 */
-	BUILD_BUG_ON(FS_VERITY_MAX_PENDING_DATA_BLOCKS +
-		     FS_VERITY_MAX_LEVELS > KM_MAX_IDX);
+	/* Up to FS_VERITY_MAX_LEVELS pages may be mapped at once. */
+	BUILD_BUG_ON(FS_VERITY_MAX_LEVELS > KM_MAX_IDX);
 
 	if (unlikely(data_pos >= inode->i_size)) {
+		u8 *data = kmap_local_page(sg_page(&dblock->sg));
+		unsigned int offset = dblock->sg.offset;
+		bool nonzero;
+
 		/*
 		 * This can happen in the data page spanning EOF when the Merkle
 		 * tree block size is less than the page size.  The Merkle tree
@@ -154,7 +150,9 @@ verify_data_block(struct inode *inode, struct fsverity_info *vi,
 		 * any part past EOF should be all zeroes.  Therefore, we need
 		 * to verify that any data blocks fully past EOF are all zeroes.
 		 */
-		if (memchr_inv(dblock->data, 0, params->block_size)) {
+		nonzero = memchr_inv(data + offset, 0, params->block_size);
+		kunmap_local(data);
+		if (nonzero) {
 			fsverity_err(inode,
 				     "FILE CORRUPTED!  Data past EOF is not zeroed");
 			return false;
@@ -276,19 +274,17 @@ fsverity_init_verification_context(struct fsverity_verification_context *ctx,
 	ctx->inode = inode;
 	ctx->vi = inode->i_verity_info;
 	ctx->max_ra_pages = max_ra_pages;
-	ctx->num_pending = 0;
+	ctx->req = NULL;
+	ctx->fbreq = NULL;
 }
 
 static void
 fsverity_clear_pending_blocks(struct fsverity_verification_context *ctx)
 {
-	int i;
-
-	for (i = ctx->num_pending - 1; i >= 0; i--) {
-		kunmap_local(ctx->pending_blocks[i].data);
-		ctx->pending_blocks[i].data = NULL;
-	}
-	ctx->num_pending = 0;
+	if (ctx->req != ctx->fbreq)
+		ahash_request_free(ctx->req);
+	ctx->req = NULL;
+	ctx->fbreq = NULL;
 }
 
 static bool
@@ -297,49 +293,27 @@ fsverity_verify_pending_blocks(struct fsverity_verification_context *ctx)
 	struct inode *inode = ctx->inode;
 	struct fsverity_info *vi = ctx->vi;
 	const struct merkle_tree_params *params = &vi->tree_params;
-	SYNC_HASH_REQUESTS_ON_STACK(reqs, FS_VERITY_MAX_PENDING_DATA_BLOCKS, params->hash_alg->tfm);
-	struct ahash_request *req;
-	int i;
+	struct ahash_request *req = ctx->req;
+	struct ahash_request *r2;
 	int err;
 
-	if (ctx->num_pending == 0)
-		return true;
-
-	req = sync_hash_requests(reqs, 0);
-	for (i = 0; i < ctx->num_pending; i++) {
-		struct ahash_request *reqi = sync_hash_requests(reqs, i);
-
-		ahash_request_set_callback(reqi, CRYPTO_TFM_REQ_MAY_SLEEP,
-					   NULL, NULL);
-		ahash_request_set_virt(reqi, ctx->pending_blocks[i].data,
-				       ctx->pending_blocks[i].real_hash,
-				       params->block_size);
-		if (i)
-			ahash_request_chain(reqi, req);
-		if (!params->hashstate)
-			continue;
-
-		err = crypto_ahash_import(reqi, params->hashstate);
-		if (err) {
-			fsverity_err(inode, "Error %d importing hash state", err);
-			return false;
-		}
-	}
-
+	crypto_init_wait(&ctx->wait);
 	if (params->hashstate)
 		err = crypto_ahash_finup(req);
 	else
 		err = crypto_ahash_digest(req);
+	err = crypto_wait_req(err, &ctx->wait);
 	if (err) {
 		fsverity_err(inode, "Error %d computing block hashes", err);
 		return false;
 	}
 
-	for (i = 0; i < ctx->num_pending; i++) {
-		if (!verify_data_block(inode, vi, &ctx->pending_blocks[i],
-				       ctx->max_ra_pages))
+	if (!verify_data_block(inode, vi, req, ctx->max_ra_pages))
+		return false;
+
+	list_for_each_entry(r2, &req->base.list, base.list)
+		if (!verify_data_block(inode, vi, r2, ctx->max_ra_pages))
 			return false;
-	}
 
 	fsverity_clear_pending_blocks(ctx);
 	return true;
@@ -352,7 +326,7 @@ fsverity_add_data_blocks(struct fsverity_verification_context *ctx,
 	struct fsverity_info *vi = ctx->vi;
 	const struct merkle_tree_params *params = &vi->tree_params;
 	const unsigned int block_size = params->block_size;
-	const int mb_max_msgs = FS_VERITY_MAX_PENDING_DATA_BLOCKS;
+	struct crypto_hash *tfm = params->hash_alg->tfm;
 	u64 pos = (u64)data_folio->index << PAGE_SHIFT;
 
 	if (WARN_ON_ONCE(len <= 0 || !IS_ALIGNED(len | offset, block_size)))
@@ -361,12 +335,59 @@ fsverity_add_data_blocks(struct fsverity_verification_context *ctx,
 			 folio_test_uptodate(data_folio)))
 		return false;
 	do {
-		ctx->pending_blocks[ctx->num_pending].data =
-			kmap_local_folio(data_folio, offset);
-		ctx->pending_blocks[ctx->num_pending].pos = pos + offset;
-		if (++ctx->num_pending == mb_max_msgs &&
-		    !fsverity_verify_pending_blocks(ctx))
+		struct fsverity_pending_block fbblock;
+		struct fsverity_pending_block *block;
+		HASH_REQUEST_ON_STACK(fbreq, tfm);
+		struct ahash_request *req;
+
+		req = hash_request_alloc_extra(params->hash_alg->tfm,
+						sizeof(*block), GFP_NOFS);
+		if (req)
+			block = hash_request_extra(req);
+		else {
+			if (!fsverity_verify_pending_blocks(ctx))
+				return false;
+
+			req = fbreq;
+			block = &fbblock;
+		}
+
+		sg_init_table(&block->sg, 1);
+		sg_set_page(&block->sg,
+			    folio_page(data_folio, offset / PAGE_SIZE),
+			    block_size, offset % PAGE_SIZE);
+		block->pos = pos + offset;
+
+		ahash_request_set_callback(req, CRYPTO_TFM_REQ_MAY_SLEEP |
+						CRYPTO_TFM_REQ_MAY_BACKLOG,
+					   crypto_req_done, &ctx->wait);
+		ahash_request_set_crypt(req, &block->sg, block->real_hash,
+					block_size);
+
+		if (params->hashstate) {
+			int err = crypto_ahash_import(req, params->hashstate);
+			if (err) {
+				fsverity_err(ctx->inode, "Error %d importing hash state", err);
+				if (req != fbreq)
+					ahash_request_free(req);
+				return false;
+			}
+		}
+
+		if (ctx->req) {
+			ahash_request_chain(req, ctx->req);
+			goto next;
+		}
+
+		ctx->req = req;
+		if (req != fbreq)
+			goto next;
+
+		ctx->fbreq = fbreq;
+		if (!fsverity_verify_pending_blocks(ctx))
 			return false;
+
+next:
 		offset += block_size;
 		len -= block_size;
 	} while (len);

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt

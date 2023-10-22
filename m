Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9F94EC25B42
	for <linux-crypto@archiver.kernel.org>; Sun, 22 Oct 2023 08:19:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231626AbjJVITC (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Sun, 22 Oct 2023 04:19:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37302 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231634AbjJVISw (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sun, 22 Oct 2023 04:18:52 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CD49EDA
        for <linux-crypto@vger.kernel.org>; Sun, 22 Oct 2023 01:18:46 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9AAF6C433C8
        for <linux-crypto@vger.kernel.org>; Sun, 22 Oct 2023 08:18:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1697962726;
        bh=iOjB1N0adCnBX+lR3hMNM96Q8Ir+G0IDr77NStX6D0w=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=MdZHcC1aGn0yNc8OZ6MCA0yGU5qsVa2wEcfCrivFjBsHiUNiPPxuYbMoF6XpPhnby
         lA3rMIc//hp7wmGfxgdgJTi0dBvxOy+MuhNGVeC37svSHbaqGXRdjXYavfwhfzHMQl
         Pfc69KF7DOwuLaHl5suR+2TyxmryOHCfjafOfT7H9maEkYKMNRlf1ajeRJzdbCE+mo
         z+UNrE/H642GHR3YRsm5ks5HfAFm0TIe2DDUO9AZNH+2m0nmFwi4vyKsUUAyBQ4FNg
         /72DtphO6JvLfz27nWQnUAmpjrDR6xHCFnBrfULhvSQ3Y+43iNYnWDhgyqRNzo2CCN
         ArApVZWRKYQVQ==
From:   Eric Biggers <ebiggers@kernel.org>
To:     linux-crypto@vger.kernel.org
Subject: [PATCH 14/30] crypto: ahash - remove support for nonzero alignmask
Date:   Sun, 22 Oct 2023 01:10:44 -0700
Message-ID: <20231022081100.123613-15-ebiggers@kernel.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231022081100.123613-1-ebiggers@kernel.org>
References: <20231022081100.123613-1-ebiggers@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

From: Eric Biggers <ebiggers@google.com>

Currently, the ahash API checks the alignment of all key and result
buffers against the algorithm's declared alignmask, and for any
unaligned buffers it falls back to manually aligned temporary buffers.

This is virtually useless, however.  First, since it does not apply to
the message, its effect is much more limited than e.g. is the case for
the alignmask for "skcipher".  Second, the key and result buffers are
given as virtual addresses and cannot (in general) be DMA'ed into, so
drivers end up having to copy to/from them in software anyway.  As a
result it's easy to use memcpy() or the unaligned access helpers.

The crypto_hash_walk_*() helper functions do use the alignmask to align
the message.  But with one exception those are only used for shash
algorithms being exposed via the ahash API, not for native ahashes, and
aligning the message is not required in this case, especially now that
alignmask support has been removed from shash.  The exception is the
n2_core driver, which doesn't set an alignmask.

In any case, no ahash algorithms actually set a nonzero alignmask
anymore.  Therefore, remove support for it from ahash.  The benefit is
that all the code to handle "misaligned" buffers in the ahash API goes
away, reducing the overhead of the ahash API.

This follows the same change that was made to shash.

Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 Documentation/crypto/devel-algos.rst |   4 +-
 crypto/ahash.c                       | 117 ++-------------------------
 crypto/shash.c                       |   8 +-
 include/crypto/internal/hash.h       |   4 +-
 include/linux/crypto.h               |  27 ++++---
 5 files changed, 28 insertions(+), 132 deletions(-)

diff --git a/Documentation/crypto/devel-algos.rst b/Documentation/crypto/devel-algos.rst
index 3506899ef83e3..9b7782f4f6e0a 100644
--- a/Documentation/crypto/devel-algos.rst
+++ b/Documentation/crypto/devel-algos.rst
@@ -228,13 +228,11 @@ Note that it is perfectly legal to "abandon" a request object:
 In other words implementations should mind the resource allocation and clean-up.
 No resources related to request objects should remain allocated after a call
 to .init() or .update(), since there might be no chance to free them.
 
 
 Specifics Of Asynchronous HASH Transformation
 ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
 
 Some of the drivers will want to use the Generic ScatterWalk in case the
 implementation needs to be fed separate chunks of the scatterlist which
-contains the input data. The buffer containing the resulting hash will
-always be properly aligned to .cra_alignmask so there is no need to
-worry about this.
+contains the input data.
diff --git a/crypto/ahash.c b/crypto/ahash.c
index 213bb3e9f2451..744fd3b8ea258 100644
--- a/crypto/ahash.c
+++ b/crypto/ahash.c
@@ -28,35 +28,26 @@ static const struct crypto_type crypto_ahash_type;
 struct ahash_request_priv {
 	crypto_completion_t complete;
 	void *data;
 	u8 *result;
 	u32 flags;
 	void *ubuf[] CRYPTO_MINALIGN_ATTR;
 };
 
 static int hash_walk_next(struct crypto_hash_walk *walk)
 {
-	unsigned int alignmask = walk->alignmask;
 	unsigned int offset = walk->offset;
 	unsigned int nbytes = min(walk->entrylen,
 				  ((unsigned int)(PAGE_SIZE)) - offset);
 
 	walk->data = kmap_local_page(walk->pg);
 	walk->data += offset;
-
-	if (offset & alignmask) {
-		unsigned int unaligned = alignmask + 1 - (offset & alignmask);
-
-		if (nbytes > unaligned)
-			nbytes = unaligned;
-	}
-
 	walk->entrylen -= nbytes;
 	return nbytes;
 }
 
 static int hash_walk_new_entry(struct crypto_hash_walk *walk)
 {
 	struct scatterlist *sg;
 
 	sg = walk->sg;
 	walk->offset = sg->offset;
@@ -66,37 +57,22 @@ static int hash_walk_new_entry(struct crypto_hash_walk *walk)
 
 	if (walk->entrylen > walk->total)
 		walk->entrylen = walk->total;
 	walk->total -= walk->entrylen;
 
 	return hash_walk_next(walk);
 }
 
 int crypto_hash_walk_done(struct crypto_hash_walk *walk, int err)
 {
-	unsigned int alignmask = walk->alignmask;
-
 	walk->data -= walk->offset;
 
-	if (walk->entrylen && (walk->offset & alignmask) && !err) {
-		unsigned int nbytes;
-
-		walk->offset = ALIGN(walk->offset, alignmask + 1);
-		nbytes = min(walk->entrylen,
-			     (unsigned int)(PAGE_SIZE - walk->offset));
-		if (nbytes) {
-			walk->entrylen -= nbytes;
-			walk->data += walk->offset;
-			return nbytes;
-		}
-	}
-
 	kunmap_local(walk->data);
 	crypto_yield(walk->flags);
 
 	if (err)
 		return err;
 
 	if (walk->entrylen) {
 		walk->offset = 0;
 		walk->pg++;
 		return hash_walk_next(walk);
@@ -114,115 +90,85 @@ EXPORT_SYMBOL_GPL(crypto_hash_walk_done);
 int crypto_hash_walk_first(struct ahash_request *req,
 			   struct crypto_hash_walk *walk)
 {
 	walk->total = req->nbytes;
 
 	if (!walk->total) {
 		walk->entrylen = 0;
 		return 0;
 	}
 
-	walk->alignmask = crypto_ahash_alignmask(crypto_ahash_reqtfm(req));
 	walk->sg = req->src;
 	walk->flags = req->base.flags;
 
 	return hash_walk_new_entry(walk);
 }
 EXPORT_SYMBOL_GPL(crypto_hash_walk_first);
 
-static int ahash_setkey_unaligned(struct crypto_ahash *tfm, const u8 *key,
-				unsigned int keylen)
-{
-	unsigned long alignmask = crypto_ahash_alignmask(tfm);
-	int ret;
-	u8 *buffer, *alignbuffer;
-	unsigned long absize;
-
-	absize = keylen + alignmask;
-	buffer = kmalloc(absize, GFP_KERNEL);
-	if (!buffer)
-		return -ENOMEM;
-
-	alignbuffer = (u8 *)ALIGN((unsigned long)buffer, alignmask + 1);
-	memcpy(alignbuffer, key, keylen);
-	ret = tfm->setkey(tfm, alignbuffer, keylen);
-	kfree_sensitive(buffer);
-	return ret;
-}
-
 static int ahash_nosetkey(struct crypto_ahash *tfm, const u8 *key,
 			  unsigned int keylen)
 {
 	return -ENOSYS;
 }
 
 static void ahash_set_needkey(struct crypto_ahash *tfm)
 {
 	const struct hash_alg_common *alg = crypto_hash_alg_common(tfm);
 
 	if (tfm->setkey != ahash_nosetkey &&
 	    !(alg->base.cra_flags & CRYPTO_ALG_OPTIONAL_KEY))
 		crypto_ahash_set_flags(tfm, CRYPTO_TFM_NEED_KEY);
 }
 
 int crypto_ahash_setkey(struct crypto_ahash *tfm, const u8 *key,
 			unsigned int keylen)
 {
-	unsigned long alignmask = crypto_ahash_alignmask(tfm);
-	int err;
-
-	if ((unsigned long)key & alignmask)
-		err = ahash_setkey_unaligned(tfm, key, keylen);
-	else
-		err = tfm->setkey(tfm, key, keylen);
+	int err = tfm->setkey(tfm, key, keylen);
 
 	if (unlikely(err)) {
 		ahash_set_needkey(tfm);
 		return err;
 	}
 
 	crypto_ahash_clear_flags(tfm, CRYPTO_TFM_NEED_KEY);
 	return 0;
 }
 EXPORT_SYMBOL_GPL(crypto_ahash_setkey);
 
 static int ahash_save_req(struct ahash_request *req, crypto_completion_t cplt,
 			  bool has_state)
 {
 	struct crypto_ahash *tfm = crypto_ahash_reqtfm(req);
-	unsigned long alignmask = crypto_ahash_alignmask(tfm);
 	unsigned int ds = crypto_ahash_digestsize(tfm);
 	struct ahash_request *subreq;
 	unsigned int subreq_size;
 	unsigned int reqsize;
 	u8 *result;
 	gfp_t gfp;
 	u32 flags;
 
 	subreq_size = sizeof(*subreq);
 	reqsize = crypto_ahash_reqsize(tfm);
 	reqsize = ALIGN(reqsize, crypto_tfm_ctx_alignment());
 	subreq_size += reqsize;
 	subreq_size += ds;
-	subreq_size += alignmask & ~(crypto_tfm_ctx_alignment() - 1);
 
 	flags = ahash_request_flags(req);
 	gfp = (flags & CRYPTO_TFM_REQ_MAY_SLEEP) ?  GFP_KERNEL : GFP_ATOMIC;
 	subreq = kmalloc(subreq_size, gfp);
 	if (!subreq)
 		return -ENOMEM;
 
 	ahash_request_set_tfm(subreq, tfm);
 	ahash_request_set_callback(subreq, flags, cplt, req);
 
 	result = (u8 *)(subreq + 1) + reqsize;
-	result = PTR_ALIGN(result, alignmask + 1);
 
 	ahash_request_set_crypt(subreq, req->src, result, req->nbytes);
 
 	if (has_state) {
 		void *state;
 
 		state = kmalloc(crypto_ahash_statesize(tfm), gfp);
 		if (!state) {
 			kfree(subreq);
 			return -ENOMEM;
@@ -244,114 +190,67 @@ static void ahash_restore_req(struct ahash_request *req, int err)
 
 	if (!err)
 		memcpy(req->result, subreq->result,
 		       crypto_ahash_digestsize(crypto_ahash_reqtfm(req)));
 
 	req->priv = NULL;
 
 	kfree_sensitive(subreq);
 }
 
-static void ahash_op_unaligned_done(void *data, int err)
-{
-	struct ahash_request *areq = data;
-
-	if (err == -EINPROGRESS)
-		goto out;
-
-	/* First copy req->result into req->priv.result */
-	ahash_restore_req(areq, err);
-
-out:
-	/* Complete the ORIGINAL request. */
-	ahash_request_complete(areq, err);
-}
-
-static int ahash_op_unaligned(struct ahash_request *req,
-			      int (*op)(struct ahash_request *),
-			      bool has_state)
-{
-	int err;
-
-	err = ahash_save_req(req, ahash_op_unaligned_done, has_state);
-	if (err)
-		return err;
-
-	err = op(req->priv);
-	if (err == -EINPROGRESS || err == -EBUSY)
-		return err;
-
-	ahash_restore_req(req, err);
-
-	return err;
-}
-
-static int crypto_ahash_op(struct ahash_request *req,
-			   int (*op)(struct ahash_request *),
-			   bool has_state)
-{
-	struct crypto_ahash *tfm = crypto_ahash_reqtfm(req);
-	unsigned long alignmask = crypto_ahash_alignmask(tfm);
-	int err;
-
-	if ((unsigned long)req->result & alignmask)
-		err = ahash_op_unaligned(req, op, has_state);
-	else
-		err = op(req);
-
-	return crypto_hash_errstat(crypto_hash_alg_common(tfm), err);
-}
-
 int crypto_ahash_final(struct ahash_request *req)
 {
 	struct crypto_ahash *tfm = crypto_ahash_reqtfm(req);
 	struct hash_alg_common *alg = crypto_hash_alg_common(tfm);
 
 	if (IS_ENABLED(CONFIG_CRYPTO_STATS))
 		atomic64_inc(&hash_get_stat(alg)->hash_cnt);
 
-	return crypto_ahash_op(req, tfm->final, true);
+	return crypto_hash_errstat(alg, tfm->final(req));
 }
 EXPORT_SYMBOL_GPL(crypto_ahash_final);
 
 int crypto_ahash_finup(struct ahash_request *req)
 {
 	struct crypto_ahash *tfm = crypto_ahash_reqtfm(req);
 	struct hash_alg_common *alg = crypto_hash_alg_common(tfm);
 
 	if (IS_ENABLED(CONFIG_CRYPTO_STATS)) {
 		struct crypto_istat_hash *istat = hash_get_stat(alg);
 
 		atomic64_inc(&istat->hash_cnt);
 		atomic64_add(req->nbytes, &istat->hash_tlen);
 	}
 
-	return crypto_ahash_op(req, tfm->finup, true);
+	return crypto_hash_errstat(alg, tfm->finup(req));
 }
 EXPORT_SYMBOL_GPL(crypto_ahash_finup);
 
 int crypto_ahash_digest(struct ahash_request *req)
 {
 	struct crypto_ahash *tfm = crypto_ahash_reqtfm(req);
 	struct hash_alg_common *alg = crypto_hash_alg_common(tfm);
+	int err;
 
 	if (IS_ENABLED(CONFIG_CRYPTO_STATS)) {
 		struct crypto_istat_hash *istat = hash_get_stat(alg);
 
 		atomic64_inc(&istat->hash_cnt);
 		atomic64_add(req->nbytes, &istat->hash_tlen);
 	}
 
 	if (crypto_ahash_get_flags(tfm) & CRYPTO_TFM_NEED_KEY)
-		return crypto_hash_errstat(alg, -ENOKEY);
+		err = -ENOKEY;
+	else
+		err = tfm->digest(req);
 
-	return crypto_ahash_op(req, tfm->digest, false);
+	return crypto_hash_errstat(alg, err);
 }
 EXPORT_SYMBOL_GPL(crypto_ahash_digest);
 
 static void ahash_def_finup_done2(void *data, int err)
 {
 	struct ahash_request *areq = data;
 
 	if (err == -EINPROGRESS)
 		return;
 
diff --git a/crypto/shash.c b/crypto/shash.c
index 409b33f9c97cc..359702c2cd02b 100644
--- a/crypto/shash.c
+++ b/crypto/shash.c
@@ -534,40 +534,40 @@ struct crypto_shash *crypto_clone_shash(struct crypto_shash *hash)
 EXPORT_SYMBOL_GPL(crypto_clone_shash);
 
 int hash_prepare_alg(struct hash_alg_common *alg)
 {
 	struct crypto_istat_hash *istat = hash_get_stat(alg);
 	struct crypto_alg *base = &alg->base;
 
 	if (alg->digestsize > HASH_MAX_DIGESTSIZE)
 		return -EINVAL;
 
+	/* alignmask is not useful for hashes, so it is not supported. */
+	if (base->cra_alignmask)
+		return -EINVAL;
+
 	base->cra_flags &= ~CRYPTO_ALG_TYPE_MASK;
 
 	if (IS_ENABLED(CONFIG_CRYPTO_STATS))
 		memset(istat, 0, sizeof(*istat));
 
 	return 0;
 }
 
 static int shash_prepare_alg(struct shash_alg *alg)
 {
 	struct crypto_alg *base = &alg->halg.base;
 	int err;
 
 	if (alg->descsize > HASH_MAX_DESCSIZE)
 		return -EINVAL;
 
-	/* alignmask is not useful for shash, so it is not supported. */
-	if (base->cra_alignmask)
-		return -EINVAL;
-
 	if ((alg->export && !alg->import) || (alg->import && !alg->export))
 		return -EINVAL;
 
 	err = hash_prepare_alg(&alg->halg);
 	if (err)
 		return err;
 
 	base->cra_type = &crypto_shash_type;
 	base->cra_flags |= CRYPTO_ALG_TYPE_SHASH;
 
diff --git a/include/crypto/internal/hash.h b/include/crypto/internal/hash.h
index 8d0cd0c591a09..59c707e4dea46 100644
--- a/include/crypto/internal/hash.h
+++ b/include/crypto/internal/hash.h
@@ -11,29 +11,27 @@
 #include <crypto/algapi.h>
 #include <crypto/hash.h>
 
 struct ahash_request;
 struct scatterlist;
 
 struct crypto_hash_walk {
 	char *data;
 
 	unsigned int offset;
-	unsigned int alignmask;
+	unsigned int flags;
 
 	struct page *pg;
 	unsigned int entrylen;
 
 	unsigned int total;
 	struct scatterlist *sg;
-
-	unsigned int flags;
 };
 
 struct ahash_instance {
 	void (*free)(struct ahash_instance *inst);
 	union {
 		struct {
 			char head[offsetof(struct ahash_alg, halg.base)];
 			struct crypto_instance base;
 		} s;
 		struct ahash_alg alg;
diff --git a/include/linux/crypto.h b/include/linux/crypto.h
index f3c3a3b27facd..b164da5e129e8 100644
--- a/include/linux/crypto.h
+++ b/include/linux/crypto.h
@@ -103,21 +103,20 @@
  *	  chunk can cross a page boundary or a scatterlist element boundary.
  *    aead:
  *	- The IV buffer and all scatterlist elements must be aligned to the
  *	  algorithm's alignmask.
  *	- The first scatterlist element must contain all the associated data,
  *	  and its pages must be !PageHighMem.
  *	- If the plaintext/ciphertext were to be divided into chunks of size
  *	  crypto_aead_walksize() (with the remainder going at the end), no chunk
  *	  can cross a page boundary or a scatterlist element boundary.
  *    ahash:
- *	- The result buffer must be aligned to the algorithm's alignmask.
  *	- crypto_ahash_finup() must not be used unless the algorithm implements
  *	  ->finup() natively.
  */
 #define CRYPTO_ALG_ALLOCATES_MEMORY	0x00010000
 
 /*
  * Mark an algorithm as a service implementation only usable by a
  * template and never by a normal user of the kernel crypto API.
  * This is intended to be used by algorithms that are themselves
  * not FIPS-approved but may instead be used to implement parts of
@@ -271,32 +270,34 @@ struct compress_alg {
  *		   of the smallest possible unit which can be transformed with
  *		   this algorithm. The users must respect this value.
  *		   In case of HASH transformation, it is possible for a smaller
  *		   block than @cra_blocksize to be passed to the crypto API for
  *		   transformation, in case of any other transformation type, an
  * 		   error will be returned upon any attempt to transform smaller
  *		   than @cra_blocksize chunks.
  * @cra_ctxsize: Size of the operational context of the transformation. This
  *		 value informs the kernel crypto API about the memory size
  *		 needed to be allocated for the transformation context.
- * @cra_alignmask: Alignment mask for the input and output data buffer. The data
- *		   buffer containing the input data for the algorithm must be
- *		   aligned to this alignment mask. The data buffer for the
- *		   output data must be aligned to this alignment mask. Note that
- *		   the Crypto API will do the re-alignment in software, but
- *		   only under special conditions and there is a performance hit.
- *		   The re-alignment happens at these occasions for different
- *		   @cra_u types: cipher -- For both input data and output data
- *		   buffer; ahash -- For output hash destination buf; shash --
- *		   For output hash destination buf.
- *		   This is needed on hardware which is flawed by design and
- *		   cannot pick data from arbitrary addresses.
+ * @cra_alignmask: For cipher, skcipher, lskcipher, and aead algorithms this is
+ *		   1 less than the alignment, in bytes, that the algorithm
+ *		   implementation requires for input and output buffers.  When
+ *		   the crypto API is invoked with buffers that are not aligned
+ *		   to this alignment, the crypto API automatically utilizes
+ *		   appropriately aligned temporary buffers to comply with what
+ *		   the algorithm needs.  (For scatterlists this happens only if
+ *		   the algorithm uses the skcipher_walk helper functions.)  This
+ *		   misalignment handling carries a performance penalty, so it is
+ *		   preferred that algorithms do not set a nonzero alignmask.
+ *		   Also, crypto API users may wish to allocate buffers aligned
+ *		   to the alignmask of the algorithm being used, in order to
+ *		   avoid the API having to realign them.  Note: the alignmask is
+ *		   not supported for hash algorithms and is always 0 for them.
  * @cra_priority: Priority of this transformation implementation. In case
  *		  multiple transformations with same @cra_name are available to
  *		  the Crypto API, the kernel will use the one with highest
  *		  @cra_priority.
  * @cra_name: Generic name (usable by multiple implementations) of the
  *	      transformation algorithm. This is the name of the transformation
  *	      itself. This field is used by the kernel when looking up the
  *	      providers of particular transformation.
  * @cra_driver_name: Unique name of the transformation provider. This is the
  *		     name of the provider of the transformation. This can be any
-- 
2.42.0


Received: from pdx-out-002.esa.us-west-2.outbound.mail-perimeter.amazon.com (pdx-out-002.esa.us-west-2.outbound.mail-perimeter.amazon.com [44.246.1.125])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE7354BCAD3;
	Tue, 19 May 2026 12:00:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=44.246.1.125
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779192028; cv=none; b=lhmFXjJs/OvxmheY2NFrZR2AsfB6qrcNVCPejMKR+4uNDt7yqU1Bee1p+Y/5AGcgqhA2OakLDbOLNOiH94RoHyU5fbapsYrup3wRRLjPoVQ7/UTczyVdcFBuDT8mpqC4tt93lDijXOs8PAN006/WKibiXg1M09PEE0Ygdhc3JvA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779192028; c=relaxed/simple;
	bh=cmw5aiU/mmpjfz/z7SlEMc31GunMUvm60AbAqOeUUAc=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=GJuHMMNzu1tQjh5frNzZS4ArzWLE6Z5oUMFEqPDi2CCYuvwQaLRLe4hj8hTkRaYzDOI5vYVUPWEKDxF5nOHagwyY/9BnxQOU9PciAxqYj474stAOTy+cXVd6U1MiZ8GBR5uxSeot80y8MzahRhfUUHAYwtY7G2H33psJhMK/5wc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.com; spf=pass smtp.mailfrom=amazon.com; dkim=pass (2048-bit key) header.d=amazon.com header.i=@amazon.com header.b=q9KWbRE0; arc=none smtp.client-ip=44.246.1.125
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=amazon.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=amazon.com header.i=@amazon.com header.b="q9KWbRE0"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazoncorp2;
  t=1779192025; x=1810728025;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=UW5P8STsJj+56MEmP59ylOT5VDbq34vc6f5Ggr7qf68=;
  b=q9KWbRE0RfJwkAGZqKRYinRwXyQIkhwZDN/ek8ZZBKiEAuryQ2rHXfXs
   Gc9LraztRwdOc2rEPlgwLSJEGtyxAJpJWGRnhMxzRCKQ2AzNggjcrDmVl
   8gEh9O3fqu6bedudl+2Z1ZUJJ9LkCh5lsQs2O74mlIZWzVpeF4hecYTJo
   Ua/AWt1TNE7e1jWEuh12Ilpudity2SyOmWHWlJ+br8aD+GKOJc8hz88pI
   YJWZ6wAp3NYSN+z05kIvQcSnlQ4zds1pb55uP1Su45tg0dlwZLim9SCqw
   Lei+7KTSXrbq+5NodfIUj8w9SClPhyZERj0+r5r89kvOrveSc2GlWTWbS
   A==;
X-CSE-ConnectionGUID: /5gWueNlQ76pOlbn+Z0ZKg==
X-CSE-MsgGUID: Fq3RHgseREWhhTdZouJMOQ==
X-IronPort-AV: E=Sophos;i="6.23,243,1770595200"; 
   d="scan'208";a="19991179"
Received: from ip-10-5-12-219.us-west-2.compute.internal (HELO smtpout.naws.us-west-2.prod.farcaster.email.amazon.dev) ([10.5.12.219])
  by internal-pdx-out-002.esa.us-west-2.outbound.mail-perimeter.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 May 2026 12:00:23 +0000
Received: from EX19MTAUWB002.ant.amazon.com [205.251.233.111:16491]
 by smtpin.naws.us-west-2.prod.farcaster.email.amazon.dev [10.0.48.131:2525] with esmtp (Farcaster)
 id 95177541-f195-4a82-8748-f0bb5d5c2a00; Tue, 19 May 2026 12:00:23 +0000 (UTC)
X-Farcaster-Flow-ID: 95177541-f195-4a82-8748-f0bb5d5c2a00
Received: from EX19D001UWA001.ant.amazon.com (10.13.138.214) by
 EX19MTAUWB002.ant.amazon.com (10.250.64.231) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.37;
 Tue, 19 May 2026 12:00:20 +0000
Received: from dev-dsk-lravich-1b-7405803b.eu-west-1.amazon.com (10.13.225.95)
 by EX19D001UWA001.ant.amazon.com (10.13.138.214) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.37;
 Tue, 19 May 2026 12:00:18 +0000
From: Leonid Ravich <lravich@amazon.com>
To: Herbert Xu <herbert@gondor.apana.org.au>
CC: "David S . Miller" <davem@davemloft.net>, Mike Snitzer
	<snitzer@kernel.org>, Mikulas Patocka <mpatocka@redhat.com>, Alasdair Kergon
	<agk@redhat.com>, Ard Biesheuvel <ardb@kernel.org>, Eric Biggers
	<ebiggers@kernel.org>, Jens Axboe <axboe@kernel.dk>, Horia Geanta
	<horia.geanta@nxp.com>, Gilad Ben-Yossef <gilad@benyossef.com>,
	<linux-crypto@vger.kernel.org>, <dm-devel@lists.linux.dev>,
	<linux-block@vger.kernel.org>
Subject: [PATCH 4/4] dm crypt: batch all sectors of a bio per crypto request
Date: Tue, 19 May 2026 12:00:00 +0000
Message-ID: <20260519120002.27267-5-lravich@amazon.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260428101225.24316-1-lravich@amazon.com>
References: <20260428101225.24316-1-lravich@amazon.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: EX19D041UWB002.ant.amazon.com (10.13.139.179) To
 EX19D001UWA001.ant.amazon.com (10.13.138.214)

When the underlying skcipher driver advertises support for multiple
data units in a single request (CRYPTO_ALG_SKCIPHER_MULTI_DATA_UNIT),
configure the cipher with cc->sector_size as data_unit_size and
submit one request per bio instead of one request per sector.  This
removes per-sector overhead in the crypto API hot path: request
allocation, callback dispatch, completion handling, and SG setup.

The optimisation is enabled automatically at table load when all
of the following hold:

 - the cipher is non-aead (i.e. skcipher);
 - tfms_count is 1 (interleaved per-sector keys would break batching);
 - the IV mode is plain or plain64 (the only modes whose generator
   produces a sequential 64-bit little-endian counter that the cipher
   can extend by adding the data-unit index, matching the convention
   documented in crypto_skcipher_set_data_unit_size());
 - the iv_gen_ops->post() hook is unset (lmk and tcw use it; both are
   already excluded by the IV-mode test, but the explicit check makes
   the assumption durable against future IV modes);
 - dm-integrity is not stacked (no integrity tag or integrity IV);
 - the cipher driver advertises multi-data-unit support.

A new CRYPT_MULTI_DATA_UNIT cipher_flag, set once at construction
time, gates the multi-data-unit path.  The existing per-sector path
in crypt_convert_block_skcipher() is unchanged; the new
crypt_convert_block_skcipher_multi() is reached from a small dispatch
in crypt_convert() and shares the same backlog/-EBUSY/-EINPROGRESS
flow control with the per-sector path.

Heap-allocated scatterlists are stashed in dm_crypt_request and freed
in crypt_free_req_skcipher() to avoid races between the synchronous-
success free path and async-completion reuse from the request pool.
On -ENOMEM during scatterlist allocation, the bio is requeued via
BLK_STS_DEV_RESOURCE rather than failed, matching the behaviour of
the existing -ENOMEM path for crypto request allocation.

Verified end-to-end with a byte-equivalence test: encrypted output of
plain64 dm-crypt with the multi-data-unit path matches output of the
single-data-unit path bit-for-bit over a 256 MB device.

Signed-off-by: Leonid Ravich <lravich@amazon.com>
---
 drivers/md/dm-crypt.c | 248 ++++++++++++++++++++++++++++++++++++++++--
 1 file changed, 241 insertions(+), 7 deletions(-)

diff --git a/drivers/md/dm-crypt.c b/drivers/md/dm-crypt.c
index 5ef43231fe77..b35831d43f0e 100644
--- a/drivers/md/dm-crypt.c
+++ b/drivers/md/dm-crypt.c
@@ -98,6 +98,14 @@ struct dm_crypt_request {
 	struct scatterlist sg_in[4];
 	struct scatterlist sg_out[4];
 	u64 iv_sector;
+	/*
+	 * Heap-allocated scatterlists used by the multi-data-unit path
+	 * when one bio is processed in a single skcipher request.  NULL
+	 * when the inline sg_in[]/sg_out[] arrays above are sufficient
+	 * (single-data-unit path).  Freed in crypt_free_req_skcipher().
+	 */
+	struct scatterlist *sg_in_ext;
+	struct scatterlist *sg_out_ext;
 };
 
 struct crypt_config;
@@ -149,6 +157,7 @@ enum cipher_flags {
 	CRYPT_IV_LARGE_SECTORS,		/* Calculate IV from sector_size, not 512B sectors */
 	CRYPT_ENCRYPT_PREPROCESS,	/* Must preprocess data for encryption (elephant) */
 	CRYPT_KEY_MAC_SIZE_SET,		/* The integrity_key_size option was used */
+	CRYPT_MULTI_DATA_UNIT,		/* Batch all sectors of a bio per crypto request */
 };
 
 /*
@@ -1501,12 +1510,139 @@ static int crypt_convert_block_skcipher(struct crypt_config *cc,
 	return r;
 }
 
+/*
+ * Multi-data-unit variant of crypt_convert_block_skcipher.  Submits all
+ * remaining sectors of the current bio in one skcipher request whose
+ * data_unit_size is cc->sector_size.  The cipher walks the IV between
+ * data units (see crypto_skcipher_set_data_unit_size()).
+ *
+ * Returns the same set of values as crypt_convert_block_skcipher:
+ *   0 on synchronous success (full chunk processed),
+ *   -EINPROGRESS / -EBUSY on asynchronous dispatch,
+ *   -ENOMEM if scatterlist allocation fails (caller maps to
+ *           BLK_STS_DEV_RESOURCE so the bio is requeued, not failed),
+ *   negative errno otherwise.
+ *
+ * On success the bio iterators have been advanced by the chunk size.
+ */
+static int crypt_convert_block_skcipher_multi(struct crypt_config *cc,
+					      struct convert_context *ctx,
+					      struct skcipher_request *req,
+					      unsigned int *out_processed)
+{
+	const unsigned int sector_size = cc->sector_size;
+	unsigned int total_in = ctx->iter_in.bi_size;
+	unsigned int total_out = ctx->iter_out.bi_size;
+	unsigned int total = min(total_in, total_out);
+	unsigned int n_sectors;
+	unsigned int n_sg_in = 0, n_sg_out = 0;
+	struct dm_crypt_request *dmreq = dmreq_of_req(cc, req);
+	struct scatterlist *sg_in = NULL, *sg_out = NULL;
+	struct bvec_iter iter_in, iter_out;
+	struct bio_vec bv;
+	u8 *iv, *org_iv;
+	int r;
+
+	if (unlikely(total < sector_size))
+		return -EIO;
+	n_sectors = total / sector_size;
+	total = n_sectors * sector_size;
+
+	/*
+	 * Walk the bio_vec iterators to count how many SG entries we need
+	 * for exactly @total bytes.  bi_size of the iterators is at least
+	 * @total by construction above.
+	 */
+	iter_in = ctx->iter_in;
+	iter_in.bi_size = total;
+	__bio_for_each_segment(bv, ctx->bio_in, iter_in, iter_in)
+		n_sg_in++;
+
+	iter_out = ctx->iter_out;
+	iter_out.bi_size = total;
+	__bio_for_each_segment(bv, ctx->bio_out, iter_out, iter_out)
+		n_sg_out++;
+
+	sg_in = kmalloc_array(n_sg_in, sizeof(*sg_in), GFP_NOIO);
+	sg_out = (ctx->bio_in == ctx->bio_out) ? sg_in :
+		 kmalloc_array(n_sg_out, sizeof(*sg_out), GFP_NOIO);
+	if (!sg_in || !sg_out) {
+		kfree(sg_in);
+		if (sg_out != sg_in)
+			kfree(sg_out);
+		return -ENOMEM;
+	}
+
+	sg_init_table(sg_in, n_sg_in);
+	{
+		unsigned int i = 0;
+
+		iter_in = ctx->iter_in;
+		iter_in.bi_size = total;
+		__bio_for_each_segment(bv, ctx->bio_in, iter_in, iter_in)
+			sg_set_page(&sg_in[i++], bv.bv_page, bv.bv_len,
+				    bv.bv_offset);
+	}
+
+	if (sg_out != sg_in) {
+		unsigned int i = 0;
+
+		sg_init_table(sg_out, n_sg_out);
+		iter_out = ctx->iter_out;
+		iter_out.bi_size = total;
+		__bio_for_each_segment(bv, ctx->bio_out, iter_out, iter_out)
+			sg_set_page(&sg_out[i++], bv.bv_page, bv.bv_len,
+				    bv.bv_offset);
+	}
+
+	/*
+	 * Compute the IV for the first data unit.  The cipher will derive
+	 * IVs for subsequent data units by treating this one as a 128-bit
+	 * little-endian counter and adding the data-unit index, which
+	 * matches the layout produced by plain and plain64.
+	 */
+	dmreq->iv_sector = ctx->cc_sector;
+	if (test_bit(CRYPT_IV_LARGE_SECTORS, &cc->cipher_flags))
+		dmreq->iv_sector >>= cc->sector_shift;
+	dmreq->ctx = ctx;
+
+	iv = iv_of_dmreq(cc, dmreq);
+	org_iv = org_iv_of_dmreq(cc, dmreq);
+	r = cc->iv_gen_ops->generator(cc, org_iv, dmreq);
+	if (r < 0)
+		goto out_free_sg;
+	memcpy(iv, org_iv, cc->iv_size);
+
+	/* Stash the SG arrays for cleanup on completion / free. */
+	dmreq->sg_in_ext = sg_in;
+	dmreq->sg_out_ext = (sg_out == sg_in) ? NULL : sg_out;
+
+	skcipher_request_set_crypt(req, sg_in, sg_out, total, iv);
+
+	if (bio_data_dir(ctx->bio_in) == WRITE)
+		r = crypto_skcipher_encrypt(req);
+	else
+		r = crypto_skcipher_decrypt(req);
+
+	*out_processed = total;
+	return r;
+
+out_free_sg:
+	kfree(sg_in);
+	if (sg_out != sg_in)
+		kfree(sg_out);
+	dmreq->sg_in_ext = NULL;
+	dmreq->sg_out_ext = NULL;
+	return r;
+}
+
 static void kcryptd_async_done(void *async_req, int error);
 
 static int crypt_alloc_req_skcipher(struct crypt_config *cc,
 				     struct convert_context *ctx)
 {
 	unsigned int key_index = ctx->cc_sector & (cc->tfms_count - 1);
+	struct dm_crypt_request *dmreq;
 
 	if (!ctx->r.req) {
 		ctx->r.req = mempool_alloc(&cc->req_pool, in_interrupt() ? GFP_ATOMIC : GFP_NOIO);
@@ -1516,6 +1652,18 @@ static int crypt_alloc_req_skcipher(struct crypt_config *cc,
 
 	skcipher_request_set_tfm(ctx->r.req, cc->cipher_tfm.tfms[key_index]);
 
+	/*
+	 * Initialise the heap-allocated scatterlist pointers so that
+	 * crypt_free_req_skcipher() does not read uninitialised memory
+	 * for paths that don't take the multi-data-unit branch.  The
+	 * dmreq trailer lives in the per-bio data area which is not
+	 * zeroed by the dm core, and the request is reused from the
+	 * mempool across many bios.
+	 */
+	dmreq = dmreq_of_req(cc, ctx->r.req);
+	dmreq->sg_in_ext = NULL;
+	dmreq->sg_out_ext = NULL;
+
 	/*
 	 * Use REQ_MAY_BACKLOG so a cipher driver internally backlogs
 	 * requests if driver request queue is full.
@@ -1562,6 +1710,12 @@ static void crypt_free_req_skcipher(struct crypt_config *cc,
 				    struct skcipher_request *req, struct bio *base_bio)
 {
 	struct dm_crypt_io *io = dm_per_bio_data(base_bio, cc->per_bio_data_size);
+	struct dm_crypt_request *dmreq = dmreq_of_req(cc, req);
+
+	kfree(dmreq->sg_in_ext);
+	dmreq->sg_in_ext = NULL;
+	kfree(dmreq->sg_out_ext);
+	dmreq->sg_out_ext = NULL;
 
 	if ((struct skcipher_request *)(io + 1) != req)
 		mempool_free(req, &cc->req_pool);
@@ -1590,7 +1744,9 @@ static void crypt_free_req(struct crypt_config *cc, void *req, struct bio *base_
 static blk_status_t crypt_convert(struct crypt_config *cc,
 			 struct convert_context *ctx, bool atomic, bool reset_pending)
 {
-	unsigned int sector_step = cc->sector_size >> SECTOR_SHIFT;
+	const unsigned int sector_step = cc->sector_size >> SECTOR_SHIFT;
+	const bool multi_du = test_bit(CRYPT_MULTI_DATA_UNIT, &cc->cipher_flags);
+	unsigned int processed;
 	int r;
 
 	/*
@@ -1611,8 +1767,13 @@ static blk_status_t crypt_convert(struct crypt_config *cc,
 
 		atomic_inc(&ctx->cc_pending);
 
+		processed = cc->sector_size;
 		if (crypt_integrity_aead(cc))
 			r = crypt_convert_block_aead(cc, ctx, ctx->r.req_aead, ctx->tag_offset);
+		else if (multi_du)
+			r = crypt_convert_block_skcipher_multi(cc, ctx,
+							       ctx->r.req,
+							       &processed);
 		else
 			r = crypt_convert_block_skcipher(cc, ctx, ctx->r.req, ctx->tag_offset);
 
@@ -1634,8 +1795,19 @@ static blk_status_t crypt_convert(struct crypt_config *cc,
 					 * exit and continue processing in a workqueue
 					 */
 					ctx->r.req = NULL;
-					ctx->tag_offset++;
-					ctx->cc_sector += sector_step;
+					if (!multi_du) {
+						ctx->tag_offset++;
+						ctx->cc_sector += sector_step;
+					} else {
+						bio_advance_iter(ctx->bio_in,
+								 &ctx->iter_in,
+								 processed);
+						bio_advance_iter(ctx->bio_out,
+								 &ctx->iter_out,
+								 processed);
+						ctx->cc_sector +=
+							processed >> SECTOR_SHIFT;
+					}
 					return BLK_STS_DEV_RESOURCE;
 				}
 			} else {
@@ -1649,19 +1821,42 @@ static blk_status_t crypt_convert(struct crypt_config *cc,
 		 */
 		case -EINPROGRESS:
 			ctx->r.req = NULL;
-			ctx->tag_offset++;
-			ctx->cc_sector += sector_step;
+			if (!multi_du) {
+				ctx->tag_offset++;
+				ctx->cc_sector += sector_step;
+			} else {
+				bio_advance_iter(ctx->bio_in, &ctx->iter_in,
+						 processed);
+				bio_advance_iter(ctx->bio_out, &ctx->iter_out,
+						 processed);
+				ctx->cc_sector += processed >> SECTOR_SHIFT;
+			}
 			continue;
 		/*
 		 * The request was already processed (synchronously).
 		 */
 		case 0:
 			atomic_dec(&ctx->cc_pending);
-			ctx->cc_sector += sector_step;
-			ctx->tag_offset++;
+			if (!multi_du) {
+				ctx->cc_sector += sector_step;
+				ctx->tag_offset++;
+			} else {
+				bio_advance_iter(ctx->bio_in, &ctx->iter_in,
+						 processed);
+				bio_advance_iter(ctx->bio_out, &ctx->iter_out,
+						 processed);
+				ctx->cc_sector += processed >> SECTOR_SHIFT;
+			}
 			if (!atomic)
 				cond_resched();
 			continue;
+		/*
+		 * Out of memory for the multi-DU SG arrays — bounce back
+		 * to the caller for requeue rather than failing the bio.
+		 */
+		case -ENOMEM:
+			atomic_dec(&ctx->cc_pending);
+			return BLK_STS_DEV_RESOURCE;
 		/*
 		 * There was a data integrity error.
 		 */
@@ -3142,6 +3337,45 @@ static int crypt_ctr_cipher(struct dm_target *ti, char *cipher_in, char *key)
 		}
 	}
 
+	/*
+	 * Enable multi-data-unit batching when the cipher supports it and
+	 * the IV layout is one we can derive per-DU from a single starting
+	 * IV: plain or plain64 produce a sequential 64-bit little-endian
+	 * counter, which matches the convention of
+	 * crypto_skcipher_set_data_unit_size().  Restrict to the simple
+	 * case (single tfm, no integrity, no per-sector post() callback)
+	 * to keep the consumer path small; modes like essiv, lmk, tcw,
+	 * eboiv, plain64be, random, null, benbi, and elephant are
+	 * deliberately excluded because their generators or post-IV hooks
+	 * cannot be re-derived by the cipher between data units.
+	 */
+	if (!crypt_integrity_aead(cc) && cc->tfms_count == 1 &&
+	    cc->iv_gen_ops &&
+	    (cc->iv_gen_ops == &crypt_iv_plain_ops ||
+	     cc->iv_gen_ops == &crypt_iv_plain64_ops) &&
+	    !cc->iv_gen_ops->post &&
+	    !cc->integrity_tag_size && !cc->integrity_iv_size &&
+	    crypto_skcipher_supports_multi_data_unit(cc->cipher_tfm.tfms[0])) {
+		ret = crypto_skcipher_set_data_unit_size(cc->cipher_tfm.tfms[0],
+							 cc->sector_size);
+		if (!ret) {
+			set_bit(CRYPT_MULTI_DATA_UNIT, &cc->cipher_flags);
+			DMINFO("Using multi-data-unit crypto offload (du=%u)",
+			       cc->sector_size);
+		} else {
+			/*
+			 * The driver advertised the capability via cra_flags
+			 * but rejected the requested data unit size.  This is
+			 * a driver bug worth seeing in dmesg; fall back to
+			 * the per-sector path so the device still activates.
+			 */
+			DMWARN_LIMIT("multi-DU offload disabled: %s rejected du=%u (%d)",
+				     crypto_skcipher_driver_name(cc->cipher_tfm.tfms[0]),
+				     cc->sector_size, ret);
+			ret = 0;
+		}
+	}
+
 	/* wipe the kernel key payload copy */
 	if (cc->key_string)
 		memset(cc->key, 0, cc->key_size * sizeof(u8));
-- 
2.47.3


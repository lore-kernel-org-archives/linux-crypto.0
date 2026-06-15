Received: from pdx-out-013.esa.us-west-2.outbound.mail-perimeter.amazon.com (pdx-out-013.esa.us-west-2.outbound.mail-perimeter.amazon.com [34.218.115.239])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3323B3E3DBB;
	Mon, 15 Jun 2026 11:15:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=34.218.115.239
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781522117; cv=none; b=agEmpMMT+BI+po2li/owFrwL3PvE58XdvN4qPhnykMv19LTPHWZ5ueWtcDAsXWhwT4Sk99Ztxvi0NY6UleGwnw8nBuPo1jF6NCsMsqT8ozVzyJIAqlolucA5M/WBo1Sp20CEy41PLXllfC74lFF2BtQYjuLv2t/37pvHz9Kp1a0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781522117; c=relaxed/simple;
	bh=givqApBd1z3ikwCVvCZHP5VbAmBxnIvXEMeO6ONi/AE=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=LjuzjwTnHBF4NH/gcWN3KwFApdUVTTZjArSTcJ3ykNQHNwdzBzJY0L8q+tsVoyIhCPS55FLCm5tsxksAwliIbh2jYvvBWtxsgaSn4CiImsgoA6v1bwo2ojq7Fd1+xLHsX07MFyz2V90a02LvF1DvY7ejhJU6TdLG+Jk5N3rh+aM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.com; spf=pass smtp.mailfrom=amazon.com; dkim=pass (2048-bit key) header.d=amazon.com header.i=@amazon.com header.b=mrbDY/8e; arc=none smtp.client-ip=34.218.115.239
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=amazon.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=amazon.com header.i=@amazon.com header.b="mrbDY/8e"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazoncorp2;
  t=1781522115; x=1813058115;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=6DQKUBc8vy9hke6V6MN2fhvts/vCRiqqrLeYQ+y0u3w=;
  b=mrbDY/8elIXWirZjRETz6KqApHlCHKFSe6iFeHSIL2OBxhQJj/PpXH7o
   USsP2S4Y8l54Oku3Hy2BxNwNnRU1Fdl4EROLE/QdIyVBU9r7kERF6d3gS
   4A0/80+6BzaHiG4Kw7Dt4FtnTWsPkvQ5LrNu7D3k7RogxSfMrcVF71y3s
   bdmSyENI9qdzT9MaUYyi6n0npbXXlc2q/W9ZTbslwryXvICKAm3FpiEl8
   Q9TnM/YZWiCVBorLekyoHodpOxbux7gzjpwefo1uUiPK6zOJvDmwVo77n
   b58Xeh9qZtxT6RfNVtmsj9hY5CPLs1eoLKWydi0WxIXWpO5WrJznhu9V7
   A==;
X-CSE-ConnectionGUID: dE/WWH8qSqiBRf052Nyj3w==
X-CSE-MsgGUID: ZFm8VP33TC6Rp7FPOaGdpg==
X-IronPort-AV: E=Sophos;i="6.24,206,1774310400"; 
   d="scan'208";a="21559217"
Received: from ip-10-5-0-115.us-west-2.compute.internal (HELO smtpout.naws.us-west-2.prod.farcaster.email.amazon.dev) ([10.5.0.115])
  by internal-pdx-out-013.esa.us-west-2.outbound.mail-perimeter.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Jun 2026 11:15:12 +0000
Received: from EX19MTAUWC001.ant.amazon.com [205.251.233.105:6960]
 by smtpin.naws.us-west-2.prod.farcaster.email.amazon.dev [10.0.63.253:2525] with esmtp (Farcaster)
 id 2b372b3b-699f-4c4f-b598-e388e7267d48; Mon, 15 Jun 2026 11:15:12 +0000 (UTC)
X-Farcaster-Flow-ID: 2b372b3b-699f-4c4f-b598-e388e7267d48
Received: from EX19D001UWA001.ant.amazon.com (10.13.138.214) by
 EX19MTAUWC001.ant.amazon.com (10.250.64.174) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.37;
 Mon, 15 Jun 2026 11:15:11 +0000
Received: from dev-dsk-lravich-1b-7405803b.eu-west-1.amazon.com (10.13.225.95)
 by EX19D001UWA001.ant.amazon.com (10.13.138.214) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.37;
 Mon, 15 Jun 2026 11:15:10 +0000
From: Leonid Ravich <lravich@amazon.com>
To: Herbert Xu <herbert@gondor.apana.org.au>
CC: Alasdair Kergon <agk@redhat.com>, Ard Biesheuvel <ardb@kernel.org>, "Eric
 Biggers" <ebiggers@kernel.org>, Jens Axboe <axboe@kernel.dk>, Horia Geanta
	<horia.geanta@nxp.com>, Gilad Ben-Yossef <gilad@benyossef.com>,
	<linux-crypto@vger.kernel.org>, <dm-devel@lists.linux.dev>,
	<linux-block@vger.kernel.org>
Subject: [PATCH v4 3/3] dm crypt: batch all sectors of a bio per crypto request
Date: Mon, 15 Jun 2026 11:14:59 +0000
Message-ID: <20260615111459.9452-4-lravich@amazon.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260615111459.9452-1-lravich@amazon.com>
References: <20260615111459.9452-1-lravich@amazon.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: EX19D035UWA004.ant.amazon.com (10.13.139.109) To
 EX19D001UWA001.ant.amazon.com (10.13.138.214)

Submit one skcipher request per bio with
skcipher_request_set_data_unit_size(req, cc->sector_size) instead of
issuing one request per sector.  This removes per-sector overhead in
the crypto API hot path: request allocation, callback dispatch,
completion handling, and SG setup.

The optimisation is enabled automatically at table load when all
of the following hold:

 - the cipher is non-aead (i.e. skcipher), sync, tfms_count 1;
 - the IV mode advertises sector_iv_le128, i.e. its per-sector IV
   advances as a 128-bit LE counter, matching the convention
   documented in skcipher_request_set_data_unit_size().  Only plain64
   sets it today (its 64-bit LE counter extends correctly); plain is
   excluded as its 32-bit counter wraps differently across a
   2^32-sector boundary;
 - ivsize is 16 (the core rejects other sizes with -EOPNOTSUPP);
 - the iv_gen_ops->post() hook is unset;
 - dm-integrity is not stacked (no integrity tag or integrity IV).

The cipher driver does not need to advertise anything: the crypto
API auto-splits multi-data-unit requests for drivers that cannot
handle them natively, so dm-crypt sees the same fast batched
submission contract regardless of the underlying driver.

A new CRYPT_MULTI_DATA_UNIT cipher_flag, set once at construction
time, gates the multi-data-unit dispatch.  The existing per-sector
path in crypt_convert_block_skcipher() is unchanged; the new
crypt_convert_block_skcipher_multi() is reached from a small
dispatch in crypt_convert() and shares the same backlog/-EBUSY/
-EINPROGRESS flow control with the per-sector path.

Heap-allocated scatterlists are stashed in dm_crypt_request and
freed in crypt_free_req_skcipher() to avoid races between the
synchronous-success free path and async-completion reuse from the
request pool.  On scatterlist allocation failure the helper returns
-EAGAIN, and the core returns -EOPNOTSUPP if a driver turns out
unable to do multi-DU; crypt_convert() handles both by clearing its
local multi_du flag and falling back to the per-sector path for the
rest of the current crypt_convert() invocation, ensuring forward progress
on the swap-out-to-dm-crypt path even under total memory exhaustion
(the per-sector path uses only cc->req_pool, a mempool with
reservoir set up at table-load time, and the inline
dmreq->sg_in[]/sg_out[] arrays — no allocation that could fail).

Verified end-to-end with a byte-equivalence test: encrypted output
of plain64 dm-crypt with the multi-data-unit path matches output of
the single-data-unit path bit-for-bit over a 256 MB device, with
xts-aes-aesni driving the auto-split path.

Signed-off-by: Leonid Ravich <lravich@amazon.com>
---
 drivers/md/dm-crypt.c | 215 ++++++++++++++++++++++++++++++++++++++++--
 1 file changed, 207 insertions(+), 8 deletions(-)

diff --git a/drivers/md/dm-crypt.c b/drivers/md/dm-crypt.c
index 608b617fb817..bfb98dd876d7 100644
--- a/drivers/md/dm-crypt.c
+++ b/drivers/md/dm-crypt.c
@@ -101,6 +101,9 @@ struct dm_crypt_request {
 	struct scatterlist sg_in[4];
 	struct scatterlist sg_out[4];
 	u64 iv_sector;
+	/* Multi-data-unit SG arrays, NULL when sg_in[]/sg_out[] suffice. */
+	struct scatterlist *sg_in_ext;
+	struct scatterlist *sg_out_ext;
 };
 
 struct crypt_config;
@@ -115,6 +118,12 @@ struct crypt_iv_operations {
 			 struct dm_crypt_request *dmreq);
 	void (*post)(struct crypt_config *cc, u8 *iv,
 		     struct dm_crypt_request *dmreq);
+	/*
+	 * The per-sector IV advances as a 128-bit LE counter, so a bio's
+	 * consecutive sectors share one starting IV and can be batched into
+	 * a single skcipher request via data_unit_size.
+	 */
+	bool sector_iv_le128;
 };
 
 struct iv_benbi_private {
@@ -151,6 +160,7 @@ enum cipher_flags {
 	CRYPT_IV_LARGE_SECTORS,		/* Calculate IV from sector_size, not 512B sectors */
 	CRYPT_ENCRYPT_PREPROCESS,	/* Must preprocess data for encryption (elephant) */
 	CRYPT_KEY_MAC_SIZE_SET,		/* The integrity_key_size option was used */
+	CRYPT_MULTI_DATA_UNIT,		/* Batch all sectors of a bio per crypto request */
 };
 
 /*
@@ -1018,7 +1028,8 @@ static const struct crypt_iv_operations crypt_iv_plain_ops = {
 };
 
 static const struct crypt_iv_operations crypt_iv_plain64_ops = {
-	.generator = crypt_iv_plain64_gen
+	.generator = crypt_iv_plain64_gen,
+	.sector_iv_le128 = true,
 };
 
 static const struct crypt_iv_operations crypt_iv_plain64be_ops = {
@@ -1426,12 +1437,126 @@ static int crypt_convert_block_skcipher(struct crypt_config *cc,
 	return r;
 }
 
+/*
+ * Submit all remaining sectors of the current bio in one skcipher request.
+ * Same return convention as crypt_convert_block_skcipher() except for
+ * -EAGAIN, which the caller must treat as "disable multi-DU and re-enter
+ * the per-sector path" so swap-out-to-dm-crypt always makes forward
+ * progress on the mempool reserve.
+ */
+static int crypt_convert_block_skcipher_multi(struct crypt_config *cc,
+					      struct convert_context *ctx,
+					      struct skcipher_request *req,
+					      unsigned int *out_processed)
+{
+	const unsigned int sector_size = cc->sector_size;
+	const gfp_t gfp = GFP_NOIO | __GFP_NORETRY | __GFP_NOWARN;
+	unsigned int total = ctx->iter_in.bi_size;
+	unsigned int n_sg_in = 0, n_sg_out = 0;
+	struct dm_crypt_request *dmreq = dmreq_of_req(cc, req);
+	struct scatterlist *sg_in = NULL, *sg_out = NULL;
+	struct bvec_iter iter_in, iter_out;
+	struct bio_vec bv;
+	u8 *iv, *org_iv;
+	int r;
+
+	if (WARN_ON_ONCE(ctx->iter_in.bi_size != ctx->iter_out.bi_size))
+		return -EIO;
+	if (unlikely(total & (sector_size - 1)))
+		return -EIO;
+
+	iter_in = ctx->iter_in;
+	iter_in.bi_size = total;
+	__bio_for_each_bvec(bv, ctx->bio_in, iter_in, iter_in)
+		n_sg_in++;
+
+	iter_out = ctx->iter_out;
+	iter_out.bi_size = total;
+	__bio_for_each_bvec(bv, ctx->bio_out, iter_out, iter_out)
+		n_sg_out++;
+
+	sg_in = kmalloc_array(n_sg_in, sizeof(*sg_in), gfp);
+	sg_out = (ctx->bio_in == ctx->bio_out) ? sg_in :
+		 kmalloc_array(n_sg_out, sizeof(*sg_out), gfp);
+	if (!sg_in || !sg_out) {
+		kfree(sg_in);
+		if (sg_out != sg_in)
+			kfree(sg_out);
+		return -EAGAIN;
+	}
+
+	sg_init_table(sg_in, n_sg_in);
+	{
+		unsigned int i = 0;
+
+		iter_in = ctx->iter_in;
+		iter_in.bi_size = total;
+		__bio_for_each_bvec(bv, ctx->bio_in, iter_in, iter_in)
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
+		__bio_for_each_bvec(bv, ctx->bio_out, iter_out, iter_out)
+			sg_set_page(&sg_out[i++], bv.bv_page, bv.bv_len,
+				    bv.bv_offset);
+	}
+
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
+	dmreq->sg_in_ext = sg_in;
+	dmreq->sg_out_ext = (sg_out == sg_in) ? NULL : sg_out;
+
+	skcipher_request_set_crypt(req, sg_in, sg_out, total, iv);
+	skcipher_request_set_data_unit_size(req, sector_size);
+
+	if (bio_data_dir(ctx->bio_in) == WRITE)
+		r = crypto_skcipher_encrypt(req);
+	else
+		r = crypto_skcipher_decrypt(req);
+
+	/*
+	 * Sync error: kcryptd_async_done won't run, so free the SG
+	 * arrays here.  Async returns (-EINPROGRESS, -EBUSY) hand
+	 * ownership to the completion callback.
+	 */
+	if (r && r != -EINPROGRESS && r != -EBUSY)
+		goto out_free_sg;
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
@@ -1441,6 +1566,11 @@ static int crypt_alloc_req_skcipher(struct crypt_config *cc,
 
 	skcipher_request_set_tfm(ctx->r.req, cc->cipher_tfm.tfms[key_index]);
 
+	/* Multi-DU SG arrays are owned by the helper that allocates them. */
+	dmreq = dmreq_of_req(cc, ctx->r.req);
+	dmreq->sg_in_ext = NULL;
+	dmreq->sg_out_ext = NULL;
+
 	/*
 	 * Use REQ_MAY_BACKLOG so a cipher driver internally backlogs
 	 * requests if driver request queue is full.
@@ -1487,6 +1617,12 @@ static void crypt_free_req_skcipher(struct crypt_config *cc,
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
@@ -1515,7 +1651,9 @@ static void crypt_free_req(struct crypt_config *cc, void *req, struct bio *base_
 static blk_status_t crypt_convert(struct crypt_config *cc,
 			 struct convert_context *ctx, bool atomic, bool reset_pending)
 {
-	unsigned int sector_step = cc->sector_size >> SECTOR_SHIFT;
+	const unsigned int sector_step = cc->sector_size >> SECTOR_SHIFT;
+	bool multi_du = test_bit(CRYPT_MULTI_DATA_UNIT, &cc->cipher_flags);
+	unsigned int processed;
 	int r;
 
 	/*
@@ -1536,8 +1674,13 @@ static blk_status_t crypt_convert(struct crypt_config *cc,
 
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
 
@@ -1559,8 +1702,19 @@ static blk_status_t crypt_convert(struct crypt_config *cc,
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
@@ -1574,19 +1728,41 @@ static blk_status_t crypt_convert(struct crypt_config *cc,
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
+		/* Multi-DU rejected (no memory or sync-only mismatch): fall back. */
+		case -EAGAIN:
+		case -EOPNOTSUPP:
+			atomic_dec(&ctx->cc_pending);
+			multi_du = false;
+			continue;
 		/*
 		 * There was a data integrity error.
 		 */
@@ -3063,6 +3239,29 @@ static int crypt_ctr_cipher(struct dm_target *ti, char *cipher_in, char *key)
 		}
 	}
 
+	/*
+	 * Enable multi-data-unit batching only when per-DU IVs can be
+	 * derived from one starting IV as a 128-bit LE counter, matching
+	 * skcipher_request_set_data_unit_size().  Only IV modes flagged
+	 * sector_iv_le128 qualify (plain64; not plain, whose 32-bit counter
+	 * wraps differently across a 2^32-sector boundary).  ivsize must be
+	 * 16 (the core rejects otherwise) and the cipher must be sync,
+	 * single-tfm, no integrity, no per-sector post() hook.  The driver
+	 * advertises nothing: the core auto-splits for drivers that lack
+	 * native support.
+	 */
+	if (!crypt_integrity_aead(cc) && cc->tfms_count == 1 &&
+	    cc->iv_gen_ops && cc->iv_gen_ops->sector_iv_le128 &&
+	    !cc->iv_gen_ops->post &&
+	    !cc->integrity_tag_size && !cc->integrity_iv_size &&
+	    crypto_skcipher_ivsize(any_tfm(cc)) == 16 &&
+	    !(crypto_skcipher_alg(any_tfm(cc))->base.cra_flags &
+	      CRYPTO_ALG_ASYNC)) {
+		set_bit(CRYPT_MULTI_DATA_UNIT, &cc->cipher_flags);
+		DMINFO("Using multi-data-unit crypto offload (du=%u)",
+		       cc->sector_size);
+	}
+
 	/* wipe the kernel key payload copy */
 	if (cc->key_string)
 		memset(cc->key, 0, cc->key_size * sizeof(u8));
-- 
2.47.3


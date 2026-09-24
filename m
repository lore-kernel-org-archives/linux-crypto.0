Received: from pdx-out-011.esa.us-west-2.outbound.mail-perimeter.amazon.com (pdx-out-011.esa.us-west-2.outbound.mail-perimeter.amazon.com [52.35.192.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B98CD43F4DA;
	Thu, 24 Sep 2026 07:59:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=52.35.192.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790236774; cv=none; b=cCEE+4Oej5CdZJnlMkUeDOdURJ6/T8SkjDWiTCeqvixlaUZqKVRCIJ5HcEEM1R0waRgUHnHU5qeuCKA9fw8miWROWcK1iRljs1u5zbHL+LD986BDHqlfwMXzVqbXWMhWV8TurL4EqrrgqdDUcZalM7ksl7m823Gs/nOTBbQj+BI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790236774; c=relaxed/simple;
	bh=BKCT1WDmDFal5x2/3WzCjapvuYD9S1cY0r8uhuKWZ6U=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=MTNUzVKz6uj0Y6H4VddBnLcTKWzttw4ZWHSFxsTKEc7aC01E1G8cYjXPw3OdcHsAKVTfz1yntCtBtRbrsbb83dHzBwI01k4YNIJMOFeaZPPigSrrvt9HnMZVXhEjGkI1osbo5lGEnEED6xZMpA/A/vh6SSOCx1asOV4BIp/iIhU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.com; spf=pass smtp.mailfrom=amazon.com; dkim=pass (2048-bit key) header.d=amazon.com header.i=@amazon.com header.b=L6Hl5ijS; arc=none smtp.client-ip=52.35.192.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=amazon.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=amazon.com header.i=@amazon.com header.b="L6Hl5ijS"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazoncorp2;
  t=1790236771; x=1821772771;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=d0A6yBEKB5pIlMDOPiNvgUgiwxwya8mWjEPJIwGfWGU=;
  b=L6Hl5ijSDJpiLuOm+BOXehxh50kzAMdgCNvn5GeO4yKkNLrHDYZkM9/k
   QINdljxIeTTySOBO3394ffyWJ6JnPuOOxeXzMNi4LhHKbFgffSNtFgZ0o
   RrWY+NMSgTuaR07/0LKZz+x4ILN3A08jf26RHmyisArYWbcJ2EDtNeSjp
   aHrzQmCxCviExoZrRhPIW3J1bORlTxthMknm+1l48ZOovT4Qmz2T9OJYV
   Y3ysumBjeVCw7Gw1U/X/nY3aynhfPa/694L07hDLcIsOsINiTvynRnGjj
   RvoCwzx53xR1iQBRBWJrz+fn+TgGcZzicJsDHhtkLHBXZyULiTQwT1mKa
   g==;
X-CSE-ConnectionGUID: tcZ4UgvyQ6+TY6f8BaqESg==
X-CSE-MsgGUID: Va2iXJLfRbqMFKjQMHhZ6A==
X-IronPort-AV: E=Sophos;i="6.27,120,1787011200"; 
   d="scan'208";a="29282609"
Received: from ip-10-5-12-219.us-west-2.compute.internal (HELO smtpout.naws.us-west-2.prod.farcaster.email.amazon.dev) ([10.5.12.219])
  by internal-pdx-out-011.esa.us-west-2.outbound.mail-perimeter.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Sep 2026 07:59:27 +0000
Received: from EX19MTAUWA001.ant.amazon.com [205.251.233.182:18184]
 by smtpin.naws.us-west-2.prod.farcaster.email.amazon.dev [10.0.45.34:2525] with esmtp (Farcaster)
 id 24cf0b7e-0a37-47c9-8099-317faaf3a0cd; Thu, 24 Sep 2026 07:59:27 +0000 (UTC)
X-Farcaster-Flow-ID: 24cf0b7e-0a37-47c9-8099-317faaf3a0cd
Received: from EX19D001UWA001.ant.amazon.com (10.13.138.214) by
 EX19MTAUWA001.ant.amazon.com (10.250.64.217) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.49;
 Thu, 24 Sep 2026 07:59:27 +0000
Received: from dev-dsk-lravich-1b-7405803b.eu-west-1.amazon.com (10.13.225.95)
 by EX19D001UWA001.ant.amazon.com (10.13.138.214) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.49;
 Thu, 24 Sep 2026 07:59:25 +0000
From: Leonid Ravich <lravich@amazon.com>
To: <linux-crypto@vger.kernel.org>, <dm-devel@lists.linux.dev>
CC: <herbert@gondor.apana.org.au>, <davem@davemloft.net>,
	<ebiggers@kernel.org>, <agk@redhat.com>, <snitzer@kernel.org>,
	<mpatocka@redhat.com>, <bmarzins@redhat.com>, <linux-kernel@vger.kernel.org>
Subject: [PATCH v6 6/6] dm crypt: batch a bio segment's sectors via multi-unit requests
Date: Thu, 24 Sep 2026 07:58:46 +0000
Message-ID: <20260924075846.28203-7-lravich@amazon.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260924075846.28203-1-lravich@amazon.com>
References: <20260924075846.28203-1-lravich@amazon.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: EX19D036UWC002.ant.amazon.com (10.13.139.242) To
 EX19D001UWA001.ant.amazon.com (10.13.138.214)

For eligible configurations, submit one skcipher request per contiguous
bio segment instead of one per sector: set
skcipher_request::unit_size = cc->sector_size and hand the crypto API
the whole segment (e.g. the default 512-byte sector with a 4 KiB
bio_vec -> one request of 8 data units), using only the existing inline
single-entry scatterlist -- no per-bio allocation.

Eligible means the per-sector IV is a little-endian data-unit-number
counter in the low 64 bits with a step of exactly one per unit: plain64
and essiv (essiv qualifies because its IV input is le64(sector) -- the
salt encryption lives in the essiv() template), single-tfm, non-aead,
sector_size 512 or iv_large_sectors, and no integrity metadata
(per-sector tags/IVs need the per-sector loop).  plain64be is not
batched: its on-disk IV is a big-endian counter in the high 8 bytes,
not the little-endian low-limb layout the API-layer split walks, so it
keeps the per-sector path (batching it would need a template producing
that layout).  Everything else likewise keeps the existing
one-sector-per-request path unchanged.  Since the API-layer transparent
split is synchronous, an async cipher batches only if it handles
multi-unit requests natively (CRYPTO_ALG_REQ_SEG).

Batching is byte-for-byte identical to the per-sector path: ciphertext
verified bit-identical to an unpatched baseline for plain64 and essiv.

Signed-off-by: Leonid Ravich <lravich@amazon.com>
---
 drivers/md/dm-crypt.c | 136 +++++++++++++++++++++++++++++++++++-------
 1 file changed, 114 insertions(+), 22 deletions(-)

diff --git a/drivers/md/dm-crypt.c b/drivers/md/dm-crypt.c
index 608b617fb817..ffb66c7c7a65 100644
--- a/drivers/md/dm-crypt.c
+++ b/drivers/md/dm-crypt.c
@@ -115,6 +115,15 @@ struct crypt_iv_operations {
 			 struct dm_crypt_request *dmreq);
 	void (*post)(struct crypt_config *cc, u8 *iv,
 		     struct dm_crypt_request *dmreq);
+
+	/*
+	 * Set for IV modes whose per-sector IV is a little-endian
+	 * data-unit-number counter (IV(s+i) == IV(s)+i) placed in the low
+	 * 64-bit limb, enabling multi-unit batching via the skcipher API-layer
+	 * split.  Clear for non-counter modes (lmk, tcw, ...) and for counter
+	 * modes whose on-disk IV is not that layout (e.g. plain64be).
+	 */
+	bool unit_counter;
 };
 
 struct iv_benbi_private {
@@ -151,6 +160,7 @@ enum cipher_flags {
 	CRYPT_IV_LARGE_SECTORS,		/* Calculate IV from sector_size, not 512B sectors */
 	CRYPT_ENCRYPT_PREPROCESS,	/* Must preprocess data for encryption (elephant) */
 	CRYPT_KEY_MAC_SIZE_SET,		/* The integrity_key_size option was used */
+	CRYPT_MULTI_DATA_UNIT,		/* Batch a bio segment's sectors per crypto request */
 };
 
 /*
@@ -1018,15 +1028,23 @@ static const struct crypt_iv_operations crypt_iv_plain_ops = {
 };
 
 static const struct crypt_iv_operations crypt_iv_plain64_ops = {
-	.generator = crypt_iv_plain64_gen
+	.generator = crypt_iv_plain64_gen,
+	.unit_counter = true,
 };
 
 static const struct crypt_iv_operations crypt_iv_plain64be_ops = {
-	.generator = crypt_iv_plain64be_gen
+	.generator = crypt_iv_plain64be_gen,
+	/*
+	 * No unit_counter: the big-endian, high-limb on-disk layout is not the
+	 * little-endian low-limb counter the API-layer split walks.  Batching
+	 * it needs a template producing this layout; unbatched for now.
+	 */
 };
 
 static const struct crypt_iv_operations crypt_iv_essiv_ops = {
-	.generator = crypt_iv_essiv_gen
+	.generator = crypt_iv_essiv_gen,
+	/* IV input is le64(sector); the salt-encrypt lives in essiv(). */
+	.unit_counter = true,
 };
 
 static const struct crypt_iv_operations crypt_iv_benbi_ops = {
@@ -1349,21 +1367,51 @@ static int crypt_convert_block_aead(struct crypt_config *cc,
 	return r;
 }
 
+/*
+ * Bytes to process in one skcipher request: a whole contiguous segment when
+ * batching (multi-data-unit), else one sector.  0 means an unusable
+ * (sub-sector / misaligned) segment.
+ */
+static unsigned int crypt_skcipher_len(struct crypt_config *cc,
+				       const struct bio_vec *bv_in,
+				       const struct bio_vec *bv_out)
+{
+	const unsigned int sector_size = cc->sector_size;
+
+	if (test_bit(CRYPT_MULTI_DATA_UNIT, &cc->cipher_flags))
+		return round_down(min(bv_in->bv_len, bv_out->bv_len),
+				  sector_size);
+
+	/* Reject unexpected unaligned bio. */
+	if (unlikely(bv_in->bv_len & (sector_size - 1)))
+		return 0;
+	return sector_size;
+}
+
+/*
+ * Encrypt/decrypt one bio segment (one sector, or a whole segment when
+ * batching) and report the bytes done in *out_processed.  The integrity /
+ * preprocess / post handling is inert when batching (crypt_can_batch_units()
+ * excludes those configs).
+ */
 static int crypt_convert_block_skcipher(struct crypt_config *cc,
 					struct convert_context *ctx,
 					struct skcipher_request *req,
-					unsigned int tag_offset)
+					unsigned int tag_offset,
+					unsigned int *out_processed)
 {
 	struct bio_vec bv_in = bio_iter_iovec(ctx->bio_in, ctx->iter_in);
 	struct bio_vec bv_out = bio_iter_iovec(ctx->bio_out, ctx->iter_out);
+	const unsigned int sector_size = cc->sector_size;
 	struct scatterlist *sg_in, *sg_out;
 	struct dm_crypt_request *dmreq;
 	u8 *iv, *org_iv, *tag_iv;
 	__le64 *sector;
+	unsigned int len;
 	int r = 0;
 
-	/* Reject unexpected unaligned bio. */
-	if (unlikely(bv_in.bv_len & (cc->sector_size - 1)))
+	len = crypt_skcipher_len(cc, &bv_in, &bv_out);
+	if (unlikely(!len))
 		return -EIO;
 
 	dmreq = dmreq_of_req(cc, req);
@@ -1386,10 +1434,10 @@ static int crypt_convert_block_skcipher(struct crypt_config *cc,
 	sg_out = &dmreq->sg_out[0];
 
 	sg_init_table(sg_in, 1);
-	sg_set_page(sg_in, bv_in.bv_page, cc->sector_size, bv_in.bv_offset);
+	sg_set_page(sg_in, bv_in.bv_page, len, bv_in.bv_offset);
 
 	sg_init_table(sg_out, 1);
-	sg_set_page(sg_out, bv_out.bv_page, cc->sector_size, bv_out.bv_offset);
+	sg_set_page(sg_out, bv_out.bv_page, len, bv_out.bv_offset);
 
 	if (cc->iv_gen_ops) {
 		/* For READs use IV stored in integrity metadata */
@@ -1410,7 +1458,9 @@ static int crypt_convert_block_skcipher(struct crypt_config *cc,
 		memcpy(iv, org_iv, cc->iv_size);
 	}
 
-	skcipher_request_set_crypt(req, sg_in, sg_out, cc->sector_size, iv);
+	skcipher_request_set_crypt(req, sg_in, sg_out, len, iv);
+	if (test_bit(CRYPT_MULTI_DATA_UNIT, &cc->cipher_flags))
+		skcipher_request_set_unit_size(req, sector_size);
 
 	if (bio_data_dir(ctx->bio_in) == WRITE)
 		r = crypto_skcipher_encrypt(req);
@@ -1420,9 +1470,10 @@ static int crypt_convert_block_skcipher(struct crypt_config *cc,
 	if (!r && cc->iv_gen_ops && cc->iv_gen_ops->post)
 		cc->iv_gen_ops->post(cc, org_iv, dmreq);
 
-	bio_advance_iter(ctx->bio_in, &ctx->iter_in, cc->sector_size);
-	bio_advance_iter(ctx->bio_out, &ctx->iter_out, cc->sector_size);
+	bio_advance_iter(ctx->bio_in, &ctx->iter_in, len);
+	bio_advance_iter(ctx->bio_out, &ctx->iter_out, len);
 
+	*out_processed = len;
 	return r;
 }
 
@@ -1509,13 +1560,25 @@ static void crypt_free_req(struct crypt_config *cc, void *req, struct bio *base_
 		crypt_free_req_skcipher(cc, req, base_bio);
 }
 
+/*
+ * Advance the IV-sector and integrity-tag cursors by @processed bytes; the
+ * bio iterators are advanced by the per-block helpers themselves.
+ */
+static void crypt_convert_advance(struct crypt_config *cc,
+				  struct convert_context *ctx,
+				  unsigned int processed)
+{
+	ctx->cc_sector += processed >> SECTOR_SHIFT;
+	ctx->tag_offset += processed / cc->sector_size;
+}
+
 /*
  * Encrypt / decrypt data from one bio to another one (can be the same one)
  */
 static blk_status_t crypt_convert(struct crypt_config *cc,
 			 struct convert_context *ctx, bool atomic, bool reset_pending)
 {
-	unsigned int sector_step = cc->sector_size >> SECTOR_SHIFT;
+	unsigned int processed;
 	int r;
 
 	/*
@@ -1536,10 +1599,12 @@ static blk_status_t crypt_convert(struct crypt_config *cc,
 
 		atomic_inc(&ctx->cc_pending);
 
+		processed = cc->sector_size;
 		if (crypt_integrity_aead(cc))
 			r = crypt_convert_block_aead(cc, ctx, ctx->r.req_aead, ctx->tag_offset);
 		else
-			r = crypt_convert_block_skcipher(cc, ctx, ctx->r.req, ctx->tag_offset);
+			r = crypt_convert_block_skcipher(cc, ctx, ctx->r.req,
+							 ctx->tag_offset, &processed);
 
 		switch (r) {
 		/*
@@ -1559,8 +1624,7 @@ static blk_status_t crypt_convert(struct crypt_config *cc,
 					 * exit and continue processing in a workqueue
 					 */
 					ctx->r.req = NULL;
-					ctx->tag_offset++;
-					ctx->cc_sector += sector_step;
+					crypt_convert_advance(cc, ctx, processed);
 					return BLK_STS_DEV_RESOURCE;
 				}
 			} else {
@@ -1574,16 +1638,14 @@ static blk_status_t crypt_convert(struct crypt_config *cc,
 		 */
 		case -EINPROGRESS:
 			ctx->r.req = NULL;
-			ctx->tag_offset++;
-			ctx->cc_sector += sector_step;
+			crypt_convert_advance(cc, ctx, processed);
 			continue;
 		/*
 		 * The request was already processed (synchronously).
 		 */
 		case 0:
 			atomic_dec(&ctx->cc_pending);
-			ctx->cc_sector += sector_step;
-			ctx->tag_offset++;
+			crypt_convert_advance(cc, ctx, processed);
 			if (!atomic)
 				cond_resched();
 			continue;
@@ -2345,12 +2407,28 @@ static int crypt_alloc_tfms_aead(struct crypt_config *cc, char *ciphermode)
 	return 0;
 }
 
+/*
+ * Whether multi-unit batching applies: a counter IV mode (unit_counter set),
+ * single-tfm, non-aead, and a per-unit IV step of exactly one (512B sectors
+ * or iv_large_sectors).  The IV must also satisfy the API split's counter
+ * constraints (non-zero multiple of 8, <= 32 bytes).  Integrity is excluded
+ * in crypt_ctr_cipher(), which runs after integrity is configured.
+ */
+static bool crypt_can_batch_units(struct crypt_config *cc)
+{
+	return !crypt_integrity_aead(cc) && cc->tfms_count == 1 &&
+		cc->iv_gen_ops && cc->iv_gen_ops->unit_counter &&
+		cc->iv_size && IS_ALIGNED(cc->iv_size, sizeof(__le64)) &&
+		cc->iv_size <= 32 &&
+		(cc->sector_size == (1 << SECTOR_SHIFT) ||
+		 test_bit(CRYPT_IV_LARGE_SECTORS, &cc->cipher_flags));
+}
+
 static int crypt_alloc_tfms(struct crypt_config *cc, char *ciphermode)
 {
 	if (crypt_integrity_aead(cc))
 		return crypt_alloc_tfms_aead(cc, ciphermode);
-	else
-		return crypt_alloc_tfms_skcipher(cc, ciphermode);
+	return crypt_alloc_tfms_skcipher(cc, ciphermode);
 }
 
 static unsigned int crypt_subkey_size(struct crypt_config *cc)
@@ -2999,7 +3077,6 @@ static int crypt_ctr_cipher_old(struct dm_target *ti, char *cipher_in, char *key
 		goto bad_mem;
 	}
 
-	/* Allocate cipher */
 	ret = crypt_alloc_tfms(cc, cipher_api);
 	if (ret < 0) {
 		ti->error = "Error allocating crypto tfm";
@@ -3063,6 +3140,21 @@ static int crypt_ctr_cipher(struct dm_target *ti, char *cipher_in, char *key)
 		}
 	}
 
+	/*
+	 * Enable multi-unit batching for an eligible config with no integrity
+	 * (integrity is set up after cipher alloc, hence the re-check here).
+	 * The API layer's transparent split is synchronous, so an async cipher
+	 * batches only if it handles multi-unit requests natively.
+	 */
+	if (crypt_can_batch_units(cc) && !cc->integrity_tag_size &&
+	    !cc->integrity_iv_size &&
+	    (crypto_skcipher_alg(any_tfm(cc))->co.base.cra_flags &
+	     (CRYPTO_ALG_ASYNC | CRYPTO_ALG_REQ_SEG)) != CRYPTO_ALG_ASYNC) {
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


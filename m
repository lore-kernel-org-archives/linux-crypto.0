Received: from pdx-out-008.esa.us-west-2.outbound.mail-perimeter.amazon.com (pdx-out-008.esa.us-west-2.outbound.mail-perimeter.amazon.com [52.42.203.116])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 877561C84D7;
	Tue, 30 Jun 2026 08:34:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=52.42.203.116
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782808493; cv=none; b=r4Ml2bO3v6HG2RZcJuk3nPue35FySsApW/VjUn9T3NE9zJq/gaRWa2Qhkuc4/Vc8P1QFJQgsV88XJ1Y+kzEitpMbACASldMyeZcfnaFqRLwMDhC5tw4hCW+YpDeAw93oV/swqe2Th2TJeIn7qPaphRG/2v6/BXzo/p42qLWp6U8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782808493; c=relaxed/simple;
	bh=MT973WI+1zLDLKuJCpoqZ7cguYVZCHjb6uoO1khLiaE=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ZyY5xYOfgdvKW+8rQ+W1dnlNiOqC2vphN3GyklV1K01BkJqjL3uMpQLjwitXZu03lqFtNnWkY/TS/g5jDqaCNpoAe+dnBixLEMRaShzT5/dtiWvThobbAT4zf7nXc6RwJYO7/vVn6EKLVu5tmszH0s0NHwCyjALn+1outRuMK4Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.com; spf=pass smtp.mailfrom=amazon.com; dkim=pass (2048-bit key) header.d=amazon.com header.i=@amazon.com header.b=P6d7E/7m; arc=none smtp.client-ip=52.42.203.116
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=amazon.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=amazon.com header.i=@amazon.com header.b="P6d7E/7m"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazoncorp2;
  t=1782808491; x=1814344491;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=Bx0GQOmsTclm6TCG9H7S3q+B3WBObT6DmJ7WoGwiFH4=;
  b=P6d7E/7mxwDKCfRu88ZqmW1iFYxg5TGwqyXA8TAU8+/TsgJwCC0WwNNL
   wYjr7WuCmNL5pePP3TDr12F6EcJZivjECT+j2fDvvyXfeWu0tMQAYyc6X
   3bjRSr2BtNi/MGDrP2RIYMJ+WOjfDi1JjjOW3iulTIDYVI53xGrOpJ9Xw
   22vP/48oVts1FfldUMVIR/xuiHemahyA64sIPZkS/7M2vVHWvQgUcYV/s
   h4H9LNUMTQZuZCJIZGZR+LwWcNfYWaqgFr2w6zW/sDrfZ7R9yzyXOO1q6
   tzk94gjwJAHQzR9doy9ctfXkTriBn1Eu/z95O97csHhcBEBAAXw68hp+3
   Q==;
X-CSE-ConnectionGUID: KDirh4L/TiS4BtzGEyMrhA==
X-CSE-MsgGUID: +2eQZ5w4RBO+oEd85Liu4g==
X-IronPort-AV: E=Sophos;i="6.24,233,1774310400"; 
   d="scan'208";a="22777039"
Received: from ip-10-5-0-115.us-west-2.compute.internal (HELO smtpout.naws.us-west-2.prod.farcaster.email.amazon.dev) ([10.5.0.115])
  by internal-pdx-out-008.esa.us-west-2.outbound.mail-perimeter.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Jun 2026 08:34:48 +0000
Received: from EX19MTAUWA002.ant.amazon.com [205.251.233.178:12729]
 by smtpin.naws.us-west-2.prod.farcaster.email.amazon.dev [10.0.30.151:2525] with esmtp (Farcaster)
 id a931eed2-86b9-445e-bf2a-2513aa59ff2a; Tue, 30 Jun 2026 08:34:48 +0000 (UTC)
X-Farcaster-Flow-ID: a931eed2-86b9-445e-bf2a-2513aa59ff2a
Received: from EX19D001UWA001.ant.amazon.com (10.13.138.214) by
 EX19MTAUWA002.ant.amazon.com (10.250.64.202) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.43;
 Tue, 30 Jun 2026 08:34:47 +0000
Received: from dev-dsk-lravich-1b-7405803b.eu-west-1.amazon.com (10.13.225.95)
 by EX19D001UWA001.ant.amazon.com (10.13.138.214) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.43;
 Tue, 30 Jun 2026 08:34:46 +0000
From: Leonid Ravich <lravich@amazon.com>
To: <linux-crypto@vger.kernel.org>, <dm-devel@lists.linux.dev>
CC: <linux-block@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<herbert@gondor.apana.org.au>, <davem@davemloft.net>, <ebiggers@kernel.org>,
	<snitzer@kernel.org>, <mpatocka@redhat.com>, <axboe@kernel.dk>
Subject: [PATCH v5 4/5] dm crypt: batch a bio segment's sectors via dun()
Date: Tue, 30 Jun 2026 08:34:30 +0000
Message-ID: <20260630083431.2772-5-lravich@amazon.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260630083431.2772-1-lravich@amazon.com>
References: <20260630083431.2772-1-lravich@amazon.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: EX19D044UWA001.ant.amazon.com (10.13.139.100) To
 EX19D001UWA001.ant.amazon.com (10.13.138.214)

Submit one skcipher request per contiguous bio segment (a single
bio_vec) with data_unit_size = cc->sector_size, instead of one request
per sector.  E.g. the default 512-byte sector with a 4 KiB bio_vec
becomes one request of 8 data units; the crypto layer (the dun()
template, or a native driver) walks the per-sector IV as a data-unit
counter.  Because a bio_vec is one contiguous segment, the request uses
only the existing inline dmreq->sg_in[0]/sg_out[0] entry -- no per-bio
scatterlist allocation, and no regression on small random I/O.

crypt_alloc_tfms() wraps the skcipher in dun(<cipher>,<endian>) when
crypt_can_batch_dun() holds: an IV mode that is a data-unit counter (its
crypt_iv_operations sets dun_endian to the counter endianness -- "le" for
plain64, "be" for plain64be; non-counter modes such as lmk/tcw/eboiv
leave it NULL and are excluded), single-tfm, non-aead, and sector_size
512 or iv_large_sectors so the per-unit IV step is exactly one.  This is
the same kind of name rewrite as essiv(), done in the one alloc helper so
callers are unchanged.

DM_CRYPT selects CRYPTO_DUN and dun() resolves against a sync inner
cipher, so wrapping has no acceptable failure that the bare cipher would
survive -- there is no fallback; any error propagates.  (A config whose
only xts provider is async with no generic CRYPTO_XTS would now fail to
activate rather than silently run per-sector; generic xts is selected by
the dependency chain, so this does not arise in practice.)

crypt_convert_block_skcipher() handles both cases in one function: the
length is crypt_skcipher_len() -- a whole contiguous segment when
batching, else a single sector -- and data_unit_size is set
unconditionally (a dun() tfm reads it; a plain skcipher ignores it).  It
advances the bio iterators itself (as the aead path already does) and
reports the bytes processed, so crypt_convert() advances cc_sector /
tag_offset uniformly via one helper, no per-case duplication.

Verified byte-equivalent to the per-sector path: plain64 and plain64be
dm-crypt with dun() produce ciphertext bit-identical to an unpatched
kernel over a 256 MB device (xts-aes driving the split).

Signed-off-by: Leonid Ravich <lravich@amazon.com>
---
 drivers/md/Kconfig    |   1 +
 drivers/md/dm-crypt.c | 208 +++++++++++++++++++++++++++++++++---------
 2 files changed, 166 insertions(+), 43 deletions(-)

diff --git a/drivers/md/Kconfig b/drivers/md/Kconfig
index a3fcdca7e6db..e8e299566374 100644
--- a/drivers/md/Kconfig
+++ b/drivers/md/Kconfig
@@ -299,6 +299,7 @@ config DM_CRYPT
 	select CRC32
 	select CRYPTO
 	select CRYPTO_CBC
+	select CRYPTO_DUN # multi-data-unit batching of contiguous sectors
 	select CRYPTO_ESSIV
 	select CRYPTO_LIB_AES
 	select CRYPTO_LIB_MD5 # needed by lmk IV mode
diff --git a/drivers/md/dm-crypt.c b/drivers/md/dm-crypt.c
index 608b617fb817..44938223ad3e 100644
--- a/drivers/md/dm-crypt.c
+++ b/drivers/md/dm-crypt.c
@@ -115,6 +115,13 @@ struct crypt_iv_operations {
 			 struct dm_crypt_request *dmreq);
 	void (*post)(struct crypt_config *cc, u8 *iv,
 		     struct dm_crypt_request *dmreq);
+
+	/*
+	 * Counter endianness ("le"/"be") for IV modes whose per-sector IV is a
+	 * data-unit-number counter (IV(s+i) == IV(s)+i), batchable via
+	 * dun(<cipher>,<dun_endian>).  NULL for non-counter modes (lmk, tcw, ...).
+	 */
+	const char *dun_endian;
 };
 
 struct iv_benbi_private {
@@ -151,6 +158,7 @@ enum cipher_flags {
 	CRYPT_IV_LARGE_SECTORS,		/* Calculate IV from sector_size, not 512B sectors */
 	CRYPT_ENCRYPT_PREPROCESS,	/* Must preprocess data for encryption (elephant) */
 	CRYPT_KEY_MAC_SIZE_SET,		/* The integrity_key_size option was used */
+	CRYPT_MULTI_DATA_UNIT,		/* Batch a bio segment's sectors per crypto request */
 };
 
 /*
@@ -1018,15 +1026,19 @@ static const struct crypt_iv_operations crypt_iv_plain_ops = {
 };
 
 static const struct crypt_iv_operations crypt_iv_plain64_ops = {
-	.generator = crypt_iv_plain64_gen
+	.generator = crypt_iv_plain64_gen,
+	.dun_endian = "le",
 };
 
 static const struct crypt_iv_operations crypt_iv_plain64be_ops = {
-	.generator = crypt_iv_plain64be_gen
+	.generator = crypt_iv_plain64be_gen,
+	.dun_endian = "be",
 };
 
 static const struct crypt_iv_operations crypt_iv_essiv_ops = {
-	.generator = crypt_iv_essiv_gen
+	.generator = crypt_iv_essiv_gen,
+	/* IV input is le64(sector); the salt-encrypt lives in essiv(). */
+	.dun_endian = "le",
 };
 
 static const struct crypt_iv_operations crypt_iv_benbi_ops = {
@@ -1349,21 +1361,51 @@ static int crypt_convert_block_aead(struct crypt_config *cc,
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
+ * preprocess / post handling is inert when batching (crypt_can_batch_dun()
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
@@ -1386,10 +1428,10 @@ static int crypt_convert_block_skcipher(struct crypt_config *cc,
 	sg_out = &dmreq->sg_out[0];
 
 	sg_init_table(sg_in, 1);
-	sg_set_page(sg_in, bv_in.bv_page, cc->sector_size, bv_in.bv_offset);
+	sg_set_page(sg_in, bv_in.bv_page, len, bv_in.bv_offset);
 
 	sg_init_table(sg_out, 1);
-	sg_set_page(sg_out, bv_out.bv_page, cc->sector_size, bv_out.bv_offset);
+	sg_set_page(sg_out, bv_out.bv_page, len, bv_out.bv_offset);
 
 	if (cc->iv_gen_ops) {
 		/* For READs use IV stored in integrity metadata */
@@ -1410,7 +1452,9 @@ static int crypt_convert_block_skcipher(struct crypt_config *cc,
 		memcpy(iv, org_iv, cc->iv_size);
 	}
 
-	skcipher_request_set_crypt(req, sg_in, sg_out, cc->sector_size, iv);
+	skcipher_request_set_crypt(req, sg_in, sg_out, len, iv);
+	/* A dun() tfm reads this; a plain skcipher ignores it (len is one sector). */
+	skcipher_request_set_data_unit_size(req, sector_size);
 
 	if (bio_data_dir(ctx->bio_in) == WRITE)
 		r = crypto_skcipher_encrypt(req);
@@ -1420,9 +1464,10 @@ static int crypt_convert_block_skcipher(struct crypt_config *cc,
 	if (!r && cc->iv_gen_ops && cc->iv_gen_ops->post)
 		cc->iv_gen_ops->post(cc, org_iv, dmreq);
 
-	bio_advance_iter(ctx->bio_in, &ctx->iter_in, cc->sector_size);
-	bio_advance_iter(ctx->bio_out, &ctx->iter_out, cc->sector_size);
+	bio_advance_iter(ctx->bio_in, &ctx->iter_in, len);
+	bio_advance_iter(ctx->bio_out, &ctx->iter_out, len);
 
+	*out_processed = len;
 	return r;
 }
 
@@ -1509,13 +1554,25 @@ static void crypt_free_req(struct crypt_config *cc, void *req, struct bio *base_
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
@@ -1536,10 +1593,12 @@ static blk_status_t crypt_convert(struct crypt_config *cc,
 
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
@@ -1559,8 +1618,7 @@ static blk_status_t crypt_convert(struct crypt_config *cc,
 					 * exit and continue processing in a workqueue
 					 */
 					ctx->r.req = NULL;
-					ctx->tag_offset++;
-					ctx->cc_sector += sector_step;
+					crypt_convert_advance(cc, ctx, processed);
 					return BLK_STS_DEV_RESOURCE;
 				}
 			} else {
@@ -1574,16 +1632,14 @@ static blk_status_t crypt_convert(struct crypt_config *cc,
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
@@ -2345,12 +2401,37 @@ static int crypt_alloc_tfms_aead(struct crypt_config *cc, char *ciphermode)
 	return 0;
 }
 
+/*
+ * Whether to wrap the cipher in dun() for multi-data-unit batching: a counter
+ * IV mode (dun_endian set: plain64 "le", plain64be "be", essiv "le"), single-
+ * tfm, non-aead, and a per-unit IV step of exactly one (512B sectors or
+ * iv_large_sectors).  Integrity is configured
+ * after alloc, so it is re-checked post-alloc in crypt_ctr_cipher(); an
+ * integrity config keeps an inert dun() wrapper but never sets the batch flag.
+ */
+static bool crypt_can_batch_dun(struct crypt_config *cc)
+{
+	return !crypt_integrity_aead(cc) && cc->tfms_count == 1 &&
+		cc->iv_gen_ops && cc->iv_gen_ops->dun_endian &&
+		(cc->sector_size == (1 << SECTOR_SHIFT) ||
+		 test_bit(CRYPT_IV_LARGE_SECTORS, &cc->cipher_flags));
+}
+
 static int crypt_alloc_tfms(struct crypt_config *cc, char *ciphermode)
 {
+	char dun_api[CRYPTO_MAX_ALG_NAME];
+
 	if (crypt_integrity_aead(cc))
 		return crypt_alloc_tfms_aead(cc, ciphermode);
-	else
-		return crypt_alloc_tfms_skcipher(cc, ciphermode);
+
+	/* Wrap in dun() for batching when eligible (like the essiv() rewrite). */
+	if (crypt_can_batch_dun(cc)) {
+		if (snprintf(dun_api, sizeof(dun_api), "dun(%s,%s)", ciphermode,
+			     cc->iv_gen_ops->dun_endian) >= (int)sizeof(dun_api))
+			return -ENAMETOOLONG;
+		ciphermode = dun_api;
+	}
+	return crypt_alloc_tfms_skcipher(cc, ciphermode);
 }
 
 static unsigned int crypt_subkey_size(struct crypt_config *cc)
@@ -2747,25 +2828,15 @@ static void crypt_dtr(struct dm_target *ti)
 	dm_audit_log_dtr(DM_MSG_PREFIX, ti, 1);
 }
 
-static int crypt_ctr_ivmode(struct dm_target *ti, const char *ivmode)
+/*
+ * Select cc->iv_gen_ops from the IV mode string -- pure parsing, no tfm
+ * dependency, so it runs before alloc and lets crypt_can_batch_dun() see the
+ * mode.  The tfm-dependent IV sizing is finished later by crypt_ctr_ivmode().
+ */
+static int crypt_select_ivmode(struct dm_target *ti, const char *ivmode)
 {
 	struct crypt_config *cc = ti->private;
 
-	if (crypt_integrity_aead(cc))
-		cc->iv_size = crypto_aead_ivsize(any_tfm_aead(cc));
-	else
-		cc->iv_size = crypto_skcipher_ivsize(any_tfm(cc));
-
-	if (cc->iv_size)
-		/* at least a 64 bit sector number should fit in our buffer */
-		cc->iv_size = max(cc->iv_size,
-				  (unsigned int)(sizeof(u64) / sizeof(u8)));
-	else if (ivmode) {
-		DMWARN("Selected cipher does not support IVs");
-		ivmode = NULL;
-	}
-
-	/* Choose ivmode, see comments at iv code. */
 	if (ivmode == NULL)
 		cc->iv_gen_ops = NULL;
 	else if (strcmp(ivmode, "plain") == 0)
@@ -2803,12 +2874,8 @@ static int crypt_ctr_ivmode(struct dm_target *ti, const char *ivmode)
 		}
 	} else if (strcmp(ivmode, "tcw") == 0) {
 		cc->iv_gen_ops = &crypt_iv_tcw_ops;
-		cc->key_parts += 2; /* IV + whitening */
-		cc->key_extra_size = cc->iv_size + TCW_WHITENING_SIZE;
 	} else if (strcmp(ivmode, "random") == 0) {
 		cc->iv_gen_ops = &crypt_iv_random_ops;
-		/* Need storage space in integrity fields. */
-		cc->integrity_iv_size = cc->iv_size;
 	} else {
 		ti->error = "Invalid IV mode";
 		return -EINVAL;
@@ -2817,6 +2884,37 @@ static int crypt_ctr_ivmode(struct dm_target *ti, const char *ivmode)
 	return 0;
 }
 
+static int crypt_ctr_ivmode(struct dm_target *ti, const char *ivmode)
+{
+	struct crypt_config *cc = ti->private;
+
+	if (crypt_integrity_aead(cc))
+		cc->iv_size = crypto_aead_ivsize(any_tfm_aead(cc));
+	else
+		cc->iv_size = crypto_skcipher_ivsize(any_tfm(cc));
+
+	if (cc->iv_size)
+		/* at least a 64 bit sector number should fit in our buffer */
+		cc->iv_size = max(cc->iv_size,
+				  (unsigned int)(sizeof(u64) / sizeof(u8)));
+	else if (ivmode) {
+		DMWARN("Selected cipher does not support IVs");
+		ivmode = NULL;
+		cc->iv_gen_ops = NULL;
+	}
+
+	/* Finish the tfm-dependent IV sizing; modes are already selected. */
+	if (cc->iv_gen_ops == &crypt_iv_tcw_ops) {
+		cc->key_parts += 2; /* IV + whitening */
+		cc->key_extra_size = cc->iv_size + TCW_WHITENING_SIZE;
+	} else if (cc->iv_gen_ops == &crypt_iv_random_ops) {
+		/* Need storage space in integrity fields. */
+		cc->integrity_iv_size = cc->iv_size;
+	}
+
+	return 0;
+}
+
 /*
  * Workaround to parse HMAC algorithm from AEAD crypto API spec.
  * The HMAC is needed to calculate tag size (HMAC digest size).
@@ -2914,7 +3012,12 @@ static int crypt_ctr_cipher_new(struct dm_target *ti, char *cipher_in, char *key
 
 	cc->key_parts = cc->tfms_count;
 
-	/* Allocate cipher */
+	/* Select IV mode before alloc so dun() wrapping can be decided. */
+	ret = crypt_select_ivmode(ti, *ivmode);
+	if (ret < 0)
+		return ret;
+
+	/* Allocate cipher (skcipher may be wrapped in dun()). */
 	ret = crypt_alloc_tfms(cc, cipher_api);
 	if (ret < 0) {
 		ti->error = "Error allocating crypto tfm";
@@ -2999,7 +3102,13 @@ static int crypt_ctr_cipher_old(struct dm_target *ti, char *cipher_in, char *key
 		goto bad_mem;
 	}
 
-	/* Allocate cipher */
+	/* Select IV mode before alloc so dun() wrapping can be decided. */
+	ret = crypt_select_ivmode(ti, *ivmode);
+	if (ret < 0) {
+		kfree(cipher_api);
+		return ret;
+	}
+
 	ret = crypt_alloc_tfms(cc, cipher_api);
 	if (ret < 0) {
 		ti->error = "Error allocating crypto tfm";
@@ -3063,6 +3172,19 @@ static int crypt_ctr_cipher(struct dm_target *ti, char *cipher_in, char *key)
 		}
 	}
 
+	/*
+	 * Enable batching only if the cipher was dun()-wrapped at alloc time and
+	 * no integrity was configured (integrity is set up after cipher alloc).
+	 */
+	if (!crypt_integrity_aead(cc) && !cc->integrity_tag_size &&
+	    !cc->integrity_iv_size &&
+	    !strncmp(crypto_skcipher_alg(any_tfm(cc))->base.cra_name,
+		     "dun(", 4)) {
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


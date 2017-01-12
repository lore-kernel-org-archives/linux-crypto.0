From: Ondrej Mosnacek <omosnacek@gmail.com>
Subject: [RFC PATCH 6/6] dm-crypt: Add bulk crypto processing support
Date: Thu, 12 Jan 2017 13:59:58 +0100
Message-ID: <75887e6759ac308a017c83b7fa377516dcd5e2a3.1484215956.git.omosnacek@gmail.com>
References: <cover.1484215956.git.omosnacek@gmail.com>
Cc: Ondrej Mosnacek <omosnacek@gmail.com>,
        linux-crypto@vger.kernel.org, dm-devel@redhat.com,
        Mike Snitzer <snitzer@redhat.com>,
        Milan Broz <gmazyland@gmail.com>,
        Mikulas Patocka <mpatocka@redhat.com>,
        Binoy Jayan <binoy.jayan@linaro.org>
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-wj0-f193.google.com ([209.85.210.193]:32918 "EHLO
        mail-wj0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751389AbdALNA4 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 12 Jan 2017 08:00:56 -0500
Received: by mail-wj0-f193.google.com with SMTP id kp2so1801624wjc.0
        for <linux-crypto@vger.kernel.org>; Thu, 12 Jan 2017 05:00:55 -0800 (PST)
In-Reply-To: <cover.1484215956.git.omosnacek@gmail.com>
In-Reply-To: <cover.1484215956.git.omosnacek@gmail.com>
References: <cover.1484215956.git.omosnacek@gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

This patch converts dm-crypt to use bulk requests when invoking skcipher
operations, allowing the crypto drivers to process multiple sectors at once,
while reducing the overhead caused by the small sector size.

The new code detects if multiple sectors from a bio are contigously stored
within a single page (which should almost always be the case), and in such case
processes all these sectors via a single bulk request.

Note that the bio can also consist of several (likely consecutive) pages, which
could be all bundled in a single request. However, since we need to specify an
upper bound on how many sectors we are going to send at once (and this bound
may affect the amount of memory allocated per single request), it is best to
just limit the request bundling to a single page.

Note that if the 'keycount' parameter of the cipher specification is set to a
value other than 1, dm-crypt still sends only one sector in each request, since
in such case the neighboring sectors are encrypted with different keys.

This change causes a detectable read/write speedup (about 5-10%) on a ramdisk
when AES-NI accelerated ciphers are used.

Signed-off-by: Ondrej Mosnacek <omosnacek@gmail.com>
---
 drivers/md/dm-crypt.c | 254 ++++++++++++++++++++++++++++++++------------------
 1 file changed, 165 insertions(+), 89 deletions(-)

diff --git a/drivers/md/dm-crypt.c b/drivers/md/dm-crypt.c
index 7c6c572..d3f69e1 100644
--- a/drivers/md/dm-crypt.c
+++ b/drivers/md/dm-crypt.c
@@ -37,6 +37,9 @@
 
 #define DM_MSG_PREFIX "crypt"
 
+/* for now, we only bundle consecutve sectors within a single page */
+#define MAX_CONSEC_SECTORS (1 << (PAGE_SHIFT - SECTOR_SHIFT))
+
 /*
  * context holding the current state of a multi-part conversion
  */
@@ -48,7 +51,7 @@ struct convert_context {
 	struct bvec_iter iter_out;
 	sector_t cc_sector;
 	atomic_t cc_pending;
-	struct skcipher_request *req;
+	struct skcipher_bulk_request *req;
 };
 
 /*
@@ -73,6 +76,7 @@ struct dm_crypt_request {
 	struct scatterlist sg_in;
 	struct scatterlist sg_out;
 	sector_t iv_sector;
+	sector_t sector_count;
 };
 
 struct crypt_config;
@@ -83,9 +87,9 @@ struct crypt_iv_operations {
 	void (*dtr)(struct crypt_config *cc);
 	int (*init)(struct crypt_config *cc);
 	int (*wipe)(struct crypt_config *cc);
-	int (*generator)(struct crypt_config *cc, u8 *iv,
+	int (*generator)(struct crypt_config *cc, u8 *iv, unsigned int sector,
 			 struct dm_crypt_request *dmreq);
-	int (*post)(struct crypt_config *cc, u8 *iv,
+	int (*post)(struct crypt_config *cc, u8 *iv, unsigned int sector,
 		    struct dm_crypt_request *dmreq);
 };
 
@@ -163,14 +167,14 @@ struct crypt_config {
 	/*
 	 * Layout of each crypto request:
 	 *
-	 *   struct skcipher_request
+	 *   struct skcipher_bulk_request
 	 *      context
 	 *      padding
 	 *   struct dm_crypt_request
 	 *      padding
-	 *   IV
+	 *   IVs
 	 *
-	 * The padding is added so that dm_crypt_request and the IV are
+	 * The padding is added so that dm_crypt_request and the IVs are
 	 * correctly aligned.
 	 */
 	unsigned int dmreq_start;
@@ -245,20 +249,24 @@ static struct crypto_skcipher *any_tfm(struct crypt_config *cc)
  * http://article.gmane.org/gmane.linux.kernel.device-mapper.dm-crypt/454
  */
 
-static int crypt_iv_plain_gen(struct crypt_config *cc, u8 *iv,
+static int crypt_iv_plain_gen(struct crypt_config *cc, u8 *ivs, unsigned int i,
 			      struct dm_crypt_request *dmreq)
 {
+	u8 *iv = ivs + i * cc->iv_size;
+
 	memset(iv, 0, cc->iv_size);
-	*(__le32 *)iv = cpu_to_le32(dmreq->iv_sector & 0xffffffff);
+	*(__le32 *)iv = cpu_to_le32((dmreq->iv_sector + i) & 0xffffffff);
 
 	return 0;
 }
 
-static int crypt_iv_plain64_gen(struct crypt_config *cc, u8 *iv,
-				struct dm_crypt_request *dmreq)
+static int crypt_iv_plain64_gen(struct crypt_config *cc, u8 *ivs,
+				unsigned int i, struct dm_crypt_request *dmreq)
 {
+	u8 *iv = ivs + i * cc->iv_size;
+
 	memset(iv, 0, cc->iv_size);
-	*(__le64 *)iv = cpu_to_le64(dmreq->iv_sector);
+	*(__le64 *)iv = cpu_to_le64(dmreq->iv_sector + i);
 
 	return 0;
 }
@@ -410,13 +418,14 @@ static int crypt_iv_essiv_ctr(struct crypt_config *cc, struct dm_target *ti,
 	return err;
 }
 
-static int crypt_iv_essiv_gen(struct crypt_config *cc, u8 *iv,
+static int crypt_iv_essiv_gen(struct crypt_config *cc, u8 *ivs, unsigned int i,
 			      struct dm_crypt_request *dmreq)
 {
 	struct crypto_cipher *essiv_tfm = cc->iv_private;
+	u8 *iv = ivs + i * cc->iv_size;
 
 	memset(iv, 0, cc->iv_size);
-	*(__le64 *)iv = cpu_to_le64(dmreq->iv_sector);
+	*(__le64 *)iv = cpu_to_le64(dmreq->iv_sector + i);
 	crypto_cipher_encrypt_one(essiv_tfm, iv, iv);
 
 	return 0;
@@ -450,22 +459,26 @@ static void crypt_iv_benbi_dtr(struct crypt_config *cc)
 {
 }
 
-static int crypt_iv_benbi_gen(struct crypt_config *cc, u8 *iv,
+static int crypt_iv_benbi_gen(struct crypt_config *cc, u8 *ivs, unsigned int i,
 			      struct dm_crypt_request *dmreq)
 {
+	u8 *iv = ivs + i * cc->iv_size;
+	u64 sector = (u64)(dmreq->iv_sector + i);
 	__be64 val;
 
 	memset(iv, 0, cc->iv_size - sizeof(u64)); /* rest is cleared below */
 
-	val = cpu_to_be64(((u64)dmreq->iv_sector << cc->iv_gen_private.benbi.shift) + 1);
+	val = cpu_to_be64((sector << cc->iv_gen_private.benbi.shift) + 1);
 	put_unaligned(val, (__be64 *)(iv + cc->iv_size - sizeof(u64)));
 
 	return 0;
 }
 
-static int crypt_iv_null_gen(struct crypt_config *cc, u8 *iv,
+static int crypt_iv_null_gen(struct crypt_config *cc, u8 *ivs, unsigned int i,
 			     struct dm_crypt_request *dmreq)
 {
+	u8 *iv = ivs + i * cc->iv_size;
+
 	memset(iv, 0, cc->iv_size);
 
 	return 0;
@@ -534,8 +547,7 @@ static int crypt_iv_lmk_wipe(struct crypt_config *cc)
 }
 
 static int crypt_iv_lmk_one(struct crypt_config *cc, u8 *iv,
-			    struct dm_crypt_request *dmreq,
-			    u8 *data)
+			    u64 sector, u8 *data)
 {
 	struct iv_lmk_private *lmk = &cc->iv_gen_private.lmk;
 	SHASH_DESC_ON_STACK(desc, lmk->hash_tfm);
@@ -562,8 +574,8 @@ static int crypt_iv_lmk_one(struct crypt_config *cc, u8 *iv,
 		return r;
 
 	/* Sector is cropped to 56 bits here */
-	buf[0] = cpu_to_le32(dmreq->iv_sector & 0xFFFFFFFF);
-	buf[1] = cpu_to_le32((((u64)dmreq->iv_sector >> 32) & 0x00FFFFFF) | 0x80000000);
+	buf[0] = cpu_to_le32(sector & 0xFFFFFFFF);
+	buf[1] = cpu_to_le32(((sector >> 32) & 0x00FFFFFF) | 0x80000000);
 	buf[2] = cpu_to_le32(4024);
 	buf[3] = 0;
 	r = crypto_shash_update(desc, (u8 *)buf, sizeof(buf));
@@ -582,39 +594,43 @@ static int crypt_iv_lmk_one(struct crypt_config *cc, u8 *iv,
 	return 0;
 }
 
-static int crypt_iv_lmk_gen(struct crypt_config *cc, u8 *iv,
+static int crypt_iv_lmk_gen(struct crypt_config *cc, u8 *ivs, unsigned int i,
 			    struct dm_crypt_request *dmreq)
 {
-	u8 *src;
+	u8 *iv = ivs + i * cc->iv_size;
+	u8 *mapped, *src;
 	int r = 0;
 
 	if (bio_data_dir(dmreq->ctx->bio_in) == WRITE) {
-		src = kmap_atomic(sg_page(&dmreq->sg_in));
-		r = crypt_iv_lmk_one(cc, iv, dmreq, src + dmreq->sg_in.offset);
-		kunmap_atomic(src);
+		mapped = kmap_atomic(sg_page(&dmreq->sg_in));
+		src = mapped + dmreq->sg_in.offset + i * (1 << SECTOR_SHIFT);
+		r = crypt_iv_lmk_one(cc, iv, dmreq->iv_sector + i, src);
+		kunmap_atomic(mapped);
 	} else
 		memset(iv, 0, cc->iv_size);
 
 	return r;
 }
 
-static int crypt_iv_lmk_post(struct crypt_config *cc, u8 *iv,
+static int crypt_iv_lmk_post(struct crypt_config *cc, u8 *ivs, unsigned int i,
 			     struct dm_crypt_request *dmreq)
 {
-	u8 *dst;
+	u8 *iv = ivs + i * cc->iv_size;
+	u8 *mapped, *dst;
 	int r;
 
 	if (bio_data_dir(dmreq->ctx->bio_in) == WRITE)
 		return 0;
 
-	dst = kmap_atomic(sg_page(&dmreq->sg_out));
-	r = crypt_iv_lmk_one(cc, iv, dmreq, dst + dmreq->sg_out.offset);
+	mapped = kmap_atomic(sg_page(&dmreq->sg_out));
+	dst = mapped + dmreq->sg_out.offset + i * (1 << SECTOR_SHIFT);
+	r = crypt_iv_lmk_one(cc, iv, dmreq->iv_sector + i, dst);
 
 	/* Tweak the first block of plaintext sector */
 	if (!r)
-		crypto_xor(dst + dmreq->sg_out.offset, iv, cc->iv_size);
+		crypto_xor(dst, iv, cc->iv_size);
 
-	kunmap_atomic(dst);
+	kunmap_atomic(mapped);
 	return r;
 }
 
@@ -682,11 +698,10 @@ static int crypt_iv_tcw_wipe(struct crypt_config *cc)
 }
 
 static int crypt_iv_tcw_whitening(struct crypt_config *cc,
-				  struct dm_crypt_request *dmreq,
-				  u8 *data)
+				  u64 iv_sector, u8 *data)
 {
 	struct iv_tcw_private *tcw = &cc->iv_gen_private.tcw;
-	__le64 sector = cpu_to_le64(dmreq->iv_sector);
+	__le64 sector = cpu_to_le64(iv_sector);
 	u8 buf[TCW_WHITENING_SIZE];
 	SHASH_DESC_ON_STACK(desc, tcw->crc32_tfm);
 	int i, r;
@@ -721,19 +736,21 @@ static int crypt_iv_tcw_whitening(struct crypt_config *cc,
 	return r;
 }
 
-static int crypt_iv_tcw_gen(struct crypt_config *cc, u8 *iv,
+static int crypt_iv_tcw_gen(struct crypt_config *cc, u8 *ivs, unsigned int i,
 			    struct dm_crypt_request *dmreq)
 {
 	struct iv_tcw_private *tcw = &cc->iv_gen_private.tcw;
-	__le64 sector = cpu_to_le64(dmreq->iv_sector);
-	u8 *src;
+	__le64 sector = cpu_to_le64(dmreq->iv_sector + i);
+	u8 *iv = ivs + i * cc->iv_size;
+	u8 *mapped, *src;
 	int r = 0;
 
 	/* Remove whitening from ciphertext */
 	if (bio_data_dir(dmreq->ctx->bio_in) != WRITE) {
-		src = kmap_atomic(sg_page(&dmreq->sg_in));
-		r = crypt_iv_tcw_whitening(cc, dmreq, src + dmreq->sg_in.offset);
-		kunmap_atomic(src);
+		mapped = kmap_atomic(sg_page(&dmreq->sg_in));
+		src = mapped + dmreq->sg_in.offset + i * (1 << SECTOR_SHIFT);
+		r = crypt_iv_tcw_whitening(cc, dmreq->iv_sector + i, src);
+		kunmap_atomic(mapped);
 	}
 
 	/* Calculate IV */
@@ -745,19 +762,20 @@ static int crypt_iv_tcw_gen(struct crypt_config *cc, u8 *iv,
 	return r;
 }
 
-static int crypt_iv_tcw_post(struct crypt_config *cc, u8 *iv,
+static int crypt_iv_tcw_post(struct crypt_config *cc, u8 *ivs, unsigned int i,
 			     struct dm_crypt_request *dmreq)
 {
-	u8 *dst;
+	u8 *mapped, *dst;
 	int r;
 
 	if (bio_data_dir(dmreq->ctx->bio_in) != WRITE)
 		return 0;
 
 	/* Apply whitening on ciphertext */
-	dst = kmap_atomic(sg_page(&dmreq->sg_out));
-	r = crypt_iv_tcw_whitening(cc, dmreq, dst + dmreq->sg_out.offset);
-	kunmap_atomic(dst);
+	mapped = kmap_atomic(sg_page(&dmreq->sg_out));
+	dst = mapped + dmreq->sg_out.offset + i * (1 << SECTOR_SHIFT);
+	r = crypt_iv_tcw_whitening(cc, dmreq->iv_sector + i, dst);
+	kunmap_atomic(mapped);
 
 	return r;
 }
@@ -821,16 +839,22 @@ static void crypt_convert_init(struct crypt_config *cc,
 	init_completion(&ctx->restart);
 }
 
+static unsigned int crypt_max_bulk_sectors(struct crypt_config *cc)
+{
+	/* go by one sector only if tfms_count > 1: */
+	return cc->tfms_count == 1 ? MAX_CONSEC_SECTORS : 1;
+}
+
 static struct dm_crypt_request *dmreq_of_req(struct crypt_config *cc,
-					     struct skcipher_request *req)
+					     struct skcipher_bulk_request *req)
 {
 	return (struct dm_crypt_request *)((char *)req + cc->dmreq_start);
 }
 
-static struct skcipher_request *req_of_dmreq(struct crypt_config *cc,
-					       struct dm_crypt_request *dmreq)
+static struct skcipher_bulk_request *req_of_dmreq(
+		struct crypt_config *cc, struct dm_crypt_request *dmreq)
 {
-	return (struct skcipher_request *)((char *)dmreq - cc->dmreq_start);
+	return (struct skcipher_bulk_request *)((u8 *)dmreq - cc->dmreq_start);
 }
 
 static u8 *iv_of_dmreq(struct crypt_config *cc,
@@ -840,48 +864,53 @@ static u8 *iv_of_dmreq(struct crypt_config *cc,
 		crypto_skcipher_alignmask(any_tfm(cc)) + 1);
 }
 
-static int crypt_convert_block(struct crypt_config *cc,
-			       struct convert_context *ctx,
-			       struct skcipher_request *req)
+static int crypt_convert_sectors(struct crypt_config *cc,
+				 struct convert_context *ctx,
+				 struct page *page_in, struct page *page_out,
+				 unsigned int off_in, unsigned int off_out,
+				 sector_t sectors)
 {
-	struct bio_vec bv_in = bio_iter_iovec(ctx->bio_in, ctx->iter_in);
-	struct bio_vec bv_out = bio_iter_iovec(ctx->bio_out, ctx->iter_out);
+	unsigned int cryptlen = (1 << SECTOR_SHIFT) * (unsigned int)sectors;
+	struct skcipher_bulk_request *req = ctx->req;
 	struct dm_crypt_request *dmreq;
+	unsigned int i;
 	u8 *iv;
 	int r;
 
-	dmreq = dmreq_of_req(cc, req);
+	dmreq = dmreq_of_req(cc, ctx->req);
 	iv = iv_of_dmreq(cc, dmreq);
 
 	dmreq->iv_sector = ctx->cc_sector;
+	dmreq->sector_count = sectors;
 	dmreq->ctx = ctx;
+
 	sg_init_table(&dmreq->sg_in, 1);
-	sg_set_page(&dmreq->sg_in, bv_in.bv_page, 1 << SECTOR_SHIFT,
-		    bv_in.bv_offset);
+	sg_set_page(&dmreq->sg_in, page_in, cryptlen, off_in);
 
 	sg_init_table(&dmreq->sg_out, 1);
-	sg_set_page(&dmreq->sg_out, bv_out.bv_page, 1 << SECTOR_SHIFT,
-		    bv_out.bv_offset);
+	sg_set_page(&dmreq->sg_out, page_out, cryptlen, off_out);
 
-	bio_advance_iter(ctx->bio_in, &ctx->iter_in, 1 << SECTOR_SHIFT);
-	bio_advance_iter(ctx->bio_out, &ctx->iter_out, 1 << SECTOR_SHIFT);
-
-	if (cc->iv_gen_ops) {
-		r = cc->iv_gen_ops->generator(cc, iv, dmreq);
-		if (r < 0)
-			return r;
-	}
+	if (cc->iv_gen_ops)
+		for (i = 0; i < sectors; i++) {
+			r = cc->iv_gen_ops->generator(cc, iv, i, dmreq);
+			if (r < 0)
+				return r;
+		}
 
-	skcipher_request_set_crypt(req, &dmreq->sg_in, &dmreq->sg_out,
-				   1 << SECTOR_SHIFT, iv);
+	skcipher_bulk_request_set_crypt(req, &dmreq->sg_in, &dmreq->sg_out,
+					sectors, 1 << SECTOR_SHIFT, NULL, iv);
 
 	if (bio_data_dir(ctx->bio_in) == WRITE)
-		r = crypto_skcipher_encrypt(req);
+		r = crypto_skcipher_encrypt_bulk(req);
 	else
-		r = crypto_skcipher_decrypt(req);
+		r = crypto_skcipher_decrypt_bulk(req);
 
 	if (!r && cc->iv_gen_ops && cc->iv_gen_ops->post)
-		r = cc->iv_gen_ops->post(cc, iv, dmreq);
+		for (i = 0; i < sectors; i++) {
+			r = cc->iv_gen_ops->post(cc, iv, i, dmreq);
+			if (r < 0)
+				return r;
+		}
 
 	return r;
 }
@@ -897,23 +926,25 @@ static void crypt_alloc_req(struct crypt_config *cc,
 	if (!ctx->req)
 		ctx->req = mempool_alloc(cc->req_pool, GFP_NOIO);
 
-	skcipher_request_set_tfm(ctx->req, cc->tfms[key_index]);
+	skcipher_bulk_request_set_maxmsgs(ctx->req, crypt_max_bulk_sectors(cc));
+	skcipher_bulk_request_set_tfm(ctx->req, cc->tfms[key_index]);
 
 	/*
 	 * Use REQ_MAY_BACKLOG so a cipher driver internally backlogs
 	 * requests if driver request queue is full.
 	 */
-	skcipher_request_set_callback(ctx->req,
+	skcipher_bulk_request_set_callback(ctx->req,
 	    CRYPTO_TFM_REQ_MAY_BACKLOG | CRYPTO_TFM_REQ_MAY_SLEEP,
 	    kcryptd_async_done, dmreq_of_req(cc, ctx->req));
 }
 
 static void crypt_free_req(struct crypt_config *cc,
-			   struct skcipher_request *req, struct bio *base_bio)
+			   struct skcipher_bulk_request *req,
+			   struct bio *base_bio)
 {
 	struct dm_crypt_io *io = dm_per_bio_data(base_bio, cc->per_bio_data_size);
 
-	if ((struct skcipher_request *)(io + 1) != req)
+	if ((struct skcipher_bulk_request *)(io + 1) != req)
 		mempool_free(req, cc->req_pool);
 }
 
@@ -923,6 +954,11 @@ static void crypt_free_req(struct crypt_config *cc,
 static int crypt_convert(struct crypt_config *cc,
 			 struct convert_context *ctx)
 {
+	struct bio_vec bv_in, bv_out;
+	struct page *page_in, *page_out;
+	unsigned int off_in, off_out;
+	unsigned int maxsectors = crypt_max_bulk_sectors(cc);
+	sector_t sectors;
 	int r;
 
 	atomic_set(&ctx->cc_pending, 1);
@@ -933,7 +969,41 @@ static int crypt_convert(struct crypt_config *cc,
 
 		atomic_inc(&ctx->cc_pending);
 
-		r = crypt_convert_block(cc, ctx, ctx->req);
+		bv_in = bio_iter_iovec(ctx->bio_in, ctx->iter_in);
+		bv_out = bio_iter_iovec(ctx->bio_out, ctx->iter_out);
+
+		page_in = bv_in.bv_page;
+		page_out = bv_out.bv_page;
+
+		off_in = bv_in.bv_offset;
+		off_out = bv_out.bv_offset;
+
+		bio_advance_iter(ctx->bio_in, &ctx->iter_in,
+				 1 << SECTOR_SHIFT);
+		bio_advance_iter(ctx->bio_out, &ctx->iter_out,
+				 1 << SECTOR_SHIFT);
+		sectors = 1;
+
+		/* count consecutive sectors: */
+		while (sectors < maxsectors &&
+				ctx->iter_in.bi_size && ctx->iter_out.bi_size) {
+
+			bv_in = bio_iter_iovec(ctx->bio_in, ctx->iter_in);
+			bv_out = bio_iter_iovec(ctx->bio_out, ctx->iter_out);
+
+			if (bv_in.bv_page != page_in ||
+			    bv_out.bv_page != page_out)
+				break;
+
+			bio_advance_iter(ctx->bio_in, &ctx->iter_in,
+					 1 << SECTOR_SHIFT);
+			bio_advance_iter(ctx->bio_out, &ctx->iter_out,
+					 1 << SECTOR_SHIFT);
+			++sectors;
+		}
+
+		r = crypt_convert_sectors(cc, ctx, page_in, page_out,
+					  off_in, off_out, sectors);
 
 		switch (r) {
 		/*
@@ -950,14 +1020,14 @@ static int crypt_convert(struct crypt_config *cc,
 		 */
 		case -EINPROGRESS:
 			ctx->req = NULL;
-			ctx->cc_sector++;
+			ctx->cc_sector += sectors;
 			continue;
 		/*
 		 * The request was already processed (synchronously).
 		 */
 		case 0:
 			atomic_dec(&ctx->cc_pending);
-			ctx->cc_sector++;
+			ctx->cc_sector += sectors;
 			cond_resched();
 			continue;
 
@@ -1360,6 +1430,7 @@ static void kcryptd_async_done(struct crypto_async_request *async_req,
 	struct convert_context *ctx = dmreq->ctx;
 	struct dm_crypt_io *io = container_of(ctx, struct dm_crypt_io, ctx);
 	struct crypt_config *cc = io->cc;
+	unsigned int i;
 
 	/*
 	 * A request from crypto driver backlog is going to be processed now,
@@ -1372,10 +1443,12 @@ static void kcryptd_async_done(struct crypto_async_request *async_req,
 	}
 
 	if (!error && cc->iv_gen_ops && cc->iv_gen_ops->post)
-		error = cc->iv_gen_ops->post(cc, iv_of_dmreq(cc, dmreq), dmreq);
-
-	if (error < 0)
-		io->error = -EIO;
+		for (i = 0; i < dmreq->sector_count; i++) {
+			error = cc->iv_gen_ops->post(cc, iv_of_dmreq(cc, dmreq),
+						     i, dmreq);
+			if (error < 0)
+				io->error = -EIO;
+		}
 
 	crypt_free_req(cc, req_of_dmreq(cc, dmreq), io->base_bio);
 
@@ -1865,7 +1938,7 @@ static int crypt_ctr(struct dm_target *ti, unsigned int argc, char **argv)
 {
 	struct crypt_config *cc;
 	int key_size;
-	unsigned int opt_params;
+	unsigned int opt_params, iv_space;
 	unsigned long long tmpll;
 	int ret;
 	size_t iv_size_padding;
@@ -1900,8 +1973,9 @@ static int crypt_ctr(struct dm_target *ti, unsigned int argc, char **argv)
 	if (ret < 0)
 		goto bad;
 
-	cc->dmreq_start = sizeof(struct skcipher_request);
-	cc->dmreq_start += crypto_skcipher_reqsize(any_tfm(cc));
+	cc->dmreq_start = sizeof(struct skcipher_bulk_request);
+	cc->dmreq_start += crypto_skcipher_bulk_reqsize(
+				any_tfm(cc), crypt_max_bulk_sectors(cc));
 	cc->dmreq_start = ALIGN(cc->dmreq_start, __alignof__(struct dm_crypt_request));
 
 	if (crypto_skcipher_alignmask(any_tfm(cc)) < CRYPTO_MINALIGN) {
@@ -1917,9 +1991,11 @@ static int crypt_ctr(struct dm_target *ti, unsigned int argc, char **argv)
 		iv_size_padding = crypto_skcipher_alignmask(any_tfm(cc));
 	}
 
+	iv_space = cc->iv_size * crypt_max_bulk_sectors(cc);
+
 	ret = -ENOMEM;
 	cc->req_pool = mempool_create_kmalloc_pool(MIN_IOS, cc->dmreq_start +
-			sizeof(struct dm_crypt_request) + iv_size_padding + cc->iv_size);
+			sizeof(struct dm_crypt_request) + iv_size_padding + iv_space);
 	if (!cc->req_pool) {
 		ti->error = "Cannot allocate crypt request mempool";
 		goto bad;
@@ -1927,7 +2003,7 @@ static int crypt_ctr(struct dm_target *ti, unsigned int argc, char **argv)
 
 	cc->per_bio_data_size = ti->per_io_data_size =
 		ALIGN(sizeof(struct dm_crypt_io) + cc->dmreq_start +
-		      sizeof(struct dm_crypt_request) + iv_size_padding + cc->iv_size,
+		      sizeof(struct dm_crypt_request) + iv_size_padding + iv_space,
 		      ARCH_KMALLOC_MINALIGN);
 
 	cc->page_pool = mempool_create_page_pool(BIO_MAX_PAGES, 0);
@@ -2067,7 +2143,7 @@ static int crypt_map(struct dm_target *ti, struct bio *bio)
 
 	io = dm_per_bio_data(bio, cc->per_bio_data_size);
 	crypt_io_init(io, cc, bio, dm_target_offset(ti, bio->bi_iter.bi_sector));
-	io->ctx.req = (struct skcipher_request *)(io + 1);
+	io->ctx.req = (struct skcipher_bulk_request *)(io + 1);
 
 	if (bio_data_dir(io->base_bio) == READ) {
 		if (kcryptd_io_read(io, GFP_NOWAIT))
-- 
2.9.3

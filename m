From: Baolin Wang <baolin.wang@linaro.org>
Subject: [RFC 3/3] md: dm-crypt: Introduce the bulk mode method when sending request
Date: Wed, 25 May 2016 14:12:31 +0800
Message-ID: <70f051223cf882b03b373369b6b65b4a7ebf07b6.1464144791.git.baolin.wang@linaro.org>
References: <cover.1464144790.git.baolin.wang@linaro.org>
Cc: ebiggers3@gmail.com, js1304@gmail.com, tadeusz.struk@intel.com,
	smueller@chronox.de, standby24x7@gmail.com, shli@kernel.org,
	dan.j.williams@intel.com, martin.petersen@oracle.com,
	sagig@mellanox.com, kent.overstreet@gmail.com,
	keith.busch@intel.com, tj@kernel.org, ming.lei@canonical.com,
	broonie@kernel.org, arnd@arndb.de, linux-crypto@vger.kernel.org,
	linux-block@vger.kernel.org, linux-raid@vger.kernel.org,
	linux-kernel@vger.kernel.org, baolin.wang@linaro.org
To: axboe@kernel.dk, agk@redhat.com, snitzer@redhat.com,
	dm-devel@redhat.com, herbert@gondor.apana.org.au,
	davem@davemloft.net
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <cover.1464144790.git.baolin.wang@linaro.org>
In-Reply-To: <cover.1464144790.git.baolin.wang@linaro.org>
References: <cover.1464144790.git.baolin.wang@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

In now dm-crypt code, it is ineffective to map one segment (always one
sector) of one bio with just only one scatterlist at one time for hardware
crypto engine. Especially for some encryption mode (like ecb or xts mode)
cooperating with the crypto engine, they just need one initial IV or null
IV instead of different IV for each sector. In this situation We can consider
to use multiple scatterlists to map the whole bio and send all scatterlists
of one bio to crypto engine to encrypt or decrypt, which can improve the
hardware engine's efficiency.

With this optimization, On my test setup (beaglebone black board) using 64KB
I/Os on an eMMC storage device I saw about 60% improvement in throughput for
encrypted writes, and about 100% improvement for encrypted reads. But this
is not fit for other modes which need different IV for each sector.

Signed-off-by: Baolin Wang <baolin.wang@linaro.org>
---
 drivers/md/dm-crypt.c |  188 +++++++++++++++++++++++++++++++++++++++++++++----
 1 file changed, 176 insertions(+), 12 deletions(-)

diff --git a/drivers/md/dm-crypt.c b/drivers/md/dm-crypt.c
index 4f3cb35..1c86ea7 100644
--- a/drivers/md/dm-crypt.c
+++ b/drivers/md/dm-crypt.c
@@ -33,6 +33,7 @@
 #include <linux/device-mapper.h>
 
 #define DM_MSG_PREFIX "crypt"
+#define DM_MAX_SG_LIST	1024
 
 /*
  * context holding the current state of a multi-part conversion
@@ -46,6 +47,8 @@ struct convert_context {
 	sector_t cc_sector;
 	atomic_t cc_pending;
 	struct skcipher_request *req;
+	struct sg_table sgt_in;
+	struct sg_table sgt_out;
 };
 
 /*
@@ -803,6 +806,108 @@ static struct crypt_iv_operations crypt_iv_tcw_ops = {
 	.post	   = crypt_iv_tcw_post
 };
 
+/*
+ * Check how many sg entry numbers are needed when map one bio
+ * with scatterlists in advance.
+ */
+static unsigned int crypt_sg_entry(struct bio *bio_t)
+{
+	struct request_queue *q = bdev_get_queue(bio_t->bi_bdev);
+	int cluster = blk_queue_cluster(q);
+	struct bio_vec bvec, bvprv = { NULL };
+	struct bvec_iter biter;
+	unsigned long nbytes = 0, sg_length = 0;
+	unsigned int sg_cnt = 0, first_bvec = 0;
+
+	if (bio_t->bi_rw & REQ_DISCARD) {
+		if (bio_t->bi_vcnt)
+			return 1;
+		return 0;
+	}
+
+	if (bio_t->bi_rw & REQ_WRITE_SAME)
+		return 1;
+
+	bio_for_each_segment(bvec, bio_t, biter) {
+		nbytes = bvec.bv_len;
+
+		if (!cluster) {
+			sg_cnt++;
+			continue;
+		}
+
+		if (!first_bvec) {
+			first_bvec = 1;
+			goto new_segment;
+		}
+
+		if (sg_length + nbytes > queue_max_segment_size(q))
+			goto new_segment;
+
+		if (!BIOVEC_PHYS_MERGEABLE(&bvprv, &bvec))
+			goto new_segment;
+
+		if (!BIOVEC_SEG_BOUNDARY(q, &bvprv, &bvec))
+			goto new_segment;
+
+		sg_length += nbytes;
+		continue;
+
+new_segment:
+		memcpy(&bvprv, &bvec, sizeof(struct bio_vec));
+		sg_length = nbytes;
+		sg_cnt++;
+	}
+
+	return sg_cnt;
+}
+
+static int crypt_convert_alloc_table(struct crypt_config *cc,
+				     struct convert_context *ctx)
+{
+	struct bio *bio_in = ctx->bio_in;
+	struct bio *bio_out = ctx->bio_out;
+	unsigned int mode = skcipher_is_bulk_mode(any_tfm(cc));
+	unsigned int sg_in_max, sg_out_max;
+	int ret = 0;
+
+	if (!mode)
+		goto out2;
+
+	/*
+	 * Need to calculate how many sg entry need to be used
+	 * for this bio.
+	 */
+	sg_in_max = crypt_sg_entry(bio_in) + 1;
+	if (sg_in_max > DM_MAX_SG_LIST || sg_in_max <= 2)
+		goto out2;
+
+	ret = sg_alloc_table(&ctx->sgt_in, sg_in_max, GFP_KERNEL);
+	if (ret)
+		goto out2;
+
+	if (bio_data_dir(bio_in) == READ)
+		goto out1;
+
+	sg_out_max = crypt_sg_entry(bio_out) + 1;
+	if (sg_out_max > DM_MAX_SG_LIST || sg_out_max <= 2)
+		goto out3;
+
+	ret = sg_alloc_table(&ctx->sgt_out, sg_out_max, GFP_KERNEL);
+	if (ret)
+		goto out3;
+
+	return 0;
+
+out3:
+	sg_free_table(&ctx->sgt_in);
+out2:
+	ctx->sgt_in.orig_nents = 0;
+out1:
+	ctx->sgt_out.orig_nents = 0;
+	return ret;
+}
+
 static void crypt_convert_init(struct crypt_config *cc,
 			       struct convert_context *ctx,
 			       struct bio *bio_out, struct bio *bio_in,
@@ -843,7 +948,13 @@ static int crypt_convert_block(struct crypt_config *cc,
 {
 	struct bio_vec bv_in = bio_iter_iovec(ctx->bio_in, ctx->iter_in);
 	struct bio_vec bv_out = bio_iter_iovec(ctx->bio_out, ctx->iter_out);
+	unsigned int mode = skcipher_is_bulk_mode(any_tfm(cc));
+	struct bio *bio_in = ctx->bio_in;
+	struct bio *bio_out = ctx->bio_out;
+	unsigned int total_bytes = bio_in->bi_iter.bi_size;
 	struct dm_crypt_request *dmreq;
+	struct scatterlist *sg_in;
+	struct scatterlist *sg_out;
 	u8 *iv;
 	int r;
 
@@ -852,16 +963,6 @@ static int crypt_convert_block(struct crypt_config *cc,
 
 	dmreq->iv_sector = ctx->cc_sector;
 	dmreq->ctx = ctx;
-	sg_init_table(&dmreq->sg_in, 1);
-	sg_set_page(&dmreq->sg_in, bv_in.bv_page, 1 << SECTOR_SHIFT,
-		    bv_in.bv_offset);
-
-	sg_init_table(&dmreq->sg_out, 1);
-	sg_set_page(&dmreq->sg_out, bv_out.bv_page, 1 << SECTOR_SHIFT,
-		    bv_out.bv_offset);
-
-	bio_advance_iter(ctx->bio_in, &ctx->iter_in, 1 << SECTOR_SHIFT);
-	bio_advance_iter(ctx->bio_out, &ctx->iter_out, 1 << SECTOR_SHIFT);
 
 	if (cc->iv_gen_ops) {
 		r = cc->iv_gen_ops->generator(cc, iv, dmreq);
@@ -869,8 +970,63 @@ static int crypt_convert_block(struct crypt_config *cc,
 			return r;
 	}
 
-	skcipher_request_set_crypt(req, &dmreq->sg_in, &dmreq->sg_out,
-				   1 << SECTOR_SHIFT, iv);
+	if (mode && ctx->sgt_in.orig_nents > 0) {
+		struct scatterlist *sg = NULL;
+		unsigned int total_sg_in, total_sg_out;
+
+		total_sg_in = blk_bio_map_sg(bdev_get_queue(bio_in->bi_bdev),
+					     bio_in, ctx->sgt_in.sgl, &sg);
+		if ((total_sg_in <= 0) ||
+		    (total_sg_in > ctx->sgt_in.orig_nents)) {
+			DMERR("%s in sg map error %d, sg table nents[%d]\n",
+			      __func__, total_sg_in, ctx->sgt_in.orig_nents);
+			return -EINVAL;
+		}
+
+		if (sg)
+			sg_mark_end(sg);
+
+		ctx->iter_in.bi_size -= total_bytes;
+		sg_in = ctx->sgt_in.sgl;
+		sg_out = ctx->sgt_in.sgl;
+
+		if (bio_data_dir(bio_in) == READ)
+			goto set_crypt;
+
+		sg = NULL;
+		total_sg_out = blk_bio_map_sg(bdev_get_queue(bio_out->bi_bdev),
+					      bio_out, ctx->sgt_out.sgl, &sg);
+		if ((total_sg_out <= 0) ||
+		    (total_sg_out > ctx->sgt_out.orig_nents)) {
+			DMERR("%s out sg map error %d, sg table nents[%d]\n",
+			      __func__, total_sg_out, ctx->sgt_out.orig_nents);
+			return -EINVAL;
+		}
+
+		if (sg)
+			sg_mark_end(sg);
+
+		ctx->iter_out.bi_size -= total_bytes;
+		sg_out = ctx->sgt_out.sgl;
+	} else  {
+		sg_init_table(&dmreq->sg_in, 1);
+		sg_set_page(&dmreq->sg_in, bv_in.bv_page, 1 << SECTOR_SHIFT,
+			    bv_in.bv_offset);
+
+		sg_init_table(&dmreq->sg_out, 1);
+		sg_set_page(&dmreq->sg_out, bv_out.bv_page, 1 << SECTOR_SHIFT,
+			    bv_out.bv_offset);
+
+		bio_advance_iter(ctx->bio_in, &ctx->iter_in, 1 << SECTOR_SHIFT);
+		bio_advance_iter(ctx->bio_out, &ctx->iter_out, 1 << SECTOR_SHIFT);
+
+		sg_in = &dmreq->sg_in;
+		sg_out = &dmreq->sg_out;
+		total_bytes = 1 << SECTOR_SHIFT;
+	}
+
+set_crypt:
+	skcipher_request_set_crypt(req, sg_in, sg_out, total_bytes, iv);
 
 	if (bio_data_dir(ctx->bio_in) == WRITE)
 		r = crypto_skcipher_encrypt(req);
@@ -1081,6 +1237,8 @@ static void crypt_dec_pending(struct dm_crypt_io *io)
 	if (io->ctx.req)
 		crypt_free_req(cc, io->ctx.req, base_bio);
 
+	sg_free_table(&io->ctx.sgt_in);
+	sg_free_table(&io->ctx.sgt_out);
 	base_bio->bi_error = error;
 	bio_endio(base_bio);
 }
@@ -1312,6 +1470,9 @@ static void kcryptd_crypt_write_convert(struct dm_crypt_io *io)
 	io->ctx.iter_out = clone->bi_iter;
 
 	sector += bio_sectors(clone);
+	r = crypt_convert_alloc_table(cc, &io->ctx);
+	if (r < 0)
+		io->error = -EIO;
 
 	crypt_inc_pending(io);
 	r = crypt_convert(cc, &io->ctx);
@@ -1343,6 +1504,9 @@ static void kcryptd_crypt_read_convert(struct dm_crypt_io *io)
 
 	crypt_convert_init(cc, &io->ctx, io->base_bio, io->base_bio,
 			   io->sector);
+	r = crypt_convert_alloc_table(cc, &io->ctx);
+	if (r < 0)
+		io->error = -EIO;
 
 	r = crypt_convert(cc, &io->ctx);
 	if (r < 0)
-- 
1.7.9.5

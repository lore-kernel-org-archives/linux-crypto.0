From: Baolin Wang <baolin.wang@linaro.org>
Subject: [RFC v3 3/4] md: dm-crypt: Introduce the bulk mode method when sending request
Date: Wed,  1 Jun 2016 12:58:06 +0800
Message-ID: <6e79425366b7fa7f7c8173db50fc3d1b2f37936c.1464756501.git.baolin.wang@linaro.org>
References: <cover.1464756501.git.baolin.wang@linaro.org>
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
In-Reply-To: <cover.1464756501.git.baolin.wang@linaro.org>
In-Reply-To: <cover.1464756501.git.baolin.wang@linaro.org>
References: <cover.1464756501.git.baolin.wang@linaro.org>
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

With this optimization, On my test setup (beaglebone black board and dd testing)
using 64KB I/Os on an eMMC storage device I saw about 127% improvement in
throughput for encrypted writes, and about 206% improvement for encrypted reads.
But this is not fit for other modes which need different IV for each sector.

Signed-off-by: Baolin Wang <baolin.wang@linaro.org>
---
 drivers/md/dm-crypt.c |  159 ++++++++++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 158 insertions(+), 1 deletion(-)

diff --git a/drivers/md/dm-crypt.c b/drivers/md/dm-crypt.c
index 4f3cb35..0b1d452 100644
--- a/drivers/md/dm-crypt.c
+++ b/drivers/md/dm-crypt.c
@@ -33,6 +33,7 @@
 #include <linux/device-mapper.h>
 
 #define DM_MSG_PREFIX "crypt"
+#define DM_MAX_SG_LIST	512
 
 /*
  * context holding the current state of a multi-part conversion
@@ -142,6 +143,11 @@ struct crypt_config {
 	char *cipher;
 	char *cipher_string;
 
+	struct sg_table sgt_in;
+	struct sg_table sgt_out;
+	atomic_t sgt_init_done;
+	struct completion sgt_restart;
+
 	struct crypt_iv_operations *iv_gen_ops;
 	union {
 		struct iv_essiv_private essiv;
@@ -837,6 +843,141 @@ static u8 *iv_of_dmreq(struct crypt_config *cc,
 		crypto_skcipher_alignmask(any_tfm(cc)) + 1);
 }
 
+static void crypt_init_sg_table(struct scatterlist *sgl)
+{
+	struct scatterlist *sg;
+	int i;
+
+	for_each_sg(sgl, sg, DM_MAX_SG_LIST, i) {
+		if (i < DM_MAX_SG_LIST - 1 && sg_is_last(sg))
+			sg_unmark_end(sg);
+		else if (i == DM_MAX_SG_LIST - 1)
+			sg_mark_end(sg);
+	}
+
+	for_each_sg(sgl, sg, DM_MAX_SG_LIST, i) {
+		memset(sg, 0, sizeof(struct scatterlist));
+
+		if (i == DM_MAX_SG_LIST - 1)
+			sg_mark_end(sg);
+	}
+}
+
+static void crypt_reinit_sg_table(struct crypt_config *cc)
+{
+	if (!cc->sgt_in.orig_nents || !cc->sgt_out.orig_nents)
+		return;
+
+	crypt_init_sg_table(cc->sgt_in.sgl);
+	crypt_init_sg_table(cc->sgt_out.sgl);
+
+	if (atomic_inc_and_test(&cc->sgt_init_done))
+		complete(&cc->sgt_restart);
+	atomic_set(&cc->sgt_init_done, 1);
+}
+
+static int crypt_alloc_sg_table(struct crypt_config *cc)
+{
+	unsigned int bulk_mode = skcipher_is_bulk_mode(any_tfm(cc));
+	int ret = 0;
+
+	if (!bulk_mode)
+		goto out_skip_alloc;
+
+	ret = sg_alloc_table(&cc->sgt_in, DM_MAX_SG_LIST, GFP_KERNEL);
+	if (ret)
+		goto out_skip_alloc;
+
+	ret = sg_alloc_table(&cc->sgt_out, DM_MAX_SG_LIST, GFP_KERNEL);
+	if (ret)
+		goto out_free_table;
+
+	init_completion(&cc->sgt_restart);
+	atomic_set(&cc->sgt_init_done, 1);
+	return 0;
+
+out_free_table:
+	sg_free_table(&cc->sgt_in);
+out_skip_alloc:
+	cc->sgt_in.orig_nents = 0;
+	cc->sgt_out.orig_nents = 0;
+
+	return ret;
+}
+
+static int crypt_convert_bulk_block(struct crypt_config *cc,
+				    struct convert_context *ctx,
+				    struct skcipher_request *req)
+{
+	struct bio *bio_in = ctx->bio_in;
+	struct bio *bio_out = ctx->bio_out;
+	unsigned int total_bytes = bio_in->bi_iter.bi_size;
+	unsigned int total_sg_in, total_sg_out;
+	struct scatterlist *sg_in, *sg_out;
+	struct dm_crypt_request *dmreq;
+	u8 *iv;
+	int r;
+
+	if (!cc->sgt_in.orig_nents || !cc->sgt_out.orig_nents)
+		return -EINVAL;
+
+	if (!atomic_dec_and_test(&cc->sgt_init_done)) {
+		wait_for_completion(&cc->sgt_restart);
+		reinit_completion(&cc->sgt_restart);
+	}
+
+	dmreq = dmreq_of_req(cc, req);
+	iv = iv_of_dmreq(cc, dmreq);
+	dmreq->iv_sector = ctx->cc_sector;
+	dmreq->ctx = ctx;
+
+	total_sg_in = blk_bio_map_sg(bdev_get_queue(bio_in->bi_bdev),
+				     bio_in, cc->sgt_in.sgl);
+	if ((total_sg_in <= 0) || (total_sg_in > DM_MAX_SG_LIST)) {
+		DMERR("%s in sg map error %d, sg table nents[%d]\n",
+		      __func__, total_sg_in, cc->sgt_in.orig_nents);
+		return -EINVAL;
+	}
+
+	ctx->iter_in.bi_size -= total_bytes;
+	sg_in = cc->sgt_in.sgl;
+	sg_out = cc->sgt_in.sgl;
+
+	if (bio_data_dir(bio_in) == READ)
+		goto set_crypt;
+
+	total_sg_out = blk_bio_map_sg(bdev_get_queue(bio_out->bi_bdev),
+				      bio_out, cc->sgt_out.sgl);
+	if ((total_sg_out <= 0) || (total_sg_out > DM_MAX_SG_LIST)) {
+		DMERR("%s out sg map error %d, sg table nents[%d]\n",
+		      __func__, total_sg_out, cc->sgt_out.orig_nents);
+		return -EINVAL;
+	}
+
+	ctx->iter_out.bi_size -= total_bytes;
+	sg_out = cc->sgt_out.sgl;
+
+set_crypt:
+	if (cc->iv_gen_ops) {
+		r = cc->iv_gen_ops->generator(cc, iv, dmreq);
+		if (r < 0)
+			return r;
+	}
+
+	atomic_set(&cc->sgt_init_done, 0);
+	skcipher_request_set_crypt(req, sg_in, sg_out, total_bytes, iv);
+
+	if (bio_data_dir(ctx->bio_in) == WRITE)
+		r = crypto_skcipher_encrypt(req);
+	else
+		r = crypto_skcipher_decrypt(req);
+
+	if (!r && cc->iv_gen_ops && cc->iv_gen_ops->post)
+		r = cc->iv_gen_ops->post(cc, iv, dmreq);
+
+	return r;
+}
+
 static int crypt_convert_block(struct crypt_config *cc,
 			       struct convert_context *ctx,
 			       struct skcipher_request *req)
@@ -920,6 +1061,7 @@ static void crypt_free_req(struct crypt_config *cc,
 static int crypt_convert(struct crypt_config *cc,
 			 struct convert_context *ctx)
 {
+	unsigned int bulk_mode;
 	int r;
 
 	atomic_set(&ctx->cc_pending, 1);
@@ -930,7 +1072,14 @@ static int crypt_convert(struct crypt_config *cc,
 
 		atomic_inc(&ctx->cc_pending);
 
-		r = crypt_convert_block(cc, ctx, ctx->req);
+		bulk_mode = skcipher_is_bulk_mode(any_tfm(cc));
+		if (!bulk_mode) {
+			r = crypt_convert_block(cc, ctx, ctx->req);
+		} else {
+			r = crypt_convert_bulk_block(cc, ctx, ctx->req);
+			if (r == -EINVAL)
+				r = crypt_convert_block(cc, ctx, ctx->req);
+		}
 
 		switch (r) {
 		/*
@@ -1081,6 +1230,7 @@ static void crypt_dec_pending(struct dm_crypt_io *io)
 	if (io->ctx.req)
 		crypt_free_req(cc, io->ctx.req, base_bio);
 
+	crypt_reinit_sg_table(cc);
 	base_bio->bi_error = error;
 	bio_endio(base_bio);
 }
@@ -1563,6 +1713,9 @@ static void crypt_dtr(struct dm_target *ti)
 	kzfree(cc->cipher);
 	kzfree(cc->cipher_string);
 
+	sg_free_table(&cc->sgt_in);
+	sg_free_table(&cc->sgt_out);
+
 	/* Must zero key material before freeing */
 	kzfree(cc);
 }
@@ -1718,6 +1871,10 @@ static int crypt_ctr_cipher(struct dm_target *ti,
 		}
 	}
 
+	ret = crypt_alloc_sg_table(cc);
+	if (ret)
+		DMWARN("Allocate sg table for bulk mode failed");
+
 	ret = 0;
 bad:
 	kfree(cipher_api);
-- 
1.7.9.5

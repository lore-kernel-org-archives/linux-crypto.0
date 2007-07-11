From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 3/3] [DM] dm-crypt: Use crypto ablkcipher
	interface
Date: Wed, 11 Jul 2007 11:05:45 +0800
Message-ID: <E1I8SWP-0001lm-00@gondolin.me.apana.org.au>
References: <20070711030303.GA6730@gondor.apana.org.au>
Reply-To: device-mapper development <dm-devel@redhat.com>
To: Alasdair G Kergon <agk@redhat.com>, dm-devel@redhat.com,
	Christophe Saout <christophe@saout.de>,
	Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Return-path: <dm-devel-bounces@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
List-Id: linux-crypto.vger.kernel.org

[DM] dm-crypt: Use crypto ablkcipher interface

This patch converts the uses of blkcipher to ablkcipher so that
async algorithms can be used if they're present.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
---

 drivers/md/dm-crypt.c |  221 +++++++++++++++++++++++++++++++++++---------------
 1 files changed, 159 insertions(+), 62 deletions(-)

diff --git a/drivers/md/dm-crypt.c b/drivers/md/dm-crypt.c
--- a/drivers/md/dm-crypt.c
+++ b/drivers/md/dm-crypt.c
@@ -6,6 +6,7 @@
  * This file is released under the GPL.
  */
 
+#include <linux/completion.h>
 #include <linux/err.h>
 #include <linux/module.h>
 #include <linux/init.h>
@@ -31,6 +32,7 @@
  * context holding the current state of a multi-part conversion
  */
 struct convert_context {
+	struct completion restart;
 	struct bio *bio_in;
 	struct bio *bio_out;
 	unsigned int offset_in;
@@ -39,6 +41,7 @@ struct convert_context {
 	unsigned int idx_out;
 	sector_t sector;
 	int write;
+	atomic_t pending;
 	int err;
 };
 
@@ -58,6 +61,11 @@ struct crypt_io {
 	sector_t sector;
 };
 
+struct dm_crypt_request {
+	struct scatterlist sg_in;
+	struct scatterlist sg_out;
+};
+
 struct crypt_config;
 
 struct crypt_iv_operations {
@@ -78,10 +86,11 @@ struct crypt_config {
 	sector_t start;
 
 	/*
-	 * pool for per bio private data and
-	 * for encryption buffer pages
+	 * pool for per bio private data, crypto requests and
+	 * encryption requeusts/buffer pages
 	 */
 	mempool_t *io_pool;
+	mempool_t *req_pool;
 	mempool_t *page_pool;
 	struct bio_set *bs;
 
@@ -97,9 +106,25 @@ struct crypt_config {
 	sector_t iv_offset;
 	unsigned int iv_size;
 
+	/*
+	 * Layout of each crypto request:
+	 *
+	 *   struct ablkcipher_request
+	 *      context
+	 *      padding
+	 *   struct dm_crypt_request
+	 *      padding
+	 *   IV
+	 *
+	 * The padding is added so that dm_crypt_request and the IV are
+	 * correctly aligned.
+	 */
+	unsigned int dmreq_start;
+	struct ablkcipher_request *req;
+
 	char cipher[CRYPTO_MAX_ALG_NAME];
 	char chainmode[CRYPTO_MAX_ALG_NAME];
-	struct crypto_blkcipher *tfm;
+	struct crypto_ablkcipher *tfm;
 	unsigned long flags;
 	unsigned int key_size;
 	u8 key[0];
@@ -191,7 +216,7 @@ static int crypt_iv_essiv_ctr(struct cry
 		return PTR_ERR(essiv_tfm);
 	}
 	if (crypto_cipher_blocksize(essiv_tfm) !=
-	    crypto_blkcipher_ivsize(cc->tfm)) {
+	    crypto_ablkcipher_ivsize(cc->tfm)) {
 		ti->error = "Block size of ESSIV cipher does "
 			        "not match IV size of block cipher";
 		crypto_free_cipher(essiv_tfm);
@@ -228,7 +253,7 @@ static int crypt_iv_essiv_gen(struct cry
 static int crypt_iv_benbi_ctr(struct crypt_config *cc, struct dm_target *ti,
 			      const char *opts)
 {
-	unsigned int bs = crypto_blkcipher_blocksize(cc->tfm);
+	unsigned int bs = crypto_ablkcipher_blocksize(cc->tfm);
 	int log = ilog2(bs);
 
 	/* we need to calculate how far we must shift the sector count
@@ -292,38 +317,6 @@ static struct crypt_iv_operations crypt_
 	.generator = crypt_iv_null_gen
 };
 
-static int
-crypt_convert_scatterlist(struct crypt_config *cc, struct scatterlist *out,
-                          struct scatterlist *in, unsigned int length,
-                          int write, sector_t sector)
-{
-	u8 iv[cc->iv_size] __attribute__ ((aligned(__alignof__(u64))));
-	struct blkcipher_desc desc = {
-		.tfm = cc->tfm,
-		.info = iv,
-		.flags = CRYPTO_TFM_REQ_MAY_SLEEP,
-	};
-	int r;
-
-	if (cc->iv_gen_ops) {
-		r = cc->iv_gen_ops->generator(cc, iv, sector);
-		if (r < 0)
-			return r;
-
-		if (write)
-			r = crypto_blkcipher_encrypt_iv(&desc, out, in, length);
-		else
-			r = crypto_blkcipher_decrypt_iv(&desc, out, in, length);
-	} else {
-		if (write)
-			r = crypto_blkcipher_encrypt(&desc, out, in, length);
-		else
-			r = crypto_blkcipher_decrypt(&desc, out, in, length);
-	}
-
-	return r;
-}
-
 static void dec_pending(struct crypt_io *io, int error);
 
 static inline void crypt_read_done(struct convert_context *ctx, int async)
@@ -335,6 +328,31 @@ static inline void crypt_read_done(struc
 
 static void crypt_write_done(struct convert_context *ctx, int async);
 
+static void dm_crypt_complete(struct crypto_async_request *req, int err)
+{
+	struct convert_context *ctx = req->data;
+	struct crypt_io *io = container_of(ctx, struct crypt_io, ctx);
+	struct crypt_config *cc = io->target->private;
+
+	if (err == -EINPROGRESS) {
+		complete(&ctx->restart);
+		return;
+	}
+
+	mempool_free(ablkcipher_request_cast(req), cc->req_pool);
+
+	if (err)
+		ctx->err = err;
+
+	if (!atomic_dec_and_test(&ctx->pending))
+		return;
+
+	if (ctx->write)
+		crypt_write_done(ctx, 1);
+	else
+		crypt_read_done(ctx, 1);
+}
+
 static void
 crypt_convert_init(struct crypt_config *cc, struct convert_context *ctx,
                    struct bio *bio_out, struct bio *bio_in,
@@ -348,6 +366,17 @@ crypt_convert_init(struct crypt_config *
 	ctx->idx_out = bio_out ? bio_out->bi_idx : 0;
 	ctx->sector = sector + cc->iv_offset;
 	ctx->write = write;
+
+	init_completion(&ctx->restart);
+
+	atomic_set(&ctx->pending, 2);
+	ctx->err = 0;
+
+	if (cc->req)
+		ablkcipher_request_set_callback(
+			cc->req, CRYPTO_TFM_REQ_MAY_BACKLOG |
+				  CRYPTO_TFM_REQ_MAY_SLEEP,
+			dm_crypt_complete, ctx);
 }
 
 /*
@@ -356,44 +385,91 @@ crypt_convert_init(struct crypt_config *
 static int crypt_convert(struct crypt_config *cc,
                          struct convert_context *ctx)
 {
-	int r = 0;
+	struct ablkcipher_request *req = cc->req;
+	struct dm_crypt_request *dmreq;
+	u8 *iv;
+
+	dmreq = (void *)((char *)req + cc->dmreq_start);
+	iv = (u8 *)ALIGN((unsigned long)(dmreq + 1),
+			 crypto_ablkcipher_alignmask(cc->tfm) + 1);
 
 	while(ctx->idx_in < ctx->bio_in->bi_vcnt &&
 	      ctx->idx_out < ctx->bio_out->bi_vcnt) {
 		struct bio_vec *bv_in = bio_iovec_idx(ctx->bio_in, ctx->idx_in);
 		struct bio_vec *bv_out = bio_iovec_idx(ctx->bio_out, ctx->idx_out);
-		struct scatterlist sg_in = {
-			.page = bv_in->bv_page,
-			.offset = bv_in->bv_offset + ctx->offset_in,
-			.length = 1 << SECTOR_SHIFT
-		};
-		struct scatterlist sg_out = {
-			.page = bv_out->bv_page,
-			.offset = bv_out->bv_offset + ctx->offset_out,
-			.length = 1 << SECTOR_SHIFT
-		};
+		int r;
+
+		if (!req) {
+			req = mempool_alloc(cc->req_pool, GFP_NOIO);
+			ablkcipher_request_set_tfm(req, cc->tfm);
+			ablkcipher_request_set_callback(
+				req, CRYPTO_TFM_REQ_MAY_BACKLOG |
+				     CRYPTO_TFM_REQ_MAY_SLEEP,
+				dm_crypt_complete, ctx);
+			dmreq = (void *)((char *)req + cc->dmreq_start);
+			iv = (u8 *)ALIGN(
+				(unsigned long)(dmreq + 1),
+				crypto_ablkcipher_alignmask(cc->tfm) + 1);
+		}
 
-		ctx->offset_in += sg_in.length;
+		dmreq->sg_in.page = bv_in->bv_page;
+		dmreq->sg_in.offset = bv_in->bv_offset + ctx->offset_in;
+		dmreq->sg_in.length = 1 << SECTOR_SHIFT;
+
+		dmreq->sg_out.page = bv_out->bv_page;
+		dmreq->sg_out.offset = bv_out->bv_offset + ctx->offset_out;
+		dmreq->sg_out.length = 1 << SECTOR_SHIFT;
+
+		ctx->offset_in += 1<< SECTOR_SHIFT;
 		if (ctx->offset_in >= bv_in->bv_len) {
 			ctx->offset_in = 0;
 			ctx->idx_in++;
 		}
 
-		ctx->offset_out += sg_out.length;
+		ctx->offset_out += 1 << SECTOR_SHIFT;
 		if (ctx->offset_out >= bv_out->bv_len) {
 			ctx->offset_out = 0;
 			ctx->idx_out++;
+		} 
+
+		if (cc->iv_gen_ops) {
+			r = cc->iv_gen_ops->generator(cc, iv, ctx->sector++);
+			if (r < 0) {
+				ctx->err = r;
+				break;
+			}
 		}
 
-		r = crypt_convert_scatterlist(cc, &sg_out, &sg_in, sg_in.length,
-		                              ctx->write, ctx->sector);
-		ctx->err = r;
-		if (r < 0)
-			break;
+		ablkcipher_request_set_crypt(req, &dmreq->sg_in,
+					     &dmreq->sg_out, 1 << SECTOR_SHIFT,
+					     iv);
+		if (ctx->write)
+			r = crypto_ablkcipher_encrypt(req);
+		else
+			r = crypto_ablkcipher_decrypt(req);
 
-		ctx->sector++;
+		switch (r) {
+		case -EBUSY:
+			wait_for_completion(&ctx->restart);
+			INIT_COMPLETION(ctx->restart);
+			/* fall through*/
+		case -EINPROGRESS:
+			atomic_inc(&ctx->pending);
+			req = NULL;
+			/* fall through*/
+		case 0:
+			continue;
+		}
+
+		ctx->err = r;
+		break;
 	}
 
+	cc->req = req;
+
+	if (atomic_sub_return(2, &ctx->pending))
+		return -EINPROGRESS;
+
 	if (ctx->write)
 		crypt_write_done(ctx, 0);
 	else
@@ -824,7 +900,7 @@ static int crypt_wipe_key(struct crypt_c
 static int crypt_ctr(struct dm_target *ti, unsigned int argc, char **argv)
 {
 	struct crypt_config *cc;
-	struct crypto_blkcipher *tfm;
+	struct crypto_ablkcipher *tfm;
 	char *tmp;
 	char *cipher;
 	char *chainmode;
@@ -878,7 +954,7 @@ static int crypt_ctr(struct dm_target *t
 		goto bad1;
 	}
 
-	tfm = crypto_alloc_blkcipher(cc->cipher, 0, CRYPTO_ALG_ASYNC);
+	tfm = crypto_alloc_ablkcipher(cc->cipher, 0, 0);
 	if (IS_ERR(tfm)) {
 		ti->error = "Error allocating crypto tfm";
 		goto bad1;
@@ -912,7 +988,7 @@ static int crypt_ctr(struct dm_target *t
 	    cc->iv_gen_ops->ctr(cc, ti, ivopts) < 0)
 		goto bad2;
 
-	cc->iv_size = crypto_blkcipher_ivsize(tfm);
+	cc->iv_size = crypto_ablkcipher_ivsize(tfm);
 	if (cc->iv_size)
 		/* at least a 64 bit sector number should fit in our buffer */
 		cc->iv_size = max(cc->iv_size,
@@ -932,6 +1008,21 @@ static int crypt_ctr(struct dm_target *t
 		goto bad3;
 	}
 
+	cc->dmreq_start = sizeof(struct ablkcipher_request);
+	cc->dmreq_start += crypto_ablkcipher_reqsize(tfm);
+	cc->dmreq_start = ALIGN(cc->dmreq_start, crypto_tfm_ctx_alignment());
+	cc->dmreq_start += crypto_ablkcipher_alignmask(tfm) &
+			   ~(crypto_tfm_ctx_alignment() - 1);
+
+	cc->req_pool = mempool_create_kmalloc_pool(
+		MIN_IOS, cc->dmreq_start +
+			 sizeof(struct dm_crypt_request) +
+			 cc->iv_size);
+	if (!cc->req_pool) {
+		ti->error = "Cannot allocate crypt request mempool";
+		goto bad_req_pool;
+	}
+
 	cc->page_pool = mempool_create_page_pool(MIN_POOL_PAGES, 0);
 	if (!cc->page_pool) {
 		ti->error = "Cannot allocate page mempool";
@@ -944,7 +1035,7 @@ static int crypt_ctr(struct dm_target *t
 		goto bad_bs;
 	}
 
-	if (crypto_blkcipher_setkey(tfm, cc->key, key_size) < 0) {
+	if (crypto_ablkcipher_setkey(tfm, cc->key, key_size) < 0) {
 		ti->error = "Error setting key";
 		goto bad5;
 	}
@@ -987,12 +1078,14 @@ bad5:
 bad_bs:
 	mempool_destroy(cc->page_pool);
 bad4:
+	mempool_destroy(cc->req_pool);
+bad_req_pool:
 	mempool_destroy(cc->io_pool);
 bad3:
 	if (cc->iv_gen_ops && cc->iv_gen_ops->dtr)
 		cc->iv_gen_ops->dtr(cc);
 bad2:
-	crypto_free_blkcipher(tfm);
+	crypto_free_ablkcipher(tfm);
 bad1:
 	/* Must zero key material before freeing */
 	memset(cc, 0, sizeof(*cc) + cc->key_size * sizeof(u8));
@@ -1004,14 +1097,18 @@ static void crypt_dtr(struct dm_target *
 {
 	struct crypt_config *cc = (struct crypt_config *) ti->private;
 
+	if (cc->req)
+		mempool_free(cc->req, cc->req_pool);
+
 	bioset_free(cc->bs);
 	mempool_destroy(cc->page_pool);
+	mempool_destroy(cc->req_pool);
 	mempool_destroy(cc->io_pool);
 
 	kfree(cc->iv_mode);
 	if (cc->iv_gen_ops && cc->iv_gen_ops->dtr)
 		cc->iv_gen_ops->dtr(cc);
-	crypto_free_blkcipher(cc->tfm);
+	crypto_free_ablkcipher(cc->tfm);
 	dm_put_device(ti, cc->dev);
 
 	/* Must zero key material before freeing */

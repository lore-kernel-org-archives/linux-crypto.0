From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 2/3] [DM] dm-crypt: Add async infrastructure
Date: Wed, 11 Jul 2007 11:05:41 +0800
Message-ID: <E1I8SWL-0001lj-00@gondolin.me.apana.org.au>
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

[DM] dm-crypt: Add async infrastructure

This patch breaks up the read/write processing so that the crypto
operations can complete asynchronously.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
---

 drivers/md/dm-crypt.c |  170 ++++++++++++++++++++++++++++++++++----------------
 1 files changed, 117 insertions(+), 53 deletions(-)

diff --git a/drivers/md/dm-crypt.c b/drivers/md/dm-crypt.c
--- a/drivers/md/dm-crypt.c
+++ b/drivers/md/dm-crypt.c
@@ -28,17 +28,6 @@
 #define MESG_STR(x) x, sizeof(x)
 
 /*
- * per bio private data
- */
-struct crypt_io {
-	struct dm_target *target;
-	struct bio *base_bio;
-	struct work_struct work;
-	atomic_t pending;
-	int error;
-};
-
-/*
  * context holding the current state of a multi-part conversion
  */
 struct convert_context {
@@ -50,6 +39,23 @@ struct convert_context {
 	unsigned int idx_out;
 	sector_t sector;
 	int write;
+	int err;
+};
+
+/*
+ * per bio private data
+ */
+struct crypt_io {
+	struct dm_target *target;
+	struct bio *base_bio;
+	struct work_struct work;
+
+	struct convert_context ctx;
+
+	atomic_t pending;
+	int error;
+	unsigned remaining;
+	sector_t sector;
 };
 
 struct crypt_config;
@@ -318,6 +324,17 @@ crypt_convert_scatterlist(struct crypt_c
 	return r;
 }
 
+static void dec_pending(struct crypt_io *io, int error);
+
+static inline void crypt_read_done(struct convert_context *ctx, int async)
+{
+	struct crypt_io *io = container_of(ctx, struct crypt_io, ctx);
+
+	dec_pending(io, ctx->err);
+}
+
+static void crypt_write_done(struct convert_context *ctx, int async);
+
 static void
 crypt_convert_init(struct crypt_config *cc, struct convert_context *ctx,
                    struct bio *bio_out, struct bio *bio_in,
@@ -370,13 +387,19 @@ static int crypt_convert(struct crypt_co
 
 		r = crypt_convert_scatterlist(cc, &sg_out, &sg_in, sg_in.length,
 		                              ctx->write, ctx->sector);
+		ctx->err = r;
 		if (r < 0)
 			break;
 
 		ctx->sector++;
 	}
 
-	return r;
+	if (ctx->write)
+		crypt_write_done(ctx, 0);
+	else
+		crypt_read_done(ctx, 0);
+
+	return ctx->err;
 }
 
  static void dm_crypt_bio_destructor(struct bio *bio)
@@ -601,72 +624,111 @@ static void process_read(struct crypt_io
 	generic_make_request(clone);
 }
 
-static void process_write(struct crypt_io *io)
+static void crypt_write_loop(struct crypt_io *io)
 {
 	struct crypt_config *cc = io->target->private;
-	struct bio *base_bio = io->base_bio;
-	struct bio *clone;
-	struct convert_context ctx;
-	unsigned remaining = base_bio->bi_size;
-	sector_t sector = base_bio->bi_sector - io->target->begin;
-
-	atomic_inc(&io->pending);
-
-	crypt_convert_init(cc, &ctx, NULL, base_bio, sector, 1);
 
 	/*
 	 * The allocated buffers can be smaller than the whole bio,
 	 * so repeat the whole process until all the data can be handled.
 	 */
-	while (remaining) {
-		clone = crypt_alloc_buffer(io, remaining);
+	do {
+		struct bio *clone;
+
+		clone = crypt_alloc_buffer(io, io->remaining);
 		if (unlikely(!clone)) {
 			dec_pending(io, -ENOMEM);
 			return;
 		}
 
-		ctx.bio_out = clone;
-		ctx.idx_out = 0;
+		io->ctx.bio_out = clone;
+		io->ctx.idx_out = 0;
 
-		if (unlikely(crypt_convert(cc, &ctx) < 0)) {
-			crypt_free_buffer_pages(cc, clone, clone->bi_size);
-			bio_put(clone);
-			dec_pending(io, -EIO);
+		if (crypt_convert(cc, &io->ctx))
 			return;
-		}
+	} while (io->remaining);
+}
+
+static void process_write_endio(struct crypt_io *io, int async)
+{
+	struct bio *clone = io->ctx.bio_out;
+	unsigned remaining = io->remaining;
+
+	/* Grab another reference to the io struct
+	 * before we kick off the request */
+	if (remaining)
+		atomic_inc(&io->pending);
+
+	generic_make_request(clone);
+
+	/* Do not reference clone after this - it
+	 * may be gone already. */
+
+	if (likely(!remaining))
+		return;
+
+	/* out of memory -> run queues */
+	if (remaining)
+		congestion_wait(WRITE, HZ / 100);
+
+	if (!async)
+		return;
+
+	crypt_write_loop(io);
+}
+
+static void crypt_write_done(struct convert_context *ctx, int async)
+{
+	struct bio *clone = ctx->bio_out;
+	struct crypt_io *io = container_of(ctx, struct crypt_io, ctx);
+	struct crypt_config *cc = io->target->private;
 
-		/* crypt_convert should have filled the clone bio */
-		BUG_ON(ctx.idx_out < clone->bi_vcnt);
+	if (ctx->err) {
+		crypt_free_buffer_pages(cc, clone, clone->bi_size);
+		bio_put(clone);
+		dec_pending(io, -EIO);
+		return;
+	}
 
-		clone->bi_sector = cc->start + sector;
-		remaining -= clone->bi_size;
-		sector += bio_sectors(clone);
-
-		/* Grab another reference to the io struct
-		 * before we kick off the request */
-		if (remaining)
-			atomic_inc(&io->pending);
-
-		generic_make_request(clone);
-
-		/* Do not reference clone after this - it
-		 * may be gone already. */
-
-		/* out of memory -> run queues */
-		if (remaining)
-			congestion_wait(WRITE, HZ/100);
+	/* crypt_convert should have filled the clone bio */
+	BUG_ON(ctx->idx_out < clone->bi_vcnt);
+
+	clone->bi_sector = cc->start + io->sector;
+	io->remaining -= clone->bi_size;
+	io->sector += bio_sectors(clone);
+
+	if (async) {
+		kcryptd_queue_io(io);
+		return;
 	}
+
+	process_write_endio(io, 0);
+}
+
+static void process_write(struct crypt_io *io)
+{
+	struct crypt_config *cc = io->target->private;
+	struct bio *base_bio = io->base_bio;
+
+	io->remaining = base_bio->bi_size;
+	io->sector = base_bio->bi_sector - io->target->begin;
+
+	atomic_inc(&io->pending);
+
+	crypt_convert_init(cc, &io->ctx, NULL, base_bio, io->sector, 1);
+
+	if (likely(io->remaining))
+		crypt_write_loop(io);
 }
 
 static void process_read_endio(struct crypt_io *io)
 {
 	struct crypt_config *cc = io->target->private;
-	struct convert_context ctx;
 
-	crypt_convert_init(cc, &ctx, io->base_bio, io->base_bio,
+	crypt_convert_init(cc, &io->ctx, io->base_bio, io->base_bio,
 			   io->base_bio->bi_sector - io->target->begin, 0);
 
-	dec_pending(io, crypt_convert(cc, &ctx));
+	crypt_convert(cc, &io->ctx);
 }
 
 static void kcryptd_do_work(struct work_struct *work)
@@ -675,6 +737,8 @@ static void kcryptd_do_work(struct work_
 
 	if (bio_data_dir(io->base_bio) == READ)
 		process_read(io);
+	else
+		process_write_endio(io, 1);
 } 
 
 static void kcryptd_do_crypt(struct work_struct *work)

From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 1/3] [DM] dm-crypt: Move post-processing into its
	own queue
Date: Mon, 16 Apr 2007 20:59:22 +1000
Message-ID: <E1HdOva-0002wN-00@gondolin.me.apana.org.au>
References: <20070416105823.GA11225@gondor.apana.org.au>
Reply-To: device-mapper development <dm-devel@redhat.com>
To: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
	dm-devel@redhat.com
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

[DM] dm-crypt: Move post-processing into its own queue

With async crypto we can have a large number of crypto requests
outstanding.  When crypto requests for write operations are completed
they need to be given back to the block layer in process context.

We can't reuse kcryptd because it'll queue these requests after
other requests which can cause starvation as memory isn't released
untill these requests are fully complete.

So this patch establishes a new queue for second stage processing.
For now it only serves the crypto operations for reads.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
---

 drivers/md/dm-crypt.c |   48 ++++++++++++++++++++++++++++++++++++++++--------
 1 files changed, 40 insertions(+), 8 deletions(-)

diff --git a/drivers/md/dm-crypt.c b/drivers/md/dm-crypt.c
--- a/drivers/md/dm-crypt.c
+++ b/drivers/md/dm-crypt.c
@@ -37,7 +37,6 @@ struct crypt_io {
 	struct work_struct work;
 	atomic_t pending;
 	int error;
-	int post_process;
 };
 
 /*
@@ -504,13 +503,25 @@ static void dec_pending(struct crypt_io 
 }
 
 /*
- * kcryptd:
+ * kcryptd/kcryptd-post:
  *
  * Needed because it would be very unwise to do decryption in an
  * interrupt context.
+ *
+ * kcryptd performs the first stage, which is the actual read for
+ * read processing and encryption for write processing.
+ *
+ * kcryptd-post performs the final stage, which is description for
+ * read processing and the actual write for write processing.
+ *
+ * They must be separated as otherwise the final stages could be
+ * starved by new requests which can block in the first stages due
+ * to memory allocation.
  */
 static struct workqueue_struct *_kcryptd_workqueue;
+static struct workqueue_struct *_kcryptd_post_workqueue;
 static void kcryptd_do_work(struct work_struct *work);
+static void kcryptd_post_work(struct work_struct *work);
 
 static void kcryptd_queue_io(struct crypt_io *io)
 {
@@ -518,6 +529,12 @@ static void kcryptd_queue_io(struct cryp
 	queue_work(_kcryptd_workqueue, &io->work);
 }
 
+static void kcryptd_queue_postio(struct crypt_io *io)
+{
+	INIT_WORK(&io->work, kcryptd_post_work);
+	queue_work(_kcryptd_post_workqueue, &io->work);
+}
+
 static int crypt_endio(struct bio *clone, unsigned int done, int error)
 {
 	struct crypt_io *io = clone->bi_private;
@@ -544,8 +561,7 @@ static int crypt_endio(struct bio *clone
 	}
 
 	bio_put(clone);
-	io->post_process = 1;
-	kcryptd_queue_io(io);
+	kcryptd_queue_postio(io);
 	return 0;
 
 out:
@@ -674,12 +690,18 @@ static void kcryptd_do_work(struct work_
 {
 	struct crypt_io *io = container_of(work, struct crypt_io, work);
 
-	if (io->post_process)
-		process_read_endio(io);
-	else if (bio_data_dir(io->base_bio) == READ)
+	if (bio_data_dir(io->base_bio) == READ)
 		process_read(io);
 	else
 		process_write(io);
+} 
+
+static void kcryptd_post_work(struct work_struct *work)
+{
+	struct crypt_io *io = container_of(work, struct crypt_io, work);
+
+	if (bio_data_dir(io->base_bio) == READ)
+		process_read_endio(io);
 }
 
 /*
@@ -958,7 +980,7 @@ static int crypt_map(struct dm_target *t
 	io->target = ti;
 	io->base_bio = bio;
 	io->first_clone = NULL;
-	io->error = io->post_process = 0;
+	io->error = 0;
 	atomic_set(&io->pending, 0);
 	kcryptd_queue_io(io);
 
@@ -1086,6 +1108,13 @@ static int __init dm_crypt_init(void)
 		goto bad1;
 	}
 
+	_kcryptd_post_workqueue = create_workqueue("kcryptd-post");
+	if (!_kcryptd_post_workqueue) {
+		r = -ENOMEM;
+		DMERR("couldn't create kcryptd-post");
+		goto bad1_5;
+	}
+
 	r = dm_register_target(&crypt_target);
 	if (r < 0) {
 		DMERR("register failed %d", r);
@@ -1095,6 +1124,8 @@ static int __init dm_crypt_init(void)
 	return 0;
 
 bad2:
+	destroy_workqueue(_kcryptd_post_workqueue);
+bad1_5:
 	destroy_workqueue(_kcryptd_workqueue);
 bad1:
 	kmem_cache_destroy(_crypt_io_pool);
@@ -1108,6 +1139,7 @@ static void __exit dm_crypt_exit(void)
 	if (r < 0)
 		DMERR("unregister failed %d", r);
 
+	destroy_workqueue(_kcryptd_post_workqueue);
 	destroy_workqueue(_kcryptd_workqueue);
 	kmem_cache_destroy(_crypt_io_pool);
 }

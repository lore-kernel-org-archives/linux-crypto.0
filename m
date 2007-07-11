From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 1/3] [DM] dm-crypt: Move post-processing into its own queue
Date: Wed, 11 Jul 2007 11:05:37 +0800
Message-ID: <E1I8SWH-0001lg-00@gondolin.me.apana.org.au>
References: <20070711030303.GA6730@gondor.apana.org.au>
To: Alasdair G Kergon <agk@redhat.com>, dm-devel@redhat.com,
	Christophe Saout <christophe@saout.de>,
	Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from rhun.apana.org.au ([64.62.148.172]:2515 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754557AbXGKDFr (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 10 Jul 2007 23:05:47 -0400
Sender: linux-crypto-owner@vger.kernel.org
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

 drivers/md/dm-crypt.c |   51 +++++++++++++++++++++++++++++++++++++++++---------
 1 files changed, 42 insertions(+), 9 deletions(-)

diff --git a/drivers/md/dm-crypt.c b/drivers/md/dm-crypt.c
--- a/drivers/md/dm-crypt.c
+++ b/drivers/md/dm-crypt.c
@@ -36,7 +36,6 @@ struct crypt_io {
 	struct work_struct work;
 	atomic_t pending;
 	int error;
-	int post_process;
 };
 
 /*
@@ -495,17 +494,33 @@ static void dec_pending(struct crypt_io 
 }
 
 /*
- * kcryptd:
+ * kcryptd/kcryptd-io:
  *
  * Needed because it would be very unwise to do decryption in an
  * interrupt context.
+ *
+ * kcryptd performs the actual encryption or decryption.
+ *
+ * kcryptd-io performs the IO submission.
+ *
+ * They must be separated as otherwise the final stages could be
+ * starved by new requests which can block in the first stages due
+ * to memory allocation.
  */
 static struct workqueue_struct *_kcryptd_workqueue;
+static struct workqueue_struct *_kcryptd_io_workqueue;
 static void kcryptd_do_work(struct work_struct *work);
+static void kcryptd_do_crypt(struct work_struct *work);
 
 static void kcryptd_queue_io(struct crypt_io *io)
 {
 	INIT_WORK(&io->work, kcryptd_do_work);
+	queue_work(_kcryptd_io_workqueue, &io->work);
+}
+
+static void kcryptd_queue_crypt(struct crypt_io *io)
+{
+	INIT_WORK(&io->work, kcryptd_do_crypt);
 	queue_work(_kcryptd_workqueue, &io->work);
 }
 
@@ -535,8 +550,7 @@ static int crypt_endio(struct bio *clone
 	}
 
 	bio_put(clone);
-	io->post_process = 1;
-	kcryptd_queue_io(io);
+	kcryptd_queue_crypt(io);
 	return 0;
 
 out:
@@ -659,10 +673,16 @@ static void kcryptd_do_work(struct work_
 {
 	struct crypt_io *io = container_of(work, struct crypt_io, work);
 
-	if (io->post_process)
-		process_read_endio(io);
-	else if (bio_data_dir(io->base_bio) == READ)
+	if (bio_data_dir(io->base_bio) == READ)
 		process_read(io);
+} 
+
+static void kcryptd_do_crypt(struct work_struct *work)
+{
+	struct crypt_io *io = container_of(work, struct crypt_io, work);
+
+	if (bio_data_dir(io->base_bio) == READ)
+		process_read_endio(io);
 	else
 		process_write(io);
 }
@@ -947,9 +967,12 @@ static int crypt_map(struct dm_target *t
 	io = mempool_alloc(cc->io_pool, GFP_NOIO);
 	io->target = ti;
 	io->base_bio = bio;
-	io->error = io->post_process = 0;
+	io->error = 0;
 	atomic_set(&io->pending, 0);
-	kcryptd_queue_io(io);
+	if (bio_data_dir(io->base_bio) == READ)
+		kcryptd_queue_io(io);
+	else
+		kcryptd_queue_crypt(io);
 
 	return DM_MAPIO_SUBMITTED;
 }
@@ -1075,6 +1098,13 @@ static int __init dm_crypt_init(void)
 		goto bad1;
 	}
 
+	_kcryptd_io_workqueue = create_workqueue("kcryptd-io");
+	if (!_kcryptd_io_workqueue) {
+		r = -ENOMEM;
+		DMERR("couldn't create kcryptd-io");
+		goto bad1_5;
+	}
+
 	r = dm_register_target(&crypt_target);
 	if (r < 0) {
 		DMERR("register failed %d", r);
@@ -1084,6 +1114,8 @@ static int __init dm_crypt_init(void)
 	return 0;
 
 bad2:
+	destroy_workqueue(_kcryptd_io_workqueue);
+bad1_5:
 	destroy_workqueue(_kcryptd_workqueue);
 bad1:
 	kmem_cache_destroy(_crypt_io_pool);
@@ -1097,6 +1129,7 @@ static void __exit dm_crypt_exit(void)
 	if (r < 0)
 		DMERR("unregister failed %d", r);
 
+	destroy_workqueue(_kcryptd_io_workqueue);
 	destroy_workqueue(_kcryptd_workqueue);
 	kmem_cache_destroy(_crypt_io_pool);
 }

From: Alasdair G Kergon <agk@redhat.com>
Subject: Re: [2.6.28.5] dm/crypt oops: "unable to handle kernel NULL pointer dereference" (tainted)
Date: Fri, 13 Mar 2009 13:49:16 +0000
Message-ID: <20090313134916.GI7445@agk.fab.redhat.com>
References: <200903111319.43778@rk-nord.at> <49B82232.2090802@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Milan Broz <mbroz@redhat.com>
To: Melchior FRANZ <melchior.franz@gmail.com>,
	linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mx2.redhat.com ([66.187.237.31]:47882 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753500AbZCMNtV (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Fri, 13 Mar 2009 09:49:21 -0400
Content-Disposition: inline
In-Reply-To: <49B82232.2090802@redhat.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Latest version of this patch - please give this some testing!

Alasdair


From: Milan Broz <mbroz@redhat.com>

The following oops has been reported when dm-crypt runs over a loop device.

...
[   70.381058] Process loop0 (pid: 4268, ti=cf3b2000 task=cf1cc1f0 task.ti=cf3b2000)
...
[   70.381058] Call Trace:
[   70.381058]  [<d0d76601>] ? crypt_dec_pending+0x5e/0x62 [dm_crypt]
[   70.381058]  [<d0d767b8>] ? crypt_endio+0xa2/0xaa [dm_crypt]
[   70.381058]  [<d0d76716>] ? crypt_endio+0x0/0xaa [dm_crypt]
[   70.381058]  [<c01a2f24>] ? bio_endio+0x2b/0x2e
[   70.381058]  [<d0806530>] ? dec_pending+0x224/0x23b [dm_mod]
[   70.381058]  [<d08066e4>] ? clone_endio+0x79/0xa4 [dm_mod]
[   70.381058]  [<d080666b>] ? clone_endio+0x0/0xa4 [dm_mod]
[   70.381058]  [<c01a2f24>] ? bio_endio+0x2b/0x2e
[   70.381058]  [<c02bad86>] ? loop_thread+0x380/0x3b7
[   70.381058]  [<c02ba8a1>] ? do_lo_send_aops+0x0/0x165
[   70.381058]  [<c013754f>] ? autoremove_wake_function+0x0/0x33
[   70.381058]  [<c02baa06>] ? loop_thread+0x0/0x3b7

When a table is being replaced, it waits for I/O to complete 
before destroying the mempool, but the endio function doesn't
call mempool_free() until after completing the bio.

Fix it by swapping the order of those two operations.

The same problem occurs in dm.c with referenced after dec_pending.
Again, we swap the order.

Signed-off-by: Milan Broz <mbroz@redhat.com>
Signed-off-by: Alasdair G Kergon <agk@redhat.com>
---
 drivers/md/dm-crypt.c |   17 ++++++++++-------
 drivers/md/dm.c       |   32 +++++++++++++++++++-------------
 2 files changed, 29 insertions(+), 20 deletions(-)

Index: linux-2.6.29-rc7/drivers/md/dm-crypt.c
===================================================================
--- linux-2.6.29-rc7.orig/drivers/md/dm-crypt.c	2009-03-13 11:06:18.000000000 +0000
+++ linux-2.6.29-rc7/drivers/md/dm-crypt.c	2009-03-13 11:07:46.000000000 +0000
@@ -568,19 +568,22 @@ static void crypt_inc_pending(struct dm_
 static void crypt_dec_pending(struct dm_crypt_io *io)
 {
 	struct crypt_config *cc = io->target->private;
+	struct bio *base_bio = io->base_bio;
+	struct dm_crypt_io *base_io = io->base_io;
+	int error = io->error;
 
 	if (!atomic_dec_and_test(&io->pending))
 		return;
 
-	if (likely(!io->base_io))
-		bio_endio(io->base_bio, io->error);
+	mempool_free(io, cc->io_pool);
+
+	if (likely(!base_io))
+		bio_endio(base_bio, error);
 	else {
-		if (io->error && !io->base_io->error)
-			io->base_io->error = io->error;
-		crypt_dec_pending(io->base_io);
+		if (error && !base_io->error)
+			base_io->error = error;
+		crypt_dec_pending(base_io);
 	}
-
-	mempool_free(io, cc->io_pool);
 }
 
 /*
Index: linux-2.6.29-rc7/drivers/md/dm.c
===================================================================
--- linux-2.6.29-rc7.orig/drivers/md/dm.c	2009-03-09 22:12:09.000000000 +0000
+++ linux-2.6.29-rc7/drivers/md/dm.c	2009-03-13 12:34:19.000000000 +0000
@@ -525,9 +525,12 @@ static int __noflush_suspending(struct m
 static void dec_pending(struct dm_io *io, int error)
 {
 	unsigned long flags;
+	int io_error;
+	struct bio *bio;
+	struct mapped_device *md = io->md;
 
 	/* Push-back supersedes any I/O errors */
-	if (error && !(io->error > 0 && __noflush_suspending(io->md)))
+	if (error && !(io->error > 0 && __noflush_suspending(md)))
 		io->error = error;
 
 	if (atomic_dec_and_test(&io->io_count)) {
@@ -537,24 +540,27 @@ static void dec_pending(struct dm_io *io
 			 * This must be handled before the sleeper on
 			 * suspend queue merges the pushback list.
 			 */
-			spin_lock_irqsave(&io->md->pushback_lock, flags);
-			if (__noflush_suspending(io->md))
-				bio_list_add(&io->md->pushback, io->bio);
+			spin_lock_irqsave(&md->pushback_lock, flags);
+			if (__noflush_suspending(md))
+				bio_list_add(&md->pushback, io->bio);
 			else
 				/* noflush suspend was interrupted. */
 				io->error = -EIO;
-			spin_unlock_irqrestore(&io->md->pushback_lock, flags);
+			spin_unlock_irqrestore(&md->pushback_lock, flags);
 		}
 
 		end_io_acct(io);
 
-		if (io->error != DM_ENDIO_REQUEUE) {
-			trace_block_bio_complete(io->md->queue, io->bio);
+		io_error = io->error;
+		bio = io->bio;
 
-			bio_endio(io->bio, io->error);
-		}
+		free_io(md, io);
 
-		free_io(io->md, io);
+		if (io_error != DM_ENDIO_REQUEUE) {
+			trace_block_bio_complete(md->queue, bio);
+
+			bio_endio(bio, io_error);
+		}
 	}
 }
 
@@ -562,6 +568,7 @@ static void clone_endio(struct bio *bio,
 {
 	int r = 0;
 	struct dm_target_io *tio = bio->bi_private;
+	struct dm_io *io = tio->io;
 	struct mapped_device *md = tio->io->md;
 	dm_endio_fn endio = tio->ti->type->end_io;
 
@@ -585,15 +592,14 @@ static void clone_endio(struct bio *bio,
 		}
 	}
 
-	dec_pending(tio->io, error);

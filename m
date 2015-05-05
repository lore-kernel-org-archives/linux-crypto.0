From: Rabin Vincent <rabin.vincent@axis.com>
Subject: [PATCH] Revert "dm crypt: fix deadlock when async crypto algorithm returns -EBUSY"
Date: Tue, 5 May 2015 15:15:56 +0200
Message-ID: <1430831756-13155-1-git-send-email-rabin.vincent@axis.com>
References: <20150505125040.GB7782@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain
Cc: <ben.c@servergy.com>, <dm-devel@redhat.com>,
	<linux-crypto@vger.kernel.org>, <mbroz@redhat.com>,
	<herbert@gondor.apana.org.au>, Rabin Vincent <rabinv@axis.com>
To: <snitzer@redhat.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from bastet.se.axis.com ([195.60.68.11]:40698 "EHLO
	bastet.se.axis.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1422917AbbEENQM (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 5 May 2015 09:16:12 -0400
In-Reply-To: <20150505125040.GB7782@redhat.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

This reverts commit 0618764cb25f6fa9fb31152995de42a8a0496475.

The problem which that commit attempts to fix actually lies in the
Freescale CAAM crypto driver.

dm-crypt uses CRYPTO_TFM_REQ_MAY_BACKLOG.  This means the the crypto
driver should internally backlog requests which arrive when the queue is
full and process them later.  Until the crypto hw's queue becomes full,
the driver returns -EINPROGRESS.  When the crypto hw's queue if full,
the driver returns -EBUSY, and if CRYPTO_TFM_REQ_MAY_BACKLOG is set, is
expected to backlog the request and process it when the hardware has
queue space.  At the point when the driver takes the request from the
backlog and starts processing it, it calls the completion function with
a status of -EINPROGRESS.  The completion function is called (for a
second time, in the case of backlogged requests) with a status/err of 0
when a request is done.

Crypto drivers for hardware without hardware queueing use the helpers,
crypto_init_queue(), crypto_enqueue_request(), crypto_dequeue_request()
and crypto_get_backlog() helpers to implement this behaviour correctly,
while others implement this behaviour without these helpers (ccp, for
example).

dm-crypt (before this patch) uses this API correctly.  It queues up as
many requests as the hw queues will allow (i.e. as long as it gets back
-EINPROGRESS from the request function).  Then, when it sees at least
one backlogged request (gets -EBUSY), it waits till that backlogged
request is handled (completion gets called with -EINPROGRESS), and then
continues.  The references to af_alg_wait_for_completion() and
af_alg_complete() in that commit's commit message are irrelevant because
those functions only handle one request at a time, unlink dm-crypt.

The problem is that the Freescale CAAM driver, which that commit
describes as having being tested with, fails to implement the
backlogging behaviour correctly.  In cam_jr_enqueue(), if the hardware
queue is full, it simply returns -EBUSY without backlogging the request.
What the observed deadlock was is not described in the commit message
but it is obviously the wait_for_completion() in crypto_convert() where
dm-crypto would wait for the completion being called with -EINPROGRESS
in the case of backlogged requests.  This completion will never be
completed due to the bug in the CAAM driver.

What that commit does is that it makes dm-crypt wait for every request,
even when the driver/hardware queues are not full, which means that
dm-crypt will never see -EBUSY.  This means that that commit will cause
a performance regression on all crypto drivers which implement the API
correctly.

Revert it.  Correct backlog handling should be implemented in the CAAM
driver instead.

Signed-off-by: Rabin Vincent <rabin.vincent@axis.com>
---
 drivers/md/dm-crypt.c |   12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/md/dm-crypt.c b/drivers/md/dm-crypt.c
index 9eeea19..5503e43 100644
--- a/drivers/md/dm-crypt.c
+++ b/drivers/md/dm-crypt.c
@@ -925,10 +925,11 @@ static int crypt_convert(struct crypt_config *cc,
 
 		switch (r) {
 		/* async */
-		case -EINPROGRESS:
 		case -EBUSY:
 			wait_for_completion(&ctx->restart);
 			reinit_completion(&ctx->restart);
+			/* fall through*/
+		case -EINPROGRESS:
 			ctx->req = NULL;
 			ctx->cc_sector++;
 			continue;
@@ -1345,8 +1346,10 @@ static void kcryptd_async_done(struct crypto_async_request *async_req,
 	struct dm_crypt_io *io = container_of(ctx, struct dm_crypt_io, ctx);
 	struct crypt_config *cc = io->cc;
 
-	if (error == -EINPROGRESS)
+	if (error == -EINPROGRESS) {
+		complete(&ctx->restart);
 		return;
+	}
 
 	if (!error && cc->iv_gen_ops && cc->iv_gen_ops->post)
 		error = cc->iv_gen_ops->post(cc, iv_of_dmreq(cc, dmreq), dmreq);
@@ -1357,15 +1360,12 @@ static void kcryptd_async_done(struct crypto_async_request *async_req,
 	crypt_free_req(cc, req_of_dmreq(cc, dmreq), io->base_bio);
 
 	if (!atomic_dec_and_test(&ctx->cc_pending))
-		goto done;
+		return;
 
 	if (bio_data_dir(io->base_bio) == READ)
 		kcryptd_crypt_read_done(io);
 	else
 		kcryptd_crypt_write_io_submit(io, 1);
-done:
-	if (!completion_done(&ctx->restart))
-		complete(&ctx->restart);
 }
 
 static void kcryptd_crypt(struct work_struct *work)
-- 
1.7.10.4

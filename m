From: "Brad Bosch" <bradbosch@comcast.net>
Subject: Crypto oops in async_chainiv_do_postponed
Date: Thu, 27 Aug 2009 17:13:04 -0500
Message-ID: <19095.1264.682820.125602@waldo.imnotcreative.homeip.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: linux-crypto@vger.kernel.org
To: herbert@gondor.apana.org.au
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from qmta10.westchester.pa.mail.comcast.net ([76.96.62.17]:38905
	"EHLO QMTA10.westchester.pa.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751899AbZH0WTM (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 27 Aug 2009 18:19:12 -0400
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Herbert,

I seem to have found a bug in chainiv.c.  The following oops occured
while using blowfish and hmac-sha with UDP.  The patch (against
2.6.27.30) after the oops output below is an completely untested
possible fix.  We will be testing this fix starting tomorrow.

The null dereference occurs when subreq is dereferenced in
async_chainiv_do_postponed().  My guess is that the
skcipher_givcrypt_request block has been freed and subsequently
overwritten by the time the postponed request is processed.  This
could happen if chainiv_givencrypt() returns anything other than
-EINPROGRESS after postponing the request.  From what I can see, this
could indeed happen since the same err field in async_chainiv_ctx is
used both when the request is postponed and also when it is later
processed by the worker thread.  Neither the lock, nor the
CHAINIV_STATE_INUSE bit in ctx->state will prevent this race which
results in the -EINPROGRESS err being overwritten between the time it
is placed in ctx->err in async_chainiv_postpone_request() and when it
is read back out in async_chainiv_schedule_work().  I am curious why
this method of returning the error code was used in the first place.

Please let me know if this change looks OK and I will follow up after I test
this patch.

Thanks!

--Brad

BUG: unable to handle kernel NULL pointer dereference at 0000003c
IP: [<c054994b>] async_chainiv_do_postponed+0x38/0x5d
*pde = 00000000 
Oops: 0002 [#1] PREEMPT SMP 
Modules linked in: loop

Pid: 19, comm: events/0 Not tainted (2.6.27.31-wmspt #1)
EIP: 0060:[<c054994b>] EFLAGS: 00010286 CPU: 0
EIP is at async_chainiv_do_postponed+0x38/0x5d
EAX: f78c2000 EBX: fffffff0 ECX: 00000000 EDX: 00000000
ESI: f4f5bdf4 EDI: 00000000 EBP: f4f5bdf0 ESP: f78c3f5c
 DS: 007b ES: 007b FS: 00d8 GS: 0000 SS: 0068
Process events/0 (pid: 19, ti=f78c2000 task=f78ae430 task.ti=f78c2000)
Stack: f4f5be14 f789bd40 f4f5be10 c0549913 c042c7e9 f789bd40 f78c3f98 f78c3fb8 
       00000005 c042c8fc 00000000 f78ae430 c042f33e f78c3fb0 f78c3fb0 c0928a80 
       c041baf3 00000000 00000000 f78ae430 c042f33e f78c3fb0 f78c3fb0 00000000 
Call Trace:
 [<c0549913>] async_chainiv_do_postponed+0x0/0x5d
 [<c042c7e9>] run_workqueue+0x72/0xf8
 [<c042c8fc>] worker_thread+0x8d/0x99
 [<c042f33e>] autoremove_wake_function+0x0/0x2d
 [<c041baf3>] __wake_up_common+0x37/0x61
 [<c042f33e>] autoremove_wake_function+0x0/0x2d
 [<c041bbdb>] complete+0x28/0x36
 [<c042c86f>] worker_thread+0x0/0x99
 [<c042ee53>] kthread+0x34/0x55
 [<c042ee1f>] kthread+0x0/0x55
 [<c04037df>] kernel_thread_helper+0x7/0x10
 =======================
Code: eb 14 89 f0 e8 92 16 23 00 89 d8 e8 c2 df ff ff 8d 58 f0 89 c7 89 f0 e8 15 18 23 00 85 db 75 0b 5b 89 e8 5e 5f 5d e9 00 fe ff ff <81> 4f 3c 00 02 00 00 89 d8 e8 6f fe ff ff 89 c3 e8 c4 9e ed ff 
EIP: [<c054994b>] async_chainiv_do_postponed+0x38/0x5d SS:ESP 0068:f78c3f5c
---[ end trace daceb93ad89f6e25 ]---


Index: chainiv.c
===================================================================
RCS file: /share/cvs/sdg/kernels/kernel.wms/kernel_2_6_27/src/crypto/chainiv.c,v
retrieving revision 1.1.1.1.4.2
diff -u -r1.1.1.1.4.2 chainiv.c
--- chainiv.c	10 Mar 2009 05:16:24 -0000	1.1.1.1.4.2
+++ chainiv.c	27 Aug 2009 19:40:27 -0000
@@ -36,7 +36,6 @@
 	unsigned long state;
 
 	spinlock_t lock;
-	int err;
 
 	struct crypto_queue queue;
 	struct work_struct postponed;
@@ -114,10 +113,9 @@
 	return chainiv_init_common(tfm);
 }
 
-static int async_chainiv_schedule_work(struct async_chainiv_ctx *ctx)
+static void async_chainiv_schedule_work(struct async_chainiv_ctx *ctx)
 {
 	int queued;
-	int err = ctx->err;
 
 	if (!ctx->queue.qlen) {
 		smp_mb__before_clear_bit();
@@ -125,14 +123,11 @@
 
 		if (!ctx->queue.qlen ||
 		    test_and_set_bit(CHAINIV_STATE_INUSE, &ctx->state))
-			goto out;
+			return;
 	}
 
 	queued = schedule_work(&ctx->postponed);
 	BUG_ON(!queued);
-
-out:
-	return err;
 }
 
 static int async_chainiv_postpone_request(struct skcipher_givcrypt_request *req)
@@ -148,8 +143,8 @@
 	if (test_and_set_bit(CHAINIV_STATE_INUSE, &ctx->state))
 		return err;
 
-	ctx->err = err;
-	return async_chainiv_schedule_work(ctx);
+	async_chainiv_schedule_work(ctx);
+	return err;
 }
 
 static int async_chainiv_givencrypt_tail(struct skcipher_givcrypt_request *req)
@@ -158,18 +153,20 @@
 	struct async_chainiv_ctx *ctx = crypto_ablkcipher_ctx(geniv);
 	struct ablkcipher_request *subreq = skcipher_givcrypt_reqctx(req);
 	unsigned int ivsize = crypto_ablkcipher_ivsize(geniv);
+	int err;
 
 	memcpy(req->giv, ctx->iv, ivsize);
 	memcpy(subreq->info, ctx->iv, ivsize);
 
-	ctx->err = crypto_ablkcipher_encrypt(subreq);
-	if (ctx->err)
+	err = crypto_ablkcipher_encrypt(subreq);
+	if (err)
 		goto out;
 
 	memcpy(ctx->iv, subreq->info, ivsize);
 
 out:
-	return async_chainiv_schedule_work(ctx);
+	async_chainiv_schedule_work(ctx);
+	return err;
 }
 
 static int async_chainiv_givencrypt(struct skcipher_givcrypt_request *req)
@@ -236,7 +233,7 @@
 	spin_unlock_bh(&ctx->lock);
 
 	if (!req) {
-		async_chainiv_schedule_work(ctx);
+	    async_chainiv_schedule_work(ctx);
 		return;
 	}
 

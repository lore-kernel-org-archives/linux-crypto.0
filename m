From: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>
Subject: [PATCH] Re: aesni intel and kernel crashes.
Date: Thu, 18 Oct 2012 14:52:49 +0300
Message-ID: <20121018115249.22157.69385.stgit@localhost6.localdomain6>
References: <CA+sc+0T3CFwv6JdcLA66=pD=6LcaQOJZnvDGqp3o4LKN85ZbZg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: linux-crypto <linux-crypto@vger.kernel.org>
To: Gurucharan Shetty <gurucharan.shetty@gmail.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from sd-mail-sa-02.sanoma.fi ([158.127.18.162]:35270 "EHLO
	sd-mail-sa-02.sanoma.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753545Ab2JRLwx (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 18 Oct 2012 07:52:53 -0400
In-Reply-To: <CA+sc+0T3CFwv6JdcLA66=pD=6LcaQOJZnvDGqp3o4LKN85ZbZg@mail.gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Does this patch help?

It applies cleanly to 3.2.x, if that version easier for you to reproduce the
issue.

...

cryptd_queue_worker attempts to prevent simultanious accesses to crypto-work
queue by cryptd_enqueue_request using preempt_disable/preempt_enable. However
cryptd_enqueue_request might be called from interrupt context, so add
local_irq_save/local_irq_restore to prevent data corruption and panics.
---
 crypto/cryptd.c |   11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

diff --git a/crypto/cryptd.c b/crypto/cryptd.c
index 671d4d6..8f62d06 100644
--- a/crypto/cryptd.c
+++ b/crypto/cryptd.c
@@ -133,16 +133,23 @@ static int cryptd_enqueue_request(struct cryptd_queue *queue,
  * do. */
 static void cryptd_queue_worker(struct work_struct *work)
 {
+	unsigned long flags;
 	struct cryptd_cpu_queue *cpu_queue;
 	struct crypto_async_request *req, *backlog;
 
 	cpu_queue = container_of(work, struct cryptd_cpu_queue, work);
-	/* Only handle one request at a time to avoid hogging crypto
+	/*
+	 * Only handle one request at a time to avoid hogging crypto
 	 * workqueue. preempt_disable/enable is used to prevent
-	 * being preempted by cryptd_enqueue_request() */
+	 * being preempted by cryptd_enqueue_request(). local_irq_save/restore
+	 * is used to prevent cryptd_enqueue_request() being accessed from
+	 * interrupts.
+	 */
+	local_irq_save(flags);
 	preempt_disable();
 	backlog = crypto_get_backlog(&cpu_queue->queue);
 	req = crypto_dequeue_request(&cpu_queue->queue);
+	local_irq_restore(flags);
 	preempt_enable();
 
 	if (!req)

From: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>
Subject: [PATCH] crypto: cryptd - disable interrupts in cryptd_queue_worker to
 prevent data corruption
Date: Sat, 20 Oct 2012 12:13:14 +0300
Message-ID: <20121020091314.32511.49390.stgit@localhost6.localdomain6>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: stable@kernel.org, Gurucharan Shetty <gurucharan.shetty@gmail.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>
To: linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from sd-mail-sa-02.sanoma.fi ([158.127.18.162]:57792 "EHLO
	sd-mail-sa-02.sanoma.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753868Ab2JTJNT (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Sat, 20 Oct 2012 05:13:19 -0400
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

cryptd_queue_worker attempts to prevent simultaneous accesses to crypto
workqueue by cryptd_enqueue_request using preempt_disable/preempt_enable.
However cryptd_enqueue_request might be called from interrupt context,
so add local_irq_save/local_irq_restore to prevent data corruption and
panics.

Bug report at http://marc.info/?l=linux-crypto-vger&m=134858649616319&w=2

Cc: stable@kernel.org
Reported-by: Gurucharan Shetty <gurucharan.shetty@gmail.com>
Tested-by: Gurucharan Shetty <gurucharan.shetty@gmail.com>
Signed-off-by: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>
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

From: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>
Subject: [PATCH] [v2] crypto: cryptd - disable softirqs in cryptd_queue_worker
 to prevent data corruption
Date: Sun, 21 Oct 2012 20:42:28 +0300
Message-ID: <20121021174228.9770.3775.stgit@localhost6.localdomain6>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: Gurucharan Shetty <gurucharan.shetty@gmail.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	stable@vger.kernel.org, "David S. Miller" <davem@davemloft.net>
To: linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from sd-mail-sa-01.sanoma.fi ([158.127.18.161]:36337 "EHLO
	sd-mail-sa-01.sanoma.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932303Ab2JURmb (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Sun, 21 Oct 2012 13:42:31 -0400
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

cryptd_queue_worker attempts to prevent simultaneous accesses to crypto
workqueue by cryptd_enqueue_request using preempt_disable/preempt_enable.
However cryptd_enqueue_request might be called from softirq context,
so add local_bh_disable/local_bh_enable to prevent data corruption and
panics.

Bug report at http://marc.info/?l=linux-crypto-vger&m=134858649616319&w=2

v2:
 - Disable software interrupts instead of hardware interrupts

Cc: stable@vger.kernel.org
Reported-by: Gurucharan Shetty <gurucharan.shetty@gmail.com>
Signed-off-by: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>
---
 crypto/cryptd.c |   11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

diff --git a/crypto/cryptd.c b/crypto/cryptd.c
index 671d4d6..7bdd61b 100644
--- a/crypto/cryptd.c
+++ b/crypto/cryptd.c
@@ -137,13 +137,18 @@ static void cryptd_queue_worker(struct work_struct *work)
 	struct crypto_async_request *req, *backlog;
 
 	cpu_queue = container_of(work, struct cryptd_cpu_queue, work);
-	/* Only handle one request at a time to avoid hogging crypto
-	 * workqueue. preempt_disable/enable is used to prevent
-	 * being preempted by cryptd_enqueue_request() */
+	/*
+	 * Only handle one request at a time to avoid hogging crypto workqueue.
+	 * preempt_disable/enable is used to prevent being preempted by
+	 * cryptd_enqueue_request(). local_bh_disable/enable is used to prevent
+	 * cryptd_enqueue_request() being accessed from software interrupts.
+	 */
+	local_bh_disable();
 	preempt_disable();
 	backlog = crypto_get_backlog(&cpu_queue->queue);
 	req = crypto_dequeue_request(&cpu_queue->queue);
 	preempt_enable();
+	local_bh_enable();
 
 	if (!req)
 		return;

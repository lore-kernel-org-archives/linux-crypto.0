From: Jon Maxwell <jmaxwell37@gmail.com>
Subject: [PATCH net-next] cryptd: Add cryptd_max_cpu_qlen module parameter
Date: Wed, 22 Nov 2017 16:08:17 +1100
Message-ID: <20171122050817.21385-1-jmaxwell37@gmail.com>
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        jmaxwell@redhat.com, Jon Maxwell <jmaxwell37@gmail.com>
To: herbert@gondor.apana.org.au, davem@davemloft.net
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-pf0-f195.google.com ([209.85.192.195]:36213 "EHLO
        mail-pf0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750959AbdKVFIs (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 22 Nov 2017 00:08:48 -0500
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Make the cryptd queue length configurable. We recently had customer where this 
needed to be tuned to accommodate the aesni_intel module and prevent packet 
drop.

Signed-off-by: Jon Maxwell <jmaxwell37@gmail.com>
---
 crypto/cryptd.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/crypto/cryptd.c b/crypto/cryptd.c
index bd43cf5be14c..b1eb131c0f10 100644
--- a/crypto/cryptd.c
+++ b/crypto/cryptd.c
@@ -32,7 +32,9 @@
 #include <linux/sched.h>
 #include <linux/slab.h>
 
-#define CRYPTD_MAX_CPU_QLEN 1000
+unsigned int cryptd_max_cpu_qlen = 1000;
+module_param(cryptd_max_cpu_qlen, uint, 0);
+MODULE_PARM_DESC(cryptd_max_cpu_qlen, "Set cryptd Max queue depth");
 
 struct cryptd_cpu_queue {
 	struct crypto_queue queue;
@@ -116,6 +118,7 @@ static int cryptd_init_queue(struct cryptd_queue *queue,
 		crypto_init_queue(&cpu_queue->queue, max_cpu_qlen);
 		INIT_WORK(&cpu_queue->work, cryptd_queue_worker);
 	}
+	pr_info("cryptd: max_cpu_qlen set to %d\n", max_cpu_qlen);
 	return 0;
 }
 
@@ -1372,7 +1375,7 @@ static int __init cryptd_init(void)
 {
 	int err;
 
-	err = cryptd_init_queue(&queue, CRYPTD_MAX_CPU_QLEN);
+	err = cryptd_init_queue(&queue, cryptd_max_cpu_qlen);
 	if (err)
 		return err;
 
-- 
2.13.6

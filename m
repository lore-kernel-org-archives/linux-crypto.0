From: Leilei Zhao <leilei.zhao@atmel.com>
Subject: [PATCH 05/10] crypto: atmel-sha: initialize spinlock in probe
Date: Tue, 7 Apr 2015 17:45:06 +0800
Message-ID: <1428399911-23325-6-git-send-email-leilei.zhao@atmel.com>
References: <1428399911-23325-1-git-send-email-leilei.zhao@atmel.com>
Mime-Version: 1.0
Content-Type: text/plain
Cc: <linux-arm-kernel@lists.infradead.org>,
	Leilei Zhao <leilei.zhao@atmel.com>
To: <herbert@gondor.apana.org.au>, <davem@davemloft.net>,
	<linux-crypto@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<nicolas.ferre@atmel.com>, <Ludovic.Desroches@atmel.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1428399911-23325-1-git-send-email-leilei.zhao@atmel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Kernel will report "BUG: spinlock lockup suspected on CPU#0"
when CONFIG_DEBUG_SPINLOCK is enabled in kernel config and the
spinlock is used at the first time. It's caused by uninitialized
spinlock, so just initialize it in probe.

Signed-off-by: Leilei Zhao <leilei.zhao@atmel.com>
Acked-by: Nicolas Ferre <nicolas.ferre@atmel.com>
---
 drivers/crypto/atmel-sha.c |    1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/crypto/atmel-sha.c b/drivers/crypto/atmel-sha.c
index 9fb8af1..6430f6a 100644
--- a/drivers/crypto/atmel-sha.c
+++ b/drivers/crypto/atmel-sha.c
@@ -1367,6 +1367,7 @@ static int atmel_sha_probe(struct platform_device *pdev)
 	platform_set_drvdata(pdev, sha_dd);
 
 	INIT_LIST_HEAD(&sha_dd->list);
+	spin_lock_init(&sha_dd->lock);
 
 	tasklet_init(&sha_dd->done_task, atmel_sha_done_task,
 					(unsigned long)sha_dd);
-- 
1.7.9.5

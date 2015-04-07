From: Leilei Zhao <leilei.zhao@atmel.com>
Subject: [PATCH 08/10] crypto: atmel-aes: initialize spinlock in probe
Date: Tue, 7 Apr 2015 17:45:09 +0800
Message-ID: <1428399911-23325-9-git-send-email-leilei.zhao@atmel.com>
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
 drivers/crypto/atmel-aes.c |    1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/crypto/atmel-aes.c b/drivers/crypto/atmel-aes.c
index ddea772..f0532ab 100644
--- a/drivers/crypto/atmel-aes.c
+++ b/drivers/crypto/atmel-aes.c
@@ -1341,6 +1341,7 @@ static int atmel_aes_probe(struct platform_device *pdev)
 	platform_set_drvdata(pdev, aes_dd);
 
 	INIT_LIST_HEAD(&aes_dd->list);
+	spin_lock_init(&aes_dd->lock);
 
 	tasklet_init(&aes_dd->done_task, atmel_aes_done_task,
 					(unsigned long)aes_dd);
-- 
1.7.9.5

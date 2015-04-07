From: Leilei Zhao <leilei.zhao@atmel.com>
Subject: [PATCH 07/10] crypto: atmel-tdes: initialize spinlock in probe
Date: Tue, 7 Apr 2015 17:45:08 +0800
Message-ID: <1428399911-23325-8-git-send-email-leilei.zhao@atmel.com>
References: <1428399911-23325-1-git-send-email-leilei.zhao@atmel.com>
Mime-Version: 1.0
Content-Type: text/plain
Cc: <linux-arm-kernel@lists.infradead.org>,
	Leilei Zhao <leilei.zhao@atmel.com>
To: <herbert@gondor.apana.org.au>, <davem@davemloft.net>,
	<linux-crypto@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<nicolas.ferre@atmel.com>, <Ludovic.Desroches@atmel.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from nasmtp01.atmel.com ([192.199.1.246]:26434 "EHLO
	DVREDG02.corp.atmel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751199AbbDGJu2 (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 7 Apr 2015 05:50:28 -0400
In-Reply-To: <1428399911-23325-1-git-send-email-leilei.zhao@atmel.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Kernel will report "BUG: spinlock lockup suspected on CPU#0"
when CONFIG_DEBUG_SPINLOCK is enabled in kernel config and the
spinlock is used at the first time. It's caused by uninitialized
spinlock, so just initialize it in probe.

Signed-off-by: Leilei Zhao <leilei.zhao@atmel.com>
Acked-by: Nicolas Ferre <nicolas.ferre@atmel.com>
---
 drivers/crypto/atmel-tdes.c |    1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/crypto/atmel-tdes.c b/drivers/crypto/atmel-tdes.c
index 258772d..3517e2a 100644
--- a/drivers/crypto/atmel-tdes.c
+++ b/drivers/crypto/atmel-tdes.c
@@ -1370,6 +1370,7 @@ static int atmel_tdes_probe(struct platform_device *pdev)
 	platform_set_drvdata(pdev, tdes_dd);
 
 	INIT_LIST_HEAD(&tdes_dd->list);
+	spin_lock_init(&tdes_dd->lock);
 
 	tasklet_init(&tdes_dd->done_task, atmel_tdes_done_task,
 					(unsigned long)tdes_dd);
-- 
1.7.9.5

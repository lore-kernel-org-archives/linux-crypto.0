From: Romain Perier <romain.perier@free-electrons.com>
Subject: [PATCH] crypto: marvell/cesa: Improving code readability
Date: Tue, 19 Apr 2016 17:09:20 +0200
Message-ID: <1461078560-30924-1-git-send-email-romain.perier@free-electrons.com>
Cc: Jason Cooper <jason@lakedaemon.net>, Andrew Lunn <andrew@lunn.ch>,
	Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
	Gregory Clement <gregory.clement@free-electrons.com>,
	Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
	Nadav Haklai <nadavh@marvell.com>,
	Ofer Heifetz <oferh@marvell.com>, linux-crypto@vger.kernel.org
To: Boris Brezillon <boris.brezillon@free-electrons.com>,
	Arnaud Ebalard <arno@natisbad.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from down.free-electrons.com ([37.187.137.238]:54259 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S932469AbcDSPJc (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 19 Apr 2016 11:09:32 -0400
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

When looking for available engines, the variable "engine" is
assigned to "&cesa->engines[i]" at the beginning of the for loop. Replacing
next occurences of "&cesa->engines[i]" by "engine" and in order to improve
readability.

Signed-off-by: Romain Perier <romain.perier@free-electrons.com>
---
 drivers/crypto/marvell/cesa.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/crypto/marvell/cesa.c b/drivers/crypto/marvell/cesa.c
index 80239ae..e8ef9fd 100644
--- a/drivers/crypto/marvell/cesa.c
+++ b/drivers/crypto/marvell/cesa.c
@@ -475,18 +475,18 @@ static int mv_cesa_probe(struct platform_device *pdev)
 		engine->regs = cesa->regs + CESA_ENGINE_OFF(i);
 
 		if (dram && cesa->caps->has_tdma)
-			mv_cesa_conf_mbus_windows(&cesa->engines[i], dram);
+			mv_cesa_conf_mbus_windows(engine, dram);
 
-		writel(0, cesa->engines[i].regs + CESA_SA_INT_STATUS);
+		writel(0, engine->regs + CESA_SA_INT_STATUS);
 		writel(CESA_SA_CFG_STOP_DIG_ERR,
-		       cesa->engines[i].regs + CESA_SA_CFG);
+		       engine->regs + CESA_SA_CFG);
 		writel(engine->sram_dma & CESA_SA_SRAM_MSK,
-		       cesa->engines[i].regs + CESA_SA_DESC_P0);
+		       engine->regs + CESA_SA_DESC_P0);
 
 		ret = devm_request_threaded_irq(dev, irq, NULL, mv_cesa_int,
 						IRQF_ONESHOT,
 						dev_name(&pdev->dev),
-						&cesa->engines[i]);
+						engine);
 		if (ret)
 			goto err_cleanup;
 	}
-- 
2.8.0

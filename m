From: Romain Perier <romain.perier@free-electrons.com>
Subject: [PATCH v3 01/10] crypto: marvell: Add a macro constant for the size of the crypto queue
Date: Tue, 21 Jun 2016 10:08:31 +0200
Message-ID: <1466496520-28806-2-git-send-email-romain.perier@free-electrons.com>
References: <1466496520-28806-1-git-send-email-romain.perier@free-electrons.com>
Cc: Gregory Clement <gregory.clement@free-electrons.com>,
	Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
	"David S. Miller" <davem@davemloft.net>,
	Russell King <linux@arm.linux.org.uk>,
	linux-crypto@vger.kernel.org, linux-arm-kernel@lists.infradead.org
To: Boris Brezillon <boris.brezillon@free-electrons.com>,
	Arnaud Ebalard <arno@natisbad.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from down.free-electrons.com ([37.187.137.238]:50115 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753641AbcFUIJa (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 21 Jun 2016 04:09:30 -0400
In-Reply-To: <1466496520-28806-1-git-send-email-romain.perier@free-electrons.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Adding a macro constant to be used for the size of the crypto queue,
instead of using a numeric value directly. It will be easier to
maintain in case we add more than one crypto queue of the same size.

Signed-off-by: Romain Perier <romain.perier@free-electrons.com>
Acked-by: Boris Brezillon <boris.brezillon@free-electrons.com>
---
 drivers/crypto/marvell/cesa.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/crypto/marvell/cesa.c b/drivers/crypto/marvell/cesa.c
index 056a754..fb403e1 100644
--- a/drivers/crypto/marvell/cesa.c
+++ b/drivers/crypto/marvell/cesa.c
@@ -31,6 +31,9 @@
 
 #include "cesa.h"
 
+/* Limit of the crypto queue before reaching the backlog */
+#define CESA_CRYPTO_DEFAULT_MAX_QLEN 50
+
 static int allhwsupport = !IS_ENABLED(CONFIG_CRYPTO_DEV_MV_CESA);
 module_param_named(allhwsupport, allhwsupport, int, 0444);
 MODULE_PARM_DESC(allhwsupport, "Enable support for all hardware (even it if overlaps with the mv_cesa driver)");
@@ -416,7 +419,7 @@ static int mv_cesa_probe(struct platform_device *pdev)
 		return -ENOMEM;
 
 	spin_lock_init(&cesa->lock);
-	crypto_init_queue(&cesa->queue, 50);
+	crypto_init_queue(&cesa->queue, CESA_CRYPTO_DEFAULT_MAX_QLEN);
 	res = platform_get_resource_byname(pdev, IORESOURCE_MEM, "regs");
 	cesa->regs = devm_ioremap_resource(dev, res);
 	if (IS_ERR(cesa->regs))
-- 
2.7.4

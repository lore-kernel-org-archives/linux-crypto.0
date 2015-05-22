From: Boris Brezillon <boris.brezillon@free-electrons.com>
Subject: [PATCH v3 01/16] crypto: mv_cesa: request registers memory region
Date: Fri, 22 May 2015 15:33:47 +0200
Message-ID: <1432301642-11470-2-git-send-email-boris.brezillon@free-electrons.com>
References: <1432301642-11470-1-git-send-email-boris.brezillon@free-electrons.com>
Cc: Boris Brezillon <boris.brezillon@free-electrons.com>,
	Arnaud Ebalard <arno@natisbad.org>,
	Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
	Gregory CLEMENT <gregory.clement@free-electrons.com>,
	Jason Cooper <jason@lakedaemon.net>,
	Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
	Andrew Lunn <andrew@lunn.ch>,
	Tawfik Bayouk <tawfik@marvell.com>,
	Lior Amsalem <alior@marvell.com>,
	Nadav Haklai <nadavh@marvell.com>,
	Eran Ben-Avi <benavi@marvell.com>,
	Rob Herring <robh+dt@kernel.org>,
	Pawel Moll <pawel.moll@arm.com>,
	Mark Rutland <mark.rutland@arm.com>,
	Ian Campbell <ijc+devicetree@hellion.org.uk>,
	Kumar Gala <galak@codeaurora.org>, devicetree@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from down.free-electrons.com ([37.187.137.238]:47224 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757167AbbEVNeH (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Fri, 22 May 2015 09:34:07 -0400
In-Reply-To: <1432301642-11470-1-git-send-email-boris.brezillon@free-electrons.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

The mv_cesa driver does not request the CESA registers memory region.
Since we're about to add a new CESA driver, we need to make sure only one
of these drivers probe the CESA device, and requesting the registers memory
region is a good way to achieve that.

Signed-off-by: Boris Brezillon <boris.brezillon@free-electrons.com>
---
 drivers/crypto/mv_cesa.c | 13 +++++--------
 1 file changed, 5 insertions(+), 8 deletions(-)

diff --git a/drivers/crypto/mv_cesa.c b/drivers/crypto/mv_cesa.c
index f91f15d..27b2373 100644
--- a/drivers/crypto/mv_cesa.c
+++ b/drivers/crypto/mv_cesa.c
@@ -1041,23 +1041,23 @@ static int mv_probe(struct platform_device *pdev)
 
 	spin_lock_init(&cp->lock);
 	crypto_init_queue(&cp->queue, 50);
-	cp->reg = ioremap(res->start, resource_size(res));
-	if (!cp->reg) {
-		ret = -ENOMEM;
+	cp->reg = devm_ioremap_resource(&pdev->dev, res);
+	if (IS_ERR(cp->reg)) {
+		ret = PTR_ERR(cp->reg);
 		goto err;
 	}
 
 	res = platform_get_resource_byname(pdev, IORESOURCE_MEM, "sram");
 	if (!res) {
 		ret = -ENXIO;
-		goto err_unmap_reg;
+		goto err;
 	}
 	cp->sram_size = resource_size(res);
 	cp->max_req_size = cp->sram_size - SRAM_CFG_SPACE;
 	cp->sram = ioremap(res->start, cp->sram_size);
 	if (!cp->sram) {
 		ret = -ENOMEM;
-		goto err_unmap_reg;
+		goto err;
 	}
 
 	if (pdev->dev.of_node)
@@ -1136,8 +1136,6 @@ err_thread:
 	kthread_stop(cp->queue_th);
 err_unmap_sram:
 	iounmap(cp->sram);
-err_unmap_reg:
-	iounmap(cp->reg);
 err:
 	kfree(cp);
 	cpg = NULL;
@@ -1158,7 +1156,6 @@ static int mv_remove(struct platform_device *pdev)
 	free_irq(cp->irq, cp);
 	memset(cp->sram, 0, cp->sram_size);
 	iounmap(cp->sram);
-	iounmap(cp->reg);
 
 	if (!IS_ERR(cp->clk)) {
 		clk_disable_unprepare(cp->clk);
-- 
1.9.1

From: Boris Brezillon <boris.brezillon-wi1+55ScJUtKEb57/3fJTNBPR1lH4CV8@public.gmane.org>
Subject: [PATCH v2 1/7] crypto: mv_cesa: request registers memory region
Date: Mon,  4 May 2015 14:27:00 +0200
Message-ID: <1430742426-21202-2-git-send-email-boris.brezillon@free-electrons.com>
References: <1430742426-21202-1-git-send-email-boris.brezillon@free-electrons.com>
Cc: Rob Herring <robh+dt-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Pawel Moll <pawel.moll-5wv7dgnIgG8@public.gmane.org>,
	Mark Rutland <mark.rutland-5wv7dgnIgG8@public.gmane.org>,
	Ian Campbell <ijc+devicetree-KcIKpvwj1kUDXYZnReoRVg@public.gmane.org>,
	Kumar Gala <galak-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>, devicetree-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	Tawfik Bayouk <tawfik-eYqpPyKDWXRBDgjK7y7TUQ@public.gmane.org>,
	Lior Amsalem <alior-eYqpPyKDWXRBDgjK7y7TUQ@public.gmane.org>,
	Nadav Haklai <nadavh-eYqpPyKDWXRBDgjK7y7TUQ@public.gmane.org>,
	Eran Ben-Avi <benavi-eYqpPyKDWXRBDgjK7y7TUQ@public.gmane.org>,
	Thomas Petazzoni <thomas.petazzoni-wi1+55ScJUtKEb57/3fJTNBPR1lH4CV8@public.gmane.org>,
	Gregory CLEMENT <gregory.clement-wi1+55ScJUtKEb57/3fJTNBPR1lH4CV8@public.gmane.org>,
	Jason Cooper <jason-NLaQJdtUoK4Be96aLqz0jA@public.gmane.org>,
	Sebastian Hesselbarth <sebastian.hesselbarth-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>,
	Andrew Lunn <andrew-g2DYL2Zd6BY@public.gmane.org>,
	linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	Arnaud Ebalard <arno-LkuqDEemtHBg9hUCZPvPmw@public.gmane.org>,
	Boris Brezillon <boris.brezillon-wi1+55ScJUtKEb57/3fJTNBPR1lH4CV8@public.gmane.org>
To: Herbert Xu <herbert-lOAM2aK0SrRLBo1qDEOMRrpzq4S04n8Q@public.gmane.org>,
	"David S. Miller" <davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org>,
	linux-crypto-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <devicetree-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1430742426-21202-1-git-send-email-boris.brezillon-wi1+55ScJUtKEb57/3fJTNBPR1lH4CV8@public.gmane.org>
Sender: devicetree-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-crypto.vger.kernel.org

The mv_cesa driver does not request the CESA registers memory region.
Since we're about to add a new CESA driver, we need to make sure only one
of these drivers probe the CESA device, and requesting the registers memory
region is a good way to achieve that.

Signed-off-by: Boris Brezillon <boris.brezillon-wi1+55ScJUtKEb57/3fJTNBPR1lH4CV8@public.gmane.org>
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

--
To unsubscribe from this list: send the line "unsubscribe devicetree" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

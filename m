From: "Mark A. Greer" <mgreer@animalcreek.com>
Subject: [PATCH v4 6/8] crypto: omap-sham: Convert to use pm_runtime API
Date: Mon, 19 Nov 2012 11:54:59 -0700
Message-ID: <1353351301-6453-7-git-send-email-mgreer@animalcreek.com>
References: <1353351301-6453-1-git-send-email-mgreer@animalcreek.com>
Cc: linux-crypto@vger.kernel.org, herbert@gondor.apana.org.au,
	davem@davemloft.net, dmitry.kasatkin@intel.com,
	rmk+kernel@arm.linux.org.uk, paul@pwsan.com,
	khilman@deeprootsystems.com,
	"Mark A. Greer" <mgreer@animalcreek.com>
To: linux-omap@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Return-path: <linux-omap-owner@vger.kernel.org>
In-Reply-To: <1353351301-6453-1-git-send-email-mgreer@animalcreek.com>
Sender: linux-omap-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

From: "Mark A. Greer" <mgreer@animalcreek.com>

Convert the omap-sham crypto driver to use the
pm_runtime API instead of the clk API.

CC: Kevin Hilman <khilman@deeprootsystems.com>
CC: Paul Walmsley <paul@pwsan.com>
CC: Dmitry Kasatkin <dmitry.kasatkin@intel.com>
Signed-off-by: Mark A. Greer <mgreer@animalcreek.com>
---
 drivers/crypto/omap-sham.c | 28 +++++++++++-----------------
 1 file changed, 11 insertions(+), 17 deletions(-)

diff --git a/drivers/crypto/omap-sham.c b/drivers/crypto/omap-sham.c
index f50387c..42989ed 100644
--- a/drivers/crypto/omap-sham.c
+++ b/drivers/crypto/omap-sham.c
@@ -22,12 +22,12 @@
 #include <linux/errno.h>
 #include <linux/interrupt.h>
 #include <linux/kernel.h>
-#include <linux/clk.h>
 #include <linux/irq.h>
 #include <linux/io.h>
 #include <linux/platform_device.h>
 #include <linux/scatterlist.h>
 #include <linux/dma-mapping.h>
+#include <linux/pm_runtime.h>
 #include <linux/delay.h>
 #include <linux/crypto.h>
 #include <linux/cryptohash.h>
@@ -140,7 +140,6 @@ struct omap_sham_dev {
 	struct device		*dev;
 	void __iomem		*io_base;
 	int			irq;
-	struct clk		*iclk;
 	spinlock_t		lock;
 	int			err;
 	int			dma;
@@ -237,7 +236,7 @@ static void omap_sham_copy_ready_hash(struct ahash_request *req)
 
 static int omap_sham_hw_init(struct omap_sham_dev *dd)
 {
-	clk_enable(dd->iclk);
+	pm_runtime_get_sync(dd->dev);
 
 	if (!test_bit(FLAGS_INIT, &dd->flags)) {
 		omap_sham_write_mask(dd, SHA_REG_MASK,
@@ -652,7 +651,8 @@ static void omap_sham_finish_req(struct ahash_request *req, int err)
 	/* atomic operation is not needed here */
 	dd->flags &= ~(BIT(FLAGS_BUSY) | BIT(FLAGS_FINAL) | BIT(FLAGS_CPU) |
 			BIT(FLAGS_DMA_READY) | BIT(FLAGS_OUTPUT_READY));
-	clk_disable(dd->iclk);
+
+	pm_runtime_put_sync(dd->dev);
 
 	if (req->base.complete)
 		req->base.complete(&req->base, err);
@@ -1197,14 +1197,6 @@ static int __devinit omap_sham_probe(struct platform_device *pdev)
 	if (err)
 		goto dma_err;
 
-	/* Initializing the clock */
-	dd->iclk = clk_get(dev, "ick");
-	if (IS_ERR(dd->iclk)) {
-		dev_err(dev, "clock intialization failed.\n");
-		err = PTR_ERR(dd->iclk);
-		goto clk_err;
-	}
-
 	dd->io_base = ioremap(dd->phys_base, SZ_4K);
 	if (!dd->io_base) {
 		dev_err(dev, "can't ioremap\n");
@@ -1212,11 +1204,14 @@ static int __devinit omap_sham_probe(struct platform_device *pdev)
 		goto io_err;
 	}
 
-	clk_enable(dd->iclk);
+	pm_runtime_enable(dev);
+	pm_runtime_get_sync(dev);
+
 	dev_info(dev, "hw accel on OMAP rev %u.%u\n",
 		(omap_sham_read(dd, SHA_REG_REV) & SHA_REG_REV_MAJOR) >> 4,
 		omap_sham_read(dd, SHA_REG_REV) & SHA_REG_REV_MINOR);
-	clk_disable(dd->iclk);
+
+	pm_runtime_put_sync(&pdev->dev);
 
 	spin_lock(&sham.lock);
 	list_add_tail(&dd->list, &sham.dev_list);
@@ -1234,9 +1229,8 @@ err_algs:
 	for (j = 0; j < i; j++)
 		crypto_unregister_ahash(&algs[j]);
 	iounmap(dd->io_base);
+	pm_runtime_disable(dev);
 io_err:
-	clk_put(dd->iclk);
-clk_err:
 	omap_sham_dma_cleanup(dd);
 dma_err:
 	if (dd->irq >= 0)
@@ -1265,7 +1259,7 @@ static int __devexit omap_sham_remove(struct platform_device *pdev)
 		crypto_unregister_ahash(&algs[i]);
 	tasklet_kill(&dd->done_task);
 	iounmap(dd->io_base);
-	clk_put(dd->iclk);
+	pm_runtime_disable(&pdev->dev);
 	omap_sham_dma_cleanup(dd);
 	if (dd->irq >= 0)
 		free_irq(dd->irq, dd);
-- 
1.7.12


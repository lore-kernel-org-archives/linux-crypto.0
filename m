From: Gilad Ben-Yossef <gilad@benyossef.com>
Subject: [PATCH 2/3] staging: ccree: handle limiting of DMA masks
Date: Tue, 31 Oct 2017 11:56:16 +0000
Message-ID: <1509450978-17784-3-git-send-email-gilad@benyossef.com>
References: <1509450978-17784-1-git-send-email-gilad@benyossef.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
 driverdev-devel@linuxdriverproject.org, linux-crypto@vger.kernel.org,
 Ofir Drang <ofir.drang@arm.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Return-path: <driverdev-devel-bounces@linuxdriverproject.org>
In-Reply-To: <1509450978-17784-1-git-send-email-gilad@benyossef.com>
List-Unsubscribe: <http://driverdev.linuxdriverproject.org/mailman/options/driverdev-devel>,
 <mailto:driverdev-devel-request@linuxdriverproject.org?subject=unsubscribe>
List-Archive: <http://driverdev.linuxdriverproject.org/pipermail/driverdev-devel/>
List-Post: <mailto:driverdev-devel@linuxdriverproject.org>
List-Help: <mailto:driverdev-devel-request@linuxdriverproject.org?subject=help>
List-Subscribe: <http://driverdev.linuxdriverproject.org/mailman/listinfo/driverdev-devel>,
 <mailto:driverdev-devel-request@linuxdriverproject.org?subject=subscribe>
Errors-To: driverdev-devel-bounces@linuxdriverproject.org
Sender: "devel" <driverdev-devel-bounces@linuxdriverproject.org>
List-Id: linux-crypto.vger.kernel.org

Properly handle limiting of DMA masks based on device and bus
capabilities.

Signed-off-by: Gilad Ben-Yossef <gilad@benyossef.com>
---
 drivers/staging/ccree/ssi_driver.c | 22 ++++++++++++++++++----
 1 file changed, 18 insertions(+), 4 deletions(-)

diff --git a/drivers/staging/ccree/ssi_driver.c b/drivers/staging/ccree/ssi_driver.c
index 5f03c25..6d4269f 100644
--- a/drivers/staging/ccree/ssi_driver.c
+++ b/drivers/staging/ccree/ssi_driver.c
@@ -208,6 +208,7 @@ static int init_cc_resources(struct platform_device *plat_dev)
 	struct device *dev = &plat_dev->dev;
 	struct device_node *np = dev->of_node;
 	u32 signature_val;
+	dma_addr_t dma_mask;
 	int rc = 0;
 
 	new_drvdata = devm_kzalloc(dev, sizeof(*new_drvdata), GFP_KERNEL);
@@ -260,11 +261,24 @@ static int init_cc_resources(struct platform_device *plat_dev)
 	if (rc)
 		goto post_drvdata_err;
 
-	if (!dev->dma_mask)
-		dev->dma_mask = &dev->coherent_dma_mask;
+	if (!plat_dev->dev.dma_mask)
+		plat_dev->dev.dma_mask = &plat_dev->dev.coherent_dma_mask;
+
+	dma_mask = (dma_addr_t)(DMA_BIT_MASK(DMA_BIT_MASK_LEN));
+	while (dma_mask > 0x7fffffffUL) {
+		if (dma_supported(&plat_dev->dev, dma_mask)) {
+			rc = dma_set_coherent_mask(&plat_dev->dev, dma_mask);
+				if (!rc)
+					break;
+		}
+		dma_mask >>= 1;
+	}
 
-	if (!dev->coherent_dma_mask)
-		dev->coherent_dma_mask = DMA_BIT_MASK(DMA_BIT_MASK_LEN);
+	if (rc) {
+		dev_err(dev, "Error: failed in dma_set_mask, mask=%par\n",
+			&dma_mask);
+		goto post_drvdata_err;
+	}
 
 	/* Verify correct mapping */
 	signature_val = CC_HAL_READ_REGISTER(CC_REG_OFFSET(HOST_RGF, HOST_SIGNATURE));
-- 
2.7.4

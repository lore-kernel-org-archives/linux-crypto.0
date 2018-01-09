From: Gilad Ben-Yossef <gilad@benyossef.com>
Subject: [PATCH 5/5] staging: ccree: dma mask is type u64
Date: Tue,  9 Jan 2018 10:24:33 +0000
Message-ID: <1515493478-30454-6-git-send-email-gilad@benyossef.com>
References: <1515493478-30454-1-git-send-email-gilad@benyossef.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
 driverdev-devel@linuxdriverproject.org, linux-crypto@vger.kernel.org,
 Ofir Drang <ofir.drang@arm.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Return-path: <driverdev-devel-bounces@linuxdriverproject.org>
In-Reply-To: <1515493478-30454-1-git-send-email-gilad@benyossef.com>
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

The dma mask var was defined as dma_addr_t but should be
u64. This showed as a sparse warning when building for 32 bit.
Fix it by changing type to u64 and drop the cast.

Signed-off-by: Gilad Ben-Yossef <gilad@benyossef.com>
---
 drivers/staging/ccree/cc_driver.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/ccree/cc_driver.c b/drivers/staging/ccree/cc_driver.c
index b49bc25..6682d9d 100644
--- a/drivers/staging/ccree/cc_driver.c
+++ b/drivers/staging/ccree/cc_driver.c
@@ -156,7 +156,7 @@ static int init_cc_resources(struct platform_device *plat_dev)
 	struct device *dev = &plat_dev->dev;
 	struct device_node *np = dev->of_node;
 	u32 signature_val;
-	dma_addr_t dma_mask;
+	u64 dma_mask;
 	int rc = 0;
 
 	new_drvdata = devm_kzalloc(dev, sizeof(*new_drvdata), GFP_KERNEL);
@@ -205,7 +205,7 @@ static int init_cc_resources(struct platform_device *plat_dev)
 	if (!plat_dev->dev.dma_mask)
 		plat_dev->dev.dma_mask = &plat_dev->dev.coherent_dma_mask;
 
-	dma_mask = (dma_addr_t)(DMA_BIT_MASK(DMA_BIT_MASK_LEN));
+	dma_mask = DMA_BIT_MASK(DMA_BIT_MASK_LEN);
 	while (dma_mask > 0x7fffffffUL) {
 		if (dma_supported(&plat_dev->dev, dma_mask)) {
 			rc = dma_set_coherent_mask(&plat_dev->dev, dma_mask);
-- 
2.7.4

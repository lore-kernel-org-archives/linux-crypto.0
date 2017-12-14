From: Gilad Ben-Yossef <gilad@benyossef.com>
Subject: [PATCH 05/10] staging: ccree: remove CC_IRQ_DELAY dead code
Date: Thu, 14 Dec 2017 14:02:42 +0000
Message-ID: <1513260170-26346-6-git-send-email-gilad@benyossef.com>
References: <1513260170-26346-1-git-send-email-gilad@benyossef.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: linux-crypto@vger.kernel.org, devel@driverdev.osuosl.org,
 driverdev-devel@linuxdriverproject.org, linux-kernel@vger.kernel.org,
 Ofir Drang <ofir.drang@arm.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Return-path: <driverdev-devel-bounces@linuxdriverproject.org>
In-Reply-To: <1513260170-26346-1-git-send-email-gilad@benyossef.com>
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

Remove dead code from older version which is not supported in current
hardware.

Signed-off-by: Gilad Ben-Yossef <gilad@benyossef.com>
---
 drivers/staging/ccree/ssi_config.h |  1 -
 drivers/staging/ccree/ssi_driver.c | 11 -----------
 2 files changed, 12 deletions(-)

diff --git a/drivers/staging/ccree/ssi_config.h b/drivers/staging/ccree/ssi_config.h
index 15725cc..e809103 100644
--- a/drivers/staging/ccree/ssi_config.h
+++ b/drivers/staging/ccree/ssi_config.h
@@ -28,7 +28,6 @@
 //#define CC_DUMP_DESCS
 // #define CC_DUMP_BYTES
 // #define CC_DEBUG
-//#define CC_IRQ_DELAY 100000
 /* was 32 bit, but for juno's sake it was enlarged to 48 bit */
 #define DMA_BIT_MASK_LEN	48
 
diff --git a/drivers/staging/ccree/ssi_driver.c b/drivers/staging/ccree/ssi_driver.c
index 14705dc..6158794 100644
--- a/drivers/staging/ccree/ssi_driver.c
+++ b/drivers/staging/ccree/ssi_driver.c
@@ -171,17 +171,6 @@ int init_cc_regs(struct cc_drvdata *drvdata, bool is_probe)
 			       CC_GPR0_IRQ_MASK));
 	cc_iowrite(drvdata, CC_REG(HOST_IMR), val);
 
-#ifdef CC_HOST_IRQ_TIMER_INIT_VAL_REG_OFFSET
-#ifdef CC_IRQ_DELAY
-	/* Set CC IRQ delay */
-	cc_iowrite(drvdata, CC_REG(HOST_IRQ_TIMER_INIT_VAL), CC_IRQ_DELAY);
-#endif
-	if (cc_ioread(drvdata, CC_REG(HOST_IRQ_TIMER_INIT_VAL)) > 0) {
-		dev_dbg(dev, "irq_delay=%d CC cycles\n",
-			cc_ioread(drvdata, CC_REG(HOST_IRQ_TIMER_INIT_VAL)));
-	}
-#endif
-
 	cache_params = (drvdata->coherent ? CC_COHERENT_CACHE_PARAMS : 0x0);
 
 	val = cc_ioread(drvdata, CC_REG(AXIM_CACHE_PARAMS));
-- 
2.7.4

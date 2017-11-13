From: Gilad Ben-Yossef <gilad@benyossef.com>
Subject: [PATCH 22/24] staging: ccree: replace msleep with a completion
Date: Mon, 13 Nov 2017 14:45:50 +0000
Message-ID: <1510584358-29473-23-git-send-email-gilad@benyossef.com>
References: <1510584358-29473-1-git-send-email-gilad@benyossef.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
 driverdev-devel@linuxdriverproject.org, linux-crypto@vger.kernel.org,
 Ofir Drang <ofir.drang@arm.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Return-path: <driverdev-devel-bounces@linuxdriverproject.org>
In-Reply-To: <1510584358-29473-1-git-send-email-gilad@benyossef.com>
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

When the driver would try to queue commands to the HW FIFO but ran out of
slots it would use msleep as a delay until the FIFO would clear. This is
messy and not accurate.

Replace the msleep with a proper completion on the event of command
completion which should indicate at least one slot is free.

Signed-off-by: Gilad Ben-Yossef <gilad@benyossef.com>
---
 drivers/staging/ccree/ssi_driver.c      | 2 ++
 drivers/staging/ccree/ssi_driver.h      | 1 +
 drivers/staging/ccree/ssi_request_mgr.c | 7 +++++--
 3 files changed, 8 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/ccree/ssi_driver.c b/drivers/staging/ccree/ssi_driver.c
index b17b811..3cb2296 100644
--- a/drivers/staging/ccree/ssi_driver.c
+++ b/drivers/staging/ccree/ssi_driver.c
@@ -251,6 +251,8 @@ static int init_cc_resources(struct platform_device *plat_dev)
 	}
 	dev_dbg(dev, "Registered to IRQ: %d\n", new_drvdata->irq);
 
+	init_completion(&new_drvdata->hw_queue_avail);
+
 	if (!plat_dev->dev.dma_mask)
 		plat_dev->dev.dma_mask = &plat_dev->dev.coherent_dma_mask;
 
diff --git a/drivers/staging/ccree/ssi_driver.h b/drivers/staging/ccree/ssi_driver.h
index ff9f5aa..f92867b 100644
--- a/drivers/staging/ccree/ssi_driver.h
+++ b/drivers/staging/ccree/ssi_driver.h
@@ -125,6 +125,7 @@ struct ssi_drvdata {
 	int irq;
 	u32 irq_mask;
 	u32 fw_ver;
+	struct completion hw_queue_avail; /* wait for HW queue availability */
 	struct platform_device *plat_dev;
 	ssi_sram_addr_t mlli_sram_addr;
 	void *buff_mgr_handle;
diff --git a/drivers/staging/ccree/ssi_request_mgr.c b/drivers/staging/ccree/ssi_request_mgr.c
index a2a82ef..0882efd 100644
--- a/drivers/staging/ccree/ssi_request_mgr.c
+++ b/drivers/staging/ccree/ssi_request_mgr.c
@@ -312,8 +312,9 @@ int send_request(
 			return rc;
 		}
 
-		/* HW queue is full - short sleep */
-		msleep(1);
+		/* HW queue is full - wait for it to clear up */
+		wait_for_completion_interruptible(&drvdata->hw_queue_avail);
+		reinit_completion(&drvdata->hw_queue_avail);
 	} while (1);
 
 	/* Additional completion descriptor is needed incase caller did not
@@ -452,6 +453,8 @@ void complete_request(struct ssi_drvdata *drvdata)
 {
 	struct ssi_request_mgr_handle *request_mgr_handle =
 						drvdata->request_mgr_handle;
+
+	complete(&drvdata->hw_queue_avail);
 #ifdef COMP_IN_WQ
 	queue_delayed_work(request_mgr_handle->workq,
 			   &request_mgr_handle->compwork, 0);
-- 
2.7.4

From: Gilad Ben-Yossef <gilad@benyossef.com>
Subject: [PATCH 21/24] staging: ccree: remove unused field
Date: Mon, 13 Nov 2017 14:45:49 +0000
Message-ID: <1510584358-29473-22-git-send-email-gilad@benyossef.com>
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

Field monitor_null_cycles of struct drvdata was not being used.
Remove it.

Signed-off-by: Gilad Ben-Yossef <gilad@benyossef.com>
---
 drivers/staging/ccree/ssi_driver.h | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/drivers/staging/ccree/ssi_driver.h b/drivers/staging/ccree/ssi_driver.h
index 7c266ff..ff9f5aa 100644
--- a/drivers/staging/ccree/ssi_driver.h
+++ b/drivers/staging/ccree/ssi_driver.h
@@ -125,10 +125,6 @@ struct ssi_drvdata {
 	int irq;
 	u32 irq_mask;
 	u32 fw_ver;
-	/* Calibration time of start/stop
-	 * monitor descriptors
-	 */
-	u32 monitor_null_cycles;
 	struct platform_device *plat_dev;
 	ssi_sram_addr_t mlli_sram_addr;
 	void *buff_mgr_handle;
-- 
2.7.4

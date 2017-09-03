From: Gilad Ben-Yossef <gilad@benyossef.com>
Subject: [PATCH v2 5/8] staging: ccree: remove unused completion
Date: Sun,  3 Sep 2017 17:57:40 +0300
Message-ID: <1504450664-28252-6-git-send-email-gilad@benyossef.com>
References: <1504450664-28252-1-git-send-email-gilad@benyossef.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: Ofir Drang <ofir.drang@arm.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
 linux-crypto@vger.kernel.org, driverdev-devel@linuxdriverproject.org,
 devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Return-path: <driverdev-devel-bounces@linuxdriverproject.org>
In-Reply-To: <1504450664-28252-1-git-send-email-gilad@benyossef.com>
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

icache_setup_completion is no longer used. Remove it.

Signed-off-by: Gilad Ben-Yossef <gilad@benyossef.com>
---
 drivers/staging/ccree/ssi_driver.c | 2 --
 drivers/staging/ccree/ssi_driver.h | 1 -
 2 files changed, 3 deletions(-)

diff --git a/drivers/staging/ccree/ssi_driver.c b/drivers/staging/ccree/ssi_driver.c
index dc22f13..8f1d7af 100644
--- a/drivers/staging/ccree/ssi_driver.c
+++ b/drivers/staging/ccree/ssi_driver.c
@@ -279,8 +279,6 @@ static int init_cc_resources(struct platform_device *plat_dev)
 	}
 	SSI_LOG_DEBUG("Registered to IRQ: %d\n", new_drvdata->irq);
 
-	init_completion(&new_drvdata->icache_setup_completion);
-
 	rc = cc_clk_on(new_drvdata);
 	if (rc)
 		goto post_drvdata_err;
diff --git a/drivers/staging/ccree/ssi_driver.h b/drivers/staging/ccree/ssi_driver.h
index 88ef370..9b6476d 100644
--- a/drivers/staging/ccree/ssi_driver.h
+++ b/drivers/staging/ccree/ssi_driver.h
@@ -138,7 +138,6 @@ struct ssi_drvdata {
 	u32 monitor_null_cycles;
 	struct platform_device *plat_dev;
 	ssi_sram_addr_t mlli_sram_addr;
-	struct completion icache_setup_completion;
 	void *buff_mgr_handle;
 	void *hash_handle;
 	void *aead_handle;
-- 
2.1.4

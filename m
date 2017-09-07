From: Gilad Ben-Yossef <gilad@benyossef.com>
Subject: [PATCH v3 5/8] staging: ccree: remove unused completion
Date: Thu,  7 Sep 2017 12:00:13 +0300
Message-ID: <1504774817-11984-6-git-send-email-gilad@benyossef.com>
References: <1504774817-11984-1-git-send-email-gilad@benyossef.com>
Cc: Ofir Drang <ofir.drang@arm.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-crypto@vger.kernel.org,
        driverdev-devel@linuxdriverproject.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1504774817-11984-1-git-send-email-gilad@benyossef.com>
Sender: linux-kernel-owner@vger.kernel.org
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

From: Gilad Ben-Yossef <gilad@benyossef.com>
Subject: [PATCH 22/24] staging: ccree: fix sram mgr naming convention
Date: Tue, 12 Dec 2017 14:53:08 +0000
Message-ID: <1513090395-7938-23-git-send-email-gilad@benyossef.com>
References: <1513090395-7938-1-git-send-email-gilad@benyossef.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
 driverdev-devel@linuxdriverproject.org, linux-crypto@vger.kernel.org,
 Ofir Drang <ofir.drang@arm.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Return-path: <driverdev-devel-bounces@linuxdriverproject.org>
In-Reply-To: <1513090395-7938-1-git-send-email-gilad@benyossef.com>
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

The SRAM manager files were using a naming convention which was
inconsistent (ssi vs. cc) and often too long.

Make the code more readable by switching to a simpler, consistent naming
convention.

Signed-off-by: Gilad Ben-Yossef <gilad@benyossef.com>
---
 drivers/staging/ccree/ssi_driver.c   |  8 ++++----
 drivers/staging/ccree/ssi_sram_mgr.c | 18 +++++++++---------
 drivers/staging/ccree/ssi_sram_mgr.h |  4 ++--
 3 files changed, 15 insertions(+), 15 deletions(-)

diff --git a/drivers/staging/ccree/ssi_driver.c b/drivers/staging/ccree/ssi_driver.c
index 3f02ceb..6e7a396 100644
--- a/drivers/staging/ccree/ssi_driver.c
+++ b/drivers/staging/ccree/ssi_driver.c
@@ -312,9 +312,9 @@ static int init_cc_resources(struct platform_device *plat_dev)
 		dev_err(dev, "CC_FIPS_INIT failed 0x%x\n", rc);
 		goto post_sysfs_err;
 	}
-	rc = ssi_sram_mgr_init(new_drvdata);
+	rc = cc_sram_mgr_init(new_drvdata);
 	if (rc) {
-		dev_err(dev, "ssi_sram_mgr_init failed\n");
+		dev_err(dev, "cc_sram_mgr_init failed\n");
 		goto post_fips_init_err;
 	}
 
@@ -391,7 +391,7 @@ static int init_cc_resources(struct platform_device *plat_dev)
 post_req_mgr_err:
 	cc_req_mgr_fini(new_drvdata);
 post_sram_mgr_err:
-	ssi_sram_mgr_fini(new_drvdata);
+	cc_sram_mgr_fini(new_drvdata);
 post_fips_init_err:
 	ssi_fips_fini(new_drvdata);
 post_sysfs_err:
@@ -423,7 +423,7 @@ static void cleanup_cc_resources(struct platform_device *plat_dev)
 	cc_pm_fini(drvdata);
 	cc_buffer_mgr_fini(drvdata);
 	cc_req_mgr_fini(drvdata);
-	ssi_sram_mgr_fini(drvdata);
+	cc_sram_mgr_fini(drvdata);
 	ssi_fips_fini(drvdata);
 #ifdef ENABLE_CC_SYSFS
 	ssi_sysfs_fini();
diff --git a/drivers/staging/ccree/ssi_sram_mgr.c b/drivers/staging/ccree/ssi_sram_mgr.c
index 5d83af5..b664e9b 100644
--- a/drivers/staging/ccree/ssi_sram_mgr.c
+++ b/drivers/staging/ccree/ssi_sram_mgr.c
@@ -18,37 +18,37 @@
 #include "ssi_sram_mgr.h"
 
 /**
- * struct ssi_sram_mgr_ctx -Internal RAM context manager
+ * struct cc_sram_ctx -Internal RAM context manager
  * @sram_free_offset:   the offset to the non-allocated area
  */
-struct ssi_sram_mgr_ctx {
+struct cc_sram_ctx {
 	cc_sram_addr_t sram_free_offset;
 };
 
 /**
- * ssi_sram_mgr_fini() - Cleanup SRAM pool.
+ * cc_sram_mgr_fini() - Cleanup SRAM pool.
  *
  * @drvdata: Associated device driver context
  */
-void ssi_sram_mgr_fini(struct cc_drvdata *drvdata)
+void cc_sram_mgr_fini(struct cc_drvdata *drvdata)
 {
-	struct ssi_sram_mgr_ctx *smgr_ctx = drvdata->sram_mgr_handle;
+	struct cc_sram_ctx *smgr_ctx = drvdata->sram_mgr_handle;
 
 	/* Free "this" context */
 	if (smgr_ctx) {
-		memset(smgr_ctx, 0, sizeof(struct ssi_sram_mgr_ctx));
+		memset(smgr_ctx, 0, sizeof(struct cc_sram_ctx));
 		kfree(smgr_ctx);
 	}
 }
 
 /**
- * ssi_sram_mgr_init() - Initializes SRAM pool.
+ * cc_sram_mgr_init() - Initializes SRAM pool.
  *      The pool starts right at the beginning of SRAM.
  *      Returns zero for success, negative value otherwise.
  *
  * @drvdata: Associated device driver context
  */
-int ssi_sram_mgr_init(struct cc_drvdata *drvdata)
+int cc_sram_mgr_init(struct cc_drvdata *drvdata)
 {
 	/* Allocate "this" context */
 	drvdata->sram_mgr_handle = kzalloc(sizeof(*drvdata->sram_mgr_handle),
@@ -71,7 +71,7 @@ int ssi_sram_mgr_init(struct cc_drvdata *drvdata)
  */
 cc_sram_addr_t cc_sram_alloc(struct cc_drvdata *drvdata, u32 size)
 {
-	struct ssi_sram_mgr_ctx *smgr_ctx = drvdata->sram_mgr_handle;
+	struct cc_sram_ctx *smgr_ctx = drvdata->sram_mgr_handle;
 	struct device *dev = drvdata_to_dev(drvdata);
 	cc_sram_addr_t p;
 
diff --git a/drivers/staging/ccree/ssi_sram_mgr.h b/drivers/staging/ccree/ssi_sram_mgr.h
index 52f5288..181968a 100644
--- a/drivers/staging/ccree/ssi_sram_mgr.h
+++ b/drivers/staging/ccree/ssi_sram_mgr.h
@@ -40,14 +40,14 @@ typedef u64 cc_sram_addr_t;
  *
  * \return int Zero for success, negative value otherwise.
  */
-int ssi_sram_mgr_init(struct cc_drvdata *drvdata);
+int cc_sram_mgr_init(struct cc_drvdata *drvdata);
 
 /*!
  * Uninits SRAM pool.
  *
  * \param drvdata
  */
-void ssi_sram_mgr_fini(struct cc_drvdata *drvdata);
+void cc_sram_mgr_fini(struct cc_drvdata *drvdata);
 
 /*!
  * Allocated buffer from SRAM pool.
-- 
2.7.4

From: Gilad Ben-Yossef <gilad@benyossef.com>
Subject: [PATCH 24/24] staging: ccree: fix FIPS mgr naming convention
Date: Tue, 12 Dec 2017 14:53:10 +0000
Message-ID: <1513090395-7938-25-git-send-email-gilad@benyossef.com>
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

The FIPS manager files were using a naming convention which was
inconsistent (ssi vs. cc) and often too long.

Make the code more readable by switching to a simpler, consistent naming
convention.

Signed-off-by: Gilad Ben-Yossef <gilad@benyossef.com>
---
 drivers/staging/ccree/ssi_driver.c | 6 +++---
 drivers/staging/ccree/ssi_fips.c   | 4 ++--
 drivers/staging/ccree/ssi_fips.h   | 8 ++++----
 3 files changed, 9 insertions(+), 9 deletions(-)

diff --git a/drivers/staging/ccree/ssi_driver.c b/drivers/staging/ccree/ssi_driver.c
index 6e7a396..28cfbb4 100644
--- a/drivers/staging/ccree/ssi_driver.c
+++ b/drivers/staging/ccree/ssi_driver.c
@@ -307,7 +307,7 @@ static int init_cc_resources(struct platform_device *plat_dev)
 	}
 #endif
 
-	rc = ssi_fips_init(new_drvdata);
+	rc = cc_fips_init(new_drvdata);
 	if (rc) {
 		dev_err(dev, "CC_FIPS_INIT failed 0x%x\n", rc);
 		goto post_sysfs_err;
@@ -393,7 +393,7 @@ static int init_cc_resources(struct platform_device *plat_dev)
 post_sram_mgr_err:
 	cc_sram_mgr_fini(new_drvdata);
 post_fips_init_err:
-	ssi_fips_fini(new_drvdata);
+	cc_fips_fini(new_drvdata);
 post_sysfs_err:
 #ifdef ENABLE_CC_SYSFS
 	ssi_sysfs_fini();
@@ -424,7 +424,7 @@ static void cleanup_cc_resources(struct platform_device *plat_dev)
 	cc_buffer_mgr_fini(drvdata);
 	cc_req_mgr_fini(drvdata);
 	cc_sram_mgr_fini(drvdata);
-	ssi_fips_fini(drvdata);
+	cc_fips_fini(drvdata);
 #ifdef ENABLE_CC_SYSFS
 	ssi_sysfs_fini();
 #endif
diff --git a/drivers/staging/ccree/ssi_fips.c b/drivers/staging/ccree/ssi_fips.c
index 036215f..a1d7782 100644
--- a/drivers/staging/ccree/ssi_fips.c
+++ b/drivers/staging/ccree/ssi_fips.c
@@ -51,7 +51,7 @@ void cc_set_ree_fips_status(struct cc_drvdata *drvdata, bool status)
 	cc_iowrite(drvdata, CC_REG(HOST_GPR0), val);
 }
 
-void ssi_fips_fini(struct cc_drvdata *drvdata)
+void cc_fips_fini(struct cc_drvdata *drvdata)
 {
 	struct cc_fips_handle *fips_h = drvdata->fips_handle;
 
@@ -105,7 +105,7 @@ static void fips_dsr(unsigned long devarg)
 }
 
 /* The function called once at driver entry point .*/
-int ssi_fips_init(struct cc_drvdata *p_drvdata)
+int cc_fips_init(struct cc_drvdata *p_drvdata)
 {
 	struct cc_fips_handle *fips_h;
 	struct device *dev = drvdata_to_dev(p_drvdata);
diff --git a/drivers/staging/ccree/ssi_fips.h b/drivers/staging/ccree/ssi_fips.h
index 5eed9f6..8321dde 100644
--- a/drivers/staging/ccree/ssi_fips.h
+++ b/drivers/staging/ccree/ssi_fips.h
@@ -27,19 +27,19 @@ enum cc_fips_status {
 	CC_FIPS_SYNC_STATUS_RESERVE32B = S32_MAX
 };
 
-int ssi_fips_init(struct cc_drvdata *p_drvdata);
-void ssi_fips_fini(struct cc_drvdata *drvdata);
+int cc_fips_init(struct cc_drvdata *p_drvdata);
+void cc_fips_fini(struct cc_drvdata *drvdata);
 void fips_handler(struct cc_drvdata *drvdata);
 void cc_set_ree_fips_status(struct cc_drvdata *drvdata, bool ok);
 
 #else  /* CONFIG_CRYPTO_FIPS */
 
-static inline int ssi_fips_init(struct cc_drvdata *p_drvdata)
+static inline int cc_fips_init(struct cc_drvdata *p_drvdata)
 {
 	return 0;
 }
 
-static inline void ssi_fips_fini(struct cc_drvdata *drvdata) {}
+static inline void cc_fips_fini(struct cc_drvdata *drvdata) {}
 static inline void cc_set_ree_fips_status(struct cc_drvdata *drvdata,
 					  bool ok) {}
 static inline void fips_handler(struct cc_drvdata *drvdata) {}
-- 
2.7.4

From: Derek Robson <robsonde@gmail.com>
Subject: [PATCH 11/27] Drivers: ccree: ssi_fips_local.c - align block comments
Date: Wed, 24 May 2017 16:43:39 +1200
Message-ID: <20170524044339.30376-1-robsonde@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: devel@driverdev.osuosl.org, Derek Robson <robsonde@gmail.com>,
 driverdev-devel@linuxdriverproject.org, linux-crypto@vger.kernel.org,
 linux-kernel@vger.kernel.org
To: gilad@benyossef.com,
	gregkh@linuxfoundation.org
Return-path: <driverdev-devel-bounces@linuxdriverproject.org>
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

Fixed block comment alignment, Style fix only
Found using checkpatch

Signed-off-by: Derek Robson <robsonde@gmail.com>
---
 drivers/staging/ccree/ssi_fips_local.c | 21 ++++++++++++---------
 1 file changed, 12 insertions(+), 9 deletions(-)

diff --git a/drivers/staging/ccree/ssi_fips_local.c b/drivers/staging/ccree/ssi_fips_local.c
index 316507d88b4e..8076c771f750 100644
--- a/drivers/staging/ccree/ssi_fips_local.c
+++ b/drivers/staging/ccree/ssi_fips_local.c
@@ -15,8 +15,8 @@
  */
 
 /**************************************************************
-This file defines the driver FIPS internal function, used by the driver itself.
-***************************************************************/
+ * This file defines the driver FIPS internal function, used by the driver itself.
+ ***************************************************************/
 #include <linux/kernel.h>
 #include <linux/module.h>
 #include <linux/platform_device.h>
@@ -80,10 +80,10 @@ static enum ssi_fips_error ssi_fips_get_tee_error(struct ssi_drvdata *drvdata)
 
 
 /*
- This function should push the FIPS REE library status towards the TEE library.
- By writing the error state to HOST_GPR0 register. The function is called from  						.
- driver entry point so no need to protect by mutex.
-*/
+ * This function should push the FIPS REE library status towards the TEE library.
+ * By writing the error state to HOST_GPR0 register. The function is called from
+ * driver entry point so no need to protect by mutex.
+ */
 static void ssi_fips_update_tee_upon_ree_status(struct ssi_drvdata *drvdata, ssi_fips_error_t err)
 {
 	void __iomem *cc_base = drvdata->cc_base;
@@ -232,7 +232,8 @@ ssi_fips_error_t cc_fips_run_power_up_tests(struct ssi_drvdata *drvdata)
 
 
 /* The function checks if FIPS supported and FIPS error exists.*
-*  It should be used in every driver API.*/
+ * It should be used in every driver API.
+ */
 int ssi_fips_check_fips_error(void)
 {
 	ssi_fips_state_t fips_state;
@@ -250,14 +251,16 @@ int ssi_fips_check_fips_error(void)
 
 
 /* The function sets the REE FIPS state.*
-*  It should be used while driver is being loaded .*/
+ * It should be used while driver is being loaded.
+ */
 int ssi_fips_set_state(ssi_fips_state_t state)
 {
 	return ssi_fips_ext_set_state(state);
 }
 
 /* The function sets the REE FIPS error, and pushes the error to TEE library. *
-*  It should be used when any of the KAT tests fails .*/
+ * It should be used when any of the KAT tests fails.
+ */
 int ssi_fips_set_error(struct ssi_drvdata *p_drvdata, ssi_fips_error_t err)
 {
 	int rc = 0;
-- 
2.12.2

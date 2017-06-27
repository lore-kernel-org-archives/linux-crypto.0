From: Gilad Ben-Yossef <gilad@benyossef.com>
Subject: [PATCH 11/14] staging: ccree: remove custom type ssi_fips_state_t
Date: Tue, 27 Jun 2017 10:27:23 +0300
Message-ID: <1498548449-10803-12-git-send-email-gilad@benyossef.com>
References: <1498548449-10803-1-git-send-email-gilad@benyossef.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: Ofir Drang <ofir.drang@arm.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
 linux-crypto@vger.kernel.org, driverdev-devel@linuxdriverproject.org,
 devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Return-path: <driverdev-devel-bounces@linuxdriverproject.org>
In-Reply-To: <1498548449-10803-1-git-send-email-gilad@benyossef.com>
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

Replace custom type ssi_fips_state_t with underlying enum.

Signed-off-by: Gilad Ben-Yossef <gilad@benyossef.com>
---
 drivers/staging/ccree/ssi_fips.c       | 4 ++--
 drivers/staging/ccree/ssi_fips.h       | 6 +++---
 drivers/staging/ccree/ssi_fips_ext.c   | 6 +++---
 drivers/staging/ccree/ssi_fips_local.c | 8 ++++----
 4 files changed, 12 insertions(+), 12 deletions(-)

diff --git a/drivers/staging/ccree/ssi_fips.c b/drivers/staging/ccree/ssi_fips.c
index 948ea49..d34d9ef 100644
--- a/drivers/staging/ccree/ssi_fips.c
+++ b/drivers/staging/ccree/ssi_fips.c
@@ -23,14 +23,14 @@
 #include "ssi_fips.h"
 
 
-extern int ssi_fips_ext_get_state(ssi_fips_state_t *p_state);
+extern int ssi_fips_ext_get_state(enum cc_fips_state_t *p_state);
 extern int ssi_fips_ext_get_error(enum cc_fips_error *p_err);
 
 /*
  * This function returns the REE FIPS state.
  * It should be called by kernel module.
  */
-int ssi_fips_get_state(ssi_fips_state_t *p_state)
+int ssi_fips_get_state(enum cc_fips_state_t *p_state)
 {
 	int rc = 0;
 
diff --git a/drivers/staging/ccree/ssi_fips.h b/drivers/staging/ccree/ssi_fips.h
index d1cd489..ce5fa45 100644
--- a/drivers/staging/ccree/ssi_fips.h
+++ b/drivers/staging/ccree/ssi_fips.h
@@ -22,12 +22,12 @@
  * @brief This file contains FIPS related defintions and APIs.
  */
 
-typedef enum ssi_fips_state {
+enum cc_fips_state {
 	CC_FIPS_STATE_NOT_SUPPORTED = 0,
 	CC_FIPS_STATE_SUPPORTED,
 	CC_FIPS_STATE_ERROR,
 	CC_FIPS_STATE_RESERVE32B = S32_MAX
-} ssi_fips_state_t;
+};
 
 
 enum cc_fips_error {
@@ -57,7 +57,7 @@ enum cc_fips_error {
 
 
 
-int ssi_fips_get_state(ssi_fips_state_t *p_state);
+int ssi_fips_get_state(enum cc_fips_state *p_state);
 int ssi_fips_get_error(enum cc_fips_error *p_err);
 
 #endif  /*__SSI_FIPS_H__*/
diff --git a/drivers/staging/ccree/ssi_fips_ext.c b/drivers/staging/ccree/ssi_fips_ext.c
index aab2805..295aeb6 100644
--- a/drivers/staging/ccree/ssi_fips_ext.c
+++ b/drivers/staging/ccree/ssi_fips_ext.c
@@ -28,7 +28,7 @@ static bool tee_error;
 module_param(tee_error, bool, 0644);
 MODULE_PARM_DESC(tee_error, "Simulate TEE library failure flag: 0 - no error (default), 1 - TEE error occured ");
 
-static ssi_fips_state_t fips_state = CC_FIPS_STATE_NOT_SUPPORTED;
+static enum cc_fips_state_t fips_state = CC_FIPS_STATE_NOT_SUPPORTED;
 static enum cc_fips_error fips_error = CC_REE_FIPS_ERROR_OK;
 
 /*
@@ -37,7 +37,7 @@ static enum cc_fips_error fips_error = CC_REE_FIPS_ERROR_OK;
  * the state value is stored.
  * The reference code uses global variable.
  */
-int ssi_fips_ext_get_state(ssi_fips_state_t *p_state)
+int ssi_fips_ext_get_state(enum cc_fips_state_t *p_state)
 {
 	int rc = 0;
 
@@ -73,7 +73,7 @@ int ssi_fips_ext_get_error(enum cc_fips_error *p_err)
  * the state value is stored.
  * The reference code uses global variable.
  */
-int ssi_fips_ext_set_state(ssi_fips_state_t state)
+int ssi_fips_ext_set_state(enum cc_fips_state_t state)
 {
 	fips_state = state;
 	return 0;
diff --git a/drivers/staging/ccree/ssi_fips_local.c b/drivers/staging/ccree/ssi_fips_local.c
index dfc871d..9b84876 100644
--- a/drivers/staging/ccree/ssi_fips_local.c
+++ b/drivers/staging/ccree/ssi_fips_local.c
@@ -50,9 +50,9 @@ struct ssi_fips_handle {
 };
 
 
-extern int ssi_fips_get_state(ssi_fips_state_t *p_state);
+extern int ssi_fips_get_state(enum cc_fips_state_t *p_state);
 extern int ssi_fips_get_error(enum cc_fips_error *p_err);
-extern int ssi_fips_ext_set_state(ssi_fips_state_t state);
+extern int ssi_fips_ext_set_state(enum cc_fips_state_t state);
 extern int ssi_fips_ext_set_error(enum cc_fips_error err);
 
 /* FIPS power-up tests */
@@ -234,7 +234,7 @@ enum cc_fips_error cc_fips_run_power_up_tests(struct ssi_drvdata *drvdata)
  */
 int ssi_fips_check_fips_error(void)
 {
-	ssi_fips_state_t fips_state;
+	enum cc_fips_state_t fips_state;
 
 	if (ssi_fips_get_state(&fips_state) != 0) {
 		FIPS_LOG("ssi_fips_get_state FAILED, returning.. \n");
@@ -251,7 +251,7 @@ int ssi_fips_check_fips_error(void)
 /* The function sets the REE FIPS state.*
  * It should be used while driver is being loaded.
  */
-int ssi_fips_set_state(ssi_fips_state_t state)
+int ssi_fips_set_state(enum cc_fips_state_t state)
 {
 	return ssi_fips_ext_set_state(state);
 }
-- 
2.1.4

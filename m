From: Derek Robson <robsonde@gmail.com>
Subject: [PATCH 13/27] Drivers: ccree: ssi_fips_ext.c - align block comments
Date: Wed, 24 May 2017 16:44:30 +1200
Message-ID: <20170524044430.30469-1-robsonde@gmail.com>
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
 drivers/staging/ccree/ssi_fips_ext.c | 46 ++++++++++++++++++------------------
 1 file changed, 23 insertions(+), 23 deletions(-)

diff --git a/drivers/staging/ccree/ssi_fips_ext.c b/drivers/staging/ccree/ssi_fips_ext.c
index 291a880f567c..0f53a4bc43de 100644
--- a/drivers/staging/ccree/ssi_fips_ext.c
+++ b/drivers/staging/ccree/ssi_fips_ext.c
@@ -15,9 +15,9 @@
  */
 
 /**************************************************************
-This file defines the driver FIPS functions that should be
-implemented by the driver user. Current implementation is sample code only.
-***************************************************************/
+ * This file defines the driver FIPS functions that should be
+ * implemented by the driver user. Current implementation is sample code only.
+ ***************************************************************/
 
 #include <linux/module.h>
 #include "ssi_fips_local.h"
@@ -32,11 +32,11 @@ static ssi_fips_state_t fips_state = CC_FIPS_STATE_NOT_SUPPORTED;
 static ssi_fips_error_t fips_error = CC_REE_FIPS_ERROR_OK;
 
 /*
-This function returns the FIPS REE state.
-The function should be implemented by the driver user, depends on where                          .
-the state value is stored.
-The reference code uses global variable.
-*/
+ * This function returns the FIPS REE state.
+ * The function should be implemented by the driver user, depends on where
+ * the state value is stored.
+ * The reference code uses global variable.
+ */
 int ssi_fips_ext_get_state(ssi_fips_state_t *p_state)
 {
         int rc = 0;
@@ -51,11 +51,11 @@ int ssi_fips_ext_get_state(ssi_fips_state_t *p_state)
 }
 
 /*
-This function returns the FIPS REE error.
-The function should be implemented by the driver user, depends on where                          .
-the error value is stored.
-The reference code uses global variable.
-*/
+ * This function returns the FIPS REE error.
+ * The function should be implemented by the driver user, depends on where
+ * the error value is stored.
+ * The reference code uses global variable.
+ */
 int ssi_fips_ext_get_error(ssi_fips_error_t *p_err)
 {
         int rc = 0;
@@ -70,11 +70,11 @@ int ssi_fips_ext_get_error(ssi_fips_error_t *p_err)
 }
 
 /*
-This function sets the FIPS REE state.
-The function should be implemented by the driver user, depends on where                          .
-the state value is stored.
-The reference code uses global variable.
-*/
+ * This function sets the FIPS REE state.
+ * The function should be implemented by the driver user, depends on where
+ * the state value is stored.
+ * The reference code uses global variable.
+ */
 int ssi_fips_ext_set_state(ssi_fips_state_t state)
 {
 	fips_state = state;
@@ -82,11 +82,11 @@ int ssi_fips_ext_set_state(ssi_fips_state_t state)
 }
 
 /*
-This function sets the FIPS REE error.
-The function should be implemented by the driver user, depends on where                          .
-the error value is stored.
-The reference code uses global variable.
-*/
+ * This function sets the FIPS REE error.
+ * The function should be implemented by the driver user, depends on where
+ * the error value is stored.
+ * The reference code uses global variable.
+ */
 int ssi_fips_ext_set_error(ssi_fips_error_t err)
 {
 	fips_error = err;
-- 
2.12.2

From: Derek Robson <robsonde@gmail.com>
Subject: [PATCH 16/27] Drivers: ccree: ssi_fips.c - align block comments
Date: Wed, 24 May 2017 16:45:14 +1200
Message-ID: <20170524044514.30610-1-robsonde@gmail.com>
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
 drivers/staging/ccree/ssi_fips.c | 16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff --git a/drivers/staging/ccree/ssi_fips.c b/drivers/staging/ccree/ssi_fips.c
index 25ee23a1cecf..60a2452f7b0b 100644
--- a/drivers/staging/ccree/ssi_fips.c
+++ b/drivers/staging/ccree/ssi_fips.c
@@ -16,8 +16,8 @@
 
 
 /**************************************************************
-This file defines the driver FIPS APIs                                                             *
-***************************************************************/
+ * This file defines the driver FIPS APIs                     *
+ **************************************************************/
 
 #include <linux/module.h>
 #include "ssi_fips.h"
@@ -27,9 +27,9 @@ extern int ssi_fips_ext_get_state(ssi_fips_state_t *p_state);
 extern int ssi_fips_ext_get_error(ssi_fips_error_t *p_err);
 
 /*
-This function returns the REE FIPS state.
-It should be called by kernel module.
-*/
+ * This function returns the REE FIPS state.
+ * It should be called by kernel module.
+ */
 int ssi_fips_get_state(ssi_fips_state_t *p_state)
 {
 	int rc = 0;
@@ -46,9 +46,9 @@ int ssi_fips_get_state(ssi_fips_state_t *p_state)
 EXPORT_SYMBOL(ssi_fips_get_state);
 
 /*
-This function returns the REE FIPS error.
-It should be called by kernel module.
-*/
+ * This function returns the REE FIPS error.
+ * It should be called by kernel module.
+ */
 int ssi_fips_get_error(ssi_fips_error_t *p_err)
 {
 	int rc = 0;
-- 
2.12.2

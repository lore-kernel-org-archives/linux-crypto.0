From: Derek Robson <robsonde@gmail.com>
Subject: [PATCH 06/27] Drivers: ccree: ssi_pm_ext.c - align block comments
Date: Wed, 24 May 2017 16:42:24 +1200
Message-ID: <20170524044224.30143-1-robsonde@gmail.com>
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
 drivers/staging/ccree/ssi_pm_ext.c | 14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/drivers/staging/ccree/ssi_pm_ext.c b/drivers/staging/ccree/ssi_pm_ext.c
index 5889d9f97479..453151cdd6b2 100644
--- a/drivers/staging/ccree/ssi_pm_ext.c
+++ b/drivers/staging/ccree/ssi_pm_ext.c
@@ -26,10 +26,10 @@
 #include "ssi_pm_ext.h"
 
 /*
-This function should suspend the HW (if possiable), It should be implemented by
-the driver user.
-The reference code clears the internal SRAM to imitate lose of state.
-*/
+ * This function should suspend the HW (if possiable), It should be implemented by
+ * the driver user.
+ * The reference code clears the internal SRAM to imitate lose of state.
+ */
 void ssi_pm_ext_hw_suspend(struct device *dev)
 {
 	struct ssi_drvdata *drvdata =
@@ -50,9 +50,9 @@ void ssi_pm_ext_hw_suspend(struct device *dev)
 }
 
 /*
-This function should resume the HW (if possiable).It should be implemented by
-the driver user.
-*/
+ * This function should resume the HW (if possiable).It should be implemented by
+ * the driver user.
+ */
 void ssi_pm_ext_hw_resume(struct device *dev)
 {
 	return;
-- 
2.12.2

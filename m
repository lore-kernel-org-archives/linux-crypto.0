From: Derek Robson <robsonde@gmail.com>
Subject: [PATCH V2 12/27] Drivers: ccree: ssi_fips_ll.c - align block comments
Date: Tue, 30 May 2017 18:13:10 +1200
Message-ID: <20170530061310.13537-1-robsonde@gmail.com>
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
 drivers/staging/ccree/ssi_fips_ll.c | 21 ++++++++++++---------
 1 file changed, 12 insertions(+), 9 deletions(-)

diff --git a/drivers/staging/ccree/ssi_fips_ll.c b/drivers/staging/ccree/ssi_fips_ll.c
index 7c7c922f0788..ef0a9a580560 100644
--- a/drivers/staging/ccree/ssi_fips_ll.c
+++ b/drivers/staging/ccree/ssi_fips_ll.c
@@ -15,9 +15,9 @@
  */
 
 /**************************************************************
-This file defines the driver FIPS Low Level implmentaion functions,
-that executes the KAT.
-***************************************************************/
+ * This file defines the driver FIPS Low Level implmentaion functions,
+ * that executes the KAT.
+ ***************************************************************/
 #include <linux/kernel.h>
 
 #include "ssi_driver.h"
@@ -816,7 +816,8 @@ ssi_hmac_fips_run_test(struct ssi_drvdata *drvdata,
 		       dma_addr_t digest_bytes_len_dma_addr)
 {
 	/* The implemented flow is not the same as the one implemented in ssi_hash.c (setkey + digest flows).
-	   In this flow, there is no need to store and reload some of the intermidiate results. */
+	 * In this flow, there is no need to store and reload some of the intermidiate results.
+	 */
 
 	/* max number of descriptors used for the flow */
 	#define FIPS_HMAC_MAX_SEQ_LEN 12
@@ -948,9 +949,9 @@ ssi_hmac_fips_run_test(struct ssi_drvdata *drvdata,
 	idx++;
 
 	/* at this point:
-	   tmp_digest = H(o_key_pad)
-	   k0 = H(i_key_pad || m)
-	   */
+	 * tmp_digest = H(o_key_pad)
+	 * k0 = H(i_key_pad || m)
+	 */
 
 	/* Loading hash opad xor key state */
 	HW_DESC_INIT(&desc[idx]);
@@ -1413,8 +1414,10 @@ ssi_gcm_fips_run_test(struct ssi_drvdata *drvdata,
 	idx++;
 
 	/* Configure Hash Engine to work with GHASH.
-	   Since it was not possible to extend HASH submodes to add GHASH,
-	   The following command is necessary in order to select GHASH (according to HW designers)*/
+	 * Since it was not possible to extend HASH submodes to add GHASH,
+	 * The following command is necessary in order to
+	 * select GHASH (according to HW designers)
+	 */
 	HW_DESC_INIT(&desc[idx]);
 	HW_DESC_SET_DIN_NO_DMA(&desc[idx], 0, 0xfffff0);
 	HW_DESC_SET_DOUT_NO_DMA(&desc[idx], 0, 0, 1);
-- 
2.13.0

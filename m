From: Derek Robson <robsonde@gmail.com>
Subject: [PATCH V2 08/27] Drivers: ccree: ssi_ivgen.c - align block comments
Date: Tue, 30 May 2017 18:11:49 +1200
Message-ID: <20170530061149.13349-1-robsonde@gmail.com>
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
 drivers/staging/ccree/ssi_ivgen.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/ccree/ssi_ivgen.c b/drivers/staging/ccree/ssi_ivgen.c
index 1bb6f8919101..db4b831e82a3 100644
--- a/drivers/staging/ccree/ssi_ivgen.c
+++ b/drivers/staging/ccree/ssi_ivgen.c
@@ -26,7 +26,8 @@
 /* The max. size of pool *MUST* be <= SRAM total size */
 #define SSI_IVPOOL_SIZE 1024
 /* The first 32B fraction of pool are dedicated to the
-   next encryption "key" & "IV" for pool regeneration */
+ * next encryption "key" & "IV" for pool regeneration
+ */
 #define SSI_IVPOOL_META_SIZE (CC_AES_IV_SIZE + AES_KEYSIZE_128)
 #define SSI_IVPOOL_GEN_SEQ_LEN	4
 
@@ -278,7 +279,8 @@ int ssi_ivgen_getiv(
 	}
 
 	/* Bypass operation is proceeded by crypto sequence, hence must
-	*  assure bypass-write-transaction by a memory barrier */
+	 *  assure bypass-write-transaction by a memory barrier
+	 */
 	HW_DESC_INIT(&iv_seq[idx]);
 	HW_DESC_SET_DIN_NO_DMA(&iv_seq[idx], 0, 0xfffff0);
 	HW_DESC_SET_DOUT_NO_DMA(&iv_seq[idx], 0, 0, 1);
-- 
2.13.0

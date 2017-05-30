From: Derek Robson <robsonde@gmail.com>
Subject: [PATCH V2 22/27] Drivers: ccree: ssi_aead.h - align block comments
Date: Tue, 30 May 2017 18:15:59 +1200
Message-ID: <20170530061559.13999-1-robsonde@gmail.com>
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
 drivers/staging/ccree/ssi_aead.h | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/ccree/ssi_aead.h b/drivers/staging/ccree/ssi_aead.h
index 654a181729d7..00a3680cb8ab 100644
--- a/drivers/staging/ccree/ssi_aead.h
+++ b/drivers/staging/ccree/ssi_aead.h
@@ -15,7 +15,7 @@
  */
 
 /* \file ssi_aead.h
-   ARM CryptoCell AEAD Crypto API
+ * ARM CryptoCell AEAD Crypto API
  */
 
 #ifndef __SSI_AEAD_H__
@@ -62,8 +62,9 @@ enum aead_ccm_header_size {
 
 struct aead_req_ctx {
 	/* Allocate cache line although only 4 bytes are needed to
-	*  assure next field falls @ cache line
-	*  Used for both: digest HW compare and CCM/GCM MAC value */
+	 *  assure next field falls @ cache line
+	 *  Used for both: digest HW compare and CCM/GCM MAC value
+	 */
 	u8 mac_buf[MAX_MAC_SIZE] ____cacheline_aligned;
 	u8 ctr_iv[AES_BLOCK_SIZE] ____cacheline_aligned;
 
-- 
2.13.0

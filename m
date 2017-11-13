From: Gilad Ben-Yossef <gilad@benyossef.com>
Subject: [PATCH 04/24] staging: ccree: remove MIN/MAX macros
Date: Mon, 13 Nov 2017 14:45:32 +0000
Message-ID: <1510584358-29473-5-git-send-email-gilad@benyossef.com>
References: <1510584358-29473-1-git-send-email-gilad@benyossef.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
 driverdev-devel@linuxdriverproject.org, linux-crypto@vger.kernel.org,
 Ofir Drang <ofir.drang@arm.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Return-path: <driverdev-devel-bounces@linuxdriverproject.org>
In-Reply-To: <1510584358-29473-1-git-send-email-gilad@benyossef.com>
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

The driver was using open coded MIN/MAX macros to
compute fixed defines. Remove them and use bigger
value always instead.

Signed-off-by: Gilad Ben-Yossef <gilad@benyossef.com>
---
 drivers/staging/ccree/ssi_aead.h   | 2 +-
 drivers/staging/ccree/ssi_driver.h | 3 ---
 drivers/staging/ccree/ssi_hash.c   | 2 +-
 3 files changed, 2 insertions(+), 5 deletions(-)

diff --git a/drivers/staging/ccree/ssi_aead.h b/drivers/staging/ccree/ssi_aead.h
index e85bcd9..580fdb8 100644
--- a/drivers/staging/ccree/ssi_aead.h
+++ b/drivers/staging/ccree/ssi_aead.h
@@ -28,7 +28,7 @@
 /* mac_cmp - HW writes 8 B but all bytes hold the same value */
 #define ICV_CMP_SIZE 8
 #define CCM_CONFIG_BUF_SIZE (AES_BLOCK_SIZE * 3)
-#define MAX_MAC_SIZE MAX(SHA256_DIGEST_SIZE, AES_BLOCK_SIZE)
+#define MAX_MAC_SIZE SHA256_DIGEST_SIZE
 
 /* defines for AES GCM configuration buffer */
 #define GCM_BLOCK_LEN_SIZE 8
diff --git a/drivers/staging/ccree/ssi_driver.h b/drivers/staging/ccree/ssi_driver.h
index f4967ca..758268e 100644
--- a/drivers/staging/ccree/ssi_driver.h
+++ b/drivers/staging/ccree/ssi_driver.h
@@ -95,9 +95,6 @@
  * field in the HW descriptor. The DMA engine +8 that value.
  */
 
-#define MIN(a, b) (((a) < (b)) ? (a) : (b))
-#define MAX(a, b) (((a) > (b)) ? (a) : (b))
-
 #define SSI_MAX_IVGEN_DMA_ADDRESSES	3
 struct ssi_crypto_req {
 	void (*user_cb)(struct device *dev, void *req);
diff --git a/drivers/staging/ccree/ssi_hash.c b/drivers/staging/ccree/ssi_hash.c
index 1fda84d..8414c25 100644
--- a/drivers/staging/ccree/ssi_hash.c
+++ b/drivers/staging/ccree/ssi_hash.c
@@ -32,7 +32,7 @@
 #include "ssi_sram_mgr.h"
 
 #define SSI_MAX_AHASH_SEQ_LEN 12
-#define SSI_MAX_HASH_OPAD_TMP_KEYS_SIZE MAX(SSI_MAX_HASH_BLCK_SIZE, 3 * AES_BLOCK_SIZE)
+#define SSI_MAX_HASH_OPAD_TMP_KEYS_SIZE SSI_MAX_HASH_BLCK_SIZE
 
 struct ssi_hash_handle {
 	ssi_sram_addr_t digest_len_sram_addr; /* const value in SRAM*/
-- 
2.7.4

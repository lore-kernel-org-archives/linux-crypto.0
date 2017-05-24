From: Derek Robson <robsonde@gmail.com>
Subject: [PATCH 27/27] Drivers: ccree: cc_crypto_ctx.h - align block comments
Date: Wed, 24 May 2017 16:47:53 +1200
Message-ID: <20170524044753.31116-1-robsonde@gmail.com>
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
 drivers/staging/ccree/cc_crypto_ctx.h | 17 ++++++++++-------
 1 file changed, 10 insertions(+), 7 deletions(-)

diff --git a/drivers/staging/ccree/cc_crypto_ctx.h b/drivers/staging/ccree/cc_crypto_ctx.h
index 216d24791d5d..dcec9a649a84 100644
--- a/drivers/staging/ccree/cc_crypto_ctx.h
+++ b/drivers/staging/ccree/cc_crypto_ctx.h
@@ -219,7 +219,8 @@ struct drv_ctx_hash {
 };
 
 /* !!!! drv_ctx_hmac should have the same structure as drv_ctx_hash except
-   k0, k0_size fields */
+ *  k0, k0_size fields
+ */
 struct drv_ctx_hmac {
 	enum drv_crypto_alg alg; /* DRV_CRYPTO_ALG_HMAC */
 	enum drv_hash_mode mode;
@@ -240,9 +241,10 @@ struct drv_ctx_cipher {
 	u32 key_size; /* numeric value in bytes   */
 	u32 data_unit_size; /* required for XTS */
 	/* block_state is the AES engine block state.
-	*  It is used by the host to pass IV or counter at initialization.
-	*  It is used by SeP for intermediate block chaining state and for
-	*  returning MAC algorithms results.           */
+	 *  It is used by the host to pass IV or counter at initialization.
+	 *  It is used by SeP for intermediate block chaining state and for
+	 *  returning MAC algorithms results.     
+         */
 	u8 block_state[CC_AES_BLOCK_SIZE];
 	u8 key[CC_AES_KEY_SIZE_MAX];
 	u8 xex_key[CC_AES_KEY_SIZE_MAX];
@@ -279,9 +281,10 @@ struct drv_ctx_aead {
 
 
 /* Get the address of a @member within a given @ctx address
-   @ctx: The context address
-   @type: Type of context structure
-   @member: Associated context field */
+ *  @ctx: The context address
+ *  @type: Type of context structure
+ *  @member: Associated context field
+ */
 #define GET_CTX_FIELD_ADDR(ctx, type, member) (ctx + offsetof(type, member))
 
 #endif /* _CC_CRYPTO_CTX_H_ */
-- 
2.12.2

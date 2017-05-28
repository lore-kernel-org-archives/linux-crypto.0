From: Gilad Ben-Yossef <gilad@benyossef.com>
Subject: [PATCH 01/12] staging: ccree: correct coding style violations
Date: Sun, 28 May 2017 17:40:26 +0300
Message-ID: <1495982440-10047-2-git-send-email-gilad@benyossef.com>
References: <1495982440-10047-1-git-send-email-gilad@benyossef.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: linux-crypto@vger.kernel.org, devel@driverdev.osuosl.org,
 driverdev-devel@linuxdriverproject.org, linux-kernel@vger.kernel.org,
 Ofir Drang <ofir.drang@arm.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Return-path: <driverdev-devel-bounces@linuxdriverproject.org>
In-Reply-To: <1495982440-10047-1-git-send-email-gilad@benyossef.com>
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

cc_crypto_ctx.h had multiple coding style violations reported by
checkpatch. Fix them all.

Signed-off-by: Gilad Ben-Yossef <gilad@benyossef.com>
---
 drivers/staging/ccree/cc_crypto_ctx.h | 66 +++++++++++++++++------------------
 1 file changed, 32 insertions(+), 34 deletions(-)

diff --git a/drivers/staging/ccree/cc_crypto_ctx.h b/drivers/staging/ccree/cc_crypto_ctx.h
index ac39d34..0823b0f 100644
--- a/drivers/staging/ccree/cc_crypto_ctx.h
+++ b/drivers/staging/ccree/cc_crypto_ctx.h
@@ -14,7 +14,6 @@
  * along with this program; if not, see <http://www.gnu.org/licenses/>.
  */
 
-
 #ifndef _CC_CRYPTO_CTX_H_
 #define _CC_CRYPTO_CTX_H_
 
@@ -28,7 +27,7 @@
 #define CC_CTX_SIZE_LOG2 7
 #endif
 #endif
-#define CC_CTX_SIZE (1<<CC_CTX_SIZE_LOG2)
+#define CC_CTX_SIZE BIT(CC_CTX_SIZE_LOG2)
 #define CC_DRV_CTX_SIZE_WORDS (CC_CTX_SIZE >> 2)
 
 #define CC_DRV_DES_IV_SIZE 8
@@ -54,13 +53,13 @@
 #define CC_AES_KEY_SIZE_MAX			CC_AES_256_BIT_KEY_SIZE
 #define CC_AES_KEY_SIZE_WORDS_MAX		(CC_AES_KEY_SIZE_MAX >> 2)
 
-#define CC_MD5_DIGEST_SIZE	16
-#define CC_SHA1_DIGEST_SIZE	20
-#define CC_SHA224_DIGEST_SIZE	28
-#define CC_SHA256_DIGEST_SIZE	32
+#define CC_MD5_DIGEST_SIZE 16
+#define CC_SHA1_DIGEST_SIZE 20
+#define CC_SHA224_DIGEST_SIZE 28
+#define CC_SHA256_DIGEST_SIZE 32
 #define CC_SHA256_DIGEST_SIZE_IN_WORDS 8
-#define CC_SHA384_DIGEST_SIZE	48
-#define CC_SHA512_DIGEST_SIZE	64
+#define CC_SHA384_DIGEST_SIZE 48
+#define CC_SHA512_DIGEST_SIZE 64
 
 #define CC_SHA1_BLOCK_SIZE 64
 #define CC_SHA1_BLOCK_SIZE_IN_WORDS 16
@@ -83,18 +82,17 @@
 
 #define CC_HMAC_BLOCK_SIZE_MAX CC_HASH_BLOCK_SIZE_MAX
 
-#define CC_MULTI2_SYSTEM_KEY_SIZE		32
-#define CC_MULTI2_DATA_KEY_SIZE		8
-#define CC_MULTI2_SYSTEM_N_DATA_KEY_SIZE	(CC_MULTI2_SYSTEM_KEY_SIZE + CC_MULTI2_DATA_KEY_SIZE)
-#define	CC_MULTI2_BLOCK_SIZE					8
-#define	CC_MULTI2_IV_SIZE					8
-#define	CC_MULTI2_MIN_NUM_ROUNDS				8
-#define	CC_MULTI2_MAX_NUM_ROUNDS				128
-
+#define CC_MULTI2_SYSTEM_KEY_SIZE 32
+#define CC_MULTI2_DATA_KEY_SIZE	8
+#define CC_MULTI2_SYSTEM_N_DATA_KEY_SIZE (CC_MULTI2_SYSTEM_KEY_SIZE + \
+					  CC_MULTI2_DATA_KEY_SIZE)
+#define	CC_MULTI2_BLOCK_SIZE 8
+#define	CC_MULTI2_IV_SIZE 8
+#define	CC_MULTI2_MIN_NUM_ROUND 8
+#define	CC_MULTI2_MAX_NUM_ROUND 128
 
 #define CC_DRV_ALG_MAX_BLOCK_SIZE CC_HASH_BLOCK_SIZE_MAX
 
-
 enum drv_engine_type {
 	DRV_ENGINE_NULL = 0,
 	DRV_ENGINE_AES = 1,
@@ -178,7 +176,6 @@ enum drv_multi2_mode {
 	DRV_MULTI2_RESERVE32B = S32_MAX
 };
 
-
 /* drv_crypto_key_type[1:0] is mapped to cipher_do[1:0] */
 /* drv_crypto_key_type[2] is mapped to cipher_config2 */
 enum drv_crypto_key_type {
@@ -208,7 +205,6 @@ struct drv_ctx_generic {
 	enum drv_crypto_alg alg;
 } __attribute__((__may_alias__));
 
-
 struct drv_ctx_hash {
 	enum drv_crypto_alg alg; /* DRV_CRYPTO_ALG_HASH */
 	enum drv_hash_mode mode;
@@ -218,13 +214,14 @@ struct drv_ctx_hash {
 			CC_DIGEST_SIZE_MAX];
 };
 
-/* !!!! drv_ctx_hmac should have the same structure as drv_ctx_hash except
-   k0, k0_size fields */
+/* NOTE! drv_ctx_hmac should have the same structure as drv_ctx_hash except
+ * k0, k0_size fields
+ */
 struct drv_ctx_hmac {
 	enum drv_crypto_alg alg; /* DRV_CRYPTO_ALG_HMAC */
 	enum drv_hash_mode mode;
 	u8 digest[CC_DIGEST_SIZE_MAX];
-	u32 k0[CC_HMAC_BLOCK_SIZE_MAX/sizeof(u32)];
+	u32 k0[CC_HMAC_BLOCK_SIZE_MAX / sizeof(u32)];
 	u32 k0_size;
 	/* reserve to end of allocated context size */
 	u8 reserved[CC_CTX_SIZE - 3 * sizeof(u32) -
@@ -240,16 +237,17 @@ struct drv_ctx_cipher {
 	u32 key_size; /* numeric value in bytes   */
 	u32 data_unit_size; /* required for XTS */
 	/* block_state is the AES engine block state.
-	*  It is used by the host to pass IV or counter at initialization.
-	*  It is used by SeP for intermediate block chaining state and for
-	*  returning MAC algorithms results.           */
+	 *  It is used by the host to pass IV or counter at initialization.
+	 *  It is used by SeP for intermediate block chaining state and for
+	 *  returning MAC algorithms results.
+	 */
 	u8 block_state[CC_AES_BLOCK_SIZE];
 	u8 key[CC_AES_KEY_SIZE_MAX];
 	u8 xex_key[CC_AES_KEY_SIZE_MAX];
 	/* reserve to end of allocated context size */
 	u32 reserved[CC_DRV_CTX_SIZE_WORDS - 7 -
-		CC_AES_BLOCK_SIZE/sizeof(u32) - 2 *
-		(CC_AES_KEY_SIZE_MAX/sizeof(u32))];
+		CC_AES_BLOCK_SIZE / sizeof(u32) - 2 *
+		(CC_AES_KEY_SIZE_MAX / sizeof(u32))];
 };
 
 /* authentication and encryption with associated data class */
@@ -269,20 +267,20 @@ struct drv_ctx_aead {
 	u8 key[CC_AES_KEY_SIZE_MAX];
 	/* reserve to end of allocated context size */
 	u32 reserved[CC_DRV_CTX_SIZE_WORDS - 8 -
-		3 * (CC_AES_BLOCK_SIZE/sizeof(u32)) -
-		CC_AES_KEY_SIZE_MAX/sizeof(u32)];
+		3 * (CC_AES_BLOCK_SIZE / sizeof(u32)) -
+		CC_AES_KEY_SIZE_MAX / sizeof(u32)];
 };
 
 /*******************************************************************/
 /***************** MESSAGE BASED CONTEXTS **************************/
 /*******************************************************************/
 
-
 /* Get the address of a @member within a given @ctx address
-   @ctx: The context address
-   @type: Type of context structure
-   @member: Associated context field */
-#define GET_CTX_FIELD_ADDR(ctx, type, member) (ctx + offsetof(type, member))
+ *  @ctx: The context address
+ *  @type: Type of context structure
+ *  @member: Associated context field
+ */
+#define GET_CTX_FIELD_ADDR(ctx, type, member) ((ctx) + offsetof(type, member))
 
 #endif /* _CC_CRYPTO_CTX_H_ */
 
-- 
2.1.4

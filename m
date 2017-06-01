From: Gilad Ben-Yossef <gilad@benyossef.com>
Subject: [PATCH v2 05/20] staging: ccree: fix comments formatting
Date: Thu,  1 Jun 2017 14:02:55 +0300
Message-ID: <1496314993-30229-6-git-send-email-gilad@benyossef.com>
References: <1496314993-30229-1-git-send-email-gilad@benyossef.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: devel@driverdev.osuosl.org, driverdev-devel@linuxdriverproject.org,
 linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org,
 Joe Perches <joe@perches.com>, Ofir Drang <ofir.drang@arm.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Return-path: <driverdev-devel-bounces@linuxdriverproject.org>
In-Reply-To: <1496314993-30229-1-git-send-email-gilad@benyossef.com>
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

A few of the comments in cc_crypto_ctx.h where not formatted
correctly. Format according to coding style guidelines.

Signed-off-by: Gilad Ben-Yossef <gilad@benyossef.com>
---
 drivers/staging/ccree/cc_crypto_ctx.h | 19 +++++++++++--------
 1 file changed, 11 insertions(+), 8 deletions(-)

diff --git a/drivers/staging/ccree/cc_crypto_ctx.h b/drivers/staging/ccree/cc_crypto_ctx.h
index 10f57e6..838e6e4 100644
--- a/drivers/staging/ccree/cc_crypto_ctx.h
+++ b/drivers/staging/ccree/cc_crypto_ctx.h
@@ -214,8 +214,9 @@ struct drv_ctx_hash {
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
@@ -236,9 +237,10 @@ struct drv_ctx_cipher {
 	u32 key_size; /* numeric value in bytes   */
 	u32 data_unit_size; /* required for XTS */
 	/* block_state is the AES engine block state.
-	*  It is used by the host to pass IV or counter at initialization.
-	*  It is used by SeP for intermediate block chaining state and for
-	*  returning MAC algorithms results.           */
+	 * It is used by the host to pass IV or counter at initialization.
+	 * It is used by SeP for intermediate block chaining state and for
+	 * returning MAC algorithms results.
+	 */
 	u8 block_state[CC_AES_BLOCK_SIZE];
 	u8 key[CC_AES_KEY_SIZE_MAX];
 	u8 xex_key[CC_AES_KEY_SIZE_MAX];
@@ -274,9 +276,10 @@ struct drv_ctx_aead {
 /*******************************************************************/
 
 /* Get the address of a @member within a given @ctx address
-   @ctx: The context address
-   @type: Type of context structure
-   @member: Associated context field */
+ * @ctx: The context address
+ * @type: Type of context structure
+ * @member: Associated context field
+ */
 #define GET_CTX_FIELD_ADDR(ctx, type, member) (ctx + offsetof(type, member))
 
 #endif /* _CC_CRYPTO_CTX_H_ */
-- 
2.1.4

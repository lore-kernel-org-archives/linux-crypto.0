From: Gennadii Altukhov <grinrag@gmail.com>
Subject: [PATCH] staging: ccree: fix cc_crypto_ctx.h white spaces
Date: Fri, 26 May 2017 11:28:47 +0200
Message-ID: <20170526092847.GA26812@dhcp129-169.brq.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: devel@driverdev.osuosl.org, driverdev-devel@linuxdriverproject.org,
 linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
To: gilad@benyossef.com
Return-path: <driverdev-devel-bounces@linuxdriverproject.org>
Content-Disposition: inline
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

Fix checkpatch.pl reported checks: spaces preferred around '/' and '<<' in cc_crypto_ctx.h

Signed-off-by: Gennadii Altukhov <grinrag@gmail.com>
---
 drivers/staging/ccree/cc_crypto_ctx.h | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/staging/ccree/cc_crypto_ctx.h b/drivers/staging/ccree/cc_crypto_ctx.h
index ac39d34..2fabb5c 100644
--- a/drivers/staging/ccree/cc_crypto_ctx.h
+++ b/drivers/staging/ccree/cc_crypto_ctx.h
@@ -28,7 +28,7 @@
 #define CC_CTX_SIZE_LOG2 7
 #endif
 #endif
-#define CC_CTX_SIZE (1<<CC_CTX_SIZE_LOG2)
+#define CC_CTX_SIZE (1 << CC_CTX_SIZE_LOG2)
 #define CC_DRV_CTX_SIZE_WORDS (CC_CTX_SIZE >> 2)
 
 #define CC_DRV_DES_IV_SIZE 8
@@ -224,7 +224,7 @@ struct drv_ctx_hmac {
 	enum drv_crypto_alg alg; /* DRV_CRYPTO_ALG_HMAC */
 	enum drv_hash_mode mode;
 	u8 digest[CC_DIGEST_SIZE_MAX];
-	u32 k0[CC_HMAC_BLOCK_SIZE_MAX/sizeof(u32)];
+	u32 k0[CC_HMAC_BLOCK_SIZE_MAX / sizeof(u32)];
 	u32 k0_size;
 	/* reserve to end of allocated context size */
 	u8 reserved[CC_CTX_SIZE - 3 * sizeof(u32) -
@@ -248,8 +248,8 @@ struct drv_ctx_cipher {
 	u8 xex_key[CC_AES_KEY_SIZE_MAX];
 	/* reserve to end of allocated context size */
 	u32 reserved[CC_DRV_CTX_SIZE_WORDS - 7 -
-		CC_AES_BLOCK_SIZE/sizeof(u32) - 2 *
-		(CC_AES_KEY_SIZE_MAX/sizeof(u32))];
+		CC_AES_BLOCK_SIZE / sizeof(u32) - 2 *
+		(CC_AES_KEY_SIZE_MAX / sizeof(u32))];
 };
 
 /* authentication and encryption with associated data class */
@@ -269,8 +269,8 @@ struct drv_ctx_aead {
 	u8 key[CC_AES_KEY_SIZE_MAX];
 	/* reserve to end of allocated context size */
 	u32 reserved[CC_DRV_CTX_SIZE_WORDS - 8 -
-		3 * (CC_AES_BLOCK_SIZE/sizeof(u32)) -
-		CC_AES_KEY_SIZE_MAX/sizeof(u32)];
+		3 * (CC_AES_BLOCK_SIZE / sizeof(u32)) -
+		CC_AES_KEY_SIZE_MAX / sizeof(u32)];
 };
 
 /*******************************************************************/
-- 
1.8.3.1

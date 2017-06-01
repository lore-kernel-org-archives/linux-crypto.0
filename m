From: Gilad Ben-Yossef <gilad@benyossef.com>
Subject: [PATCH v2 04/20] staging: ccree: fix operator spacing
Date: Thu,  1 Jun 2017 14:02:54 +0300
Message-ID: <1496314993-30229-5-git-send-email-gilad@benyossef.com>
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

cc_crypto_ctx.h file had a few macro definitions with missing
spaces around operators. Add missing spaces.

Signed-off-by: Gilad Ben-Yossef <gilad@benyossef.com>
---
 drivers/staging/ccree/cc_crypto_ctx.h | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/staging/ccree/cc_crypto_ctx.h b/drivers/staging/ccree/cc_crypto_ctx.h
index 15b4ef9..10f57e6 100644
--- a/drivers/staging/ccree/cc_crypto_ctx.h
+++ b/drivers/staging/ccree/cc_crypto_ctx.h
@@ -220,7 +220,7 @@ struct drv_ctx_hmac {
 	enum drv_crypto_alg alg; /* DRV_CRYPTO_ALG_HMAC */
 	enum drv_hash_mode mode;
 	u8 digest[CC_DIGEST_SIZE_MAX];
-	u32 k0[CC_HMAC_BLOCK_SIZE_MAX/sizeof(u32)];
+	u32 k0[CC_HMAC_BLOCK_SIZE_MAX / sizeof(u32)];
 	u32 k0_size;
 	/* reserve to end of allocated context size */
 	u8 reserved[CC_CTX_SIZE - 3 * sizeof(u32) -
@@ -244,8 +244,8 @@ struct drv_ctx_cipher {
 	u8 xex_key[CC_AES_KEY_SIZE_MAX];
 	/* reserve to end of allocated context size */
 	u32 reserved[CC_DRV_CTX_SIZE_WORDS - 7 -
-		CC_AES_BLOCK_SIZE/sizeof(u32) - 2 *
-		(CC_AES_KEY_SIZE_MAX/sizeof(u32))];
+		CC_AES_BLOCK_SIZE / sizeof(u32) - 2 *
+		(CC_AES_KEY_SIZE_MAX / sizeof(u32))];
 };
 
 /* authentication and encryption with associated data class */
@@ -265,8 +265,8 @@ struct drv_ctx_aead {
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
2.1.4

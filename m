From: Gilad Ben-Yossef <gilad@benyossef.com>
Subject: [PATCH v2 01/20] staging: ccree: remove spurious blank lines
Date: Thu,  1 Jun 2017 14:02:51 +0300
Message-ID: <1496314993-30229-2-git-send-email-gilad@benyossef.com>
References: <1496314993-30229-1-git-send-email-gilad@benyossef.com>
Cc: Joe Perches <joe@perches.com>, Ofir Drang <ofir.drang@arm.com>,
        linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org,
        driverdev-devel@linuxdriverproject.org, devel@driverdev.osuosl.org
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1496314993-30229-1-git-send-email-gilad@benyossef.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Remove spurious blanks lines from cc_crypto_ctx.h file

Signed-off-by: Gilad Ben-Yossef <gilad@benyossef.com>
---
 drivers/staging/ccree/cc_crypto_ctx.h | 6 ------
 1 file changed, 6 deletions(-)

diff --git a/drivers/staging/ccree/cc_crypto_ctx.h b/drivers/staging/ccree/cc_crypto_ctx.h
index ac39d34..9bfadb21 100644
--- a/drivers/staging/ccree/cc_crypto_ctx.h
+++ b/drivers/staging/ccree/cc_crypto_ctx.h
@@ -14,7 +14,6 @@
  * along with this program; if not, see <http://www.gnu.org/licenses/>.
  */
 
-
 #ifndef _CC_CRYPTO_CTX_H_
 #define _CC_CRYPTO_CTX_H_
 
@@ -91,10 +90,8 @@
 #define	CC_MULTI2_MIN_NUM_ROUNDS				8
 #define	CC_MULTI2_MAX_NUM_ROUNDS				128
 
-
 #define CC_DRV_ALG_MAX_BLOCK_SIZE CC_HASH_BLOCK_SIZE_MAX
 
-
 enum drv_engine_type {
 	DRV_ENGINE_NULL = 0,
 	DRV_ENGINE_AES = 1,
@@ -178,7 +175,6 @@ enum drv_multi2_mode {
 	DRV_MULTI2_RESERVE32B = S32_MAX
 };
 
-
 /* drv_crypto_key_type[1:0] is mapped to cipher_do[1:0] */
 /* drv_crypto_key_type[2] is mapped to cipher_config2 */
 enum drv_crypto_key_type {
@@ -208,7 +204,6 @@ struct drv_ctx_generic {
 	enum drv_crypto_alg alg;
 } __attribute__((__may_alias__));
 
-
 struct drv_ctx_hash {
 	enum drv_crypto_alg alg; /* DRV_CRYPTO_ALG_HASH */
 	enum drv_hash_mode mode;
@@ -277,7 +272,6 @@ struct drv_ctx_aead {
 /***************** MESSAGE BASED CONTEXTS **************************/
 /*******************************************************************/
 
-
 /* Get the address of a @member within a given @ctx address
    @ctx: The context address
    @type: Type of context structure
-- 
2.1.4

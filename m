From: Derek Robson <robsonde@gmail.com>
Subject: [PATCH V2 24/27] Drivers: ccree: hash_defs.h - align block comments
Date: Tue, 30 May 2017 18:16:38 +1200
Message-ID: <20170530061638.14091-1-robsonde@gmail.com>
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
 drivers/staging/ccree/hash_defs.h | 15 ++++++++-------
 1 file changed, 8 insertions(+), 7 deletions(-)

diff --git a/drivers/staging/ccree/hash_defs.h b/drivers/staging/ccree/hash_defs.h
index 613897038f6d..3f2b2d1521c2 100644
--- a/drivers/staging/ccree/hash_defs.h
+++ b/drivers/staging/ccree/hash_defs.h
@@ -59,13 +59,14 @@ enum HashCipherDoPadding {
 
 typedef struct SepHashPrivateContext {
 	/* The current length is placed at the end of the context buffer because the hash
-	   context is used for all HMAC operations as well. HMAC context includes a 64 bytes
-	   K0 field.  The size of struct drv_ctx_hash reserved field is  88/184 bytes depend if t
-	   he SHA512 is supported ( in this case teh context size is 256 bytes).
-	   The size of struct drv_ctx_hash reseved field is 20 or 52 depend if the SHA512 is supported.
-	   This means that this structure size (without the reserved field can be up to 20 bytes ,
-	   in case sha512 is not suppported it is 20 bytes (SEP_HASH_LENGTH_WORDS define to 2 ) and in the other
-	   case it is 28 (SEP_HASH_LENGTH_WORDS define to 4) */
+	 *  context is used for all HMAC operations as well. HMAC context includes a 64 bytes
+	 *  K0 field.  The size of struct drv_ctx_hash reserved field is  88/184 bytes depend if t
+	 *  he SHA512 is supported ( in this case teh context size is 256 bytes).
+	 *  The size of struct drv_ctx_hash reseved field is 20 or 52 depend if the SHA512 is supported.
+	 *  This means that this structure size (without the reserved field can be up to 20 bytes ,
+	 *  in case sha512 is not suppported it is 20 bytes (SEP_HASH_LENGTH_WORDS define to 2 ) and in the other
+	 * case it is 28 (SEP_HASH_LENGTH_WORDS define to 4)
+	 */
 	u32 reserved[(sizeof(struct drv_ctx_hash)/sizeof(u32)) - SEP_HASH_LENGTH_WORDS - 3];
 	u32 CurrentDigestedLength[SEP_HASH_LENGTH_WORDS];
 	u32 KeyType;
-- 
2.13.0

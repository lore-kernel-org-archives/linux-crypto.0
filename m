From: Gilad Ben-Yossef <gilad@benyossef.com>
Subject: [PATCH v2 15/20] staging: ccree: remove unused struct
Date: Thu,  1 Jun 2017 14:03:05 +0300
Message-ID: <1496314993-30229-16-git-send-email-gilad@benyossef.com>
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

struct SepHashPrivateContext is not used anywhere in the code.
Remove it.

Signed-off-by: Gilad Ben-Yossef <gilad@benyossef.com>
---
 drivers/staging/ccree/hash_defs.h | 17 -----------------
 1 file changed, 17 deletions(-)

diff --git a/drivers/staging/ccree/hash_defs.h b/drivers/staging/ccree/hash_defs.h
index 6138970..9e01219 100644
--- a/drivers/staging/ccree/hash_defs.h
+++ b/drivers/staging/ccree/hash_defs.h
@@ -57,22 +57,5 @@ enum HashCipherDoPadding {
 	HASH_CIPHER_DO_PADDING_RESERVE32 = S32_MAX,
 };
 
-typedef struct SepHashPrivateContext {
-	/* The current length is placed at the end of the context buffer because the hash
-	   context is used for all HMAC operations as well. HMAC context includes a 64 bytes
-	   K0 field.  The size of struct drv_ctx_hash reserved field is  88/184 bytes depend if t
-	   he SHA512 is supported ( in this case teh context size is 256 bytes).
-	   The size of struct drv_ctx_hash reseved field is 20 or 52 depend if the SHA512 is supported.
-	   This means that this structure size (without the reserved field can be up to 20 bytes ,
-	   in case sha512 is not suppported it is 20 bytes (SEP_HASH_LENGTH_WORDS define to 2 ) and in the other
-	   case it is 28 (SEP_HASH_LENGTH_WORDS define to 4) */
-	u32 reserved[(sizeof(struct drv_ctx_hash)/sizeof(u32)) - SEP_HASH_LENGTH_WORDS - 3];
-	u32 CurrentDigestedLength[SEP_HASH_LENGTH_WORDS];
-	u32 KeyType;
-	u32 dataCompleted;
-	u32 hmacFinalization;
-	/* no space left */
-} SepHashPrivateContext_s;
-
 #endif /*_HASH_DEFS_H__*/
 
-- 
2.1.4

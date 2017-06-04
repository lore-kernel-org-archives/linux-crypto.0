From: Gilad Ben-Yossef <gilad@benyossef.com>
Subject: [PATCH v3 10/18] staging: ccree: remove unused struct
Date: Sun,  4 Jun 2017 11:02:31 +0300
Message-ID: <1496563362-7954-11-git-send-email-gilad@benyossef.com>
References: <1496563362-7954-1-git-send-email-gilad@benyossef.com>
Cc: Joe Perches <joe@perches.com>, Ofir Drang <ofir.drang@arm.com>,
        linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org,
        driverdev-devel@linuxdriverproject.org, devel@driverdev.osuosl.org
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from foss.arm.com ([217.140.101.70]:52768 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751193AbdFDIDw (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Sun, 4 Jun 2017 04:03:52 -0400
In-Reply-To: <1496563362-7954-1-git-send-email-gilad@benyossef.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

struct SepHashPrivateContext is not used anywhere in the code.
Remove it.

Signed-off-by: Gilad Ben-Yossef <gilad@benyossef.com>
---
 drivers/staging/ccree/hash_defs.h | 18 ------------------
 1 file changed, 18 deletions(-)

diff --git a/drivers/staging/ccree/hash_defs.h b/drivers/staging/ccree/hash_defs.h
index 3f2b2d1..9e01219 100644
--- a/drivers/staging/ccree/hash_defs.h
+++ b/drivers/staging/ccree/hash_defs.h
@@ -57,23 +57,5 @@ enum HashCipherDoPadding {
 	HASH_CIPHER_DO_PADDING_RESERVE32 = S32_MAX,
 };
 
-typedef struct SepHashPrivateContext {
-	/* The current length is placed at the end of the context buffer because the hash
-	 *  context is used for all HMAC operations as well. HMAC context includes a 64 bytes
-	 *  K0 field.  The size of struct drv_ctx_hash reserved field is  88/184 bytes depend if t
-	 *  he SHA512 is supported ( in this case teh context size is 256 bytes).
-	 *  The size of struct drv_ctx_hash reseved field is 20 or 52 depend if the SHA512 is supported.
-	 *  This means that this structure size (without the reserved field can be up to 20 bytes ,
-	 *  in case sha512 is not suppported it is 20 bytes (SEP_HASH_LENGTH_WORDS define to 2 ) and in the other
-	 * case it is 28 (SEP_HASH_LENGTH_WORDS define to 4)
-	 */
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

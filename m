From: Gilad Ben-Yossef <gilad@benyossef.com>
Subject: [PATCH 08/12] staging: ccree: remove unused struct
Date: Sun, 28 May 2017 17:40:33 +0300
Message-ID: <1495982440-10047-9-git-send-email-gilad@benyossef.com>
References: <1495982440-10047-1-git-send-email-gilad@benyossef.com>
Cc: Ofir Drang <ofir.drang@arm.com>, linux-kernel@vger.kernel.org,
        linux-crypto@vger.kernel.org,
        driverdev-devel@linuxdriverproject.org, devel@driverdev.osuosl.org
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from foss.arm.com ([217.140.101.70]:42156 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751022AbdE1Ol1 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Sun, 28 May 2017 10:41:27 -0400
In-Reply-To: <1495982440-10047-1-git-send-email-gilad@benyossef.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

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

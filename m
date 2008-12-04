From: Adrian-Ken Rueegsegger <ken@codelabs.ch>
Subject: [PATCH 4/4][RFC] crypto: michael_mic - Switch to shash
Date: Thu,  4 Dec 2008 01:18:12 +0100
Message-ID: <12283498962759-git-send-email-ken@codelabs.ch>
References: <12283498922490-git-send-email-ken@codelabs.ch>
 <12283498932360-git-send-email-ken@codelabs.ch>
 <12283498942104-git-send-email-ken@codelabs.ch>
 <12283498953450-git-send-email-ken@codelabs.ch>
Cc: linux-crypto@vger.kernel.org, steffen.klassert@secunet.com,
	Adrian-Ken Rueegsegger <ken@codelabs.ch>
To: herbert@gondor.apana.org.au
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from [217.150.249.120] ([217.150.249.120]:40708 "EHLO
	fenrir.codelabs.ch" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1751789AbYLDAST (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 3 Dec 2008 19:18:19 -0500
In-Reply-To: <12283498953450-git-send-email-ken@codelabs.ch>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

This patch changes michael_mic to the new shash interface.

Signed-off-by: Adrian-Ken Rueegsegger <ken@codelabs.ch>
---
 crypto/michael_mic.c |   72 ++++++++++++++++++++++++++++---------------------
 1 files changed, 41 insertions(+), 31 deletions(-)

diff --git a/crypto/michael_mic.c b/crypto/michael_mic.c
index 9e917b8..079b761 100644
--- a/crypto/michael_mic.c
+++ b/crypto/michael_mic.c
@@ -9,23 +9,25 @@
  * it under the terms of the GNU General Public License version 2 as
  * published by the Free Software Foundation.
  */
-
+#include <crypto/internal/hash.h>
 #include <asm/byteorder.h>
 #include <linux/init.h>
 #include <linux/module.h>
 #include <linux/string.h>
-#include <linux/crypto.h>
 #include <linux/types.h>
 
 
 struct michael_mic_ctx {
+	u32 l, r;
+};
+
+struct michael_mic_desc_ctx {
 	u8 pending[4];
 	size_t pending_len;
 
 	u32 l, r;
 };
 
-
 static inline u32 xswap(u32 val)
 {
 	return ((val & 0x00ff00ff) << 8) | ((val & 0xff00ff00) >> 8);
@@ -45,17 +47,22 @@ do {				\
 } while (0)
 
 
-static void michael_init(struct crypto_tfm *tfm)
+static int michael_init(struct shash_desc *desc)
 {
-	struct michael_mic_ctx *mctx = crypto_tfm_ctx(tfm);
+	struct michael_mic_desc_ctx *mctx = shash_desc_ctx(desc);
+	struct michael_mic_ctx *ctx = crypto_shash_ctx(desc->tfm);
 	mctx->pending_len = 0;
+	mctx->l = ctx->l;
+	mctx->r = ctx->r;
+
+	return 0;
 }
 
 
-static void michael_update(struct crypto_tfm *tfm, const u8 *data,
+static int michael_update(struct shash_desc *desc, const u8 *data,
 			   unsigned int len)
 {
-	struct michael_mic_ctx *mctx = crypto_tfm_ctx(tfm);
+	struct michael_mic_desc_ctx *mctx = shash_desc_ctx(desc);
 	const __le32 *src;
 
 	if (mctx->pending_len) {
@@ -68,7 +75,7 @@ static void michael_update(struct crypto_tfm *tfm, const u8 *data,
 		len -= flen;
 
 		if (mctx->pending_len < 4)
-			return;
+			return 0;
 
 		src = (const __le32 *)mctx->pending;
 		mctx->l ^= le32_to_cpup(src);
@@ -88,12 +95,14 @@ static void michael_update(struct crypto_tfm *tfm, const u8 *data,
 		mctx->pending_len = len;
 		memcpy(mctx->pending, src, len);
 	}
+
+	return 0;
 }
 
 
-static void michael_final(struct crypto_tfm *tfm, u8 *out)
+static int michael_final(struct shash_desc *desc, u8 *out)
 {
-	struct michael_mic_ctx *mctx = crypto_tfm_ctx(tfm);
+	struct michael_mic_desc_ctx *mctx = shash_desc_ctx(desc);
 	u8 *data = mctx->pending;
 	__le32 *dst = (__le32 *)out;
 
@@ -119,17 +128,20 @@ static void michael_final(struct crypto_tfm *tfm, u8 *out)
 
 	dst[0] = cpu_to_le32(mctx->l);
 	dst[1] = cpu_to_le32(mctx->r);
+
+	return 0;
 }
 
 
-static int michael_setkey(struct crypto_tfm *tfm, const u8 *key,
+static int michael_setkey(struct crypto_shash *tfm, const u8 *key,
 			  unsigned int keylen)
 {
-	struct michael_mic_ctx *mctx = crypto_tfm_ctx(tfm);
+	struct michael_mic_ctx *mctx = crypto_shash_ctx(tfm);
+
 	const __le32 *data = (const __le32 *)key;
 
 	if (keylen != 8) {
-		tfm->crt_flags |= CRYPTO_TFM_RES_BAD_KEY_LEN;
+		crypto_shash_set_flags(tfm, CRYPTO_TFM_RES_BAD_KEY_LEN);
 		return -EINVAL;
 	}
 
@@ -138,33 +150,31 @@ static int michael_setkey(struct crypto_tfm *tfm, const u8 *key,
 	return 0;
 }
 
-
-static struct crypto_alg michael_mic_alg = {
-	.cra_name	= "michael_mic",
-	.cra_flags	= CRYPTO_ALG_TYPE_DIGEST,
-	.cra_blocksize	= 8,
-	.cra_ctxsize	= sizeof(struct michael_mic_ctx),
-	.cra_module	= THIS_MODULE,
-	.cra_alignmask	= 3,
-	.cra_list	= LIST_HEAD_INIT(michael_mic_alg.cra_list),
-	.cra_u		= { .digest = {
-	.dia_digestsize	= 8,
-	.dia_init	= michael_init,
-	.dia_update	= michael_update,
-	.dia_final	= michael_final,
-	.dia_setkey	= michael_setkey } }
+static struct shash_alg alg = {
+	.digestsize		=	8,
+	.setkey			=	michael_setkey,
+	.init			=	michael_init,
+	.update			=	michael_update,
+	.final			=	michael_final,
+	.descsize		=	sizeof(struct michael_mic_desc_ctx),
+	.base			=	{
+		.cra_name		=	"michael_mic",
+		.cra_blocksize		=	8,
+		.cra_alignmask		=	3,
+		.cra_ctxsize		=	sizeof(struct michael_mic_ctx),
+		.cra_module		=	THIS_MODULE,
+	}
 };
 

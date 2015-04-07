From: Dan Streetman <ddstreet@ieee.org>
Subject: [PATCH 09/11] crypto: remove LZO fallback from crypto 842
Date: Tue,  7 Apr 2015 13:34:28 -0400
Message-ID: <1428428070-17803-10-git-send-email-ddstreet@ieee.org>
References: <1428428070-17803-1-git-send-email-ddstreet@ieee.org>
Cc: Seth Jennings <sjennings@variantweb.net>,
	Robert Jennings <rob@pochix.net>, linux-crypto@vger.kernel.org,
	linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org,
	Dan Streetman <ddstreet@ieee.org>
To: Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Benjamin Herrenschmidt <benh@kernel.crashing.org>,
	Paul Mackerras <paulus@samba.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1428428070-17803-1-git-send-email-ddstreet@ieee.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Update the crypto 842 driver to no longer fallback to LZO if the 842
hardware is unavailable.  Simplify the crpypto 842 driver to remove all
headers indicating 842/lzo.

The crypto 842 driver should do 842-format compression and decompression
only.  It should not fallback to LZO compression/decompression.  The
user of the crypto 842 driver can fallback to another format if desired.

Signed-off-by: Dan Streetman <ddstreet@ieee.org>
---
 crypto/842.c   | 139 ++++++++++++---------------------------------------------
 crypto/Kconfig |   4 +-
 2 files changed, 29 insertions(+), 114 deletions(-)

diff --git a/crypto/842.c b/crypto/842.c
index d21cedb..d81c6c7 100644
--- a/crypto/842.c
+++ b/crypto/842.c
@@ -26,128 +26,46 @@
 #include <linux/crypto.h>
 #include <linux/vmalloc.h>
 #include <linux/nx842.h>
-#include <linux/lzo.h>
+#include <linux/sw842.h>
 #include <linux/timer.h>
 
-static int nx842_uselzo;
-
-struct nx842_ctx {
-	void *nx842_wmem; /* working memory for 842/lzo */
-};
-
-enum nx842_crypto_type {
-	NX842_CRYPTO_TYPE_842,
-	NX842_CRYPTO_TYPE_LZO
+struct crypto842_ctx {
+	void *wmem; /* working memory for 842 */
 };
 
-#define NX842_SENTINEL 0xdeadbeef
-
-struct nx842_crypto_header {
-	unsigned int sentinel; /* debug */
-	enum nx842_crypto_type type;
-};
-
-static int nx842_init(struct crypto_tfm *tfm)
+static int crypto842_init(struct crypto_tfm *tfm)
 {
-	struct nx842_ctx *ctx = crypto_tfm_ctx(tfm);
-	int wmemsize;
+	struct crypto842_ctx *ctx = crypto_tfm_ctx(tfm);
 
-	wmemsize = max_t(int, NX842_MEM_COMPRESS, LZO1X_MEM_COMPRESS);
-	ctx->nx842_wmem = kmalloc(wmemsize, GFP_NOFS);
-	if (!ctx->nx842_wmem)
+	ctx->wmem = kmalloc(NX842_MEM_COMPRESS, GFP_NOFS);
+	if (!ctx->wmem)
 		return -ENOMEM;
 
 	return 0;
 }
 
-static void nx842_exit(struct crypto_tfm *tfm)
+static void crypto842_exit(struct crypto_tfm *tfm)
 {
-	struct nx842_ctx *ctx = crypto_tfm_ctx(tfm);
+	struct crypto842_ctx *ctx = crypto_tfm_ctx(tfm);
 
-	kfree(ctx->nx842_wmem);
+	kfree(ctx->wmem);
 }
 
-static void nx842_reset_uselzo(unsigned long data)
-{
-	nx842_uselzo = 0;
-}
-
-static DEFINE_TIMER(failover_timer, nx842_reset_uselzo, 0, 0);
-
-static int nx842_crypto_compress(struct crypto_tfm *tfm, const u8 *src,
+static int crypto842_compress(struct crypto_tfm *tfm, const u8 *src,
 			    unsigned int slen, u8 *dst, unsigned int *dlen)
 {
-	struct nx842_ctx *ctx = crypto_tfm_ctx(tfm);
-	struct nx842_crypto_header *hdr;
-	unsigned int tmp_len = *dlen;
-	size_t lzodlen; /* needed for lzo */
-	int err;
-
-	*dlen = 0;
-	hdr = (struct nx842_crypto_header *)dst;
-	hdr->sentinel = NX842_SENTINEL; /* debug */
-	dst += sizeof(struct nx842_crypto_header);
-	tmp_len -= sizeof(struct nx842_crypto_header);
-	lzodlen = tmp_len;
-
-	if (likely(!nx842_uselzo)) {
-		err = nx842_compress(src, slen, dst, &tmp_len, ctx->nx842_wmem);
-
-		if (likely(!err)) {
-			hdr->type = NX842_CRYPTO_TYPE_842;
-			*dlen = tmp_len + sizeof(struct nx842_crypto_header);
-			return 0;
-		}
-
-		/* hardware failed */
-		nx842_uselzo = 1;
-
-		/* set timer to check for hardware again in 1 second */
-		mod_timer(&failover_timer, jiffies + msecs_to_jiffies(1000));
-	}
-
-	/* no hardware, use lzo */
-	err = lzo1x_1_compress(src, slen, dst, &lzodlen, ctx->nx842_wmem);
-	if (err != LZO_E_OK)
-		return -EINVAL;
-
-	hdr->type = NX842_CRYPTO_TYPE_LZO;
-	*dlen = lzodlen + sizeof(struct nx842_crypto_header);
-	return 0;
+	struct crypto842_ctx *ctx = crypto_tfm_ctx(tfm);
+
+	return nx842_compress(src, slen, dst, dlen, ctx->wmem);
 }
 
-static int nx842_crypto_decompress(struct crypto_tfm *tfm, const u8 *src,
+static int crypto842_decompress(struct crypto_tfm *tfm, const u8 *src,
 			      unsigned int slen, u8 *dst, unsigned int *dlen)
 {
-	struct nx842_ctx *ctx = crypto_tfm_ctx(tfm);
-	struct nx842_crypto_header *hdr;
-	unsigned int tmp_len = *dlen;
-	size_t lzodlen; /* needed for lzo */
-	int err;
-
-	*dlen = 0;
-	hdr = (struct nx842_crypto_header *)src;
-
-	if (unlikely(hdr->sentinel != NX842_SENTINEL))
-		return -EINVAL;
-
-	src += sizeof(struct nx842_crypto_header);
-	slen -= sizeof(struct nx842_crypto_header);
-
-	if (likely(hdr->type == NX842_CRYPTO_TYPE_842)) {
-		err = nx842_decompress(src, slen, dst, &tmp_len,
-			ctx->nx842_wmem);
-		if (err)
-			return -EINVAL;
-		*dlen = tmp_len;
-	} else if (hdr->type == NX842_CRYPTO_TYPE_LZO) {
-		lzodlen = tmp_len;
-		err = lzo1x_decompress_safe(src, slen, dst, &lzodlen);
-		if (err != LZO_E_OK)
-			return -EINVAL;
-		*dlen = lzodlen;
-	} else
-		return -EINVAL;
+	struct crypto842_ctx *ctx = crypto_tfm_ctx(tfm);
+
+	if (nx842_decompress(src, slen, dst, dlen, ctx->wmem))
+		return sw842_decompress(src, slen, dst, dlen);
 
 	return 0;
 }
@@ -155,28 +73,27 @@ static int nx842_crypto_decompress(struct crypto_tfm *tfm, const u8 *src,
 static struct crypto_alg alg = {
 	.cra_name		= "842",
 	.cra_flags		= CRYPTO_ALG_TYPE_COMPRESS,
-	.cra_ctxsize		= sizeof(struct nx842_ctx),
+	.cra_ctxsize		= sizeof(struct crypto842_ctx),
 	.cra_module		= THIS_MODULE,
-	.cra_init		= nx842_init,
-	.cra_exit		= nx842_exit,
+	.cra_init		= crypto842_init,
+	.cra_exit		= crypto842_exit,
 	.cra_u			= { .compress = {
-	.coa_compress		= nx842_crypto_compress,
-	.coa_decompress		= nx842_crypto_decompress } }
+	.coa_compress		= crypto842_compress,
+	.coa_decompress		= crypto842_decompress } }
 };
 
-static int __init nx842_mod_init(void)
+static int __init crypto842_mod_init(void)
 {
-	del_timer(&failover_timer);
 	return crypto_register_alg(&alg);
 }
 
-static void __exit nx842_mod_exit(void)
+static void __exit crypto842_mod_exit(void)
 {
 	crypto_unregister_alg(&alg);
 }
 
-module_init(nx842_mod_init);
-module_exit(nx842_mod_exit);
+module_init(crypto842_mod_init);
+module_exit(crypto842_mod_exit);
 
 MODULE_LICENSE("GPL");
 MODULE_DESCRIPTION("842 Compression Algorithm");
diff --git a/crypto/Kconfig b/crypto/Kconfig
index 50f4da4..a7148ff 100644
--- a/crypto/Kconfig
+++ b/crypto/Kconfig
@@ -1424,9 +1424,7 @@ config CRYPTO_LZO
 config CRYPTO_842
 	tristate "842 compression algorithm"
 	depends on CRYPTO_DEV_NX_COMPRESS
-	# 842 uses lzo if the hardware becomes unavailable
-	select LZO_COMPRESS
-	select LZO_DECOMPRESS
+	select 842_DECOMPRESS
 	help
 	  This is the 842 algorithm.
 
-- 
2.1.0

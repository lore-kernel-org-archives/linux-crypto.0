From: Dan Streetman <ddstreet@ieee.org>
Subject: [PATCH 04/10] crypto: change 842 alg to use software
Date: Thu,  7 May 2015 13:49:15 -0400
Message-ID: <1431020961-22285-5-git-send-email-ddstreet@ieee.org>
References: <1431020961-22285-1-git-send-email-ddstreet@ieee.org>
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
In-Reply-To: <1431020961-22285-1-git-send-email-ddstreet@ieee.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Change the crypto 842 compression alg to use the software 842 compression
and decompression library.  Add the crypto driver_name as "842-generic".
Remove the fallback to LZO compression.

Previously, this crypto compression alg attemped 842 compression using
PowerPC hardware, and fell back to LZO compression and decompression if
the 842 PowerPC hardware was unavailable or failed.  This should not
fall back to any other compression method, however; users of this crypto
compression alg can fallback if desired, and transparent fallback tricks
callers into thinking they are getting 842 compression when they actually
get LZO compression - the failure of the 842 hardware should not be
transparent to the caller.

The crypto compression alg for a hardware device also should not be located
in crypto/ so this is now a software-only implementation that uses the 842
software compression/decompression library.

Signed-off-by: Dan Streetman <ddstreet@ieee.org>
---
 MAINTAINERS    |   1 +
 crypto/842.c   | 174 ++++++++++++---------------------------------------------
 crypto/Kconfig |   7 +--
 3 files changed, 41 insertions(+), 141 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index 116af01..5a5c1dc 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -4873,6 +4873,7 @@ S:	Supported
 F:	drivers/crypto/nx/nx-842.c
 F:	include/linux/nx842.h
 F:	include/linux/sw842.h
+F:	crypto/842.c
 F:	lib/842/
 
 IBM Power Linux RAID adapter
diff --git a/crypto/842.c b/crypto/842.c
index b48f4f1..98e387e 100644
--- a/crypto/842.c
+++ b/crypto/842.c
@@ -1,5 +1,5 @@
 /*
- * Cryptographic API for the 842 compression algorithm.
+ * Cryptographic API for the 842 software compression algorithm.
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License as published by
@@ -11,173 +11,73 @@
  * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
  * GNU General Public License for more details.
  *
- * You should have received a copy of the GNU General Public License
- * along with this program; if not, write to the Free Software
- * Foundation, 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301, USA.
+ * Copyright (C) IBM Corporation, 2011-2015
  *
- * Copyright (C) IBM Corporation, 2011
+ * Original Authors: Robert Jennings <rcj@linux.vnet.ibm.com>
+ *                   Seth Jennings <sjenning@linux.vnet.ibm.com>
  *
- * Authors: Robert Jennings <rcj@linux.vnet.ibm.com>
- *          Seth Jennings <sjenning@linux.vnet.ibm.com>
+ * Rewrite: Dan Streetman <ddstreet@ieee.org>
+ *
+ * This is the software implementation of compression and decompression using
+ * the 842 format.  This uses the software 842 library at lib/842/ which is
+ * only a reference implementation, and is very, very slow as compared to other
+ * software compressors.  You probably do not want to use this software
+ * compression.  If you have access to the PowerPC 842 compression hardware, you
+ * want to use the 842 hardware compression interface, which is at:
+ * drivers/crypto/nx/nx-842-crypto.c
  */
 
 #include <linux/init.h>
 #include <linux/module.h>
 #include <linux/crypto.h>
-#include <linux/vmalloc.h>
-#include <linux/nx842.h>
-#include <linux/lzo.h>
-#include <linux/timer.h>
-
-static int nx842_uselzo;
-
-struct nx842_ctx {
-	void *nx842_wmem; /* working memory for 842/lzo */
-};
+#include <linux/sw842.h>
 
-enum nx842_crypto_type {
-	NX842_CRYPTO_TYPE_842,
-	NX842_CRYPTO_TYPE_LZO
+struct crypto842_ctx {
+	char wmem[SW842_MEM_COMPRESS];	/* working memory for compress */
 };
 
-#define NX842_SENTINEL 0xdeadbeef
-
-struct nx842_crypto_header {
-	unsigned int sentinel; /* debug */
-	enum nx842_crypto_type type;
-};
-
-static int nx842_init(struct crypto_tfm *tfm)
-{
-	struct nx842_ctx *ctx = crypto_tfm_ctx(tfm);
-	int wmemsize;
-
-	wmemsize = max_t(int, nx842_get_workmem_size(), LZO1X_MEM_COMPRESS);
-	ctx->nx842_wmem = kmalloc(wmemsize, GFP_NOFS);
-	if (!ctx->nx842_wmem)
-		return -ENOMEM;
-
-	return 0;
-}
-
-static void nx842_exit(struct crypto_tfm *tfm)
-{
-	struct nx842_ctx *ctx = crypto_tfm_ctx(tfm);
-
-	kfree(ctx->nx842_wmem);
-}
-
-static void nx842_reset_uselzo(unsigned long data)
+static int crypto842_compress(struct crypto_tfm *tfm,
+			      const u8 *src, unsigned int slen,
+			      u8 *dst, unsigned int *dlen)
 {
-	nx842_uselzo = 0;
-}
-
-static DEFINE_TIMER(failover_timer, nx842_reset_uselzo, 0, 0);
-
-static int nx842_crypto_compress(struct crypto_tfm *tfm, const u8 *src,
-			    unsigned int slen, u8 *dst, unsigned int *dlen)
-{
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
+	struct crypto842_ctx *ctx = crypto_tfm_ctx(tfm);
 
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
+	return sw842_compress(src, slen, dst, dlen, ctx->wmem);
 }
 
-static int nx842_crypto_decompress(struct crypto_tfm *tfm, const u8 *src,
-			      unsigned int slen, u8 *dst, unsigned int *dlen)
+static int crypto842_decompress(struct crypto_tfm *tfm,
+				const u8 *src, unsigned int slen,
+				u8 *dst, unsigned int *dlen)
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
-
-	return 0;
+	return sw842_decompress(src, slen, dst, dlen);
 }
 
 static struct crypto_alg alg = {
 	.cra_name		= "842",
+	.cra_driver_name	= "842-generic",
+	.cra_priority		= 100,
 	.cra_flags		= CRYPTO_ALG_TYPE_COMPRESS,
-	.cra_ctxsize		= sizeof(struct nx842_ctx),
+	.cra_ctxsize		= sizeof(struct crypto842_ctx),
 	.cra_module		= THIS_MODULE,
-	.cra_init		= nx842_init,
-	.cra_exit		= nx842_exit,
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
+module_init(crypto842_mod_init);
 
-static void __exit nx842_mod_exit(void)
+static void __exit crypto842_mod_exit(void)
 {
 	crypto_unregister_alg(&alg);
 }
-
-module_init(nx842_mod_init);
-module_exit(nx842_mod_exit);
+module_exit(crypto842_mod_exit);
 
 MODULE_LICENSE("GPL");
-MODULE_DESCRIPTION("842 Compression Algorithm");
+MODULE_DESCRIPTION("842 Software Compression Algorithm");
 MODULE_ALIAS_CRYPTO("842");
+MODULE_ALIAS_CRYPTO("842-generic");
+MODULE_AUTHOR("Dan Streetman <ddstreet@ieee.org>");
diff --git a/crypto/Kconfig b/crypto/Kconfig
index 8aaf298..eba55b4 100644
--- a/crypto/Kconfig
+++ b/crypto/Kconfig
@@ -1412,10 +1412,9 @@ config CRYPTO_LZO
 
 config CRYPTO_842
 	tristate "842 compression algorithm"
-	depends on CRYPTO_DEV_NX_COMPRESS
-	# 842 uses lzo if the hardware becomes unavailable
-	select LZO_COMPRESS
-	select LZO_DECOMPRESS
+	select CRYPTO_ALGAPI
+	select 842_COMPRESS
+	select 842_DECOMPRESS
 	help
 	  This is the 842 algorithm.
 
-- 
2.1.0

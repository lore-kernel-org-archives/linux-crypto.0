From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: crypto: nx/842 - Fix context corruption
Date: Wed, 8 Jul 2015 21:40:39 +0800
Message-ID: <20150708134039.GA22723@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
	"Leonidas S. Barbosa" <leosilva@linux.vnet.ibm.com>,
	Fionnuala Gunter <fin@linux.vnet.ibm.com>,
	Nishanth Aravamudan <nacc@linux.vnet.ibm.com>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Dan Streetman <ddstreet@us.ibm.com>,
	=?utf-8?B?4oCcZ3VzdGF2b2xkQGxpbnV4LnZuZXQuaWJtLmNvbeKAnQ==?=
	<gustavold@linux.vnet.ibm.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:36623 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758585AbbGHNkr (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 8 Jul 2015 09:40:47 -0400
Content-Disposition: inline
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

The transform context is shared memory and must not be written
to without locking.  This patch adds locking to nx-842 to prevent
context corruption.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>

diff --git a/drivers/crypto/nx/nx-842-crypto.c b/drivers/crypto/nx/nx-842-crypto.c
index d53a1dc..3288a70 100644
--- a/drivers/crypto/nx/nx-842-crypto.c
+++ b/drivers/crypto/nx/nx-842-crypto.c
@@ -60,6 +60,7 @@
 #include <linux/vmalloc.h>
 #include <linux/sw842.h>
 #include <linux/ratelimit.h>
+#include <linux/spinlock.h>
 
 #include "nx-842.h"
 
@@ -125,6 +126,8 @@ static int update_param(struct nx842_crypto_param *p,
 }
 
 struct nx842_crypto_ctx {
+	spinlock_t lock;
+
 	u8 *wmem;
 	u8 *sbounce, *dbounce;
 
@@ -136,6 +139,7 @@ static int nx842_crypto_init(struct crypto_tfm *tfm)
 {
 	struct nx842_crypto_ctx *ctx = crypto_tfm_ctx(tfm);
 
+	spin_lock_init(&ctx->lock);
 	ctx->wmem = kmalloc(nx842_workmem_size(), GFP_KERNEL);
 	ctx->sbounce = (u8 *)__get_free_pages(GFP_KERNEL, BOUNCE_BUFFER_ORDER);
 	ctx->dbounce = (u8 *)__get_free_pages(GFP_KERNEL, BOUNCE_BUFFER_ORDER);
@@ -315,6 +319,8 @@ static int nx842_crypto_compress(struct crypto_tfm *tfm,
 		       DIV_ROUND_UP(p.iremain, c.maximum));
 	hdrsize = NX842_CRYPTO_HEADER_SIZE(groups);
 
+	spin_lock_bh(&ctx->lock);
+
 	/* skip adding header if the buffers meet all constraints */
 	add_header = (p.iremain % c.multiple	||
 		      p.iremain < c.minimum	||
@@ -331,8 +337,9 @@ static int nx842_crypto_compress(struct crypto_tfm *tfm,
 
 	while (p.iremain > 0) {
 		n = hdr->groups++;
+		ret = -ENOSPC;
 		if (hdr->groups > NX842_CRYPTO_GROUP_MAX)
-			return -ENOSPC;
+			goto unlock;
 
 		/* header goes before first group */
 		h = !n && add_header ? hdrsize : 0;
@@ -342,12 +349,13 @@ static int nx842_crypto_compress(struct crypto_tfm *tfm,
 
 		ret = compress(ctx, &p, &hdr->group[n], &c, &ignore, h);
 		if (ret)
-			return ret;
+			goto unlock;
 	}
 
 	if (!add_header && hdr->groups > 1) {
 		pr_err("Internal error: No header but multiple groups\n");
-		return -EINVAL;
+		ret = -EINVAL;
+		goto unlock;
 	}
 
 	/* ignore indicates the input stream needed to be padded */
@@ -358,13 +366,15 @@ static int nx842_crypto_compress(struct crypto_tfm *tfm,
 	if (add_header)
 		ret = nx842_crypto_add_header(hdr, dst);
 	if (ret)
-		return ret;
+		goto unlock;
 
 	*dlen = p.ototal;
 
 	pr_debug("compress total slen %x dlen %x\n", slen, *dlen);
 
-	return 0;
+unlock:
+	spin_unlock_bh(&ctx->lock);
+	return ret;
 }
 
 static int decompress(struct nx842_crypto_ctx *ctx,
@@ -494,6 +504,8 @@ static int nx842_crypto_decompress(struct crypto_tfm *tfm,
 
 	hdr = (struct nx842_crypto_header *)src;
 
+	spin_lock_bh(&ctx->lock);
+
 	/* If it doesn't start with our header magic number, assume it's a raw
 	 * 842 compressed buffer and pass it directly to the hardware driver
 	 */
@@ -506,26 +518,31 @@ static int nx842_crypto_decompress(struct crypto_tfm *tfm,
 
 		ret = decompress(ctx, &p, &g, &c, 0, usehw);
 		if (ret)
-			return ret;
+			goto unlock;
 
 		*dlen = p.ototal;
 
-		return 0;
+		ret = 0;
+		goto unlock;
 	}
 
 	if (!hdr->groups) {
 		pr_err("header has no groups\n");
-		return -EINVAL;
+		ret = -EINVAL;
+		goto unlock;
 	}
 	if (hdr->groups > NX842_CRYPTO_GROUP_MAX) {
 		pr_err("header has too many groups %x, max %x\n",
 		       hdr->groups, NX842_CRYPTO_GROUP_MAX);
-		return -EINVAL;
+		ret = -EINVAL;
+		goto unlock;
 	}
 
 	hdr_len = NX842_CRYPTO_HEADER_SIZE(hdr->groups);
-	if (hdr_len > slen)
-		return -EOVERFLOW;
+	if (hdr_len > slen) {
+		ret = -EOVERFLOW;
+		goto unlock;
+	}
 
 	memcpy(&ctx->header, src, hdr_len);
 	hdr = &ctx->header;
@@ -537,14 +554,19 @@ static int nx842_crypto_decompress(struct crypto_tfm *tfm,
 
 		ret = decompress(ctx, &p, &hdr->group[n], &c, ignore, usehw);
 		if (ret)
-			return ret;
+			goto unlock;
 	}
 
 	*dlen = p.ototal;
 
 	pr_debug("decompress total slen %x dlen %x\n", slen, *dlen);
 
-	return 0;
+	ret = 0;
+
+unlock:
+	spin_unlock_bh(&ctx->lock);
+
+	return ret;
 }
 
 static struct crypto_alg alg = {
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt

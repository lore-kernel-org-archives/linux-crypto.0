From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH] crypto: hash - Added scatter list walking helper
Date: Wed, 9 Jul 2008 15:37:32 +0800
Message-ID: <20080709073732.GA11891@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from rhun.apana.org.au ([64.62.148.172]:44899 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752386AbYGIHhf (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 9 Jul 2008 03:37:35 -0400
Received: from gondolin.me.apana.org.au ([192.168.0.6] ident=mail)
	by arnor.apana.org.au with esmtp (Exim 4.63 #1 (Debian))
	id 1KGUF3-0001yT-7h
	for <linux-crypto@vger.kernel.org>; Wed, 09 Jul 2008 17:37:33 +1000
Received: from herbert by gondolin.me.apana.org.au with local (Exim 3.36 #1 (Debian))
	id 1KGUF2-000365-00
	for <linux-crypto@vger.kernel.org>; Wed, 09 Jul 2008 15:37:32 +0800
Content-Disposition: inline
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi:

This patch lets us convert existing software implementations
of hash algorithms to use the ahash interface.  It's similar
to how the blkcipher walking works.

commit 505ae158f41441b9c7e65116b9cb4df7ab1d6753
Author: Herbert Xu <herbert@gondor.apana.org.au>
Date:   Mon Jul 7 22:19:53 2008 +0800

    crypto: hash - Added scatter list walking helper
    
    This patch adds the walking helpers for hash algorithms akin to
    those of block ciphers.  This is a necessary step before we can
    reimplement existing hash algorithms using the new ahash interface.
    
    Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>

diff --git a/crypto/ahash.c b/crypto/ahash.c
index e6e5906..bb0239c 100644
--- a/crypto/ahash.c
+++ b/crypto/ahash.c
@@ -13,7 +13,8 @@
  *
  */
 
-#include <crypto/algapi.h>
+#include <crypto/hash.h>
+#include <crypto/scatterwalk.h>
 #include <linux/err.h>
 #include <linux/kernel.h>
 #include <linux/module.h>
@@ -23,6 +24,94 @@
 
 #include "internal.h"
 
+static int hash_walk_next(struct crypto_hash_walk *walk)
+{
+	unsigned int alignmask = walk->alignmask;
+	unsigned int offset = walk->offset;
+	unsigned int nbytes = min(walk->entrylen,
+				  ((unsigned int)(PAGE_SIZE)) - offset);
+
+	walk->data = crypto_kmap(walk->pg, 0);
+	walk->data += offset;
+
+	if (offset & alignmask)
+		nbytes = alignmask + 1 - (offset & alignmask);
+
+	walk->entrylen -= nbytes;
+	return nbytes;
+}
+
+static int hash_walk_new_entry(struct crypto_hash_walk *walk)
+{
+	struct scatterlist *sg;
+
+	sg = walk->sg;
+	walk->pg = sg_page(sg);
+	walk->offset = sg->offset;
+	walk->entrylen = sg->length;
+
+	if (walk->entrylen > walk->total)
+		walk->entrylen = walk->total;
+	walk->total -= walk->entrylen;
+
+	return hash_walk_next(walk);
+}
+
+int crypto_hash_walk_done(struct crypto_hash_walk *walk, int err)
+{
+	unsigned int alignmask = walk->alignmask;
+	unsigned int nbytes = walk->entrylen;
+
+	walk->data -= walk->offset;
+
+	if (nbytes && walk->offset & alignmask && !err) {
+		walk->offset += alignmask - 1;
+		walk->offset = ALIGN(walk->offset, alignmask + 1);
+		walk->data += walk->offset;
+
+		nbytes = min(nbytes,
+			     ((unsigned int)(PAGE_SIZE)) - walk->offset);
+		walk->entrylen -= nbytes;
+
+		return nbytes;
+	}
+
+	crypto_kunmap(walk->data, 0);
+	crypto_yield(walk->flags);
+
+	if (err)
+		return err;
+
+	walk->offset = 0;
+
+	if (nbytes)
+		return hash_walk_next(walk);
+
+	if (!walk->total)
+		return 0;
+
+	walk->sg = scatterwalk_sg_next(walk->sg);
+
+	return hash_walk_new_entry(walk);
+}
+EXPORT_SYMBOL_GPL(crypto_hash_walk_done);
+
+int crypto_hash_walk_first(struct ahash_request *req,
+			   struct crypto_hash_walk *walk)
+{
+	walk->total = req->nbytes;
+
+	if (!walk->total)
+		return 0;
+
+	walk->alignmask = crypto_ahash_alignmask(crypto_ahash_reqtfm(req));
+	walk->sg = req->src;
+	walk->flags = req->base.flags;
+
+	return hash_walk_new_entry(walk);
+}
+EXPORT_SYMBOL_GPL(crypto_hash_walk_first);
+
 static int ahash_setkey_unaligned(struct crypto_ahash *tfm, const u8 *key,
 				unsigned int keylen)
 {
diff --git a/include/crypto/hash.h b/include/crypto/hash.h
new file mode 100644
index 0000000..f9d54c0
--- /dev/null
+++ b/include/crypto/hash.h
@@ -0,0 +1,41 @@
+/*
+ * Hash algorithms.
+ * 
+ * Copyright (c) 2008 Herbert Xu <herbert@gondor.apana.org.au>
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms of the GNU General Public License as published by the Free
+ * Software Foundation; either version 2 of the License, or (at your option) 
+ * any later version.
+ *
+ */
+
+#ifndef _CRYPTO_HASH_H
+#define _CRYPTO_HASH_H
+
+#include <crypto/algapi.h>
+
+struct ahash_request;
+struct scatterlist;
+
+struct crypto_hash_walk {
+	char *data;
+
+	unsigned int offset;
+	unsigned int alignmask;
+
+	struct page *pg;
+	unsigned int entrylen;
+
+	unsigned int total;
+	struct scatterlist *sg;
+
+	unsigned int flags;
+};
+
+int crypto_hash_walk_done(struct crypto_hash_walk *walk, int err);
+int crypto_hash_walk_first(struct ahash_request *req,
+			   struct crypto_hash_walk *walk);
+
+#endif	/* _CRYPTO_HASH_H */
+
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt

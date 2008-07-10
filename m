From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] crypto: hash - Added scatter list walking helper
Date: Thu, 10 Jul 2008 15:58:33 +0800
Message-ID: <20080710075833.GA23429@gondor.apana.org.au>
References: <20080709073732.GA11891@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from rhun.apana.org.au ([64.62.148.172]:36869 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750985AbYGJH6g (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 10 Jul 2008 03:58:36 -0400
Received: from gondolin.me.apana.org.au ([192.168.0.6] ident=mail)
	by arnor.apana.org.au with esmtp (Exim 4.63 #1 (Debian))
	id 1KGr2w-0000iB-28
	for <linux-crypto@vger.kernel.org>; Thu, 10 Jul 2008 17:58:34 +1000
Received: from herbert by gondolin.me.apana.org.au with local (Exim 3.36 #1 (Debian))
	id 1KGr2v-00066A-00
	for <linux-crypto@vger.kernel.org>; Thu, 10 Jul 2008 15:58:33 +0800
Content-Disposition: inline
In-Reply-To: <20080709073732.GA11891@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Wed, Jul 09, 2008 at 03:37:32PM +0800, Herbert Xu wrote:
>
> diff --git a/include/crypto/hash.h b/include/crypto/hash.h
> new file mode 100644
> index 0000000..f9d54c0
> --- /dev/null
> +++ b/include/crypto/hash.h

I've moved this file to include/crypto/internal since it's meant
to be used by ahash implementors rather than uesrs.

Cheers,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
--
diff --git a/crypto/ahash.c b/crypto/ahash.c
index bb0239c..27128f2 100644
--- a/crypto/ahash.c
+++ b/crypto/ahash.c
@@ -13,7 +13,7 @@
  *
  */
 
-#include <crypto/hash.h>
+#include <crypto/internal/hash.h>
 #include <crypto/scatterwalk.h>
 #include <linux/err.h>
 #include <linux/kernel.h>
diff --git a/crypto/crc32c.c b/crypto/crc32c.c
index 7049a98..a882d9e 100644
--- a/crypto/crc32c.c
+++ b/crypto/crc32c.c
@@ -14,7 +14,7 @@
  *
  */
 
-#include <crypto/hash.h>
+#include <crypto/internal/hash.h>
 #include <linux/init.h>
 #include <linux/module.h>
 #include <linux/string.h>
diff --git a/include/crypto/hash.h b/include/crypto/hash.h
deleted file mode 100644
index f9d54c0..0000000
--- a/include/crypto/hash.h
+++ /dev/null
@@ -1,41 +0,0 @@
-/*
- * Hash algorithms.
- * 
- * Copyright (c) 2008 Herbert Xu <herbert@gondor.apana.org.au>
- *
- * This program is free software; you can redistribute it and/or modify it
- * under the terms of the GNU General Public License as published by the Free
- * Software Foundation; either version 2 of the License, or (at your option) 
- * any later version.
- *
- */
-
-#ifndef _CRYPTO_HASH_H
-#define _CRYPTO_HASH_H
-
-#include <crypto/algapi.h>
-
-struct ahash_request;
-struct scatterlist;
-
-struct crypto_hash_walk {
-	char *data;
-
-	unsigned int offset;
-	unsigned int alignmask;
-
-	struct page *pg;
-	unsigned int entrylen;
-
-	unsigned int total;
-	struct scatterlist *sg;
-
-	unsigned int flags;
-};
-
-int crypto_hash_walk_done(struct crypto_hash_walk *walk, int err);
-int crypto_hash_walk_first(struct ahash_request *req,
-			   struct crypto_hash_walk *walk);
-
-#endif	/* _CRYPTO_HASH_H */
-
diff --git a/include/crypto/internal/hash.h b/include/crypto/internal/hash.h
new file mode 100644
index 0000000..93ac422
--- /dev/null
+++ b/include/crypto/internal/hash.h
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
+#ifndef _CRYPTO_INTERNAL_HASH_H
+#define _CRYPTO_INTERNAL_HASH_H
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
+#endif	/* _CRYPTO_INTERNAL_HASH_H */
+

From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 4/5] [CRYPTO] scatterwalk: Move scatterwalk.h to linux/crypto
Date: Fri, 07 Dec 2007 16:19:46 +0800
Message-ID: <E1J0YR0-000222-00@gondolin.me.apana.org.au>
References: <20071207081904.GA7733@gondor.apana.org.au>
To: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from rhun.apana.org.au ([64.62.148.172]:1994 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752345AbXLGITv (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Fri, 7 Dec 2007 03:19:51 -0500
Received: from gondolin.me.apana.org.au ([192.168.0.6] ident=mail)
	by arnor.apana.org.au with esmtp (Exim 4.50 #1 (Debian))
	id 1J0YR1-0005Ec-HE
	for <linux-crypto@vger.kernel.org>; Fri, 07 Dec 2007 19:19:48 +1100
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

[CRYPTO] scatterwalk: Move scatterwalk.h to linux/crypto

The scatterwalk infrastructure is used by algorithms so it needs to
move out of crypto for future users that may live in drivers/crypto
or asm/*/crypto.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
---

 crypto/authenc.c             |    3 -
 crypto/blkcipher.c           |    2 
 crypto/digest.c              |    3 -
 crypto/gcm.c                 |    3 -
 crypto/internal.h            |   29 -----------
 crypto/scatterwalk.c         |    5 --
 crypto/scatterwalk.h         |   75 ------------------------------
 crypto/xcbc.c                |    2 
 include/crypto/scatterwalk.h |  107 +++++++++++++++++++++++++++++++++++++++++++
 9 files changed, 114 insertions(+), 115 deletions(-)

diff --git a/crypto/authenc.c b/crypto/authenc.c
index 6c9104e..fbbc2b5 100644
--- a/crypto/authenc.c
+++ b/crypto/authenc.c
@@ -12,6 +12,7 @@
 
 #include <crypto/algapi.h>
 #include <crypto/authenc.h>
+#include <crypto/scatterwalk.h>
 #include <linux/err.h>
 #include <linux/init.h>
 #include <linux/kernel.h>
@@ -20,8 +21,6 @@
 #include <linux/slab.h>
 #include <linux/spinlock.h>
 
-#include "scatterwalk.h"
-
 struct authenc_instance_ctx {
 	struct crypto_spawn auth;
 	struct crypto_spawn enc;
diff --git a/crypto/blkcipher.c b/crypto/blkcipher.c
index 180d914..7939504 100644
--- a/crypto/blkcipher.c
+++ b/crypto/blkcipher.c
@@ -14,6 +14,7 @@
  *
  */
 
+#include <crypto/scatterwalk.h>
 #include <linux/crypto.h>
 #include <linux/errno.h>
 #include <linux/hardirq.h>
@@ -25,7 +26,6 @@
 #include <linux/string.h>
 
 #include "internal.h"
-#include "scatterwalk.h"
 
 enum {
 	BLKCIPHER_WALK_PHYS = 1 << 0,
diff --git a/crypto/digest.c b/crypto/digest.c
index d3e827a..52845f5 100644
--- a/crypto/digest.c
+++ b/crypto/digest.c
@@ -12,6 +12,7 @@
  *
  */
 
+#include <crypto/scatterwalk.h>
 #include <linux/mm.h>
 #include <linux/errno.h>
 #include <linux/hardirq.h>
@@ -20,8 +21,6 @@
 #include <linux/module.h>
 #include <linux/scatterlist.h>
 
-#include "internal.h"
-
 static int init(struct hash_desc *desc)
 {
 	struct crypto_tfm *tfm = crypto_hash_tfm(desc->tfm);
diff --git a/crypto/gcm.c b/crypto/gcm.c
index d60c340..67cd067 100644
--- a/crypto/gcm.c
+++ b/crypto/gcm.c
@@ -10,14 +10,13 @@
 
 #include <crypto/algapi.h>
 #include <crypto/gf128mul.h>
+#include <crypto/scatterwalk.h>
 #include <linux/err.h>
 #include <linux/init.h>
 #include <linux/kernel.h>
 #include <linux/module.h>
 #include <linux/slab.h>
 
-#include "scatterwalk.h"
-
 struct gcm_instance_ctx {
 	struct crypto_spawn ctr;
 };
diff --git a/crypto/internal.h b/crypto/internal.h
index abb01f7..cb13952 100644
--- a/crypto/internal.h
+++ b/crypto/internal.h
@@ -25,7 +25,6 @@
 #include <linux/notifier.h>
 #include <linux/rwsem.h>
 #include <linux/slab.h>
-#include <asm/kmap_types.h>
 
 /* Crypto notification events. */
 enum {
@@ -50,34 +49,6 @@ extern struct list_head crypto_alg_list;
 extern struct rw_semaphore crypto_alg_sem;
 extern struct blocking_notifier_head crypto_chain;
 
-static inline enum km_type crypto_kmap_type(int out)
-{
-	enum km_type type;
-
-	if (in_softirq())
-		type = out * (KM_SOFTIRQ1 - KM_SOFTIRQ0) + KM_SOFTIRQ0;
-	else
-		type = out * (KM_USER1 - KM_USER0) + KM_USER0;
-
-	return type;
-}
-
-static inline void *crypto_kmap(struct page *page, int out)
-{
-	return kmap_atomic(page, crypto_kmap_type(out));
-}
-
-static inline void crypto_kunmap(void *vaddr, int out)
-{
-	kunmap_atomic(vaddr, crypto_kmap_type(out));
-}
-
-static inline void crypto_yield(u32 flags)
-{
-	if (flags & CRYPTO_TFM_REQ_MAY_SLEEP)
-		cond_resched();
-}
-
 #ifdef CONFIG_PROC_FS
 void __init crypto_init_proc(void);
 void __exit crypto_exit_proc(void);
diff --git a/crypto/scatterwalk.c b/crypto/scatterwalk.c
index 206c39a..12d1901 100644
--- a/crypto/scatterwalk.c
+++ b/crypto/scatterwalk.c
@@ -13,6 +13,8 @@
  * any later version.
  *
  */
+
+#include <crypto/scatterwalk.h>
 #include <linux/kernel.h>
 #include <linux/mm.h>
 #include <linux/module.h>
@@ -20,9 +22,6 @@
 #include <linux/highmem.h>
 #include <linux/scatterlist.h>
 
-#include "internal.h"
-#include "scatterwalk.h"
-
 static inline void memcpy_dir(void *buf, void *sgdata, size_t nbytes, int out)
 {
 	void *src = out ? buf : sgdata;
diff --git a/crypto/scatterwalk.h b/crypto/scatterwalk.h
deleted file mode 100644
index fd5517d..0000000
--- a/crypto/scatterwalk.h
+++ /dev/null
@@ -1,75 +0,0 @@
-/*
- * Cryptographic API.
- *
- * Copyright (c) 2002 James Morris <jmorris@intercode.com.au>
- * Copyright (c) 2002 Adam J. Richter <adam@yggdrasil.com>
- * Copyright (c) 2004 Jean-Luc Cooke <jlcooke@certainkey.com>
- *
- * This program is free software; you can redistribute it and/or modify it
- * under the terms of the GNU General Public License as published by the Free
- * Software Foundation; either version 2 of the License, or (at your option)
- * any later version.
- *
- */
-
-#ifndef _CRYPTO_SCATTERWALK_H
-#define _CRYPTO_SCATTERWALK_H
-
-#include <linux/mm.h>
-#include <linux/scatterlist.h>
-
-#include "internal.h"
-
-static inline unsigned long scatterwalk_samebuf(struct scatter_walk *walk_in,
-						struct scatter_walk *walk_out)
-{
-	return !(((sg_page(walk_in->sg) - sg_page(walk_out->sg)) << PAGE_SHIFT) +
-		 (int)(walk_in->offset - walk_out->offset));
-}
-
-static inline unsigned int scatterwalk_pagelen(struct scatter_walk *walk)
-{
-	unsigned int len = walk->sg->offset + walk->sg->length - walk->offset;
-	unsigned int len_this_page = offset_in_page(~walk->offset) + 1;
-	return len_this_page > len ? len : len_this_page;
-}
-
-static inline unsigned int scatterwalk_clamp(struct scatter_walk *walk,
-					     unsigned int nbytes)
-{
-	unsigned int len_this_page = scatterwalk_pagelen(walk);
-	return nbytes > len_this_page ? len_this_page : nbytes;
-}
-
-static inline void scatterwalk_advance(struct scatter_walk *walk,
-				       unsigned int nbytes)
-{
-	walk->offset += nbytes;
-}
-
-static inline unsigned int scatterwalk_aligned(struct scatter_walk *walk,
-					       unsigned int alignmask)
-{
-	return !(walk->offset & alignmask);
-}
-
-static inline struct page *scatterwalk_page(struct scatter_walk *walk)
-{
-	return sg_page(walk->sg) + (walk->offset >> PAGE_SHIFT);
-}
-
-static inline void scatterwalk_unmap(void *vaddr, int out)
-{
-	crypto_kunmap(vaddr, out);
-}
-
-void scatterwalk_start(struct scatter_walk *walk, struct scatterlist *sg);
-void scatterwalk_copychunks(void *buf, struct scatter_walk *walk,
-			    size_t nbytes, int out);
-void *scatterwalk_map(struct scatter_walk *walk, int out);
-void scatterwalk_done(struct scatter_walk *walk, int out, int more);
-
-void scatterwalk_map_and_copy(void *buf, struct scatterlist *sg,
-			      unsigned int start, unsigned int nbytes, int out);
-
-#endif  /* _CRYPTO_SCATTERWALK_H */
diff --git a/crypto/xcbc.c b/crypto/xcbc.c
index ac68f3b..789cdee 100644
--- a/crypto/xcbc.c
+++ b/crypto/xcbc.c
@@ -19,6 +19,7 @@
  * 	Kazunori Miyazawa <miyazawa@linux-ipv6.org>
  */
 
+#include <crypto/scatterwalk.h>
 #include <linux/crypto.h>
 #include <linux/err.h>
 #include <linux/hardirq.h>
@@ -27,7 +28,6 @@
 #include <linux/rtnetlink.h>
 #include <linux/slab.h>
 #include <linux/scatterlist.h>
-#include "internal.h"
 
 static u_int32_t ks[12] = {0x01010101, 0x01010101, 0x01010101, 0x01010101,
 			   0x02020202, 0x02020202, 0x02020202, 0x02020202,
diff --git a/include/crypto/scatterwalk.h b/include/crypto/scatterwalk.h
new file mode 100644
index 0000000..07b6f17
--- /dev/null
+++ b/include/crypto/scatterwalk.h
@@ -0,0 +1,107 @@
+/*
+ * Cryptographic scatter and gather helpers.
+ *
+ * Copyright (c) 2002 James Morris <jmorris@intercode.com.au>
+ * Copyright (c) 2002 Adam J. Richter <adam@yggdrasil.com>
+ * Copyright (c) 2004 Jean-Luc Cooke <jlcooke@certainkey.com>
+ * Copyright (c) 2007 Herbert Xu <herbert@gondor.apana.org.au>
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms of the GNU General Public License as published by the Free
+ * Software Foundation; either version 2 of the License, or (at your option)
+ * any later version.
+ *
+ */
+
+#ifndef _CRYPTO_SCATTERWALK_H
+#define _CRYPTO_SCATTERWALK_H
+
+#include <asm/kmap_types.h>
+#include <crypto/algapi.h>
+#include <linux/hardirq.h>
+#include <linux/highmem.h>
+#include <linux/kernel.h>
+#include <linux/mm.h>
+#include <linux/scatterlist.h>
+
+static inline enum km_type crypto_kmap_type(int out)
+{
+	enum km_type type;
+
+	if (in_softirq())
+		type = out * (KM_SOFTIRQ1 - KM_SOFTIRQ0) + KM_SOFTIRQ0;
+	else
+		type = out * (KM_USER1 - KM_USER0) + KM_USER0;
+
+	return type;
+}
+
+static inline void *crypto_kmap(struct page *page, int out)
+{
+	return kmap_atomic(page, crypto_kmap_type(out));
+}
+
+static inline void crypto_kunmap(void *vaddr, int out)
+{
+	kunmap_atomic(vaddr, crypto_kmap_type(out));
+}
+
+static inline void crypto_yield(u32 flags)
+{
+	if (flags & CRYPTO_TFM_REQ_MAY_SLEEP)
+		cond_resched();
+}
+
+static inline unsigned long scatterwalk_samebuf(struct scatter_walk *walk_in,
+						struct scatter_walk *walk_out)
+{
+	return !(((sg_page(walk_in->sg) - sg_page(walk_out->sg)) << PAGE_SHIFT) +
+		 (int)(walk_in->offset - walk_out->offset));
+}
+
+static inline unsigned int scatterwalk_pagelen(struct scatter_walk *walk)
+{
+	unsigned int len = walk->sg->offset + walk->sg->length - walk->offset;
+	unsigned int len_this_page = offset_in_page(~walk->offset) + 1;
+	return len_this_page > len ? len : len_this_page;
+}
+
+static inline unsigned int scatterwalk_clamp(struct scatter_walk *walk,
+					     unsigned int nbytes)
+{
+	unsigned int len_this_page = scatterwalk_pagelen(walk);
+	return nbytes > len_this_page ? len_this_page : nbytes;
+}
+
+static inline void scatterwalk_advance(struct scatter_walk *walk,
+				       unsigned int nbytes)
+{
+	walk->offset += nbytes;
+}
+
+static inline unsigned int scatterwalk_aligned(struct scatter_walk *walk,
+					       unsigned int alignmask)
+{
+	return !(walk->offset & alignmask);
+}
+
+static inline struct page *scatterwalk_page(struct scatter_walk *walk)
+{
+	return sg_page(walk->sg) + (walk->offset >> PAGE_SHIFT);
+}
+
+static inline void scatterwalk_unmap(void *vaddr, int out)
+{
+	crypto_kunmap(vaddr, out);
+}
+
+void scatterwalk_start(struct scatter_walk *walk, struct scatterlist *sg);
+void scatterwalk_copychunks(void *buf, struct scatter_walk *walk,
+			    size_t nbytes, int out);
+void *scatterwalk_map(struct scatter_walk *walk, int out);
+void scatterwalk_done(struct scatter_walk *walk, int out, int more);
+
+void scatterwalk_map_and_copy(void *buf, struct scatterlist *sg,
+			      unsigned int start, unsigned int nbytes, int out);
+
+#endif  /* _CRYPTO_SCATTERWALK_H */

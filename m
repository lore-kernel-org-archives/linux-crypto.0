From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 27/30] crypto: scatterwalk - Inline start/map/done
Date: Tue, 12 Jul 2016 13:18:00 +0800
Message-ID: <E1bMq52-0007VB-IW@gondolin.me.apana.org.au>
References: <20160712051554.GA28324@gondor.apana.org.au>
To: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:59054 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750972AbcGLFSE (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 12 Jul 2016 01:18:04 -0400
Received: from gondolin.me.apana.org.au ([192.168.0.6])
	by norbury.hengli.com.au with esmtp (Exim 4.80 #3 (Debian))
	id 1bMq52-0004iX-N9
	for <linux-crypto@vger.kernel.org>; Tue, 12 Jul 2016 15:18:00 +1000
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

This patch inlines the functions scatterwalk_start, scatterwalk_map
and scatterwalk_done as they're all tiny and mostly used by the block
cipher walker.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
---

 crypto/scatterwalk.c         |   43 ----------------------------------------
 include/crypto/scatterwalk.h |   46 +++++++++++++++++++++++++++++++++++++------
 2 files changed, 40 insertions(+), 49 deletions(-)

diff --git a/crypto/scatterwalk.c b/crypto/scatterwalk.c
index ddffbb3..52ce17a 100644
--- a/crypto/scatterwalk.c
+++ b/crypto/scatterwalk.c
@@ -18,8 +18,6 @@
 #include <linux/kernel.h>
 #include <linux/mm.h>
 #include <linux/module.h>
-#include <linux/pagemap.h>
-#include <linux/highmem.h>
 #include <linux/scatterlist.h>
 
 static inline void memcpy_dir(void *buf, void *sgdata, size_t nbytes, int out)
@@ -30,47 +28,6 @@ static inline void memcpy_dir(void *buf, void *sgdata, size_t nbytes, int out)
 	memcpy(dst, src, nbytes);
 }
 
-void scatterwalk_start(struct scatter_walk *walk, struct scatterlist *sg)
-{
-	walk->sg = sg;
-	walk->offset = sg->offset;
-}
-EXPORT_SYMBOL_GPL(scatterwalk_start);
-
-void *scatterwalk_map(struct scatter_walk *walk)
-{
-	return kmap_atomic(scatterwalk_page(walk)) +
-	       offset_in_page(walk->offset);
-}
-EXPORT_SYMBOL_GPL(scatterwalk_map);
-
-static void scatterwalk_pagedone(struct scatter_walk *walk, int out,
-				 unsigned int more)
-{
-	if (out) {
-		struct page *page;
-
-		page = sg_page(walk->sg) + ((walk->offset - 1) >> PAGE_SHIFT);
-		/* Test ARCH_IMPLEMENTS_FLUSH_DCACHE_PAGE first as
-		 * PageSlab cannot be optimised away per se due to
-		 * use of volatile pointer.
-		 */
-		if (ARCH_IMPLEMENTS_FLUSH_DCACHE_PAGE && !PageSlab(page))
-			flush_dcache_page(page);
-	}
-
-	if (more && walk->offset >= walk->sg->offset + walk->sg->length)
-		scatterwalk_start(walk, sg_next(walk->sg));
-}
-
-void scatterwalk_done(struct scatter_walk *walk, int out, int more)
-{
-	if (!more || walk->offset >= walk->sg->offset + walk->sg->length ||
-	    !(walk->offset & (PAGE_SIZE - 1)))
-		scatterwalk_pagedone(walk, out, more);
-}
-EXPORT_SYMBOL_GPL(scatterwalk_done);
-
 void scatterwalk_copychunks(void *buf, struct scatter_walk *walk,
 			    size_t nbytes, int out)
 {
diff --git a/include/crypto/scatterwalk.h b/include/crypto/scatterwalk.h
index 7e1a336..880e6be 100644
--- a/include/crypto/scatterwalk.h
+++ b/include/crypto/scatterwalk.h
@@ -16,14 +16,10 @@
 #ifndef _CRYPTO_SCATTERWALK_H
 #define _CRYPTO_SCATTERWALK_H
 
-#include <asm/kmap_types.h>
 #include <crypto/algapi.h>
-#include <linux/hardirq.h>
 #include <linux/highmem.h>
 #include <linux/kernel.h>
-#include <linux/mm.h>
 #include <linux/scatterlist.h>
-#include <linux/sched.h>
 
 static inline void scatterwalk_crypto_chain(struct scatterlist *head,
 					    struct scatterlist *sg,
@@ -83,11 +79,49 @@ static inline void scatterwalk_unmap(void *vaddr)
 	kunmap_atomic(vaddr);
 }
 
-void scatterwalk_start(struct scatter_walk *walk, struct scatterlist *sg);
+static inline void scatterwalk_start(struct scatter_walk *walk,
+				     struct scatterlist *sg)
+{
+	walk->sg = sg;
+	walk->offset = sg->offset;
+}
+
+static inline void *scatterwalk_map(struct scatter_walk *walk)
+{
+	return kmap_atomic(scatterwalk_page(walk)) +
+	       offset_in_page(walk->offset);
+}
+
+static inline void scatterwalk_pagedone(struct scatter_walk *walk, int out,
+					unsigned int more)
+{
+	if (out) {
+		struct page *page;
+
+		page = sg_page(walk->sg) + ((walk->offset - 1) >> PAGE_SHIFT);
+		/* Test ARCH_IMPLEMENTS_FLUSH_DCACHE_PAGE first as
+		 * PageSlab cannot be optimised away per se due to
+		 * use of volatile pointer.
+		 */
+		if (ARCH_IMPLEMENTS_FLUSH_DCACHE_PAGE && !PageSlab(page))
+			flush_dcache_page(page);
+	}
+
+	if (more && walk->offset >= walk->sg->offset + walk->sg->length)
+		scatterwalk_start(walk, sg_next(walk->sg));
+}
+
+static inline void scatterwalk_done(struct scatter_walk *walk, int out,
+				    int more)
+{
+	if (!more || walk->offset >= walk->sg->offset + walk->sg->length ||
+	    !(walk->offset & (PAGE_SIZE - 1)))
+		scatterwalk_pagedone(walk, out, more);
+}
+
 void scatterwalk_copychunks(void *buf, struct scatter_walk *walk,
 			    size_t nbytes, int out);
 void *scatterwalk_map(struct scatter_walk *walk);
-void scatterwalk_done(struct scatter_walk *walk, int out, int more);
 
 void scatterwalk_map_and_copy(void *buf, struct scatterlist *sg,
 			      unsigned int start, unsigned int nbytes, int out);

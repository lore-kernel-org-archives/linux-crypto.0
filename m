Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8618C1F416B
	for <linux-crypto@vger.kernel.org>; Tue,  4 Mar 2025 06:10:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741068625; cv=none; b=d4QEiZvaPwK0G6uQR77BvtKQFb6pf3QN5lTv8oOqWskLCrsvLJV7r06OW71UwGlieIU52I4Su0r6s6fRcDE3SXMWIAf+ztuqYQK71S7/fJNt4wpn+V+wVZNDPZfRG4wwipttU210zhLIKZDmk7EfC5jE3YJGU0cbAZiYKAmQVjI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741068625; c=relaxed/simple;
	bh=JJvmUfiAdjaMf3saa2kIG1wETTLCrXRHlUjXEu33r7k=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=B7Kohf4iTNi002RhQB2Ioz5XZv6zMRgIJc7usFk1otWJAyMFrXsrdepmSnLmxBRY4rbbGMeSXacYWcY61SvW2MVfeH38kASWlp9TFGQgcGougpK87XPPCsLcRoV4ntFOu7rnpuF1y0CbPyHpV20wXoRyY34AgeNN0DRfe4ltLb0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=Kfx0CiKN; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="Kfx0CiKN"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=jYFV4rSSTCccUrPh12MJ7dlU6kdUs0ysVOn6Eyqvajg=; b=Kfx0CiKNCq46lFMMo1CsYVk8Vv
	+FJbt8AIvRVirJUlXzvQU9WAS0uG2wMnCEkKA/9qJaaz/1izeoM7bwmwAC0mp9tLnDM4vmnchKNz4
	HoG6F2G7iubKMuCrQt9GwBVQ69xghJ1lPXZ91l+AIUACmzQSKRwG2jkO+2uzFMPEMBPDwFCkGsUhN
	fwK/UeTLAqnErdQfRe3RVC3BAI/HG+khjihHKxCozfxxZ4eVoJjioHSodByIdzxFRjalh/kbaR9dj
	XxNW7OzkWN2uRGqe8IzGLxSROSYHwHnufe0B/mCySJElfVUcV/d44Mb3g+ulokjnQpu0U8qA98LMz
	rMd7fK/w==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1tpLTh-003WcQ-2s;
	Tue, 04 Mar 2025 14:10:06 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Tue, 04 Mar 2025 14:10:05 +0800
Date: Tue, 4 Mar 2025 14:10:05 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Yosry Ahmed <yosry.ahmed@linux.dev>
Cc: Eric Biggers <ebiggers@kernel.org>,
	Sergey Senozhatsky <senozhatsky@chromium.org>,
	Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
	linux-mm@kvack.org
Subject: Re: [RFC PATCH 7/7] mm: zswap: Use acomp virtual address interface
Message-ID: <Z8aZPcgzuaNR6N8L@gondor.apana.org.au>
References: <20250227183847.GB1613@sol.localdomain>
 <Z8DcmK4eECXp3aws@google.com>
 <Z8FwFJ4iMLuvo3Jj@gondor.apana.org.au>
 <Z8GH7VssQGR1ujHV@gondor.apana.org.au>
 <Z8Hcur3T82_FiONj@google.com>
 <Z8KrAk9Y52RDox2U@gondor.apana.org.au>
 <Z8KxVC1RBeh8DTKI@gondor.apana.org.au>
 <Z8YOVyGugHwAsvmO@google.com>
 <Z8ZzqOw9veZ2HGkk@gondor.apana.org.au>
 <Z8aByQ5kJZf47wzW@google.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Z8aByQ5kJZf47wzW@google.com>

On Tue, Mar 04, 2025 at 04:30:01AM +0000, Yosry Ahmed wrote:
>
> Looking forward to this :)

Here is something that is entirely untested.  It doesn't depend
on my acomp patch-set and should apply on mainline.

commit 71955ecc7d6680386bb685f7f7f3951b5da9da9a
Author: Herbert Xu <herbert@gondor.apana.org.au>
Date:   Thu Feb 27 18:10:32 2025 +0800

    mm: zswap: Give non-linear objects to Crypto API
    
    Instead of copying non-linear objects into a buffer, use the
    scatterlist to give them directly to the Crypto API.
    
    Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>

diff --git a/include/linux/zpool.h b/include/linux/zpool.h
index a67d62b79698..0250a4f0760d 100644
--- a/include/linux/zpool.h
+++ b/include/linux/zpool.h
@@ -12,6 +12,7 @@
 #ifndef _ZPOOL_H_
 #define _ZPOOL_H_
 
+struct scatterlist;
 struct zpool;
 
 /*
@@ -53,6 +54,11 @@ void *zpool_map_handle(struct zpool *pool, unsigned long handle,
 
 void zpool_unmap_handle(struct zpool *pool, unsigned long handle);
 
+void zpool_map_sg(struct zpool *pool, unsigned long handle,
+		  enum zpool_mapmode mm, struct scatterlist *sg);
+
+void zpool_unmap_sg(struct zpool *pool, unsigned long handle);
+
 u64 zpool_get_total_pages(struct zpool *pool);
 
 
@@ -66,7 +72,9 @@ u64 zpool_get_total_pages(struct zpool *pool);
  * @free:	free mem from a pool.
  * @sleep_mapped: whether zpool driver can sleep during map.
  * @map:	map a handle.
+ * @map_sg:	map a handle into a two-entry SG list
  * @unmap:	unmap a handle.
+ * @unmap:	unmap a handle given to map_sg.
  * @total_size:	get total size of a pool.
  *
  * This is created by a zpool implementation and registered
@@ -89,7 +97,11 @@ struct zpool_driver {
 	bool sleep_mapped;
 	void *(*map)(void *pool, unsigned long handle,
 				enum zpool_mapmode mm);
+	void (*map_sg)(void *pool, unsigned long handle,
+				enum zpool_mapmode mm,
+				struct scatterlist *sg);
 	void (*unmap)(void *pool, unsigned long handle);
+	void (*unmap_sg)(void *pool, unsigned long handle);
 
 	u64 (*total_pages)(void *pool);
 };
diff --git a/mm/z3fold.c b/mm/z3fold.c
index 379d24b4fef9..7be8e3b3ba13 100644
--- a/mm/z3fold.c
+++ b/mm/z3fold.c
@@ -36,6 +36,7 @@
 #include <linux/percpu.h>
 #include <linux/preempt.h>
 #include <linux/workqueue.h>
+#include <linux/scatterlist.h>
 #include <linux/slab.h>
 #include <linux/spinlock.h>
 #include <linux/zpool.h>
@@ -1402,6 +1403,15 @@ static void z3fold_zpool_unmap(void *pool, unsigned long handle)
 	z3fold_unmap(pool, handle);
 }
 
+static void z3fold_zpool_map_sg(void *pool, unsigned long handle,
+				 enum zpool_mapmode mm,
+				 struct scatterlist sg[2])
+{
+	void *buf = z3fold_map(pool, handle);
+
+	sg_init_one(sg, buf, PAGE_SIZE - offset_in_page(buf));
+}
+
 static u64 z3fold_zpool_total_pages(void *pool)
 {
 	return z3fold_get_pool_pages(pool);
@@ -1416,6 +1426,7 @@ static struct zpool_driver z3fold_zpool_driver = {
 	.malloc =	z3fold_zpool_malloc,
 	.free =		z3fold_zpool_free,
 	.map =		z3fold_zpool_map,
+	.map_sg =	z3fold_zpool_map_sg,
 	.unmap =	z3fold_zpool_unmap,
 	.total_pages =	z3fold_zpool_total_pages,
 };
diff --git a/mm/zbud.c b/mm/zbud.c
index e9836fff9438..f6a4da93c985 100644
--- a/mm/zbud.c
+++ b/mm/zbud.c
@@ -49,6 +49,7 @@
 #include <linux/mm.h>
 #include <linux/module.h>
 #include <linux/preempt.h>
+#include <linux/scatterlist.h>
 #include <linux/slab.h>
 #include <linux/spinlock.h>
 #include <linux/zpool.h>
@@ -410,6 +411,14 @@ static void zbud_zpool_unmap(void *pool, unsigned long handle)
 	zbud_unmap(pool, handle);
 }
 
+static void zbud_zpool_map_sg(void *pool, unsigned long handle,
+			      enum zpool_mapmode mm, struct scatterlist sg[2])
+{
+	void *buf = (void *)handle;
+
+	sg_init_one(sg, buf, PAGE_SIZE - offset_in_page(buf));
+}
+
 static u64 zbud_zpool_total_pages(void *pool)
 {
 	return zbud_get_pool_pages(pool);
@@ -424,7 +433,9 @@ static struct zpool_driver zbud_zpool_driver = {
 	.malloc =	zbud_zpool_malloc,
 	.free =		zbud_zpool_free,
 	.map =		zbud_zpool_map,
+	.map_sg =	zbud_zpool_map_sg,
 	.unmap =	zbud_zpool_unmap,
+	.unmap_sg =	zbud_zpool_unmap,
 	.total_pages =	zbud_zpool_total_pages,
 };
 
diff --git a/mm/zpool.c b/mm/zpool.c
index b9fda1fa857d..120dbca8ca6e 100644
--- a/mm/zpool.c
+++ b/mm/zpool.c
@@ -13,6 +13,7 @@
 #include <linux/list.h>
 #include <linux/types.h>
 #include <linux/mm.h>
+#include <linux/scatterlist.h>
 #include <linux/slab.h>
 #include <linux/spinlock.h>
 #include <linux/module.h>
@@ -305,6 +306,33 @@ void *zpool_map_handle(struct zpool *zpool, unsigned long handle,
 	return zpool->driver->map(zpool->pool, handle, mapmode);
 }
 
+/**
+ * zpool_map_handle() - Map a previously allocated handle into an SG list
+ * @zpool:	The zpool that the handle was allocated from
+ * @handle:	The handle to map
+ * @mapmode:	How the memory should be mapped
+ * @sg:		2-entry SG list to store the mapping
+ *
+ * This maps a previously allocated handle into an SG list.  The
+ * @mapmode param indicates to the implementation how the memory
+ * will be * used, i.e. read-only, write-only, read-write.  If the
+ * implementation does not support it, the memory will be treated
+ * as read-write.
+ *
+ * This may hold locks, disable interrupts, and/or preemption,
+ * and the zpool_unmap_handle() must be called to undo those
+ * actions.  The code that uses the mapped handle should complete
+ * its operations on the mapped handle memory quickly and unmap
+ * as soon as possible.  As the implementation may use per-cpu
+ * data, multiple handles should not be mapped concurrently on
+ * any cpu.
+ */
+void zpool_map_sg(struct zpool *zpool, unsigned long handle,
+		   enum zpool_mapmode mapmode, struct scatterlist *sg)
+{
+	zpool->driver->map_sg(zpool->pool, handle, mapmode, sg);
+}
+
 /**
  * zpool_unmap_handle() - Unmap a previously mapped handle
  * @zpool:	The zpool that the handle was allocated from
@@ -320,6 +348,21 @@ void zpool_unmap_handle(struct zpool *zpool, unsigned long handle)
 	zpool->driver->unmap(zpool->pool, handle);
 }
 
+/**
+ * zpool_unmap_sg() - Unmap a previously SG-mapped handle
+ * @zpool:	The zpool that the handle was allocated from
+ * @handle:	The handle to unmap
+ *
+ * This unmaps a previously mapped handle.  Any locks or other
+ * actions that the implementation took in zpool_map_handle()
+ * will be undone here.  The memory area returned from
+ * zpool_map_handle() should no longer be used after this.
+ */
+void zpool_unmap_sg(struct zpool *zpool, unsigned long handle)
+{
+	zpool->driver->unmap_sg(zpool->pool, handle);
+}
+
 /**
  * zpool_get_total_pages() - The total size of the pool
  * @zpool:	The zpool to check
diff --git a/mm/zsmalloc.c b/mm/zsmalloc.c
index 6d0e47f7ae33..122294dd4105 100644
--- a/mm/zsmalloc.c
+++ b/mm/zsmalloc.c
@@ -49,6 +49,7 @@
 #include <linux/pagemap.h>
 #include <linux/fs.h>
 #include <linux/local_lock.h>
+#include <linux/scatterlist.h>
 #include "zpdesc.h"
 
 #define ZSPAGE_MAGIC	0x58
@@ -306,6 +307,10 @@ static void init_deferred_free(struct zs_pool *pool) {}
 static void SetZsPageMovable(struct zs_pool *pool, struct zspage *zspage) {}
 #endif
 
+static void zs_map_object_sg(struct zs_pool *pool, unsigned long handle,
+			     enum zs_mapmode mm, struct scatterlist sg[2]);
+static void zs_unmap_object_sg(struct zs_pool *pool, unsigned long handle);
+
 static int create_cache(struct zs_pool *pool)
 {
 	char *name;
@@ -426,6 +431,32 @@ static void zs_zpool_unmap(void *pool, unsigned long handle)
 	zs_unmap_object(pool, handle);
 }
 
+static void zs_zpool_map_sg(void *pool, unsigned long handle,
+			    enum zpool_mapmode mm, struct scatterlist sg[2])
+{
+	enum zs_mapmode zs_mm;
+
+	switch (mm) {
+	case ZPOOL_MM_RO:
+		zs_mm = ZS_MM_RO;
+		break;
+	case ZPOOL_MM_WO:
+		zs_mm = ZS_MM_WO;
+		break;
+	case ZPOOL_MM_RW:
+	default:
+		zs_mm = ZS_MM_RW;
+		break;
+	}
+
+	zs_map_object_sg(pool, handle, zs_mm, sg);
+}
+
+static void zs_zpool_unmap_sg(void *pool, unsigned long handle)
+{
+	zs_unmap_object_sg(pool, handle);
+}
+
 static u64 zs_zpool_total_pages(void *pool)
 {
 	return zs_get_total_pages(pool);
@@ -440,7 +471,9 @@ static struct zpool_driver zs_zpool_driver = {
 	.malloc =		  zs_zpool_malloc,
 	.free =			  zs_zpool_free,
 	.map =			  zs_zpool_map,
+	.map_sg =		  zs_zpool_map_sg,
 	.unmap =		  zs_zpool_unmap,
+	.unmap_sg =		  zs_zpool_unmap_sg,
 	.total_pages =		  zs_zpool_total_pages,
 };
 
@@ -1281,6 +1314,72 @@ void zs_unmap_object(struct zs_pool *pool, unsigned long handle)
 }
 EXPORT_SYMBOL_GPL(zs_unmap_object);
 
+static void zs_map_object_sg(struct zs_pool *pool, unsigned long handle,
+			     enum zs_mapmode mm, struct scatterlist sg[2])
+{
+	int handle_size = ZS_HANDLE_SIZE;
+	struct zspage *zspage;
+	struct zpdesc *zpdesc;
+	unsigned long obj, off;
+	unsigned int obj_idx;
+
+	struct size_class *class;
+	struct zpdesc *zpdescs[2];
+
+	/* It guarantees it can get zspage from handle safely */
+	read_lock(&pool->migrate_lock);
+	obj = handle_to_obj(handle);
+	obj_to_location(obj, &zpdesc, &obj_idx);
+	zspage = get_zspage(zpdesc);
+
+	/*
+	 * migration cannot move any zpages in this zspage. Here, class->lock
+	 * is too heavy since callers would take some time until they calls
+	 * zs_unmap_object API so delegate the locking from class to zspage
+	 * which is smaller granularity.
+	 */
+	migrate_read_lock(zspage);
+	read_unlock(&pool->migrate_lock);
+
+	class = zspage_class(pool, zspage);
+	off = offset_in_page(class->size * obj_idx);
+
+	if (unlikely(ZsHugePage(zspage)))
+		handle_size = 0;
+
+	if (off + class->size <= PAGE_SIZE) {
+		/* this object is contained entirely within a page */
+		sg_init_table(sg, 1);
+		sg_set_page(sg, zpdesc_page(zpdesc), class->size - handle_size,
+			    off + handle_size);
+		return;
+	}
+
+	/* this object spans two pages */
+	zpdescs[0] = zpdesc;
+	zpdescs[1] = get_next_zpdesc(zpdesc);
+	BUG_ON(!zpdescs[1]);
+
+	sg_init_table(sg, 2);
+	sg_set_page(sg, zpdesc_page(zpdescs[0]),
+		    PAGE_SIZE - off - handle_size, off + handle_size);
+	sg_set_page(&sg[1], zpdesc_page(zpdescs[1]),
+		    class->size - (PAGE_SIZE - off - handle_size), 0);
+}
+
+static void zs_unmap_object_sg(struct zs_pool *pool, unsigned long handle)
+{
+	struct zspage *zspage;
+	struct zpdesc *zpdesc;
+	unsigned int obj_idx;
+	unsigned long obj;
+
+	obj = handle_to_obj(handle);
+	obj_to_location(obj, &zpdesc, &obj_idx);
+	zspage = get_zspage(zpdesc);
+	migrate_read_unlock(zspage);
+}
+
 /**
  * zs_huge_class_size() - Returns the size (in bytes) of the first huge
  *                        zsmalloc &size_class.
diff --git a/mm/zswap.c b/mm/zswap.c
index 6504174fbc6a..004fdf26da61 100644
--- a/mm/zswap.c
+++ b/mm/zswap.c
@@ -13,6 +13,8 @@
 
 #define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
 
+#include <crypto/acompress.h>
+#include <crypto/scatterwalk.h>
 #include <linux/module.h>
 #include <linux/cpu.h>
 #include <linux/highmem.h>
@@ -26,7 +28,6 @@
 #include <linux/mempolicy.h>
 #include <linux/mempool.h>
 #include <linux/zpool.h>
-#include <crypto/acompress.h>
 #include <linux/zswap.h>
 #include <linux/mm_types.h>
 #include <linux/page-flags.h>
@@ -928,9 +929,9 @@ static bool zswap_compress(struct page *page, struct zswap_entry *entry,
 	struct scatterlist input, output;
 	int comp_ret = 0, alloc_ret = 0;
 	unsigned int dlen = PAGE_SIZE;
+	struct scatterlist sg[2];
 	unsigned long handle;
 	struct zpool *zpool;
-	char *buf;
 	gfp_t gfp;
 	u8 *dst;
 
@@ -972,9 +973,9 @@ static bool zswap_compress(struct page *page, struct zswap_entry *entry,
 	if (alloc_ret)
 		goto unlock;
 
-	buf = zpool_map_handle(zpool, handle, ZPOOL_MM_WO);
-	memcpy(buf, dst, dlen);
-	zpool_unmap_handle(zpool, handle);
+	zpool_map_sg(zpool, handle, ZPOOL_MM_WO, sg);
+	memcpy_to_sglist(sg, 0, dst, dlen);
+	zpool_unmap_sg(zpool, handle);
 
 	entry->handle = handle;
 	entry->length = dlen;
@@ -994,37 +995,19 @@ static bool zswap_compress(struct page *page, struct zswap_entry *entry,
 static void zswap_decompress(struct zswap_entry *entry, struct folio *folio)
 {
 	struct zpool *zpool = entry->pool->zpool;
-	struct scatterlist input, output;
 	struct crypto_acomp_ctx *acomp_ctx;
-	u8 *src;
+	struct scatterlist input[2];
+	struct scatterlist output;
 
 	acomp_ctx = acomp_ctx_get_cpu_lock(entry->pool);
-	src = zpool_map_handle(zpool, entry->handle, ZPOOL_MM_RO);
-	/*
-	 * If zpool_map_handle is atomic, we cannot reliably utilize its mapped buffer
-	 * to do crypto_acomp_decompress() which might sleep. In such cases, we must
-	 * resort to copying the buffer to a temporary one.
-	 * Meanwhile, zpool_map_handle() might return a non-linearly mapped buffer,
-	 * such as a kmap address of high memory or even ever a vmap address.
-	 * However, sg_init_one is only equipped to handle linearly mapped low memory.
-	 * In such cases, we also must copy the buffer to a temporary and lowmem one.
-	 */
-	if ((acomp_ctx->is_sleepable && !zpool_can_sleep_mapped(zpool)) ||
-	    !virt_addr_valid(src)) {
-		memcpy(acomp_ctx->buffer, src, entry->length);
-		src = acomp_ctx->buffer;
-		zpool_unmap_handle(zpool, entry->handle);
-	}
-
-	sg_init_one(&input, src, entry->length);
+	zpool_map_sg(zpool, entry->handle, ZPOOL_MM_RO, input);
 	sg_init_table(&output, 1);
 	sg_set_folio(&output, folio, PAGE_SIZE, 0);
-	acomp_request_set_params(acomp_ctx->req, &input, &output, entry->length, PAGE_SIZE);
+	acomp_request_set_params(acomp_ctx->req, input, &output, entry->length, PAGE_SIZE);
 	BUG_ON(crypto_wait_req(crypto_acomp_decompress(acomp_ctx->req), &acomp_ctx->wait));
 	BUG_ON(acomp_ctx->req->dlen != PAGE_SIZE);
 
-	if (src != acomp_ctx->buffer)
-		zpool_unmap_handle(zpool, entry->handle);
+	zpool_unmap_sg(zpool, entry->handle);
 	acomp_ctx_put_unlock(acomp_ctx);
 }
 
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt

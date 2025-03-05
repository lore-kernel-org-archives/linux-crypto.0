Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 802822E3388
	for <linux-crypto@vger.kernel.org>; Wed,  5 Mar 2025 03:41:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741146079; cv=none; b=OLdYTFHEvWiHHOO6Yu94xwIwalKyINfrd4KYhmT2+4oigvHxJcv09OBC26T93lWsCXTFJ+qxi5DqPay2L0TcmIN/uddFHQVCVAJza+bvRaNl+jpbSXrZQk/u8cTYLL5fOrUdQdRHCcUJpBzwEpEh7/9mQf91o1Yr3cCI7hJOyGY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741146079; c=relaxed/simple;
	bh=AFPn6pEQ61ijnwAJGGJhXf35d1XhtDboU29Fk7/T29s=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=sb0mosxK6+PBJpcdohNotpzx0usAydbGVs8vguIkyxW8pVgX5nLkNOfoOm+2ldgFdEO8KykBWWtWM6LkLc4TpTDLOSh4DPlxgkm/OED8c/n0QzuzhtGLGoYDjRM1qQWvSWPRGJAKazC6IZFYLQrCt3POSHKI63t1M9/CAGrNJmI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=sc3gwd7M; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="sc3gwd7M"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=bHE7t1tRizSwyF8M6lZmTHUDZxREfL0erI/FH/2rFVc=; b=sc3gwd7MIMj/rrJ8kGKm8TLNuk
	4/I/rvruzksrUiqTBAcPZagxzNUhZGRxK6qhJQ3gzUCFdbkaeLkWAJu1Z/QAce9XWuOQzKayOxxF/
	59CSVrzp7fb48+urjqIRToeO/fZy4ffApgbrAFse1CtPR+e/QHSTa2fvfFniQuRVY++4e+SkmwU2z
	BHKnIrRnfg3/uM4nHKxE5V1x3O7d5ghc/0JiJdLj5U6i0VcI3gZYd51+tIXwg0CoOR8sLqItDQtH3
	Lddm2kWQGcP3bn2kxA2Dr5Y/LGjNZKY72mTdOBqg2iZSboRyzmuNBm+oUD7s18vzDDJoZWR1sYI8m
	JHR8HUzw==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1tpfcw-003rgP-0V;
	Wed, 05 Mar 2025 11:40:59 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Wed, 05 Mar 2025 11:40:58 +0800
Date: Wed, 5 Mar 2025 11:40:58 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Sergey Senozhatsky <senozhatsky@chromium.org>
Cc: Yosry Ahmed <yosry.ahmed@linux.dev>, Eric Biggers <ebiggers@kernel.org>,
	Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
	linux-mm@kvack.org
Subject: Re: [RFC PATCH 7/7] mm: zswap: Use acomp virtual address interface
Message-ID: <Z8fHyvF3GNKeVw0k@gondor.apana.org.au>
References: <Z8FwFJ4iMLuvo3Jj@gondor.apana.org.au>
 <Z8GH7VssQGR1ujHV@gondor.apana.org.au>
 <Z8Hcur3T82_FiONj@google.com>
 <Z8KrAk9Y52RDox2U@gondor.apana.org.au>
 <Z8KxVC1RBeh8DTKI@gondor.apana.org.au>
 <Z8YOVyGugHwAsvmO@google.com>
 <Z8ZzqOw9veZ2HGkk@gondor.apana.org.au>
 <Z8aByQ5kJZf47wzW@google.com>
 <Z8aZPcgzuaNR6N8L@gondor.apana.org.au>
 <dawjvaf3nbfd6hnaclhcih6sfjzeuusu6kwhklv3bpptwwjzsd@t4ln7cwu74lh>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <dawjvaf3nbfd6hnaclhcih6sfjzeuusu6kwhklv3bpptwwjzsd@t4ln7cwu74lh>

On Tue, Mar 04, 2025 at 10:19:51PM +0900, Sergey Senozhatsky wrote:
>
> One thing to notice is that these functions don't actually map/unmap.

Fair enough.  I'll rename them to pin and unpin.

> And the handling is spread out over different parts of the stack,
> sg list is set in zsmalloc, but the actual zsmalloc map local page is
> done in crypto, and then zswap does memcpy() to write to object and so
> on.  The "new" zsmalloc map API, which we plan on landing soon, handles
> most of the things within zsmalloc.  Would it be possible to do something
> similar with the sg API?

If by mapping you're referring to kmap then it's only being done
in the Crypto API.  zswap is not doing any mappings with my patch,
even the copy to SG list operation after compression calls Crypto
API code (the newly introduced memcpy_to_sglist from crypto/scatterwalk.c.

The data is only ever read/written by Crypto API code so it
would seem to be more natural to map it when and where the
data is needed.

This also eliminates unnecessary mappings when the data is passed
to hardware offload, since there is no point in mapping the data
into CPU address space at all if it's only going to be accessed
with DMA.

> > @@ -972,9 +973,9 @@ static bool zswap_compress(struct page *page, struct zswap_entry *entry,
> >  	if (alloc_ret)
> >  		goto unlock;
> >  
> > -	buf = zpool_map_handle(zpool, handle, ZPOOL_MM_WO);
> > -	memcpy(buf, dst, dlen);
> > -	zpool_unmap_handle(zpool, handle);
> > +	zpool_map_sg(zpool, handle, ZPOOL_MM_WO, sg);
> > +	memcpy_to_sglist(sg, 0, dst, dlen);
> > +	zpool_unmap_sg(zpool, handle);
> 
> You can give zsmalloc a handle and a compressed buffer (u8) and
> zsmalloc should be able to figure it out.  WO direction map()
> seems, a bit, like an extra step.

Sure, this part can be dropped since your patch-set already provides
an interface for writing to the buffer.  Here is the same patch rebased
on top of your read_begin series.

commit d5891a27df516192e381047b4c79de4e9f7df4cd
Author: Herbert Xu <herbert@gondor.apana.org.au>
Date:   Thu Feb 27 18:10:32 2025 +0800

    mm: zswap: Give non-linear objects to Crypto API
    
    Instead of copying non-linear objects into a buffer, use the
    scatterlist to give them directly to the Crypto API.
    
    Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>

diff --git a/include/linux/zpool.h b/include/linux/zpool.h
index a67d62b79698..795f8e3ad964 100644
--- a/include/linux/zpool.h
+++ b/include/linux/zpool.h
@@ -12,27 +12,9 @@
 #ifndef _ZPOOL_H_
 #define _ZPOOL_H_
 
+struct scatterlist;
 struct zpool;
 
-/*
- * Control how a handle is mapped.  It will be ignored if the
- * implementation does not support it.  Its use is optional.
- * Note that this does not refer to memory protection, it
- * refers to how the memory will be copied in/out if copying
- * is necessary during mapping; read-write is the safest as
- * it copies the existing memory in on map, and copies the
- * changed memory back out on unmap.  Write-only does not copy
- * in the memory and should only be used for initialization.
- * If in doubt, use ZPOOL_MM_DEFAULT which is read-write.
- */
-enum zpool_mapmode {
-	ZPOOL_MM_RW, /* normal read-write mapping */
-	ZPOOL_MM_RO, /* read-only (no copy-out at unmap time) */
-	ZPOOL_MM_WO, /* write-only (no copy-in at map time) */
-
-	ZPOOL_MM_DEFAULT = ZPOOL_MM_RW
-};
-
 bool zpool_has_pool(char *type);
 
 struct zpool *zpool_create_pool(const char *type, const char *name, gfp_t gfp);
@@ -48,10 +30,13 @@ int zpool_malloc(struct zpool *pool, size_t size, gfp_t gfp,
 
 void zpool_free(struct zpool *pool, unsigned long handle);
 
-void *zpool_map_handle(struct zpool *pool, unsigned long handle,
-			enum zpool_mapmode mm);
+void zpool_pin_handle(struct zpool *pool, unsigned long handle,
+		      struct scatterlist *sg);
 
-void zpool_unmap_handle(struct zpool *pool, unsigned long handle);
+void zpool_unpin_handle(struct zpool *pool, unsigned long handle);
+
+void zpool_write_handle(struct zpool *pool, unsigned long handle,
+			void *handle_mem, size_t mem_len);
 
 u64 zpool_get_total_pages(struct zpool *pool);
 
@@ -64,9 +49,9 @@ u64 zpool_get_total_pages(struct zpool *pool);
  * @destroy:	destroy a pool.
  * @malloc:	allocate mem from a pool.
  * @free:	free mem from a pool.
- * @sleep_mapped: whether zpool driver can sleep during map.
- * @map:	map a handle.
- * @unmap:	unmap a handle.
+ * @pin:	pin a handle and write it into a two-entry SG list.
+ * @unpin:	unpin a handle.
+ * @write:	write buffer to a handle.
  * @total_size:	get total size of a pool.
  *
  * This is created by a zpool implementation and registered
@@ -86,10 +71,10 @@ struct zpool_driver {
 				unsigned long *handle);
 	void (*free)(void *pool, unsigned long handle);
 
-	bool sleep_mapped;
-	void *(*map)(void *pool, unsigned long handle,
-				enum zpool_mapmode mm);
-	void (*unmap)(void *pool, unsigned long handle);
+	void (*pin)(void *pool, unsigned long handle, struct scatterlist *sg);
+	void (*unpin)(void *pool, unsigned long handle);
+	void (*write)(void *pool, unsigned long handle,
+				void *handle_mem, size_t mem_len);
 
 	u64 (*total_pages)(void *pool);
 };
@@ -98,6 +83,4 @@ void zpool_register_driver(struct zpool_driver *driver);
 
 int zpool_unregister_driver(struct zpool_driver *driver);
 
-bool zpool_can_sleep_mapped(struct zpool *pool);
-
 #endif
diff --git a/include/linux/zsmalloc.h b/include/linux/zsmalloc.h
index 7d70983cf398..c26baf9fb331 100644
--- a/include/linux/zsmalloc.h
+++ b/include/linux/zsmalloc.h
@@ -16,23 +16,6 @@
 
 #include <linux/types.h>
 
-/*
- * zsmalloc mapping modes
- *
- * NOTE: These only make a difference when a mapped object spans pages.
- */
-enum zs_mapmode {
-	ZS_MM_RW, /* normal read-write mapping */
-	ZS_MM_RO, /* read-only (no copy-out at unmap time) */
-	ZS_MM_WO /* write-only (no copy-in at map time) */
-	/*
-	 * NOTE: ZS_MM_WO should only be used for initializing new
-	 * (uninitialized) allocations.  Partial writes to already
-	 * initialized allocations should use ZS_MM_RW to preserve the
-	 * existing data.
-	 */
-};
-
 struct zs_pool_stats {
 	/* How many pages were migrated (freed) */
 	atomic_long_t pages_compacted;
@@ -48,10 +31,6 @@ void zs_free(struct zs_pool *pool, unsigned long obj);
 
 size_t zs_huge_class_size(struct zs_pool *pool);
 
-void *zs_map_object(struct zs_pool *pool, unsigned long handle,
-			enum zs_mapmode mm);
-void zs_unmap_object(struct zs_pool *pool, unsigned long handle);
-
 unsigned long zs_get_total_pages(struct zs_pool *pool);
 unsigned long zs_compact(struct zs_pool *pool);
 
diff --git a/mm/z3fold.c b/mm/z3fold.c
index 379d24b4fef9..f0dc45cf9138 100644
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
@@ -1392,16 +1393,28 @@ static void z3fold_zpool_free(void *pool, unsigned long handle)
 	z3fold_free(pool, handle);
 }
 
-static void *z3fold_zpool_map(void *pool, unsigned long handle,
-			enum zpool_mapmode mm)
+static void z3fold_zpool_pin(void *pool, unsigned long handle,
+			     struct scatterlist sg[2])
 {
-	return z3fold_map(pool, handle);
+	void *buf = z3fold_map(pool, handle);
+
+	sg_init_one(sg, buf, PAGE_SIZE - offset_in_page(buf));
 }
-static void z3fold_zpool_unmap(void *pool, unsigned long handle)
+
+static void z3fold_zpool_unpin(void *pool, unsigned long handle)
 {
 	z3fold_unmap(pool, handle);
 }
 
+static void z3fold_zpool_write(void *pool, unsigned long handle,
+			       void *handle_mem, size_t mem_len)
+{
+	void *buf = z3fold_map(pool, handle);
+
+	memcpy(buf, handle_mem, mem_len);
+	z3fold_unmap(pool, handle);
+}
+
 static u64 z3fold_zpool_total_pages(void *pool)
 {
 	return z3fold_get_pool_pages(pool);
@@ -1409,14 +1422,14 @@ static u64 z3fold_zpool_total_pages(void *pool)
 
 static struct zpool_driver z3fold_zpool_driver = {
 	.type =		"z3fold",
-	.sleep_mapped = true,
 	.owner =	THIS_MODULE,
 	.create =	z3fold_zpool_create,
 	.destroy =	z3fold_zpool_destroy,
 	.malloc =	z3fold_zpool_malloc,
 	.free =		z3fold_zpool_free,
-	.map =		z3fold_zpool_map,
-	.unmap =	z3fold_zpool_unmap,
+	.pin =		z3fold_zpool_pin,
+	.unpin =	z3fold_zpool_unpin,
+	.write =	z3fold_zpool_write,
 	.total_pages =	z3fold_zpool_total_pages,
 };
 
diff --git a/mm/zbud.c b/mm/zbud.c
index e9836fff9438..21c0a9c26abe 100644
--- a/mm/zbud.c
+++ b/mm/zbud.c
@@ -36,10 +36,9 @@
  *
  * The zbud API differs from that of conventional allocators in that the
  * allocation function, zbud_alloc(), returns an opaque handle to the user,
- * not a dereferenceable pointer.  The user must map the handle using
- * zbud_map() in order to get a usable pointer by which to access the
- * allocation data and unmap the handle with zbud_unmap() when operations
- * on the allocation data are complete.
+ * not a dereferenceable pointer.  The user must pin the handle using
+ * zbud_pin() in order to access the allocation data and unpin the handle
+ * with zbud_unpin() when operations on the allocation data are complete.
  */
 
 #define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
@@ -49,6 +48,7 @@
 #include <linux/mm.h>
 #include <linux/module.h>
 #include <linux/preempt.h>
+#include <linux/scatterlist.h>
 #include <linux/slab.h>
 #include <linux/spinlock.h>
 #include <linux/zpool.h>
@@ -339,28 +339,30 @@ static void zbud_free(struct zbud_pool *pool, unsigned long handle)
 }
 
 /**
- * zbud_map() - maps the allocation associated with the given handle
+ * zbud_pin() - pins the allocation associated with the given handle
  * @pool:	pool in which the allocation resides
- * @handle:	handle associated with the allocation to be mapped
+ * @handle:	handle associated with the allocation to be pinned
+ * @sg:		2-entry scatter list to store the memory pointers
  *
- * While trivial for zbud, the mapping functions for others allocators
+ * While trivial for zbud, the pinning functions for others allocators
  * implementing this allocation API could have more complex information encoded
  * in the handle and could create temporary mappings to make the data
  * accessible to the user.
- *
- * Returns: a pointer to the mapped allocation
  */
-static void *zbud_map(struct zbud_pool *pool, unsigned long handle)
+static void zbud_pin(struct zbud_pool *pool, unsigned long handle,
+		      struct scatterlist sg[2])
 {
-	return (void *)(handle);
+	void *buf = (void *)handle;
+
+	sg_init_one(sg, buf, PAGE_SIZE - offset_in_page(buf));
 }
 
 /**
- * zbud_unmap() - maps the allocation associated with the given handle
+ * zbud_unpin() - unpins the allocation associated with the given handle
  * @pool:	pool in which the allocation resides
- * @handle:	handle associated with the allocation to be unmapped
+ * @handle:	handle associated with the allocation to be unpinned
  */
-static void zbud_unmap(struct zbud_pool *pool, unsigned long handle)
+static void zbud_unpin(struct zbud_pool *pool, unsigned long handle)
 {
 }
 
@@ -400,14 +402,20 @@ static void zbud_zpool_free(void *pool, unsigned long handle)
 	zbud_free(pool, handle);
 }
 
-static void *zbud_zpool_map(void *pool, unsigned long handle,
-			enum zpool_mapmode mm)
+static void zbud_zpool_pin(void *pool, unsigned long handle,
+			   struct scatterlist sg[2])
 {
-	return zbud_map(pool, handle);
+	zbud_pin(pool, handle, sg);
 }
-static void zbud_zpool_unmap(void *pool, unsigned long handle)
+static void zbud_zpool_unpin(void *pool, unsigned long handle)
 {
-	zbud_unmap(pool, handle);
+	zbud_unpin(pool, handle);
+}
+
+static void zbud_zpool_write(void *pool, unsigned long handle,
+			     void *handle_mem, size_t mem_len)
+{
+	memcpy((void *)handle, handle_mem, mem_len);
 }
 
 static u64 zbud_zpool_total_pages(void *pool)
@@ -417,14 +425,14 @@ static u64 zbud_zpool_total_pages(void *pool)
 
 static struct zpool_driver zbud_zpool_driver = {
 	.type =		"zbud",
-	.sleep_mapped = true,
 	.owner =	THIS_MODULE,
 	.create =	zbud_zpool_create,
 	.destroy =	zbud_zpool_destroy,
 	.malloc =	zbud_zpool_malloc,
 	.free =		zbud_zpool_free,
-	.map =		zbud_zpool_map,
-	.unmap =	zbud_zpool_unmap,
+	.pin =		zbud_zpool_pin,
+	.unpin =	zbud_zpool_unpin,
+	.write =	zbud_zpool_write,
 	.total_pages =	zbud_zpool_total_pages,
 };
 
diff --git a/mm/zpool.c b/mm/zpool.c
index b9fda1fa857d..304639959b90 100644
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
@@ -278,46 +279,53 @@ void zpool_free(struct zpool *zpool, unsigned long handle)
 }
 
 /**
- * zpool_map_handle() - Map a previously allocated handle into memory
+ * zpool_pin_handle() - Pin a previously allocated handle into memory
  * @zpool:	The zpool that the handle was allocated from
- * @handle:	The handle to map
- * @mapmode:	How the memory should be mapped
+ * @handle:	The handle to pin
+ * @sg:		2-entry scatterlist to store pointers to the memmory
  *
- * This maps a previously allocated handle into memory.  The @mapmode
- * param indicates to the implementation how the memory will be
- * used, i.e. read-only, write-only, read-write.  If the
- * implementation does not support it, the memory will be treated
- * as read-write.
+ * This pins a previously allocated handle into memory.
  *
  * This may hold locks, disable interrupts, and/or preemption,
- * and the zpool_unmap_handle() must be called to undo those
- * actions.  The code that uses the mapped handle should complete
- * its operations on the mapped handle memory quickly and unmap
- * as soon as possible.  As the implementation may use per-cpu
- * data, multiple handles should not be mapped concurrently on
- * any cpu.
- *
- * Returns: A pointer to the handle's mapped memory area.
+ * and the zpool_unpin_handle() must be called to undo those
+ * actions.  The code that uses the pinned handle should complete
+ * its operations on the pinned handle memory quickly and unpin
+ * as soon as possible.
  */
-void *zpool_map_handle(struct zpool *zpool, unsigned long handle,
-			enum zpool_mapmode mapmode)
+void zpool_pin_handle(struct zpool *zpool, unsigned long handle,
+		      struct scatterlist *sg)
 {
-	return zpool->driver->map(zpool->pool, handle, mapmode);
+	zpool->driver->pin(zpool->pool, handle, sg);
 }
 
 /**
- * zpool_unmap_handle() - Unmap a previously mapped handle
+ * zpool_unpin_handle() - Unpin a previously pinned handle
  * @zpool:	The zpool that the handle was allocated from
- * @handle:	The handle to unmap
+ * @handle:	The handle to unpin
  *
- * This unmaps a previously mapped handle.  Any locks or other
- * actions that the implementation took in zpool_map_handle()
+ * This unpins a previously pinned handle.  Any locks or other
+ * actions that the implementation took in zpool_pin_handle()
  * will be undone here.  The memory area returned from
- * zpool_map_handle() should no longer be used after this.
+ * zpool_pin_handle() should no longer be used after this.
  */
-void zpool_unmap_handle(struct zpool *zpool, unsigned long handle)
+void zpool_unpin_handle(struct zpool *zpool, unsigned long handle)
 {
-	zpool->driver->unmap(zpool->pool, handle);
+	zpool->driver->unpin(zpool->pool, handle);
+}
+
+/**
+ * zpool_write_handle() - Write to a previously allocated handle
+ * @zpool:	The zpool that the handle was allocated from
+ * @handle:	The handle to write
+ * @handle_mem:	Data to write from
+ * @mem_len:	Length of data to be written
+ *
+ * This writes data to a previously allocated handle.
+ */
+void zpool_write_handle(struct zpool *zpool, unsigned long handle,
+			void *handle_mem, size_t mem_len)
+{
+	zpool->driver->write(zpool->pool, handle, handle_mem, mem_len);
 }
 
 /**
@@ -333,23 +341,5 @@ u64 zpool_get_total_pages(struct zpool *zpool)
 	return zpool->driver->total_pages(zpool->pool);
 }
 
-/**
- * zpool_can_sleep_mapped - Test if zpool can sleep when do mapped.
- * @zpool:	The zpool to test
- *
- * Some allocators enter non-preemptible context in ->map() callback (e.g.
- * disable pagefaults) and exit that context in ->unmap(), which limits what
- * we can do with the mapped object. For instance, we cannot wait for
- * asynchronous crypto API to decompress such an object or take mutexes
- * since those will call into the scheduler. This function tells us whether
- * we use such an allocator.
- *
- * Returns: true if zpool can sleep; false otherwise.
- */
-bool zpool_can_sleep_mapped(struct zpool *zpool)
-{
-	return zpool->driver->sleep_mapped;
-}
-
 MODULE_AUTHOR("Dan Streetman <ddstreet@ieee.org>");
 MODULE_DESCRIPTION("Common API for compressed memory storage");
diff --git a/mm/zsmalloc.c b/mm/zsmalloc.c
index 63c99db71dc1..934b3be467e6 100644
--- a/mm/zsmalloc.c
+++ b/mm/zsmalloc.c
@@ -23,6 +23,7 @@
  *	zspage->lock
  */
 
+#include <crypto/scatterwalk.h>
 #include <linux/module.h>
 #include <linux/kernel.h>
 #include <linux/sched.h>
@@ -49,6 +50,7 @@
 #include <linux/pagemap.h>
 #include <linux/fs.h>
 #include <linux/local_lock.h>
+#include <linux/scatterlist.h>
 #include "zpdesc.h"
 
 #define ZSPAGE_MAGIC	0x58
@@ -281,13 +283,6 @@ struct zspage {
 	struct zspage_lock zsl;
 };
 
-struct mapping_area {
-	local_lock_t lock;
-	char *vm_buf; /* copy buffer for objects that span pages */
-	char *vm_addr; /* address of kmap_local_page()'ed pages */
-	enum zs_mapmode vm_mm; /* mapping mode */
-};
-
 static void zspage_lock_init(struct zspage *zspage)
 {
 	static struct lock_class_key __key;
@@ -453,6 +448,10 @@ static void record_obj(unsigned long handle, unsigned long obj)
 
 #ifdef CONFIG_ZPOOL
 
+static int zs_pin_object(struct zs_pool *pool, unsigned long handle,
+			 struct scatterlist sg[2]);
+static void zs_unpin_object(struct zs_pool *pool, unsigned long handle);
+
 static void *zs_zpool_create(const char *name, gfp_t gfp)
 {
 	/*
@@ -482,29 +481,21 @@ static void zs_zpool_free(void *pool, unsigned long handle)
 	zs_free(pool, handle);
 }
 
-static void *zs_zpool_map(void *pool, unsigned long handle,
-			enum zpool_mapmode mm)
+static void zs_zpool_pin(void *pool, unsigned long handle,
+			 struct scatterlist sg[2])
 {
-	enum zs_mapmode zs_mm;
-
-	switch (mm) {
-	case ZPOOL_MM_RO:
-		zs_mm = ZS_MM_RO;
-		break;
-	case ZPOOL_MM_WO:
-		zs_mm = ZS_MM_WO;
-		break;
-	case ZPOOL_MM_RW:
-	default:
-		zs_mm = ZS_MM_RW;
-		break;
-	}
-
-	return zs_map_object(pool, handle, zs_mm);
+	zs_pin_object(pool, handle, sg);
 }
-static void zs_zpool_unmap(void *pool, unsigned long handle)
+
+static void zs_zpool_unpin(void *pool, unsigned long handle)
 {
-	zs_unmap_object(pool, handle);
+	zs_unpin_object(pool, handle);
+}
+
+static void zs_zpool_write(void *pool, unsigned long handle,
+			   void *handle_mem, size_t mem_len)
+{
+	zs_obj_write(pool, handle, handle_mem, mem_len);
 }
 
 static u64 zs_zpool_total_pages(void *pool)
@@ -520,19 +511,15 @@ static struct zpool_driver zs_zpool_driver = {
 	.malloc_support_movable = true,
 	.malloc =		  zs_zpool_malloc,
 	.free =			  zs_zpool_free,
-	.map =			  zs_zpool_map,
-	.unmap =		  zs_zpool_unmap,
+	.pin =			  zs_zpool_pin,
+	.unpin =		  zs_zpool_unpin,
+	.write =		  zs_zpool_write,
 	.total_pages =		  zs_zpool_total_pages,
 };
 
 MODULE_ALIAS("zpool-zsmalloc");
 #endif /* CONFIG_ZPOOL */
 
-/* per-cpu VM mapping areas for zspage accesses that cross page boundaries */
-static DEFINE_PER_CPU(struct mapping_area, zs_map_area) = {
-	.lock	= INIT_LOCAL_LOCK(lock),
-};
-
 static inline bool __maybe_unused is_first_zpdesc(struct zpdesc *zpdesc)
 {
 	return PagePrivate(zpdesc_page(zpdesc));
@@ -1117,93 +1104,6 @@ static struct zspage *find_get_zspage(struct size_class *class)
 	return zspage;
 }
 
-static inline int __zs_cpu_up(struct mapping_area *area)
-{
-	/*
-	 * Make sure we don't leak memory if a cpu UP notification
-	 * and zs_init() race and both call zs_cpu_up() on the same cpu
-	 */
-	if (area->vm_buf)
-		return 0;
-	area->vm_buf = kmalloc(ZS_MAX_ALLOC_SIZE, GFP_KERNEL);
-	if (!area->vm_buf)
-		return -ENOMEM;
-	return 0;
-}
-
-static inline void __zs_cpu_down(struct mapping_area *area)
-{
-	kfree(area->vm_buf);
-	area->vm_buf = NULL;
-}
-
-static void *__zs_map_object(struct mapping_area *area,
-			struct zpdesc *zpdescs[2], int off, int size)
-{
-	size_t sizes[2];
-	char *buf = area->vm_buf;
-
-	/* disable page faults to match kmap_local_page() return conditions */
-	pagefault_disable();
-
-	/* no read fastpath */
-	if (area->vm_mm == ZS_MM_WO)
-		goto out;
-
-	sizes[0] = PAGE_SIZE - off;
-	sizes[1] = size - sizes[0];
-
-	/* copy object to per-cpu buffer */
-	memcpy_from_page(buf, zpdesc_page(zpdescs[0]), off, sizes[0]);
-	memcpy_from_page(buf + sizes[0], zpdesc_page(zpdescs[1]), 0, sizes[1]);
-out:
-	return area->vm_buf;
-}
-
-static void __zs_unmap_object(struct mapping_area *area,
-			struct zpdesc *zpdescs[2], int off, int size)
-{
-	size_t sizes[2];
-	char *buf;
-
-	/* no write fastpath */
-	if (area->vm_mm == ZS_MM_RO)
-		goto out;
-
-	buf = area->vm_buf;
-	buf = buf + ZS_HANDLE_SIZE;
-	size -= ZS_HANDLE_SIZE;
-	off += ZS_HANDLE_SIZE;
-
-	sizes[0] = PAGE_SIZE - off;
-	sizes[1] = size - sizes[0];
-
-	/* copy per-cpu buffer to object */
-	memcpy_to_page(zpdesc_page(zpdescs[0]), off, buf, sizes[0]);
-	memcpy_to_page(zpdesc_page(zpdescs[1]), 0, buf + sizes[0], sizes[1]);
-
-out:
-	/* enable page faults to match kunmap_local() return conditions */
-	pagefault_enable();
-}
-
-static int zs_cpu_prepare(unsigned int cpu)
-{
-	struct mapping_area *area;
-
-	area = &per_cpu(zs_map_area, cpu);
-	return __zs_cpu_up(area);
-}
-
-static int zs_cpu_dead(unsigned int cpu)
-{
-	struct mapping_area *area;
-
-	area = &per_cpu(zs_map_area, cpu);
-	__zs_cpu_down(area);
-	return 0;
-}
-
 static bool can_merge(struct size_class *prev, int pages_per_zspage,
 					int objs_per_zspage)
 {
@@ -1251,126 +1151,15 @@ unsigned long zs_get_total_pages(struct zs_pool *pool)
 }
 EXPORT_SYMBOL_GPL(zs_get_total_pages);
 
-/**
- * zs_map_object - get address of allocated object from handle.
- * @pool: pool from which the object was allocated
- * @handle: handle returned from zs_malloc
- * @mm: mapping mode to use
- *
- * Before using an object allocated from zs_malloc, it must be mapped using
- * this function. When done with the object, it must be unmapped using
- * zs_unmap_object.
- *
- * Only one object can be mapped per cpu at a time. There is no protection
- * against nested mappings.
- *
- * This function returns with preemption and page faults disabled.
- */
-void *zs_map_object(struct zs_pool *pool, unsigned long handle,
-			enum zs_mapmode mm)
-{
-	struct zspage *zspage;
-	struct zpdesc *zpdesc;
-	unsigned long obj, off;
-	unsigned int obj_idx;
-
-	struct size_class *class;
-	struct mapping_area *area;
-	struct zpdesc *zpdescs[2];
-	void *ret;
-
-	/*
-	 * Because we use per-cpu mapping areas shared among the
-	 * pools/users, we can't allow mapping in interrupt context
-	 * because it can corrupt another users mappings.
-	 */
-	BUG_ON(in_interrupt());
-
-	/* It guarantees it can get zspage from handle safely */
-	read_lock(&pool->lock);
-	obj = handle_to_obj(handle);
-	obj_to_location(obj, &zpdesc, &obj_idx);
-	zspage = get_zspage(zpdesc);
-
-	/*
-	 * migration cannot move any zpages in this zspage. Here, class->lock
-	 * is too heavy since callers would take some time until they calls
-	 * zs_unmap_object API so delegate the locking from class to zspage
-	 * which is smaller granularity.
-	 */
-	zspage_read_lock(zspage);
-	read_unlock(&pool->lock);
-
-	class = zspage_class(pool, zspage);
-	off = offset_in_page(class->size * obj_idx);
-
-	local_lock(&zs_map_area.lock);
-	area = this_cpu_ptr(&zs_map_area);
-	area->vm_mm = mm;
-	if (off + class->size <= PAGE_SIZE) {
-		/* this object is contained entirely within a page */
-		area->vm_addr = kmap_local_zpdesc(zpdesc);
-		ret = area->vm_addr + off;
-		goto out;
-	}
-
-	/* this object spans two pages */
-	zpdescs[0] = zpdesc;
-	zpdescs[1] = get_next_zpdesc(zpdesc);
-	BUG_ON(!zpdescs[1]);
-
-	ret = __zs_map_object(area, zpdescs, off, class->size);
-out:
-	if (likely(!ZsHugePage(zspage)))
-		ret += ZS_HANDLE_SIZE;
-
-	return ret;
-}
-EXPORT_SYMBOL_GPL(zs_map_object);
-
-void zs_unmap_object(struct zs_pool *pool, unsigned long handle)
-{
-	struct zspage *zspage;
-	struct zpdesc *zpdesc;
-	unsigned long obj, off;
-	unsigned int obj_idx;
-
-	struct size_class *class;
-	struct mapping_area *area;
-
-	obj = handle_to_obj(handle);
-	obj_to_location(obj, &zpdesc, &obj_idx);
-	zspage = get_zspage(zpdesc);
-	class = zspage_class(pool, zspage);
-	off = offset_in_page(class->size * obj_idx);
-
-	area = this_cpu_ptr(&zs_map_area);
-	if (off + class->size <= PAGE_SIZE)
-		kunmap_local(area->vm_addr);
-	else {
-		struct zpdesc *zpdescs[2];
-
-		zpdescs[0] = zpdesc;
-		zpdescs[1] = get_next_zpdesc(zpdesc);
-		BUG_ON(!zpdescs[1]);
-
-		__zs_unmap_object(area, zpdescs, off, class->size);
-	}
-	local_unlock(&zs_map_area.lock);
-
-	zspage_read_unlock(zspage);
-}
-EXPORT_SYMBOL_GPL(zs_unmap_object);
-
-void *zs_obj_read_begin(struct zs_pool *pool, unsigned long handle,
-			void *local_copy)
+static int zs_pin_object(struct zs_pool *pool, unsigned long handle,
+			 struct scatterlist sg[2])
 {
+	int handle_size = ZS_HANDLE_SIZE;
 	struct zspage *zspage;
 	struct zpdesc *zpdesc;
 	unsigned long obj, off;
 	unsigned int obj_idx;
 	struct size_class *class;
-	void *addr;
 
 	/* Guarantee we can get zspage from handle safely */
 	read_lock(&pool->lock);
@@ -1385,33 +1174,56 @@ void *zs_obj_read_begin(struct zs_pool *pool, unsigned long handle,
 	class = zspage_class(pool, zspage);
 	off = offset_in_page(class->size * obj_idx);
 
+	if (ZsHugePage(zspage))
+		handle_size = 0;
+
 	if (off + class->size <= PAGE_SIZE) {
 		/* this object is contained entirely within a page */
-		addr = kmap_local_zpdesc(zpdesc);
-		addr += off;
+		sg_init_table(sg, 1);
+		sg_set_page(sg, zpdesc_page(zpdesc),
+			    class->size - handle_size, off + handle_size);
 	} else {
 		size_t sizes[2];
 
 		/* this object spans two pages */
 		sizes[0] = PAGE_SIZE - off;
 		sizes[1] = class->size - sizes[0];
-		addr = local_copy;
 
-		memcpy_from_page(addr, zpdesc_page(zpdesc),
-				 off, sizes[0]);
+		sg_init_table(sg, 2);
+		sg_set_page(sg, zpdesc_page(zpdesc), sizes[0] - handle_size,
+			    off + handle_size);
 		zpdesc = get_next_zpdesc(zpdesc);
-		memcpy_from_page(addr + sizes[0],
-				 zpdesc_page(zpdesc),
-				 0, sizes[1]);
+		sg_set_page(&sg[1], zpdesc_page(zpdesc), sizes[1], 0);
 	}
 
-	if (!ZsHugePage(zspage))
-		addr += ZS_HANDLE_SIZE;
+	return class->size - handle_size;
+}
+
+void *zs_obj_read_begin(struct zs_pool *pool, unsigned long handle,
+			void *local_copy)
+{
+	struct scatterlist sg[2];
+	void *addr;
+	int len;
+
+	len = zs_pin_object(pool, handle, sg);
+	if (sg_is_last(sg)) {
+		addr = kmap_local_page(sg_page(sg));
+		addr += sg[0].offset;;
+	} else {
+		addr = local_copy;
+		memcpy_from_sglist(addr, sg, 0, len);
+	}
 
 	return addr;
 }
 EXPORT_SYMBOL_GPL(zs_obj_read_begin);
 
+static void zs_unpin_object(struct zs_pool *pool, unsigned long handle)
+{
+	zs_obj_read_end(pool, handle, NULL);
+}
+
 void zs_obj_read_end(struct zs_pool *pool, unsigned long handle,
 		     void *handle_mem)
 {
@@ -1427,7 +1239,7 @@ void zs_obj_read_end(struct zs_pool *pool, unsigned long handle,
 	class = zspage_class(pool, zspage);
 	off = offset_in_page(class->size * obj_idx);
 
-	if (off + class->size <= PAGE_SIZE) {
+	if (handle_mem && off + class->size <= PAGE_SIZE) {
 		if (!ZsHugePage(zspage))
 			off += ZS_HANDLE_SIZE;
 		handle_mem -= off;
@@ -1441,49 +1253,11 @@ EXPORT_SYMBOL_GPL(zs_obj_read_end);
 void zs_obj_write(struct zs_pool *pool, unsigned long handle,
 		  void *handle_mem, size_t mem_len)
 {
-	struct zspage *zspage;
-	struct zpdesc *zpdesc;
-	unsigned long obj, off;
-	unsigned int obj_idx;
-	struct size_class *class;
+	struct scatterlist sg[2];
 
-	/* Guarantee we can get zspage from handle safely */
-	read_lock(&pool->lock);
-	obj = handle_to_obj(handle);
-	obj_to_location(obj, &zpdesc, &obj_idx);
-	zspage = get_zspage(zpdesc);
-
-	/* Make sure migration doesn't move any pages in this zspage */
-	zspage_read_lock(zspage);
-	read_unlock(&pool->lock);
-
-	class = zspage_class(pool, zspage);
-	off = offset_in_page(class->size * obj_idx);
-
-	if (off + class->size <= PAGE_SIZE) {
-		/* this object is contained entirely within a page */
-		void *dst = kmap_local_zpdesc(zpdesc);
-
-		if (!ZsHugePage(zspage))
-			off += ZS_HANDLE_SIZE;
-		memcpy(dst + off, handle_mem, mem_len);
-		kunmap_local(dst);
-	} else {
-		/* this object spans two pages */
-		size_t sizes[2];
-
-		off += ZS_HANDLE_SIZE;
-		sizes[0] = PAGE_SIZE - off;
-		sizes[1] = mem_len - sizes[0];
-
-		memcpy_to_page(zpdesc_page(zpdesc), off,
-			       handle_mem, sizes[0]);
-		zpdesc = get_next_zpdesc(zpdesc);
-		memcpy_to_page(zpdesc_page(zpdesc), 0,
-			       handle_mem + sizes[0], sizes[1]);
-	}
-
-	zspage_read_unlock(zspage);
+	zs_pin_object(pool, handle, sg);
+	memcpy_to_sglist(sg, 0, handle_mem, mem_len);
+	zs_unpin_object(pool, handle);
 }
 EXPORT_SYMBOL_GPL(zs_obj_write);
 
@@ -2465,13 +2239,6 @@ EXPORT_SYMBOL_GPL(zs_destroy_pool);
 
 static int __init zs_init(void)
 {
-	int ret;
-
-	ret = cpuhp_setup_state(CPUHP_MM_ZS_PREPARE, "mm/zsmalloc:prepare",
-				zs_cpu_prepare, zs_cpu_dead);
-	if (ret)
-		goto out;
-
 #ifdef CONFIG_ZPOOL
 	zpool_register_driver(&zs_zpool_driver);
 #endif
@@ -2479,9 +2246,6 @@ static int __init zs_init(void)
 	zs_stat_init();
 
 	return 0;
-
-out:
-	return ret;
 }
 
 static void __exit zs_exit(void)
@@ -2489,7 +2253,6 @@ static void __exit zs_exit(void)
 #ifdef CONFIG_ZPOOL
 	zpool_unregister_driver(&zs_zpool_driver);
 #endif
-	cpuhp_remove_state(CPUHP_MM_ZS_PREPARE);
 
 	zs_stat_exit();
 }
diff --git a/mm/zswap.c b/mm/zswap.c
index 6504174fbc6a..74252187d763 100644
--- a/mm/zswap.c
+++ b/mm/zswap.c
@@ -147,7 +147,6 @@ struct crypto_acomp_ctx {
 	struct crypto_wait wait;
 	u8 *buffer;
 	struct mutex mutex;
-	bool is_sleepable;
 };
 
 /*
@@ -865,7 +864,6 @@ static int zswap_cpu_comp_prepare(unsigned int cpu, struct hlist_node *node)
 
 	acomp_ctx->buffer = buffer;
 	acomp_ctx->acomp = acomp;
-	acomp_ctx->is_sleepable = acomp_is_async(acomp);
 	acomp_ctx->req = req;
 	mutex_unlock(&acomp_ctx->mutex);
 	return 0;
@@ -930,7 +928,6 @@ static bool zswap_compress(struct page *page, struct zswap_entry *entry,
 	unsigned int dlen = PAGE_SIZE;
 	unsigned long handle;
 	struct zpool *zpool;
-	char *buf;
 	gfp_t gfp;
 	u8 *dst;
 
@@ -972,9 +969,7 @@ static bool zswap_compress(struct page *page, struct zswap_entry *entry,
 	if (alloc_ret)
 		goto unlock;
 
-	buf = zpool_map_handle(zpool, handle, ZPOOL_MM_WO);
-	memcpy(buf, dst, dlen);
-	zpool_unmap_handle(zpool, handle);
+	zpool_write_handle(zpool, handle, dst, dlen);
 
 	entry->handle = handle;
 	entry->length = dlen;
@@ -994,37 +989,19 @@ static bool zswap_compress(struct page *page, struct zswap_entry *entry,
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
+	zpool_pin_handle(zpool, entry->handle, input);
 	sg_init_table(&output, 1);
 	sg_set_folio(&output, folio, PAGE_SIZE, 0);
-	acomp_request_set_params(acomp_ctx->req, &input, &output, entry->length, PAGE_SIZE);
+	acomp_request_set_params(acomp_ctx->req, input, &output, entry->length, PAGE_SIZE);
 	BUG_ON(crypto_wait_req(crypto_acomp_decompress(acomp_ctx->req), &acomp_ctx->wait));
 	BUG_ON(acomp_ctx->req->dlen != PAGE_SIZE);
 
-	if (src != acomp_ctx->buffer)
-		zpool_unmap_handle(zpool, entry->handle);
+	zpool_unpin_handle(zpool, entry->handle);
 	acomp_ctx_put_unlock(acomp_ctx);
 }
 

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt

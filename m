From: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Subject: Re: [PATCH 2/2] zram: use crypto API to compress the page
Date: Thu, 13 Aug 2015 16:19:41 +0900
Message-ID: <20150813071941.GB13352@js1304-P5Q-DELUXE>
References: <1439432654-23322-1-git-send-email-iamjoonsoo.kim@lge.com>
 <1439432654-23322-2-git-send-email-iamjoonsoo.kim@lge.com>
 <20150813035113.GB17958@swordfish>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Minchan Kim <minchan@kernel.org>,
	Nitin Gupta <ngupta@vflare.org>, linux-kernel@vger.kernel.org,
	linux-crypto@vger.kernel.org,
	Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	Stephan Mueller <smueller@chronox.de>
To: Sergey Senozhatsky <sergey.senozhatsky.work@gmail.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20150813035113.GB17958@swordfish>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Thu, Aug 13, 2015 at 12:51:13PM +0900, Sergey Senozhatsky wrote:
> On (08/13/15 11:24), Joonsoo Kim wrote:
> > Until now, zram uses compression algorithm through direct call
> > to core algorithm function, but, it has drawback that we need to add
> > compression algorithm manually to zram if needed. Without this work,
> > we cannot utilize various compression algorithms in the system.
> > Moreover, to add new compression algorithm, we need to know how to use it
> > and this is somewhat time-consuming.
> > 
> 
> I don't like this change, sorry.
> 
> Here is why. One of the main reasons why I haven't implemented it using
> crypto API (and it was an option and I thought about it) was and still
> is the fact that crypto API requires tfm for both compress and decompress
> operations. And this is a show stopper. No matter how you implement it,
> it is slower than what we have by definition.

I don't think it is show stopper. Current implementation that uses zstrm
only for compression seems over-optimized thing to me. Some of other
compression algorithms need scratch-buffer to decompress the contents.
As you know, zlib is one of them. I tested some of other decompression
algorithm such as quicklz, wkdm and they also need scratch-buffer.

And, we cannot support crypto algorithm *module* in current
implementation.

If that optimization is really needed for the case that doesn't need
tfm except fetching function pointer, we can implement sharable tfm
in crypto subsystem.

> 
> Now zram_bvec_read() operations depends on:
> 
> a) other read operations
>    because read() path now use limited in size idle stream list
> 
> b) write operations
>    because write() path uses same idle streams list
> 
> 
> 
> Literally, you change zram_bvec_read() from a fast
> 
>   zram_decompress_page(zram, uncmem, index);
> 
> to a slow
> 
>   zstrm = zcomp_strm_find(zram->comp);
>   zram_decompress_page(zram, zstrm, uncmem, index);
>   zcomp_strm_release(zram->comp, zstrm);
> 
> 
> you either slow down both write() and read() if you use a single idle
> stream list for both read and write, or double the amount of memory
> used by idle streams if you decide to use separate read and write
> idle stream lists. I see no real reason to do either of those. I like
> that the existing read() is as fast as probably possible.

Yes, there can be some performace regression. But, by allocating some
more streams, we can easily eliminate regression. Memory overhead
would be really small. I think that gaining flexibility and reducing
management overhead can compensate this small memory overhead.

Thanks.

> 
> > When I tested new algorithms such as zlib, these problems make me hard
> > to test them. To prevent these problem in the future, I think that
> > using crypto API to compress the page is better approach and this patch
> > implements it.
> > 
> > The reason we need to support vairous compression algorithms is that
> > zram's performance is highly depend on workload and compression algorithm
> > and architecture. Every compression algorithm has it's own strong point.
> > For example, zlib is the best for compression ratio, but, it's
> > (de)compression speed is rather slow. Against my expectation, in my kernel
> > build test with zram swap, in low-memory condition on x86, zlib shows best
> > performance than others. In this case, I guess that compression ratio is
> > the most important factor. Unlike this situation, on ARM, maybe fast
> > (de)compression speed is the most important because it's computation speed
> > is slower than x86.
> > 
> > We can't expect what algorithm is the best fit for one's system, because
> > it needs too complex calculation. We need to test it in case by case and
> > easy to use new compression algorithm by this patch will help
> > that situation.
> > 
> > Signed-off-by: Joonsoo Kim <iamjoonsoo.kim@lge.com>
> > ---
> >  drivers/block/zram/Kconfig     | 13 +------
> >  drivers/block/zram/Makefile    |  4 +-
> >  drivers/block/zram/zcomp.c     | 87 ++++++++++++++++++------------------------
> >  drivers/block/zram/zcomp.h     | 34 +++++------------
> >  drivers/block/zram/zcomp_lz4.c | 47 -----------------------
> >  drivers/block/zram/zcomp_lz4.h | 17 ---------
> >  drivers/block/zram/zcomp_lzo.c | 47 -----------------------
> >  drivers/block/zram/zcomp_lzo.h | 17 ---------
> >  drivers/block/zram/zram_drv.c  | 28 +++++++++-----
> >  9 files changed, 66 insertions(+), 228 deletions(-)
> >  delete mode 100644 drivers/block/zram/zcomp_lz4.c
> >  delete mode 100644 drivers/block/zram/zcomp_lz4.h
> >  delete mode 100644 drivers/block/zram/zcomp_lzo.c
> >  delete mode 100644 drivers/block/zram/zcomp_lzo.h
> > 
> > diff --git a/drivers/block/zram/Kconfig b/drivers/block/zram/Kconfig
> > index 386ba3d..36ec96f 100644
> > --- a/drivers/block/zram/Kconfig
> > +++ b/drivers/block/zram/Kconfig
> > @@ -1,8 +1,7 @@
> >  config ZRAM
> >  	tristate "Compressed RAM block device support"
> >  	depends on BLOCK && SYSFS && ZSMALLOC
> > -	select LZO_COMPRESS
> > -	select LZO_DECOMPRESS
> > +	select CRYPTO_LZO
> >  	default n
> >  	help
> >  	  Creates virtual block devices called /dev/zramX (X = 0, 1, ...).
> > @@ -14,13 +13,3 @@ config ZRAM
> >  	  disks and maybe many more.
> >  
> >  	  See zram.txt for more information.
> > -
> > -config ZRAM_LZ4_COMPRESS
> > -	bool "Enable LZ4 algorithm support"
> > -	depends on ZRAM
> > -	select LZ4_COMPRESS
> > -	select LZ4_DECOMPRESS
> > -	default n
> > -	help
> > -	  This option enables LZ4 compression algorithm support. Compression
> > -	  algorithm can be changed using `comp_algorithm' device attribute.
> > \ No newline at end of file
> > diff --git a/drivers/block/zram/Makefile b/drivers/block/zram/Makefile
> > index be0763f..9e2b79e 100644
> > --- a/drivers/block/zram/Makefile
> > +++ b/drivers/block/zram/Makefile
> > @@ -1,5 +1,3 @@
> > -zram-y	:=	zcomp_lzo.o zcomp.o zram_drv.o
> > -
> > -zram-$(CONFIG_ZRAM_LZ4_COMPRESS) += zcomp_lz4.o
> > +zram-y	:=	zcomp.o zram_drv.o
> >  
> >  obj-$(CONFIG_ZRAM)	+=	zram.o
> > diff --git a/drivers/block/zram/zcomp.c b/drivers/block/zram/zcomp.c
> > index 965d1af..3dc9bfa 100644
> > --- a/drivers/block/zram/zcomp.c
> > +++ b/drivers/block/zram/zcomp.c
> > @@ -13,12 +13,9 @@
> >  #include <linux/slab.h>
> >  #include <linux/wait.h>
> >  #include <linux/sched.h>
> > +#include <linux/crypto.h>
> >  
> >  #include "zcomp.h"
> > -#include "zcomp_lzo.h"
> > -#ifdef CONFIG_ZRAM_LZ4_COMPRESS
> > -#include "zcomp_lz4.h"
> > -#endif
> >  
> >  /*
> >   * single zcomp_strm backend
> > @@ -43,36 +40,17 @@ struct zcomp_strm_multi {
> >  	wait_queue_head_t strm_wait;
> >  };
> >  
> > -static struct zcomp_backend *backends[] = {
> > -	&zcomp_lzo,
> > -#ifdef CONFIG_ZRAM_LZ4_COMPRESS
> > -	&zcomp_lz4,
> > -#endif
> > -	NULL
> > -};
> > -
> > -static struct zcomp_backend *find_backend(const char *compress)
> > -{
> > -	int i = 0;
> > -	while (backends[i]) {
> > -		if (sysfs_streq(compress, backends[i]->name))
> > -			break;
> > -		i++;
> > -	}
> > -	return backends[i];
> > -}
> > -
> >  static void zcomp_strm_free(struct zcomp *comp, struct zcomp_strm *zstrm)
> >  {
> > -	if (zstrm->private)
> > -		comp->backend->destroy(zstrm->private);
> > +	if (zstrm->tfm)
> > +		crypto_free_comp(zstrm->tfm);
> >  	free_pages((unsigned long)zstrm->buffer, 1);
> >  	kfree(zstrm);
> >  }
> >  
> >  /*
> > - * allocate new zcomp_strm structure with ->private initialized by
> > - * backend, return NULL on error
> > + * allocate new zcomp_strm structure with initializing crypto data structure,
> > + * return NULL on error
> >   */
> >  static struct zcomp_strm *zcomp_strm_alloc(struct zcomp *comp)
> >  {
> > @@ -80,13 +58,18 @@ static struct zcomp_strm *zcomp_strm_alloc(struct zcomp *comp)
> >  	if (!zstrm)
> >  		return NULL;
> >  
> > -	zstrm->private = comp->backend->create();
> > +	zstrm->tfm = crypto_alloc_comp(comp->name, 0, 0);
> > +	if (IS_ERR(zstrm->tfm)) {
> > +		kfree(zstrm);
> > +		return NULL;
> > +	}
> > +
> >  	/*
> >  	 * allocate 2 pages. 1 for compressed data, plus 1 extra for the
> >  	 * case when compressed size is larger than the original one
> >  	 */
> >  	zstrm->buffer = (void *)__get_free_pages(GFP_KERNEL | __GFP_ZERO, 1);
> > -	if (!zstrm->private || !zstrm->buffer) {
> > +	if (!zstrm->buffer) {
> >  		zcomp_strm_free(comp, zstrm);
> >  		zstrm = NULL;
> >  	}
> > @@ -270,25 +253,26 @@ static int zcomp_strm_single_create(struct zcomp *comp)
> >  /* show available compressors */
> >  ssize_t zcomp_available_show(const char *comp, char *buf)
> >  {
> > +	struct crypto_alg *alg;
> >  	ssize_t sz = 0;
> > -	int i = 0;
> >  
> > -	while (backends[i]) {
> > -		if (!strcmp(comp, backends[i]->name))
> > +	down_read(&crypto_alg_sem);
> > +	list_for_each_entry(alg, &crypto_alg_list, cra_list) {
> > +		if ((alg->cra_flags & CRYPTO_ALG_TYPE_MASK)
> > +			!= CRYPTO_ALG_TYPE_COMPRESS)
> > +			continue;
> > +
> > +		if (sysfs_streq(comp, alg->cra_name))
> >  			sz += scnprintf(buf + sz, PAGE_SIZE - sz - 2,
> > -					"[%s] ", backends[i]->name);
> > +					"[%s] ", alg->cra_name);
> >  		else
> >  			sz += scnprintf(buf + sz, PAGE_SIZE - sz - 2,
> > -					"%s ", backends[i]->name);
> > -		i++;
> > +					"%s ", alg->cra_name);
> >  	}
> >  	sz += scnprintf(buf + sz, PAGE_SIZE - sz, "\n");
> > -	return sz;
> > -}
> > +	up_read(&crypto_alg_sem);
> >  
> > -bool zcomp_available_algorithm(const char *comp)
> > -{
> > -	return find_backend(comp) != NULL;
> > +	return sz;
> >  }
> >  
> >  bool zcomp_set_max_streams(struct zcomp *comp, int num_strm)
> > @@ -307,16 +291,21 @@ void zcomp_strm_release(struct zcomp *comp, struct zcomp_strm *zstrm)
> >  }
> >  
> >  int zcomp_compress(struct zcomp *comp, struct zcomp_strm *zstrm,
> > -		const unsigned char *src, size_t *dst_len)
> > +			const unsigned char *src, unsigned int *dst_len)
> >  {
> > -	return comp->backend->compress(src, zstrm->buffer, dst_len,
> > -			zstrm->private);
> > +	*dst_len = PAGE_SIZE << 1;
> > +	return crypto_comp_compress(zstrm->tfm, src, PAGE_SIZE,
> > +					zstrm->buffer, dst_len);
> >  }
> >  
> > -int zcomp_decompress(struct zcomp *comp, const unsigned char *src,
> > -		size_t src_len, unsigned char *dst)
> > +int zcomp_decompress(struct zcomp *comp, struct zcomp_strm *zstrm,
> > +			const unsigned char *src, unsigned int src_len,
> > +			unsigned char *dst)
> >  {
> > -	return comp->backend->decompress(src, src_len, dst);
> > +	unsigned int size = PAGE_SIZE;
> > +
> > +	return crypto_comp_decompress(zstrm->tfm, src, src_len,
> > +					dst, &size);
> >  }
> >  
> >  void zcomp_destroy(struct zcomp *comp)
> > @@ -335,17 +324,15 @@ void zcomp_destroy(struct zcomp *comp)
> >  struct zcomp *zcomp_create(const char *compress, int max_strm)
> >  {
> >  	struct zcomp *comp;
> > -	struct zcomp_backend *backend;
> >  
> > -	backend = find_backend(compress);
> > -	if (!backend)
> > +	if (!crypto_has_comp(compress, 0, 0))
> >  		return ERR_PTR(-EINVAL);
> >  
> >  	comp = kzalloc(sizeof(struct zcomp), GFP_KERNEL);
> >  	if (!comp)
> >  		return ERR_PTR(-ENOMEM);
> >  
> > -	comp->backend = backend;
> > +	comp->name = compress;
> >  	if (max_strm > 1)
> >  		zcomp_strm_multi_create(comp, max_strm);
> >  	else
> > diff --git a/drivers/block/zram/zcomp.h b/drivers/block/zram/zcomp.h
> > index 46e2b9f..35f7f10 100644
> > --- a/drivers/block/zram/zcomp.h
> > +++ b/drivers/block/zram/zcomp.h
> > @@ -10,39 +10,23 @@
> >  #ifndef _ZCOMP_H_
> >  #define _ZCOMP_H_
> >  
> > +#include <linux/crypto.h>
> >  #include <linux/mutex.h>
> >  
> >  struct zcomp_strm {
> > +	struct crypto_comp *tfm;
> > +
> >  	/* compression/decompression buffer */
> >  	void *buffer;
> > -	/*
> > -	 * The private data of the compression stream, only compression
> > -	 * stream backend can touch this (e.g. compression algorithm
> > -	 * working memory)
> > -	 */
> > -	void *private;
> > +
> >  	/* used in multi stream backend, protected by backend strm_lock */
> >  	struct list_head list;
> >  };
> >  
> > -/* static compression backend */
> > -struct zcomp_backend {
> > -	int (*compress)(const unsigned char *src, unsigned char *dst,
> > -			size_t *dst_len, void *private);
> > -
> > -	int (*decompress)(const unsigned char *src, size_t src_len,
> > -			unsigned char *dst);
> > -
> > -	void *(*create)(void);
> > -	void (*destroy)(void *private);
> > -
> > -	const char *name;
> > -};
> > -
> >  /* dynamic per-device compression frontend */
> >  struct zcomp {
> >  	void *stream;
> > -	struct zcomp_backend *backend;
> > +	const char *name;
> >  
> >  	struct zcomp_strm *(*strm_find)(struct zcomp *comp);
> >  	void (*strm_release)(struct zcomp *comp, struct zcomp_strm *zstrm);
> > @@ -51,7 +35,6 @@ struct zcomp {
> >  };
> >  
> >  ssize_t zcomp_available_show(const char *comp, char *buf);
> > -bool zcomp_available_algorithm(const char *comp);
> >  
> >  struct zcomp *zcomp_create(const char *comp, int max_strm);
> >  void zcomp_destroy(struct zcomp *comp);
> > @@ -60,10 +43,11 @@ struct zcomp_strm *zcomp_strm_find(struct zcomp *comp);
> >  void zcomp_strm_release(struct zcomp *comp, struct zcomp_strm *zstrm);
> >  
> >  int zcomp_compress(struct zcomp *comp, struct zcomp_strm *zstrm,
> > -		const unsigned char *src, size_t *dst_len);
> > +			const unsigned char *src, unsigned int *dst_len);
> >  
> > -int zcomp_decompress(struct zcomp *comp, const unsigned char *src,
> > -		size_t src_len, unsigned char *dst);
> > +int zcomp_decompress(struct zcomp *comp, struct zcomp_strm *zstrm,
> > +			const unsigned char *src, unsigned int src_len,
> > +			unsigned char *dst);
> >  
> >  bool zcomp_set_max_streams(struct zcomp *comp, int num_strm);
> >  #endif /* _ZCOMP_H_ */
> > diff --git a/drivers/block/zram/zcomp_lz4.c b/drivers/block/zram/zcomp_lz4.c
> > deleted file mode 100644
> > index f2afb7e..0000000
> > --- a/drivers/block/zram/zcomp_lz4.c
> > +++ /dev/null
> > @@ -1,47 +0,0 @@
> > -/*
> > - * Copyright (C) 2014 Sergey Senozhatsky.
> > - *
> > - * This program is free software; you can redistribute it and/or
> > - * modify it under the terms of the GNU General Public License
> > - * as published by the Free Software Foundation; either version
> > - * 2 of the License, or (at your option) any later version.
> > - */
> > -
> > -#include <linux/kernel.h>
> > -#include <linux/slab.h>
> > -#include <linux/lz4.h>
> > -
> > -#include "zcomp_lz4.h"
> > -
> > -static void *zcomp_lz4_create(void)
> > -{
> > -	return kzalloc(LZ4_MEM_COMPRESS, GFP_KERNEL);
> > -}
> > -
> > -static void zcomp_lz4_destroy(void *private)
> > -{
> > -	kfree(private);
> > -}
> > -
> > -static int zcomp_lz4_compress(const unsigned char *src, unsigned char *dst,
> > -		size_t *dst_len, void *private)
> > -{
> > -	/* return  : Success if return 0 */
> > -	return lz4_compress(src, PAGE_SIZE, dst, dst_len, private);
> > -}
> > -
> > -static int zcomp_lz4_decompress(const unsigned char *src, size_t src_len,
> > -		unsigned char *dst)
> > -{
> > -	size_t dst_len = PAGE_SIZE;
> > -	/* return  : Success if return 0 */
> > -	return lz4_decompress_unknownoutputsize(src, src_len, dst, &dst_len);
> > -}
> > -
> > -struct zcomp_backend zcomp_lz4 = {
> > -	.compress = zcomp_lz4_compress,
> > -	.decompress = zcomp_lz4_decompress,
> > -	.create = zcomp_lz4_create,
> > -	.destroy = zcomp_lz4_destroy,
> > -	.name = "lz4",
> > -};
> > diff --git a/drivers/block/zram/zcomp_lz4.h b/drivers/block/zram/zcomp_lz4.h
> > deleted file mode 100644
> > index 60613fb..0000000
> > --- a/drivers/block/zram/zcomp_lz4.h
> > +++ /dev/null
> > @@ -1,17 +0,0 @@
> > -/*
> > - * Copyright (C) 2014 Sergey Senozhatsky.
> > - *
> > - * This program is free software; you can redistribute it and/or
> > - * modify it under the terms of the GNU General Public License
> > - * as published by the Free Software Foundation; either version
> > - * 2 of the License, or (at your option) any later version.
> > - */
> > -
> > -#ifndef _ZCOMP_LZ4_H_
> > -#define _ZCOMP_LZ4_H_
> > -
> > -#include "zcomp.h"
> > -
> > -extern struct zcomp_backend zcomp_lz4;
> > -
> > -#endif /* _ZCOMP_LZ4_H_ */
> > diff --git a/drivers/block/zram/zcomp_lzo.c b/drivers/block/zram/zcomp_lzo.c
> > deleted file mode 100644
> > index da1bc47..0000000
> > --- a/drivers/block/zram/zcomp_lzo.c
> > +++ /dev/null
> > @@ -1,47 +0,0 @@
> > -/*
> > - * Copyright (C) 2014 Sergey Senozhatsky.
> > - *
> > - * This program is free software; you can redistribute it and/or
> > - * modify it under the terms of the GNU General Public License
> > - * as published by the Free Software Foundation; either version
> > - * 2 of the License, or (at your option) any later version.
> > - */
> > -
> > -#include <linux/kernel.h>
> > -#include <linux/slab.h>
> > -#include <linux/lzo.h>
> > -
> > -#include "zcomp_lzo.h"
> > -
> > -static void *lzo_create(void)
> > -{
> > -	return kzalloc(LZO1X_MEM_COMPRESS, GFP_KERNEL);
> > -}
> > -
> > -static void lzo_destroy(void *private)
> > -{
> > -	kfree(private);
> > -}
> > -
> > -static int lzo_compress(const unsigned char *src, unsigned char *dst,
> > -		size_t *dst_len, void *private)
> > -{
> > -	int ret = lzo1x_1_compress(src, PAGE_SIZE, dst, dst_len, private);
> > -	return ret == LZO_E_OK ? 0 : ret;
> > -}
> > -
> > -static int lzo_decompress(const unsigned char *src, size_t src_len,
> > -		unsigned char *dst)
> > -{
> > -	size_t dst_len = PAGE_SIZE;
> > -	int ret = lzo1x_decompress_safe(src, src_len, dst, &dst_len);
> > -	return ret == LZO_E_OK ? 0 : ret;
> > -}
> > -
> > -struct zcomp_backend zcomp_lzo = {
> > -	.compress = lzo_compress,
> > -	.decompress = lzo_decompress,
> > -	.create = lzo_create,
> > -	.destroy = lzo_destroy,
> > -	.name = "lzo",
> > -};
> > diff --git a/drivers/block/zram/zcomp_lzo.h b/drivers/block/zram/zcomp_lzo.h
> > deleted file mode 100644
> > index 128c580..0000000
> > --- a/drivers/block/zram/zcomp_lzo.h
> > +++ /dev/null
> > @@ -1,17 +0,0 @@
> > -/*
> > - * Copyright (C) 2014 Sergey Senozhatsky.
> > - *
> > - * This program is free software; you can redistribute it and/or
> > - * modify it under the terms of the GNU General Public License
> > - * as published by the Free Software Foundation; either version
> > - * 2 of the License, or (at your option) any later version.
> > - */
> > -
> > -#ifndef _ZCOMP_LZO_H_
> > -#define _ZCOMP_LZO_H_
> > -
> > -#include "zcomp.h"
> > -
> > -extern struct zcomp_backend zcomp_lzo;
> > -
> > -#endif /* _ZCOMP_LZO_H_ */
> > diff --git a/drivers/block/zram/zram_drv.c b/drivers/block/zram/zram_drv.c
> > index b088ca9..84704d8 100644
> > --- a/drivers/block/zram/zram_drv.c
> > +++ b/drivers/block/zram/zram_drv.c
> > @@ -30,6 +30,7 @@
> >  #include <linux/err.h>
> >  #include <linux/idr.h>
> >  #include <linux/sysfs.h>
> > +#include <linux/crypto.h>
> >  
> >  #include "zram_drv.h"
> >  
> > @@ -349,7 +350,7 @@ out:
> >  static ssize_t comp_algorithm_show(struct device *dev,
> >  		struct device_attribute *attr, char *buf)
> >  {
> > -	size_t sz;
> > +	size_t sz = 0;
> >  	struct zram *zram = dev_to_zram(dev);
> >  
> >  	down_read(&zram->init_lock);
> > @@ -378,7 +379,7 @@ static ssize_t comp_algorithm_store(struct device *dev,
> >  	if (sz > 0 && zram->compressor[sz - 1] == '\n')
> >  		zram->compressor[sz - 1] = 0x00;
> >  
> > -	if (!zcomp_available_algorithm(zram->compressor))
> > +	if (!crypto_has_comp(zram->compressor, 0, 0))
> >  		len = -EINVAL;
> >  
> >  	up_write(&zram->init_lock);
> > @@ -562,13 +563,14 @@ static void zram_free_page(struct zram *zram, size_t index)
> >  	zram_set_obj_size(meta, index, 0);
> >  }
> >  
> > -static int zram_decompress_page(struct zram *zram, char *mem, u32 index)
> > +static int zram_decompress_page(struct zram *zram, struct zcomp_strm *zstrm,
> > +				char *mem, u32 index)
> >  {
> >  	int ret = 0;
> >  	unsigned char *cmem;
> >  	struct zram_meta *meta = zram->meta;
> >  	unsigned long handle;
> > -	size_t size;
> > +	unsigned int size;
> >  
> >  	bit_spin_lock(ZRAM_ACCESS, &meta->table[index].value);
> >  	handle = meta->table[index].handle;
> > @@ -584,7 +586,7 @@ static int zram_decompress_page(struct zram *zram, char *mem, u32 index)
> >  	if (size == PAGE_SIZE)
> >  		copy_page(mem, cmem);
> >  	else
> > -		ret = zcomp_decompress(zram->comp, cmem, size, mem);
> > +		ret = zcomp_decompress(zram->comp, zstrm, cmem, size, mem);
> >  	zs_unmap_object(meta->mem_pool, handle);
> >  	bit_spin_unlock(ZRAM_ACCESS, &meta->table[index].value);
> >  
> > @@ -604,6 +606,8 @@ static int zram_bvec_read(struct zram *zram, struct bio_vec *bvec,
> >  	struct page *page;
> >  	unsigned char *user_mem, *uncmem = NULL;
> >  	struct zram_meta *meta = zram->meta;
> > +	struct zcomp_strm *zstrm = NULL;
> > +
> >  	page = bvec->bv_page;
> >  
> >  	bit_spin_lock(ZRAM_ACCESS, &meta->table[index].value);
> > @@ -619,6 +623,7 @@ static int zram_bvec_read(struct zram *zram, struct bio_vec *bvec,
> >  		/* Use  a temporary buffer to decompress the page */
> >  		uncmem = kmalloc(PAGE_SIZE, GFP_NOIO);
> >  
> > +	zstrm = zcomp_strm_find(zram->comp);
> >  	user_mem = kmap_atomic(page);
> >  	if (!is_partial_io(bvec))
> >  		uncmem = user_mem;
> > @@ -629,7 +634,7 @@ static int zram_bvec_read(struct zram *zram, struct bio_vec *bvec,
> >  		goto out_cleanup;
> >  	}
> >  
> > -	ret = zram_decompress_page(zram, uncmem, index);
> > +	ret = zram_decompress_page(zram, zstrm, uncmem, index);
> >  	/* Should NEVER happen. Return bio error if it does. */
> >  	if (unlikely(ret))
> >  		goto out_cleanup;
> > @@ -642,6 +647,7 @@ static int zram_bvec_read(struct zram *zram, struct bio_vec *bvec,
> >  	ret = 0;
> >  out_cleanup:
> >  	kunmap_atomic(user_mem);
> > +	zcomp_strm_release(zram->comp, zstrm);
> >  	if (is_partial_io(bvec))
> >  		kfree(uncmem);
> >  	return ret;
> > @@ -651,7 +657,7 @@ static int zram_bvec_write(struct zram *zram, struct bio_vec *bvec, u32 index,
> >  			   int offset)
> >  {
> >  	int ret = 0;
> > -	size_t clen;
> > +	unsigned int clen;
> >  	unsigned long handle;
> >  	struct page *page;
> >  	unsigned char *user_mem, *cmem, *src, *uncmem = NULL;
> > @@ -670,12 +676,14 @@ static int zram_bvec_write(struct zram *zram, struct bio_vec *bvec, u32 index,
> >  			ret = -ENOMEM;
> >  			goto out;
> >  		}
> > -		ret = zram_decompress_page(zram, uncmem, index);
> > +		zstrm = zcomp_strm_find(zram->comp);
> > +		ret = zram_decompress_page(zram, zstrm, uncmem, index);
> >  		if (ret)
> >  			goto out;
> >  	}
> >  
> > -	zstrm = zcomp_strm_find(zram->comp);
> > +	if (!zstrm)
> > +		zstrm = zcomp_strm_find(zram->comp);
> >  	user_mem = kmap_atomic(page);
> >  
> >  	if (is_partial_io(bvec)) {
> > @@ -721,7 +729,7 @@ static int zram_bvec_write(struct zram *zram, struct bio_vec *bvec, u32 index,
> >  
> >  	handle = zs_malloc(meta->mem_pool, clen);
> >  	if (!handle) {
> > -		pr_info("Error allocating memory for compressed page: %u, size=%zu\n",
> > +		pr_info("Error allocating memory for compressed page: %u, size=%u\n",
> >  			index, clen);
> >  		ret = -ENOMEM;
> >  		goto out;
> > -- 
> > 1.9.1
> > 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

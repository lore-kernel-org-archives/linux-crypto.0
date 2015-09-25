From: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Subject: Re: [PATCH v3 8/9] zram: use crypto API for compression
Date: Fri, 25 Sep 2015 14:44:42 +0900
Message-ID: <20150925054441.GF7158@js1304-P5Q-DELUXE>
References: <1442553564-3476-1-git-send-email-iamjoonsoo.kim@lge.com>
 <1442553564-3476-9-git-send-email-iamjoonsoo.kim@lge.com>
 <20150921034512.GC27729@bbox>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Nitin Gupta <ngupta@vflare.org>,
	Sergey Senozhatsky <sergey.senozhatsky.work@gmail.com>,
	linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org,
	Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	Stephan Mueller <smueller@chronox.de>
To: Minchan Kim <minchan@kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from LGEAMRELO12.lge.com ([156.147.23.52]:42442 "EHLO
	lgeamrelo12.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754486AbbIYFnj (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Fri, 25 Sep 2015 01:43:39 -0400
Content-Disposition: inline
In-Reply-To: <20150921034512.GC27729@bbox>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Mon, Sep 21, 2015 at 12:45:12PM +0900, Minchan Kim wrote:
> Hi Joonsoo,
> 
> On Fri, Sep 18, 2015 at 02:19:23PM +0900, Joonsoo Kim wrote:
> > Until now, zram uses compression algorithm through direct call
> > to core algorithm function, but, it has drawback that we need to add
> > compression algorithm manually to zram if needed. Without this work,
> > we cannot utilize various compression algorithms in the system.
> > Moreover, to add new compression algorithm, we need to know how to use it
> > and this is somewhat time-consuming.
> > 
> > When I tested new algorithms such as zlib, these problems make me hard
> > to test them. To prevent these problem in the future, I think that
> > using crypto API for compression is better approach and this patch
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
> > There is one problem that crypto API requires tfm object to (de)compress
> > something and zram abstract it on zstrm which is very limited resource.
> > If number of zstrm is set to low and is contended, zram's performace could
> > be down-graded due to this change. But, following patch support to use
> > crypto decompress_noctx API and would restore the performance as is.
> > 
> > Signed-off-by: Joonsoo Kim <iamjoonsoo.kim@lge.com>
> > ---
> >  drivers/block/zram/Kconfig     |  8 +++----
> >  drivers/block/zram/Makefile    |  4 +---
> >  drivers/block/zram/zcomp.c     | 54 +++++++++++++++++++++++-------------------
> >  drivers/block/zram/zcomp.h     | 30 ++++++-----------------
> >  drivers/block/zram/zcomp_lz4.c | 47 ------------------------------------
> >  drivers/block/zram/zcomp_lz4.h | 17 -------------
> >  drivers/block/zram/zcomp_lzo.c | 47 ------------------------------------
> >  drivers/block/zram/zcomp_lzo.h | 17 -------------
> >  drivers/block/zram/zram_drv.c  |  6 ++---
> >  9 files changed, 44 insertions(+), 186 deletions(-)
> >  delete mode 100644 drivers/block/zram/zcomp_lz4.c
> >  delete mode 100644 drivers/block/zram/zcomp_lz4.h
> >  delete mode 100644 drivers/block/zram/zcomp_lzo.c
> >  delete mode 100644 drivers/block/zram/zcomp_lzo.h
> > 
> > diff --git a/drivers/block/zram/Kconfig b/drivers/block/zram/Kconfig
> > index 386ba3d..7619bed 100644
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
> > @@ -18,9 +17,8 @@ config ZRAM
> >  config ZRAM_LZ4_COMPRESS
> >  	bool "Enable LZ4 algorithm support"
> >  	depends on ZRAM
> > -	select LZ4_COMPRESS
> > -	select LZ4_DECOMPRESS
> > +	select CRYPTO_LZ4
> 
> It is out of my expectation.
> 
> When I heard crypto support for zRAM first, I imagined zram user can
> use any crypto compressor algorithm easily if system has the algorithm.
> IOW, I expect zRAM shouldn't bind CONFIG_CRYPTO_ALGONAME statically
> except the default one(ie, CONFIG_CRYPTO_LZO) like zswap and It seems
> you did in eariler version.
> 
> You seem to have a trouble to adapt crypto to current comp_algorithm
> because crypto doesn't export any API to enumerate algorithm name
> while zram should export supporting algorithm name via comp_algorithm
> and I heard crypto maintainer doesn't want to export it. Instead,
> user can use /proc/crypto to know what kinds of compressor system
> can support.
> 
> Hmm,
> At the first glance, I was about to say "let's sort it out with
> futher patches" but I changed my mind. ;-).
> 
> We should sort it out before you are adding zlib support(ie, please
> include zlib support patch with number data in this patchset). Otherwise,
> we should add new hard-wired stuff for zlib like lzo, lz4 to
> comp_algorithm and will depreate soon.
> 
> My idea is ABI change of comp_algorithm. Namely, let's deprecate it
> and guide to use /proc/crypto to show available compressor.
> Someday, we removes backends string array finally.

Okay! That's also what I want so I will follow your comment.

Thanks.
> 
> Welcome to any ideas.
> 
> >  	default n
> >  	help
> >  	  This option enables LZ4 compression algorithm support. Compression
> > -	  algorithm can be changed using `comp_algorithm' device attribute.
> > \ No newline at end of file
> > +	  algorithm can be changed using `comp_algorithm' device attribute.
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
> > index 3456d5a..c2ed7c8 100644
> > --- a/drivers/block/zram/zcomp.c
> > +++ b/drivers/block/zram/zcomp.c
> > @@ -15,10 +15,6 @@
> >  #include <linux/sched.h>
> >  
> >  #include "zcomp.h"
> > -#include "zcomp_lzo.h"
> > -#ifdef CONFIG_ZRAM_LZ4_COMPRESS
> > -#include "zcomp_lz4.h"
> > -#endif
> >  
> >  /*
> >   * single zcomp_strm backend
> > @@ -43,19 +39,20 @@ struct zcomp_strm_multi {
> >  	wait_queue_head_t strm_wait;
> >  };
> >  
> > -static struct zcomp_backend *backends[] = {
> > -	&zcomp_lzo,
> > +static const char * const backends[] = {
> > +	"lzo",
> >  #ifdef CONFIG_ZRAM_LZ4_COMPRESS
> > -	&zcomp_lz4,
> > +	"lz4",
> >  #endif
> >  	NULL
> >  };
> >  
> > -static struct zcomp_backend *find_backend(const char *compress)
> > +static const char *find_backend(const char *compress)
> >  {
> >  	int i = 0;
> >  	while (backends[i]) {
> > -		if (sysfs_streq(compress, backends[i]->name))
> > +		if (sysfs_streq(compress, backends[i]) &&
> > +			crypto_has_comp(compress, 0, 0))
> >  			break;
> >  		i++;
> >  	}
> > @@ -64,8 +61,8 @@ static struct zcomp_backend *find_backend(const char *compress)
> >  
> >  static void zcomp_strm_free(struct zcomp *comp, struct zcomp_strm *zstrm)
> >  {
> > -	if (zstrm->private)
> > -		comp->backend->destroy(zstrm->private);
> > +	if (zstrm->tfm)
> > +		crypto_free_comp(zstrm->tfm);
> >  	free_pages((unsigned long)zstrm->buffer, 1);
> >  	kfree(zstrm);
> >  }
> > @@ -80,13 +77,18 @@ static struct zcomp_strm *zcomp_strm_alloc(struct zcomp *comp)
> >  	if (!zstrm)
> >  		return NULL;
> >  
> > -	zstrm->private = comp->backend->create();
> > +	zstrm->tfm = crypto_alloc_comp(comp->backend, 0, 0);
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
> > @@ -274,12 +276,12 @@ ssize_t zcomp_available_show(const char *comp, char *buf)
> >  	int i = 0;
> >  
> >  	while (backends[i]) {
> > -		if (!strcmp(comp, backends[i]->name))
> > +		if (!strcmp(comp, backends[i]))
> >  			sz += scnprintf(buf + sz, PAGE_SIZE - sz - 2,
> > -					"[%s] ", backends[i]->name);
> > +					"[%s] ", backends[i]);
> >  		else
> >  			sz += scnprintf(buf + sz, PAGE_SIZE - sz - 2,
> > -					"%s ", backends[i]->name);
> > +					"%s ", backends[i]);
> >  		i++;
> >  	}
> >  	sz += scnprintf(buf + sz, PAGE_SIZE - sz, "\n");
> > @@ -317,10 +319,10 @@ void zcomp_compress_end(struct zcomp *comp, struct zcomp_strm *zstrm)
> >  	zcomp_strm_release(comp, zstrm);
> >  }
> >  
> > -/* May return NULL, may sleep */
> > +/* Never return NULL, may sleep */
> >  struct zcomp_strm *zcomp_decompress_begin(struct zcomp *comp)
> >  {
> > -	return NULL;
> > +	return zcomp_strm_find(comp);
> >  }
> >  
> >  void zcomp_decompress_end(struct zcomp *comp, struct zcomp_strm *zstrm)
> > @@ -330,17 +332,21 @@ void zcomp_decompress_end(struct zcomp *comp, struct zcomp_strm *zstrm)
> >  }
> >  
> >  int zcomp_compress(struct zcomp *comp, struct zcomp_strm *zstrm,
> > -		const unsigned char *src, size_t *dst_len)
> > +		const unsigned char *src, unsigned int *dst_len)
> >  {
> > -	return comp->backend->compress(src, zstrm->buffer, dst_len,
> > -			zstrm->private);
> > +	*dst_len = PAGE_SIZE << 1;
> > +
> > +	return crypto_comp_compress(zstrm->tfm, src, PAGE_SIZE,
> > +					zstrm->buffer, dst_len);
> >  }
> >  
> >  int zcomp_decompress(struct zcomp *comp, struct zcomp_strm *zstrm,
> >  		const unsigned char *src,
> > -		size_t src_len, unsigned char *dst)
> > +		unsigned int src_len, unsigned char *dst)
> >  {
> > -	return comp->backend->decompress(src, src_len, dst);
> > +	unsigned int size = PAGE_SIZE;
> > +
> > +	return crypto_comp_decompress(zstrm->tfm, src, src_len,	dst, &size);
> >  }
> >  
> >  void zcomp_destroy(struct zcomp *comp)
> > @@ -359,7 +365,7 @@ void zcomp_destroy(struct zcomp *comp)
> >  struct zcomp *zcomp_create(const char *compress, int max_strm)
> >  {
> >  	struct zcomp *comp;
> > -	struct zcomp_backend *backend;
> > +	const char *backend;
> >  
> >  	backend = find_backend(compress);
> >  	if (!backend)
> > diff --git a/drivers/block/zram/zcomp.h b/drivers/block/zram/zcomp.h
> > index 4c09c01..4f9df8e 100644
> > --- a/drivers/block/zram/zcomp.h
> > +++ b/drivers/block/zram/zcomp.h
> > @@ -11,38 +11,22 @@
> >  #define _ZCOMP_H_
> >  
> >  #include <linux/mutex.h>
> > +#include <linux/crypto.h>
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
> > +	const char *backend;
> >  
> >  	struct zcomp_strm *(*strm_find)(struct zcomp *comp);
> >  	void (*strm_release)(struct zcomp *comp, struct zcomp_strm *zstrm);
> > @@ -61,14 +45,14 @@ struct zcomp_strm *zcomp_compress_begin(struct zcomp *comp);
> >  void zcomp_compress_end(struct zcomp *comp, struct zcomp_strm *zstrm);
> >  
> >  int zcomp_compress(struct zcomp *comp, struct zcomp_strm *zstrm,
> > -		const unsigned char *src, size_t *dst_len);
> > +		const unsigned char *src, unsigned int *dst_len);
> >  
> >  struct zcomp_strm *zcomp_decompress_begin(struct zcomp *comp);
> >  void zcomp_decompress_end(struct zcomp *comp, struct zcomp_strm *zstrm);
> >  
> >  int zcomp_decompress(struct zcomp *comp, struct zcomp_strm *zstrm,
> >  		const unsigned char *src,
> > -		size_t src_len, unsigned char *dst);
> > +		unsigned int src_len, unsigned char *dst);
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
> > index 55e09db1..834f452 100644
> > --- a/drivers/block/zram/zram_drv.c
> > +++ b/drivers/block/zram/zram_drv.c
> > @@ -567,7 +567,7 @@ static int zram_decompress_page(struct zram *zram, struct zcomp_strm *zstrm,
> >  	unsigned char *cmem;
> >  	struct zram_meta *meta = zram->meta;
> >  	unsigned long handle;
> > -	size_t size;
> > +	unsigned int size;
> >  
> >  	bit_spin_lock(ZRAM_ACCESS, &meta->table[index].value);
> >  	handle = meta->table[index].handle;
> > @@ -656,7 +656,7 @@ static int zram_bvec_write(struct zram *zram, struct bio_vec *bvec, u32 index,
> >  			   int offset)
> >  {
> >  	int ret = 0;
> > -	size_t clen;
> > +	unsigned int clen;
> >  	unsigned long handle;
> >  	struct page *page;
> >  	unsigned char *user_mem, *cmem, *src, *uncmem = NULL;
> > @@ -731,7 +731,7 @@ static int zram_bvec_write(struct zram *zram, struct bio_vec *bvec, u32 index,
> >  
> >  	handle = zs_malloc(meta->mem_pool, clen);
> >  	if (!handle) {
> > -		pr_err("Error allocating memory for compressed page: %u, size=%zu\n",
> > +		pr_err("Error allocating memory for compressed page: %u, size=%u\n",
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

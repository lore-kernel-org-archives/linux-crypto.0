From: Sergey Senozhatsky <sergey.senozhatsky.work@gmail.com>
Subject: Re: [PATCH v2 7/8] zram: use crypto API for compression
Date: Thu, 27 Aug 2015 13:01:26 +0900
Message-ID: <20150827040126.GE1545@swordfish>
References: <1440052504-15442-1-git-send-email-iamjoonsoo.kim@lge.com>
 <1440052504-15442-8-git-send-email-iamjoonsoo.kim@lge.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Minchan Kim <minchan@kernel.org>,
	Nitin Gupta <ngupta@vflare.org>,
	Sergey Senozhatsky <sergey.senozhatsky.work@gmail.com>,
	linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org,
	Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	Stephan Mueller <smueller@chronox.de>,
	Joonsoo Kim <iamjoonsoo.kim@lge.com>
To: Joonsoo Kim <js1304@gmail.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-pa0-f51.google.com ([209.85.220.51]:35774 "EHLO
	mail-pa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750809AbbH0EAr (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 27 Aug 2015 00:00:47 -0400
Content-Disposition: inline
In-Reply-To: <1440052504-15442-8-git-send-email-iamjoonsoo.kim@lge.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

The patch contains too much noise and unrelated changes. Its goal is
to switch zcomp to use Crypto api.

I really would love to see zram_drv aligned with
	https://lkml.org/lkml/2015/8/13/343

IOW, only zcomp_decompress_begin()/zcomp_decompress_end() changes in
zram; the rest is purely zcomp related.


[..]
> -static struct zcomp_backend *backends[] = {
> -	&zcomp_lzo,
> -#ifdef CONFIG_ZRAM_LZ4_COMPRESS
> -	&zcomp_lz4,
> +static const char * const backends[] = {
> +	"lzo",
> +#ifdef CONFIG_CRYPTO_LZ4
> +	"lz4",
> +#endif
> +#ifdef CONFIG_CRYPTO_LZ4HC
> +	"lz4hc",
> +#endif
> +#ifdef CONFIG_CRYPTO_DEFLATE
> +	"deflate",
> +#endif
> +#ifdef CONFIG_CRYPTO_842
> +	"842",
>  #endif
>  	NULL
>  };

why this change is in this patch?


> -static struct zcomp_backend *find_backend(const char *compress)
> -{
> -	int i = 0;
> -	while (backends[i]) {
> -		if (sysfs_streq(compress, backends[i]->name))
> -			break;
> -		i++;
> -	}
> -	return backends[i];
> -}

No, find_backend() and zcomp_available_algorithm() must stay. Don't call
crypto API functions from zram_drv directly. This functionality belongs to
zcomp.

>  static void zcomp_strm_free(struct zcomp *comp, struct zcomp_strm *zstrm)
>  {
> -	if (zstrm->private)
> -		comp->backend->destroy(zstrm->private);
> +	if (zstrm->tfm)
> +		crypto_free_comp(zstrm->tfm);
>  	free_pages((unsigned long)zstrm->buffer, 1);
>  	kfree(zstrm);
>  }
>  
>  /*
> - * allocate new zcomp_strm structure with ->private initialized by
> - * backend, return NULL on error
> + * allocate new zcomp_strm structure with initializing crypto data structure,
> + * return NULL on error
>   */
>  static struct zcomp_strm *zcomp_strm_alloc(struct zcomp *comp)
>  {
> @@ -80,13 +75,18 @@ static struct zcomp_strm *zcomp_strm_alloc(struct zcomp *comp)
>  	if (!zstrm)
>  		return NULL;
>  
> -	zstrm->private = comp->backend->create();
> +	zstrm->tfm = crypto_alloc_comp(comp->name, 0, 0);
> +	if (IS_ERR(zstrm->tfm)) {
> +		kfree(zstrm);
> +		return NULL;
> +	}
> +
>  	/*
>  	 * allocate 2 pages. 1 for compressed data, plus 1 extra for the
>  	 * case when compressed size is larger than the original one
>  	 */
>  	zstrm->buffer = (void *)__get_free_pages(GFP_KERNEL | __GFP_ZERO, 1);
> -	if (!zstrm->private || !zstrm->buffer) {
> +	if (!zstrm->buffer) {
>  		zcomp_strm_free(comp, zstrm);
>  		zstrm = NULL;
>  	}
> @@ -274,23 +274,18 @@ ssize_t zcomp_available_show(const char *comp, char *buf)
>  	int i = 0;
>  
>  	while (backends[i]) {
> -		if (!strcmp(comp, backends[i]->name))
> +		if (!strcmp(comp, backends[i]))
>  			sz += scnprintf(buf + sz, PAGE_SIZE - sz - 2,
> -					"[%s] ", backends[i]->name);
> +					"[%s] ", backends[i]);
>  		else
>  			sz += scnprintf(buf + sz, PAGE_SIZE - sz - 2,
> -					"%s ", backends[i]->name);
> +					"%s ", backends[i]);
>  		i++;
>  	}
>  	sz += scnprintf(buf + sz, PAGE_SIZE - sz, "\n");
>  	return sz;
>  }
>  
> -bool zcomp_available_algorithm(const char *comp)
> -{
> -	return find_backend(comp) != NULL;
> -}
> -

No.

>  bool zcomp_set_max_streams(struct zcomp *comp, int num_strm)
>  {
>  	return comp->set_max_streams(comp, num_strm);
> @@ -307,15 +302,21 @@ void zcomp_strm_release(struct zcomp *comp, struct zcomp_strm *zstrm)
>  }
>  
>  int zcomp_compress(struct zcomp *comp, struct zcomp_strm *zstrm,
> -		const unsigned char *src, unsigned char *dst, size_t *dst_len)
> +		const unsigned char *src, unsigned char *dst,
> +		unsigned int *dst_len)
>  {
> -	return comp->backend->compress(src, dst, dst_len, zstrm->private);
> +	*dst_len = PAGE_SIZE << 1;
> +
> +	return crypto_comp_compress(zstrm->tfm, src, PAGE_SIZE, dst, dst_len);
>  }

No, see later.

> -int zcomp_decompress(struct zcomp *comp, const unsigned char *src,
> -		size_t src_len, unsigned char *dst)
> +int zcomp_decompress(struct zcomp *comp, struct zcomp_strm *zstrm,
> +		const unsigned char *src, unsigned int src_len,
> +		unsigned char *dst)
>  {
> -	return comp->backend->decompress(src, src_len, dst);
> +	unsigned int size = PAGE_SIZE;
> +
> +	return crypto_comp_decompress(zstrm->tfm, src, src_len,	dst, &size);
>  }

No, no direct Crypto API calls from zram_drv.
compression/decompression should be handled in zcomp. period.
What's the point of having zcomp in the first place then?

>  
>  void zcomp_destroy(struct zcomp *comp)
> @@ -334,17 +335,16 @@ void zcomp_destroy(struct zcomp *comp)
>  struct zcomp *zcomp_create(const char *compress, int max_strm)
>  {
>  	struct zcomp *comp;
> -	struct zcomp_backend *backend;
>  
> -	backend = find_backend(compress);
> -	if (!backend)
> +	if (!crypto_has_comp(compress, 0, 0))
>  		return ERR_PTR(-EINVAL);

No. Crypto API calls stay in zcomp.
zram_drv should know nothing about it.


>  	comp = kzalloc(sizeof(struct zcomp), GFP_KERNEL);
>  	if (!comp)
>  		return ERR_PTR(-ENOMEM);
>  
> -	comp->backend = backend;
> +	comp->name = compress;

No. I don't like that zram now use `struct zcomp' internals. Besides,
->tfm keeps alg name, zram keeps alg name.


>  	if (max_strm > 1)
>  		zcomp_strm_multi_create(comp, max_strm);
>  	else
> diff --git a/drivers/block/zram/zcomp.h b/drivers/block/zram/zcomp.h
> index b2388e0..c47db4d 100644
> --- a/drivers/block/zram/zcomp.h
> +++ b/drivers/block/zram/zcomp.h
> @@ -10,39 +10,23 @@
>  #ifndef _ZCOMP_H_
>  #define _ZCOMP_H_
>  
> +#include <linux/crypto.h>
>  #include <linux/mutex.h>
>  
>  struct zcomp_strm {
> +	struct crypto_comp *tfm;
> +
>  	/* compression/decompression buffer */
>  	void *buffer;
> -	/*
> -	 * The private data of the compression stream, only compression
> -	 * stream backend can touch this (e.g. compression algorithm
> -	 * working memory)
> -	 */
> -	void *private;
> +
>  	/* used in multi stream backend, protected by backend strm_lock */
>  	struct list_head list;
>  };
>  
> -/* static compression backend */
> -struct zcomp_backend {
> -	int (*compress)(const unsigned char *src, unsigned char *dst,
> -			size_t *dst_len, void *private);
> -
> -	int (*decompress)(const unsigned char *src, size_t src_len,
> -			unsigned char *dst);
> -
> -	void *(*create)(void);
> -	void (*destroy)(void *private);
> -
> -	const char *name;
> -};
> -
>  /* dynamic per-device compression frontend */
>  struct zcomp {
>  	void *stream;
> -	struct zcomp_backend *backend;
> +	const char *name;
>  
>  	struct zcomp_strm *(*strm_find)(struct zcomp *comp);
>  	void (*strm_release)(struct zcomp *comp, struct zcomp_strm *zstrm);
> @@ -51,7 +35,6 @@ struct zcomp {
>  };
>  
>  ssize_t zcomp_available_show(const char *comp, char *buf);
> -bool zcomp_available_algorithm(const char *comp);
>  
>  struct zcomp *zcomp_create(const char *comp, int max_strm);
>  void zcomp_destroy(struct zcomp *comp);
> @@ -60,10 +43,12 @@ struct zcomp_strm *zcomp_strm_find(struct zcomp *comp);
>  void zcomp_strm_release(struct zcomp *comp, struct zcomp_strm *zstrm);
>  
>  int zcomp_compress(struct zcomp *comp, struct zcomp_strm *zstrm,
> -		const unsigned char *src, unsigned char *dst, size_t *dst_len);
> +		const unsigned char *src, unsigned char *dst,
> +		unsigned int *dst_len);
>  
> -int zcomp_decompress(struct zcomp *comp, const unsigned char *src,
> -		size_t src_len, unsigned char *dst);
> +int zcomp_decompress(struct zcomp *comp, struct zcomp_strm *zstrm,
> +		const unsigned char *src, unsigned int src_len,
> +		unsigned char *dst);
>  
>  bool zcomp_set_max_streams(struct zcomp *comp, int num_strm);
>  #endif /* _ZCOMP_H_ */
> diff --git a/drivers/block/zram/zcomp_lz4.c b/drivers/block/zram/zcomp_lz4.c
> deleted file mode 100644
> index f2afb7e..0000000
> --- a/drivers/block/zram/zcomp_lz4.c
> +++ /dev/null
> @@ -1,47 +0,0 @@
> -/*
> - * Copyright (C) 2014 Sergey Senozhatsky.
> - *
> - * This program is free software; you can redistribute it and/or
> - * modify it under the terms of the GNU General Public License
> - * as published by the Free Software Foundation; either version
> - * 2 of the License, or (at your option) any later version.
> - */
> -
> -#include <linux/kernel.h>
> -#include <linux/slab.h>
> -#include <linux/lz4.h>
> -
> -#include "zcomp_lz4.h"
> -
> -static void *zcomp_lz4_create(void)
> -{
> -	return kzalloc(LZ4_MEM_COMPRESS, GFP_KERNEL);
> -}
> -
> -static void zcomp_lz4_destroy(void *private)
> -{
> -	kfree(private);
> -}
> -
> -static int zcomp_lz4_compress(const unsigned char *src, unsigned char *dst,
> -		size_t *dst_len, void *private)
> -{
> -	/* return  : Success if return 0 */
> -	return lz4_compress(src, PAGE_SIZE, dst, dst_len, private);
> -}
> -
> -static int zcomp_lz4_decompress(const unsigned char *src, size_t src_len,
> -		unsigned char *dst)
> -{
> -	size_t dst_len = PAGE_SIZE;
> -	/* return  : Success if return 0 */
> -	return lz4_decompress_unknownoutputsize(src, src_len, dst, &dst_len);
> -}
> -
> -struct zcomp_backend zcomp_lz4 = {
> -	.compress = zcomp_lz4_compress,
> -	.decompress = zcomp_lz4_decompress,
> -	.create = zcomp_lz4_create,
> -	.destroy = zcomp_lz4_destroy,
> -	.name = "lz4",
> -};
> diff --git a/drivers/block/zram/zcomp_lz4.h b/drivers/block/zram/zcomp_lz4.h
> deleted file mode 100644
> index 60613fb..0000000
> --- a/drivers/block/zram/zcomp_lz4.h
> +++ /dev/null
> @@ -1,17 +0,0 @@
> -/*
> - * Copyright (C) 2014 Sergey Senozhatsky.
> - *
> - * This program is free software; you can redistribute it and/or
> - * modify it under the terms of the GNU General Public License
> - * as published by the Free Software Foundation; either version
> - * 2 of the License, or (at your option) any later version.
> - */
> -
> -#ifndef _ZCOMP_LZ4_H_
> -#define _ZCOMP_LZ4_H_
> -
> -#include "zcomp.h"
> -
> -extern struct zcomp_backend zcomp_lz4;
> -
> -#endif /* _ZCOMP_LZ4_H_ */
> diff --git a/drivers/block/zram/zcomp_lzo.c b/drivers/block/zram/zcomp_lzo.c
> deleted file mode 100644
> index da1bc47..0000000
> --- a/drivers/block/zram/zcomp_lzo.c
> +++ /dev/null
> @@ -1,47 +0,0 @@
> -/*
> - * Copyright (C) 2014 Sergey Senozhatsky.
> - *
> - * This program is free software; you can redistribute it and/or
> - * modify it under the terms of the GNU General Public License
> - * as published by the Free Software Foundation; either version
> - * 2 of the License, or (at your option) any later version.
> - */
> -
> -#include <linux/kernel.h>
> -#include <linux/slab.h>
> -#include <linux/lzo.h>
> -
> -#include "zcomp_lzo.h"
> -
> -static void *lzo_create(void)
> -{
> -	return kzalloc(LZO1X_MEM_COMPRESS, GFP_KERNEL);
> -}
> -
> -static void lzo_destroy(void *private)
> -{
> -	kfree(private);
> -}
> -
> -static int lzo_compress(const unsigned char *src, unsigned char *dst,
> -		size_t *dst_len, void *private)
> -{
> -	int ret = lzo1x_1_compress(src, PAGE_SIZE, dst, dst_len, private);
> -	return ret == LZO_E_OK ? 0 : ret;
> -}
> -
> -static int lzo_decompress(const unsigned char *src, size_t src_len,
> -		unsigned char *dst)
> -{
> -	size_t dst_len = PAGE_SIZE;
> -	int ret = lzo1x_decompress_safe(src, src_len, dst, &dst_len);
> -	return ret == LZO_E_OK ? 0 : ret;
> -}
> -
> -struct zcomp_backend zcomp_lzo = {
> -	.compress = lzo_compress,
> -	.decompress = lzo_decompress,
> -	.create = lzo_create,
> -	.destroy = lzo_destroy,
> -	.name = "lzo",
> -};
> diff --git a/drivers/block/zram/zcomp_lzo.h b/drivers/block/zram/zcomp_lzo.h
> deleted file mode 100644
> index 128c580..0000000
> --- a/drivers/block/zram/zcomp_lzo.h
> +++ /dev/null
> @@ -1,17 +0,0 @@
> -/*
> - * Copyright (C) 2014 Sergey Senozhatsky.
> - *
> - * This program is free software; you can redistribute it and/or
> - * modify it under the terms of the GNU General Public License
> - * as published by the Free Software Foundation; either version
> - * 2 of the License, or (at your option) any later version.
> - */
> -
> -#ifndef _ZCOMP_LZO_H_
> -#define _ZCOMP_LZO_H_
> -
> -#include "zcomp.h"
> -
> -extern struct zcomp_backend zcomp_lzo;
> -
> -#endif /* _ZCOMP_LZO_H_ */
> diff --git a/drivers/block/zram/zram_drv.c b/drivers/block/zram/zram_drv.c
> index 4801e4d..b3044d3 100644
> --- a/drivers/block/zram/zram_drv.c
> +++ b/drivers/block/zram/zram_drv.c
> @@ -30,6 +30,7 @@
>  #include <linux/err.h>
>  #include <linux/idr.h>
>  #include <linux/sysfs.h>
> +#include <linux/crypto.h>
>  
>  #include "zram_drv.h"
>  
> @@ -378,7 +379,7 @@ static ssize_t comp_algorithm_store(struct device *dev,
>  	if (sz > 0 && zram->compressor[sz - 1] == '\n')
>  		zram->compressor[sz - 1] = 0x00;
>  
> -	if (!zcomp_available_algorithm(zram->compressor))
> +	if (!crypto_has_comp(zram->compressor, 0, 0))
>  		len = -EINVAL;

No.

>  	up_write(&zram->init_lock);
> @@ -562,13 +563,14 @@ static void zram_free_page(struct zram *zram, size_t index)
>  	zram_set_obj_size(meta, index, 0);
>  }
>  
> -static int zram_decompress_page(struct zram *zram, char *mem, u32 index)
> +static int zram_decompress_page(struct zram *zram, struct zcomp_strm *zstrm,
> +				char *mem, u32 index)
>  {
>  	int ret = 0;
>  	unsigned char *cmem;
>  	struct zram_meta *meta = zram->meta;
>  	unsigned long handle;
> -	size_t size;
> +	unsigned int size;
>  
>  	bit_spin_lock(ZRAM_ACCESS, &meta->table[index].value);
>  	handle = meta->table[index].handle;
> @@ -584,7 +586,7 @@ static int zram_decompress_page(struct zram *zram, char *mem, u32 index)
>  	if (size == PAGE_SIZE)
>  		copy_page(mem, cmem);
>  	else
> -		ret = zcomp_decompress(zram->comp, cmem, size, mem);
> +		ret = zcomp_decompress(zram->comp, zstrm, cmem, size, mem);
>  	zs_unmap_object(meta->mem_pool, handle);
>  	bit_spin_unlock(ZRAM_ACCESS, &meta->table[index].value);
>  
> @@ -604,6 +606,8 @@ static int zram_bvec_read(struct zram *zram, struct bio_vec *bvec,
>  	struct page *page;
>  	unsigned char *user_mem, *uncmem = NULL;
>  	struct zram_meta *meta = zram->meta;
> +	struct zcomp_strm *zstrm;
> +
>  	page = bvec->bv_page;
>  
>  	bit_spin_lock(ZRAM_ACCESS, &meta->table[index].value);
> @@ -619,6 +623,7 @@ static int zram_bvec_read(struct zram *zram, struct bio_vec *bvec,
>  		/* Use  a temporary buffer to decompress the page */
>  		uncmem = kmalloc(PAGE_SIZE, GFP_NOIO);
>  
> +	zstrm = zcomp_strm_find(zram->comp);

No.
zcomp_decompress_begin()/zcomp_decompress_end() please, and then just
change them to return NULL or zstrm when needed.

don't change zcomp_strm_find() to return NULL. that completely brakes
zcomp design. it always return zstream -- immediately (if there is an
idle zstrm) or after sleep.


>  	user_mem = kmap_atomic(page);
>  	if (!is_partial_io(bvec))
>  		uncmem = user_mem;
> @@ -629,7 +634,7 @@ static int zram_bvec_read(struct zram *zram, struct bio_vec *bvec,
>  		goto out_cleanup;
>  	}
>  
> -	ret = zram_decompress_page(zram, uncmem, index);
> +	ret = zram_decompress_page(zram, zstrm, uncmem, index);
>  	/* Should NEVER happen. Return bio error if it does. */
>  	if (unlikely(ret))
>  		goto out_cleanup;
> @@ -642,6 +647,7 @@ static int zram_bvec_read(struct zram *zram, struct bio_vec *bvec,
>  	ret = 0;
>  out_cleanup:
>  	kunmap_atomic(user_mem);
> +	zcomp_strm_release(zram->comp, zstrm);
>  	if (is_partial_io(bvec))
>  		kfree(uncmem);
>  	return ret;
> @@ -651,7 +657,7 @@ static int zram_bvec_write(struct zram *zram, struct bio_vec *bvec, u32 index,
>  			   int offset)
>  {
>  	int ret = 0;
> -	size_t clen;
> +	unsigned int clen;
>  	unsigned long handle;
>  	struct page *page;
>  	unsigned char *user_mem, *cmem, *src, *uncmem = NULL;
> @@ -670,12 +676,14 @@ static int zram_bvec_write(struct zram *zram, struct bio_vec *bvec, u32 index,
>  			ret = -ENOMEM;
>  			goto out;
>  		}
> -		ret = zram_decompress_page(zram, uncmem, index);
> +		zstrm = zcomp_strm_find(zram->comp);
> +		ret = zram_decompress_page(zram, zstrm, uncmem, index);
>  		if (ret)
>  			goto out;
>  	}
>  
> -	zstrm = zcomp_strm_find(zram->comp);
> +	if (!zstrm)
> +		zstrm = zcomp_strm_find(zram->comp);
>  	user_mem = kmap_atomic(page);
>  
>  	if (is_partial_io(bvec)) {
> @@ -721,7 +729,7 @@ static int zram_bvec_write(struct zram *zram, struct bio_vec *bvec, u32 index,
>  
>  	handle = zs_malloc(meta->mem_pool, clen);
>  	if (!handle) {
> -		pr_info("Error allocating memory for compressed page: %u, size=%zu\n",
> +		pr_info("Error allocating memory for compressed page: %u, size=%u\n",
>  			index, clen);

Please rebase against the linux-next. I do believe that I have changed
that line a couple of weeks ago.

	-ss

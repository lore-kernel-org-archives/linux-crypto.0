From: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Subject: Re: [PATCH v4 7/8] zram: use crypto contextless compression API to
 (de)compress
Date: Thu, 15 Oct 2015 10:07:33 +0900
Message-ID: <20151015010732.GB4900@js1304-P5Q-DELUXE>
References: <1444808304-29320-1-git-send-email-iamjoonsoo.kim@lge.com>
 <1444808304-29320-8-git-send-email-iamjoonsoo.kim@lge.com>
 <20151015003841.GC1735@swordfish>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Minchan Kim <minchan@kernel.org>,
	Nitin Gupta <ngupta@vflare.org>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	Stephan Mueller <smueller@chronox.de>,
	linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org
To: Sergey Senozhatsky <sergey.senozhatsky.work@gmail.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from LGEAMRELO12.lge.com ([156.147.23.52]:54299 "EHLO
	lgeamrelo12.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754193AbbJOBGo (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 14 Oct 2015 21:06:44 -0400
Content-Disposition: inline
In-Reply-To: <20151015003841.GC1735@swordfish>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Thu, Oct 15, 2015 at 09:38:41AM +0900, Sergey Senozhatsky wrote:
> Hi,
> 
> On (10/14/15 16:38), Joonsoo Kim wrote:
> [..]
> >  	  Creates virtual block devices called /dev/zramX (X = 0, 1, ...).
> > @@ -18,9 +17,8 @@ config ZRAM
> >  config ZRAM_LZ4_COMPRESS
> >  	bool "Enable LZ4 algorithm support"
> >  	depends on ZRAM
> > -	select LZ4_COMPRESS
> > -	select LZ4_DECOMPRESS
> > +	select CRYPTO_LZ4
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
> 
> + git rm zcomp_lzo.* zcomp_lz4.*    :)

Will do. :)

> 
> 
> >  obj-$(CONFIG_ZRAM)	+=	zram.o
> > diff --git a/drivers/block/zram/zcomp.c b/drivers/block/zram/zcomp.c
> > index e3016da..9be83db 100644
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
> 
> a nitpick -- this CONFIG option does not exist at this point.

Will fix.

> 
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
> > +			crypto_has_comp(backends[i], 0, 0))
> 
> again (the same as in my previous email). I'd rather prefer to have
> FOO backends in ` const char * const backends[]' array only when the
> corresponding CONFIG_CRYPTO_FOO option has been selected. otherwise you
> have to find an intersection of two independent sets. sort of unreasonable
> to me.

Okay.

> 
> >  			break;
> >  		i++;
> >  	}
> > @@ -65,7 +62,7 @@ static struct zcomp_backend *find_backend(const char *compress)
> >  static void zcomp_strm_free(struct zcomp *comp, struct zcomp_strm *zstrm)
> >  {
> >  	if (zstrm->private)
> > -		comp->backend->destroy(zstrm->private);
> > +		crypto_ccomp_free_context(comp->tfm, zstrm->private);
> >  	free_pages((unsigned long)zstrm->buffer, 1);
> >  	kfree(zstrm);
> >  }
> > @@ -80,7 +77,13 @@ static struct zcomp_strm *zcomp_strm_alloc(struct zcomp *comp)
> >  	if (!zstrm)
> >  		return NULL;
> >  
> > -	zstrm->private = comp->backend->create();
> > +	zstrm->private = crypto_ccomp_alloc_context(comp->tfm);
> > +	if (IS_ERR(zstrm->private)) {
> > +		zstrm->private = NULL;
> > +		zcomp_strm_free(comp, zstrm);
> > +		return NULL;
> > +	}
> > +
> >  	/*
> >  	 * allocate 2 pages. 1 for compressed data, plus 1 extra for the
> >  	 * case when compressed size is larger than the original one
> > @@ -274,12 +277,12 @@ ssize_t zcomp_available_show(const char *comp, char *buf)
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
> > @@ -320,7 +323,10 @@ void zcomp_compress_end(struct zcomp *comp, struct zcomp_strm *zstrm)
> >  /* May return NULL, may sleep */
> >  struct zcomp_strm *zcomp_decompress_begin(struct zcomp *comp)
> >  {
> > -	return NULL;
> > +	if (crypto_ccomp_decomp_noctx(comp->tfm))
> > +		return NULL;
> > +
> > +	return zcomp_strm_find(comp);
> >  }
> >  
> >  void zcomp_decompress_end(struct zcomp *comp, struct zcomp_strm *zstrm)
> > @@ -330,22 +336,29 @@ void zcomp_decompress_end(struct zcomp *comp, struct zcomp_strm *zstrm)
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
> > +	return crypto_ccomp_compress(comp->tfm, src, PAGE_SIZE,
> > +			zstrm->buffer, dst_len, zstrm->private);
> >  }
> >  
> >  int zcomp_decompress(struct zcomp *comp, struct zcomp_strm *zstrm,
> >  		const unsigned char *src,
> > -		size_t src_len, unsigned char *dst)
> > +		unsigned int src_len, unsigned char *dst)
> >  {
> > -	return comp->backend->decompress(src, src_len, dst);
> > +	unsigned int size = PAGE_SIZE;
> > +	void *private = zstrm ? zstrm->private : NULL;
> > +
> > +	return crypto_ccomp_decompress(comp->tfm, src, src_len,
> > +					dst, &size, private);
> >  }
> >  
> >  void zcomp_destroy(struct zcomp *comp)
> >  {
> >  	comp->destroy(comp);
> > +	crypto_free_ccomp(comp->tfm);
> >  	kfree(comp);
> >  }
> >  
> > @@ -360,7 +373,7 @@ void zcomp_destroy(struct zcomp *comp)
> >  struct zcomp *zcomp_create(const char *compress, int max_strm)
> >  {
> >  	struct zcomp *comp;
> > -	struct zcomp_backend *backend;
> > +	const char *backend;
> >  	int error;
> >  
> >  	backend = find_backend(compress);
> > @@ -371,12 +384,18 @@ struct zcomp *zcomp_create(const char *compress, int max_strm)
> >  	if (!comp)
> >  		return ERR_PTR(-ENOMEM);
> >  
> > -	comp->backend = backend;
> > +	comp->tfm = crypto_alloc_ccomp(backend, 0, 0);
> > +	if (IS_ERR(comp->tfm)) {
> > +		kfree(comp);
> > +		return ERR_CAST(comp->tfm);
> > +	}
> > +
> >  	if (max_strm > 1)
> >  		error = zcomp_strm_multi_create(comp, max_strm);
> >  	else
> >  		error = zcomp_strm_single_create(comp);
> >  	if (error) {
> > +		crypto_free_ccomp(comp->tfm);
> >  		kfree(comp);
> 
> hm... zcomp_destroy(comp) ?

It's not possible to use zcomp_destroy() here. It tries to access
field of comp->stream which could be NULL.

Thanks.

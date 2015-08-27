From: Sergey Senozhatsky <sergey.senozhatsky.work@gmail.com>
Subject: Re: [PATCH v2 8/8] zram: use decompress_noctx
Date: Thu, 27 Aug 2015 14:47:14 +0900
Message-ID: <20150827054714.GA30236@swordfish>
References: <1440052504-15442-1-git-send-email-iamjoonsoo.kim@lge.com>
 <1440052504-15442-9-git-send-email-iamjoonsoo.kim@lge.com>
 <20150827040712.GF1545@swordfish>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Joonsoo Kim <js1304@gmail.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Minchan Kim <minchan@kernel.org>,
	Nitin Gupta <ngupta@vflare.org>, linux-kernel@vger.kernel.org,
	linux-crypto@vger.kernel.org,
	Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	Stephan Mueller <smueller@chronox.de>,
	Joonsoo Kim <iamjoonsoo.kim@lge.com>
To: Sergey Senozhatsky <sergey.senozhatsky.work@gmail.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20150827040712.GF1545@swordfish>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On (08/27/15 13:07), Sergey Senozhatsky wrote:
[..]
> > -struct zcomp_strm *zcomp_strm_find(struct zcomp *comp)
> > +struct zcomp_strm *zcomp_strm_find(struct zcomp *comp, bool decomp)
> >

I think we can hide zcomp_strm_find()/_release (make them static),
and instead introduce:

a) zcomp_decompress_begin()/zcomp_decompress_end()

	calls zcomp_strm_find()/zcomp_strm_release() for tfms that
require context for decompression; may return NULL, may sleep.

b) zcomp_compress_begin()/zcomp_compress_end()
	always calls zcomp_strm_find()/zcomp_strm_release();
	never return NULL; may sleep.

	-ss

> >  {
> > +	/* We don't need decompression context so zstrm neither */
> > +	if (decomp && test_bit(ZCOMP_DECOMPRESS_NOCTX, &comp->flags))
> > +		return NULL;
> > +
> >  	return comp->strm_find(comp);
> >  }
> 
> No. zcomp_strm_find() should never return NULL. And no, I don't like
> "if (decomp)" change.
> 
> 
> >  
> > @@ -307,6 +311,11 @@ int zcomp_compress(struct zcomp *comp, struct zcomp_strm *zstrm,
> >  {
> >  	*dst_len = PAGE_SIZE << 1;
> >  
> > +	if (!zstrm) {
> > +		return crypto_comp_compress_noctx(comp->alg, src, PAGE_SIZE,
> > +							dst, dst_len);
> > +	}
> > +
> >  	return crypto_comp_compress(zstrm->tfm, src, PAGE_SIZE, dst, dst_len);
> >  }
> >  
> > @@ -316,12 +325,18 @@ int zcomp_decompress(struct zcomp *comp, struct zcomp_strm *zstrm,
> >  {
> >  	unsigned int size = PAGE_SIZE;
> >  
> > +	if (!zstrm) {
> > +		return crypto_comp_decompress_noctx(comp->alg, src, src_len,
> > +							dst, &size);
> > +	}
> > +
> >  	return crypto_comp_decompress(zstrm->tfm, src, src_len,	dst, &size);
> >  }
> >  
> >  void zcomp_destroy(struct zcomp *comp)
> >  {
> >  	comp->destroy(comp);
> > +	crypto_put_comp(comp->alg);
> >  	kfree(comp);
> >  }
> >  
> > @@ -344,12 +359,23 @@ struct zcomp *zcomp_create(const char *compress, int max_strm)
> >  		return ERR_PTR(-ENOMEM);
> >  
> >  	comp->name = compress;
> > +	comp->alg = crypto_get_comp(compress, 0, 0);
> > +	if (!comp->alg) {
> > +		kfree(comp);
> > +		return ERR_PTR(-EINVAL);
> > +	}
> > +
> > +	if (crypto_has_compress_noctx(comp->alg))
> > +		set_bit(ZCOMP_COMPRESS_NOCTX, &comp->flags);
> 
> do you use ZCOMP_COMPRESS_NOCTX algs in this patch set?
> 
> 
> > +	if (crypto_has_decompress_noctx(comp->alg))
> > +		set_bit(ZCOMP_DECOMPRESS_NOCTX, &comp->flags);
> >  
> >  	if (max_strm > 1)
> >  		zcomp_strm_multi_create(comp, max_strm);
> >  	else
> >  		zcomp_strm_single_create(comp);
> >  	if (!comp->stream) {
> > +		crypto_put_comp(comp->alg);
> >  		kfree(comp);
> >  		return ERR_PTR(-ENOMEM);
> >  	}
> > diff --git a/drivers/block/zram/zcomp.h b/drivers/block/zram/zcomp.h
> > index c47db4d..6c137c8 100644
> > --- a/drivers/block/zram/zcomp.h
> > +++ b/drivers/block/zram/zcomp.h
> > @@ -13,6 +13,11 @@
> >  #include <linux/crypto.h>
> >  #include <linux/mutex.h>
> >  
> > +enum {
> > +	ZCOMP_COMPRESS_NOCTX,
> > +	ZCOMP_DECOMPRESS_NOCTX,
> > +};
> 
> Can it be handled via crypto api? check if ->foo_noctx() is !NULL ?
> 
> >  struct zcomp_strm {
> >  	struct crypto_comp *tfm;
> >  
> > @@ -27,6 +32,8 @@ struct zcomp_strm {
> >  struct zcomp {
> >  	void *stream;
> >  	const char *name;
> > +	struct crypto_alg *alg;
> > +	unsigned long flags;
> >  
> >  	struct zcomp_strm *(*strm_find)(struct zcomp *comp);
> >  	void (*strm_release)(struct zcomp *comp, struct zcomp_strm *zstrm);
> > @@ -39,7 +46,7 @@ ssize_t zcomp_available_show(const char *comp, char *buf);
> >  struct zcomp *zcomp_create(const char *comp, int max_strm);
> >  void zcomp_destroy(struct zcomp *comp);
> >  
> > -struct zcomp_strm *zcomp_strm_find(struct zcomp *comp);
> > +struct zcomp_strm *zcomp_strm_find(struct zcomp *comp, bool decomp);
> >  void zcomp_strm_release(struct zcomp *comp, struct zcomp_strm *zstrm);
> >  
> >  int zcomp_compress(struct zcomp *comp, struct zcomp_strm *zstrm,
> > diff --git a/drivers/block/zram/zram_drv.c b/drivers/block/zram/zram_drv.c
> > index b3044d3..8283bd3 100644
> > --- a/drivers/block/zram/zram_drv.c
> > +++ b/drivers/block/zram/zram_drv.c
> > @@ -623,7 +623,7 @@ static int zram_bvec_read(struct zram *zram, struct bio_vec *bvec,
> >  		/* Use  a temporary buffer to decompress the page */
> >  		uncmem = kmalloc(PAGE_SIZE, GFP_NOIO);
> >  
> > -	zstrm = zcomp_strm_find(zram->comp);
> > +	zstrm = zcomp_strm_find(zram->comp, true);
> 
> No, I don't like this.
> 
> >  	user_mem = kmap_atomic(page);
> >  	if (!is_partial_io(bvec))
> >  		uncmem = user_mem;
> > @@ -647,7 +647,8 @@ static int zram_bvec_read(struct zram *zram, struct bio_vec *bvec,
> >  	ret = 0;
> >  out_cleanup:
> >  	kunmap_atomic(user_mem);
> > -	zcomp_strm_release(zram->comp, zstrm);
> > +	if (zstrm)
> > +		zcomp_strm_release(zram->comp, zstrm);
> >  	if (is_partial_io(bvec))
> >  		kfree(uncmem);
> >  	return ret;
> > @@ -676,14 +677,14 @@ static int zram_bvec_write(struct zram *zram, struct bio_vec *bvec, u32 index,
> >  			ret = -ENOMEM;
> >  			goto out;
> >  		}
> > -		zstrm = zcomp_strm_find(zram->comp);
> > +		zstrm = zcomp_strm_find(zram->comp, true);
> >  		ret = zram_decompress_page(zram, zstrm, uncmem, index);
> >  		if (ret)
> >  			goto out;
> >  	}
> >  
> >  	if (!zstrm)
> > -		zstrm = zcomp_strm_find(zram->comp);
> > +		zstrm = zcomp_strm_find(zram->comp, false);
> 
> No. I don't like this.
> 
> 	-ss
> 

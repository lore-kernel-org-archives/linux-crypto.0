From: Sergey Senozhatsky <sergey.senozhatsky.work@gmail.com>
Subject: Re: [PATCH v3 8/9] zram: use crypto API for compression
Date: Mon, 21 Sep 2015 14:19:03 +0900
Message-ID: <20150921051903.GB863@swordfish>
References: <1442553564-3476-1-git-send-email-iamjoonsoo.kim@lge.com>
 <1442553564-3476-9-git-send-email-iamjoonsoo.kim@lge.com>
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
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1442553564-3476-9-git-send-email-iamjoonsoo.kim@lge.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On (09/18/15 14:19), Joonsoo Kim wrote:
[..]
> -static struct zcomp_backend *find_backend(const char *compress)
> +static const char *find_backend(const char *compress)
>  {
>  	int i = 0;
>  	while (backends[i]) {
> -		if (sysfs_streq(compress, backends[i]->name))
> +		if (sysfs_streq(compress, backends[i]) &&
> +			crypto_has_comp(compress, 0, 0))

ok, just for note. zcomp does sysfs_streq(), because sysfs data
usually contain a trailing new line, crypto_has_comp() does strcmp().


>  int zcomp_compress(struct zcomp *comp, struct zcomp_strm *zstrm,
> -		const unsigned char *src, size_t *dst_len)
> +		const unsigned char *src, unsigned int *dst_len)
>  {
> -	return comp->backend->compress(src, zstrm->buffer, dst_len,
> -			zstrm->private);
> +	*dst_len = PAGE_SIZE << 1;
> +

hm... wouldn't it be better to say crypto api that we have a PAGE_SIZE
buffer instead of PAGE_SIZE << 1, so in case of buffer overrun (or
whatever is the correct term here) it will stop compression earlier
(well, possibly)? zram will drop compressed data larger than PAGE_SIZE
anyway, so if passing a smaller buffer size can save us CPU time then
let's do it.


> +	return crypto_comp_compress(zstrm->tfm, src, PAGE_SIZE,
> +					zstrm->buffer, dst_len);
>  }
>  
>  int zcomp_decompress(struct zcomp *comp, struct zcomp_strm *zstrm,
>  		const unsigned char *src,
> -		size_t src_len, unsigned char *dst)
> +		unsigned int src_len, unsigned char *dst)
>  {
> -	return comp->backend->decompress(src, src_len, dst);
> +	unsigned int size = PAGE_SIZE;
> +
> +	return crypto_comp_decompress(zstrm->tfm, src, src_len,	dst, &size);

							^^^^^^^^ tab?

>  }
>  
>  void zcomp_destroy(struct zcomp *comp)
> @@ -359,7 +365,7 @@ void zcomp_destroy(struct zcomp *comp)
>  struct zcomp *zcomp_create(const char *compress, int max_strm)
>  {
>  	struct zcomp *comp;
> -	struct zcomp_backend *backend;
> +	const char *backend;

rebase against the current linux-next. this and the next patch do not
apply cleanly. the function was touched recently: '+int error'.


>  
>  	backend = find_backend(compress);
>  	if (!backend)
> diff --git a/drivers/block/zram/zcomp.h b/drivers/block/zram/zcomp.h
> index 4c09c01..4f9df8e 100644
> --- a/drivers/block/zram/zcomp.h
> +++ b/drivers/block/zram/zcomp.h
> @@ -11,38 +11,22 @@
>  #define _ZCOMP_H_
>  
>  #include <linux/mutex.h>
> +#include <linux/crypto.h>
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
> +	const char *backend;

	^^ what for?

	-ss

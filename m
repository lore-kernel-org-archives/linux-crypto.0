From: Sergey Senozhatsky <sergey.senozhatsky.work@gmail.com>
Subject: Re: [PATCH v2 6/8] zram: change zcomp_compress interface
Date: Thu, 27 Aug 2015 11:14:36 +0900
Message-ID: <20150827021436.GD1545@swordfish>
References: <1440052504-15442-1-git-send-email-iamjoonsoo.kim@lge.com>
 <1440052504-15442-7-git-send-email-iamjoonsoo.kim@lge.com>
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
Received: from mail-pa0-f54.google.com ([209.85.220.54]:33305 "EHLO
	mail-pa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751644AbbH0CN4 (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 26 Aug 2015 22:13:56 -0400
Content-Disposition: inline
In-Reply-To: <1440052504-15442-7-git-send-email-iamjoonsoo.kim@lge.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On (08/20/15 15:35), Joonsoo Kim wrote:
> zram regards zstrm's buffer as compression destination buffer, but,
> it is not intuitive and there is no document about it. Providing
> destination buffer to zcomp_compress() directly seems more intuitive
> interface to me so this patch changes zcomp_compress interface.
> 
> Signed-off-by: Joonsoo Kim <iamjoonsoo.kim@lge.com>
> ---
>  drivers/block/zram/zcomp.c    | 5 ++---
>  drivers/block/zram/zcomp.h    | 2 +-
>  drivers/block/zram/zram_drv.c | 2 +-
>  3 files changed, 4 insertions(+), 5 deletions(-)
> 
> diff --git a/drivers/block/zram/zcomp.c b/drivers/block/zram/zcomp.c
> index 965d1af..2ad504b 100644
> --- a/drivers/block/zram/zcomp.c
> +++ b/drivers/block/zram/zcomp.c
> @@ -307,10 +307,9 @@ void zcomp_strm_release(struct zcomp *comp, struct zcomp_strm *zstrm)
>  }
>  
>  int zcomp_compress(struct zcomp *comp, struct zcomp_strm *zstrm,
> -		const unsigned char *src, size_t *dst_len)
> +		const unsigned char *src, unsigned char *dst, size_t *dst_len)
>  {
> -	return comp->backend->compress(src, zstrm->buffer, dst_len,
> -			zstrm->private);
> +	return comp->backend->compress(src, dst, dst_len, zstrm->private);
>  }
>  
>  int zcomp_decompress(struct zcomp *comp, const unsigned char *src,
> diff --git a/drivers/block/zram/zcomp.h b/drivers/block/zram/zcomp.h
> index 46e2b9f..b2388e0 100644
> --- a/drivers/block/zram/zcomp.h
> +++ b/drivers/block/zram/zcomp.h
> @@ -60,7 +60,7 @@ struct zcomp_strm *zcomp_strm_find(struct zcomp *comp);
>  void zcomp_strm_release(struct zcomp *comp, struct zcomp_strm *zstrm);
>  
>  int zcomp_compress(struct zcomp *comp, struct zcomp_strm *zstrm,
> -		const unsigned char *src, size_t *dst_len);
> +		const unsigned char *src, unsigned char *dst, size_t *dst_len);
>  
>  int zcomp_decompress(struct zcomp *comp, const unsigned char *src,
>  		size_t src_len, unsigned char *dst);
> diff --git a/drivers/block/zram/zram_drv.c b/drivers/block/zram/zram_drv.c
> index b088ca9..4801e4d 100644
> --- a/drivers/block/zram/zram_drv.c
> +++ b/drivers/block/zram/zram_drv.c
> @@ -701,7 +701,7 @@ static int zram_bvec_write(struct zram *zram, struct bio_vec *bvec, u32 index,
>  		goto out;
>  	}
>  
> -	ret = zcomp_compress(zram->comp, zstrm, uncmem, &clen);
> +	ret = zcomp_compress(zram->comp, zstrm, uncmem, zstrm->buffer, &clen);

No, this change is unreasonable. zcomp might want to do with zstrm
anything it wants to, because zstrm belongs there. Besides, you change
zcomp_decompress() to require `struct zcomp_strm *zstrm', so let's
stick with this -- pass `struct zcomp_strm *zstrm' to both compress and
decompress functions. It's up to zcomp to ignore passed zstrm or do
something sane; not up to zram_drv.

	-ss

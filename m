From: Minchan Kim <minchan@kernel.org>
Subject: Re: [PATCH v3 7/9] zram: pass zstrm down to decompression path
Date: Mon, 21 Sep 2015 08:42:03 +0900
Message-ID: <20150920234203.GB27729@bbox>
References: <1442553564-3476-1-git-send-email-iamjoonsoo.kim@lge.com>
 <1442553564-3476-8-git-send-email-iamjoonsoo.kim@lge.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Nitin Gupta <ngupta@vflare.org>,
	Sergey Senozhatsky <sergey.senozhatsky.work@gmail.com>,
	linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org,
	Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	Stephan Mueller <smueller@chronox.de>,
	Sergey Senozhatsky <sergey.senozhatsky@gmail.com>,
	Joonsoo Kim <iamjoonsoo.kim@lge.com>
To: Joonsoo Kim <js1304@gmail.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-pa0-f50.google.com ([209.85.220.50]:32965 "EHLO
	mail-pa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755505AbbITXkh (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Sun, 20 Sep 2015 19:40:37 -0400
Content-Disposition: inline
In-Reply-To: <1442553564-3476-8-git-send-email-iamjoonsoo.kim@lge.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Fri, Sep 18, 2015 at 02:19:22PM +0900, Joonsoo Kim wrote:
> From: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
> 
> Introduce zcomp_decompress_begin()/zcomp_decompress_end() as a
> preparation for crypto API-powered zcomp.
> 
> Change zcomp_decompress() signature to require zstrm parameter.
> 
> Unlike zcomp_compress_begin(), zcomp_decompress_begin() may return
> zstrm if currently selected compression backend require zstrm for
> decompression or NULL if it does not.
> 
> Signed-off-by: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
> Signed-off-by: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Acked-by: Minchan Kim <minchan@kernel.org>

There is a trivial comment below.

> ---
>  drivers/block/zram/zcomp.c    |  3 ++-
>  drivers/block/zram/zcomp.h    |  3 ++-
>  drivers/block/zram/zram_drv.c | 20 ++++++++++++++++----
>  3 files changed, 20 insertions(+), 6 deletions(-)
> 
> diff --git a/drivers/block/zram/zcomp.c b/drivers/block/zram/zcomp.c
> index fc13bf2..3456d5a 100644
> --- a/drivers/block/zram/zcomp.c
> +++ b/drivers/block/zram/zcomp.c
> @@ -336,7 +336,8 @@ int zcomp_compress(struct zcomp *comp, struct zcomp_strm *zstrm,
>  			zstrm->private);
>  }
>  
> -int zcomp_decompress(struct zcomp *comp, const unsigned char *src,
> +int zcomp_decompress(struct zcomp *comp, struct zcomp_strm *zstrm,
> +		const unsigned char *src,
>  		size_t src_len, unsigned char *dst)
>  {
>  	return comp->backend->decompress(src, src_len, dst);
> diff --git a/drivers/block/zram/zcomp.h b/drivers/block/zram/zcomp.h
> index 616e013..4c09c01 100644
> --- a/drivers/block/zram/zcomp.h
> +++ b/drivers/block/zram/zcomp.h
> @@ -66,7 +66,8 @@ int zcomp_compress(struct zcomp *comp, struct zcomp_strm *zstrm,
>  struct zcomp_strm *zcomp_decompress_begin(struct zcomp *comp);
>  void zcomp_decompress_end(struct zcomp *comp, struct zcomp_strm *zstrm);
>  
> -int zcomp_decompress(struct zcomp *comp, const unsigned char *src,
> +int zcomp_decompress(struct zcomp *comp, struct zcomp_strm *zstrm,
> +		const unsigned char *src,
>  		size_t src_len, unsigned char *dst);
>  
>  bool zcomp_set_max_streams(struct zcomp *comp, int num_strm);
> diff --git a/drivers/block/zram/zram_drv.c b/drivers/block/zram/zram_drv.c
> index 20c41ed..55e09db1 100644
> --- a/drivers/block/zram/zram_drv.c
> +++ b/drivers/block/zram/zram_drv.c
> @@ -560,7 +560,8 @@ static void zram_free_page(struct zram *zram, size_t index)
>  	zram_set_obj_size(meta, index, 0);
>  }
>  
> -static int zram_decompress_page(struct zram *zram, char *mem, u32 index)
> +static int zram_decompress_page(struct zram *zram, struct zcomp_strm *zstrm,
> +		char *mem, u32 index)
>  {
>  	int ret = 0;
>  	unsigned char *cmem;
> @@ -582,7 +583,7 @@ static int zram_decompress_page(struct zram *zram, char *mem, u32 index)
>  	if (size == PAGE_SIZE)
>  		copy_page(mem, cmem);
>  	else
> -		ret = zcomp_decompress(zram->comp, cmem, size, mem);
> +		ret = zcomp_decompress(zram->comp, zstrm, cmem, size, mem);
>  	zs_unmap_object(meta->mem_pool, handle);
>  	bit_spin_unlock(ZRAM_ACCESS, &meta->table[index].value);
>  
> @@ -602,6 +603,7 @@ static int zram_bvec_read(struct zram *zram, struct bio_vec *bvec,
>  	struct page *page;
>  	unsigned char *user_mem, *uncmem = NULL;
>  	struct zram_meta *meta = zram->meta;
> +	struct zcomp_strm *zstrm = NULL;

No need to initialize with NULL.

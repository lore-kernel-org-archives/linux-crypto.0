From: Sergey Senozhatsky <sergey.senozhatsky.work@gmail.com>
Subject: Re: [PATCH v4 8/8] zram: enable contextless compression alg in zram
Date: Thu, 15 Oct 2015 09:29:03 +0900
Message-ID: <20151015002903.GB1735@swordfish>
References: <1444808304-29320-1-git-send-email-iamjoonsoo.kim@lge.com>
 <1444808304-29320-9-git-send-email-iamjoonsoo.kim@lge.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Minchan Kim <minchan@kernel.org>,
	Nitin Gupta <ngupta@vflare.org>,
	Sergey Senozhatsky <sergey.senozhatsky.work@gmail.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	Stephan Mueller <smueller@chronox.de>,
	linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org,
	Joonsoo Kim <iamjoonsoo.kim@lge.com>
To: Joonsoo Kim <js1304@gmail.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-pa0-f41.google.com ([209.85.220.41]:33714 "EHLO
	mail-pa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751222AbbJOA2M (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 14 Oct 2015 20:28:12 -0400
Content-Disposition: inline
In-Reply-To: <1444808304-29320-9-git-send-email-iamjoonsoo.kim@lge.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi,

On (10/14/15 16:38), Joonsoo Kim wrote:
[..]
>  static const char * const backends[] = {
>  	"lzo",
> -#ifdef CONFIG_ZRAM_LZ4_COMPRESS
>  	"lz4",
> -#endif
>  	NULL
>  };
>  
>  static const char *find_backend(const char *compress)
>  {
> -	int i = 0;
> -	while (backends[i]) {
> -		if (sysfs_streq(compress, backends[i]) &&
> -			crypto_has_comp(backends[i], 0, 0))
> -			break;
> -		i++;
> -	}
> -	return backends[i];
> +	if (crypto_has_comp(compress, 0, 0))
> +		return compress;
> +
> +	return NULL;
>  }
>  
>  static void zcomp_strm_free(struct zcomp *comp, struct zcomp_strm *zstrm)
> @@ -277,6 +271,9 @@ ssize_t zcomp_available_show(const char *comp, char *buf)
>  	int i = 0;
>  
>  	while (backends[i]) {
> +		if (!crypto_has_comp(backends[i], 0, 0))
> +			continue;
> +

hm... this sort of looks a bit `unnatural' to me. we have two _independent_
sets -- what zram supports and what crypto supports. that's why you have
to do extra work and consult crypto. can we return back the old scheme:
use ifdef CONFIG in backends, but replace CONFIG_ZRAM with CONFIG_CRYPTO?

e.g.

	static const char * const backends[] = {
		"lzo",
	#ifdef CONFIG_CRYPTO_LZ4
		"lz4",
	#endif
		NULL
	};


so you can remove `crypto_has_comp(backends[i], 0, 0)' from
zcomp_available_show(), because zram will support *only* what
crypto supports.

	-ss


>  		if (!strcmp(comp, backends[i]))
>  			sz += scnprintf(buf + sz, PAGE_SIZE - sz - 2,
>  					"[%s] ", backends[i]);
> diff --git a/drivers/block/zram/zram_drv.c b/drivers/block/zram/zram_drv.c
> index 6f04fb2..6b4cf85 100644
> --- a/drivers/block/zram/zram_drv.c
> +++ b/drivers/block/zram/zram_drv.c
> @@ -352,6 +352,7 @@ static ssize_t comp_algorithm_show(struct device *dev,
>  	size_t sz;
>  	struct zram *zram = dev_to_zram(dev);
>  
> +	deprecated_attr_warn("comp_algorithm");
>  	down_read(&zram->init_lock);
>  	sz = zcomp_available_show(zram->compressor, buf);
>  	up_read(&zram->init_lock);
> -- 
> 1.9.1
> 

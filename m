From: Sergey Senozhatsky <sergey.senozhatsky.work@gmail.com>
Subject: Re: [PATCH v3 9/9] zram: use crypto decompress_noctx API
Date: Mon, 21 Sep 2015 16:56:00 +0900
Message-ID: <20150921075600.GA511@swordfish>
References: <1442553564-3476-1-git-send-email-iamjoonsoo.kim@lge.com>
 <1442553564-3476-10-git-send-email-iamjoonsoo.kim@lge.com>
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
Received: from mail-pa0-f46.google.com ([209.85.220.46]:36640 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755986AbbIUHzP (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 21 Sep 2015 03:55:15 -0400
Content-Disposition: inline
In-Reply-To: <1442553564-3476-10-git-send-email-iamjoonsoo.kim@lge.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On (09/18/15 14:19), Joonsoo Kim wrote:
[..]
> +	/*
> +	 * Prepare to use crypto decompress_noctx API. One tfm is required
> +	 * to initialize crypto algorithm properly and fetch corresponding
> +	 * function pointer. But, it is sharable for multiple concurrent
> +	 * decompress users.
> +	 */

if comp algorithm require zstrm for both compression and decompression,
then there seems to be no need in allocating sharable ->tfm_noctx, we
will never use it.

	-ss

> +	tfm = crypto_alloc_comp_noctx(compress, 0, 0);
> +	if (!IS_ERR(tfm))
> +		comp->tfm_noctx = tfm;
> +
>  	return comp;
>  }
> diff --git a/drivers/block/zram/zcomp.h b/drivers/block/zram/zcomp.h
> index 4f9df8e..c76d8e4 100644
> --- a/drivers/block/zram/zcomp.h
> +++ b/drivers/block/zram/zcomp.h
> @@ -26,6 +26,7 @@ struct zcomp_strm {
>  /* dynamic per-device compression frontend */
>  struct zcomp {
>  	void *stream;
> +	struct crypto_comp *tfm_noctx;
>  	const char *backend;
>  
>  	struct zcomp_strm *(*strm_find)(struct zcomp *comp);

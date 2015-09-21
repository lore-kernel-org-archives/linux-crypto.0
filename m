From: Sergey Senozhatsky <sergey.senozhatsky.work@gmail.com>
Subject: Re: [PATCH v3 9/9] zram: use crypto decompress_noctx API
Date: Mon, 21 Sep 2015 14:29:18 +0900
Message-ID: <20150921052918.GA5313@swordfish>
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
Received: from mail-pa0-f54.google.com ([209.85.220.54]:35797 "EHLO
	mail-pa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751894AbbIUF2d (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 21 Sep 2015 01:28:33 -0400
Content-Disposition: inline
In-Reply-To: <1442553564-3476-10-git-send-email-iamjoonsoo.kim@lge.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On (09/18/15 14:19), Joonsoo Kim wrote:
> -/* Never return NULL, may sleep */
> +/* May return NULL, may sleep */
>  struct zcomp_strm *zcomp_decompress_begin(struct zcomp *comp)
>  {
> +	if (comp->tfm_noctx)
> +		return NULL;
> +
>  	return zcomp_strm_find(comp);
>  }
>  
> @@ -346,11 +349,18 @@ int zcomp_decompress(struct zcomp *comp, struct zcomp_strm *zstrm,
>  {
>  	unsigned int size = PAGE_SIZE;
>  
> +	if (!zstrm) {
> +		return crypto_comp_decompress_noctx(comp->tfm_noctx,
> +						src, src_len, dst, &size);
> +	}

unneeded braces.

	-ss

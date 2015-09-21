From: Sergey Senozhatsky <sergey.senozhatsky.work@gmail.com>
Subject: Re: [PATCH v3 1/9] crypto: introduce decompression API that can be
 called via sharable tfm object
Date: Mon, 21 Sep 2015 15:18:17 +0900
Message-ID: <20150921061817.GC5313@swordfish>
References: <1442553564-3476-1-git-send-email-iamjoonsoo.kim@lge.com>
 <1442553564-3476-2-git-send-email-iamjoonsoo.kim@lge.com>
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
Received: from mail-pa0-f42.google.com ([209.85.220.42]:34866 "EHLO
	mail-pa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752501AbbIUGRb (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 21 Sep 2015 02:17:31 -0400
Content-Disposition: inline
In-Reply-To: <1442553564-3476-2-git-send-email-iamjoonsoo.kim@lge.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On (09/18/15 14:19), Joonsoo Kim wrote:
[..]
>  static int __init lzo_mod_init(void)
> diff --git a/include/linux/crypto.h b/include/linux/crypto.h
> index e71cb70..31152b1 100644
> --- a/include/linux/crypto.h
> +++ b/include/linux/crypto.h
> @@ -355,6 +355,8 @@ struct compress_alg {
>  			    unsigned int slen, u8 *dst, unsigned int *dlen);
>  	int (*coa_decompress)(struct crypto_tfm *tfm, const u8 *src,
>  			      unsigned int slen, u8 *dst, unsigned int *dlen);
> +	int (*coa_decompress_noctx)(const u8 *src, unsigned int slen,
> +				    u8 *dst, unsigned int *dlen);
>  };
>  
>  
> @@ -538,6 +540,9 @@ struct compress_tfm {
>  	int (*cot_decompress)(struct crypto_tfm *tfm,
>  	                      const u8 *src, unsigned int slen,
>  	                      u8 *dst, unsigned int *dlen);
> +	int (*cot_decompress_noctx)(struct crypto_tfm *tfm,
> +				const u8 *src, unsigned int slen,
> +				u8 *dst, unsigned int *dlen);
>  };
>  
>  #define crt_ablkcipher	crt_u.ablkcipher
> @@ -1836,6 +1841,14 @@ static inline void crypto_free_comp(struct crypto_comp *tfm)
>  	crypto_free_tfm(crypto_comp_tfm(tfm));
>  }
>  
> +struct crypto_comp *crypto_alloc_comp_noctx(const char *alg_name,
> +					u32 type, u32 mask);
> +

this should be EXPORT_SYMBOL_GPL().

	-ss

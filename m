From: Sergey Senozhatsky <sergey.senozhatsky.work@gmail.com>
Subject: Re: [PATCH v2 3/8] crypyo/lz4: support decompress_noctx
Date: Thu, 27 Aug 2015 10:56:19 +0900
Message-ID: <20150827015619.GB1545@swordfish>
References: <1440052504-15442-1-git-send-email-iamjoonsoo.kim@lge.com>
 <1440052504-15442-4-git-send-email-iamjoonsoo.kim@lge.com>
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
Received: from mail-pa0-f54.google.com ([209.85.220.54]:32843 "EHLO
	mail-pa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750968AbbH0Bzj (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 26 Aug 2015 21:55:39 -0400
Content-Disposition: inline
In-Reply-To: <1440052504-15442-4-git-send-email-iamjoonsoo.kim@lge.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On (08/20/15 15:34), Joonsoo Kim wrote:
> lz4's decompression doesn't requires any scratch buffer so
> it doesn't need tfm context. Hence, it can support
> crypto compression noctx API and this patch implements it.
> 
> Signed-off-by: Joonsoo Kim <iamjoonsoo.kim@lge.com>
> ---
>  crypto/lz4.c | 17 ++++++++++++++++-
>  1 file changed, 16 insertions(+), 1 deletion(-)
> 
> diff --git a/crypto/lz4.c b/crypto/lz4.c
> index 1848435..aa23da3 100644
> --- a/crypto/lz4.c
> +++ b/crypto/lz4.c
> @@ -76,6 +76,21 @@ static int lz4_decompress_crypto(struct crypto_tfm *tfm, const u8 *src,
>  	return err;
>  }
>  
> +static int lz4_decompress_noctx(const u8 *src, unsigned int slen,
> +				u8 *dst, unsigned int *dlen)
> +{
> +	int err;
> +	size_t tmp_len = *dlen;
> +	size_t __slen = slen;
> +
> +	err = lz4_decompress_unknownoutputsize(src, __slen, dst, &tmp_len);
> +	if (err < 0)
> +		return -EINVAL;
> +
> +	*dlen = tmp_len;
> +	return err;
> +}
> +

same,

static int lz4_decompress_noctx(const u8 *src, unsigned int slen,
				u8 *dst, unsigned int *dlen)
{
	return lz4_decompress_crypto(NULL, ....);
}

?

>  static struct crypto_alg alg_lz4 = {
>  	.cra_name		= "lz4",
>  	.cra_flags		= CRYPTO_ALG_TYPE_COMPRESS,
> @@ -88,7 +103,7 @@ static struct crypto_alg alg_lz4 = {
>  	.coa_compress		= lz4_compress_crypto,
>  	.coa_decompress		= lz4_decompress_crypto,
>  	.coa_compress_noctx	= NULL,
> -	.coa_decompress_noctx	= NULL } }
> +	.coa_decompress_noctx	= lz4_decompress_noctx } }
>  };
>  
>  static int __init lz4_mod_init(void)
> -- 
> 1.9.1
> 

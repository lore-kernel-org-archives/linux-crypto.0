From: Sergey Senozhatsky <sergey.senozhatsky.work@gmail.com>
Subject: Re: [PATCH v2 2/8] crypto/lzo: support decompress_noctx
Date: Thu, 27 Aug 2015 10:54:32 +0900
Message-ID: <20150827015432.GA1545@swordfish>
References: <1440052504-15442-1-git-send-email-iamjoonsoo.kim@lge.com>
 <1440052504-15442-3-git-send-email-iamjoonsoo.kim@lge.com>
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
In-Reply-To: <1440052504-15442-3-git-send-email-iamjoonsoo.kim@lge.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On (08/20/15 15:34), Joonsoo Kim wrote:
> lzo's decompression doesn't requires any scratch buffer so
> it doesn't need tfm context. Hence, it can support
> crypto compression noctx API and this patch implements it.
> 
> Signed-off-by: Joonsoo Kim <iamjoonsoo.kim@lge.com>
> ---
>  crypto/lzo.c | 18 +++++++++++++++++-
>  1 file changed, 17 insertions(+), 1 deletion(-)
> 
> diff --git a/crypto/lzo.c b/crypto/lzo.c
> index 9ca516b..f1844dd 100644
> --- a/crypto/lzo.c
> +++ b/crypto/lzo.c
> @@ -80,6 +80,22 @@ static int lzo_decompress(struct crypto_tfm *tfm, const u8 *src,
>  
>  }
>  
> +static int lzo_decompress_noctx(const u8 *src, unsigned int slen,
> +				u8 *dst, unsigned int *dlen)
> +{
> +	int err;
> +	size_t tmp_len = *dlen; /* size_t(ulong) <-> uint on 64 bit */
> +
> +	err = lzo1x_decompress_safe(src, slen, dst, &tmp_len);
> +
> +	if (err != LZO_E_OK)
> +		return -EINVAL;
> +
> +	*dlen = tmp_len;
> +	return 0;
> +

just do

static int lzo_decompress_noctx(const u8 *src, unsigned int slen,
				u8 *dst, unsigned int *dlen)
{
	return lzo_decompress(NULL, src, len, dst, dlen);
}

?

	-ss

> +}
> +
>  static struct crypto_alg alg = {
>  	.cra_name		= "lzo",
>  	.cra_flags		= CRYPTO_ALG_TYPE_COMPRESS,
> @@ -91,7 +107,7 @@ static struct crypto_alg alg = {
>  	.coa_compress 		= lzo_compress,
>  	.coa_decompress		= lzo_decompress,
>  	.coa_compress_noctx	= NULL,
> -	.coa_decompress_noctx	= NULL } }
> +	.coa_decompress_noctx	= lzo_decompress_noctx } }
>  };
>  
>  static int __init lzo_mod_init(void)
> -- 
> 1.9.1
> 

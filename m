From: Marek Vasut <marex@denx.de>
Subject: Re: [PATCH crypto 1/2] crypto: caam - fix mem leak in ahash_setkey
Date: Wed, 23 Apr 2014 01:47:32 +0200
Message-ID: <201404230147.32552.marex@denx.de>
References: <1397815302-15915-1-git-send-email-horia.geanta@freescale.com>
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	linux-crypto@vger.kernel.org, stable@vger.kernel.org
To: Horia Geanta <horia.geanta@freescale.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-out.m-online.net ([212.18.0.10]:55092 "EHLO
	mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751229AbaDVX7G (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 22 Apr 2014 19:59:06 -0400
In-Reply-To: <1397815302-15915-1-git-send-email-horia.geanta@freescale.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Friday, April 18, 2014 at 12:01:41 PM, Horia Geanta wrote:
> In case hash key is bigger than algorithm block size, it is hashed.
> In this case, memory is allocated to keep this hash in hashed_key.
> hashed_key has to be freed on the key_dma dma mapping error path.
> 
> Cc: <stable@vger.kernel.org> # 3.10+
> Signed-off-by: Horia Geanta <horia.geanta@freescale.com>
> ---
>  drivers/crypto/caam/caamhash.c | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/crypto/caam/caamhash.c
> b/drivers/crypto/caam/caamhash.c index 0378328f47a7..2d244e629ed2 100644
> --- a/drivers/crypto/caam/caamhash.c
> +++ b/drivers/crypto/caam/caamhash.c
> @@ -545,7 +545,8 @@ static int ahash_setkey(struct crypto_ahash *ahash,
>  				      DMA_TO_DEVICE);
>  	if (dma_mapping_error(jrdev, ctx->key_dma)) {
>  		dev_err(jrdev, "unable to map key i/o memory\n");
> -		return -ENOMEM;
> +		ret = -ENOMEM;
> +		goto map_err;
>  	}
>  #ifdef DEBUG
>  	print_hex_dump(KERN_ERR, "ctx.key@"__stringify(__LINE__)": ",
> @@ -559,6 +560,7 @@ static int ahash_setkey(struct crypto_ahash *ahash,
>  				 DMA_TO_DEVICE);
>  	}
> 
> +map_err:
>  	kfree(hashed_key);

Reviewed-by: Marek Vasut <marex@denx.de>

btw you might want to clean up the use of printk() vs. dev_*() throughout the 
driver, it's horribly intermixed. It'd be nice to use just dev_*() for output.
Stuff like
#ifdef DEBUG
printk(...)
#endif
can be easily replaced with dev_dbg() for example ...

Best regards,
Marek Vasut

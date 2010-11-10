From: Felipe Balbi <me@felipebalbi.com>
Subject: Re: [PATCH 2/5] omap-aes: DMA initialization fixes for OMAP off
 mode
Date: Wed, 10 Nov 2010 19:48:20 +0200
Message-ID: <1289411300.2785.1.camel@eowin>
References: <y>
	 <5625ae87a8364e1b10ebadfacbb7d27a5bcb12a5.1289409924.git.dmitry.kasatkin@nokia.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Cc: herbert@gondor.hengli.com.au, linux-crypto@vger.kernel.org,
	linux-omap@vger.kernel.org
To: Dmitry Kasatkin <dmitry.kasatkin@nokia.com>
Return-path: <linux-omap-owner@vger.kernel.org>
In-Reply-To: <5625ae87a8364e1b10ebadfacbb7d27a5bcb12a5.1289409924.git.dmitry.kasatkin@nokia.com>
Sender: linux-omap-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Hi,

On Wed, 2010-11-10 at 19:26 +0200, Dmitry Kasatkin wrote:
> diff --git a/drivers/crypto/omap-aes.c b/drivers/crypto/omap-aes.c
> index 9d65611..04cab70 100644
> --- a/drivers/crypto/omap-aes.c
> +++ b/drivers/crypto/omap-aes.c
> @@ -99,7 +99,7 @@ struct omap_aes_reqctx {
>  struct omap_aes_dev {
>  	struct list_head	list;
>  	unsigned long		phys_base;
> -	void __iomem 		*io_base;
> +	void __iomem		*io_base;
>  	struct clk		*iclk;
>  	struct omap_aes_ctx	*ctx;
>  	struct device		*dev;

this hunk is not part of this patch.

> @@ -752,7 +752,7 @@ static struct crypto_alg algs[] = {
>  	.cra_flags		= CRYPTO_ALG_TYPE_ABLKCIPHER | CRYPTO_ALG_ASYNC,
>  	.cra_blocksize		= AES_BLOCK_SIZE,
>  	.cra_ctxsize		= sizeof(struct omap_aes_ctx),
> -	.cra_alignmask	 	= 0,
> +	.cra_alignmask		= 0,
>  	.cra_type		= &crypto_ablkcipher_type,
>  	.cra_module		= THIS_MODULE,
>  	.cra_init		= omap_aes_cra_init,

not part of this patch.

> @@ -772,7 +772,7 @@ static struct crypto_alg algs[] = {
>  	.cra_flags		= CRYPTO_ALG_TYPE_ABLKCIPHER | CRYPTO_ALG_ASYNC,
>  	.cra_blocksize		= AES_BLOCK_SIZE,
>  	.cra_ctxsize		= sizeof(struct omap_aes_ctx),
> -	.cra_alignmask	 	= 0,
> +	.cra_alignmask		= 0,
>  	.cra_type		= &crypto_ablkcipher_type,
>  	.cra_module		= THIS_MODULE,
>  	.cra_init		= omap_aes_cra_init,

not part of this patch

-- 
balbi


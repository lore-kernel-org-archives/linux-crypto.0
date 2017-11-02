From: Eric Biggers <ebiggers3@gmail.com>
Subject: Re: [PATCH 3/4] crypto: qat - fix double free of ctx->p
Date: Thu, 2 Nov 2017 10:34:04 -0700
Message-ID: <20171102173404.GC23035@gmail.com>
References: <20171101222517.41602-1-ebiggers3@gmail.com>
 <20171101222517.41602-4-ebiggers3@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: keyrings@vger.kernel.org,
        Tudor-Dan Ambarus <tudor.ambarus@microchip.com>,
        Mat Martineau <mathew.j.martineau@linux.intel.com>,
        Salvatore Benedetto <salvatore.benedetto@intel.com>,
        Stephan Mueller <smueller@chronox.de>,
        Eric Biggers <ebiggers@google.com>, stable@vger.kernel.org
To: linux-crypto@vger.kernel.org,
        Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <stable-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20171101222517.41602-4-ebiggers3@gmail.com>
Sender: stable-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Wed, Nov 01, 2017 at 03:25:16PM -0700, Eric Biggers wrote:
> From: Eric Biggers <ebiggers@google.com>
> 
> When setting the secret with the "qat-dh" Diffie-Hellman implementation,
> if allocating 'g' failed, then 'p' was freed twice: once immediately,
> and once later when the crypto_kpp tfm was destroyed.  Fix it by using
> qat_dh_clear_ctx() in the error paths, as that sets the pointers to
> NULL.
> 
> Fixes: c9839143ebbf ("crypto: qat - Add DH support")
> Cc: <stable@vger.kernel.org> # v4.8+
> Signed-off-by: Eric Biggers <ebiggers@google.com>
> ---
>  drivers/crypto/qat/qat_common/qat_asym_algs.c | 15 ++++++++-------
>  1 file changed, 8 insertions(+), 7 deletions(-)
> 
> diff --git a/drivers/crypto/qat/qat_common/qat_asym_algs.c b/drivers/crypto/qat/qat_common/qat_asym_algs.c
> index 6f5dd68449c6..7655fdb499de 100644
> --- a/drivers/crypto/qat/qat_common/qat_asym_algs.c
> +++ b/drivers/crypto/qat/qat_common/qat_asym_algs.c
> @@ -462,11 +462,8 @@ static int qat_dh_set_params(struct qat_dh_ctx *ctx, struct dh *params)
>  	}
>  
>  	ctx->g = dma_zalloc_coherent(dev, ctx->p_size, &ctx->dma_g, GFP_KERNEL);
> -	if (!ctx->g) {
> -		dma_free_coherent(dev, ctx->p_size, ctx->p, ctx->dma_p);
> -		ctx->p = NULL;
> +	if (!ctx->g)

Sorry, I misread this code (and I didn't have the hardware to test this driver);
there is actually no bug here because it sets ctx->p to NULL.

I think we should still do this patch to simplify the code, but I'll update the
description to reflect that it's not actually fixing anything.

Eric

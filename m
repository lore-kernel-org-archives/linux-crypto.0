Return-Path: <SRS0=/v7T=NZ=vger.kernel.org=linux-crypto-owner@kernel.org>
Received: from mail.bootlin.com ([62.4.15.54]:51063 "EHLO mail.bootlin.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725952AbeKOJpV (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 15 Nov 2018 04:45:21 -0500
Date: Thu, 15 Nov 2018 00:39:47 +0100
From: Antoine Tenart <antoine.tenart@bootlin.com>
To: Eric Biggers <ebiggers@kernel.org>
Cc: linux-crypto@vger.kernel.org,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Antoine Tenart <antoine.tenart@bootlin.com>
Subject: Re: [PATCH] crypto: inside-secure - remove useless setting of type
 flags
Message-ID: <20181114233947.GA4767@kwain>
References: <20181114191053.3534-1-ebiggers@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20181114191053.3534-1-ebiggers@kernel.org>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi Eric,

On Wed, Nov 14, 2018 at 11:10:53AM -0800, Eric Biggers wrote:
> From: Eric Biggers <ebiggers@google.com>
> 
> Remove the unnecessary setting of CRYPTO_ALG_TYPE_SKCIPHER.
> Commit 2c95e6d97892 ("crypto: skcipher - remove useless setting of type
> flags") took care of this everywhere else, but a few more instances made
> it into the tree at about the same time.  Squash them before they get
> copy+pasted around again.
> 
> This patch shouldn't change any actual behavior.
> 
> Signed-off-by: Eric Biggers <ebiggers@google.com>

Acked-by: Antoine Tenart <antoine.tenart@bootlin.com>

Thanks!
Antoine

> ---
>  drivers/crypto/inside-secure/safexcel_cipher.c | 8 ++++----
>  1 file changed, 4 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/crypto/inside-secure/safexcel_cipher.c b/drivers/crypto/inside-secure/safexcel_cipher.c
> index 3aef1d43e4351..d531c14020dcb 100644
> --- a/drivers/crypto/inside-secure/safexcel_cipher.c
> +++ b/drivers/crypto/inside-secure/safexcel_cipher.c
> @@ -970,7 +970,7 @@ struct safexcel_alg_template safexcel_alg_cbc_des = {
>  			.cra_name = "cbc(des)",
>  			.cra_driver_name = "safexcel-cbc-des",
>  			.cra_priority = 300,
> -			.cra_flags = CRYPTO_ALG_TYPE_SKCIPHER | CRYPTO_ALG_ASYNC |
> +			.cra_flags = CRYPTO_ALG_ASYNC |
>  				     CRYPTO_ALG_KERN_DRIVER_ONLY,
>  			.cra_blocksize = DES_BLOCK_SIZE,
>  			.cra_ctxsize = sizeof(struct safexcel_cipher_ctx),
> @@ -1010,7 +1010,7 @@ struct safexcel_alg_template safexcel_alg_ecb_des = {
>  			.cra_name = "ecb(des)",
>  			.cra_driver_name = "safexcel-ecb-des",
>  			.cra_priority = 300,
> -			.cra_flags = CRYPTO_ALG_TYPE_SKCIPHER | CRYPTO_ALG_ASYNC |
> +			.cra_flags = CRYPTO_ALG_ASYNC |
>  				     CRYPTO_ALG_KERN_DRIVER_ONLY,
>  			.cra_blocksize = DES_BLOCK_SIZE,
>  			.cra_ctxsize = sizeof(struct safexcel_cipher_ctx),
> @@ -1074,7 +1074,7 @@ struct safexcel_alg_template safexcel_alg_cbc_des3_ede = {
>  			.cra_name = "cbc(des3_ede)",
>  			.cra_driver_name = "safexcel-cbc-des3_ede",
>  			.cra_priority = 300,
> -			.cra_flags = CRYPTO_ALG_TYPE_SKCIPHER | CRYPTO_ALG_ASYNC |
> +			.cra_flags = CRYPTO_ALG_ASYNC |
>  				     CRYPTO_ALG_KERN_DRIVER_ONLY,
>  			.cra_blocksize = DES3_EDE_BLOCK_SIZE,
>  			.cra_ctxsize = sizeof(struct safexcel_cipher_ctx),
> @@ -1114,7 +1114,7 @@ struct safexcel_alg_template safexcel_alg_ecb_des3_ede = {
>  			.cra_name = "ecb(des3_ede)",
>  			.cra_driver_name = "safexcel-ecb-des3_ede",
>  			.cra_priority = 300,
> -			.cra_flags = CRYPTO_ALG_TYPE_SKCIPHER | CRYPTO_ALG_ASYNC |
> +			.cra_flags = CRYPTO_ALG_ASYNC |
>  				     CRYPTO_ALG_KERN_DRIVER_ONLY,
>  			.cra_blocksize = DES3_EDE_BLOCK_SIZE,
>  			.cra_ctxsize = sizeof(struct safexcel_cipher_ctx),
> -- 
> 2.19.1.930.g4563a0d9d0-goog
> 

-- 
Antoine Ténart, Bootlin
Embedded Linux and Kernel engineering
https://bootlin.com

From: Jason Cooper <jason@lakedaemon.net>
Subject: Re: [PATCH] crypto: mv_cesa requires on CRYPTO_HASH to build
Date: Sat, 12 May 2012 10:02:19 -0400
Message-ID: <20120512140219.GB16338@titan.lakedaemon.net>
References: <1336812308-32501-1-git-send-email-alex@digriz.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org
To: Alexander Clouter <alex@digriz.org.uk>, herbert@gondor.apana.org.au
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mho-02-ewr.mailhop.org ([204.13.248.72]:30358 "EHLO
	mho-02-ewr.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752730Ab2ELOCZ (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Sat, 12 May 2012 10:02:25 -0400
Content-Disposition: inline
In-Reply-To: <1336812308-32501-1-git-send-email-alex@digriz.org.uk>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Herbert,

I'm putting together a pull request of fixes for arm:kirkwood
3.4/stable, shall I add this to my tree, or would you like to take it in
through yours?

On Sat, May 12, 2012 at 09:45:08AM +0100, Alexander Clouter wrote:
> Without CRYPTO_HASH being selected, mv_cesa has a lot of hooks
> into undefined exports.
> ----

Alexander,

minor nit: Do you intend the below to be a part of the commit message?
You may want to choose a different separator...

>   MODPOST 81 modules
>   Kernel: arch/arm/boot/Image is ready
>   AS      arch/arm/boot/compressed/head.o
>   GZIP    arch/arm/boot/compressed/piggy.gzip
>   CC      arch/arm/boot/compressed/misc.o
>   CC      arch/arm/boot/compressed/decompress.o
> ERROR: "crypto_ahash_type" [drivers/crypto/mv_cesa.ko] undefined!
> ERROR: "crypto_shash_final" [drivers/crypto/mv_cesa.ko] undefined!
> ERROR: "crypto_register_ahash" [drivers/crypto/mv_cesa.ko] undefined!
> ERROR: "crypto_unregister_ahash" [drivers/crypto/mv_cesa.ko] undefined!
> ERROR: "crypto_shash_update" [drivers/crypto/mv_cesa.ko] undefined!
> ERROR: "crypto_shash_digest" [drivers/crypto/mv_cesa.ko] undefined!
> ERROR: "crypto_shash_setkey" [drivers/crypto/mv_cesa.ko] undefined!
> ERROR: "crypto_alloc_shash" [drivers/crypto/mv_cesa.ko] undefined!
> make[1]: *** [__modpost] Error 1
> make: *** [modules] Error 2
> make: *** Waiting for unfinished jobs....
> ----
> 
> Signed-off-by: Alexander Clouter <alex@digriz.org.uk>

Acked-By: Jason Cooper <jason@lakedaemon.net>

thx,

Jason.

> ---
>  drivers/crypto/Kconfig |    1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/drivers/crypto/Kconfig b/drivers/crypto/Kconfig
> index e707979..07dbc77 100644
> --- a/drivers/crypto/Kconfig
> +++ b/drivers/crypto/Kconfig
> @@ -173,6 +173,7 @@ config CRYPTO_DEV_MV_CESA
>  	select CRYPTO_ALGAPI
>  	select CRYPTO_AES
>  	select CRYPTO_BLKCIPHER2
> +	select CRYPTO_HASH
>  	help
>  	  This driver allows you to utilize the Cryptographic Engines and
>  	  Security Accelerator (CESA) which can be found on the Marvell Orion
> -- 
> 1.7.10
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-crypto" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

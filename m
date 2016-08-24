From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH 3/5] hwrng: amd: Be consitent with the driver name
Date: Wed, 24 Aug 2016 18:58:11 +0800
Message-ID: <20160824105811.GA2120@gondor.apana.org.au>
References: <1471614177-12380-1-git-send-email-clabbe.montjoie@gmail.com>
 <1471614177-12380-3-git-send-email-clabbe.montjoie@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: mpm@selenic.com, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org
To: LABBE Corentin <clabbe.montjoie@gmail.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:36234 "EHLO
        helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755246AbcHXK6j (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 24 Aug 2016 06:58:39 -0400
Content-Disposition: inline
In-Reply-To: <1471614177-12380-3-git-send-email-clabbe.montjoie@gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Fri, Aug 19, 2016 at 03:42:55PM +0200, LABBE Corentin wrote:
> The driver name is displayed each time differently.
> This patch make use of the same name everywhere.
> 
> Signed-off-by: LABBE Corentin <clabbe.montjoie@gmail.com>
> ---
>  drivers/char/hw_random/amd-rng.c | 13 ++++++-------
>  1 file changed, 6 insertions(+), 7 deletions(-)
> 
> diff --git a/drivers/char/hw_random/amd-rng.c b/drivers/char/hw_random/amd-rng.c
> index d0042f5..d0a806a 100644
> --- a/drivers/char/hw_random/amd-rng.c
> +++ b/drivers/char/hw_random/amd-rng.c
> @@ -31,7 +31,7 @@
>  #include <linux/delay.h>
>  #include <asm/io.h>
>  
> -#define PFX	KBUILD_MODNAME ": "
> +#define DRV_NAME "AMD768-HWRNG"
>  
>  /*
>   * Data for PCI driver interface
> @@ -98,7 +98,7 @@ static void amd_rng_cleanup(struct hwrng *rng)
>  }
>  
>  static struct hwrng amd_rng = {
> -	.name		= "amd",
> +	.name		= DRV_NAME,

Hmm, this changes a sysfs-exported name which has the potential
to break user-space.  So I think you'd need to a stronger argument
to do it other than just cleaning it up.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt

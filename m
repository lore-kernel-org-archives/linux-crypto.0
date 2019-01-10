Return-Path: <SRS0=+HSe=PS=vger.kernel.org=linux-crypto-owner@kernel.org>
Received: from orcrist.hmeau.com ([104.223.48.154]:59550 "EHLO
        deadmen.hmeau.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728088AbfAJN0x (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 10 Jan 2019 08:26:53 -0500
Date: Thu, 10 Jan 2019 21:26:22 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Aditya Pakki <pakki001@umn.edu>
Cc: kjlu@umn.edu, Matt Mackall <mpm@selenic.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Michael S. Tsirkin" <mst@redhat.com>, Michael Buesch <m@bues.ch>,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] [v2] hwrng: core: Fix missing check during driver release
Message-ID: <20190110132622.ni5lshjmhmsydaal@gondor.apana.org.au>
References: <20190106172613.10913-1-pakki001@umn.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190106172613.10913-1-pakki001@umn.edu>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Sun, Jan 06, 2019 at 11:26:12AM -0600, Aditya Pakki wrote:
> devres_release can return -ENOENT if the device is not freed. The fix
> throws a warning consistent with other invocations.
> 
> Signed-off-by: Aditya Pakki <pakki001@umn.edu>
> ---
>  drivers/char/hw_random/core.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/char/hw_random/core.c b/drivers/char/hw_random/core.c
> index 95be7228f327..1b05da40626a 100644
> --- a/drivers/char/hw_random/core.c
> +++ b/drivers/char/hw_random/core.c
> @@ -578,7 +578,8 @@ EXPORT_SYMBOL_GPL(devm_hwrng_register);
>  
>  void devm_hwrng_unregister(struct device *dev, struct hwrng *rng)
>  {
> -	devres_release(dev, devm_hwrng_release, devm_hwrng_match, rng);
> +	WARN_ON(devres_release(dev, devm_hwrng_release,
> +				devm_hwrng_match, rng));

Hmm please don't perform real operations within a WARN_ON.  This
is potentially confusing to the reader.  If you had to do this, do
it like

	err = devres_release(...);
	WARN_ON(err);

I'd also like to know under what circumstances can you get an
-ENOENT?

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt

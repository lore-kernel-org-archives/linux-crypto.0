Return-Path: <SRS0=VXLt=PD=vger.kernel.org=linux-crypto-owner@kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:57402 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727285AbeLZRoT (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 26 Dec 2018 12:44:19 -0500
Date: Wed, 26 Dec 2018 12:44:16 -0500
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Aditya Pakki <pakki001@umn.edu>
Cc: kjlu@umn.edu, Matt Mackall <mpm@selenic.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Michael Buesch <m@bues.ch>, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] char: hw_random: Fix missing check during driver release
Message-ID: <20181226124405-mutt-send-email-mst@kernel.org>
References: <20181226172332.6365-1-pakki001@umn.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20181226172332.6365-1-pakki001@umn.edu>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Wed, Dec 26, 2018 at 11:23:31AM -0600, Aditya Pakki wrote:
> devres_release can return -ENOENT if the device is not freed. The fix
> throws a warning consistent with other invocations.
> 
> Signed-off-by: Aditya Pakki <pakki001@umn.edu>

Well why not

Acked-by: Michael S. Tsirkin <mst@redhat.com>


> ---
>  drivers/char/hw_random/core.c | 6 +++++-
>  1 file changed, 5 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/char/hw_random/core.c b/drivers/char/hw_random/core.c
> index 95be7228f327..582d983fa93f 100644
> --- a/drivers/char/hw_random/core.c
> +++ b/drivers/char/hw_random/core.c
> @@ -578,7 +578,11 @@ EXPORT_SYMBOL_GPL(devm_hwrng_register);
>  
>  void devm_hwrng_unregister(struct device *dev, struct hwrng *rng)
>  {
> -	devres_release(dev, devm_hwrng_release, devm_hwrng_match, rng);
> +	int rc;
> +
> +	rc = devres_release(dev, devm_hwrng_release, devm_hwrng_match, rng);
> +	if (rc)
> +		WARN_ON(rc);
>  }
>  EXPORT_SYMBOL_GPL(devm_hwrng_unregister);
>  
> -- 
> 2.17.1

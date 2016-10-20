From: Kevin Hilman <khilman@baylibre.com>
Subject: Re: [PATCH] hwrng: meson: Remove unneeded platform MODULE_ALIAS
Date: Thu, 20 Oct 2016 09:24:22 -0700
Message-ID: <7h4m477zux.fsf@baylibre.com>
References: <1476906618-14455-1-git-send-email-javier@osg.samsung.com>
Mime-Version: 1.0
Content-Type: text/plain
Cc: linux-kernel@vger.kernel.org,
        Neil Armstrong <narmstrong@baylibre.com>,
        PrasannaKumar Muralidharan <prasannatsmkumar@gmail.com>,
        Carlo Caione <carlo@caione.org>,
        linux-amlogic@lists.infradead.org,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Matt Mackall <mpm@selenic.com>,
        linux-arm-kernel@lists.infradead.org, linux-crypto@vger.kernel.org
To: Javier Martinez Canillas <javier@osg.samsung.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1476906618-14455-1-git-send-email-javier@osg.samsung.com>
        (Javier Martinez Canillas's message of "Wed, 19 Oct 2016 16:50:18
        -0300")
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Javier Martinez Canillas <javier@osg.samsung.com> writes:

> The Amlogic Meson is a DT-only platform, which means the devices are
> registered via OF and not using the legacy platform devices support.
>
> So there's no need to have a MODULE_ALIAS("platform:meson-rng") since
> the reported uevent MODALIAS to user-space will always be the OF one.
>
> Signed-off-by: Javier Martinez Canillas <javier@osg.samsung.com>

Acked-by: Kevin Hilman <khilman@baylibre.com>

> ---
>
>  drivers/char/hw_random/meson-rng.c | 1 -
>  1 file changed, 1 deletion(-)
>
> diff --git a/drivers/char/hw_random/meson-rng.c b/drivers/char/hw_random/meson-rng.c
> index 51864a509be7..119d698439ae 100644
> --- a/drivers/char/hw_random/meson-rng.c
> +++ b/drivers/char/hw_random/meson-rng.c
> @@ -122,7 +122,6 @@ static struct platform_driver meson_rng_driver = {
>  
>  module_platform_driver(meson_rng_driver);
>  
> -MODULE_ALIAS("platform:meson-rng");
>  MODULE_DESCRIPTION("Meson H/W Random Number Generator driver");
>  MODULE_AUTHOR("Lawrence Mok <lawrence.mok@amlogic.com>");
>  MODULE_AUTHOR("Neil Armstrong <narmstrong@baylibre.com>");

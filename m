From: Neil Armstrong <narmstrong@baylibre.com>
Subject: Re: [PATCH] hwrng: meson: Remove unneeded platform MODULE_ALIAS
Date: Fri, 21 Oct 2016 16:11:28 +0200
Message-ID: <29086305-c8a7-ba17-5e99-3a779b9dd410@baylibre.com>
References: <1476906618-14455-1-git-send-email-javier@osg.samsung.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Cc: Kevin Hilman <khilman@baylibre.com>,
        PrasannaKumar Muralidharan <prasannatsmkumar@gmail.com>,
        Carlo Caione <carlo@caione.org>,
        linux-amlogic@lists.infradead.org,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Matt Mackall <mpm@selenic.com>,
        linux-arm-kernel@lists.infradead.org, linux-crypto@vger.kernel.org
To: Javier Martinez Canillas <javier@osg.samsung.com>,
        linux-kernel@vger.kernel.org
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1476906618-14455-1-git-send-email-javier@osg.samsung.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On 10/19/2016 09:50 PM, Javier Martinez Canillas wrote:
> The Amlogic Meson is a DT-only platform, which means the devices are
> registered via OF and not using the legacy platform devices support.
> 
> So there's no need to have a MODULE_ALIAS("platform:meson-rng") since
> the reported uevent MODALIAS to user-space will always be the OF one.
> 
> Signed-off-by: Javier Martinez Canillas <javier@osg.samsung.com>
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
> 

Acked-by: Neil Armstrong <narmstrong@baylibre.com>

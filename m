From: Stephen Boyd <swboyd@chromium.org>
Subject: Re: [PATCH 1/3] hwrng: msm - Move hwrng to a table
Date: Mon, 18 Jun 2018 08:58:24 -0700
Message-ID: <152933750484.16708.1950713243960317531@swboyd.mtv.corp.google.com>
References: <20180618141259.23141-1-vkoul@kernel.org>
 <20180618141259.23141-2-vkoul@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable
Cc: Matt Mackall <mpm@selenic.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-arm-msm@vger.kernel.org, Vinod Koul <vkoul@kernel.org>
To: Vinod Koul <vinod.koul@linaro.org>, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180618141259.23141-2-vkoul@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Quoting Vinod Koul (2018-06-18 07:12:57)
> @@ -127,6 +125,13 @@ static void msm_rng_cleanup(struct hwrng *hwrng)
>         msm_rng_enable(hwrng, 0);
>  }
>  =

> +static struct hwrng msm_rng =3D {
> +       .name =3D KBUILD_MODNAME,
> +       .init =3D msm_rng_init,
> +       .cleanup =3D msm_rng_cleanup,
> +       .read =3D msm_rng_read,
> +};
> +
>  static int msm_rng_probe(struct platform_device *pdev)
>  {
>         struct resource *res;
> @@ -148,12 +153,10 @@ static int msm_rng_probe(struct platform_device *pd=
ev)
>         if (IS_ERR(rng->clk))
>                 return PTR_ERR(rng->clk);
>  =

> -       rng->hwrng.name =3D KBUILD_MODNAME,
> -       rng->hwrng.init =3D msm_rng_init,
> -       rng->hwrng.cleanup =3D msm_rng_cleanup,

Wouldn't it be a lot easier to skip assigning the init and cleanup
functions on v2 devices with an if statement? It would be smaller size
wise too because then we don't have two structs for v1 and v2 hwrngs.
Plus the patch would be smaller overall because we would do everything
else pretty much the same besides the if condition in probe.

> -       rng->hwrng.read =3D msm_rng_read,
> +       rng->hwrng =3D &msm_rng;
>  =

> -       ret =3D devm_hwrng_register(&pdev->dev, &rng->hwrng);
> +       rng->hwrng->priv =3D (unsigned long)rng;
> +       ret =3D devm_hwrng_register(&pdev->dev, rng->hwrng);
>         if (ret) {
>                 dev_err(&pdev->dev, "failed to register hwrng\n");
>                 return ret;
> -- =

> 2.14.4
>=20

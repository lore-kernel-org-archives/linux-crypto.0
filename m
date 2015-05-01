From: Florian Fainelli <f.fainelli@gmail.com>
Subject: Re: [PATCH] hw_random: bcm63xx-rng: fix bugs introduced in commit
 6229c16060fee9a015bf476f21e40c6f08609d6e.
Date: Fri, 01 May 2015 10:27:48 -0700
Message-ID: <5543B794.3070906@gmail.com>
References: <1430491041-24480-1-git-send-email-noltari@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
To: =?UTF-8?B?w4FsdmFybyBGZXJuw6FuZGV6IFJvamFz?= <noltari@gmail.com>,
	herbert@gondor.apana.org.au, dmitry.torokhov@gmail.com,
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
	jogo@openwrt.org, cernekee@gmail.com
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1430491041-24480-1-git-send-email-noltari@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On 01/05/15 07:37, =C3=81lvaro Fern=C3=A1ndez Rojas wrote:
> s/clk_didsable_unprepare/clk_disable_unprepare
> s/prov/priv
> s/error/ret in bcm63xx_rng_probe

Thanks for fixing that!

Could you resubmit with a "Fixes" tag like this and remove the long
commit id from the subject?

=46ixes: 6229c16060fe ("hwrng: bcm63xx - make use of devm_hwrng_registe=
r")

Acked-by: Florian Fainelli <f.fainelli@gmail.com>

Even for mechanical devm_* transformations, it would be nice to be CC'd
on the patches ;)

>=20
> Signed-off-by: =C3=81lvaro Fern=C3=A1ndez Rojas <noltari@gmail.com>
> ---
>  drivers/char/hw_random/bcm63xx-rng.c | 18 +++++++++---------
>  1 file changed, 9 insertions(+), 9 deletions(-)
>=20
> diff --git a/drivers/char/hw_random/bcm63xx-rng.c b/drivers/char/hw_r=
andom/bcm63xx-rng.c
> index d1494ec..4b31f13 100644
> --- a/drivers/char/hw_random/bcm63xx-rng.c
> +++ b/drivers/char/hw_random/bcm63xx-rng.c
> @@ -57,7 +57,7 @@ static void bcm63xx_rng_cleanup(struct hwrng *rng)
>  	val &=3D ~RNG_EN;
>  	__raw_writel(val, priv->regs + RNG_CTRL);
> =20
> -	clk_didsable_unprepare(prov->clk);
> +	clk_disable_unprepare(priv->clk);
>  }
> =20
>  static int bcm63xx_rng_data_present(struct hwrng *rng, int wait)
> @@ -97,14 +97,14 @@ static int bcm63xx_rng_probe(struct platform_devi=
ce *pdev)
>  	priv->rng.name =3D pdev->name;
>  	priv->rng.init =3D bcm63xx_rng_init;
>  	priv->rng.cleanup =3D bcm63xx_rng_cleanup;
> -	prov->rng.data_present =3D bcm63xx_rng_data_present;
> +	priv->rng.data_present =3D bcm63xx_rng_data_present;
>  	priv->rng.data_read =3D bcm63xx_rng_data_read;
> =20
>  	priv->clk =3D devm_clk_get(&pdev->dev, "ipsec");
>  	if (IS_ERR(priv->clk)) {
> -		error =3D PTR_ERR(priv->clk);
> -		dev_err(&pdev->dev, "no clock for device: %d\n", error);
> -		return error;
> +		ret =3D PTR_ERR(priv->clk);
> +		dev_err(&pdev->dev, "no clock for device: %d\n", ret);
> +		return ret;
>  	}
> =20
>  	if (!devm_request_mem_region(&pdev->dev, r->start,
> @@ -120,11 +120,11 @@ static int bcm63xx_rng_probe(struct platform_de=
vice *pdev)
>  		return -ENOMEM;
>  	}
> =20
> -	error =3D devm_hwrng_register(&pdev->dev, &priv->rng);
> -	if (error) {
> +	ret =3D devm_hwrng_register(&pdev->dev, &priv->rng);
> +	if (ret) {
>  		dev_err(&pdev->dev, "failed to register rng device: %d\n",
> -			error);
> -		return error;
> +			ret);
> +		return ret;
>  	}
> =20
>  	dev_info(&pdev->dev, "registered RNG driver\n");
>=20


--=20
=46lorian

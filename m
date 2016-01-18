From: Florian Fainelli <f.fainelli-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH 2/4] hw_random: bcm63xx-rng: add device tree support
Date: Mon, 18 Jan 2016 11:12:39 -0800
Message-ID: <569D3927.3030401@gmail.com>
References: <1453021437-12531-2-git-send-email-noltari@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
To: =?UTF-8?Q?=c3=81lvaro_Fern=c3=a1ndez_Rojas?= <noltari-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>,
	linux-crypto-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, herbert-lOAM2aK0SrRLBo1qDEOMRrpzq4S04n8Q@public.gmane.org,
	linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, devicetree-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	jogo-p3rKhJxN3npAfugRpC6u6w@public.gmane.org, cernekee-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Return-path: <devicetree-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1453021437-12531-2-git-send-email-noltari-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: devicetree-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-crypto.vger.kernel.org

Le 17/01/2016 01:03, =C3=81lvaro Fern=C3=A1ndez Rojas a =C3=A9crit :
> Adds device tree support for BCM6368, which seems to be the only BCM6=
3xx with
> bcm63xx-rng support.
>=20
> Signed-off-by: =C3=81lvaro Fern=C3=A1ndez Rojas <noltari-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
> ---
>  drivers/char/hw_random/bcm63xx-rng.c | 7 +++++++
>  1 file changed, 7 insertions(+)
>=20
> diff --git a/drivers/char/hw_random/bcm63xx-rng.c b/drivers/char/hw_r=
andom/bcm63xx-rng.c
> index c303f30..38553f0 100644
> --- a/drivers/char/hw_random/bcm63xx-rng.c
> +++ b/drivers/char/hw_random/bcm63xx-rng.c
> @@ -130,10 +130,17 @@ static int bcm63xx_rng_probe(struct platform_de=
vice *pdev)
>  	return 0;
>  }
> =20

#ifdef CONFIG_OF here?

> +static const struct of_device_id bcm63xx_rng_of_match[] =3D {
> +	{ .compatible =3D "brcm,bcm6368-rng", },
> +	{},
> +};
> +MODULE_DEVICE_TABLE(of, bcm63xx_rng_of_match);
> +
>  static struct platform_driver bcm63xx_rng_driver =3D {
>  	.probe		=3D bcm63xx_rng_probe,
>  	.driver		=3D {
>  		.name	=3D "bcm63xx-rng",
> +		.of_match_table =3D bcm63xx_rng_of_match,

of_match_ptr(bcm63xx_rng_of_match) would be nice here as well since we
can still build this driver for BCM63XX which is not OF enabled.

Other than that:

Reviewed-by: Florian Fainelli <f.fainelli-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
--=20
=46lorian
--
To unsubscribe from this list: send the line "unsubscribe devicetree" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

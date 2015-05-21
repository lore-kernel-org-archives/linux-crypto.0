From: Pali =?utf-8?B?Um9ow6Fy?= <pali.rohar@gmail.com>
Subject: Re: [PATCH 01/10] ARM: OMAP2+: Return correct error values from
 device and hwmod
Date: Thu, 21 May 2015 13:44:48 +0200
Message-ID: <20150521114448.GB8329@pali>
References: <1424958600-18881-1-git-send-email-pali.rohar@gmail.com>
 <1424958600-18881-2-git-send-email-pali.rohar@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-omap@vger.kernel.org, devicetree@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org,
	Pavel Machek <pavel@ucw.cz>, Nishanth Menon <nm@ti.com>,
	Ivaylo Dimitrov <ivo.g.dimitrov.75@gmail.com>,
	Aaro Koskinen <aaro.koskinen@iki.fi>,
	Sebastian Reichel <sre@kernel.org>,
	=?utf-8?Q?Beno=C3=AEt?= Cousson <bcousson@baylibre.com>,
	Tony Lindgren <tony@atomide.com>,
	Rob Herring <robh+dt@kernel.org>,
	Russell King <linux@arm.linux.org.uk>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>
To: Paul Walmsley <paul@pwsan.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-wi0-f177.google.com ([209.85.212.177]:37212 "EHLO
	mail-wi0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752824AbbEULow (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 21 May 2015 07:44:52 -0400
Content-Disposition: inline
In-Reply-To: <1424958600-18881-2-git-send-email-pali.rohar@gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Thursday 26 February 2015 14:49:51 Pali Roh=C3=A1r wrote:
> Without this patch function pm_runtime_get_sync() returns 0 even when=
 some
> omap subfunction fails. This patch properly propagate error codes fro=
m omap
> functions back to caller.
>=20
> This patch fix problem, when loading omap-aes driver in qemu cause ke=
rnel oops.
>=20
> Signed-off-by: Pali Roh=C3=A1r <pali.rohar@gmail.com>
> ---
>  arch/arm/mach-omap2/omap_device.c |   30 +++++++++++++++++----------=
---
>  arch/arm/mach-omap2/omap_hwmod.c  |   10 ++++++----
>  2 files changed, 23 insertions(+), 17 deletions(-)
>=20
> diff --git a/arch/arm/mach-omap2/omap_device.c b/arch/arm/mach-omap2/=
omap_device.c
> index be9541e..9fd47a9 100644
> --- a/arch/arm/mach-omap2/omap_device.c
> +++ b/arch/arm/mach-omap2/omap_device.c
> @@ -224,13 +224,13 @@ static int _omap_device_notifier_call(struct no=
tifier_block *nb,
>   */
>  static int _omap_device_enable_hwmods(struct omap_device *od)
>  {
> +	int ret =3D 0;
>  	int i;
> =20
>  	for (i =3D 0; i < od->hwmods_cnt; i++)
> -		omap_hwmod_enable(od->hwmods[i]);
> +		ret |=3D omap_hwmod_enable(od->hwmods[i]);
> =20
> -	/* XXX pass along return value here? */
> -	return 0;
> +	return ret;
>  }
> =20
>  /**
> @@ -241,13 +241,13 @@ static int _omap_device_enable_hwmods(struct om=
ap_device *od)
>   */
>  static int _omap_device_idle_hwmods(struct omap_device *od)
>  {
> +	int ret =3D 0;
>  	int i;
> =20
>  	for (i =3D 0; i < od->hwmods_cnt; i++)
> -		omap_hwmod_idle(od->hwmods[i]);
> +		ret |=3D omap_hwmod_idle(od->hwmods[i]);
> =20
> -	/* XXX pass along return value here? */
> -	return 0;
> +	return ret;
>  }
> =20
>  /* Public functions for use by core code */
> @@ -595,18 +595,20 @@ static int _od_runtime_suspend(struct device *d=
ev)
>  	int ret;
> =20
>  	ret =3D pm_generic_runtime_suspend(dev);
> +	if (ret)
> +		return ret;
> =20
> -	if (!ret)
> -		omap_device_idle(pdev);
> -
> -	return ret;
> +	return omap_device_idle(pdev);
>  }
> =20
>  static int _od_runtime_resume(struct device *dev)
>  {
>  	struct platform_device *pdev =3D to_platform_device(dev);
> +	int ret;
> =20
> -	omap_device_enable(pdev);
> +	ret =3D omap_device_enable(pdev);
> +	if (ret)
> +		return ret;
> =20
>  	return pm_generic_runtime_resume(dev);
>  }
> @@ -740,7 +742,8 @@ int omap_device_enable(struct platform_device *pd=
ev)
> =20
>  	ret =3D _omap_device_enable_hwmods(od);
> =20
> -	od->_state =3D OMAP_DEVICE_STATE_ENABLED;
> +	if (ret =3D=3D 0)
> +		od->_state =3D OMAP_DEVICE_STATE_ENABLED;
> =20
>  	return ret;
>  }
> @@ -770,7 +773,8 @@ int omap_device_idle(struct platform_device *pdev=
)
> =20
>  	ret =3D _omap_device_idle_hwmods(od);
> =20
> -	od->_state =3D OMAP_DEVICE_STATE_IDLE;
> +	if (ret =3D=3D 0)
> +		od->_state =3D OMAP_DEVICE_STATE_IDLE;
> =20
>  	return ret;
>  }
> diff --git a/arch/arm/mach-omap2/omap_hwmod.c b/arch/arm/mach-omap2/o=
map_hwmod.c
> index 92afb72..870e984 100644
> --- a/arch/arm/mach-omap2/omap_hwmod.c
> +++ b/arch/arm/mach-omap2/omap_hwmod.c
> @@ -3350,16 +3350,17 @@ int omap_hwmod_enable(struct omap_hwmod *oh)
>   */
>  int omap_hwmod_idle(struct omap_hwmod *oh)
>  {
> +	int r;
>  	unsigned long flags;
> =20
>  	if (!oh)
>  		return -EINVAL;
> =20
>  	spin_lock_irqsave(&oh->_lock, flags);
> -	_idle(oh);
> +	r =3D _idle(oh);
>  	spin_unlock_irqrestore(&oh->_lock, flags);
> =20
> -	return 0;
> +	return r;
>  }
> =20
>  /**
> @@ -3372,16 +3373,17 @@ int omap_hwmod_idle(struct omap_hwmod *oh)
>   */
>  int omap_hwmod_shutdown(struct omap_hwmod *oh)
>  {
> +	int r;
>  	unsigned long flags;
> =20
>  	if (!oh)
>  		return -EINVAL;
> =20
>  	spin_lock_irqsave(&oh->_lock, flags);
> -	_shutdown(oh);
> +	r =3D _shutdown(oh);
>  	spin_unlock_irqrestore(&oh->_lock, flags);
> =20
> -	return 0;
> +	return r;
>  }
> =20
>  /*

Hello Paul, can you apply this patch?

--=20
Pali Roh=C3=A1r
pali.rohar@gmail.com

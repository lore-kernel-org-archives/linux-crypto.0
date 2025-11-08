Received: from relay2-d.mail.gandi.net (relay2-d.mail.gandi.net [217.70.183.194])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4DF062EAB81;
	Sat,  8 Nov 2025 08:45:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.183.194
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762591512; cv=none; b=TkBEL/+pkVmCCu9817nHc1iNLdnO3PDgo/5zawcW9zh5OtEOuk8/MJDKB0NZgjlSgs5281G+d04efMMb5S69PiXNZYUXoNk3coSn5UPuxbbuB9w2zuVfGEo1ujFcEwz+BFU5Gi/7iSnjD5ITLwr8v3SjP+z/xd7B8iI7MWDHoyM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762591512; c=relaxed/simple;
	bh=eE280G+ZvsAECeHbzXR1a6t/8FGgoMOyBkIR5e4DCQk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=XRmbXIZm9WqZvR1xMeKBdsmTMNH1C0X3+HIVEqTsAjSNI18XIj3idiqe68PNuu62vnEEcEN1aQ6stqvv20A3LH5vhCMgkr4Ofq0suM5PdrXarmS0YMIlEN1z1RTU7lZGbkc+JiwOV1uXIZlYzPdEWhRik3hsWQmybTv+Wm5mMhk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=yoseli.org; spf=pass smtp.mailfrom=yoseli.org; dkim=pass (2048-bit key) header.d=yoseli.org header.i=@yoseli.org header.b=VOyICK/r; arc=none smtp.client-ip=217.70.183.194
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=yoseli.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=yoseli.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=yoseli.org header.i=@yoseli.org header.b="VOyICK/r"
Received: by mail.gandi.net (Postfix) with ESMTPSA id 27DBE44397;
	Sat,  8 Nov 2025 08:44:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yoseli.org; s=gm1;
	t=1762591503;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Ut4oMSTk7b+dbxdcRqPmARJS+jrrJjq3W66XwW6y+Is=;
	b=VOyICK/rKVAf+5hSjx4sY+TNKvms0h4bmOjcjtfCx7bz0rSILztPuq5cp7jm9U0FXsSe5h
	q2CTxl4wUnwjEjb1Cjealcy0XWMiXgbo4mg6UAQsMkjMskjdx+m2NszVX9ojDMw4WY2/jI
	KMPiX1Ddv02K8gG+dP2NK/ps+fVpGAK1vsFW79VMdfEcDcxSwMKmZVBNgv/XXLN0CjevMZ
	QAANcltrF82vOEMLag8869sGiDuF8gPSWNKH674ET01WdHoH083+FZtgs0OdnV0Iz0LJb3
	SfNiJ37Q06K8mJ4q9VuOlyRQCZ0RLl+E0N8wpDplo3nVR9qj8e+N5q0NkydHJQ==
From: Jean-Michel Hautbois <jeanmichel.hautbois@yoseli.org>
To: Frank Li <Frank.li@nxp.com>
Cc: Greg Ungerer <gerg@linux-m68k.org>,
 Geert Uytterhoeven <geert@linux-m68k.org>,
 Olivia Mackall <olivia@selenic.com>,
 Herbert Xu <herbert@gondor.apana.org.au>, Shawn Guo <shawnguo@kernel.org>,
 Sascha Hauer <s.hauer@pengutronix.de>,
 Pengutronix Kernel Team <kernel@pengutronix.de>,
 Fabio Estevam <festevam@gmail.com>, linux-m68k@lists.linux-m68k.org,
 linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org,
 imx@lists.linux.dev, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v2 2/2] m68k: coldfire: Add RNG support for MCF54418
Date: Sat, 08 Nov 2025 09:44:47 +0100
Message-ID: <6209223.lOV4Wx5bFT@jeanmichel-ms7b89>
In-Reply-To: <aQ4ZLl5ssB/4uq2f@lizhi-Precision-Tower-5810>
References:
 <20251107-b4-m5441x-add-rng-support-v2-0-f91d685832b9@yoseli.org>
 <20251107-b4-m5441x-add-rng-support-v2-2-f91d685832b9@yoseli.org>
 <aQ4ZLl5ssB/4uq2f@lizhi-Precision-Tower-5810>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="utf-8"
X-GND-State: clean
X-GND-Score: -100
X-GND-Cause: gggruggvucftvghtrhhoucdtuddrgeeffedrtdeggdduledvtdelucetufdoteggodetrfdotffvucfrrhhofhhilhgvmecuifetpfffkfdpucggtfgfnhhsuhgsshgtrhhisggvnecuuegrihhlohhuthemuceftddunecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenucfjughrpefhvfevufffkfgjfhgggfgtsehtqhertddttdejnecuhfhrohhmpeflvggrnhdqofhitghhvghlucfjrghuthgsohhishcuoehjvggrnhhmihgthhgvlhdrhhgruhhtsghoihhsseihohhsvghlihdrohhrgheqnecuggftrfgrthhtvghrnhepffevhfduvdeludeugfdtleduuedvhfeuvdevgfeiieefieevteektdettdeifeetnecukfhppedvrgdtudemvgdtrgemudeileemjedugedtmedvrgegtdemfhefrggrmeejudejvgemudefsgdvnecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehinhgvthepvdgrtddumegvtdgrmeduieelmeejudegtdemvdgrgedtmehffegrrgemjedujegvmedufegsvddphhgvlhhopehjvggrnhhmihgthhgvlhdqmhhsjegskeelrdhlohgtrghlnhgvthdpmhgrihhlfhhrohhmpehjvggrnhhmihgthhgvlhdrhhgruhhtsghoihhsseihohhsvghlihdrohhrghdpnhgspghrtghpthhtohepudegpdhrtghpthhtohephfhrrghnkhdrlhhisehngihprdgtohhmpdhrtghpthhtohepghgvrhhgsehlihhnuhigqdhmieekkhdrohhrghdprhgtphhtthhopehgvggvrhhtsehlihhnu
 higqdhmieekkhdrohhrghdprhgtphhtthhopeholhhivhhirgesshgvlhgvnhhitgdrtghomhdprhgtphhtthhopehhvghrsggvrhhtsehgohhnughorhdrrghprghnrgdrohhrghdrrghupdhrtghpthhtohepshhhrgifnhhguhhosehkvghrnhgvlhdrohhrghdprhgtphhtthhopehsrdhhrghuvghrsehpvghnghhuthhrohhnihigrdguvgdprhgtphhtthhopehkvghrnhgvlhesphgvnhhguhhtrhhonhhigidruggv
X-GND-Sasl: jeanmichel.hautbois@yoseli.org

Hi Frank,

Le vendredi 7 novembre 2025, 17:07:10 heure normale d=E2=80=99Europe centra=
le Frank Li=20
a =C3=A9crit :
> On Fri, Nov 07, 2025 at 11:29:44AM +0100, Jean-Michel Hautbois wrote:
> > Add platform device support for the MCF54418 RNGB hardware with clock
> > enabled at platform initialization.
> >=20
> > The imx-rngc driver now uses devm_clk_get_optional() to support both
> > Coldfire (always-on clock) and i.MX platforms (managed clock).
> >=20
> > Signed-off-by: Jean-Michel Hautbois <jeanmichel.hautbois@yoseli.org>
> > ---
> >=20
> >  arch/m68k/coldfire/device.c       | 28 ++++++++++++++++++++++++++++
> >  arch/m68k/coldfire/m5441x.c       |  2 +-
> >  arch/m68k/include/asm/m5441xsim.h |  9 +++++++++
> >  drivers/char/hw_random/Kconfig    |  3 ++-
> >  drivers/char/hw_random/imx-rngc.c |  9 ++++++++-
> >  5 files changed, 48 insertions(+), 3 deletions(-)
>=20
> Most likely need two patches, one patch change rngc use
> devm_clk_get_optional(). one patch update arch/m68k/coldfire.
>=20
> so difference mantainer can pick up easily.

Thanks for this suggestion, I will split this into two for v3. I am just=20
waiting a bit to see if other remarks are emerging, in order to not spam wi=
th=20
multiple versions :-).

Thanks,
JM

>=20
> Frank
>=20
> > diff --git a/arch/m68k/coldfire/device.c b/arch/m68k/coldfire/device.c
> > index
> > 20adba27a687029ef53249bad71b342d563d612b..4183929b0b501459da25d1b4cde7d=
77
> > f19c3dc16 100644 --- a/arch/m68k/coldfire/device.c
> > +++ b/arch/m68k/coldfire/device.c
> > @@ -622,6 +622,31 @@ static struct platform_device mcf_flexcan0 =3D {
> >=20
> >  };
> >  #endif /* MCFFLEXCAN_SIZE */
> >=20
> > +#ifdef MCF_RNG_BASE
> > +/*
> > + * Random Number Generator (RNG) - only on MCF54418
> > + */
> > +static const struct resource mcf_rng_resource[] =3D {
> > +	{
> > +		.start =3D MCF_RNG_BASE,
> > +		.end   =3D MCF_RNG_BASE + MCF_RNG_SIZE - 1,
> > +		.flags =3D IORESOURCE_MEM,
> > +	},
> > +	{
> > +		.start =3D MCF_IRQ_RNG,
> > +		.end   =3D MCF_IRQ_RNG,
> > +		.flags =3D IORESOURCE_IRQ,
> > +	},
> > +};
> > +
> > +static struct platform_device mcf_rng =3D {
> > +	.name           =3D "imx-rngc",
> > +	.id             =3D -1,
> > +	.num_resources  =3D ARRAY_SIZE(mcf_rng_resource),
> > +	.resource       =3D mcf_rng_resource,
> > +};
> > +#endif /* MCF_RNG_BASE */
> > +
> >=20
> >  static struct platform_device *mcf_devices[] __initdata =3D {
> > =20
> >  	&mcf_uart,
> > =20
> >  #ifdef MCFFEC_BASE0
> >=20
> > @@ -660,6 +685,9 @@ static struct platform_device *mcf_devices[]
> > __initdata =3D {>=20
> >  #ifdef MCFFLEXCAN_SIZE
> > =20
> >  	&mcf_flexcan0,
> > =20
> >  #endif
> >=20
> > +#ifdef MCF_RNG_BASE
> > +	&mcf_rng,
> > +#endif
> >=20
> >  };
> > =20
> >  /*
> >=20
> > diff --git a/arch/m68k/coldfire/m5441x.c b/arch/m68k/coldfire/m5441x.c
> > index
> > 7a25cfc7ac07570ff15da3c55d080a717cf93a06..ab5b006372379294db3b522820de8=
81
> > 37bfb7e78 100644 --- a/arch/m68k/coldfire/m5441x.c
> > +++ b/arch/m68k/coldfire/m5441x.c
> > @@ -158,6 +158,7 @@ static struct clk * const enable_clks[] __initconst=
 =3D
> > {
> >=20
> >  	&__clk_0_33, /* pit.1 */
> >  	&__clk_0_37, /* eport */
> >  	&__clk_0_48, /* pll */
> >=20
> > +	&__clk_0_49, /* rng */
> >=20
> >  	&__clk_0_51, /* esdhc */
> >  =09
> >  	&__clk_1_36, /* CCM/reset module/Power management */
> >=20
> > @@ -179,7 +180,6 @@ static struct clk * const disable_clks[] __initcons=
t =3D
> > {>=20
> >  	&__clk_0_44, /* usb otg */
> >  	&__clk_0_45, /* usb host */
> >  	&__clk_0_47, /* ssi.0 */
> >=20
> > -	&__clk_0_49, /* rng */
> >=20
> >  	&__clk_0_50, /* ssi.1 */
> >  	&__clk_0_53, /* enet-fec */
> >  	&__clk_0_54, /* enet-fec */
> >=20
> > diff --git a/arch/m68k/include/asm/m5441xsim.h
> > b/arch/m68k/include/asm/m5441xsim.h index
> > f48cf63bd7822fd53c33788128f984585c0c421a..dd64cdfcad3e810254c6854b9de5b=
6b
> > beb67b950 100644 --- a/arch/m68k/include/asm/m5441xsim.h
> > +++ b/arch/m68k/include/asm/m5441xsim.h
> > @@ -198,6 +198,15 @@
> >=20
> >  #define MCFRTC_SIZE		(0xfc0a8840 - 0xfc0a8000)
> >  #define MCF_IRQ_RTC		(MCFINT2_VECBASE + MCFINT2_RTC)
> >=20
> > +/*
> > + *  Random Number Generator (RNG) Module.
> > + *  Note: Only present in MCF54418, not in MCF54410/54415/54417
> > + */
> > +#define MCF_RNG_BASE		0xfc0c4000
> > +#define MCF_RNG_SIZE		0x1c
> > +#define MCFINT2_RNG		28
> > +#define MCF_IRQ_RNG		(MCFINT2_VECBASE + MCFINT2_RNG)
> > +
> >=20
> >  /*
> > =20
> >   *  GPIO Module.
> >   */
> >=20
> > diff --git a/drivers/char/hw_random/Kconfig
> > b/drivers/char/hw_random/Kconfig index
> > 492a2a61a65be8bd9e46b0a70f3e43703973512e..e046eabaac2d9053a5a4a98c6e373=
3b
> > b19258e54 100644 --- a/drivers/char/hw_random/Kconfig
> > +++ b/drivers/char/hw_random/Kconfig
> > @@ -270,12 +270,13 @@ config HW_RANDOM_MXC_RNGA
> >=20
> >  config HW_RANDOM_IMX_RNGC
> > =20
> >  	tristate "Freescale i.MX RNGC Random Number Generator"
> >  	depends on HAS_IOMEM
> >=20
> > -	depends on SOC_IMX25 || SOC_IMX6SL || SOC_IMX6SLL || SOC_IMX6UL ||
> > COMPILE_TEST +	depends on SOC_IMX25 || SOC_IMX6SL || SOC_IMX6SLL ||
> > SOC_IMX6UL || M5441x || COMPILE_TEST>=20
> >  	default HW_RANDOM
> >  	help
> >  =09
> >  	  This driver provides kernel-side support for the Random Number
> >  	  Generator Version C hardware found on some Freescale i.MX
> >  	  processors. Version B is also supported by this driver.
> >=20
> > +	  Also supports RNGB on Freescale MCF54418 (Coldfire V4e).
> >=20
> >  	  To compile this driver as a module, choose M here: the
> >  	  module will be called imx-rngc.
> >=20
> > diff --git a/drivers/char/hw_random/imx-rngc.c
> > b/drivers/char/hw_random/imx-rngc.c index
> > 241664a9b5d9ac7244f15cbe5d5302ca3787ebea..44f20a05de0a425cb6ff7b2a347b1=
11
> > 750ac3702 100644 --- a/drivers/char/hw_random/imx-rngc.c
> > +++ b/drivers/char/hw_random/imx-rngc.c
> > @@ -259,7 +259,7 @@ static int __init imx_rngc_probe(struct
> > platform_device *pdev)>=20
> >  	if (IS_ERR(rngc->base))
> >  =09
> >  		return PTR_ERR(rngc->base);
> >=20
> > -	rngc->clk =3D devm_clk_get(&pdev->dev, NULL);
> > +	rngc->clk =3D devm_clk_get_optional(&pdev->dev, NULL);
> >=20
> >  	if (IS_ERR(rngc->clk))
> >  =09
> >  		return dev_err_probe(&pdev->dev, PTR_ERR(rngc->clk),=20
"Cannot get
> >  		rng_clk\n");>=20
> > @@ -353,12 +353,19 @@ static const struct of_device_id imx_rngc_dt_ids[=
] =3D
> > {>=20
> >  };
> >  MODULE_DEVICE_TABLE(of, imx_rngc_dt_ids);
> >=20
> > +static const struct platform_device_id imx_rngc_devtype[] =3D {
> > +	{ .name =3D "imx-rngc" },
> > +	{ /* sentinel */ }
> > +};
> > +MODULE_DEVICE_TABLE(platform, imx_rngc_devtype);
> > +
> >=20
> >  static struct platform_driver imx_rngc_driver =3D {
> > =20
> >  	.driver =3D {
> >  =09
> >  		.name =3D KBUILD_MODNAME,
> >  		.pm =3D pm_ptr(&imx_rngc_pm_ops),
> >  		.of_match_table =3D imx_rngc_dt_ids,
> >  =09
> >  	},
> >=20
> > +	.id_table =3D imx_rngc_devtype,
> >=20
> >  };
> > =20
> >  module_platform_driver_probe(imx_rngc_driver, imx_rngc_probe);
> >=20
> > --
> > 2.39.5





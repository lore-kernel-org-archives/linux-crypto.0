Received: from relay5-d.mail.gandi.net (relay5-d.mail.gandi.net [217.70.183.197])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 251BD1DF723;
	Mon, 10 Nov 2025 08:35:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.183.197
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762763707; cv=none; b=SL8Dfk1sU/XXHXUB3s15EeGr95Rdm17LKvk8uCKrpl/1qyNqb/QvPnIAKLTE6qxKDDc/LmwuJ8+sZI/ts1d+oU5urCPLF1yrru1TG9iat3y/HjjFZoRSguHycsyoP5OnMOMdmdd/0Uh1869vLvhTD6JRxsCQjYJMrKIwg5nayYo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762763707; c=relaxed/simple;
	bh=+ijNI65W+ZEFvK4Ew06TjA+hc0H10nDb/fRorO6fxqo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=q6HtVtXysgArRscS6X/x7F48CkrMXPPNeYyuUHvewLR3xWuk/eS/SkbmNbq7kxtqZidTWBA7wM4XlaLVQs+LQ3hmXceILPhKUx3Es8NZ44VYTBo1KKApRx0fGb7COpU9CcDZJifLnZ3OyWwBg5r/+6l6QUt4jX8FO3+DS2sntI0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=yoseli.org; spf=pass smtp.mailfrom=yoseli.org; dkim=pass (2048-bit key) header.d=yoseli.org header.i=@yoseli.org header.b=A121KGlo; arc=none smtp.client-ip=217.70.183.197
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=yoseli.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=yoseli.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=yoseli.org header.i=@yoseli.org header.b="A121KGlo"
Received: by mail.gandi.net (Postfix) with ESMTPSA id B2E6843A97;
	Mon, 10 Nov 2025 08:34:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yoseli.org; s=gm1;
	t=1762763697;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=z6wRniPCN18DmCkPRn+D/brzx7dyupMuJ1WbzWmkjT4=;
	b=A121KGloifIUhJ77Bap/KOBzqy308FGX0YX9ci0cAfs5CYooKQhgPPLMF1FQtVjbVTJ6lv
	2lkQ0FW1JGeCS0eKxh0frvsNIaLNqpPNws2awkS2/MJyc4KARgpqDsE4jl12Q2Qt1rrX+W
	jbp/RnR1Ocsz1u0G0OWIrPDKObMSirSACifE1/RV3AEJIe38uDeYmvSc3qfOXS/kKzmvd4
	Ffv/q8r/dhI+l0dkUO4pftTJslWKs5/tWVbNxZx9hquw9PWMEuhWxtXtbiEXBXJFHZb8W0
	OR30Ia18TDhJPUsRXlm/wFCKiJGuqAt4xrkO+eynqfGwvm0qYuBr0i4a0y2ZkA==
From: Jean-Michel Hautbois <jeanmichel.hautbois@yoseli.org>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Greg Ungerer <gerg@linux-m68k.org>, Olivia Mackall <olivia@selenic.com>,
 Herbert Xu <herbert@gondor.apana.org.au>, Shawn Guo <shawnguo@kernel.org>,
 Sascha Hauer <s.hauer@pengutronix.de>,
 Pengutronix Kernel Team <kernel@pengutronix.de>,
 Fabio Estevam <festevam@gmail.com>, linux-m68k@lists.linux-m68k.org,
 linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org,
 imx@lists.linux.dev, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v2 2/2] m68k: coldfire: Add RNG support for MCF54418
Date: Mon, 10 Nov 2025 09:34:42 +0100
Message-ID: <12779401.O9o76ZdvQC@jeanmichel-ms7b89>
In-Reply-To:
 <CAMuHMdWL76hY-Pv30ooSM1J6XkVWbRXSLTDCjfpPOvhFN4tKyA@mail.gmail.com>
References:
 <20251107-b4-m5441x-add-rng-support-v2-0-f91d685832b9@yoseli.org>
 <20251107-b4-m5441x-add-rng-support-v2-2-f91d685832b9@yoseli.org>
 <CAMuHMdWL76hY-Pv30ooSM1J6XkVWbRXSLTDCjfpPOvhFN4tKyA@mail.gmail.com>
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
X-GND-Cause: gggruggvucftvghtrhhoucdtuddrgeeffedrtdeggdduleejkeegucetufdoteggodetrfdotffvucfrrhhofhhilhgvmecuifetpfffkfdpucggtfgfnhhsuhgsshgtrhhisggvnecuuegrihhlohhuthemuceftddunecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenucfjughrpefhvfevufffkfgjfhgggfgtsehtqhertddttdejnecuhfhrohhmpeflvggrnhdqofhitghhvghlucfjrghuthgsohhishcuoehjvggrnhhmihgthhgvlhdrhhgruhhtsghoihhsseihohhsvghlihdrohhrgheqnecuggftrfgrthhtvghrnhepffevhfduvdeludeugfdtleduuedvhfeuvdevgfeiieefieevteektdettdeifeetnecukfhppedvrgdtudemvgdtrgemudeileemjedugedtmedvrgegtdemfhefrggrmeejudejvgemudefsgdvnecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehinhgvthepvdgrtddumegvtdgrmeduieelmeejudegtdemvdgrgedtmehffegrrgemjedujegvmedufegsvddphhgvlhhopehjvggrnhhmihgthhgvlhdqmhhsjegskeelrdhlohgtrghlnhgvthdpmhgrihhlfhhrohhmpehjvggrnhhmihgthhgvlhdrhhgruhhtsghoihhsseihohhsvghlihdrohhrghdpnhgspghrtghpthhtohepudefpdhrtghpthhtohepghgvvghrtheslhhinhhugidqmheikehkrdhorhhgpdhrtghpthhtohepghgvrhhgsehlihhnuhigqdhmieekkhdrohhrghdprhgtphhtthhopeholhhivhhir
 gesshgvlhgvnhhitgdrtghomhdprhgtphhtthhopehhvghrsggvrhhtsehgohhnughorhdrrghprghnrgdrohhrghdrrghupdhrtghpthhtohepshhhrgifnhhguhhosehkvghrnhgvlhdrohhrghdprhgtphhtthhopehsrdhhrghuvghrsehpvghnghhuthhrohhnihigrdguvgdprhgtphhtthhopehkvghrnhgvlhesphgvnhhguhhtrhhonhhigidruggvpdhrtghpthhtohepfhgvshhtvghvrghmsehgmhgrihhlrdgtohhm
X-GND-Sasl: jeanmichel.hautbois@yoseli.org

Hi Geert,

Le lundi 10 novembre 2025, 09:15:11 heure normale d=E2=80=99Europe centrale=
 Geert=20
Uytterhoeven a =C3=A9crit :
> Hi Jean-Michel,
>=20
> On Fri, 7 Nov 2025 at 11:29, Jean-Michel Hautbois
>=20
> <jeanmichel.hautbois@yoseli.org> wrote:
> > Add platform device support for the MCF54418 RNGB hardware with clock
> > enabled at platform initialization.
> >=20
> > The imx-rngc driver now uses devm_clk_get_optional() to support both
> > Coldfire (always-on clock) and i.MX platforms (managed clock).
> >=20
> > Signed-off-by: Jean-Michel Hautbois <jeanmichel.hautbois@yoseli.org>
>=20
> Thanks for your patch!
>=20
> > --- a/drivers/char/hw_random/Kconfig
> > +++ b/drivers/char/hw_random/Kconfig
> > @@ -270,12 +270,13 @@ config HW_RANDOM_MXC_RNGA
> >=20
> >  config HW_RANDOM_IMX_RNGC
> > =20
> >         tristate "Freescale i.MX RNGC Random Number Generator"
> >         depends on HAS_IOMEM
> >=20
> > -       depends on SOC_IMX25 || SOC_IMX6SL || SOC_IMX6SLL || SOC_IMX6UL=
 ||
> > COMPILE_TEST +       depends on SOC_IMX25 || SOC_IMX6SL || SOC_IMX6SLL =
||
> > SOC_IMX6UL || M5441x || COMPILE_TEST
> Is the same RNG present in other Coldfire SoCs?

According to the RM, it is only present in MCF54416 and MCF54418.

>=20
> >         default HW_RANDOM
> >         help
> >        =20
> >           This driver provides kernel-side support for the Random Number
> >           Generator Version C hardware found on some Freescale i.MX
> >           processors. Version B is also supported by this driver.
> >=20
> > +         Also supports RNGB on Freescale MCF54418 (Coldfire V4e).
> >=20
> >           To compile this driver as a module, choose M here: the
> >           module will be called imx-rngc.
> >=20
> > diff --git a/drivers/char/hw_random/imx-rngc.c
> > b/drivers/char/hw_random/imx-rngc.c index
> > 241664a9b5d9ac7244f15cbe5d5302ca3787ebea..44f20a05de0a425cb6ff7b2a347b1=
11
> > 750ac3702 100644 --- a/drivers/char/hw_random/imx-rngc.c
> > +++ b/drivers/char/hw_random/imx-rngc.c
> > @@ -353,12 +353,19 @@ static const struct of_device_id imx_rngc_dt_ids[=
] =3D
> > {>=20
> >  };
> >  MODULE_DEVICE_TABLE(of, imx_rngc_dt_ids);
> >=20
> > +static const struct platform_device_id imx_rngc_devtype[] =3D {
> > +       { .name =3D "imx-rngc" },
>=20
> I believe this is identical to KBUILD_MODNAME, so the .name below
> should be sufficient for binding?
>=20
> > +       { /* sentinel */ }
> > +};
> > +MODULE_DEVICE_TABLE(platform, imx_rngc_devtype);
>=20
> Or do you need this mainly for the addition of MODULE_DEVICE_TABLE(),
> i.e. the module is not auto-loaded based on just KBUILD_MODNAME?

Yes, exactly. If you have a better way, I will happily apply it :-).

Thanks !
JM

>=20
> > +
> >=20
> >  static struct platform_driver imx_rngc_driver =3D {
> > =20
> >         .driver =3D {
> >        =20
> >                 .name =3D KBUILD_MODNAME,
>=20
>                   ^^^^^^^^^^^^^^^^^^^^^^^
>=20
> >                 .pm =3D pm_ptr(&imx_rngc_pm_ops),
> >                 .of_match_table =3D imx_rngc_dt_ids,
> >        =20
> >         },
> >=20
> > +       .id_table =3D imx_rngc_devtype,
> >=20
> >  };
> > =20
> >  module_platform_driver_probe(imx_rngc_driver, imx_rngc_probe);
>=20
> Gr{oetje,eeting}s,
>=20
>                         Geert





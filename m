Received: from relay9-d.mail.gandi.net (relay9-d.mail.gandi.net [217.70.183.199])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9FFC12D877D;
	Thu,  6 Nov 2025 18:16:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.183.199
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762452998; cv=none; b=RiMgXdJAqFcGlUmbgDnqP5x65uiq262w+Lmt4RIpwK0bd6AE/WFqsX32Csv4WF14nkMuUISY+WRtxCl1mU5COqYsoldA7pbSxb4U6XsTf5rQvGcgt32f+ize4oi6iGgstG/rFWqHk4iVAudPFgkEyMxsiHl6ZRpeyN+pNT4iZGU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762452998; c=relaxed/simple;
	bh=WilPTc4l6SbkcmoD6H9/XVoLeq69nGoaUqu2FKouRnU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=GLKSjm/docvYoBj0JQrlp5WBjxjqVbLd95+XoLILAdFEOtrv9tlkcf5m68acONLirMtkVGAbDvprQrP4Gcc7D6ZHUehlme/K5OZWuk0qKnprWsfGNt7vJtmmlR9ZUO+sYM9m/cwaTnEEFDq0/fLy73eiikQmPtN0stYAO0b80U8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=yoseli.org; spf=pass smtp.mailfrom=yoseli.org; dkim=pass (2048-bit key) header.d=yoseli.org header.i=@yoseli.org header.b=UAurMIDh; arc=none smtp.client-ip=217.70.183.199
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=yoseli.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=yoseli.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=yoseli.org header.i=@yoseli.org header.b="UAurMIDh"
Received: by mail.gandi.net (Postfix) with ESMTPSA id 055C04447C;
	Thu,  6 Nov 2025 18:16:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yoseli.org; s=gm1;
	t=1762452989;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=IbaUwN97vGeANThuFDgulgsFTpORSyAqqWAycmMvn0Q=;
	b=UAurMIDhvSirMkEYhH8XOdIrF0QaJtlbdslpce4O9SGmzZ/RKVM2eyy3koQ1nl05Ga1WZP
	MIIwfeUBRdE4R7HtdNQgD57Z4zaSOcFfy76RbFos318PSt9gCCOHdXeT1e6e5LB2nBJaY5
	kJXkGISsNkt9PJKtrBDT/Tx0VhibOWRh4auHXKLPA90bT2s7UzHj0wpVY0I8P+vTQ5s7hj
	NIyGIKu2Hj5jB9mUJ0LU5oE8qRFon9ywu8lkYFg9UgTtm7vwwFR0z5q4c3E8s81VgjVZ68
	dyfbk+1hPIPAUNuMSq9bPGb6asMguUHhfTTRJXxiGnA/qEm0HkKKA3TKKcUu7A==
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
Subject: Re: [PATCH] m68k: coldfire: Add RNG support for MCF54418
Date: Thu, 06 Nov 2025 19:16:17 +0100
Message-ID: <4689159.LvFx2qVVIh@jeanmichel-ms7b89>
In-Reply-To: <aQzHO6Ty+l1Bwt6N@lizhi-Precision-Tower-5810>
References:
 <20251106-m5441x-add-rng-support-v1-1-ee8230910d17@yoseli.org>
 <aQzHO6Ty+l1Bwt6N@lizhi-Precision-Tower-5810>
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
X-GND-Cause: gggruggvucftvghtrhhoucdtuddrgeeffedrtdeggddukeejgeekucetufdoteggodetrfdotffvucfrrhhofhhilhgvmecuifetpfffkfdpucggtfgfnhhsuhgsshgtrhhisggvnecuuegrihhlohhuthemuceftddunecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenucfjughrpefhvfevufffkfgjfhgggfgtsehtqhertddttdejnecuhfhrohhmpeflvggrnhdqofhitghhvghlucfjrghuthgsohhishcuoehjvggrnhhmihgthhgvlhdrhhgruhhtsghoihhsseihohhsvghlihdrohhrgheqnecuggftrfgrthhtvghrnhepffevhfduvdeludeugfdtleduuedvhfeuvdevgfeiieefieevteektdettdeifeetnecukfhppedvrgdtudemvgdtrgemudeileemjedugedtmedvrgegtdemfhefrggrmeejudejvgemudefsgdvnecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehinhgvthepvdgrtddumegvtdgrmeduieelmeejudegtdemvdgrgedtmehffegrrgemjedujegvmedufegsvddphhgvlhhopehjvggrnhhmihgthhgvlhdqmhhsjegskeelrdhlohgtrghlnhgvthdpmhgrihhlfhhrohhmpehjvggrnhhmihgthhgvlhdrhhgruhhtsghoihhsseihohhsvghlihdrohhrghdpnhgspghrtghpthhtohepudegpdhrtghpthhtohephfhrrghnkhdrlhhisehngihprdgtohhmpdhrtghpthhtohepghgvrhhgsehlihhnuhigqdhmieekkhdrohhrghdprhgtphhtthhopehgvggvrhhtsehlihhnu
 higqdhmieekkhdrohhrghdprhgtphhtthhopeholhhivhhirgesshgvlhgvnhhitgdrtghomhdprhgtphhtthhopehhvghrsggvrhhtsehgohhnughorhdrrghprghnrgdrohhrghdrrghupdhrtghpthhtohepshhhrgifnhhguhhosehkvghrnhgvlhdrohhrghdprhgtphhtthhopehsrdhhrghuvghrsehpvghnghhuthhrohhnihigrdguvgdprhgtphhtthhopehkvghrnhgvlhesphgvnhhguhhtrhhonhhigidruggv
X-GND-Sasl: jeanmichel.hautbois@yoseli.org

Hi Frank,

Le jeudi 6 novembre 2025, 17:05:15 heure normale d=E2=80=99Europe centrale =
=46rank Li a=20
=C3=A9crit :
> On Thu, Nov 06, 2025 at 08:10:08AM +0100, Jean-Michel Hautbois wrote:
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
> >=20
> > diff --git a/arch/m68k/coldfire/device.c b/arch/m68k/coldfire/device.c
> > index
> > b6958ec2a220cf91a78a14fc7fa18749451412f7..9d8f844e319a98f0afb79cceb544c=
2d
> > 3029482a4 100644 --- a/arch/m68k/coldfire/device.c
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
> > +static struct resource mcf_rng_resource[] =3D {
>=20
> const?

Why not, but I wanted to be consistent with all the other structures in thi=
s=20
file.

JM

> Frank
>=20
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
>=20
> ...





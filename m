Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7B4BC15278D;
	Fri, 28 Jun 2024 09:40:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719567610; cv=none; b=nFuD/hIekIj7WCUETrJv0FqfQLLD/HVLLsm7QR30/nOYZctB6cEbrDGP91gUc5ak5eFx4U9ekOepvZw34j1w/eIfvzEU9QRBf/7pOkDWpNhjBY3N26wkFcmd2RsqtZzeoa34/dsysJBsf3AWa9TbS0jrIhzqHb4l8KeT8FeWn8s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719567610; c=relaxed/simple;
	bh=vwWYuw8MReSjhj/uWrhsSw093dCcYZAc3JIqgm9h7vs=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Ja8EpLB/lGeejANlqcCHlNmnR7MCCE2qmNhWYg5zqCVd8xSlhlvIAF51SwG2r3f7HNs44V27+0Rrb+OuN/2+wGsjfqpw7CGhCd+xV6NnP/mWeMnAxRf5oce65w9FfXvTi8vdS7/PIMiTvL5N4JjBtXjorSRXbl+v2wKpVyM4l2I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id D8EEB106F;
	Fri, 28 Jun 2024 02:30:38 -0700 (PDT)
Received: from donnerap.manchester.arm.com (usa-sjc-imap-foss1.foss.arm.com [10.121.207.14])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id F0FEF3F6A8;
	Fri, 28 Jun 2024 02:30:11 -0700 (PDT)
Date: Fri, 28 Jun 2024 10:30:07 +0100
From: Andre Przywara <andre.przywara@arm.com>
To: Chen-Yu Tsai <wens@csie.org>
Cc: Corentin Labbe <clabbe.montjoie@gmail.com>, Herbert Xu
 <herbert@gondor.apana.org.au>, "David S . Miller" <davem@davemloft.net>,
 Jernej Skrabec <jernej.skrabec@gmail.com>, Samuel Holland
 <samuel@sholland.org>, Rob Herring <robh@kernel.org>, Krzysztof Kozlowski
 <krzk+dt@kernel.org>, Conor Dooley <conor+dt@kernel.org>, Ryan Walklin
 <ryan@testtoast.com>, Philippe Simons <simons.philippe@gmail.com>,
 linux-crypto@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
 linux-sunxi@lists.linux.dev, devicetree@vger.kernel.org
Subject: Re: [PATCH v2 4/4] arm64: dts: allwinner: h616: add crypto engine
 node
Message-ID: <20240628103007.6ea3685c@donnerap.manchester.arm.com>
In-Reply-To: <CAGb2v67qo7qgf2uzBAUf9-C9NHrHG47mLc579NRkTO7qLDtV7Q@mail.gmail.com>
References: <20240624232110.9817-1-andre.przywara@arm.com>
	<20240624232110.9817-5-andre.przywara@arm.com>
	<CAGb2v67qo7qgf2uzBAUf9-C9NHrHG47mLc579NRkTO7qLDtV7Q@mail.gmail.com>
Organization: ARM
X-Mailer: Claws Mail 3.18.0 (GTK+ 2.24.32; aarch64-unknown-linux-gnu)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On Fri, 28 Jun 2024 01:54:00 +0800
Chen-Yu Tsai <wens@csie.org> wrote:

Hi Chen-Yu,

> On Tue, Jun 25, 2024 at 7:23=E2=80=AFAM Andre Przywara <andre.przywara@ar=
m.com> wrote:
> >
> > The Allwinner H616 SoC contains a crypto engine very similar to the H6
> > version, but with all base addresses in the DMA descriptors shifted by
> > two bits. This requires a new compatible string.
> > Also the H616 CE relies on the internal osciallator for the TRNG
> > operation, so we need to reference this clock.
> >
> > Signed-off-by: Andre Przywara <andre.przywara@arm.com>
> > ---
> >  arch/arm64/boot/dts/allwinner/sun50i-h616.dtsi | 10 ++++++++++
> >  1 file changed, 10 insertions(+)
> >
> > diff --git a/arch/arm64/boot/dts/allwinner/sun50i-h616.dtsi b/arch/arm6=
4/boot/dts/allwinner/sun50i-h616.dtsi
> > index 921d5f61d8d6a..187663d45ed72 100644
> > --- a/arch/arm64/boot/dts/allwinner/sun50i-h616.dtsi
> > +++ b/arch/arm64/boot/dts/allwinner/sun50i-h616.dtsi
> > @@ -113,6 +113,16 @@ soc {
> >                 #size-cells =3D <1>;
> >                 ranges =3D <0x0 0x0 0x0 0x40000000>;
> >
> > +               crypto: crypto@1904000 {
> > +                       compatible =3D "allwinner,sun50i-h616-crypto";
> > +                       reg =3D <0x01904000 0x1000>; =20
>=20
> The address range only goes up to 0x019047ff. The other half is the
> secure crypto engine. The other bits look correct.

You are right, the manual restricts CE_NS to 0x019047ff, and we certainly
use much less registers than that anyway. So good catch!

> I can fix this up when applying, assuming the driver parts get merged
> in the next few days.

Many thanks, I'd be very grateful if you could fix this up!

Cheers,
Andre

>=20
> Chenyu
>=20
> > +                       interrupts =3D <GIC_SPI 91 IRQ_TYPE_LEVEL_HIGH>;
> > +                       clocks =3D <&ccu CLK_BUS_CE>, <&ccu CLK_CE>,
> > +                                <&ccu CLK_MBUS_CE>, <&rtc CLK_IOSC>;
> > +                       clock-names =3D "bus", "mod", "ram", "trng";
> > +                       resets =3D <&ccu RST_BUS_CE>;
> > +               };
> > +
> >                 syscon: syscon@3000000 {
> >                         compatible =3D "allwinner,sun50i-h616-system-co=
ntrol";
> >                         reg =3D <0x03000000 0x1000>;
> > --
> > 2.39.4
> > =20


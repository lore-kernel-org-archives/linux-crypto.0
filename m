From: Maxime Ripard <maxime.ripard@free-electrons.com>
Subject: Re: [PATCH 8/8] ARM: mvebu: a38x: Enable A38x XOR engine features
Date: Wed, 13 May 2015 10:33:28 +0200
Message-ID: <20150513083328.GU10961@lukather>
References: <1431445063-20226-1-git-send-email-maxime.ripard@free-electrons.com>
 <1431445063-20226-9-git-send-email-maxime.ripard@free-electrons.com>
 <20150512161314.GL19927@lunn.ch>
 <14c9a6d3ba4c46f89880e4c1b4494dbb@IL-EXCH02.marvell.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="1PHmS26pdpOR3Xc0"
Cc: Andrew Lunn <andrew@lunn.ch>, Vinod Koul <vinod.koul@intel.com>,
	Dan Williams <dan.j.williams@intel.com>,
	Gregory Clement <gregory.clement@free-electrons.com>,
	Jason Cooper <jason@lakedaemon.net>,
	Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
	"dmaengine@vger.kernel.org" <dmaengine@vger.kernel.org>,
	"linux-arm-kernel@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
	Thomas Petazzoni <thomas@free-electrons.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>
To: Lior Amsalem <alior@marvell.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <14c9a6d3ba4c46f89880e4c1b4494dbb@IL-EXCH02.marvell.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org


--1PHmS26pdpOR3Xc0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, May 13, 2015 at 07:16:34AM +0000, Lior Amsalem wrote:
> > From: Andrew Lunn [mailto:andrew@lunn.ch]
> > Sent: Tuesday, May 12, 2015 7:13 PM
> >=20
> > On Tue, May 12, 2015 at 05:37:43PM +0200, Maxime Ripard wrote:
> > > From: Lior Amsalem <alior@marvell.com>
> > >
> > > The new XOR engine has a new compatible of its own, together with new
> > > channel capabilities.
> > >
> > > Use that new compatible now that we have a driver that can handle it.
> > >
> > > Signed-off-by: Lior Amsalem <alior@marvell.com>
> > > Reviewed-by: Ofer Heifetz <oferh@marvell.com>
> > > Reviewed-by: Nadav Haklai <nadavh@marvell.com>
> > > Tested-by: Nadav Haklai <nadavh@marvell.com>
> > > ---
> > >  arch/arm/boot/dts/armada-38x.dtsi | 20 ++++++--------------
> > >  1 file changed, 6 insertions(+), 14 deletions(-)
> > >
> > > diff --git a/arch/arm/boot/dts/armada-38x.dtsi
> > > b/arch/arm/boot/dts/armada-38x.dtsi
> > > index ed2dd8ba4080..6d07b7389415 100644
> > > --- a/arch/arm/boot/dts/armada-38x.dtsi
> > > +++ b/arch/arm/boot/dts/armada-38x.dtsi
> > > @@ -448,7 +448,7 @@
> > >  			};
> > >
> > >  			xor@60800 {
> > > -				compatible =3D "marvell,orion-xor";
> > > +				compatible =3D "marvell,a38x-xor";
> > >  				reg =3D <0x60800 0x100
> > >  				       0x60a00 0x100>;
> > >  				clocks =3D <&gateclk 22>;
> > > @@ -458,17 +458,13 @@
> > >  					interrupts =3D <GIC_SPI 22
> > IRQ_TYPE_LEVEL_HIGH>;
> > >  					dmacap,memcpy;
> > >  					dmacap,xor;
> > > -				};
> > > -				xor01 {
> > > -					interrupts =3D <GIC_SPI 23
> > IRQ_TYPE_LEVEL_HIGH>;
> > > -					dmacap,memcpy;
> > > -					dmacap,xor;
> > > -					dmacap,memset;
> > > +					dmacap,pq;
> > > +					dmacap,interrupt;
> >=20
> > Does this mean the hardware only has one channel?
> > And memset is no longer supported?
> >=20
>=20
> The hardware has two channels per engine and two engines.
> However, both on HW side (both channels are on the same "bus port")
> and SW (the dma subsystem will assign one channel per CPU).
> we found it's better (performance wise) to use only one channel on each e=
ngine
> and let the framework assign one per CPU.
> This way, descriptors chaining was better (cause of the depended descript=
ors
> problem) and overall interrupt number reduced.
>=20
> Yes, since memset is a problematic one. It can only be done via registers
> (and not on descriptors level) plus no one really needs it...

And memset support has been removed from dmaengine since 3.11, so it
doesn't look like anyone really needs it :)

We're talking about reintroducing it for some platforms that actually
need it, but it wasn't really used on marvell anyway...

Maxime

--=20
Maxime Ripard, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com

--1PHmS26pdpOR3Xc0
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJVUwxYAAoJEBx+YmzsjxAgd/IP/jUrdlsl5heMbcuMMmphUk2O
5SWYkHN6FAaxIsmzveAB5FgajkJC8MaQ94VxCit5ts+FvmQIJ7wPcho/JaFoqSXP
sVmxKGonamy8NlGJUMDonf4XfpNzQ3O0C6N7qbpxnQWbQ5hTz1w0FL52zGfk8pFh
yqzYyW1DkXjHfUxFPX0G3d8PdVT3wa6Mwk17kwtLCrtS7N6PwNgJ6qlN7o9tjH/d
BA7bAzDmH5OYeUE0/3qOB7BYfSQ6/ZpJAoNlvL1UIXhILL2v6pwLvIAlAnFqxOHl
gOfWYMlQKt1O6uHlb2INBgFcK2tv2zBz6iWGyY8l68C3HKPMeP/ddhFf9B6zw9gm
VxJUON4FQgcTkwSB/EmEI+Avs80nCkI1tBC2BEDuggvBi5jb23yrBwsDJwjSjzwc
bh5x9clnDSNTA3YC1QI6Mn5nEvGyy//NNvojeV6zYdb5AmIkQUjAMXUhAd2C+pHY
flO3fmFWdUlmrHZZHVEH9GW4sAkMo7jhSHPgzs/k1SfY47P6zrda4f6EUPBQr9gw
z/QZtrEVj1YHhdcBDSUItTX3czfQ3utBxScdA9oI0uM2Aua6oC56XJcL77jG78x4
jgcNL0G9XXM/Gkw6WxxQWz+AYn2YpWwoDEZMOvxqf5zyLSyohDv+XX9V/gkNd8Wb
LfGG+wt2jAI8T61EYfzN
=GSJC
-----END PGP SIGNATURE-----

--1PHmS26pdpOR3Xc0--

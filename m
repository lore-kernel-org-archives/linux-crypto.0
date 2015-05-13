From: Maxime Ripard <maxime.ripard@free-electrons.com>
Subject: Re: [PATCH 2/8] dmaengine: mv_xor: add support for a38x command in
 descriptor mode
Date: Wed, 13 May 2015 10:15:35 +0200
Message-ID: <20150513081535.GS10961@lukather>
References: <1431445063-20226-1-git-send-email-maxime.ripard@free-electrons.com>
 <1431445063-20226-3-git-send-email-maxime.ripard@free-electrons.com>
 <4862159.g8Sk9nOiS2@wuerfel>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="NAmHCRPXNp23hR9r"
Cc: linux-arm-kernel@lists.infradead.org,
	Vinod Koul <vinod.koul@intel.com>,
	Dan Williams <dan.j.williams@intel.com>,
	Gregory Clement <gregory.clement@free-electrons.com>,
	Jason Cooper <jason@lakedaemon.net>,
	Andrew Lunn <andrew@lunn.ch>,
	Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
	Lior Amsalem <alior@marvell.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Thomas Petazzoni <thomas@free-electrons.com>,
	linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org,
	dmaengine@vger.kernel.org, "David S. Miller" <davem@davemloft.net>
To: Arnd Bergmann <arnd@arndb.de>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <4862159.g8Sk9nOiS2@wuerfel>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org


--NAmHCRPXNp23hR9r
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Arnd,

On Tue, May 12, 2015 at 05:49:08PM +0200, Arnd Bergmann wrote:
> On Tuesday 12 May 2015 17:37:37 Maxime Ripard wrote:
> > From: Lior Amsalem <alior@marvell.com>
> >=20
> > The Marvell Armada 38x SoC introduce new features to the XOR engine,
> > especially the fact that the engine mode (MEMCPY/XOR/PQ/etc) can be par=
t of
> > the descriptor and not set through the controller registers.
> >=20
> > This new feature allows mixing of different commands (even PQ) on the s=
ame
> > channel/chain without the need to stop the engine to reconfigure the en=
gine
> > mode.
> >=20
> > Refactor the driver to be able to use that new feature on the Armada 38=
x,
> > while keeping the old behaviour on the older SoCs.
> >=20
> > Signed-off-by: Lior Amsalem <alior@marvell.com>
> > Reviewed-by: Ofer Heifetz <oferh@marvell.com>
> > Signed-off-by: Maxime Ripard <maxime.ripard@free-electrons.com>
>=20
> Two minimal style comments:
>=20
> > +static void mv_chan_set_mode_to_desc(struct mv_xor_chan *chan)
> > +{
> > +	u32 op_mode;
> > +	u32 config =3D readl_relaxed(XOR_CONFIG(chan));
> > +
> > +	op_mode =3D XOR_OPERATION_MODE_IN_DESC;
> > +
> > +	config &=3D ~0x7;
> > +	config |=3D op_mode;
> > +
> > +#if defined(__BIG_ENDIAN)
> > +	config |=3D XOR_DESCRIPTOR_SWAP;
> > +#else
> > +	config &=3D ~XOR_DESCRIPTOR_SWAP;
> > +#endif
> > +
> > +	writel_relaxed(config, XOR_CONFIG(chan));
> > +}
>=20
> Using=20
>=20
> 	if (IS_ENABLED(__BIG_ENDIAN))
>=20
> here would make it more readable by avoiding the #if.

Indeed. I'll change that.

> Alternatively, you could leave the XOR_DESCRIPTOR_SWAP flag disabled
> and just swap the descriptors manually like a lot of other drivers
> do. You have to swap the mmio accesses anywya.

That won't be easily doable however.

Not only the endianness of the individual fields in the descriptor
changes, but changing the endianness also swaps the fields themselves
by pair of u32.

You can see that here:
http://lxr.free-electrons.com/source/drivers/dma/mv_xor.h#L159

So I'm guessing that leaving it like it is was the more readable
solution.

> >  }
> > =20
> > +#ifdef CONFIG_OF
> > +static const struct of_device_id mv_xor_dt_ids[] =3D {
> > +	{ .compatible =3D "marvell,orion-xor", .data =3D (void *)XOR_MODE_IN_=
REG },
> > +	{ .compatible =3D "marvell,a38x-xor", .data =3D (void *)XOR_MODE_IN_D=
ESC },
> > +	{},
> > +};
> > +MODULE_DEVICE_TABLE(of, mv_xor_dt_ids);
> > +#endif
> > +
>=20
> Just leave out the #ifdef here. Almost all the mvebu machines use DT now,
> so it's not worth the size benefit of leaving it out on the few machines
> that don't.
>=20
> You'll have to remove the of_match_ptr() invocation as well if you do tha=
t,
> to avoid a warning about an unused symbol.

Will do.

Thanks!
Maxime

--=20
Maxime Ripard, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com

--NAmHCRPXNp23hR9r
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJVUwgnAAoJEBx+YmzsjxAg75gP/i02BLB4Bw6NHMfNbC4iw1eM
aYrfbFwx3s1WCPi6UpZBOzGiF6/lhykwVTQNzLKxXwOFabUYlTzQKSII1ArqhpLG
2dCad3DH+/aMpvYU4dsO/dE7hzzB9nojE62GthK0f2I4jBUB7pyXWD6w9zx7X6JX
FCwdwQSKvFM0nxHf+q223PVN6W8CpBCq594g1TM0lTYgqcJNb36biKyEMpVXzf7C
ihDlew2xtE1zCaUKxMOYzpU8ePkKSxR8R0s/V5CNmltKxM4mihUvwO/tb6+qAAOj
iPZjH459CMLqUQi+CzLhGyDze/KpR4Se/gg6mg25vN7wYv9RVpCSSMSc5auMXs82
lONZUD765Pi1XBaPbFKUgKNDODAY3n5gOZrbiOeGn5Wm43s6EjlLcv6TLH3fkdG8
mS710WdZ20zgKbfjL707OyTjz0ejain+tivwucC5+5ClR4TNOissMU9CSfGCiF6h
LKSeKXXYNO6IyunORCyk9CPXqGIEhRJb9yUhN+5t5tQ90wyZDyeM+IWHhuwkIF12
QscXVHEMWfJE14WJVeBOWGwirTtwhvPkeOn4AGnqlN9j18Ip1SMIujmJ4KYsFL8T
iKPowShlq/481/nP4aIJTOKT+d0V303rN+ZghJvIvYi9LXzC9QhSJprra/38K6ZT
n3pHmlD28KAPpSh68+wH
=PGb7
-----END PGP SIGNATURE-----

--NAmHCRPXNp23hR9r--

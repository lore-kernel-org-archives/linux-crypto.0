From: Pali =?utf-8?q?Roh=C3=A1r?= <pali.rohar@gmail.com>
Subject: Re: Nokia N900: omap aes is broken
Date: Tue, 24 Feb 2015 18:49:03 +0100
Message-ID: <201502241849.03170@pali>
References: <201502181321.03774@pali> <201502241838.44317@pali> <20150224173734.GD28244@atomide.com>
Mime-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart1693690.aSPyuCaX9c";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Cc: Nishanth Menon <nm@ti.com>, Felipe Balbi <balbi@ti.com>,
	Ivaylo Dimitrov <ivo.g.dimitrov.75@gmail.com>,
	Aaro Koskinen <aaro.koskinen@iki.fi>,
	Sebastian Reichel <sre@kernel.org>,
	Pavel Machek <pavel@ucw.cz>, linux-kernel@vger.kernel.org,
	linux-omap@vger.kernel.org, linux-crypto@vger.kernel.org
To: Tony Lindgren <tony@atomide.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20150224173734.GD28244@atomide.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

--nextPart1693690.aSPyuCaX9c
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: quoted-printable

On Tuesday 24 February 2015 18:37:34 Tony Lindgren wrote:
> * Pali Roh=C3=A1r <pali.rohar@gmail.com> [150224 09:42]:
> > On Tuesday 24 February 2015 18:25:12 Tony Lindgren wrote:
> > > * Pali Roh=C3=A1r <pali.rohar@gmail.com> [150218 16:03]:
> > > > --- a/arch/arm/mach-omap2/omap_hwmod_3xxx_data.c
> > > > +++ b/arch/arm/mach-omap2/omap_hwmod_3xxx_data.c
> > > > @@ -3938,8 +3938,9 @@ int __init
> > > > omap3xxx_hwmod_init(void)
> > > >=20
> > > >  	if (r < 0)
> > > >  =09
> > > >  		return r;
> > > >=20
> > > > -	/* Register GP-only hwmod links. */
> > > > -	if (h_gp && omap_type() =3D=3D OMAP2_DEVICE_TYPE_GP) {
> > > > +//	/* Register GP-only hwmod links. */
> > > > +//	if (h_gp && omap_type() =3D=3D OMAP2_DEVICE_TYPE_GP) {
> > > > +	if (h_gp) {
> > > >=20
> > > >  		r =3D omap_hwmod_register_links(h_gp);
> > > >  		if (r < 0)
> > > >  	=09
> > > >  			return r;
> > > >=20
> > > > aes hwmod is defined in GP-only hwmod...
> > >=20
> > > Doesn't this depend on the bootloader version of n900 to
> > > work?
> > >=20
> > > Regards,
> > >=20
> > > Tony
> >=20
> > Ok, it looks like second patch (omap_hwmod_3xxx_data.c)
> > needs that aes-enabled bootloader.
>=20
> OK we need some runtime detection somehow for what's enabled..
>=20

What about checking DT if omap-aes is disabled or not?

> > But first patch (omap3.dtsi) is needed for proper
> > definitions. Otherwise omap-aes driver will never work on
> > DT systems.
>=20
> Yeah that one makes sense to me, I guess you'll do a proper
> fix for that one.
>=20
> Regards,
>=20
> Tony

Yes, I will send patches via correct git format-patch.

=2D-=20
Pali Roh=C3=A1r
pali.rohar@gmail.com

--nextPart1693690.aSPyuCaX9c
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iEYEABECAAYFAlTsuY8ACgkQi/DJPQPkQ1J0dwCgwqRuML5dlqIpylmsy7KEBtn6
CqYAnj4ozz/Cp0FqKZrSwc+gUJQcs65Z
=vPra
-----END PGP SIGNATURE-----

--nextPart1693690.aSPyuCaX9c--

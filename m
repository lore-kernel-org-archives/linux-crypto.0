From: Pali =?utf-8?q?Roh=C3=A1r?= <pali.rohar@gmail.com>
Subject: Re: Nokia N900: omap aes is broken
Date: Wed, 25 Feb 2015 11:18:22 +0100
Message-ID: <201502251118.22991@pali>
References: <201502181321.03774@pali> <20150224173734.GD28244@atomide.com> <20150225095000.GB24627@amd>
Mime-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart237481912.y5Hj0EVIFL";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Cc: Tony Lindgren <tony@atomide.com>, Nishanth Menon <nm@ti.com>,
	Felipe Balbi <balbi@ti.com>,
	Ivaylo Dimitrov <ivo.g.dimitrov.75@gmail.com>,
	Aaro Koskinen <aaro.koskinen@iki.fi>,
	Sebastian Reichel <sre@kernel.org>,
	linux-kernel@vger.kernel.org, linux-omap@vger.kernel.org,
	linux-crypto@vger.kernel.org
To: Pavel Machek <pavel@ucw.cz>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-we0-f179.google.com ([74.125.82.179]:39126 "EHLO
	mail-we0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752666AbbBYKS0 (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 25 Feb 2015 05:18:26 -0500
In-Reply-To: <20150225095000.GB24627@amd>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

--nextPart237481912.y5Hj0EVIFL
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: quoted-printable

On Wednesday 25 February 2015 10:50:00 Pavel Machek wrote:
> On Tue 2015-02-24 09:37:34, Tony Lindgren wrote:
> > * Pali Roh=C3=A1r <pali.rohar@gmail.com> [150224 09:42]:
> > > On Tuesday 24 February 2015 18:25:12 Tony Lindgren wrote:
> > > > * Pali Roh=C3=A1r <pali.rohar@gmail.com> [150218 16:03]:
> > > > > --- a/arch/arm/mach-omap2/omap_hwmod_3xxx_data.c
> > > > > +++ b/arch/arm/mach-omap2/omap_hwmod_3xxx_data.c
> > > > > @@ -3938,8 +3938,9 @@ int __init
> > > > > omap3xxx_hwmod_init(void)
> > > > >=20
> > > > >  	if (r < 0)
> > > > >  =09
> > > > >  		return r;
> > > > >=20
> > > > > -	/* Register GP-only hwmod links. */
> > > > > -	if (h_gp && omap_type() =3D=3D OMAP2_DEVICE_TYPE_GP) {
> > > > > +//	/* Register GP-only hwmod links. */
> > > > > +//	if (h_gp && omap_type() =3D=3D OMAP2_DEVICE_TYPE_GP) {
> > > > > +	if (h_gp) {
> > > > >=20
> > > > >  		r =3D omap_hwmod_register_links(h_gp);
> > > > >  		if (r < 0)
> > > > >  	=09
> > > > >  			return r;
> > > > >=20
> > > > > aes hwmod is defined in GP-only hwmod...
> > > >=20
> > > > Doesn't this depend on the bootloader version of n900 to
> > > > work?
> > > >=20
> > > > Regards,
> > > >=20
> > > > Tony
> > >=20
> > > Ok, it looks like second patch (omap_hwmod_3xxx_data.c)
> > > needs that aes-enabled bootloader.
> >=20
> > OK we need some runtime detection somehow for what's
> > enabled..
> >=20
> > > But first patch (omap3.dtsi) is needed for proper
> > > definitions. Otherwise omap-aes driver will never work on
> > > DT systems.
> >=20
> > Yeah that one makes sense to me, I guess you'll do a proper
> > fix for that one.
>=20
> If this depends on bootloader... would command line parameter
> be right solution here?
> 									Pavel

Problem is that we need to disable AES in:

* DT file
* hwmod source code
* ... and maybe on other places too ...

So I think it make sense to check if AES is disabled in DT and=20
add this check to other parts of kernel source code where needed.

=2D-=20
Pali Roh=C3=A1r
pali.rohar@gmail.com

--nextPart237481912.y5Hj0EVIFL
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iEYEABECAAYFAlTtoW4ACgkQi/DJPQPkQ1KfHwCdEzdmJZ9RtR3SmXNUopfZq0CD
tAIAn1rz2bolw9HZS4nsNw5wGIf/tM/0
=wUAW
-----END PGP SIGNATURE-----

--nextPart237481912.y5Hj0EVIFL--

From: Pavel Machek <pavel@ucw.cz>
Subject: Re: Nokia N900: omap aes is broken
Date: Wed, 25 Feb 2015 10:50:00 +0100
Message-ID: <20150225095000.GB24627@amd>
References: <201502181321.03774@pali>
 <201502182227.55488@pali>
 <20150224172512.GC28244@atomide.com>
 <201502241838.44317@pali>
 <20150224173734.GD28244@atomide.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Pali =?iso-8859-1?Q?Roh=E1r?= <pali.rohar@gmail.com>,
	Nishanth Menon <nm@ti.com>, Felipe Balbi <balbi@ti.com>,
	Ivaylo Dimitrov <ivo.g.dimitrov.75@gmail.com>,
	Aaro Koskinen <aaro.koskinen@iki.fi>,
	Sebastian Reichel <sre@kernel.org>,
	linux-kernel@vger.kernel.org, linux-omap@vger.kernel.org,
	linux-crypto@vger.kernel.org
To: Tony Lindgren <tony@atomide.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20150224173734.GD28244@atomide.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Tue 2015-02-24 09:37:34, Tony Lindgren wrote:
> * Pali Roh=E1r <pali.rohar@gmail.com> [150224 09:42]:
> > On Tuesday 24 February 2015 18:25:12 Tony Lindgren wrote:
> > > * Pali Roh=E1r <pali.rohar@gmail.com> [150218 16:03]:
> > > > --- a/arch/arm/mach-omap2/omap_hwmod_3xxx_data.c
> > > > +++ b/arch/arm/mach-omap2/omap_hwmod_3xxx_data.c
> > > > @@ -3938,8 +3938,9 @@ int __init omap3xxx_hwmod_init(void)
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
> > > Doesn't this depend on the bootloader version of n900 to work?
> > >=20
> > > Regards,
> > >=20
> > > Tony
> >=20
> > Ok, it looks like second patch (omap_hwmod_3xxx_data.c) needs=20
> > that aes-enabled bootloader.
>=20
> OK we need some runtime detection somehow for what's enabled..
> =20
> > But first patch (omap3.dtsi) is needed for proper definitions.=20
> > Otherwise omap-aes driver will never work on DT systems.
>=20
> Yeah that one makes sense to me, I guess you'll do a proper
> fix for that one.

If this depends on bootloader... would command line parameter be right
solution here?
									Pavel
--=20
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses=
/blog.html

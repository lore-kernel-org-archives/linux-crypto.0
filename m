From: Tony Lindgren <tony@atomide.com>
Subject: Re: Nokia N900: omap aes is broken
Date: Tue, 24 Feb 2015 09:50:57 -0800
Message-ID: <20150224175056.GE28244@atomide.com>
References: <201502181321.03774@pali>
 <201502241838.44317@pali>
 <20150224173734.GD28244@atomide.com>
 <201502241849.03170@pali>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Nishanth Menon <nm@ti.com>, Felipe Balbi <balbi@ti.com>,
	Ivaylo Dimitrov <ivo.g.dimitrov.75@gmail.com>,
	Aaro Koskinen <aaro.koskinen@iki.fi>,
	Sebastian Reichel <sre@kernel.org>,
	Pavel Machek <pavel@ucw.cz>, linux-kernel@vger.kernel.org,
	linux-omap@vger.kernel.org, linux-crypto@vger.kernel.org
To: Pali =?utf-8?B?Um9ow6Fy?= <pali.rohar@gmail.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <201502241849.03170@pali>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

* Pali Roh=C3=A1r <pali.rohar@gmail.com> [150224 09:52]:
> On Tuesday 24 February 2015 18:37:34 Tony Lindgren wrote:
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
> > OK we need some runtime detection somehow for what's enabled..
> >=20
>=20
> What about checking DT if omap-aes is disabled or not?

In general that's not a good solution as marking something with
status =3D "disabled" means the device is completely ignored and
we will never have the struct device entry created for it and
we can never idle it.

But in this case however, it may be the right thing to do if the
secure mode is using that device.

Regards,

Tony

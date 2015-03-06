From: Pali =?utf-8?q?Roh=C3=A1r?= <pali.rohar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH 00/10] omap3 crypto fixes
Date: Fri, 6 Mar 2015 20:16:05 +0100
Message-ID: <201503062016.05608@pali>
References: <1424958600-18881-1-git-send-email-pali.rohar@gmail.com> <20150306183631.GA13520@atomide.com>
Mime-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart4273937.UzHOZsBag1";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Cc: =?utf-8?q?Beno=C3=AEt_Cousson?= <bcousson-rdvid1DuHRBWk0Htik3J/w@public.gmane.org>,
	Rob Herring <robh+dt-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>,
	Russell King <linux-lFZ/pmaqli7XmaaqVzeoHQ@public.gmane.org>,
	Paul Walmsley <paul-DWxLp4Yu+b8AvxtiuMwx3w@public.gmane.org>,
	Herbert Xu <herbert-lOAM2aK0SrRLBo1qDEOMRrpzq4S04n8Q@public.gmane.org>,
	"David S. Miller" <davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org>,
	linux-omap-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, devicetree-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-crypto-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	Pavel Machek <pavel-+ZI9xUNit7I@public.gmane.org>, Nishanth Menon <nm-l0cyMroinI0@public.gmane.org>,
	Ivaylo Dimitrov <ivo.g.dimitrov.75-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>,
	Aaro Koskinen <aaro.koskinen-X3B1VOXEql0@public.gmane.org>,
	Sebastian Reichel <sre-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
To: Tony Lindgren <tony-4v6yS6AI5VpBDgjK7y7TUQ@public.gmane.org>
Return-path: <devicetree-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20150306183631.GA13520-4v6yS6AI5VpBDgjK7y7TUQ@public.gmane.org>
Sender: devicetree-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-crypto.vger.kernel.org

--nextPart4273937.UzHOZsBag1
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: quoted-printable

On Friday 06 March 2015 19:36:32 Tony Lindgren wrote:
> * Pali Roh=C3=A1r <pali.rohar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> [150226 05:54]:
> > This patch series fix crypto support for omap3 devices which
> > use DT.
> >=20
> > It enables AES and SHAM on N9/N950 and SHAM on N900. AES is
> > still disabled for N900.
> >=20
> > Pali Roh=C3=A1r (10):
> >   ARM: OMAP2+: Return correct error values from device and
> >   hwmod ARM: OMAP3: Fix crypto support for HS devices
> >   crypto: omap-sham: Add support for omap3 devices
> >   crypto: omap-sham: Check for return value from
> >   pm_runtime_get_sync ARM: dts: omap3 hs: Remove timer12
> >   ARM: dts: omap3: Add missing dmas for crypto
> >   ARM: dts: n9/n950: Enable omap crypto support
> >   ARM: dts: n900: Enable omap sham and include directly
> >   omap34xx.dtsi ARM: dts: omap3-tao3530: Include directly
> >   omap34xx.dtsi ARM: dts: Remove files omap34xx-hs.dtsi and
> >   omap36xx-hs.dtsi
> > =20
> >  arch/arm/boot/dts/omap3-n900.dts           |   16 +++++-
> >  arch/arm/boot/dts/omap3-n950-n9.dtsi       |    2 +-
> >  arch/arm/boot/dts/omap3-tao3530.dtsi       |   11 +++-
> >  arch/arm/boot/dts/omap3.dtsi               |    4 ++
> >  arch/arm/boot/dts/omap34xx-hs.dtsi         |   16 ------
> >  arch/arm/boot/dts/omap36xx-hs.dtsi         |   16 ------
> >  arch/arm/mach-omap2/omap_device.c          |   30
> >  ++++++----- arch/arm/mach-omap2/omap_hwmod.c           | =20
> >  10 ++-- arch/arm/mach-omap2/omap_hwmod_3xxx_data.c |   79
> >  +++++++++++++++++++++++----- drivers/crypto/omap-sham.c  =20
> >               |   13 ++++- 10 files changed, 131
> >  insertions(+), 66 deletions(-) delete mode 100644
> >  arch/arm/boot/dts/omap34xx-hs.dtsi delete mode 100644
> >  arch/arm/boot/dts/omap36xx-hs.dtsi
>=20
> Are there any fixes in this series that should go into
> v4.0-rc series, or can it all wait for v4.1?
>=20
> Regards,
>=20
> Tony

I do not know which patches are you sending to 4.0-rc series, but=20
omap crypto is totally broken in linus tree for both GP & HS=20
omap3 devices when DT booting is used. This patch series fix that=20
problem.

=2D-=20
Pali Roh=C3=A1r
pali.rohar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org

--nextPart4273937.UzHOZsBag1
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iEYEABECAAYFAlT5/PUACgkQi/DJPQPkQ1JmWwCdHik8a25hVfqosZiBMBazhiTi
XfwAoKPvyyHF9andlc8NXXaYTTY1p653
=Gn3R
-----END PGP SIGNATURE-----

--nextPart4273937.UzHOZsBag1--
--
To unsubscribe from this list: send the line "unsubscribe devicetree" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

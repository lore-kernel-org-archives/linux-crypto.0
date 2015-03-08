From: Paul Walmsley <paul-DWxLp4Yu+b8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH 00/10] omap3 crypto fixes
Date: Sun, 8 Mar 2015 16:35:13 +0000 (UTC)
Message-ID: <alpine.DEB.2.02.1503081633300.20994@utopia.booyaka.com>
References: <1424958600-18881-1-git-send-email-pali.rohar@gmail.com> <20150306183631.GA13520@atomide.com> <20150306222306.GB587@fuloong-minipc.musicnaut.iki.fi> <201503081101.37452@pali>
Mime-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="843723315-361176072-1425832513=:20994"
Cc: Aaro Koskinen <aaro.koskinen-X3B1VOXEql0@public.gmane.org>,
	Tony Lindgren <tony-4v6yS6AI5VpBDgjK7y7TUQ@public.gmane.org>,
	=?ISO-8859-15?Q?Beno=EEt_Cousson?= <bcousson-rdvid1DuHRBWk0Htik3J/w@public.gmane.org>,
	Rob Herring <robh+dt-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>,
	Russell King <linux-lFZ/pmaqli7XmaaqVzeoHQ@public.gmane.org>,
	Herbert Xu <herbert-lOAM2aK0SrRLBo1qDEOMRrpzq4S04n8Q@public.gmane.org>,
	"David S. Miller" <davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org>,
	linux-omap-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, devicetree-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-crypto-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	Pavel Machek <pavel-+ZI9xUNit7I@public.gmane.org>, Nishanth Menon <nm-l0cyMroinI0@public.gmane.org>,
	Ivaylo Dimitrov <ivo.g.dimitrov.75-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>,
	Sebastian Reichel <sre-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
To: =?ISO-8859-15?Q?Pali_Roh=E1r?= <pali.rohar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <devicetree-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <201503081101.37452@pali>
Sender: devicetree-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-crypto.vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--843723315-361176072-1425832513=:20994
Content-Type: TEXT/PLAIN; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE

On Sun, 8 Mar 2015, Pali Roh=C3=A1r wrote:

> On Friday 06 March 2015 23:23:06 Aaro Koskinen wrote:
> > On Fri, Mar 06, 2015 at 10:36:32AM -0800, Tony Lindgren wrote:
> > > Are there any fixes in this series that should go into
> > > v4.0-rc series, or can it all wait for v4.1?
> >=20
> > I think these all should wait for v4.1.
> >=20
> > A.
>=20
> I would suggest to include at least patches 01, 04, 06. Probably=20
> those could go to -stable tree... but this decision is up to you.

I'm not sure patch 1 is a fix.  As far as I know we haven't=20
run into any issues with it on real hardware - only on QEMU - unless you=20
know otherwise, Pali?  Are we sure that the QEMU model behavior matches=20
the hardware?


- Paul
--843723315-361176072-1425832513=:20994--
--
To unsubscribe from this list: send the line "unsubscribe devicetree" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

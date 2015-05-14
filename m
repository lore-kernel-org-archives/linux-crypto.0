From: Tony Lindgren <tony-4v6yS6AI5VpBDgjK7y7TUQ@public.gmane.org>
Subject: Re: [PATCH 00/10] omap3 crypto fixes
Date: Thu, 14 May 2015 15:03:26 -0700
Message-ID: <20150514220325.GR15563@atomide.com>
References: <1424958600-18881-1-git-send-email-pali.rohar@gmail.com>
 <201505142317.41151@pali>
 <20150514213418.GP15563@atomide.com>
 <201505142339.14697@pali>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Aaro Koskinen <aaro.koskinen-X3B1VOXEql0@public.gmane.org>,
	=?utf-8?Q?Beno=C3=AEt?= Cousson <bcousson-rdvid1DuHRBWk0Htik3J/w@public.gmane.org>,
	Rob Herring <robh+dt-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>,
	Russell King <linux-lFZ/pmaqli7XmaaqVzeoHQ@public.gmane.org>,
	Paul Walmsley <paul-DWxLp4Yu+b8AvxtiuMwx3w@public.gmane.org>,
	Herbert Xu <herbert-lOAM2aK0SrRLBo1qDEOMRrpzq4S04n8Q@public.gmane.org>,
	"David S. Miller" <davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org>,
	linux-omap-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, devicetree-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-crypto-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	Pavel Machek <pavel-+ZI9xUNit7I@public.gmane.org>, Nishanth Menon <nm-l0cyMroinI0@public.gmane.org>,
	Ivaylo Dimitrov <ivo.g.dimitrov.75-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>,
	Sebastian Reichel <sre-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
To: Pali =?utf-8?B?Um9ow6Fy?= <pali.rohar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <devicetree-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <201505142339.14697@pali>
Sender: devicetree-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-crypto.vger.kernel.org

* Pali Roh=C3=A1r <pali.rohar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> [150514 14:40]:
> On Thursday 14 May 2015 23:34:19 Tony Lindgren wrote:
> > * Pali Roh=C3=A1r <pali.rohar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> [150514 14:19]:
> > > On Friday 06 March 2015 23:23:06 Aaro Koskinen wrote:
> > > > Hi,
> > > >=20
> > > > On Fri, Mar 06, 2015 at 10:36:32AM -0800, Tony Lindgren wrote:
> > > > > Are there any fixes in this series that should go into
> > > > > v4.0-rc series, or can it all wait for v4.1?
> > > >=20
> > > > I think these all should wait for v4.1.
> > > >=20
> > > > A.
> > >=20
> > > 4.1-rc3 was released and this patch series is still not included.=
=2E.
> >=20
> > The dts changes should be merged?
> >=20
>=20
> Looks like yes, but first two arch/arm/mach-omap2 patches not.

I suggest you repost those to separately so Paul can take
a look at them. It seems they can be merged separately from
the driver changes?
=20
Regards,

Tony
--
To unsubscribe from this list: send the line "unsubscribe devicetree" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

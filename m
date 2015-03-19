From: Tony Lindgren <tony-4v6yS6AI5VpBDgjK7y7TUQ@public.gmane.org>
Subject: Re: [PATCH 07/10] ARM: dts: n9/n950: Enable omap crypto support
Date: Thu, 19 Mar 2015 09:43:32 -0700
Message-ID: <20150319164331.GG31346@atomide.com>
References: <1424958600-18881-1-git-send-email-pali.rohar@gmail.com>
 <1424958600-18881-8-git-send-email-pali.rohar@gmail.com>
 <20150228164148.GE4978@amd>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Pali =?utf-8?B?Um9ow6Fy?= <pali.rohar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>,
	=?utf-8?Q?Beno=C3=AEt?= Cousson <bcousson-rdvid1DuHRBWk0Htik3J/w@public.gmane.org>,
	Rob Herring <robh+dt-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>,
	Russell King <linux-lFZ/pmaqli7XmaaqVzeoHQ@public.gmane.org>,
	Paul Walmsley <paul-DWxLp4Yu+b8AvxtiuMwx3w@public.gmane.org>,
	Herbert Xu <herbert-lOAM2aK0SrRLBo1qDEOMRrpzq4S04n8Q@public.gmane.org>,
	"David S. Miller" <davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org>,
	linux-omap-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, devicetree-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-crypto-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	Nishanth Menon <nm-l0cyMroinI0@public.gmane.org>,
	Ivaylo Dimitrov <ivo.g.dimitrov.75-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>,
	Aaro Koskinen <aaro.koskinen-X3B1VOXEql0@public.gmane.org>,
	Sebastian Reichel <sre-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
To: Pavel Machek <pavel-+ZI9xUNit7I@public.gmane.org>
Return-path: <devicetree-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20150228164148.GE4978@amd>
Sender: devicetree-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-crypto.vger.kernel.org

* Pavel Machek <pavel-+ZI9xUNit7I@public.gmane.org> [150228 08:45]:
> On Thu 2015-02-26 14:49:57, Pali Roh=C3=A1r wrote:
> > Harmattan system on Nokia N9 and N950 devices uses omap crypto supp=
ort.
> > Bootloader on those devices is known that it enables HW crypto supp=
ort.
> > This patch just include omap36xx.dtsi directly, so aes and sham is =
enabled.
> >=20
> > Signed-off-by: Pali Roh=C3=A1r <pali.rohar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
>=20
> Acked-by: Pavel Machek <pavel-+ZI9xUNit7I@public.gmane.org>

I'm picking patches 7 - 10 into omap-for-v4.1/dt branch thanks.

Tony
--
To unsubscribe from this list: send the line "unsubscribe devicetree" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

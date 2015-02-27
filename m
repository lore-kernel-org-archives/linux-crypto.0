From: Tony Lindgren <tony@atomide.com>
Subject: Re: [PATCH 07/10] ARM: dts: n9/n950: Enable omap crypto support
Date: Fri, 27 Feb 2015 08:10:04 -0800
Message-ID: <20150227161004.GW11056@atomide.com>
References: <1424958600-18881-1-git-send-email-pali.rohar@gmail.com>
 <1424958600-18881-8-git-send-email-pali.rohar@gmail.com>
 <20150227154319.GT11056@atomide.com>
 <201502271701.56059@pali>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: =?utf-8?Q?Beno=C3=AEt?= Cousson <bcousson@baylibre.com>,
	Rob Herring <robh+dt@kernel.org>,
	Russell King <linux@arm.linux.org.uk>,
	Paul Walmsley <paul@pwsan.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	linux-omap@vger.kernel.org, devicetree@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org,
	Pavel Machek <pavel@ucw.cz>, Nishanth Menon <nm@ti.com>,
	Ivaylo Dimitrov <ivo.g.dimitrov.75@gmail.com>,
	Aaro Koskinen <aaro.koskinen@iki.fi>,
	Sebastian Reichel <sre@kernel.org>
To: Pali =?utf-8?B?Um9ow6Fy?= <pali.rohar@gmail.com>
Return-path: <linux-omap-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <201502271701.56059@pali>
Sender: linux-omap-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

* Pali Roh=C3=A1r <pali.rohar@gmail.com> [150227 08:05]:
> On Friday 27 February 2015 16:43:20 Tony Lindgren wrote:
> > * Pali Roh=C3=A1r <pali.rohar@gmail.com> [150226 05:54]:
> > > Harmattan system on Nokia N9 and N950 devices uses omap
> > > crypto support. Bootloader on those devices is known that
> > > it enables HW crypto support. This patch just include
> > > omap36xx.dtsi directly, so aes and sham is enabled.
> >=20
> > Let's also remove omap36xx-hs.dtsi with this patch if no other
> > users.
> >=20
>=20
> Removing both -hs files is done by last patch in this series.

Yes just noticed thanks, no need to change.

Regards,

Tony
--
To unsubscribe from this list: send the line "unsubscribe linux-omap" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

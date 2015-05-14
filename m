From: Tony Lindgren <tony@atomide.com>
Subject: Re: [PATCH 00/10] omap3 crypto fixes
Date: Thu, 14 May 2015 14:34:19 -0700
Message-ID: <20150514213418.GP15563@atomide.com>
References: <1424958600-18881-1-git-send-email-pali.rohar@gmail.com>
 <20150306183631.GA13520@atomide.com>
 <20150306222306.GB587@fuloong-minipc.musicnaut.iki.fi>
 <201505142317.41151@pali>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Aaro Koskinen <aaro.koskinen@iki.fi>,
	=?utf-8?Q?Beno=C3=AEt?= Cousson <bcousson@baylibre.com>,
	Rob Herring <robh+dt@kernel.org>,
	Russell King <linux@arm.linux.org.uk>,
	Paul Walmsley <paul@pwsan.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	linux-omap@vger.kernel.org, devicetree@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org,
	Pavel Machek <pavel@ucw.cz>, Nishanth Menon <nm@ti.com>,
	Ivaylo Dimitrov <ivo.g.dimitrov.75@gmail.com>,
	Sebastian Reichel <sre@kernel.org>
To: Pali =?utf-8?B?Um9ow6Fy?= <pali.rohar@gmail.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from muru.com ([72.249.23.125]:51041 "EHLO muru.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933547AbbENVeW (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Thu, 14 May 2015 17:34:22 -0400
Content-Disposition: inline
In-Reply-To: <201505142317.41151@pali>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

* Pali Roh=C3=A1r <pali.rohar@gmail.com> [150514 14:19]:
> On Friday 06 March 2015 23:23:06 Aaro Koskinen wrote:
> > Hi,
> >=20
> > On Fri, Mar 06, 2015 at 10:36:32AM -0800, Tony Lindgren wrote:
> > > Are there any fixes in this series that should go into
> > > v4.0-rc series, or can it all wait for v4.1?
> >=20
> > I think these all should wait for v4.1.
> >=20
> > A.
>=20
> 4.1-rc3 was released and this patch series is still not included...

The dts changes should be merged?

I suggest you repost the driver fixes so Herbert can queue them.

Regards,

Tony

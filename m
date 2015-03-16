From: Tony Lindgren <tony@atomide.com>
Subject: Re: [PATCH 06/10] ARM: dts: omap3: Add missing dmas for crypto
Date: Mon, 16 Mar 2015 14:44:43 -0700
Message-ID: <20150316214442.GJ12397@atomide.com>
References: <1424958600-18881-1-git-send-email-pali.rohar@gmail.com>
 <1424958600-18881-7-git-send-email-pali.rohar@gmail.com>
 <20150228164604.GI4978@amd>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Pali =?utf-8?B?Um9ow6Fy?= <pali.rohar@gmail.com>,
	=?utf-8?Q?Beno=C3=AEt?= Cousson <bcousson@baylibre.com>,
	Rob Herring <robh+dt@kernel.org>,
	Russell King <linux@arm.linux.org.uk>,
	Paul Walmsley <paul@pwsan.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	linux-omap@vger.kernel.org, devicetree@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org,
	Nishanth Menon <nm@ti.com>,
	Ivaylo Dimitrov <ivo.g.dimitrov.75@gmail.com>,
	Aaro Koskinen <aaro.koskinen@iki.fi>,
	Sebastian Reichel <sre@kernel.org>
To: Pavel Machek <pavel@ucw.cz>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from muru.com ([72.249.23.125]:37866 "EHLO muru.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753100AbbCPVtd (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Mon, 16 Mar 2015 17:49:33 -0400
Content-Disposition: inline
In-Reply-To: <20150228164604.GI4978@amd>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

* Pavel Machek <pavel@ucw.cz> [150228 08:49]:
> On Thu 2015-02-26 14:49:56, Pali Roh=C3=A1r wrote:
> > This patch adds missing dma DTS definitions for omap aes and sham d=
rivers.
> > Without it kernel drivers do not work.
> >=20
> > Signed-off-by: Pali Roh=C3=A1r <pali.rohar@gmail.com>
>=20
> Acked-by: Pavel	 Machek <pavel@ucw.cz>

Applying this into omap-for-v4.0/fixes to remove the regression
for legacy vs DT based booting for GP omap3 boards.

Tony

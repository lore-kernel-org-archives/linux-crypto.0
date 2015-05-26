From: Pali =?utf-8?B?Um9ow6Fy?= <pali.rohar@gmail.com>
Subject: Re: [PATCH 02/10] ARM: OMAP3: Fix crypto support for HS devices
Date: Tue, 26 May 2015 12:54:15 +0200
Message-ID: <20150526105415.GB14541@pali>
References: <1424958600-18881-1-git-send-email-pali.rohar@gmail.com>
 <1424958600-18881-3-git-send-email-pali.rohar@gmail.com>
 <20150228162436.GB4978@amd>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: =?utf-8?Q?Beno=C3=AEt?= Cousson <bcousson@baylibre.com>,
	Tony Lindgren <tony@atomide.com>,
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
	Sebastian Reichel <sre@kernel.org>, Pavel Machek <pavel@ucw.cz>
To: Paul Walmsley <paul@pwsan.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-wi0-f179.google.com ([209.85.212.179]:35263 "EHLO
	mail-wi0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752002AbbEZMga (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 26 May 2015 08:36:30 -0400
Content-Disposition: inline
In-Reply-To: <20150228162436.GB4978@amd>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi Paul,

this patch is also for omap2... Can you review it too?

On Saturday 28 February 2015 17:24:36 Pavel Machek wrote:
> On Thu 2015-02-26 14:49:52, Pali Roh=C3=A1r wrote:
> > Register crypto hwmod links only if they are not disabled in DT.
> > If DT information is missing, enable them only for GP devices.
> >=20
> > Before this patch crypto hwmod links were always disabled for all H=
S devices
> > and it was not possible to use omap-aes and omap-sham linux drivers=
=2E
> >=20
> > Signed-off-by: Pali Roh=C3=A1r <pali.rohar@gmail.com>
>=20
> Acked-by: Pavel Machek <pavel@ucw.cz>
>=20

--=20
Pali Roh=C3=A1r
pali.rohar@gmail.com

From: Pali =?utf-8?B?Um9ow6Fy?= <pali.rohar@gmail.com>
Subject: Re: [PATCH v2] crypto: omap-sham: Check for return value from
 pm_runtime_get_sync
Date: Fri, 15 May 2015 11:20:51 +0200
Message-ID: <20150515092051.GB12078@pali>
References: <1424958600-18881-5-git-send-email-pali.rohar@gmail.com>
 <1425808861-17004-1-git-send-email-pali.rohar@gmail.com>
 <201505142340.37649@pali>
 <20150515070229.GA16939@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: =?utf-8?Q?Beno=C3=AEt?= Cousson <bcousson@baylibre.com>,
	Tony Lindgren <tony@atomide.com>,
	Rob Herring <robh+dt@kernel.org>,
	Russell King <linux@arm.linux.org.uk>,
	Paul Walmsley <paul@pwsan.com>,
	"David S. Miller" <davem@davemloft.net>,
	linux-omap@vger.kernel.org, devicetree@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org,
	Pavel Machek <pavel@ucw.cz>, Nishanth Menon <nm@ti.com>,
	Ivaylo Dimitrov <ivo.g.dimitrov.75@gmail.com>,
	Aaro Koskinen <aaro.koskinen@iki.fi>,
	Sebastian Reichel <sre@kernel.org>
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-wi0-f177.google.com ([209.85.212.177]:36599 "EHLO
	mail-wi0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752880AbbEOJVA (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Fri, 15 May 2015 05:21:00 -0400
Content-Disposition: inline
In-Reply-To: <20150515070229.GA16939@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Friday 15 May 2015 15:02:29 Herbert Xu wrote:
> On Thu, May 14, 2015 at 11:40:37PM +0200, Pali Roh=C3=A1r wrote:
> > On Sunday 08 March 2015 11:01:01 Pali Roh=C3=A1r wrote:
> > > Function pm_runtime_get_sync could fail and we need to check retu=
rn
> > > value to prevent kernel crash.
> > >=20
> > > Signed-off-by: Pali Roh=C3=A1r <pali.rohar@gmail.com>
>=20
> Applied.

Thanks! In this patch series is also another one patch for crypto
subsystem. I replied to that patch email.

--=20
Pali Roh=C3=A1r
pali.rohar@gmail.com

From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH v2] crypto: omap-sham: Check for return value from
 pm_runtime_get_sync
Date: Fri, 15 May 2015 15:02:29 +0800
Message-ID: <20150515070229.GA16939@gondor.apana.org.au>
References: <1424958600-18881-5-git-send-email-pali.rohar@gmail.com>
 <1425808861-17004-1-git-send-email-pali.rohar@gmail.com>
 <201505142340.37649@pali>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: =?iso-8859-1?Q?Beno=EEt?= Cousson <bcousson@baylibre.com>,
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
To: Pali =?iso-8859-1?Q?Roh=E1r?= <pali.rohar@gmail.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:43417 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754010AbbEOHCr (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Fri, 15 May 2015 03:02:47 -0400
Content-Disposition: inline
In-Reply-To: <201505142340.37649@pali>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Thu, May 14, 2015 at 11:40:37PM +0200, Pali Roh=E1r wrote:
> On Sunday 08 March 2015 11:01:01 Pali Roh=E1r wrote:
> > Function pm_runtime_get_sync could fail and we need to check return
> > value to prevent kernel crash.
> >=20
> > Signed-off-by: Pali Roh=E1r <pali.rohar@gmail.com>

Applied.
--=20
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt

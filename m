From: Pavel Machek <pavel@ucw.cz>
Subject: Re: [PATCH v2] crypto: omap-sham: Check for return value from
 pm_runtime_get_sync
Date: Mon, 9 Mar 2015 21:52:58 +0100
Message-ID: <20150309205259.GA11826@amd>
References: <1424958600-18881-5-git-send-email-pali.rohar@gmail.com>
 <1425808861-17004-1-git-send-email-pali.rohar@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: =?iso-8859-1?Q?Beno=EEt?= Cousson <bcousson@baylibre.com>,
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
	Sebastian Reichel <sre@kernel.org>
To: Pali =?iso-8859-1?Q?Roh=E1r?= <pali.rohar@gmail.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:36357 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754110AbbCIUxT (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 9 Mar 2015 16:53:19 -0400
Content-Disposition: inline
In-Reply-To: <1425808861-17004-1-git-send-email-pali.rohar@gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Sun 2015-03-08 11:01:01, Pali Roh=E1r wrote:
> Function pm_runtime_get_sync could fail and we need to check return
> value to prevent kernel crash.
>=20
> Signed-off-by: Pali Roh=E1r <pali.rohar@gmail.com>

Acked-by: Pavel Machek <pavel@ucw.cz>

--=20
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses=
/blog.html

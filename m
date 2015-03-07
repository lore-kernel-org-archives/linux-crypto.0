From: Aaro Koskinen <aaro.koskinen@iki.fi>
Subject: Re: [PATCH 00/10] omap3 crypto fixes
Date: Sun, 8 Mar 2015 01:19:25 +0200
Message-ID: <20150307231924.GC587@fuloong-minipc.musicnaut.iki.fi>
References: <1424958600-18881-1-git-send-email-pali.rohar@gmail.com>
 <20150226224605.GC14117@fuloong-minipc.musicnaut.iki.fi>
 <201502271340.44659@pali>
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
	Pavel Machek <pavel@ucw.cz>, Nishanth Menon <nm@ti.com>,
	Ivaylo Dimitrov <ivo.g.dimitrov.75@gmail.com>,
	Sebastian Reichel <sre@kernel.org>
To: Pali =?iso-8859-1?Q?Roh=E1r?= <pali.rohar@gmail.com>
Return-path: <linux-omap-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <201502271340.44659@pali>
Sender: linux-omap-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Hi,

On Fri, Feb 27, 2015 at 01:40:44PM +0100, Pali Roh=E1r wrote:
> > However I get these when CONFIG_CRYPTO_MANAGER_DISABLE_TESTS
> > is not set:
> >=20
> > 	alg: hash: Chunking test 1 failed for omap-sha1
> > 	alg: hash: Chunking test 1 failed for omap-md5
> > 	alg: hash: Chunking test 1 failed for omap-hmac-sha1
> > 	alg: hash: Chunking test 1 failed for omap-hmac-md5

BTW, it seems these errors are reported to be introduced possibly
somewhere between 3.11 and 3.15:

	https://lists.fedoraproject.org/pipermail/arm/2014-August/008240.html=20

A.
--
To unsubscribe from this list: send the line "unsubscribe linux-omap" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

From: Aaro Koskinen <aaro.koskinen@iki.fi>
Subject: Re: [PATCH 00/10] omap3 crypto fixes
Date: Fri, 27 Feb 2015 00:46:05 +0200
Message-ID: <20150226224605.GC14117@fuloong-minipc.musicnaut.iki.fi>
References: <1424958600-18881-1-git-send-email-pali.rohar@gmail.com>
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
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1424958600-18881-1-git-send-email-pali.rohar@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Hi,

On Thu, Feb 26, 2015 at 02:49:50PM +0100, Pali Roh=E1r wrote:
> This patch series fix crypto support for omap3 devices which use DT.
>=20
> It enables AES and SHAM on N9/N950 and SHAM on N900. AES is still dis=
abled for N900.

(Please format your lines somewhere near < 76 chars, especially in
commit logs, otherwise "git log" looks ugly on 80 char terminals.)

I tested these with stock bootloaders, and devices boot normally
and I can now modprobe omap-aes (on N9 and N950) and omap-sham
(on all three):

	omap-aes 480c5000.aes: OMAP AES hw accel rev: 2.6
	omap-sham 480c3000.sham: hw accel on OMAP rev 0.9

However I get these when CONFIG_CRYPTO_MANAGER_DISABLE_TESTS is not set=
:

	alg: hash: Chunking test 1 failed for omap-sha1
	alg: hash: Chunking test 1 failed for omap-md5
	alg: hash: Chunking test 1 failed for omap-hmac-sha1
	alg: hash: Chunking test 1 failed for omap-hmac-md5

But that's probably unrelated to this series. For patches 1-8,
feel free to add:

Tested-by: Aaro Koskinen <aaro.koskinen@iki.fi>

A.

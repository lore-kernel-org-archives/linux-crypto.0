From: Pali =?utf-8?q?Roh=C3=A1r?= <pali.rohar@gmail.com>
Subject: Re: [PATCH 00/10] omap3 crypto fixes
Date: Sun, 15 Mar 2015 10:59:32 +0100
Message-ID: <201503151059.32063@pali>
References: <1424958600-18881-1-git-send-email-pali.rohar@gmail.com> <201503081101.37452@pali> <alpine.DEB.2.02.1503081633300.20994@utopia.booyaka.com>
Mime-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart3182315.HzrrPGmqaH";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Cc: Aaro Koskinen <aaro.koskinen@iki.fi>,
	Tony Lindgren <tony@atomide.com>,
	=?utf-8?q?Beno=C3=AEt_Cousson?= <bcousson@baylibre.com>,
	Rob Herring <robh+dt@kernel.org>,
	Russell King <linux@arm.linux.org.uk>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	linux-omap@vger.kernel.org, devicetree@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org,
	Pavel Machek <pavel@ucw.cz>, Nishanth Menon <nm@ti.com>,
	Ivaylo Dimitrov <ivo.g.dimitrov.75@gmail.com>,
	Sebastian Reichel <sre@kernel.org>
To: Paul Walmsley <paul@pwsan.com>
Return-path: <linux-omap-owner@vger.kernel.org>
In-Reply-To: <alpine.DEB.2.02.1503081633300.20994@utopia.booyaka.com>
Sender: linux-omap-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

--nextPart3182315.HzrrPGmqaH
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: quoted-printable

On Sunday 08 March 2015 17:35:13 Paul Walmsley wrote:
> On Sun, 8 Mar 2015, Pali Roh=C3=A1r wrote:
> > On Friday 06 March 2015 23:23:06 Aaro Koskinen wrote:
> > > On Fri, Mar 06, 2015 at 10:36:32AM -0800, Tony Lindgren=20
wrote:
> > > > Are there any fixes in this series that should go into
> > > > v4.0-rc series, or can it all wait for v4.1?
> > >=20
> > > I think these all should wait for v4.1.
> > >=20
> > > A.
> >=20
> > I would suggest to include at least patches 01, 04, 06.
> > Probably those could go to -stable tree... but this
> > decision is up to you.
>=20
> I'm not sure patch 1 is a fix.  As far as I know we haven't
> run into any issues with it on real hardware - only on QEMU -
> unless you know otherwise, Pali?  Are we sure that the QEMU
> model behavior matches the hardware?
>=20
>=20
> - Paul

Patch 1 check for return value of more functions. If real HW or=20
software emulated HW (in qemu) does not support e.g. aes then=20
kernel show oops message, because kernel does not check return=20
values and try to touch non-existent HW. So I think patch 1 is=20
really fix. In my opinion if something can fail, then kernel=20
should check if it failed. And not expect that function call=20
always pass.

=2D-=20
Pali Roh=C3=A1r
pali.rohar@gmail.com

--nextPart3182315.HzrrPGmqaH
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iEYEABECAAYFAlUFWAQACgkQi/DJPQPkQ1JXCgCfZulItY/lich4DDYhBSXqwhQ6
eHQAnjPcOXMp+jWKOW2umzBzKPb4LtL6
=VleP
-----END PGP SIGNATURE-----

--nextPart3182315.HzrrPGmqaH--

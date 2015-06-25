From: Simon Guinot <simon.guinot@sequanux.org>
Subject: Re: [PATCH] crypto: mv_cesa - fix up for of_get_named_gen_pool()
 rename
Date: Thu, 25 Jun 2015 17:56:05 +0200
Message-ID: <20150625155605.GI4853@kw.sim.vm.gnt>
References: <CABxcv=m4juAMHaMYSB+8O8cEX+YZCJ0cArS2wN-YGpTBgWe-CA@mail.gmail.com>
 <1435221470-5382-1-git-send-email-simon.guinot@sequanux.org>
 <20150625153006.GA11513@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="ixNtouB4hv1hrEz3"
Cc: Lior Amsalem <alior@marvell.com>, Andrew Lunn <andrew@lunn.ch>,
	Nadav Haklai <nadavh@marvell.com>,
	Mark Rutland <mark.rutland@arm.com>,
	Boris Brezillon <boris.brezillon@free-electrons.com>,
	Russell King - ARM Linux <linux@arm.linux.org.uk>,
	Tawfik Bayouk <tawfik@marvell.com>,
	Eran Ben-Avi <benavi@marvell.com>,
	Jason Gunthorpe <jgunthorpe@obsidianresearch.com>,
	linux-next@vger.kernel.org,
	Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
	devicetree@vger.kernel.org, Jason Cooper <jason@lakedaemon.net>,
	Pawel Moll <pawel.moll@arm.com>,
	Ian Campbell <ijc+devicetree@hellion.org.uk>,
	Arnaud Ebalard <arno@natisbad.org>,
	Rob Herring <robh+dt@kernel.org>,
	Gregory CLEMENT <gregory.clement@free-electrons.com>,
	linux-arm-kernel@lists.infradead.org,
	Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
	LKML <linux-kernel@vger.kernel.org>,
	linux-crypto@vger.kernel.org,
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-next-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20150625153006.GA11513@gondor.apana.org.au>
Sender: linux-next-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org


--ixNtouB4hv1hrEz3
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Jun 25, 2015 at 11:30:06PM +0800, Herbert Xu wrote:
> On Thu, Jun 25, 2015 at 10:37:50AM +0200, Simon Guinot wrote:
> > This patch fixes the following build error:
> >=20
> > drivers/crypto/mv_cesa.c: In function 'mv_cesa_get_sram':
> > drivers/crypto/mv_cesa.c:1037: error: implicit declaration of function =
'of_get_named_gen_pool'
> > drivers/crypto/mv_cesa.c:1038: warning: assignment makes pointer from i=
nteger without a cast
> > scripts/Makefile.build:258: recipe for target 'drivers/crypto/mv_cesa.o=
' failed
> >=20
> > Signed-off-by: Simon Guinot <simon.guinot@sequanux.org>
>=20
> This patch doesn't compile.

It does compile. How it could not ?
But since the issue has already been fixed, it doesn't really matter.

Simon

--ixNtouB4hv1hrEz3
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAlWMJJUACgkQgtp0PDeOcDrrIgCeIK8ognMIibnhMwkgTykdiHGF
tZoAoKE1jmRtSe/rQopXtJfvoo9JANre
=vl6b
-----END PGP SIGNATURE-----

--ixNtouB4hv1hrEz3--

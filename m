From: Huang Ying <ying.huang@intel.com>
Subject: Accelerate GCM with PCLMULQDQ-NI
Date: Wed, 18 Mar 2009 16:52:12 +0800
Message-ID: <1237366332.24215.260.camel@yhuang-dev.sh.intel.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-EkkVgnBVuB/dPcXZpoic"
Cc: linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>,
	Sebastian Andrzej Siewior <linux-crypto@ml.breakpoint.cc>
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1755323AbZCRIwe@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org


--=-EkkVgnBVuB/dPcXZpoic
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

Hi,

In addition to AES-NI, Intel will provide PCLMULQDQ-NI (carry-less
multiplication) in future CPU to accelerate GCM mode. The document can
be found here:

http://software.intel.com/en-us/articles/carry-less-multiplication-and-its-=
usage-for-computing-the-gcm-mode/

It follows the same design as that of AES-NI, that is, XMM registers are
used.

To accelerate GCM with it, I make the following design:

1. Implement ghash as an ahash algorithm, Use ghash in gcm
implementation.
2. Provide a new implementation of ghash with PCLMULQDQ-NI.

What do you think about that?

Best Regards,
Huang Ying


--=-EkkVgnBVuB/dPcXZpoic
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEABECAAYFAknAtjMACgkQKhFGF+eHlpgW2gCeOAf4TntXHaISbNu7uTqHvjKe
oSMAoIw5qb2+9mA87+vqQYtEV5GvLsMa
=9uRP
-----END PGP SIGNATURE-----

--=-EkkVgnBVuB/dPcXZpoic--

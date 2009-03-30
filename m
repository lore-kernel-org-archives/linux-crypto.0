From: Huang Ying <ying.huang@intel.com>
Subject: Re: Accelerate GCM with PCLMULQDQ-NI
Date: Mon, 30 Mar 2009 09:36:35 +0800
Message-ID: <1238376995.6639.80.camel@yhuang-dev.sh.intel.com>
References: <1237366332.24215.260.camel@yhuang-dev.sh.intel.com>
	 <20090329074326.GB11735@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-ZT24eGYiBapoGWK5d4tS"
Cc: Sebastian Andrzej Siewior <linux-crypto@ml.breakpoint.cc>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1757440AbZC3Bg4@vger.kernel.org>
In-Reply-To: <20090329074326.GB11735@gondor.apana.org.au>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org


--=-ZT24eGYiBapoGWK5d4tS
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Sun, 2009-03-29 at 15:43 +0800, Herbert Xu wrote:
> On Wed, Mar 18, 2009 at 04:52:12PM +0800, Huang Ying wrote:
> >
> > To accelerate GCM with it, I make the following design:
> >=20
> > 1. Implement ghash as an ahash algorithm, Use ghash in gcm
> > implementation.
> > 2. Provide a new implementation of ghash with PCLMULQDQ-NI.
> >=20
> > What do you think about that?
>=20
> Sounds OK to me.  I presume the choice of ahash instead of shash
> is due to the use of XMM registers, just like AES?

Yes, because PCLMULQDQ touches XMMs too. Just like AES, there is a raw
shash: ghash-clmul and an ahash via cryptd(ghash-clmul).

Best Regards,
Huang Ying


--=-ZT24eGYiBapoGWK5d4tS
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEABECAAYFAknQIh8ACgkQKhFGF+eHlpjiyQCdGZnZKSWJiZpyQET0G2m66wvC
UAsAnii91nPpLBW1pHWMKdt5aAIhMn0+
=PIwQ
-----END PGP SIGNATURE-----

--=-ZT24eGYiBapoGWK5d4tS--

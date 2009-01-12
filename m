From: Huang Ying <ying.huang@intel.com>
Subject: Re: [RFC PATCH crypto 4/4] AES-NI: Add support to Intel AES-NI
	instructions for x86_64 platform
Date: Mon, 12 Jan 2009 14:55:10 +0800
Message-ID: <1231743310.5937.107.camel@yhuang-dev.sh.intel.com>
References: <1231120947.5937.31.camel@yhuang-dev.sh.intel.com>
	 <20090109070144.GA7358@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-pgGYok33G0B8RvoQt4kN"
Cc: Sebastian Siewior <linux-crypto@ml.breakpoint.cc>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mga14.intel.com ([143.182.124.37]:43530 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750977AbZALGzN (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Mon, 12 Jan 2009 01:55:13 -0500
In-Reply-To: <20090109070144.GA7358@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>


--=-pgGYok33G0B8RvoQt4kN
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Fri, 2009-01-09 at 15:01 +0800, Herbert Xu wrote:
> Actually I was thinking of something as simple as just using
> cryptd as is.  That is, register a blkcipher algorithm for your
> version of cbc-aes, but don't register under the name cbc(aes),
> e.g., register it under the name of __cbc-aes-aesni for both alg
> name and driver name.  You can register it under cbc(aes) too
> if you add the fallback in there.
>=20
> Then for the real thing, just allocate the blkcipher __cbc_*,
> plus the ablkcipher cryptd(__cbc_*), and invoke the right one
> depending on caller context.

One more question:

I use a "shell" cbc(aes) algorithm which chooses between
cryptd(__cbc-aes-aesni) and __cbc-aes-aesni according to context. But
the struct ablkcipher_request passed in can not be used for cryptd(*).
This can be resolved by allocating another struct ablkcipher_request for
cryptd(*) for each incoming struct ablkcipher_request. But is there any
better solution?

Best Regards,
Huang Ying

--=-pgGYok33G0B8RvoQt4kN
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEABECAAYFAklq6UsACgkQKhFGF+eHlph79gCfaq/sf1JlBB8zTb2HLVGTiqmU
JHoAmgNCiJdMqjwZCoOBKmWyM4GvqLjI
=EgKi
-----END PGP SIGNATURE-----

--=-pgGYok33G0B8RvoQt4kN--


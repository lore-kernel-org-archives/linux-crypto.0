From: Huang Ying <ying.huang@intel.com>
Subject: Re: Use cryptd(%s) as cryptd-ed algorithm name instead of %s
Date: Wed, 14 Jan 2009 15:01:51 +0800
Message-ID: <1231916511.5937.151.camel@yhuang-dev.sh.intel.com>
References: <1231915448.5937.145.camel@yhuang-dev.sh.intel.com>
	 <20090114065359.GA16044@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-XZKUfC8tHQUIZ0vlIVmr"
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:64907 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753314AbZANHBy (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Wed, 14 Jan 2009 02:01:54 -0500
In-Reply-To: <20090114065359.GA16044@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>


--=-XZKUfC8tHQUIZ0vlIVmr
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Wed, 2009-01-14 at 14:53 +0800, Herbert Xu wrote:
> On Wed, Jan 14, 2009 at 02:44:08PM +0800, Huang Ying wrote:
> > Because:
> >=20
> > 1. if use %s, you can only request cryptd(<driver name>), not
> >    cryptd(<alg name>), because generated new algorithm instance has
> >    algorithm name: <alg name> and driver name cryptd(<driver name>).
>=20
> This is intentional.  For the purposes we talked about we should
> be requesting cryptd(<driver name>), as otherwise you may end up
> with someone else's AES algorithm as the base.

Current cryptd works well for AES-NI implementation. But how about
somebody want cryptd(cbc(aes)), and don't care about the driver.

> > 2. Generated cryptd-ed algorithm will have the same algorithm name and
> >    higher priority, but some user may not want to use cryptd-ed
> >    version.
>=20
> The priority shouldn't be an issue in our case since the AES-NI
> algorithm should register itself as an ablkcipher with an even
> higher priority.

Yes, not an issue for AES-NI case until now. But, for example there is
no aes-ni, if someone request cryptd(cbc(aes-asm)), other user will get
cryptd(cbc(aes-asm)) instead of cbc(aes-asm) when request cbc(aes), is
this a good behavior?

Best Regards,
Huang Ying


--=-XZKUfC8tHQUIZ0vlIVmr
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEUEABECAAYFAkltjdwACgkQKhFGF+eHlpjGgQCWK3boOD9Ozpho3AhqUEfXYAll
4gCfRmF6aesJ1bIM/d0S5PNQRE32zeE=
=QGK7
-----END PGP SIGNATURE-----

--=-XZKUfC8tHQUIZ0vlIVmr--


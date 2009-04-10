From: Huang Ying <ying.huang@intel.com>
Subject: Re: GCM benchmark
Date: Fri, 10 Apr 2009 09:51:28 +0800
Message-ID: <1239328288.6384.69.camel@yhuang-dev.sh.intel.com>
References: <1239263421.6384.41.camel@yhuang-dev.sh.intel.com>
	 <20090409082152.GA4099@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-AE2TDQ5F4aSmGFi0ab+H"
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:20207 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753562AbZDJBva (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Thu, 9 Apr 2009 21:51:30 -0400
In-Reply-To: <20090409082152.GA4099@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>


--=-AE2TDQ5F4aSmGFi0ab+H
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Thu, 2009-04-09 at 16:21 +0800, Herbert Xu wrote:
> On Thu, Apr 09, 2009 at 03:50:21PM +0800, Huang Ying wrote:
> > Hi, Herbert,
> >=20
> > I am working on GCM acceleration with Intel new PCLMULQDQ instructions
> > now. Can you tell me how to do GCM benchmark?
>=20
> We need to add the infrastructure for testing AEAD speed.  It can
> be modelled after the cipher/hash speed testing code.

One issue here is that blkcipher testing infrastructure uses
local_bh_disable()/local_irq_disable() to get more accurate result. But
AEAD uses asynchronous interface, something like
wait_for_completion_interruptable() will be used in test path. How to
get more accurate result for testing asynchronous interface? Maybe it
can be: test many times, select the one with best performance. What's
your opinion?

> > BTW: Similar with AES-NI support, I use cryptd to defer requests in sof=
t
> > IRQ context. Now, cryptd uses crypto_hash instead of crypto_shash as
> > child. I think we should change that. If you have not done that, I will
> > do that.
>=20
> We need to complete the conversion of all hash algorithms to shash
> first.

Yes.

Best Regards,
Huang Ying


--=-AE2TDQ5F4aSmGFi0ab+H
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEABECAAYFAkneph4ACgkQKhFGF+eHlpjZdQCeN1YQbGWmiwSxOmYjfxIsN4RO
YTkAoJluLPcdm7+8b2kr0x/Hp03oXzwI
=f+Z1
-----END PGP SIGNATURE-----

--=-AE2TDQ5F4aSmGFi0ab+H--


From: Huang Ying <ying.huang@intel.com>
Subject: Re: [RFC PATCH crypto 4/4] AES-NI: Add support to Intel AES-NI
	instructions for x86_64 platform
Date: Fri, 09 Jan 2009 16:54:33 +0800
Message-ID: <1231491273.5937.94.camel@yhuang-dev.sh.intel.com>
References: <1231120947.5937.31.camel@yhuang-dev.sh.intel.com>
	 <20090109070144.GA7358@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-uxBaHU/ZfddHsHge4Oxp"
Cc: Sebastian Siewior <linux-crypto@ml.breakpoint.cc>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mga14.intel.com ([143.182.124.37]:12785 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750815AbZAIIyg (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Fri, 9 Jan 2009 03:54:36 -0500
In-Reply-To: <20090109070144.GA7358@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>


--=-uxBaHU/ZfddHsHge4Oxp
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Fri, 2009-01-09 at 15:01 +0800, Herbert Xu wrote:
> > - ablkcipher asynchronous machanism is used to delay a crypto request
> >   to work queue context upon FPU state is using by other kernel
> >   context.
>=20
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

I have ever considered this method too. This one is simpler, but the
drawbacks are as follow:

- cryptd thread is not per-CPU, so I think there will be some
unnecessary cache inter-CPU migration. Why not use a dedicate workqueue
or just system events workqueue?

- with cryptd(__*-aes-aesni), we need 4 internal tfms for each external
tfm allocation request. For example, for one external cbc(aes) tfm
allocation request, we need one cbc(aes) ablkcipher tfm, one
cryptd(cbc-aes-aesni) tfm, and two cbc-aes-aesni tfm. Do we use too much
memory? And we need to call aesni_set_key() twice.

> This is even simpler for the modes which you don't implement.
> In that case you would just allocate FOO(aes-aesni) in conjunction
> with cryptd(FOO(aes-aesni)).

Yes. This is really a simple method.

Best Regards,
Huang Ying


--=-uxBaHU/ZfddHsHge4Oxp
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEABECAAYFAklnEMYACgkQKhFGF+eHlpiVxACfUxMAPWcVA4Hg7Rhv+mK4abrN
DcMAn1croaIo93RUI//yKGBOIkWpnBg6
=l1VE
-----END PGP SIGNATURE-----

--=-uxBaHU/ZfddHsHge4Oxp--


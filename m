From: Huang Ying <ying.huang@intel.com>
Subject: Re: [PATCH crypto -v4 1/2] AES-NI: Add support to access
	underlying blkcipher under cryptd ablkcipher
Date: Thu, 15 Jan 2009 17:30:51 +0800
Message-ID: <1232011851.5937.208.camel@yhuang-dev.sh.intel.com>
References: <1232008113.5937.199.camel@yhuang-dev.sh.intel.com>
	 <20090115084750.GA32239@gondor.apana.org.au>
	 <1232011307.5937.204.camel@yhuang-dev.sh.intel.com>
	 <20090115092314.GA32559@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-bdjU8KK2Xk0NS5L5KzmE"
Cc: Sebastian Siewior <linux-crypto@ml.breakpoint.cc>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:51480 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752593AbZAOJbK (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Thu, 15 Jan 2009 04:31:10 -0500
In-Reply-To: <20090115092314.GA32559@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>


--=-bdjU8KK2Xk0NS5L5KzmE
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Thu, 2009-01-15 at 17:23 +0800, Herbert Xu wrote:
> On Thu, Jan 15, 2009 at 05:21:47PM +0800, Huang Ying wrote:
> > On Thu, 2009-01-15 at 16:47 +0800, Herbert Xu wrote:
> > > On Thu, Jan 15, 2009 at 04:28:33PM +0800, Huang Ying wrote:
> > > >
> > > > +	tfm =3D crypto_alloc_ablkcipher(cryptd_alg_name, type, mask);
> > > > +	BUG_ON(crypto_ablkcipher_tfm(tfm)->__crt_alg->cra_module !=3D
> > > > +	       THIS_MODULE);
> > >=20
> > > You need to check whether tfm is an error before dereferencing it.
> > > Also it's probably better to free the tfm and return an error rather
> > > than invoking BUG.
> >=20
> > Why do we need this check? Someone else may register cryptd template?
> > Which error number should be return? -EINVAL?
>=20
> -ENOMEM for example.

You mean something as follow:

if (crypto_ablkcipher_tfm(tfm)->__crt_alg->cra_module !=3D THIS_MODULE)
        return ERR_PTR(-ENOMEM);

I think -ENOMEM is not appropriate for this check.

Sorry for ask you same question twice. Why do we need this check? Some
other module may register cryptd template?

Best Regards,
Huang Ying

--=-bdjU8KK2Xk0NS5L5KzmE
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEABECAAYFAklvAkgACgkQKhFGF+eHlpjFzwCgpZz+1f3W8NAr5hQgERfVFZEF
cpYAn1pkME/ny+oNoD19rVpoFxsfLUPQ
=Ekuo
-----END PGP SIGNATURE-----

--=-bdjU8KK2Xk0NS5L5KzmE--


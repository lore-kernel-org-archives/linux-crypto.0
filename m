From: Huang Ying <ying.huang@intel.com>
Subject: Re: [PATCH crypto -v4 1/2] AES-NI: Add support to
	access	underlying blkcipher under cryptd ablkcipher
Date: Thu, 15 Jan 2009 17:21:47 +0800
Message-ID: <1232011307.5937.204.camel@yhuang-dev.sh.intel.com>
References: <1232008113.5937.199.camel@yhuang-dev.sh.intel.com>
	 <20090115084750.GA32239@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-AD0AjA9WQ+R5xnAG6R87"
Cc: Sebastian Siewior <linux-crypto@ml.breakpoint.cc>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1754264AbZAOJWO@vger.kernel.org>
In-Reply-To: <20090115084750.GA32239@gondor.apana.org.au>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org


--=-AD0AjA9WQ+R5xnAG6R87
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Thu, 2009-01-15 at 16:47 +0800, Herbert Xu wrote:
> On Thu, Jan 15, 2009 at 04:28:33PM +0800, Huang Ying wrote:
> >
> > +	tfm =3D crypto_alloc_ablkcipher(cryptd_alg_name, type, mask);
> > +	BUG_ON(crypto_ablkcipher_tfm(tfm)->__crt_alg->cra_module !=3D
> > +	       THIS_MODULE);
>=20
> You need to check whether tfm is an error before dereferencing it.
> Also it's probably better to free the tfm and return an error rather
> than invoking BUG.

Why do we need this check? Someone else may register cryptd template?
Which error number should be return? -EINVAL?

> > --- a/include/crypto/algapi.h
> > +++ b/include/crypto/algapi.h
>=20
> Please create a new file for this, e.g., include/crypto/cryptd.h.

OK. I will do that.

Best Regards,
Huang Ying

--=-AD0AjA9WQ+R5xnAG6R87
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEABECAAYFAklvACkACgkQKhFGF+eHlpittACfR9st94CYff7LlUjcv0eOYcbJ
1lYAn2n7yJGbuzpP2ozmmeKRK0FuglfD
=J46t
-----END PGP SIGNATURE-----

--=-AD0AjA9WQ+R5xnAG6R87--

From: Huang Ying <ying.huang@intel.com>
Subject: Re: [RFC PATCH crypto 4/4] AES-NI: Add support to Intel AES-NI
	instructions for x86_64 platform
Date: Mon, 12 Jan 2009 10:30:23 +0800
Message-ID: <1231727423.5937.101.camel@yhuang-dev.sh.intel.com>
References: <1231120947.5937.31.camel@yhuang-dev.sh.intel.com>
	 <20090109070144.GA7358@gondor.apana.org.au>
	 <1231491273.5937.94.camel@yhuang-dev.sh.intel.com>
	 <20090109091814.GA10881@gondor.apana.org.au>
	 <20090110100823.GA22352@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-QBT1SP4U6wWICTx+2DMP"
Cc: Sebastian Siewior <linux-crypto@ml.breakpoint.cc>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1753572AbZALCaj@vger.kernel.org>
In-Reply-To: <20090110100823.GA22352@gondor.apana.org.au>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org


--=-QBT1SP4U6wWICTx+2DMP
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Sat, 2009-01-10 at 18:08 +0800, Herbert Xu wrote:
> On Fri, Jan 09, 2009 at 08:18:14PM +1100, Herbert Xu wrote:
> >
> > Not at all, tfms are just "shell" objects and they were designed
> > to be used in thie way.  Calling setkey twice is an issue but it's
> > not a show-stopper.  We have the same problem in other places to
> > so this something that we can potentially optimise.
>=20
> Here's how we can solve the double setkey problem.  We can make
> a new cryptd_alloc_ablkcipher interface that returns a cryptd
> ablkcipher object.  Since it's cryptd specific we can then access
> its underlying blkcipher object, which can be shared between the
> cryptd object and the user of the cryptd object.  This way you
> only need to do setkey on the cryptd object and it'll get set
> on the underlying blkcipher automatically.

With this method, we can allocate only one cryptd tfm internally,
without dedicated blkcipher tfm. If kernel is using FPU, crypd tfm is
used, otherwise, the underlying blkcipher tfm is used directly.

Best Regards,
Huang Ying


--=-QBT1SP4U6wWICTx+2DMP
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEABECAAYFAklqqzwACgkQKhFGF+eHlphBXwCePKPOXICxSqUUn3pgJr3KpCaB
/A8AoIgDuVLEvnjwJTk9CMC5D5sd6vxz
=Hlwu
-----END PGP SIGNATURE-----

--=-QBT1SP4U6wWICTx+2DMP--

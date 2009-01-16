From: Huang Ying <ying.huang@intel.com>
Subject: Re: [PATCH crypto -v4 2/2] AES-NI: Add support to Intel AES-NI
	instructions for x86_64 platform
Date: Fri, 16 Jan 2009 11:37:25 +0800
Message-ID: <1232077045.13948.14.camel@yhuang-dev.sh.intel.com>
References: <1232008119.5937.200.camel@yhuang-dev.sh.intel.com>
	 <25e057c00901150147t570d8ab6g3b2b99c60f10c3c2@mail.gmail.com>
	 <1232068858.5937.222.camel@yhuang-dev.sh.intel.com>
	 <20090116015356.GA9822@gondor.apana.org.au>
	 <1232073422.13948.3.camel@yhuang-dev.sh.intel.com>
	 <20090116032639.GA10390@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-crbCDSzUOFnguJgerKeZ"
Cc: roel kluin <roel.kluin@gmail.com>,
	Sebastian Siewior <linux-crypto@ml.breakpoint.cc>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:53234 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754825AbZAPDh2 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Thu, 15 Jan 2009 22:37:28 -0500
In-Reply-To: <20090116032639.GA10390@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>


--=-crbCDSzUOFnguJgerKeZ
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Fri, 2009-01-16 at 11:26 +0800, Herbert Xu wrote:
> On Fri, Jan 16, 2009 at 10:37:02AM +0800, Huang Ying wrote:
> >
> > But after checking blkcipher_walk_done() in 2.6.28, If input argument
> > err !=3D 0 and walk->flags & BLKCIPHER_WALK_SLOW !=3D 0, when
> > blkcipher_walk_done() return non-zero, walk->nbytes !=3D 0. So I think =
it
> > is a little fragile to use walk->nbytes =3D=3D 0 indicate error.
>=20
> Right, that's a bug.  Although this case shouldn't occur unless
> wer have a buggy algorithm (that's why it's a WARN_ON).  But as
> we're handling it anyway, we should ensure that the result is sane.
>=20
> crypt: blkcipher - Fix WARN_ON handling in walk_done
>=20
> When we get left-over bits from a slow walk, it means that the
> underlying cipher has gone troppo.  However, as we're handling
> that case we should ensure that the caller terminates the walk.
>=20
> This patch does this by setting walk->nbytes to zero.
>=20
> Reported-by: Huang Ying <ying.huang@intel.com>

I think Roel Kluin is the real reporter.

Best Regards,
Huang Ying


--=-crbCDSzUOFnguJgerKeZ
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEABECAAYFAklwAPMACgkQKhFGF+eHlpj+ewCffKNEd08LMdEogFv3BzfxrI7E
ohUAoIhVDQ4NfKQX5HH3OfcxVwVlJN+6
=lUNp
-----END PGP SIGNATURE-----

--=-crbCDSzUOFnguJgerKeZ--


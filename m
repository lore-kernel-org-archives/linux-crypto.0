From: Andrey Borzenkov <arvidjaar@mail.ru>
Subject: Re: Clarification of allowed context for crypto routines
Date: Tue, 27 Jan 2009 21:01:13 +0300
Message-ID: <200901272101.20190.arvidjaar@mail.ru>
References: <20090124093245.GA4889@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart1401283.OYWsxPA8Cm";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1756876AbZA0SBj@vger.kernel.org>
In-Reply-To: <20090124093245.GA4889@gondor.apana.org.au>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

--nextPart1401283.OYWsxPA8Cm
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

On 24 =D1=8F=D0=BD=D0=B2=D0=B0=D1=80=D1=8F 2009 12:32:45 Herbert Xu wrote:
> Andrey Borzenkov <arvidjaar@mail.ru> wrote:
> > On 24 =D1=8F=D0=BD=D0=B2=D0=B0=D1=80=D1=8F 2009 01:31:50 Herbert Xu wro=
te:
> >> 2) The highmem primitives we use are currently softirq only.  We
> >> could make them work for hardirq as well, but because of 1) we
> >> didn't.
> >
> > Could you point to example of such primitive in code under crypto?
>
> Grep for kmap under crypto.
>

I checked and

=2D all usage is kmap_atomic; which implies it should be technically safe=20
(not advisable) to use in interrupt context as well

=2D as far as I understand, if it could be kmap() that could sleep, it is=20
unsafe to use in tasklet anyway?

Please bear with me. The problem with kernel is lack of any=20
comprehensive documentation; so almost the only way to learn is by=20
example - get code that is known to work and has at least /some/=20
documentation; and assume that what it does is correct. In this case=20
incomplete or misleading documentation leads to adopting incorrect usage=20
lately ... in this case I do not argue about code under crypto; but=20
rather try to learn how and when I can safely use this code in my=20
driver.

So I still miss difference between interrupt context and bottom half=20
(i.e. tasklet) that is made in documentation. Sorry :)

--nextPart1401283.OYWsxPA8Cm
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEABECAAYFAkl/S+sACgkQR6LMutpd94y7ZgCgoMdFwHvbTF2qeZmXrdpKPzw3
NMgAoK0L5pbqhz4H49LT6WSJbIUBfDEU
=xuCM
-----END PGP SIGNATURE-----

--nextPart1401283.OYWsxPA8Cm--

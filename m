From: Stephan Mueller <smueller@chronox.de>
Subject: Re: [PATCH v2 02/20] crypto: testmgr to use CRYPTO_ALG_INTERNAL
Date: Mon, 30 Mar 2015 21:31:58 +0200
Message-ID: <6768727.OdoHOMWXfn@tachyon.chronox.de>
References: <1746748.uPZFXamDiM@tachyon.chronox.de> <1657882.6iCTT84gKK@tachyon.chronox.de> <20150330131034.GA6251@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.eperm.de ([89.247.134.16]:39574 "EHLO mail.eperm.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751990AbbC3TcB convert rfc822-to-8bit (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 30 Mar 2015 15:32:01 -0400
In-Reply-To: <20150330131034.GA6251@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Am Dienstag, 31. M=E4rz 2015, 00:10:34 schrieb Herbert Xu:

Hi Herbert,

> On Fri, Mar 27, 2015 at 11:50:42PM +0100, Stephan Mueller wrote:
> > If a cipher allocation fails with -ENOENT, the testmgr now retries
> > to allocate the cipher with CRYPTO_ALG_INTERNAL flag.
> >=20
> > As all ciphers, including the internal ciphers will be processed by
> > the testmgr, it needs to be able to allocate those ciphers.
> >=20
> > Signed-off-by: Stephan Mueller <smueller@chronox.de>
> > ---
> >=20
> >  crypto/testmgr.c | 22 ++++++++++++++++++++++
> >  1 file changed, 22 insertions(+)
> >=20
> > diff --git a/crypto/testmgr.c b/crypto/testmgr.c
> > index 1f879ad..609bafa 100644
> > --- a/crypto/testmgr.c
> > +++ b/crypto/testmgr.c
> > @@ -1506,6 +1506,9 @@ static int alg_test_aead(const struct alg_tes=
t_desc
> > *desc, const char *driver,>=20
> >  	int err =3D 0;
> >  =09
> >  	tfm =3D crypto_alloc_aead(driver, type, mask);
> >=20
> > +	if (PTR_ERR(tfm) =3D=3D -ENOENT)
> > +		tfm =3D crypto_alloc_aead(driver, type | CRYPTO_ALG_INTERNAL,
> > +					mask | CRYPTO_ALG_INTERNAL);
>=20
> We need to be able to say give me an algorithm regardless of the
> INTERNAL bit.  How about treating (type & CRYPTO_ALG_INTERNAL) &&
> !(mask & CRYPTO_ALG_INTERNAL) as that special case?
>=20
> So in patch 1 you would do
>=20
> 	if (!((type | mask) & CRYPTO_ALG_INTERNAL))
> 		mask |=3D CRYPTO_ALG_INTERNAL;

Thank you for the hint. It works and I will release a patch shortly.
>=20
> Thanks,


--=20
Ciao
Stephan

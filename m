From: Marcelo Cerri <marcelo.cerri@canonical.com>
Subject: Re: [PATCH 1/2] crypto: vmx - Use skcipher for cbc fallback
Date: Wed, 22 Feb 2017 19:17:00 -0300
Message-ID: <20170222221700.GA19026@gallifrey>
References: <20170222180015.27573-1-pfsmorigo@linux.vnet.ibm.com>
 <20170222191819.GB20626@gallifrey>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="mYCpIKhGyMATD0i+"
Cc: linux-crypto@vger.kernel.org
To: herbert@gondor.apana.org.au
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-qk0-f177.google.com ([209.85.220.177]:36413 "EHLO
        mail-qk0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933406AbdBVWRd (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 22 Feb 2017 17:17:33 -0500
Received: by mail-qk0-f177.google.com with SMTP id x71so16530979qkb.3
        for <linux-crypto@vger.kernel.org>; Wed, 22 Feb 2017 14:17:05 -0800 (PST)
Content-Disposition: inline
In-Reply-To: <20170222191819.GB20626@gallifrey>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>


--mYCpIKhGyMATD0i+
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Hebert,

On Wed, Feb 22, 2017 at 04:18:19PM -0300, Marcelo Cerri wrote:
> Hi Paulo.
>=20
> On Wed, Feb 22, 2017 at 03:00:15PM -0300, Paulo Flabiano Smorigo wrote:
> > =20
> >  	if (in_interrupt()) {
> > -		ret =3D crypto_blkcipher_encrypt(&fallback_desc, dst, src,
> > -					       nbytes);
> > +		SKCIPHER_REQUEST_ON_STACK(req, ctx->fallback);
> > +		skcipher_request_set_tfm(req, ctx->fallback);
> > +		skcipher_request_set_callback(req, desc->flags, NULL, NULL);
> > +		skcipher_request_set_crypt(req, src, dst, nbytes, desc->info);
> > +		ret =3D crypto_skcipher_encrypt(req);
> > +		skcipher_request_zero(req);
>=20
> Probably you have to wait for the completion here before proceeding.
>=20
> Check Documentation/crypto/api-samples.rst
>=20

I noticed you used a similar approach in arch/s390/crypto/aes_s390.c
(commit 64e2680).

How do you ensure the skcipher operation will not be asynchronous?=20

--=20
Regards,
Marcelo


--mYCpIKhGyMATD0i+
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEcBAABCAAGBQJYrg3cAAoJEM8aS8c01e1HJfEIAIi+DzhRhSAmIGTgoSyh7tTS
NYQ7IKBIaHxWAm0XCt2oSNN63UFPuPkNzuouPkNc6BeD9ssixWG9rX/w2xVJZ+R7
fKL618o1bq9ubr4dhw/b1JWIJ0XuAQhTSOEJdtz6uMAaKKpMQg5cfH4kQFWkAD5F
yXAr0wQU60y0OfYbrMavgRIEO+yxVtZAUrPnTER1uz1hWwVrloPsntHIuLRBoHMu
iETHCzj8ZkcrBXaJ6ud5P4G/mLvHVWX3gHvt/zqrCRt0riC7S7B9EA+RG5iNvFJE
lQEb5ZWo7YCVqjqDbY+9vIp7o5Emf+4YcGPmTkOg/LH6co01mFjiA9b3XAMDew8=
=YcEm
-----END PGP SIGNATURE-----

--mYCpIKhGyMATD0i+--

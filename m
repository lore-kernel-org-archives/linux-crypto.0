From: Marcelo Cerri <marcelo.cerri@canonical.com>
Subject: Re: [PATCH 0/3] Fix crypto/vmx/p8_ghash memory corruption
Date: Mon, 3 Oct 2016 12:07:25 -0300
Message-ID: <20161003150725.GF10133@gallifrey>
References: <1475080931-7926-1-git-send-email-marcelo.cerri@canonical.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="m1UC1K4AOz1Ywdkx"
Cc: linux-crypto@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-qt0-f173.google.com ([209.85.216.173]:32774 "EHLO
        mail-qt0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751375AbcJCPHa (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 3 Oct 2016 11:07:30 -0400
Received: by mail-qt0-f173.google.com with SMTP id s49so10857549qta.0
        for <linux-crypto@vger.kernel.org>; Mon, 03 Oct 2016 08:07:30 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <1475080931-7926-1-git-send-email-marcelo.cerri@canonical.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>


--m1UC1K4AOz1Ywdkx
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Herbert,

Sorry for bothering you. I noticed you included two of the patches in
the crypto-2.6 repository and the remaining one in cryptodev-2.6. Is
that right? I thought all 3 patches would be included in the cruptodev
repository.

--=20
Regards,
Marcelo

On Wed, Sep 28, 2016 at 01:42:08PM -0300, Marcelo Cerri wrote:
> This series fixes the memory corruption found by Jan Stancek in 4.8-rc7. =
The
> problem however also affects previous versions of the driver.
>=20
> Marcelo Cerri (3):
>   crypto: ghash-generic - move common definitions to a new header file
>   crypto: vmx - Fix memory corruption caused by p8_ghash
>   crypto: vmx - Ensure ghash-generic is enabled
>=20
>  crypto/ghash-generic.c     | 13 +------------
>  drivers/crypto/vmx/Kconfig |  2 +-
>  drivers/crypto/vmx/ghash.c | 31 ++++++++++++++++---------------
>  include/crypto/ghash.h     | 23 +++++++++++++++++++++++
>  4 files changed, 41 insertions(+), 28 deletions(-)
>  create mode 100644 include/crypto/ghash.h
>=20
> --=20
> 2.7.4
>=20

--m1UC1K4AOz1Ywdkx
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEcBAABCAAGBQJX8nQsAAoJEM8aS8c01e1HS5YH/RT5AnoBhLSv0G4UHbzUfkJg
Zw4ZJswkhed8o5YmgRP6N0lCjhIwHi0+kPqGIQ3FvziinZVU/yXdYAGRj7bEbMJ5
I/DfOwfGwvdZltbuY503tfkB0ceSuRULOzJeNLVcD+p/PKrK7IJCNXklvlRm2XAW
7wa2tazCIstfUi6CuK7PRv1McCT9b2vs/JBxUIe+3kR262/NO/QVO/vrwALW2Qev
pyGI5pP26kO4LRnI8B5O1dI+11DCcWkTGWeQ6aapRKjIy5TeXWzRX/pptMYjgq8U
Z8sK/qXdmttJKZ1TAIAKBd8B3QXw9ia7j+219qB3LCq3rCmrJ5QdpCeCJqDxso4=
=m5hP
-----END PGP SIGNATURE-----

--m1UC1K4AOz1Ywdkx--

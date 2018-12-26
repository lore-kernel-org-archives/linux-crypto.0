Return-Path: <SRS0=VXLt=PD=vger.kernel.org=linux-crypto-owner@kernel.org>
Received: from bues.ch ([80.190.117.144]:35224 "EHLO bues.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727586AbeLZWVy (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 26 Dec 2018 17:21:54 -0500
Date: Wed, 26 Dec 2018 23:03:01 +0100
From: Michael =?UTF-8?B?QsO8c2No?= <m@bues.ch>
To: Aditya Pakki <pakki001@umn.edu>
Cc: kjlu@umn.edu, Matt Mackall <mpm@selenic.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] char: hw_random: Fix missing check during driver
 release
Message-ID: <20181226230301.7eb74756@wiggum>
In-Reply-To: <20181226172332.6365-1-pakki001@umn.edu>
References: <20181226172332.6365-1-pakki001@umn.edu>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
 boundary="Sig_/925EluWbr=Z2EgNFUYy7.LM"; protocol="application/pgp-signature"
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

--Sig_/925EluWbr=Z2EgNFUYy7.LM
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Wed, 26 Dec 2018 11:23:31 -0600
Aditya Pakki <pakki001@umn.edu> wrote:

> devres_release can return -ENOENT if the device is not freed. The fix
> throws a warning consistent with other invocations.
>=20
> Signed-off-by: Aditya Pakki <pakki001@umn.edu>
> ---
>  drivers/char/hw_random/core.c | 6 +++++-
>  1 file changed, 5 insertions(+), 1 deletion(-)
>=20
> diff --git a/drivers/char/hw_random/core.c b/drivers/char/hw_random/core.c
> index 95be7228f327..582d983fa93f 100644
> --- a/drivers/char/hw_random/core.c
> +++ b/drivers/char/hw_random/core.c
> @@ -578,7 +578,11 @@ EXPORT_SYMBOL_GPL(devm_hwrng_register);
> =20
>  void devm_hwrng_unregister(struct device *dev, struct hwrng *rng)
>  {
> -	devres_release(dev, devm_hwrng_release, devm_hwrng_match, rng);
> +	int rc;
> +
> +	rc =3D devres_release(dev, devm_hwrng_release, devm_hwrng_match, rng);
> +	if (rc)

The if statement is redundant and can be removed.

> +		WARN_ON(rc);
>  }
>  EXPORT_SYMBOL_GPL(devm_hwrng_unregister);
> =20

--=20
Michael

--Sig_/925EluWbr=Z2EgNFUYy7.LM
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCgAdFiEEihRzkKVZOnT2ipsS9TK+HZCNiw4FAlwj+pUACgkQ9TK+HZCN
iw5p7xAAt3Mf7jNemb4oYCbLxy6LGgqBVFTVRgjBCj55eM28zqJZt2mZ1MPZv3zf
/bqQiTQzJmfHiqzrT35Np7UKJcJD+bQeW0za/BCAIapzjrELSm7zcY+6YpviRqNS
98EBTVMpkDgATApEqw31hvJAy+d+uuR7D2HKXP5Tr0nDSKMgBWD+M59+0cNXuSbU
gb4EVFCozTC2L5Ko6oTbiTSX2k/O55jP3iGjEefAwGnBjqJ1gEsZdSQhlG+ucItL
/e0PNY2fROahVg7s5VnuywPdMkZDNBKul6JzVBtqi8z4a4pKYL8YAKIaQtOqHW99
/9dPlhyAHtZWvq/OxYaS4Q/Dd9k7RrwLaM0U2hEE9AKysJ5MdvNmCk5hwuhnjRc7
POhWZLmW8ZelEFZkc4sc3DeeP3+mZrFdkITWlBBEgcnQLgxWtD8ZHI1ot4MGqGND
Q5Hx53oANeUjnsLJuAN85NoI0/Y6C02VuWMWcPpErYkJIs10WaTF/eTsGbeXf6iQ
d7cimIoauhOZBg0fSflZYpVavQiqo+hYw7SqYbvD+IVS6pPazg0LFRP2Oz8ie6pv
N5abc1zFtP0q2RuUSEA1pofapCwSvC3FhwNktuo4fRjlI0wLfcnr0Zi5VwbRXTh4
dyiWkpt444Nk3nx/up562wSMiz/LAHNmmVXeNHzfTEupRRY7krI=
=zRzm
-----END PGP SIGNATURE-----

--Sig_/925EluWbr=Z2EgNFUYy7.LM--

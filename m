From: Pierre <pinaraf@pinaraf.info>
Subject: PATCH : Fix NULL pointer dereference on no default_rng
Date: Sun, 12 Nov 2017 14:30:29 +0100
Message-ID: <2266358.Kig6R46j1N@peanuts2>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="nextPart3894775.KXgezVveBg"; micalg="pgp-sha512"; protocol="application/pgp-signature"
Cc: davem@davemloft.net, herbert@gondor.apana.org.au
To: linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mout.kundenserver.de ([212.227.126.187]:51073 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750779AbdKLNay (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sun, 12 Nov 2017 08:30:54 -0500
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

--nextPart3894775.KXgezVveBg
Content-Type: multipart/mixed; boundary="nextPart2373012.qHJWCflb60"
Content-Transfer-Encoding: quoted-printable

This is a multi-part message in MIME format.

--nextPart2373012.qHJWCflb60
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"

Hi

The attached patch fixes a kernel panic on boot on my current system that 
occurs since kernel 4.13 (and is still happening with 4.14-rc7).
crypto_get_default_rng() likely returns an error, and ecc_gen_privkey ignore 
that error. Thus when it later uses the default_rng, a null pointer 
dereference occurs.
This patch just sends an error as was likely intended in the original code.

Thanks

 Pierre Ducroquet

--nextPart2373012.qHJWCflb60
Content-Disposition: attachment; filename="0001-Fix-NULL-pointer-deref.-on-no-default_rng.patch"
Content-Transfer-Encoding: 7Bit
Content-Type: text/x-patch; charset="UTF-8"; name="0001-Fix-NULL-pointer-deref.-on-no-default_rng.patch"

From=2040d1addfa5cfeb0b93cec333f35e39900216ddb6 Mon Sep 17 00:00:00 2001
From: Pierre Ducroquet <pinaraf@pinaraf.info>
Date: Sun, 12 Nov 2017 14:18:47 +0100
Subject: [PATCH] Fix NULL pointer deref. on no default_rng

If crypto_get_default_rng returns an error, the
function ecc_gen_privkey should return an error.
Instead, it currently tries to use the default_rng
nevertheless, thus creating a kernel panic with a
NULL pointer dereference.
Returning the error directly, as was supposedly
intended when looking at the code, fixes this.

Signed-off-by: Pierre Ducroquet <pinaraf@pinaraf.info>
---
 crypto/ecc.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/crypto/ecc.c b/crypto/ecc.c
index 633a9bcdc574..18f32f2a5e1c 100644
--- a/crypto/ecc.c
+++ b/crypto/ecc.c
@@ -964,7 +964,7 @@ int ecc_gen_privkey(unsigned int curve_id, unsigned int ndigits, u64 *privkey)
 	 * DRBG with a security strength of 256.
 	 */
 	if (crypto_get_default_rng())
-		err = -EFAULT;
+		return -EFAULT;
 
 	err = crypto_rng_get_bytes(crypto_default_rng, (u8 *)priv, nbytes);
 	crypto_put_default_rng();
-- 
2.15.0


--nextPart2373012.qHJWCflb60--
This is a multi-part message in MIME format.

--nextPart2373012.qHJWCflb60
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"

Hi

The attached patch fixes a kernel panic on boot on my current system that 
occurs since kernel 4.13 (and is still happening with 4.14-rc7).
crypto_get_default_rng() likely returns an error, and ecc_gen_privkey ignore 
that error. Thus when it later uses the default_rng, a null pointer 
dereference occurs.
This patch just sends an error as was likely intended in the original code.

Thanks

 Pierre Ducroquet

--nextPart2373012.qHJWCflb60
Content-Disposition: attachment; filename="0001-Fix-NULL-pointer-deref.-on-no-default_rng.patch"
Content-Transfer-Encoding: 7Bit
Content-Type: text/x-patch; charset="UTF-8"; name="0001-Fix-NULL-pointer-deref.-on-no-default_rng.patch"

>From 40d1addfa5cfeb0b93cec333f35e39900216ddb6 Mon Sep 17 00:00:00 2001
From: Pierre Ducroquet <pinaraf@pinaraf.info>
Date: Sun, 12 Nov 2017 14:18:47 +0100
Subject: [PATCH] Fix NULL pointer deref. on no default_rng

If crypto_get_default_rng returns an error, the
function ecc_gen_privkey should return an error.
Instead, it currently tries to use the default_rng
nevertheless, thus creating a kernel panic with a
NULL pointer dereference.
Returning the error directly, as was supposedly
intended when looking at the code, fixes this.

Signed-off-by: Pierre Ducroquet <pinaraf@pinaraf.info>
---
 crypto/ecc.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/crypto/ecc.c b/crypto/ecc.c
index 633a9bcdc574..18f32f2a5e1c 100644
--- a/crypto/ecc.c
+++ b/crypto/ecc.c
@@ -964,7 +964,7 @@ int ecc_gen_privkey(unsigned int curve_id, unsigned int ndigits, u64 *privkey)
 	 * DRBG with a security strength of 256.
 	 */
 	if (crypto_get_default_rng())
-		err = -EFAULT;
+		return -EFAULT;
 
 	err = crypto_rng_get_bytes(crypto_default_rng, (u8 *)priv, nbytes);
 	crypto_put_default_rng();
-- 
2.15.0


--nextPart2373012.qHJWCflb60--

--nextPart3894775.KXgezVveBg
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part.
Content-Transfer-Encoding: 7Bit

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEEds3aTMo5n1dvXH/GYkPWy+GpSGUFAloITPUACgkQYkPWy+Gp
SGXeWw/9HlSKrhcd7hU4ztoWAgj2Wl3N1o0AYob0WP7ofUuyyS/xb+ISGkZ8mxLK
4EeSJBH7eNYddnrj3nYW+AIj5diDpuMVA1bkL1OMv3ho7doZqNgSOIWPva2Eb+PJ
TFxnwn/UjoRh8biRs460514pXwZt+gdEJnq+CFgAbzEQCEcJlFfkxzBc0YSAcuGm
Ew3alRP19WIT39xJ6M86UibjUOP/ST8FH5dn0xgd9px8iW/poGWFyIcrigvxCrUg
NxCsuxkEjn42YktPd7VIboh6mRiWHi1pZwc8cHjZcIefkbpWOaEUkJKC1z59FufL
dGKy/hbXccJBadlLWWmLrkuEFYLDnI2aLVezCk8UMG74YtYVtRIGRxRRTdDGTykY
awEmDZqBnhNDz+IJwEI6GHjDcYr+Eb0PvTTgpsJUvql3JZdIRNoxWjq1lP+sqFHJ
aPR9FteDfu5mkLQvPMWqBWkq6Ir7rKMAnUm3bOwiPdctYCGT8glItm4bHG0ESJFP
eqK6G+ufTOGJ6leJXvN7e/o9amrbezxmFBMsf00IN27b6jhNiq8Lmbs09BNGP8Ta
GcT+MwxNYnWIBrBjfpIIOpwefQbFVQXr0tKoHV1vc7S4L15h8pNxLJkKSahAMlyR
SAAi4/KnwIqgIoLy8Pvf0ihKXN70MMajFMG/YpDn4NLNEdbPxrw=
=pRwa
-----END PGP SIGNATURE-----

--nextPart3894775.KXgezVveBg--

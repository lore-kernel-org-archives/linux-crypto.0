From: mancha <mancha1@zoho.com>
Subject: [BUG/PATCH] kernel RNG and its secrets
Date: Wed, 18 Mar 2015 09:53:45 +0000
Message-ID: <20150318095345.GA12923@zoho.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="lrZ03NoBR/3+SXJZ"
Cc: linux-crypto@vger.kernel.org, herbert@gondor.apana.org.au,
	dborkman@redhat.com
To: tytso@mit.edu, linux-kernel@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from sender1.zohomail.com ([74.201.84.157]:38693 "EHLO
	sender1.zohomail.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754850AbbCRKMl (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 18 Mar 2015 06:12:41 -0400
Content-Disposition: inline
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>


--lrZ03NoBR/3+SXJZ
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi.

The kernel RNG introduced memzero_explicit in d4c5efdb9777 to protect
memory cleansing against things like dead store optimization:

   void memzero_explicit(void *s, size_t count)
   {
           memset(s, 0, count);
           OPTIMIZER_HIDE_VAR(s);
   }

OPTIMIZER_HIDE_VAR, introduced in fe8c8a126806 to protect crypto_memneq
against timing analysis, is defined when using gcc as:

   #define OPTIMIZER_HIDE_VAR(var) __asm__ ("" : "=3Dr" (var) : "0" (var))

My tests with gcc 4.8.2 on x86 find it insufficient to prevent gcc from
optimizing out memset (i.e. secrets remain in memory).

Two things that do work:

   __asm__ __volatile__ ("" : "=3Dr" (var) : "0" (var))

   and

   __asm__ __volatile__("": : :"memory")

The first is OPTIMIZER_HIDE_VAR plus a volatile qualifier and the second
is barrier() [as defined when using gcc].

I propose memzero_explicit use barrier().

--- a/lib/string.c
+++ b/lib/string.c
@@ -616,7 +616,7 @@ EXPORT_SYMBOL(memset);
 void memzero_explicit(void *s, size_t count)
 {
        memset(s, 0, count);
-       OPTIMIZER_HIDE_VAR(s);
+       barrier();
 }
 EXPORT_SYMBOL(memzero_explicit);
=20
For any attribution deemed necessary, please use "mancha security".
Please CC me on replies.

--mancha

PS CC'ing Herbert Xu in case this impacts crypto_memneq.

--lrZ03NoBR/3+SXJZ
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBCgAGBQJVCUsoAAoJEB4VYy8JqhaDAsQP/0jhWuUk4FpYLjukvqOYKZip
Wa7rjVCVgR1/E017MqAo/fILSnw4VJTN+nYXYuuEiWAf9u46DEul66ZRU3unORjd
RZRaF73aV9y1cbLGuZAEmHXS/TGrVRiOSV5z4wxYywkSO2zjMGhB+fO+Nog7GeX3
AB5Tw4akFmuf4JCPsW7FbAweDGC9OGXscGvF2iSu8YjBZZTBP0PvWTHcx7Hb1jT5
tY3kCG7wLOkmtQRuWxcxcDa2aQ+Br05i1FF/SEis4xUoOsmu7XJnz6vUZTOhiObf
npZ0MBUOChovhJg9zsI3zqYMnM7pQZTQ0sXrV+OsLzaCPm0swrZyK6U+JzbEjLAh
n99WnEhdiBv9uEmAKRlw75MldI9maEevwu2ucWfBQdl8BHtMqHKxfZjVYRJvhzIK
5Q956OqxrG6qt6U21gSwiHkrkQr9H90z2RNJkS7w0F/o/KtCwbMPqbXTncCm14Rh
4sV4elcCU77Azc9/qwMzhNAWqMVXjUGIzRmAi+uK8dYiV3+DNAfCE73ojc2oyOEx
b2j5FN3OpMftCGhhEC8lBwmMqS0olYDdoUm/meTMU2Jr5q05T9KFMIXk2NHJWuaY
i9btBLwt1+eHAVwpo56rHqYG4Y6p586SHvNlaqS1lYO4YEBMqIw3eXFf0AC30JXP
2rCkgLkQITl2GJ80nXBw
=LU8A
-----END PGP SIGNATURE-----

--lrZ03NoBR/3+SXJZ--

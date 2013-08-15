From: Jan-Simon =?ISO-8859-1?Q?M=F6ller?= <dl9pf@gmx.de>
Subject: [RFC] [PATCH]  Fix for a warning - crypto/fcrypt,c
Date: Thu, 15 Aug 2013 14:01:50 +0200
Message-ID: <4092573.JCpLRYcAKP@aragorn.auenland.lan>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="nextPart35304420.Oyc0LRdjpQ"
Content-Transfer-Encoding: 7Bit
To: dl9pf@gmx.de, Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	linux-crypto@vger.kernel.org, behanw@converseincode.com,
	pageexec@freemail.hu
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.18]:51066 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751952Ab3HOMCu (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Thu, 15 Aug 2013 08:02:50 -0400
Received: from aragorn.auenland.lan ([95.90.187.207]) by mail.gmx.com
 (mrgmx002) with ESMTPSA (Nemesis) id 0M3RZI-1W0Wsp3wKO-00r3ud for
 <linux-crypto@vger.kernel.org>; Thu, 15 Aug 2013 14:02:48 +0200
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

This is a multi-part message in MIME format.

--nextPart35304420.Oyc0LRdjpQ
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="iso-8859-1"

Hi all,

please merge the attached patch.=20

Fix for warning:
linux/crypto/fcrypt.c:143:47: warning: signed shift result (0x598000000=
)=20
requires 36 bits to
      represent, but 'int' only has 32 bits [-Wshift-overflow]
        Z(0xef), Z(0x70), Z(0xcf), Z(0xc2), Z(0x2a), Z(0xb3), Z(0x61),=20=

Z(0xad),
                                                     ^~~~~~~
linux/crypto/fcrypt.c:113:29: note: expanded from macro 'Z'
#define Z(x) cpu_to_be32((x << 27 ) | (x >> 5))
                            ^  ~~
linux/include/uapi/linux/byteorder/little_endian.h:38:53: note: expande=
d from=20
macro
      '__cpu_to_be32'
#define __cpu_to_be32(x) ((__force __be32)__swab32((x)))
                                                    ^
linux/include/uapi/linux/swab.h:116:21: note: expanded from macro '__sw=
ab32'
        ___constant_swab32(x) :                 \
                           ^
linux/include/uapi/linux/swab.h:18:12: note: expanded from macro=20
'___constant_swab32'
        (((__u32)(x) & (__u32)0x0000ff00UL) <<  8) |            \
                  ^

Solution - make sure we don't exceed the 32 bit range by adding (x & ~(=
1U <<=20
27)) =20
=3D  & (0xF7FFFFFF)_16 or & (1111 0111 1111 1111 1111 1111 1111 1111)_2=



Author:  PaX Team <pageexec at freemail.hu>                            =
                                                                       =
                             =20
ML-Post: http://lists.cs.uiuc.edu/pipermail/llvm-commits/Week-of-Mon-20=
120507/142707.html
URL:     http://llvm.linuxfoundation.org

Merge:   Jan-Simon M=F6ller <dl9pf at gmx.de>



Best,
--=20

Dipl.-Ing.
Jan-Simon M=F6ller

jansimon.moeller@gmx.de
--nextPart35304420.Oyc0LRdjpQ
Content-Disposition: attachment; filename="0044-Fix-bitoperation-for-compilation-with-clang.patch"
Content-Transfer-Encoding: quoted-printable
Content-Type: text/x-patch; charset="UTF-8"; name="0044-Fix-bitoperation-for-compilation-with-clang.patch"

>From 7b1f235999aa1f1c45602826696e613b1eab315b Mon Sep 17 00:00:00 2001
From: =3D?UTF-8?q?Jan-Simon=3D20M=3DC3=3DB6ller?=3D <dl9pf@gmx.de>
Date: Wed, 14 Nov 2012 13:09:07 +0100
Subject: [PATCH 44/51] Fix bitoperation for compilation with clang
MIME-Version: 1.0
Content-Type: text/plain; charset=3DUTF-8
Content-Transfer-Encoding: 8bit

Author:  PaX Team <pageexec at freemail.hu>
ML-Post: http://lists.cs.uiuc.edu/pipermail/llvm-commits/Week-of-Mon-20=
120507/142707.html
URL:     http://llvm.linuxfoundation.org

Merge:   Jan-Simon M=C3=B6ller <dl9pf at gmx.de>

Description:

Fix for warning:
linux/crypto/fcrypt.c:143:47: warning: signed shift result (0x598000000=
) requires 36 bits to
      represent, but 'int' only has 32 bits [-Wshift-overflow]
        Z(0xef), Z(0x70), Z(0xcf), Z(0xc2), Z(0x2a), Z(0xb3), Z(0x61), =
Z(0xad),
                                                     ^~~~~~~
linux/crypto/fcrypt.c:113:29: note: expanded from macro 'Z'
#define Z(x) cpu_to_be32((x << 27 ) | (x >> 5))
                            ^  ~~
linux/include/uapi/linux/byteorder/little_endian.h:38:53: note: expande=
d from macro
      '__cpu_to_be32'
#define __cpu_to_be32(x) ((__force __be32)__swab32((x)))
                                                    ^
linux/include/uapi/linux/swab.h:116:21: note: expanded from macro '__sw=
ab32'
        ___constant_swab32(x) :                 \
                           ^
linux/include/uapi/linux/swab.h:18:12: note: expanded from macro '___co=
nstant_swab32'
        (((__u32)(x) & (__u32)0x0000ff00UL) <<  8) |            \
                  ^

Solution - make sure we don't exceed the 32 bit range by adding (x & ~(=
1U << 27)) =20
=3D  & (0xF7FFFFFF)_16 or & (1111 0111 1111 1111 1111 1111 1111 1111)_2=


Signed-off-by: Jan-Simon M=C3=B6ller <dl9pf@gmx.de>
---
 crypto/fcrypt.c |    2 +-
 1 Datei ge=C3=A4ndert, 1 Zeile hinzugef=C3=BCgt(+), 1 Zeile entfernt(-=
)

diff --git a/crypto/fcrypt.c b/crypto/fcrypt.c
index 3b2cf56..8ad29b7 100644
--- a/crypto/fcrypt.c
+++ b/crypto/fcrypt.c
@@ -110,7 +110,7 @@ static const __be32 sbox0[256] =3D {
 };
=20
 #undef Z
-#define Z(x) cpu_to_be32((x << 27) | (x >> 5))
+#define Z(x) cpu_to_be32(((x & ~(1U << 27)) << 27) | (x >> 5))
 static const __be32 sbox1[256] =3D {
 =09Z(0x77), Z(0x14), Z(0xa6), Z(0xfe), Z(0xb2), Z(0x5e), Z(0x8c), Z(0x=
3e),
 =09Z(0x67), Z(0x6c), Z(0xa1), Z(0x0d), Z(0xc2), Z(0xa2), Z(0xc1), Z(0x=
85),
--=20
1.7.10.4


--nextPart35304420.Oyc0LRdjpQ--

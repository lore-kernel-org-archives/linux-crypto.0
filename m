From: Guenter Roeck <linux@roeck-us.net>
Subject: [PATCH] keys: Use non-conflicting variable name
Date: Wed, 24 Jun 2015 15:27:01 -0700
Message-ID: <1435184821-7688-1-git-send-email-linux@roeck-us.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: "David S. Miller" <davem@davemloft.net>,
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
	Guenter Roeck <linux@roeck-us.net>,
	"Suthikulpanit, Suravee" <Suravee.Suthikulpanit@amd.com>
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from bh-25.webhostbox.net ([208.91.199.152]:40721 "EHLO
	bh-25.webhostbox.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750903AbbFXW1M (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 24 Jun 2015 18:27:12 -0400
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

arm64:allmodconfig fails to build as follows.

In file included from include/acpi/platform/aclinux.h:74:0,
                 from include/acpi/platform/acenv.h:173,
                 from include/acpi/acpi.h:56,
                 from include/linux/acpi.h:37,
                 from ./arch/arm64/include/asm/dma-mapping.h:21,
                 from include/linux/dma-mapping.h:86,
                 from include/linux/skbuff.h:34,
                 from include/crypto/algapi.h:18,
                 from crypto/asymmetric_keys/rsa.c:16:
include/linux/ctype.h:15:12: error: expected =E2=80=98;=E2=80=99, =E2=80=
=98,=E2=80=99 or =E2=80=98)=E2=80=99
		before numeric constant
 #define _X 0x40 /* hex digit */
            ^
crypto/asymmetric_keys/rsa.c:123:47: note: in expansion of macro =E2=80=
=98_X=E2=80=99
 static int RSA_I2OSP(MPI x, size_t xLen, u8 **_X)
                                               ^
crypto/asymmetric_keys/rsa.c: In function =E2=80=98RSA_verify_signature=
=E2=80=99:
crypto/asymmetric_keys/rsa.c:256:2: error:
		implicit declaration of function =E2=80=98RSA_I2OSP=E2=80=99

The problem is caused by an unrelated include file change, resulting in
the inclusion of ctype.h on arm64. This in turn causes the local variab=
le
_X to conflict with macro _X used in ctype.h.

=46ixes: b6197b93fa4b ("arm64 : Introduce support for ACPI _CCA object"=
)
Cc: Suthikulpanit, Suravee <Suravee.Suthikulpanit@amd.com>
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
---
 crypto/asymmetric_keys/rsa.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/crypto/asymmetric_keys/rsa.c b/crypto/asymmetric_keys/rsa.=
c
index 459cf97a75e2..508b57b77474 100644
--- a/crypto/asymmetric_keys/rsa.c
+++ b/crypto/asymmetric_keys/rsa.c
@@ -120,7 +120,7 @@ static int RSAVP1(const struct public_key *key, MPI=
 s, MPI *_m)
 /*
  * Integer to Octet String conversion [RFC3447 sec 4.1]
  */
-static int RSA_I2OSP(MPI x, size_t xLen, u8 **_X)
+static int RSA_I2OSP(MPI x, size_t xLen, u8 **pX)
 {
 	unsigned X_size, x_size;
 	int X_sign;
@@ -147,7 +147,7 @@ static int RSA_I2OSP(MPI x, size_t xLen, u8 **_X)
 		return -EBADMSG;
 	}
=20
-	*_X =3D X;
+	*pX =3D X;
 	return 0;
 }
=20
--=20
2.1.0

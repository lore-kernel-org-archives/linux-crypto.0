From: Will Deacon <will.deacon@arm.com>
Subject: arm64 allmodconfig failure in =?utf-8?Q?ex?=
 =?utf-8?B?cGFuc2lvbiBvZiBtYWNybyDigJhfWOKAmQ==?=
Date: Fri, 26 Jun 2015 11:08:05 +0100
Message-ID: <20150626100805.GC1568@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org
To: herbert@gondor.apana.org.au
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from foss.arm.com ([217.140.101.70]:59617 "EHLO foss.arm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751617AbbFZKIJ (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Fri, 26 Jun 2015 06:08:09 -0400
Content-Disposition: inline
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi all,

arm64 allmodconfig fails to build with mainline due to the following:


  In file included from include/acpi/platform/aclinux.h:74:0,
                   from include/acpi/platform/acenv.h:173,
                   from include/acpi/acpi.h:56,
                   from include/linux/acpi.h:37,
                   from ./arch/arm64/include/asm/dma-mapping.h:21,
                   from include/linux/dma-mapping.h:86,
                   from include/linux/skbuff.h:34,
                   from include/crypto/algapi.h:18,
                   from crypto/asymmetric_keys/rsa.c:16:
  include/linux/ctype.h:15:12: error: expected =E2=80=98;=E2=80=99, =E2=
=80=98,=E2=80=99 or =E2=80=98)=E2=80=99 before numeric constant
   #define _X 0x40 /* hex digit */
              ^
  crypto/asymmetric_keys/rsa.c:123:47: note: in expansion of macro =E2=80=
=98_X=E2=80=99
   static int RSA_I2OSP(MPI x, size_t xLen, u8 **_X)
                                                 ^
  crypto/asymmetric_keys/rsa.c: In function =E2=80=98RSA_verify_signatu=
re=E2=80=99:
  crypto/asymmetric_keys/rsa.c:256:2: error: implicit declaration of fu=
nction =E2=80=98RSA_I2OSP=E2=80=99 [-Werror=3Dimplicit-function-declara=
tion]
    ret =3D RSA_I2OSP(m, k, &EM);


This is thanks to the following function type:

  static int RSA_I2OSP(MPI x, size_t xLen, u8 **__X)

conflicting with the _X #define in linux/ctype.h:

  #define _X      0x40    /* hex digit */

Simple patch below, but solving this problem with more underscores feel=
s
slightly inhumane.

Will

--->8

diff --git a/crypto/asymmetric_keys/rsa.c b/crypto/asymmetric_keys/rsa.=
c
index 459cf97a75e2..a4e53239448b 100644
--- a/crypto/asymmetric_keys/rsa.c
+++ b/crypto/asymmetric_keys/rsa.c
@@ -120,7 +120,7 @@ static int RSAVP1(const struct public_key *key, MPI=
 s, MPI *_m)
 /*
  * Integer to Octet String conversion [RFC3447 sec 4.1]
  */
-static int RSA_I2OSP(MPI x, size_t xLen, u8 **_X)
+static int RSA_I2OSP(MPI x, size_t xLen, u8 **__X)
 {
 	unsigned X_size, x_size;
 	int X_sign;
@@ -147,7 +147,7 @@ static int RSA_I2OSP(MPI x, size_t xLen, u8 **_X)
 		return -EBADMSG;
 	}
=20
-	*_X =3D X;
+	*__X =3D X;
 	return 0;
 }
=20

From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: arm64 allmodconfig failure =?utf-8?Q?i?=
 =?utf-8?B?biBleHBhbnNpb24gb2YgbWFjcm8g4oCYX1jigJk=?=
Date: Fri, 26 Jun 2015 19:09:44 +0900
Message-ID: <20150626100944.GA19292@gondor.apana.org.au>
References: <20150626100805.GC1568@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org
To: Will Deacon <will.deacon@arm.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:42332 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751979AbbFZKJt (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Fri, 26 Jun 2015 06:09:49 -0400
Content-Disposition: inline
In-Reply-To: <20150626100805.GC1568@arm.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Fri, Jun 26, 2015 at 11:08:05AM +0100, Will Deacon wrote:
> Hi all,
>=20
> arm64 allmodconfig fails to build with mainline due to the following:
>=20
>=20
>   In file included from include/acpi/platform/aclinux.h:74:0,
>                    from include/acpi/platform/acenv.h:173,
>                    from include/acpi/acpi.h:56,
>                    from include/linux/acpi.h:37,
>                    from ./arch/arm64/include/asm/dma-mapping.h:21,
>                    from include/linux/dma-mapping.h:86,
>                    from include/linux/skbuff.h:34,
>                    from include/crypto/algapi.h:18,
>                    from crypto/asymmetric_keys/rsa.c:16:
>   include/linux/ctype.h:15:12: error: expected =E2=80=98;=E2=80=99, =E2=
=80=98,=E2=80=99 or =E2=80=98)=E2=80=99 before numeric constant
>    #define _X 0x40 /* hex digit */
>               ^
>   crypto/asymmetric_keys/rsa.c:123:47: note: in expansion of macro =E2=
=80=98_X=E2=80=99
>    static int RSA_I2OSP(MPI x, size_t xLen, u8 **_X)
>                                                  ^
>   crypto/asymmetric_keys/rsa.c: In function =E2=80=98RSA_verify_signa=
ture=E2=80=99:
>   crypto/asymmetric_keys/rsa.c:256:2: error: implicit declaration of =
function =E2=80=98RSA_I2OSP=E2=80=99 [-Werror=3Dimplicit-function-decla=
ration]
>     ret =3D RSA_I2OSP(m, k, &EM);
>=20
>=20
> This is thanks to the following function type:
>=20
>   static int RSA_I2OSP(MPI x, size_t xLen, u8 **__X)
>=20
> conflicting with the _X #define in linux/ctype.h:
>=20
>   #define _X      0x40    /* hex digit */
>=20
> Simple patch below, but solving this problem with more underscores fe=
els
> slightly inhumane.

Thanks but I've already merged a similar patch yesterday.
--=20
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt

From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] keys: Use non-conflicting variable name
Date: Thu, 25 Jun 2015 23:36:32 +0800
Message-ID: <20150625153632.GB11592@gondor.apana.org.au>
References: <1435184821-7688-1-git-send-email-linux@roeck-us.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: "David S. Miller" <davem@davemloft.net>,
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
	"Suthikulpanit, Suravee" <Suravee.Suthikulpanit@amd.com>
To: Guenter Roeck <linux@roeck-us.net>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:43752 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751685AbbFYPgj (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 25 Jun 2015 11:36:39 -0400
Content-Disposition: inline
In-Reply-To: <1435184821-7688-1-git-send-email-linux@roeck-us.net>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Wed, Jun 24, 2015 at 03:27:01PM -0700, Guenter Roeck wrote:
> arm64:allmodconfig fails to build as follows.
>=20
> In file included from include/acpi/platform/aclinux.h:74:0,
>                  from include/acpi/platform/acenv.h:173,
>                  from include/acpi/acpi.h:56,
>                  from include/linux/acpi.h:37,
>                  from ./arch/arm64/include/asm/dma-mapping.h:21,
>                  from include/linux/dma-mapping.h:86,
>                  from include/linux/skbuff.h:34,
>                  from include/crypto/algapi.h:18,
>                  from crypto/asymmetric_keys/rsa.c:16:
> include/linux/ctype.h:15:12: error: expected =E2=80=98;=E2=80=99, =E2=
=80=98,=E2=80=99 or =E2=80=98)=E2=80=99
> 		before numeric constant
>  #define _X 0x40 /* hex digit */
>             ^
> crypto/asymmetric_keys/rsa.c:123:47: note: in expansion of macro =E2=80=
=98_X=E2=80=99
>  static int RSA_I2OSP(MPI x, size_t xLen, u8 **_X)
>                                                ^
> crypto/asymmetric_keys/rsa.c: In function =E2=80=98RSA_verify_signatu=
re=E2=80=99:
> crypto/asymmetric_keys/rsa.c:256:2: error:
> 		implicit declaration of function =E2=80=98RSA_I2OSP=E2=80=99
>=20
> The problem is caused by an unrelated include file change, resulting =
in
> the inclusion of ctype.h on arm64. This in turn causes the local vari=
able
> _X to conflict with macro _X used in ctype.h.
>=20
> Fixes: b6197b93fa4b ("arm64 : Introduce support for ACPI _CCA object"=
)
> Cc: Suthikulpanit, Suravee <Suravee.Suthikulpanit@amd.com>
> Signed-off-by: Guenter Roeck <linux@roeck-us.net>

Applied.
--=20
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt

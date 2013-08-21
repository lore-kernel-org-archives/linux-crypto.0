From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [RFC] [PATCH]  Fix for a warning - crypto/fcrypt,c
Date: Wed, 21 Aug 2013 20:47:15 +1000
Message-ID: <20130821104715.GA22975@gondor.apana.org.au>
References: <4092573.JCpLRYcAKP@aragorn.auenland.lan>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: "David S. Miller" <davem@davemloft.net>,
	linux-crypto@vger.kernel.org, behanw@converseincode.com,
	pageexec@freemail.hu
To: Jan-Simon =?iso-8859-1?Q?M=F6ller?= <dl9pf@gmx.de>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from ringil.hengli.com.au ([178.18.16.133]:54360 "EHLO
	fornost.hengli.com.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751495Ab3HUKr0 (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 21 Aug 2013 06:47:26 -0400
Content-Disposition: inline
In-Reply-To: <4092573.JCpLRYcAKP@aragorn.auenland.lan>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Thu, Aug 15, 2013 at 02:01:50PM +0200, Jan-Simon M=F6ller wrote:
> Hi all,
>=20
> please merge the attached patch.=20
>=20
> Fix for warning:
> linux/crypto/fcrypt.c:143:47: warning: signed shift result (0x5980000=
00)=20
> requires 36 bits to
>       represent, but 'int' only has 32 bits [-Wshift-overflow]
>         Z(0xef), Z(0x70), Z(0xcf), Z(0xc2), Z(0x2a), Z(0xb3), Z(0x61)=
,=20
> Z(0xad),
>                                                      ^~~~~~~
> linux/crypto/fcrypt.c:113:29: note: expanded from macro 'Z'
> #define Z(x) cpu_to_be32((x << 27 ) | (x >> 5))
>                             ^  ~~
> linux/include/uapi/linux/byteorder/little_endian.h:38:53: note: expan=
ded from=20
> macro
>       '__cpu_to_be32'
> #define __cpu_to_be32(x) ((__force __be32)__swab32((x)))
>                                                     ^
> linux/include/uapi/linux/swab.h:116:21: note: expanded from macro '__=
swab32'
>         ___constant_swab32(x) :                 \
>                            ^
> linux/include/uapi/linux/swab.h:18:12: note: expanded from macro=20
> '___constant_swab32'
>         (((__u32)(x) & (__u32)0x0000ff00UL) <<  8) |            \
>                   ^
>=20
> Solution - make sure we don't exceed the 32 bit range by adding (x & =
~(1U <<=20
> 27)) =20
> =3D  & (0xF7FFFFFF)_16 or & (1111 0111 1111 1111 1111 1111 1111 1111)=
_2

Your fix makes no sense.  To achieve what you want you'd need to lop
off the first 5 bits, not the fifth bit.

However, which compiler is this? This warning seems to be rather
pointless.

Thanks,
--=20
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt

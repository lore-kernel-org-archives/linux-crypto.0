From: Jan-Simon =?ISO-8859-1?Q?M=F6ller?= <dl9pf@gmx.de>
Subject: Re: [RFC] [PATCH]  Fix for a warning - crypto/fcrypt,c
Date: Wed, 21 Aug 2013 22:42:01 +0200
Message-ID: <3514602.viscUS1bgS@aragorn.auenland.lan>
References: <4092573.JCpLRYcAKP@aragorn.auenland.lan>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: behanw@converseincode.com, pageexec@freemail.hu
To: Herbert Xu <herbert@gondor.apana.org.au>,
	linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.17.22]:52957 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752515Ab3HUUnU convert rfc822-to-8bit (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 21 Aug 2013 16:43:20 -0400
Received: from aragorn.auenland.lan ([95.90.185.134]) by mail.gmx.com
 (mrgmx101) with ESMTPSA (Nemesis) id 0Ldcv0-1VutSJ0tRy-00imVc for
 <linux-crypto@vger.kernel.org>; Wed, 21 Aug 2013 22:43:17 +0200
In-Reply-To: <4092573.JCpLRYcAKP@aragorn.auenland.lan>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>


Should I resend a fixed version with=20
(1U << 27) - 1) instead ?

Best,
JS

On Thursday 15 August 2013 14:01:50 Jan-Simon M=F6ller wrote:
> Hi all,
>=20
> please merge the attached patch.
>=20
> Fix for warning:
> linux/crypto/fcrypt.c:143:47: warning: signed shift result (0x5980000=
00)
> requires 36 bits to
>       represent, but 'int' only has 32 bits [-Wshift-overflow]
>         Z(0xef), Z(0x70), Z(0xcf), Z(0xc2), Z(0x2a), Z(0xb3), Z(0x61)=
,
> Z(0xad),
>                                                      ^~~~~~~
> linux/crypto/fcrypt.c:113:29: note: expanded from macro 'Z'
> #define Z(x) cpu_to_be32((x << 27 ) | (x >> 5))
>                             ^  ~~
> linux/include/uapi/linux/byteorder/little_endian.h:38:53: note: expan=
ded
> from macro
>       '__cpu_to_be32'
> #define __cpu_to_be32(x) ((__force __be32)__swab32((x)))
>                                                     ^
> linux/include/uapi/linux/swab.h:116:21: note: expanded from macro '__=
swab32'
> ___constant_swab32(x) :                 \
>                            ^
> linux/include/uapi/linux/swab.h:18:12: note: expanded from macro
> '___constant_swab32'
>         (((__u32)(x) & (__u32)0x0000ff00UL) <<  8) |            \
>                   ^
>=20
> Solution - make sure we don't exceed the 32 bit range by adding (x & =
~(1U <<
> 27))
> =3D  & (0xF7FFFFFF)_16 or & (1111 0111 1111 1111 1111 1111 1111 1111)=
_2
>=20
>=20
> Author:  PaX Team <pageexec at freemail.hu>
> ML-Post:
> http://lists.cs.uiuc.edu/pipermail/llvm-commits/Week-of-Mon-20120507/=
142707
> .html URL:     http://llvm.linuxfoundation.org
>=20
> Merge:   Jan-Simon M=F6ller <dl9pf at gmx.de>
>=20
>=20
>=20
> Best,

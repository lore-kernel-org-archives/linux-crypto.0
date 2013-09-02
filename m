From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] Fix bitoperation for compilation with clang
Date: Mon, 2 Sep 2013 20:35:52 +1000
Message-ID: <20130902103552.GB815@gondor.apana.org.au>
References: <1377799764-14373-1-git-send-email-dl9pf@gmx.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-kernel@vger.kernel.org, pageexec@freemail.hu,
	llvmlinux@lists.linuxfoundation.org, behanw@converseincode.com,
	davem@davemloft.net, linux-crypto@vger.kernel.org
To: dl9pf@gmx.de
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1377799764-14373-1-git-send-email-dl9pf@gmx.de>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Thu, Aug 29, 2013 at 08:09:24PM +0200, dl9pf@gmx.de wrote:
> From: Jan-Simon M=F6ller <dl9pf@gmx.de>
>=20
> v2: Fix bug in statement as pointed out by Herbert Xu. Kudos to pipac=
s.
>=20
> Author:  PaX Team <pageexec at freemail.hu>
> ML-Post: http://lists.cs.uiuc.edu/pipermail/llvm-commits/Week-of-Mon-=
20120507/142707.html
> URL:     http://llvm.linuxfoundation.org
>=20
> Merge:   Jan-Simon M=F6ller <dl9pf at gmx.de>
>=20
> Description:
>=20
> Fix for warning:
> linux/crypto/fcrypt.c:143:47: warning: signed shift result (0x5980000=
00) requires 36 bits to
>       represent, but 'int' only has 32 bits [-Wshift-overflow]
>         Z(0xef), Z(0x70), Z(0xcf), Z(0xc2), Z(0x2a), Z(0xb3), Z(0x61)=
, Z(0xad),
>                                                      ^~~~~~~
> linux/crypto/fcrypt.c:113:29: note: expanded from macro 'Z'
>                             ^  ~~
> linux/include/uapi/linux/byteorder/little_endian.h:38:53: note: expan=
ded from macro
>       '__cpu_to_be32'
>                                                     ^
> linux/include/uapi/linux/swab.h:116:21: note: expanded from macro '__=
swab32'
>         ___constant_swab32(x) :                 \
>                            ^
> linux/include/uapi/linux/swab.h:18:12: note: expanded from macro '___=
constant_swab32'
>         (((__u32)(x) & (__u32)0x0000ff00UL) <<  8) |            \
>                   ^
>=20
> Solution - make sure we don't exceed the 32 bit range.
>  #define Z(x) cpu_to_be32(((x & 0x1f) << 27) | (x >> 5))
>=20
> Signed-off-by: Jan-Simon M=F6ller <dl9pf@gmx.de>

Patch applied.
--=20
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt

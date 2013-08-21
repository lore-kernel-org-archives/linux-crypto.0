From: "PaX Team" <pageexec@freemail.hu>
Subject: Re: [RFC] [PATCH]  Fix for a warning - crypto/fcrypt,c
Date: Wed, 21 Aug 2013 17:39:36 +0200
Message-ID: <5214DF38.17262.204C9B7D@pageexec.freemail.hu>
References: <4092573.JCpLRYcAKP@aragorn.auenland.lan>, <20130821104715.GA22975@gondor.apana.org.au>
Reply-To: pageexec@freemail.hu
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: "David S. Miller" <davem@davemloft.net>,
	linux-crypto@vger.kernel.org, behanw@converseincode.com
To: "=?UTF-8?Q?Jan-Simon_M=C3=B6ller?=" <dl9pf@gmx.de>,
	Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from r00tworld.com ([212.85.137.150]:47354 "EHLO r00tworld.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751610Ab3HUQhu convert rfc822-to-8bit (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 21 Aug 2013 12:37:50 -0400
In-reply-to: <20130821104715.GA22975@gondor.apana.org.au>
Content-description: Mail message body
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On 21 Aug 2013 at 20:47, Herbert Xu wrote:

> On Thu, Aug 15, 2013 at 02:01:50PM +0200, Jan-Simon M=C3=B6ller wrote=
:
> > Solution - make sure we don't exceed the 32 bit range by adding (x =
& ~(1U <<=20
> > 27)) =20
> > =3D  & (0xF7FFFFFF)_16 or & (1111 0111 1111 1111 1111 1111 1111 111=
1)_2
>=20
> Your fix makes no sense.  To achieve what you want you'd need to lop
> off the first 5 bits, not the fifth bit.

oops, the bitmask expression wanted to be (1U << 27) - 1) instead.
another approach would be to simply cast the macro argument to __be32.

> However, which compiler is this? This warning seems to be rather
> pointless.

it's clang and this warning is about an undefined behaviour because
the hexadecimal constants passed to this macro are treated as signed
ints and for some of the constants the result of the shift cannot be
represented as a signed int.

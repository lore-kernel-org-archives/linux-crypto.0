From: Hannes Frederic Sowa <hannes@stressinduktion.org>
Subject: Re: [BUG/PATCH] kernel RNG and its secrets
Date: Wed, 18 Mar 2015 16:09:34 +0100
Message-ID: <1426691374.2212055.242060697.4DDF89CA@webmail.messagingengine.com>
References: <20150318095345.GA12923@zoho.com> <1712478.ujdQuuIYol@tauon>
 <1426681147.2164835.241982149.0C3DD661@webmail.messagingengine.com>
 <1867652.j97RWRfxn1@tauon> <550972A7.9030100@iogearbox.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: mancha <mancha1@zoho.com>, tytso@mit.edu,
	linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org,
	herbert@gondor.apana.org.au, dborkman@redhat.com
To: Daniel Borkmann <daniel@iogearbox.net>,
	Stephan Mueller <smueller@chronox.de>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from out3-smtp.messagingengine.com ([66.111.4.27]:60230 "EHLO
	out3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751564AbbCRPJf convert rfc822-to-8bit
	(ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Wed, 18 Mar 2015 11:09:35 -0400
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
	by mailout.nyi.internal (Postfix) with ESMTP id B587820812
	for <linux-crypto@vger.kernel.org>; Wed, 18 Mar 2015 11:09:32 -0400 (EDT)
In-Reply-To: <550972A7.9030100@iogearbox.net>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>



On Wed, Mar 18, 2015, at 13:42, Daniel Borkmann wrote:
> On 03/18/2015 01:20 PM, Stephan Mueller wrote:
> > Am Mittwoch, 18. M=C3=A4rz 2015, 13:19:07 schrieb Hannes Frederic S=
owa:
> >>>> My proposal would be to add a
> >>>>
> >>>> #define OPTIMIZER_HIDE_MEM(ptr, len) __asm__ __volatile__ ("" : =
:
> >>>> "m"(
> >>>> ({ struct { u8 b[len]; } *p =3D (void *)ptr ; *p; }) )
> >>>>
> >>>> and use this in the code function.
> >>>>
> >>>> This is documented in gcc manual 6.43.2.5.
> >>>
> >>> That one adds the zeroization instructuctions. But now there are =
much
> >>> more than with the barrier.
> >>>
> >>>    400469:       48 c7 04 24 00 00 00    movq   $0x0,(%rsp)
> >>>    400470:       00
> >>>    400471:       48 c7 44 24 08 00 00    movq   $0x0,0x8(%rsp)
> >>>    400478:       00 00
> >>>    40047a:       c7 44 24 10 00 00 00    movl   $0x0,0x10(%rsp)
> >>>    400481:       00
> >>>    400482:       48 c7 44 24 20 00 00    movq   $0x0,0x20(%rsp)
> >>>    400489:       00 00
> >>>    40048b:       48 c7 44 24 28 00 00    movq   $0x0,0x28(%rsp)
> >>>    400492:       00 00
> >>>    400494:       c7 44 24 30 00 00 00    movl   $0x0,0x30(%rsp)
> >>>    40049b:       00
> >>>
> >>> Any ideas?
> >>
> >> Hmm, correct definition of u8?
> >
> > I use unsigned char
> >>
> >> Which version of gcc do you use? I can't see any difference if I
> >> compile your example at -O2.
> >
> > gcc-Version 4.9.2 20150212 (Red Hat 4.9.2-6) (GCC)

Well, was an error on my side, I see the same behavior.

>=20
> I can see the same with the gcc version I previously posted. So
> it clears the 20 bytes from your example (movq, movq, movl) at
> two locations, presumably buf[] and b[].

Yes, it looks like that. The reservation on the stack changes, too.

Seems like just using barrier() is the best and easiest option.

Thanks,
Hannes

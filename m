From: Stephan Mueller <smueller@chronox.de>
Subject: Re: [BUG/PATCH] kernel RNG and its secrets
Date: Wed, 18 Mar 2015 17:02:01 +0100
Message-ID: <4937031.1sk5yglzr8@tauon>
References: <20150318095345.GA12923@zoho.com> <550972A7.9030100@iogearbox.net> <1426691374.2212055.242060697.4DDF89CA@webmail.messagingengine.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Daniel Borkmann <daniel@iogearbox.net>, mancha <mancha1@zoho.com>,
	tytso@mit.edu, linux-kernel@vger.kernel.org,
	linux-crypto@vger.kernel.org, herbert@gondor.apana.org.au,
	dborkman@redhat.com
To: Hannes Frederic Sowa <hannes@stressinduktion.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1426691374.2212055.242060697.4DDF89CA@webmail.messagingengine.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Am Mittwoch, 18. M=E4rz 2015, 16:09:34 schrieb Hannes Frederic Sowa:

Hi Hannes,

>On Wed, Mar 18, 2015, at 13:42, Daniel Borkmann wrote:
>> On 03/18/2015 01:20 PM, Stephan Mueller wrote:
>> > Am Mittwoch, 18. M=E4rz 2015, 13:19:07 schrieb Hannes Frederic Sow=
a:
>> >>>> My proposal would be to add a
>> >>>>=20
>> >>>> #define OPTIMIZER_HIDE_MEM(ptr, len) __asm__ __volatile__ ("" :
>> >>>> :
>> >>>> "m"(
>> >>>> ({ struct { u8 b[len]; } *p =3D (void *)ptr ; *p; }) )
>> >>>>=20
>> >>>> and use this in the code function.
>> >>>>=20
>> >>>> This is documented in gcc manual 6.43.2.5.
>> >>>=20
>> >>> That one adds the zeroization instructuctions. But now there are
>> >>> much
>> >>> more than with the barrier.
>> >>>=20
>> >>>    400469:       48 c7 04 24 00 00 00    movq   $0x0,(%rsp)
>> >>>    400470:       00
>> >>>    400471:       48 c7 44 24 08 00 00    movq   $0x0,0x8(%rsp)
>> >>>    400478:       00 00
>> >>>    40047a:       c7 44 24 10 00 00 00    movl   $0x0,0x10(%rsp)
>> >>>    400481:       00
>> >>>    400482:       48 c7 44 24 20 00 00    movq   $0x0,0x20(%rsp)
>> >>>    400489:       00 00
>> >>>    40048b:       48 c7 44 24 28 00 00    movq   $0x0,0x28(%rsp)
>> >>>    400492:       00 00
>> >>>    400494:       c7 44 24 30 00 00 00    movl   $0x0,0x30(%rsp)
>> >>>    40049b:       00
>> >>>=20
>> >>> Any ideas?
>> >>=20
>> >> Hmm, correct definition of u8?
>> >=20
>> > I use unsigned char
>> >=20
>> >> Which version of gcc do you use? I can't see any difference if I
>> >> compile your example at -O2.
>> >=20
>> > gcc-Version 4.9.2 20150212 (Red Hat 4.9.2-6) (GCC)
>
>Well, was an error on my side, I see the same behavior.
>
>> I can see the same with the gcc version I previously posted. So
>> it clears the 20 bytes from your example (movq, movq, movl) at
>> two locations, presumably buf[] and b[].
>
>Yes, it looks like that. The reservation on the stack changes, too.
>
>Seems like just using barrier() is the best and easiest option.

Would you prepare a patch for that?
>
>Thanks,
>Hannes


Ciao
Stephan

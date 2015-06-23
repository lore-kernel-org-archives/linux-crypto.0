From: Geert Uytterhoeven <geert@linux-m68k.org>
Subject: Re: #pragma GCC warnings (was: Re: [PATCH] crypto: drbg - use pragmas
 for disabling optimization)
Date: Tue, 23 Jun 2015 15:17:20 +0200
Message-ID: <CAMuHMdUw9FJE3kWEQf+TNTaLB9gMjdHEGt27bnD--qoGX22H7Q@mail.gmail.com>
References: <CAMuHMdXLDeqSU3WcVEh=jcGdS4z2YMejU_nZ2gDObDVjsm7vvw@mail.gmail.com>
	<20150623092106.GA18791@gondor.apana.org.au>
	<33380936.3jDOACMRCz@tachyon.chronox.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
	Guenter Roeck <linux@roeck-us.net>,
	Peter Zijlstra
	<public-peterz-wegcikhe2lqwvfeawa7xhq@plane.gmane.org>,
	Andy Shevchenko <andy.shevchenko@gmail.com>,
	Jim Davis <jim.epost@gmail.com>,
	Stephen Rothwell <sfr@canb.auug.org.au>,
	Linux-Next <linux-next@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"David S. Miller" <davem@davemloft.net>,
	linux-crypto@vger.kernel.org, Waiman Long <waiman.long@hp.com>,
	Ingo Molnar <mingo@kernel.org>, x86 <x86@kernel.org>
To: Stephan Mueller <smueller@chronox.de>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-oi0-f44.google.com ([209.85.218.44]:34303 "EHLO
	mail-oi0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753521AbbFWNRU (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 23 Jun 2015 09:17:20 -0400
In-Reply-To: <33380936.3jDOACMRCz@tachyon.chronox.de>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi Stephan,

On Tue, Jun 23, 2015 at 3:01 PM, Stephan Mueller <smueller@chronox.de> wrote:
>> On Tue, Jun 23, 2015 at 11:17:23AM +0200, Geert Uytterhoeven wrote:
>> > I get that too with m68k-linux-gcc-4.6.3 and m68k-linux-gcc-4.9.0.
>> >
>> > With m68k-linux-gnu-gcc-4.1, which is still my default cross-compiler due
>> > to the good unused warning reporting, I get:
>> >
>> > crypto/jitterentropy.c:235: warning: ignoring #pragma GCC push_options
>> > crypto/jitterentropy.c:236: warning: ignoring #pragma GCC optimize
>> > crypto/jitterentropy.c:266: warning: ignoring #pragma GCC pop_options
>> > crypto/jitterentropy.c:295: warning: ignoring #pragma GCC push_options
>> > crypto/jitterentropy.c:296: warning: ignoring #pragma GCC optimize
>> > crypto/jitterentropy.c:336: warning: ignoring #pragma GCC pop_options
>> > crypto/jitterentropy.c:385: warning: ignoring #pragma GCC push_options
>> > crypto/jitterentropy.c:386: warning: ignoring #pragma GCC optimize
>> > crypto/jitterentropy.c:416: warning: ignoring #pragma GCC pop_options
>> > crypto/jitterentropy.c:517: warning: ignoring #pragma GCC push_options
>> > crypto/jitterentropy.c:518: warning: ignoring #pragma GCC optimize
>> > crypto/jitterentropy.c:580: warning: ignoring #pragma GCC pop_options
>>
>> Stephan, could you look into moving the relevant functions into
>> its own file which can then be compiled with -O0? Obviously any
>> dependency on kernel header files would have to be hidden using
>> functions outside of this file.
>
> I have separated all so far. However, there are two items left where I am not
> sure about:
>
> - asm/types.h: I need __u64

I don't expect any reliance on optimization in <asm/types.h>, as it should
just add definitions. However, "__u64" is "unsigned long long" everywhere,
so you can just use that.

> - linux/bitops.h: I need rol64
>
> Can I safely include both header files or do I have to hide them too. If yes,
> how would I do that in a way that is satisfactory?

Either open-code rol64() (it's not that complicated), or add a source file that
contains only

        #include <linux/types.h>
        #include <linux/bitops.h>

        __u64 outofline_rol64(__u64 word, unsigned int shift)
        {
                return rol64(word, shift);
        }

and call outofline_rol64() from your code.

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds

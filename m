From: Geert Uytterhoeven <geert@linux-m68k.org>
Subject: #pragma GCC warnings (was: Re: [PATCH] crypto: drbg - use pragmas for
 disabling optimization)
Date: Tue, 23 Jun 2015 11:17:23 +0200
Message-ID: <CAMuHMdXLDeqSU3WcVEh=jcGdS4z2YMejU_nZ2gDObDVjsm7vvw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: Stephan Mueller <smueller@chronox.de>,
	Herbert Xu <herbert@gondor.apana.org.au>,
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
To: Guenter Roeck <linux@roeck-us.net>
Return-path: <linux-next-owner@vger.kernel.org>
Sender: linux-next-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Tue, Jun 9, 2015 at 6:31 AM, Guenter Roeck <linux@roeck-us.net> wrote:
> On 06/08/2015 07:08 PM, Stephan Mueller wrote:
>> ---8<---
>> Replace the global -O0 compiler flag from the Makefile with GCC
>> pragmas to mark only the functions required to be compiled without
>> optimizations.
>>
>> This patch also adds a comment describing the rationale for the
>> functions chosen to be compiled without optimizations.
>>
>> Signed-off-by: Stephan Mueller <smueller@chronox.de>
>
> With openrisc, I get:
>
>   CC [M]  crypto/jitterentropy.o
> crypto/jitterentropy.c:266:9: warning: #pragma GCC target is not supported
> for this machine
>
> which may not be perfect, but is better than a compile error ;-).

I get that too with m68k-linux-gcc-4.6.3 and m68k-linux-gcc-4.9.0.

With m68k-linux-gnu-gcc-4.1, which is still my default cross-compiler due
to the good unused warning reporting, I get:

crypto/jitterentropy.c:235: warning: ignoring #pragma GCC push_options
crypto/jitterentropy.c:236: warning: ignoring #pragma GCC optimize
crypto/jitterentropy.c:266: warning: ignoring #pragma GCC pop_options
crypto/jitterentropy.c:295: warning: ignoring #pragma GCC push_options
crypto/jitterentropy.c:296: warning: ignoring #pragma GCC optimize
crypto/jitterentropy.c:336: warning: ignoring #pragma GCC pop_options
crypto/jitterentropy.c:385: warning: ignoring #pragma GCC push_options
crypto/jitterentropy.c:386: warning: ignoring #pragma GCC optimize
crypto/jitterentropy.c:416: warning: ignoring #pragma GCC pop_options
crypto/jitterentropy.c:517: warning: ignoring #pragma GCC push_options
crypto/jitterentropy.c:518: warning: ignoring #pragma GCC optimize
crypto/jitterentropy.c:580: warning: ignoring #pragma GCC pop_options

If you want to reproduce with a simple test case, you need -Wall.

Which gcc versions introduced support for these pragmas?

I tried all my cross-compilers from https://www.kernel.org/pub/tools/crosstool/,
and it seems I get warnings for all of them, except for powerpc and x86_64:

/opt/cross/gcc-4.2.4-nolibc/avr32-linux/bin/avr32-linux-gcc :
        warning: ignoring #pragma GCC push_options
        warning: ignoring #pragma GCC optimize
        warning: ignoring #pragma GCC pop_options
/opt/cross/gcc-4.5.1-nolibc/or32-linux/bin/or32-linux-gcc :
        warning: #pragma GCC target is not supported for this machine
/opt/cross/gcc-4.6.2-nolibc/tilegx-linux/bin/tilegx-linux-gcc :
        warning: #pragma GCC target is not supported for this machine
[-Wpragmas]
/opt/cross/gcc-4.6.3-nolibc/alpha-linux/bin/alpha-linux-gcc :
        warning: #pragma GCC target is not supported for this machine
[-Wpragmas]
/opt/cross/gcc-4.6.3-nolibc/am33_2.0-linux/bin/am33_2.0-linux-gcc :
        warning: #pragma GCC target is not supported for this machine
[-Wpragmas]
/opt/cross/gcc-4.6.3-nolibc/arm-unknown-linux-gnueabi/bin/arm-unknown-linux-gnueabi-gcc
:
        warning: #pragma GCC target is not supported for this machine
[-Wpragmas]
/opt/cross/gcc-4.6.3-nolibc/bfin-uclinux/bin/bfin-uclinux-gcc :
        warning: #pragma GCC target is not supported for this machine
[-Wpragmas]
/opt/cross/gcc-4.6.3-nolibc/crisv32-linux/bin/crisv32-linux-gcc :
        warning: #pragma GCC target is not supported for this machine
[-Wpragmas]
/opt/cross/gcc-4.6.3-nolibc/frv-linux/bin/frv-linux-gcc :
        warning: #pragma GCC target is not supported for this machine
[-Wpragmas]
/opt/cross/gcc-4.6.3-nolibc/hppa64-linux/bin/hppa64-linux-gcc :
        warning: #pragma GCC target is not supported for this machine
[-Wpragmas]
/opt/cross/gcc-4.6.3-nolibc/ia64-linux/bin/ia64-linux-gcc :
        warning: #pragma GCC target is not supported for this machine
[-Wpragmas]
/opt/cross/gcc-4.6.3-nolibc/m32r-linux/bin/m32r-linux-gcc :
        warning: #pragma GCC target is not supported for this machine
[-Wpragmas]
/opt/cross/gcc-4.6.3-nolibc/m68k-linux/bin/m68k-linux-gcc :
        warning: #pragma GCC target is not supported for this machine
[-Wpragmas]
/opt/cross/gcc-4.6.3-nolibc/mips64-linux/bin/mips64-linux-gcc :
        warning: #pragma GCC target is not supported for this machine
[-Wpragmas]
/opt/cross/gcc-4.6.3-nolibc/s390x-linux/bin/s390x-linux-gcc :
        warning: #pragma GCC target is not supported for this machine
[-Wpragmas]
/opt/cross/gcc-4.6.3-nolibc/sh4-linux/bin/sh4-linux-gcc :
        warning: #pragma GCC target is not supported for this machine
[-Wpragmas]
/opt/cross/gcc-4.6.3-nolibc/sparc64-linux/bin/sparc64-linux-gcc :
        warning: #pragma GCC target is not supported for this machine
[-Wpragmas]
/opt/cross/gcc-4.6.3-nolibc/xtensa-linux/bin/xtensa-linux-gcc :
        warning: #pragma GCC target is not supported for this machine
[-Wpragmas]
/opt/cross/gcc-4.8.0-nolibc/microblaze-linux/bin/microblaze-linux-gcc :
        warning: #pragma GCC target is not supported for this machine
[-Wpragmas]
         #pragma GCC pop_options
                 ^
/opt/cross/gcc-4.8.0-nolibc/powerpc64-linux/bin/powerpc64-linux-gcc :
/opt/cross/gcc-4.9.0-nolibc/aarch64-linux/bin/aarch64-linux-gcc :
        warning: #pragma GCC target is not supported for this machine
[-Wpragmas]
         #pragma GCC pop_options
                 ^
/opt/cross/gcc-4.9.0-nolibc/alpha-linux/bin/alpha-linux-gcc :
        warning: #pragma GCC target is not supported for this machine
[-Wpragmas]
         #pragma GCC pop_options
                 ^
/opt/cross/gcc-4.9.0-nolibc/am33_2.0-linux/bin/am33_2.0-linux-gcc :
        warning: #pragma GCC target is not supported for this machine
[-Wpragmas]
         #pragma GCC pop_options
                 ^
/opt/cross/gcc-4.9.0-nolibc/arm-unknown-linux-gnueabi/bin/arm-unknown-linux-gnueabi-gcc
:
        warning: #pragma GCC target is not supported for this machine
[-Wpragmas]
         #pragma GCC pop_options
                 ^
/opt/cross/gcc-4.9.0-nolibc/frv-linux/bin/frv-linux-gcc :
        warning: #pragma GCC target is not supported for this machine
[-Wpragmas]
         #pragma GCC pop_options
                 ^
/opt/cross/gcc-4.9.0-nolibc/h8300-elf/bin/h8300-elf-gcc :
        warning: #pragma GCC target is not supported for this machine
[-Wpragmas]
         #pragma GCC pop_options
                 ^
/opt/cross/gcc-4.9.0-nolibc/hppa64-linux/bin/hppa64-linux-gcc :
        warning: #pragma GCC target is not supported for this machine
[-Wpragmas]
         #pragma GCC pop_options
                 ^
/opt/cross/gcc-4.9.0-nolibc/ia64-linux/bin/ia64-linux-gcc :
        warning: #pragma GCC target is not supported for this machine
[-Wpragmas]
         #pragma GCC pop_options
                 ^
/opt/cross/gcc-4.9.0-nolibc/m32r-linux/bin/m32r-linux-gcc :
        warning: #pragma GCC target is not supported for this machine
[-Wpragmas]
         #pragma GCC pop_options
                 ^
/opt/cross/gcc-4.9.0-nolibc/m68k-linux/bin/m68k-linux-gcc :
        warning: #pragma GCC target is not supported for this machine
[-Wpragmas]
         #pragma GCC pop_options
                 ^
/opt/cross/gcc-4.9.0-nolibc/microblaze-linux/bin/microblaze-linux-gcc :
        warning: #pragma GCC target is not supported for this machine
[-Wpragmas]
         #pragma GCC pop_options
                 ^
/opt/cross/gcc-4.9.0-nolibc/mips64-linux/bin/mips64-linux-gcc :
        warning: #pragma GCC target is not supported for this machine
[-Wpragmas]
         #pragma GCC pop_options
                 ^
/opt/cross/gcc-4.9.0-nolibc/powerpc64-linux/bin/powerpc64-linux-gcc :
/opt/cross/gcc-4.9.0-nolibc/ppc64le-linux/bin/ppc64le-linux-gcc :
/opt/cross/gcc-4.9.0-nolibc/s390x-linux/bin/s390x-linux-gcc :
        warning: #pragma GCC target is not supported for this machine
[-Wpragmas]
         #pragma GCC pop_options
                 ^
/opt/cross/gcc-4.9.0-nolibc/sparc64-linux/bin/sparc64-linux-gcc :
        warning: #pragma GCC target is not supported for this machine
[-Wpragmas]
         #pragma GCC pop_options
                 ^
/opt/cross/gcc-4.9.0-nolibc/x86_64-linux/bin/x86_64-linux-gcc :
/opt/cross/gcc-4.9.0-nolibc/x86_64-linux/bin/x86_64-linux-x86_64-linux-gcc :
/opt/cross/gcc-4.9.0-nolibc/xtensa-linux/bin/xtensa-linux-gcc :
        warning: #pragma GCC target is not supported for this machine
[-Wpragmas]
         #pragma GCC pop_options
                 ^

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds

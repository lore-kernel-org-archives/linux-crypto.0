From: Jeffrey Walton <noloader@gmail.com>
Subject: Fast Code and HAVE_EFFICIENT_UNALIGNED_ACCESS (was: [PATCH] poly1305:
 generic C can be faster on chips with slow unaligned access)
Date: Wed, 2 Nov 2016 17:35:21 -0400
Message-ID: <CAH8yC8nuWaWNahj6MxG=3kkEN+M=Qi86o+LagZCbBCLtcCChnQ@mail.gmail.com>
Reply-To: noloader@gmail.com
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: linux-crypto@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        Martin Willi <martin@strongswan.org>
To: "Jason A. Donenfeld" <Jason@zx2c4.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Wed, Nov 2, 2016 at 5:25 PM, Jason A. Donenfeld <Jason@zx2c4.com> wrote:
> These architectures select HAVE_EFFICIENT_UNALIGNED_ACCESS:
>
> s390 arm arm64 powerpc x86 x86_64
>
> So, these will use the original old code.
>
> The architectures that will thus use the new code are:
>
> alpha arc avr32 blackfin c6x cris frv h7300 hexagon ia64 m32r m68k
> metag microblaze mips mn10300 nios2 openrisc parisc score sh sparc
> tile um unicore32 xtensa

What I have found in practice from helping maintain a security library
and running benchmarks until my eyes bled....

UNALIGNED_ACCESS is a kiss of death. It effectively prohibits -O3 and
above due to undefined behavior in C and problems with GCC
vectorization. In the bigger picture, it simply slows things down.

Once we moved away from UNALIGNED_ACCESS and started testing at -O3
and -O5, the benchmarks enjoyed non-trivial speedups on top of any
speedups we were trying to achieve with hand tuned assembly language
routines. Effectively, the best speedup was the sum of C-code and ASM;
they were not disjoint as they appear.

The one wrinkle for UNALIGNED_ACCESS is Bernstein's compressed tables
(https://cr.yp.to/antiforgery/cachetiming-20050414.pdf).
UNALIGNED_ACCESS meets some security goals. The techniques from
Bernstein's paper apply equally well to AES, Camellia and other
table-driven implementations. Painting with a broad brush (and as far
as I know), the kernel is not observing the recommendations. My
apologies if I parsed things incorrectly.

Jeff

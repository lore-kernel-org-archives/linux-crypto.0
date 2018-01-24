From: Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH RFC 0/3] API for 128-bit IO access
Date: Wed, 24 Jan 2018 11:28:55 +0100
Message-ID: <CAK8P3a3TEV7Uyo_oBcMz_GYEYTB+V5AhDgbOgCEW-+X1h7sXEg@mail.gmail.com>
References: <20180124090519.6680-1-ynorov@caviumnetworks.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Cc: Linux ARM <linux-arm-kernel@lists.infradead.org>,
        linux-arch <linux-arch@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "open list:HARDWARE RANDOM NUMBER GENERATOR CORE"
        <linux-crypto@vger.kernel.org>, Al Viro <viro@zeniv.linux.org.uk>,
        Andrew Morton <akpm@linux-foundation.org>,
        Andrew Pinski <Andrew.Pinski@cavium.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        "David S . Miller" <davem@davemloft.net>,
        Geethasowjanya Akula <Geethasowjanya.Akula@cavium.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Ingo Molnar <mingo@kernel.org>,
        Kees Cook <keescook@chromium.org>,
        Laura Abbott <labbott@redhat.com>,
        Nicholas Piggin <npiggin@gmail.com>,
        Sunil Goutham <Sunil.Goutham@cavium.com>,
        Will Deacon <will.deacon@arm.com>
To: Yury Norov <ynorov@caviumnetworks.com>
Return-path: <linux-arch-owner@vger.kernel.org>
In-Reply-To: <20180124090519.6680-1-ynorov@caviumnetworks.com>
Sender: linux-arch-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Wed, Jan 24, 2018 at 10:05 AM, Yury Norov <ynorov@caviumnetworks.com> wrote:
> This series adds API for 128-bit memory IO access and enables it for ARM64.
> The original motivation for 128-bit API came from new Cavium network device
> driver. The hardware requires 128-bit access to make things work. See
> description in patch 3 for details.

We might also want to do something similar to the
include/linux/io-64-nonatomic-lo-hi.h
and hi-lo.h files, to simulate 128-bit access using pairs of 64-bit access on
other targets. It's apparently driver specific which half you need to do first
to make it work, so we need both.

> Also, starting from ARMv8.4, stp and ldp instructions become atomic, and
> API for 128-bit access would be helpful in core arm64 code.
>
> This series is RFC. I'd like to collect opinions on idea and implementation
> details.
> * I didn't implement all 128-bit operations existing for 64-bit variables
> and other types (__swab128p etc). Do we need them all right now, or we
> can add them when actually needed?

I think in this case it's better to do them all at once.

> * u128 name is already used in crypto code. So here I use __uint128_t that
> comes from GCC for 128-bit types. Should I rename existing type in crypto
> and make core code for 128-bit variables consistent with u64, u32 etc? (I
> think yes, but would like to ask crypto people for it.)

Hmm, that file probably predates the __uint128_t support. My guess would
be that the crypto code using it can actually benefit from the new types as
well, so maybe move the existing file to include/linux/int128.h and add
an #if/#else logic to it so we use 'typedef __uint128_t __u128' if that
is available.

> * Some compilers don't support __uint128_t, so I protected all generic code
> with config option HAVE_128BIT_ACCESS. I think it's OK, but...

That would be nicely solved by using the #if/#else definition above.

> * For 128-bit read/write functions I take suffix 'o', which means read/write
> the octet of bytes. Is this name OK?

Can't think of anything better. It's not an octet though, but 16 bytes
('q' is for quadword, meaning four 16-bit words in Intel terminology).

> * my mips-linux-gnu-gcc v6.3.0 doesn't support __uint128_t, and I
> don't have other BE setup on hand, so BE case is formally not tested.
> BE code for arm64 is looking well though.

I've run it through my collection of compilers, it seems that most but not
all 64-bit targets support it (exceptions appear to be older versions of
gcc for s390x and parisc), and none of the 32-bit targets do:

$ for i in /home/arnd/cross-gcc/bin/*gcc-[3-8]* ; do echo -n $i" " ;
echo '__uint128_t v;' | $i -xc -S - -o /dev/null && echo ok ; done
/home/arnd/cross-gcc/bin/aarch64-linux-gcc-4.8.5 ok
/home/arnd/cross-gcc/bin/aarch64-linux-gcc-4.9.3 ok
/home/arnd/cross-gcc/bin/aarch64-linux-gcc-4.9.4 ok
/home/arnd/cross-gcc/bin/aarch64-linux-gcc-5.2.1 ok
/home/arnd/cross-gcc/bin/aarch64-linux-gcc-5.4.1 ok
/home/arnd/cross-gcc/bin/aarch64-linux-gcc-5.5.0 ok
/home/arnd/cross-gcc/bin/aarch64-linux-gcc-6.3.1 ok
/home/arnd/cross-gcc/bin/aarch64-linux-gcc-7.0.0 ok
/home/arnd/cross-gcc/bin/aarch64-linux-gcc-7.0.1 ok
/home/arnd/cross-gcc/bin/aarch64-linux-gcc-7.1.1 ok
/home/arnd/cross-gcc/bin/aarch64-linux-gcc-7.2.1 ok
/home/arnd/cross-gcc/bin/aarch64-linux-gcc-8.0.0 ok
/home/arnd/cross-gcc/bin/alpha-linux-gcc-4.1.3 ok
/home/arnd/cross-gcc/bin/alpha-linux-gcc-4.3.6 ok
/home/arnd/cross-gcc/bin/alpha-linux-gcc-4.9.3 ok
/home/arnd/cross-gcc/bin/alpha-linux-gcc-7.2.1 ok
/home/arnd/cross-gcc/bin/am33_2.0-linux-gcc-4.9.3 <stdin>:1:1: error:
unknown type name '__uint128_t'
/home/arnd/cross-gcc/bin/am33_2.0-linux-gcc-5.2.1 <stdin>:1:1: error:
unknown type name '__uint128_t'
/home/arnd/cross-gcc/bin/am33_2.0-linux-gcc-7.2.1 <stdin>:1:1: error:
unknown type name '__uint128_t'; did you mean '__int128'?
/home/arnd/cross-gcc/bin/arc-elf-gcc-7.2.1 <stdin>:1:1: error: unknown
type name '__uint128_t'; did you mean '__int128'?
/home/arnd/cross-gcc/bin/arm-linux-gnueabi-gcc-3.4.6 ok
/home/arnd/cross-gcc/bin/arm-linux-gnueabi-gcc-4.3.6 <stdin>:1: error:
expected '=', ',', ';', 'asm' or '__attribute__' before 'v'
/home/arnd/cross-gcc/bin/arm-linux-gnueabi-gcc-4.4.7 <stdin>:1: error:
expected '=', ',', ';', 'asm' or '__attribute__' before 'v'
/home/arnd/cross-gcc/bin/arm-linux-gnueabi-gcc-4.5.4 <stdin>:1:13:
error: expected '=', ',', ';', 'asm' or '__attribute__' before 'v'
/home/arnd/cross-gcc/bin/arm-linux-gnueabi-gcc-4.6.4 <stdin>:1:1:
error: unknown type name '__uint128_t'
/home/arnd/cross-gcc/bin/arm-linux-gnueabi-gcc-4.7.4 <stdin>:1:1:
error: unknown type name '__uint128_t'
/home/arnd/cross-gcc/bin/arm-linux-gnueabi-gcc-4.8.5 <stdin>:1:1:
error: unknown type name '__uint128_t'
/home/arnd/cross-gcc/bin/arm-linux-gnueabi-gcc-4.9.0 <stdin>:1:1:
error: unknown type name '__uint128_t'
/home/arnd/cross-gcc/bin/arm-linux-gnueabi-gcc-4.9.1 <stdin>:1:1:
error: unknown type name '__uint128_t'
/home/arnd/cross-gcc/bin/arm-linux-gnueabi-gcc-4.9.2 <stdin>:1:1:
error: unknown type name '__uint128_t'
/home/arnd/cross-gcc/bin/arm-linux-gnueabi-gcc-4.9.3 <stdin>:1:1:
error: unknown type name '__uint128_t'
/home/arnd/cross-gcc/bin/arm-linux-gnueabi-gcc-4.9.4 <stdin>:1:1:
error: unknown type name '__uint128_t'
/home/arnd/cross-gcc/bin/arm-linux-gnueabi-gcc-5.0.0 <stdin>:1:1:
error: unknown type name '__uint128_t'
/home/arnd/cross-gcc/bin/arm-linux-gnueabi-gcc-5.1.1 <stdin>:1:1:
error: unknown type name '__uint128_t'
/home/arnd/cross-gcc/bin/arm-linux-gnueabi-gcc-5.2.1 <stdin>:1:1:
error: unknown type name '__uint128_t'
/home/arnd/cross-gcc/bin/arm-linux-gnueabi-gcc-5.3.1 <stdin>:1:1:
error: unknown type name '__uint128_t'
/home/arnd/cross-gcc/bin/arm-linux-gnueabi-gcc-5.4.1 <stdin>:1:1:
error: unknown type name '__uint128_t'
/home/arnd/cross-gcc/bin/arm-linux-gnueabi-gcc-5.5.0 <stdin>:1:1:
error: unknown type name '__uint128_t'
/home/arnd/cross-gcc/bin/arm-linux-gnueabi-gcc-6.0.0 <stdin>:1:1:
error: unknown type name '__uint128_t'
/home/arnd/cross-gcc/bin/arm-linux-gnueabi-gcc-6.1.1 <stdin>:1:1:
error: unknown type name '__uint128_t'
/home/arnd/cross-gcc/bin/arm-linux-gnueabi-gcc-6.3.1 <stdin>:1:1:
error: unknown type name '__uint128_t'
/home/arnd/cross-gcc/bin/arm-linux-gnueabi-gcc-7.0.0 <stdin>:1:1:
error: unknown type name '__uint128_t'; did you mean '__int128'?
/home/arnd/cross-gcc/bin/arm-linux-gnueabi-gcc-7.0.1 <stdin>:1:1:
error: unknown type name '__uint128_t'; did you mean '__int128'?
/home/arnd/cross-gcc/bin/arm-linux-gnueabi-gcc-7.1.1 <stdin>:1:1:
error: unknown type name '__uint128_t'; did you mean '__int128'?
/home/arnd/cross-gcc/bin/arm-linux-gnueabi-gcc-7.2.1 <stdin>:1:1:
error: unknown type name '__uint128_t'; did you mean '__int128'?
/home/arnd/cross-gcc/bin/arm-linux-gnueabi-gcc-8.0.0 <stdin>:1:1:
error: unknown type name '__uint128_t'; did you mean '__int128'?
/home/arnd/cross-gcc/bin/bfin-uclinux-gcc-7.0.0
bfin-uclinux-gcc-7.0.0: error trying to exec 'cc1': execvp: No such
file or directory
/home/arnd/cross-gcc/bin/bfin-uclinux-gcc-7.2.1 <stdin>:1:1: error:
unknown type name '__uint128_t'; did you mean '__int128'?
/home/arnd/cross-gcc/bin/c6x-elf-gcc-7.2.1 <stdin>:1:1: error: unknown
type name '__uint128_t'; did you mean '__int128'?
/home/arnd/cross-gcc/bin/cris-linux-gcc-4.1.3 <stdin>:1: error:
expected '=', ',', ';', 'asm' or '__attribute__' before 'v'
/home/arnd/cross-gcc/bin/cris-linux-gcc-4.3.6 <stdin>:1: error:
expected '=', ',', ';', 'asm' or '__attribute__' before 'v'
/home/arnd/cross-gcc/bin/cris-linux-gcc-4.9.3 <stdin>:1:1: error:
unknown type name '__uint128_t'
/home/arnd/cross-gcc/bin/cris-linux-gcc-7.2.1 <stdin>:1:1: error:
unknown type name '__uint128_t'; did you mean '__int128'?
/home/arnd/cross-gcc/bin/frv-linux-gcc-4.1.3 <stdin>:1: error:
expected '=', ',', ';', 'asm' or '__attribute__' before 'v'
/home/arnd/cross-gcc/bin/frv-linux-gcc-4.3.6 <stdin>:1: internal
compiler error: in default_secondary_reload, at targhooks.c:618
Please submit a full bug report,
with preprocessed source if appropriate.
See <http://gcc.gnu.org/bugs.html> for instructions.
/home/arnd/cross-gcc/bin/frv-linux-gcc-4.9.3 <stdin>:1:1: error:
unknown type name '__uint128_t'
/home/arnd/cross-gcc/bin/frv-linux-gcc-7.2.1 <stdin>:1:1: error:
unknown type name '__uint128_t'; did you mean '__int128'?
/home/arnd/cross-gcc/bin/h8300-linux-gcc-7.2.1 <stdin>:1:1: error:
unknown type name '__uint128_t'; did you mean '__int128'?
/home/arnd/cross-gcc/bin/hppa64-linux-gcc-4.9.3 <stdin>:1:1: error:
unknown type name '__uint128_t'
/home/arnd/cross-gcc/bin/hppa64-linux-gcc-7.2.1 <stdin>:1:1: error:
unknown type name '__uint128_t'; did you mean '__int128'?
/home/arnd/cross-gcc/bin/hppa-linux-gcc-4.1.3 <stdin>:1: error:
expected '=', ',', ';', 'asm' or '__attribute__' before 'v'
/home/arnd/cross-gcc/bin/hppa-linux-gcc-4.3.6 <stdin>:1: error:
expected '=', ',', ';', 'asm' or '__attribute__' before 'v'
/home/arnd/cross-gcc/bin/hppa-linux-gcc-4.9.3 <stdin>:1:1: error:
unknown type name '__uint128_t'
/home/arnd/cross-gcc/bin/hppa-linux-gcc-7.2.1 <stdin>:1:1: error:
unknown type name '__uint128_t'; did you mean '__int128'?
/home/arnd/cross-gcc/bin/i386-linux-gcc-4.9.3 <stdin>:1:1: error:
unknown type name '__uint128_t'
/home/arnd/cross-gcc/bin/i386-linux-gcc-7.2.1 <stdin>:1:1: error:
unknown type name '__uint128_t'; did you mean '__int128'?
/home/arnd/cross-gcc/bin/ia64-linux-gcc-7.2.1 ok
/home/arnd/cross-gcc/bin/m32r-linux-gcc-4.1.3 <stdin>:1: error:
expected '=', ',', ';', 'asm' or '__attribute__' before 'v'
/home/arnd/cross-gcc/bin/m32r-linux-gcc-4.3.6 <stdin>:1: error:
expected '=', ',', ';', 'asm' or '__attribute__' before 'v'
/home/arnd/cross-gcc/bin/m32r-linux-gcc-4.9.3 <stdin>:1:1: error:
unknown type name '__uint128_t'
/home/arnd/cross-gcc/bin/m32r-linux-gcc-7.2.1 <stdin>:1:1: error:
unknown type name '__uint128_t'; did you mean '__int128'?
/home/arnd/cross-gcc/bin/m68k-linux-gcc-4.1.3 <stdin>:1: error:
expected '=', ',', ';', 'asm' or '__attribute__' before 'v'
/home/arnd/cross-gcc/bin/m68k-linux-gcc-4.3.6 <stdin>:1: error:
expected '=', ',', ';', 'asm' or '__attribute__' before 'v'
/home/arnd/cross-gcc/bin/m68k-linux-gcc-6.0.0 <stdin>:1:1: error:
unknown type name '__uint128_t'
/home/arnd/cross-gcc/bin/m68k-linux-gcc-7.2.1 <stdin>:1:1: error:
unknown type name '__uint128_t'; did you mean '__int128'?
/home/arnd/cross-gcc/bin/microblaze-linux-gcc-4.9.3 <stdin>:1:1:
error: unknown type name '__uint128_t'
/home/arnd/cross-gcc/bin/microblaze-linux-gcc-7.2.1 <stdin>:1:1:
error: unknown type name '__uint128_t'; did you mean '__int128'?
/home/arnd/cross-gcc/bin/mips64-linux-gcc-4.9.3 ok
/home/arnd/cross-gcc/bin/mips64-linux-gcc-7.2.1 ok
/home/arnd/cross-gcc/bin/mips-linux-gcc-4.0.4 <stdin>:1: error: syntax
error before 'v'
<stdin>:1: warning: data definition has no type or storage class
/home/arnd/cross-gcc/bin/mips-linux-gcc-4.1.3 <stdin>:1: error:
expected '=', ',', ';', 'asm' or '__attribute__' before 'v'
/home/arnd/cross-gcc/bin/mips-linux-gcc-4.3.6 <stdin>:1: error:
expected '=', ',', ';', 'asm' or '__attribute__' before 'v'
/home/arnd/cross-gcc/bin/mips-linux-gcc-4.9.3 <stdin>:1:1: error:
unknown type name '__uint128_t'
/home/arnd/cross-gcc/bin/mips-linux-gcc-7.0.0 <stdin>:1:1: error:
unknown type name '__uint128_t'; did you mean '__int128'?
/home/arnd/cross-gcc/bin/mips-linux-gcc-7.0.1 <stdin>:1:1: error:
unknown type name '__uint128_t'; did you mean '__int128'?
/home/arnd/cross-gcc/bin/mips-linux-gcc-7.2.1 <stdin>:1:1: error:
unknown type name '__uint128_t'; did you mean '__int128'?
/home/arnd/cross-gcc/bin/nios2-linux-gcc-7.2.1 <stdin>:1:1: error:
unknown type name '__uint128_t'; did you mean '__int128'?
/home/arnd/cross-gcc/bin/parisc-linux-gcc-4.9.3 <stdin>:1:1: error:
unknown type name '__uint128_t'
/home/arnd/cross-gcc/bin/powerpc64-linux-gcc-4.1.3 ok
/home/arnd/cross-gcc/bin/powerpc64-linux-gcc-4.3.6 ok
/home/arnd/cross-gcc/bin/powerpc64-linux-gcc-4.9.3 ok
/home/arnd/cross-gcc/bin/powerpc64-linux-gcc-7.2.1 ok
/home/arnd/cross-gcc/bin/powerpc-linux-gcc-4.9.3 <stdin>:1:1: error:
unknown type name '__uint128_t'
/home/arnd/cross-gcc/bin/powerpc-linux-gcc-7.2.1 <stdin>:1:1: error:
unknown type name '__uint128_t'; did you mean '__int128'?
/home/arnd/cross-gcc/bin/riscv32-linux-gcc-7.2.1 <stdin>:1:1: error:
unknown type name '__uint128_t'; did you mean '__int128'?
/home/arnd/cross-gcc/bin/riscv64-linux-gcc-7.2.1 ok
/home/arnd/cross-gcc/bin/s390-linux-gcc-4.1.3 <stdin>:1: error:
expected '=', ',', ';', 'asm' or '__attribute__' before 'v'
/home/arnd/cross-gcc/bin/s390-linux-gcc-4.3.6 <stdin>:1: error:
expected '=', ',', ';', 'asm' or '__attribute__' before 'v'
/home/arnd/cross-gcc/bin/s390-linux-gcc-4.9.3 <stdin>:1:1: error:
unknown type name '__uint128_t'
/home/arnd/cross-gcc/bin/s390-linux-gcc-7.2.1 <stdin>:1:1: error:
unknown type name '__uint128_t'; did you mean '__int128'?
/home/arnd/cross-gcc/bin/sh2-linux-gcc-7.2.1 <stdin>:1:1: error:
unknown type name '__uint128_t'; did you mean '__int128'?
/home/arnd/cross-gcc/bin/sh3-linux-gcc-4.1.3 <stdin>:1: error:
expected '=', ',', ';', 'asm' or '__attribute__' before 'v'
/home/arnd/cross-gcc/bin/sh3-linux-gcc-4.3.6 <stdin>:1: error:
expected '=', ',', ';', 'asm' or '__attribute__' before 'v'
/home/arnd/cross-gcc/bin/sh3-linux-gcc-4.9.3 <stdin>:1:1: error:
unknown type name '__uint128_t'
/home/arnd/cross-gcc/bin/sh4-linux-gcc-7.2.1 <stdin>:1:1: error:
unknown type name '__uint128_t'; did you mean '__int128'?
/home/arnd/cross-gcc/bin/sh-linux-gcc-4.9.3 <stdin>:1:1: error:
unknown type name '__uint128_t'
/home/arnd/cross-gcc/bin/sparc64-linux-gcc-4.9.3 ok
/home/arnd/cross-gcc/bin/sparc64-linux-gcc-7.2.1 ok
/home/arnd/cross-gcc/bin/sparc-linux-gcc-4.1.3 <stdin>:1: error:
expected '=', ',', ';', 'asm' or '__attribute__' before 'v'
/home/arnd/cross-gcc/bin/sparc-linux-gcc-4.9.3 <stdin>:1:1: error:
unknown type name '__uint128_t'
/home/arnd/cross-gcc/bin/sparc-linux-gcc-7.2.1 <stdin>:1:1: error:
unknown type name '__uint128_t'; did you mean '__int128'?
/home/arnd/cross-gcc/bin/tilegx-linux-gcc-7.2.1 ok
/home/arnd/cross-gcc/bin/tilepro-linux-gcc-7.2.1 <stdin>:1:1: error:
unknown type name '__uint128_t'; did you mean '__int128'?
/home/arnd/cross-gcc/bin/x86_64-linux-gcc-3.4.6 ok
/home/arnd/cross-gcc/bin/x86_64-linux-gcc-4.0.4 ok
/home/arnd/cross-gcc/bin/x86_64-linux-gcc-4.1.3 ok
/home/arnd/cross-gcc/bin/x86_64-linux-gcc-4.2.5 ok
/home/arnd/cross-gcc/bin/x86_64-linux-gcc-4.3.6 ok
/home/arnd/cross-gcc/bin/x86_64-linux-gcc-4.4.7 ok
/home/arnd/cross-gcc/bin/x86_64-linux-gcc-4.5.4 ok
/home/arnd/cross-gcc/bin/x86_64-linux-gcc-4.6.4 ok
/home/arnd/cross-gcc/bin/x86_64-linux-gcc-4.7.4 ok
/home/arnd/cross-gcc/bin/x86_64-linux-gcc-4.8.5 ok
/home/arnd/cross-gcc/bin/x86_64-linux-gcc-4.9.3 ok
/home/arnd/cross-gcc/bin/x86_64-linux-gcc-4.9.4 ok
/home/arnd/cross-gcc/bin/x86_64-linux-gcc-5.4.1 ok
/home/arnd/cross-gcc/bin/x86_64-linux-gcc-5.5.0 ok
/home/arnd/cross-gcc/bin/x86_64-linux-gcc-6.1.1 ok
/home/arnd/cross-gcc/bin/x86_64-linux-gcc-6.3.1 ok
/home/arnd/cross-gcc/bin/x86_64-linux-gcc-7.0.0 ok
/home/arnd/cross-gcc/bin/x86_64-linux-gcc-7.0.1 ok
/home/arnd/cross-gcc/bin/x86_64-linux-gcc-7.1.1 ok
/home/arnd/cross-gcc/bin/x86_64-linux-gcc-7.2.1 ok
/home/arnd/cross-gcc/bin/x86_64-linux-gcc-8.0.0 ok
/home/arnd/cross-gcc/bin/xtensa-linux-gcc-4.1.3 <stdin>:1: error:
expected '=', ',', ';', 'asm' or '__attribute__' before 'v'
/home/arnd/cross-gcc/bin/xtensa-linux-gcc-4.9.3 <stdin>:1:1: error:
unknown type name '__uint128_t'
/home/arnd/cross-gcc/bin/xtensa-linux-gcc-7.2.1 <stdin>:1:1: error:
unknown type name '__uint128_t'; did you mean '__int128'?

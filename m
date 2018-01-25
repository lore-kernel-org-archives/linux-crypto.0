From: Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH RFC 0/3] API for 128-bit IO access
Date: Thu, 25 Jan 2018 14:59:34 +0100
Message-ID: <CAK8P3a1gn5KFur-Vs9wCW4odLyJ=WbWjcHb7bgEBgUjETG4VEA@mail.gmail.com>
References: <CAK8P3a3TEV7Uyo_oBcMz_GYEYTB+V5AhDgbOgCEW-+X1h7sXEg@mail.gmail.com>
 <20180125113843.vgv6kyp7qjd75qif@yury-thinkpad>
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
        Will Deacon <will.deacon@arm.com>,
        Je
To: Yury Norov <ynorov@caviumnetworks.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180125113843.vgv6kyp7qjd75qif@yury-thinkpad>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Thu, Jan 25, 2018 at 12:38 PM, Yury Norov <ynorov@caviumnetworks.com> wrote:
> On Wed, Jan 24, 2018 at 11:28:55AM +0100, Arnd Bergmann wrote:
>> On Wed, Jan 24, 2018 at 10:05 AM, Yury Norov <ynorov@caviumnetworks.com> wrote:

> Thanks for doing this test. Looking at this I realize that this is
> not the architecture feature but compiler feature. So if we add
> 128-bit interface, it would be reasonable to add it for all targets
> that compiled with toolchain supporting 128-bit accesses.
>
> There's already the option ARCH_SUPPORTS_INT128 that is enabled for
> x86_64 in arch/x86/Kconfig and conditionally enabled for arm64 in
> arch/arm64/Makefile:
> KBUILD_CFLAGS    += $(call cc-ifversion, -ge, 0500, -DCONFIG_ARCH_SUPPORTS_INT128)
>
> It is used in include/linux/math64.h and in lib/ubsan.c, not so wide.
>
> So I find things little messed. Crypto code ignores compilers' ability
> to operate with 128-bit numbers. Ubsan and math64 relies on compiler
> version (at least for arm64, and I doubt it would work correctly with clang).
> And now I introduce HAVE_128BIT_ACCESS with the same meaning for memory
> access.
>
> I think it's time to unify 128-bit code:
>  - enable CONFIG_ARCH_SUPPORTS_INT128 if compiler supports it, ie check
>    it like you do below;
>  - declare u128 as structure or typedef depending on ARCH_SUPPORTS_INT128
>    in generic include/linux/int128.h, as you suggest here;
>  - switch this series to ARCH_SUPPORTS_INT128.
>
> Does it sound reasonable?

The CONFIG_* symbol namespace should not be set dynamically. However, you
can define a symbol with another name, e.g. ARCH_SUPPORTS_INT128 (without
CONFIG_ prefix) in linux/compiler-gcc.h based on the version and BITS_PER_LONG.

         Arnd

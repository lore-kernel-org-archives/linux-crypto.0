From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: Re: [PATCH net-next v3 02/17] zinc: introduce minimal cryptography library
Date: Tue, 11 Sep 2018 12:08:56 +0200
Message-ID: <CAKv+Gu9nSeo4PFVrtjtqGQ32eqyxUp3xVCczZfu+dhFz5yLM0A@mail.gmail.com>
References: <20180911010838.8818-1-Jason@zx2c4.com> <20180911010838.8818-3-Jason@zx2c4.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "<netdev@vger.kernel.org>" <netdev@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Andy Lutomirski <luto@kernel.org>,
        Samuel Neves <sneves@dei.uc.pt>,
        Jean-Philippe Aumasson <jeanphilippe.aumasson@gmail.com>,
        "open list:HARDWARE RANDOM NUMBER GENERATOR CORE"
        <linux-crypto@vger.kernel.org>
To: "Jason A. Donenfeld" <Jason@zx2c4.com>
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20180911010838.8818-3-Jason@zx2c4.com>
Sender: netdev-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On 11 September 2018 at 03:08, Jason A. Donenfeld <Jason@zx2c4.com> wrote:
> Zinc stands for "Zinc Is Neat Crypto" or "Zinc as IN Crypto" or maybe
> just "Zx2c4's INsane Cryptolib." It's also short, easy to type, and
> plays nicely with the recent trend of naming crypto libraries after
> elements. The guiding principle is "don't overdo it". It's less of a
> library and more of a directory tree for organizing well-curated direct
> implementations of cryptography primitives.
>
> Zinc is a new cryptography API that is much more minimal and lower-level
> than the current one. It intends to complement it and provide a basis
> upon which the current crypto API might build, as the provider of
> software implementations of cryptographic primitives. It is motivated by
> three primary observations in crypto API design:
>
>   * Highly composable "cipher modes" and related abstractions from
>     90s cryptographers did not turn out to be as terrific an idea as
>     hoped, leading to a host of API misuse problems.
>
>   * Most programmers are afraid of crypto code, and so prefer to
>     integrate it into libraries in a highly abstracted manner, so as to
>     shield themselves from implementation details. Cryptographers, on
>     the other hand, prefer simple direct implementations, which they're
>     able to verify for high assurance and optimize in accordance with
>     their expertise.
>
>   * Overly abstracted and flexible cryptography APIs lead to a host of
>     dangerous problems and performance issues. The kernel is in the
>     business usually not of coming up with new uses of crypto, but
>     rather implementing various constructions, which means it essentially
>     needs a library of primitives, not a highly abstracted enterprise-ready
>     pluggable system, with a few particular exceptions.
>
> This last observation has seen itself play out several times over and
> over again within the kernel:
>
>   * The perennial move of actual primitives away from crypto/ and into
>     lib/, so that users can actually call these functions directly with
>     no overhead and without lots of allocations, function pointers,
>     string specifier parsing, and general clunkiness. For example:
>     sha256, chacha20, siphash, sha1, and so forth live in lib/ rather
>     than in crypto/. Zinc intends to stop the cluttering of lib/ and
>     introduce these direct primitives into their proper place, lib/zinc/.
>
>   * An abundance of misuse bugs with the present crypto API that have
>     been very unpleasant to clean up.
>
>   * A hesitance to even use cryptography, because of the overhead and
>     headaches involved in accessing the routines.
>
> Zinc goes in a rather different direction. Rather than providing a
> thoroughly designed and abstracted API, Zinc gives you simple functions,
> which implement some primitive, or some particular and specific
> construction of primitives. It is not dynamic in the least, though one
> could imagine implementing a complex dynamic dispatch mechanism (such as
> the current crypto API) on top of these basic functions. After all,
> dynamic dispatch is usually needed for applications with cipher agility,
> such as IPsec, dm-crypt, AF_ALG, and so forth, and the existing crypto
> API will continue to play that role. However, Zinc will provide a non-
> haphazard way of directly utilizing crypto routines in applications
> that do have neither the need nor desire for abstraction and dynamic
> dispatch.
>
> It also organizes the implementations in a simple, straight-forward,
> and direct manner, making it enjoyable and intuitive to work on.
> Rather than moving optimized assembly implementations into arch/, it
> keeps them all together in lib/zinc/, making it simple and obvious to
> compare and contrast what's happening. This is, notably, exactly what
> the lib/raid6/ tree does, and that seems to work out rather well. It's
> also the pattern of most successful crypto libraries. The architecture-
> specific glue-code is made a part of each translation unit, rather than
> being in a separate one, so that generic and architecture-optimized code
> are combined at compile-time, and incompatibility branches compiled out by
> the optimizer.
>
> All implementations have been extensively tested and fuzzed, and are
> selected for their quality, trustworthiness, and performance. Wherever
> possible and performant, formally verified implementations are used,
> such as those from HACL* [1] and Fiat-Crypto [2]. The routines also take
> special care to zero out secrets using memzero_explicit (and future work
> is planned to have gcc do this more reliably and performantly with
> compiler plugins). The performance of the selected implementations is
> state-of-the-art and unrivaled on a broad array of hardware, though of
> course we will continue to fine tune these to the hardware demands
> needed by kernel contributors. Each implementation also comes with
> extensive self-tests and crafted test vectors, pulled from various
> places such as Wycheproof [9].
>
> Regularity of function signatures is important, so that users can easily
> "guess" the name of the function they want. Though, individual
> primitives are oftentimes not trivially interchangeable, having been
> designed for different things and requiring different parameters and
> semantics, and so the function signatures they provide will directly
> reflect the realities of the primitives' usages, rather than hiding it
> behind (inevitably leaky) abstractions. Also, in contrast to the current
> crypto API, Zinc functions can work on stack buffers, and can be called
> with different keys, without requiring allocations or locking.
>
> SIMD is used automatically when available, though some routines may
> benefit from either having their SIMD disabled for particular
> invocations, or to have the SIMD initialization calls amortized over
> several invocations of the function, and so Zinc utilizes function
> signatures enabling that in conjunction with the recently introduced
> simd_context_t.
>
> More generally, Zinc provides function signatures that allow just what
> is required by the various callers. This isn't to say that users of the
> functions will be permitted to pollute the function semantics with weird
> particular needs, but we are trying very hard not to overdo it, and that
> means looking carefully at what's actually necessary, and doing just that,
> and not much more than that. Remember: practicality and cleanliness rather
> than over-zealous infrastructure.
>
> Zinc provides also an opening for the best implementers in academia to
> contribute their time and effort to the kernel, by being sufficiently
> simple and inviting. In discussing this commit with some of the best and
> brightest over the last few years, there are many who are eager to
> devote rare talent and energy to this effort.
>
> Following the merging of this, I expect for the primitives that
> currently exist in lib/ to work their way into lib/zinc/, after intense
> scrutiny of each implementation, potentially replacing them with either
> formally-verified implementations, or better studied and faster
> state-of-the-art implementations.
>
> Also following the merging of this, I expect for the old crypto API
> implementations to be ported over to use Zinc for their software-based
> implementations.
>
> As Zinc is simply library code, its config options are un-menued, with
> the exception of CONFIG_ZINC_DEBUG, which enables various selftests and
> BUG_ONs.
>

In spite of the wall of text, you fail to point out exactly why the
existing AEAD API in unsuitable, and why fixing it is not an option.

As I pointed out in a previous version, I don't think we need a
separate crypto API/library in the kernel, and I don't think you have
convinced anyone else yet either.

Perhaps you can devote /your/ rare talent and energy to improving what
we already have for everybody's sake, rather than providing a
completely separate crypto stack that only benefits WireGuard (unless
you yourself port the existing crypto API software algorithms to this
crypto stack first and present *that* work as a convincing case in
itself)

I won't go into the 1000s lines of generated assembly again - you
already know my position on that topic.

Please refrain from sending a v4 with just a couple of more tweaks on
top - these are fundamental issues that require discussion before
there is any chance of this being merged.


> [1] https://github.com/project-everest/hacl-star
> [2] https://github.com/mit-plv/fiat-crypto
> [3] https://cr.yp.to/ecdh.html
> [4] https://cr.yp.to/chacha.html
> [5] https://cr.yp.to/snuffle/xsalsa-20081128.pdf
> [6] https://cr.yp.to/mac.html
> [7] https://blake2.net/
> [8] https://tools.ietf.org/html/rfc8439
> [9] https://github.com/google/wycheproof
>
> Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>
> Cc: Andy Lutomirski <luto@kernel.org>
> Cc: Greg KH <gregkh@linuxfoundation.org>
> Cc: Samuel Neves <sneves@dei.uc.pt>
> Cc: Jean-Philippe Aumasson <jeanphilippe.aumasson@gmail.com>
> Cc: linux-crypto@vger.kernel.org
> ---
>  MAINTAINERS       |  8 ++++++++
>  lib/Kconfig       |  2 ++
>  lib/Makefile      |  2 ++
>  lib/zinc/Kconfig  | 20 ++++++++++++++++++++
>  lib/zinc/Makefile |  8 ++++++++
>  lib/zinc/main.c   | 31 +++++++++++++++++++++++++++++++
>  6 files changed, 71 insertions(+)
>  create mode 100644 lib/zinc/Kconfig
>  create mode 100644 lib/zinc/Makefile
>  create mode 100644 lib/zinc/main.c
>
> diff --git a/MAINTAINERS b/MAINTAINERS
> index 2ef884b883c3..d2092e52320d 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -16160,6 +16160,14 @@ Q:     https://patchwork.linuxtv.org/project/linux-media/list/
>  S:     Maintained
>  F:     drivers/media/dvb-frontends/zd1301_demod*
>
> +ZINC CRYPTOGRAPHY LIBRARY
> +M:     Jason A. Donenfeld <Jason@zx2c4.com>
> +M:     Samuel Neves <sneves@dei.uc.pt>
> +S:     Maintained
> +F:     lib/zinc/
> +F:     include/zinc/
> +L:     linux-crypto@vger.kernel.org
> +
>  ZPOOL COMPRESSED PAGE STORAGE API
>  M:     Dan Streetman <ddstreet@ieee.org>
>  L:     linux-mm@kvack.org
> diff --git a/lib/Kconfig b/lib/Kconfig
> index a3928d4438b5..3e6848269c66 100644
> --- a/lib/Kconfig
> +++ b/lib/Kconfig
> @@ -485,6 +485,8 @@ config GLOB_SELFTEST
>           module load) by a small amount, so you're welcome to play with
>           it, but you probably don't need it.
>
> +source "lib/zinc/Kconfig"
> +
>  #
>  # Netlink attribute parsing support is select'ed if needed
>  #
> diff --git a/lib/Makefile b/lib/Makefile
> index ca3f7ebb900d..3f16e35d2c11 100644
> --- a/lib/Makefile
> +++ b/lib/Makefile
> @@ -214,6 +214,8 @@ obj-$(CONFIG_PERCPU_TEST) += percpu_test.o
>
>  obj-$(CONFIG_ASN1) += asn1_decoder.o
>
> +obj-$(CONFIG_ZINC) += zinc/
> +
>  obj-$(CONFIG_FONT_SUPPORT) += fonts/
>
>  obj-$(CONFIG_PRIME_NUMBERS) += prime_numbers.o
> diff --git a/lib/zinc/Kconfig b/lib/zinc/Kconfig
> new file mode 100644
> index 000000000000..aa4f8d449d6b
> --- /dev/null
> +++ b/lib/zinc/Kconfig
> @@ -0,0 +1,20 @@
> +config ZINC
> +       tristate
> +       select CRYPTO_BLKCIPHER
> +       select VFP
> +       select VFPv3
> +       select NEON
> +       select KERNEL_MODE_NEON
> +
> +config ZINC_DEBUG
> +       bool "Zinc cryptography library debugging and self-tests"
> +       depends on ZINC
> +       help
> +         This builds a series of self-tests for the Zinc crypto library, which
> +         help diagnose any cryptographic algorithm implementation issues that
> +         might be at the root cause of potential bugs. It also adds various
> +         debugging traps.
> +
> +         Unless you're developing and testing cryptographic routines, or are
> +         especially paranoid about correctness on your hardware, you may say
> +         N here.
> diff --git a/lib/zinc/Makefile b/lib/zinc/Makefile
> new file mode 100644
> index 000000000000..dad47573de42
> --- /dev/null
> +++ b/lib/zinc/Makefile
> @@ -0,0 +1,8 @@
> +ccflags-y := -O3
> +ccflags-y += -Wframe-larger-than=8192
> +ccflags-y += -D'pr_fmt(fmt)=KBUILD_MODNAME ": " fmt'
> +ccflags-$(CONFIG_ZINC_DEBUG) += -DDEBUG
> +
> +zinc-y += main.o
> +
> +obj-$(CONFIG_ZINC) := zinc.o
> diff --git a/lib/zinc/main.c b/lib/zinc/main.c
> new file mode 100644
> index 000000000000..ceece33ff5a7
> --- /dev/null
> +++ b/lib/zinc/main.c
> @@ -0,0 +1,31 @@
> +/* SPDX-License-Identifier: GPL-2.0
> + *
> + * Copyright (C) 2015-2018 Jason A. Donenfeld <Jason@zx2c4.com>. All Rights Reserved.
> + */
> +
> +#include <linux/init.h>
> +#include <linux/module.h>
> +
> +#ifdef DEBUG
> +#define selftest(which) do { \
> +       if (!which ## _selftest()) \
> +               return -ENOTRECOVERABLE; \
> +} while (0)
> +#else
> +#define selftest(which)
> +#endif
> +
> +static int __init mod_init(void)
> +{
> +       return 0;
> +}
> +
> +static void __exit mod_exit(void)
> +{
> +}
> +
> +module_init(mod_init);
> +module_exit(mod_exit);
> +MODULE_LICENSE("GPL v2");
> +MODULE_DESCRIPTION("Zinc cryptography library");
> +MODULE_AUTHOR("Jason A. Donenfeld <Jason@zx2c4.com>");
> --
> 2.18.0
>

From: Eric Biggers <ebiggers3@gmail.com>
Subject: Re: [PATCH v1 2/3] zinc: Introduce minimal cryptography library
Date: Wed, 1 Aug 2018 00:22:46 -0700
Message-ID: <20180801072246.GA15677@sol.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, davem@davemloft.net,
        Andy Lutomirski <luto@kernel.org>,
        Greg KH <gregkh@linuxfoundation.org>,
        Samuel Neves <sneves@dei.uc.pt>,
        "D . J . Bernstein" <djb@cr.yp.to>,
        Tanja Lange <tanja@hyperelliptic.org>,
        Jean-Philippe Aumasson <jeanphilippe.aumasson@gmail.com>,
        Karthikeyan Bhargavan <karthik.bhargavan@gmail.com>
To: "Jason A. Donenfeld" <Jason@zx2c4.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

[+Cc linux-crypto]

Hi Jason,

Apologies for starting a new thread, but this patch apparently wasn't
Cc'ed to linux-crypto, despite adding over 24000 lines of crypto code.
So much for WireGuard being only 4000 lines :-)

(For anyone else like me who didn't receive the patch, it can be found at
https://patchwork.ozlabs.org/patch/951763/)

I have some preliminary comments below.

On Tue, 31 Jul 2018 21:11:01 +0200, Jason A. Donenfeld wrote:
> [PATCH v1 2/3] zinc: Introduce minimal cryptography library 
> 
> Zinc stands for "Zinc Is Not crypto/". It's also short, easy to type,
> and plays nicely with the recent trend of naming crypto libraries after
> elements. The guiding principle is "don't overdo it". It's less of a
> library and more of a directory tree for organizing well-curated direct
> implementations of cryptography primitives.
> 
> Zinc is a new cryptography API that is much more minimal and lower-level
> than the current one. It intends to complement it and provide a basis
> upon which the current crypto API might build, and perhaps someday Zinc
> may altogether supplant the current crypto API. It is motivated by
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
> that do have neither need nor desire for abstraction and dynamic
> dispatch.
> 
> It also organizes the implementations in a simple, straight-forward,
> and direct manner, making it enjoyable and intuitive to work on.
> Rather than moving optimized assembly implementations into arch/, it
> keeps them all together in lib/zinc/, making it simple and obvious to
> compare and contrast what's happening. This is, notably, exactly what
> the lib/raid6/ tree does, and that seems to work out rather well. It's
> also the pattern of most successful crypto libraries. Likewise, the
> cascade of architecture-specific functions is done as ifdefs within one
> file, so that it's easy and obvious and clear what's happening, how each
> architecture differs, and how to optimize for shared patterns. This is
> very much preferable to architecture-specific file splitting.
> 
> All implementations have been extensively tested and fuzzed, and are
> selected for their quality, trustworthiness, and performance. Wherever
> possible and performant, formally verified implementations are used,
> such as those from HACL* [1] and Fiat-Crypto [2]. The routines also take
> special care to zero out secrets using memzero_explicit (and future work
> is planned to have gcc do this more reliably and performantly with
> compiler plugins). The performance of the selected implementations is
> state-of-the-art and unrivaled. Each implementation also comes with
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
> several invocations of the function, and so Zinc provides helpers and
> function signatures enabling that.
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
> This initial commit adds implementations of the primitives used by WireGuard:
> 
>   * Curve25519 [3]: formally verified 64-bit C, formally verified 32-bit C,
>     x86_64 BMI2, x86_64 ADX, ARM NEON.
> 
>   * ChaCha20 [4]: generic C, x86_64 SSSE3, x86_64 AVX-2, x86_64 AVX-512F,
>     x86_64 AVX-512VL, ARM NEON, ARM64 NEON, MIPS.
> 
>   * HChaCha20 [5]: generic C, x86_64 SSSE3.
> 
>   * Poly1305 [6]: generic C, x86_64, x86_64 AVX, x86_64 AVX-2, x86_64
>     AVX-512F, ARM NEON, ARM64 NEON, MIPS, MIPS64.
> 
>   * BLAKE2s [7]: generic C, x86_64 AVX, x86_64 AVX-512VL.
> 
>   * ChaCha20Poly1305 [8]: generic C construction for both full buffers and
>     scatter gather.
> 
>   * XChaCha20Poly1305 [5]: generic C construction.
> 
> Following the merging of this, I expect for first the primitives that
> currently exist in lib/ to work their way into lib/zinc/, after intense
> scrutiny of each implementation, potentially replacing them with either
> formally-verified implementations, or better studied and faster
> state-of-the-art implementations. In a phase after that, I envision that
> certain instances from crypto/ will want to rebase themselves to simply
> be abstracted crypto API wrappers using the lower level Zinc functions.
> This is already what various crypto/ implementations do with the
> existing code in lib/.
> 
> Currently Zinc exists as a single un-menued option, CONFIG_ZINC, but as
> this grows we will inevitably want to make that more granular. This will
> happen at the appropriate time, rather than doing so prematurely. There
> also is a CONFIG_ZINC_DEBUG menued option, performing several intense
> tests at startup and enabling various BUG_ONs.
> 
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
> Cc: D. J. Bernstein <djb@cr.yp.to>
> Cc: Tanja Lange <tanja@hyperelliptic.org>
> Cc: Jean-Philippe Aumasson <jeanphilippe.aumasson@gmail.com>
> Cc: Karthikeyan Bhargavan <karthik.bhargavan@gmail.com>
> ---
>  MAINTAINERS                             |    7 +
>  include/zinc/blake2s.h                  |   94 +
>  include/zinc/chacha20.h                 |   46 +
>  include/zinc/chacha20poly1305.h         |   51 +
>  include/zinc/curve25519.h               |   25 +
>  include/zinc/poly1305.h                 |   34 +
>  include/zinc/simd.h                     |   60 +
>  lib/Kconfig                             |   21 +
>  lib/Makefile                            |    2 +
>  lib/zinc/Makefile                       |   28 +
>  lib/zinc/blake2s/blake2s-x86_64.S       |  685 ++++++
>  lib/zinc/blake2s/blake2s.c              |  292 +++
>  lib/zinc/chacha20/chacha20-arm.S        | 1471 ++++++++++++
>  lib/zinc/chacha20/chacha20-arm64.S      | 1940 ++++++++++++++++
>  lib/zinc/chacha20/chacha20-mips.S       |  474 ++++
>  lib/zinc/chacha20/chacha20-x86_64.S     | 2630 +++++++++++++++++++++
>  lib/zinc/chacha20/chacha20.c            |  242 ++
>  lib/zinc/chacha20poly1305.c             |  286 +++
>  lib/zinc/curve25519/curve25519-arm.S    | 2110 +++++++++++++++++
>  lib/zinc/curve25519/curve25519-arm.h    |   14 +
>  lib/zinc/curve25519/curve25519-fiat32.h |  838 +++++++
>  lib/zinc/curve25519/curve25519-hacl64.h |  751 ++++++
>  lib/zinc/curve25519/curve25519-x86_64.h | 2060 +++++++++++++++++
>  lib/zinc/curve25519/curve25519.c        |   86 +
>  lib/zinc/main.c                         |   36 +
>  lib/zinc/poly1305/poly1305-arm.S        | 1115 +++++++++
>  lib/zinc/poly1305/poly1305-arm64.S      |  820 +++++++
>  lib/zinc/poly1305/poly1305-mips.S       |  417 ++++
>  lib/zinc/poly1305/poly1305-mips64.S     |  357 +++
>  lib/zinc/poly1305/poly1305-x86_64.S     | 2790 +++++++++++++++++++++++
>  lib/zinc/poly1305/poly1305.c            |  377 +++
>  lib/zinc/selftest/blake2s.h             |  559 +++++
>  lib/zinc/selftest/chacha20poly1305.h    | 1559 +++++++++++++
>  lib/zinc/selftest/curve25519.h          |  607 +++++
>  lib/zinc/selftest/poly1305.h            | 1568 +++++++++++++
>  35 files changed, 24452 insertions(+)
>  create mode 100644 include/zinc/blake2s.h
>  create mode 100644 include/zinc/chacha20.h
>  create mode 100644 include/zinc/chacha20poly1305.h
>  create mode 100644 include/zinc/curve25519.h
>  create mode 100644 include/zinc/poly1305.h
>  create mode 100644 include/zinc/simd.h
>  create mode 100644 lib/zinc/Makefile
>  create mode 100644 lib/zinc/blake2s/blake2s-x86_64.S
>  create mode 100644 lib/zinc/blake2s/blake2s.c
>  create mode 100644 lib/zinc/chacha20/chacha20-arm.S
>  create mode 100644 lib/zinc/chacha20/chacha20-arm64.S
>  create mode 100644 lib/zinc/chacha20/chacha20-mips.S
>  create mode 100644 lib/zinc/chacha20/chacha20-x86_64.S
>  create mode 100644 lib/zinc/chacha20/chacha20.c
>  create mode 100644 lib/zinc/chacha20poly1305.c
>  create mode 100644 lib/zinc/curve25519/curve25519-arm.S
>  create mode 100644 lib/zinc/curve25519/curve25519-arm.h
>  create mode 100644 lib/zinc/curve25519/curve25519-fiat32.h
>  create mode 100644 lib/zinc/curve25519/curve25519-hacl64.h
>  create mode 100644 lib/zinc/curve25519/curve25519-x86_64.h
>  create mode 100644 lib/zinc/curve25519/curve25519.c
>  create mode 100644 lib/zinc/main.c
>  create mode 100644 lib/zinc/poly1305/poly1305-arm.S
>  create mode 100644 lib/zinc/poly1305/poly1305-arm64.S
>  create mode 100644 lib/zinc/poly1305/poly1305-mips.S
>  create mode 100644 lib/zinc/poly1305/poly1305-mips64.S
>  create mode 100644 lib/zinc/poly1305/poly1305-x86_64.S
>  create mode 100644 lib/zinc/poly1305/poly1305.c
>  create mode 100644 lib/zinc/selftest/blake2s.h
>  create mode 100644 lib/zinc/selftest/chacha20poly1305.h
>  create mode 100644 lib/zinc/selftest/curve25519.h
>  create mode 100644 lib/zinc/selftest/poly1305.h
[...]

In general this is great work, and I'm very excited for WireGuard to be
upstreamed!  But for the new crypto code, I think a few things are on
the wrong track, for example treating it is a special library.  Even the
name is contradicting itself: Zinc is "not crypto/", yet as you stated
it's intended that the "Zinc" algorithms will be exposed through the
crypto API -- just like how most of the existing crypto code in lib/ is
also exposed through the crypto API.  So, I think that what you're doing
isn't actually *that* different from what already exists in some cases;
and pretending that it is very different is just going to cause
problems.  Rather, the actual truly new thing seems to be that the
dispatch to architecture specific implementations is done at the lib/
level instead of handled by the crypto API priority numbers.

So, I don't see why you don't just add lib/blake2s/, lib/chacha20/,
lib/poly1305/, etc., without pretending that they all have some special
new "Zinc" thing in common and are part of some holy crusade against the
crypto API.

They could even still go in subdirectory lib/crypto/ -- but just for
logical code organization purposes, as opposed to a special library with
a name that isn't self-explanatory and sounds like some third-party
library rather than first-class kernel code.

CONFIG_ZINC also needs to go.  Algorithms will need to be independently
configurable as soon as anything other than WireGuard needs to use any
of them, so you might as well do it right from the start with
CONFIG_BLAKE2, CONFIG_CHACHA20, CONFIG_POLY1305, etc.

I think the above changes would also naturally lead to a much saner
patch series where each algorithm is added by its own patch, rather than
one monster patch that adds many algorithms and 24000 lines of code.

Note that adding all the algorithms in one patch also makes the
description of them conflated, e.g. you wrote that "formally verified"
implementations were used whenever possible, but AFAICS that actually
only applies to the C implementations of Curve25519, and even those have
your copyright statement so presumably you had to change something from
the "formally verified" code :-).  Note also that Poly1305
implementations are somewhat error-prone, since there can be overflow
bugs that are extremely rarely hit; see e.g. how OpenSSL's Poly1305 NEON
implementation was initially buggy and had to be fixed:
https://mta.openssl.org/pipermail/openssl-commits/2016-April/006639.html.
Not to mention that C glue code is error-prone, especially with the tons
of #ifdefs.  So, I'd strongly prefer that you don't oversell the crypto
code you're adding, e.g. by implying that most of it is formally
verified, as it likely still has bugs, like any other code...

I also want to compare the performance of some of the assembly
implementations you're adding to the existing implementations in the
kernel they duplicate.  I'm especially interested in the NEON
implementation of ChaCha20.  But adding 11 implementations in one single
patch means there isn't really a chance to comment on them individually.

Also, earlier when I tested OpenSSL's ChaCha NEON implementation on ARM
Cortex-A7 it was actually quite a bit slower than the one in the Linux
kernel written by Ard Biesheuvel... I trust that when claiming the
performance of all implementations you're adding is "state-of-the-art
and unrivaled", you actually compared them to the ones already in the
Linux kernel which you're advocating replacing, right? :-)

Your patch description is also missing any mention of crypto accelerator
hardware.  Quite a bit of the complexity in the crypto API, such as
scatterlist support and asynchronous execution, exists because it
supports crypto accelerators.  AFAICS your new APIs cannot support
crypto accelerators, as your APIs are synchronous and operate on virtual
addresses.  I assume your justification is that "djb algorithms" like
ChaCha and Poly1305 don't need crypto accelerators as they are fast in
software.  But you never explicitly stated this and discussed the
tradeoffs.  Since this is basically the foundation for the design you've
chosen, it really needs to be addressed.

As for doing the architecture-specific dispatch in lib/ rather than
through the crypto API, there definitely are some arguments in favor of
it.  The main problem, though, is that your code is a mess due to all
the #ifdefs, and it will only get worse as people add more
architectures.  You may think you already added all the architectures
that matter, but tomorrow people will come and want to add PowerPC,
RISC-V, etc.  I really think you should consider splitting up
implementations by architecture; this would *not*, however, preclude the
implementations from still being accessed through a single top-level
"glue" function.  For example chacha20() could look like:

void chacha20(struct chacha20_ctx *state, u8 *dst, const u8 *src, u32 len,
	      bool have_simd)
{
	if (chacha20_arch(dst, src, len, state->key, state->counter, have_simd))
		goto out;

	chacha20_generic(dst, src, len, state->key, state->counter);

out:
	state->counter[0] += (len + 63) / 64;
}

So, each architecture would optionally define its own chacha20_arch()
that returns true if the data was processed, or false if not.  (The data
wouldn't be processed if, for example, 'have_simd' was false but only
SIMD implementations are available; or if the input was too short for an
SIMD implementation to be faster than the generic one.)  Note that this
would make the code much more consistent with the usual Linux kernel
coding style, which strongly prefers calling functions unconditionally
rather than having core logic littered with unmaintainable #ifdefs.

I'd also strongly prefer the patchset to include converting the crypto
API versions of ChaCha20 and Poly1305 over to use your new lib/ code, to
show that it's really possible.  You mentioned that it's planned, but if
it's not done right away there will be things that were missed and will
require changes when someone finally does it.  IMO it's not acceptable
to add your own completely separate ChaCha20 and Poly1305 just because
you don't like that the existing ones are part of the crypto API.  You
need to refactor things properly.  I think you'd need to expose the new
code under a cra_driver_name like "chacha20-software" and
"poly1305-software" to reflect that they use the fastest available
implementation of the algorithm on the CPU, e.g. "chacha20-generic",
"chacha20-neon", and "chacha20-simd" would all be replaced by a single
"chacha20-software".  Is that what you had in mind?

I'm also wondering about the origin and licensing of some of the
assembly language files.  Many have an OpenSSL copyright statement.
But, the OpenSSL license is often thought to be incompatible with GPL,
so using OpenSSL assembly code in the kernel has in the past required
getting special permission from Andy Polyakov (the person who's written
most of OpenSSL's assembly code so holds the copyright on it).  As one
example, see arch/arm/crypto/sha256-armv4.pl: the file explicitly states
that Andy has relicensed it under GPLv2.  For your new OpenSSL-derived
files, have you gone through and explicitly gotten GPLv2 permission from
Andy / the copyright holders?

Each assembly language file should also explicitly state where it came
from.  For example lib/zinc/curve25519/curve25519-arm.S has your
copyright statement and says it's "Based on algorithms from Daniel J.
Bernstein and Peter Schwabe.", but it's not clarified whether the *code*
was written by those other people, as opposed to those people designing
the *algorithms* and then you writing the code; and if you didn't write
it, where you retrieved the file from and when, what license it had
(even if it was "public domain" like some of djb's code, this should be
mentioned for informational purposes), and what changes you made if any.

Oh, and please use 80-character lines like the rest of the kernel, so
that people's eyes don't bleed when reading your code :-)

Thanks for all your hard work on WireGuard!

- Eric

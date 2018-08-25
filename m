From: Eric Biggers <ebiggers@kernel.org>
Subject: Re: [PATCH v2 02/17] zinc: introduce minimal cryptography library
Date: Fri, 24 Aug 2018 23:29:52 -0700
Message-ID: <20180825062951.GC726@sol.localdomain>
References: <20180824213849.23647-1-Jason@zx2c4.com>
 <20180824213849.23647-3-Jason@zx2c4.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        davem@davemloft.net, Andy Lutomirski <luto@kernel.org>,
        Greg KH <gregkh@linuxfoundation.org>,
        Samuel Neves <sneves@dei.uc.pt>,
        Jean-Philippe Aumasson <jeanphilippe.aumasson@gmail.com>,
        linux-crypto@vger.kernel.org
To: "Jason A. Donenfeld" <Jason@zx2c4.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20180824213849.23647-3-Jason@zx2c4.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Hi Jason,

On Fri, Aug 24, 2018 at 03:38:34PM -0600, Jason A. Donenfeld wrote:
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

I think the crypto portion of the patchset is looking *slightly* better from v1.
(Thanks for getting rid of the #ifdef mazes!)  But here are some more comments,
with the caveat that I haven't really reviewed any actual implementations yet,
and it's a *lot* of new code so this is really just scratching the surface...:

I thought you were going to wrap lines at 80 characters?  It's hard to read the
extremely long lines, and they encourage deep nesting.

As I said before, I still think you need to switch the crypto API ChaCha20 and
Poly1305 over to use the new implementations.  It's not okay to have two
completely different sets of ChaCha20 and Poly1305 implementations just because
you want a different API, so you might as well get started on it...  The thing
is that before you try it, it's not clear what problems will come up that
require changes to the design.  So, this really ought to be addressed up-front.

It's also not clearly explained whether/why/how the new ChaCha20 and Poly1305
implementations are better than the existing ones.  The patch adding the ARM and
ARM64 ChaCha, for example, just says who wrote them, with no mention of why the
particular implementations were chosen.

You've also documented a lot of stuff in commit messages which will be lost as
it isn't being added to the source itself.  There are various examples of this,
such as information about where the various implementations came from, what you
changed, why a particular implementation isn't used on Skylake or whatever, etc.
Can you please make sure that any important information is in comments, e.g. at
the top of the files?  There maybe should even be a Documentation/ file for
"Zinc", rather than only a long commit message.

I still think the "Zinc" name is confusing and misleading, and people are going
to forget that it means "crypto".  lib/crypto/ would be more intuitive.
But I don't care *that* much myself, and you should see what others think...

It seems you still don't explicitly clarify anywhere in the source itself that
the copyright holders of the code from OpenSSL have relicensed it under GPLv2.
I only see a GPLv2 license slapped on the files, yet no such license is presence
in the OpenSSL originals, at least in the one I checked.  If you did receive
explicit permission, then you should include an explicit clarification in each
file like the one in arch/arm/crypto/sha1-armv4-large.S.  Otherwise people will
be confused and come asking about the license status.

As Ard and I discussed recently on my patch
"crypto: arm/poly1305 - add NEON accelerated Poly1305 implementation"
which proposed adding the exact same poly1305-arm.S file, for all the OpenSSL
assembly it would probably be better to include the .pl file and generate the .S
file as part of the build process.  For one, there is semantic information like
register names in the .pl script that is lost in the .S file, thereby making the
.S file less readable.

There are still some alignment bugs where integers are loaded from byte arrays
without using the unaligned access macros, e.g. in chacha20_init(),
hchacha20_generic(), and fe_frombytes_impl().  I found these grepping for
le32_to_cpu.  Interestingly, that last one is in "formally verified" code :-)

Thanks!

Eric

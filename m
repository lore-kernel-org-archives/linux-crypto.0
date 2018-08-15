From: Eric Biggers <ebiggers@kernel.org>
Subject: Re: [PATCH v1 2/3] zinc: Introduce minimal cryptography library
Date: Wed, 15 Aug 2018 12:57:33 -0700
Message-ID: <20180815195732.GA79500@gmail.com>
References: <20180801072246.GA15677@sol.localdomain>
 <CAHmME9pbwj0RaX4YM9epGOSgDRNUt=GA4UzO_iKcW=Md7kG6JQ@mail.gmail.com>
 <20180814211229.GB24575@gmail.com>
 <20180815162819.22765.qmail@cr.yp.to>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "Jason A. Donenfeld" <Jason@zx2c4.com>,
        Eric Biggers <ebiggers3@gmail.com>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Netdev <netdev@vger.kernel.org>,
        David Miller <davem@davemloft.net>,
        Andrew Lutomirski <luto@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Samuel Neves <sneves@dei.uc.pt>,
        Tanja Lange <tanja@hyperelliptic.org>,
        Jean-Philippe Aumasson <jeanphilippe.aumasson@gmail.com>,
        Karthikeyan Bhargavan <karthik.bhargavan@gmail.com>
To: "D. J. Bernstein" <djb@cr.yp.to>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20180815162819.22765.qmail@cr.yp.to>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Wed, Aug 15, 2018 at 04:28:19PM -0000, D. J. Bernstein wrote:
> Eric Biggers writes:
> > I've also written a scalar ChaCha20 implementation (no NEON instructions!) that
> > is 12.2 cpb on one block at a time on Cortex-A7, taking advantage of the free
> > rotates; that would be useful for the single permutation used to compute
> > XChaCha's subkey, and also for the ends of messages.
> 
> This is also how ends of messages are handled in the 2012 implementation
> crypto_stream/salsa20/armneon6 (see "mainloop1") inside the SUPERCOP
> benchmarking framework:
> 
>    https://bench.cr.yp.to/supercop.html
> 
> This code is marginally different from Eric's new code because the
> occasional loads and stores are scheduled for the Cortex-A8 rather than
> the Cortex-A7, and because it's Salsa20 rather than ChaCha20.
> 
> The bigger picture is that there are 63 implementations of Salsa20 and
> ChaCha20 in SUPERCOP from 10 authors showing various implementation
> techniques, including all the techniques that have been mentioned in
> this thread; and centralized benchmarks on (e.g.)
> 
>    https://bench.cr.yp.to/results-stream.html#amd64-kizomba
>    https://bench.cr.yp.to/web-impl/amd64-kizomba-crypto_stream-salsa20.html
> 
> showing what's fastest on various platforms, using well-developed
> benchmarking tools that produce repeatable, meaningful measurements.
> There are also various papers explaining the main techniques.
> 
> Of course it's possible that new code will do better, especially on
> platforms with different performance characteristics from the platforms
> previously targeted. Contributing new implementations to SUPERCOP is
> easy---which is why SUPERCOP already has thousands of implementations of
> hundreds of cryptographic functions---and is a more effective way to
> advertise speedups than adding code merely to (e.g.) the Linux kernel.
> Infrastructure is centralized in SUPERCOP to minimize per-implementation
> work. There's no risk of being rejected on the basis of cryptographic
> concerns (MD5, Speck, and RSA-512 are included in the benchmarks) or
> code-style concerns. Users can then decide which implementations best
> meet their requirements.
> 
> "Do better" seems to be what's happened for the Cortex-A7. The best
> SUPERCOP speeds (from code targeting the Cortex-A8 etc.) are 13.42
> cycles/byte for 4096 bytes for ChaCha20; 12.2, 11.9, and 11.3 sound
> noticeably better. The Cortex-A7 is an interesting case because it's
> simultaneously (1) widely deployed---more than a billion units sold---
> but (2) poorly documented. If you want to know, e.g., which instructions
> can dual-issue with loads/FPU moves/..., then you won't be able to find
> anything from ARM giving the answer. I've started building an automated
> tool to compute the full CPU pipeline structure from benchmarks, but
> this isn't ready yet.
> 

Hi Dan, are you saying I should contribute my scalar ChaCha implementation,
and/or the Linux kernel's ChaCha NEON implementation, to SUPERCOP?  Just a few
comments: there doesn't appear to be an official git repository for SUPERCOP,
nor is there any mention of how to send patches, nor is there any COPYING or
LICENSE file, nor even a README file.  So, while I'm interested, from my
perspective SUPERCOP doesn't seem friendly to contributions.  You'd probably
attract more contributors if you followed established open source conventions.

Another issue is that the ChaCha code in SUPERCOP is duplicated for each number
of rounds: 8, 12, and 20.  So if anyone adds a new ChaCha implementation, they'd
apparently have to add 3 copies of it, which isn't very maintainable.

There are actually only two ARM NEON implementations of ChaCha20 in SUPERCOP:
(1) the one in crypto_stream/chacha20/moon/neon/32/chacha.S which looks like an
'objdump' output as it has no comments or anything that would make it readable
like macros and register aliases; and (2) the one in
crypto_stream/chacha20/dolbeau/arm-neon/, which uses a method similar to the
Linux implementation but it uses GCC intrinsics, so its performance will heavily
depend on how the compiler assigns and spills registers, which can vary greatly
depending on the compiler version and options.

I understand that Salsa20 is similar to ChaCha, and that ideas from Salsa20
implementations often apply to ChaCha too.  But it's not always obvious what
carries over and what doesn't; the rotation amounts can matter a lot, for
example, as different rotations can be implemented in different ways.  Nor is it
always obvious which ideas from SSE2 or AVX2 implementations (for example) carry
over to NEON implementations, as these instruction sets are different enough
that each has its own unique quirks and optimizations.

Previously I also found that OpenSSL's ARM NEON implementation of Poly1305 is
much faster than the implementations in SUPERCOP, as well as more
understandable.  (I don't know the 'qhasm' language, for example.)  So from my
perspective, I've had more luck with OpenSSL than SUPERCOP when looking for fast
implementations of crypto algorithms.  Have you considered adding the OpenSSL
implementations to SUPERCOP?

In the end though, both Linux and OpenSSL don't need every implementation under
the sun, but rather a small number of implementations that provide "good"
performance on nearly all CPUs, while not necessarily being optimal on every CPU
out there.  I.e., some tradeoffs are necessary and acceptable.  So for
ChaCha{12,20} on ARM we should choose which 2-3 implementations are most
valuable to have and make them as generally well optimized as possible.  Based
on the research I've seen and done, I think they're likely to be:

	- a 1x_scalar implementation
	- a 3x_NEON+1x_scalar implementation like OpenSSL's
	- a 4x_NEON implementation like Linux's current one

Currently my main argument is just that having the 3x_NEON+1x_scalar method be
the only NEON implementation is probably insufficient, as there are important
CPUs where the 4x_NEON method is significantly faster.

Thanks,

Eric

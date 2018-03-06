From: Eric Biggers <ebiggers3@gmail.com>
Subject: Re: [RESEND PATCH v3] crypto: add zBeWalgo compression for zram
Date: Tue, 6 Mar 2018 14:13:42 -0800
Message-ID: <20180306221342.GA178079@gmail.com>
References: <A4A8A981-9668-4F3F-B718-8F05B0506074@informatik.uni-hamburg.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        linux-kernel@vger.kernel.org, herbert@gondor.apana.org.au,
        davem@davemloft.net, minchan@kernel.org, ngupta@vflare.org,
        sergey.senozhatsky.work@gmail.com
To: Benjamin Warnke <4bwarnke@informatik.uni-hamburg.de>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <A4A8A981-9668-4F3F-B718-8F05B0506074@informatik.uni-hamburg.de>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Hi Benjamin,

On Tue, Mar 06, 2018 at 09:23:08PM +0100, Benjamin Warnke wrote:
> Currently ZRAM uses compression-algorithms from the crypto-api. ZRAM
> compresses each page individually. As a result the compression algorithm is
> forced to use a very small sliding window. None of the available compression
> algorithms is designed to achieve high compression ratios with small inputs.
> 
> This patch adds a new compression algorithm 'zBeWalgo' to the crypto api. This
> algorithm focusses on increasing the capacity of the compressed block-device
> created by ZRAM. The choice of compression algorithms is always a tradeoff
> between speed and compression ratio.
> 
[...]
> 
> Zstd is not in the list of compared algorithms, because it is not available
> for Zram in the currently available kernel trees.
>

This still isn't a valid excuse for not comparing it to Zstandard.  Zstandard is
already in the kernel in lib/.  It would only need glue code to wire it up as an
scomp_alg to the crypto API.  In contrast you're proposing an entirely new
algorithm.  Ultimately, by proposing a new algorithm you're on the hook to
demonstrate that existing algorithms aren't good enough.  Note that many of the
existing algorithms including Zstandard also have multiple compression levels
available to choose from.

It's also rare to add a compression or encryption algorithm to the Linux kernel
that isn't already used somewhere else.  Have you at least written a formal
specification of the 'zBeWalgo' data format?  Zstandard, for example, had a
well-tested and optimized userspace library and a specification of the data
format before it was added to the kernel.  And even before that it took a couple
years of development to stabilize the Zstandard data format.

Now, it's true that you don't strictly need a stable data format if the
algorithm will only ever be used for RAM compression.  But, if you want to take
that shortcut, then you're on the hook to justify it, and perhaps to enlighten
the crypto API about algorithms that don't have a stable data format (e.g. using
a new CRYPTO_ALG_* flag) so that users have to more explicitly opt-in to using
them.

You cannot just ignore fuzz-safety in the decompressor either.  The existing
decompressors exposed through the crypto API are fuzz-safe, so it's not valid to
compare an unsafe decompressor to them.  If you really do want to add an unsafe
decompressor then you'd likely need to look into adding crypto API support for
users to request unsafe decompression -- which could also be used to expose the
unsafe version of the LZ4 decompressor (LZ4_decompress_fast() instead of
LZ4_decompress_safe()).  Or if you do make the decompressor safe, then of course
you'd actually need to fuzz it; I suggest porting the code to userspace and
running american fuzzy lop (afl-fuzz) on it: http://lcamtuf.coredump.cx/afl/

Separately, given that this is a brand new algorithm and it seems to have
various corner cases, it would be a good idea to demonstrate a higher guarantee
of the correctness of the compression-decompression round trip.  afl-fuzz can be
good for that too: you could port the code to userspace and write a simple
program which compresses and decompresses a file and aborts if it was corrupted.
Then by passing the program to afl-fuzz it will eventually cover most of the
compressor and decompressor.  I've done that when testing compression code in
the past.

Hope this is helpful!

Eric

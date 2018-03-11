From: Eric Biggers <ebiggers3@gmail.com>
Subject: Re: [RESEND PATCH v3] crypto: add zBeWalgo compression for zram
Date: Sun, 11 Mar 2018 12:58:35 -0700
Message-ID: <20180311195835.GB630@zzz.localdomain>
References: <A4A8A981-9668-4F3F-B718-8F05B0506074@informatik.uni-hamburg.de>
 <20180306221342.GA178079@gmail.com>
 <16D8CBDD-CE09-49A5-86A1-1176847EDD71@informatik.uni-hamburg.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        linux-kernel@vger.kernel.org, herbert@gondor.apana.org.au,
        davem@davemloft.net, minchan@kernel.org, ngupta@vflare.org,
        sergey.senozhatsky.work@gmail.com
To: Benjamin Warnke <4bwarnke@informatik.uni-hamburg.de>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <16D8CBDD-CE09-49A5-86A1-1176847EDD71@informatik.uni-hamburg.de>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Hi Benjamin,

On Wed, Mar 07, 2018 at 12:50:08PM +0100, Benjamin Warnke wrote:
> Hi Eric,
> 
> 
> On 06.03.2018 at 23:13, Eric Biggers wrote:
> > 
> > Hi Benjamin,
> > 
> > On Tue, Mar 06, 2018 at 09:23:08PM +0100, Benjamin Warnke wrote:
> >> Currently ZRAM uses compression-algorithms from the crypto-api. ZRAM
> >> compresses each page individually. As a result the compression algorithm is
> >> forced to use a very small sliding window. None of the available compression
> >> algorithms is designed to achieve high compression ratios with small inputs.
> >> 
> >> This patch adds a new compression algorithm 'zBeWalgo' to the crypto api. This
> >> algorithm focusses on increasing the capacity of the compressed block-device
> >> created by ZRAM. The choice of compression algorithms is always a tradeoff
> >> between speed and compression ratio.
> >> 
> > [...]
> >> 
> >> Zstd is not in the list of compared algorithms, because it is not available
> >> for Zram in the currently available kernel trees.
> >> 
> > 
> > This still isn't a valid excuse for not comparing it to Zstandard.  Zstandard is
> > already in the kernel in lib/.  It would only need glue code to wire it up as an
> > scomp_alg to the crypto API.  
> 
> I'll add benchmarks with Zstandard.
> 
> > In contrast you're proposing an entirely new
> > algorithm.  Ultimately, by proposing a new algorithm you're on the hook to
> > demonstrate that existing algorithms aren't good enough.  Note that many of the
> > existing algorithms including Zstandard also have multiple compression levels
> > available to choose from.
> 
> The crypto api exposes each algorithm only once with its default compression level.
> Currently there is no switch/option/mechanism/code or something to switch thoose levels.
> Of course I could benchmark the algorithms with multiple compression levels.
> How many / Which compression levels would you like to see to be compared with each other?
> 

However many are needed to demonstrate that the new algorithm is needed.  E.g.
if your primary argument is that the new algorithm provides a better compression
ratio, than you'd need to show that simply choosing a higher compression level
with Zstandard or DEFLATE isn't good enough.

> > It's also rare to add a compression or encryption algorithm to the Linux kernel
> > that isn't already used somewhere else.
> 
> The kernel is the only place where so many small pieces of data need to be compressed.
> In user space nobody cares that the data is splitted into pages, and therefore compression usually applied to large datasets.
> 

Not really true.  There are other situations where people need near-random
access to data so not too much can be compressed at once.  Also there are
applications where compression needs to be applied at the level of individual
packets or messages because e.g. the messages need to be sent over the network
right away to meet a time constraint.

> >  Have you at least written a formal
> > specification of the 'zBeWalgo' data format?
> 
> Not yet.
> 
> >  Zstandard, for example, had a
> > well-tested and optimized userspace library and a specification of the data
> > format before it was added to the kernel.  And even before that it took a couple
> > years of development to stabilize the Zstandard data format.
> > 
> > Now, it's true that you don't strictly need a stable data format if the
> > algorithm will only ever be used for RAM compression.  But, if you want to take
> > that shortcut, then you're on the hook to justify it, and perhaps to enlighten
> > the crypto API about algorithms that don't have a stable data format (e.g. using
> > a new CRYPTO_ALG_* flag) so that users have to more explicitly opt-in to using
> > them.
> 
> I could add CRYPTO_ALG_TYPE_COMPRESS_UNSTABLE as an alias for CRYPTO_ALG_TYPE_COMPRESS
> 

A real flag would probably make more sense than an algorithm type.  Note that it
could also be meaningful for other algorithm types besides compression, e.g.
encryption algorithms.

> > You cannot just ignore fuzz-safety in the decompressor either. The existing
> > decompressors exposed through the crypto API are fuzz-safe, so it's not valid to
> > compare an unsafe decompressor to them.  If you really do want to add an unsafe
> > decompressor then you'd likely need to look into adding crypto API support for
> > users to request unsafe decompression -- which could also be used to expose the
> > unsafe version of the LZ4 decompressor (LZ4_decompress_fast() instead of
> > LZ4_decompress_safe()).  Or if you do make the decompressor safe, then of course
> > you'd actually need to fuzz it; I suggest porting the code to userspace and
> > running american fuzzy lop (afl-fuzz) on it: http://lcamtuf.coredump.cx/afl/
> 
> The current version of the decompressor is fuzz-safe. I tested it with lots of data and made sure, that each possible branch in the code is executed multiple times in different combinations.
> 

Are you sure?  Just taking a random example I found in 2 minutes, in
decompress_rle() there is no validation that the destination buffer is not
overflowed, even though each 2 source bytes can expand into 128 destination
bytes.

Branch coverage is not enough.  You need to fuzz it with real fuzzers such as
afl-fuzz and libFuzzer.  It's 2018; there's no excuse for not doing so anymore
for code that is easily plugged into a fuzzer, e.g. decompression functions.

- Eric

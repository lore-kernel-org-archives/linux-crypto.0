From: Jeffrey Walton <noloader@gmail.com>
Subject: Re: [PATCH 3/3] crypto: siphash - drop _aligned variants
Date: Tue, 9 Oct 2018 02:10:37 -0400
Message-ID: <CAH8yC8kqsDAYyTyn3W6oThH5qRX3Qw=2SYr_eA=L03JN0NSBSg@mail.gmail.com>
References: <20181008211554.5355-1-ard.biesheuvel@linaro.org>
 <20181008211554.5355-4-ard.biesheuvel@linaro.org>
 <CAHmME9rDfVbGLpeV9-LDOUo1on2UB7UHd8jBKcWycf9HYkar=g@mail.gmail.com>
 <CAKv+Gu96PKVnymyJyR-9-3HGTryNT=c2kYfXwmHX-QS6DzWf5Q@mail.gmail.com>
Reply-To: noloader@gmail.com
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: linux-mips@linux-mips.org, "Jason A. Donenfeld" <Jason@zx2c4.com>,
 Herbert Xu <herbert@gondor.apana.org.au>, Arnd Bergmann <arnd@arndb.de>,
 Eric Biggers <ebiggers@google.com>, LKML <linux-kernel@vger.kernel.org>,
 Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
 linux-arm-kernel@lists.infradead.org
To: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Return-path: <linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org>
In-Reply-To: <CAKv+Gu96PKVnymyJyR-9-3HGTryNT=c2kYfXwmHX-QS6DzWf5Q@mail.gmail.com>
List-Unsubscribe: <http://lists.infradead.org/mailman/options/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=unsubscribe>
List-Archive: <http://lists.infradead.org/pipermail/linux-arm-kernel/>
List-Post: <mailto:linux-arm-kernel@lists.infradead.org>
List-Help: <mailto:linux-arm-kernel-request@lists.infradead.org?subject=help>
List-Subscribe: <http://lists.infradead.org/mailman/listinfo/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=subscribe>
Sender: "linux-arm-kernel" <linux-arm-kernel-bounces@lists.infradead.org>
Errors-To: linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org
List-Id: linux-crypto.vger.kernel.org

On Tue, Oct 9, 2018 at 2:00 AM Ard Biesheuvel <ard.biesheuvel@linaro.org> wrote:
>
> On 9 October 2018 at 06:11, Jason A. Donenfeld <Jason@zx2c4.com> wrote:
> > Hi Ard,
> > ...
> > As you might expect, when compiling in __siphash_unaligned and
> > __siphash_aligned on the x86 at the same time, __siphash_unaligned is
> > replaced with just "jmp __siphash_aligned", as gcc recognized that
> > indeed the same code is generated.
> >
> Yeah, I noticed something similar on arm64, although we do get a stack
> frame there.
>
> > However, on platforms where get_unaligned_* does do something
> > different, it looks to me like this patch now always calls the
> > unaligned code, even when the input data _is_ an aligned address
> > already, which is worse behaviour than before. While it would be
> > possible for the get_unaligned_* function headers to also detect this
> > and fallback to the faster version at compile time, by the time
> > get_unaligned_* is used in this patch, it's no longer in the header,
> > but rather in siphash.c, which means the compiler no longer knows that
> > the address is aligned, and so we hit the slow path. This especially
> > impacts architectures like MIPS, for example. This is why the original
> > code, prior to this patch, checks the alignment in the .h and then
> > selects which codepath afterwards. So while this patch might handle
> > the ARM use case, it seems like a regression on all other platforms.
> > See, for example, the struct passing in net/core/secure_seq.c, which
> > sends intentionally aligned and packed structs to siphash, which then
> > benefits from using the faster instructions on certain platforms.
> >
> > It seems like what you're grappling with on the ARM side of things is
> > that CONFIG_HAVE_EFFICIENT_UNALIGNED_ACCESS only half means what it
> > says on some ISAs, complicating this logic. It seems like the ideal
> > thing to do, given that, would be to just not set
> > CONFIG_HAVE_EFFICIENT_UNALIGNED_ACCESS on those, so that we can fall
> > back to the unaligned path always, like this patch suggests. Or if
> > that's _too_ drastic, perhaps introduce another variable like
> > CONFIG_MOSTLY_EFFICIENT_UNALIGNED_ACCESS.
> >
> Perhaps we should clarify better what
> CONFIG_HAVE_EFFICIENT_UNALIGNED_ACCESS means.
>
> One could argue that it means there is no point in reorganizing your
> data to make it appear aligned, because the unaligned accessors are
> cheap. Instead, it is used as a license to cast unaligned pointers to
> any type (which C does not permit btw), even in the example.

I recommend avoiding this strategy. One of the libraries I help with
used a similar strategy and was constantly putting out 1-off fires
when GCC assumed, say, 4- or 8-byte alignments. Integer stuff was
fine. The problems did not surface until vectorization at -O3 when the
misaligned buffers started causing exceptions.

To be clear, there were very few problems. It might surface with GCC
4.9 on ARM in one function; and then surface again with GCC 5.1 on
x86_64 on another function; and then surface again under Cygwin for
another function with GCC 6.3.

The pattern was finally gutted in favor of the classic stuff - treat
the data unaligned an walk the buffer OR'ing in to a datatype. Or,
memcpy it into aligned datatypes. Modern compilers recognize the
pattern and it will be optimized they way you hope.

Older GCC's, like say, GCC 4.3, may not do as well. But it is the
price paid for portability and bug free code. And nowadays those old
GCC's and Clang's are getting more rare. There's no sense in doing
something quickly if you can't arrive at the correct result or you
crash at runtime.

> So in the case of siphash, that would mean always taking the unaligned
> path if CONFIG_HAVE_EFFICIENT_UNALIGNED_ACCESS is set, or only for
> unaligned data if it is not.

Jeff

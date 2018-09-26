From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: Re: [PATCH v8 7/9] crypto: qat: Remove VLA usage
Date: Wed, 26 Sep 2018 10:55:10 +0200
Message-ID: <CAKv+Gu-1nfbDU_9fHhZoafPCjOObDbYQzif0NSox_sxwGM1N5g@mail.gmail.com>
References: <20180807211843.47586-1-keescook@chromium.org> <20180807211843.47586-8-keescook@chromium.org>
 <CAK8P3a3kiH-a+JG8FqUw7nc_hk+9z-FdsGFT57SxR83W32zKzQ@mail.gmail.com>
 <CAKv+Gu-dGbWsQu0NgOWVFy7Sca3yBD0pLzEMwmkG3mg9LFPpkA@mail.gmail.com> <CAK8P3a3=_uQihMw0GwEbvDnbvrxzq-em6rccW-so+qmkXk8btQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Cc: Kees Cook <keescook@chromium.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Eric Biggers <ebiggers@google.com>,
        Giovanni Cabiddu <giovanni.cabiddu@intel.com>,
        "Alasdair G. Kergon" <agk@redhat.com>,
        Mike Snitzer <snitzer@redhat.com>,
        Tudor-Dan Ambarus <tudor.ambarus@microchip.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Will Deacon <will.deacon@arm.com>,
        Rasmus Villemoes <linux@rasmusvillemoes.dk>,
        David Woodhouse <dwmw@amazon.co.uk>,
        Matthew Wilcox <willy@infradead.org>,
        "David S. Miller" <davem@davemloft.net>,
        "Gustavo A. R. Silva" <gustavo@embeddedor.com>,
        "open list:HARDWARE RANDOM NUMBER GENERATOR CORE"
        <linux-crypto@vger.kernel.org>,
        device-mapper deve
To: Arnd Bergmann <arnd@arndb.de>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CAK8P3a3=_uQihMw0GwEbvDnbvrxzq-em6rccW-so+qmkXk8btQ@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Wed, 26 Sep 2018 at 10:54, Arnd Bergmann <arnd@arndb.de> wrote:
>
> On Wed, Sep 26, 2018 at 10:44 AM Ard Biesheuvel
> <ard.biesheuvel@linaro.org> wrote:
> >
> > On Tue, 25 Sep 2018 at 18:12, Arnd Bergmann <arnd@arndb.de> wrote:
> > >
> > > On Tue, Aug 7, 2018 at 11:18 PM Kees Cook <keescook@chromium.org> wrote:
> > > >
> > > > In the quest to remove all stack VLA usage from the kernel[1], this uses
> > > > the new upper bound for the stack buffer. Also adds a sanity check.
> > > >
> > > > [1] https://lkml.kernel.org/r/CA+55aFzCG-zNmZwX4A2FQpadafLfEzK6CC=qPXydAacU1RqZWA@mail.gmail.com
> > > >
> > > > Signed-off-by: Kees Cook <keescook@chromium.org>
> > >
> > > After rebasing to linux-next, I now get a warning about this file:
> > >
> > > drivers/crypto/qat/qat_common/qat_algs.c: In function 'qat_alg_do_precomputes':
> > > drivers/crypto/qat/qat_common/qat_algs.c:257:1: error: the frame size
> > > of 1112 bytes is larger than 1024 bytes [-Werror=frame-larger-than=]
> > >
> > > I assume it was already possible to get into that state with the VLA,
> > > but it seems bad enough that I think we need to do something
> > > about it.
> > >
> > > The large stack variables add up to 1084 bytes, which fully explains
> > > how we got here:
> > >
> > >         SHASH_DESC_ON_STACK(shash, ctx->hash_tfm); /* 360 */
> > >         struct sha1_state sha1;  /* 92 */
> > >         struct sha256_state sha256; /* 104 */
> > >         struct sha512_state sha512; /* 208 */
> > >         char ipad[MAX_ALGAPI_BLOCKSIZE]; /* 160 */
> > >         char opad[MAX_ALGAPI_BLOCKSIZE]; /* 160 */
> > >
> > > The question is what we can do about it. One simple step I've tried
> > > is to move the sha1/sha256/sha512 into a union, which saves around
> > > 200 bytes and should bring us (slightly) below the warning
> > > limit, but I suspect we can do better than that. Any ideas?
> > >
> >
> > All the processing takes place in the context of a setkey() operation,
> > which means only one such operation should be in flight per tfm at any
> > given time. So we could move all these pieces into the tfm context
> > struct instead. Something like the below [untested] (whitespace
> > mangling courtesy of Gmail)
>
> Ah, right, this is what I was hoping for. I assume we already guarantee
> that this context is never put on the stack somewhere else, right?
>

Yes.

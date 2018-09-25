From: Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH v8 7/9] crypto: qat: Remove VLA usage
Date: Tue, 25 Sep 2018 18:12:10 +0200
Message-ID: <CAK8P3a3kiH-a+JG8FqUw7nc_hk+9z-FdsGFT57SxR83W32zKzQ@mail.gmail.com>
References: <20180807211843.47586-1-keescook@chromium.org> <20180807211843.47586-8-keescook@chromium.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
        Eric Biggers <ebiggers@google.com>,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        Giovanni Cabiddu <giovanni.cabiddu@intel.com>,
        Alasdair Kergon <agk@redhat.com>,
        Mike Snitzer <snitzer@redhat.com>,
        Tudor Ambarus <tudor.ambarus@microchip.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Will Deacon <will.deacon@arm.com>,
        Rasmus Villemoes <linux@rasmusvillemoes.dk>,
        David Woodhouse <dwmw@amazon.co.uk>,
        Matthew Wilcox <willy@infradead.org>,
        David Miller <davem@davemloft.net>,
        "Gustavo A. R. Silva" <gustavo@embeddedor.com>,
        "open list:HARDWARE RANDOM NUMBER GENERATOR CORE"
        <linux-crypto@vger.kernel.org>, dm-devel@redhat.com,
        qa
To: Kees Cook <keescook@chromium.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180807211843.47586-8-keescook@chromium.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Tue, Aug 7, 2018 at 11:18 PM Kees Cook <keescook@chromium.org> wrote:
>
> In the quest to remove all stack VLA usage from the kernel[1], this uses
> the new upper bound for the stack buffer. Also adds a sanity check.
>
> [1] https://lkml.kernel.org/r/CA+55aFzCG-zNmZwX4A2FQpadafLfEzK6CC=qPXydAacU1RqZWA@mail.gmail.com
>
> Signed-off-by: Kees Cook <keescook@chromium.org>

After rebasing to linux-next, I now get a warning about this file:

drivers/crypto/qat/qat_common/qat_algs.c: In function 'qat_alg_do_precomputes':
drivers/crypto/qat/qat_common/qat_algs.c:257:1: error: the frame size
of 1112 bytes is larger than 1024 bytes [-Werror=frame-larger-than=]

I assume it was already possible to get into that state with the VLA,
but it seems bad enough that I think we need to do something
about it.

The large stack variables add up to 1084 bytes, which fully explains
how we got here:

        SHASH_DESC_ON_STACK(shash, ctx->hash_tfm); /* 360 */
        struct sha1_state sha1;  /* 92 */
        struct sha256_state sha256; /* 104 */
        struct sha512_state sha512; /* 208 */
        char ipad[MAX_ALGAPI_BLOCKSIZE]; /* 160 */
        char opad[MAX_ALGAPI_BLOCKSIZE]; /* 160 */

The question is what we can do about it. One simple step I've tried
is to move the sha1/sha256/sha512 into a union, which saves around
200 bytes and should bring us (slightly) below the warning
limit, but I suspect we can do better than that. Any ideas?

        Arnd

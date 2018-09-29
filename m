From: "Jason A. Donenfeld" <Jason@zx2c4.com>
Subject: Re: [PATCH net-next v6 03/23] zinc: ChaCha20 generic C implementation
 and selftest
Date: Sat, 29 Sep 2018 03:53:48 +0200
Message-ID: <CAHmME9oigSgEqxcevZNmEB9HYpdW6_aMgkdLAXx5YrDckV=g0w@mail.gmail.com>
References: <20180925145622.29959-1-Jason@zx2c4.com> <20180925145622.29959-4-Jason@zx2c4.com>
 <CAKv+Gu8dscmuEnRYNACFfCudwVkA6CRHhTe7K-=r_SfJQBGgzQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Cc: LKML <linux-kernel@vger.kernel.org>,
        Netdev <netdev@vger.kernel.org>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        David Miller <davem@davemloft.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Samuel Neves <sneves@dei.uc.pt>,
        Andrew Lutomirski <luto@kernel.org>,
        Jean-Philippe Aumasson <jeanphilippe.aumasson@gmail.com>
To: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CAKv+Gu8dscmuEnRYNACFfCudwVkA6CRHhTe7K-=r_SfJQBGgzQ@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Hi Ard,

On Fri, Sep 28, 2018 at 5:40 PM Ard Biesheuvel
<ard.biesheuvel@linaro.org> wrote:
> > +struct chacha20_ctx {
> > +       u32 constant[4];
> > +       u32 key[8];
> > +       u32 counter[4];
> > +} __aligned(32);
> > +
>
> 32 *byte* alignment? Is that right? If this is for performance and it
> actually helps, using __cacheline_aligned is more appropriate,

It was originally this way, I believe, for vmovdqa, which requires
32-byte alignment in vex.256 encoding, and I never removed it after
changing some things. But I'll spend some time ensuring this is so and
if it doesn't make sense anymore it'll be gone by v7. On the other
hand, your suggestion of __cacheline_aligned may actually be something
worth considering, especially on MIPS.

> I guess this include is for crypto_xor_cpy() ?
>
> We may want to put a comment here, so we keep track of the interdependencies.

Right, it's for crypto_xor_cpy. Good idea, I'll add the comment.

> > +#ifndef HAVE_CHACHA20_ARCH_IMPLEMENTATION
>
> This #define is never set in subsequent patches, so just drop this
> #ifndef entirely (for this patch only)

Okay. It's also there for the other primitives too; I'll nix it for all of them.

> Return values from initcalls are ignored, and given that chacha20 will
> be depended upon by random.c, it will never be a module in practice.
>
> Given your previous statement that selftest should *not* be a DEBUG
> feature (which I wholeheartedly agree with), you could be a bit
> noisier here imo.
> E.g.,
>
> if (WARN_ON(!chach20_selftest())
>     return ...

That's an excellent idea. We could bloat the whole thing with something like:

#ifdef MODULE
#define WARN_ON_IF_MODULE(x) (x)
#else
#define WARN_ON_IF_MODULE(x) WARN_ON(x)
#endif

But given that kind of thing would probably need to touch more files
in the tree, and hence involve more drawn-out conversation, I'll keep
it as the simple WARN_ON for now. Besides, being noisy no matter what
might actually be the best strategy for receiving bug reports on what
is potentially a pretty catastrophic error.

Thanks for the review.

Jason

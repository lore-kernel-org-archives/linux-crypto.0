From: "Jason A. Donenfeld" <Jason@zx2c4.com>
Subject: Re: [PATCH net-next v6 07/23] zinc: ChaCha20 ARM and ARM64 implementations
Date: Thu, 27 Sep 2018 02:04:56 +0200
Message-ID: <CAHmME9qNn5aRgtbV3bAsz3xW1A49a7RMMkOzGruBUPzLVUxVNg@mail.gmail.com>
References: <20180925145622.29959-1-Jason@zx2c4.com> <20180925145622.29959-8-Jason@zx2c4.com>
 <CAKv+Gu9mVAfdBvOMCFqRJj+wBiWu3JVOgPZdkcdjzqSdQQ5Jrw@mail.gmail.com>
 <CAHmME9r9KppoFwwNVpzpYbU+9dCPzb7Pit+4iRa4MY_ouJBWrA@mail.gmail.com>
 <CAKv+Gu8ih-TsASRGqK+ST_5+EQ0=Zo-zhGCadOdGyPjucMFTCg@mail.gmail.com>
 <CAKv+Gu8w74dUSEAGxxh=C6To6F=bSm8DjiExUPmh_LUyhoDLhg@mail.gmail.com>
 <CAHmME9pbRabkGjNh-65S9qBNNS1GLJSwZ_tTM507S_Ezr1=QLg@mail.gmail.com>
 <CAHmME9ru=kJO8QiW+uNNgt5NgFVZzRsQ4tNSgo+f+KfHs3fAKQ@mail.gmail.com> <CAKv+Gu-WDt8f9qVjLDRPHL7THS0BjtKHThw2RMfHbWBT8Hs8aQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
        Thomas Gleixner <tglx@linutronix.de>,
        LKML <linux-kernel@vger.kernel.org>,
        Netdev <netdev@vger.kernel.org>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        David Miller <davem@davemloft.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Samuel Neves <sneves@dei.uc.pt>,
        Andrew Lutomirski <luto@kernel.org>,
        Jean-Philippe Aumasson <jeanphilippe.aumasson@gmail.com>,
        Russell King - ARM Linux <linux@armlinux.org.uk>,
        linux-arm-kernel@lists.infradead.org
To: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CAKv+Gu-WDt8f9qVjLDRPHL7THS0BjtKHThw2RMfHbWBT8Hs8aQ@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Wed, Sep 26, 2018 at 5:52 PM Ard Biesheuvel
<ard.biesheuvel@linaro.org> wrote:
>
> On Wed, 26 Sep 2018 at 17:50, Jason A. Donenfeld <Jason@zx2c4.com> wrote:
> >
> > On Wed, Sep 26, 2018 at 5:45 PM Jason A. Donenfeld <Jason@zx2c4.com> wrote:
> > > So what you have in mind is something like calling simd_relax() every
> > > 4096 bytes or so?
> >
> > That was actually pretty easy, putting together both of your suggestions:
> >
> > static inline bool chacha20_arch(struct chacha20_ctx *state, u8 *dst,
> >                  u8 *src, size_t len,
> >                  simd_context_t *simd_context)
> > {
> >     while (len > PAGE_SIZE) {
> >         chacha20_arch(state, dst, src, PAGE_SIZE, simd_context);
> >         len -= PAGE_SIZE;
> >         src += PAGE_SIZE;
> >         dst += PAGE_SIZE;
> >         simd_relax(simd_context);
> >     }
> >     if (IS_ENABLED(CONFIG_KERNEL_MODE_NEON) && chacha20_use_neon &&
> >         len >= CHACHA20_BLOCK_SIZE * 3 && simd_use(simd_context))
> >         chacha20_neon(dst, src, len, state->key, state->counter);
> >     else
> >         chacha20_arm(dst, src, len, state->key, state->counter);
> >
> >     state->counter[0] += (len + 63) / 64;
> >     return true;
> > }
>
> Nice one :-)
>
> This works for me (but perhaps add a comment as well)

As elegant as my quick recursive solution was, gcc produced kind of
bad code from it, as you might expect. So I've implemented this using
a boring old loop that works the way it's supposed to. This is marked
for v7.

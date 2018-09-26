From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: Re: [PATCH net-next v6 07/23] zinc: ChaCha20 ARM and ARM64 implementations
Date: Wed, 26 Sep 2018 19:08:30 +0200
Message-ID: <CAKv+Gu__KE5taR-w5ZVKySM0zA3Y3tooTi=wvboX07qeWxBxkA@mail.gmail.com>
References: <20180925145622.29959-1-Jason@zx2c4.com> <20180925145622.29959-8-Jason@zx2c4.com>
 <CAKv+Gu9mVAfdBvOMCFqRJj+wBiWu3JVOgPZdkcdjzqSdQQ5Jrw@mail.gmail.com>
 <CAHmME9r9KppoFwwNVpzpYbU+9dCPzb7Pit+4iRa4MY_ouJBWrA@mail.gmail.com>
 <CAKv+Gu8ih-TsASRGqK+ST_5+EQ0=Zo-zhGCadOdGyPjucMFTCg@mail.gmail.com>
 <D93C2C15-DC70-4A95-9350-AD4036C9556A@amacapital.net> <CAHmME9pZKUMnnSZ0670rUH4H61g0x88c-B-DZYw_X-8+xgH-=g@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Cc: Andy Lutomirski <luto@amacapital.net>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Thomas Gleixner <tglx@linutronix.de>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "<netdev@vger.kernel.org>" <netdev@vger.kernel.org>,
        "open list:HARDWARE RANDOM NUMBER GENERATOR CORE"
        <linux-crypto@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Samuel Neves <sneves@dei.uc.pt>,
        Andy Lutomirski <luto@kernel.org>,
        Jean-Philippe Aumasson <jeanphilippe.aumasson@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>
To: "Jason A. Donenfeld" <Jason@zx2c4.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CAHmME9pZKUMnnSZ0670rUH4H61g0x88c-B-DZYw_X-8+xgH-=g@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Wed, 26 Sep 2018 at 19:03, Jason A. Donenfeld <Jason@zx2c4.com> wrote:
>
> On Wed, Sep 26, 2018 at 6:21 PM Andy Lutomirski <luto@amacapital.net> wro=
te:
> > Are, is what you=E2=80=99re saying that the Zinc chacha20 functions sho=
uld call simd_relax() every n bytes automatically for some reasonable value=
 of n?  If so, seems sensible, except that some care might be needed to mak=
e sure they interact with preemption correctly.
> >
> > What I mean is: the public Zinc entry points should either be callable =
in an atomic context or they should not be.  I think this should be checked=
 at runtime in an appropriate place with an __might_sleep or similar.  Or s=
imd_relax should learn to *not* schedule if the result of preempt_enable() =
leaves it atomic. (And the latter needs to be done in a way that works even=
 on non-preempt kernels, and I don=E2=80=99t remember whether that=E2=80=99=
s possible.). And this should happen regardless of how many bytes are proce=
ssed. IOW, calling into Zinc should be equally not atomic-safe for 100 byte=
s and for 10 MB.
>
> I'm not sure this is actually a problem. Namely:
>
> preempt_disable();
> kernel_fpu_begin();
> kernel_fpu_end();
> schedule(); <--- bug!
>
> Calling kernel_fpu_end() disables preemption, but AFAIK, preemption
> enabling/disabling is recursive, so kernel_fpu_end's use of
> preempt_disable won't actually do anything until the outer preempt
> enable is called:
>
> preempt_disable();
> kernel_fpu_begin();
> kernel_fpu_end();
> preempt_enable();
> schedule(); <--- works!
>
> Or am I missing some more subtle point?
>

No that seems accurate to me.

From: "Jason A. Donenfeld" <Jason@zx2c4.com>
Subject: Re: [PATCH net-next v6 01/23] asm: simd context helper API
Date: Fri, 28 Sep 2018 15:45:20 +0200
Message-ID: <CAHmME9qpRSNZnPds8dcoObstWhMm_QXs55o=QHipLFfT7n=edg@mail.gmail.com>
References: <20180925145622.29959-1-Jason@zx2c4.com> <20180925145622.29959-2-Jason@zx2c4.com>
 <CAKv+Gu9e35+AyktmSq9qeNE0LR83_yrEEB3DiQv0bmyArivqRQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Cc: LKML <linux-kernel@vger.kernel.org>,
        Netdev <netdev@vger.kernel.org>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        David Miller <davem@davemloft.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Samuel Neves <sneves@dei.uc.pt>,
        Andrew Lutomirski <luto@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        linux-arch@vger.kernel.org
To: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CAKv+Gu9e35+AyktmSq9qeNE0LR83_yrEEB3DiQv0bmyArivqRQ@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Fri, Sep 28, 2018 at 10:28 AM Ard Biesheuvel
<ard.biesheuvel@linaro.org> wrote:
> Given that this patch applies to all architectures at once, it is
> probably better to drop the unrelated reordering hunks to avoid
> conflicts.

Ack. Will retain order for v7.

> > +static __must_check inline bool may_use_simd(void)
> > +{
> > +       return !in_interrupt();
> > +}
> > +
>
> Remember this guy?
>
> https://marc.info/?l=linux-arch&m=149631094625176&w=2
>
> That was never merged, so let's get it right this time.

Wow, nice memory. I had forgotten all about that. Queued for v7.

> > +static inline void simd_relax(simd_context_t *ctx)
> > +{
> > +#ifdef CONFIG_PREEMPT
> > +       if ((*ctx & HAVE_SIMD_IN_USE) && need_resched()) {
> > +               simd_put(ctx);
> > +               simd_get(ctx);
> > +       }
> > +#endif
>
> Could we return a bool here indicating whether we rescheduled or not?
> In some cases, we could pass that into the asm code as a 'reload'
> param, allowing repeated loads of key schedules, round constant tables
> or S-boxes to be elided.

Sure, sounds easy enough.

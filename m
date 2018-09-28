From: "Jason A. Donenfeld" <Jason@zx2c4.com>
Subject: Re: [PATCH net-next v6 01/23] asm: simd context helper API
Date: Fri, 28 Sep 2018 15:59:51 +0200
Message-ID: <CAHmME9owF+3aQaZUkK4KkfnJna+DK=GoWV8yf-Wb+gH4w3y9eg@mail.gmail.com>
References: <20180925145622.29959-1-Jason@zx2c4.com> <20180925145622.29959-2-Jason@zx2c4.com>
 <CAKv+Gu9e35+AyktmSq9qeNE0LR83_yrEEB3DiQv0bmyArivqRQ@mail.gmail.com>
 <CAKv+Gu9kbLPZH4W0zKAfuv-b11mcDaZ05HUauvh9gMZVGVR0AQ@mail.gmail.com>
 <CAHmME9pfs0_MsD9QAGfSm31_w-=6BCF_gZO04XkfhD=mEoZmtQ@mail.gmail.com> <CAKv+Gu__7mZFFq6qC=8yh0OuaV+TCCLFt6nm8yJfaANHUPrJ=A@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Cc: Joe Perches <joe@perches.com>, LKML <linux-kernel@vger.kernel.org>,
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
In-Reply-To: <CAKv+Gu__7mZFFq6qC=8yh0OuaV+TCCLFt6nm8yJfaANHUPrJ=A@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Fri, Sep 28, 2018 at 3:58 PM Ard Biesheuvel
<ard.biesheuvel@linaro.org> wrote:
>
> On 28 September 2018 at 15:47, Jason A. Donenfeld <Jason@zx2c4.com> wrote:
> > On Fri, Sep 28, 2018 at 10:49 AM Ard Biesheuvel
> > <ard.biesheuvel@linaro.org> wrote:
> >> >> +typedef enum {
> >> >> +       HAVE_NO_SIMD = 1 << 0,
> >> >> +       HAVE_FULL_SIMD = 1 << 1,
> >> >> +       HAVE_SIMD_IN_USE = 1 << 31
> >> >> +} simd_context_t;
> >> >> +
> >>
> >> Oh, and another thing (and I'm surprised checkpatch.pl didn't complain
> >> about it): the use of typedef in new code is strongly discouraged.
> >> This policy predates my involvement, so perhaps Joe can elaborate on
> >> the rationale?
> >
> > In case it matters, the motivation for making this a typedef is I
> > could imagine this at some point turning into a more complicated
> > struct on certain platforms and that would make refactoring easier. I
> > could just make it `struct simd_context` now with 1 member though...
>
> Yes that makes sense

The rationale for it being a typedef or moving to a struct now?

From: "Jason A. Donenfeld" <Jason@zx2c4.com>
Subject: Re: [PATCH net-next v6 01/23] asm: simd context helper API
Date: Mon, 1 Oct 2018 03:43:25 +0200
Message-ID: <CAHmME9o7_Xh=dZfnEHbPCJdqzXW1L5R7qjg=_sqPZiP2KmTc1Q@mail.gmail.com>
References: <20180925145622.29959-1-Jason@zx2c4.com> <20180925145622.29959-2-Jason@zx2c4.com>
 <CAKv+Gu9e35+AyktmSq9qeNE0LR83_yrEEB3DiQv0bmyArivqRQ@mail.gmail.com>
 <CAKv+Gu9kbLPZH4W0zKAfuv-b11mcDaZ05HUauvh9gMZVGVR0AQ@mail.gmail.com>
 <CAHmME9pfs0_MsD9QAGfSm31_w-=6BCF_gZO04XkfhD=mEoZmtQ@mail.gmail.com>
 <CAKv+Gu__7mZFFq6qC=8yh0OuaV+TCCLFt6nm8yJfaANHUPrJ=A@mail.gmail.com>
 <CAHmME9owF+3aQaZUkK4KkfnJna+DK=GoWV8yf-Wb+gH4w3y9eg@mail.gmail.com>
 <CAKv+Gu9FAVVOiYyGovYZ19-107_6sK9Ya6LnK=AQkTgctMmu5A@mail.gmail.com>
 <CAHmME9rqsOid6UOx+VTsFzJLEiaXpTP_z_wvHC6MbeAQUeEtHg@mail.gmail.com>
 <8afdd3b1c51587708db6ae878eb0a7e9f8b5673a.camel@perches.com> <3E9E1888-026E-45C1-8AA7-DADA211EDBDF@amacapital.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Cc: Joe Perches <joe@perches.com>,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Netdev <netdev@vger.kernel.org>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        David Miller <davem@davemloft.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Samuel Neves <sneves@dei.uc.pt>,
        Andrew Lutomirski <luto@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        linux-arch@vger.kernel.org
To: Andy Lutomirski <luto@amacapital.net>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <3E9E1888-026E-45C1-8AA7-DADA211EDBDF@amacapital.net>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Sun, Sep 30, 2018 at 7:35 AM Andy Lutomirski <luto@amacapital.net> wrote=
:
> >>>>>>> Oh, and another thing (and I'm surprised checkpatch.pl didn't com=
plain
> >>>>>>> about it): the use of typedef in new code is strongly discouraged=
.
> >>>>>>> This policy predates my involvement, so perhaps Joe can elaborate=
 on
> >>>>>>> the rationale?
> >>>>>>
> >>>>>> In case it matters, the motivation for making this a typedef is I
> >>>>>> could imagine this at some point turning into a more complicated
> >>>>>> struct on certain platforms and that would make refactoring easier=
. I
> >>>>>> could just make it `struct simd_context` now with 1 member though.=
..
> >>>>>
> >>>>> Yes that makes sense
> >>>>
> >>>> The rationale for it being a typedef or moving to a struct now?
> >>>
> >>> Yes just switch to a struct.
> >>
> >> Okay. No problem with that, but will wait to hear from Joe first.
> >
> > Why do you need to hear from me again?
> >
> > As far as I know, the only info about typedef avoidance are in
> > Documentation/process/coding-style.rst section 5.
> >
> >
>
> I personally prefer it with the typedef. If this were my code, I=E2=80=99=
d say the coding style is silly for opaque tiny structs like this.

I'll stick with a typedef. Reading the style guide, this clearly falls
into 5.a, 5.b, and maybe 5.c. For 5.a, at some point this will
possibly contain architecture specific blobs. For 5.b, it is just an
enum (integer) right now.

From: Andy Lutomirski <luto@amacapital.net>
Subject: Re: [PATCH net-next v6 01/23] asm: simd context helper API
Date: Sat, 29 Sep 2018 22:35:13 -0700
Message-ID: <3E9E1888-026E-45C1-8AA7-DADA211EDBDF@amacapital.net>
References: <20180925145622.29959-1-Jason@zx2c4.com> <20180925145622.29959-2-Jason@zx2c4.com> <CAKv+Gu9e35+AyktmSq9qeNE0LR83_yrEEB3DiQv0bmyArivqRQ@mail.gmail.com> <CAKv+Gu9kbLPZH4W0zKAfuv-b11mcDaZ05HUauvh9gMZVGVR0AQ@mail.gmail.com> <CAHmME9pfs0_MsD9QAGfSm31_w-=6BCF_gZO04XkfhD=mEoZmtQ@mail.gmail.com> <CAKv+Gu__7mZFFq6qC=8yh0OuaV+TCCLFt6nm8yJfaANHUPrJ=A@mail.gmail.com> <CAHmME9owF+3aQaZUkK4KkfnJna+DK=GoWV8yf-Wb+gH4w3y9eg@mail.gmail.com> <CAKv+Gu9FAVVOiYyGovYZ19-107_6sK9Ya6LnK=AQkTgctMmu5A@mail.gmail.com> <CAHmME9rqsOid6UOx+VTsFzJLEiaXpTP_z_wvHC6MbeAQUeEtHg@mail.gmail.com> <8afdd3b1c51587708db6ae878eb0a7e9f8b5673a.camel@perches.com>
Mime-Version: 1.0 (1.0)
Content-Type: text/plain;
        charset=utf-8
Content-Transfer-Encoding: quoted-printable
Cc: "Jason A. Donenfeld" <Jason@zx2c4.com>,
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
To: Joe Perches <joe@perches.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <8afdd3b1c51587708db6ae878eb0a7e9f8b5673a.camel@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org



> On Sep 29, 2018, at 9:20 PM, Joe Perches <joe@perches.com> wrote:
>=20
>> On Fri, 2018-09-28 at 16:01 +0200, Jason A. Donenfeld wrote:
>> On Fri, Sep 28, 2018 at 4:00 PM Ard Biesheuvel
>> <ard.biesheuvel@linaro.org> wrote:
>>>=20
>>>> On 28 September 2018 at 15:59, Jason A. Donenfeld <Jason@zx2c4.com> wro=
te:
>>>> On Fri, Sep 28, 2018 at 3:58 PM Ard Biesheuvel
>>>> <ard.biesheuvel@linaro.org> wrote:
>>>>>=20
>>>>>> On 28 September 2018 at 15:47, Jason A. Donenfeld <Jason@zx2c4.com> w=
rote:
>>>>>> On Fri, Sep 28, 2018 at 10:49 AM Ard Biesheuvel
>>>>>> <ard.biesheuvel@linaro.org> wrote:
>>>>>>>>> +typedef enum {
>>>>>>>>> +       HAVE_NO_SIMD =3D 1 << 0,
>>>>>>>>> +       HAVE_FULL_SIMD =3D 1 << 1,
>>>>>>>>> +       HAVE_SIMD_IN_USE =3D 1 << 31
>>>>>>>>> +} simd_context_t;
>>>>>>>>> +
>>>>>>>=20
>>>>>>> Oh, and another thing (and I'm surprised checkpatch.pl didn't compla=
in
>>>>>>> about it): the use of typedef in new code is strongly discouraged.
>>>>>>> This policy predates my involvement, so perhaps Joe can elaborate on=

>>>>>>> the rationale?
>>>>>>=20
>>>>>> In case it matters, the motivation for making this a typedef is I
>>>>>> could imagine this at some point turning into a more complicated
>>>>>> struct on certain platforms and that would make refactoring easier. I=

>>>>>> could just make it `struct simd_context` now with 1 member though...
>>>>>=20
>>>>> Yes that makes sense
>>>>=20
>>>> The rationale for it being a typedef or moving to a struct now?
>>>=20
>>> Yes just switch to a struct.
>>=20
>> Okay. No problem with that, but will wait to hear from Joe first.
>=20
> Why do you need to hear from me again?
>=20
> As far as I know, the only info about typedef avoidance are in
> Documentation/process/coding-style.rst section 5.
>=20
>=20

I personally prefer it with the typedef. If this were my code, I=E2=80=99d s=
ay the coding style is silly for opaque tiny structs like this.=

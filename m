From: Andy Lutomirski <luto@amacapital.net>
Subject: Re: [PATCH net-next v5 02/20] zinc: introduce minimal cryptography library
Date: Thu, 20 Sep 2018 21:52:04 -0700
Message-ID: <AA5D5BE5-79EC-4149-BD54-2C4286CFA291@amacapital.net>
References: <20180918161646.19105-1-Jason@zx2c4.com> <20180918161646.19105-3-Jason@zx2c4.com> <CAKv+Gu-0oTBrg3T8TsNYPOdrmJSSC313-CYASO34kb_nviva6A@mail.gmail.com> <CAK8P3a0CS3QzEKEV5==qj8hUYgW+q2v1f13jA+s0TjQd8kYXFA@mail.gmail.com> <CAHmME9rJq=q7xj_E_84GN5FuzSW2KdP4Ch=y527Lem0ME4GnLg@mail.gmail.com> <20180921031255.GB11109@lunn.ch> <8FA361E3-FBCB-469E-88DC-F4085BD91175@amacapital.net> <CAHmME9rF=FfOf-_EOB-BeT-BM=B9Q9YzFAoUimaPiM2RKb5sGA@mail.gmail.com> <CAKv+Gu-sciHeWVij8hWGF78HV_CLddMv7Xdf1GRSY+6B2yt48A@mail.gmail.com>
Mime-Version: 1.0 (1.0)
Content-Type: text/plain;
        charset=utf-8
Content-Transfer-Encoding: quoted-printable
Cc: "Jason A. Donenfeld" <Jason@zx2c4.com>,
        Andrew Lunn <andrew@lunn.ch>, Arnd Bergmann <arnd@arndb.de>,
        Eric Biggers <ebiggers@google.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Netdev <netdev@vger.kernel.org>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        David Miller <davem@davemloft.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Samuel Neves <sneves@dei.uc.pt>,
        Andrew Lutomirski <luto@kernel.org>,
        Jean-Philippe Aumasson <jeanphilippe.aumasson@gmail.com>
To: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CAKv+Gu-sciHeWVij8hWGF78HV_CLddMv7Xdf1GRSY+6B2yt48A@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org



> On Sep 20, 2018, at 9:30 PM, Ard Biesheuvel <ard.biesheuvel@linaro.org> wr=
ote:
>=20
>> On 20 September 2018 at 21:15, Jason A. Donenfeld <Jason@zx2c4.com> wrote=
:
>> Hi Andy,
>>=20
>>> On Fri, Sep 21, 2018 at 5:23 AM Andy Lutomirski <luto@amacapital.net> wr=
ote:
>>> At the risk on suggesting something awful: on x86_64, since we turn pree=
mption off for simd, it wouldn=E2=80=99t be *completely* insane to do the cr=
ypto on the irq stack. It would look like:
>>>=20
>>> kernel_fpu_call(func, arg);
>>>=20
>>> And this helper would disable preemption, enable FPU, switch to the irq s=
tack, call func(arg), disable FPU, enable preemption, and return. And we can=
 have large IRQ stacks.
>>>=20
>>> I refuse to touch this with a ten-foot pole until the lazy FPU restore p=
atches land.
>>=20
>> Haha. That's fun, and maybe we'll do that at some point, but I have
>> some other reasons too for being on a workqueue now.
>>=20
>=20
> Kernel mode crypto is callable from any context, and SIMD can be used
> in softirq context on arm64 (and on x86, even from hardirq context
> IIRC if the interrupt is taken from userland), in which case we'd
> already be on the irq stack.

The x86_64 irq stack handles nesting already.

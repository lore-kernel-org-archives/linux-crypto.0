From: Andy Lutomirski <luto@amacapital.net>
Subject: Re: [PATCH net-next v5 02/20] zinc: introduce minimal cryptography library
Date: Thu, 20 Sep 2018 20:23:43 -0700
Message-ID: <8FA361E3-FBCB-469E-88DC-F4085BD91175@amacapital.net>
References: <20180918161646.19105-1-Jason@zx2c4.com> <20180918161646.19105-3-Jason@zx2c4.com> <CAKv+Gu-0oTBrg3T8TsNYPOdrmJSSC313-CYASO34kb_nviva6A@mail.gmail.com> <CAK8P3a0CS3QzEKEV5==qj8hUYgW+q2v1f13jA+s0TjQd8kYXFA@mail.gmail.com> <CAHmME9rJq=q7xj_E_84GN5FuzSW2KdP4Ch=y527Lem0ME4GnLg@mail.gmail.com> <20180921031255.GB11109@lunn.ch>
Mime-Version: 1.0 (1.0)
Content-Type: text/plain;
        charset=utf-8
Content-Transfer-Encoding: quoted-printable
Cc: "Jason A. Donenfeld" <Jason@zx2c4.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        Eric Biggers <ebiggers@google.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Netdev <netdev@vger.kernel.org>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        David Miller <davem@davemloft.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Samuel Neves <sneves@dei.uc.pt>,
        Andrew Lutomirski <luto@kernel.org>,
        Jean-Philippe Aumasson <jeanphilippe.aumasson@gmail.com>
To: Andrew Lunn <andrew@lunn.ch>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180921031255.GB11109@lunn.ch>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org


> On Sep 20, 2018, at 8:12 PM, Andrew Lunn <andrew@lunn.ch> wrote:
>=20
>> On Fri, Sep 21, 2018 at 02:11:43AM +0200, Jason A. Donenfeld wrote:
>> Hey Arnd,
>>=20
>>> On Thu, Sep 20, 2018 at 6:02 PM Arnd Bergmann <arnd@arndb.de> wrote:
>>> Right, if you hit a stack requirement like this, it's usually the compil=
er
>>> doing something bad, not just using too much stack but also generating
>>> rather slow object code in the process. It's better to fix the bug by
>>> optimizing the code to not spill registers to the stack.
>>>=20
>>> In the long run, I'd like to reduce the stack frame size further, so
>>> best assume that anything over 1024 bytes (on 32-bit) or 1280 bytes
>>> (on 64-bit) is a bug in the code, and stay below that.
>>>=20
>>> For prototyping, you can just mark the broken functions individually
>>> by setting the warning limit for a specific function that is known to
>>> be misoptimized by the compiler (with a comment about which compiler
>>> and architectures are affected), but not override the limit for the
>>> entire file.
>>=20
>> Thanks for the explanation. Fortunately in my case, the issues were
>> trivially fixable to get it under 1024/1280. (By the way, why does
>> 64-bit have a slightly larger stack frame? To account for 32 pointers
>> taking double the space or something?) That will be rectified in v6.
>=20
> Hi Jason
>=20
> Do you any stack usage information?
>=20
> A VPN can be at the bottom of some deep stack calls. Swap on NFS over
> the VPN? If you have one frame of 1K, you might be O.K. But if you
> have a few of these, i can see there might be issues of overflowing
> the stack.
>=20
> =20

At the risk on suggesting something awful: on x86_64, since we turn preempti=
on off for simd, it wouldn=E2=80=99t be *completely* insane to do the crypto=
 on the irq stack. It would look like:

kernel_fpu_call(func, arg);

And this helper would disable preemption, enable FPU, switch to the irq stac=
k, call func(arg), disable FPU, enable preemption, and return. And we can ha=
ve large IRQ stacks.

I refuse to touch this with a ten-foot pole until the lazy FPU restore patch=
es land.

All that being said, why are these frames so large?  It sounds like somethin=
g may be spilling that ought not to.=

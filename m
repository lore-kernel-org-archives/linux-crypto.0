From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: Re: [PATCH net-next v5 02/20] zinc: introduce minimal cryptography library
Date: Thu, 20 Sep 2018 21:30:26 -0700
Message-ID: <CAKv+Gu-sciHeWVij8hWGF78HV_CLddMv7Xdf1GRSY+6B2yt48A@mail.gmail.com>
References: <20180918161646.19105-1-Jason@zx2c4.com> <20180918161646.19105-3-Jason@zx2c4.com>
 <CAKv+Gu-0oTBrg3T8TsNYPOdrmJSSC313-CYASO34kb_nviva6A@mail.gmail.com>
 <CAK8P3a0CS3QzEKEV5==qj8hUYgW+q2v1f13jA+s0TjQd8kYXFA@mail.gmail.com>
 <CAHmME9rJq=q7xj_E_84GN5FuzSW2KdP4Ch=y527Lem0ME4GnLg@mail.gmail.com>
 <20180921031255.GB11109@lunn.ch> <8FA361E3-FBCB-469E-88DC-F4085BD91175@amacapital.net>
 <CAHmME9rF=FfOf-_EOB-BeT-BM=B9Q9YzFAoUimaPiM2RKb5sGA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Cc: Andy Lutomirski <luto@amacapital.net>,
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
To: "Jason A. Donenfeld" <Jason@zx2c4.com>
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <CAHmME9rF=FfOf-_EOB-BeT-BM=B9Q9YzFAoUimaPiM2RKb5sGA@mail.gmail.com>
Sender: netdev-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On 20 September 2018 at 21:15, Jason A. Donenfeld <Jason@zx2c4.com> wrote:
> Hi Andy,
>
> On Fri, Sep 21, 2018 at 5:23 AM Andy Lutomirski <luto@amacapital.net> wro=
te:
>> At the risk on suggesting something awful: on x86_64, since we turn pree=
mption off for simd, it wouldn=E2=80=99t be *completely* insane to do the c=
rypto on the irq stack. It would look like:
>>
>> kernel_fpu_call(func, arg);
>>
>> And this helper would disable preemption, enable FPU, switch to the irq =
stack, call func(arg), disable FPU, enable preemption, and return. And we c=
an have large IRQ stacks.
>>
>> I refuse to touch this with a ten-foot pole until the lazy FPU restore p=
atches land.
>
> Haha. That's fun, and maybe we'll do that at some point, but I have
> some other reasons too for being on a workqueue now.
>

Kernel mode crypto is callable from any context, and SIMD can be used
in softirq context on arm64 (and on x86, even from hardirq context
IIRC if the interrupt is taken from userland), in which case we'd
already be on the irq stack.

>>
>> All that being said, why are these frames so large?  It sounds like some=
thing may be spilling that ought not to.
>
> They're not. Well, they're not anymore. I had a silly thing before
> like "u8 buffer[1 << 12]" in some debugging code, which is what
> prompted the ccflag-y addition. I cleaned up the mistakes like that
> and frames are now reasonable everywhere. Non-issue.
>

Did any of the fuzzing/testing you mention in the cover letter occur
on the kernel versions of these algorithms?

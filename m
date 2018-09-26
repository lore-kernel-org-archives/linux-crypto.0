From: Andy Lutomirski <luto@amacapital.net>
Subject: Re: [PATCH net-next v6 07/23] zinc: ChaCha20 ARM and ARM64 implementations
Date: Wed, 26 Sep 2018 09:21:23 -0700
Message-ID: <D93C2C15-DC70-4A95-9350-AD4036C9556A@amacapital.net>
References: <20180925145622.29959-1-Jason@zx2c4.com> <20180925145622.29959-8-Jason@zx2c4.com> <CAKv+Gu9mVAfdBvOMCFqRJj+wBiWu3JVOgPZdkcdjzqSdQQ5Jrw@mail.gmail.com> <CAHmME9r9KppoFwwNVpzpYbU+9dCPzb7Pit+4iRa4MY_ouJBWrA@mail.gmail.com> <CAKv+Gu8ih-TsASRGqK+ST_5+EQ0=Zo-zhGCadOdGyPjucMFTCg@mail.gmail.com>
Mime-Version: 1.0 (1.0)
Content-Type: text/plain;
        charset=utf-8
Content-Transfer-Encoding: quoted-printable
Cc: "Jason A. Donenfeld" <Jason@zx2c4.com>,
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
To: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <CAKv+Gu8ih-TsASRGqK+ST_5+EQ0=Zo-zhGCadOdGyPjucMFTCg@mail.gmail.com>
Sender: netdev-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org



> On Sep 26, 2018, at 7:02 AM, Ard Biesheuvel <ard.biesheuvel@linaro.org> wr=
ote:
>=20
> (+ Herbert, Thomas)
>=20
>> On Wed, 26 Sep 2018 at 15:33, Jason A. Donenfeld <Jason@zx2c4.com> wrote:=

>>=20
>> Hi Ard,
>> .
>=20
>> And if it becomes one,
>> this is something we can address *later*, but certainly there's no use
>> of adding additional complexity to the initial patchset to do this
>> now.
>>=20
>=20
> You are introducing a very useful SIMD abstraction, but it lets code
> run with preemption disabled for unbounded amounts of time, and so now
> is the time to ensure we get it right.
>=20
> Part of the [justified] criticism on the current state of the crypto
> API is on its complexity, and so I don't think it makes sense to keep
> it simple now and add the complexity later (and the same concern
> applies to async support btw).

Are, is what you=E2=80=99re saying that the Zinc chacha20 functions should c=
all simd_relax() every n bytes automatically for some reasonable value of n?=
  If so, seems sensible, except that some care might be needed to make sure t=
hey interact with preemption correctly.

What I mean is: the public Zinc entry points should either be callable in an=
 atomic context or they should not be.  I think this should be checked at ru=
ntime in an appropriate place with an __might_sleep or similar.  Or simd_rel=
ax should learn to *not* schedule if the result of preempt_enable() leaves i=
t atomic. (And the latter needs to be done in a way that works even on non-p=
reempt kernels, and I don=E2=80=99t remember whether that=E2=80=99s possible=
.). And this should happen regardless of how many bytes are processed. IOW, c=
alling into Zinc should be equally not atomic-safe for 100 bytes and for 10 M=
B.

As for async, ISTM a really good WireGuard accelerator would expose a differ=
ent interface than crypto API supports, and it probably makes sense to wait f=
or such hardware to show up before figuring out how to use it.  And no matte=
r what form it takes, I don=E2=80=99t think it should complicate the basic Z=
inc crypto entry points.=

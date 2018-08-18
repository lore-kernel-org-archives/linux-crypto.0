From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: Re: [PATCH v1 2/3] zinc: Introduce minimal cryptography library
Date: Sat, 18 Aug 2018 11:13:28 +0300
Message-ID: <47A76A96-3B58-4A42-B55A-5D1D6068CEE4@linaro.org>
References: <20180801072246.GA15677@sol.localdomain> <CAHmME9pbwj0RaX4YM9epGOSgDRNUt=GA4UzO_iKcW=Md7kG6JQ@mail.gmail.com> <20180814211229.GB24575@gmail.com> <20180815162819.22765.qmail@cr.yp.to> <20180815195732.GA79500@gmail.com> <20180816042454.15529.qmail@cr.yp.to> <20180816194620.GA185651@gmail.com> <20180817073120.12640.qmail@cr.yp.to>
Mime-Version: 1.0 (1.0)
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Cc: Eric Biggers <ebiggers@kernel.org>,
        "Jason A. Donenfeld" <Jason@zx2c4.com>,
        Eric Biggers <ebiggers3@gmail.com>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Netdev <netdev@vger.kernel.org>,
        David Miller <davem@davemloft.net>,
        Andrew Lutomirski <luto@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Samuel Neves <sneves@dei.uc.pt>,
        Tanja Lange <tanja@hyperelliptic.org>,
        Jean-Philippe Aumasson <jeanphilippe.aumasson@gmail.com>,
        Karthikeyan Bhargavan <karthik.bhargavan@gmail.com>
To: "D. J. Bernstein" <djb@cr.yp.to>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180817073120.12640.qmail@cr.yp.to>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org



> On 17 Aug 2018, at 10:31, D. J. Bernstein <djb@cr.yp.to> wrote:
>=20
> Eric Biggers writes:
>> If (more likely) you're talking about things like "use this NEON implemen=
tation
>> on Cortex-A7 but this other NEON implementation on Cortex-A53", it's up t=
he
>> developers and community to test different CPUs and make appropriate deci=
sions,
>> and yes it can be very useful to have external benchmarks like SUPERCOP t=
o refer
>> to, and I appreciate your work in that area.
>=20
> You seem to be talking about a process that selects (e.g.) ChaCha20
> implementations as follows: manually inspect benchmarks of various
> implementations on various CPUs, manually write code to map CPUs to
> implementations, manually update the code as necessary for new CPUs, and
> of course manually do the same for every other primitive that can see
> differences between microarchitectures (which isn't something weird---
> it's the normal situation after enough optimization effort).
>=20
> This is quite a bit of manual work, so the kernel often doesn't do it,
> so we end up with unhappy people talking about performance regressions.
>=20
> For comparison, imagine one simple central piece of code in the kernel
> to automatically do the following:
>=20
>   When a CPU core is booted:
>     For each primitive:
>       Benchmark all implementations of the primitive on the core.
>       Select the fastest for subsequent use on the core.
>=20
> If this is a general-purpose mechanism (as in SUPERCOP, NaCl, and
> libpqcrypto) rather than something ad-hoc (as in raid6), then there's no
> manual work per primitive, and no work per implementation. Each CPU, old
> or new, automatically obtains the fastest available code for that CPU.
>=20
> The only cost is a moment of benchmarking at boot time. _If_ this is a
> noticeable cost then there are many ways to speed it up: for example,
> automatically copy the results across identical cores, automatically
> copy the results across boots if the cores are unchanged, automatically
> copy results from a central database indexed by CPU identifiers, etc.
> The SUPERCOP database is evolving towards enabling this type of sharing.
>=20

=E2=80=98Fastest=E2=80=99 does not imply =E2=80=98preferred=E2=80=99. For in=
stance, running the table based cache thrashing generic AES implementation m=
ay be fast, but may put a disproportionate load on, e.g., a hyperthreading s=
ystem, and as you have pointed out yourself, it is time variant as well. The=
n, there is the power consumption aspect: NEON bit sliced AES may be faster,=
 but does a lot more work, and does it on the SIMD unit which could potentia=
lly be turned off entirely otherwise. Only the implementations based on h/w i=
nstructions can generally be assumed optimal in all senses, and there is no r=
eal point in benchmarking those against pure software implementations.

Then, there is the aspect of accelerators: the kernel=E2=80=99s crypto API s=
eamlessly supports crypto peripherals, which may be slower or faster, have m=
ore or fewer queues than the number of CPUs, may offer additional benefits s=
uch as protected AES keys etc etc.

In the linux kernel, we generally try to stay away from policy decisions, an=
d offer the controls to allow userland to take charge of this. The modulariz=
ed crypto code can be blacklisted per algo implementation if desired, and be=
yond that, we simply try to offer functionality that covers the common case.=


>> A lot of code can be shared, but in practice different environments have
>> different constraints, and kernel programming in particular has some dist=
inct
>> differences from userspace programming.  For example, you cannot just use=
 the
>> FPU (including SSE, AVX, NEON, etc.) registers whenever you want to, sinc=
e on
>> most architectures they can't be used in some contexts such as hardirq co=
ntext,
>> and even when they *can* be used you have to run special code before and a=
fter
>> which does things like saving all the FPU registers to the task_struct,
>> disabling preemption, and/or enabling the FPU.
>=20
> Is there some reason that each implementor is being pestered to handle
> all this? Detecting FPU usage is a simple static-analysis exercise, and
> the rest sounds like straightforward boilerplate that should be handled
> centrally.
>=20

Detecting it is easy but that does not mean that you can use SIMD in any con=
text, and whether a certain function may ever be called from such a context c=
annot be decided by static analysis. Also, there are performance and latency=
 concerns which need to be taken into account.

In the kernel, we simply cannot write our algorithm as if our code is the on=
ly thing running on the system.

>> But disabling preemption for
>> long periods of time hurts responsiveness, so it's also desirable to yiel=
d the
>> processor occasionally, which means that assembly implementations should b=
e
>> incremental rather than having a single entry point that does everything.=

>=20
> Doing this rewrite automatically is a bit more of a code-analysis
> challenge, but the alternative approach of doing it by hand is insanely
> error-prone. See, e.g., https://eprint.iacr.org/2017/891.
>=20
>> Many people may have contributed to SUPERCOP already, but that doesn't me=
an
>> there aren't things you could do to make it more appealing to contributor=
s and
>> more of a community project,
>=20
> The logic in this sentence is impeccable, and is already illustrated by
> many SUPERCOP improvements through the years from an increasing number
> of contributors, as summarized in the 87 release announcements so far on
> the relevant public mailing list, which you're welcome to study in
> detail along with the 400 megabytes of current code and as many previous
> versions as you're interested in. That's also the mailing list where
> people are told to send patches, as you'll see if you RTFM.
>=20
>> So Linux distributions may not want to take on the legal risk of
>> distributing it
>=20
> This is a puzzling comment. A moment ago we were talking about the
> possibility of useful sharing of (e.g.) ChaCha20 implementations between
> SUPERCOP and the Linux kernel, avoiding pointless fracturing of the
> community's development process for these implementations. This doesn't
> mean that the kernel should be grabbing implementations willy-nilly from
> SUPERCOP---surely the kernel should be doing security audits, and the
> kernel already has various coding requirements, and the kernel requires
> GPL compatibility, while putting any of these requirements into SUPERCOP
> would be counterproductive.
>=20
> If you mean having the entire SUPERCOP benchmarking package distributed
> through Linux distributions, I have no idea what your motivation is or
> how this is supposed to be connected to anything else we're discussing.
> Obviously SUPERCOP's broad code-inclusion policies make this idea a
> non-starter.
>=20
>> nor may companies want to take on the risk of contributing.
>=20
> RTFM. People who submit code are authorizing public redistribution for
> benchmarking. It's up to them to decide if they want to allow more.
>=20
> ---Dan

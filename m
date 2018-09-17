From: Andy Lutomirski <luto@amacapital.net>
Subject: Re: [PATCH net-next v3 02/17] zinc: introduce minimal cryptography library
Date: Mon, 17 Sep 2018 07:51:54 -0700
Message-ID: <35BC21D7-01F4-4F91-A7E9-8D15DE5B95D6@amacapital.net>
References: <20180911214737.GA81235@gmail.com> <CAHmME9rFUruF-VN1pmU-k5nFsb9ppAPhPpW-5Ho9dKL2HCg4kA@mail.gmail.com> <20180911233015.GD11474@lunn.ch> <20180911.165739.2032677219588723041.davem@davemloft.net> <CALCETrXrJPcs3h9CtF50N4k2AGx3qzspJd_UW3t+KGYOj7+p=Q@mail.gmail.com> <CAKv+Gu8QgRo-Oex2Sk5unET3FMq+1Cp2btAWXCB8xsALxjatHg@mail.gmail.com>
Mime-Version: 1.0 (1.0)
Content-Type: text/plain;
        charset=utf-8
Content-Transfer-Encoding: quoted-printable
Cc: Andy Lutomirski <luto@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Andrew Lunn <andrew@lunn.ch>,
        "Jason A. Donenfeld" <Jason@zx2c4.com>,
        Eric Biggers <ebiggers@kernel.org>,
        Greg KH <gregkh@linuxfoundation.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        Samuel Neves <sneves@dei.uc.pt>,
        Jean-Philippe Aumasson <jeanphilippe.aumasson@gmail.com>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
To: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CAKv+Gu8QgRo-Oex2Sk5unET3FMq+1Cp2btAWXCB8xsALxjatHg@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org



> On Sep 16, 2018, at 10:26 PM, Ard Biesheuvel <ard.biesheuvel@linaro.org> w=
rote:

>=20
> As far as I can tell (i.e., as a user not a network dev), WireGuard is
> an excellent piece of code, and I would like to see it merged. I also
> think there is little disagreement about the quality of the proposed
> algorithm implementations and the usefulness of having a set of easy
> to use solid crypto primitives in addition to or complementing the
> current crypto API.
>=20
> I do have some concerns over how the code is organized though:
>=20
> * simd_relax() is currently not called by the crypto routines
> themselves. This means that the worst case scheduling latency is
> unbounded, which is unacceptable for the -rt kernel. The worst case
> scheduling latency should never be proportional to the input size.
> (Apologies for not spotting that earlier)
>=20
> * Using a cute name for the crypto library [that will end up being the
> preferred choice for casual use only] may confuse people, given that
> we have lots of code in crypto/ already. I'd much prefer using, e.g.,
> crypto/lib and crypto/api (regardless of where the arch specific
> pieces live)
>=20
> * I'd prefer the arch specific pieces to live under arch, but I can
> live with keeping them in a single place, as long as the arch
> maintainers have some kind of jurisdiction over them. I also think
> there should be some overlap between the maintainership
> responsibilities of the two generic pieces (api and lib).
>=20
> * (Nit) The GCC command line -include'd .h files contain variable and
> function definitions so they are actually .c files.

Hmm. I would suggest just getting rid of the -include magic entirely.  The r=
esulting ifdef will be more comprehensible.


> * The current organization of the code puts all available (for the
> arch) versions of all routines into a single module, which can only be
> built in once we update random.c to use Zinc's chacha20 routines. This
> bloats the core kernel (which is a huge deal for embedded systems that
> have very strict boot requirements). It also makes it impossible to
> simply blacklist a module if you, for instance, prefer to use the
> [potentially more power efficient] scalar code over the SIMD code when
> using a distro kernel.

I think the module organization needs to change. It needs to be possible to h=
ave chacha20 built in but AES or whatever as a module.

>=20
> [To summarize the 4 points above, I'd much rather see a more
> conventional organization where different parts are provided by
> different modules. I don't think the argument that inlining is needed
> for performance is actually valid, given that we have branch
> predictors and static keys, and the arch SIMD code is built as
> separate object files anyway]

I might have agreed before Spectre :(. Unfortunately, unless we do some magi=
c, I think the code would look something like:

if (static_branch_likely(have_simd)) arch_chacha20();

...where arch_chacha20 is a *pointer*. And that will generate a retpoline an=
d run very, very slowly.  (I just rewrote some of the x86 entry code to elim=
inate one retpoline. I got a 5% speedup on some tests according to the kbuil=
d bot.)

So, if we really wanted modules, we=E2=80=99d need a new dynamic patching me=
chanism.

I would suggest instead adding two boot (or debugfs) options:

simd=3Doff: disables simd_get using a static branch.

crypto_chacha20_nosimd: Does what it sounds like.

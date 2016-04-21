From: Stephan Mueller <smueller@chronox.de>
Subject: Re: [RFC][PATCH 0/6] /dev/random - a new approach
Date: Thu, 21 Apr 2016 15:09:24 +0200
Message-ID: <2820324.abt0t88sWo@tauon.atsec.com>
References: <9192755.iDgo3Omyqe@positron.chronox.de> <CAJU7zaL26c33wApqb=S_NCP9gTZPMGnQ+DACjEi6vnXfTq6XkA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Ted Tso <tytso@mit.edu>, Herbert Xu <herbert@gondor.apana.org.au>,
	Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	Sandy Harris <sandyinchina@gmail.com>
To: Nikos Mavrogiannopoulos <nmav@gnutls.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CAJU7zaL26c33wApqb=S_NCP9gTZPMGnQ+DACjEi6vnXfTq6XkA@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Am Donnerstag, 21. April 2016, 15:03:37 schrieb Nikos Mavrogiannopoulos=
:

Hi Nikos,

> On Thu, Apr 21, 2016 at 11:11 AM, Stephan Mueller <smueller@chronox.d=
e>=20
wrote:
> > Hi Herbert, Ted,
> >=20
> > The venerable Linux /dev/random served users of cryptographic mecha=
nisms
> > well for a long time. Its behavior is well understood to deliver en=
tropic
> > data. In the last years, however, the Linux /dev/random showed sign=
s of
> > age where it has challenges to cope with modern computing environme=
nts
> > ranging from tiny embedded systems, over new hardware resources suc=
h as
> > SSDs, up to massive parallel systems as well as virtualized environ=
ments.
> >=20
> > With the experience gained during numerous studies of /dev/random, =
entropy
> > assessments of different noise source designs and assessing entropy
> > behavior in virtual machines and other special environments, I felt=
 to do
> > something about it.
> > I developed a different approach, which I call Linux Random Number
> > Generator (LRNG) to collect entropy within the Linux kernel. The ma=
in
> > improvements compared to the legacy /dev/random is to provide suffi=
cient
> > entropy during boot time as well as in virtual environments and whe=
n
> > using SSDs. A secondary design goal is to limit the impact of the e=
ntropy
> > collection on massive parallel systems and also allow the use accel=
erated
> > cryptographic primitives. Also, all steps of the entropic data proc=
essing
> > are testable. Finally massive performance improvements are visible =
at
> > /dev/urandom / get_random_bytes.
>=20
> [quote from pdf]
>=20
> > ... DRBG is =E2=80=9Cminimally=E2=80=9D seeded with 112^6 bits of e=
ntropy.
> > This is commonly achieved even before user space is initiated.
>=20
> Unfortunately one of the issues of the /dev/urandom interface is the
> fact that it may start providing random numbers even before the
> seeding is complete. From the above quote, I understand that this
> issue is not addressed by the new interface. That's a serious
> limitation (of the current and inherited by the new implementation),
> since most/all newly deployed systems from "cloud" images generate
> keys using /dev/urandom (for sshd for example) on boot, and it is
> unknown to these applications whether they operate with uninitialized
> seed.

That limitation is addressed with the getrandom system call. This call =
will=20
block until the initial seeding is provided. After the initial seeding,=
=20
getrandom behaves like /dev/urandom. This behavior is implemented alred=
y with=20
the legacy /dev/random and is preserved with the LRNG.
>=20
> While one could argue for using /dev/random, the unpredictability of
> the delay it incurs is prohibitive for any practical use. Thus I'd
> expect any new interface to provide a better /dev/urandom, by ensurin=
g
> that the kernel seed buffer is fully seeded prior to switching to
> userspace.
>=20
> About the rest of the design, I think it is quite clean. I think the
> DRBG choice is quite natural given the NIST recommendations, but have
> you considered using a stream cipher instead like chacha20 which in
> most of cases it would outperform the DRBG based on AES?

This can easily be covered by changing the DRBG implementation -- the c=
urrent=20
DRBG implementation in the kernel crypto API is implemented to operate =
like a=20
"block chaining mode" on top of the raw cipher. Thus, such change can b=
e=20
easily rolled in.

Ciao
Stephan

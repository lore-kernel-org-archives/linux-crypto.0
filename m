From: Nikos Mavrogiannopoulos <nmav@gnutls.org>
Subject: Re: [RFC][PATCH 0/6] /dev/random - a new approach
Date: Thu, 21 Apr 2016 15:03:37 +0200
Message-ID: <CAJU7zaL26c33wApqb=S_NCP9gTZPMGnQ+DACjEi6vnXfTq6XkA@mail.gmail.com>
References: <9192755.iDgo3Omyqe@positron.chronox.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Ted Tso <tytso@mit.edu>, Herbert Xu <herbert@gondor.apana.org.au>,
	Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	Sandy Harris <sandyinchina@gmail.com>
To: Stephan Mueller <smueller@chronox.de>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <9192755.iDgo3Omyqe@positron.chronox.de>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Thu, Apr 21, 2016 at 11:11 AM, Stephan Mueller <smueller@chronox.de>=
 wrote:
> Hi Herbert, Ted,
>
> The venerable Linux /dev/random served users of cryptographic mechani=
sms well
> for a long time. Its behavior is well understood to deliver entropic =
data. In
> the last years, however, the Linux /dev/random showed signs of age wh=
ere it has
> challenges to cope with modern computing environments ranging from ti=
ny embedded
> systems, over new hardware resources such as SSDs, up to massive para=
llel
> systems as well as virtualized environments.
>
> With the experience gained during numerous studies of /dev/random, en=
tropy
> assessments of different noise source designs and assessing entropy b=
ehavior in
> virtual machines and other special environments, I felt to do somethi=
ng about
> it.
> I developed a different approach, which I call Linux Random Number Ge=
nerator
> (LRNG) to collect entropy within the Linux kernel. The main improveme=
nts
> compared to the legacy /dev/random is to provide sufficient entropy d=
uring boot
> time as well as in virtual environments and when using SSDs. A second=
ary design
> goal is to limit the impact of the entropy collection on massive para=
llel
> systems and also allow the use accelerated cryptographic primitives. =
Also, all
> steps of the entropic data processing are testable. Finally massive p=
erformance
> improvements are visible at /dev/urandom / get_random_bytes.

[quote from pdf]
> ... DRBG is =E2=80=9Cminimally=E2=80=9D seeded with 112^6 bits of ent=
ropy.
> This is commonly achieved even before user space is initiated.

Unfortunately one of the issues of the /dev/urandom interface is the
fact that it may start providing random numbers even before the
seeding is complete. From the above quote, I understand that this
issue is not addressed by the new interface. That's a serious
limitation (of the current and inherited by the new implementation),
since most/all newly deployed systems from "cloud" images generate
keys using /dev/urandom (for sshd for example) on boot, and it is
unknown to these applications whether they operate with uninitialized
seed.

While one could argue for using /dev/random, the unpredictability of
the delay it incurs is prohibitive for any practical use. Thus I'd
expect any new interface to provide a better /dev/urandom, by ensuring
that the kernel seed buffer is fully seeded prior to switching to
userspace.

About the rest of the design, I think it is quite clean. I think the
DRBG choice is quite natural given the NIST recommendations, but have
you considered using a stream cipher instead like chacha20 which in
most of cases it would outperform the DRBG based on AES?

regards,
Nikos

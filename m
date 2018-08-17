From: "D. J. Bernstein" <djb@cr.yp.to>
Subject: Re: [PATCH v1 2/3] zinc: Introduce minimal cryptography library
Date: 17 Aug 2018 07:31:20 -0000
Message-ID: <20180817073120.12640.qmail@cr.yp.to>
References: <20180801072246.GA15677@sol.localdomain>
 <CAHmME9pbwj0RaX4YM9epGOSgDRNUt=GA4UzO_iKcW=Md7kG6JQ@mail.gmail.com>
 <20180814211229.GB24575@gmail.com>
 <20180815162819.22765.qmail@cr.yp.to>
 <20180815195732.GA79500@gmail.com>
 <20180816042454.15529.qmail@cr.yp.to>
 <20180816194620.GA185651@gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="ibTvN161/egqYuK8"
To: Eric Biggers <ebiggers@kernel.org>,
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
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org


--ibTvN161/egqYuK8
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Eric Biggers writes:
> If (more likely) you're talking about things like "use this NEON implementation
> on Cortex-A7 but this other NEON implementation on Cortex-A53", it's up the
> developers and community to test different CPUs and make appropriate decisions,
> and yes it can be very useful to have external benchmarks like SUPERCOP to refer
> to, and I appreciate your work in that area.

You seem to be talking about a process that selects (e.g.) ChaCha20
implementations as follows: manually inspect benchmarks of various
implementations on various CPUs, manually write code to map CPUs to
implementations, manually update the code as necessary for new CPUs, and
of course manually do the same for every other primitive that can see
differences between microarchitectures (which isn't something weird---
it's the normal situation after enough optimization effort).

This is quite a bit of manual work, so the kernel often doesn't do it,
so we end up with unhappy people talking about performance regressions.

For comparison, imagine one simple central piece of code in the kernel
to automatically do the following:

   When a CPU core is booted:
     For each primitive:
       Benchmark all implementations of the primitive on the core.
       Select the fastest for subsequent use on the core.

If this is a general-purpose mechanism (as in SUPERCOP, NaCl, and
libpqcrypto) rather than something ad-hoc (as in raid6), then there's no
manual work per primitive, and no work per implementation. Each CPU, old
or new, automatically obtains the fastest available code for that CPU.

The only cost is a moment of benchmarking at boot time. _If_ this is a
noticeable cost then there are many ways to speed it up: for example,
automatically copy the results across identical cores, automatically
copy the results across boots if the cores are unchanged, automatically
copy results from a central database indexed by CPU identifiers, etc.
The SUPERCOP database is evolving towards enabling this type of sharing.

> A lot of code can be shared, but in practice different environments have
> different constraints, and kernel programming in particular has some distinct
> differences from userspace programming.  For example, you cannot just use the
> FPU (including SSE, AVX, NEON, etc.) registers whenever you want to, since on
> most architectures they can't be used in some contexts such as hardirq context,
> and even when they *can* be used you have to run special code before and after
> which does things like saving all the FPU registers to the task_struct,
> disabling preemption, and/or enabling the FPU.

Is there some reason that each implementor is being pestered to handle
all this? Detecting FPU usage is a simple static-analysis exercise, and
the rest sounds like straightforward boilerplate that should be handled
centrally.

> But disabling preemption for
> long periods of time hurts responsiveness, so it's also desirable to yield the
> processor occasionally, which means that assembly implementations should be
> incremental rather than having a single entry point that does everything.

Doing this rewrite automatically is a bit more of a code-analysis
challenge, but the alternative approach of doing it by hand is insanely
error-prone. See, e.g., https://eprint.iacr.org/2017/891.

> Many people may have contributed to SUPERCOP already, but that doesn't mean
> there aren't things you could do to make it more appealing to contributors and
> more of a community project,

The logic in this sentence is impeccable, and is already illustrated by
many SUPERCOP improvements through the years from an increasing number
of contributors, as summarized in the 87 release announcements so far on
the relevant public mailing list, which you're welcome to study in
detail along with the 400 megabytes of current code and as many previous
versions as you're interested in. That's also the mailing list where
people are told to send patches, as you'll see if you RTFM.

> So Linux distributions may not want to take on the legal risk of
> distributing it

This is a puzzling comment. A moment ago we were talking about the
possibility of useful sharing of (e.g.) ChaCha20 implementations between
SUPERCOP and the Linux kernel, avoiding pointless fracturing of the
community's development process for these implementations. This doesn't
mean that the kernel should be grabbing implementations willy-nilly from
SUPERCOP---surely the kernel should be doing security audits, and the
kernel already has various coding requirements, and the kernel requires
GPL compatibility, while putting any of these requirements into SUPERCOP
would be counterproductive.

If you mean having the entire SUPERCOP benchmarking package distributed
through Linux distributions, I have no idea what your motivation is or
how this is supposed to be connected to anything else we're discussing.
Obviously SUPERCOP's broad code-inclusion policies make this idea a
non-starter.

> nor may companies want to take on the risk of contributing.

RTFM. People who submit code are authorizing public redistribution for
benchmarking. It's up to them to decide if they want to allow more.

---Dan

--ibTvN161/egqYuK8
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIcBAEBAgAGBQJbdnnIAAoJELDADU47DlRZROAP/0SxUKbr7jw7SAswEEtNMD4V
Oz5SCoBygaCBpG+2X1+1pJ76v7osFmQ1dU73jE87bxTVsiu+1YciG5jSKrNBLjrG
WzBTK/NB4Owerpqq3+SRzJL6Zy+XI7ROIxDcVE/05WvpezLNK7jpTP5o9PUo5sB7
G+O2jBY6q7/u7uXfwNQewvLTNZHq802tIl+JcaFY2DH6Yh5/RLtmdxLTGpB61KdK
0pbFUUkNZljQhsiwlwl/Dd1U9HarYfGOZ5MWf70V30M2qu1znzGrYFLe9Kkhtbrn
NfNkmdv6WzgUI5Ld7OyaSWuZ9pA7GjFU3qyhgg81aVEChMBPZxwAB0twYeRPIAxp
XFyX5pLcqlVfqvbh2LWaKXvXLO1LJF8CPEV8w+t136mrprre51Yf+lK2y/ySXsVn
JooyXIbYkOkZxTCPe+u3ChS99D8BA+SdE0AUuHwAzyQ+b7JdsQz3Uzx6hITCzkYu
5MDLYf44/ANaiO/EWmtOIl8GgnqGEU/0cuIO8luAr3BA3prsQhOSP4ICldgP6+O8
zSvf5QwGmFX9RsLt/0myqnKOySF/u8pCHNudIVqRCgrSh9aRM1+ngqjIgSI+lU0G
O+DlOqJfDQIo80ya8gOr60jp6LLoQkPGEgSJuZWAhxotARVmeNDLK2PVW/RygIHX
M30mbrOyTkTsuTq9wZjI
=DlV9
-----END PGP SIGNATURE-----

--ibTvN161/egqYuK8--

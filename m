From: Huang Ying <ying.huang@intel.com>
Subject: Re: [RFC PATCH crypto] AES: Add support to Intel AES-NI
	instructions
Date: Mon, 15 Dec 2008 13:14:59 +0800
Message-ID: <1229318099.5936.224.camel@yhuang-dev.sh.intel.com>
References: <1229054926.5936.160.camel@yhuang-dev.sh.intel.com>
	 <20081212195722.GA24489@Chamillionaire.breakpoint.cc>
	 <1229307542.5936.204.camel@yhuang-dev.sh.intel.com>
	 <20081215033842.GA28499@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-3knk14zbL8iGHq744xav"
Cc: "Siddha, Suresh B" <suresh.b.siddha@intel.com>,
	Sebastian Andrzej Siewior <linux-crypto@ml.breakpoint.cc>,
	"akpm@linux-foundation.org" <akpm@linux-foundation.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
	"mingo@elte.hu" <mingo@elte.hu>,
	"tglx@linutronix.de" <tglx@linutronix.de>
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:16445 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750746AbYLOFPD (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Mon, 15 Dec 2008 00:15:03 -0500
In-Reply-To: <20081215033842.GA28499@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>


--=-3knk14zbL8iGHq744xav
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Mon, 2008-12-15 at 11:38 +0800, Herbert Xu wrote:
> On Mon, Dec 15, 2008 at 10:19:02AM +0800, Huang Ying wrote:
> >=20
> > The general x86 implementation is used as the fall back for new AES-NI
> > based implementation. Because AES-NI can not be used in kernel soft_irq
> > context. If crypto layer is used to access general x86 implementation,
>=20
> Why is that? The VIA PadLock also "touches" the SSE state but we still
> use it on softirq paths.
>=20
> In fact Suresh told me earlier that your AES instruction wasn't
> going to have the SSE problems that VIA had, is this not the case?

The PadLock instructions don't use/touch SSE registers, but might cause
DNA fault when CR0.TS is set. So it is sufficient just to clear CR0.TS
before executed.

The AES-NI instructions do use SSE registers. Considering the following
situation:

1. In kernel, code path using SSE registers are executed, user space SSE
state is saved if necessary.
2. An interrupt/soft_irq comes, and encrypt/decrypt with AES-NI is
executed. The SSE state of code path 1 is destroyed.

To solve the above issue, the following methods can be used:

a. Do not touch SSE state in soft_irq
b. Disable/restore soft_irq in kernel_fpu_begin/kernel_fpu_end
c. Use a per-CPU data structure to save kernel FPU state during
soft_irq.

The mothod a is used in patch.

Best Regards,
Huang Ying


--=-3knk14zbL8iGHq744xav
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEABECAAYFAklF59EACgkQKhFGF+eHlpgjVQCgmjx4n+Vqzx/CO7UJeiSBqp3k
X3MAniUEuXswKYo2uRjLE1P1K+QMU2YD
=xQ4I
-----END PGP SIGNATURE-----

--=-3knk14zbL8iGHq744xav--


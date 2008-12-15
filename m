From: Huang Ying <ying.huang@intel.com>
Subject: Re: [RFC PATCH crypto] AES: Add support to Intel
	AES-NI	instructions
Date: Mon, 15 Dec 2008 13:48:51 +0800
Message-ID: <1229320131.5936.232.camel@yhuang-dev.sh.intel.com>
References: <1229054926.5936.160.camel@yhuang-dev.sh.intel.com>
	 <20081212195722.GA24489@Chamillionaire.breakpoint.cc>
	 <1229307542.5936.204.camel@yhuang-dev.sh.intel.com>
	 <20081215033842.GA28499@gondor.apana.org.au>
	 <1229318099.5936.224.camel@yhuang-dev.sh.intel.com>
	 <20081215052106.GA29324@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-nZ3Rj0rY396gsJUsIYn/"
Cc: "Siddha, Suresh B" <suresh.b.siddha@intel.com>,
	Sebastian Andrzej Siewior <linux-crypto@ml.breakpoint.cc>,
	"akpm@linux-foundation.org" <akpm@linux-foundation.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
	"mingo@elte.hu" <mingo@elte.hu>,
	"tglx@linutronix.de" <tglx@linutronix.de>
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mga03.intel.com ([143.182.124.21]:48695 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750904AbYLOFsy (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Mon, 15 Dec 2008 00:48:54 -0500
In-Reply-To: <20081215052106.GA29324@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>


--=-nZ3Rj0rY396gsJUsIYn/
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Mon, 2008-12-15 at 13:21 +0800, Herbert Xu wrote:
> On Mon, Dec 15, 2008 at 01:14:59PM +0800, Huang Ying wrote:
> >=20
> > The PadLock instructions don't use/touch SSE registers, but might cause
> > DNA fault when CR0.TS is set. So it is sufficient just to clear CR0.TS
> > before executed.
> >=20
> > The AES-NI instructions do use SSE registers. Considering the following
>=20
> This really sucks as more than half of the kernel AES users are
> in softirq context.  Someone hit the guy who designed this with
> a clue-bat please!
>=20
> > To solve the above issue, the following methods can be used:
> >=20
> > a. Do not touch SSE state in soft_irq
> > b. Disable/restore soft_irq in kernel_fpu_begin/kernel_fpu_end
> > c. Use a per-CPU data structure to save kernel FPU state during
> > soft_irq.
> >=20
> > The mothod a is used in patch.
>=20
> Could you run the tcrypt speed test on this and measure the
> difference between the native AES vs. the fallback? Depending
> on the difference I think we'd want to consider b) or c).

I do not have appropriate machine at hand, I will contact my colleague
for testing and post the results later.

Best Regards,
Huang Ying


--=-nZ3Rj0rY396gsJUsIYn/
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEABECAAYFAklF77wACgkQKhFGF+eHlpj8XgCdF0kGcQCT3q5W9gNiXnugA/s7
4U0An2iecvuNhoing8wIMe5lVKR5NT2V
=eMdo
-----END PGP SIGNATURE-----

--=-nZ3Rj0rY396gsJUsIYn/--


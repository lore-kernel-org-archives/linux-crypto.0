From: Huang Ying <ying.huang@intel.com>
Subject: Re: [RFC PATCH crypto] AES: Add support to Intel
	AES-NI	instructions
Date: Wed, 17 Dec 2008 09:14:22 +0800
Message-ID: <1229476462.5936.314.camel@yhuang-dev.sh.intel.com>
References: <1229054926.5936.160.camel@yhuang-dev.sh.intel.com>
	 <20081212195722.GA24489@Chamillionaire.breakpoint.cc>
	 <1229307542.5936.204.camel@yhuang-dev.sh.intel.com>
	 <20081215033842.GA28499@gondor.apana.org.au>
	 <1229318099.5936.224.camel@yhuang-dev.sh.intel.com>
	 <20081215052106.GA29324@gondor.apana.org.au>
	 <20081215123801.GA32485@gondor.apana.org.au>
	 <20081216233128.GA13942@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-8wFTIG7607i674qXOQEh"
Cc: "Siddha, Suresh B" <suresh.b.siddha@intel.com>,
	Sebastian Andrzej Siewior <linux-crypto@ml.breakpoint.cc>,
	"akpm@linux-foundation.org" <akpm@linux-foundation.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
	"mingo@elte.hu" <mingo@elte.hu>,
	"tglx@linutronix.de" <tglx@linutronix.de>
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1756111AbYLQBOi@vger.kernel.org>
In-Reply-To: <20081216233128.GA13942@gondor.apana.org.au>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org


--=-8wFTIG7607i674qXOQEh
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Wed, 2008-12-17 at 07:31 +0800, Herbert Xu wrote:
> On Mon, Dec 15, 2008 at 11:38:01PM +1100, Herbert Xu wrote:
> > On Mon, Dec 15, 2008 at 04:21:06PM +1100, Herbert Xu wrote:
> > >
> > > > a. Do not touch SSE state in soft_irq
> > > > b. Disable/restore soft_irq in kernel_fpu_begin/kernel_fpu_end
> > > > c. Use a per-CPU data structure to save kernel FPU state during
> > > > soft_irq.
> =20
> > Here's another option
> >=20
> > d. When we're in interrupt context, schedule a task to perform
> > the encryption asynchronously.
>=20
> We can also hybridise b. and d.:
>=20
> e. When we're in interrupt context, if TS is clear, then we defer
> the operation to a thread.  Otherwise if user-space has touched
> the FPU we save the state, if not then we simply clear TS.  In
> either case we perform the operation immediately and then reset
> TS if user-space didn't touch the FPU.
>=20
> This is based on the fact that it should be fairly rare for us
> to interrupt a kernel FPU/SSE operation.  The common case would
> be interrupting a user process or a kernel context which is not
> engaging in any kernel FPU operations.

Yes. This is a better solution with much better performance. How about
hybridise b. and a.:

f. if TS is clear, then use x86_64 implementation. Otherwise if
user-space has touched the FPU, we save the state, if not then simply
clear TS.

I think that could be simpler to be implemented.

Best Regards,
Huang Ying


--=-8wFTIG7607i674qXOQEh
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEABECAAYFAklIUmsACgkQKhFGF+eHlpi7ngCfUVxnHxaNgJ/3tA++ZdAVP4tl
XGUAoJvXU1klnocrdYPax0mM+0SxMSwJ
=Acci
-----END PGP SIGNATURE-----

--=-8wFTIG7607i674qXOQEh--

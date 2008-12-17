From: Huang Ying <ying.huang@intel.com>
Subject: Re: [RFC PATCH crypto] AES: Add support to
	Intel	AES-NI	instructions
Date: Wed, 17 Dec 2008 11:33:39 +0800
Message-ID: <1229484819.5936.337.camel@yhuang-dev.sh.intel.com>
References: <E1LClB3-0006WP-9J@gondolin.me.apana.org.au>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-KmrgkliXSkUKqDuWbkyH"
Cc: "Siddha, Suresh B" <suresh.b.siddha@intel.com>,
	"linux-crypto@ml.breakpoint.cc" <linux-crypto@ml.breakpoint.cc>,
	"akpm@linux-foundation.org" <akpm@linux-foundation.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
	"mingo@elte.hu" <mingo@elte.hu>,
	"tglx@linutronix.de" <tglx@linutronix.de>
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1757617AbYLQDdx@vger.kernel.org>
In-Reply-To: <E1LClB3-0006WP-9J@gondolin.me.apana.org.au>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org


--=-KmrgkliXSkUKqDuWbkyH
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Wed, 2008-12-17 at 09:26 +0800, Herbert Xu wrote:
> Huang Ying <ying.huang@intel.com> wrote:
> >
> > f. if TS is clear, then use x86_64 implementation. Otherwise if
> > user-space has touched the FPU, we save the state, if not then simply
> > clear TS.
>=20
> Well I'd rather avoid using the x86_64 implementation ever because
> unless the chip guys have really screwed up we should be looking at
> a difference of at least a factor of 10.
>=20
> BTW I wasn't very clear in the original email.  You'd only do the
> asynchronous operation for CBC/ECB.  For the simple AES case I
> suppose we'll just have to stick to the x86_64 fallback.  This'll
> really suck for disk encryption but I guess you could always add
> an LRW/XTS mode to your code.

It seems that asynchronous operations are only provided in blkcipher
level not cipher level. So the situation may be as follow:

- Now an AES core block algorithm is implemented with AES-NI as
CRYPTO_ALG_TYPE_CIPHER, which can benefit all modes (CBC, LRW, etc). But
because it seems that there is no asynchronous interface for
CRYPTO_ALG_TYPE_CIPHER, the AES core block algorithm can not use a
thread to defer real operations.

- To take full advantage of AES-NI pipeline implementation, at least
"cbc(aes)", "ecb(aes)" and "ctr(aes)" should be implemented as
CRYPTO_ALG_TYPE_ABLKCIPHER. So a thread can be used to defer real
operation upon soft_irq.

Because the combination that kernel process context FPU usage + soft_irq
AES usage is fairly rare, I think the above combination is acceptable.
That is,

- In AES core block algorithm implementation with AES-NI, use x86_64
implementation for the combination above.

- In "cbc(aes)", "ecb(aes)" and "ctr(aes)", use thread deferring for the
combination above.

Best Regards,
Huang Ying


--=-KmrgkliXSkUKqDuWbkyH
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEABECAAYFAklIcwcACgkQKhFGF+eHlphuAACgpZzxjDiwSuFxF84p2eIHFEot
DPUAn0Yn0fcJORJk3W9HhTzULovzRVVl
=kdOh
-----END PGP SIGNATURE-----

--=-KmrgkliXSkUKqDuWbkyH--

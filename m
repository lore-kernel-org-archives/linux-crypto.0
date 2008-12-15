From: Huang Ying <ying.huang@intel.com>
Subject: Re: [RFC PATCH crypto] AES: Add support to Intel
	AES-NI	instructions
Date: Mon, 15 Dec 2008 10:19:02 +0800
Message-ID: <1229307542.5936.204.camel@yhuang-dev.sh.intel.com>
References: <1229054926.5936.160.camel@yhuang-dev.sh.intel.com>
	 <20081212195722.GA24489@Chamillionaire.breakpoint.cc>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-cRS9AB20f1NDRS2ambDX"
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
	"akpm@linux-foundation.org" <akpm@linux-foundation.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
	"mingo@elte.hu" <mingo@elte.hu>,
	"tglx@linutronix.de" <tglx@linutronix.de>
To: Sebastian Andrzej Siewior <linux-crypto@ml.breakpoint.cc>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:24814 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751707AbYLOCTG (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Sun, 14 Dec 2008 21:19:06 -0500
In-Reply-To: <20081212195722.GA24489@Chamillionaire.breakpoint.cc>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>


--=-cRS9AB20f1NDRS2ambDX
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Sat, 2008-12-13 at 03:57 +0800, Sebastian Andrzej Siewior wrote:
> * Huang Ying | 2008-12-12 12:08:46 [+0800]:
>=20
> >Add support to Intel AES-NI instructions for x86_64 platform.
> >
> >Intel AES-NI is a new set of Single Instruction Multiple Data (SIMD)
> >instructions that are going to be introduced in the next generation of
> >Intel processor, as of 2009. These instructions enable fast and secure
> >data encryption and decryption, using the Advanced Encryption Standard
> >(AES), defined by FIPS Publication number 197.  The architecture
> >introduces six instructions that offer full hardware support for
> >AES. Four of them support high performance data encryption and
> >decryption, and the other two instructions support the AES key
> >expansion procedure.
> >
> >The white paper can be downloaded from:
> >
> >http://softwarecommunity.intel.com/isn/downloads/intelavx/AES-Instructio=
ns-Set_WP.pdf
> >
> >AES may be used in soft_irq context, but MMX/SSE context can not be
> >touched safely in soft_irq context. So in_interrupt() is checked, if
> >in IRQ or soft_irq context, the general x86_64 implementation are used
> >instead.
>=20
> Nice work. A few things:
> - Did you rename the "old" x86 functions to avoid a clash?
>   So you bypass the crypto layer in case you can't handle the operation.
>   Does this improve the performace or just saves key strokes? Not sure
>   what the best sollution could be....

The general x86 implementation is used as the fall back for new AES-NI
based implementation. Because AES-NI can not be used in kernel soft_irq
context. If crypto layer is used to access general x86 implementation,
we will have tfm_ctx alignment issue, because AES-NI need tfm_ctx to be
16 byte aligned.

> - unless I've read the code too fast, it does not work if someone sets th=
e
>   key in user context and starts an encryption in softirq context.

Oh, I should use struct crypto_aes_ctx instead of define struct aes_ctx.
The tfm_ctx definition is different. I will fix this. Except that, is
there any other issue?

> - aes_ctx is somehow bad. You are using this for a function and a
>   struct. An Intel prefix would be nice (in case of the struct). On a
>   second thought, any reason why you can't use crypto_aes_ctx?

Yes. I will use that. The only issue is that AES-NI need scheduled key
to be 16 bytes aligned, so we need move key_length in struct
crypto_aes_ctx to the end of the struct.

> - Is this an Intel thing or is going to be part of X86 and also
>   available to others (like mmx). In that case the Intel prefix may be
>   "wrong".

Now it is an Intel thing. But in the future it may become part of x86.
Intel named it as AES-NI (AES New Instructions), but name like
aes_ni_aes_set_key is not good too. Does aes_ni_set_key sound better?

> - does the cpu support more than just pure aes e.g. block modes? In case
>   it does not, does the perfomance improve if you implement lets say
>   cbc(aes) and do the xor with sse in order to save a few
>   kernel_fpu_begin() calls? I'm just asking because I saw a similar
>   thing and PowerPC and the AltiVec unit. Maybe it is cheap on x86 :)

Yes. AES-NI can benefit not only block modes. And the pipeline
implementation of AES-NI can benefit cbc(aes) decryption and ctr(aes)
even more (described in detail in white paper). We will work on that.

> - I can't see how why the intel-aes alias is required.

Yes. I will remove it.

Best Regards,
Huang Ying


--=-cRS9AB20f1NDRS2ambDX
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEABECAAYFAklFvpMACgkQKhFGF+eHlpgWyQCgnN/6ckmaEdUGCvq+QjIma7qB
mxcAoIESRxdoe2MC8HhCLJv9YlIyu3yB
=7Khl
-----END PGP SIGNATURE-----

--=-cRS9AB20f1NDRS2ambDX--


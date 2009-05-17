From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: understanding concept, async block ciphers
Date: Sun, 17 May 2009 11:38:11 +1000
Message-ID: <20090517013811.GA7183@gondor.apana.org.au>
References: <aa09d86e0905120221n2dadd1e5jd99a7adc11658e2f@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-crypto@vger.kernel.org
To: =?utf-8?B?0KHQtdGA0LPQtdC5INCc0LjRgNC+0L3QvtCy?= <ierton@gmail.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from rhun.apana.org.au ([64.62.148.172]:58669 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753024AbZEQBiP (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Sat, 16 May 2009 21:38:15 -0400
Content-Disposition: inline
In-Reply-To: <aa09d86e0905120221n2dadd1e5jd99a7adc11658e2f@mail.gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

=D0=A1=D0=B5=D1=80=D0=B3=D0=B5=D0=B9 =D0=9C=D0=B8=D1=80=D0=BE=D0=BD=D0=BE=
=D0=B2 <ierton@gmail.com> wrote:
>
> 1. Whats the difference between async crypto_alg's with
>    .cra_type =3D CRYPTO_ALG_TYPE_BLKCIPHER | CRYPTO_ALG_ASYNC
> and
>    .cra_type =3D CRYPTO_ALG_TYPE_ABLKCIPHER
>=20
> Seems, that both are async. What is typical use-cases for them?

No, only the latter is async.

> 2. What are the rules for naming my alorithms?
> I looked in code, and think, that name is constructed like
> template_name1 ( template_name2 ( ... ( algorithm_name ) ... )
>=20
> For example (as i saw in tcrypt.c), if my crypto_alg has
>   .cra_flags =3D CRYPTO_ALG_TYPE_CIPHER ,
>   .cra_name =3D   "des3_ede"
> then it is possible to alloc CRYPTO_ALG_TYPE_BLKCIPHER request by
> names  "cbc(des3_ede)"  or "ecb(des3_ede)" and
> CRYPTO_ALG_TYPE_BLKCIPHER  | CRYPTO_ALG_ASYNC  request with
> "cryptd(cbc(des3_ede)))" ?   Am i right ?

Yes, that's the correct algorithm name.  Each implementation
has two names, the algorithm and an implementation-specific
driver name.  The driver name is the unique identifier for that
implementation and/or device.

Cheers,
--=20
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
--
To unsubscribe from this list: send the line "unsubscribe linux-crypto"=
 in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: AEAD: Having separate underlying cipher handle for each request
Date: Wed, 6 Jul 2016 14:31:49 +0800
Message-ID: <20160706063149.GA14106@gondor.apana.org.au>
References: <CAAUqJDvY9x+iOkH_vNQS9+qV+ONkbfgprOKFGcRXNe2788JnBA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-crypto@vger.kernel.org
To: Ondrej =?utf-8?B?TW9zbsOhxI1law==?= <omosnacek@gmail.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:41454 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750779AbcGFHDu (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 6 Jul 2016 03:03:50 -0400
Content-Disposition: inline
In-Reply-To: <CAAUqJDvY9x+iOkH_vNQS9+qV+ONkbfgprOKFGcRXNe2788JnBA@mail.gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Ondrej Mosn=C3=A1=C4=8Dek <omosnacek@gmail.com> wrote:
> Hi,
>=20
> I'm trying to experimentally implement the GCM-SIV AEAD algorithm fro=
m
> [1] for the Linux crypto API and I've ran into a problem...
>=20
> Basically, the encryption/decryption process starts by deriving a
> so-called "record-encryption key" from the nonce (by encrypting it
> using another key) and this key is then used to encrypt the plaintext
> in CTR mode and to encrypt the final authentication tag (otherwise it
> works similarly to GCM).
>=20
> Since the API is asynchronous and multiple requests can be executed i=
n
> parallel over a single cipher handle (according to [2]), I need to
> have a separate underlying cipher handle for each AEAD request.
>=20
> Now this is a problem, because aead_request has no init/destroy
> mechanism where I could allocate/free the cipher handle, which means =
I
> would have to do this inside the encrypt/decrypt function. AFAIK,
> allocating with GFP_KERNEL inside encrypt/decrypt functions is
> problematic, as they may be called from an atomic context.
>=20
> Besides, it seems that also the crypto_*_setkey functions are not
> guaranteed to be atomic [3], and I will need to call such function
> either way... OTOH, the CTR mode/AES driver should not really need to
> allocate any memory there, so this may be tolerable...
>=20
> Does anyone have any ideas how to deal with this?

Well you're pretty much screwed as far as performance is concerned.
So just postpone all processing to process context and allocate a new
tfm for each request.

Cheers,
--=20
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt

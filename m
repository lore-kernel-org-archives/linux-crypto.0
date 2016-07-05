From: Stephan Mueller <smueller@chronox.de>
Subject: Re: AEAD: Having separate underlying cipher handle for each request
Date: Tue, 05 Jul 2016 18:11:41 +0200
Message-ID: <12765125.UxRRnhuqVV@tauon.atsec.com>
References: <CAAUqJDvY9x+iOkH_vNQS9+qV+ONkbfgprOKFGcRXNe2788JnBA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-crypto@vger.kernel.org
To: Ondrej =?utf-8?B?TW9zbsOhxI1law==?= <omosnacek@gmail.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.eperm.de ([89.247.134.16]:38728 "EHLO mail.eperm.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755160AbcGEQLu convert rfc822-to-8bit (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 5 Jul 2016 12:11:50 -0400
In-Reply-To: <CAAUqJDvY9x+iOkH_vNQS9+qV+ONkbfgprOKFGcRXNe2788JnBA@mail.gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Am Dienstag, 5. Juli 2016, 13:44:05 schrieb Ondrej Mosn=C3=A1=C4=8Dek:

Hi Ondrej,

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

I have not yet looked into [1], but it sounds like a specific GCM case,=
 just=20
like RFC4106 formatting.

Did you consider the structure discussion in [4] and add a specific han=
dler=20
like the rfc4106() handler on top of GCM?

[4] https://www.kernel.org/doc/htmldocs/crypto-API/ch02s07.html
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
>=20
> BTW, for justification of deriving the key from the nonce see section
> 9 of [1]. I don't really like the design decision, but there seems to
> be no better way to achieve the same property...
>=20
> Thanks,
> Ondrej Mosn=C3=A1=C4=8Dek
>=20
> [1] https://tools.ietf.org/html/draft-irtf-cfrg-gcmsiv-01
> [2] https://www.kernel.org/doc/htmldocs/crypto-API/ch05s03.html
> [3] https://www.spinics.net/lists/linux-crypto/msg17733.html
> --
> To unsubscribe from this list: send the line "unsubscribe linux-crypt=
o" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


Ciao
Stephan

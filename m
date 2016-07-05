From: =?UTF-8?B?T25kcmVqIE1vc27DocSNZWs=?= <omosnacek@gmail.com>
Subject: AEAD: Having separate underlying cipher handle for each request
Date: Tue, 5 Jul 2016 13:44:05 +0200
Message-ID: <CAAUqJDvY9x+iOkH_vNQS9+qV+ONkbfgprOKFGcRXNe2788JnBA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
To: linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-oi0-f53.google.com ([209.85.218.53]:35544 "EHLO
	mail-oi0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933021AbcGELoN convert rfc822-to-8bit (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 5 Jul 2016 07:44:13 -0400
Received: by mail-oi0-f53.google.com with SMTP id r2so225546479oih.2
        for <linux-crypto@vger.kernel.org>; Tue, 05 Jul 2016 04:44:07 -0700 (PDT)
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi,

I'm trying to experimentally implement the GCM-SIV AEAD algorithm from
[1] for the Linux crypto API and I've ran into a problem...

Basically, the encryption/decryption process starts by deriving a
so-called "record-encryption key" from the nonce (by encrypting it
using another key) and this key is then used to encrypt the plaintext
in CTR mode and to encrypt the final authentication tag (otherwise it
works similarly to GCM).

Since the API is asynchronous and multiple requests can be executed in
parallel over a single cipher handle (according to [2]), I need to
have a separate underlying cipher handle for each AEAD request.

Now this is a problem, because aead_request has no init/destroy
mechanism where I could allocate/free the cipher handle, which means I
would have to do this inside the encrypt/decrypt function. AFAIK,
allocating with GFP_KERNEL inside encrypt/decrypt functions is
problematic, as they may be called from an atomic context.

Besides, it seems that also the crypto_*_setkey functions are not
guaranteed to be atomic [3], and I will need to call such function
either way... OTOH, the CTR mode/AES driver should not really need to
allocate any memory there, so this may be tolerable...

Does anyone have any ideas how to deal with this?

BTW, for justification of deriving the key from the nonce see section
9 of [1]. I don't really like the design decision, but there seems to
be no better way to achieve the same property...

Thanks,
Ondrej Mosn=C3=A1=C4=8Dek

[1] https://tools.ietf.org/html/draft-irtf-cfrg-gcmsiv-01
[2] https://www.kernel.org/doc/htmldocs/crypto-API/ch05s03.html
[3] https://www.spinics.net/lists/linux-crypto/msg17733.html

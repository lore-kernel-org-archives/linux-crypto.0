From: =?UTF-8?B?T25kcmVqIE1vc27DocSNZWs=?= <omosnacek@gmail.com>
Subject: Re: AEAD: Having separate underlying cipher handle for each request
Date: Wed, 6 Jul 2016 15:07:42 +0200
Message-ID: <CAAUqJDsM9EwHUXB7R4shuRF9pMrP__pOqYgOHhU0c_etObMMfQ@mail.gmail.com>
References: <CAAUqJDvY9x+iOkH_vNQS9+qV+ONkbfgprOKFGcRXNe2788JnBA@mail.gmail.com>
 <12765125.UxRRnhuqVV@tauon.atsec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-crypto@vger.kernel.org
To: Stephan Mueller <smueller@chronox.de>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-oi0-f51.google.com ([209.85.218.51]:34208 "EHLO
	mail-oi0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751782AbcGFNHo convert rfc822-to-8bit (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 6 Jul 2016 09:07:44 -0400
Received: by mail-oi0-f51.google.com with SMTP id s66so269298766oif.1
        for <linux-crypto@vger.kernel.org>; Wed, 06 Jul 2016 06:07:44 -0700 (PDT)
In-Reply-To: <12765125.UxRRnhuqVV@tauon.atsec.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi Stephan,

2016-07-05 18:11 GMT+02:00, Stephan Mueller <smueller@chronox.de>:
> Am Dienstag, 5. Juli 2016, 13:44:05 schrieb Ondrej Mosn=C3=A1=C4=8Dek=
:
>
> Hi Ondrej,
>
>> Hi,
>>
>> I'm trying to experimentally implement the GCM-SIV AEAD algorithm fr=
om
>> [1] for the Linux crypto API and I've ran into a problem...
>>
>> Basically, the encryption/decryption process starts by deriving a
>> so-called "record-encryption key" from the nonce (by encrypting it
>> using another key) and this key is then used to encrypt the plaintex=
t
>> in CTR mode and to encrypt the final authentication tag (otherwise i=
t
>> works similarly to GCM).
>
> I have not yet looked into [1], but it sounds like a specific GCM cas=
e, just
>
> like RFC4106 formatting.
>
> Did you consider the structure discussion in [4] and add a specific h=
andler
>
> like the rfc4106() handler on top of GCM?
>
> [4] https://www.kernel.org/doc/htmldocs/crypto-API/ch02s07.html

Yes, if it were possible, I would certainly do it in such way :)
Unfortunately, this wouldn't work, since there are some significant
differences. For example, in GCM the initial counter block for CTR
encryption is derived directly from the nonce, while in GCM-SIV the
authentication tag is used as the ICB (with MSB set to 1).

Actually, it seems the authors tried to be clever and changed the bit
order to big endian (in gf128mul's terms it uses ble ordering instead
of lle), so even GHASH (here called POLYVAL) may need to be
reimplemented :/

Cheers,
Ondrej

>>
>> Since the API is asynchronous and multiple requests can be executed =
in
>> parallel over a single cipher handle (according to [2]), I need to
>> have a separate underlying cipher handle for each AEAD request.
>>
>> Now this is a problem, because aead_request has no init/destroy
>> mechanism where I could allocate/free the cipher handle, which means=
 I
>> would have to do this inside the encrypt/decrypt function. AFAIK,
>> allocating with GFP_KERNEL inside encrypt/decrypt functions is
>> problematic, as they may be called from an atomic context.
>>
>> Besides, it seems that also the crypto_*_setkey functions are not
>> guaranteed to be atomic [3], and I will need to call such function
>> either way... OTOH, the CTR mode/AES driver should not really need t=
o
>> allocate any memory there, so this may be tolerable...
>>
>> Does anyone have any ideas how to deal with this?
>>
>> BTW, for justification of deriving the key from the nonce see sectio=
n
>> 9 of [1]. I don't really like the design decision, but there seems t=
o
>> be no better way to achieve the same property...
>>
>> Thanks,
>> Ondrej Mosn=C3=A1=C4=8Dek
>>
>> [1] https://tools.ietf.org/html/draft-irtf-cfrg-gcmsiv-01
>> [2] https://www.kernel.org/doc/htmldocs/crypto-API/ch05s03.html
>> [3] https://www.spinics.net/lists/linux-crypto/msg17733.html
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-cryp=
to"
>> in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
>
> Ciao
> Stephan
>

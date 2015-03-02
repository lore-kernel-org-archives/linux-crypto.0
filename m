From: Milan Broz <gmazyland@gmail.com>
Subject: Re: [PATCH 0/2] crypto: talitos: Add AES-XTS mode
Date: Mon, 02 Mar 2015 15:37:28 +0100
Message-ID: <54F475A8.6030105@gmail.com>
References: <1424451610-5786-1-git-send-email-mort@bork.org> <54F464E4.8080204@freescale.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linuxppc-dev@lists.ozlabs.org, linux-crypto@vger.kernel.org
To: =?UTF-8?B?SG9yaWEgR2VhbnTEgw==?= <horia.geanta@freescale.com>,
	Martin Hicks <mort@bork.org>,
	Kim Phillips <kim.phillips@freescale.com>,
	Scott Wood <scottwood@freescale.com>,
	Kumar Gala <galak@kernel.crashing.org>,
	Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-wi0-f171.google.com ([209.85.212.171]:38278 "EHLO
	mail-wi0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755639AbbCBOhd (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 2 Mar 2015 09:37:33 -0500
Received: by wiwh11 with SMTP id h11so15345065wiw.3
        for <linux-crypto@vger.kernel.org>; Mon, 02 Mar 2015 06:37:31 -0800 (PST)
In-Reply-To: <54F464E4.8080204@freescale.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On 03/02/2015 02:25 PM, Horia Geant=C4=83 wrote:
> On 2/20/2015 7:00 PM, Martin Hicks wrote:
>> This adds the AES-XTS mode, supported by the Freescale SEC 3.3.2.
>>
>> One of the nice things about this hardware is that it knows how to d=
eal
>> with encrypt/decrypt requests that are larger than sector size, but =
that=20
>> also requires that that the sector size be passed into the crypto en=
gine
>> as an XTS cipher context parameter.
>>
>> When a request is larger than the sector size the sector number is
>> incremented by the talitos engine and the tweak key is re-calculated
>> for the new sector.
>>
>> I've tested this with 256bit and 512bit keys (tweak and data keys of=
 128bit
>> and 256bit) to ensure interoperability with the software AES-XTS
>> implementation.  All testing was done using dm-crypt/LUKS with
>> aes-xts-plain64.
>>
>> Is there a better solution that just hard coding the sector size to
>> (1<<SECTOR_SHIFT)?  Maybe dm-crypt should be modified to pass the
>> sector size along with the plain/plain64 IV to an XTS algorithm?
>=20
> AFAICT, SW implementation of xts mode in kernel (crypto/xts.c) is not
> aware of a sector size ("data unit size" in IEEE P1619 terminology):
> There's a hidden assumption that all the data send to xts in one requ=
est
> belongs to a single sector. Even more, it's supposed that the first
> 16-byte block in the request is "block 0" in the sector. These can be
> seen from the way the tweak ("T") value is computed.
> (Side note: there's no support of ciphertext stealing in crypto/xts.c=
 -
> i.e. sector sizes must be a multiple of underlying block cipher size =
-
> that is 16B.)
>=20
> If dm-crypt would be modified to pass sector size somehow, all in-ker=
nel
> xts implementations would have to be made aware of the change.
> I have nothing against this, but let's see what crypto maintainers ha=
ve
> to say...
>=20
> BTW, there were some discussions back in 2013 wrt. being able to
> configure / increase sector size, smth. crypto engines would benefit =
from:
> http://www.saout.de/pipermail/dm-crypt/2013-January/003125.html
> (experimental patch)
> http://www.saout.de/pipermail/dm-crypt/2013-March/003202.html
>=20
> The experimental patch sends sector size as the req->nbytes - hidden
> assumption: data size sent in an xts crypto request equals a sector.

There was no follow-up but the idea is not yet abandoned :-)

Dmcrypt will always use "sector" as a minimal unit
(and I believe sectors will by always multiple of block size so
no need for ciphertext stealing in XTS.)

=46or now, dmcrypt always use 512 bytes sector size.

If crypto API allows to encrypt more sectors in one run
(handling IV internally) dmcrypt can be modified of course.

But do not forget we can use another IV (not only sequential number)
e.g. ESSIV with XTS as well (even if it doesn't make much sense, some p=
eople
are using it).

Maybe the following question would be if the dmcrypt sector IV algorith=
ms
should moved into crypto API as well.
(But because I misused dmcrypt IVs hooks for some additional operations
for loopAES and old Truecrypt CBC mode, it is not so simple...)

Milan

From: =?UTF-8?B?SG9yaWEgR2VhbnTEgw==?= <horia.geanta@freescale.com>
Subject: Re: [PATCH 0/2] crypto: talitos: Add AES-XTS mode
Date: Wed, 11 Mar 2015 17:48:33 +0200
Message-ID: <550063D1.2070105@freescale.com>
References: <1424451610-5786-1-git-send-email-mort@bork.org>
	<54F464E4.8080204@freescale.com>	<54F475A8.6030105@gmail.com>
	<20150302220923.GC30523@darwin.bork.org>	<54F5D6D5.8070407@freescale.com>
	<CAJUS3Xnw66Eu6tvGPpdcet6KLjhKM=ptj8NRaztAVr0h_r+LqQ@mail.gmail.com>
	<54FD72E4.1060701@freescale.com>
 <CAJUS3XkY0tbYqBbU5HR7NT63UPFi5DO6XWuymbZnQaJEA5kkBw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: <linux-crypto@vger.kernel.org>,
	Scott Wood <scottwood@freescale.com>,
	<linuxppc-dev@lists.ozlabs.org>, Milan Broz <gmazyland@gmail.com>,
	Herbert Xu <herbert@gondor.apana.org.au>
To: Martin Hicks <mort@bork.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-bn1bon0119.outbound.protection.outlook.com ([157.56.111.119]:54912
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751395AbbCKPsz (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Wed, 11 Mar 2015 11:48:55 -0400
In-Reply-To: <CAJUS3XkY0tbYqBbU5HR7NT63UPFi5DO6XWuymbZnQaJEA5kkBw@mail.gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On 3/9/2015 5:08 PM, Martin Hicks wrote:
> On Mon, Mar 9, 2015 at 6:16 AM, Horia Geant=C4=83 <horia.geanta@frees=
cale.com> wrote:
>> On 3/3/2015 7:44 PM, Martin Hicks wrote:
>>> On Tue, Mar 3, 2015 at 10:44 AM, Horia Geant=C4=83
>>> <horia.geanta@freescale.com> wrote:
>>>>
>>>> For talitos, there are two cases:
>>>>
>>>> 1. request data size is <=3D data unit / sector size
>>>> talitos can handle any IV / tweak scheme
>>>>
>>>> 2. request data size > sector size
>>>> since talitos internally generates the IV for the next sector by
>>>> incrementing the previous IV, only IV schemes that allocate consec=
utive
>>>> IV to consecutive sectors will function correctly.
>>>>
>>>
>>> it's not clear to me that #1 is right.  I guess it could be, but th=
e
>>> IV length would be limited to 8 bytes.
>>
>> Yes, there's a limitation in talitos wrt. XTS IV / tweak size - it's=
 up
>> to 8 bytes.
>> So I guess ESSIV won't work with talitos-xts, since the encrypted IV
>> output is 16 bytes.
>> But as previously said, ESSIV breaks the XTS standard requirement fo=
r
>> having a consecutive IV for consecutive blocks. ESSIV should really =
be
>> used only with disk-level encryption schemes that require an
>> unpredictable IV.
>=20
> Ok.  I'll verify that the second half of the IV is zeroed.
>=20
> One last thing that I'm not sure of is what string to place in
> cra_ablkcipher.geniv field.   "eseqiv" seems wrong if plain/plain64
> are the IVs that XTS is designed for.

Right. But since currently dm-crypt does not use .givencrypt and deals
with IV generation by itself, we're safe.
When dm-crypt IV generation will be moved to crypto, we'll have to
revisit this.

While here: note that xts-talitos supports only two key lengths - 256
and 512 bits. There are tcrypt speed tests that check also for 384-bit
keys (which is out-of-spec, but still...), leading to a "Key Size Error=
"
- see below (KSE bit in AESU Interrupt Status Register is set)

testing speed of async xts(aes) (xts-aes-talitos) encryption
[...]
test 5 (384 bit key, 16 byte blocks):
talitos ffe30000.crypto: CDPR is NULL, giving up search for offending
descriptor
talitos ffe30000.crypto: AESUISR 0x00000000_00000200
talitos ffe30000.crypto: DESCBUF 0x64300011_00000000
talitos ffe30000.crypto: DESCBUF 0x00000000_00000000
talitos ffe30000.crypto: DESCBUF 0x00100000_00000000
talitos ffe30000.crypto: DESCBUF 0x00300000_00000000
talitos ffe30000.crypto: DESCBUF 0x00100000_00000000
talitos ffe30000.crypto: DESCBUF 0x00100000_00000000
talitos ffe30000.crypto: DESCBUF 0x00100000_00000000
talitos ffe30000.crypto: DESCBUF 0x00000000_00000000
encryption() failed flags=3D0

So for xts, driver must enforce 256/512 bit key lengths and return
CRYPTO_TFM_RES_BAD_KEY_LEN in all other cases.
Or a SW fallback could be used for the other cases, but I don't think
it's worth the effort since these are non-standard.

Horia

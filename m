From: Martin Hicks <mort@bork.org>
Subject: Re: [PATCH 0/2] crypto: talitos: Add AES-XTS mode
Date: Tue, 3 Mar 2015 12:44:58 -0500
Message-ID: <CAJUS3Xnw66Eu6tvGPpdcet6KLjhKM=ptj8NRaztAVr0h_r+LqQ@mail.gmail.com>
References: <1424451610-5786-1-git-send-email-mort@bork.org>
	<54F464E4.8080204@freescale.com>
	<54F475A8.6030105@gmail.com>
	<20150302220923.GC30523@darwin.bork.org>
	<54F5D6D5.8070407@freescale.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Milan Broz <gmazyland@gmail.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	linux-crypto@vger.kernel.org, Scott Wood <scottwood@freescale.com>,
	linuxppc-dev@lists.ozlabs.org
To: =?UTF-8?Q?Horia_Geant=C4=83?= <horia.geanta@freescale.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-ig0-f172.google.com ([209.85.213.172]:40997 "EHLO
	mail-ig0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755320AbbCCRo7 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 3 Mar 2015 12:44:59 -0500
Received: by igal13 with SMTP id l13so30098690iga.0
        for <linux-crypto@vger.kernel.org>; Tue, 03 Mar 2015 09:44:59 -0800 (PST)
In-Reply-To: <54F5D6D5.8070407@freescale.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Tue, Mar 3, 2015 at 10:44 AM, Horia Geant=C4=83
<horia.geanta@freescale.com> wrote:
> On 3/3/2015 12:09 AM, Martin Hicks wrote:
>>
>> On Mon, Mar 02, 2015 at 03:37:28PM +0100, Milan Broz wrote:
>>>
>>> If crypto API allows to encrypt more sectors in one run
>>> (handling IV internally) dmcrypt can be modified of course.
>>>
>>> But do not forget we can use another IV (not only sequential number=
)
>>> e.g. ESSIV with XTS as well (even if it doesn't make much sense, so=
me people
>>> are using it).
>>
>> Interesting, I'd not considered using XTS with an IV other than plai=
n/64.
>> The talitos hardware would not support aes/xts in any mode other tha=
n
>> plain/plain64 I don't think...Although perhaps you could push in an =
8-byte
>> IV and the hardware would interpret it as the sector #.
>>
>
> For talitos, there are two cases:
>
> 1. request data size is <=3D data unit / sector size
> talitos can handle any IV / tweak scheme
>
> 2. request data size > sector size
> since talitos internally generates the IV for the next sector by
> incrementing the previous IV, only IV schemes that allocate consecuti=
ve
> IV to consecutive sectors will function correctly.
>

it's not clear to me that #1 is right.  I guess it could be, but the
IV length would be limited to 8 bytes.

This also points out that claiming that the XTS IV size is 16 bytes,
as my current patch does, could be problematic.  It's handy because
the first 8 bytes should contain a plain64 sector #, and the second
u64 can be used to encode the sector size but it would be a mistake
for someone to use the second 8 bytes for the rest of a 16byte IV.

mh

--=20
Martin Hicks P.Eng.      |         mort@bork.org
Bork Consulting Inc.     |   +1 (613) 266-2296

From: Martin Hicks <mort@bork.org>
Subject: Re: [PATCH 0/2] crypto: talitos: Add AES-XTS mode
Date: Mon, 9 Mar 2015 11:08:42 -0400
Message-ID: <CAJUS3XkY0tbYqBbU5HR7NT63UPFi5DO6XWuymbZnQaJEA5kkBw@mail.gmail.com>
References: <1424451610-5786-1-git-send-email-mort@bork.org>
	<54F464E4.8080204@freescale.com>
	<54F475A8.6030105@gmail.com>
	<20150302220923.GC30523@darwin.bork.org>
	<54F5D6D5.8070407@freescale.com>
	<CAJUS3Xnw66Eu6tvGPpdcet6KLjhKM=ptj8NRaztAVr0h_r+LqQ@mail.gmail.com>
	<54FD72E4.1060701@freescale.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-crypto@vger.kernel.org, Scott Wood <scottwood@freescale.com>,
	linuxppc-dev@lists.ozlabs.org, Milan Broz <gmazyland@gmail.com>,
	Herbert Xu <herbert@gondor.apana.org.au>
To: =?UTF-8?Q?Horia_Geant=C4=83?= <horia.geanta@freescale.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-ie0-f170.google.com ([209.85.223.170]:39924 "EHLO
	mail-ie0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753206AbbCIPIn convert rfc822-to-8bit (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 9 Mar 2015 11:08:43 -0400
Received: by iecat20 with SMTP id at20so50494241iec.6
        for <linux-crypto@vger.kernel.org>; Mon, 09 Mar 2015 08:08:42 -0700 (PDT)
In-Reply-To: <54FD72E4.1060701@freescale.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Mon, Mar 9, 2015 at 6:16 AM, Horia Geant=C4=83 <horia.geanta@freesca=
le.com> wrote:
> On 3/3/2015 7:44 PM, Martin Hicks wrote:
>> On Tue, Mar 3, 2015 at 10:44 AM, Horia Geant=C4=83
>> <horia.geanta@freescale.com> wrote:
>>>
>>> For talitos, there are two cases:
>>>
>>> 1. request data size is <=3D data unit / sector size
>>> talitos can handle any IV / tweak scheme
>>>
>>> 2. request data size > sector size
>>> since talitos internally generates the IV for the next sector by
>>> incrementing the previous IV, only IV schemes that allocate consecu=
tive
>>> IV to consecutive sectors will function correctly.
>>>
>>
>> it's not clear to me that #1 is right.  I guess it could be, but the
>> IV length would be limited to 8 bytes.
>
> Yes, there's a limitation in talitos wrt. XTS IV / tweak size - it's =
up
> to 8 bytes.
> So I guess ESSIV won't work with talitos-xts, since the encrypted IV
> output is 16 bytes.
> But as previously said, ESSIV breaks the XTS standard requirement for
> having a consecutive IV for consecutive blocks. ESSIV should really b=
e
> used only with disk-level encryption schemes that require an
> unpredictable IV.

Ok.  I'll verify that the second half of the IV is zeroed.

One last thing that I'm not sure of is what string to place in
cra_ablkcipher.geniv field.   "eseqiv" seems wrong if plain/plain64
are the IVs that XTS is designed for.

Thanks,
mh

--=20
Martin Hicks P.Eng.      |         mort@bork.org
Bork Consulting Inc.     |   +1 (613) 266-2296

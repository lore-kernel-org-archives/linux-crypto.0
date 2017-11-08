From: Gilad Ben-Yossef <gilad@benyossef.com>
Subject: Re: [PATCH v2 1/3] staging: ccree: copy IV to DMAable memory
Date: Wed, 8 Nov 2017 13:54:03 +0200
Message-ID: <CAOtvUMeOXh=erNTQPzuYx2upfy4H2eQaSy+mBci_btaDuE46iA@mail.gmail.com>
References: <1509610224-14708-1-git-send-email-gilad@benyossef.com>
 <1509610224-14708-2-git-send-email-gilad@benyossef.com> <VI1PR0402MB3342B8E2BF19C2C5E298981F98560@VI1PR0402MB3342.eurprd04.prod.outlook.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Ofir Drang <ofir.drang@arm.com>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "driverdev-devel@linuxdriverproject.org"
        <driverdev-devel@linuxdriverproject.org>,
        "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
To: =?UTF-8?Q?Horia_Geant=C4=83?= <horia.geanta@nxp.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-ot0-f176.google.com ([74.125.82.176]:49687 "EHLO
        mail-ot0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751826AbdKHLyE (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 8 Nov 2017 06:54:04 -0500
Received: by mail-ot0-f176.google.com with SMTP id c47so2045693otj.6
        for <linux-crypto@vger.kernel.org>; Wed, 08 Nov 2017 03:54:04 -0800 (PST)
In-Reply-To: <VI1PR0402MB3342B8E2BF19C2C5E298981F98560@VI1PR0402MB3342.eurprd04.prod.outlook.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi,

On Wed, Nov 8, 2017 at 12:26 PM, Horia Geant=C4=83 <horia.geanta@nxp.com> w=
rote:
> On 11/2/2017 10:14 AM, Gilad Ben-Yossef wrote:
>> We are being passed an IV buffer from unknown origin, which may be
>> stack allocated and thus not safe for DMA. Allocate a DMA safe
>> buffer for the IV and use that instead.
>>
> IIUC this fixes only the (a)blkcipher / skcipher algorithms.
> What about aead, authenc?

AFAIK the implementation of aead/authenc in ccree already copies the IV to =
a
internally allocated buffer because how it deals with GCM and CTR.

But you did trigger me to double check that, so thanks for that :-)

>
> The fact that only the skcipher tcrypt tests use IVs on stack doesn't
> mean aead, authenc implementations are safe - other crypto API users
> could provide IVs laying in non-DMAable memory.

Of course. In fact, it might be a good idea to actually make tcrypt
explicitly use a stack allocated IV just to trigger proper warnings
from the DMA debug code. Does that sounds sane?

>
> To reiterate, the proper approach is to fix the crypto API to guarantee
> IVs are DMAable.
> However Herbert suggests he is not willing to do this work:
> https://www.mail-archive.com/linux-crypto@vger.kernel.org/msg28821.html
>
> A few high-level details mentioning what this implies would be helpful,
> in case somebody else decides its worth pursuing this path.
>
> The compromise is to fix all crypto drivers that need DMAable IVs.
> IMHO this is suboptimal, both in terms of performance (memory
> allocation, memcpy) and increased code complexity.

As a HW based crypto driver maintainer I sympathize, but let's play
devil's advocate for a second here:

In the current state, HW based crypto drivers need to allocate a buffer
and copy the IV, because they don't know if they got a DMAable buffer
or not. SW based crypto drivers don't need to do anything.

If we switch to an API that guarantee IVs are DMAable all crypto API
*users* will be forced to make sure IV are located in DMAable memory,
possibly resulting in the need for extra buffer allocation, whether this is
needed or not and SW based crypto drivers suffer added complexicty
of extracting the IV from scatter/gather list (I'm assuming we'll just add
it there).

Despite this hurting the driver I care about, I'm not sure this is a good t=
rade
off, really.

Thinking aloud, would it be sane to add an API of "alloc and copy if buffer
is on stack"?

Gilad


--=20
Gilad Ben-Yossef
Chief Coffee Drinker

"If you take a class in large-scale robotics, can you end up in a
situation where the homework eats your dog?"
 -- Jean-Baptiste Queru

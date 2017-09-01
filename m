From: Michael Ellerman <mpe@ellerman.id.au>
Subject: Re: [PATCH V3 6/6] crypto/nx: Add P9 NX support for 842 compression engine
Date: Fri, 01 Sep 2017 21:34:24 +1000
Message-ID: <878thy64an.fsf@concordia.ellerman.id.au>
References: <1500699702.23205.8.camel@hbabu-laptop> <878ti35l7z.fsf@concordia.ellerman.id.au> <CALZtONDnFLiGhTRNs89VWr3nrY0Bp9VPRqFXA0iEaa6U_+w4Ag@mail.gmail.com> <59A7BE4E.1040806@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain
Cc: mikey@neuling.org, Herbert Xu <herbert@gondor.apana.org.au>,
        Ram Pai <linuxram@us.ibm.com>, npiggin@gmail.com,
        suka@us.ibm.com,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        "linuxppc-dev\@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>
To: Haren Myneni <haren@linux.vnet.ibm.com>,
        Dan Streetman <ddstreet@ieee.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from ozlabs.org ([103.22.144.67]:47063 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751499AbdIALe0 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 1 Sep 2017 07:34:26 -0400
In-Reply-To: <59A7BE4E.1040806@linux.vnet.ibm.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Haren Myneni <haren@linux.vnet.ibm.com> writes:
>> On Mon, Aug 28, 2017 at 7:25 PM, Michael Ellerman <mpe@ellerman.id.au> wrote:
>>> Hi Haren,
>>>
>>> Some comments inline ...
>>>
>>> Haren Myneni <haren@linux.vnet.ibm.com> writes:
>>>
>>>> diff --git a/drivers/crypto/nx/nx-842-powernv.c b/drivers/crypto/nx/nx-842-powernv.c
>>>> index c0dd4c7e17d3..13089a0b9dfa 100644
>>>> --- a/drivers/crypto/nx/nx-842-powernv.c
>>>> +++ b/drivers/crypto/nx/nx-842-powernv.c
>>>> @@ -32,6 +33,9 @@ MODULE_ALIAS_CRYPTO("842-nx");
>>>>
>>>>  #define WORKMEM_ALIGN        (CRB_ALIGN)
>>>>  #define CSB_WAIT_MAX (5000) /* ms */
>>>> +#define VAS_RETRIES  (10)
>>>
>>> Where does that number come from?
>
> Sometimes HW returns copy/paste failures. So we should retry the
> request again. With 10 retries, Test running 12 hours was successful
> for repeated compression/decompression requests with 1024 threads.

But why 10. Why not 5, or 100, or 1, or 10,000?

Presumably when we have to retry it means the NX is too busy to service the
request?

Do we have any way to find out how long it might be busy for?

Should we try an NX on another chip?

We should also take into account the size of our request, ie. are we
asking the NX to compress one page, or 1GB ?

If it's just one page maybe we should fall back to software immediately.

cheers

From: Dan Streetman <ddstreet@ieee.org>
Subject: Re: [PATCH V3 6/6] crypto/nx: Add P9 NX support for 842 compression engine
Date: Thu, 31 Aug 2017 09:40:06 -0400
Message-ID: <CALZtONCmvVM1qu9RjP9iVn+C32rJ3fCHCJCbjkXJqNFfmVGgKg@mail.gmail.com>
References: <1500699702.23205.8.camel@hbabu-laptop> <878ti35l7z.fsf@concordia.ellerman.id.au>
 <CALZtONDnFLiGhTRNs89VWr3nrY0Bp9VPRqFXA0iEaa6U_+w4Ag@mail.gmail.com> <59A7BE4E.1040806@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Cc: Michael Ellerman <mpe@ellerman.id.au>,
        Michael Neuling <mikey@neuling.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Ram Pai <linuxram@us.ibm.com>, npiggin@gmail.com,
        suka@us.ibm.com,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        "linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>
To: Haren Myneni <haren@linux.vnet.ibm.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-io0-f196.google.com ([209.85.223.196]:38351 "EHLO
        mail-io0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751022AbdHaNks (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 31 Aug 2017 09:40:48 -0400
Received: by mail-io0-f196.google.com with SMTP id m40so4294312ioi.5
        for <linux-crypto@vger.kernel.org>; Thu, 31 Aug 2017 06:40:47 -0700 (PDT)
In-Reply-To: <59A7BE4E.1040806@linux.vnet.ibm.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Thu, Aug 31, 2017 at 3:44 AM, Haren Myneni <haren@linux.vnet.ibm.com> wrote:
> Thanks MIchael and Dan for your review comments.
>
>
> On 08/29/2017 06:32 AM, Dan Streetman wrote:
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
> Sometimes HW returns copy/paste failures.

why?  what is causing the failure?

> So we should retry the request again. With 10 retries, Test running
> 12 hours was successful for repeated compression/decompression
> requests with 1024 threads.
>
>>>
>>> Do we have any idea what the trade off is between retrying vs just
>>> falling back to doing the request in software?
>
> Not checked the overhead with falling back to SW compression.

SW is very, very, very slow, due to 842 being an unaligned compression format.

>
>>>
>>>> +/* # of requests allowed per RxFIFO at a time. 0 for unlimited */
>>>> +#define MAX_CREDITS_PER_RXFIFO       (1024)
>>>>
>>>>  struct nx842_workmem {
>>>>       /* Below fields must be properly aligned */
>>>> @@ -42,16 +46,27 @@ struct nx842_workmem {
>>>>
>>>>       ktime_t start;
>>>>
>>>> +     struct vas_window *txwin;       /* Used with VAS function */
>>>
>>> I don't understand how it makes sense to put txwin and start between the
>>> fields above, and the padding.
>>
>> workmem is a scratch buffer and shouldn't be used for something
>> persistent like this.
>>
>>>
>>> If the workmem pointer you receive is not aligned, then PTR_ALIGN() will
>>> advance it and mean you end up writing over start and txwin.
>
> We always access workmem with PTR_ALIGN even when assigning txwin (nx842_powernv_crypto_init/exit_vas).
> So we should not overwrite start and txwin,
>
> We can add txwin in nx842_crypto_ctx instead of workmem. But nx842_crypto_ctx is used for both powernv and pseries. Hence used workmem. But if nx842_crypto_ctx is preferred, I will send new patch soon.
>
>>>
>>> That's probably not your bug, the code is already like that.
>>
>> no, it's a bug in this patch, because workmem is scratch whose
>> contents are only valid for the duration of each operation (compress
>> or decompress).
>>
>>>
>>>>       char padding[WORKMEM_ALIGN]; /* unused, to allow alignment */
>>>>  } __packed __aligned(WORKMEM_ALIGN);
>>>
>
> Thanks
> Haren
>

From: Haren Myneni <haren@linux.vnet.ibm.com>
Subject: Re: [PATCH V3 6/6] crypto/nx: Add P9 NX support for 842 compression
 engine
Date: Thu, 31 Aug 2017 00:44:14 -0700
Message-ID: <59A7BE4E.1040806@linux.vnet.ibm.com>
References: <1500699702.23205.8.camel@hbabu-laptop> <878ti35l7z.fsf@concordia.ellerman.id.au> <CALZtONDnFLiGhTRNs89VWr3nrY0Bp9VPRqFXA0iEaa6U_+w4Ag@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Cc: Michael Ellerman <mpe@ellerman.id.au>, mikey@neuling.org,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Ram Pai <linuxram@us.ibm.com>, npiggin@gmail.com,
        suka@us.ibm.com,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        "linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>
To: Dan Streetman <ddstreet@ieee.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:38203 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1750711AbdHaHoc (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 31 Aug 2017 03:44:32 -0400
Received: from pps.filterd (m0098413.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.21/8.16.0.21) with SMTP id v7V7iFYw045107
        for <linux-crypto@vger.kernel.org>; Thu, 31 Aug 2017 03:44:31 -0400
Received: from e16.ny.us.ibm.com (e16.ny.us.ibm.com [129.33.205.206])
        by mx0b-001b2d01.pphosted.com with ESMTP id 2cpbh8acwh-1
        (version=TLSv1.2 cipher=AES256-SHA bits=256 verify=NOT)
        for <linux-crypto@vger.kernel.org>; Thu, 31 Aug 2017 03:44:30 -0400
Received: from localhost
        by e16.ny.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <linux-crypto@vger.kernel.org> from <haren@linux.vnet.ibm.com>;
        Thu, 31 Aug 2017 03:44:30 -0400
In-Reply-To: <CALZtONDnFLiGhTRNs89VWr3nrY0Bp9VPRqFXA0iEaa6U_+w4Ag@mail.gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Thanks MIchael and Dan for your review comments.


On 08/29/2017 06:32 AM, Dan Streetman wrote:
> On Mon, Aug 28, 2017 at 7:25 PM, Michael Ellerman <mpe@ellerman.id.au> wrote:
>> Hi Haren,
>>
>> Some comments inline ...
>>
>> Haren Myneni <haren@linux.vnet.ibm.com> writes:
>>
>>> diff --git a/drivers/crypto/nx/nx-842-powernv.c b/drivers/crypto/nx/nx-842-powernv.c
>>> index c0dd4c7e17d3..13089a0b9dfa 100644
>>> --- a/drivers/crypto/nx/nx-842-powernv.c
>>> +++ b/drivers/crypto/nx/nx-842-powernv.c
>>> @@ -32,6 +33,9 @@ MODULE_ALIAS_CRYPTO("842-nx");
>>>
>>>  #define WORKMEM_ALIGN        (CRB_ALIGN)
>>>  #define CSB_WAIT_MAX (5000) /* ms */
>>> +#define VAS_RETRIES  (10)
>>
>> Where does that number come from?

Sometimes HW returns copy/paste failures. So we should retry the request again. With 10 retries, Test running 12 hours was successful for repeated compression/decompression requests with 1024 threads. 

>>
>> Do we have any idea what the trade off is between retrying vs just
>> falling back to doing the request in software?

Not checked the overhead with falling back to SW compression. 

>>
>>> +/* # of requests allowed per RxFIFO at a time. 0 for unlimited */
>>> +#define MAX_CREDITS_PER_RXFIFO       (1024)
>>>
>>>  struct nx842_workmem {
>>>       /* Below fields must be properly aligned */
>>> @@ -42,16 +46,27 @@ struct nx842_workmem {
>>>
>>>       ktime_t start;
>>>
>>> +     struct vas_window *txwin;       /* Used with VAS function */
>>
>> I don't understand how it makes sense to put txwin and start between the
>> fields above, and the padding.
> 
> workmem is a scratch buffer and shouldn't be used for something
> persistent like this.
> 
>>
>> If the workmem pointer you receive is not aligned, then PTR_ALIGN() will
>> advance it and mean you end up writing over start and txwin.

We always access workmem with PTR_ALIGN even when assigning txwin (nx842_powernv_crypto_init/exit_vas).
So we should not overwrite start and txwin,

We can add txwin in nx842_crypto_ctx instead of workmem. But nx842_crypto_ctx is used for both powernv and pseries. Hence used workmem. But if nx842_crypto_ctx is preferred, I will send new patch soon. 

>>
>> That's probably not your bug, the code is already like that.
> 
> no, it's a bug in this patch, because workmem is scratch whose
> contents are only valid for the duration of each operation (compress
> or decompress).
> 
>>
>>>       char padding[WORKMEM_ALIGN]; /* unused, to allow alignment */
>>>  } __packed __aligned(WORKMEM_ALIGN);
>>

Thanks
Haren

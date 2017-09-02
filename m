From: Haren Myneni <haren@linux.vnet.ibm.com>
Subject: Re: [PATCH V3 6/6] crypto/nx: Add P9 NX support for 842 compression
 engine
Date: Fri, 01 Sep 2017 21:11:02 -0700
Message-ID: <59AA2F56.7090307@linux.vnet.ibm.com>
References: <1500699702.23205.8.camel@hbabu-laptop> <878ti35l7z.fsf@concordia.ellerman.id.au> <CALZtONDnFLiGhTRNs89VWr3nrY0Bp9VPRqFXA0iEaa6U_+w4Ag@mail.gmail.com> <59A7BE4E.1040806@linux.vnet.ibm.com> <878thy64an.fsf@concordia.ellerman.id.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: Dan Streetman <ddstreet@ieee.org>, mikey@neuling.org,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Ram Pai <linuxram@us.ibm.com>, npiggin@gmail.com,
        suka@us.ibm.com,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        "linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>
To: Michael Ellerman <mpe@ellerman.id.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:52137 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1750771AbdIBELV (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sat, 2 Sep 2017 00:11:21 -0400
Received: from pps.filterd (m0098413.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.21/8.16.0.21) with SMTP id v8243klt030003
        for <linux-crypto@vger.kernel.org>; Sat, 2 Sep 2017 00:11:20 -0400
Received: from e16.ny.us.ibm.com (e16.ny.us.ibm.com [129.33.205.206])
        by mx0b-001b2d01.pphosted.com with ESMTP id 2cqdaf1tc5-1
        (version=TLSv1.2 cipher=AES256-SHA bits=256 verify=NOT)
        for <linux-crypto@vger.kernel.org>; Sat, 02 Sep 2017 00:11:20 -0400
Received: from localhost
        by e16.ny.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <linux-crypto@vger.kernel.org> from <haren@linux.vnet.ibm.com>;
        Sat, 2 Sep 2017 00:11:20 -0400
In-Reply-To: <878thy64an.fsf@concordia.ellerman.id.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On 09/01/2017 04:34 AM, Michael Ellerman wrote:
> Haren Myneni <haren@linux.vnet.ibm.com> writes:
>>> On Mon, Aug 28, 2017 at 7:25 PM, Michael Ellerman <mpe@ellerman.id.au> wrote:
>>>> Hi Haren,
>>>>
>>>> Some comments inline ...
>>>>
>>>> Haren Myneni <haren@linux.vnet.ibm.com> writes:
>>>>
>>>>> diff --git a/drivers/crypto/nx/nx-842-powernv.c b/drivers/crypto/nx/nx-842-powernv.c
>>>>> index c0dd4c7e17d3..13089a0b9dfa 100644
>>>>> --- a/drivers/crypto/nx/nx-842-powernv.c
>>>>> +++ b/drivers/crypto/nx/nx-842-powernv.c
>>>>> @@ -32,6 +33,9 @@ MODULE_ALIAS_CRYPTO("842-nx");
>>>>>
>>>>>  #define WORKMEM_ALIGN        (CRB_ALIGN)
>>>>>  #define CSB_WAIT_MAX (5000) /* ms */
>>>>> +#define VAS_RETRIES  (10)
>>>>
>>>> Where does that number come from?
>>
>> Sometimes HW returns copy/paste failures. So we should retry the
>> request again. With 10 retries, Test running 12 hours was successful
>> for repeated compression/decompression requests with 1024 threads.
> 
> But why 10. Why not 5, or 100, or 1, or 10,000?

VAS spec says small number of retries. During my 12 hour test with 1024 threads - doing continuous compression/decompression requests, noticed around 6 or 7 retries needed. Hence used 10 retries.  

> 
> Presumably when we have to retry it means the NX is too busy to service the
> request?

One possible case. We can also see failures when receive/send credit are exhausted or reached the cached windows limit.

> 
> Do we have any way to find out how long it might be busy for?
Hard to know the reason of failure. VAS simply returns success or failure without providing the actual reason.

> 
> Should we try an NX on another chip?
Hard to decide whether to fall back on other NX engine since no way to know the actual failure reason on the current NX or no idea whether other NX is free. 

> 
> We should also take into account the size of our request, ie. are we
> asking the NX to compress one page, or 1GB ?

842 compression/decompression request size for NX is always fixed. So divide in to smaller requests for large buffer. Whereas NX gzip engine is different - can be configurable request size. We can look at this optimization when gzip support is added.   
   
> 
> If it's just one page maybe we should fall back to software immediately.

Right now falls back to SW decompression after 10 retries. Whereas user can use SW 842 compression upon failures.

We are planning to look in to performance analysis as part of VAS/NX optimizatiion and make necessary changes.

Thanks
Haren
> 
> cheers
> 

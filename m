From: Haren Myneni <haren@linux.vnet.ibm.com>
Subject: Re: [PATCH V3 6/6] crypto/nx: Add P9 NX support for 842 compression
 engine
Date: Thu, 31 Aug 2017 12:09:02 -0700
Message-ID: <59A85ECE.9080501@linux.vnet.ibm.com>
References: <1500699702.23205.8.camel@hbabu-laptop> <CALZtONBGVQy2iwkb8WpVd-_QG7bLFTvUbnuub6CCXP55YpQiSQ@mail.gmail.com> <1504041817.2358.32.camel@kernel.crashing.org> <59A5E2AE.5060400@linux.vnet.ibm.com> <CALZtONBBvrfWkiFQipMrM9+VxsbBkHMFOAbgL0OBm5gb8yZ=LQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Cc: Michael Neuling <mikey@neuling.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Ram Pai <linuxram@us.ibm.com>, npiggin@gmail.com,
        suka@us.ibm.com,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        "linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>
To: Dan Streetman <ddstreet@ieee.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:41250 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1750968AbdHaTJR (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 31 Aug 2017 15:09:17 -0400
Received: from pps.filterd (m0098419.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.21/8.16.0.21) with SMTP id v7VJ8CD3005445
        for <linux-crypto@vger.kernel.org>; Thu, 31 Aug 2017 15:09:16 -0400
Received: from e34.co.us.ibm.com (e34.co.us.ibm.com [32.97.110.152])
        by mx0b-001b2d01.pphosted.com with ESMTP id 2cpneg0fyv-1
        (version=TLSv1.2 cipher=AES256-SHA bits=256 verify=NOT)
        for <linux-crypto@vger.kernel.org>; Thu, 31 Aug 2017 15:09:16 -0400
Received: from localhost
        by e34.co.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <linux-crypto@vger.kernel.org> from <haren@linux.vnet.ibm.com>;
        Thu, 31 Aug 2017 13:09:15 -0600
In-Reply-To: <CALZtONBBvrfWkiFQipMrM9+VxsbBkHMFOAbgL0OBm5gb8yZ=LQ@mail.gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On 08/31/2017 06:31 AM, Dan Streetman wrote:
> On Tue, Aug 29, 2017 at 5:54 PM, Haren Myneni <haren@linux.vnet.ibm.com> wrote:
>> On 08/29/2017 02:23 PM, Benjamin Herrenschmidt wrote:
>>> On Tue, 2017-08-29 at 09:58 -0400, Dan Streetman wrote:
>>>>> +
>>>>> +       ret = -EINVAL;
>>>>> +       if (coproc && coproc->vas.rxwin) {
>>>>> +               wmem->txwin = nx842_alloc_txwin(coproc);
>>>>
>>>> this is wrong.  the workmem is scratch memory that's valid only for
>>>> the duration of a single operation.
>>
>> Correct, workmem is used until crypto_free is called.
> 
> that's not a 'single operation'.  a single operation is compress() or
> decompress().

workmem is allocated in nx842_crypto_init (called from crypto_alloc) and freed in crypto_free(). We can have single compression / decompression() operation or multiple within this crypto session. In case of single operation, we will end up workmem, ctx->sbounce/dbounce alloc/free for each request.  

> 
>>>>
>>>> do you actually need a txwin per crypto transform?  or do you need a
>>>> txwin per coprocessor?  or txwin per processor?  either per-coproc or
>>>> per-cpu should be created at driver init and held separately
>>>> (globally) instead of a per-transform txwin.  I really don't see why
>>>> you would need a txwin per transform, because the coproc should not
>>>> care how many different transforms there are.
>>>
>>> We should only need a single window for the whole kernel really, plus
>>> one per user process who wants direct access but that's not relevant
>>> here.
>>
>> Opening send window for each crypto transform (crypto_alloc,
>> compression/decompression, ..., crypto_free) so that does not
>> have to wait for the previous copy/paste complete.
>> VAS will map send and receive windows, and can cache in send
>> windows (up to 128). So I thought using the same send window
>> (per chip) for more requests (say 1000) may be adding overhead.
>>
>> I will make changes if you prefer using 1 send window per chip.
> 
> i don't have the spec, so i shouldn't be making the decision on it,
> but i do know putting a persistent field into the workmem is the wrong
> location.  If it's valid for the life of the transform, put it into
> the transform context.  The workmem buffer is intended to be used only
> during a single operation - it's "working memory" to perform each
> individual crypto transformation.
> 
>>
>>>
>>> Cheers,
>>> Ben.
>>>
>>
> 

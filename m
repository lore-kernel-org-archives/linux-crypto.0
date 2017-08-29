From: Haren Myneni <haren@linux.vnet.ibm.com>
Subject: Re: [PATCH V3 6/6] crypto/nx: Add P9 NX support for 842 compression
 engine
Date: Tue, 29 Aug 2017 14:54:54 -0700
Message-ID: <59A5E2AE.5060400@linux.vnet.ibm.com>
References: <1500699702.23205.8.camel@hbabu-laptop> <CALZtONBGVQy2iwkb8WpVd-_QG7bLFTvUbnuub6CCXP55YpQiSQ@mail.gmail.com> <1504041817.2358.32.camel@kernel.crashing.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Cc: Dan Streetman <ddstreet@ieee.org>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        "linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>,
        mikey@neuling.org, suka@us.ibm.com, Ram Pai <linuxram@us.ibm.com>,
        npiggin@gmail.com, Haren Myneni <hbabu@us.ibm.com>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:55416 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751492AbdH2VzP (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 29 Aug 2017 17:55:15 -0400
Received: from pps.filterd (m0098399.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.21/8.16.0.21) with SMTP id v7TLr1Gd062507
        for <linux-crypto@vger.kernel.org>; Tue, 29 Aug 2017 17:55:15 -0400
Received: from e36.co.us.ibm.com (e36.co.us.ibm.com [32.97.110.154])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2cn9t4cb35-1
        (version=TLSv1.2 cipher=AES256-SHA bits=256 verify=NOT)
        for <linux-crypto@vger.kernel.org>; Tue, 29 Aug 2017 17:55:14 -0400
Received: from localhost
        by e36.co.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <linux-crypto@vger.kernel.org> from <haren@linux.vnet.ibm.com>;
        Tue, 29 Aug 2017 15:55:06 -0600
In-Reply-To: <1504041817.2358.32.camel@kernel.crashing.org>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On 08/29/2017 02:23 PM, Benjamin Herrenschmidt wrote:
> On Tue, 2017-08-29 at 09:58 -0400, Dan Streetman wrote:
>>> +
>>> +       ret = -EINVAL;
>>> +       if (coproc && coproc->vas.rxwin) {
>>> +               wmem->txwin = nx842_alloc_txwin(coproc);
>>
>> this is wrong.  the workmem is scratch memory that's valid only for
>> the duration of a single operation.

Correct, workmem is used until crypto_free is called. 
>>
>> do you actually need a txwin per crypto transform?  or do you need a
>> txwin per coprocessor?  or txwin per processor?  either per-coproc or
>> per-cpu should be created at driver init and held separately
>> (globally) instead of a per-transform txwin.  I really don't see why
>> you would need a txwin per transform, because the coproc should not
>> care how many different transforms there are.
> 
> We should only need a single window for the whole kernel really, plus
> one per user process who wants direct access but that's not relevant
> here.

Opening send window for each crypto transform (crypto_alloc, compression/decompression, ..., crypto_free) so that does not have to wait for the previous copy/paste complete. VAS will map send and receive windows, and can cache in send windows (up to 128). So I thought using the same send window (per chip) for more requests (say 1000) may be adding overhead.

I will make changes if you prefer using 1 send window per chip.  

> 
> Cheers,
> Ben.
> 

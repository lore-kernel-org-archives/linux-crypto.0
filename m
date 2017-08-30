From: Haren Myneni <haren@linux.vnet.ibm.com>
Subject: Re: [PATCH V3 6/6] crypto/nx: Add P9 NX support for 842 compression
 engine
Date: Tue, 29 Aug 2017 18:02:09 -0700
Message-ID: <59A60E91.8020803@linux.vnet.ibm.com>
References: <1500699702.23205.8.camel@hbabu-laptop> <CALZtONBGVQy2iwkb8WpVd-_QG7bLFTvUbnuub6CCXP55YpQiSQ@mail.gmail.com> <1504041817.2358.32.camel@kernel.crashing.org> <59A5E2AE.5060400@linux.vnet.ibm.com> <1504043837.2358.38.camel@kernel.crashing.org>
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
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:40023 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751378AbdH3BCY (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 29 Aug 2017 21:02:24 -0400
Received: from pps.filterd (m0098396.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.21/8.16.0.21) with SMTP id v7U10DBW108604
        for <linux-crypto@vger.kernel.org>; Tue, 29 Aug 2017 21:02:24 -0400
Received: from e38.co.us.ibm.com (e38.co.us.ibm.com [32.97.110.159])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2cn9g047y8-1
        (version=TLSv1.2 cipher=AES256-SHA bits=256 verify=NOT)
        for <linux-crypto@vger.kernel.org>; Tue, 29 Aug 2017 21:02:24 -0400
Received: from localhost
        by e38.co.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <linux-crypto@vger.kernel.org> from <haren@linux.vnet.ibm.com>;
        Tue, 29 Aug 2017 19:02:23 -0600
In-Reply-To: <1504043837.2358.38.camel@kernel.crashing.org>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On 08/29/2017 02:57 PM, Benjamin Herrenschmidt wrote:
> On Tue, 2017-08-29 at 14:54 -0700, Haren Myneni wrote:
>> Opening send window for each crypto transform (crypto_alloc,
>> compression/decompression, ..., crypto_free) so that does not have to
>> wait for the previous copy/paste complete. VAS will map send and
>> receive windows, and can cache in send windows (up to 128). So I
>> thought using the same send window (per chip) for more requests (say
>> 1000) may be adding overhead.
>>
>> I will make changes if you prefer using 1 send window per chip.  
> 
> Did you check the cost of opening/closing a window ?

No, Not yet. opening / closing happens only during alloc/free, but not for each compression/decompression. Hence used separate send windows. 

Thanks
Haren  
 
> 
> Cheers,
> Ben.
> 

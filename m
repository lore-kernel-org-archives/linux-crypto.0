From: Kamil Konieczny <k.konieczny@partner.samsung.com>
Subject: Re: [PATCH v2 3/4] crypto: inside-secure - only update the result
 buffer when provided
Date: Fri, 01 Dec 2017 12:24:26 +0100
Message-ID: <10b81ab7-ba16-602c-2df0-a0462ccae416@partner.samsung.com>
References: <20171128154236.19192-1-antoine.tenart@free-electrons.com>
        <CGME20171128154525epcas3p42e9bb1308ab731910522a19a8fef4ad8@epcas3p4.samsung.com>
        <20171128154236.19192-4-antoine.tenart@free-electrons.com>
        <c91f78af-122d-1a5e-3a34-21dd137c8847@partner.samsung.com>
        <20171201003109.GA26156@gondor.apana.org.au> <20171201081157.GA2535@kwain>
        <8c42f4a1-ac1d-3817-3380-da4cee73168e@partner.samsung.com>
        <20171201103648.GB320@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: Antoine Tenart <antoine.tenart@free-electrons.com>,
        davem@davemloft.net, thomas.petazzoni@free-electrons.com,
        gregory.clement@free-electrons.com,
        miquel.raynal@free-electrons.com, oferh@marvell.com,
        igall@marvell.com, nadavh@marvell.com, linux-crypto@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mailout2.w1.samsung.com ([210.118.77.12]:46461 "EHLO
        mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751899AbdLALYb (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 1 Dec 2017 06:24:31 -0500
In-reply-to: <20171201103648.GB320@gondor.apana.org.au>
Content-language: en-US
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi Herbert,

On 01.12.2017 11:36, Herbert Xu wrote:
> On Fri, Dec 01, 2017 at 11:18:30AM +0100, Kamil Konieczny wrote:
>>
>> Herbert, is it possible for every init/update that areq->result can be NULL,
>> and only for final/update/digit user set it to actual memory ?
>> testmgr.c can check if hash update writes into areq->result and if yes, 
>> then test fails ?
> 
> Yes we should modify testmgr to check that.

I can write patch for it. Should it WARN_ON or treat it as error ?

-- 
Best regards,
Kamil Konieczny
Samsung R&D Institute Poland

From: Kamil Konieczny <k.konieczny@partner.samsung.com>
Subject: Re: [PATCH v2 3/4] crypto: inside-secure - only update the result
 buffer when provided
Date: Fri, 01 Dec 2017 11:43:18 +0100
Message-ID: <cdc62e93-a09d-af28-e279-3a6dd10066fd@partner.samsung.com>
References: <20171128154236.19192-1-antoine.tenart@free-electrons.com>
        <CGME20171128154525epcas3p42e9bb1308ab731910522a19a8fef4ad8@epcas3p4.samsung.com>
        <20171128154236.19192-4-antoine.tenart@free-electrons.com>
        <c91f78af-122d-1a5e-3a34-21dd137c8847@partner.samsung.com>
        <20171201003109.GA26156@gondor.apana.org.au> <20171201081157.GA2535@kwain>
        <8c42f4a1-ac1d-3817-3380-da4cee73168e@partner.samsung.com>
        <20171201102440.GA22648@kwain>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: Herbert Xu <herbert@gondor.apana.org.au>, davem@davemloft.net,
        thomas.petazzoni@free-electrons.com,
        gregory.clement@free-electrons.com,
        miquel.raynal@free-electrons.com, oferh@marvell.com,
        igall@marvell.com, nadavh@marvell.com, linux-crypto@vger.kernel.org
To: Antoine Tenart <antoine.tenart@free-electrons.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mailout2.w1.samsung.com ([210.118.77.12]:37010 "EHLO
        mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751891AbdLAKnX (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 1 Dec 2017 05:43:23 -0500
In-reply-to: <20171201102440.GA22648@kwain>
Content-language: en-US
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi Antoine,

On 01.12.2017 11:24, Antoine Tenart wrote:
> Hi Kamil,
> 
> On Fri, Dec 01, 2017 at 11:18:30AM +0100, Kamil Konieczny wrote:
>> On 01.12.2017 09:11, Antoine Tenart wrote:
>>> - Other drivers are doing this check (grep "if (!req->result)" or
>>>   "if (req->result)" to see some of them).
>>> - I see at least one commit fixing the exact same issue I'm facing here,
>>>   393897c5156a415533ff85aa381458840417b032:
>>>
>>>     crypto: ccp - Check for caller result area before using it
>>>
>>>     For a hash operation, the caller doesn't have to supply a result
>>>     area on every call so don't use it / update it if it hasn't
>>>     been supplied.
>>
>> Do you set last_req true for digest/finup/final ? If yes,
>> then you need to copy result only when it is true,
>>
>> 	if (sreq->last_req) {
>> 		result_sz = crypto_ahash_digestsize(ahash);
>> 		memcpy(sreq->state, areq->result, result_sz);
>> 	}
> 
> Yes the last_req flag is set for the last request, so when
> digest/finup/final are called. But no we can't copy the result into the
> state based on this as an user might want to perform multiple updates,
> then export the context, to import it again before sending more updates.

IMHO set them to false in hash update and init, set finish false and last_req true
for hash final, and set both true for hash finup and digest.

As Herbert tells in https://www.spinics.net/lists/linux-crypto/msg28658.html
you should support scenario export + update/finup, so basically export is reading
state but it do not halt your hash driver.

-- 
Best regards,
Kamil Konieczny
Samsung R&D Institute Poland

From: Kamil Konieczny <k.konieczny@partner.samsung.com>
Subject: Re: [PATCH v2 3/4] crypto: inside-secure - only update the result
 buffer when provided
Date: Fri, 01 Dec 2017 11:18:30 +0100
Message-ID: <8c42f4a1-ac1d-3817-3380-da4cee73168e@partner.samsung.com>
References: <20171128154236.19192-1-antoine.tenart@free-electrons.com>
        <CGME20171128154525epcas3p42e9bb1308ab731910522a19a8fef4ad8@epcas3p4.samsung.com>
        <20171128154236.19192-4-antoine.tenart@free-electrons.com>
        <c91f78af-122d-1a5e-3a34-21dd137c8847@partner.samsung.com>
        <20171201003109.GA26156@gondor.apana.org.au> <20171201081157.GA2535@kwain>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: davem@davemloft.net, thomas.petazzoni@free-electrons.com,
        gregory.clement@free-electrons.com,
        miquel.raynal@free-electrons.com, oferh@marvell.com,
        igall@marvell.com, nadavh@marvell.com, linux-crypto@vger.kernel.org
To: Antoine Tenart <antoine.tenart@free-electrons.com>,
        Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mailout2.w1.samsung.com ([210.118.77.12]:59165 "EHLO
        mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751699AbdLAKSf (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 1 Dec 2017 05:18:35 -0500
In-reply-to: <20171201081157.GA2535@kwain>
Content-language: en-US
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi All,

On 01.12.2017 09:11, Antoine Tenart wrote:
> Hi Herbert,
> 
> On Fri, Dec 01, 2017 at 11:31:09AM +1100, Herbert Xu wrote:
>> On Thu, Nov 30, 2017 at 10:19:26AM +0100, Kamil Konieczny wrote:
>>>
>>> can the driver get request for final/finup/digest with null req->result ?
>>> If yes (?), such checks can be done before any hardware processing, saving time,
>>> for example:
>>
>> This should not be possible through any user-space facing API.
>>
>> If a kernel API user did this then they're just shooting themselves
>> in the foot.
>>
>> So unless there is a valida call path that leads to this then I
>> would say that there is nothing to fix.
> 
> I agree this should not be the case.
> 
> But:
> - Other drivers are doing this check (grep "if (!req->result)" or
>   "if (req->result)" to see some of them).
> - I see at least one commit fixing the exact same issue I'm facing here,
>   393897c5156a415533ff85aa381458840417b032:
> 
>     crypto: ccp - Check for caller result area before using it
> 
>     For a hash operation, the caller doesn't have to supply a result
>     area on every call so don't use it / update it if it hasn't
>     been supplied.

Herbert, is it possible for every init/update that areq->result can be NULL,
and only for final/update/digit user set it to actual memory ?
testmgr.c can check if hash update writes into areq->result and if yes, 
then test fails ?

As I understand this, when crypto api user allocates ahash_request, 
crypto allocates memory for itself _plus_ for driver's context. This allocated
ahash_request is "handle" for all subsequent updates/export/import, 
and for last final/finup, so I do not need to copy hash state into areq->result,
but keep it whole time in context, in your code in sreq:

struct safexcel_ahash_req *sreq = ahash_request_ctx(areq);

so here sreq is async hash request context.

Do you set last_req true for digest/finup/final ? If yes,
then you need to copy result only when it is true,

	if (sreq->last_req) {
		result_sz = crypto_ahash_digestsize(ahash);
		memcpy(sreq->state, areq->result, result_sz);
	}

I do not read all your code though, so I can be wrong here.
 
> I'm not entirely sure what was the code path that leads to this, I'll
> reproduce the issue and try to understand what is going on (I clearly
> recall having this crash though).
> 
> The crypto API does not enforce this somehow, and this should probably
> be fixed. That might break some users. But it was seen as a valid use
> for some, so we should probably fix this in previous versions of the
> driver anyway.

-- 
Best regards,
Kamil Konieczny
Samsung R&D Institute Poland

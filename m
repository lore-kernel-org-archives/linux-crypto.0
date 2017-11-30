From: Kamil Konieczny <k.konieczny@partner.samsung.com>
Subject: Re: [PATCH v2 3/4] crypto: inside-secure - only update the result
 buffer when provided
Date: Thu, 30 Nov 2017 15:10:28 +0100
Message-ID: <37f78e96-f7f7-2fde-25ac-7ae54a7a4217@partner.samsung.com>
References: <20171128154236.19192-1-antoine.tenart@free-electrons.com>
        <CGME20171128154525epcas3p42e9bb1308ab731910522a19a8fef4ad8@epcas3p4.samsung.com>
        <20171128154236.19192-4-antoine.tenart@free-electrons.com>
        <c91f78af-122d-1a5e-3a34-21dd137c8847@partner.samsung.com>
        <20171130092927.GH30391@kwain>
        <6a920087-6cf2-6074-1f95-63ce56f0abee@partner.samsung.com>
        <20171130124106.GJ30391@kwain>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: herbert@gondor.apana.org.au, davem@davemloft.net,
        thomas.petazzoni@free-electrons.com,
        gregory.clement@free-electrons.com,
        miquel.raynal@free-electrons.com, oferh@marvell.com,
        igall@marvell.com, nadavh@marvell.com, linux-crypto@vger.kernel.org
To: Antoine Tenart <antoine.tenart@free-electrons.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mailout2.w1.samsung.com ([210.118.77.12]:59039 "EHLO
        mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751810AbdK3OKd (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 30 Nov 2017 09:10:33 -0500
In-reply-to: <20171130124106.GJ30391@kwain>
Content-language: en-US
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>


On 30.11.2017 13:41, Antoine Tenart wrote:
> On Thu, Nov 30, 2017 at 12:52:42PM +0100, Kamil Konieczny wrote:
>> On 30.11.2017 10:29, Antoine Tenart wrote:
>>> On Thu, Nov 30, 2017 at 10:19:26AM +0100, Kamil Konieczny wrote:

>>>> can the driver get request for final/finup/digest with null req->result ?
>>>
>>> I don't think that can happen. But having an update called without
>>> req->result provided is a valid call (though it's not well documented).

Yes, this field may be unset until finup/final.
One more to watch out is that in final, you can have areq->nsize != 0 so
you should not use  areq->nsize nor areq->src

>> so maybe:
>>
>>  	if (sreq->finish) {
>>   		result_sz = crypto_ahash_digestsize(ahash);
>> 		memcpy(sreq->state, areq->result, result_sz);
>> 	}
> 
> No, if we do this we'll lose the ability to export the current state.

So maybe save it into request context:

	result_sz = crypto_ahash_digestsize(ahash);
	ctx = ahash_request_ctx(areq);

  	if (sreq->finish)
 		memcpy(sreq->state, areq->result, result_sz);
	else
		memcpy(sreq->state, ctx->state, result_sz);


-- 
Best regards,
Kamil Konieczny
Samsung R&D Institute Poland

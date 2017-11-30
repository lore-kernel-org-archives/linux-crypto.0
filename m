From: Kamil Konieczny <k.konieczny@partner.samsung.com>
Subject: Re: [PATCH v2 3/4] crypto: inside-secure - only update the result
 buffer when provided
Date: Thu, 30 Nov 2017 12:52:42 +0100
Message-ID: <6a920087-6cf2-6074-1f95-63ce56f0abee@partner.samsung.com>
References: <20171128154236.19192-1-antoine.tenart@free-electrons.com>
        <CGME20171128154525epcas3p42e9bb1308ab731910522a19a8fef4ad8@epcas3p4.samsung.com>
        <20171128154236.19192-4-antoine.tenart@free-electrons.com>
        <c91f78af-122d-1a5e-3a34-21dd137c8847@partner.samsung.com>
        <20171130092927.GH30391@kwain>
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
Received: from mailout1.w1.samsung.com ([210.118.77.11]:39430 "EHLO
        mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751157AbdK3Lwr (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 30 Nov 2017 06:52:47 -0500
In-reply-to: <20171130092927.GH30391@kwain>
Content-language: en-US
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi Antoine,

On 30.11.2017 10:29, Antoine Tenart wrote:
> Hi Kamil,
> 
> On Thu, Nov 30, 2017 at 10:19:26AM +0100, Kamil Konieczny wrote:
>> On 28.11.2017 16:42, Antoine Tenart wrote:
>>> The patch fixes the ahash support by only updating the result buffer
>>> when provided. Otherwise the driver could crash with NULL pointer
>>> exceptions, because the ahash caller isn't required to supply a result
>>> buffer on all calls.
>>
>> Can you point to bug crush report ?
> 
> Do you want the crash dump? (It'll only be a "normal" NULL pointer
> dereference).

Ah I see, in this case not.

>>> Fixes: 1b44c5a60c13 ("crypto: inside-secure - add SafeXcel EIP197 crypto engine driver")
>>> Signed-off-by: Antoine Tenart <antoine.tenart@free-electrons.com>
>>> ---
>>>  drivers/crypto/inside-secure/safexcel_hash.c | 7 ++++++-
>>>  1 file changed, 6 insertions(+), 1 deletion(-)
>>>
>>> diff --git a/drivers/crypto/inside-secure/safexcel_hash.c b/drivers/crypto/inside-secure/safexcel_hash.c
>>> index 6135c9f5742c..424f4c5d4d25 100644
>>> --- a/drivers/crypto/inside-secure/safexcel_hash.c
>>> +++ b/drivers/crypto/inside-secure/safexcel_hash.c
>>> @@ -150,7 +150,12 @@ static int safexcel_handle_req_result(struct safexcel_crypto_priv *priv, int rin
>>>  
>>>  	if (sreq->finish)
>>>  		result_sz = crypto_ahash_digestsize(ahash);
>>> -	memcpy(sreq->state, areq->result, result_sz);
>> [...]
>> can the driver get request for final/finup/digest with null req->result ?
> 
> I don't think that can happen. But having an update called without
> req->result provided is a valid call (though it's not well documented).

so maybe:

 	if (sreq->finish) {
  		result_sz = crypto_ahash_digestsize(ahash);
		memcpy(sreq->state, areq->result, result_sz);
	}

-- 
Best regards,
Kamil Konieczny
Samsung R&D Institute Poland

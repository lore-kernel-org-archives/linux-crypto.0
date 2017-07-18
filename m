From: Tudor Ambarus <tudor.ambarus@microchip.com>
Subject: Re: [v3 RFC PATCH 2/2] crypto: ecc: use caller's GFP flags
Date: Tue, 18 Jul 2017 16:15:44 +0300
Message-ID: <3aaa1647-5bc2-6f2f-b532-6829fa2918cc@microchip.com>
References: <1498658916-11044-1-git-send-email-tudor.ambarus@microchip.com>
 <1498658916-11044-3-git-send-email-tudor.ambarus@microchip.com>
 <20170718055209.GC4764@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
Cc: <davem@davemloft.net>, <linux-crypto@vger.kernel.org>,
        <nicolas.ferre@microchip.com>
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from esa2.microchip.iphmx.com ([68.232.149.84]:62480 "EHLO
        esa2.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751401AbdGRNQe (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 18 Jul 2017 09:16:34 -0400
In-Reply-To: <20170718055209.GC4764@gondor.apana.org.au>
Content-Language: en-US
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi, Herbert,

On 07/18/2017 08:52 AM, Herbert Xu wrote:
> On Wed, Jun 28, 2017 at 05:08:36PM +0300, Tudor Ambarus wrote:
>> Using GFP_KERNEL when allocating data and implicitly
>> assuming that we can sleep was wrong because the caller
>> could be in atomic context. Let the caller decide whether
>> sleeping is possible or not.
>>
>> The caller (ecdh) was updated in the same patch in order
>> to not affect bissectability.
>>
>> Signed-off-by: Tudor Ambarus <tudor.ambarus@microchip.com>
> 
> Hmm, who wants to do asymmetric key crypto in interrupt context?

I thought of a caller that doesn't set the CRYPTO_TFM_REQ_MAY_SLEEP
flag. As of now I'm not aware of an user who wants asymmetric key
crypto in interrupt context. We can consider this patch superfluous
if CRYPTO_TFM_REQ_MAY_SLEEP is not meaningful for asymmetric key crypto.

Thanks,
ta

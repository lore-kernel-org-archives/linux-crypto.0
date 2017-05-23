From: Tudor Ambarus <tudor.ambarus@microchip.com>
Subject: Re: [PATCH v2 08/11] crypto: testmgr - check err on akcipher maxsize
Date: Tue, 23 May 2017 12:18:23 +0300
Message-ID: <dcec37d7-888f-4903-2aeb-b287b5d1042c@microchip.com>
References: <1495033238-26016-1-git-send-email-tudor.ambarus@microchip.com>
 <1495033238-26016-9-git-send-email-tudor.ambarus@microchip.com>
 <20170523040836.GD12788@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
Cc: <davem@davemloft.net>, <dhowells@redhat.com>,
        <linux-crypto@vger.kernel.org>, <keyrings@vger.kernel.org>,
        <Nicolas.Ferre@microchip.com>
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from esa5.microchip.iphmx.com ([216.71.150.166]:61677 "EHLO
        esa5.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S935239AbdEWJS2 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 23 May 2017 05:18:28 -0400
In-Reply-To: <20170523040836.GD12788@gondor.apana.org.au>
Content-Language: en-US
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>



On 23.05.2017 07:08, Herbert Xu wrote:
> On Wed, May 17, 2017 at 06:00:35PM +0300, Tudor Ambarus wrote:
>> crypto_akcipher_maxsize() returns minimum length for output buffer
>> or error code if key hasn't been set.
>>
>> Signed-off-by: Tudor Ambarus <tudor.ambarus@microchip.com>
>> ---
>>   crypto/testmgr.c | 5 +++++
>>   1 file changed, 5 insertions(+)
>>
>> diff --git a/crypto/testmgr.c b/crypto/testmgr.c
>> index 6f5f3ed..87a4abd 100644
>> --- a/crypto/testmgr.c
>> +++ b/crypto/testmgr.c
>> @@ -2150,6 +2150,11 @@ static int test_akcipher_one(struct crypto_akcipher *tfm,
>>   
>>   	err = -ENOMEM;
>>   	out_len_max = crypto_akcipher_maxsize(tfm);
> 
> Can this call be reached without a setkey or with a failed setkey?

As of now, this call is reached only after a successful setkey.
If some user call it before setkey we will end up in a NULL dereference.
I tend to keep the error checking.

Thanks,
ta

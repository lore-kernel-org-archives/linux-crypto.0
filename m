From: Tudor Ambarus <tudor.ambarus@microchip.com>
Subject: Re: [v3 RFC PATCH 1/2] crypto: ecdh: fix concurrency on ecdh_ctx
Date: Tue, 18 Jul 2017 15:52:19 +0300
Message-ID: <60b15bac-d295-36f4-c55f-a3ff3f8267fd@microchip.com>
References: <1498658916-11044-1-git-send-email-tudor.ambarus@microchip.com>
 <1498658916-11044-2-git-send-email-tudor.ambarus@microchip.com>
 <20170718055015.GB4764@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
Cc: <davem@davemloft.net>, <linux-crypto@vger.kernel.org>,
        <nicolas.ferre@microchip.com>
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from esa3.microchip.iphmx.com ([68.232.153.233]:48606 "EHLO
        esa3.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751371AbdGRMxJ (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 18 Jul 2017 08:53:09 -0400
In-Reply-To: <20170718055015.GB4764@gondor.apana.org.au>
Content-Language: en-US
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi, Herbert,

On 07/18/2017 08:50 AM, Herbert Xu wrote:
> On Wed, Jun 28, 2017 at 05:08:35PM +0300, Tudor Ambarus wrote:
>> ecdh_ctx contained static allocated data for the shared secret,
>> for the public and private key.
>>
>> When talking about shared secret and public key, they were
>> doomed to concurrency issues because they could be shared by
>> multiple crypto requests. The requests were generating specific
>> data to the same zone of memory without any protection.
>>
>> The private key was subject to concurrency problems because
>> multiple setkey calls could fight to memcpy to the same zone
>> of memory.
>>
>> Shared secret and public key concurrency is fixed by allocating
>> memory on heap for each request. In the end, the shared secret
>> and public key are computed for each request, there is no reason
>> to use shared memory.
>>
>> Private key concurrency is fixed by allocating memory on heap
>> for each setkey call, by memcopying the parsed/generated private
>> key to the heap and by making the private key pointer from
>> ecdh_ctx to point to the newly allocated data.
>>
>> On all systems running Linux, loads from and stores to pointers
>> are atomic, that is, if a store to a pointer occurs at the same
>> time as a load from that same pointer, the load will return either
>> the initial value or the value stored, never some bitwise mashup
>> of the two.
>>
>> With this, the private key will always point to a valid key,
>> but to what setkey call it belongs, is the responsibility of the
>> caller, as it is now in all crypto framework.
> 
> I don't get it.  You're replacing a per-tfm shared secret with
> a per-tfm dynamically allocated shared secret.  As far as I can
> see nothing has changed?

I'm replacing a per-tfm shared secret with a per-request dynamically
allocated shared secret. The same for the public key, I'm replacing
a per-tfm public key with a per-request dynamically allocated public
key. No shared memory, no concurrency.

> If the caller is making simultaneous setkey calls on the same tfm,
> then it's their problem.
> 

For the private key I wanted to be sure that we don't interleave data
from multiple setkey calls. As of now, the setkey calls can fight to
memcopy to the same zone of memory. I'm making sure that the private key
is valid and not a mash of multiple private keys.

Thanks,
ta

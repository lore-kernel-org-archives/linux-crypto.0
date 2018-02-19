From: Christophe LEROY <christophe.leroy@c-s.fr>
Subject: Re: [PATCH 16/18] crypto: talitos - do hw_context DMA mapping outside
 the requests
Date: Mon, 19 Feb 2018 08:58:15 +0100
Message-ID: <630c313c-5eca-224d-a5ac-fb3f2783573a@c-s.fr>
References: <cover.1507284818.git.christophe.leroy@c-s.fr>
 <e47bf94ae44f23230b1647e31c9623f1075d3b79.1507284818.git.christophe.leroy@c-s.fr>
 <VI1PR0402MB3342A0A8530F74D408CA2F0298FC0@VI1PR0402MB3342.eurprd04.prod.outlook.com>
 <2338eb8d-a26a-9722-d667-5a9785b32977@c-s.fr>
 <VI1PR0402MB3342D90D574C8829701882BE98C90@VI1PR0402MB3342.eurprd04.prod.outlook.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1258; format=flowed
Content-Transfer-Encoding: 8bit
Cc: "linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>,
 "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
 "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
To: =?UTF-8?Q?Horia_Geant=c4=83?= <horia.geanta@nxp.com>,
 Herbert Xu <herbert@gondor.apana.org.au>,
 "David S. Miller" <davem@davemloft.net>
Return-path: <linuxppc-dev-bounces+glppe-linuxppc-embedded-2=m.gmane.org@lists.ozlabs.org>
In-Reply-To: <VI1PR0402MB3342D90D574C8829701882BE98C90@VI1PR0402MB3342.eurprd04.prod.outlook.com>
Content-Language: fr
List-Unsubscribe: <https://lists.ozlabs.org/options/linuxppc-dev>,
 <mailto:linuxppc-dev-request@lists.ozlabs.org?subject=unsubscribe>
List-Archive: <http://lists.ozlabs.org/pipermail/linuxppc-dev/>
List-Post: <mailto:linuxppc-dev@lists.ozlabs.org>
List-Help: <mailto:linuxppc-dev-request@lists.ozlabs.org?subject=help>
List-Subscribe: <https://lists.ozlabs.org/listinfo/linuxppc-dev>,
 <mailto:linuxppc-dev-request@lists.ozlabs.org?subject=subscribe>
Errors-To: linuxppc-dev-bounces+glppe-linuxppc-embedded-2=m.gmane.org@lists.ozlabs.org
Sender: "Linuxppc-dev"
 <linuxppc-dev-bounces+glppe-linuxppc-embedded-2=m.gmane.org@lists.ozlabs.org>
List-Id: linux-crypto.vger.kernel.org



Le 18/02/2018 à 18:14, Horia Geantã a écrit :
> On 2/17/2018 6:32 PM, Christophe LEROY wrote:
>>
>>
>> Le 07/02/2018 à 15:39, Horia Geantã a écrit :
>>> On 10/6/2017 4:06 PM, Christophe Leroy wrote:
>>>> At every request, we map and unmap the same hash hw_context.
>>>>
>>>> This patch moves the dma mapping/unmapping in functions ahash_init()
>>>> and ahash_import().
>>>>
>>>> Signed-off-by: Christophe Leroy <christophe.leroy@c-s.fr>
>>>> ---
>>>>    drivers/crypto/talitos.c | 80 ++++++++++++++++++++++++++++++++++--------------
>>>>    1 file changed, 57 insertions(+), 23 deletions(-)
>>>>
>>>> diff --git a/drivers/crypto/talitos.c b/drivers/crypto/talitos.c
>>>> index ebfd6d982ed6..d495649d5267 100644
>>>> --- a/drivers/crypto/talitos.c
>>>> +++ b/drivers/crypto/talitos.c
>>>> @@ -819,6 +819,7 @@ struct talitos_ctx {
>>>>    	unsigned int keylen;
>>>>    	unsigned int enckeylen;
>>>>    	unsigned int authkeylen;
>>>> +	dma_addr_t dma_hw_context;
>>> This doesn't look correct.
>>>
>>> talitos_ctx structure is the tfm context.
>>> dma_hw_context is the IOVA of hw_context, located in talitos_ahash_req_ctx
>>> structure (request context).
>>
>> Yes but I have now found how I can know that the request context is
>> being released in order to unmap() dma at that time.
>> It is tricky to use the tmf context I agree, but at least I know when
>> tmf context get destroyed, ie in talitos_cra_exit_ahash()
>> The request context is created by ahash_request_alloc() and released by
>> ahash_request_free(). I have not found the way to call dma_unmap()
>> before ahash_request_free() gets called.
>>
>>>
>>> If there are multiple requests in flight for the same tfm, dma_hw_context will
>>> be overwritten.
>>
>> Before overwritting dma_hw_context, it is always released, see
>> talitos_cra_exit_ahash(), ahash_init(), ahash_import()
>>
> The problem is not the unmapping.
> If there are two requests for the same tfm, then given the following sequence
> 1. tfm->ahash_init(req1)
> 	tfm_ctx->dma_hw_context points to req1_ctx->hw_context
> 2. tfm->ahash_init(req2)
> 	tfm_ctx->dma_hw_context [unmapped, then] points to req2_ctx->hw_context
> i.e. req1 will use the hw_context of req2.
> 
>>>
>>> dma_hw_context needs to be moved in request context (talitos_ahash_req_ctx struct).
>>
>> Any suggestion then on how to handle the issue explained above ?
>>
> There is no ahash_exit() callback mirroring ahash_init().
> 
> The clean-up of request ctx should be done in the last states of the hash flows
> described here:
> https://www.kernel.org/doc/html/latest/crypto/devel-algos.html#cipher-definition-with-struct-shash-alg-and-ahash-alg
> for e.g. in the final() callback.

Unfortunatly it seems that we can't rely on those finalising functions 
being called all the time.
If you look into test_ahash_jiffies() for instance, in case of error the 
call of crypto_hash_final() is skipped.
So at the time being, I can't see any place to put the unmapping to be 
100% sure it will be done before the call of ahash_request_free()

Christophe

> 
> Hope this helps,
> Horia
> 

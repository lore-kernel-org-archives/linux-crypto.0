From: Christophe LEROY <christophe.leroy@c-s.fr>
Subject: Re: [PATCH 16/18] crypto: talitos - do hw_context DMA mapping outside
 the requests
Date: Mon, 19 Feb 2018 10:14:24 +0100
Message-ID: <d5809df9-fc17-03da-b7f4-038d973dbd1f@c-s.fr>
References: <cover.1507284818.git.christophe.leroy@c-s.fr>
 <e47bf94ae44f23230b1647e31c9623f1075d3b79.1507284818.git.christophe.leroy@c-s.fr>
 <VI1PR0402MB3342A0A8530F74D408CA2F0298FC0@VI1PR0402MB3342.eurprd04.prod.outlook.com>
 <2338eb8d-a26a-9722-d667-5a9785b32977@c-s.fr>
 <VI1PR0402MB3342D90D574C8829701882BE98C90@VI1PR0402MB3342.eurprd04.prod.outlook.com>
 <630c313c-5eca-224d-a5ac-fb3f2783573a@c-s.fr>
 <VI1PR0402MB334256E1706A4E1AED09F4A598C80@VI1PR0402MB3342.eurprd04.prod.outlook.com>
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
In-Reply-To: <VI1PR0402MB334256E1706A4E1AED09F4A598C80@VI1PR0402MB3342.eurprd04.prod.outlook.com>
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



Le 19/02/2018 à 09:30, Horia Geantã a écrit :
> On 2/19/2018 9:58 AM, Christophe LEROY wrote:
>> Le 18/02/2018 à 18:14, Horia Geantã a écrit :
>>> There is no ahash_exit() callback mirroring ahash_init().
>>>
>>> The clean-up of request ctx should be done in the last states of the hash flows
>>> described here:
>>> https://www.kernel.org/doc/html/latest/crypto/devel-algos.html#cipher-definition-with-struct-shash-alg-and-ahash-alg
>>> for e.g. in the final() callback.
>>
>> Unfortunatly it seems that we can't rely on those finalising functions
>> being called all the time.
>> If you look into test_ahash_jiffies() for instance, in case of error the
>> call of crypto_hash_final() is skipped.
> 
> If test_ahash_jiffies() errors before calling crypto_ahash_final(req), this
> means a previous callback failed.
> Accordingly, DMA unmapping should be performed also on the corresponding errors
> paths in the driver.
> 

And what about ALGIF path from user space ?
What if the user never calls the last sendmsg() which will call 
hash_finup() ?

Christophe

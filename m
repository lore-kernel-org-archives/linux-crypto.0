Return-Path: <SRS0=b7+G=PP=vger.kernel.org=linux-crypto-owner@kernel.org>
Received: from pegase1.c-s.fr ([93.17.236.30]:37200 "EHLO pegase1.c-s.fr"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726643AbfAGRGS (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 7 Jan 2019 12:06:18 -0500
Subject: Re: [PATCH v3] crypto: talitos - fix ablkcipher for CONFIG_VMAP_STACK
To: Horia Geanta <horia.geanta@nxp.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>
Cc: "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>
References: <ae7b64e9415874060977e32ed48b62f1f6148084.1545346337.git.christophe.leroy@c-s.fr>
 <VI1PR0402MB3485FC2A3758BCEAC05BF3A2988E0@VI1PR0402MB3485.eurprd04.prod.outlook.com>
 <VI1PR0402MB34853754B8F90F5904710526988E0@VI1PR0402MB3485.eurprd04.prod.outlook.com>
From: Christophe Leroy <christophe.leroy@c-s.fr>
Message-ID: <d609078d-b432-0fba-8a48-4224e62b46a9@c-s.fr>
Date: Mon, 7 Jan 2019 18:06:15 +0100
MIME-Version: 1.0
In-Reply-To: <VI1PR0402MB34853754B8F90F5904710526988E0@VI1PR0402MB3485.eurprd04.prod.outlook.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: fr
Content-Transfer-Encoding: 8bit
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>



Le 04/01/2019 à 16:24, Horia Geanta a écrit :
> On 1/4/2019 5:17 PM, Horia Geanta wrote:
>> On 12/21/2018 10:07 AM, Christophe Leroy wrote:
>> [snip]
>>> IV cannot be on stack when CONFIG_VMAP_STACK is selected because the stack
>>> cannot be DMA mapped anymore.
>>> This looks better, thanks.
>>
>>> This patch copies the IV into the extended descriptor when iv is not
>>> a valid linear address.
>>>
>> Though I am not sure the checks in place are enough.
>>
>>> Fixes: 4de9d0b547b9 ("crypto: talitos - Add ablkcipher algorithms")
>>> Cc: stable@vger.kernel.org
>>> Signed-off-by: Christophe Leroy <christophe.leroy@c-s.fr>
>>> ---
>>>   v3: Using struct edesc buffer.
>>>
>>>   v2: Using per-request context.
>> [snip]
>>> +	if (ivsize && !virt_addr_valid(iv))
>>> +		alloc_len += ivsize;
>> [snip]
>>>   
>>> +	if (ivsize && !virt_addr_valid(iv))
>> A more precise condition would be (!is_vmalloc_addr || is_vmalloc_addr(iv))
>>
> Sorry for the typo, I meant:
> (!virt_addr_valid(iv) || is_vmalloc_addr(iv))

As far as I know, virt_addr_valid() means the address is in the linear 
memory space. So it cannot be a vmalloc_addr if it is a linear space 
addr, can it ?

At least, it is that way on powerpc which is the arch embedding the 
talitos crypto engine. virt_addr_valid() means we are under max_pfn, 
while VMALLOC_START is above max_pfn.

Christophe

> 
>> It matches the checks in debug_dma_map_single() helper, though I am not sure
>> they are enough to rule out all exceptions of DMA API.

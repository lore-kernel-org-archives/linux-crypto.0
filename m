From: "Gustavo A. R. Silva" <gustavo@embeddedor.com>
Subject: Re: [RESEND] SHASH_DESC_ON_STACK macro
Date: Thu, 5 Apr 2018 03:26:54 -0500
Message-ID: <296706fc-9578-1ca5-ac7f-9b0a5e863114@embeddedor.com>
References: <f662fa16-2cbb-a484-4efb-68bb3b39a792@embeddedor.com>
 <bda66faa-f52d-215d-f21b-763593b30f91@embeddedor.com>
 <20180327100709.GA12961@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Cc: "David S. Miller" <davem@davemloft.net>,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180327100709.GA12961@gondor.apana.org.au>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Hi Herbert,

On 03/27/2018 05:07 AM, Herbert Xu wrote:
> On Fri, Mar 23, 2018 at 02:09:46PM -0500, Gustavo A. R. Silva wrote:
>>
>> Hi Herbert,
>>
>> There is an ongoing effort to remove all VLAs from the code base [1] and
>> while working on that I came across the following macro at
>> include/crypto/hash.h:154:
>>
>> #define SHASH_DESC_ON_STACK(shash, ctx)                           \
>>          char __##shash##_desc[sizeof(struct shash_desc) +         \
>>                  crypto_shash_descsize(ctx)] CRYPTO_MINALIGN_ATTR; \
>>          struct shash_desc *shash = (struct shash_desc *)__##shash##_desc
>>
>>
>> Currently, this macro is being used in 46 different places.
>>
>> I wonder how big can tfm->descsize can get?
> 
> descsize is capped at PAGE_SIZE / 8.
> 

Sorry for the late response. It seems I lost track of this email somehow.

OK. So based on your response I will propose a patch for this.

Thanks!
--
Gustavo

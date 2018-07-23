From: Jia-Ju Bai <baijiaju1990@gmail.com>
Subject: Re: [REPORT] Possible unnecessary usages of GFP_ATOMIC in
 crypto/ablkcipher.c
Date: Mon, 23 Jul 2018 15:19:43 +0800
Message-ID: <f0ec23d2-4766-6677-d95c-ea8d193d4083@gmail.com>
References: <78a7d726-f2fa-3afb-3451-bbd51a41a48a@gmail.com>
 <20180723062101.zzm5royyjfda6jma@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180723062101.zzm5royyjfda6jma@gondor.apana.org.au>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org



On 2018/7/23 14:21, Herbert Xu wrote:
> On Mon, Jul 23, 2018 at 10:39:40AM +0800, Jia-Ju Bai wrote:
>> My tool DCNS reports three unnecessary usages of GFP_ATOMIC in
>> crypto/ablkcipher.c:
>> crypto/ablkcipher.c, 162: kmalloc(GFP_ATOMIC) in ablkcipher_next_slow
>> crypto/ablkcipher.c, 199: kmalloc(GFP_ATOMIC) in ablkcipher_copy_iv
>> crypto/ablkcipher.c, 315: kmalloc(GFP_ATOMIC) in setkey_unaligned
>>
>> I meant to manually check the code, but I find that there are many functions
>> calling ablkcipher_next_slow(),
>> ablkcipher_copy_iv() and setkey_unaligned(), so I am not sure whether the
>> above three reports are true.
>>
>> Could someone help me to validate these reports?
>> Thanks a lot in advance :)
> They must use GFP_ATOMIC because they can be called from softirq
> context, e.g., IPsec.

Okay, thanks for the reply.


Best wishes,
Jia-Ju Bai

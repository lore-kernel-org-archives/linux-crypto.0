From: Neeraj Soni <neersoni@codeaurora.org>
Subject: Re: need to pick a solution for dm-crypt IV generation and do it!
 [was: Re: dm: submit stacked requests in irq enabled context]
Date: Thu, 11 May 2017 11:24:33 +0530
Message-ID: <17685656-9384-e050-d7d6-0bdb68e2a2d3@codeaurora.org>
References: <a66b6e17-a8c4-3465-fc2e-c3114abe0ca7@codeaurora.org>
 <dee12838-7b43-2fdd-0644-41c10ecf9148@codeaurora.org>
 <20170509155555.GB2572@localhost.localdomain>
 <20170510071733.GA24980@infradead.org>
 <39356321-b39b-98c7-f52b-ffd19d6dfc69@codeaurora.org>
 <CAOtvUMcjULAOZYQ3K_XDvxcFoFJJjX-wxF6e6Y1+-r67tS_Y7g@mail.gmail.com>
 <20170510144525.GA5608@redhat.com>
 <CAOtvUMdrnvr4RSzh6YB9F0B_WqfQ2WmSDUtCgn605JvRHrB3gg@mail.gmail.com>
 <6f802971-1622-1186-93d2-ff2cb3ca9fa0@codeaurora.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Christoph Hellwig <hch@infradead.org>,
        Keith Busch <keith.busch@intel.com>, dm-devel@redhat.com,
        Alasdair Kergon <agk@redhat.com>,
        Ondrej Mosnacek <omosnace@redhat.com>,
        Milan Broz <gmazyland@gmail.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        linux-crypto@vger.kernel.org
To: Gilad Ben-Yossef <gilad@benyossef.com>,
        Mike Snitzer <snitzer@redhat.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:45648 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751146AbdEKFyj (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 11 May 2017 01:54:39 -0400
In-Reply-To: <6f802971-1622-1186-93d2-ff2cb3ca9fa0@codeaurora.org>
Content-Language: en-US
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Until we move to some latest stable kernel as Keith mentioned.

On 5/11/2017 11:22 AM, Neeraj Soni wrote:
> Thanks for inputs folks. So shall i conclude that there is no remedy 
> available that can be applied on 4.4 and reverting this patch is only 
> way forward to solve the degradation?
>
> Neeraj
>
>
> On 5/10/2017 8:25 PM, Gilad Ben-Yossef wrote:
>> On Wed, May 10, 2017 at 5:45 PM, Mike Snitzer <snitzer@redhat.com> 
>> wrote:
>>> On Wed, May 10 2017 at  9:37am -0400,
>>> Gilad Ben-Yossef <gilad@benyossef.com> wrote:
>>>
>>>> On Wed, May 10, 2017 at 11:49 AM, Neeraj Soni 
>>>> <neersoni@codeaurora.org> wrote:
>>>>> Hi Keith,
>>>>>
>>>>> Request based dm (dm-req-crypt) is being used for Disk Encryption 
>>>>> solution
>>>>> in Android used by Google. Also as i mentioned reverting this fix  
>>>>> improves
>>>>> the RR/RW numbers so this proves the request based dm is coming 
>>>>> into path
>>>>> and is being used.
>>>> Sadly, that is an out of tree module.
>>>>
>>>> Does it still use Qcom specific APIs in its implementation 
>>>> (qcrypto_* funcs)?
>>>> It did the last time I've checked - and the driver that implements
>>>> those is not upstream either...
>>>>
>>>> It makes it difficult to help - which is a shame since I am interested
>>>> in enabling higher performance
>>>> of dm-crypt when using HW based crypto transformation myself.
>>> I have absolutely no interest in request-based dm-crypt.  It is a hack
>>> to work-around limitations in crypto IV generation.
>> I agree. This is why I've said I'm interested in a high performance 
>> dm-crypt,
>> not "request based dm-crypt". They are trying to solve the same 
>> problem but
>> with the wrong solution and doing so out of upstream.
>>
>> As the parlance of our time seems to go... sad. :-)
>>
>>
>> Cheers,
>> Gilad
>>
>>
>

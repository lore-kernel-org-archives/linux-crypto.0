From: Farhan Ali <alifm@linux.ibm.com>
Subject: Re: [PATCH v2 0/2] Detect & register virtio-crypto algos only if it
 can be supported by backend
Date: Tue, 19 Jun 2018 10:57:54 -0400
Message-ID: <4301ac2e-a8f5-7432-cdd9-f39d30a9fb5e@linux.ibm.com>
References: <cover.1528921468.git.alifm@linux.ibm.com>
 <44ccc5db-e1d4-27b7-8942-c77f467f422e@linux.ibm.com>
 <0c5d7e42-e6c5-6aa2-8c1b-487c8cc9eb21@de.ibm.com>
 <20180619143230.zjemmhhz7embs2li@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Cc: linux-kernel@vger.kernel.org, kvm@vger.kernel.org, mst@redhat.com,
        qemu-devel@nongnu.org, arei.gonglei@huawei.com,
        longpeng2@huawei.com, pasic@linux.ibm.com, frankja@linux.ibm.com,
        Jason Wang <jasowang@redhat.com>, linux-crypto@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>,
        Christian Borntraeger <borntraeger@de.ibm.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180619143230.zjemmhhz7embs2li@gondor.apana.org.au>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org



On 06/19/2018 10:32 AM, Herbert Xu wrote:
> On Tue, Jun 19, 2018 at 04:08:05PM +0200, Christian Borntraeger wrote:
>> On 06/19/2018 03:26 PM, Farhan Ali wrote:
>>> A polite ping :)
>>>
>>> If no one has any more comments/feedback then I would like to how to merge these patches to the mainline kernel tree.
>>
>> I think it should go via Michael Tsirkin or Jason Wang (Adding Jason).
>> Also adding Herbert Xu as FYI.
>>
>>
>> I have not looked into the details of the patch, but I like the idea.
>> Acked-by: Christian Borntraeger <borntraeger@de.ibm.com>
> 
> Please post crypto patches to linux-crypto.
> 
> Thanks,
> 

I have cc'ed linux-crypto folks. Sorry I missed them

Thanks
Farhan

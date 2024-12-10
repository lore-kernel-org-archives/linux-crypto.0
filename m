Received: from dggsgout12.his.huawei.com (dggsgout12.his.huawei.com [45.249.212.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1E37078F2D;
	Tue, 10 Dec 2024 09:39:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733823546; cv=none; b=E4eEEHKcCjLi3L6g4nGiKngDPveBZmxmP9SfN54vLMFUtTAmHdK9ZntJAvdqrcCJBI3u+p51HgjgjpDBfg/h3PiNXjUtq7IjS1vnJZFwwP3mi6tFwvo4wSZ6F/hfGdx5X8KfHM2UT4ljGCmmGFQ14b8bMKPVee7VEm29a9Yg0Nw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733823546; c=relaxed/simple;
	bh=HE6bPAhwg6wpoW3wRylD4+eYXegxdPr468veA/EXiHk=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=MaApuIAJJKDvqP2hM0RoKVtX1WmFm/gln/3G6OZxiaJ4/o2b4K0RB99t4ogmPZM6czqmF6b4mcNqw7oJucqoC2uJ5r6TFniay5w5JGghDoh22SxtvFq4A3mrHPUvRCfi+7jczrDoRm6vPbApw73nMfLfz+ycFOgmfJDx5xkkM+U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.235])
	by dggsgout12.his.huawei.com (SkyGuard) with ESMTP id 4Y6tvv1Sf6z4f3jXh;
	Tue, 10 Dec 2024 17:38:35 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.75])
	by mail.maildlp.com (Postfix) with ESMTP id 694261A058E;
	Tue, 10 Dec 2024 17:38:54 +0800 (CST)
Received: from [10.67.109.79] (unknown [10.67.109.79])
	by APP2 (Coremail) with SMTP id Syh0CgBH9OArDFhnYnWmEA--.7276S2;
	Tue, 10 Dec 2024 17:38:53 +0800 (CST)
Message-ID: <dc4a4fc1-2628-4e0c-8b8e-1e44193c440e@huaweicloud.com>
Date: Tue, 10 Dec 2024 17:38:51 +0800
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/2] padata: fix UAF in padata_reorder
To: chenridong <chenridong@huawei.com>,
 Daniel Jordan <daniel.m.jordan@oracle.com>
Cc: steffen.klassert@secunet.com, herbert@gondor.apana.org.au,
 linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
 wangweiyang2@huawei.com
References: <20241123080509.2573987-1-chenridong@huaweicloud.com>
 <20241123080509.2573987-3-chenridong@huaweicloud.com>
 <nihv732hsimy4lfnzspjur4ndal7n3nngrukvr5fx7emgp2jzl@mjz6q5zsswds>
 <2ba08cbe-ce27-4b83-acad-3845421c9bf6@huawei.com>
Content-Language: en-US
From: Chen Ridong <chenridong@huaweicloud.com>
In-Reply-To: <2ba08cbe-ce27-4b83-acad-3845421c9bf6@huawei.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:Syh0CgBH9OArDFhnYnWmEA--.7276S2
X-Coremail-Antispam: 1UD129KBjvJXoWxGrW8CrWkZF4xKrWDCrW3KFg_yoWrJryfpF
	WakayayFW8Jr97Jw1IvrsrXry0gr4j9r13KF45Grn5C34ayryIvr12yr4F9a4F9r1vkw1q
	vF4UX3WavwnrAFDanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUymb4IE77IF4wAFF20E14v26r4j6ryUM7CY07I20VC2zVCF04k2
	6cxKx2IYs7xG6rWj6s0DM7CIcVAFz4kK6r1j6r18M28lY4IEw2IIxxk0rwA2F7IY1VAKz4
	vEj48ve4kI8wA2z4x0Y4vE2Ix0cI8IcVAFwI0_Xr0_Ar1l84ACjcxK6xIIjxv20xvEc7Cj
	xVAFwI0_Cr0_Gr1UM28EF7xvwVC2z280aVAFwI0_GcCE3s1l84ACjcxK6I8E87Iv6xkF7I
	0E14v26rxl6s0DM2AIxVAIcxkEcVAq07x20xvEncxIr21l5I8CrVACY4xI64kE6c02F40E
	x7xfMcIj6xIIjxv20xvE14v26r1j6r18McIj6I8E87Iv67AKxVWUJVW8JwAm72CE4IkC6x
	0Yz7v_Jr0_Gr1lF7xvr2IY64vIr41lc7CjxVAaw2AFwI0_JF0_Jw1l42xK82IYc2Ij64vI
	r41l4I8I3I0E4IkC6x0Yz7v_Jr0_Gr1lx2IqxVAqx4xG67AKxVWUJVWUGwC20s026x8Gjc
	xK67AKxVWUGVWUWwC2zVAF1VAY17CE14v26r126r1DMIIYrxkI7VAKI48JMIIF0xvE2Ix0
	cI8IcVAFwI0_Jr0_JF4lIxAIcVC0I7IYx2IY6xkF7I0E14v26r1j6r4UMIIF0xvE42xK8V
	AvwI8IcIk0rVWUJVWUCwCI42IY6I8E87Iv67AKxVWUJVW8JwCI42IY6I8E87Iv6xkF7I0E
	14v26r1j6r4UYxBIdaVFxhVjvjDU0xZFpf9x07UK2NtUUUUU=
X-CM-SenderInfo: hfkh02xlgr0w46kxt4xhlfz01xgou0bp/



On 2024/12/6 11:48, chenridong wrote:
> 
> 
> On 2024/12/6 7:01, Daniel Jordan wrote:
>> Hello Ridong,
>>
>> On Sat, Nov 23, 2024 at 08:05:09AM +0000, Chen Ridong wrote:
>>> From: Chen Ridong <chenridong@huawei.com>
>>>
>>> A bug was found when run ltp test:
>> ...snip...
>>> This can be explained as bellow:
>>>
>>> pcrypt_aead_encrypt
>>> ...
>>> padata_do_parallel
>>> refcount_inc(&pd->refcnt); // add refcnt
>>> ...
>>> padata_do_serial
>>> padata_reorder // pd
>>> while (1) {
>>> padata_find_next(pd, true); // using pd
>>> queue_work_on
>>> ...
>>> padata_serial_worker				crypto_del_alg
>>> padata_put_pd_cnt // sub refcnt
>>> 						padata_free_shell
>>> 						padata_put_pd(ps->pd);
>>> 						// pd is freed
>>> // loop again, but pd is freed
>>> // call padata_find_next, UAF
>>> }
>>
>> Thanks for the fix and clear explanation.
>>
>>> diff --git a/kernel/padata.c b/kernel/padata.c
>>> index 5d8e18cdcb25..627014825266 100644
>>> --- a/kernel/padata.c
>>> +++ b/kernel/padata.c
>>> @@ -319,6 +319,7 @@ static void padata_reorder(struct parallel_data *pd)
>>>  	if (!spin_trylock_bh(&pd->lock))
>>>  		return;
>>>  
>>> +	padata_get_pd(pd);
>>>  	while (1) {
>>>  		padata = padata_find_next(pd, true);
>>>  
>>> @@ -355,6 +356,7 @@ static void padata_reorder(struct parallel_data *pd)
>>>  	reorder = per_cpu_ptr(pd->reorder_list, pd->cpu);
>>>  	if (!list_empty(&reorder->list) && padata_find_next(pd, false))
>>>  		queue_work(pinst->serial_wq, &pd->reorder_work);
>>> +	padata_put_pd(pd);
>>
>> Putting the ref unconditionally here doesn't cover the case where reorder_work
>> is queued and accesses the freed pd.
>>
>> The review of patches 3-5 from this series has a potential solution for
>> this that also keeps some of these refcount operations out of the fast
>> path:
>>
>>     https://lore.kernel.org/all/20221019083708.27138-1-nstange@suse.de/
>>
> 
> Thank you for your review.
> 
> IIUC, patches 3-5 from this series aim to fix two issue.
> 1. Avoid UAF for pd(the patch 3).
> 2. Avoid UAF for ps(the patch 4-5).
> What my patch 2 intends to fix is the issue 1.
> 
> Let's focus on issue 1.
> As shown bellow, if reorder_work is queued, the refcnt must greater than
> 0, since its serial work have not be finished yet. Do your agree with that?
> 
> pcrypt_aead_encrypt/pcrypt_aead_decrypt
> padata_do_parallel 			// refcount_inc(&pd->refcnt);
> padata_parallel_worker	
> padata->parallel(padata);
> padata_do_serial(padata);		
> // pd->reorder_list 			// enque reorder_list
> padata_reorder
>  - case1:squeue->work
> 	padata_serial_worker		// sub refcnt cnt
>  - case2:pd->reorder_work		// reorder->list is not empty
> 	invoke_padata_reorder 		// this means refcnt > 0
> 	...
> 	padata_serial_worker
> 
> I think the patch 3(from Nicolai Stange) can also avoid UAF for pd, but
> it's complicated. IIUC, the issue 1 can only occur in the scenario what
> I mentioned is my commit message. How I fix issue 1 is by adding and
> putting the refcnt in the padata_reorder function, which is simple and
> clear.
> 
> If understand something uncorrectly, please let me know.
> 
> As the issue 2, I have not encountered it, but it exists in theory.
> 
> Thanks,
> Ridong

Hi, Daniel, I am trying to produce the issue 2. However，I failed.
I added 'mdelay' as helper.

 static void padata_reorder(struct parallel_data *pd)
 {
+       mdelay(10);
        struct padata_instance *pinst = pd->ps->pinst;
        int cb_cpu;
        struct padata_priv *padata;

I believe this can increase the probability of issue 2. But after
testing with pcrypt_aead01, issue 2 cannot be reproduced.
And I don't know whether it exists now.

Looking forward your reply.

Best regards,
Ridong


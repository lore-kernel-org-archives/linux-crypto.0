Received: from dggsgout11.his.huawei.com (dggsgout11.his.huawei.com [45.249.212.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 35CF38624B;
	Mon, 23 Dec 2024 09:00:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734944428; cv=none; b=cMQVoMJVxobKmNpKv5FFQyI3dqPgWKhEPK5+mibmEEoPFc/QXB94R5UjJtPr9dPbV85Njqbf0U69gPrkI9tgRTvrsfvSxXmarJtpxALbGqLoJXeqJeiH6t2bCHlOVuC79ktpe2Dw8+3MhufPqnKcW0XvLTVcOPffdcbG5vC0lHw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734944428; c=relaxed/simple;
	bh=Ic8bhXZ6FR1zAG0CeqwB/yqzja0d35YeRUDtq1AKVXA=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=pvy4a9LfccmZDYyft7KQsf0YDJv9cZfTsFo8xDJsg3nR9XkVdjlsUSywrFTMuG/YXAiHYzt8T6fHZpndipxmyXOqEze4Y1NVh3+FQOWJMD5Db+5z8NF26xQj3/TDZjdQEvGnScsBl6zHnYqNwIx+B86k8WGpuaI9HzXb4gvtrS8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=none smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.216])
	by dggsgout11.his.huawei.com (SkyGuard) with ESMTP id 4YGsRM4Myyz4f3lVg;
	Mon, 23 Dec 2024 16:59:59 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.252])
	by mail.maildlp.com (Postfix) with ESMTP id 4DC3A1A0196;
	Mon, 23 Dec 2024 17:00:20 +0800 (CST)
Received: from [10.67.109.79] (unknown [10.67.109.79])
	by APP3 (Coremail) with SMTP id _Ch0CgAXqcWgJmlnGeT9FA--.5190S2;
	Mon, 23 Dec 2024 17:00:18 +0800 (CST)
Message-ID: <27690711-20f5-4e2c-8f43-17b7d3f10f86@huaweicloud.com>
Date: Mon, 23 Dec 2024 17:00:16 +0800
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/2] padata: fix UAF in padata_reorder
To: Daniel Jordan <daniel.m.jordan@oracle.com>,
 chenridong <chenridong@huawei.com>, nstange@suse.de
Cc: steffen.klassert@secunet.com, herbert@gondor.apana.org.au,
 linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
 wangweiyang2@huawei.com
References: <20241123080509.2573987-1-chenridong@huaweicloud.com>
 <20241123080509.2573987-3-chenridong@huaweicloud.com>
 <nihv732hsimy4lfnzspjur4ndal7n3nngrukvr5fx7emgp2jzl@mjz6q5zsswds>
 <2ba08cbe-ce27-4b83-acad-3845421c9bf6@huawei.com>
 <mffodsysfv4qakpyv6qbuqxzfpmt54q7cbpgne6paykzjx626y@f3ze6ti7cshp>
Content-Language: en-US
From: Chen Ridong <chenridong@huaweicloud.com>
In-Reply-To: <mffodsysfv4qakpyv6qbuqxzfpmt54q7cbpgne6paykzjx626y@f3ze6ti7cshp>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-CM-TRANSID:_Ch0CgAXqcWgJmlnGeT9FA--.5190S2
X-Coremail-Antispam: 1UD129KBjvJXoWxGFWrWFy7Wryxur1xGw4DJwb_yoWrtFW5pF
	WYkFW2yF4ktr48J3s2vw1UZryIgr1j9F13KF1rKr15C398tryIvw12yF4F9Fyj9r1kKw1q
	vr4DXasavws7Za7anT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUylb4IE77IF4wAFF20E14v26r4j6ryUM7CY07I20VC2zVCF04k2
	6cxKx2IYs7xG6rWj6s0DM7CIcVAFz4kK6r1j6r18M28lY4IEw2IIxxk0rwA2F7IY1VAKz4
	vEj48ve4kI8wA2z4x0Y4vE2Ix0cI8IcVAFwI0_Xr0_Ar1l84ACjcxK6xIIjxv20xvEc7Cj
	xVAFwI0_Cr0_Gr1UM28EF7xvwVC2z280aVAFwI0_GcCE3s1l84ACjcxK6I8E87Iv6xkF7I
	0E14v26rxl6s0DM2AIxVAIcxkEcVAq07x20xvEncxIr21l5I8CrVACY4xI64kE6c02F40E
	x7xfMcIj6xIIjxv20xvE14v26r1j6r18McIj6I8E87Iv67AKxVWUJVW8JwAm72CE4IkC6x
	0Yz7v_Jr0_Gr1lF7xvr2IY64vIr41lc7CjxVAaw2AFwI0_JF0_Jw1l42xK82IYc2Ij64vI
	r41l4I8I3I0E4IkC6x0Yz7v_Jr0_Gr1lx2IqxVAqx4xG67AKxVWUJVWUGwC20s026x8Gjc
	xK67AKxVWUGVWUWwC2zVAF1VAY17CE14v26r1q6r43MIIYrxkI7VAKI48JMIIF0xvE2Ix0
	cI8IcVAFwI0_Jr0_JF4lIxAIcVC0I7IYx2IY6xkF7I0E14v26r1j6r4UMIIF0xvE42xK8V
	AvwI8IcIk0rVWUJVWUCwCI42IY6I8E87Iv67AKxVWUJVW8JwCI42IY6I8E87Iv6xkF7I0E
	14v26r4j6r4UJbIYCTnIWIevJa73UjIFyTuYvjxUwxhLUUUUU
X-CM-SenderInfo: hfkh02xlgr0w46kxt4xhlfz01xgou0bp/



On 2024/12/11 3:12, Daniel Jordan wrote:
> Hi Ridong,
> 
> On Fri, Dec 06, 2024 at 11:48:36AM +0800, chenridong wrote:
>> On 2024/12/6 7:01, Daniel Jordan wrote:
>>> On Sat, Nov 23, 2024 at 08:05:09AM +0000, Chen Ridong wrote:
>>>> diff --git a/kernel/padata.c b/kernel/padata.c
>>>> index 5d8e18cdcb25..627014825266 100644
>>>> --- a/kernel/padata.c
>>>> +++ b/kernel/padata.c
>>>> @@ -319,6 +319,7 @@ static void padata_reorder(struct parallel_data *pd)
>>>>  	if (!spin_trylock_bh(&pd->lock))
>>>>  		return;
>>>>  
>>>> +	padata_get_pd(pd);
>>>>  	while (1) {
>>>>  		padata = padata_find_next(pd, true);
>>>>  
>>>> @@ -355,6 +356,7 @@ static void padata_reorder(struct parallel_data *pd)
>>>>  	reorder = per_cpu_ptr(pd->reorder_list, pd->cpu);
>>>>  	if (!list_empty(&reorder->list) && padata_find_next(pd, false))
>>>>  		queue_work(pinst->serial_wq, &pd->reorder_work);
>>>> +	padata_put_pd(pd);
>>>
>>> Putting the ref unconditionally here doesn't cover the case where reorder_work
>>> is queued and accesses the freed pd.
>>>
>>> The review of patches 3-5 from this series has a potential solution for
>>> this that also keeps some of these refcount operations out of the fast
>>> path:
>>>
>>>     https://lore.kernel.org/all/20221019083708.27138-1-nstange@suse.de/
>>>
>>
>> Thank you for your review.
>>
>> IIUC, patches 3-5 from this series aim to fix two issue.
>> 1. Avoid UAF for pd(the patch 3).
>> 2. Avoid UAF for ps(the patch 4-5).
>> What my patch 2 intends to fix is the issue 1.
>>
>> Let's focus on issue 1.
>> As shown bellow, if reorder_work is queued, the refcnt must greater than
>> 0, since its serial work have not be finished yet. Do your agree with that?
> 
> I think it's possible for reorder_work to be queued even though all
> serial works have finished:
> 
>  - padata_reorder finds the reorder list nonempty and sees an object from
>    padata_find_next, then gets preempted
>  - the serial work finishes in another context
>  - back in padata_reorder, reorder_work is queued
> 
> Not sure this race could actually happen in practice though.
> 
> But, I also think reorder_work can be queued when there's an unfinished
> serial work, as you say, but with UAF still happening:
> 
> padata_do_serial
>   ...
>   padata_reorder
>     // processes all remaining
>     // requests then breaks
>     while (1) {
>       if (!padata)
>         break;
>       ...
>     }
>   
>                                   padata_do_serial
>                                     // new request added
>                                     list_add
>     // sees the new request
>     queue_work(reorder_work)
>                                     padata_reorder
>                                       queue_work_on(squeue->work)
> 
> 
>    
>                                   <kworker context>
>                                   padata_serial_worker
>                                     // completes new request,
>                                     // no more outstanding
>                                     // requests
>                                                                       crypto_del_alg
>                                                                         // free pd
> <kworker context>
> invoke_padata_reorder
>   // UAF of pd
> 

Sorry for being busy with other work for a while.
Thank you for your patience.
In theory, it does exist. Although I was unable reproduce it(I added
delay helper as below), I noticed that Herbert has reported a UAF issue
occurred in the padata_parallel_worker function. Therefore, it would be
better to fix it in Nicolai's approach.

static void padata_parallel_worker(struct work_struct *parallel_work)
 {
+       mdelay(10);
+

Hi, Nicolai, would you resend the patch 3 to fix this issue?
I noticed you sent the patch 2 years ago, but this series has not been
merged.

Or may I send a patch that aligns with your approach to resolve it?
Looking forward your feedback.


>> pcrypt_aead_encrypt/pcrypt_aead_decrypt
>> padata_do_parallel 			// refcount_inc(&pd->refcnt);
>> padata_parallel_worker	
>> padata->parallel(padata);
>> padata_do_serial(padata);		
>> // pd->reorder_list 			// enque reorder_list
>> padata_reorder
>>  - case1:squeue->work
>> 	padata_serial_worker		// sub refcnt cnt
>>  - case2:pd->reorder_work		// reorder->list is not empty
>> 	invoke_padata_reorder 		// this means refcnt > 0
>> 	...
>> 	padata_serial_worker
> 
> In other words, in case2 above, reorder_work could be queued, another
> context could complete the request in padata_serial_worker, and then
> invoke_padata_reorder could run and UAF when there aren't any remaining
> serial works.
> 
>> I think the patch 3(from Nicolai Stange) can also avoid UAF for pd, but
>> it's complicated.
> 
> For fixing the issue you describe, without regard for the reorder work,
> I think the synchronize_rcu from near the end of the patch 3 thread is
> enough.  A synchronize_rcu in the slow path seems better than two
> atomics in the fast path.

Thank you. I tested with 'synchronize_rcu', and it can fix the issue I
encountered. As I mentioned, Herbert has provided another stack, which
indicates that case 2 exists. I think it would be better to fix it as
patch 3 did.

Thanks,
Ridong


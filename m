Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 331EE6FBF;
	Fri,  6 Dec 2024 03:48:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.187
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733456929; cv=none; b=Wl3LNV0W5oLctotd0qGF8Rgi5kXb+7f/s6iOTT6BsvLLlXwSyuaU+yf1iCaVVhgeMpytk4jZHPdy6L7guCE6G3oM+ouRW8FFQ2UqJHHlNlLtgMyBh/LYd+pyYuay/lDX5oqWcGKrYs0Zi2gC9HQSpJOUS+SwtGqzbRifGWXiZ9g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733456929; c=relaxed/simple;
	bh=ynRzNbP/8JinuPL9OYupd8jhTZfVrzQbdDdX3HyqwJw=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type; b=h2BBXaNNg4m1NkaUkMJe/mj2rlQbGN3YShof5HVAQi6bbCduvjISpeh+JbQYrtq90bL+0tAgNuReu7iaUZ60ayL6BDZgX4AFBYuRokFWkAt+icnVesmuVSZ6veDovMvq8IxaR1ZW3FHc2KkPnixN25vaUfzF3nTHmjHaNvUk9go=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=45.249.212.187
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.88.194])
	by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4Y4HHH29v2z11PQ2;
	Fri,  6 Dec 2024 11:46:19 +0800 (CST)
Received: from kwepemd100013.china.huawei.com (unknown [7.221.188.163])
	by mail.maildlp.com (Postfix) with ESMTPS id 3859F140118;
	Fri,  6 Dec 2024 11:48:38 +0800 (CST)
Received: from [10.67.109.79] (10.67.109.79) by kwepemd100013.china.huawei.com
 (7.221.188.163) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1258.34; Fri, 6 Dec
 2024 11:48:37 +0800
Message-ID: <2ba08cbe-ce27-4b83-acad-3845421c9bf6@huawei.com>
Date: Fri, 6 Dec 2024 11:48:36 +0800
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/2] padata: fix UAF in padata_reorder
To: Daniel Jordan <daniel.m.jordan@oracle.com>, Chen Ridong
	<chenridong@huaweicloud.com>
CC: <steffen.klassert@secunet.com>, <herbert@gondor.apana.org.au>,
	<linux-crypto@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<wangweiyang2@huawei.com>
References: <20241123080509.2573987-1-chenridong@huaweicloud.com>
 <20241123080509.2573987-3-chenridong@huaweicloud.com>
 <nihv732hsimy4lfnzspjur4ndal7n3nngrukvr5fx7emgp2jzl@mjz6q5zsswds>
Content-Language: en-US
From: chenridong <chenridong@huawei.com>
In-Reply-To: <nihv732hsimy4lfnzspjur4ndal7n3nngrukvr5fx7emgp2jzl@mjz6q5zsswds>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: dggems702-chm.china.huawei.com (10.3.19.179) To
 kwepemd100013.china.huawei.com (7.221.188.163)



On 2024/12/6 7:01, Daniel Jordan wrote:
> Hello Ridong,
> 
> On Sat, Nov 23, 2024 at 08:05:09AM +0000, Chen Ridong wrote:
>> From: Chen Ridong <chenridong@huawei.com>
>>
>> A bug was found when run ltp test:
> ...snip...
>> This can be explained as bellow:
>>
>> pcrypt_aead_encrypt
>> ...
>> padata_do_parallel
>> refcount_inc(&pd->refcnt); // add refcnt
>> ...
>> padata_do_serial
>> padata_reorder // pd
>> while (1) {
>> padata_find_next(pd, true); // using pd
>> queue_work_on
>> ...
>> padata_serial_worker				crypto_del_alg
>> padata_put_pd_cnt // sub refcnt
>> 						padata_free_shell
>> 						padata_put_pd(ps->pd);
>> 						// pd is freed
>> // loop again, but pd is freed
>> // call padata_find_next, UAF
>> }
> 
> Thanks for the fix and clear explanation.
> 
>> diff --git a/kernel/padata.c b/kernel/padata.c
>> index 5d8e18cdcb25..627014825266 100644
>> --- a/kernel/padata.c
>> +++ b/kernel/padata.c
>> @@ -319,6 +319,7 @@ static void padata_reorder(struct parallel_data *pd)
>>  	if (!spin_trylock_bh(&pd->lock))
>>  		return;
>>  
>> +	padata_get_pd(pd);
>>  	while (1) {
>>  		padata = padata_find_next(pd, true);
>>  
>> @@ -355,6 +356,7 @@ static void padata_reorder(struct parallel_data *pd)
>>  	reorder = per_cpu_ptr(pd->reorder_list, pd->cpu);
>>  	if (!list_empty(&reorder->list) && padata_find_next(pd, false))
>>  		queue_work(pinst->serial_wq, &pd->reorder_work);
>> +	padata_put_pd(pd);
> 
> Putting the ref unconditionally here doesn't cover the case where reorder_work
> is queued and accesses the freed pd.
> 
> The review of patches 3-5 from this series has a potential solution for
> this that also keeps some of these refcount operations out of the fast
> path:
> 
>     https://lore.kernel.org/all/20221019083708.27138-1-nstange@suse.de/
> 

Thank you for your review.

IIUC, patches 3-5 from this series aim to fix two issue.
1. Avoid UAF for pd(the patch 3).
2. Avoid UAF for ps(the patch 4-5).
What my patch 2 intends to fix is the issue 1.

Let's focus on issue 1.
As shown bellow, if reorder_work is queued, the refcnt must greater than
0, since its serial work have not be finished yet. Do your agree with that?

pcrypt_aead_encrypt/pcrypt_aead_decrypt
padata_do_parallel 			// refcount_inc(&pd->refcnt);
padata_parallel_worker	
padata->parallel(padata);
padata_do_serial(padata);		
// pd->reorder_list 			// enque reorder_list
padata_reorder
 - case1:squeue->work
	padata_serial_worker		// sub refcnt cnt
 - case2:pd->reorder_work		// reorder->list is not empty
	invoke_padata_reorder 		// this means refcnt > 0
	...
	padata_serial_worker

I think the patch 3(from Nicolai Stange) can also avoid UAF for pd, but
it's complicated. IIUC, the issue 1 can only occur in the scenario what
I mentioned is my commit message. How I fix issue 1 is by adding and
putting the refcnt in the padata_reorder function, which is simple and
clear.

If understand something uncorrectly, please let me know.

As the issue 2, I have not encountered it, but it exists in theory.

Thanks,
Ridong

Received: from dggsgout12.his.huawei.com (dggsgout12.his.huawei.com [45.249.212.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3792919F421;
	Thu,  9 Jan 2025 07:27:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736407630; cv=none; b=aVa0sDwNQfJpYLD7vDFI3SWVB9BOgdTpAcVrV62ah8Qsd9rATLdM90CZHcXn/rgFuygJSJfWN13PL7bLSHFiayDqMv4RIXsrJC9OtzhnUvmzY5mGCjER2Sy1xNEbnPsg4JegeehR4q0UXLlyk9e98tUwI2MiRmD4A2wQzdG71HE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736407630; c=relaxed/simple;
	bh=HrTS+U25Gs6egDsE8E0/0a0Kl/Qpw2fz6AMZh2l4scU=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=bkhLEhQEe+JAnnaS6N+Y5snmDY81/Gc3MuRC0PVVkSWtttw5fPknkMF3M9smxRd8ZKfgPz7uHCVXwbu1PY83uYKwrmAFr9uJKJZSP2HcPtCGPEUY5HHoLno5HbKmjdyHOK/ZMQoozmqfzNCmzdNgwrjjbptNq+VawyyKSxNmlrU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.93.142])
	by dggsgout12.his.huawei.com (SkyGuard) with ESMTP id 4YTGYv0csxz4f3kG8;
	Thu,  9 Jan 2025 15:26:43 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.252])
	by mail.maildlp.com (Postfix) with ESMTP id 47D991A0E67;
	Thu,  9 Jan 2025 15:27:03 +0800 (CST)
Received: from [10.67.109.79] (unknown [10.67.109.79])
	by APP3 (Coremail) with SMTP id _Ch0CgCH2MJCen9nJIfNAQ--.43334S2;
	Thu, 09 Jan 2025 15:26:59 +0800 (CST)
Message-ID: <348d0c75-b8a9-4319-93f4-de2f1dd1eab8@huaweicloud.com>
Date: Thu, 9 Jan 2025 15:26:58 +0800
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/2] padata: fix UAF in padata_reorder
To: Daniel Jordan <daniel.m.jordan@oracle.com>,
 Chen Ridong <chenridong@huaweicloud.com>
Cc: nstange@suse.de, steffen.klassert@secunet.com,
 herbert@gondor.apana.org.au, linux-crypto@vger.kernel.org,
 linux-kernel@vger.kernel.org, wangweiyang2@huawei.com
References: <20241123080509.2573987-1-chenridong@huaweicloud.com>
 <20241123080509.2573987-3-chenridong@huaweicloud.com>
 <nihv732hsimy4lfnzspjur4ndal7n3nngrukvr5fx7emgp2jzl@mjz6q5zsswds>
 <2ba08cbe-ce27-4b83-acad-3845421c9bf6@huawei.com>
 <mffodsysfv4qakpyv6qbuqxzfpmt54q7cbpgne6paykzjx626y@f3ze6ti7cshp>
 <27690711-20f5-4e2c-8f43-17b7d3f10f86@huaweicloud.com>
 <jfjz5d7zwbytztackem7ibzalm5lnxldi2eofeiczqmqs2m7o6@fq426cwnjtkm>
Content-Language: en-US
From: Chen Ridong <chenridong@huaweicloud.com>
In-Reply-To: <jfjz5d7zwbytztackem7ibzalm5lnxldi2eofeiczqmqs2m7o6@fq426cwnjtkm>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-CM-TRANSID:_Ch0CgCH2MJCen9nJIfNAQ--.43334S2
X-Coremail-Antispam: 1UD129KBjvJXoWxuF1kCr17Wr1UWFW5GF1kuFg_yoW5Wry5pa
	yYyay2kr4DJrWxAwn2vw42vryIg34jqF1agF1rGr1rC398trySvw1IyF4F9F9rWrn3K34v
	vrWUX3Zavw4DAaDanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUkm14x267AKxVW8JVW5JwAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
	rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2ocxC64kIII0Yj41l84x0c7CEw4AK67xGY2AK02
	1l84ACjcxK6xIIjxv20xvE14v26F1j6w1UM28EF7xvwVC0I7IYx2IY6xkF7I0E14v26r4U
	JVWxJr1l84ACjcxK6I8E87Iv67AKxVW0oVCq3wA2z4x0Y4vEx4A2jsIEc7CjxVAFwI0_Gc
	CE3s1le2I262IYc4CY6c8Ij28IcVAaY2xG8wAqx4xG64xvF2IEw4CE5I8CrVC2j2WlYx0E
	2Ix0cI8IcVAFwI0_Jr0_Jr4lYx0Ex4A2jsIE14v26r1j6r4UMcvjeVCFs4IE7xkEbVWUJV
	W8JwACjcxG0xvEwIxGrwACjI8F5VA0II8E6IAqYI8I648v4I1lc7CjxVAaw2AFwI0_JF0_
	Jw1l42xK82IYc2Ij64vIr41l4I8I3I0E4IkC6x0Yz7v_Jr0_Gr1lx2IqxVAqx4xG67AKxV
	WUJVWUGwC20s026x8GjcxK67AKxVWUGVWUWwC2zVAF1VAY17CE14v26r1q6r43MIIYrxkI
	7VAKI48JMIIF0xvE2Ix0cI8IcVAFwI0_Jr0_JF4lIxAIcVC0I7IYx2IY6xkF7I0E14v26r
	1j6r4UMIIF0xvE42xK8VAvwI8IcIk0rVWUJVWUCwCI42IY6I8E87Iv67AKxVWUJVW8JwCI
	42IY6I8E87Iv6xkF7I0E14v26r4j6r4UJbIYCTnIWIevJa73UjIFyTuYvjfUYCJmUUUUU
X-CM-SenderInfo: hfkh02xlgr0w46kxt4xhlfz01xgou0bp/



On 2025/1/8 2:43, Daniel Jordan wrote:
> Hello Ridong,
> 
> On Mon, Dec 23, 2024 at 05:00:16PM +0800, Chen Ridong wrote:
>> Sorry for being busy with other work for a while.
>> Thank you for your patience.
>> In theory, it does exist. Although I was unable reproduce it(I added
>> delay helper as below), I noticed that Herbert has reported a UAF issue
>> occurred in the padata_parallel_worker function. Therefore, it would be
> 
> I'm thinking you're referring to this?:
>     https://lore.kernel.org/all/ZuFxD90UO8HadnCj@gondor.apana.org.au/
> 
Yes.

>> better to fix it in Nicolai's approach.
>>
>> static void padata_parallel_worker(struct work_struct *parallel_work)
>>  {
>> +       mdelay(10);
>> +
>>
>> Hi, Nicolai, would you resend the patch 3 to fix this issue?
>> I noticed you sent the patch 2 years ago, but this series has not been
>> merged.
>>
>> Or may I send a patch that aligns with your approach to resolve it?
>> Looking forward your feedback.
>>
>>
>>>> pcrypt_aead_encrypt/pcrypt_aead_decrypt
>>>> padata_do_parallel 			// refcount_inc(&pd->refcnt);
>>>> padata_parallel_worker	
>>>> padata->parallel(padata);
>>>> padata_do_serial(padata);		
>>>> // pd->reorder_list 			// enque reorder_list
>>>> padata_reorder
>>>>  - case1:squeue->work
>>>> 	padata_serial_worker		// sub refcnt cnt
>>>>  - case2:pd->reorder_work		// reorder->list is not empty
>>>> 	invoke_padata_reorder 		// this means refcnt > 0
>>>> 	...
>>>> 	padata_serial_worker
>>>
>>> In other words, in case2 above, reorder_work could be queued, another
>>> context could complete the request in padata_serial_worker, and then
>>> invoke_padata_reorder could run and UAF when there aren't any remaining
>>> serial works.
>>>
>>>> I think the patch 3(from Nicolai Stange) can also avoid UAF for pd, but
>>>> it's complicated.
>>>
>>> For fixing the issue you describe, without regard for the reorder work,
>>> I think the synchronize_rcu from near the end of the patch 3 thread is
>>> enough.  A synchronize_rcu in the slow path seems better than two
>>> atomics in the fast path.
>>
>> Thank you. I tested with 'synchronize_rcu', and it can fix the issue I
> 
> Good to know the synchronize_rcu works, thanks for testing that.
> 
>> encountered. As I mentioned, Herbert has provided another stack, which
>> indicates that case 2 exists. I think it would be better to fix it as
>> patch 3 did.
> 
> But Nicolai and I already agreed to the synchronize_rcu change plus the
> alternative fix in the patch 5 thread:
>     https://lore.kernel.org/all/87bkpgb7q6.fsf@suse.de/
> 
> These two changes fix all known padata lifetime issues, including the
> one with reorder_work in case 2, and keep more refcnt ops out of the
> fast path than the original patch 3.
> 

Thank you. I will send a new series with thought.

Best regard,
Ridong


Received: from dggsgout11.his.huawei.com (dggsgout11.his.huawei.com [45.249.212.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE251B661;
	Mon, 26 May 2025 01:15:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748222146; cv=none; b=dcdeVdk+cIZjlAZnQ044a0Spks+Ae8CYcATiydwgcMPDxqXgBkMEfgJKMmemAuoGcFf5XKmyfWEGM1hLvEcF3kO7ldl+QJGKPAOjh1NK43/EBtumkouVwbq4kfOD/s0O0Abwm5XMeTe5P2VmHVvuBiQzXEgOTSdC2UQSsB3/CiU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748222146; c=relaxed/simple;
	bh=kLgHflASkk+AOoCMgwo9BpScIU/wjvk0wobHRl8/3gs=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=BHn9/8LfSio/yGBIDEta+Diu8jMALnaRN83rMTt8QyUBioxP+AqVEOhGdc+CcaD5GY6znDOq0scl0N072/rubE94fG+sSlLWNi+NW8qpUnicllxDikRYUTQ8yAivP22HNexibCmt0KlWXGKrfpzrjn9NOa4KkFOQLhDnt77x6uQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=none smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.93.142])
	by dggsgout11.his.huawei.com (SkyGuard) with ESMTPS id 4b5HrZ2CCYzYQtG9;
	Mon, 26 May 2025 09:15:42 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.252])
	by mail.maildlp.com (Postfix) with ESMTP id 71C3B1A018D;
	Mon, 26 May 2025 09:15:41 +0800 (CST)
Received: from [10.67.109.79] (unknown [10.67.109.79])
	by APP3 (Coremail) with SMTP id _Ch0CgDHG8a6wDNooAxJNQ--.29873S2;
	Mon, 26 May 2025 09:15:39 +0800 (CST)
Message-ID: <faa23d11-4387-4952-bd29-034b4558668c@huaweicloud.com>
Date: Mon, 26 May 2025 09:15:37 +0800
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 3/3] padata: avoid UAF for reorder_work
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: steffen.klassert@secunet.com, daniel.m.jordan@oracle.com,
 nstange@suse.de, linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
 chenridong@huawei.com, wangweiyang2@huawei.com
References: <20250110061639.1280907-1-chenridong@huaweicloud.com>
 <20250110061639.1280907-4-chenridong@huaweicloud.com>
 <aC_yoWXJcsLxfLR4@gondor.apana.org.au>
Content-Language: en-US
From: Chen Ridong <chenridong@huaweicloud.com>
In-Reply-To: <aC_yoWXJcsLxfLR4@gondor.apana.org.au>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-CM-TRANSID:_Ch0CgDHG8a6wDNooAxJNQ--.29873S2
X-Coremail-Antispam: 1UD129KBjvJXoW7tF4kCFWrJrWUtr4kAF1xuFg_yoW8tryxpr
	WYkay7tF48trs7G3s2qryaq3W093yfZw13Krs7K34rC390qry0vr42vrWa9Fnrurn7Ar1j
	kFs5ZrnIv3yqvFJanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUylb4IE77IF4wAFF20E14v26r4j6ryUM7CY07I20VC2zVCF04k2
	6cxKx2IYs7xG6rWj6s0DM7CIcVAFz4kK6r1j6r18M28lY4IEw2IIxxk0rwA2F7IY1VAKz4
	vEj48ve4kI8wA2z4x0Y4vE2Ix0cI8IcVAFwI0_tr0E3s1l84ACjcxK6xIIjxv20xvEc7Cj
	xVAFwI0_Gr1j6F4UJwA2z4x0Y4vEx4A2jsIE14v26rxl6s0DM28EF7xvwVC2z280aVCY1x
	0267AKxVW0oVCq3wAS0I0E0xvYzxvE52x082IY62kv0487Mc02F40EFcxC0VAKzVAqx4xG
	6I80ewAv7VC0I7IYx2IY67AKxVWUJVWUGwAv7VC2z280aVAFwI0_Jr0_Gr1lOx8S6xCaFV
	Cjc4AY6r1j6r4UM4x0Y48IcVAKI48JMxkF7I0En4kS14v26r126r1DMxAIw28IcxkI7VAK
	I48JMxC20s026xCaFVCjc4AY6r1j6r4UMI8I3I0E5I8CrVAFwI0_Jr0_Jr4lx2IqxVCjr7
	xvwVAFwI0_JrI_JrWlx4CE17CEb7AF67AKxVWUtVW8ZwCIc40Y0x0EwIxGrwCI42IY6xII
	jxv20xvE14v26r1j6r1xMIIF0xvE2Ix0cI8IcVCY1x0267AKxVWUJVW8JwCI42IY6xAIw2
	0EY4v20xvaj40_Jr0_JF4lIxAIcVC2z280aVAFwI0_Jr0_Gr1lIxAIcVC2z280aVCY1x02
	67AKxVWUJVW8JbIYCTnIWIevJa73UjIFyTuYvjxUwxhLUUUUU
X-CM-SenderInfo: hfkh02xlgr0w46kxt4xhlfz01xgou0bp/



On 2025/5/23 11:59, Herbert Xu wrote:
> On Fri, Jan 10, 2025 at 06:16:39AM +0000, Chen Ridong wrote:
>> From: Chen Ridong <chenridong@huawei.com>
>>
>> Although the previous patch can avoid ps and ps UAF for _do_serial, it
>> can not avoid potential UAF issue for reorder_work. This issue can
>> happen just as below:
>>
>> crypto_request			crypto_request		crypto_del_alg
>> padata_do_serial
>>   ...
>>   padata_reorder
>>     // processes all remaining
>>     // requests then breaks
>>     while (1) {
>>       if (!padata)
>>         break;
>>       ...
>>     }
>>
>> 				padata_do_serial
>> 				  // new request added
>> 				  list_add
>>     // sees the new request
>>     queue_work(reorder_work)
>> 				  padata_reorder
>> 				    queue_work_on(squeue->work)
>> ...
>>
>> 				<kworker context>
>> 				padata_serial_worker
>> 				// completes new request,
>> 				// no more outstanding
>> 				// requests
>>
>> 							crypto_del_alg
>> 							  // free pd
>>
>> <kworker context>
>> invoke_padata_reorder
>>   // UAF of pd
> 
> Looking back this explanation is actually broken.  The call
> crypto_del_alg does not free anything immediately.  It can only
> start freeing things once the final tfm user goes away.  Any crypto
> request of that tfm must have completed before that happens.
> 
> If not there is a serious bug in the Crypto API.
> 
> So if crypto_del_alg is leading to a freeing of the pd while there
> are still outstanding users of that tfm, then this points to a bug
> in the Crypto API and not padata.
> 
> Can you still reproduce this bug easily if you revert the patches
> in this series? If so we should be able to track down the real bug.
> 

Unfortunately, I did not reproduce this bug, It was mentioned:
https://lore.kernel.org/all/20221019083708.27138-6-nstange@suse.de/

We through that the kworker is asynchronous, and this scenarios may happen.

Thanks,
Ridong

> To recap, every tfm holds a ref count on the underlying crypto_alg.
> All crypto requests must complete before a tfm can be freed, which
> then leads to a drop of the refcount on crypto_alg.
> 
> A crypto_alg can only be freed when its ref count hits zero.  Only
> then will the associated pd be freed.
> 
> So what's missing in the above picture is the entity that is freeing
> the tfm, thus leading to the actual freeing of the alg and pd.
> 
> Thanks,


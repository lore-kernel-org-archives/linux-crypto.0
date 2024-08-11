Received: from fllv0015.ext.ti.com (fllv0015.ext.ti.com [198.47.19.141])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7245517FE;
	Sun, 11 Aug 2024 05:44:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.47.19.141
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723355069; cv=none; b=Xi0XrAUN1kuGDrWMl38/nqLbLHHYS/dGg0YkZgJz3Fgqsa9GWTb5/HalzUErWU4ePe4UdGw9kjGE4ZPKszZK4dvRPVBrYec1zVWqagsjYsFv+f+m3kpjCoQy0tV4GS/4CM7b91K1CqWjlLFJtVMft5P06CJ/WRmh41IrLYr95ZM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723355069; c=relaxed/simple;
	bh=JGO6cAaAYQrAkledt5zG6oxNXE2zt4v72GCHvYMjDLU=;
	h=From:To:CC:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=LYjCrD7tQjvEQpWtU51pZzt1ya5suxn92gu3iOFgyeBN8Kq2qqKaZ9I450kqTEGedBbJ/taJ9IWE/WbAHTdYC7VVm3gM8acpvEQH3UOsSiyO8mx9f1vULE7ryuQNjQq3hK+95EQxBoTHhNme744KXWgZHhXmW0EN5EUC0YCisgE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=ti.com; spf=pass smtp.mailfrom=ti.com; dkim=pass (1024-bit key) header.d=ti.com header.i=@ti.com header.b=yh15/wgP; arc=none smtp.client-ip=198.47.19.141
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=ti.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ti.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=ti.com header.i=@ti.com header.b="yh15/wgP"
Received: from lelv0266.itg.ti.com ([10.180.67.225])
	by fllv0015.ext.ti.com (8.15.2/8.15.2) with ESMTP id 47B5i89T002019;
	Sun, 11 Aug 2024 00:44:08 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
	s=ti-com-17Q1; t=1723355048;
	bh=/+PUL3LEMAgL23QbsIlJGx5S8eUd+Dakmov9dS9NNFc=;
	h=From:To:CC:Subject:In-Reply-To:References:Date;
	b=yh15/wgPUSS4AxHoEdrV+kxOA+KRqVQt/pW6oP2OmcBnvs53YcK973pvYI7tBYTi1
	 4REZcWq/6GOp/5DYAXraQ0TzzwWjGhiMS468mpStM0cRya901dPbeRkIBeHywdWkIs
	 f4YodD6svGmd/ajgBkvwxNoSpGKbRVDJQl5RTJ8M=
Received: from DFLE109.ent.ti.com (dfle109.ent.ti.com [10.64.6.30])
	by lelv0266.itg.ti.com (8.15.2/8.15.2) with ESMTPS id 47B5i87i016786
	(version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
	Sun, 11 Aug 2024 00:44:08 -0500
Received: from DFLE107.ent.ti.com (10.64.6.28) by DFLE109.ent.ti.com
 (10.64.6.30) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2507.23; Sun, 11
 Aug 2024 00:44:08 -0500
Received: from lelvsmtp5.itg.ti.com (10.180.75.250) by DFLE107.ent.ti.com
 (10.64.6.28) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2507.23 via
 Frontend Transport; Sun, 11 Aug 2024 00:44:08 -0500
Received: from localhost (kamlesh.dhcp.ti.com [172.24.227.123])
	by lelvsmtp5.itg.ti.com (8.15.2/8.15.2) with ESMTP id 47B5i76L120127;
	Sun, 11 Aug 2024 00:44:08 -0500
From: Kamlesh Gurudasani <kamlesh@ti.com>
To: Waiman Long <longman@redhat.com>,
        Steffen Klassert
	<steffen.klassert@secunet.com>,
        Daniel Jordan <daniel.m.jordan@oracle.com>,
        Andrew Morton <akpm@linux-foundation.org>
CC: <linux-crypto@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] padata: Fix possible divide-by-0 panic in
 padata_mt_helper()
In-Reply-To: <70e28278-d9cf-4158-b296-cabe7786e4a7@redhat.com>
References: <20240806174647.1050398-1-longman@redhat.com>
 <87jzgonug5.fsf@kamlesh.i-did-not-set--mail-host-address--so-tickle-me>
 <70e28278-d9cf-4158-b296-cabe7786e4a7@redhat.com>
Date: Sun, 11 Aug 2024 11:14:06 +0530
Message-ID: <87h6brobq1.fsf@kamlesh.i-did-not-set--mail-host-address--so-tickle-me>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
X-EXCLAIMER-MD-CONFIG: e1e8a2fd-e40a-4ac6-ac9b-f7e9cc9ee180

Waiman Long <longman@redhat.com> writes:

> On 8/10/24 13:44, Kamlesh Gurudasani wrote:
>> Waiman Long <longman@redhat.com> writes:
>>
...
>>> diff --git a/kernel/padata.c b/kernel/padata.c
>>> index 53f4bc912712..0fa6c2895460 100644
>>> --- a/kernel/padata.c
>>> +++ b/kernel/padata.c
>>> @@ -517,6 +517,13 @@ void __init padata_do_multithreaded(struct padata_mt_job *job)
>>>   	ps.chunk_size = max(ps.chunk_size, job->min_chunk);
>>>   	ps.chunk_size = roundup(ps.chunk_size, job->align);
>>>   
>>> +	/*
>>> +	 * chunk_size can be 0 if the caller sets min_chunk to 0. So force it
>>> +	 * to at least 1 to prevent divide-by-0 panic in padata_mt_helper().`
>>> +	 */
>> Thanks for the patch and detailed comment.
>>> +	if (!ps.chunk_size)
>>> +		ps.chunk_size = 1U;
>>> +
>> could it be
>>          ps.chunk_size = max(ps.chunk_size, 1U);
>>          
>> or can be merged with earlier max()
>>    	ps.chunk_size = max(ps.chunk_size, max(job->min_chunk, 1U));
>>    	ps.chunk_size = roundup(ps.chunk_size, job->align);
>>
>> sits well with how entire file is written and compiler is optimizing
>> them to same level.
>
> I had actually thought about doing that as an alternative. I used the 
> current patch to avoid putting too many max() calls there. I can go this 
> route if you guys prefer this.
Just curious, what is your reason for avoiding too many max() calls? Both
        if (!ps.chunk_size)
        	ps.chunk_size = 1U;
and
        ps.chunk_size = max(ps.chunk_size, 1U);

are having same number of instructions [1]. 

[1] https://godbolt.org/z/ajrK59c67

We can avoid nested max(), though following would make it easier to understand. 

   ps.chunk_size = max(ps.chunk_size, 1U);

Cheers,
Kamlesh

>
> Cheers,
> Longman

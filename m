Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8FCA51A3BDB
	for <linux-crypto@vger.kernel.org>; Tue, 13 Aug 2024 18:28:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723573707; cv=none; b=fIaSyTono23cUlXoSrE8yW8TbQoAfTSHpkUwEiqHU2XAFk6+pFP5XS4sRhjDrDdKQzLi157UPBXTiXSU/OMIp2ETgW8m2lsgeHSycpUcr2dOTI34n24JV86+1xp32ovJPFDxVaFpkI2QZkuTJpRdYcBH7d36Q8xfhBht73mABDA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723573707; c=relaxed/simple;
	bh=Hpt8Zo5E5ld5ZcUmnN7Q+4OYNPJ9H1oI3fleI51iO8M=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=swX6SG+6wYBSMi0Pa2O2pNCwN6OAToI1n89UYLWGDmtDpw+xOQ1gYOv/EB+qhgpDxFq5TyX+9VbZFGsW6BT9EqEXOug3z9/x2EJMKw46enjOKxscQWqT43Z/j5mQ4kxdXP1JBoWRNBHSH9mJTEeCJ8neSWfrx7lpaWIr18W9o6I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=fuv+6xA7; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="fuv+6xA7"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1723573704;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=JiRLVePlGkQbycAKOyNYAtTK9fFgSoD/Bslm5dQ9Bug=;
	b=fuv+6xA7XUzSlonuvlrgkhrwM8jyX185NNwzyjyzhhKR0/TJa2IBZd74VCvSQJWsSqi4G9
	v5gii4pETtB3Pon3dtl6uq0w/6JGmisuJlgaewSq5JXYGkSBtdGmGemeywlyFyGS4AQx/h
	aassV3hP1+98d27D2rz+xJUtByoxK1U=
Received: from mx-prod-mc-02.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-328-bC5nKgKYPJefVndcaNOblg-1; Tue,
 13 Aug 2024 14:28:20 -0400
X-MC-Unique: bC5nKgKYPJefVndcaNOblg-1
Received: from mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.15])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-02.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 6FFE018EB230;
	Tue, 13 Aug 2024 18:28:19 +0000 (UTC)
Received: from [10.2.16.208] (unknown [10.2.16.208])
	by mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id BD4891944A95;
	Tue, 13 Aug 2024 18:28:17 +0000 (UTC)
Message-ID: <986ef2c0-4ed7-4b13-82f2-5f14e30d08e1@redhat.com>
Date: Tue, 13 Aug 2024 14:28:17 -0400
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] padata: Fix possible divide-by-0 panic in
 padata_mt_helper()
To: Kamlesh Gurudasani <kamlesh@ti.com>,
 Steffen Klassert <steffen.klassert@secunet.com>,
 Daniel Jordan <daniel.m.jordan@oracle.com>,
 Andrew Morton <akpm@linux-foundation.org>
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20240806174647.1050398-1-longman@redhat.com>
 <87jzgonug5.fsf@kamlesh.i-did-not-set--mail-host-address--so-tickle-me>
 <70e28278-d9cf-4158-b296-cabe7786e4a7@redhat.com>
 <87h6brobq1.fsf@kamlesh.i-did-not-set--mail-host-address--so-tickle-me>
Content-Language: en-US
From: Waiman Long <longman@redhat.com>
In-Reply-To: <87h6brobq1.fsf@kamlesh.i-did-not-set--mail-host-address--so-tickle-me>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.15


On 8/11/24 01:44, Kamlesh Gurudasani wrote:
> Waiman Long <longman@redhat.com> writes:
>
>> On 8/10/24 13:44, Kamlesh Gurudasani wrote:
>>> Waiman Long <longman@redhat.com> writes:
>>>
> ...
>>>> diff --git a/kernel/padata.c b/kernel/padata.c
>>>> index 53f4bc912712..0fa6c2895460 100644
>>>> --- a/kernel/padata.c
>>>> +++ b/kernel/padata.c
>>>> @@ -517,6 +517,13 @@ void __init padata_do_multithreaded(struct padata_mt_job *job)
>>>>    	ps.chunk_size = max(ps.chunk_size, job->min_chunk);
>>>>    	ps.chunk_size = roundup(ps.chunk_size, job->align);
>>>>    
>>>> +	/*
>>>> +	 * chunk_size can be 0 if the caller sets min_chunk to 0. So force it
>>>> +	 * to at least 1 to prevent divide-by-0 panic in padata_mt_helper().`
>>>> +	 */
>>> Thanks for the patch and detailed comment.
>>>> +	if (!ps.chunk_size)
>>>> +		ps.chunk_size = 1U;
>>>> +
>>> could it be
>>>           ps.chunk_size = max(ps.chunk_size, 1U);
>>>           
>>> or can be merged with earlier max()
>>>     	ps.chunk_size = max(ps.chunk_size, max(job->min_chunk, 1U));
>>>     	ps.chunk_size = roundup(ps.chunk_size, job->align);
>>>
>>> sits well with how entire file is written and compiler is optimizing
>>> them to same level.
>> I had actually thought about doing that as an alternative. I used the
>> current patch to avoid putting too many max() calls there. I can go this
>> route if you guys prefer this.
> Just curious, what is your reason for avoiding too many max() calls? Both
>          if (!ps.chunk_size)
>          	ps.chunk_size = 1U;
> and
>          ps.chunk_size = max(ps.chunk_size, 1U);
>
> are having same number of instructions [1].
>
> [1] https://godbolt.org/z/ajrK59c67
>
> We can avoid nested max(), though following would make it easier to understand.
>
>     ps.chunk_size = max(ps.chunk_size, 1U);

That will certainly work. My current patch has been merged into the 
Linus tree. You are welcome to post another patch to clean it up if you 
want.

Cheers,
Longman

>
> Cheers,
> Kamlesh
>
>> Cheers,
>> Longman


Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 43BA9154C11
	for <linux-crypto@vger.kernel.org>; Sun, 25 Aug 2024 15:58:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724601482; cv=none; b=NE4c8JQxklIRAYMXjnIbYfrrWZ8xFVUNFsu5520sncPlL0k67mXnguKJ9XjGIFmzTiCnpLGLBAH0mXF5n9Vab+RcmOFLRcjNR8KjE09wfj8bvCkoi+eQufULRTIaSOV81O6YIXvuhDCtOyttSq1SIVybq54sEogJ3T3Cv6g9nUI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724601482; c=relaxed/simple;
	bh=ezffQNU1szIz3pvp4vj5BZ5nLJ9pWUp7VuSOTePVzl4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=hI0U7hb8KpeRgFWKpPH3ctFM2oJSVF+YdWbI5f2TM9apFiE297tlHicT3rmZTvALtDSc+ZK4lrUSVw6dqoRQauy+ouCQtMRJKUP87Apx8zISVgnQezWH5l1EM/6TGEEoruTQjFRnRfTKWBodXuZz4ZR2FPwbKQxBCBR0mE/oPTo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Fqz7b1SS; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Fqz7b1SS"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1724601479;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=HW4V02rxhL7jFxeX8s68XMzeocslCRd9TScmMxpXdJY=;
	b=Fqz7b1SSDmhka9XEYaqm8iIxaK6zFncAyS+Hjat+RPiGIWjtz8OWe63Q/c4NpmZQu1aEYt
	KgG7jPrwrbzffkf3gvYhBw+plgzxYMe27nuAL9tFbGvJyIsFFIEJ/PIjjnseHRGrVxmz5c
	g2Cibu+EikRfB1NTWDDaUnr3EmMxBYc=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-634-k8lLBNtuND2MULniVMKF7g-1; Sun,
 25 Aug 2024 11:57:55 -0400
X-MC-Unique: k8lLBNtuND2MULniVMKF7g-1
Received: from mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.15])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 507781956080;
	Sun, 25 Aug 2024 15:57:53 +0000 (UTC)
Received: from [10.2.16.7] (unknown [10.2.16.7])
	by mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 456791955E8C;
	Sun, 25 Aug 2024 15:57:51 +0000 (UTC)
Message-ID: <609c9a82-38c9-4643-b62f-16fbd34b20e0@redhat.com>
Date: Sun, 25 Aug 2024 11:57:50 -0400
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [EXTERNAL] Re: [PATCH] padata: Honor the caller's alignment in
 case of chunk_size 0
To: Kamlesh Gurudasani <kamlesh@ti.com>,
 Steffen Klassert <steffen.klassert@secunet.com>,
 Daniel Jordan <daniel.m.jordan@oracle.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 Herbert Xu <herbert@gondor.apana.org.au>
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20240822-max-v1-1-cb4bc5b1c101@ti.com>
 <21df0502-3f16-4afc-9f3c-7825ded578c4@redhat.com>
 <87y14kn8ev.fsf@kamlesh.i-did-not-set--mail-host-address--so-tickle-me>
Content-Language: en-US
From: Waiman Long <longman@redhat.com>
In-Reply-To: <87y14kn8ev.fsf@kamlesh.i-did-not-set--mail-host-address--so-tickle-me>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.15

On 8/25/24 07:34, Kamlesh Gurudasani wrote:
> Waiman Long <longman@redhat.com> writes:
>
>> This message was sent from outside of Texas Instruments.
>> Do not click links or open attachments unless you recognize the source of this email and know the content is safe.
>> Report Suspicious
>>   
>> On 8/21/24 17:02, Kamlesh Gurudasani wrote:
>>> In the case where we are forcing the ps.chunk_size to be at least 1,
>>> we are ignoring the caller's alignment.
>>>
>>> Move the forcing of ps.chunk_size to be at least 1 before rounding it
>>> up to caller's alignment, so that caller's alignment is honored.
>>>
>>> While at it, use max() to force the ps.chunk_size to be at least 1 to
>>> improve readability.
>>>
>>> Fixes: 6d45e1c948a8 ("padata: Fix possible divide-by-0 panic in padata_mt_helper()")
>>> Signed-off-by: Kamlesh Gurudasani <kamlesh@ti.com>
>>> ---
>>>    kernel/padata.c | 12 ++++--------
>>>    1 file changed, 4 insertions(+), 8 deletions(-)
>>>
>>> diff --git a/kernel/padata.c b/kernel/padata.c
>>> index 0fa6c2895460..d8a51eff1581 100644
>>> --- a/kernel/padata.c
>>> +++ b/kernel/padata.c
>>> @@ -509,21 +509,17 @@ void __init padata_do_multithreaded(struct padata_mt_job *job)
>>>    
>>>    	/*
>>>    	 * Chunk size is the amount of work a helper does per call to the
>>> -	 * thread function.  Load balance large jobs between threads by
>>> +	 * thread function. Load balance large jobs between threads by
>>>    	 * increasing the number of chunks, guarantee at least the minimum
>>>    	 * chunk size from the caller, and honor the caller's alignment.
>>> +	 * Ensure chunk_size is at least 1 to prevent divide-by-0
>>> +	 * panic in padata_mt_helper().
>>>    	 */
>>>    	ps.chunk_size = job->size / (ps.nworks * load_balance_factor);
>>>    	ps.chunk_size = max(ps.chunk_size, job->min_chunk);
>>> +	ps.chunk_size = max(ps.chunk_size, 1ul);
>>>    	ps.chunk_size = roundup(ps.chunk_size, job->align);
>>>    
>>> -	/*
>>> -	 * chunk_size can be 0 if the caller sets min_chunk to 0. So force it
>>> -	 * to at least 1 to prevent divide-by-0 panic in padata_mt_helper().`
>>> -	 */
>>> -	if (!ps.chunk_size)
>>> -		ps.chunk_size = 1U;
>>> -
>>>    	list_for_each_entry(pw, &works, pw_list)
>>>    		if (job->numa_aware) {
>>>    			int old_node = atomic_read(&last_used_nid);
>>>
>>> ---
>>> base-commit: b311c1b497e51a628aa89e7cb954481e5f9dced2
>>> change-id: 20240822-max-93c17adc6457
>> LGTM, my only nit is the use of "1ul" which is less common and harder to
>> read than "1UL" as the former one may be misread as a "lul" variable.
>>
>> Acked-by:  Waiman Long <longman@redhat.com>
> Thanks for the Acked-by, Waiman. I understand your point, though Daniel seems
> to be okay with this, so will keep it as is this time.

This is just a suggestion in case you need to update your patch. I am 
fine with keeping it as is if no further update is needed.

Cheers,
Longman


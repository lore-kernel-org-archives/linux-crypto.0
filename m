Received: from out-178.mta0.migadu.com (out-178.mta0.migadu.com [91.218.175.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E95C390989
	for <linux-crypto@vger.kernel.org>; Tue,  2 Jun 2026 18:17:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780424247; cv=none; b=YORtWe7g8EVT/C7SFgBNoj2hVyn7UzSVVNTBuOJK3myCjz/GTkDwzzgzb39WpBRtfE2RMZmXMjm1w2Gob2AYrUqNMKOhl8fy2nKIEt5n0UvGNzh9cFcOrwlaz4rAayBgB8/w37Dz0NtQ5J92SFEWcIaVFfDQK6V10wQnQ2SIHoI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780424247; c=relaxed/simple;
	bh=lKrbErFL33y0hvZLmkIS71x1sxFvJ5v/SI1TpWYA9xA=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=i/eEFufLxbfoWVg3mpfWTGrLRYSiIlUITgZdY6toxl8uFkHv+dSk9FhxRMQLS8xHA1vdKT/gEWeOzsVXPifn2Fah4/p5mZsSn18IagoygYngqQxGhUAJy9ZzByxl8P39V42ipPKF2e0pbx9gBd856cAbxi0sHI1UAQxOxDahefA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=BB8/dpvx; arc=none smtp.client-ip=91.218.175.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="BB8/dpvx"
Message-ID: <9f134eb4-1c64-47c4-8c4d-feb3c75072e6@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1780424234;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=KwNAHhnYjbAwxb3CujRs87uODn/mS6bwBRlR99Zbexw=;
	b=BB8/dpvxkI7ABBOHbbeUMG9d/OHBj/j+bxj8pt9mKsrjGzrzANg73shTc6xoqaD/+aPP0Y
	vjKYgCbcV3WOG7slgBbAE1+AzCYXkkR0MeM4lA+LI99GrQz1UM1pgr8frkxXrK2lpQb7mG
	ZbKZwEmW1VvzZbsEBSBae6FKovSch1A=
Date: Tue, 2 Jun 2026 11:17:06 -0700
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Subject: Re: [PATCH v2 4/4] crypto: ccp: Fix memory leak in SEV INIT_EX path
To: Tom Lendacky <thomas.lendacky@amd.com>,
 Sean Christopherson <seanjc@google.com>, Paolo Bonzini
 <pbonzini@redhat.com>, Borislav Petkov <bp@alien8.de>,
 Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
 "H. Peter Anvin" <hpa@zytor.com>, Peter Gonda <pgonda@google.com>,
 Brijesh Singh <brijesh.singh@amd.com>, Youngjae Lee <youngjaelee@meta.com>,
 Ashish Kalra <ashish.kalra@amd.com>, Michael Roth <michael.roth@amd.com>,
 John Allen <john.allen@amd.com>, Herbert Xu <herbert@gondor.apana.org.au>
Cc: clm@meta.com, kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-crypto@vger.kernel.org, stable@vger.kernel.org,
 Atish Patra <atishp@meta.com>, Sashiko <sashiko-bot@kernel.org>
References: <20260601-sev_snp_fixes-v2-0-611891b28a86@meta.com>
 <20260601-sev_snp_fixes-v2-4-611891b28a86@meta.com>
 <f57a427b-0fc8-41f6-bc3c-cd86e7812629@amd.com>
Content-Language: en-US
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Atish Patra <atish.patra@linux.dev>
In-Reply-To: <f57a427b-0fc8-41f6-bc3c-cd86e7812629@amd.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT


On 6/2/26 7:54 AM, Tom Lendacky wrote:
> On 6/1/26 18:04, Atish Patra wrote:
>> From: Atish Patra <atishp@meta.com>
>>
>> allocated pages in _init_ext_path are never freed and sev_init_ex_buffer
>> is left pointing at the leaked memory in case of any failures during the
>> function..
>>
>> Fix by adding an error path that frees the pages and clears
>> sev_init_ex_buffer. Make sure we only free the memory if the failure
>> happens before the conversion. Otherwise, we may end up trying to free
>> up converted pages in case of reclaim failure. rmp_mark_pages_firmware
>> failures should be rare enough to avoid more code complexity to track
>> down which pages were reclaimed/leaked vs which are not.
>>
>> Fixes: 7364a6fbca45 ("crypto: ccp: Handle non-volatile INIT_EX data when SNP is enabled")
>>
>> Reported-by: Sashiko <sashiko-bot@kernel.org>
>> Signed-off-by: Atish Patra <atishp@meta.com>
> Not sure the goto's are the best, but they do the job - just a personal
> preference for me here.
>
> The new comment below is a bit verbose, I would think it is sufficient to
> just say something like "Pages can be in an inconsistent state, don't
> release them back to the system" or such.
Sure. I will update the comment.
> It might be nice in the future if we can identify if the reclaim was
> successful and use that for determining whether the pages are safe to
> freed... but the failure chance should be practically zero, so I'm not
> sure it is worth it.

Yes. I had started that path but was not sure if the code churn is worth it.
I can send it as a separate patch and we can take a call if you are 
think it's worth.

>
> Reviewed-by: Tom Lendacky <thomas.lendacky@amd.com>
>
>> ---
>>   drivers/crypto/ccp/sev-dev.c | 16 ++++++++++++++--
>>   1 file changed, 14 insertions(+), 2 deletions(-)
>>
>> diff --git a/drivers/crypto/ccp/sev-dev.c b/drivers/crypto/ccp/sev-dev.c
>> index 3d4793e8e34b..8566f164430b 100644
>> --- a/drivers/crypto/ccp/sev-dev.c
>> +++ b/drivers/crypto/ccp/sev-dev.c
>> @@ -1550,7 +1550,7 @@ static int __sev_platform_init_handle_init_ex_path(struct sev_device *sev)
>>   
>>   	rc = sev_read_init_ex_file();
>>   	if (rc)
>> -		return rc;
>> +		goto err_free;
>>   
>>   	/* If SEV-SNP is initialized, transition to firmware page. */
>>   	if (sev->snp_initialized) {
>> @@ -1559,11 +1559,23 @@ static int __sev_platform_init_handle_init_ex_path(struct sev_device *sev)
>>   		npages = 1UL << get_order(NV_LENGTH);
>>   		if (rmp_mark_pages_firmware(__pa(sev_init_ex_buffer), npages, true)) {
>>   			dev_err(sev->dev, "SEV: INIT_EX NV memory page state change failed.\n");
>> -			return -ENOMEM;
>> +			rc = -ENOMEM;
>> +			/*
>> +			 * Don't free on conversion failure: the rollback may
>> +			 * have left pages firmware-owned, and a high-order
>> +			 * block can't be partially freed.
>> +			 */
>> +			goto err_reset;
>>   		}
>>   	}
>>   
>>   	return 0;
>> +
>> +err_free:
>> +	__free_pages(page, get_order(NV_LENGTH));
>> +err_reset:
>> +	sev_init_ex_buffer = NULL;
>> +	return rc;
>>   }
>>   
>>   static int __sev_platform_init_locked(int *error)
>>

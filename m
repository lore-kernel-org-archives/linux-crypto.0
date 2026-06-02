Received: from out-183.mta0.migadu.com (out-183.mta0.migadu.com [91.218.175.183])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6827720B80B
	for <linux-crypto@vger.kernel.org>; Tue,  2 Jun 2026 18:46:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.183
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780425984; cv=none; b=aXMgO3WI4JUR7hE+RlvwrM/oukNL+1K0qJIAonuQgvWMMJgcqXDmCBobGQJUyuTW8ECAWbnldP5yvPfTpvbNQkkCxtZxadjUVC+o6TWMzvCMIfpVDa9FKi/XBHWpXIdbEH1pWwMuOrSUrzMrpCoVbIJxqc3vUJ8gyjqdIPghVq8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780425984; c=relaxed/simple;
	bh=V6EBvgPkBCJj4gMf5RnwXrcs3ISikfnUiRSRzesNW3U=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=ZzF+Gj7Vh7fW/8uyrr+6s3QqI28+pPGfzP95Pcv72wMgr6TzPTpUpqk98WxZ2T7mVdD2Xza7vmKyVJB9/B7QEvZybXo1fyhbI8woeOtWXqY9+uqlg0ArAX8Z4AboWujOOwezXshd4DdL0TYjrapXANOwZXg3nGe+1YMZ5QGnpOA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=kFA+XhGT; arc=none smtp.client-ip=91.218.175.183
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="kFA+XhGT"
Message-ID: <d62b1b27-7a70-4d06-9191-a8d95104c2b7@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1780425971;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=FlAg+csNNDI+pLXHH0cpQXS1ilqz4znagmUSixnYiE4=;
	b=kFA+XhGTjmkHMETtRBBpUqn5/Lu4VBsrgMGd6adUpbJ+LBW2rRCMQynI3Z/cIS76au2UCj
	xoR+8y1AkY/2syut1/x1JQ5/egAn31QPd4HGgNRqQUryA9MG7kRoy+Iptc+j5+6FDnCM+y
	8/VHwuwMet9JVb1/enPJLELVAAYDr+E=
Date: Tue, 2 Jun 2026 11:46:03 -0700
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Subject: Re: [PATCH v2 3/4] crypto: ccp: Fix possible deadlock in SEV init
 failure path
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
 Atish Patra <atishp@meta.com>
References: <20260601-sev_snp_fixes-v2-0-611891b28a86@meta.com>
 <20260601-sev_snp_fixes-v2-3-611891b28a86@meta.com>
 <379e45d2-1765-4043-8ad0-ce013da8683f@amd.com>
Content-Language: en-US
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Atish Patra <atish.patra@linux.dev>
In-Reply-To: <379e45d2-1765-4043-8ad0-ce013da8683f@amd.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT


On 6/2/26 7:43 AM, Tom Lendacky wrote:
> On 6/1/26 18:04, Atish Patra wrote:
>> From: Atish Patra <atishp@meta.com>
>>
>> __sev_platform_init_handle_init_ex_path() called
> s/called/calls/
>
>> rmp_mark_pages_firmware() with locked=false but while the parent
> s/but//
>
>> function of init_ex_path already acquired the sev_cmd_mutex.
>> In case of a rmpupdate failure for any page after the first, the cleanup
> s/In case/In the case/
> s/a rmpupdate/an RMPUPDATE/
>
>> path would invoke reclaim pages which would result in a deadlock in
>> sev_do_cmd.
>>
>> Pass locked=true to honor the lock status of the parent function.
>>
>> Fixes: 7364a6fbca45 ("crypto: ccp: Handle non-volatile INIT_EX data when SNP is enabled")
>>
>> Reported-by: Chris Mason <clm@meta.com>
>> Assisted-by: Claude:claude-opus-4-6
>> Signed-off-by: Atish Patra <atishp@meta.com>
> Reviewed-by: Tom Lendacky <thomas.lendacky@amd.com>
>
Thanks for the review. Fixed the typos in the commit text.

>> ---
>>   drivers/crypto/ccp/sev-dev.c | 2 +-
>>   1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/drivers/crypto/ccp/sev-dev.c b/drivers/crypto/ccp/sev-dev.c
>> index d1e9e0ac63b6..3d4793e8e34b 100644
>> --- a/drivers/crypto/ccp/sev-dev.c
>> +++ b/drivers/crypto/ccp/sev-dev.c
>> @@ -1557,7 +1557,7 @@ static int __sev_platform_init_handle_init_ex_path(struct sev_device *sev)
>>   		unsigned long npages;
>>   
>>   		npages = 1UL << get_order(NV_LENGTH);
>> -		if (rmp_mark_pages_firmware(__pa(sev_init_ex_buffer), npages, false)) {
>> +		if (rmp_mark_pages_firmware(__pa(sev_init_ex_buffer), npages, true)) {
>>   			dev_err(sev->dev, "SEV: INIT_EX NV memory page state change failed.\n");
>>   			return -ENOMEM;
>>   		}
>>

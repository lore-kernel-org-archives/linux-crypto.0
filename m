Received: from mail-dy1-f171.google.com (mail-dy1-f171.google.com [74.125.82.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F0BCD3DBD59
	for <linux-crypto@vger.kernel.org>; Wed,  4 Mar 2026 19:54:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.82.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772654099; cv=none; b=KJBzD80oMsGZ7NYz2N9oNP4naaQkRLBgDNogt7NKOB/uOJaDULhLZSXVV2oZgNdCPCDONP8SRCGKoWN7PjOB8iKgidi7T9B1pbiVoeCd/fRlM7J/0yv3n/mz+ocrr2nFq2pStEuFuvzqwFzHw95Wzq//PkPPlcngvDd77V2mgsw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772654099; c=relaxed/simple;
	bh=FW3AWDEd8503Di4y1jMMTQnaxekzU10fNgaQHQOr4k4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=R2BeiKUzC60ulyV8Iq2RB9VmovNzxQneWyNOlq0yq0qDcW+dA8hVzRA+lLSwhb1EIW/gcXkz1R5S889vsa1Ux6kgOiZbJkpVc5EW/2BDNg7U8R6TJhCIPp1RI6EFik1Y3GDQotKqzDWLOr2HOjPoiM8SsoMKh11lK5hm339xGE8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=roeck-us.net; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=hH8K6tAF; arc=none smtp.client-ip=74.125.82.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=roeck-us.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="hH8K6tAF"
Received: by mail-dy1-f171.google.com with SMTP id 5a478bee46e88-2be1b5fe11cso3460642eec.0
        for <linux-crypto@vger.kernel.org>; Wed, 04 Mar 2026 11:54:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1772654096; x=1773258896; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:sender:from:to:cc:subject:date:message-id:reply-to;
        bh=ub1EQsKqnyQYPawp23MhhFXmeXeV1oEvsZyKiingcJU=;
        b=hH8K6tAFgmm3UMAEWV/hzHW7H/tgpJ5gcDFdbHFcr4Ti2Hp80Zy4sy+5HnT6A4oXRs
         Rq7Gl1hmGiIKAx4UHbMptA3HqcVu+EcSfNV+z8jHR51rzCRdPKnO1J/o9xQ83OrHIyIE
         dOCE9KQNljpa5CY/FtkhsRTcp3jgI0VBbtSUhlAuObq7f0wt5BPyGmxiLeSpcbsHq1x+
         JTTlU3etQUTvZT/9pFuVUwgY7rNXGAlvc8PCMx3ae0b+MQojQ8XXNvG/W/ZRtk7B9OYA
         g/TO7ioqms+daLXkQ/lioaCJs9YUFq00lTisOSnoIRef0ZaEYXEpZTerEBtSZBdJYbar
         /wtA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772654096; x=1773258896;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:sender:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ub1EQsKqnyQYPawp23MhhFXmeXeV1oEvsZyKiingcJU=;
        b=MqnpvssJnyLydkKKlBLe98d0FtbtwnQemvvwLZuevalxI/+aM59Ldzr7Ohmvk+Y54/
         IQfKLMoVdzQYflxhZoeZHn9R+Sylzc6llf2ExQnH49ql0hMVUx+ZZat4beP4tn9gigRg
         8XgatPSWGoIzvJB9oxty+LL7Ru6vcXRb36qPB8PLkwVy3ahV+QhIsEPJKv5wzuSPYcnf
         q52eJxGtN0uzWyuvgKUUga7mRei9Tx0WJ+ighzcFCML+bInX54uHlDqwFfMnV9fNyV6n
         OGXqaztMpqsTHM7Y1sEaR5zMkRgkHrHXqOceU3YH2Wh3XrOeemoV0ESrDOmSoG0TOWS/
         rppQ==
X-Forwarded-Encrypted: i=1; AJvYcCXnri8k6FMucwvena2t9EV4RrDA5W89Q+loMKo24FGo0OBbbnMAZ+KgZO5gjC7HNCjIe/y5GIIMO8p+EDA=@vger.kernel.org
X-Gm-Message-State: AOJu0YxzbU/t255KOzgTVXty9pAlfW7flgcYVACORcFHx0thRSc4XP2t
	sU8gUjh71bkSl5uM4r9PtbObi/l//9+3V/y1QITfUHKDXpZoxjTx6aPO
X-Gm-Gg: ATEYQzweZPXsul6GmgBT0v034JtQ25oDwcr5BObC7taN35t2MZ06Yq/jtjiC2VXTCIi
	vW9dAonZXfdCU+XbiNo4jXXR4f8495wmsIEcFD+kFq+MM9zdmTwfmO4F60qVrEbMc2blSBT2q9C
	K9USArao/05AL0C+xU+Cnv95y8FqPHp0SgKly4k7Ly9tNRUDctp9xOWRXBCRs3oNrvipkqgps6L
	RjGFK9XnSg/PEptEC6+66h2c7M/lXmJ4R+JZDWP2MdlrryROqIUDFWa0ymR3UnsC/gSYMHcNJq4
	7WzoFPISYzasLi4SYr1xdLWixTE4H7cRo55Rah/ZyDOJ46ztTH3z7fH+eeKw7SFKumDDuT8Z3UQ
	m6VvE54mm8bGdiHA9EXK2T06xIrzmg9ne8Djv5XKEY4XgbVoupT9m4qnq1mgdJvysY2oDBndNZc
	+X9DWCbzMsvodBURUJGIvNks3EsvL4bEebmhfINiR+WbhYNKzuzmiw5AlEfEHMOB+BJXPSliLB
X-Received: by 2002:a05:7300:72d5:b0:2b7:35c8:32cf with SMTP id 5a478bee46e88-2be311c3691mr1009829eec.28.1772654095841;
        Wed, 04 Mar 2026 11:54:55 -0800 (PST)
Received: from ?IPV6:2600:1700:e321:62f0:da43:aeff:fecc:bfd5? ([2600:1700:e321:62f0:da43:aeff:fecc:bfd5])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-2be1731b6b6sm7574366eec.5.2026.03.04.11.54.54
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 04 Mar 2026 11:54:54 -0800 (PST)
Sender: Guenter Roeck <groeck7@gmail.com>
Message-ID: <ffee3bb5-f47d-4b81-9242-f17cbed4029d@roeck-us.net>
Date: Wed, 4 Mar 2026 11:54:49 -0800
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/2] crypto: ccp - Fix a case where SNP_SHUTDOWN is missed
To: Tycho Andersen <tycho@kernel.org>
Cc: Ashish Kalra <ashish.kalra@amd.com>,
 Tom Lendacky <thomas.lendacky@amd.com>, John Allen <john.allen@amd.com>,
 Herbert Xu <herbert@gondor.apana.org.au>,
 "David S . Miller" <davem@davemloft.net>, linux-crypto@vger.kernel.org,
 linux-kernel@vger.kernel.org, Alexey Kardashevskiy <aik@amd.com>
References: <20260105172218.39993-1-tycho@kernel.org>
 <0182578a-424d-454f-8a38-57b885eb966b@roeck-us.net>
 <aahIz8bTPNpnaSZM@tycho.pizza>
Content-Language: en-US
From: Guenter Roeck <linux@roeck-us.net>
Autocrypt: addr=linux@roeck-us.net; keydata=
 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
 np3900V20aS7eD9K8GTU0TGC1pyz6IVJwIE=
In-Reply-To: <aahIz8bTPNpnaSZM@tycho.pizza>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 3/4/26 06:59, Tycho Andersen wrote:
> Hi Guenter,
> 
> On Tue, Mar 03, 2026 at 02:35:10PM -0800, Guenter Roeck wrote:
>> Hi,
>>
>> On Mon, Jan 05, 2026 at 10:22:17AM -0700, Tycho Andersen wrote:
>>> From: Tom Lendacky <thomas.lendacky@amd.com>
>>>
>>> If page reclaim fails in sev_ioctl_do_snp_platform_status() and SNP was
>>> moved from UNINIT to INIT for the function, SNP is not moved back to
>>> UNINIT state. Additionally, SNP is not required to be initialized in order
>>> to execute the SNP_PLATFORM_STATUS command, so don't attempt to move to
>>> INIT state and let SNP_PLATFORM_STATUS report the status as is.
>>>
>>> Fixes: ceac7fb89e8d ("crypto: ccp - Ensure implicit SEV/SNP init and shutdown in ioctls")
>>> Signed-off-by: Tom Lendacky <thomas.lendacky@amd.com>
>>> Reviewed-by: Tycho Andersen (AMD) <tycho@kernel.org>
>>> Reviewed-by: Alexey Kardashevskiy <aik@amd.com>
>>> Signed-off-by: Tycho Andersen (AMD) <tycho@kernel.org>
>>> ---
>>>   drivers/crypto/ccp/sev-dev.c | 46 ++++++++++++++++++------------------
>>>   1 file changed, 23 insertions(+), 23 deletions(-)
>>>
>>> -	if (snp_reclaim_pages(__pa(data), 1, true))
>>> -		return -EFAULT;
>>> +	if (sev->snp_initialized) {
>>> +		/*
>>> +		 * The status page will be in Reclaim state on success, or left
>>> +		 * in Firmware state on failure. Use snp_reclaim_pages() to
>>> +		 * transition either case back to Hypervisor-owned state.
>>> +		 */
>>> +		if (snp_reclaim_pages(__pa(data), 1, true)) {
>>> +			snp_leak_pages(__page_to_pfn(status_page), 1);
>>
>> This change got flagged by an experimental AI agent:
>>
>>    If `snp_reclaim_pages()` fails, it already internally calls
>>    `snp_leak_pages()`. Does calling `snp_leak_pages()` a second time
>>    on the exact same page corrupt the `snp_leaked_pages_list` because
>>    `list_add_tail(&page->buddy_list, &snp_leaked_pages_list)` is
>>    executed again?
>>
>> I don't claim to understand the code, but it does look like snp_leak_pages()
>> is indeed called twice on the same page, which does suggest that it is added
>> twice to the leaked pages list if it is not a compound page.
>>
>> Does this make sense, or is the AI missing something ?
> 
> Thanks for flagging this, I agree. I think we can drop that call:
> 
> diff --git a/drivers/crypto/ccp/sev-dev.c b/drivers/crypto/ccp/sev-dev.c
> index 096f993974d1..bd31ebfc85d5 100644
> --- a/drivers/crypto/ccp/sev-dev.c
> +++ b/drivers/crypto/ccp/sev-dev.c
> @@ -2410,10 +2410,8 @@ static int sev_ioctl_do_snp_platform_status(struct sev_issue_cmd *argp)
>   		 * in Firmware state on failure. Use snp_reclaim_pages() to
>   		 * transition either case back to Hypervisor-owned state.
>   		 */
> -		if (snp_reclaim_pages(__pa(data), 1, true)) {
> -			snp_leak_pages(__page_to_pfn(status_page), 1);
> +		if (snp_reclaim_pages(__pa(data), 1, true))
>   			return -EFAULT;
> -		}
>   	}
>   
>   	if (ret)
> 
> Double checking other uses of snp_reclaim_pages(), I don't think
> anyone else makes this mistake.
> 
> Do you want to send a patch? Otherwise, how do I credit via
> Reported-by:, to just you?
> 

I'll send it.

Thanks,
Guenter


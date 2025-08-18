Received: from mail-pg1-f201.google.com (mail-pg1-f201.google.com [209.85.215.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9EAEC25C6FF
	for <linux-crypto@vger.kernel.org>; Mon, 18 Aug 2025 21:14:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755551646; cv=none; b=rIhDQhXKw1FNT78Coeycj5yVGaygdcC78N/k25jQ7XRqstc2n5ZYxFBz24VDnjxPpWGAVh0haJoCa+kEtoXVMNT8wkmyLDzC8D0wlVO6K2x4FbK+YV55aKWERKYTfeVkDxsDZ2VkAbe9E5Vjw8C2qKVzqxJLy2pITjHfIJJ66S8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755551646; c=relaxed/simple;
	bh=oCjboA07oTOVMV8mvnKqalrMk0ZlXiVX81n3SQq4U/4=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=noRnqA/tjCSyNeXwFdPlKFwicGosUtiWJc3rPzXRrbHmWamqt+eyVzU6/vit/oiR2SfCbm1bcit1xzqMyz29zKmuO2gM3H+rEzH1eblvGxZeZygEqy5WPmNr+6JD6uoRHcc4Wy9DHDzMH2k65SQAxa7Lkp4vTQK18nB6/36tLMo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Ltf/m4WX; arc=none smtp.client-ip=209.85.215.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Ltf/m4WX"
Received: by mail-pg1-f201.google.com with SMTP id 41be03b00d2f7-b473910af91so2139238a12.1
        for <linux-crypto@vger.kernel.org>; Mon, 18 Aug 2025 14:14:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1755551644; x=1756156444; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=iWfaerBVilt6H0LpnTS/wyzJ0MBPeAowINZUiobUFXQ=;
        b=Ltf/m4WXd3X8/krm3L0yhLQbR4mbEugiVhyq//cgldnVhkZBX7QL8cZlyOALRxM0FR
         XrrluCS/8gfBOC3MfORVynVRAaiKukudWqSMBpHYj9bO13u7q9ZIgiOt8n2oWsYlyzf7
         Y9Eyj8+pqfzqmcCD2YGlXr1Uw8RiGmmgwqTWb00phoIp/y/b+e1dNoheo/GqXUGyMQZS
         yWeE5DV/B5+DK/fAkNxKvXakZFdOL2JHsi6lVaCNy4rnSJJqmsWm4yS9NVGxEr0DaJcU
         fDnlBDxsXVsnFlz/S/UZGIpPBX8UVxY7BP9AlrsIT0TEVNdsIv0QwZKwo+RcEJUElYaK
         z/0Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755551644; x=1756156444;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=iWfaerBVilt6H0LpnTS/wyzJ0MBPeAowINZUiobUFXQ=;
        b=Mve+vJHJRAa05cnCRW9hVf4gcY2gnCAudS1KnT0h6lqAUaJtJHIB2ZcCHHCo50vBPS
         cJGoP17TTVfTGoFhmxsuYym+eGru/3xbdP3U+fNiNMfwyCLRhBur4IahnDLKY0g7594Y
         NTCdOPElsSJXIYdKTEzNQwiw0S+neovhM7wwsrl6DhjCiHFhiPv6gZUfexufmGn6hU92
         ZUCCLwousnzQs31wyDJgGrNPtS98l4hKvzO1hLqZoYmc1R3Iw5nDI+yOK6y3LMDGTM6g
         PEptx1vPm3pcp9/kia61/q4fmZNTz9J7IztIUG5cGkrI2e6XtbysJJ/G0TqTjuLDEKnb
         E1Gw==
X-Forwarded-Encrypted: i=1; AJvYcCXkapPcuTjno2Cr6ksbTzxngIurGHnQ5IF4M4e/mKNa0vPaLJ//tdIIyhNXMTXJzYx5fPmkudkWDA2dLPI=@vger.kernel.org
X-Gm-Message-State: AOJu0Yz3WwQQvSUGbRjKOlEsotmR2iJTWkXVxZRDBOK7WpD9wgPXaE+E
	qhHjqNfLJ6ypcoz4RKarZCxqwVqRaAGuynHZoUO246UhfNJWBhhKpKP/t0mOexL82EzljnlFfqF
	v9ktJgQ==
X-Google-Smtp-Source: AGHT+IGow9wuGQLBi70C1lZydDC+t2IRRyfOwf+N82YpONBCzuLAXRoJqSyqXbfSnuUOg1FQDwQUqWlHeRA=
X-Received: from pjwx5.prod.google.com ([2002:a17:90a:c2c5:b0:2fb:fa85:1678])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:902:dacd:b0:240:3f43:260
 with SMTP id d9443c01a7336-2449c9be0a4mr14536765ad.17.1755551643920; Mon, 18
 Aug 2025 14:14:03 -0700 (PDT)
Date: Mon, 18 Aug 2025 14:14:02 -0700
In-Reply-To: <7f7cdb3268e95b7dfa924c3da16a201da0b095f3.1755548015.git.ashish.kalra@amd.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <cover.1755548015.git.ashish.kalra@amd.com> <7f7cdb3268e95b7dfa924c3da16a201da0b095f3.1755548015.git.ashish.kalra@amd.com>
Message-ID: <aKOXmlCkk900zyVY@google.com>
Subject: Re: [RESEND PATCH v2 1/3] x86/sev: Add new quiet parameter to
 snp_leak_pages() API
From: Sean Christopherson <seanjc@google.com>
To: Ashish Kalra <Ashish.Kalra@amd.com>
Cc: tglx@linutronix.de, mingo@redhat.com, bp@alien8.de, 
	dave.hansen@linux.intel.com, x86@kernel.org, hpa@zytor.com, 
	pbonzini@redhat.com, thomas.lendacky@amd.com, herbert@gondor.apana.org.au, 
	nikunj@amd.com, davem@davemloft.net, aik@amd.com, ardb@kernel.org, 
	michael.roth@amd.com, Neeraj.Upadhyay@amd.com, linux-kernel@vger.kernel.org, 
	kvm@vger.kernel.org, linux-crypto@vger.kernel.org
Content-Type: text/plain; charset="us-ascii"

On Mon, Aug 18, 2025, Ashish Kalra wrote:
> diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
> index 2fbdebf79fbb..a7db96a5f56d 100644
> --- a/arch/x86/kvm/svm/sev.c
> +++ b/arch/x86/kvm/svm/sev.c
> @@ -271,7 +271,7 @@ static void sev_decommission(unsigned int handle)
>  static int kvm_rmp_make_shared(struct kvm *kvm, u64 pfn, enum pg_level level)
>  {
>  	if (KVM_BUG_ON(rmp_make_shared(pfn, level), kvm)) {
> -		snp_leak_pages(pfn, page_level_size(level) >> PAGE_SHIFT);
> +		snp_leak_pages(pfn, page_level_size(level) >> PAGE_SHIFT, false);
>  		return -EIO;
>  	}
>  
> @@ -300,7 +300,7 @@ static int snp_page_reclaim(struct kvm *kvm, u64 pfn)
>  	data.paddr = __sme_set(pfn << PAGE_SHIFT);
>  	rc = sev_do_cmd(SEV_CMD_SNP_PAGE_RECLAIM, &data, &fw_err);
>  	if (KVM_BUG(rc, kvm, "Failed to reclaim PFN %llx, rc %d fw_err %d", pfn, rc, fw_err)) {
> -		snp_leak_pages(pfn, 1);
> +		snp_leak_pages(pfn, 1, false);

Open coded true/false literals are ugly, e.g. now I have to go look at the
declaration (or even definition) of snp_leak_pages() to understand what %false
controls.

Assuming "don't dump the RMP entry" is the rare case, then craft the APIs to
reflect that, i.e. make snp_leak_pages() a wrapper for the common case.  As a
bonus, you don't need to churn any extra code either.

void __snp_leak_pages(u64 pfn, unsigned int npages, bool dump_rmp);

static inline void snp_leak_pages(u64 pfn, unsigned int npages)
{
	__snp_leak_pages(pfn, npages, true);
}

>  		return -EIO;
>  	}
>  
> diff --git a/arch/x86/virt/svm/sev.c b/arch/x86/virt/svm/sev.c
> index 942372e69b4d..d75659859a07 100644
> --- a/arch/x86/virt/svm/sev.c
> +++ b/arch/x86/virt/svm/sev.c
> @@ -1029,7 +1029,7 @@ int rmp_make_shared(u64 pfn, enum pg_level level)
>  }
>  EXPORT_SYMBOL_GPL(rmp_make_shared);
>  
> -void snp_leak_pages(u64 pfn, unsigned int npages)
> +void snp_leak_pages(u64 pfn, unsigned int npages, bool quiet)
>  {
>  	struct page *page = pfn_to_page(pfn);
>  
> @@ -1052,7 +1052,8 @@ void snp_leak_pages(u64 pfn, unsigned int npages)
>  		    (PageHead(page) && compound_nr(page) <= npages))
>  			list_add_tail(&page->buddy_list, &snp_leaked_pages_list);
>  
> -		dump_rmpentry(pfn);
> +		if (!quiet)

The polarity is arbitrarily odd, and "quiet" is annoyingly ambiguous and arguably
misleading, e.g. one could expect "quiet=true" to suppress the pr_warn() too, but
it does not.

	pr_warn("Leaking PFN range 0x%llx-0x%llx\n", pfn, pfn + npages)

If you call it "bool dump_rmp" then it's more precise, self-explanatory, and
doesn't need to be inverted.

> +			dump_rmpentry(pfn);
>  		snp_nr_leaked_pages++;
>  		pfn++;
>  		page++;
> diff --git a/drivers/crypto/ccp/sev-dev.c b/drivers/crypto/ccp/sev-dev.c
> index 4f000dc2e639..203a43a2df63 100644
> --- a/drivers/crypto/ccp/sev-dev.c
> +++ b/drivers/crypto/ccp/sev-dev.c
> @@ -408,7 +408,7 @@ static int snp_reclaim_pages(unsigned long paddr, unsigned int npages, bool lock
>  	 * If there was a failure reclaiming the page then it is no longer safe
>  	 * to release it back to the system; leak it instead.
>  	 */
> -	snp_leak_pages(__phys_to_pfn(paddr), npages - i);
> +	snp_leak_pages(__phys_to_pfn(paddr), npages - i, false);
>  	return ret;
>  }
>  
> -- 
> 2.34.1
> 

Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 702D043AC2
	for <linux-crypto@vger.kernel.org>; Sat, 30 Mar 2024 20:51:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711831919; cv=none; b=QvP1KoCmsEXMmeZZIhpmMTElUYax6EoJQ+F2Uhsxj9ljRXP7pzNxhb6mLTcDuETrrvnnGEzyIZHbNozsBB4BMTtIg8aWLRIdgpw8NFx5vq09e3iVIn1VgKdka1GZjyvUgkNGgpRIGLwl1j5aiQ8aXFu4hiSkraJi51Zc03ImDQI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711831919; c=relaxed/simple;
	bh=eo76hJ5KgggZKPYnrOo0bwJDa2FPFvtChdiC2X3NlIs=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=HbgYj3HiCALVgvSPHXUoo2wNoIFWqkWJJQxLY0T0G1ZA9sd7yze3ssYJSsZN9wXf/tU6chAsoRqD87LY/3KUfYt6AGJWTF1ahuLqiiqyNGE9vQ1QwEUzxBHLT4PTKzYwNKI/V8fOti5pFCqKrlPH+YfwDKd1n39u9/5QPyummIE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=GDsB8mzR; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="GDsB8mzR"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1711831915;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=OZ3Ciau6EpVtoog0PBxIAt4mBisJnFBL8QU+3ujOsIY=;
	b=GDsB8mzRt7qplwK+Erlu4RM+kimSVlIpS3t4yaOmtdgU4TlUcUlBVqLtSKTXzyy8YzgiuI
	jHof/6AdAPyYzzjJ5ou5lfvYP6LmzPwVi0slsISSz4rqk0pFrzSuhSuUWdlXKPbaGAzine
	EWuuJfMOecAZiQLlhh/L5Jwfrz7F+Y8=
Received: from mail-ej1-f72.google.com (mail-ej1-f72.google.com
 [209.85.218.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-376-8O2xzqRVNUazlido7ma5Rg-1; Sat, 30 Mar 2024 16:51:53 -0400
X-MC-Unique: 8O2xzqRVNUazlido7ma5Rg-1
Received: by mail-ej1-f72.google.com with SMTP id a640c23a62f3a-a46852c2239so192215966b.1
        for <linux-crypto@vger.kernel.org>; Sat, 30 Mar 2024 13:51:53 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1711831912; x=1712436712;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=OZ3Ciau6EpVtoog0PBxIAt4mBisJnFBL8QU+3ujOsIY=;
        b=fjZJTtAM9/ZF93lyx6OLDdgC3JD3cIYYt4r3gdVwSdceM63ZBDtP7rrIjtDoKpE2AS
         B3VYV3UUc7p8lFbqZIP8D0Hqrk6WZ+7XJP2uIyHI7OWYwRiEl9w/ao3gKbPQX2ygToMP
         WBFSlwzz/C39Eg4gTH+Ohg6nmW2v2CiQxCUrCKtsnbym0bIPL0C1jBZ8yyR8Nk2x5DAl
         1fEkmqV6oWv7qh2lse+Pjcfv3Aicm7LZ448AH8/VeV9G6UD6UKKANAo6TxnzXyO2LF/c
         10RpPBga59nojouQic0lMh4ZGqgDOIwSuTkhQRIfzis9kEcJqOgtjP1H5Tz+yfevNEN3
         XXAw==
X-Forwarded-Encrypted: i=1; AJvYcCWo09xTT88fofDy/N7GPWRuxsTHd8E20d1wyK05gTbl37Uq6s2ecmHnmNAqpeq81ztqHB9M90NZHTYaq/DuqGUDcW6+268xIcS8uW+9
X-Gm-Message-State: AOJu0YxQhCVbpA8ZY181Pp3A2+GXyKZhwHQlToIPwPYhpSgNts/1y/AA
	qAREUvrSptTvFdCNgwNj+zw+iqMPii1iTYxLyc9KQXmXBRJOP1Xg25ZOq1ZDg/nZuI1oQyto023
	ASsdmHZQqlKmH11o72B+NNvE2sQ51WInGvoa0mJYGjw67X2tHE693bLlO1Jctjg==
X-Received: by 2002:a17:906:1253:b0:a4d:ff5f:98ad with SMTP id u19-20020a170906125300b00a4dff5f98admr3545173eja.37.1711831912737;
        Sat, 30 Mar 2024 13:51:52 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IE01IT9TeNxfmx0zF5Xk6kwBCeppMFBPly3IZPz1shqv6ixk8RRaNFkk5C/OVE5TsIYrwjytA==
X-Received: by 2002:a17:906:1253:b0:a4d:ff5f:98ad with SMTP id u19-20020a170906125300b00a4dff5f98admr3545135eja.37.1711831912424;
        Sat, 30 Mar 2024 13:51:52 -0700 (PDT)
Received: from [192.168.10.4] ([151.95.49.219])
        by smtp.googlemail.com with ESMTPSA id z3-20020a170906714300b00a4650ec48d0sm3489665ejj.140.2024.03.30.13.51.49
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 30 Mar 2024 13:51:51 -0700 (PDT)
Message-ID: <30c5f2f3-ff1e-4b0d-bb1f-eba95f578376@redhat.com>
Date: Sat, 30 Mar 2024 21:51:49 +0100
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v12 16/29] KVM: x86: Export the kvm_zap_gfn_range() for
 the SNP use
To: Michael Roth <michael.roth@amd.com>, kvm@vger.kernel.org
Cc: linux-coco@lists.linux.dev, linux-mm@kvack.org,
 linux-crypto@vger.kernel.org, x86@kernel.org, linux-kernel@vger.kernel.org,
 tglx@linutronix.de, mingo@redhat.com, jroedel@suse.de,
 thomas.lendacky@amd.com, hpa@zytor.com, ardb@kernel.org, seanjc@google.com,
 vkuznets@redhat.com, jmattson@google.com, luto@kernel.org,
 dave.hansen@linux.intel.com, slp@redhat.com, pgonda@google.com,
 peterz@infradead.org, srinivas.pandruvada@linux.intel.com,
 rientjes@google.com, dovmurik@linux.ibm.com, tobin@ibm.com, bp@alien8.de,
 vbabka@suse.cz, kirill@shutemov.name, ak@linux.intel.com,
 tony.luck@intel.com, sathyanarayanan.kuppuswamy@linux.intel.com,
 alpergun@google.com, jarkko@kernel.org, ashish.kalra@amd.com,
 nikunj.dadhania@amd.com, pankaj.gupta@amd.com, liam.merwick@oracle.com,
 Brijesh Singh <brijesh.singh@amd.com>
References: <20240329225835.400662-1-michael.roth@amd.com>
 <20240329225835.400662-17-michael.roth@amd.com>
From: Paolo Bonzini <pbonzini@redhat.com>
Content-Language: en-US
Autocrypt: addr=pbonzini@redhat.com; keydata=
 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
In-Reply-To: <20240329225835.400662-17-michael.roth@amd.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 3/29/24 23:58, Michael Roth wrote:
> From: Brijesh Singh <brijesh.singh@amd.com>
> 
> While resolving the RMP page fault, there may be cases where the page
> level between the RMP entry and TDP does not match and the 2M RMP entry
> must be split into 4K RMP entries. Or a 2M TDP page need to be broken
> into multiple of 4K pages.
> 
> To keep the RMP and TDP page level in sync, zap the gfn range after
> splitting the pages in the RMP entry. The zap should force the TDP to
> gets rebuilt with the new page level.

Just squash this in patch 17.

Paolo

> Signed-off-by: Brijesh Singh <brijesh.singh@amd.com>
> Signed-off-by: Ashish Kalra <ashish.kalra@amd.com>
> Signed-off-by: Michael Roth <michael.roth@amd.com>
> ---
>   arch/x86/include/asm/kvm_host.h | 1 +
>   arch/x86/kvm/mmu.h              | 2 --
>   arch/x86/kvm/mmu/mmu.c          | 1 +
>   3 files changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> index a3f8eba8d8b6..49b294a8d917 100644
> --- a/arch/x86/include/asm/kvm_host.h
> +++ b/arch/x86/include/asm/kvm_host.h
> @@ -1950,6 +1950,7 @@ void kvm_mmu_slot_leaf_clear_dirty(struct kvm *kvm,
>   				   const struct kvm_memory_slot *memslot);
>   void kvm_mmu_invalidate_mmio_sptes(struct kvm *kvm, u64 gen);
>   void kvm_mmu_change_mmu_pages(struct kvm *kvm, unsigned long kvm_nr_mmu_pages);
> +void kvm_zap_gfn_range(struct kvm *kvm, gfn_t gfn_start, gfn_t gfn_end);
>   
>   int load_pdptrs(struct kvm_vcpu *vcpu, unsigned long cr3);
>   
> diff --git a/arch/x86/kvm/mmu.h b/arch/x86/kvm/mmu.h
> index 2c54ba5b0a28..89da37be241a 100644
> --- a/arch/x86/kvm/mmu.h
> +++ b/arch/x86/kvm/mmu.h
> @@ -253,8 +253,6 @@ static inline bool kvm_mmu_honors_guest_mtrrs(struct kvm *kvm)
>   	return __kvm_mmu_honors_guest_mtrrs(kvm_arch_has_noncoherent_dma(kvm));
>   }
>   
> -void kvm_zap_gfn_range(struct kvm *kvm, gfn_t gfn_start, gfn_t gfn_end);
> -
>   int kvm_arch_write_log_dirty(struct kvm_vcpu *vcpu);
>   
>   int kvm_mmu_post_init_vm(struct kvm *kvm);
> diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> index 0049d49aa913..c5af52e3f0c5 100644
> --- a/arch/x86/kvm/mmu/mmu.c
> +++ b/arch/x86/kvm/mmu/mmu.c
> @@ -6772,6 +6772,7 @@ static bool kvm_mmu_zap_collapsible_spte(struct kvm *kvm,
>   
>   	return need_tlb_flush;
>   }
> +EXPORT_SYMBOL_GPL(kvm_zap_gfn_range);
>   
>   static void kvm_rmap_zap_collapsible_sptes(struct kvm *kvm,
>   					   const struct kvm_memory_slot *slot)


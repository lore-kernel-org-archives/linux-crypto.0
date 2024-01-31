Received: from mail-pl1-f201.google.com (mail-pl1-f201.google.com [209.85.214.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 42AF24C98
	for <linux-crypto@vger.kernel.org>; Wed, 31 Jan 2024 01:13:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706663584; cv=none; b=SwuTJnxIUpjByqe+KBIFuav90N83dIQALJVXhWbWn4O9303Hjh7BBVU0MsjLfw1FDWIwOkH3680moD9WMWxV3K3H/iDjiiir0Oa2Ivnan/xbADG/1iXJ/ixG+07mTY3i8wNe3SsTxYylzHlFCC+4XbBiQ6ZyarWpx61vAgKMb9U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706663584; c=relaxed/simple;
	bh=WnaiMYjG3HYrBPVosKeochjRi58QHb85b9Uafy87v5A=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=XwQGKRk8sjpE1P6np5WqkLqmgf5IxU4kIUkQ1m/erTPQrd0/EWB9SPYhH6KYidX2KihHyPlrmK8F8hj+z9mKnZzAsHG94IQtezegteoeDPLArv3weDAUAaUjw9YMEHC1A2Xv4JKlbXStwRHb07UUFvdeKYeBbX1ZIgi5eUslv2o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=w9IQLSNZ; arc=none smtp.client-ip=209.85.214.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="w9IQLSNZ"
Received: by mail-pl1-f201.google.com with SMTP id d9443c01a7336-1d72c4b8165so25198185ad.3
        for <linux-crypto@vger.kernel.org>; Tue, 30 Jan 2024 17:13:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1706663582; x=1707268382; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=/GoosJvXV4tQVgQnoX094ue9LgaeDV/puMZ+zgV5v8A=;
        b=w9IQLSNZ4uiLohicHi+6G4ZMJRs0oUrtBRqKLSOvirKyQrWa1O/qJwki5kVmpdZUx3
         IpKJ4/Q6lzxOqvq+nzIOc64XbTDVm5OnVcguzGFi4NlitC2y4KwWXcGKJZHfHjeWTbpc
         Nqc5QsHw1b4PeF0Jqt2N5f0pgo9UHiHsbXI6wiwqGaevp5KffFT1lNyFTEchXuLFnmwy
         8aeYQITF4QJdmpaKl8yABpwEesen6QirhP2R5sWTUkaY7VuuYZpwS4VR8k2F/w6BascW
         TIj9TXanfw+TjmKBdug0CmE/Jm2wfYbveeQ59wYGdBLLdJZWqwhMyrLj+atS2x+AgBwu
         5s7Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1706663582; x=1707268382;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=/GoosJvXV4tQVgQnoX094ue9LgaeDV/puMZ+zgV5v8A=;
        b=ClfFSbPgyzqc/0weBueGPjvSGTz5kjf3pZHp1wehZW8/mcMmbSdKmlT9QSJosL8F4S
         I7mjUFdR7MbvYauQ0S9NKzB1wgYZf/1d/hv4PUNtHQ2Ht9LS5MiD05NLG/R0f7T3eCYE
         1GxYSnXyhxJpIWzmSUMIXU7vSo0yxiz4QsFeTdU7jXPomCQnmSWYu5DQLVj1uF1HOLub
         DUjS8+kGbOuPLoBpbBpmkNxRzgRMJfi/VW+hqYuJWJXngCTNoblpG5IFaEwe1gEY9DLH
         iE1Ib5JcGllblRctYlFpxHyTkQKct0ny8KsNc0ji6BWucN851EuZ474IKwiE1alCoLyd
         VT8A==
X-Gm-Message-State: AOJu0YzAam9T1oUtyHbVnCXZ8JDBlPdKGXFjk29nO+PRYLD030E9uh5Z
	3Uf7DubWebVPDBSIG32s9T1FABuc/nAUJ3ZWBbzo8V4w7+ixQIMfZGegn9Td9jQzZSjoAL7z2ee
	G4g==
X-Google-Smtp-Source: AGHT+IHXA4t0uhZ7tzthJIqQkUlU7edO5hP5ya6T+NaNmVk8RFxp+26SnKPKNqGEdvTVdg4s3sxwKV4qvvQ=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:902:d212:b0:1d9:1e1:76ca with SMTP id
 t18-20020a170902d21200b001d901e176camr715ply.10.1706663582547; Tue, 30 Jan
 2024 17:13:02 -0800 (PST)
Date: Tue, 30 Jan 2024 17:13:00 -0800
In-Reply-To: <20231016115028.996656-9-michael.roth@amd.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20231016115028.996656-1-michael.roth@amd.com> <20231016115028.996656-9-michael.roth@amd.com>
Message-ID: <ZbmenP05fo8hZU8N@google.com>
Subject: Re: [PATCH RFC gmem v1 8/8] KVM: x86: Determine shared/private faults
 based on vm_type
From: Sean Christopherson <seanjc@google.com>
To: Michael Roth <michael.roth@amd.com>
Cc: kvm@vger.kernel.org, linux-coco@lists.linux.dev, linux-mm@kvack.org, 
	linux-crypto@vger.kernel.org, x86@kernel.org, linux-kernel@vger.kernel.org, 
	linux-fsdevel@vger.kernel.org, pbonzini@redhat.com, isaku.yamahata@intel.com, 
	ackerleytng@google.com, vbabka@suse.cz, ashish.kalra@amd.com, 
	nikunj.dadhania@amd.com, jroedel@suse.de, pankaj.gupta@amd.com
Content-Type: text/plain; charset="us-ascii"

On Mon, Oct 16, 2023, Michael Roth wrote:
> For KVM_X86_SNP_VM, only the PFERR_GUEST_ENC_MASK flag is needed to
> determine with an #NPF is due to a private/shared access by the guest.
> Implement that handling here. Also add handling needed to deal with
> SNP guests which in some cases will make MMIO accesses with the
> encryption bit.

...

> @@ -4356,12 +4357,19 @@ static int __kvm_faultin_pfn(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault
>  			return RET_PF_EMULATE;
>  	}
>  
> -	if (fault->is_private != kvm_mem_is_private(vcpu->kvm, fault->gfn)) {
> +	/*
> +	 * In some cases SNP guests will make MMIO accesses with the encryption
> +	 * bit set. Handle these via the normal MMIO fault path.
> +	 */
> +	if (!slot && private_fault && kvm_is_vm_type(vcpu->kvm, KVM_X86_SNP_VM))
> +		private_fault = false;

Why?  This is inarguably a guest bug.

> +	if (private_fault != kvm_mem_is_private(vcpu->kvm, fault->gfn)) {
>  		kvm_mmu_prepare_memory_fault_exit(vcpu, fault);
>  		return -EFAULT;
>  	}
>  
> -	if (fault->is_private)
> +	if (private_fault)
>  		return kvm_faultin_pfn_private(vcpu, fault);
>  
>  	async = false;
> diff --git a/arch/x86/kvm/mmu/mmu_internal.h b/arch/x86/kvm/mmu/mmu_internal.h
> index 759c8b718201..e5b973051ad9 100644
> --- a/arch/x86/kvm/mmu/mmu_internal.h
> +++ b/arch/x86/kvm/mmu/mmu_internal.h
> @@ -251,6 +251,24 @@ struct kvm_page_fault {
>  
>  int kvm_tdp_page_fault(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault);
>  
> +static bool kvm_mmu_fault_is_private(struct kvm *kvm, gpa_t gpa, u64 err)
> +{
> +	bool private_fault = false;
> +
> +	if (kvm_is_vm_type(kvm, KVM_X86_SNP_VM)) {
> +		private_fault = !!(err & PFERR_GUEST_ENC_MASK);
> +	} else if (kvm_is_vm_type(kvm, KVM_X86_SW_PROTECTED_VM)) {
> +		/*
> +		 * This handling is for gmem self-tests and guests that treat
> +		 * userspace as the authority on whether a fault should be
> +		 * private or not.
> +		 */
> +		private_fault = kvm_mem_is_private(kvm, gpa >> PAGE_SHIFT);
> +	}

This can be more simply:

	if (kvm_is_vm_type(kvm, KVM_X86_SNP_VM))
		return !!(err & PFERR_GUEST_ENC_MASK);

	if (kvm_is_vm_type(kvm, KVM_X86_SW_PROTECTED_VM))
		return kvm_mem_is_private(kvm, gpa >> PAGE_SHIFT);

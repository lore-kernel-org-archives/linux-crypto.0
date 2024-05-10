Received: from mail-yb1-f201.google.com (mail-yb1-f201.google.com [209.85.219.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B38BB12C498
	for <linux-crypto@vger.kernel.org>; Fri, 10 May 2024 13:47:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715348861; cv=none; b=UXPvIqMYAme223kmgCpol4oy6iFgrZdlhi6vkKuWvOgEaC4RGmMLL7if3hE539WXXuvLeqkCRXkkuBct0SNR5frWhduGEk0vOOCzKf8AAgmN4zcTdTk1lUPWyF4CL5BIYJpQcFY9CgTyk7aO+zvpOYB9ZFXoHqO8hjf/hlz7Ldk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715348861; c=relaxed/simple;
	bh=VjLQ4LMP6CaVwr23Yos/UzvuYuiA7pp7/SnwDdrkvJw=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=MZ8UiC7ZeN3I7Y2TL5h90A+0LO1VA/20UlKaikQU3JelUn2Ab+MyiVAiKMTNvKthdw167psZU3LntTOpUgde+dipDLL4ql9ntjywlD1cD7+SBNroUGlXkR+G6CIboE7YTDKD1adBVerZ6ohs3ojrQRf7+vpWf2ZHumdaojLXA18=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=ve9nOPWN; arc=none smtp.client-ip=209.85.219.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="ve9nOPWN"
Received: by mail-yb1-f201.google.com with SMTP id 3f1490d57ef6-de5a8638579so3421274276.1
        for <linux-crypto@vger.kernel.org>; Fri, 10 May 2024 06:47:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1715348859; x=1715953659; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=s0BQ7TnRKjFMrxEq7NT+cPq9l36GVpbuuSkGmH4Esl8=;
        b=ve9nOPWNL1J2A4ZTdE8wdGaf+/rf0mzYixFshAOFT3Woil0nx0U17FO/xzha4VMsW0
         Rit4TuPU4iJ/qzbbrDRupau/sc7po2tU1djYGLFu2X4yG6cZT+Q/jfVqxXMF22qtp4IY
         bLkHtp/u4oLw+rEW29IGUnLZ2iXB8Cs52/ULIDjqvRhMt1cceAaSo3tpuZ7g1s1C06iT
         9sDuWocueyrS5QCRyTWwzD5ezPIDW1xs/GAM5x2YG9UEpimn2ujbM/qyIij9uDewJlQK
         bxggeAaCB3aqqXSnKkDuFEAR8kxVs9LnanMwaQLVrgiAYayxcCf8sQJKuNvjbtzwOvel
         /wIw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1715348859; x=1715953659;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=s0BQ7TnRKjFMrxEq7NT+cPq9l36GVpbuuSkGmH4Esl8=;
        b=biJqafd0sbJYMkpiCHTo3fyjUHQjiWj5YqS4BSNfqTe/yTGCqlYIbaAnQ5jbKnXy5M
         5XW6mOFu7RtGWcvDuCfQ9XVbND7nlP7oiCgkS/k19xoax0j274G18+CfqGBIDau6GH8h
         mecpDXZbFqQTGj8eN0rCRZ2+01E3K0BbwoxbVIkQnA2yN3szrbpdKnmO+qPGeHxcot44
         nuZt41UFNilN1ZClHfykR/LDve/ZPA2AsGSJJMqj2lo5MWS9sD4w+6hCiaW8lEaz7iOc
         pjSXNnh4ec1jx+LIRs2MaMIwX5v2M76qIggZJzJKdPri/jf/2pBX28GDvq/W8LlS01c4
         RwqA==
X-Forwarded-Encrypted: i=1; AJvYcCUSIsRH1rfXdexfUpP7wH1w8hSeINVsrLjCjlrcM2g1gGY1oE858MAGKKz3aaqpGgXbiap89tXgODYGlUZwT58Pd4yEWe8yrXHXTadE
X-Gm-Message-State: AOJu0YyhcDy/DjEhoxH3gluMwA3hw91LqnNM+mJuLdDmm1q9xTWCjCpy
	PrNpK5Le7harnNign6dX6MSwhoMZDfR7A9HfDdqSY45DQQUMKtgvFD5/DUTzeSYpDp02A649OvK
	3Lw==
X-Google-Smtp-Source: AGHT+IGeFXcvsiksARA9h1b7EfkKsK64PaIzGQcHXGZ3C4+3t16ZKMcUaQTapjqXNiSAJUTt6kTNKMrdw7g=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6902:2b85:b0:de5:2ce1:b638 with SMTP id
 3f1490d57ef6-dee4f0719dfmr158392276.0.1715348858717; Fri, 10 May 2024
 06:47:38 -0700 (PDT)
Date: Fri, 10 May 2024 06:47:37 -0700
In-Reply-To: <20240510015822.503071-1-michael.roth@amd.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240501085210.2213060-1-michael.roth@amd.com> <20240510015822.503071-1-michael.roth@amd.com>
Message-ID: <Zj4lebCMsRvGn7ws@google.com>
Subject: Re: [PATCH v15 21/23] KVM: MMU: Disable fast path for private memslots
From: Sean Christopherson <seanjc@google.com>
To: Michael Roth <michael.roth@amd.com>
Cc: kvm@vger.kernel.org, linux-coco@lists.linux.dev, linux-mm@kvack.org, 
	linux-crypto@vger.kernel.org, x86@kernel.org, linux-kernel@vger.kernel.org, 
	tglx@linutronix.de, mingo@redhat.com, jroedel@suse.de, 
	thomas.lendacky@amd.com, hpa@zytor.com, ardb@kernel.org, pbonzini@redhat.com, 
	vkuznets@redhat.com, jmattson@google.com, luto@kernel.org, 
	dave.hansen@linux.intel.com, slp@redhat.com, pgonda@google.com, 
	peterz@infradead.org, srinivas.pandruvada@linux.intel.com, 
	rientjes@google.com, dovmurik@linux.ibm.com, tobin@ibm.com, bp@alien8.de, 
	vbabka@suse.cz, kirill@shutemov.name, ak@linux.intel.com, tony.luck@intel.com, 
	sathyanarayanan.kuppuswamy@linux.intel.com, alpergun@google.com, 
	jarkko@kernel.org, ashish.kalra@amd.com, nikunj.dadhania@amd.com, 
	pankaj.gupta@amd.com, liam.merwick@oracle.com, papaluri@amd.com, 
	Isaku Yamahata <isaku.yamahata@intel.com>
Content-Type: text/plain; charset="us-ascii"

On Thu, May 09, 2024, Michael Roth wrote:
> ---
>  arch/x86/kvm/mmu/mmu.c | 30 ++++++++++++++++++++++++++++--
>  1 file changed, 28 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> index 62ad38b2a8c9..cecd8360378f 100644
> --- a/arch/x86/kvm/mmu/mmu.c
> +++ b/arch/x86/kvm/mmu/mmu.c
> @@ -3296,7 +3296,7 @@ static int kvm_handle_noslot_fault(struct kvm_vcpu *vcpu,
>  	return RET_PF_CONTINUE;
>  }
>  
> -static bool page_fault_can_be_fast(struct kvm_page_fault *fault)
> +static bool page_fault_can_be_fast(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault)
>  {
>  	/*
>  	 * Page faults with reserved bits set, i.e. faults on MMIO SPTEs, only
> @@ -3307,6 +3307,32 @@ static bool page_fault_can_be_fast(struct kvm_page_fault *fault)
>  	if (fault->rsvd)
>  		return false;
>  
> +	/*
> +	 * For hardware-protected VMs, certain conditions like attempting to
> +	 * perform a write to a page which is not in the state that the guest
> +	 * expects it to be in can result in a nested/extended #PF. In this
> +	 * case, the below code might misconstrue this situation as being the
> +	 * result of a write-protected access, and treat it as a spurious case
> +	 * rather than taking any action to satisfy the real source of the #PF
> +	 * such as generating a KVM_EXIT_MEMORY_FAULT. This can lead to the
> +	 * guest spinning on a #PF indefinitely.
> +	 *
> +	 * For now, just skip the fast path for hardware-protected VMs since
> +	 * they don't currently utilize any of this machinery anyway. In the
> +	 * future, these considerations will need to be taken into account if
> +	 * there's any need/desire to re-enable the fast path for
> +	 * hardware-protected VMs.
> +	 *
> +	 * Since software-protected VMs don't have a notion of a shared vs.
> +	 * private that's separate from what KVM is tracking, the above
> +	 * KVM_EXIT_MEMORY_FAULT condition wouldn't occur, so avoid the
> +	 * special handling for that case for now.

Very technically, it can occur if userspace _just_ modified the attributes.  And
as I've said multiple times, at least for now, I want to avoid special casing
SW-protected VMs unless it is *absolutely* necessary, because their sole purpose
is to allow testing flows that are impossible to excercise without SNP/TDX hardware.

> +	 */
> +	if (kvm_slot_can_be_private(fault->slot) &&
> +	    !(IS_ENABLED(CONFIG_KVM_SW_PROTECTED_VM) &&
> +	      vcpu->kvm->arch.vm_type == KVM_X86_SW_PROTECTED_VM))

Heh, !(x && y) kills me, I misread this like 4 times.

Anyways, I don't like the heuristic.  It doesn't tie the restriction back to the
cause in any reasonable way.  Can't this simply be?

	if (fault->is_private != kvm_mem_is_private(vcpu->kvm, fault->gfn)
		return false;

Which is much, much more self-explanatory.

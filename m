Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.7 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 69D88C433EF
	for <linux-crypto@archiver.kernel.org>; Thu, 23 Sep 2021 18:39:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4164661242
	for <linux-crypto@archiver.kernel.org>; Thu, 23 Sep 2021 18:39:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242626AbhIWSk5 (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 23 Sep 2021 14:40:57 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:24753 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S242714AbhIWSk4 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 23 Sep 2021 14:40:56 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1632422363;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=gl3rmZvVThFaeFfRLTdG0cOEV5CZHPaggzd6TpSp/rE=;
        b=Ypp8xa3dFBtHoCoZYmw/lRo0lesloqFE8XKoboiQ3atCOVAQ2DZ/nXHVX8cuSm8GP10FoG
        i8rZyR36T9Nvhh5jkbjXakXK2eR1HPEKd+XSKQHThbxtGs6/unTfY1hQxINTWdlrkmRph5
        xdaSkAONNekb5abvQAtcYNsWgx+T0kU=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-283-IG1WP8ldPGGEQVB1-2YeaQ-1; Thu, 23 Sep 2021 14:39:22 -0400
X-MC-Unique: IG1WP8ldPGGEQVB1-2YeaQ-1
Received: by mail-wr1-f71.google.com with SMTP id f7-20020a5d50c7000000b0015e288741a4so5914373wrt.9
        for <linux-crypto@vger.kernel.org>; Thu, 23 Sep 2021 11:39:22 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        bh=gl3rmZvVThFaeFfRLTdG0cOEV5CZHPaggzd6TpSp/rE=;
        b=YG5VSn+VoXVS0gNbs4Bmk03LtwAfivlWuzUPl0W5W70wIbLvO+HU+ayJmiOC5PO+T6
         vYszH8/jKW51o3Iz8uSocFCqJY8nVxws1S6Y/cGij+aONACenaSsZVMOol5dNjXn5SE8
         SPxYOtWjRC5kPlhrICzAoZF5ufKj/JuggdJ3bWQ9jSo6MUhyxPNmdjX8OdZIaK9oPrm2
         uYpe0nWWDdDylqHhJW3wzcIBEvwDhODdv5J9hQCfEskvIjX/OGhsPH7/FWFlXEDvZ6By
         QoS7AxxeRx8S7/HD3mcLEBNBQioYiXFA29uDdF/NnjR3cGheLOMgyn9vG3+xEjSratVk
         KJ0w==
X-Gm-Message-State: AOAM530IGENUW83ZAa4BPiedI7Mu03oBwkvhXMax3wfqN7p6L91HaP64
        jx0Reu/g4Hhd71+0j1sMuK5SGACLNP/+yaGlT5dk/0QJtenmBgzRCwE72O6qY4hjltxBxv4OJCR
        QLJ3lr1isa4LrfklN55YQrhaP
X-Received: by 2002:a1c:9851:: with SMTP id a78mr17377003wme.107.1632422361371;
        Thu, 23 Sep 2021 11:39:21 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwIFESmjQrx6emyOVymLS1YeXQOOTBEsXjK57+Zczby+mJ8smnriGz36fqHD+SNd+0fKZevBw==
X-Received: by 2002:a1c:9851:: with SMTP id a78mr17376966wme.107.1632422361061;
        Thu, 23 Sep 2021 11:39:21 -0700 (PDT)
Received: from work-vm (cpc109011-salf6-2-0-cust1562.10-2.cable.virginm.net. [82.29.118.27])
        by smtp.gmail.com with ESMTPSA id x21sm9982202wmc.14.2021.09.23.11.39.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 23 Sep 2021 11:39:20 -0700 (PDT)
Date:   Thu, 23 Sep 2021 19:39:17 +0100
From:   "Dr. David Alan Gilbert" <dgilbert@redhat.com>
To:     Brijesh Singh <brijesh.singh@amd.com>
Cc:     x86@kernel.org, linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        linux-coco@lists.linux.dev, linux-mm@kvack.org,
        linux-crypto@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Joerg Roedel <jroedel@suse.de>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Ard Biesheuvel <ardb@kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Andy Lutomirski <luto@kernel.org>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Sergio Lopez <slp@redhat.com>, Peter Gonda <pgonda@google.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>,
        David Rientjes <rientjes@google.com>,
        Dov Murik <dovmurik@linux.ibm.com>,
        Tobin Feldman-Fitzthum <tobin@ibm.com>,
        Borislav Petkov <bp@alien8.de>,
        Michael Roth <michael.roth@amd.com>,
        Vlastimil Babka <vbabka@suse.cz>,
        "Kirill A . Shutemov" <kirill@shutemov.name>,
        Andi Kleen <ak@linux.intel.com>, tony.luck@intel.com,
        marcorr@google.com, sathyanarayanan.kuppuswamy@linux.intel.com
Subject: Re: [PATCH Part2 v5 21/45] KVM: SVM: Make AVIC backing, VMSA and
 VMCB memory allocation SNP safe
Message-ID: <YUzJ1VHbSIrKYy0c@work-vm>
References: <20210820155918.7518-1-brijesh.singh@amd.com>
 <20210820155918.7518-22-brijesh.singh@amd.com>
 <YUt8KOiwTwwa6xZK@work-vm>
 <b3f340dc-ceee-3d04-227d-741ad0c17c49@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <b3f340dc-ceee-3d04-227d-741ad0c17c49@amd.com>
User-Agent: Mutt/2.0.7 (2021-05-04)
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

* Brijesh Singh (brijesh.singh@amd.com) wrote:
> 
> On 9/22/21 1:55 PM, Dr. David Alan Gilbert wrote:
> > * Brijesh Singh (brijesh.singh@amd.com) wrote:
> >> Implement a workaround for an SNP erratum where the CPU will incorrectly
> >> signal an RMP violation #PF if a hugepage (2mb or 1gb) collides with the
> >> RMP entry of a VMCB, VMSA or AVIC backing page.
> >>
> >> When SEV-SNP is globally enabled, the CPU marks the VMCB, VMSA, and AVIC
> >> backing   pages as "in-use" in the RMP after a successful VMRUN.  This is
> >> done for _all_ VMs, not just SNP-Active VMs.
> > Can you explain what 'globally enabled' means?
> 
> This means that SNP is enabled in  host SYSCFG_MSR.Snp=1. Once its
> enabled then RMP checks are enforced.
> 
> 
> > Or more specifically, can we trip this bug on public hardware that has
> > the SNP enabled in the bios, but no SNP init in the host OS?
> 
> Enabling the SNP support on host is 3 step process:
> 
> step1 (bios): reserve memory for the RMP table.
> 
> step2 (host): initialize the RMP table memory, set the SYSCFG msr to
> enable the SNP feature
> 
> step3 (host): call the SNP_INIT to initialize the SNP firmware (this is
> needed only if you ever plan to launch SNP guest from this host).
> 
> The "SNP globally enabled" means the step 1 to 2. The RMP checks are
> enforced as soon as step 2 is completed.

So I think that means we don't need to backport this to older kernels
that don't know about SNP but might run on SNP enabled hardware (1), since
those kernels won't do step2.

Dave

> thanks
> 
> >
> > Dave
> >
> >> If the hypervisor accesses an in-use page through a writable translation,
> >> the CPU will throw an RMP violation #PF.  On early SNP hardware, if an
> >> in-use page is 2mb aligned and software accesses any part of the associated
> >> 2mb region with a hupage, the CPU will incorrectly treat the entire 2mb
> >> region as in-use and signal a spurious RMP violation #PF.
> >>
> >> The recommended is to not use the hugepage for the VMCB, VMSA or
> >> AVIC backing page. Add a generic allocator that will ensure that the page
> >> returns is not hugepage (2mb or 1gb) and is safe to be used when SEV-SNP
> >> is enabled.
> >>
> >> Co-developed-by: Marc Orr <marcorr@google.com>
> >> Signed-off-by: Marc Orr <marcorr@google.com>
> >> Signed-off-by: Brijesh Singh <brijesh.singh@amd.com>
> >> ---
> >>  arch/x86/include/asm/kvm-x86-ops.h |  1 +
> >>  arch/x86/include/asm/kvm_host.h    |  1 +
> >>  arch/x86/kvm/lapic.c               |  5 ++++-
> >>  arch/x86/kvm/svm/sev.c             | 35 ++++++++++++++++++++++++++++++
> >>  arch/x86/kvm/svm/svm.c             | 16 ++++++++++++--
> >>  arch/x86/kvm/svm/svm.h             |  1 +
> >>  6 files changed, 56 insertions(+), 3 deletions(-)
> >>
> >> diff --git a/arch/x86/include/asm/kvm-x86-ops.h b/arch/x86/include/asm/kvm-x86-ops.h
> >> index a12a4987154e..36a9c23a4b27 100644
> >> --- a/arch/x86/include/asm/kvm-x86-ops.h
> >> +++ b/arch/x86/include/asm/kvm-x86-ops.h
> >> @@ -122,6 +122,7 @@ KVM_X86_OP_NULL(enable_direct_tlbflush)
> >>  KVM_X86_OP_NULL(migrate_timers)
> >>  KVM_X86_OP(msr_filter_changed)
> >>  KVM_X86_OP_NULL(complete_emulated_msr)
> >> +KVM_X86_OP(alloc_apic_backing_page)
> >>  
> >>  #undef KVM_X86_OP
> >>  #undef KVM_X86_OP_NULL
> >> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> >> index 974cbfb1eefe..5ad6255ff5d5 100644
> >> --- a/arch/x86/include/asm/kvm_host.h
> >> +++ b/arch/x86/include/asm/kvm_host.h
> >> @@ -1453,6 +1453,7 @@ struct kvm_x86_ops {
> >>  	int (*complete_emulated_msr)(struct kvm_vcpu *vcpu, int err);
> >>  
> >>  	void (*vcpu_deliver_sipi_vector)(struct kvm_vcpu *vcpu, u8 vector);
> >> +	void *(*alloc_apic_backing_page)(struct kvm_vcpu *vcpu);
> >>  };
> >>  
> >>  struct kvm_x86_nested_ops {
> >> diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
> >> index ba5a27879f1d..05b45747b20b 100644
> >> --- a/arch/x86/kvm/lapic.c
> >> +++ b/arch/x86/kvm/lapic.c
> >> @@ -2457,7 +2457,10 @@ int kvm_create_lapic(struct kvm_vcpu *vcpu, int timer_advance_ns)
> >>  
> >>  	vcpu->arch.apic = apic;
> >>  
> >> -	apic->regs = (void *)get_zeroed_page(GFP_KERNEL_ACCOUNT);
> >> +	if (kvm_x86_ops.alloc_apic_backing_page)
> >> +		apic->regs = static_call(kvm_x86_alloc_apic_backing_page)(vcpu);
> >> +	else
> >> +		apic->regs = (void *)get_zeroed_page(GFP_KERNEL_ACCOUNT);
> >>  	if (!apic->regs) {
> >>  		printk(KERN_ERR "malloc apic regs error for vcpu %x\n",
> >>  		       vcpu->vcpu_id);
> >> diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
> >> index 1644da5fc93f..8771b878193f 100644
> >> --- a/arch/x86/kvm/svm/sev.c
> >> +++ b/arch/x86/kvm/svm/sev.c
> >> @@ -2703,3 +2703,38 @@ void sev_vcpu_deliver_sipi_vector(struct kvm_vcpu *vcpu, u8 vector)
> >>  		break;
> >>  	}
> >>  }
> >> +
> >> +struct page *snp_safe_alloc_page(struct kvm_vcpu *vcpu)
> >> +{
> >> +	unsigned long pfn;
> >> +	struct page *p;
> >> +
> >> +	if (!cpu_feature_enabled(X86_FEATURE_SEV_SNP))
> >> +		return alloc_page(GFP_KERNEL_ACCOUNT | __GFP_ZERO);
> >> +
> >> +	/*
> >> +	 * Allocate an SNP safe page to workaround the SNP erratum where
> >> +	 * the CPU will incorrectly signal an RMP violation  #PF if a
> >> +	 * hugepage (2mb or 1gb) collides with the RMP entry of VMCB, VMSA
> >> +	 * or AVIC backing page. The recommeded workaround is to not use the
> >> +	 * hugepage.
> >> +	 *
> >> +	 * Allocate one extra page, use a page which is not 2mb aligned
> >> +	 * and free the other.
> >> +	 */
> >> +	p = alloc_pages(GFP_KERNEL_ACCOUNT | __GFP_ZERO, 1);
> >> +	if (!p)
> >> +		return NULL;
> >> +
> >> +	split_page(p, 1);
> >> +
> >> +	pfn = page_to_pfn(p);
> >> +	if (IS_ALIGNED(__pfn_to_phys(pfn), PMD_SIZE)) {
> >> +		pfn++;
> >> +		__free_page(p);
> >> +	} else {
> >> +		__free_page(pfn_to_page(pfn + 1));
> >> +	}
> >> +
> >> +	return pfn_to_page(pfn);
> >> +}
> >> diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
> >> index 25773bf72158..058eea8353c9 100644
> >> --- a/arch/x86/kvm/svm/svm.c
> >> +++ b/arch/x86/kvm/svm/svm.c
> >> @@ -1368,7 +1368,7 @@ static int svm_create_vcpu(struct kvm_vcpu *vcpu)
> >>  	svm = to_svm(vcpu);
> >>  
> >>  	err = -ENOMEM;
> >> -	vmcb01_page = alloc_page(GFP_KERNEL_ACCOUNT | __GFP_ZERO);
> >> +	vmcb01_page = snp_safe_alloc_page(vcpu);
> >>  	if (!vmcb01_page)
> >>  		goto out;
> >>  
> >> @@ -1377,7 +1377,7 @@ static int svm_create_vcpu(struct kvm_vcpu *vcpu)
> >>  		 * SEV-ES guests require a separate VMSA page used to contain
> >>  		 * the encrypted register state of the guest.
> >>  		 */
> >> -		vmsa_page = alloc_page(GFP_KERNEL_ACCOUNT | __GFP_ZERO);
> >> +		vmsa_page = snp_safe_alloc_page(vcpu);
> >>  		if (!vmsa_page)
> >>  			goto error_free_vmcb_page;
> >>  
> >> @@ -4539,6 +4539,16 @@ static int svm_vm_init(struct kvm *kvm)
> >>  	return 0;
> >>  }
> >>  
> >> +static void *svm_alloc_apic_backing_page(struct kvm_vcpu *vcpu)
> >> +{
> >> +	struct page *page = snp_safe_alloc_page(vcpu);
> >> +
> >> +	if (!page)
> >> +		return NULL;
> >> +
> >> +	return page_address(page);
> >> +}
> >> +
> >>  static struct kvm_x86_ops svm_x86_ops __initdata = {
> >>  	.hardware_unsetup = svm_hardware_teardown,
> >>  	.hardware_enable = svm_hardware_enable,
> >> @@ -4667,6 +4677,8 @@ static struct kvm_x86_ops svm_x86_ops __initdata = {
> >>  	.complete_emulated_msr = svm_complete_emulated_msr,
> >>  
> >>  	.vcpu_deliver_sipi_vector = svm_vcpu_deliver_sipi_vector,
> >> +
> >> +	.alloc_apic_backing_page = svm_alloc_apic_backing_page,
> >>  };
> >>  
> >>  static struct kvm_x86_init_ops svm_init_ops __initdata = {
> >> diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
> >> index d1f1512a4b47..e40800e9c998 100644
> >> --- a/arch/x86/kvm/svm/svm.h
> >> +++ b/arch/x86/kvm/svm/svm.h
> >> @@ -575,6 +575,7 @@ void sev_es_create_vcpu(struct vcpu_svm *svm);
> >>  void sev_vcpu_deliver_sipi_vector(struct kvm_vcpu *vcpu, u8 vector);
> >>  void sev_es_prepare_guest_switch(struct vcpu_svm *svm, unsigned int cpu);
> >>  void sev_es_unmap_ghcb(struct vcpu_svm *svm);
> >> +struct page *snp_safe_alloc_page(struct kvm_vcpu *vcpu);
> >>  
> >>  /* vmenter.S */
> >>  
> >> -- 
> >> 2.17.1
> >>
> >>
> 
-- 
Dr. David Alan Gilbert / dgilbert@redhat.com / Manchester, UK


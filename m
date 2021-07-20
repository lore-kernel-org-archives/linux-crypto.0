Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.6 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,FSL_HELO_FAKE,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DBB14C07E9B
	for <linux-crypto@archiver.kernel.org>; Tue, 20 Jul 2021 00:59:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BF4C361165
	for <linux-crypto@archiver.kernel.org>; Tue, 20 Jul 2021 00:59:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240095AbhGTASs (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 19 Jul 2021 20:18:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47914 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1378415AbhGSXhL (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 19 Jul 2021 19:37:11 -0400
Received: from mail-pf1-x435.google.com (mail-pf1-x435.google.com [IPv6:2607:f8b0:4864:20::435])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9F2C3C08EA3C
        for <linux-crypto@vger.kernel.org>; Mon, 19 Jul 2021 17:10:40 -0700 (PDT)
Received: by mail-pf1-x435.google.com with SMTP id b12so18133832pfv.6
        for <linux-crypto@vger.kernel.org>; Mon, 19 Jul 2021 17:10:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=AK7Am28M2zvc87KGZLscBYou7JeqfY9AoMRwA8Z1is0=;
        b=kOJz/QU/yH26H5nk02wvJPuP7I15H5DyQmeaxzTCZy4nge9IPwiNMKHI7U3dCKd+z9
         VC46tces4DPjfyQd6/7DoXA8J0G8oMlGEvEwNHxh8zAiKv4xlhDbHdbn7UTq6cU0emJX
         bXtDSYyPOi2ynMErJTUKqEjXAR575c7xvzK3Q2zaohOoMkCX3bqOSYvttDkw34YdWZoW
         UE0rNfvMHAczrp8ll5j1fxv/l7Y9beXzNf5dJ/pjBhVIxzpMgE/gLBA9qQHOdS4CIRbN
         tPqP556jUWGYKfSbaAIj2nWSdziw0T1MJUhOJWd5mlT+jpq+wQgyLLVdbRUU7Xe1WZ0c
         kv3w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=AK7Am28M2zvc87KGZLscBYou7JeqfY9AoMRwA8Z1is0=;
        b=azi1ZDdtI09MonCczp3PsLFoBdrFJcghHwru6MP+4qzvPZbTBf2/jsO10Qy0oDVK7Q
         CDJfcNZcjiJRq0PKvvPjdHsFBzcJQVMbUbU1atAINZqmpnRVFcS2Rnk2ty2CZeJaITBW
         KjBgCjVJF4Thb9tHRujHWTvNZZ9u9MJLG8VqdQGAKliaREeYLUENuVrLzOuQzDxavq/Q
         OHkff4gnCqZGQDXZC5PkiQkZskETJ8bBts7GeO/hBOCeFzeCLa1ZG7Ax2e4k1olHC3aw
         RphmQ2ximxwBHZ6Yg8ySiy5D4kJ4IP8i6ndUTajazmkKnIMFMiW441lutdH4MAgbnqk3
         xx1g==
X-Gm-Message-State: AOAM53274PSe6OFILsqzzIzXdbM7tlHet67iT/yauyY4nkZ2W5/7AlQm
        lFadmo88cLu3fMobMkejeTmyag==
X-Google-Smtp-Source: ABdhPJwXXNzz6kdDJ2LYdi7Q+ws13YMDHqvdk1hUvnOwKNdrC60c1ezx7UMJv5UI1Q2z1WInzxdE0g==
X-Received: by 2002:a62:684:0:b029:330:2fe:28ef with SMTP id 126-20020a6206840000b029033002fe28efmr28679143pfg.21.1626739839808;
        Mon, 19 Jul 2021 17:10:39 -0700 (PDT)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id d191sm24218090pga.27.2021.07.19.17.10.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 19 Jul 2021 17:10:39 -0700 (PDT)
Date:   Tue, 20 Jul 2021 00:10:35 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Brijesh Singh <brijesh.singh@amd.com>
Cc:     x86@kernel.org, linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        linux-efi@vger.kernel.org, platform-driver-x86@vger.kernel.org,
        linux-coco@lists.linux.dev, linux-mm@kvack.org,
        linux-crypto@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Joerg Roedel <jroedel@suse.de>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Ard Biesheuvel <ardb@kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
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
        Vlastimil Babka <vbabka@suse.cz>, tony.luck@intel.com,
        npmccallum@redhat.com, brijesh.ksingh@gmail.com
Subject: Re: [PATCH Part2 RFC v4 37/40] KVM: SVM: Add support to handle the
 RMP nested page fault
Message-ID: <YPYUe8hAz5/c7IW9@google.com>
References: <20210707183616.5620-1-brijesh.singh@amd.com>
 <20210707183616.5620-38-brijesh.singh@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210707183616.5620-38-brijesh.singh@amd.com>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Wed, Jul 07, 2021, Brijesh Singh wrote:
> Follow the recommendation from APM2 section 15.36.10 and 15.36.11 to
> resolve the RMP violation encountered during the NPT table walk.

Heh, please elaborate on exactly what that recommendation is.  A recommendation
isn't exactly architectural, i.e. is subject to change :-)

And, do we have to follow the APM's recommendation?  Specifically, can KVM treat
#NPF RMP violations as guest errors, or is that not allowed by the GHCB spec?
I.e. can we mandate accesses be preceded by page state change requests?  It would
simplify KVM (albeit not much of a simplificiation) and would also make debugging
easier since transitions would require an explicit guest request and guest bugs
would result in errors instead of random corruption/weirdness.

> index 46323af09995..117e2e08d7ed 100644
> --- a/arch/x86/include/asm/kvm_host.h
> +++ b/arch/x86/include/asm/kvm_host.h
> @@ -1399,6 +1399,9 @@ struct kvm_x86_ops {
>  
>  	void (*write_page_begin)(struct kvm *kvm, struct kvm_memory_slot *slot, gfn_t gfn);
>  	void (*write_page_end)(struct kvm *kvm, struct kvm_memory_slot *slot, gfn_t gfn);
> +
> +	int (*handle_rmp_page_fault)(struct kvm_vcpu *vcpu, gpa_t gpa, kvm_pfn_t pfn,
> +			int level, u64 error_code);
>  };
>  
>  struct kvm_x86_nested_ops {
> diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> index e60f54455cdc..b6a676ba1862 100644
> --- a/arch/x86/kvm/mmu/mmu.c
> +++ b/arch/x86/kvm/mmu/mmu.c
> @@ -5096,6 +5096,18 @@ static void kvm_mmu_pte_write(struct kvm_vcpu *vcpu, gpa_t gpa,
>  	write_unlock(&vcpu->kvm->mmu_lock);
>  }
>  
> +static int handle_rmp_page_fault(struct kvm_vcpu *vcpu, gpa_t gpa, u64 error_code)
> +{
> +	kvm_pfn_t pfn;
> +	int level;
> +
> +	if (unlikely(!kvm_mmu_get_tdp_walk(vcpu, gpa, &pfn, &level)))
> +		return RET_PF_RETRY;
> +
> +	kvm_x86_ops.handle_rmp_page_fault(vcpu, gpa, pfn, level, error_code);
> +	return RET_PF_RETRY;
> +}
> +
>  int kvm_mmu_page_fault(struct kvm_vcpu *vcpu, gpa_t cr2_or_gpa, u64 error_code,
>  		       void *insn, int insn_len)
>  {
> @@ -5112,6 +5124,14 @@ int kvm_mmu_page_fault(struct kvm_vcpu *vcpu, gpa_t cr2_or_gpa, u64 error_code,
>  			goto emulate;
>  	}
>  
> +	if (unlikely(error_code & PFERR_GUEST_RMP_MASK)) {
> +		r = handle_rmp_page_fault(vcpu, cr2_or_gpa, error_code);

Adding a kvm_x86_ops hook is silly, there's literally one path, npf_interception()
that can encounter RMP violations.  Just invoke snp_handle_rmp_page_fault() from
there.  That works even if kvm_mmu_get_tdp_walk() stays around since it was
exported earlier.

> +		if (r == RET_PF_RETRY)
> +			return 1;
> +		else
> +			return r;
> +	}
> +
>  	if (r == RET_PF_INVALID) {
>  		r = kvm_mmu_do_page_fault(vcpu, cr2_or_gpa,
>  					  lower_32_bits(error_code), false);
> diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
> index 839cf321c6dd..53a60edc810e 100644
> --- a/arch/x86/kvm/svm/sev.c
> +++ b/arch/x86/kvm/svm/sev.c
> @@ -3519,3 +3519,60 @@ void sev_snp_write_page_begin(struct kvm *kvm, struct kvm_memory_slot *slot, gfn
>  		BUG_ON(rc != 0);
>  	}
>  }
> +
> +int snp_handle_rmp_page_fault(struct kvm_vcpu *vcpu, gpa_t gpa, kvm_pfn_t pfn,
> +			      int level, u64 error_code)
> +{
> +	struct rmpentry *e;
> +	int rlevel, rc = 0;
> +	bool private;
> +	gfn_t gfn;
> +
> +	e = snp_lookup_page_in_rmptable(pfn_to_page(pfn), &rlevel);
> +	if (!e)
> +		return 1;
> +
> +	private = !!(error_code & PFERR_GUEST_ENC_MASK);
> +
> +	/*
> +	 * See APM section 15.36.11 on how to handle the RMP fault for the large pages.

Please do not punt the reader to the APM for things like this.  It's ok when there
are gory details about CPU behavior that aren't worth commenting, but under no
circumstance should KVM's software implementation be "documented" in a CPU spec.

> +	 *
> +	 *  npt	     rmp    access      action
> +	 *  --------------------------------------------------
> +	 *  4k       2M     C=1       psmash
> +	 *  x        x      C=1       if page is not private then add a new RMP entry
> +	 *  x        x      C=0       if page is private then make it shared
> +	 *  2M       4k     C=x       zap
> +	 */
> +	if ((error_code & PFERR_GUEST_SIZEM_MASK) ||
> +	    ((level == PG_LEVEL_4K) && (rlevel == PG_LEVEL_2M) && private)) {
> +		rc = snp_rmptable_psmash(vcpu, pfn);
> +		goto zap_gfn;
> +	}
> +
> +	/*
> +	 * If it's a private access, and the page is not assigned in the RMP table, create a
> +	 * new private RMP entry.
> +	 */
> +	if (!rmpentry_assigned(e) && private) {
> +		rc = snp_make_page_private(vcpu, gpa, pfn, PG_LEVEL_4K);
> +		goto zap_gfn;
> +	}
> +
> +	/*
> +	 * If it's a shared access, then make the page shared in the RMP table.
> +	 */
> +	if (rmpentry_assigned(e) && !private)
> +		rc = snp_make_page_shared(vcpu, gpa, pfn, PG_LEVEL_4K);

Hrm, this really feels like it needs to be protected by mmu_lock.  Functionally,
it might all work out in the end after enough RMP violations, but it's extremely
difficult to reason about and probably even more difficult if multiple vCPUs end
up fighting over a gfn.

My gut reaction is that this is also backwards, i.e. KVM should update the RMP
to match its TDP SPTEs, not the other way around.

The one big complication is that the TDP MMU only takes mmu_lock for read.  A few
options come to mind but none of them are all that pretty.  I'll wait to hear back
on whether or not we can make PSC request mandatory before thinking too hard on
this one.

> +zap_gfn:
> +	/*
> +	 * Now that we have updated the RMP pagesize, zap the existing rmaps for
> +	 * large entry ranges so that nested page table gets rebuilt with the updated RMP
> +	 * pagesize.
> +	 */
> +	gfn = gpa_to_gfn(gpa) & ~(KVM_PAGES_PER_HPAGE(PG_LEVEL_2M) - 1);
> +	kvm_zap_gfn_range(vcpu->kvm, gfn, gfn + 512);
> +
> +	return 0;
> +}

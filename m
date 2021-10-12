Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 46497C433EF
	for <linux-crypto@archiver.kernel.org>; Tue, 12 Oct 2021 18:52:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 154CC60527
	for <linux-crypto@archiver.kernel.org>; Tue, 12 Oct 2021 18:52:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231672AbhJLSyo (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 12 Oct 2021 14:54:44 -0400
Received: from mail-pj1-f48.google.com ([209.85.216.48]:36451 "EHLO
        mail-pj1-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233059AbhJLSyh (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 12 Oct 2021 14:54:37 -0400
Received: by mail-pj1-f48.google.com with SMTP id qe4-20020a17090b4f8400b0019f663cfcd1so2600271pjb.1
        for <linux-crypto@vger.kernel.org>; Tue, 12 Oct 2021 11:52:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=DfbFY8+dvVdayrpl/HC8aWmEL5nQTdONvOQ8G8k3sdI=;
        b=btrJZ/IPtSJJEbgCzV6kLMKqVSQRPFad9W9idPv/BiZkJlo6bd8G81Kds8V+qlts68
         3bQnjkeOOxKIBW56arcH1rokJD7Au9TeVsJ8TJ+Z5zeMOmbsetfD1dwwfcHcz6Ypn0kq
         hM+nYHme6i+QiLuXnZc+fGlxFT9/zcx8u8iqhQ/6sSEjE12Dj53FwHia2CePuYV1/jkO
         faSxpMuKmvLzs/e1NY8UN9zkG/5P75+JRJbV8MPR8oi6a1W0SYyP6vgly4sUvh4UQEoP
         yGCsAs4zCy+iTJ0jhrZEFAcP5DBJ4XPOou6hakCEZOKj2fxsyuBfwVLPCkTnrkbgSqTq
         H41g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=DfbFY8+dvVdayrpl/HC8aWmEL5nQTdONvOQ8G8k3sdI=;
        b=TjKZgaw91IEaK/dXFTjb8xnKmqbITfoxdcRIKkXoCniA+eDgnlADqMLnRzxF7E7P7r
         A5gm/BEX8xe5unTECpBOu2/qju+dkRsrEoXuWw3HGBDZpNFRo2j/SLSYCU106RbNM0CI
         57m+rDugJqPLyIRNvaUS1Cu0NUMSfNfGXykDMZZ15M5X9GemKAi7aUvPYcvwIch+stjD
         Axpc9E1sXKXmiFU3EfauMezpfGMAMOipgjefKhtRfeO/no9ASEd728yi/qk0U2bK3h6K
         Q0uDF9cK7X1V5l85f1VYmbbfhnaWyaiglq296msN7Fx6vyL5g8S21e+5vDEE5vwN6NXr
         PsRg==
X-Gm-Message-State: AOAM531hndT5xljxns15SNDMuibTUJ8h6YwgELQaLFVXWA8S4PfetNdr
        +60OGd+FTxml0IdM+5WsaLFRAQ==
X-Google-Smtp-Source: ABdhPJw+X5MZoBakEaHZNsLbsAa4QxFgESLNxqGtJNcguDnKmi32hzC66ItirwvCxHpvHxMp0faMyQ==
X-Received: by 2002:a17:902:a710:b029:12b:9b9f:c461 with SMTP id w16-20020a170902a710b029012b9b9fc461mr31769695plq.59.1634064422208;
        Tue, 12 Oct 2021 11:47:02 -0700 (PDT)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id w2sm11975808pfq.207.2021.10.12.11.47.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 12 Oct 2021 11:47:01 -0700 (PDT)
Date:   Tue, 12 Oct 2021 18:46:57 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Brijesh Singh <brijesh.singh@amd.com>
Cc:     x86@kernel.org, linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
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
        Vlastimil Babka <vbabka@suse.cz>,
        "Kirill A . Shutemov" <kirill@shutemov.name>,
        Andi Kleen <ak@linux.intel.com>, tony.luck@intel.com,
        marcorr@google.com, sathyanarayanan.kuppuswamy@linux.intel.com
Subject: Re: [PATCH Part2 v5 26/45] KVM: SVM: Mark the private vma unmerable
 for SEV-SNP guests
Message-ID: <YWXYIWuK2T8Kejng@google.com>
References: <20210820155918.7518-1-brijesh.singh@amd.com>
 <20210820155918.7518-27-brijesh.singh@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210820155918.7518-27-brijesh.singh@amd.com>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Fri, Aug 20, 2021, Brijesh Singh wrote:
> When SEV-SNP is enabled, the guest private pages are added in the RMP
> table; while adding the pages, the rmp_make_private() unmaps the pages
> from the direct map. If KSM attempts to access those unmapped pages then
> it will trigger #PF (page-not-present).
> 
> Encrypted guest pages cannot be shared between the process, so an
> userspace should not mark the region mergeable but to be safe, mark the
> process vma unmerable before adding the pages in the RMP table.

To be safe from what?  Does the !PRESENT #PF crash the kernel?

> Signed-off-by: Brijesh Singh <brijesh.singh@amd.com>
> ---
>  arch/x86/kvm/svm/sev.c | 32 ++++++++++++++++++++++++++++++++
>  1 file changed, 32 insertions(+)
> 
> diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
> index 4b126598b7aa..dcef0ae5f8e4 100644
> --- a/arch/x86/kvm/svm/sev.c
> +++ b/arch/x86/kvm/svm/sev.c
> @@ -18,11 +18,13 @@
>  #include <linux/processor.h>
>  #include <linux/trace_events.h>
>  #include <linux/sev.h>
> +#include <linux/ksm.h>
>  #include <asm/fpu/internal.h>
>  
>  #include <asm/pkru.h>
>  #include <asm/trapnr.h>
>  #include <asm/sev.h>
> +#include <asm/mman.h>
>  
>  #include "x86.h"
>  #include "svm.h"
> @@ -1683,6 +1685,30 @@ static bool is_hva_registered(struct kvm *kvm, hva_t hva, size_t len)
>  	return false;
>  }
>  
> +static int snp_mark_unmergable(struct kvm *kvm, u64 start, u64 size)
> +{
> +	struct vm_area_struct *vma;
> +	u64 end = start + size;
> +	int ret;
> +
> +	do {
> +		vma = find_vma_intersection(kvm->mm, start, end);
> +		if (!vma) {
> +			ret = -EINVAL;
> +			break;
> +		}
> +
> +		ret = ksm_madvise(vma, vma->vm_start, vma->vm_end,
> +				  MADV_UNMERGEABLE, &vma->vm_flags);
> +		if (ret)
> +			break;
> +
> +		start = vma->vm_end;
> +	} while (end > vma->vm_end);
> +
> +	return ret;
> +}
> +
>  static int snp_launch_update(struct kvm *kvm, struct kvm_sev_cmd *argp)
>  {
>  	struct kvm_sev_info *sev = &to_kvm_svm(kvm)->sev_info;
> @@ -1707,6 +1733,12 @@ static int snp_launch_update(struct kvm *kvm, struct kvm_sev_cmd *argp)
>  	if (!is_hva_registered(kvm, params.uaddr, params.len))
>  		return -EINVAL;
>  
> +	mmap_write_lock(kvm->mm);
> +	ret = snp_mark_unmergable(kvm, params.uaddr, params.len);
> +	mmap_write_unlock(kvm->mm);

This does not, and practically speaking cannot, work.  There are multiple TOCTOU
bugs, here and in __snp_handle_page_state_change().  Userspace can madvise() the
range at any later point, munmap()/mmap() the entire range, mess with the memslots
in the PSC case, and so on and so forth.  Relying on MADV_UNMERGEABLE for functional
correctness simply cannot work in KVM, barring mmu_notifier and a big pile of code.

> +	if (ret)
> +		return -EFAULT;
> +
>  	/*
>  	 * The userspace memory is already locked so technically we don't
>  	 * need to lock it again. Later part of the function needs to know
> -- 
> 2.17.1
> 

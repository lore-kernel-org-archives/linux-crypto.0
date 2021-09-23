Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.7 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 05283C433F5
	for <linux-crypto@archiver.kernel.org>; Thu, 23 Sep 2021 17:18:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DC4D461090
	for <linux-crypto@archiver.kernel.org>; Thu, 23 Sep 2021 17:18:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235318AbhIWRUJ (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 23 Sep 2021 13:20:09 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:52337 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S242322AbhIWRUI (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 23 Sep 2021 13:20:08 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1632417515;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=HTLd0L367gc4jN84e5+s0fqSREmR7mCJKNMwOZgzIVE=;
        b=VvLzmhYfoOKJ9TT/RGO+gah3XODYvWQgBPsyW6LWNndKAjwBU7MJOm60MMG3oaU8iQtpdU
        7RNws4HNNrAtjgAe1Ka9AUQW8XufRbeWoEewW9Een7uvR6MUfSww3+u4Lcf8bXD8CpMj1h
        nhFEWNQ7lqBpNSSIbO6JqNZb2GhmWss=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-233-wp8BmxAqNHWTB4HBoWCk7w-1; Thu, 23 Sep 2021 13:18:34 -0400
X-MC-Unique: wp8BmxAqNHWTB4HBoWCk7w-1
Received: by mail-wr1-f70.google.com with SMTP id x2-20020a5d54c2000000b0015dfd2b4e34so5751656wrv.6
        for <linux-crypto@vger.kernel.org>; Thu, 23 Sep 2021 10:18:34 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=HTLd0L367gc4jN84e5+s0fqSREmR7mCJKNMwOZgzIVE=;
        b=uMV24aSbECbEksfIbWDTxC5NCRRDXOiZsVBvCpWcIRZkEc/d0wqrkFEqk/C2Cvx9kk
         jx2l2XFGSZo49NIjjvCu0Gd46FrM94KiqRNwdGHLk6y7pgcXl9gG0+avR3AKlhdxzFxn
         dy39fS56QdPk7IY43qoaFWLBhpwX83ALHcpsOeGDW2WcpyL5wB8cKlqcUEzmUAkfn7ac
         pc7HXOqS5FzxzEbpZ85qLFTBXrt8sHHYcZLI3AXNdRI6ImTa5iF5uFdpMJXPnRctZawM
         8QPMg52QoKtEUhVPLs5V+JbQLNyhWu5Qf8aXmLl7SKMHEtk9/P/2QiW+rQaodMdEPbw5
         hV4w==
X-Gm-Message-State: AOAM532dvZAH/w5iYOBq93i2IjpL7YeChzKq3qLQQXma4KJZQVNfhJ5l
        p3FH+VOREpfzZ31yQbY5poCiI5UMJDuZahZJ8J2sie9KN/b7K8TTgv2+ltv6hZUvxM8poAY43Fh
        lWWSN/9TNr1lSTryY8fYsT7/y
X-Received: by 2002:a1c:7906:: with SMTP id l6mr5628016wme.78.1632417513372;
        Thu, 23 Sep 2021 10:18:33 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJy/YA/RfXw7S2MKlGlRm+21Dc17PDAzjJVExvB0JyJaKY7mCiCzEn2iZFxNNrPXbLrfoDtZPA==
X-Received: by 2002:a1c:7906:: with SMTP id l6mr5627996wme.78.1632417513136;
        Thu, 23 Sep 2021 10:18:33 -0700 (PDT)
Received: from work-vm (cpc109011-salf6-2-0-cust1562.10-2.cable.virginm.net. [82.29.118.27])
        by smtp.gmail.com with ESMTPSA id h15sm5740773wrc.19.2021.09.23.10.18.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 23 Sep 2021 10:18:32 -0700 (PDT)
Date:   Thu, 23 Sep 2021 18:18:29 +0100
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
Subject: Re: [PATCH Part2 v5 26/45] KVM: SVM: Mark the private vma unmerable
 for SEV-SNP guests
Message-ID: <YUy25drlqFoJLNXE@work-vm>
References: <20210820155918.7518-1-brijesh.singh@amd.com>
 <20210820155918.7518-27-brijesh.singh@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210820155918.7518-27-brijesh.singh@amd.com>
User-Agent: Mutt/2.0.7 (2021-05-04)
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

* Brijesh Singh (brijesh.singh@amd.com) wrote:
> When SEV-SNP is enabled, the guest private pages are added in the RMP
> table; while adding the pages, the rmp_make_private() unmaps the pages
> from the direct map. If KSM attempts to access those unmapped pages then
> it will trigger #PF (page-not-present).
> 
> Encrypted guest pages cannot be shared between the process, so an
> userspace should not mark the region mergeable but to be safe, mark the
> process vma unmerable before adding the pages in the RMP table.
              ^^^^^^^^^

(and in the subject) -> unmergeable

> 
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
                       ^^^^^^^^^^

> +{
> +	struct vm_area_struct *vma;
> +	u64 end = start + size;

Do you need to worry about wrap there? (User supplied start/size?)

Dave

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
> +	if (ret)
> +		return -EFAULT;
> +
>  	/*
>  	 * The userspace memory is already locked so technically we don't
>  	 * need to lock it again. Later part of the function needs to know
> -- 
> 2.17.1
> 
> 
-- 
Dr. David Alan Gilbert / dgilbert@redhat.com / Manchester, UK


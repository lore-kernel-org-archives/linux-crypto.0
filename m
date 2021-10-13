Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5877EC433EF
	for <linux-crypto@archiver.kernel.org>; Wed, 13 Oct 2021 00:23:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3BF9860BD3
	for <linux-crypto@archiver.kernel.org>; Wed, 13 Oct 2021 00:23:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235220AbhJMAZd (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 12 Oct 2021 20:25:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54284 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233128AbhJMAZc (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 12 Oct 2021 20:25:32 -0400
Received: from mail-pl1-x62a.google.com (mail-pl1-x62a.google.com [IPv6:2607:f8b0:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0036EC061570
        for <linux-crypto@vger.kernel.org>; Tue, 12 Oct 2021 17:23:29 -0700 (PDT)
Received: by mail-pl1-x62a.google.com with SMTP id t11so612943plq.11
        for <linux-crypto@vger.kernel.org>; Tue, 12 Oct 2021 17:23:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=nNn+UC9/cpHxaqXZcUQl1BrWnaOK7ya+9AekxpxnqsI=;
        b=bdidJxg0jUARvsCBaeu3CeAv/AxMHtqGox7Vw3htO3XcEp8pH0N4F01G7pgZ2yNGrY
         3jkTn1wx6FkK4CeEv2VpIKlIrocztMIS4vjxog0azQviZFmOhBMjWzF2I6AYgut4P+Jq
         wGKSniQfk/e7V5M7x0ZQv+XWg6Ao/WbjQg6pdrBkqDEUXcaoo3l/mHISseVJgDz4JiQj
         GZPyJUhqrlmf8EvlBE8hMZHu1I19WJ+fQ4uJL/m71vriEf9TRgf2pen9yYTC95UHd20x
         jxgw5qZuFGKwx4l6ccUt+rcFrIyMJugk8Q5Q7Tr/f/qRPad5wL6xqsjN0WNsDMJ2yRYc
         YuaQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=nNn+UC9/cpHxaqXZcUQl1BrWnaOK7ya+9AekxpxnqsI=;
        b=NQowuqc60yROXeiaz6iStmAseA9zWpSgPboa2Runjh3IzQomnIdQAQiO6QhYCjDDEc
         eTk3gl76NoPPazRzBWsYbKjxJapt1vGqAKuXODRMW5k9h7VM6odZYM3Z6lXhuaPkTLDo
         nl0b7iCH8n7dy2Tl9dYqA0giTLK/WtZiOaO5BycqmnBHkBhaAswfrAOZnucjOOYbH8BF
         t5I6C8SNs/Vx+OFcRtqnkq2vAKaQ4wg7Slpy+oZtz8SyWTJrE717QKY1PZFLU+2lqApk
         cexatd8OA3LSzQbmttBk+x69QCjvk3T+o73LTQZlFnMWwYrXVd+sMPmLtYXiesgFWnU7
         XskQ==
X-Gm-Message-State: AOAM531v12O9CcIFa1xr+5Sv2bs81tPCK5ZrKTS9+SLokn9AmWYmXvTw
        +8taNt6vYOYc3ptobYmXVnZFyQ==
X-Google-Smtp-Source: ABdhPJxaRLNJrBS6tXom7VBegOlMNlwQPmcEbezV0bmx1DzR9C9l5P18IIb0pLw5I26UbkJ7cmzQoA==
X-Received: by 2002:a17:90a:9f44:: with SMTP id q4mr9553649pjv.136.1634084609231;
        Tue, 12 Oct 2021 17:23:29 -0700 (PDT)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id oa4sm314443pjb.13.2021.10.12.17.23.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 12 Oct 2021 17:23:28 -0700 (PDT)
Date:   Wed, 13 Oct 2021 00:23:24 +0000
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
Subject: Re: [PATCH Part2 v5 39/45] KVM: SVM: Introduce ops for the post gfn
 map and unmap
Message-ID: <YWYm/Gw8PbaAKBF0@google.com>
References: <20210820155918.7518-1-brijesh.singh@amd.com>
 <20210820155918.7518-40-brijesh.singh@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210820155918.7518-40-brijesh.singh@amd.com>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Fri, Aug 20, 2021, Brijesh Singh wrote:
> When SEV-SNP is enabled in the guest VM, the guest memory pages can
> either be a private or shared. A write from the hypervisor goes through
> the RMP checks. If hardware sees that hypervisor is attempting to write
> to a guest private page, then it triggers an RMP violation #PF.
> 
> To avoid the RMP violation, add post_{map,unmap}_gfn() ops that can be
> used to verify that its safe to map a given guest page. Use the SRCU to
> protect against the page state change for existing mapped pages.

SRCU isn't protecting anything.  The synchronize_srcu_expedited() in the PSC code
forces it to wait for existing maps to go away, but it doesn't prevent new maps
from being created while the actual RMP updates are in-flight.  Most telling is
that the RMP updates happen _after_ the synchronize_srcu_expedited() call.

This also doesn't handle kvm_{read,write}_guest_cached().

I can't help but note that the private memslots idea[*] would handle this gracefully,
e.g. the memslot lookup would fail, and any change in private memslots would
invalidate the cache due to a generation mismatch.

KSM is another mess that would Just Work.

I'm not saying that SNP should be blocked on support for unmapping guest private
memory, but I do think we should strongly consider focusing on that effort rather
than trying to fix things piecemeal throughout KVM.  I don't think it's too absurd
to say that it might actually be faster overall.  And I 100% think that having a
cohesive design and uABI for SNP and TDX would be hugely beneficial to KVM.

[*] https://lkml.kernel.org/r/20210824005248.200037-1-seanjc@google.com

> +int sev_post_map_gfn(struct kvm *kvm, gfn_t gfn, kvm_pfn_t pfn, int *token)
> +{
> +	struct kvm_sev_info *sev = &to_kvm_svm(kvm)->sev_info;
> +	int level;
> +
> +	if (!sev_snp_guest(kvm))
> +		return 0;
> +
> +	*token = srcu_read_lock(&sev->psc_srcu);
> +
> +	/* If pfn is not added as private then fail */

This comment and the pr_err() are backwards, and confused the heck out of me.
snp_lookup_rmpentry() returns '1' if the pfn is assigned, a.k.a. private.  That
means this code throws an error if the page is private, i.e. requires the page
to be shared.  Which makes sense given the use cases, it's just incredibly
confusing.

> +	if (snp_lookup_rmpentry(pfn, &level) == 1) {

Any reason not to provide e.g. rmp_is_shared() and rmp_is_private() so that
callers don't have to care as much about the return values?  The -errno/0/1
semantics are all but guarantee to bite us in the rear at some point.

Actually, peeking at other patches, I think it already has.  This usage in
__unregister_enc_region_locked() is wrong:

	/*
	 * The guest memory pages are assigned in the RMP table. Unassign it
	 * before releasing the memory.
	 */
	if (sev_snp_guest(kvm)) {
		for (i = 0; i < region->npages; i++) {
			pfn = page_to_pfn(region->pages[i]);

			if (!snp_lookup_rmpentry(pfn, &level))  <-- attempts make_shared() on non-existent entry
				continue;

			cond_resched();

			if (level > PG_LEVEL_4K)
				pfn &= ~(KVM_PAGES_PER_HPAGE(PG_LEVEL_2M) - 1);

			host_rmp_make_shared(pfn, level, true);
		}
	}


> +		srcu_read_unlock(&sev->psc_srcu, *token);
> +		pr_err_ratelimited("failed to map private gfn 0x%llx pfn 0x%llx\n", gfn, pfn);
> +		return -EBUSY;
> +	}
> +
> +	return 0;
> +}
>  static struct kvm_x86_init_ops svm_init_ops __initdata = {
> diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
> index d10f7166b39d..ff91184f9b4a 100644
> --- a/arch/x86/kvm/svm/svm.h
> +++ b/arch/x86/kvm/svm/svm.h
> @@ -76,16 +76,22 @@ struct kvm_sev_info {
>  	bool active;		/* SEV enabled guest */
>  	bool es_active;		/* SEV-ES enabled guest */
>  	bool snp_active;	/* SEV-SNP enabled guest */
> +
>  	unsigned int asid;	/* ASID used for this guest */
>  	unsigned int handle;	/* SEV firmware handle */
>  	int fd;			/* SEV device fd */
> +
>  	unsigned long pages_locked; /* Number of pages locked */
>  	struct list_head regions_list;  /* List of registered regions */
> +
>  	u64 ap_jump_table;	/* SEV-ES AP Jump Table address */
> +
>  	struct kvm *enc_context_owner; /* Owner of copied encryption context */
>  	struct misc_cg *misc_cg; /* For misc cgroup accounting */
> +

Unrelated whitespace changes.

>  	u64 snp_init_flags;
>  	void *snp_context;      /* SNP guest context page */
> +	struct srcu_struct psc_srcu;
>  };

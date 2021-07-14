Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-20.4 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,FSL_HELO_FAKE,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_IN_DEF_DKIM_WL
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5D46CC47E4B
	for <linux-crypto@archiver.kernel.org>; Wed, 14 Jul 2021 22:25:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 49542613CA
	for <linux-crypto@archiver.kernel.org>; Wed, 14 Jul 2021 22:25:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235774AbhGNW2C (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 14 Jul 2021 18:28:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60184 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233792AbhGNW2B (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 14 Jul 2021 18:28:01 -0400
Received: from mail-pj1-x102d.google.com (mail-pj1-x102d.google.com [IPv6:2607:f8b0:4864:20::102d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1EC86C061767
        for <linux-crypto@vger.kernel.org>; Wed, 14 Jul 2021 15:25:09 -0700 (PDT)
Received: by mail-pj1-x102d.google.com with SMTP id cu14so2552567pjb.0
        for <linux-crypto@vger.kernel.org>; Wed, 14 Jul 2021 15:25:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=d0LEZQXZXBUYt56KXRh0C3kDKHdIojtN6Lf/OzbsuzM=;
        b=FfQxK3SV/ESQiEb5v3FHVKWIjqOGMi4YhXCbDa/51EtfbkQHxT2bFZuQBtvVg++Xeg
         6tt92/t1RsBiKAXrzBF+W13Xl100z7HkSSk7BE9ticaVj6iq5TZK7Yg/85MWig+KqUDw
         cyh4r8o4dCYrVzEuhIF9iT9raSFKiQqQNcDLT7akQKaZ/An2B98mJOTtp0QI2qrbIFM4
         WR9L7DaXT0Vv1KusvFEYql1V5zbws+hFtvF3t8YfggWxOEhoGuBz+C+2lUnc/kEi5Ad0
         eL5L3DWqhdHe5U357bksn3v1Xz/7tZ2TBx48v3xH753GiAUfNYU73mbLS26JarnruUEu
         /B+g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=d0LEZQXZXBUYt56KXRh0C3kDKHdIojtN6Lf/OzbsuzM=;
        b=htgEYGLMkkUk7zbtsY5/4rfglO8eUSGeHootrm9zTQe6MelZxl0/6BCMcMGmECVyM/
         eJJRxQr9R6Xnm8reqIVZKlNwt71cvcggY6NxrHc/IYNYZT7HCRLd8g9FTbMhVo61GOo5
         Hl2Jcsv9SaFBAM3gSd6jFuWBjxMN4W3J2K39E3uncZJOtojJQ1Cf1xTb6+RWheGmIVHJ
         HQU0qKR5155JUE5wzxZPdFGBulRmCV5ycoMbu/QU/ioh0GssHmJdOaaAk5axfhGZx/XJ
         A7NmOUOhyrSP6zzDOUPjbYZ+TJhSfPnFLWUM50qu9xwlRxVrzIAYkvVA9vFOzjQqeK9u
         86yA==
X-Gm-Message-State: AOAM532azvCeDhQpZN9WOf5CgyFU6f5l4/9xBy+c3vRRCjCl98cEAHj0
        B0/gvJyzUU9QScCQ6sd0ZemksQ==
X-Google-Smtp-Source: ABdhPJyj12ndfez3CtyE1b5kgpw1CSsww4ClT6FKSpDwrLOL4aVpAEAP3FkBpK5S7C9HrKMRFrU05w==
X-Received: by 2002:a17:90b:1d84:: with SMTP id pf4mr140522pjb.166.1626301507743;
        Wed, 14 Jul 2021 15:25:07 -0700 (PDT)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id 3sm3889790pfm.25.2021.07.14.15.25.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 14 Jul 2021 15:25:07 -0700 (PDT)
Date:   Wed, 14 Jul 2021 22:25:03 +0000
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
Subject: Re: [PATCH Part2 RFC v4 07/40] x86/sev: Split the physmap when
 adding the page in RMP table
Message-ID: <YO9kP1v0TAFXISHD@google.com>
References: <20210707183616.5620-1-brijesh.singh@amd.com>
 <20210707183616.5620-8-brijesh.singh@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210707183616.5620-8-brijesh.singh@amd.com>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Wed, Jul 07, 2021, Brijesh Singh wrote:
> The integrity guarantee of SEV-SNP is enforced through the RMP table.
> The RMP is used in conjuntion with standard x86 and IOMMU page
> tables to enforce memory restrictions and page access rights. The
> RMP is indexed by system physical address, and is checked at the end
> of CPU and IOMMU table walks. The RMP check is enforced as soon as
> SEV-SNP is enabled globally in the system. Not every memory access
> requires an RMP check. In particular, the read accesses from the
> hypervisor do not require RMP checks because the data confidentiality
> is already protected via memory encryption. When hardware encounters
> an RMP checks failure, it raise a page-fault exception. The RMP bit in
> fault error code can be used to determine if the fault was due to an
> RMP checks failure.
> 
> A write from the hypervisor goes through the RMP checks. When the
> hypervisor writes to pages, hardware checks to ensures that the assigned
> bit in the RMP is zero (i.e page is shared). If the page table entry that
> gives the sPA indicates that the target page size is a large page, then
> all RMP entries for the 4KB constituting pages of the target must have the
> assigned bit 0. If one of entry does not have assigned bit 0 then hardware
> will raise an RMP violation. To resolve it, split the page table entry
> leading to target page into 4K.

Isn't the above just saying:

  All RMP entries covered by a large page must match the shared vs. encrypted
  state of the page, e.g. host large pages must have assigned=0 for all relevant
  RMP entries.

> This poses a challenge in the Linux memory model. The Linux kernel
> creates a direct mapping of all the physical memory -- referred to as
> the physmap. The physmap may contain a valid mapping of guest owned pages.
> During the page table walk, the host access may get into the situation
> where one of the pages within the large page is owned by the guest (i.e
> assigned bit is set in RMP). A write to a non-guest within the large page
> will raise an RMP violation. Call set_memory_4k() to split the physmap
> before adding the page in the RMP table. This ensures that the pages
> added in the RMP table are used as 4K in the physmap.
> 
> Signed-off-by: Brijesh Singh <brijesh.singh@amd.com>
> ---
>  arch/x86/kernel/sev.c | 6 ++++++
>  1 file changed, 6 insertions(+)
> 
> diff --git a/arch/x86/kernel/sev.c b/arch/x86/kernel/sev.c
> index 949efe530319..a482e01f880a 100644
> --- a/arch/x86/kernel/sev.c
> +++ b/arch/x86/kernel/sev.c
> @@ -2375,6 +2375,12 @@ int rmpupdate(struct page *page, struct rmpupdate *val)
>  	if (!cpu_feature_enabled(X86_FEATURE_SEV_SNP))
>  		return -ENXIO;
>  
> +	ret = set_memory_4k((unsigned long)page_to_virt(page), 1);

IIUC, this shatters the direct map for page that's assigned to an SNP guest, and
the large pages are never recovered?

I believe a better approach would be to do something similar to memfd_secret[*],
which encountered a similar problem with the direct map.  Instead of forcing the
direct map to be forever 4k, unmap the direct map when making a page guest private,
and restore the direct map when it's made shared (or freed).

I thought memfd_secret had also solved the problem of restoring large pages in
the direct map, but at a glance I can't tell if that's actually implemented
anywhere.  But, even if it's not currently implemented, I think it makes sense
to mimic the memfd_secret approach so that both features can benefit if large
page preservation/restoration is ever added.

[*] https://lkml.kernel.org/r/20210518072034.31572-5-rppt@kernel.org

> +	if (ret) {
> +		pr_err("Failed to split physical address 0x%lx (%d)\n", spa, ret);
> +		return ret;
> +	}
> +
>  	/* Retry if another processor is modifying the RMP entry. */
>  	do {
>  		/* Binutils version 2.36 supports the RMPUPDATE mnemonic. */
> -- 
> 2.17.1
> 

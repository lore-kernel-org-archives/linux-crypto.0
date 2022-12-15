Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3CE26C4332F
	for <linux-crypto@archiver.kernel.org>; Thu, 15 Dec 2022 01:01:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229834AbiLOBBd (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 14 Dec 2022 20:01:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57924 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229787AbiLOBBa (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 14 Dec 2022 20:01:30 -0500
Received: from mail-oi1-x22c.google.com (mail-oi1-x22c.google.com [IPv6:2607:f8b0:4864:20::22c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B96F746655
        for <linux-crypto@vger.kernel.org>; Wed, 14 Dec 2022 17:01:26 -0800 (PST)
Received: by mail-oi1-x22c.google.com with SMTP id l127so4105984oia.8
        for <linux-crypto@vger.kernel.org>; Wed, 14 Dec 2022 17:01:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:message-id:in-reply-to:subject:cc:to:from
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=+AXpgMmuL3NSvfn8iBTUkD9z8GYz9GV/xJMhFU7McSc=;
        b=Hj80HcFk1+wGgWdM0qYtfoEP118g7pnbDZ1iaONKLRyq7ALD/XEV7vVSxyeyG5C332
         DuC73/7jKGMCEB1dULH+KLHOKSeumpkwpUW+GG68qvMmQss4v6sir0gMkHngJ4x1PdNs
         8vdv6ESeeyQvXXjiXz48kEds4m3Lm1jtvmFWcha7pPVkxpn+OyzTG9/53OGVegS45kva
         5BafxskuHY7iVDaqjM/QPv26NHNdJ8WRDt4flC21tJbgAsNeqEiTNTWmog0Muzakrg+B
         VTXrP+16m5YsUQA7uxS09XE7vABC6lHuib020amhH4dBXy3QWuaWt/Jwty6r6MYSoUQT
         6e1g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=mime-version:references:message-id:in-reply-to:subject:cc:to:from
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=+AXpgMmuL3NSvfn8iBTUkD9z8GYz9GV/xJMhFU7McSc=;
        b=w/yBXvjXQOuL3J/YckVusYQ/xQfKZgJ8POobLnjPgjjRRYeKh3+eRs/snCPR5pJn0V
         FjjBQkcUQ9Nkd4DLt8J3huO6bH/S4t23q/jm9DUvx00RVnara5Y40FteWAUFljtLPIvT
         hQxFmMPrXzofh0kxWY0RCCVlmaoxrRAxeABxLttd7Nib8PRHtARrFNnejLHdUyK2gUS+
         DJRBU6be1KDgXxnlaqjzafAXRx01SLZDtm5kvi72V/EdLNvGlGoiwhI6zX6ArAh1QsX+
         YPHChIRo4JRed1B+mEMvWMzkDopkBMZxJiUHf2/vMcYvJgl/BWKB61SRwUYIaqj0Z86s
         TBuQ==
X-Gm-Message-State: ANoB5pk0u09ICyLgEpbN3jjxulw37RaOAebpp1Za54sfsWSyqumPofjX
        5MEoH0b1R3Q2lr+b0yXfMCCEog==
X-Google-Smtp-Source: AA0mqf7KxsTUFtO5GJXQhQPOFp5+C1dzmEUY6YPXNbXSdYOeKDPdD1PHkb69Ov9jtK9L5BUY7Y7G2Q==
X-Received: by 2002:a05:6808:2387:b0:35e:9bb3:b8fa with SMTP id bp7-20020a056808238700b0035e9bb3b8famr7121698oib.51.1671066085845;
        Wed, 14 Dec 2022 17:01:25 -0800 (PST)
Received: from ripple.attlocal.net (172-10-233-147.lightspeed.sntcca.sbcglobal.net. [172.10.233.147])
        by smtp.gmail.com with ESMTPSA id i8-20020a05620a404800b006feea093006sm11137891qko.124.2022.12.14.17.01.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 14 Dec 2022 17:01:24 -0800 (PST)
Date:   Wed, 14 Dec 2022 17:01:13 -0800 (PST)
From:   Hugh Dickins <hughd@google.com>
X-X-Sender: hugh@ripple.attlocal.net
To:     Michael Roth <michael.roth@amd.com>
cc:     kvm@vger.kernel.org, linux-coco@lists.linux.dev,
        linux-mm@kvack.org, linux-crypto@vger.kernel.org, x86@kernel.org,
        linux-kernel@vger.kernel.org, tglx@linutronix.de, mingo@redhat.com,
        jroedel@suse.de, thomas.lendacky@amd.com, hpa@zytor.com,
        ardb@kernel.org, pbonzini@redhat.com, seanjc@google.com,
        vkuznets@redhat.com, wanpengli@tencent.com, jmattson@google.com,
        luto@kernel.org, dave.hansen@linux.intel.com, slp@redhat.com,
        pgonda@google.com, peterz@infradead.org,
        srinivas.pandruvada@linux.intel.com, rientjes@google.com,
        dovmurik@linux.ibm.com, tobin@ibm.com, bp@alien8.de,
        vbabka@suse.cz, kirill@shutemov.name, ak@linux.intel.com,
        tony.luck@intel.com, marcorr@google.com,
        sathyanarayanan.kuppuswamy@linux.intel.com, alpergun@google.com,
        dgilbert@redhat.com, jarkko@kernel.org, ashish.kalra@amd.com,
        harald@profian.com, Hugh Dickins <hughd@google.com>
Subject: Re: [PATCH RFC v7 21/64] x86/fault: fix handle_split_page_fault()
 to work with memfd backed pages
In-Reply-To: <20221214194056.161492-22-michael.roth@amd.com>
Message-ID: <7f2228c4-1586-2934-7b92-1a9d23b6046@google.com>
References: <20221214194056.161492-1-michael.roth@amd.com> <20221214194056.161492-22-michael.roth@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Wed, 14 Dec 2022, Michael Roth wrote:
> From: Hugh Dickins <hughd@google.com>
> 
> When the address is backed by a memfd, the code to split the page does
> nothing more than remove the PMD from the page tables. So immediately
> install a PTE to ensure that any other pages in that 2MB region are
> brought back as in 4K pages.
> 
> Signed-off-by: Hugh Dickins <hughd@google.com>
> Cc: Hugh Dickins <hughd@google.com>
> Signed-off-by: Ashish Kalra <ashish.kalra@amd.com>
> Signed-off-by: Michael Roth <michael.roth@amd.com>

Hah, it's good to see this again, but it was "Suggested-by" me, not
"Signed-off-by" me.  And was a neat pragmatic one-liner workaround
for the immediate problem we had, but came with caveats.

The problem is that we have one wind blowing in the split direction,
and another wind (khugepaged) blowing in the collapse direction, and
who wins for how long depends on factors I've not fully got to grips
with (and is liable to differ between kernel releases).

Good and bad timing to see it.  I was just yesterday reviewing a patch
to the collapsing wind, which reminded me of an improvement yet to be
made there, thinking I'd like to try it sometime; but recallng that
someone somewhere relies on the splitting wind, and doesn't want the
collapsing wind to blow any harder - now you remind me who!

Bad timing in that I don't have any quick answer on the right thing
to do instead, and can't give it the thought it needs at the moment -
perhaps others can chime in more usefully.

Hugh

p.s. I don't know where "handle_split_page_fault" comes in, but
"x86/fault" in the subject looks wrong, since this appears to be
in generic code; and "memfd" seems inappropriate too, but perhaps you
have a situation where only memfds can reach handle_split_page_fault().

> ---
>  mm/memory.c | 5 +++++
>  1 file changed, 5 insertions(+)
> 
> diff --git a/mm/memory.c b/mm/memory.c
> index e68da7e403c6..33c9020ba1f8 100644
> --- a/mm/memory.c
> +++ b/mm/memory.c
> @@ -4999,6 +4999,11 @@ static vm_fault_t handle_pte_fault(struct vm_fault *vmf)
>  static int handle_split_page_fault(struct vm_fault *vmf)
>  {
>  	__split_huge_pmd(vmf->vma, vmf->pmd, vmf->address, false, NULL);
> +	/*
> +	 * Install a PTE immediately to ensure that any other pages in
> +	 * this 2MB region are brought back in as 4K pages.
> +	 */
> +	__pte_alloc(vmf->vma->vm_mm, vmf->pmd);
>  	return 0;
>  }
>  
> -- 
> 2.25.1

Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 43D54C3DA78
	for <linux-crypto@archiver.kernel.org>; Fri, 13 Jan 2023 22:57:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230245AbjAMW5R (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 13 Jan 2023 17:57:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48390 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230193AbjAMW5L (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 13 Jan 2023 17:57:11 -0500
Received: from mail-il1-x133.google.com (mail-il1-x133.google.com [IPv6:2607:f8b0:4864:20::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2EFD989BC1
        for <linux-crypto@vger.kernel.org>; Fri, 13 Jan 2023 14:56:47 -0800 (PST)
Received: by mail-il1-x133.google.com with SMTP id h11so482502ilc.1
        for <linux-crypto@vger.kernel.org>; Fri, 13 Jan 2023 14:56:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=t9OYCY5AQ//JBDxFPYPi4BdHfpgPadouZrXYVbVKOKc=;
        b=Q5hUBJJQ2kzFMhMCC25IIWPv9X9Auo96vTTq/gyoIPpburCx/8/aziqbndYCIIxFuw
         gD5jl4yT7v1j9IRyAWKl4yzkZMHouAd8sqXYlf6krcAtjnw7lzWj6agC89tSVC3aN+QJ
         6pvSPxFLj5lJ9xDmUfPjt0SWQJNp30OE0fjl/lbJes3MXWWbVolHKswF4K85iqPJH4Bu
         kAix5XIrDsFcVyAmp3NI1cET1ddc2ZRdJ+yt1yLMFXSycsK20gZNy3qzjVHZUBstxXst
         G5yztZNjNDZbv9sp5SU/mLpe2Op80Pho9VlGA0A1kO/yBTAE3j7uwGweN1cClY2NYtgL
         TsPA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=t9OYCY5AQ//JBDxFPYPi4BdHfpgPadouZrXYVbVKOKc=;
        b=pVZ2phRw0CL2rk27xj1k86AbXuRjj9k09DNra1kRfi9ldVLWm/uYG2pmICrAMr9WPl
         gCZV5ClkKYJRHaSjuRXPxEYjWO1EoV4vrVdlwVE1F0kz6e6XyJsDlCzDFHg1bJ0cerEx
         sbiQBgVM6GWIVPbr2NvyHvI4BX/ct+d5QFLYwxkQLJcMpIC7YvUkWNivfZvotXmhxn5f
         b65qndgQWQoPTU4OcoLvrqKyK4HbqkakH2P0enyTzpEToU/72uVwwzGAidl1juNLmmH7
         NcD9qUvMRAziCHyyX/w+y8TvVqyn5Y3utKAhww+gqi0nxsFjcSwghw/niejEQf/6GtxS
         4cPg==
X-Gm-Message-State: AFqh2koCWDME2qP7bgH9WDTDVeR0pL0VjVKR8z7rq9LNZmqd0u9HYywb
        whD0B7pcPT+vIZBd8MgLlUC9uyXOZCKU/hzOoSuWeA==
X-Google-Smtp-Source: AMrXdXt6PNhpMWTCzhJRGnREELU2zzAWx9YzlhAaqnF6nUrsUno+E0GVqcp0lPVWl9HGKEnQbf3SVAgxOlC6yytSd+4=
X-Received: by 2002:a05:6e02:b2b:b0:30e:eaf7:e742 with SMTP id
 e11-20020a056e020b2b00b0030eeaf7e742mr137639ilu.63.1673650606379; Fri, 13 Jan
 2023 14:56:46 -0800 (PST)
MIME-Version: 1.0
References: <20221214194056.161492-1-michael.roth@amd.com> <20221214194056.161492-24-michael.roth@amd.com>
In-Reply-To: <20221214194056.161492-24-michael.roth@amd.com>
From:   Alper Gun <alpergun@google.com>
Date:   Fri, 13 Jan 2023 14:56:35 -0800
Message-ID: <CABpDEu=eNi_R5c_hmw1J3kFUsWiNUFQ2Sdxwf0QXX5osH4u6cQ@mail.gmail.com>
Subject: Re: [PATCH RFC v7 23/64] x86/fault: Add support to dump RMP entry on fault
To:     Michael Roth <michael.roth@amd.com>
Cc:     kvm@vger.kernel.org, linux-coco@lists.linux.dev,
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
        sathyanarayanan.kuppuswamy@linux.intel.com, dgilbert@redhat.com,
        jarkko@kernel.org, ashish.kalra@amd.com, harald@profian.com,
        Brijesh Singh <brijesh.singh@amd.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Wed, Dec 14, 2022 at 11:52 AM Michael Roth <michael.roth@amd.com> wrote:
>
> From: Brijesh Singh <brijesh.singh@amd.com>
>
> When SEV-SNP is enabled globally, a write from the host goes through the
> RMP check. If the hardware encounters the check failure, then it raises
> the #PF (with RMP set). Dump the RMP entry at the faulting pfn to help
> the debug.
>
> Signed-off-by: Brijesh Singh <brijesh.singh@amd.com>
> Signed-off-by: Ashish Kalra <ashish.kalra@amd.com>
> Signed-off-by: Michael Roth <michael.roth@amd.com>
> ---
>  arch/x86/include/asm/sev.h |  2 ++
>  arch/x86/kernel/sev.c      | 43 ++++++++++++++++++++++++++++++++++++++
>  arch/x86/mm/fault.c        |  7 ++++++-
>  3 files changed, 51 insertions(+), 1 deletion(-)
>
> diff --git a/arch/x86/include/asm/sev.h b/arch/x86/include/asm/sev.h
> index 4eeedcaca593..2916f4150ac7 100644
> --- a/arch/x86/include/asm/sev.h
> +++ b/arch/x86/include/asm/sev.h
> @@ -215,6 +215,7 @@ int snp_lookup_rmpentry(u64 pfn, int *level);
>  int psmash(u64 pfn);
>  int rmp_make_private(u64 pfn, u64 gpa, enum pg_level level, int asid, bool immutable);
>  int rmp_make_shared(u64 pfn, enum pg_level level);
> +void sev_dump_rmpentry(u64 pfn);
>  #else
>  static inline void sev_es_ist_enter(struct pt_regs *regs) { }
>  static inline void sev_es_ist_exit(void) { }
> @@ -247,6 +248,7 @@ static inline int rmp_make_private(u64 pfn, u64 gpa, enum pg_level level, int as
>         return -ENODEV;
>  }
>  static inline int rmp_make_shared(u64 pfn, enum pg_level level) { return -ENODEV; }
> +static inline void sev_dump_rmpentry(u64 pfn) {}
>  #endif
>
>  #endif
> diff --git a/arch/x86/kernel/sev.c b/arch/x86/kernel/sev.c
> index e2b38c3551be..1dd1b36bdfea 100644
> --- a/arch/x86/kernel/sev.c
> +++ b/arch/x86/kernel/sev.c
> @@ -2508,6 +2508,49 @@ static struct rmpentry *__snp_lookup_rmpentry(u64 pfn, int *level)
>         return entry;
>  }
>
> +void sev_dump_rmpentry(u64 pfn)
> +{
> +       unsigned long pfn_end;
> +       struct rmpentry *e;
> +       int level;
> +
> +       e = __snp_lookup_rmpentry(pfn, &level);
> +       if (!e) {
if (IS_ERR(e)) {

> +               pr_info("failed to read RMP entry pfn 0x%llx\n", pfn);
> +               return;
> +       }
> +
> +       if (rmpentry_assigned(e)) {
> +               pr_info("RMPEntry paddr 0x%llx [assigned=%d immutable=%d pagesize=%d gpa=0x%lx"
> +                       " asid=%d vmsa=%d validated=%d]\n", pfn << PAGE_SHIFT,
> +                       rmpentry_assigned(e), e->info.immutable, rmpentry_pagesize(e),
> +                       (unsigned long)e->info.gpa, e->info.asid, e->info.vmsa,
> +                       e->info.validated);
> +               return;
> +       }
> +
> +       /*
> +        * If the RMP entry at the faulting pfn was not assigned, then not sure
> +        * what caused the RMP violation. To get some useful debug information,
> +        * iterate through the entire 2MB region, and dump the RMP entries if
> +        * one of the bit in the RMP entry is set.
> +        */
> +       pfn = pfn & ~(PTRS_PER_PMD - 1);
> +       pfn_end = pfn + PTRS_PER_PMD;
> +
> +       while (pfn < pfn_end) {
> +               e = __snp_lookup_rmpentry(pfn, &level);
> +               if (!e)
> +                       return;
if (IS_ERR(e))
      continue;
> +
> +               if (e->low || e->high)
> +                       pr_info("RMPEntry paddr 0x%llx: [high=0x%016llx low=0x%016llx]\n",
> +                               pfn << PAGE_SHIFT, e->high, e->low);
> +               pfn++;
> +       }
> +}
> +EXPORT_SYMBOL_GPL(sev_dump_rmpentry);
> +
>  /*
>   * Return 1 if the RMP entry is assigned, 0 if it exists but is not assigned,
>   * and -errno if there is no corresponding RMP entry.
> diff --git a/arch/x86/mm/fault.c b/arch/x86/mm/fault.c
> index ded53879f98d..f2b16dcfbd9a 100644
> --- a/arch/x86/mm/fault.c
> +++ b/arch/x86/mm/fault.c
> @@ -536,6 +536,8 @@ static void show_ldttss(const struct desc_ptr *gdt, const char *name, u16 index)
>  static void
>  show_fault_oops(struct pt_regs *regs, unsigned long error_code, unsigned long address)
>  {
> +       unsigned long pfn;
> +
>         if (!oops_may_print())
>                 return;
>
> @@ -608,7 +610,10 @@ show_fault_oops(struct pt_regs *regs, unsigned long error_code, unsigned long ad
>                 show_ldttss(&gdt, "TR", tr);
>         }
>
> -       dump_pagetable(address);
> +       pfn = dump_pagetable(address);
> +
> +       if (error_code & X86_PF_RMP)
> +               sev_dump_rmpentry(pfn);
>  }
>
>  static noinline void
> --
> 2.25.1
>

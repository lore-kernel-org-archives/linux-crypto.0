Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 140FFC43334
	for <linux-crypto@archiver.kernel.org>; Thu, 23 Jun 2022 21:00:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229648AbiFWVAw (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 23 Jun 2022 17:00:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54780 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229470AbiFWVAv (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 23 Jun 2022 17:00:51 -0400
Received: from mail-oa1-x2a.google.com (mail-oa1-x2a.google.com [IPv6:2001:4860:4864:20::2a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 080E054BFA
        for <linux-crypto@vger.kernel.org>; Thu, 23 Jun 2022 14:00:48 -0700 (PDT)
Received: by mail-oa1-x2a.google.com with SMTP id 586e51a60fabf-1048b8a38bbso1032825fac.12
        for <linux-crypto@vger.kernel.org>; Thu, 23 Jun 2022 14:00:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=YFZn+6KIIWp9gABMuWoR/dKCyEO4Zr5Rzf3hYjExeKM=;
        b=SLSQuGNHJV37cOtMEFG3uwEzqjiH7rjf8lBN6dlJxGi5K+qWAXGF9NaHB34fDTGnnG
         5BO6KBC5M9pv9FZxmNICTOXTmCjuDmEFXatrzbKgwFgT5Xwxwx7ok4mIUzi9Zaw9ZH9j
         hPKLQ5ipJETzDMCc1BbrD2MIcLQZi9LLB3BXeXoa6G+i5m3Lx1QgXn15IUHKZkjT/GnV
         HRCmcy3hXV0Lzzz0YERx53i6O5/3isS7ABZxFZgI7IoNX1ywx7gub33tTSzKErrXnsAa
         P84cUd7O2iPNeHWqT+MEBYdPFRU5j5M8eVJefEmJlF34ljWH6wgP3O2BHg+Wg97ictpa
         mBvA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=YFZn+6KIIWp9gABMuWoR/dKCyEO4Zr5Rzf3hYjExeKM=;
        b=OriFdIyTt5HPhU0Z853cUu0vAadfHyGDs7+9HMv4pvVjFTov7pxr2RCXYYI9x1H8JN
         Els3r91sKSvelhoc9b1a9QtX3wrZxf2ZLpQraWGLC2I9mRKghB1o9oLI+yLxJ1VwzoDI
         Ktr8KR75dzJeSuoGK4MkkAIKyaVwpZoDUWSi7sfJL6dc5xvegOKSJYfPMl5sfb5kV5zq
         h89CToTEtXYIS0BR1bajWRw6w1KFP6os4p+CbA0xPkpfsUgHXVpJm59A7qAjJHU72Vjg
         pmsKCX6xPRYOVDK+J4XNzX35AllB+LuAW5Qnbg4VsgTsp3dIZCYB0gWmTGlAKlD5XloN
         y15Q==
X-Gm-Message-State: AJIora/09iBFU8Ala16FY8giLfW8yu/QY0RX6glUI6zixQ+nGKs7ndgI
        Fc1rhAXlR7/jmjWok/KKitPrGQy9qOXODUSYcT/o/w==
X-Google-Smtp-Source: AGRyM1u+6NKJmTl5AxpFSRq+8aQW2BDLG8AB1hBjiM3k8m1AvB1fSE0FBJqFqc2vKOE78+7yBQ8YcxTcWmTVOZli3B8=
X-Received: by 2002:a05:6870:b616:b0:e2:f8bb:5eb with SMTP id
 cm22-20020a056870b61600b000e2f8bb05ebmr3694057oab.218.1656018047090; Thu, 23
 Jun 2022 14:00:47 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1655761627.git.ashish.kalra@amd.com> <c933e87762d78e5dce78e9bbf9c41aa0b30ddba2.1655761627.git.ashish.kalra@amd.com>
In-Reply-To: <c933e87762d78e5dce78e9bbf9c41aa0b30ddba2.1655761627.git.ashish.kalra@amd.com>
From:   Marc Orr <marcorr@google.com>
Date:   Thu, 23 Jun 2022 14:00:36 -0700
Message-ID: <CAA03e5G-6-x-iOaAvrAb-fWTsuWzQdCOX6eiRAv=ZscG6QHDNg@mail.gmail.com>
Subject: Re: [PATCH Part2 v6 04/49] x86/sev: set SYSCFG.MFMD
To:     Ashish Kalra <Ashish.Kalra@amd.com>
Cc:     x86 <x86@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        kvm list <kvm@vger.kernel.org>, linux-coco@lists.linux.dev,
        linux-mm@kvack.org,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Joerg Roedel <jroedel@suse.de>,
        "Lendacky, Thomas" <thomas.lendacky@amd.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Ard Biesheuvel <ardb@kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
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
        "Roth, Michael" <michael.roth@amd.com>,
        Vlastimil Babka <vbabka@suse.cz>,
        "Kirill A . Shutemov" <kirill@shutemov.name>,
        Andi Kleen <ak@linux.intel.com>,
        Tony Luck <tony.luck@intel.com>,
        Sathyanarayanan Kuppuswamy 
        <sathyanarayanan.kuppuswamy@linux.intel.com>,
        Alper Gun <alpergun@google.com>,
        "Dr . David Alan Gilbert" <dgilbert@redhat.com>, jarkko@kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Mon, Jun 20, 2022 at 4:02 PM Ashish Kalra <Ashish.Kalra@amd.com> wrote:
>
> From: Brijesh Singh <brijesh.singh@amd.com>
>
> SEV-SNP FW >= 1.51 requires that SYSCFG.MFMD must be set.
>
> Subsequent CCP patches while require 1.51 as the minimum SEV-SNP
> firmware version.
>
> Signed-off-by: Brijesh Singh <brijesh.singh@amd.com>
> ---
>  arch/x86/include/asm/msr-index.h |  3 +++
>  arch/x86/kernel/sev.c            | 24 ++++++++++++++++++++++++
>  2 files changed, 27 insertions(+)
>
> diff --git a/arch/x86/include/asm/msr-index.h b/arch/x86/include/asm/msr-index.h
> index 57a8280e283a..1e36f16daa56 100644
> --- a/arch/x86/include/asm/msr-index.h
> +++ b/arch/x86/include/asm/msr-index.h
> @@ -587,6 +587,9 @@
>  #define MSR_AMD64_SYSCFG_SNP_EN                BIT_ULL(MSR_AMD64_SYSCFG_SNP_EN_BIT)
>  #define MSR_AMD64_SYSCFG_SNP_VMPL_EN_BIT       25
>  #define MSR_AMD64_SYSCFG_SNP_VMPL_EN   BIT_ULL(MSR_AMD64_SYSCFG_SNP_VMPL_EN_BIT)
> +#define MSR_AMD64_SYSCFG_MFDM_BIT              19
> +#define MSR_AMD64_SYSCFG_MFDM          BIT_ULL(MSR_AMD64_SYSCFG_MFDM_BIT)

nit: Similar to the previous patch, the alignment here doesn't look
right. The bad alignment can be viewed on the github version of this
patch:
https://github.com/AMDESE/linux/commit/6d4469b86f90e67119ff110230857788a0d9dbd0

> +
>  #define MSR_K8_INT_PENDING_MSG         0xc0010055
>  /* C1E active bits in int pending message */
>  #define K8_INTP_C1E_ACTIVE_MASK                0x18000000
> diff --git a/arch/x86/kernel/sev.c b/arch/x86/kernel/sev.c
> index 3a233b5d47c5..25c7feb367f6 100644
> --- a/arch/x86/kernel/sev.c
> +++ b/arch/x86/kernel/sev.c
> @@ -2257,6 +2257,27 @@ static __init void snp_enable(void *arg)
>         __snp_enable(smp_processor_id());
>  }
>
> +static int __mfdm_enable(unsigned int cpu)
> +{
> +       u64 val;
> +
> +       if (!cpu_feature_enabled(X86_FEATURE_SEV_SNP))
> +               return 0;
> +
> +       rdmsrl(MSR_AMD64_SYSCFG, val);
> +
> +       val |= MSR_AMD64_SYSCFG_MFDM;

Can we do this inside `__snp_enable()`, above? Then, we'll execute if
a hotplug event happens as well.

static int __snp_enable(unsigned int cpu)
{
     u64 val;

     if (!cpu_feature_enabled(X86_FEATURE_SEV_SNP))
          return 0;

     rdmsrl(MSR_AMD64_SYSCFG, val);

     val |= MSR_AMD64_SYSCFG_SNP_EN;
     val |= MSR_AMD64_SYSCFG_SNP_VMPL_EN;
     val |= MSR_AMD64_SYSCFG_MFDM;

     wrmsrl(MSR_AMD64_SYSCFG, val);

     return 0;
}

> +
> +       wrmsrl(MSR_AMD64_SYSCFG, val);
> +
> +       return 0;
> +}
> +
> +static __init void mfdm_enable(void *arg)
> +{
> +       __mfdm_enable(smp_processor_id());
> +}
> +
>  static bool get_rmptable_info(u64 *start, u64 *len)
>  {
>         u64 calc_rmp_sz, rmp_sz, rmp_base, rmp_end, nr_pages;
> @@ -2325,6 +2346,9 @@ static __init int __snp_rmptable_init(void)
>         /* Flush the caches to ensure that data is written before SNP is enabled. */
>         wbinvd_on_all_cpus();
>
> +       /* MFDM must be enabled on all the CPUs prior to enabling SNP. */
> +       on_each_cpu(mfdm_enable, NULL, 1);
> +
>         /* Enable SNP on all CPUs. */
>         on_each_cpu(snp_enable, NULL, 1);
>
> --
> 2.25.1
>

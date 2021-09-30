Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CC7EAC433FE
	for <linux-crypto@archiver.kernel.org>; Thu, 30 Sep 2021 23:42:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A57176124D
	for <linux-crypto@archiver.kernel.org>; Thu, 30 Sep 2021 23:42:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350336AbhI3Xnt (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 30 Sep 2021 19:43:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50784 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350228AbhI3Xnt (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 30 Sep 2021 19:43:49 -0400
Received: from mail-oi1-x22b.google.com (mail-oi1-x22b.google.com [IPv6:2607:f8b0:4864:20::22b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 31A86C06176D
        for <linux-crypto@vger.kernel.org>; Thu, 30 Sep 2021 16:42:06 -0700 (PDT)
Received: by mail-oi1-x22b.google.com with SMTP id u22so9435092oie.5
        for <linux-crypto@vger.kernel.org>; Thu, 30 Sep 2021 16:42:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Gi00dUKbEnLBBRPaXgkT5o8maxEnkVJlIu1XQkEnZC0=;
        b=KbzcW1uCfgaHX1R4cGCWYPX7UdNQyYMdI2TaNa0i7HP9MHoSkC/vqAaGCgbin6mB6T
         se+E7M7c8NwmnlvSAHX5Ie1kV2dQUGPSOdeqqEWF3Lwk2UCXrVLeLlgFqq84wDU9ZO/z
         y5JKi+oFRhFbmcrebDHwOlzmSssggAwIKOW79O97lnO4uguXxhrzpEcb4eFn8kFc3SBB
         WMQvnY7IFk8eR6WWepatQtY23RGz9Az/Xqjs9nqtdJONqku7bY6wav7l+I/4l/ILJI+W
         aMPQGheTvyHDLJc6QYsimS5BjEn4+6tQhaUZjCY5c7157mhO7h89Kblg9SE+vbVy4BwF
         IkJA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Gi00dUKbEnLBBRPaXgkT5o8maxEnkVJlIu1XQkEnZC0=;
        b=utRXgHsDP2jQb+3I1xwOBVm7IE3B9VJXri0Ivd8Z2UOCR6on8RVRqspH5pf98Cmbx3
         /hdOaDc5Vxs3hTOTnCRxiTov2QjpBYz2+/iGKKDaCtV2SOpXs2CzY0aPhRX/jloi6x98
         nkX2fiZcB9rIu99P7X+rxInsw9RLijhICb3japy4Um1nno3qknvD/5yyggyzOjmt0/qK
         7r6ESCxjaHn2c2tVuJkq26R3jEfS8HhqtnQiVWhMg6EJADYIwJ8vR3AqRyNp471YtYDE
         4c6F8FIFjSGjhyf+uQeyGgfsSEuXs7UjQb0uiD4tMELszZCrL+5Uq8zTPXt6lD285+ZL
         qE7Q==
X-Gm-Message-State: AOAM531j/v4s43FwXjUih7CRgbbvpwJ3OfeS46IOyBrxt9BfJi+QZDgt
        IIF+cj6tKxEtd3SbV5k+XvrIkLc/l49K9r5Y9e6Qfg==
X-Google-Smtp-Source: ABdhPJwKPjQgHWUMf0Og0OYmzz1BYvLtSYzI/LiSuuHHPOcmotdMisrFNn74dwe+jncaX/uBBZp37kj5RhHAGMWQhf4=
X-Received: by 2002:a05:6808:60f:: with SMTP id y15mr1599090oih.15.1633045325230;
 Thu, 30 Sep 2021 16:42:05 -0700 (PDT)
MIME-Version: 1.0
References: <20210820155918.7518-1-brijesh.singh@amd.com> <20210820155918.7518-33-brijesh.singh@amd.com>
In-Reply-To: <20210820155918.7518-33-brijesh.singh@amd.com>
From:   Marc Orr <marcorr@google.com>
Date:   Thu, 30 Sep 2021 16:41:54 -0700
Message-ID: <CAA03e5G-UX761uBAFLS3e1NuYZOh2v8b=UkrX+rZUviegyWVGQ@mail.gmail.com>
Subject: Re: [PATCH Part2 v5 32/45] KVM: x86: Define RMP page fault error bits
 for #NPF
To:     Brijesh Singh <brijesh.singh@amd.com>
Cc:     x86 <x86@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        kvm list <kvm@vger.kernel.org>, linux-coco@lists.linux.dev,
        linux-mm@kvack.org, linux-crypto@vger.kernel.org,
        Thomas Gleixner <tglx@linutronix.de>,
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
        sathyanarayanan.kuppuswamy@linux.intel.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Fri, Aug 20, 2021 at 9:00 AM Brijesh Singh <brijesh.singh@amd.com> wrote:
>
> When SEV-SNP is enabled globally, the hardware places restrictions on all
> memory accesses based on the RMP entry, whether the hypervisor or a VM,
> performs the accesses. When hardware encounters an RMP access violation
> during a guest access, it will cause a #VMEXIT(NPF).
>
> See APM2 section 16.36.10 for more details.

nit: Section # should be 15.36.10 (rather than 16.36.10). Also, is it
better to put section headings, rather than numbers in the commit logs
and comments? Someone mentioned to me that the section numbering in
APM and SDM can move around over time, but the section titles tend to
be more stable. I'm not sure how true this is, so feel free to
disregard this comment.

>
> Signed-off-by: Brijesh Singh <brijesh.singh@amd.com>
> ---
>  arch/x86/include/asm/kvm_host.h | 8 ++++++++
>  1 file changed, 8 insertions(+)
>
> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> index 109e80167f11..a6e764458f3e 100644
> --- a/arch/x86/include/asm/kvm_host.h
> +++ b/arch/x86/include/asm/kvm_host.h
> @@ -239,8 +239,12 @@ enum x86_intercept_stage;
>  #define PFERR_FETCH_BIT 4
>  #define PFERR_PK_BIT 5
>  #define PFERR_SGX_BIT 15
> +#define PFERR_GUEST_RMP_BIT 31
>  #define PFERR_GUEST_FINAL_BIT 32
>  #define PFERR_GUEST_PAGE_BIT 33
> +#define PFERR_GUEST_ENC_BIT 34
> +#define PFERR_GUEST_SIZEM_BIT 35
> +#define PFERR_GUEST_VMPL_BIT 36
>
>  #define PFERR_PRESENT_MASK (1U << PFERR_PRESENT_BIT)
>  #define PFERR_WRITE_MASK (1U << PFERR_WRITE_BIT)
> @@ -251,6 +255,10 @@ enum x86_intercept_stage;
>  #define PFERR_SGX_MASK (1U << PFERR_SGX_BIT)
>  #define PFERR_GUEST_FINAL_MASK (1ULL << PFERR_GUEST_FINAL_BIT)
>  #define PFERR_GUEST_PAGE_MASK (1ULL << PFERR_GUEST_PAGE_BIT)
> +#define PFERR_GUEST_RMP_MASK (1ULL << PFERR_GUEST_RMP_BIT)
> +#define PFERR_GUEST_ENC_MASK (1ULL << PFERR_GUEST_ENC_BIT)
> +#define PFERR_GUEST_SIZEM_MASK (1ULL << PFERR_GUEST_SIZEM_BIT)
> +#define PFERR_GUEST_VMPL_MASK (1ULL << PFERR_GUEST_VMPL_BIT)
>
>  #define PFERR_NESTED_GUEST_PAGE (PFERR_GUEST_PAGE_MASK |       \
>                                  PFERR_WRITE_MASK |             \
> --
> 2.17.1
>

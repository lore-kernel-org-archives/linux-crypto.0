Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.3 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_IN_DEF_DKIM_WL
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AF16FC433EF
	for <linux-crypto@archiver.kernel.org>; Thu, 23 Sep 2021 20:55:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 979C260F6F
	for <linux-crypto@archiver.kernel.org>; Thu, 23 Sep 2021 20:55:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243056AbhIWU4s (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 23 Sep 2021 16:56:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52942 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229609AbhIWU4o (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 23 Sep 2021 16:56:44 -0400
Received: from mail-oo1-xc2c.google.com (mail-oo1-xc2c.google.com [IPv6:2607:f8b0:4864:20::c2c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C153BC061574
        for <linux-crypto@vger.kernel.org>; Thu, 23 Sep 2021 13:55:12 -0700 (PDT)
Received: by mail-oo1-xc2c.google.com with SMTP id y3-20020a4ab403000000b00290e2a52c71so2591785oon.2
        for <linux-crypto@vger.kernel.org>; Thu, 23 Sep 2021 13:55:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=tuAuDbYoqWTX1qLGSlEdN/vEAB2ogbMYztyFItd+EBc=;
        b=kffc8Bs2M9fmas9cVTmc2dxOYcmX43mfJnInRmBRfKL4ci0Ra/Ed4N8E9aIVQqSA24
         y6quxScpBT1ZO+7locgf2IBsBtTWSV1MKNtI2oVT4do2OZeKdRz10YZCGL/52KyupAbV
         8aWkm3j9u3p+CMwFtEy2BYAl++cwlQPKQPEbredKllWpQDcZG0YCswdFmrI0IV65882C
         QrAs7PCAcggjX4Ld0w7WKDz9iYcyrX72CHPj2bDCzmi5ujt9pcaMq+9eQgQMIWSurH2G
         Eys/T351rHFPil0fxp9pW01KjxiNyz8ucX3AGU0NrklTz5k2qrrM1pH/hsaX+WoH5gj0
         HvuA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=tuAuDbYoqWTX1qLGSlEdN/vEAB2ogbMYztyFItd+EBc=;
        b=BO2gCBms+EmYkM+KRN8rPT5PJr7SO4OGAZ/GUBYa4z3ytR5m8XkPXuBMPKmnGjdIDz
         YwXgSzf7m0qSRWiVv0Uytz1+J7VoMUzNx/9lXNrH+nUkYWCPw1eQV3f5TRkamvWPQTXb
         9LyTQixDZqwLGAcch0xF7EiuIrSJyO56qowrHcy0g9v0ctvhvoGm4yNBN3n7XcNiEUV4
         b3h3hCuLPQJykajTpK5lFrv0H6FxrhhrxYyRGGdMIdhzdLGqkkZWpQCD/pcbQlDlMN5S
         ElV/BWT8JGhobiC557qvj2Y4idXMZAGMvT+eJHCI6Cm3g2o9mbJ+gb7gqZ6Hjy0RyabL
         0qjQ==
X-Gm-Message-State: AOAM533lZbAJWXrFkRyATbBjXlvdy2TRE3jzyJNsGPBTO01FrMwLGNWM
        GJioiinbJxm/w4GNRZUASbyvnSRHCGpHrhgyObhYcA==
X-Google-Smtp-Source: ABdhPJyrQCd4do4odQK5DYKgmv7IsQ+AMJhA+BxnQq44T7hGl3RRh3tzoKAYCmy4S2uMMD9KFjWXH8MfmAL80dEIdbw=
X-Received: by 2002:a4a:7452:: with SMTP id t18mr5499065ooe.20.1632430511717;
 Thu, 23 Sep 2021 13:55:11 -0700 (PDT)
MIME-Version: 1.0
References: <20210820155918.7518-1-brijesh.singh@amd.com> <20210820155918.7518-22-brijesh.singh@amd.com>
 <YUt8KOiwTwwa6xZK@work-vm> <b3f340dc-ceee-3d04-227d-741ad0c17c49@amd.com>
 <CAA03e5FTpmCXqsB9OZfkxVY4TQb8n5KfRiFAsmd6jjvbb1DdCQ@mail.gmail.com> <9f89fce8-421a-2219-91d0-73147aca4689@amd.com>
In-Reply-To: <9f89fce8-421a-2219-91d0-73147aca4689@amd.com>
From:   Marc Orr <marcorr@google.com>
Date:   Thu, 23 Sep 2021 13:55:00 -0700
Message-ID: <CAA03e5EOb1=ndtroDw=mZgfCBPJ5OOEYLDLBxrBKrhZb=WtWAQ@mail.gmail.com>
Subject: Re: [PATCH Part2 v5 21/45] KVM: SVM: Make AVIC backing, VMSA and VMCB
 memory allocation SNP safe
To:     Brijesh Singh <brijesh.singh@amd.com>
Cc:     "Dr. David Alan Gilbert" <dgilbert@redhat.com>,
        x86 <x86@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
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

On Thu, Sep 23, 2021 at 1:44 PM Brijesh Singh <brijesh.singh@amd.com> wrote:
>
>
> On 9/23/21 2:17 PM, Marc Orr wrote:
>
> >>>> +
> >>>> +struct page *snp_safe_alloc_page(struct kvm_vcpu *vcpu)
> >>>> +{
> >>>> +    unsigned long pfn;
> >>>> +    struct page *p;
> >>>> +
> >>>> +    if (!cpu_feature_enabled(X86_FEATURE_SEV_SNP))
> >>>> +            return alloc_page(GFP_KERNEL_ACCOUNT | __GFP_ZERO);
> > Continuing my other comment, above: if we introduce a
> > `snp_globally_enabled` var, we could use that here, rather than
> > `cpu_feature_enabled(X86_FEATURE_SEV_SNP)`.
>
>
> Maybe I am missing something, what is wrong with
> cpu_feature_enabled(...) check ? It's same as creating a global
> variable. The feature enabled bit is not set if the said is not
> enabled.  See the patch #3 [1] in this series.
>
> [1]
> https://lore.kernel.org/linux-mm/YUN+L0dlFMbC3bd4@zn.tnic/T/#m2ac1242b33abfcd0d9fb22a89f4c103eacf67ea7
>
> thanks

You are right. Patch #3 does exactly what I was asking for in
`snp_rmptable_init()`. Thanks!

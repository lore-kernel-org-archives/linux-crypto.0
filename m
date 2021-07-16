Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.4 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,FSL_HELO_FAKE,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_IN_DEF_DKIM_WL autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1856AC12002
	for <linux-crypto@archiver.kernel.org>; Fri, 16 Jul 2021 20:26:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id EE1CD6120A
	for <linux-crypto@archiver.kernel.org>; Fri, 16 Jul 2021 20:26:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233529AbhGPU3A (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 16 Jul 2021 16:29:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38824 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232172AbhGPU27 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 16 Jul 2021 16:28:59 -0400
Received: from mail-pl1-x62a.google.com (mail-pl1-x62a.google.com [IPv6:2607:f8b0:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7686EC061760
        for <linux-crypto@vger.kernel.org>; Fri, 16 Jul 2021 13:26:03 -0700 (PDT)
Received: by mail-pl1-x62a.google.com with SMTP id d1so5901665plg.0
        for <linux-crypto@vger.kernel.org>; Fri, 16 Jul 2021 13:26:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=8tvSxeWjAmiPV1ecaOaeAqaw4ZJnCIRGxkWGCmBjbA8=;
        b=jIlbt7ooesOkOpbmts5nBhgs9jIU/SiAau352QIY0Hgeubf1kEbT+OcR/XjVd4kT+v
         3fD8lV4szvIhxFXyM+uYYrQGWrg5wBxeuQ2S0VFf48AH+i4/ScDMvZ/wpqxl8XaLtWB1
         5sBw774M3CLXtT+Vj+GS9UQahjyyarePM6P/ZXZBxsr54dQm0m5kpkcDppT69Py56TWs
         57gCQFY57LOuhVvwhFAZTfqiyYlRvDo2aFfrRtqAV3Gj+D7CgmOqL2nfkKqI7gWSNwWP
         Evl25i5YTmPuqDf/s9LZtr9s03mx1pQcAG1vJ40a1kDU8OqGPXFnRlemxj0KkvtmTLYB
         bqPA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=8tvSxeWjAmiPV1ecaOaeAqaw4ZJnCIRGxkWGCmBjbA8=;
        b=B7h13IwZOF0gNGyRsIHlmh+aku7Bx3l3GawGxRoxRiyjuC3OIRQ2V1JIMkH51WRl3G
         WjWJwX7Mq2rV3cXcMGo5Qjybe2RFdma9DAxnildhkZZW53HuCG5IIpbP/Fbge9dlhsiG
         A2DxajiqF/SasoQ88p/pzORl57NryKf57S/Ah4cge9CprG1P6buFYRJetXD9v0GgOasb
         fFXdreZ6owJsuzm2trBSZYpkWvtOix32MeHI2VoPIxgHJ5LeT8F1aXIyhSWLTlH6gv97
         yjt55q+WCpzjYWfSFLyGbyVVoj3e0vlYE6CXlMhFRjXcb0PixosTFtXrfv/TsZA2ZX0J
         4zoQ==
X-Gm-Message-State: AOAM531XpYDjWgZvLV5dlFFNr+Kh7OOsYpQ1MinI6fU2QQMfLYmFuCIz
        azMEjGpHQ1UP0QEkP04yZ+WJGA==
X-Google-Smtp-Source: ABdhPJyV16kybEQiRhFSioiQewGBf027oKkuUbSPAPg4nYD34PcD9PtL9JdNgcXLrSoQ1Ly4eisLjQ==
X-Received: by 2002:a17:90a:4893:: with SMTP id b19mr11380703pjh.45.1626467162727;
        Fri, 16 Jul 2021 13:26:02 -0700 (PDT)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id b15sm11895147pgm.15.2021.07.16.13.26.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 16 Jul 2021 13:26:02 -0700 (PDT)
Date:   Fri, 16 Jul 2021 20:25:58 +0000
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
Subject: Re: [PATCH Part2 RFC v4 31/40] KVM: X86: update page-fault trace to
 log the 64-bit error code
Message-ID: <YPHrVkFJwRsMm9V2@google.com>
References: <20210707183616.5620-1-brijesh.singh@amd.com>
 <20210707183616.5620-32-brijesh.singh@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210707183616.5620-32-brijesh.singh@amd.com>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Wed, Jul 07, 2021, Brijesh Singh wrote:
> The page-fault error code is a 64-bit value, but the trace prints only

It's worth clarifying that #NPT has a 64-bit error code, and so KVM also passes
around a 64-bit PFEC.  E.g. the above statement is wrong for legacy #PF.

> the lower 32-bits. Some of the SEV-SNP RMP fault error codes are
> available in the upper 32-bits.

Can you send this separately with Cc: stable@?  And I guess tweak the changelog
to replace "SEV-SNP RMP" with a reference to e.g. PFERR_GUEST_FINAL_MASK.  KVM
already has error codes that can set the upper bits.

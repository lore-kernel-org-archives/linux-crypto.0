Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,FSL_HELO_FAKE,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_IN_DEF_DKIM_WL autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8A31EC636C8
	for <linux-crypto@archiver.kernel.org>; Tue, 20 Jul 2021 22:31:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7873D611CE
	for <linux-crypto@archiver.kernel.org>; Tue, 20 Jul 2021 22:31:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229795AbhGTVvC (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 20 Jul 2021 17:51:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38692 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229745AbhGTVvB (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 20 Jul 2021 17:51:01 -0400
Received: from mail-pf1-x436.google.com (mail-pf1-x436.google.com [IPv6:2607:f8b0:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 66919C061762
        for <linux-crypto@vger.kernel.org>; Tue, 20 Jul 2021 15:31:39 -0700 (PDT)
Received: by mail-pf1-x436.google.com with SMTP id j199so732409pfd.7
        for <linux-crypto@vger.kernel.org>; Tue, 20 Jul 2021 15:31:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=AUrpqM7EFCXw9fZsFBephub57NHu0f56SMcR8ChIC2w=;
        b=Xf67p1gIpTUa0N9bF53hw4Pso0MHOTykJkzRFBpE6Liqej39JSMiNH/yQGUIUlvrlq
         BIXMpPa7XCxUib8ZcXcNx8kghXf0V3BijM/fTIGAzWNk45BB2s0ZQ4pkvWM8oxYYhfYL
         4+unUB5lFyqAW183cAe1BcUGRmzWZU8tBCzK3VC47os2coH4Lb/Os99Fo9i/2uAmevrk
         TzLsFgcQg0DSOnqLzToknLUTZrAA3BMRS4A1fHCLsRZtGT1XX0znha6Aja3xonwxm0pv
         BYYbRNzfFe1iXBpuuhSQauwXaHJYY58Ml8gw6j3skd4C1vsEYU9AcuHBUQVQnjVAtVMF
         tj8w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=AUrpqM7EFCXw9fZsFBephub57NHu0f56SMcR8ChIC2w=;
        b=sVsWmiCoYOOGcXE5H8DTcw1zr8qEP5fZJgzhIYDPDJv+YPUGR2obGD6H8PCTNq9w3j
         s8QBA1EIjLinM8GcbnWVFOyXR2WpN86oyo+P+2y1EvQrGRXEgShtJP+SU90UcHZ+z2Hz
         GYQ+hbMsJunobV338FU3spxxwlAqEcOQKaZm9IJZukVoWRz2b/AsoL4atLgjC2q/fwSz
         m86Q76LZDB28pGLId+4dSs1/CjQgAOJ5RcHUh94YebFS9gum6DOaEth1q3qg5895ru7u
         zsHXJxVnnWJF9A7pMzEjTs6hpHxvnLu07OEA08mTktg1zr6HBoVp1nWEF7B51NzzN2WP
         n7lQ==
X-Gm-Message-State: AOAM530YUFKdCmp601tbNxtWqFELDvG2PVTUzolJhjBGNqmB8dVh85H7
        xwR+QIPSVvLsFxremsTU5OuEXQ==
X-Google-Smtp-Source: ABdhPJyGCIJWkhxVxYTObBcNLjwnF+6O7AyjvJyweoOlaa1ix7nfiAIzNUmYXM3xG7qIUTl6T+uQxg==
X-Received: by 2002:aa7:804f:0:b029:334:4951:da88 with SMTP id y15-20020aa7804f0000b02903344951da88mr27399387pfm.29.1626820298460;
        Tue, 20 Jul 2021 15:31:38 -0700 (PDT)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id 202sm27151546pfy.198.2021.07.20.15.31.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 20 Jul 2021 15:31:37 -0700 (PDT)
Date:   Tue, 20 Jul 2021 22:31:34 +0000
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
Subject: Re: [PATCH Part2 RFC v4 37/40] KVM: SVM: Add support to handle the
 RMP nested page fault
Message-ID: <YPdOxrIA6o3uymq2@google.com>
References: <20210707183616.5620-1-brijesh.singh@amd.com>
 <20210707183616.5620-38-brijesh.singh@amd.com>
 <YPYUe8hAz5/c7IW9@google.com>
 <bff43050-aed7-011c-89e5-9899bd1df414@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <bff43050-aed7-011c-89e5-9899bd1df414@amd.com>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Tue, Jul 20, 2021, Brijesh Singh wrote:
> 
> On 7/19/21 7:10 PM, Sean Christopherson wrote:
> > On Wed, Jul 07, 2021, Brijesh Singh wrote:
> > > Follow the recommendation from APM2 section 15.36.10 and 15.36.11 to
> > > resolve the RMP violation encountered during the NPT table walk.
> > 
> > Heh, please elaborate on exactly what that recommendation is.  A recommendation
> > isn't exactly architectural, i.e. is subject to change :-)
> 
> I will try to expand it :)
> 
> > 
> > And, do we have to follow the APM's recommendation?
> 
> Yes, unless we want to be very strict on what a guest can do.
> 
> > Specifically, can KVM treat #NPF RMP violations as guest errors, or is that
> > not allowed by the GHCB spec?
> 
> The GHCB spec does not say anything about the #NPF RMP violation error. And
> not all #NPF RMP is a guest error (mainly those size mismatch etc).
> 
> > I.e. can we mandate accesses be preceded by page state change requests?
> 
> This is a good question, the GHCB spec does not enforce that a guest *must*
> use page state. If the page state changes is not done by the guest then it
> will cause #NPF and its up to the hypervisor to decide on what it wants to
> do.

Drat.  Is there any hope of pushing through a GHCB change to require the guest
to use PSC?

> > It would simplify KVM (albeit not much of a simplificiation) and would also
> > make debugging easier since transitions would require an explicit guest
> > request and guest bugs would result in errors instead of random
> > corruption/weirdness.
> 
> I am good with enforcing this from the KVM. But the question is, what fault
> we should inject in the guest when KVM detects that guest has issued the
> page state change.

Injecting a fault, at least from KVM, isn't an option since there's no architectural
behavior we can leverage.  E.g. a guest that isn't enlightened enough to properly
use PSC isn't going to do anything useful with a #MC or #VC.

Sadly, as is I think our only options are to either automatically convert RMP
entries as need, or to punt the exit to userspace.  Maybe we could do both, e.g.
have a module param to control the behavior?  The problem with punting to userspace
is that KVM would also need a way for userspace to fix the issue, otherwise we're
just taking longer to kill the guest :-/

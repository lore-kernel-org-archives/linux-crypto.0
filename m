Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 19F66C433F5
	for <linux-crypto@archiver.kernel.org>; Fri, 15 Oct 2021 20:27:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id ECAB7611C2
	for <linux-crypto@archiver.kernel.org>; Fri, 15 Oct 2021 20:27:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242957AbhJOU3l (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 15 Oct 2021 16:29:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54146 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238594AbhJOU3l (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 15 Oct 2021 16:29:41 -0400
Received: from mail-pl1-x635.google.com (mail-pl1-x635.google.com [IPv6:2607:f8b0:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 56C72C061764
        for <linux-crypto@vger.kernel.org>; Fri, 15 Oct 2021 13:27:34 -0700 (PDT)
Received: by mail-pl1-x635.google.com with SMTP id f21so7098562plb.3
        for <linux-crypto@vger.kernel.org>; Fri, 15 Oct 2021 13:27:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=aaCe1c/Il7mwzazLNOhBGe2zeoY0WJjHVx8W7f1BZpY=;
        b=VHlnVWlZ/Pi2ld0Wgs4bKW4ri4LZhR1mLrjD69QcbOsw5z3yd7R0KP+xvCIFwoCuF6
         45XI8i1uJ89nfB+II5BqxkkMe7Q5HyhfoIve+oqsATzlugEJXT8kZCH8NAuTpdVRpH23
         IckZs4yOSQ3AGBE1qy6aZRWByu55YprOLoPFlSOodj4vA64qeuoxyqkZwXp2VJMbr1ys
         hm8/fjdTMe4NI1MsXOqsPhkmAqOl7Z69QZQc22mmlXVdI8SaBN5ZJyuIXb16u/BUK+vp
         p8jFDDinLpd1p6zcVEI04X9REwumzJqZgZ/8zPyCUeuieKdYE3KHSle5dIxhjLTV3xJj
         RFkQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=aaCe1c/Il7mwzazLNOhBGe2zeoY0WJjHVx8W7f1BZpY=;
        b=CCLxSNfs+mQazKAT+RA9frigWgfN1gZumAHynN3HV2HC40VRSFBrCyIxbdCwtCPDqE
         QzTMFfjwXX5DNeerFHA/Ql/ll+uZMir+R5vNMBhwXQELgyofO1H6cb2WRFRF0mIJr9oB
         30vLrRnoeKeN8KmTlRN006tjpu4Vb3vbIcKzhlACY26I9rwUmusYgwzjRwhfJKgh5Nuz
         qJJBh7nq4IipHmGm2/p4VKmgYqBuJnpre7dAKJhFlwI30g71sh+9pcyvYz8OT4/QmOMH
         HjPzwA8+NPcCSIHmtpiX62iM2OQaoEjZqhm3uVAQyB4fMCquaXjjrJRBs2ntXd/a61kN
         1YDg==
X-Gm-Message-State: AOAM533qrEGhIbnzzLk2NkFarOfnuqAdJ+PcMr9aHhiPBybKSzCKR4fa
        n0R7eIcYE6cW68XoO3qo4WQPYg==
X-Google-Smtp-Source: ABdhPJyMgV4d0MRDRJMTxbsrDlkWbmCHM9MvjK5KFtNvkfUV62+XAfcThk5V8SCnlNHJcjIB0quT5g==
X-Received: by 2002:a17:90a:858e:: with SMTP id m14mr30194808pjn.1.1634329653554;
        Fri, 15 Oct 2021 13:27:33 -0700 (PDT)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id i2sm12231684pjg.48.2021.10.15.13.27.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 15 Oct 2021 13:27:32 -0700 (PDT)
Date:   Fri, 15 Oct 2021 20:27:29 +0000
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
Subject: Re: [PATCH Part2 v5 05/45] x86/sev: Add helper functions for
 RMPUPDATE and PSMASH instruction
Message-ID: <YWnkMXdL89AHPF10@google.com>
References: <20210820155918.7518-1-brijesh.singh@amd.com>
 <20210820155918.7518-6-brijesh.singh@amd.com>
 <YWnC++azH3xXrMm6@google.com>
 <3fc1b403-73a1-cf2e-2990-66d2c1ecdfa3@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3fc1b403-73a1-cf2e-2990-66d2c1ecdfa3@amd.com>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Fri, Oct 15, 2021, Brijesh Singh wrote:
> On 10/15/21 1:05 PM, Sean Christopherson wrote:
> > On Fri, Aug 20, 2021, Brijesh Singh wrote:
> >> +	if (!cpu_feature_enabled(X86_FEATURE_SEV_SNP))
> > Shouldn't this be a WARN_ON_ONCE()?
> 
> Since some of these function are called while handling the PSC so I
> tried to avoid using the WARN -- mainly because if the warn_on_panic=1
> is set on the host then it will result in the kernel panic.

But why would KVM be handling PSC requests if SNP is disabled?

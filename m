Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D1188C4338F
	for <linux-crypto@archiver.kernel.org>; Fri, 13 Aug 2021 15:21:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B55A260C3E
	for <linux-crypto@archiver.kernel.org>; Fri, 13 Aug 2021 15:21:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242258AbhHMPVq (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 13 Aug 2021 11:21:46 -0400
Received: from mail.skyhub.de ([5.9.137.197]:45724 "EHLO mail.skyhub.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S242428AbhHMPS4 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 13 Aug 2021 11:18:56 -0400
Received: from zn.tnic (p200300ec2f0a0d0070a51027a6cfb94b.dip0.t-ipconnect.de [IPv6:2003:ec:2f0a:d00:70a5:1027:a6cf:b94b])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.skyhub.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 1C9EF1EC01A8;
        Fri, 13 Aug 2021 17:18:24 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=dkim;
        t=1628867904;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:in-reply-to:in-reply-to:  references:references;
        bh=dczs9anjttgTzg/uu954njfB+GeLW6EkJBQxK9xBxd4=;
        b=L/xLFyvayZt+LUhW0u37pNjr5TvN/IZS0NT7BC2ZchY0z8mCo1k21N4EQspJmckwmuuhss
        T45E+ksx/nZm1PMKqxifajMY4nDrPCT9cddbwmrlZwnULH4s3cD8uXP2K1GUDLby/MHaGt
        rXDLK1x/miuXg83W0A5qvXiGhosDp94=
Date:   Fri, 13 Aug 2021 17:19:07 +0200
From:   Borislav Petkov <bp@alien8.de>
To:     Brijesh Singh <brijesh.singh@amd.com>
Cc:     x86@kernel.org, linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        linux-efi@vger.kernel.org, platform-driver-x86@vger.kernel.org,
        linux-coco@lists.linux.dev, linux-mm@kvack.org,
        linux-crypto@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
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
        Michael Roth <michael.roth@amd.com>,
        Vlastimil Babka <vbabka@suse.cz>, tony.luck@intel.com,
        brijesh.ksingh@gmail.com
Subject: Re: [PATCH Part1 RFC v4 09/36] x86/compressed: Add helper for
 validating pages in the decompression stage
Message-ID: <YRaNa7Mo+J7wQZFF@zn.tnic>
References: <20210707181506.30489-1-brijesh.singh@amd.com>
 <20210707181506.30489-10-brijesh.singh@amd.com>
 <YRZIA+qQ7EpO0zxC@zn.tnic>
 <c519e685-5447-1847-2c97-99c5fcbbaa15@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <c519e685-5447-1847-2c97-99c5fcbbaa15@amd.com>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Fri, Aug 13, 2021 at 09:21:14AM -0500, Brijesh Singh wrote:
> > Also get rid of eccessive defines...
> 
> I am getting conflicting review comments on function naming, comment style,
> macro etc. While addressing the feedback I try to incorporate all those
> comments, lets see how I do in next rev.

What do you mean? Example?

With "Also get rid of eccessive defines..." I mean this here from
earlier this week:

https://lkml.kernel.org/r/YRJOkQe0W9/HyjjQ@zn.tnic

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette

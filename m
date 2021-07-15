Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.4 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,FSL_HELO_FAKE,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_IN_DEF_DKIM_WL autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2C1B3C636C8
	for <linux-crypto@archiver.kernel.org>; Thu, 15 Jul 2021 19:53:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 13FA661073
	for <linux-crypto@archiver.kernel.org>; Thu, 15 Jul 2021 19:53:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344847AbhGOT4R (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 15 Jul 2021 15:56:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42314 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346388AbhGOTvU (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 15 Jul 2021 15:51:20 -0400
Received: from mail-pg1-x52b.google.com (mail-pg1-x52b.google.com [IPv6:2607:f8b0:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0A4EDC05BD35
        for <linux-crypto@vger.kernel.org>; Thu, 15 Jul 2021 12:18:21 -0700 (PDT)
Received: by mail-pg1-x52b.google.com with SMTP id a6so224396pgw.3
        for <linux-crypto@vger.kernel.org>; Thu, 15 Jul 2021 12:18:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=elaxZZafDjVLiuc49owUeZ0204o65amFxOUC2qpgTKs=;
        b=Q5HupHoPS4LdRZjI9aLLpJl+EXOusDVJvjG4Iz0vi484LYzH9bZJ+UVYAPgxON53tD
         3HUhZR3sPDonrp6Rx9HVRmHE8bwdJDYe3XLJrkaVZXuJgNA1I9br3fWYQH0NR8D1K4Bh
         wpY5QEoNAb+x/8n9tWtUWQ3oLRqyDIIHHMOiw2yPQ7Z+1WXGx+r3bT61UMlsD+Gt9KvD
         wSosGIOovnI5kM/c/4ZOB1p0adgb7KpSr/rm6WtHEv8nbN2mbwno03HSeDBR3602UD+d
         /PViOtSgang4WUW2+i6djc478rpbuJrqWD+lJ9Dy+1oTIcTKK+8C3zjn8Ias8jxuPdd5
         sHkQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=elaxZZafDjVLiuc49owUeZ0204o65amFxOUC2qpgTKs=;
        b=TVvnXxw1plWf63BRuvahANwSJM+AhdOfyH8PhdGe7HGFQUpXvKGZjjV5FEMscpovtB
         2V/NqQ9ASM9iim4YI8+EmOpcec3Gth0WDkQJR3PaOjggJv5UVjIZN9kP6X7PMKfnp+w6
         KLxX4feGlZjRK976mS9bWeEghnHcrNeE2Hl+Ing7qyZcPweioKFx/XOxxEOAmlON3hWw
         ATIGHtnl02PCsfmg/X3KAMCJ28MldpO9sZ21esahNe6BW+2yvMFrSDEobAz5RyNF/5c0
         r9W5/EY+OJvpATHZo1WWjUPlNHgNJcoB3RADx+GwoPFv7x2niqKcJ3gHztcmkOpVhZp8
         J3mA==
X-Gm-Message-State: AOAM532a0yh7PYEyZuvRkuVShdXDeUNHzbXyt4KPjz0SagNA1Gec21IT
        293AApTzFIXcmhG2/EMA83Hd1w==
X-Google-Smtp-Source: ABdhPJxs5P265vYYEPGZ8x+HkOKGVsrc3wav0sXpzToNYrqG5Ockpl2xyO49rMlEI8CkyKvDo3JDEA==
X-Received: by 2002:a05:6a00:d5f:b029:32c:7264:2f65 with SMTP id n31-20020a056a000d5fb029032c72642f65mr6181751pfv.40.1626376700235;
        Thu, 15 Jul 2021 12:18:20 -0700 (PDT)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id i12sm6029283pjj.9.2021.07.15.12.18.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 15 Jul 2021 12:18:19 -0700 (PDT)
Date:   Thu, 15 Jul 2021 19:18:15 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Dave Hansen <dave.hansen@intel.com>
Cc:     Peter Gonda <pgonda@google.com>,
        Brijesh Singh <brijesh.singh@amd.com>, x86@kernel.org,
        linux-kernel@vger.kernel.org, kvm list <kvm@vger.kernel.org>,
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
        Sergio Lopez <slp@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>,
        David Rientjes <rientjes@google.com>,
        Dov Murik <dovmurik@linux.ibm.com>,
        Tobin Feldman-Fitzthum <tobin@ibm.com>,
        Borislav Petkov <bp@alien8.de>,
        Michael Roth <michael.roth@amd.com>,
        Vlastimil Babka <vbabka@suse.cz>, tony.luck@intel.com,
        Nathaniel McCallum <npmccallum@redhat.com>,
        brijesh.ksingh@gmail.com
Subject: Re: [PATCH Part2 RFC v4 06/40] x86/sev: Add helper functions for
 RMPUPDATE and PSMASH instruction
Message-ID: <YPCJ95ABlMjxnDWX@google.com>
References: <20210707183616.5620-1-brijesh.singh@amd.com>
 <20210707183616.5620-7-brijesh.singh@amd.com>
 <CAMkAt6quzRMiEJ=iYDocRvpaYuNcV5vm=swbowK+KG=j7FjyKA@mail.gmail.com>
 <8ab309cd-8465-d543-55c8-5f6529fe74fd@intel.com>
 <YPCE5D6h7V0iZiX/@google.com>
 <a00bb4f7-ab06-5773-8c8b-3540c75b257a@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a00bb4f7-ab06-5773-8c8b-3540c75b257a@intel.com>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Thu, Jul 15, 2021, Dave Hansen wrote:
> On 7/15/21 11:56 AM, Sean Christopherson wrote:
> >>>> +       /* Retry if another processor is modifying the RMP entry. */
> >>>> +       do {
> >>>> +               /* Binutils version 2.36 supports the PSMASH mnemonic. */
> >>>> +               asm volatile(".byte 0xF3, 0x0F, 0x01, 0xFF"
> >>>> +                             : "=a"(ret)
> >>>> +                             : "a"(spa)
> >>>> +                             : "memory", "cc");
> >>>> +       } while (ret == FAIL_INUSE);
> >>> Should there be some retry limit here for safety? Or do we know that
> >>> we'll never be stuck in this loop? Ditto for the loop in rmpupdate.
> >> It's probably fine to just leave this.  While you could *theoretically*
> >> lose this race forever, it's unlikely to happen in practice.  If it
> >> does, you'll get an easy-to-understand softlockup backtrace which should
> >> point here pretty quickly.
> > But should failure here even be tolerated?  The TDX cases spin on flows that are
> > _not_ due to (direct) contenion, e.g. a pending interrupt while flushing the
> > cache or lack of randomness when generating a key.  In this case, there are two
> > CPUs racing to modify the RMP entry, which implies that the final state of the
> > RMP entry is not deterministic.
> 
> I was envisioning that two different CPUs could try to smash two
> *different* 4k physical pages, but collide since they share
> a 2M page.
> 
> But, in patch 33, this is called via:
> 
> > +		write_lock(&kvm->mmu_lock);
> > +
> > +		switch (op) {
> > +		case SNP_PAGE_STATE_SHARED:
> > +			rc = snp_make_page_shared(vcpu, gpa, pfn, level);
> ...
> 
> Which should make collisions impossible.  Did I miss another call-site?

Ya, there's more, e.g. sev_snp_write_page_begin() and snp_handle_rmp_page_fault(),
both of which run without holding mmu_lock.  The PSMASH operation isn't too
concerning, but the associated RMPUDATE is most definitely a concern, e.g. if two
vCPUs are trying to access different variants of a page.  It's ok if KVM's
"response" in such a situation does weird things to the guest, but one of the
two operations should "win", which I don't think is guaranteed if multiple RMP
violations are racing.

I'll circle back to this patch after I've gone through the KVM MMU changes.

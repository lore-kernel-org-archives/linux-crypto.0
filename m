Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B9E00C433EF
	for <linux-crypto@archiver.kernel.org>; Tue, 16 Nov 2021 05:41:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9330661B6F
	for <linux-crypto@archiver.kernel.org>; Tue, 16 Nov 2021 05:41:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235839AbhKPFoi (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 16 Nov 2021 00:44:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59548 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235808AbhKPFod (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 16 Nov 2021 00:44:33 -0500
Received: from mail-oo1-xc29.google.com (mail-oo1-xc29.google.com [IPv6:2607:f8b0:4864:20::c29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E4E4EC0432D4
        for <linux-crypto@vger.kernel.org>; Mon, 15 Nov 2021 19:07:34 -0800 (PST)
Received: by mail-oo1-xc29.google.com with SMTP id v30-20020a4a315e000000b002c52d555875so5691189oog.12
        for <linux-crypto@vger.kernel.org>; Mon, 15 Nov 2021 19:07:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=rHziY9MThdsUNbYFgXYuXj5jMHTBoTLoLQxrdrvoiAk=;
        b=HvUx4r3xINAZEtOROqeuKRhlbW+/zG0NpUk0OZwxaGuFgkVz7b9D5OXqbQEHEDa1JH
         gl0wwTp3vUH/2jeiNj43WuDEEkizorNCLQz53j98wmlhmqf1xb/KyzYtAojlrrh5n+9Z
         o1IyI+pfOAP8QLYXsJrRMzmEanQODhtK+IsKRbg0EjU7hUNZSz9IEXTFQFCEyrvKCQBE
         DeATNN+4SLAAg6oEkaYVk92VGGMKsZDvcaq7df28KDLA5EdtfH7iRa+omgP6nND0TwCz
         G+QVlL6WKzcsJhnplGZns/wzkF/cZ3zxOdgdafMdR076rdhqH3Uktufgk+qaq3Vu44VW
         7gyw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=rHziY9MThdsUNbYFgXYuXj5jMHTBoTLoLQxrdrvoiAk=;
        b=VceJHPkVpyznq+G562pMC2colnfDtAyR6ZY7Tz1xWEhCrJk7sSUUGhgs5mLJCFCbXw
         Hmf59aluoGwVbc/DygFUS6fSkCK41BD6rQuHSjBM9nshUFEwcesFmfNzIBFVALMp4Pqd
         g2ViKYb/J6YSQau6s8Zj7EP82qQ+/T/mddP7VYiyoOQkK2nRBshZr/58C5iIJgG8rBTO
         mQGjWSNiRADfw1aLIHGiKBMTqco7uBQN5yBbhTtEjrjmyi4fnbqLReFxL1mm/9dLwwiN
         7DufDay9L5Ay1cB9pitX8ya0g+f5LTdHK2xtdulf9OQquG5OFCroCL6MISlPsRbEHjGa
         yIqQ==
X-Gm-Message-State: AOAM530E+MNLLSOC/GSREhe87h33TlgQjBbO8RlwtTgJG9f7DbdO0L1d
        7WrIAKfXOUfh3dU0RvfYukL7Mr94zr8fzrfhjGOFVA==
X-Google-Smtp-Source: ABdhPJzJfVFQI5w6yeOBFiEuBQDiYeXmqsR6pz3fPWeT0OmBWY+Td9tl6y0Bq9rJAQr5ON5m3ssAYi/A/1dCsv8hzpQ=
X-Received: by 2002:a4a:b501:: with SMTP id r1mr2023604ooo.20.1637032053949;
 Mon, 15 Nov 2021 19:07:33 -0800 (PST)
MIME-Version: 1.0
References: <20210820155918.7518-1-brijesh.singh@amd.com> <CAMkAt6o0ySn1=iLYsH0LCnNARrUbfaS0cvtxB__y_d+Q6DUzfA@mail.gmail.com>
 <061ccd49-3b9f-d603-bafd-61a067c3f6fa@intel.com> <YY6z5/0uGJmlMuM6@zn.tnic>
 <YY7FAW5ti7YMeejj@google.com> <YZJTA1NyLCmVtGtY@work-vm> <YZKmSDQJgCcR06nE@google.com>
 <CAA03e5E3Rvx0t8_ZrbNMZwBkjPivGKOg5HCShSFYwfkKDDHWtA@mail.gmail.com> <YZKxuxZurFW6BVZJ@google.com>
In-Reply-To: <YZKxuxZurFW6BVZJ@google.com>
From:   Marc Orr <marcorr@google.com>
Date:   Mon, 15 Nov 2021 19:07:22 -0800
Message-ID: <CAA03e5GBajwRJBuTJLPjji7o8QD2daEUJU7DpPJBxtWsf-DE8g@mail.gmail.com>
Subject: Re: [PATCH Part2 v5 00/45] Add AMD Secure Nested Paging (SEV-SNP)
 Hypervisor Support
To:     Sean Christopherson <seanjc@google.com>
Cc:     "Dr. David Alan Gilbert" <dgilbert@redhat.com>,
        Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@intel.com>,
        Peter Gonda <pgonda@google.com>,
        Brijesh Singh <brijesh.singh@amd.com>, x86@kernel.org,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        linux-coco@lists.linux.dev, linux-mm@kvack.org,
        linux-crypto@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Joerg Roedel <jroedel@suse.de>,
        Tom Lendacky <Thomas.Lendacky@amd.com>,
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
        Michael Roth <Michael.Roth@amd.com>,
        Vlastimil Babka <vbabka@suse.cz>,
        "Kirill A . Shutemov" <kirill@shutemov.name>,
        Andi Kleen <ak@linux.intel.com>, tony.luck@intel.com,
        sathyanarayanan.kuppuswamy@linux.intel.com,
        Marc Zyngier <maz@kernel.org>, Will Deacon <will@kernel.org>,
        Quentin Perret <qperret@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Mon, Nov 15, 2021 at 11:15 AM Sean Christopherson <seanjc@google.com> wrote:
>
> +arm64 KVM folks
>
> On Mon, Nov 15, 2021, Marc Orr wrote:
> > On Mon, Nov 15, 2021 at 10:26 AM Sean Christopherson <seanjc@google.com> wrote:
> > >
> > > On Mon, Nov 15, 2021, Dr. David Alan Gilbert wrote:
> > > > * Sean Christopherson (seanjc@google.com) wrote:
> > > > > On Fri, Nov 12, 2021, Borislav Petkov wrote:
> > > > > > On Fri, Nov 12, 2021 at 09:59:46AM -0800, Dave Hansen wrote:
> > > > > > > Or, is there some mechanism that prevent guest-private memory from being
> > > > > > > accessed in random host kernel code?
> > > > >
> > > > > Or random host userspace code...
> > > > >
> > > > > > So I'm currently under the impression that random host->guest accesses
> > > > > > should not happen if not previously agreed upon by both.
> > > > >
> > > > > Key word "should".
> > > > >
> > > > > > Because, as explained on IRC, if host touches a private guest page,
> > > > > > whatever the host does to that page, the next time the guest runs, it'll
> > > > > > get a #VC where it will see that that page doesn't belong to it anymore
> > > > > > and then, out of paranoia, it will simply terminate to protect itself.
> > > > > >
> > > > > > So cloud providers should have an interest to prevent such random stray
> > > > > > accesses if they wanna have guests. :)
> > > > >
> > > > > Yes, but IMO inducing a fault in the guest because of _host_ bug is wrong.
> > > >
> > > > Would it necessarily have been a host bug?  A guest telling the host a
> > > > bad GPA to DMA into would trigger this wouldn't it?
> > >
> > > No, because as Andy pointed out, host userspace must already guard against a bad
> > > GPA, i.e. this is just a variant of the guest telling the host to DMA to a GPA
> > > that is completely bogus.  The shared vs. private behavior just means that when
> > > host userspace is doing a GPA=>HVA lookup, it needs to incorporate the "shared"
> > > state of the GPA.  If the host goes and DMAs into the completely wrong HVA=>PFN,
> > > then that is a host bug; that the bug happened to be exploited by a buggy/malicious
> > > guest doesn't change the fact that the host messed up.
> >
> > "If the host goes and DMAs into the completely wrong HVA=>PFN, then
> > that is a host bug; that the bug happened to be exploited by a
> > buggy/malicious guest doesn't change the fact that the host messed
> > up."
> > ^^^
> > Again, I'm flabbergasted that you are arguing that it's OK for a guest
> > to exploit a host bug to take down host-side processes or the host
> > itself, either of which could bring down all other VMs on the machine.
> >
> > I'm going to repeat -- this is not OK! Period.
>
> Huh?  At which point did I suggest it's ok to ship software with bugs?  Of course
> it's not ok to introduce host bugs that let the guest crash the host (or host
> processes).  But _if_ someone does ship buggy host software, it's not like we can
> wave a magic wand and stop the guest from exploiting the bug.  That's why they're
> such a big deal.
>
> Yes, in this case a very specific flavor of host userspace bug could be morphed
> into a guest exception, but as mentioned ad nauseum, _if_ host userspace has bug
> where it does not properly validate a GPA=>HVA, then any such bug exists and is
> exploitable today irrespective of SNP.

If I'm understanding you correctly, you're saying that we will never
get into the host's page fault handler due to an RMP violation if we
implement the unmapping guest private memory proposal (without bugs).

However, bugs do happen. And the host-side page fault handler will
have code to react to an RMP violation (even if it's supposedly
impossible to hit). I'm saying that the host-side page fault handler
should NOT handle an RMP violation by killing host-side processes or
the kernel itself. This is detrimental to host reliability.

There are two ways to handle this. (1) Convert the private page
causing the RMP violation to shared, (2) Kill the guest.

Converting the private page to shared is a good solution in SNP's
threat model. And overall, it's better for debuggability than
immediately terminating the guest.

> > Again, if the community wants to layer some orchestration scheme
> > between host userspace, host kernel, and guest, on top of the code to
> > inject the #VC into the guest, that's fine. This proposal is not
> > stopping that. In fact, the two approaches are completely orthogonal
> > and compatible.
> >
> > But so far I have heard zero reasons why injecting a #VC into the
> > guest is wrong. Other than just stating that it's wrong.
>
> It creates a new attack surface, e.g. if the guest mishandles the #VC and does
> PVALIDATE on memory that it previously accepted, then userspace can attack the
> guest by accessing guest private memory to coerce the guest into consuming corrupted
> data.

We should handle RMP violations as best possible from within the
host-side page fault handler, independent of the proposal to unmap
private guest memory for all CVM architectures. Otherwise, if someone
figures out how to trigger an RMP violation by writing guest private
memory (despite unmapping guest private memory's goal to make this
impossible), the attack surface has now increased. Because now we're
either killing host processes or the kernel. Which is worse than
killing the single guest.

Second, I don't think it's correct to say that the host-side
implementation changes the attack surface. The guest must already be
hardened against host-side bugs and attacks. From the guest's
perspective, the attack surface is the same. Also, unmapping private
guest memory is going to require coordination across host userspace,
host kernel, and guest. That's a lot of code. And typically more code
means more attack surface. That being said, if all that code is
implemented perfectly, you might be right, that unmapping guest
private memory makes it harder for the host to attack the guest. But I
think it's a moot point. Because in the end, converting the page from
private to shared is entirely reasonable to solve this problem for
SNP, and we should be doing it irregardless, even if we do get
unmapping private memory working on SNP.

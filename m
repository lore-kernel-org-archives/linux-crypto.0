Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B8649C433F5
	for <linux-crypto@archiver.kernel.org>; Tue, 16 Nov 2021 00:31:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A6F0F619E1
	for <linux-crypto@archiver.kernel.org>; Tue, 16 Nov 2021 00:31:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240189AbhKPAeH (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 15 Nov 2021 19:34:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36734 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344946AbhKOTZr (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 15 Nov 2021 14:25:47 -0500
Received: from mail-oi1-x22f.google.com (mail-oi1-x22f.google.com [IPv6:2607:f8b0:4864:20::22f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 11790C096769
        for <linux-crypto@vger.kernel.org>; Mon, 15 Nov 2021 10:41:27 -0800 (PST)
Received: by mail-oi1-x22f.google.com with SMTP id t19so36780808oij.1
        for <linux-crypto@vger.kernel.org>; Mon, 15 Nov 2021 10:41:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=DvmCs80nJQRJulfMPNgITfN/kpc9dv/WOKQeVjWwio4=;
        b=D2Mt+z865FvjQUumFXEdNURlsU2N9UC/MMmG8rlUqPypkNsBqmKRw0im+95vMwMZt+
         lOyHOqJBT2Wf61emETZgh/H8MwFKn+7mxNspVDUE3ab/thq8z8MqaNv5E3cFC88Dhb1D
         kozJOtu5iF3U6ReVV+IClUxB/KJuaaQOSaFzBpZV/RSinsd98IOm4cNGt+PpulbFPi4G
         fh0anmlEfno22cJKa2/xdP2buGHXZVvlyBs3T5g9PgR1ul84hlgBs7kIQv+hZicSWIx/
         DFY+BXoYlqwxk1FLb90BO7ox0VLE0OsYnIeGGKqSrw6S20pm4gRfEwAzqEUKSDwO5qAw
         9xyQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=DvmCs80nJQRJulfMPNgITfN/kpc9dv/WOKQeVjWwio4=;
        b=KDc1yGDSiLddSjF0cjbk6xni0ncsfg/ghVtedYKRmGwTVxcN8aiiWLoBuMUHSzLMGS
         ceZqcuoFmwM/1MSBQ/UzonZQCCgWuVi7wMKbbu0GpWsyV5BJMEi417E9MibmipVZadFn
         v3li54hJ34CcldY2177t+LTLZd9oCQR4Lmn4myMh7GYCs7ofV7E9nca/8TkWx0aTCadf
         i1yRYOh+S6BPppBYpCWGGu17b4jQYzns8nvulgwVNQX2CNeWdwYVCrlMZslGvtVkGLtx
         Aivr9dap85MfuZgnB23wguiUsjBnaKlaDtfxueJnDC4cjNUiUNcP/8GWrYIwCkXEgIP0
         QdMQ==
X-Gm-Message-State: AOAM533vAvDpQa7eDpeF+AeDD7/QH+odrxCO3xq8DQ9v0uxCFD69uFdM
        K4kU8147+aEHhQbBvZ01xrYC47oSCjXLieFsDHwzfg==
X-Google-Smtp-Source: ABdhPJw+kw8Q07aUefBFMr3P/o64UhYLq5zXtIiaN0731ps80GxSYVXnY4M15E2ojpsZr+HhuXIh46aqRnH7y2V4Jys=
X-Received: by 2002:a54:4515:: with SMTP id l21mr746806oil.15.1637001686230;
 Mon, 15 Nov 2021 10:41:26 -0800 (PST)
MIME-Version: 1.0
References: <20210820155918.7518-1-brijesh.singh@amd.com> <CAMkAt6o0ySn1=iLYsH0LCnNARrUbfaS0cvtxB__y_d+Q6DUzfA@mail.gmail.com>
 <061ccd49-3b9f-d603-bafd-61a067c3f6fa@intel.com> <YY6z5/0uGJmlMuM6@zn.tnic>
 <YY7FAW5ti7YMeejj@google.com> <YZJTA1NyLCmVtGtY@work-vm> <YZKmSDQJgCcR06nE@google.com>
In-Reply-To: <YZKmSDQJgCcR06nE@google.com>
From:   Marc Orr <marcorr@google.com>
Date:   Mon, 15 Nov 2021 10:41:15 -0800
Message-ID: <CAA03e5E3Rvx0t8_ZrbNMZwBkjPivGKOg5HCShSFYwfkKDDHWtA@mail.gmail.com>
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
        sathyanarayanan.kuppuswamy@linux.intel.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Mon, Nov 15, 2021 at 10:26 AM Sean Christopherson <seanjc@google.com> wrote:
>
> On Mon, Nov 15, 2021, Dr. David Alan Gilbert wrote:
> > * Sean Christopherson (seanjc@google.com) wrote:
> > > On Fri, Nov 12, 2021, Borislav Petkov wrote:
> > > > On Fri, Nov 12, 2021 at 09:59:46AM -0800, Dave Hansen wrote:
> > > > > Or, is there some mechanism that prevent guest-private memory from being
> > > > > accessed in random host kernel code?
> > >
> > > Or random host userspace code...
> > >
> > > > So I'm currently under the impression that random host->guest accesses
> > > > should not happen if not previously agreed upon by both.
> > >
> > > Key word "should".
> > >
> > > > Because, as explained on IRC, if host touches a private guest page,
> > > > whatever the host does to that page, the next time the guest runs, it'll
> > > > get a #VC where it will see that that page doesn't belong to it anymore
> > > > and then, out of paranoia, it will simply terminate to protect itself.
> > > >
> > > > So cloud providers should have an interest to prevent such random stray
> > > > accesses if they wanna have guests. :)
> > >
> > > Yes, but IMO inducing a fault in the guest because of _host_ bug is wrong.
> >
> > Would it necessarily have been a host bug?  A guest telling the host a
> > bad GPA to DMA into would trigger this wouldn't it?
>
> No, because as Andy pointed out, host userspace must already guard against a bad
> GPA, i.e. this is just a variant of the guest telling the host to DMA to a GPA
> that is completely bogus.  The shared vs. private behavior just means that when
> host userspace is doing a GPA=>HVA lookup, it needs to incorporate the "shared"
> state of the GPA.  If the host goes and DMAs into the completely wrong HVA=>PFN,
> then that is a host bug; that the bug happened to be exploited by a buggy/malicious
> guest doesn't change the fact that the host messed up.

"If the host goes and DMAs into the completely wrong HVA=>PFN, then
that is a host bug; that the bug happened to be exploited by a
buggy/malicious guest doesn't change the fact that the host messed
up."
^^^
Again, I'm flabbergasted that you are arguing that it's OK for a guest
to exploit a host bug to take down host-side processes or the host
itself, either of which could bring down all other VMs on the machine.

I'm going to repeat -- this is not OK! Period.

Again, if the community wants to layer some orchestration scheme
between host userspace, host kernel, and guest, on top of the code to
inject the #VC into the guest, that's fine. This proposal is not
stopping that. In fact, the two approaches are completely orthogonal
and compatible.

But so far I have heard zero reasons why injecting a #VC into the
guest is wrong. Other than just stating that it's wrong.

Again, the guest must be able to detect buggy and malicious host-side
writes to private memory. Or else "confidential computing" doesn't
work. Assuming that's not true is not a valid argument to dismiss
injecting a #VC exception into the guest.

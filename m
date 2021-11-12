Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5070DC433EF
	for <linux-crypto@archiver.kernel.org>; Fri, 12 Nov 2021 21:30:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2E581610FC
	for <linux-crypto@archiver.kernel.org>; Fri, 12 Nov 2021 21:30:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235702AbhKLVda (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 12 Nov 2021 16:33:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52400 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235700AbhKLVda (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 12 Nov 2021 16:33:30 -0500
Received: from mail-ot1-x32e.google.com (mail-ot1-x32e.google.com [IPv6:2607:f8b0:4864:20::32e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1CC73C061766
        for <linux-crypto@vger.kernel.org>; Fri, 12 Nov 2021 13:30:39 -0800 (PST)
Received: by mail-ot1-x32e.google.com with SMTP id a23-20020a9d4717000000b0056c15d6d0caso8675122otf.12
        for <linux-crypto@vger.kernel.org>; Fri, 12 Nov 2021 13:30:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=+vmT47JswBq7qxvW2mmjE/g946I5saxbuX5b7gNLFL4=;
        b=D+gcCXh1f960budU8lRnqkEeApuI8XhOqtSVvs0dvBafahJkfh0OCX/v6oi/L8uoIW
         h0ADo3uvGEiLXn1ziPjvl9m3NKy8i2nrGKIggbclcW73xbKNNvuhwTbPubCSDReUis3c
         eIrpTM53tPPkO6JjyiG+rasTsXGxT6j7LwGtTz0Rnpj2ZRHB4l6QGMWQXelwdpSTtS+M
         QEqML6xNRvBqkTktfaXaPii0CI20inBmaYdX4SSk2vXeTV+TI2ekReL3GTR2Jo8Txurw
         Bzu5soH9DfgA2BLQiucG2RibYEFf4Ht0LphtU4tl7FvlSOabHfHCqnoLbj7IQ0xlIJTV
         AQyw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=+vmT47JswBq7qxvW2mmjE/g946I5saxbuX5b7gNLFL4=;
        b=TrqpTCtf74MqhoO4pamQ1KcvYEdDaZjgR30Fkh14ebhhOoj92ePZtEKXvjjBT8ZzvF
         gDOn8uaw0rAeL8qa8T5SXIkSN7acFnyljahCehX9PwGI/XHvSOlcTHcFEYNjmiqvPd43
         2r8d5MZp708ozu2RpvEF7vU7ue5ZF1TM4XZGcKBdVcquct8Nae4paBFi7w9NnwCqZ00m
         WafNuTYlfbvEdKpZfTS5abm9Z26MRZwJuDcDcrcunLOjw1Ndkck9o2oPM9akIUA3zJxJ
         j+ssYqCOlvGhJtrH/Q2EHdFfGoquC4Xwo9rQjhUlOKvST4GfUW9jUvjjGzwLyngCtLyJ
         8oqA==
X-Gm-Message-State: AOAM532vOnlOOC/oA2nIMK2qUx5vmw1XmhvI+V8aeTFl6CgyTaomwVae
        /Wah3PhOigRa85wQTJa3qpaFM/f0mSs4WkXYlFUFSg==
X-Google-Smtp-Source: ABdhPJyx1AWCSNjtqlponw22EGcsSL4a/s3aR2bIU6ixr3xAwW099I1ZHWbBZZx2PhIrAjcNg3Rs+YuMZQEXWd8m6is=
X-Received: by 2002:a9d:ed6:: with SMTP id 80mr14812790otj.35.1636752638202;
 Fri, 12 Nov 2021 13:30:38 -0800 (PST)
MIME-Version: 1.0
References: <20210820155918.7518-1-brijesh.singh@amd.com> <CAMkAt6o0ySn1=iLYsH0LCnNARrUbfaS0cvtxB__y_d+Q6DUzfA@mail.gmail.com>
 <061ccd49-3b9f-d603-bafd-61a067c3f6fa@intel.com> <YY6z5/0uGJmlMuM6@zn.tnic>
 <YY7FAW5ti7YMeejj@google.com> <YY7I6sgqIPubTrtA@zn.tnic> <YY7Qp8c/gTD1rT86@google.com>
In-Reply-To: <YY7Qp8c/gTD1rT86@google.com>
From:   Marc Orr <marcorr@google.com>
Date:   Fri, 12 Nov 2021 13:30:27 -0800
Message-ID: <CAA03e5GwHMPYHHq3Nkkq1HnEJUUsw-Vk+5wFCott3pmJY7WuAw@mail.gmail.com>
Subject: Re: [PATCH Part2 v5 00/45] Add AMD Secure Nested Paging (SEV-SNP)
 Hypervisor Support
To:     Sean Christopherson <seanjc@google.com>
Cc:     Borislav Petkov <bp@alien8.de>,
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

On Fri, Nov 12, 2021 at 12:38 PM Sean Christopherson <seanjc@google.com> wrote:
>
> On Fri, Nov 12, 2021, Borislav Petkov wrote:
> > On Fri, Nov 12, 2021 at 07:48:17PM +0000, Sean Christopherson wrote:
> > > Yes, but IMO inducing a fault in the guest because of _host_ bug is wrong.
> >
> > What do you suggest instead?
>
> Let userspace decide what is mapped shared and what is mapped private.  The kernel
> and KVM provide the APIs/infrastructure to do the actual conversions in a thread-safe
> fashion and also to enforce the current state, but userspace is the control plane.
>
> It would require non-trivial changes in userspace if there are multiple processes
> accessing guest memory, e.g. Peter's networking daemon example, but it _is_ fully
> solvable.  The exit to userspace means all three components (guest, kernel,
> and userspace) have full knowledge of what is shared and what is private.  There
> is zero ambiguity:
>
>   - if userspace accesses guest private memory, it gets SIGSEGV or whatever.
>   - if kernel accesses guest private memory, it does BUG/panic/oops[*]
>   - if guest accesses memory with the incorrect C/SHARED-bit, it gets killed.
>
> This is the direction KVM TDX support is headed, though it's obviously still a WIP.
>
> And ideally, to avoid implicit conversions at any level, hardware vendors' ABIs
> define that:
>
>   a) All convertible memory, i.e. RAM, starts as private.
>   b) Conversions between private and shared must be done via explicit hypercall.
>
> Without (b), userspace and thus KVM have to treat guest accesses to the incorrect
> type as implicit conversions.
>
> [*] Sadly, fully preventing kernel access to guest private is not possible with
>     TDX, especially if the direct map is left intact.  But maybe in the future
>     TDX will signal a fault instead of poisoning memory and leaving a #MC mine.

In this proposal, consider a guest driver instructing a device to DMA
write a 1 GB memory buffer. A well-behaved guest driver will ensure
that the entire 1 GB is marked shared. But what about a malicious or
buggy guest? Let's assume a bad guest driver instructs the device to
write guest private memory.

So now, the virtual device, which might be implemented as some host
side process, needs to (1) check and lock all 4k constituent RMP
entries (so they're not converted to private while the DMA write is
taking palce), (2) write the 1 GB buffer, and (3) unlock all 4 k
constituent RMP entries? If I'm understanding this correctly, then the
synchronization will be prohibitively expensive.

Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F2581C6FA89
	for <linux-crypto@archiver.kernel.org>; Wed, 14 Sep 2022 16:39:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229748AbiINQje (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 14 Sep 2022 12:39:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35190 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229523AbiINQjc (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 14 Sep 2022 12:39:32 -0400
Received: from mail-yw1-x1134.google.com (mail-yw1-x1134.google.com [IPv6:2607:f8b0:4864:20::1134])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BFDA7D87
        for <linux-crypto@vger.kernel.org>; Wed, 14 Sep 2022 09:39:29 -0700 (PDT)
Received: by mail-yw1-x1134.google.com with SMTP id 00721157ae682-346cd4c3d7aso187262817b3.8
        for <linux-crypto@vger.kernel.org>; Wed, 14 Sep 2022 09:39:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date;
        bh=qw5c1rQO9auXlb1weto/2p+w4wwBPYYtzhiHNjVL//I=;
        b=OAZPO49RrJRJ1iDc42pcPY8eoQOr9U6LI/jzWl/t/qHJGAwMcmrdHEHcTpZAoEhple
         vmC5s4DomwuO1+aqLB8TMmpmXa4+GKx8HHg3AY/pPl/n26W8L7+GLOtWsIv2AVaWwP4Z
         ZQNaQeralnxC2np7lvsaONpxNi6tvum3IDZggIXPXTJp9vOigUhfQMvo1WFRSQ0ovgeY
         ysF+7Rn8+Te/7o66UPvqNQsZr8wJVkRGpZa/Wk186u5fYhn8lQ0jDLw/f7B7H6UMAQRs
         exEGbIfuANJwGK8IU+YFusPFqhFGXGudweKXCFkCPqfbQuIl49QspG/wobLqsnBjfOE1
         UjPA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date;
        bh=qw5c1rQO9auXlb1weto/2p+w4wwBPYYtzhiHNjVL//I=;
        b=lOkzP34NtPTeLDrgvO8hBPXXwuW5da+7eppb7SDxbrwcFFb/4L3Vo3sOdpRjXn12KA
         wD5gL7JtAqfgB1STC3LA6pCGbT7MvnTig29bzj2p5o4mfx++L7LZP0WIzIbQ13TDeMVo
         Nk3gN9z7vmSGZTnOe/0e/o8lfZ6aphrSzxD7GOzZcO9rcCidQBZyXqrq3w2mtQwFcyJM
         aAzB6dEHg9Zl1ixwFA5GwQLsUgUWA+oIJlHJQ5hVQhznjdGK8BKYcqTX+XK1IB6Tprbf
         ALOSWkoV3JhWwvWihibOfmHGHX2FzQ/twGf+aaHKdEsPD6ZpJ9Bq6T+cvIHzJ2QbTBWP
         kFWw==
X-Gm-Message-State: ACgBeo1AJhh6EmfP4QJDbs5PwcwR/okZeovipBjNAlIqPHKRsy3yWVKS
        bTdSgnFnpfRqW9zmkL00Aghqy9TOW8ln70FiUlpy6g==
X-Google-Smtp-Source: AA6agR4ZwapujsKhSGBJ8nLTDmAGCZkhuO0sc3uJlAZUs5ydbGgLq/Slr/TreGV6Rcw8FLrJapUcRgU+ddTrKrUYAUQ=
X-Received: by 2002:a81:c30a:0:b0:328:4a6c:bc89 with SMTP id
 r10-20020a81c30a000000b003284a6cbc89mr31170890ywk.29.1663173568737; Wed, 14
 Sep 2022 09:39:28 -0700 (PDT)
MIME-Version: 1.0
References: <20210820155918.7518-1-brijesh.singh@amd.com> <20210820155918.7518-40-brijesh.singh@amd.com>
 <YWYm/Gw8PbaAKBF0@google.com> <YWc+sRwHxEmcZZxB@google.com>
 <4e41dcff-7c7b-cf36-434a-c7732e7e8ff2@amd.com> <YWm3bOFcUSlyZjNb@google.com>
 <20220908212114.sqne7awimfwfztq7@amd.com> <YyGLXXkFCmxBfu5U@google.com>
 <CAA03e5H-V+axMiXTLXi7bf+mBs8ZMvaFZTSHSfktZDTSfu=HZQ@mail.gmail.com>
 <YyH+IGpBBsjfHdDC@google.com> <CAA03e5FndJnwSXQVg9RCvEqAsx4o52h59mBAEWatkyZHzT3T2g@mail.gmail.com>
In-Reply-To: <CAA03e5FndJnwSXQVg9RCvEqAsx4o52h59mBAEWatkyZHzT3T2g@mail.gmail.com>
From:   Marc Orr <marcorr@google.com>
Date:   Wed, 14 Sep 2022 17:39:18 +0100
Message-ID: <CAA03e5EdmtXdxpy02vsGRwUKjH+Y5+BT2yKXwhu-bb=ZKELo+w@mail.gmail.com>
Subject: Re: [PATCH Part2 v5 39/45] KVM: SVM: Introduce ops for the post gfn
 map and unmap
To:     Sean Christopherson <seanjc@google.com>
Cc:     Michael Roth <michael.roth@amd.com>,
        Brijesh Singh <brijesh.singh@amd.com>, x86 <x86@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        kvm list <kvm@vger.kernel.org>, linux-coco@lists.linux.dev,
        Linux Memory Management List <linux-mm@kvack.org>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
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
        Vlastimil Babka <vbabka@suse.cz>,
        "Kirill A . Shutemov" <kirill@shutemov.name>,
        Andi Kleen <ak@linux.intel.com>,
        Tony Luck <tony.luck@intel.com>,
        Sathyanarayanan Kuppuswamy 
        <sathyanarayanan.kuppuswamy@linux.intel.com>, jarkko@profian.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Wed, Sep 14, 2022 at 5:32 PM Marc Orr <marcorr@google.com> wrote:
>
> On Wed, Sep 14, 2022 at 5:15 PM Sean Christopherson <seanjc@google.com> wrote:
> >
> > On Wed, Sep 14, 2022, Marc Orr wrote:
> > > On Wed, Sep 14, 2022 at 9:05 AM Sean Christopherson <seanjc@google.com> wrote:
> > > >
> > > > On Thu, Sep 08, 2022, Michael Roth wrote:
> > > > > On Fri, Oct 15, 2021 at 05:16:28PM +0000, Sean Christopherson wrote:
> > > > > So in the context of this interim solution, we're trying to look for a
> > > > > solution that's simple enough that it can be used reliably, without
> > > > > introducing too much additional complexity into KVM. There is one
> > > > > approach that seems to fit that bill, that Brijesh attempted in an
> > > > > earlier version of this series (I'm not sure what exactly was the
> > > > > catalyst to changing the approach, as I wasn't really in the loop at
> > > > > the time, but AIUI there weren't any showstoppers there, but please
> > > > > correct me if I'm missing anything):
> > > > >
> > > > >  - if the host is writing to a page that it thinks is supposed to be
> > > > >    shared, and the guest switches it to private, we get an RMP fault
> > > > >    (actually, we will get a !PRESENT fault, since as of v5 we now
> > > > >    remove the mapping from the directmap as part of conversion)
> > > > >  - in the host #PF handler, if we see that the page is marked private
> > > > >    in the RMP table, simply switch it back to shared
> > > > >  - if this was a bug on the part of the host, then the guest will see
> > > >
> > > > As discussed off-list, attempting to fix up RMP violations in the host #PF handler
> > > > is not a viable approach.  There was also extensive discussion on-list a while back:
> > > >
> > > > https://lore.kernel.org/all/8a244d34-2b10-4cf8-894a-1bf12b59cf92@www.fastmail.com
> > >
> > > I mentioned this during Mike's talk at the micro-conference: For pages
> > > mapped in by the kernel can we disallow them to be converted to
> > > private?
> >
> > In theory, yes.  Do we want to do something like this?  No.  kmap() does something
> > vaguely similar for 32-bit PAE/PSE kernels, but that's a lot of complexity and
> > overhead to take on.  And this issue goes far beyond a kmap(); when the kernel gup()s
> > a page, the kernel expects the pfn to be available, no exceptions (pun intended).
> >
> > > Note, userspace accesses are already handled by UPM.
> >
> > I'm confused by the UPM comment.  Isn't the gist of this thread about the ability
> > to merge SNP _without_ UPM?  Or am I out in left field?
>
> I think that was the overall gist: yes. But it's not what I was trying
> to comment on :-).
>
> HOWEVER, thinking about this more: I was confused when I wrote out my
> last reply. I had thought that the issue that Michael brought up
> applied even with UPM. That is, I was thinking it was still possibly
> for a guest to maliciously convert a page to private mapped in by the
> kernel and assumed to be shared.
>
> But I now realize that is not what will actually happen. To be
> concrete, let's assume the GHCB page. What will happen is:
> - KVM has GHCB page mapped in. GHCB is always assumed to be shared. So
> far so good.
> - Malicious guest converts GHCB page to private (e.g., via Page State
> Change request)
> - Guest exits to KVM
> - KVM exits to userspace VMM
> - Userspace VM allocates page in private FD.
>
> Now, what happens here depends on how UPM works. If we allow double
> allocation then our host kernel is safe. However, now we have the
> "double allocation problem".
>
> If on the other hand, we deallocate the page in the shared FD, the
> host kernel can segfault. And now we actually do have essentially the
> same problem Michael was describing that we have without UPM. Because
> we'll end up in fault.c in the kernel context and likely panic the
> host.

Thinking about this even more... Even if we deallocate in the
userspace VMM's shared FD, the kernel has its own page tables --
right? So maybe we are actually 100% OK under UPM then regardless of
the userspace VMM's policy around managing the private and shared FDs.

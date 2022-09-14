Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A2DADECAAD8
	for <linux-crypto@archiver.kernel.org>; Wed, 14 Sep 2022 11:02:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230081AbiINLCm (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 14 Sep 2022 07:02:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58948 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230100AbiINLCj (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 14 Sep 2022 07:02:39 -0400
Received: from mail-yb1-xb31.google.com (mail-yb1-xb31.google.com [IPv6:2607:f8b0:4864:20::b31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2D0E845F5E
        for <linux-crypto@vger.kernel.org>; Wed, 14 Sep 2022 04:02:36 -0700 (PDT)
Received: by mail-yb1-xb31.google.com with SMTP id 198so17080498ybc.1
        for <linux-crypto@vger.kernel.org>; Wed, 14 Sep 2022 04:02:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date;
        bh=/x00XsnVTU+kUzsYJrpklCSNRK/9eB/Ro0omNgHKcjw=;
        b=Ac+HILwHqFFR2pInEWD80qd2Hhz+KfnP4ARhZ3KyCXTpvJHHyDr5V77NYqhoryvKQF
         dJl70OsGI0lKszgDLTBOZms3/5pvkgfdBUsbSMNSOIBlxaFsdc7cgn5psSKITP8kpB8V
         xOzwhPJMSYAUctwdpFGlbaEV8SCKDjuEChL+pePwijO8xIoqVkrcYcsRV3btirYx+tku
         aJU0WUO414C/Wxp0Pun9MOzwXxccxG7OLsrzTyXTmPxK4MXbny48p17mxgOF8jpFZlSC
         vn7QRQpNrCPXxTAfiA2XvFNUXAO+i9LMxAgMQkBRd9WFAiYeZLTuesMC0akB+54eK5HU
         ub8g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date;
        bh=/x00XsnVTU+kUzsYJrpklCSNRK/9eB/Ro0omNgHKcjw=;
        b=jbAEyz9HuHQcW5/5Ait/UW5diRHN8DxZ1EVvxU5paxXJk2Yj1X83ye73EAmQyg35dn
         uno1/mfkD0Vf3RQiGwCwNBiQFWXQAGZ9h3sTFKKwoj6Ux4ai5KsYhQ0lZZE7m276TLlx
         jMJClTXE4/fa74SZ/BfwK16yx11kTw/+R6/7S5XbgxOATshLgRa1k+mixAS84SatKhuK
         JRsszD6YCMOPKKIWsIcl1mErRgpucf8Elx+7JANMMLgvl/16XUfGlFYc1slIz4qpz7+q
         tULxEscoB5zfYgqf9wQJ5iuRee0qaQwqIirOzgS+IB25O2IRJK1ngh7XzuE83iBvr9RO
         ptAQ==
X-Gm-Message-State: ACrzQf1KmsxIGkrZt90+8QnGylGKvr2jkvVJi3feRKKqGIA1UX72OmNC
        hqJzEJ7Ib+fMkMU79FYOjKFnklHmywKxcevZO9zAORWuBYVVJg==
X-Google-Smtp-Source: AMsMyM6fR7f9+1MEXCI5QuGuGovnipYhYRAJTAwDI0qsEJj/bJnJPP8LwBKgS1imITQ25V5RZaRZfc6YC0GybpIkiZM=
X-Received: by 2002:a25:720b:0:b0:6b0:4b3:c121 with SMTP id
 n11-20020a25720b000000b006b004b3c121mr1725545ybc.473.1663153355073; Wed, 14
 Sep 2022 04:02:35 -0700 (PDT)
MIME-Version: 1.0
References: <20210820155918.7518-1-brijesh.singh@amd.com> <20210820155918.7518-40-brijesh.singh@amd.com>
 <YWYm/Gw8PbaAKBF0@google.com> <YWc+sRwHxEmcZZxB@google.com>
 <4e41dcff-7c7b-cf36-434a-c7732e7e8ff2@amd.com> <YWm3bOFcUSlyZjNb@google.com>
 <20220908212114.sqne7awimfwfztq7@amd.com> <YyGLXXkFCmxBfu5U@google.com>
In-Reply-To: <YyGLXXkFCmxBfu5U@google.com>
From:   Marc Orr <marcorr@google.com>
Date:   Wed, 14 Sep 2022 12:02:24 +0100
Message-ID: <CAA03e5H-V+axMiXTLXi7bf+mBs8ZMvaFZTSHSfktZDTSfu=HZQ@mail.gmail.com>
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

On Wed, Sep 14, 2022 at 9:05 AM Sean Christopherson <seanjc@google.com> wrote:
>
> On Thu, Sep 08, 2022, Michael Roth wrote:
> > On Fri, Oct 15, 2021 at 05:16:28PM +0000, Sean Christopherson wrote:
> > So in the context of this interim solution, we're trying to look for a
> > solution that's simple enough that it can be used reliably, without
> > introducing too much additional complexity into KVM. There is one
> > approach that seems to fit that bill, that Brijesh attempted in an
> > earlier version of this series (I'm not sure what exactly was the
> > catalyst to changing the approach, as I wasn't really in the loop at
> > the time, but AIUI there weren't any showstoppers there, but please
> > correct me if I'm missing anything):
> >
> >  - if the host is writing to a page that it thinks is supposed to be
> >    shared, and the guest switches it to private, we get an RMP fault
> >    (actually, we will get a !PRESENT fault, since as of v5 we now
> >    remove the mapping from the directmap as part of conversion)
> >  - in the host #PF handler, if we see that the page is marked private
> >    in the RMP table, simply switch it back to shared
> >  - if this was a bug on the part of the host, then the guest will see
>
> As discussed off-list, attempting to fix up RMP violations in the host #PF handler
> is not a viable approach.  There was also extensive discussion on-list a while back:
>
> https://lore.kernel.org/all/8a244d34-2b10-4cf8-894a-1bf12b59cf92@www.fastmail.com

I mentioned this during Mike's talk at the micro-conference: For pages
mapped in by the kernel can we disallow them to be converted to
private? Note, userspace accesses are already handled by UPM.

In pseudo-code, I'm thinking something like this:

kmap_helper() {
  // And all other interfaces where the kernel can map a GPA
  // into the kernel page tables
  mapped_into_kernel_mem_set[hpa] = true;
}

kunmap_helper() {
  // And all other interfaces where the kernel can unmap a GPA
  // into the kernel page tables
  mapped_into_kernel_mem_set[hpa] = false;

  // Except it's not this simple because we probably need ref counting
  // for multiple mappings. Sigh. But you get the idea.
}

rmpupdate_helper() {
  if (conversion = SHARED_TO_PRIVATE && mapped_into_kernel_mem_set[hpa])
    return -EINVAL;  // Or whatever the appropriate error code here is.
}

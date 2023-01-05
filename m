Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 670CBC3DA7A
	for <linux-crypto@archiver.kernel.org>; Thu,  5 Jan 2023 22:32:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236026AbjAEWcW (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 5 Jan 2023 17:32:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34000 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236069AbjAEWcC (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 5 Jan 2023 17:32:02 -0500
Received: from mail-oa1-x2c.google.com (mail-oa1-x2c.google.com [IPv6:2001:4860:4864:20::2c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3C70B1A806
        for <linux-crypto@vger.kernel.org>; Thu,  5 Jan 2023 14:31:59 -0800 (PST)
Received: by mail-oa1-x2c.google.com with SMTP id 586e51a60fabf-12c8312131fso44572843fac.4
        for <linux-crypto@vger.kernel.org>; Thu, 05 Jan 2023 14:31:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=bzW/w/1hM8B3dAJhNRkp0Jphokn3JFk7Z5V07SJ3Qvg=;
        b=irhVthMkbXMEX15iArMrcDY5gNuF5eBvK4eo1OtUylhsmE3IG9S+mrhZxQOiqFOCIp
         B0NdfYGQgplol+qXFg23OWfulPwvSU6W3PDU1vto6PpvE0VAeFfNIFN4a8ZuHbQY9yux
         PXeSKyeq3An9rFPoa3fVNGzGEqqWpmTNW/IhDMPZHTEGo5GXlC3tHCL+PpUMhytJ91mi
         VnE7MFoMeikcgMvkL5CbthLdijfrodW+nJq5InxHQqUSFW5SY7wrPzcsnCf8IgP9ADVl
         OSDDZsGxvXwBgux7z61kSSUwbOnmCiTQmx5XrBl1LtTxgEFPc4Tdi1LcRhBuf47g7+EW
         8CKA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=bzW/w/1hM8B3dAJhNRkp0Jphokn3JFk7Z5V07SJ3Qvg=;
        b=QrikTizWn3uQpwbsQ/0gUPc35wfQUnduhntz9C04SxU/rrpl4GUqQft8i3URbfSnvW
         o42H1TbQgFHbpUj6dofEeuH+S39TVMvA0/yzzhBzwtc7PHSJ6+ZgVUUG4Ln70q6XGxqh
         c4XhHn++nkBOh8JFh0AaEi4l1ZPWhOSMuzE+fv2SsmkRIZgtytRIvuE1eOeiJq+h2K5s
         n13pHbDHioa2QiKVtQhZPf1PA/hRrYr3wYosHQ3HdPMsSXZ7AfFLFxsusGGB66jUkWf+
         kTvDQvQ+KAaPpBpaLilolgwxz2vinXL3Q6fWtAn+O1PFWgMPhbbcQOVKFMwwQ0zN2oUq
         5p5A==
X-Gm-Message-State: AFqh2kqi5OrJHYeq/VU9csIIv3UEb81qdnlG9c+rEawi9N8ILkHyL1fw
        3KBnZkI3O+P4XXhaf6N0/+nva4HXjtYXUgYOJvt8kg==
X-Google-Smtp-Source: AMrXdXuhK0FyKkeqVW5l22eKW+0UG+HL1l0rnz8gKZ4dAVgXGahu6I04Z2YvHkfHXjMPojl5mAzlig7pu90phEAYxnc=
X-Received: by 2002:a05:6870:b020:b0:14f:9d87:3d58 with SMTP id
 y32-20020a056870b02000b0014f9d873d58mr4259851oae.108.1672957918361; Thu, 05
 Jan 2023 14:31:58 -0800 (PST)
MIME-Version: 1.0
References: <cover.1655761627.git.ashish.kalra@amd.com> <243778c282cd55a554af9c11d2ecd3ff9ea6820f.1655761627.git.ashish.kalra@amd.com>
 <YuFvbm/Zck9Tr5pq@zn.tnic> <20221219150026.bltiyk72pmdc2ic3@amd.com>
 <Y6DEv4QuvIfwWlCW@zn.tnic> <ab96e918-c8b7-67d5-1dfd-320264858cec@amd.com>
 <CAA03e5GKCcevo7goyyRqWrgk3KeFPTddb-E2pRmgDmyPSNxDvA@mail.gmail.com> <993e0896-cda6-5033-ad0e-e21508a58077@amd.com>
In-Reply-To: <993e0896-cda6-5033-ad0e-e21508a58077@amd.com>
From:   Marc Orr <marcorr@google.com>
Date:   Thu, 5 Jan 2023 14:31:47 -0800
Message-ID: <CAA03e5EZtTqNHOuKAPKpw0xJ_tSa4DYCAf-nSDqsjaSxbJZVkg@mail.gmail.com>
Subject: Re: [PATCH Part2 v6 07/49] x86/sev: Invalid pages from direct map
 when adding it to RMP table
To:     "Kalra, Ashish" <ashish.kalra@amd.com>
Cc:     Borislav Petkov <bp@alien8.de>,
        Michael Roth <michael.roth@amd.com>, x86@kernel.org,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        linux-coco@lists.linux.dev, linux-mm@kvack.org,
        linux-crypto@vger.kernel.org, tglx@linutronix.de, mingo@redhat.com,
        jroedel@suse.de, thomas.lendacky@amd.com, hpa@zytor.com,
        ardb@kernel.org, pbonzini@redhat.com, seanjc@google.com,
        vkuznets@redhat.com, jmattson@google.com, luto@kernel.org,
        dave.hansen@linux.intel.com, slp@redhat.com, pgonda@google.com,
        peterz@infradead.org, srinivas.pandruvada@linux.intel.com,
        rientjes@google.com, dovmurik@linux.ibm.com, tobin@ibm.com,
        vbabka@suse.cz, kirill@shutemov.name, ak@linux.intel.com,
        tony.luck@intel.com, sathyanarayanan.kuppuswamy@linux.intel.com,
        alpergun@google.com, dgilbert@redhat.com, jarkko@kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Thu, Jan 5, 2023 at 2:27 PM Kalra, Ashish <ashish.kalra@amd.com> wrote:
>
> Hello Marc,
>
> On 1/5/2023 4:08 PM, Marc Orr wrote:
> > On Tue, Dec 27, 2022 at 1:49 PM Kalra, Ashish <ashish.kalra@amd.com> wrote:
> >>
> >> Hello Boris,
> >>
> >> On 12/19/2022 2:08 PM, Borislav Petkov wrote:
> >>> On Mon, Dec 19, 2022 at 09:00:26AM -0600, Michael Roth wrote:
> >>>> We implemented this approach for v7, but it causes a fairly significant
> >>>> performance regression, particularly for the case for npages > 1 which
> >>>> this change was meant to optimize.
> >>>>
> >>>> I still need to dig in a big but I'm guessing it's related to flushing
> >>>> behavior.
> >>>
> >>> Well, AFAICT, change_page_attr_set_clr() flushes once at the end.
> >>>
> >>> Don't you need to flush when you modify the direct map?
> >>>
> >>
> >> Milan onward, there is H/W support for coherency between mappings of the
> >> same physical page with different encryption keys, so AFAIK, there
> >> should be no need to flush during page state transitions, where we
> >> invoke these direct map interface functions for re-mapping/invalidating
> >> pages.
> >>
> >> I don't know if there is any other reason to flush after modifying
> >> the direct map ?
> >
> > Isn't the Milan coherence feature (SME_COHERENT?) about the caches --
> > not the TLBs? And isn't the flushing being discussed here about the
> > TLBs?
>
> Actually, the flush does both cache and TLB flushing.
>
> Both cpa_flush() and cpa_flush_all() will also do cache flushing if
> cache argument is not NULL. As in this case, no page caching attributes
> are being changed so there is no need to do cache flushing.
>
> But TLB flushing (as PTE is updated) is still required and will be done.

Ah, got it now. Thanks for explaining. (I should've looked at the code
a bit closer.)

> > Also, I thought that Mingwei Zhang <mizhang@google.com> found that the
> > Milan SEV coherence feature was basically unusable in Linux because it
> > only works across CPUs. It does not extend to IO (e.g., CPU caches
> > need to be flushed prior to free'ing a SEV VM's private address and
> > reallocating that location to a device driver to be used for IO). My
> > understanding of this feature and its limitations may be too coarse.
> > But I think we should be very careful about relying on this feature as
> > it is implemented in Milan.
> >
> > That being said, I guess I could see an argument to rely on the
> > feature here, since we're not deallocating the memory and reallocating
> > it to a device. But again, I thought the feature was about cache
> > coherence -- not TLB coherence.
>
> Yes, this is just invalidating or re-mapping into the kernel direct map,
> so we can rely on this feature for the use case here.

SGTM and that does make sense then. Thanks for confirming.

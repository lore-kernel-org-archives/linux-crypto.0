Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E22E4C54EBC
	for <linux-crypto@archiver.kernel.org>; Thu,  5 Jan 2023 22:10:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234584AbjAEWJf (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 5 Jan 2023 17:09:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45754 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236139AbjAEWJB (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 5 Jan 2023 17:09:01 -0500
Received: from mail-oi1-x22f.google.com (mail-oi1-x22f.google.com [IPv6:2607:f8b0:4864:20::22f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B28C36B185
        for <linux-crypto@vger.kernel.org>; Thu,  5 Jan 2023 14:08:59 -0800 (PST)
Received: by mail-oi1-x22f.google.com with SMTP id e205so33128740oif.11
        for <linux-crypto@vger.kernel.org>; Thu, 05 Jan 2023 14:08:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=bn7Z6oDABvJGYJVlfHzj/OFR2MilP9KE/xPylqtRaI8=;
        b=LPsmEqdAF17ASsCpSdQFeo9d4yZM+w20RGOPe9inlsD+sZCird0lne6ib9WTiUsoq6
         2YgzaklAwt7/d/G7TwXebs7qINP7lo6g4gokBAoTDbEuLNRCPOur2bdGaSB5436CIeQq
         ow56Fuel0bIs5L34wyTU1If5GO/VcfHRlBWxOg8w8qsR3+7n9GR21BPqtWii9RShhyO4
         sK4o0wllJQDfn0fBTBRKdj+90uTkehVGEmVCx2XkcMotlGcWsc49QFRAovOssriMnEgU
         2rvFg916i1tZO2H3RWKP5p1gJ4gYmWV4zvrIbxxpj3BvvCGMhW7SujCWmA146HEcnYhg
         iNbg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=bn7Z6oDABvJGYJVlfHzj/OFR2MilP9KE/xPylqtRaI8=;
        b=X8Oj6wnaJRWa0f81w7yUIR8Bcdz6PfFaiIJsz0kd/GPLwu17dWLTK5x5CK9/5zKFER
         LIotHNJFqDuz+0SvsLx7tqimcva0uTMntqxX5tfBEPW3YpHKCrS164iKCn29FOYtFpOq
         51Sljry7rSIhb/5f3L+jHUZSeJTC8KVyrToG7rbMK91+kJ2tpw6+0wYSxSmp6uf+NsEX
         C0mN+rf6evDNBrRs7tTXagicMf6NYVn30kvHaC5HsMKTGvQZP2BDESe6UZNwth+OgBOv
         6mQnCnsP/afDeKSviejtUlvLrB5d3K51DsOL4bi3V5wLqkjGjr0vUP3Ez2FEDjEJgvDj
         5Cmg==
X-Gm-Message-State: AFqh2krZ/O7uM3E324N00jWgiXBshBwevS1EOv5JLeMiymxyupFstvQj
        13E6sSe2I0eJe5fScLk5gJ4/qn60bluj4UTjmJJYjg==
X-Google-Smtp-Source: AMrXdXuxkMBtlIcBn4GdWW98m54t/OKdTbEuF+GncEMuoeBfYSSzt5Own7F/lydDPhj0/ruVF7sknqqThK7mIt4x8Js=
X-Received: by 2002:a05:6808:3947:b0:354:7fd4:f17b with SMTP id
 en7-20020a056808394700b003547fd4f17bmr2403497oib.221.1672956538794; Thu, 05
 Jan 2023 14:08:58 -0800 (PST)
MIME-Version: 1.0
References: <cover.1655761627.git.ashish.kalra@amd.com> <243778c282cd55a554af9c11d2ecd3ff9ea6820f.1655761627.git.ashish.kalra@amd.com>
 <YuFvbm/Zck9Tr5pq@zn.tnic> <20221219150026.bltiyk72pmdc2ic3@amd.com>
 <Y6DEv4QuvIfwWlCW@zn.tnic> <ab96e918-c8b7-67d5-1dfd-320264858cec@amd.com>
In-Reply-To: <ab96e918-c8b7-67d5-1dfd-320264858cec@amd.com>
From:   Marc Orr <marcorr@google.com>
Date:   Thu, 5 Jan 2023 14:08:47 -0800
Message-ID: <CAA03e5GKCcevo7goyyRqWrgk3KeFPTddb-E2pRmgDmyPSNxDvA@mail.gmail.com>
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

On Tue, Dec 27, 2022 at 1:49 PM Kalra, Ashish <ashish.kalra@amd.com> wrote:
>
> Hello Boris,
>
> On 12/19/2022 2:08 PM, Borislav Petkov wrote:
> > On Mon, Dec 19, 2022 at 09:00:26AM -0600, Michael Roth wrote:
> >> We implemented this approach for v7, but it causes a fairly significant
> >> performance regression, particularly for the case for npages > 1 which
> >> this change was meant to optimize.
> >>
> >> I still need to dig in a big but I'm guessing it's related to flushing
> >> behavior.
> >
> > Well, AFAICT, change_page_attr_set_clr() flushes once at the end.
> >
> > Don't you need to flush when you modify the direct map?
> >
>
> Milan onward, there is H/W support for coherency between mappings of the
> same physical page with different encryption keys, so AFAIK, there
> should be no need to flush during page state transitions, where we
> invoke these direct map interface functions for re-mapping/invalidating
> pages.
>
> I don't know if there is any other reason to flush after modifying
> the direct map ?

Isn't the Milan coherence feature (SME_COHERENT?) about the caches --
not the TLBs? And isn't the flushing being discussed here about the
TLBs?

Also, I thought that Mingwei Zhang <mizhang@google.com> found that the
Milan SEV coherence feature was basically unusable in Linux because it
only works across CPUs. It does not extend to IO (e.g., CPU caches
need to be flushed prior to free'ing a SEV VM's private address and
reallocating that location to a device driver to be used for IO). My
understanding of this feature and its limitations may be too coarse.
But I think we should be very careful about relying on this feature as
it is implemented in Milan.

That being said, I guess I could see an argument to rely on the
feature here, since we're not deallocating the memory and reallocating
it to a device. But again, I thought the feature was about cache
coherence -- not TLB coherence.

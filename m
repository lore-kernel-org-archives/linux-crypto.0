Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.3 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 31435C11F66
	for <linux-crypto@archiver.kernel.org>; Mon, 12 Jul 2021 18:44:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 118BE61206
	for <linux-crypto@archiver.kernel.org>; Mon, 12 Jul 2021 18:44:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235060AbhGLSr1 (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 12 Jul 2021 14:47:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59236 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233973AbhGLSr0 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 12 Jul 2021 14:47:26 -0400
Received: from mail-lf1-x12d.google.com (mail-lf1-x12d.google.com [IPv6:2a00:1450:4864:20::12d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AFF2BC0613DD
        for <linux-crypto@vger.kernel.org>; Mon, 12 Jul 2021 11:44:37 -0700 (PDT)
Received: by mail-lf1-x12d.google.com with SMTP id b26so12869718lfo.4
        for <linux-crypto@vger.kernel.org>; Mon, 12 Jul 2021 11:44:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=PiEei4/RLF9jTsxsrsUBV60BJotPkybau7lkhBzo5/I=;
        b=s5pTurZ13T3fHlyrCaThZOVUofr0Cky2/zld5yC8l0myWNX69BvnBNc9Opj6HMkCfc
         y3CjiuyOByMOeSBVV+o4qu5xJGAw4E/i0pQADCVD/2UOoJrIHi3478hpZZLuoqg1WGst
         OcCnt2jSO0vJrOopZchNBQ9+MjglGj0qNJPE/zKAtnQq1YJa/gtnDpyh4R1JAsZBUefy
         UEn4mtsvyV/dfykaoHSxiB9rtcJ7XqsA3Zf+EHYgfdQgNtp/YlSs2jWfDZvn7iwNgCp8
         ndBvPbOGbkTvsCYluNITw35znBdI+ATFOMw1rixRW4qkI/Kx/zacoIs85goZ2XGThimw
         JBFQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=PiEei4/RLF9jTsxsrsUBV60BJotPkybau7lkhBzo5/I=;
        b=LEE0xjK+2CAZj1i/ELG+XBOc0TUH3FbWBpsZ7LS2s1+9DKmVqZ83jruNENDwMjYt4j
         ge15pEYq0QC8/+PPlQHQb0DfmlFpqR0OZFUBzhmSzTV2BknD+IisvKfBTg/1XhXqOzVT
         ZgOxoeAQlJg5cncftfnYRhpG+itPZ6q7mo1TR99pyiFvzhFcmodBBXlZtWZwYH2nWx+3
         ixsaonZFLEv6MwHzbz0EHnWoc/Te515hjCwKgCEWsL0NMxbPQz8nYKUSs4s8hJgLfTmq
         lm2Hl7M4oWf2fQVp5x+Pc/ZBL1EeVwuYtKH9VLsoD1BXimrg2mcbNWZwDmVPVT5VayUD
         wx9A==
X-Gm-Message-State: AOAM5315b3NIiA6j2kzvOfkYA/C34ihemYor3JQ07xMUwYhAk3MKWoDZ
        6R8UvMDJOxtXmpbXYXAu03Y/xWbdGMxYNjn/km2ARnXkfZW/X6SA
X-Google-Smtp-Source: ABdhPJw+0tMpJcSV02e9y5OpgohRH2ByLJzW2eRxTjnkHhxkF0WhBTLMKzB5LpXi+sxeGsfF6oUSnjAO+65wVmAaEuA=
X-Received: by 2002:ac2:5b1e:: with SMTP id v30mr136916lfn.226.1626115475779;
 Mon, 12 Jul 2021 11:44:35 -0700 (PDT)
MIME-Version: 1.0
References: <20210707183616.5620-1-brijesh.singh@amd.com> <20210707183616.5620-7-brijesh.singh@amd.com>
In-Reply-To: <20210707183616.5620-7-brijesh.singh@amd.com>
From:   Peter Gonda <pgonda@google.com>
Date:   Mon, 12 Jul 2021 12:44:24 -0600
Message-ID: <CAMkAt6quzRMiEJ=iYDocRvpaYuNcV5vm=swbowK+KG=j7FjyKA@mail.gmail.com>
Subject: Re: [PATCH Part2 RFC v4 06/40] x86/sev: Add helper functions for
 RMPUPDATE and PSMASH instruction
To:     Brijesh Singh <brijesh.singh@amd.com>
Cc:     x86@kernel.org, linux-kernel@vger.kernel.org,
        kvm list <kvm@vger.kernel.org>, linux-efi@vger.kernel.org,
        platform-driver-x86@vger.kernel.org, linux-coco@lists.linux.dev,
        linux-mm@kvack.org, linux-crypto@vger.kernel.org,
        Thomas Gleixner <tglx@linutronix.de>,
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
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

> +int psmash(struct page *page)
> +{
> +       unsigned long spa = page_to_pfn(page) << PAGE_SHIFT;
> +       int ret;
> +
> +       if (!cpu_feature_enabled(X86_FEATURE_SEV_SNP))
> +               return -ENXIO;
> +
> +       /* Retry if another processor is modifying the RMP entry. */
> +       do {
> +               /* Binutils version 2.36 supports the PSMASH mnemonic. */
> +               asm volatile(".byte 0xF3, 0x0F, 0x01, 0xFF"
> +                             : "=a"(ret)
> +                             : "a"(spa)
> +                             : "memory", "cc");
> +       } while (ret == FAIL_INUSE);

Should there be some retry limit here for safety? Or do we know that
we'll never be stuck in this loop? Ditto for the loop in rmpupdate.

> +
> +       return ret;
> +}
> +EXPORT_SYMBOL_GPL(psmash);
>

Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E6978C433F5
	for <linux-crypto@archiver.kernel.org>; Tue,  2 Nov 2021 16:49:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CD5A960F24
	for <linux-crypto@archiver.kernel.org>; Tue,  2 Nov 2021 16:49:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235102AbhKBQwO (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 2 Nov 2021 12:52:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45842 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234964AbhKBQvr (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 2 Nov 2021 12:51:47 -0400
Received: from mail-lf1-x135.google.com (mail-lf1-x135.google.com [IPv6:2a00:1450:4864:20::135])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E6B87C0797BB
        for <linux-crypto@vger.kernel.org>; Tue,  2 Nov 2021 09:26:11 -0700 (PDT)
Received: by mail-lf1-x135.google.com with SMTP id j2so44060479lfg.3
        for <linux-crypto@vger.kernel.org>; Tue, 02 Nov 2021 09:26:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=8Q0JPKYImsEJj8uXVW8VH9ex3CWAhIL8zIYTnj92VzE=;
        b=b2wpaHZtxvLTTFPBxpmHmXcYLsOooGKiTRHoJm0lDHl9gjWU3E8C5iKELK1urL9nl0
         /eh+1gSgJQdZ0B6p9JqHjzhSCQMRq8oujbnPuUFf3+zcVzQPjc/4E1WgaXNf4CUI45fw
         l/da5LhUd9WL5f11IO5SZp3AUVnwxjS2Lawu9L7H5V7nVq0bTn/qsg4J8cokd7eIc5Pf
         Xzj5AhUtir4rSvNiIfy78uCzhl1pBSrepsGKkQFdZkhrlcG+YrRG9ivYblEs5p7RKm3v
         qTqQh5dlLsWAowfQlKY+NpoFli/H2a8HDqBHHTeDoXCJQ4uOHIYXSTtJp4tMO7F8/faF
         kYwg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=8Q0JPKYImsEJj8uXVW8VH9ex3CWAhIL8zIYTnj92VzE=;
        b=CcHGHjxqFWdhnQT+hNB6+gAZq8cXNxJOg29cFcSGhhI+LK0oVedh1ey34XM+MPe6ec
         htEIH55AGPZFs/GGVkCgTaksuOFU2X12zRx2KyIn6ZzWsztbMNeqDUpFP5uo3dLzRvvr
         1vfZ8pxjus29RrCNyg5Vnton/kWShZgsRmEMgqoheOafgEsMOnEXvLoFvUSIlud5XXzt
         ZlPdBENPkk3jr5UgMdZuS8mprRjYUR1oi3k4lqmDkMM84FklhmYmUjs+TUSdX/MVNMjA
         P/mm3Z66v/YskeFjMLd9PZLxGnNkC3HWnYad+idJd6oTtBFVdH1bL0FnKgnaQ9ULfX/l
         Ydow==
X-Gm-Message-State: AOAM530M88h8h2thKwxf8kNlPRQ+v0AgNhp3fuBLDQJRe0SlwInKGfTA
        atO67gQEkbe0wWwo0YFG5CToVIrUNO5RBicT+zL5tw==
X-Google-Smtp-Source: ABdhPJyE48dVJQUvXK3BpIfv6YeOgL+VG6t5AJUmekuPNbSHTfUNWQhfUPoxkvPHoscLLNfESi/wos0A9JOKGtEJKN8=
X-Received: by 2002:a05:6512:3d29:: with SMTP id d41mr12071889lfv.685.1635870369633;
 Tue, 02 Nov 2021 09:26:09 -0700 (PDT)
MIME-Version: 1.0
References: <20211102142331.3753798-1-pgonda@google.com> <YYFh323otsIauvmH@google.com>
In-Reply-To: <YYFh323otsIauvmH@google.com>
From:   Peter Gonda <pgonda@google.com>
Date:   Tue, 2 Nov 2021 10:25:58 -0600
Message-ID: <CAMkAt6pnmr53V1Ckdw8vdK3=Ed0evknE8XPNyV35eFD_WP-RMQ@mail.gmail.com>
Subject: Re: [PATCH V3 0/4] Add SEV_INIT_EX support
To:     Sean Christopherson <seanjc@google.com>
Cc:     Thomas.Lendacky@amd.com, Marc Orr <marcorr@google.com>,
        David Rientjes <rientjes@google.com>,
        Brijesh Singh <brijesh.singh@amd.com>,
        Joerg Roedel <jroedel@suse.de>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        John Allen <john.allen@amd.com>,
        "David S. Miller" <davem@davemloft.net>,
        Paolo Bonzini <pbonzini@redhat.com>,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Tue, Nov 2, 2021 at 10:05 AM Sean Christopherson <seanjc@google.com> wrote:
>
> On Tue, Nov 02, 2021, Peter Gonda wrote:
> > SEV_INIT requires users to unlock their SPI bus for the PSP's non
> > volatile (NV) storage. Users may wish to lock their SPI bus for numerous
> > reasons, to support this the PSP firmware supports SEV_INIT_EX. INIT_EX
> > allows the firmware to use a region of memory for its NV storage leaving
> > the kernel responsible for actually storing the data in a persistent
> > way. This series adds a new module parameter to ccp allowing users to
> > specify a path to a file for use as the PSP's NV storage. The ccp driver
> > then reads the file into memory for the PSP to use and is responsible
> > for writing the file whenever the PSP modifies the memory region.
>
> What's changed between v1 and v3?  Also, please wait a few days between versions.
> I know us KVM people are often slow to get to reviews, but posting a new version
> every day is usually counter-productive as it increases the review cost (more
> threads to find and read).

My mistake. I can wait longer between revisions. I was just trying to
include Tom's feedback promptly, I didn't think having many versions
would be an issue.

Between V1 and V3: I have fixed a lot of style issues Tom identified.
Added documentation to the SEV documentation file. Fixed some
incorrect type usage. Made the logging more uniform. Removed writing
on the SHUTDOWN command. And fixed some error handling.

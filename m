Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 54AFFC433DB
	for <linux-crypto@archiver.kernel.org>; Mon, 11 Jan 2021 18:37:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 01609225AB
	for <linux-crypto@archiver.kernel.org>; Mon, 11 Jan 2021 18:37:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390391AbhAKShN (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 11 Jan 2021 13:37:13 -0500
Received: from mail.kernel.org ([198.145.29.99]:41308 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390386AbhAKShN (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 11 Jan 2021 13:37:13 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id ED4982250E
        for <linux-crypto@vger.kernel.org>; Mon, 11 Jan 2021 18:36:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1610390192;
        bh=0q07mtHWOU/So8MwGGtkt6ZE1zcSGxEYN2RPb+MFCX8=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=H7OmZOxw/SLD8H6i4LCuNGBwXE+b2/DtLF8Z/79HEBhIPMWrLKtkGoENptxg3eRyV
         nFNhvC+1oc6in0yiv4a0BQ+vs8BlugHZoK5qJmwITX8SVIgChljy4F19tuzyidLar7
         OxmHnI0jMysrOr5gQUi//lpAyW+tp6RL/PLDSQtI+iU7A2xjvSPdndgls/ayc9oySL
         pcJF44RJK4eygb+xCoxmy69uc/+m6wbUrLZPqIxDQ+hFLFjjFYsm3AVVN20hLjd3hC
         aaLLlqyYvDdQflRyCI6SFrcKyUyqmcIkBpDF5kw2VHT6vAiRQqq6ij1ec/RWVsVhDR
         vgPH67o0/yatQ==
Received: by mail-oi1-f181.google.com with SMTP id w124so340843oia.6
        for <linux-crypto@vger.kernel.org>; Mon, 11 Jan 2021 10:36:31 -0800 (PST)
X-Gm-Message-State: AOAM532yAnXG60kFaVer4Bw7lPCRpOX6YjpOK0TAct+RFFnT26tNffcH
        22ssbgyBlkY49kPqA2ovPjKZUtk2TBy7YrVe18c=
X-Google-Smtp-Source: ABdhPJwBwxbjLCHAfp+B/KZtFCWmfbv0EmytZ6S0gf9OWR3yagDqUYvT6QmwwKh+sp1xO+QWv4uF9DHfElLNdwWAexc=
X-Received: by 2002:aca:d98a:: with SMTP id q132mr109585oig.33.1610390191262;
 Mon, 11 Jan 2021 10:36:31 -0800 (PST)
MIME-Version: 1.0
References: <20210111165237.18178-1-ardb@kernel.org> <CAMj1kXEBPjmCGPPme=rXqadLQeNdqzeyr7uw1WsUoHUqQv1_LQ@mail.gmail.com>
In-Reply-To: <CAMj1kXEBPjmCGPPme=rXqadLQeNdqzeyr7uw1WsUoHUqQv1_LQ@mail.gmail.com>
From:   Ard Biesheuvel <ardb@kernel.org>
Date:   Mon, 11 Jan 2021 19:36:20 +0100
X-Gmail-Original-Message-ID: <CAMj1kXHLBDUGZbc7dw0bd5K4ecPLmnDYMwrPA7yGzA0VNaJWgw@mail.gmail.com>
Message-ID: <CAMj1kXHLBDUGZbc7dw0bd5K4ecPLmnDYMwrPA7yGzA0VNaJWgw@mail.gmail.com>
Subject: Re: [PATCH 0/7] crypto: switch to static calls for CRC-T10DIF
To:     Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Cc:     Herbert Xu <herbert@gondor.apana.org.au>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Eric Biggers <ebiggers@google.com>,
        Peter Zijlstra <peterz@infradead.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Mon, 11 Jan 2021 at 18:27, Ard Biesheuvel <ardb@kernel.org> wrote:
>
> On Mon, 11 Jan 2021 at 17:52, Ard Biesheuvel <ardb@kernel.org> wrote:
> >
> > CRC-T10DIF is a very poor match for the crypto API:
> > - every user in the kernel calls it via a library wrapper around the
> >   shash API, so all callers share a single instance of the transform
> > - each architecture provides at most a single optimized implementation,
> >   based on SIMD instructions for carryless multiplication
> >
> > In other words, none of the flexibility it provides is put to good use,
> > and so it is better to get rid of this complexity, and expose the optimized
> > implementations via static calls instead. This removes a substantial chunk
> > of code, and also gets rid of any indirect calls on architectures that
> > obsess about those (x86)
> >
> > If this approach is deemed suitable, there are other places where we might
> > consider adopting it: CRC32 and CRC32(C).
> >
> > Patch #1 does some preparatory refactoring and removes the library wrapper
> > around the shash transform.
> >
> > Patch #2 introduces the actual static calls, along with the registration
> > routines to update the crc-t10dif implementation at runtime.
> >
> > Patch #3 updates the generic CRC-T10DIF shash driver so it distinguishes
> > between the optimized library code and the generic library code.
> >
> > Patches #4 to #7 update the various arch implementations to switch over to
> > the new method.
> >
> > Special request to Peter to take a look at patch #2, and in particular,
> > whether synchronize_rcu_tasks() is sufficient to ensure that a module
> > providing the target of a static call can be unloaded safely.
> >
>
> It seems I may have managed to confuse myself slightly here: without
> an upper bound on the size of the input of the crc_t10dif() routine, I
> suppose we can never assume that all its callers have finished.
>

Replying to self again - apologies.

I think this is actually correct after all: synchronize_rcu_tasks()
guarantees that all tasks have passed through a 'safe state', i.e.,
voluntary schedule(), return to userland, etc, which guarantees that
no task could be executing the old static call target after
synchronize_rcu_tasks() returns.

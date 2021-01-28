Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DB3A3C433E0
	for <linux-crypto@archiver.kernel.org>; Thu, 28 Jan 2021 08:22:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 91C7A64DA1
	for <linux-crypto@archiver.kernel.org>; Thu, 28 Jan 2021 08:22:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231615AbhA1IWG (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 28 Jan 2021 03:22:06 -0500
Received: from mail.kernel.org ([198.145.29.99]:43338 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231400AbhA1IUX (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 28 Jan 2021 03:20:23 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7298664DD9
        for <linux-crypto@vger.kernel.org>; Thu, 28 Jan 2021 08:19:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1611821981;
        bh=kS/e2cXMo3h+IP8A5F6ah33JwurIOAdsCrIIfwAf370=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=Mzzn1Nwemhp8OqO6H1fO1e4asZBO5ME28H9MWk4BdGT2wgXIg5yjKUjvUJlJjNgZr
         9KTlZUKAJtBZUAU5qcPjAPR3LQFgi2+pVewiUhcLpI5NGb456swqf4xxV7xufJYBTJ
         mx3XWyn3yuaIYyVA0347l7AuG0XXrQhBz9XYS/NzeRYyMYHnW/Boze3jCZwC4jFg6A
         2PrJUJfO0brhxkt84xxx6GxwYd7hn19zfRJRHhDj31E2e2InqloYvQRA2c0OMmCEaC
         713upsULPZorIUEK4nADNzg+tRy3b1Sxlof6r+HBSmw7aZD2Gh6UkmuEjRXHljPxwg
         fDvT4ByW4VYyg==
Received: by mail-ot1-f50.google.com with SMTP id k8so4403202otr.8
        for <linux-crypto@vger.kernel.org>; Thu, 28 Jan 2021 00:19:41 -0800 (PST)
X-Gm-Message-State: AOAM532lj3mB9PbRObP111nLalIoDGHjaENNmA+GgZWDOuRNvTPwjt4F
        rKCVyMH4T5+u2aS3RI0ldpA38m3ykQIlOpHJ0bM=
X-Google-Smtp-Source: ABdhPJx1A2ajCPP3Zv63GzJGTrt50eZ5dZIPoMHtyAR5+m+1iCKXPYumZbLzGvWqVLmZU6tZoXUKMTOw4zz7M5TfiMA=
X-Received: by 2002:a05:6830:1158:: with SMTP id x24mr10312110otq.108.1611821980629;
 Thu, 28 Jan 2021 00:19:40 -0800 (PST)
MIME-Version: 1.0
References: <20210111165237.18178-1-ardb@kernel.org> <X/y9f4vbJwqfKZh5@sol.localdomain>
 <CAMj1kXGJ9uvxkSfvxOaXnek10WicPZPK8eG4=6CGwKgmoxdj+w@mail.gmail.com>
In-Reply-To: <CAMj1kXGJ9uvxkSfvxOaXnek10WicPZPK8eG4=6CGwKgmoxdj+w@mail.gmail.com>
From:   Ard Biesheuvel <ardb@kernel.org>
Date:   Thu, 28 Jan 2021 09:19:29 +0100
X-Gmail-Original-Message-ID: <CAMj1kXFz_3q13HLbS3=1_ahQM3GMpjX=kKDijaGEYz5ewa_VvQ@mail.gmail.com>
Message-ID: <CAMj1kXFz_3q13HLbS3=1_ahQM3GMpjX=kKDijaGEYz5ewa_VvQ@mail.gmail.com>
Subject: Re: [PATCH 0/7] crypto: switch to static calls for CRC-T10DIF
To:     Eric Biggers <ebiggers@kernel.org>
Cc:     Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Peter Zijlstra <peterz@infradead.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Mon, 11 Jan 2021 at 22:31, Ard Biesheuvel <ardb@kernel.org> wrote:
>
> On Mon, 11 Jan 2021 at 22:05, Eric Biggers <ebiggers@kernel.org> wrote:
> >
> > On Mon, Jan 11, 2021 at 05:52:30PM +0100, Ard Biesheuvel wrote:
> > > CRC-T10DIF is a very poor match for the crypto API:
> > > - every user in the kernel calls it via a library wrapper around the
> > >   shash API, so all callers share a single instance of the transform
> > > - each architecture provides at most a single optimized implementation,
> > >   based on SIMD instructions for carryless multiplication
> > >
> > > In other words, none of the flexibility it provides is put to good use,
> > > and so it is better to get rid of this complexity, and expose the optimized
> > > implementations via static calls instead. This removes a substantial chunk
> > > of code, and also gets rid of any indirect calls on architectures that
> > > obsess about those (x86)
> > >
> > > If this approach is deemed suitable, there are other places where we might
> > > consider adopting it: CRC32 and CRC32(C).
> > >
> > > Patch #1 does some preparatory refactoring and removes the library wrapper
> > > around the shash transform.
> > >
> > > Patch #2 introduces the actual static calls, along with the registration
> > > routines to update the crc-t10dif implementation at runtime.
> > >
> > > Patch #3 updates the generic CRC-T10DIF shash driver so it distinguishes
> > > between the optimized library code and the generic library code.
> > >
> > > Patches #4 to #7 update the various arch implementations to switch over to
> > > the new method.
> > >
> > > Special request to Peter to take a look at patch #2, and in particular,
> > > whether synchronize_rcu_tasks() is sufficient to ensure that a module
> > > providing the target of a static call can be unloaded safely.
> > >
> > > Cc: "Martin K. Petersen" <martin.petersen@oracle.com>
> > > Cc: Eric Biggers <ebiggers@google.com>
> > > Cc: Peter Zijlstra <peterz@infradead.org>
> > >
> > > Ard Biesheuvel (7):
> > >   crypto: crc-t10dif - turn library wrapper for shash into generic
> > >     library
> > >   crypto: lib/crc-t10dif - add static call support for optimized
> > >     versions
> > >   crypto: generic/crc-t10dif - expose both arch and generic shashes
> > >   crypto: x86/crc-t10dif - convert to static call library API
> > >   crypto: arm/crc-t10dif - convert to static call library API
> > >   crypto: arm64/crc-t10dif - convert to static call API
> > >   crypto: powerpc/crc-t10dif - convert to static call API
> > >
> > >  arch/arm/crypto/Kconfig                     |   2 +-
> > >  arch/arm/crypto/crct10dif-ce-glue.c         |  58 ++------
> > >  arch/arm64/crypto/Kconfig                   |   3 +-
> > >  arch/arm64/crypto/crct10dif-ce-glue.c       |  85 ++---------
> > >  arch/powerpc/crypto/crct10dif-vpmsum_glue.c |  51 +------
> > >  arch/x86/crypto/crct10dif-pclmul_glue.c     |  90 ++----------
> > >  crypto/Kconfig                              |   7 +-
> > >  crypto/Makefile                             |   2 +-
> > >  crypto/crct10dif_common.c                   |  82 -----------
> > >  crypto/crct10dif_generic.c                  | 100 +++++++++----
> > >  include/linux/crc-t10dif.h                  |  21 ++-
> > >  lib/Kconfig                                 |   2 -
> > >  lib/crc-t10dif.c                            | 152 +++++++++-----------
> > >  13 files changed, 204 insertions(+), 451 deletions(-)
> > >  delete mode 100644 crypto/crct10dif_common.c
> >
> > There is already a library API for two other hash functions, BLAKE2s and
> > Poly1305, which takes advantage of architecture-specific implementations without
> > using static calls.  Also, those algorithms are likewise also exposed through
> > the shash API, but in a different way from what this patchset proposes.
> >
> > Is there a reason not to do things in the same way?  What are the advantages of
> > the new approach that you're proposing?
> >
>
> The current approach uses build time dependencies - i.e., if you
> decide to build the accelerated implementation, you always have to
> load it, even if the accelerated implementation cannot be used on the
> system in question, and it is up to that code to use fallbacks for
> everything, This was kind of a compromise on my part when we were
> having the crypto library vs Wireguard discussion - I mentioned at the
> time that [in my opinion] it was a temporary approach because static
> call support was taking so long to arrive. (lwn article here [0] but
> the links in it seem to be dead). It also results in some nasty
> Kconfig dependencies because building the generic code into the kernel
> and building the accelerated code as a module gives problems.
>
> I agree that having different approaches for doing the same thing is
> suboptimal, but I think the situation may be slightly different for
> plain SIMD code such as blake2 and poly1305 versus crc implementations
> based on carryless multiplication instructions which may be rare but
> 10-20x faster if they are supported.
>
> So in summary, I think this approach is better. The generic code can
> be built in and superseded by module code, and there are no
> dependencies going both ways.
>
> There are some complications as well, though:
> - module softdeps don't work {afaik) if the depender is builtin
> - our poly1305 implementations use a different layout for the state
> that is passed between the init/update/final calls, so it may be
> tricky to use a similar approach there.
>
>

This does not actually work. The kernel_fpu_end() occurring in the
CRC-T10 code amounts to a voluntary schedule, which means
synchronize_rcu_tasks() does not guarantee that the accelerated code
is no longer live after the static call is updated to refer to the
generic code again, and so the remove is risky.

There are some other issues I want to focus on first, so I am going to
disregard this series for now.

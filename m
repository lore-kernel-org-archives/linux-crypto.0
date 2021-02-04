Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.4 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7B244C433DB
	for <linux-crypto@archiver.kernel.org>; Thu,  4 Feb 2021 08:30:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4366064E4D
	for <linux-crypto@archiver.kernel.org>; Thu,  4 Feb 2021 08:30:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234658AbhBDIaL (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 4 Feb 2021 03:30:11 -0500
Received: from mail.kernel.org ([198.145.29.99]:34220 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232882AbhBDIaJ (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 4 Feb 2021 03:30:09 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 19B1D60295
        for <linux-crypto@vger.kernel.org>; Thu,  4 Feb 2021 08:29:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1612427368;
        bh=0Q4cTPJp6Fkx/ADmGTMdkkz0fHhEEp85X/ZCrKqMP/c=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=sz/WHIzicOkLZSqPf4viyqWHRfNrpcd1YZx4r8OZ6G8kYZID0p73JWyHpa//9CpUL
         xdKB6RETqIsUDTnLyfmLcjZY2nYB/1wXIDnhbDq3G8ouW7hH+E+2FFCRb+blcBELpf
         GZhoD6h01tKz5mPpF3X1vwMhtmMrMDXbJk1TQYoYjBTpqk+XuBvU9QYGoFjdeVlcL8
         HJXyiGzFS1/x3m2cI5pL3KuweI0MSSENoNyZjnUZz7mM2lmPeJHyG4p3Y5GqkIfhrQ
         xnX3Ofru01wgu6VBQAZXA5CDvCd6PCmICP6uxTN0ca+wiwcFGFyrINpIjUGXzSrnbg
         X3mdVar6v88tw==
Received: by mail-ot1-f41.google.com with SMTP id s107so2602482otb.8
        for <linux-crypto@vger.kernel.org>; Thu, 04 Feb 2021 00:29:28 -0800 (PST)
X-Gm-Message-State: AOAM531Lk0qseeWfaFXEcDiXau0EbqqS/Sf/cmdBTlG3Au8YpdWGweJO
        OdKbXZOYhSuSIxjxQ7asviveTQHd6kiSKQNwELo=
X-Google-Smtp-Source: ABdhPJwKfycSD6mWlO3tm8oJZK7oEda1IEHVbovGKCVDcbhcvSVIKKeZ4s9aqYPmXU5GJcmqIvo5UV24rcPQq/RL9lU=
X-Received: by 2002:a05:6830:1614:: with SMTP id g20mr4825567otr.77.1612427367400;
 Thu, 04 Feb 2021 00:29:27 -0800 (PST)
MIME-Version: 1.0
References: <20210203113626.220151-1-ardb@kernel.org> <161238528350.1984862.12324465919265084208.b4-ty@kernel.org>
 <20210204024429.GB5482@gondor.apana.org.au>
In-Reply-To: <20210204024429.GB5482@gondor.apana.org.au>
From:   Ard Biesheuvel <ardb@kernel.org>
Date:   Thu, 4 Feb 2021 09:29:16 +0100
X-Gmail-Original-Message-ID: <CAMj1kXH6B8jbVk6xMa4H6GOpEgDCS9vbWLxvM0X-cdataoijdA@mail.gmail.com>
Message-ID: <CAMj1kXH6B8jbVk6xMa4H6GOpEgDCS9vbWLxvM0X-cdataoijdA@mail.gmail.com>
Subject: Re: (subset) Re: [PATCH v2 0/9] arm64: rework NEON yielding to avoid
 scheduling from asm code
To:     Herbert Xu <herbert@gondor.apana.org.au>
Cc:     Will Deacon <will@kernel.org>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Android Kernel Team <kernel-team@android.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Dave Martin <dave.martin@arm.com>,
        Eric Biggers <ebiggers@google.com>,
        Linux ARM <linux-arm-kernel@lists.infradead.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Thu, 4 Feb 2021 at 03:44, Herbert Xu <herbert@gondor.apana.org.au> wrote:
>
> On Wed, Feb 03, 2021 at 09:31:31PM +0000, Will Deacon wrote:
> >
> > Applied first patch only to arm64 (for-next/crypto), thanks!
> >
> > [1/9] arm64: assembler: add cond_yield macro
> >       https://git.kernel.org/arm64/c/d13c613f136c
> >
> > This is the only patch on the branch, so I'm happy for it to be pulled
> > into the crypto tree too if it enables some of the other patches to land
> > in 5.12.
>
> Hi Will:
>
> I think it might be easier if you take the lot.
>
> Acked-by: Herbert Xu <herbert@gondor.apana.org.au>
>

Half of the patches in this series conflict with

0df07d8117c3 crypto: arm64/sha - add missing module aliases

in the cryptodev tree, so that won't work.

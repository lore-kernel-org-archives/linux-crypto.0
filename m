Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.2 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 42BB6C433ED
	for <linux-crypto@archiver.kernel.org>; Mon, 26 Apr 2021 09:01:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 001D860232
	for <linux-crypto@archiver.kernel.org>; Mon, 26 Apr 2021 09:01:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232078AbhDZJCg (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 26 Apr 2021 05:02:36 -0400
Received: from mail.kernel.org ([198.145.29.99]:34652 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232068AbhDZJCg (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 26 Apr 2021 05:02:36 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4221061139;
        Mon, 26 Apr 2021 09:01:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1619427715;
        bh=t3czjXocmQ55D2hIA7IF6tpRkkrO+CYu0SYiBaFbz1Y=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=Rr+xnQ9bh2WK8O/8hfZ126rO6UOx2U5yz/82OPuEcM/63rxn3pZU2mIi1ZytNaPi1
         Q0urBmzwLalR1PIiMmcY15FIdU8E4ejI2vORj0T6FlEN80iTP3D/u2Bo27vEzqrzqk
         FKu4rfU+Xcud/PmQRq8m03q1Oe1sPuVlX/fUqIewk9S3jWYPS1U/VVtiTID74zAJHC
         Z7Ue0v8s7ocR/1iFU3IInJt93pXxOO0nhkfX44LQUd2kEfKYXChwrwyrhE6O+YsgaS
         zXTtRFA9tKHtIpoBj0G3yuioFLQX+N8l+sQ7PaghSC0iz9MDubGkwd8OScSSpunduO
         KLBBRzRjEcVzw==
Received: by mail-oi1-f180.google.com with SMTP id m13so55772353oiw.13;
        Mon, 26 Apr 2021 02:01:55 -0700 (PDT)
X-Gm-Message-State: AOAM530zoz3k0y0lASOW1Ndd6QlxLdDmCad7xSdIaSIebmm9sNAZAoY+
        31NQQPbUmlZEAYwRtwxUUYftBCIGDJIaaabIya4=
X-Google-Smtp-Source: ABdhPJz490C9Bm6kCo7qnrhIQmJXGMOsL4UyybpS8HkW9UBlUjHlPJc3QUhNKE17yuV4sZvhQGWABW2vijsRIQpxtRs=
X-Received: by 2002:aca:4056:: with SMTP id n83mr12587221oia.47.1619427714462;
 Mon, 26 Apr 2021 02:01:54 -0700 (PDT)
MIME-Version: 1.0
References: <20210425175734.1310191-1-masahiroy@kernel.org>
 <20210425175734.1310191-3-masahiroy@kernel.org> <20210426085836.GA5802@willie-the-truck>
In-Reply-To: <20210426085836.GA5802@willie-the-truck>
From:   Ard Biesheuvel <ardb@kernel.org>
Date:   Mon, 26 Apr 2021 11:01:43 +0200
X-Gmail-Original-Message-ID: <CAMj1kXFe7wf_3jmoSAM98s+sZS4Ex4yyoXXiToR-EX8K0e-aNw@mail.gmail.com>
Message-ID: <CAMj1kXFe7wf_3jmoSAM98s+sZS4Ex4yyoXXiToR-EX8K0e-aNw@mail.gmail.com>
Subject: Re: [PATCH 3/4] crypto: arm64: generate *.S by Perl at build time
 instead of shipping them
To:     Will Deacon <will@kernel.org>
Cc:     Masahiro Yamada <masahiroy@kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S . Miller" <davem@davemloft.net>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Linux ARM <linux-arm-kernel@lists.infradead.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Mon, 26 Apr 2021 at 10:58, Will Deacon <will@kernel.org> wrote:
>
> [+Ard]
>
> On Mon, Apr 26, 2021 at 02:57:33AM +0900, Masahiro Yamada wrote:
> > Generate *.S by Perl like arch/{mips,x86}/crypto/Makefile.
> >
> > Signed-off-by: Masahiro Yamada <masahiroy@kernel.org>
> > ---
> >
> >  arch/arm64/crypto/Makefile                |    9 +-
> >  arch/arm64/crypto/poly1305-core.S_shipped |  835 ---------
> >  arch/arm64/crypto/sha256-core.S_shipped   | 2069 ---------------------
> >  arch/arm64/crypto/sha512-core.S_shipped   | 1093 -----------
> >  4 files changed, 3 insertions(+), 4003 deletions(-)
> >  delete mode 100644 arch/arm64/crypto/poly1305-core.S_shipped
> >  delete mode 100644 arch/arm64/crypto/sha256-core.S_shipped
> >  delete mode 100644 arch/arm64/crypto/sha512-core.S_shipped
>
> What's the advantage of removing the _shipped files? We included them
> originally so that we didn't require perl for the kernel build -- is that no
> longer an issue?
>
> I guess I'm just missing the justification for the change.

Removing 4000 lines of code is an improvement in itself, I suppose,
but I have no preference either way,

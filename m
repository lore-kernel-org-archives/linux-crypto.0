Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-14.0 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 40862C433B4
	for <linux-crypto@archiver.kernel.org>; Mon, 26 Apr 2021 10:41:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1475160FE6
	for <linux-crypto@archiver.kernel.org>; Mon, 26 Apr 2021 10:41:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233120AbhDZKmA (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 26 Apr 2021 06:42:00 -0400
Received: from conssluserg-02.nifty.com ([210.131.2.81]:51209 "EHLO
        conssluserg-02.nifty.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233149AbhDZKl5 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 26 Apr 2021 06:41:57 -0400
X-Greylist: delayed 60167 seconds by postgrey-1.27 at vger.kernel.org; Mon, 26 Apr 2021 06:41:57 EDT
Received: from mail-pj1-f46.google.com (mail-pj1-f46.google.com [209.85.216.46]) (authenticated)
        by conssluserg-02.nifty.com with ESMTP id 13QAf2EF001749;
        Mon, 26 Apr 2021 19:41:03 +0900
DKIM-Filter: OpenDKIM Filter v2.10.3 conssluserg-02.nifty.com 13QAf2EF001749
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nifty.com;
        s=dec2015msa; t=1619433663;
        bh=A/AFSUsmk8GSI8VlkwdoqysmX6n1tl4gnFBoHFKOnt8=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=UFEAB5xyFk1ZiXHs0t+2WeIy+x00RzTJgToP/pE1e+H3Lr/Xm7UFs7f7lJbH9UvIE
         QZFpd8yud13e7CO7sd/PiafI74xW2KPL5x0DqJiNLpeFRsYzG19dm88df4tw56XoNM
         kA1l9OAidjwH3C5Y9DJg5j5yYvkgoPR5bNh98NNwnPkbrw04IOMaNmOElQXKAYRvZq
         pWs3yvmB7MkVBo92haIqRcli25/jC5OzZogscaEahnB0tGjP0dYe463PJegVeoN9kS
         hKn89CytYRIql7aJdvg6hIn0Qv6DqjkeRgpOiL2/E23ZB8wH4XCa4cySJFL1hI47UK
         v1k42W8Nac0iw==
X-Nifty-SrcIP: [209.85.216.46]
Received: by mail-pj1-f46.google.com with SMTP id f2-20020a17090a4a82b02900c67bf8dc69so4950850pjh.1;
        Mon, 26 Apr 2021 03:41:03 -0700 (PDT)
X-Gm-Message-State: AOAM533Vi30QwMzfz60f0biPqXcdWR2IOMdkGABQqbjZYxH515KIUPh7
        wtjqCCDV4QV+4x95Gn/0+3EhDuXWlMwtV/ru37k=
X-Google-Smtp-Source: ABdhPJzn/di78c+8czLJrNo4jmACFnoKtdKgSMSJGKqB/K/iu2xwqySD7ggAsYTD38yYzuznyTgvVXrnesPH1uaw3CA=
X-Received: by 2002:a17:902:d645:b029:e8:ec90:d097 with SMTP id
 y5-20020a170902d645b02900e8ec90d097mr18106542plh.47.1619433662462; Mon, 26
 Apr 2021 03:41:02 -0700 (PDT)
MIME-Version: 1.0
References: <20210425175734.1310191-1-masahiroy@kernel.org>
 <20210425175734.1310191-3-masahiroy@kernel.org> <20210426085836.GA5802@willie-the-truck>
 <CAMj1kXFe7wf_3jmoSAM98s+sZS4Ex4yyoXXiToR-EX8K0e-aNw@mail.gmail.com>
In-Reply-To: <CAMj1kXFe7wf_3jmoSAM98s+sZS4Ex4yyoXXiToR-EX8K0e-aNw@mail.gmail.com>
From:   Masahiro Yamada <masahiroy@kernel.org>
Date:   Mon, 26 Apr 2021 19:40:24 +0900
X-Gmail-Original-Message-ID: <CAK7LNAR+3DKGOdg=Jo1yt0QvjjjCzthKzpx5RCMK3x+MO0oMew@mail.gmail.com>
Message-ID: <CAK7LNAR+3DKGOdg=Jo1yt0QvjjjCzthKzpx5RCMK3x+MO0oMew@mail.gmail.com>
Subject: Re: [PATCH 3/4] crypto: arm64: generate *.S by Perl at build time
 instead of shipping them
To:     Ard Biesheuvel <ardb@kernel.org>
Cc:     Will Deacon <will@kernel.org>,
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

On Mon, Apr 26, 2021 at 6:01 PM Ard Biesheuvel <ardb@kernel.org> wrote:
>
> On Mon, 26 Apr 2021 at 10:58, Will Deacon <will@kernel.org> wrote:
> >
> > [+Ard]
> >
> > On Mon, Apr 26, 2021 at 02:57:33AM +0900, Masahiro Yamada wrote:
> > > Generate *.S by Perl like arch/{mips,x86}/crypto/Makefile.
> > >
> > > Signed-off-by: Masahiro Yamada <masahiroy@kernel.org>
> > > ---
> > >
> > >  arch/arm64/crypto/Makefile                |    9 +-
> > >  arch/arm64/crypto/poly1305-core.S_shipped |  835 ---------
> > >  arch/arm64/crypto/sha256-core.S_shipped   | 2069 ---------------------
> > >  arch/arm64/crypto/sha512-core.S_shipped   | 1093 -----------
> > >  4 files changed, 3 insertions(+), 4003 deletions(-)
> > >  delete mode 100644 arch/arm64/crypto/poly1305-core.S_shipped
> > >  delete mode 100644 arch/arm64/crypto/sha256-core.S_shipped
> > >  delete mode 100644 arch/arm64/crypto/sha512-core.S_shipped
> >
> > What's the advantage of removing the _shipped files? We included them
> > originally so that we didn't require perl for the kernel build -- is that no
> > longer an issue?
> >
> > I guess I'm just missing the justification for the change.
>
> Removing 4000 lines of code is an improvement in itself, I suppose,
> but I have no preference either way,



If necessary, I can send v2 with the following info added.


------------------------------>8---------------------------------
People building the arm64 kernel are likely to have Perl already
installed on the system.

ARCH=arm64 defconfig sets CONFIG_OID_REGISTRY=y, so Perl is required
to generate lib/oid_registery_data.c anyway.

Also, Documentation/process/changes.rst says:

You will need perl 5 and the following modules: ``Getopt::Long``,
``Getopt::Std``, ``File::Basename``, and ``File::Find`` to build the kernel.
------------------------------>8---------------------------------





--
Best Regards
Masahiro Yamada

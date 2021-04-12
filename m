Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D2221C433B4
	for <linux-crypto@archiver.kernel.org>; Mon, 12 Apr 2021 08:39:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9AFE46109E
	for <linux-crypto@archiver.kernel.org>; Mon, 12 Apr 2021 08:39:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237301AbhDLIja (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 12 Apr 2021 04:39:30 -0400
Received: from mail.kernel.org ([198.145.29.99]:32960 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237270AbhDLIj3 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 12 Apr 2021 04:39:29 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 290BB60241
        for <linux-crypto@vger.kernel.org>; Mon, 12 Apr 2021 08:39:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1618216752;
        bh=DuOvMxZ8XJDOkEr5alXvgVhlP00/c6HSBIe8G41QU9U=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=e+Blt/vN7cKgjWNxR+p/OX3TCW+WYuRth7GTBklOaOG5MsHssHvzSimokmM36h3Ro
         RDweK660qucRr2HIPZVrae67d+BBmrt1yhTunLKDj9lulZJyhC3XD1X5QZ7Sv1rIsV
         xEYaCiARUuoFxh5Er1CCuyUSiBkS+50IRwNTXcQ5Hkba8GGe3Ewb/0DNU2CGVN04gy
         6ZTvsTQXRkOp9/gNoYCOZ6LnmMsdk7mn2VMZ0gc6L7vGinR8zNCReQVGQI/HGD/cGq
         XdGQ7xniv6Z3iT1pBNi9Is+q0D3ZOZIPEZn5dt83eY5bJe7OxOug8UmTrP7Cys+NMi
         ywV5rqRRQdAsw==
Received: by mail-oi1-f176.google.com with SMTP id k25so12705808oic.4
        for <linux-crypto@vger.kernel.org>; Mon, 12 Apr 2021 01:39:12 -0700 (PDT)
X-Gm-Message-State: AOAM530A5iCGpnYEF4dWcO4+VD7cjDCITveW+oS5/u1pm97LMDrk6Ezf
        Uywa1RVSP/5OJb1HS4S/WJ97LCJYgFFAS/M+fn4=
X-Google-Smtp-Source: ABdhPJztZr9TEt3zZDoZayJ7cXkStQAcd44GGfS4QXeeiADHdDqIaiNe4VxMO+e40o2LiiwIR82qOgPhuk4gtA0H6Ek=
X-Received: by 2002:a05:6808:4c3:: with SMTP id a3mr277852oie.174.1618216751431;
 Mon, 12 Apr 2021 01:39:11 -0700 (PDT)
MIME-Version: 1.0
References: <20210302090118.30666-1-ardb@kernel.org> <20210302090118.30666-2-ardb@kernel.org>
 <20210330095250.GA5352@willie-the-truck>
In-Reply-To: <20210330095250.GA5352@willie-the-truck>
From:   Ard Biesheuvel <ardb@kernel.org>
Date:   Mon, 12 Apr 2021 10:39:00 +0200
X-Gmail-Original-Message-ID: <CAMj1kXFS4e-0pTPx8B7HS=nkf55LfzFPCkohYbBBAiv+BEONeQ@mail.gmail.com>
Message-ID: <CAMj1kXFS4e-0pTPx8B7HS=nkf55LfzFPCkohYbBBAiv+BEONeQ@mail.gmail.com>
Subject: Re: [PATCH v2 1/9] arm64: assembler: remove conditional NEON yield macros
To:     Will Deacon <will@kernel.org>,
        Catalin Marinas <catalin.marinas@arm.com>
Cc:     Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        Linux ARM <linux-arm-kernel@lists.infradead.org>,
        Dave Martin <dave.martin@arm.com>,
        Mark Brown <broonie@kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Eric Biggers <ebiggers@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Ingo Molnar <mingo@kernel.org>,
        Andy Lutomirski <luto@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Tue, 30 Mar 2021 at 11:52, Will Deacon <will@kernel.org> wrote:
>
> On Tue, Mar 02, 2021 at 10:01:10AM +0100, Ard Biesheuvel wrote:
> > The users of the conditional NEON yield macros have all been switched to
> > the simplified cond_yield macro, and so the NEON specific ones can be
> > removed.
> >
> > Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
> > ---
> >  arch/arm64/include/asm/assembler.h | 70 --------------------
> >  1 file changed, 70 deletions(-)
>
> Acked-by: Will Deacon <will@kernel.org>
>

Thanks.

Catalin,

Please consider taking the first 3 patches of this series through the
arm64 tree. I will then resubmit the rest to be taken via the crypto
tree for the next cycle.

Thanks,
Ard.

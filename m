Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 85684C433E0
	for <linux-crypto@archiver.kernel.org>; Thu, 28 Jan 2021 20:28:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3282064DDE
	for <linux-crypto@archiver.kernel.org>; Thu, 28 Jan 2021 20:28:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231350AbhA1U2C (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 28 Jan 2021 15:28:02 -0500
Received: from mail.kernel.org ([198.145.29.99]:52686 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231154AbhA1U1n (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 28 Jan 2021 15:27:43 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 49A8164E05
        for <linux-crypto@vger.kernel.org>; Thu, 28 Jan 2021 20:27:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1611865622;
        bh=A8VizoC/kGtJF6Ee4cawYgbcj/+BUWWZ59hffYwI1GI=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=ulA/eRWW9GMlsKEzH/xrofPDGjTyOP8senjIeg/tVuqNH0qDj0JcCU3aQjpNx9cVz
         EA0JksZA1m4rrXUeki5eJvsJ4amGhWYlbHBGVbKce2COtDWD/sPV41jSXlpOSmlkFt
         xrAo+K7YKG1JL2JpOSa8HmYO/qb1mUyVSTxwUALlpFmsB4bX0YtQhHHcBjTtQuwBW2
         yw6FM22ScpLv+hJZZpYNzgI5S3GL1XNUNNN0/D58AWzwF9QWcb5Zx1o/9BoFsN9Gjq
         5frbxnKOISyyJNNIGZuThM8Qn3nymcdRdWcFs/1i/oUMNwtM/ZAOQk6sm6ZhtnTNl3
         DPEaXRrIkP9UQ==
Received: by mail-ot1-f50.google.com with SMTP id i20so6477514otl.7
        for <linux-crypto@vger.kernel.org>; Thu, 28 Jan 2021 12:27:02 -0800 (PST)
X-Gm-Message-State: AOAM530cZJUAg5Rtf4KpIhVYLG9ee4p57WEFeGsd6r3/9XSA+GUqdPPR
        kq49W8CYzRN0O9ddKWnyqy2kaOlXwSGtThYOYcA=
X-Google-Smtp-Source: ABdhPJxW/whtZhO4aofUYo+kF+Q81MhrlRvsoaGLSpRp51IXUhTfICw+9zZOYvrA3xnZ9UnkVaHeVay3sktECgO5NVQ=
X-Received: by 2002:a05:6830:1614:: with SMTP id g20mr804055otr.77.1611865621406;
 Thu, 28 Jan 2021 12:27:01 -0800 (PST)
MIME-Version: 1.0
References: <20210128130625.54076-1-ardb@kernel.org> <20210128130625.54076-2-ardb@kernel.org>
 <20210128202401.GD3016@willie-the-truck> <20210128202509.GE3016@willie-the-truck>
In-Reply-To: <20210128202509.GE3016@willie-the-truck>
From:   Ard Biesheuvel <ardb@kernel.org>
Date:   Thu, 28 Jan 2021 21:26:50 +0100
X-Gmail-Original-Message-ID: <CAMj1kXETUPWkZm4DWc8QnAonR9AwbRKhFMKajt__u8exo-9scA@mail.gmail.com>
Message-ID: <CAMj1kXETUPWkZm4DWc8QnAonR9AwbRKhFMKajt__u8exo-9scA@mail.gmail.com>
Subject: Re: [PATCH 1/9] arm64: assembler: add cond_yield macro
To:     Will Deacon <will@kernel.org>
Cc:     Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Linux ARM <linux-arm-kernel@lists.infradead.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Dave Martin <dave.martin@arm.com>,
        Eric Biggers <ebiggers@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Thu, 28 Jan 2021 at 21:25, Will Deacon <will@kernel.org> wrote:
>
> On Thu, Jan 28, 2021 at 08:24:01PM +0000, Will Deacon wrote:
> > On Thu, Jan 28, 2021 at 02:06:17PM +0100, Ard Biesheuvel wrote:
> > > Add a macro cond_yield that branches to a specified label when called if
> > > the TIF_NEED_RESCHED flag is set and decreasing the preempt count would
> > > make the task preemptible again, resulting in a schedule to occur. This
> > > can be used by kernel mode SIMD code that keeps a lot of state in SIMD
> > > registers, which would make chunking the input in order to perform the
> > > cond_resched() check from C code disproportionately costly.
> > >
> > > Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
> > > ---
> > >  arch/arm64/include/asm/assembler.h | 16 ++++++++++++++++
> > >  1 file changed, 16 insertions(+)
> > >
> > > diff --git a/arch/arm64/include/asm/assembler.h b/arch/arm64/include/asm/assembler.h
> > > index bf125c591116..5f977a7c6b43 100644
> > > --- a/arch/arm64/include/asm/assembler.h
> > > +++ b/arch/arm64/include/asm/assembler.h
> > > @@ -745,6 +745,22 @@ USER(\label, ic        ivau, \tmp2)                    // invalidate I line PoU
> > >  .Lyield_out_\@ :
> > >     .endm
> > >
> > > +   /*
> > > +    * Check whether preempt-disabled code should yield as soon as it
> > > +    * is able. This is the case if re-enabling preemption a single
> > > +    * time results in a preempt count of zero, and the TIF_NEED_RESCHED
> > > +    * flag is set. (Note that the latter is stored negated in the
> > > +    * top word of the thread_info::preempt_count field)
> > > +    */
> > > +   .macro          cond_yield, lbl:req, tmp:req
> > > +#ifdef CONFIG_PREEMPTION
> > > +   get_current_task \tmp
> > > +   ldr             \tmp, [\tmp, #TSK_TI_PREEMPT]
> > > +   cmp             \tmp, #PREEMPT_DISABLE_OFFSET
> > > +   beq             \lbl
> >
> > Fancy that, I didn't know the '.' was optional in "b.eq"!
> >
> > Anyway, a very similar code sequence exists inside if_will_cond_yield_neon,
> > only it doesn't touch the flags. Can we use that sequence instead, and then
> > use the new macro from there?
>
> ... and now I noticed the last patch :)
>
> But it would still be nice not to clobber the flags inside the macro.
>

Yeah, that's a good point - I did not consider that. I'll fix that for v2.

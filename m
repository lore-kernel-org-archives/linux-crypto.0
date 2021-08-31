Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.4 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F0AD1C4320E
	for <linux-crypto@archiver.kernel.org>; Tue, 31 Aug 2021 18:49:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D4DF261075
	for <linux-crypto@archiver.kernel.org>; Tue, 31 Aug 2021 18:49:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230366AbhHaSuf (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 31 Aug 2021 14:50:35 -0400
Received: from mail.kernel.org ([198.145.29.99]:58306 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230525AbhHaSuf (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 31 Aug 2021 14:50:35 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4BE116108B;
        Tue, 31 Aug 2021 18:49:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1630435779;
        bh=s0v10fx2wIM2WlCJsoeN2cxqVtakw414FOy2ZKgaK/k=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=lOs8rPbwIvgF2gWdK9LiA+xkJyNXt5fI4N9QI2R6VxAUwYogt/zv92YvmSC5fX8Qg
         424czAmCyFEF/lUi6/1kGH6Qb/I/M7PITzdzQENh3upsPCwm23NjyqAOjfByGgD/Ub
         EcvFc1LfhnwLgTNKf8e5DuLp0SPcUbOudppZ2Tr9y80MwduxTdts8AhsUChnacYSt3
         FI8YgYrbQglRsdq13q8RO7CpLhYXgbEljdg7E4aciDrfoDhAIZ4Z/Ps0aJfLOvgJ6X
         LoV/k10g1NicZW5K7Vk0xl6ieqGOgTYHIBzY3xC04TYNUfAx+nPX2hf1v/ND57UDM6
         8euhfydgPVahA==
Date:   Tue, 31 Aug 2021 11:49:37 -0700
From:   Eric Biggers <ebiggers@kernel.org>
To:     Sandy Harris <sandyinchina@gmail.com>
Cc:     Herbert Xu <herbert@gondor.apana.org.au>,
        Lukas Bulwahn <lukas.bulwahn@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        Nathan Chancellor <nathan@kernel.org>,
        Nick Desaulniers <ndesaulniers@google.com>,
        clang-built-linux@googlegroups.com,
        kernel-janitors@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] crypto: sha512: remove imaginary and mystifying clearing
 of variables
Message-ID: <YS55wSEVAYhmrtWE@sol.localdomain>
References: <20210822103107.28974-1-lukas.bulwahn@gmail.com>
 <20210827083842.GF21571@gondor.apana.org.au>
 <CACXcFm=sRBr6cORdyntuOum6n4dJpKv+vTZSi98_JrDWWKF1NQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CACXcFm=sRBr6cORdyntuOum6n4dJpKv+vTZSi98_JrDWWKF1NQ@mail.gmail.com>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Sat, Aug 28, 2021 at 03:46:50PM +0800, Sandy Harris wrote:
> On Fri, Aug 27, 2021 at 4:40 PM Herbert Xu <herbert@gondor.apana.org.au> wrote:
> >
> > On Sun, Aug 22, 2021 at 12:31:07PM +0200, Lukas Bulwahn wrote:
> > > The function sha512_transform() assigns all local variables to 0 before
> > > returning to its caller with the intent to erase sensitive data.
> > > ....
> > >
> > >   The assignments to clear a through h and t1/t2 are optimized out by the
> > >   compiler because they are unused after the assignments.
> 
> Just no.
> 
> You are right, there is a problem here. I thank you for pointing it
> out & I've already fixed it in some of my own code.
> 
> However, I think your solution is dead wrong. You are correct that
> these assignments are useless because the compiler will optimise them
> out, and that's a problem. However, it is not at all "mistiifying";
> they are there for an obvious reason, to avoid leaving state that
> might be useful to an enemy. That is quite a small risk, but then it
> is a small mitigation, so worth doing.
> 
> The correct solution is not to just remove the assignments, but rather
> to replace them with code that will not be optimised away, force the
> compiler to do what we need. We already do that for operations that
> clear various arrays and structures, using memzero_explicit() rather
> than memset(). Similarly, we should replace the assignments with calls
> to this macro:
> 
> /*
>     clear a variable
>     in a way the compiler will not optimise out
> */
> #define clear(x)  memzero_explicit( &x, sizeof(x) )

Clearing of local variables is never guaranteed to work properly, as the
compiler can create multiple copies and/or put them in registers.  It's much
more likely to work for arrays than simple variables though (and not cause the
variable to be unnecessarily spilled from registers to the stack), so that is
the only one the kernel really bothers with.

- Eric

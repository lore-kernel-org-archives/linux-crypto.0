Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5E052C433FE
	for <linux-crypto@archiver.kernel.org>; Fri, 18 Nov 2022 22:33:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229677AbiKRWdQ (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 18 Nov 2022 17:33:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56840 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229660AbiKRWdP (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 18 Nov 2022 17:33:15 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F349A9ACA2
        for <linux-crypto@vger.kernel.org>; Fri, 18 Nov 2022 14:33:14 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9472F627A9
        for <linux-crypto@vger.kernel.org>; Fri, 18 Nov 2022 22:33:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A41DDC433C1;
        Fri, 18 Nov 2022 22:33:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1668810793;
        bh=Qn+bhuDN4Uq8dMdeJ49qjwh7QjWi1Pb6Ow16TnENIWA=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=bpbVUy562ncoA0HYnNrkzFAXqmO1O2ZdgN+kbR68FqT/zXa2/ZmYb/rVaLBQazQs/
         VgBAISIoPdSvt9JkDstJt3HHXV4jXMwC8NtxnMzIzAOdoO7Qgg9PzVS7gNGhjoiIuw
         XR/8cMtIYY7Sw8g1+8gmEYZYVNjUwh5TyU8R4AmpQKjSZSdE8zcYkAcDBRRGxWKGC0
         v3XqIaTT9xCgv705L+OFHRBvh/Fd2LLbHopZDKEJr+gVcFoXyNDe1Kqxph+2eHbvlO
         8aMF39mCgq173Fne5KXHYKqTeU1DLiZ+1ot26LQ3rXwydu7xArgGIFSxVK0r47lRK9
         p/Jxzvto51wTA==
Date:   Fri, 18 Nov 2022 14:33:11 -0800
From:   Eric Biggers <ebiggers@kernel.org>
To:     Sami Tolvanen <samitolvanen@google.com>
Cc:     x86@kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-crypto@vger.kernel.org
Subject: Re: [PATCH v2 08/12] crypto: x86/sm4 - fix crash with CFI enabled
Message-ID: <Y3gIJ0G5pMsQG/gF@sol.localdomain>
References: <20221118194421.160414-1-ebiggers@kernel.org>
 <20221118194421.160414-9-ebiggers@kernel.org>
 <Y3fmskgfAb/xxzpS@sol.localdomain>
 <CABCJKudPXbDx2MSURDxGanTLhBkJjpMx=G=2RPDi6+96LGxcvw@mail.gmail.com>
 <CABCJKueoEkn7rWnDs7hb0nm84kKyyQuj5EVS_MtFNcfdT0D-EA@mail.gmail.com>
 <CABCJKuf4YeN++wYDrmwQyvzjfwWqjuctsezYQO9yOe2h9-TPrQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CABCJKuf4YeN++wYDrmwQyvzjfwWqjuctsezYQO9yOe2h9-TPrQ@mail.gmail.com>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Fri, Nov 18, 2022 at 02:01:40PM -0800, Sami Tolvanen wrote:
> On Fri, Nov 18, 2022 at 12:53 PM Sami Tolvanen <samitolvanen@google.com> wrote:
> >
> > On Fri, Nov 18, 2022 at 12:27 PM Sami Tolvanen <samitolvanen@google.com> wrote:
> > >
> > > On Fri, Nov 18, 2022 at 12:10 PM Eric Biggers <ebiggers@kernel.org> wrote:
> > > > Sami, is it expected that a CFI check isn't being generated for the indirect
> > > > call to 'func' in sm4_avx_cbc_decrypt()?  I'm using LLVM commit 4a7be42d922af0.
> > >
> > > If the compiler emits an indirect call, it should also emit a CFI
> > > check. What's the assembly code it generates here?
> >
> > With CONFIG_RETPOLINE, the check is emitted as expected, but I can
> > reproduce this issue without retpolines. It looks like the cfi-type
> > attribute is dropped from the machine instruction in one of the X86
> > specific passes. I'll take a look.
> 
> This should now be fixed in ToT LLVM after commit 7c96f61aaa4c. Thanks
> for spotting the issue!
> 

Thanks, it seems to work now.  (If I revert my sm4 fix, I get a CFI failure as
expected.)

- Eric

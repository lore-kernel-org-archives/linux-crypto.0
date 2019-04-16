Return-Path: <SRS0=uro5=SS=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_MUTT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0C409C10F0E
	for <linux-crypto@archiver.kernel.org>; Tue, 16 Apr 2019 02:19:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D1E4E204EC
	for <linux-crypto@archiver.kernel.org>; Tue, 16 Apr 2019 02:19:03 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="egV7tTkp"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725796AbfDPCS5 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 15 Apr 2019 22:18:57 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:40842 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725308AbfDPCS5 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 15 Apr 2019 22:18:57 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=UCqn4xJsfn6LSF38geTP0GiT3GQOfaOQ+QhzCgzo1co=; b=egV7tTkpiN9UWTV3PXo4mGfLW
        tbeL71ZPBs4HFrlSAHPfvTx5o1bsD58ovucaD2v+AGmrP7XvuU7izDvOhAY3sqSPXU42U8Gb3pycu
        wXJ3K6Vbk/xXJ/HQYyn/Gwpw5kM8HAqi3pC7vlMBhzuPKGe5T9e9FP5ZkfxJ25pivvxM5iwZqz9jd
        ZHZ6gy1YHEIcLju7XgZkwVQMjQCOOBqM9z3F+MXW/gnUI1bRcGIBJr83/OlHMDhbi4wTOaFHLYIRc
        meSEFn5Bbi+peV/JaPozGSUudMpsq8SkY17MhfLYr+A6jeSyE/r2AzgFz9MxL4aYdkeFilGuP/jN3
        YBRDv9a/A==;
Received: from willy by bombadil.infradead.org with local (Exim 4.90_1 #2 (Red Hat Linux))
        id 1hGDgS-0004Ef-Gw; Tue, 16 Apr 2019 02:18:52 +0000
Date:   Mon, 15 Apr 2019 19:18:52 -0700
From:   Matthew Wilcox <willy@infradead.org>
To:     Herbert Xu <herbert@gondor.apana.org.au>
Cc:     Kees Cook <keescook@chromium.org>,
        Eric Biggers <ebiggers@kernel.org>,
        Rik van Riel <riel@surriel.com>,
        linux-crypto <linux-crypto@vger.kernel.org>,
        Dmitry Vyukov <dvyukov@google.com>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        linux-security-module <linux-security-module@vger.kernel.org>,
        Linux ARM <linux-arm-kernel@lists.infradead.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Laura Abbott <labbott@redhat.com>, linux-mm@kvack.org
Subject: Re: [PATCH] crypto: testmgr - allocate buffers with __GFP_COMP
Message-ID: <20190416021852.GA18616@bombadil.infradead.org>
References: <20190411192607.GD225654@gmail.com>
 <20190411192827.72551-1-ebiggers@kernel.org>
 <CAGXu5jJ8k7fP5Vb=ygmQ0B45GfrK2PeaV04bPWmcZ6Vb+swgyA@mail.gmail.com>
 <20190415022412.GA29714@bombadil.infradead.org>
 <20190415024615.f765e7oagw26ezam@gondor.apana.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190415024615.f765e7oagw26ezam@gondor.apana.org.au>
User-Agent: Mutt/1.9.2 (2017-12-15)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Mon, Apr 15, 2019 at 10:46:15AM +0800, Herbert Xu wrote:
> On Sun, Apr 14, 2019 at 07:24:12PM -0700, Matthew Wilcox wrote:
> > On Thu, Apr 11, 2019 at 01:32:32PM -0700, Kees Cook wrote:
> > > > @@ -156,7 +156,8 @@ static int __testmgr_alloc_buf(char *buf[XBUFSIZE], int order)
> > > >         int i;
> > > >
> > > >         for (i = 0; i < XBUFSIZE; i++) {
> > > > -               buf[i] = (char *)__get_free_pages(GFP_KERNEL, order);
> > > > +               buf[i] = (char *)__get_free_pages(GFP_KERNEL | __GFP_COMP,
> > > > +                                                 order);
> > > 
> > > Is there a reason __GFP_COMP isn't automatically included in all page
> > > allocations? (Or rather, it seems like the exception is when things
> > > should NOT be considered part of the same allocation, so something
> > > like __GFP_SINGLE should exist?.)
> > 
> > The question is not whether or not things should be considered part of the
> > same allocation.  The question is whether the allocation is of a compound
> > page or of N consecutive pages.  Now you're asking what the difference is,
> > and it's whether you need to be able to be able to call compound_head(),
> > compound_order(), PageTail() or use a compound_dtor.  If you don't, then
> > you can save some time at allocation & free by not specifying __GFP_COMP.
> 
> Thanks for clarifying Matthew.
> 
> Eric, this means that we should not use __GFP_COMP here just to
> silent what is clearly a broken warning.

I agree; if the crypto code is never going to try to go from the address of
a byte in the allocation back to the head page, then there's no need to
specify GFP_COMP.

But that leaves us in the awkward situation where
HARDENED_USERCOPY_PAGESPAN does need to be able to figure out whether
'ptr + n - 1' lies within the same allocation as ptr.  Without using
a compound page, there's no indication in the VM structures that these
two pages were allocated as part of the same allocation.

We could force all multi-page allocations to be compound pages if
HARDENED_USERCOPY_PAGESPAN is enabled, but I worry that could break
something.  We could make it catch fewer problems by succeeding if the
page is not compound.  I don't know, these all seem like bad choices
to me.

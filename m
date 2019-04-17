Return-Path: <SRS0=UJZd=ST=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_NEOMUTT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0357EC282DA
	for <linux-crypto@archiver.kernel.org>; Wed, 17 Apr 2019 08:09:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9A87D21773
	for <linux-crypto@archiver.kernel.org>; Wed, 17 Apr 2019 08:09:53 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=armlinux.org.uk header.i=@armlinux.org.uk header.b="jrHBLtqh"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727013AbfDQIJv (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 17 Apr 2019 04:09:51 -0400
Received: from pandora.armlinux.org.uk ([78.32.30.218]:48958 "EHLO
        pandora.armlinux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728143AbfDQIJu (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 17 Apr 2019 04:09:50 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=SYuZrgQB7tJG7K7f5LjyBEKaXZO/UGBfG4FuxsfdE1o=; b=jrHBLtqh/DMPI1om+61hhVpcB
        n8FRHS0icipmzIceW19zbPG8NLeJ2chHhS2LCguRJL2nKWwMTCs0dgqSEykSqcvTghjoc4G5iBsGB
        7AtlZx0McyFUjB5I5IAIzwyh4ZWARQpVwiSIAOBVYRI2ShdM8YzrmcT249NhjvPNc8UXrIPFOn72H
        t9JE5CJDrBpI9ykx/cY4zLHxaJ4E7ErOMHV65gfGCjxb8BRmKhtza0QkFuWBtnFqENTkjeG5A1gA7
        s2+SLKOR7iw8y3dR2q72GePIJKw2JaM2E/e+ZWCprYAKpqJai2dBLOUcCixRU/FCIODy9rzWXod5O
        ZBsX5BqxA==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:52136)
        by pandora.armlinux.org.uk with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.90_1)
        (envelope-from <linux@armlinux.org.uk>)
        id 1hGfdG-0000L3-7q; Wed, 17 Apr 2019 09:09:26 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.89)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1hGfd9-0000gr-CZ; Wed, 17 Apr 2019 09:09:19 +0100
Date:   Wed, 17 Apr 2019 09:09:19 +0100
From:   Russell King - ARM Linux admin <linux@armlinux.org.uk>
To:     Matthew Wilcox <willy@infradead.org>
Cc:     Kees Cook <keescook@chromium.org>,
        Linux ARM <linux-arm-kernel@lists.infradead.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Rik van Riel <riel@surriel.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Eric Biggers <ebiggers@kernel.org>,
        Linux-MM <linux-mm@kvack.org>,
        linux-security-module <linux-security-module@vger.kernel.org>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        linux-crypto <linux-crypto@vger.kernel.org>,
        Laura Abbott <labbott@redhat.com>,
        Dmitry Vyukov <dvyukov@google.com>
Subject: Re: [PATCH] crypto: testmgr - allocate buffers with __GFP_COMP
Message-ID: <20190417080919.54wywpzrt3psn4vj@shell.armlinux.org.uk>
References: <20190411192607.GD225654@gmail.com>
 <20190411192827.72551-1-ebiggers@kernel.org>
 <CAGXu5jJ8k7fP5Vb=ygmQ0B45GfrK2PeaV04bPWmcZ6Vb+swgyA@mail.gmail.com>
 <20190415022412.GA29714@bombadil.infradead.org>
 <20190415024615.f765e7oagw26ezam@gondor.apana.org.au>
 <20190416021852.GA18616@bombadil.infradead.org>
 <CAGXu5jKaVB=bTJCBWhsxAny7-OkzXQ+8KCd5O+_-7hKcJFiqKw@mail.gmail.com>
 <20190417040822.GB7751@bombadil.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190417040822.GB7751@bombadil.infradead.org>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Tue, Apr 16, 2019 at 09:08:22PM -0700, Matthew Wilcox wrote:
> On Mon, Apr 15, 2019 at 10:14:51PM -0500, Kees Cook wrote:
> > On Mon, Apr 15, 2019 at 9:18 PM Matthew Wilcox <willy@infradead.org> wrote:
> > > I agree; if the crypto code is never going to try to go from the address of
> > > a byte in the allocation back to the head page, then there's no need to
> > > specify GFP_COMP.
> > >
> > > But that leaves us in the awkward situation where
> > > HARDENED_USERCOPY_PAGESPAN does need to be able to figure out whether
> > > 'ptr + n - 1' lies within the same allocation as ptr.  Without using
> > > a compound page, there's no indication in the VM structures that these
> > > two pages were allocated as part of the same allocation.
> > >
> > > We could force all multi-page allocations to be compound pages if
> > > HARDENED_USERCOPY_PAGESPAN is enabled, but I worry that could break
> > > something.  We could make it catch fewer problems by succeeding if the
> > > page is not compound.  I don't know, these all seem like bad choices
> > > to me.
> > 
> > If GFP_COMP is _not_ the correct signal about adjacent pages being
> > part of the same allocation, then I agree: we need to drop this check
> > entirely from PAGESPAN. Is there anything else that indicates this
> > property? (Or where might we be able to store that info?)
> 
> As far as I know, the page allocator does not store size information
> anywhere, unless you use GFP_COMP.  That's why you have to pass
> the 'order' to free_pages() and __free_pages().  It's also why
> alloc_pages_exact() works (follow all the way into split_page()).
> 
> > There are other pagespan checks, though, so those could stay. But I'd
> > really love to gain page allocator allocation size checking ...
> 
> I think that's a great idea, but I'm not sure how you'll be able to
> do that.

However, we have had code (maybe historically now) that has allocated
a higher order page and then handed back pages that it doesn't need -
for example, when the code requires multiple contiguous pages but does
not require a power-of-2 size of contiguous pages.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTC broadband for 0.8mile line in suburbia: sync at 12.1Mbps down 622kbps up
According to speedtest.net: 11.9Mbps down 500kbps up

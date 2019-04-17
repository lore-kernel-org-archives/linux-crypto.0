Return-Path: <SRS0=UJZd=ST=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_MUTT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 83FD5C282DC
	for <linux-crypto@archiver.kernel.org>; Wed, 17 Apr 2019 04:08:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5339E20693
	for <linux-crypto@archiver.kernel.org>; Wed, 17 Apr 2019 04:08:31 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="CON7p5qb"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725767AbfDQEIa (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 17 Apr 2019 00:08:30 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:37466 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725320AbfDQEIa (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 17 Apr 2019 00:08:30 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=Em4HpOp3QfI9scdNSfMBzQDhJV4iaM3Bd30fC2vkXHU=; b=CON7p5qb8+GWuIuaXABny5e1b
        78XtNR3iadVEg2rNXkBrCWv715s3AtTYJMLTdNT0QCRRdQ9fJWPSUQukE+LPNMhSr/fd10/w9l/Hv
        Wz0AxaKBh/AeKrFFkj2x+XQBZjkfhjM5PcwIXKXslLN6KOny76URhvSqY42AecAmCwEZLapoJKSgv
        sQQ45ZOYF0EGWTc/Ld4hZS8RUtZF2g6iRfTWKYYjcDEpKnjk8HRF+FkF9VvkYRZtxqji86Hy8FSOT
        VDOBV85w1wdqy2/Y2Sw9nkmwjNCMyg4hUXDTwK39ZKai6BMQFvhoilI0BHoa+dcfib0I2PptYbriB
        QVwqb5ZiQ==;
Received: from willy by bombadil.infradead.org with local (Exim 4.90_1 #2 (Red Hat Linux))
        id 1hGbry-0002lh-TV; Wed, 17 Apr 2019 04:08:22 +0000
Date:   Tue, 16 Apr 2019 21:08:22 -0700
From:   Matthew Wilcox <willy@infradead.org>
To:     Kees Cook <keescook@chromium.org>
Cc:     Herbert Xu <herbert@gondor.apana.org.au>,
        Eric Biggers <ebiggers@kernel.org>,
        Rik van Riel <riel@surriel.com>,
        linux-crypto <linux-crypto@vger.kernel.org>,
        Dmitry Vyukov <dvyukov@google.com>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        linux-security-module <linux-security-module@vger.kernel.org>,
        Linux ARM <linux-arm-kernel@lists.infradead.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Laura Abbott <labbott@redhat.com>,
        Linux-MM <linux-mm@kvack.org>
Subject: Re: [PATCH] crypto: testmgr - allocate buffers with __GFP_COMP
Message-ID: <20190417040822.GB7751@bombadil.infradead.org>
References: <20190411192607.GD225654@gmail.com>
 <20190411192827.72551-1-ebiggers@kernel.org>
 <CAGXu5jJ8k7fP5Vb=ygmQ0B45GfrK2PeaV04bPWmcZ6Vb+swgyA@mail.gmail.com>
 <20190415022412.GA29714@bombadil.infradead.org>
 <20190415024615.f765e7oagw26ezam@gondor.apana.org.au>
 <20190416021852.GA18616@bombadil.infradead.org>
 <CAGXu5jKaVB=bTJCBWhsxAny7-OkzXQ+8KCd5O+_-7hKcJFiqKw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAGXu5jKaVB=bTJCBWhsxAny7-OkzXQ+8KCd5O+_-7hKcJFiqKw@mail.gmail.com>
User-Agent: Mutt/1.9.2 (2017-12-15)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Mon, Apr 15, 2019 at 10:14:51PM -0500, Kees Cook wrote:
> On Mon, Apr 15, 2019 at 9:18 PM Matthew Wilcox <willy@infradead.org> wrote:
> > I agree; if the crypto code is never going to try to go from the address of
> > a byte in the allocation back to the head page, then there's no need to
> > specify GFP_COMP.
> >
> > But that leaves us in the awkward situation where
> > HARDENED_USERCOPY_PAGESPAN does need to be able to figure out whether
> > 'ptr + n - 1' lies within the same allocation as ptr.  Without using
> > a compound page, there's no indication in the VM structures that these
> > two pages were allocated as part of the same allocation.
> >
> > We could force all multi-page allocations to be compound pages if
> > HARDENED_USERCOPY_PAGESPAN is enabled, but I worry that could break
> > something.  We could make it catch fewer problems by succeeding if the
> > page is not compound.  I don't know, these all seem like bad choices
> > to me.
> 
> If GFP_COMP is _not_ the correct signal about adjacent pages being
> part of the same allocation, then I agree: we need to drop this check
> entirely from PAGESPAN. Is there anything else that indicates this
> property? (Or where might we be able to store that info?)

As far as I know, the page allocator does not store size information
anywhere, unless you use GFP_COMP.  That's why you have to pass
the 'order' to free_pages() and __free_pages().  It's also why
alloc_pages_exact() works (follow all the way into split_page()).

> There are other pagespan checks, though, so those could stay. But I'd
> really love to gain page allocator allocation size checking ...

I think that's a great idea, but I'm not sure how you'll be able to
do that.

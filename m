Return-Path: <SRS0=EtZ3=SR=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED,USER_AGENT_NEOMUTT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 64E80C10F13
	for <linux-crypto@archiver.kernel.org>; Mon, 15 Apr 2019 02:46:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 37ABA2084E
	for <linux-crypto@archiver.kernel.org>; Mon, 15 Apr 2019 02:46:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726042AbfDOCqk (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Sun, 14 Apr 2019 22:46:40 -0400
Received: from orcrist.hmeau.com ([104.223.48.154]:56794 "EHLO
        deadmen.hmeau.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725775AbfDOCqj (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sun, 14 Apr 2019 22:46:39 -0400
Received: from gondobar.mordor.me.apana.org.au ([192.168.128.4] helo=gondobar)
        by deadmen.hmeau.com with esmtps (Exim 4.89 #2 (Debian))
        id 1hFrdU-0001NG-T0; Mon, 15 Apr 2019 10:46:21 +0800
Received: from herbert by gondobar with local (Exim 4.89)
        (envelope-from <herbert@gondor.apana.org.au>)
        id 1hFrdP-0003On-6f; Mon, 15 Apr 2019 10:46:15 +0800
Date:   Mon, 15 Apr 2019 10:46:15 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Matthew Wilcox <willy@infradead.org>
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
Message-ID: <20190415024615.f765e7oagw26ezam@gondor.apana.org.au>
References: <20190411192607.GD225654@gmail.com>
 <20190411192827.72551-1-ebiggers@kernel.org>
 <CAGXu5jJ8k7fP5Vb=ygmQ0B45GfrK2PeaV04bPWmcZ6Vb+swgyA@mail.gmail.com>
 <20190415022412.GA29714@bombadil.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190415022412.GA29714@bombadil.infradead.org>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Sun, Apr 14, 2019 at 07:24:12PM -0700, Matthew Wilcox wrote:
> On Thu, Apr 11, 2019 at 01:32:32PM -0700, Kees Cook wrote:
> > > @@ -156,7 +156,8 @@ static int __testmgr_alloc_buf(char *buf[XBUFSIZE], int order)
> > >         int i;
> > >
> > >         for (i = 0; i < XBUFSIZE; i++) {
> > > -               buf[i] = (char *)__get_free_pages(GFP_KERNEL, order);
> > > +               buf[i] = (char *)__get_free_pages(GFP_KERNEL | __GFP_COMP,
> > > +                                                 order);
> > 
> > Is there a reason __GFP_COMP isn't automatically included in all page
> > allocations? (Or rather, it seems like the exception is when things
> > should NOT be considered part of the same allocation, so something
> > like __GFP_SINGLE should exist?.)
> 
> The question is not whether or not things should be considered part of the
> same allocation.  The question is whether the allocation is of a compound
> page or of N consecutive pages.  Now you're asking what the difference is,
> and it's whether you need to be able to be able to call compound_head(),
> compound_order(), PageTail() or use a compound_dtor.  If you don't, then
> you can save some time at allocation & free by not specifying __GFP_COMP.

Thanks for clarifying Matthew.

Eric, this means that we should not use __GFP_COMP here just to
silent what is clearly a broken warning.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt

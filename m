Return-Path: <SRS0=EtZ3=SR=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_MUTT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CD0D5C282CE
	for <linux-crypto@archiver.kernel.org>; Mon, 15 Apr 2019 02:24:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 96C7020848
	for <linux-crypto@archiver.kernel.org>; Mon, 15 Apr 2019 02:24:16 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="fq0EfNQX"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726120AbfDOCYP (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Sun, 14 Apr 2019 22:24:15 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:51310 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725789AbfDOCYP (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sun, 14 Apr 2019 22:24:15 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=aB6g0E//NkNVlipKG0sOhrOyS6Dw+DkFuHN89+1UXTY=; b=fq0EfNQX5nmmKBJBSToMWL+EU
        FxkpnJG2cnRAHFxr+1W/jqEJiVT7FnrH9KpPttGpFx/T7D9QeyyP6ORiCBXLzW0CSHJgygexR8OEv
        LGgRxRk6rGqLCiZ7KvkazpzS3Ut3DXqH6MarjmuEo/wxSBFEb4VLhMJFLX2C6dc8tHn3KZ57MypRf
        c2AG1z6qj6Gzc7hj5pNwfP3/xYm+JbK/igIaiG/xhkuvqKjv3NBQNiY/SumzLQQ7HXAPm7ggHF4Go
        ds5GKrGU3C1kVsilweVs8h7utQitrg4S1CeaHlkJaGpFenphFG+mPP5NG7MCoitqRzYgwVPBWPZ+E
        cpkaKGf7g==;
Received: from willy by bombadil.infradead.org with local (Exim 4.90_1 #2 (Red Hat Linux))
        id 1hFrI4-0005Pf-K4; Mon, 15 Apr 2019 02:24:12 +0000
Date:   Sun, 14 Apr 2019 19:24:12 -0700
From:   Matthew Wilcox <willy@infradead.org>
To:     Kees Cook <keescook@chromium.org>
Cc:     Eric Biggers <ebiggers@kernel.org>,
        Rik van Riel <riel@surriel.com>,
        linux-crypto <linux-crypto@vger.kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Dmitry Vyukov <dvyukov@google.com>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        linux-security-module <linux-security-module@vger.kernel.org>,
        Linux ARM <linux-arm-kernel@lists.infradead.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Laura Abbott <labbott@redhat.com>, linux-mm@kvack.org
Subject: Re: [PATCH] crypto: testmgr - allocate buffers with __GFP_COMP
Message-ID: <20190415022412.GA29714@bombadil.infradead.org>
References: <20190411192607.GD225654@gmail.com>
 <20190411192827.72551-1-ebiggers@kernel.org>
 <CAGXu5jJ8k7fP5Vb=ygmQ0B45GfrK2PeaV04bPWmcZ6Vb+swgyA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAGXu5jJ8k7fP5Vb=ygmQ0B45GfrK2PeaV04bPWmcZ6Vb+swgyA@mail.gmail.com>
User-Agent: Mutt/1.9.2 (2017-12-15)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Thu, Apr 11, 2019 at 01:32:32PM -0700, Kees Cook wrote:
> > @@ -156,7 +156,8 @@ static int __testmgr_alloc_buf(char *buf[XBUFSIZE], int order)
> >         int i;
> >
> >         for (i = 0; i < XBUFSIZE; i++) {
> > -               buf[i] = (char *)__get_free_pages(GFP_KERNEL, order);
> > +               buf[i] = (char *)__get_free_pages(GFP_KERNEL | __GFP_COMP,
> > +                                                 order);
> 
> Is there a reason __GFP_COMP isn't automatically included in all page
> allocations? (Or rather, it seems like the exception is when things
> should NOT be considered part of the same allocation, so something
> like __GFP_SINGLE should exist?.)

The question is not whether or not things should be considered part of the
same allocation.  The question is whether the allocation is of a compound
page or of N consecutive pages.  Now you're asking what the difference is,
and it's whether you need to be able to be able to call compound_head(),
compound_order(), PageTail() or use a compound_dtor.  If you don't, then
you can save some time at allocation & free by not specifying __GFP_COMP.

I'll agree this is not documented well, and maybe most multi-page
allocations do want __GFP_COMP and we should invert that bit, but
__GFP_SINGLE doesn't seem like the right antonym to __GFP_COMP to me.

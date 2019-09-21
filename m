Return-Path: <SRS0=FYQz=XQ=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.0 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7C82EC3A5A2
	for <linux-crypto@archiver.kernel.org>; Sat, 21 Sep 2019 01:09:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 46F0E2086A
	for <linux-crypto@archiver.kernel.org>; Sat, 21 Sep 2019 01:09:56 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="B1earZD/"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726947AbfIUBJz (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 20 Sep 2019 21:09:55 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:50574 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726295AbfIUBJz (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 20 Sep 2019 21:09:55 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=058TNc0pu0U1h9ZhReTUnVvFtu8q/fBjZnqUokPcNEE=; b=B1earZD/8vzs06OugH/xgqc1p
        xMMWj5FKvpl3h+wF57dBGLLU3EibhLPJcxJGfF93c+iRpjiOoPpxtwFbMhf9UYrF+xi4FG4/3IUOb
        M5r3PftKFZf0TTnXdPcHiHthGW4ttYZG0W/uBMvnkN6SpeX44igyDQtkUz3vZYGo9+kdTOk6dnf5E
        jZ46Io/5kOXaPhAJ2LvTK73YJ5Sz/ZlVZpCZPOpXHC3uQeCOHr9Pi4vnPLVatarkPzumKIr88RExW
        bzPA18sHIA4uiuWeqcoxBwTXl5LstiUMHxMPIeQ2A2nRI4b+FrfHzzCySiIyi9Czzq58C1rAPjz7r
        yWGDy853g==;
Received: from willy by bombadil.infradead.org with local (Exim 4.92.2 #3 (Red Hat Linux))
        id 1iBTuG-0005m6-9I; Sat, 21 Sep 2019 01:09:48 +0000
Date:   Fri, 20 Sep 2019 18:09:48 -0700
From:   Matthew Wilcox <willy@infradead.org>
To:     Andrew Morton <akpm@linux-foundation.org>
Cc:     Ira Weiny <ira.weiny@intel.com>, linux-mm@kvack.org,
        Atul Gupta <atul.gupta@chelsio.com>,
        linux-crypto@vger.kernel.org
Subject: Re: [PATCH v2 1/3] mm: Introduce page_size()
Message-ID: <20190921010948.GD15392@bombadil.infradead.org>
References: <20190721104612.19120-1-willy@infradead.org>
 <20190721104612.19120-2-willy@infradead.org>
 <20190723004307.GB10284@iweiny-DESK2.sc.intel.com>
 <20190723160248.GK363@bombadil.infradead.org>
 <20190920162848.950dd70264e670a485f410dc@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190920162848.950dd70264e670a485f410dc@linux-foundation.org>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Fri, Sep 20, 2019 at 04:28:48PM -0700, Andrew Morton wrote:
> On Tue, 23 Jul 2019 09:02:48 -0700 Matthew Wilcox <willy@infradead.org> wrote:
> 
> > On Mon, Jul 22, 2019 at 05:43:07PM -0700, Ira Weiny wrote:
> > > > diff --git a/drivers/crypto/chelsio/chtls/chtls_io.c b/drivers/crypto/chelsio/chtls/chtls_io.c
> > > > index 551bca6fef24..925be5942895 100644
> > > > --- a/drivers/crypto/chelsio/chtls/chtls_io.c
> > > > +++ b/drivers/crypto/chelsio/chtls/chtls_io.c
> > > > @@ -1078,7 +1078,7 @@ int chtls_sendmsg(struct sock *sk, struct msghdr *msg, size_t size)
> > > >  			bool merge;
> > > >  
> > > >  			if (page)
> > > > -				pg_size <<= compound_order(page);
> > > > +				pg_size = page_size(page);
> > > >  			if (off < pg_size &&
> > > >  			    skb_can_coalesce(skb, i, page, off)) {
> > > >  				merge = 1;
> > > > @@ -1105,8 +1105,7 @@ int chtls_sendmsg(struct sock *sk, struct msghdr *msg, size_t size)
> > > >  							   __GFP_NORETRY,
> > > >  							   order);
> > > >  					if (page)
> > > > -						pg_size <<=
> > > > -							compound_order(page);
> > > > +						pg_size <<= order;
> > > 
> > > Looking at the code I see pg_size should be PAGE_SIZE right before this so why
> > > not just use the new call and remove the initial assignment?
> > 
> > This driver is really convoluted.  I wasn't certain I wouldn't break it
> > in some horrid way.  I made larger changes to it originally, then they
> > touched this part of the driver and I had to rework the patch to apply
> > on top of their changes.  So I did something more minimal.
> > 
> > This, on top of what's in Andrew's tree, would be my guess, but I don't
> > have the hardware.
> > 
> > diff --git a/drivers/crypto/chelsio/chtls/chtls_io.c b/drivers/crypto/chelsio/chtls/chtls_io.c
> > index 925be5942895..d4eb0fcd04c7 100644
> > --- a/drivers/crypto/chelsio/chtls/chtls_io.c
> > +++ b/drivers/crypto/chelsio/chtls/chtls_io.c
> > @@ -1073,7 +1073,7 @@ int chtls_sendmsg(struct sock *sk, struct msghdr *msg, size_t size)
> >  		} else {
> >  			int i = skb_shinfo(skb)->nr_frags;
> >  			struct page *page = TCP_PAGE(sk);
> > -			int pg_size = PAGE_SIZE;
> > +			unsigned int pg_size = 0;
> >  			int off = TCP_OFF(sk);
> >  			bool merge;
> >  
> > @@ -1092,7 +1092,7 @@ int chtls_sendmsg(struct sock *sk, struct msghdr *msg, size_t size)
> >  			if (page && off == pg_size) {
> >  				put_page(page);
> >  				TCP_PAGE(sk) = page = NULL;
> > -				pg_size = PAGE_SIZE;
> > +				pg_size = 0;
> >  			}
> >  
> >  			if (!page) {
> > @@ -1104,15 +1104,13 @@ int chtls_sendmsg(struct sock *sk, struct msghdr *msg, size_t size)
> >  							   __GFP_NOWARN |
> >  							   __GFP_NORETRY,
> >  							   order);
> > -					if (page)
> > -						pg_size <<= order;
> >  				}
> >  				if (!page) {
> >  					page = alloc_page(gfp);
> > -					pg_size = PAGE_SIZE;
> >  				}
> >  				if (!page)
> >  					goto wait_for_memory;
> > +				pg_size = page_size(page);
> >  				off = 0;
> >  			}
> 
> I didn't do anything with this.  I assume the original patch (which has
> been in -next since July 22) is good and the above is merely a cleanup?

Yes, just a cleanup.  Since Atul didn't offer an opinion, I assume
he doesn't care.

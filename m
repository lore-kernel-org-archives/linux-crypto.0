Return-Path: <SRS0=XUD9=VU=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.1 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C4ABAC7618B
	for <linux-crypto@archiver.kernel.org>; Tue, 23 Jul 2019 16:02:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 90CA721738
	for <linux-crypto@archiver.kernel.org>; Tue, 23 Jul 2019 16:02:51 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="ovAbxfUA"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387763AbfGWQCv (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 23 Jul 2019 12:02:51 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:57498 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728293AbfGWQCu (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 23 Jul 2019 12:02:50 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=I+4AWJfYixrAYAfDAYQ7YdaozuxSb83KaZ2pWoAh6p0=; b=ovAbxfUARIjlcZ/yDUszdNyUS
        k6DImR4clx4Nf4+GGZINvWXJ0yGqy5uq5Dg6cRpcJlCx7HOq5dOH+AqZJA/yjf/f9nNYih/YiirTL
        lEOYrW0wh+0Q2o3Tkb7Or8GWD7j7hhVUFHMFdU5IUWhs0MoV4Kq063FnmqlWHtij+ixK/7/qudcA2
        gfUGSk+Js1dqMY74dNrO2d2wak8DJIhR1iOv1zYjqi6YOtdLT9XTW15ugDA+xXcwG5YhSOsPYcArg
        4lRvwdLU3jZUESgt8gAB0Xu1A03V/ejYz0cIwdljrQtK86YaUacolwLdYt08MslRd+d5IUAdHcw99
        PSLqbjEHA==;
Received: from willy by bombadil.infradead.org with local (Exim 4.92 #3 (Red Hat Linux))
        id 1hpxFY-0003pm-LB; Tue, 23 Jul 2019 16:02:48 +0000
Date:   Tue, 23 Jul 2019 09:02:48 -0700
From:   Matthew Wilcox <willy@infradead.org>
To:     Ira Weiny <ira.weiny@intel.com>
Cc:     Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
        Atul Gupta <atul.gupta@chelsio.com>,
        linux-crypto@vger.kernel.org
Subject: Re: [PATCH v2 1/3] mm: Introduce page_size()
Message-ID: <20190723160248.GK363@bombadil.infradead.org>
References: <20190721104612.19120-1-willy@infradead.org>
 <20190721104612.19120-2-willy@infradead.org>
 <20190723004307.GB10284@iweiny-DESK2.sc.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190723004307.GB10284@iweiny-DESK2.sc.intel.com>
User-Agent: Mutt/1.11.4 (2019-03-13)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Mon, Jul 22, 2019 at 05:43:07PM -0700, Ira Weiny wrote:
> > diff --git a/drivers/crypto/chelsio/chtls/chtls_io.c b/drivers/crypto/chelsio/chtls/chtls_io.c
> > index 551bca6fef24..925be5942895 100644
> > --- a/drivers/crypto/chelsio/chtls/chtls_io.c
> > +++ b/drivers/crypto/chelsio/chtls/chtls_io.c
> > @@ -1078,7 +1078,7 @@ int chtls_sendmsg(struct sock *sk, struct msghdr *msg, size_t size)
> >  			bool merge;
> >  
> >  			if (page)
> > -				pg_size <<= compound_order(page);
> > +				pg_size = page_size(page);
> >  			if (off < pg_size &&
> >  			    skb_can_coalesce(skb, i, page, off)) {
> >  				merge = 1;
> > @@ -1105,8 +1105,7 @@ int chtls_sendmsg(struct sock *sk, struct msghdr *msg, size_t size)
> >  							   __GFP_NORETRY,
> >  							   order);
> >  					if (page)
> > -						pg_size <<=
> > -							compound_order(page);
> > +						pg_size <<= order;
> 
> Looking at the code I see pg_size should be PAGE_SIZE right before this so why
> not just use the new call and remove the initial assignment?

This driver is really convoluted.  I wasn't certain I wouldn't break it
in some horrid way.  I made larger changes to it originally, then they
touched this part of the driver and I had to rework the patch to apply
on top of their changes.  So I did something more minimal.

This, on top of what's in Andrew's tree, would be my guess, but I don't
have the hardware.

diff --git a/drivers/crypto/chelsio/chtls/chtls_io.c b/drivers/crypto/chelsio/chtls/chtls_io.c
index 925be5942895..d4eb0fcd04c7 100644
--- a/drivers/crypto/chelsio/chtls/chtls_io.c
+++ b/drivers/crypto/chelsio/chtls/chtls_io.c
@@ -1073,7 +1073,7 @@ int chtls_sendmsg(struct sock *sk, struct msghdr *msg, size_t size)
 		} else {
 			int i = skb_shinfo(skb)->nr_frags;
 			struct page *page = TCP_PAGE(sk);
-			int pg_size = PAGE_SIZE;
+			unsigned int pg_size = 0;
 			int off = TCP_OFF(sk);
 			bool merge;
 
@@ -1092,7 +1092,7 @@ int chtls_sendmsg(struct sock *sk, struct msghdr *msg, size_t size)
 			if (page && off == pg_size) {
 				put_page(page);
 				TCP_PAGE(sk) = page = NULL;
-				pg_size = PAGE_SIZE;
+				pg_size = 0;
 			}
 
 			if (!page) {
@@ -1104,15 +1104,13 @@ int chtls_sendmsg(struct sock *sk, struct msghdr *msg, size_t size)
 							   __GFP_NOWARN |
 							   __GFP_NORETRY,
 							   order);
-					if (page)
-						pg_size <<= order;
 				}
 				if (!page) {
 					page = alloc_page(gfp);
-					pg_size = PAGE_SIZE;
 				}
 				if (!page)
 					goto wait_for_memory;
+				pg_size = page_size(page);
 				off = 0;
 			}
 copy:

Return-Path: <SRS0=XUD9=VU=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 02E7CC76186
	for <linux-crypto@archiver.kernel.org>; Tue, 23 Jul 2019 17:58:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D2145218A0
	for <linux-crypto@archiver.kernel.org>; Tue, 23 Jul 2019 17:58:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728005AbfGWR6j (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 23 Jul 2019 13:58:39 -0400
Received: from mga06.intel.com ([134.134.136.31]:37893 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726513AbfGWR6j (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 23 Jul 2019 13:58:39 -0400
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by orsmga104.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 23 Jul 2019 10:58:39 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,299,1559545200"; 
   d="scan'208";a="160276390"
Received: from iweiny-desk2.sc.intel.com ([10.3.52.157])
  by orsmga007.jf.intel.com with ESMTP; 23 Jul 2019 10:58:38 -0700
Date:   Tue, 23 Jul 2019 10:58:38 -0700
From:   Ira Weiny <ira.weiny@intel.com>
To:     Matthew Wilcox <willy@infradead.org>
Cc:     Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
        Atul Gupta <atul.gupta@chelsio.com>,
        linux-crypto@vger.kernel.org
Subject: Re: [PATCH v2 1/3] mm: Introduce page_size()
Message-ID: <20190723175838.GA29729@iweiny-DESK2.sc.intel.com>
References: <20190721104612.19120-1-willy@infradead.org>
 <20190721104612.19120-2-willy@infradead.org>
 <20190723004307.GB10284@iweiny-DESK2.sc.intel.com>
 <20190723160248.GK363@bombadil.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190723160248.GK363@bombadil.infradead.org>
User-Agent: Mutt/1.11.1 (2018-12-01)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Tue, Jul 23, 2019 at 09:02:48AM -0700, Matthew Wilcox wrote:
> On Mon, Jul 22, 2019 at 05:43:07PM -0700, Ira Weiny wrote:
> > > diff --git a/drivers/crypto/chelsio/chtls/chtls_io.c b/drivers/crypto/chelsio/chtls/chtls_io.c
> > > index 551bca6fef24..925be5942895 100644
> > > --- a/drivers/crypto/chelsio/chtls/chtls_io.c
> > > +++ b/drivers/crypto/chelsio/chtls/chtls_io.c
> > > @@ -1078,7 +1078,7 @@ int chtls_sendmsg(struct sock *sk, struct msghdr *msg, size_t size)
> > >  			bool merge;
> > >  
> > >  			if (page)
> > > -				pg_size <<= compound_order(page);
> > > +				pg_size = page_size(page);
> > >  			if (off < pg_size &&
> > >  			    skb_can_coalesce(skb, i, page, off)) {
> > >  				merge = 1;
> > > @@ -1105,8 +1105,7 @@ int chtls_sendmsg(struct sock *sk, struct msghdr *msg, size_t size)
> > >  							   __GFP_NORETRY,
> > >  							   order);
> > >  					if (page)
> > > -						pg_size <<=
> > > -							compound_order(page);
> > > +						pg_size <<= order;
> > 
> > Looking at the code I see pg_size should be PAGE_SIZE right before this so why
> > not just use the new call and remove the initial assignment?
> 
> This driver is really convoluted.

Agreed...

>
> I wasn't certain I wouldn't break it
> in some horrid way.  I made larger changes to it originally, then they
> touched this part of the driver and I had to rework the patch to apply
> on top of their changes.  So I did something more minimal.
> 
> This, on top of what's in Andrew's tree, would be my guess, but I don't
> have the hardware.
> 
> diff --git a/drivers/crypto/chelsio/chtls/chtls_io.c b/drivers/crypto/chelsio/chtls/chtls_io.c
> index 925be5942895..d4eb0fcd04c7 100644
> --- a/drivers/crypto/chelsio/chtls/chtls_io.c
> +++ b/drivers/crypto/chelsio/chtls/chtls_io.c
> @@ -1073,7 +1073,7 @@ int chtls_sendmsg(struct sock *sk, struct msghdr *msg, size_t size)
>  		} else {
>  			int i = skb_shinfo(skb)->nr_frags;
>  			struct page *page = TCP_PAGE(sk);
> -			int pg_size = PAGE_SIZE;
> +			unsigned int pg_size = 0;
>  			int off = TCP_OFF(sk);
>  			bool merge;
>  
> @@ -1092,7 +1092,7 @@ int chtls_sendmsg(struct sock *sk, struct msghdr *msg, size_t size)
>  			if (page && off == pg_size) {
>  				put_page(page);
>  				TCP_PAGE(sk) = page = NULL;
> -				pg_size = PAGE_SIZE;
> +				pg_size = 0;

Yea...  I was not sure about this one at first...  :-/

>  			}
>  
>  			if (!page) {
> @@ -1104,15 +1104,13 @@ int chtls_sendmsg(struct sock *sk, struct msghdr *msg, size_t size)
>  							   __GFP_NOWARN |
>  							   __GFP_NORETRY,
>  							   order);
> -					if (page)
> -						pg_size <<= order;
>  				}
>  				if (!page) {
>  					page = alloc_page(gfp);
> -					pg_size = PAGE_SIZE;
>  				}
>  				if (!page)
>  					goto wait_for_memory;

Side note: why 2 checks for !page?

Reviewed-by: Ira Weiny <ira.weiny@intel.com>

> +				pg_size = page_size(page);
>  				off = 0;
>  			}
>  copy:

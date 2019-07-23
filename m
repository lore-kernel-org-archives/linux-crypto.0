Return-Path: <SRS0=XUD9=VU=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.1 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2CA3AC76186
	for <linux-crypto@archiver.kernel.org>; Tue, 23 Jul 2019 18:14:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id EF53F20665
	for <linux-crypto@archiver.kernel.org>; Tue, 23 Jul 2019 18:14:15 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="JCBoGa/9"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726386AbfGWSOO (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 23 Jul 2019 14:14:14 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:37368 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725848AbfGWSOO (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 23 Jul 2019 14:14:14 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=meFPjAHnVpkx5LzG9td2xbKYymV0m46R0toM8uhLgg4=; b=JCBoGa/9fMlH12kemgaHenbGi
        Y4ZMyaL5fQuZnEcxRikVrj03Lz0tgfVMCuczzN07zpVBD0rNInixq1H9UAaW6FSvOqwF11DL7A4fo
        CfObJnXMtoO3//rBTxCSrSu/pCnlVVWIYTXirei8pOS7LsJcimLotK/Oy9EcFQTrrTHg+pTQaDFsm
        D4vP8YZnwRIeci4FPJgi976tbB2AVhRiwW/sIREyXx23Xj3gW5lvMlYV4bGksXwIZAdbK7CtbgMyr
        G3cz7l2Kig4hHN7JNCmZNWvVb07hCTvLGJgOL6sgItjf/8EYQjF8uss8/NDmslnZgsdZ9tDkucoHA
        9xe/HMC/A==;
Received: from willy by bombadil.infradead.org with local (Exim 4.92 #3 (Red Hat Linux))
        id 1hpzIj-00021d-9d; Tue, 23 Jul 2019 18:14:13 +0000
Date:   Tue, 23 Jul 2019 11:14:13 -0700
From:   Matthew Wilcox <willy@infradead.org>
To:     Ira Weiny <ira.weiny@intel.com>
Cc:     Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
        Atul Gupta <atul.gupta@chelsio.com>,
        linux-crypto@vger.kernel.org
Subject: Re: [PATCH v2 1/3] mm: Introduce page_size()
Message-ID: <20190723181413.GN363@bombadil.infradead.org>
References: <20190721104612.19120-1-willy@infradead.org>
 <20190721104612.19120-2-willy@infradead.org>
 <20190723004307.GB10284@iweiny-DESK2.sc.intel.com>
 <20190723160248.GK363@bombadil.infradead.org>
 <20190723175838.GA29729@iweiny-DESK2.sc.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190723175838.GA29729@iweiny-DESK2.sc.intel.com>
User-Agent: Mutt/1.11.4 (2019-03-13)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Tue, Jul 23, 2019 at 10:58:38AM -0700, Ira Weiny wrote:
> > @@ -1092,7 +1092,7 @@ int chtls_sendmsg(struct sock *sk, struct msghdr *msg, size_t size)
> >  			if (page && off == pg_size) {
> >  				put_page(page);
> >  				TCP_PAGE(sk) = page = NULL;
> > -				pg_size = PAGE_SIZE;
> > +				pg_size = 0;
> 
> Yea...  I was not sure about this one at first...  :-/

I'm not sure we actually need to change pg_size here, but it seemed
appropriate to set it back to 0.

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
> 
> Side note: why 2 checks for !page?

Because page is assigned to after the first check ...


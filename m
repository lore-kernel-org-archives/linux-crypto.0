Return-Path: <SRS0=XUD9=VU=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A9737C76186
	for <linux-crypto@archiver.kernel.org>; Tue, 23 Jul 2019 20:44:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 82E49218D4
	for <linux-crypto@archiver.kernel.org>; Tue, 23 Jul 2019 20:44:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728529AbfGWUoT (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 23 Jul 2019 16:44:19 -0400
Received: from mga07.intel.com ([134.134.136.100]:64460 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726920AbfGWUoT (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 23 Jul 2019 16:44:19 -0400
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by orsmga105.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 23 Jul 2019 13:44:18 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,300,1559545200"; 
   d="scan'208";a="368558615"
Received: from iweiny-desk2.sc.intel.com ([10.3.52.157])
  by fmsmga005.fm.intel.com with ESMTP; 23 Jul 2019 13:44:17 -0700
Date:   Tue, 23 Jul 2019 13:44:16 -0700
From:   Ira Weiny <ira.weiny@intel.com>
To:     Matthew Wilcox <willy@infradead.org>
Cc:     Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
        Atul Gupta <atul.gupta@chelsio.com>,
        linux-crypto@vger.kernel.org
Subject: Re: [PATCH v2 1/3] mm: Introduce page_size()
Message-ID: <20190723204416.GA27491@iweiny-DESK2.sc.intel.com>
References: <20190721104612.19120-1-willy@infradead.org>
 <20190721104612.19120-2-willy@infradead.org>
 <20190723004307.GB10284@iweiny-DESK2.sc.intel.com>
 <20190723160248.GK363@bombadil.infradead.org>
 <20190723175838.GA29729@iweiny-DESK2.sc.intel.com>
 <20190723181413.GN363@bombadil.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190723181413.GN363@bombadil.infradead.org>
User-Agent: Mutt/1.11.1 (2018-12-01)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Tue, Jul 23, 2019 at 11:14:13AM -0700, Matthew Wilcox wrote:
> On Tue, Jul 23, 2019 at 10:58:38AM -0700, Ira Weiny wrote:
> > > @@ -1092,7 +1092,7 @@ int chtls_sendmsg(struct sock *sk, struct msghdr *msg, size_t size)
> > >  			if (page && off == pg_size) {
> > >  				put_page(page);
> > >  				TCP_PAGE(sk) = page = NULL;
> > > -				pg_size = PAGE_SIZE;
> > > +				pg_size = 0;
> > 
> > Yea...  I was not sure about this one at first...  :-/
> 
> I'm not sure we actually need to change pg_size here, but it seemed
> appropriate to set it back to 0.
> 
> > >  							   __GFP_NORETRY,
> > >  							   order);
> > > -					if (page)
> > > -						pg_size <<= order;
> > >  				}
> > >  				if (!page) {
> > >  					page = alloc_page(gfp);
> > > -					pg_size = PAGE_SIZE;
> > >  				}
> > >  				if (!page)
> > >  					goto wait_for_memory;
> > 
> > Side note: why 2 checks for !page?
> 
> Because page is assigned to after the first check ...

Ah yea duh!  Sorry it is a bit hard to follow.

Ira


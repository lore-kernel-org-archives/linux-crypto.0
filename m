Return-Path: <SRS0=lF8a=XR=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5B4A5C4360D
	for <linux-crypto@archiver.kernel.org>; Sun, 22 Sep 2019 02:13:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2FA4D20C01
	for <linux-crypto@archiver.kernel.org>; Sun, 22 Sep 2019 02:13:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727050AbfIVCNw convert rfc822-to-8bit (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Sat, 21 Sep 2019 22:13:52 -0400
Received: from mga18.intel.com ([134.134.136.126]:64842 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727027AbfIVCNv (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Sat, 21 Sep 2019 22:13:51 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga106.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 21 Sep 2019 19:13:51 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,534,1559545200"; 
   d="scan'208";a="182164757"
Received: from fmsmsx103.amr.corp.intel.com ([10.18.124.201])
  by orsmga008.jf.intel.com with ESMTP; 21 Sep 2019 19:13:50 -0700
Received: from FMSMSX110.amr.corp.intel.com (10.18.116.10) by
 FMSMSX103.amr.corp.intel.com (10.18.124.201) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Sat, 21 Sep 2019 19:13:50 -0700
Received: from crsmsx104.amr.corp.intel.com (172.18.63.32) by
 fmsmsx110.amr.corp.intel.com (10.18.116.10) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Sat, 21 Sep 2019 19:13:50 -0700
Received: from crsmsx101.amr.corp.intel.com ([169.254.1.249]) by
 CRSMSX104.amr.corp.intel.com ([169.254.6.58]) with mapi id 14.03.0439.000;
 Sat, 21 Sep 2019 20:13:48 -0600
From:   "Weiny, Ira" <ira.weiny@intel.com>
To:     Matthew Wilcox <willy@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>
CC:     "linux-mm@kvack.org" <linux-mm@kvack.org>,
        Atul Gupta <atul.gupta@chelsio.com>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>
Subject: RE: [PATCH v2 1/3] mm: Introduce page_size()
Thread-Topic: [PATCH v2 1/3] mm: Introduce page_size()
Thread-Index: AQHVcAsqYO/T6JFMt0+7/3dzSRFwbac1twUAgAE+cXA=
Date:   Sun, 22 Sep 2019 02:13:46 +0000
Message-ID: <2807E5FD2F6FDA4886F6618EAC48510E89916163@CRSMSX101.amr.corp.intel.com>
References: <20190721104612.19120-1-willy@infradead.org>
 <20190721104612.19120-2-willy@infradead.org>
 <20190723004307.GB10284@iweiny-DESK2.sc.intel.com>
 <20190723160248.GK363@bombadil.infradead.org>
 <20190920162848.950dd70264e670a485f410dc@linux-foundation.org>
 <20190921010948.GD15392@bombadil.infradead.org>
In-Reply-To: <20190921010948.GD15392@bombadil.infradead.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-titus-metadata-40: eyJDYXRlZ29yeUxhYmVscyI6IiIsIk1ldGFkYXRhIjp7Im5zIjoiaHR0cDpcL1wvd3d3LnRpdHVzLmNvbVwvbnNcL0ludGVsMyIsImlkIjoiMzRhZTQ2ODItNGJhOC00NzFlLWFkYjgtNGM3YjNkMTgyMDU2IiwicHJvcHMiOlt7Im4iOiJDVFBDbGFzc2lmaWNhdGlvbiIsInZhbHMiOlt7InZhbHVlIjoiQ1RQX05UIn1dfV19LCJTdWJqZWN0TGFiZWxzIjpbXSwiVE1DVmVyc2lvbiI6IjE3LjEwLjE4MDQuNDkiLCJUcnVzdGVkTGFiZWxIYXNoIjoiUzZrOEkzeFNObTNzXC9jMW1VaGFzY1BWRnJQV3FkZG5idmRlbitEdHYwbENHRFVFQWYrTU95ZDlKY2swV1VlTG0ifQ==
x-ctpclassification: CTP_NT
dlp-product: dlpe-windows
dlp-version: 11.2.0.6
dlp-reaction: no-action
x-originating-ip: [172.18.205.10]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

> On Fri, Sep 20, 2019 at 04:28:48PM -0700, Andrew Morton wrote:
> > On Tue, 23 Jul 2019 09:02:48 -0700 Matthew Wilcox <willy@infradead.org>
> wrote:
> >
> > > On Mon, Jul 22, 2019 at 05:43:07PM -0700, Ira Weiny wrote:
> > > > > diff --git a/drivers/crypto/chelsio/chtls/chtls_io.c
> > > > > b/drivers/crypto/chelsio/chtls/chtls_io.c
> > > > > index 551bca6fef24..925be5942895 100644
> > > > > --- a/drivers/crypto/chelsio/chtls/chtls_io.c
> > > > > +++ b/drivers/crypto/chelsio/chtls/chtls_io.c
> > > > > @@ -1078,7 +1078,7 @@ int chtls_sendmsg(struct sock *sk, struct
> msghdr *msg, size_t size)
> > > > >  			bool merge;
> > > > >
> > > > >  			if (page)
> > > > > -				pg_size <<= compound_order(page);
> > > > > +				pg_size = page_size(page);
> > > > >  			if (off < pg_size &&
> > > > >  			    skb_can_coalesce(skb, i, page, off)) {
> > > > >  				merge = 1;
> > > > > @@ -1105,8 +1105,7 @@ int chtls_sendmsg(struct sock *sk, struct
> msghdr *msg, size_t size)
> > > > >
> __GFP_NORETRY,
> > > > >  							   order);
> > > > >  					if (page)
> > > > > -						pg_size <<=
> > > > > -
> 	compound_order(page);
> > > > > +						pg_size <<= order;
> > > >
> > > > Looking at the code I see pg_size should be PAGE_SIZE right before
> > > > this so why not just use the new call and remove the initial assignment?
> > >
> > > This driver is really convoluted.  I wasn't certain I wouldn't break
> > > it in some horrid way.  I made larger changes to it originally, then
> > > they touched this part of the driver and I had to rework the patch
> > > to apply on top of their changes.  So I did something more minimal.
> > >
> > > This, on top of what's in Andrew's tree, would be my guess, but I
> > > don't have the hardware.
> > >
> > > diff --git a/drivers/crypto/chelsio/chtls/chtls_io.c
> > > b/drivers/crypto/chelsio/chtls/chtls_io.c
> > > index 925be5942895..d4eb0fcd04c7 100644
> > > --- a/drivers/crypto/chelsio/chtls/chtls_io.c
> > > +++ b/drivers/crypto/chelsio/chtls/chtls_io.c
> > > @@ -1073,7 +1073,7 @@ int chtls_sendmsg(struct sock *sk, struct
> msghdr *msg, size_t size)
> > >  		} else {
> > >  			int i = skb_shinfo(skb)->nr_frags;
> > >  			struct page *page = TCP_PAGE(sk);
> > > -			int pg_size = PAGE_SIZE;
> > > +			unsigned int pg_size = 0;
> > >  			int off = TCP_OFF(sk);
> > >  			bool merge;
> > >
> > > @@ -1092,7 +1092,7 @@ int chtls_sendmsg(struct sock *sk, struct
> msghdr *msg, size_t size)
> > >  			if (page && off == pg_size) {
> > >  				put_page(page);
> > >  				TCP_PAGE(sk) = page = NULL;
> > > -				pg_size = PAGE_SIZE;
> > > +				pg_size = 0;
> > >  			}
> > >
> > >  			if (!page) {
> > > @@ -1104,15 +1104,13 @@ int chtls_sendmsg(struct sock *sk, struct
> msghdr *msg, size_t size)
> > >  							   __GFP_NOWARN |
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
> > > +				pg_size = page_size(page);
> > >  				off = 0;
> > >  			}
> >
> > I didn't do anything with this.  I assume the original patch (which
> > has been in -next since July 22) is good and the above is merely a cleanup?
> 
> Yes, just a cleanup.  Since Atul didn't offer an opinion, I assume he doesn't
> care.

Agreed I think what went in is fine.

Ira


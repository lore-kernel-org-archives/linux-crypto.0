Return-Path: <SRS0=EE7o=UX=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_MUTT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7A18AC43613
	for <linux-crypto@archiver.kernel.org>; Mon, 24 Jun 2019 17:35:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 55E3B20663
	for <linux-crypto@archiver.kernel.org>; Mon, 24 Jun 2019 17:35:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731313AbfFXRfg (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 24 Jun 2019 13:35:36 -0400
Received: from mga07.intel.com ([134.134.136.100]:15148 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731032AbfFXRfg (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 24 Jun 2019 13:35:36 -0400
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by orsmga105.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 24 Jun 2019 10:35:36 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.63,412,1557212400"; 
   d="scan'208";a="187988905"
Received: from ideak-desk.fi.intel.com ([10.237.72.204])
  by fmsmga002.fm.intel.com with ESMTP; 24 Jun 2019 10:35:33 -0700
Date:   Mon, 24 Jun 2019 20:35:33 +0300
From:   Imre Deak <imre.deak@intel.com>
To:     Herbert Xu <herbert@gondor.apana.org.au>
Cc:     Christophe Leroy <christophe.leroy@c-s.fr>,
        "David S. Miller" <davem@davemloft.net>, horia.geanta@nxp.com,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org
Subject: Re: [PATCH v4 1/4] lib/scatterlist: Fix mapping iterator when
 sg->offset is greater than PAGE_SIZE
Message-ID: <20190624173533.GA809@ideak-desk.fi.intel.com>
Reply-To: imre.deak@intel.com
References: <cover.1560805614.git.christophe.leroy@c-s.fr>
 <f28c6b0e2f9510f42ca934f19c4315084e668c21.1560805614.git.christophe.leroy@c-s.fr>
 <20190620060221.q4pbsqzsza3pxs42@gondor.apana.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190620060221.q4pbsqzsza3pxs42@gondor.apana.org.au>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Hi,

On Thu, Jun 20, 2019 at 02:02:21PM +0800, Herbert Xu wrote:
> On Mon, Jun 17, 2019 at 09:15:02PM +0000, Christophe Leroy wrote:
> > All mapping iterator logic is based on the assumption that sg->offset
> > is always lower than PAGE_SIZE.
> > 
> > But there are situations where sg->offset is such that the SG item
> > is on the second page.

could you explain how sg->offset becomes >= PAGE_SIZE?

--Imre


> > In that case sg_copy_to_buffer() fails
> > properly copying the data into the buffer. One of the reason is
> > that the data will be outside the kmapped area used to access that
> > data.
> > 
> > This patch fixes the issue by adjusting the mapping iterator
> > offset and pgoffset fields such that offset is always lower than
> > PAGE_SIZE.
> > 
> > Signed-off-by: Christophe Leroy <christophe.leroy@c-s.fr>
> > Fixes: 4225fc8555a9 ("lib/scatterlist: use page iterator in the mapping iterator")
> > Cc: stable@vger.kernel.org
> > ---
> >  lib/scatterlist.c | 9 +++++++--
> >  1 file changed, 7 insertions(+), 2 deletions(-)
> 
> Good catch.
> 
> > @@ -686,7 +686,12 @@ static bool sg_miter_get_next_page(struct sg_mapping_iter *miter)
> >  		sg = miter->piter.sg;
> >  		pgoffset = miter->piter.sg_pgoffset;
> >  
> > -		miter->__offset = pgoffset ? 0 : sg->offset;
> > +		offset = pgoffset ? 0 : sg->offset;
> > +		while (offset >= PAGE_SIZE) {
> > +			miter->piter.sg_pgoffset = ++pgoffset;
> > +			offset -= PAGE_SIZE;
> > +		}
> 
> How about
> 
> 	miter->piter.sg_pgoffset += offset >> PAGE_SHIFT;
> 	offset &= PAGE_SIZE - 1;
> 
> Thanks,
> -- 
> Email: Herbert Xu <herbert@gondor.apana.org.au>
> Home Page: http://gondor.apana.org.au/~herbert/
> PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt

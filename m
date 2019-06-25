Return-Path: <SRS0=EEB8=UY=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_NEOMUTT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4D213C4646C
	for <linux-crypto@archiver.kernel.org>; Tue, 25 Jun 2019 01:21:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 21FAE20663
	for <linux-crypto@archiver.kernel.org>; Tue, 25 Jun 2019 01:21:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729424AbfFYBVV (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 24 Jun 2019 21:21:21 -0400
Received: from helcar.hmeau.com ([216.24.177.18]:35818 "EHLO deadmen.hmeau.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729384AbfFYBVV (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 24 Jun 2019 21:21:21 -0400
Received: from gondobar.mordor.me.apana.org.au ([192.168.128.4] helo=gondobar)
        by deadmen.hmeau.com with esmtps (Exim 4.89 #2 (Debian))
        id 1hfa8x-0004UA-5l; Tue, 25 Jun 2019 09:21:07 +0800
Received: from herbert by gondobar with local (Exim 4.89)
        (envelope-from <herbert@gondor.apana.org.au>)
        id 1hfa8p-0005ra-Sk; Tue, 25 Jun 2019 09:20:59 +0800
Date:   Tue, 25 Jun 2019 09:20:59 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Imre Deak <imre.deak@intel.com>
Cc:     Christophe Leroy <christophe.leroy@c-s.fr>,
        "David S. Miller" <davem@davemloft.net>, horia.geanta@nxp.com,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org
Subject: Re: [PATCH v4 1/4] lib/scatterlist: Fix mapping iterator when
 sg->offset is greater than PAGE_SIZE
Message-ID: <20190625012059.albyfaca73uoaoxr@gondor.apana.org.au>
References: <cover.1560805614.git.christophe.leroy@c-s.fr>
 <f28c6b0e2f9510f42ca934f19c4315084e668c21.1560805614.git.christophe.leroy@c-s.fr>
 <20190620060221.q4pbsqzsza3pxs42@gondor.apana.org.au>
 <20190624173533.GA809@ideak-desk.fi.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190624173533.GA809@ideak-desk.fi.intel.com>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Mon, Jun 24, 2019 at 08:35:33PM +0300, Imre Deak wrote:
> Hi,
> 
> On Thu, Jun 20, 2019 at 02:02:21PM +0800, Herbert Xu wrote:
> > On Mon, Jun 17, 2019 at 09:15:02PM +0000, Christophe Leroy wrote:
> > > All mapping iterator logic is based on the assumption that sg->offset
> > > is always lower than PAGE_SIZE.
> > > 
> > > But there are situations where sg->offset is such that the SG item
> > > is on the second page.
> 
> could you explain how sg->offset becomes >= PAGE_SIZE?

The network stack can produce SG list elements that are longer
than PAGE_SIZE.  If you the iterate over it one page at a time
then the offset can exceed PAGE_SIZE.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt

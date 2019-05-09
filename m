Return-Path: <SRS0=8ziv=TJ=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.9 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_NEOMUTT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 38612C04AAF
	for <linux-crypto@archiver.kernel.org>; Thu,  9 May 2019 05:24:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id F088120850
	for <linux-crypto@archiver.kernel.org>; Thu,  9 May 2019 05:24:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726281AbfEIFYF (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 9 May 2019 01:24:05 -0400
Received: from [5.180.42.13] ([5.180.42.13]:53918 "EHLO deadmen.hmeau.com"
        rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org with ESMTP
        id S1725936AbfEIFYF (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 9 May 2019 01:24:05 -0400
Received: from gondobar.mordor.me.apana.org.au ([192.168.128.4] helo=gondobar)
        by deadmen.hmeau.com with esmtps (Exim 4.89 #2 (Debian))
        id 1hObXG-0001CA-LP; Thu, 09 May 2019 13:24:02 +0800
Received: from herbert by gondobar with local (Exim 4.89)
        (envelope-from <herbert@gondor.apana.org.au>)
        id 1hObX6-0001Yk-GZ; Thu, 09 May 2019 13:23:52 +0800
Date:   Thu, 9 May 2019 13:23:52 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Horia Geanta <horia.geanta@nxp.com>
Cc:     Michael Ellerman <mpe@ellerman.id.au>,
        Vakul Garg <vakul.garg@nxp.com>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        Aymen Sghaier <aymen.sghaier@nxp.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>
Subject: Re: [PATCH] crypto: caam/jr - Remove extra memory barrier during job
 ring dequeue
Message-ID: <20190509052352.nje7a4niuc2n6c57@gondor.apana.org.au>
References: <87pnp2aflz.fsf@concordia.ellerman.id.au>
 <VI1PR0402MB34851F6AB9FE68A2322EB09E98340@VI1PR0402MB3485.eurprd04.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <VI1PR0402MB34851F6AB9FE68A2322EB09E98340@VI1PR0402MB3485.eurprd04.prod.outlook.com>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Thu, May 02, 2019 at 11:08:55AM +0000, Horia Geanta wrote:
>
> >> +
> >>  static inline void wr_reg32(void __iomem *reg, u32 data)
> >>  {
> >>  	if (caam_little_end)
> > 
> > This crashes on my p5020ds. Did you test on powerpc?
> > 
> > # first bad commit: [bbfcac5ff5f26aafa51935a62eb86b6eacfe8a49] crypto: caam/jr - Remove extra memory barrier during job ring dequeue
> 
> Thanks for the report Michael.
> 
> Any hint what would be the proper approach here - to have relaxed I/O accessors
> that would work both for ARM and PPC, and avoid ifdeffery etc.?

Since no fix has been found I'm reverting the commit in question.

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt

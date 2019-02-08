Return-Path: <SRS0=4jM/=QP=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_NEOMUTT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 21BEAC169C4
	for <linux-crypto@archiver.kernel.org>; Fri,  8 Feb 2019 11:45:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id ED46F20823
	for <linux-crypto@archiver.kernel.org>; Fri,  8 Feb 2019 11:45:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727171AbfBHLpK (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 8 Feb 2019 06:45:10 -0500
Received: from orcrist.hmeau.com ([104.223.48.154]:35222 "EHLO
        deadmen.hmeau.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726781AbfBHLpK (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 8 Feb 2019 06:45:10 -0500
Received: from gondobar.mordor.me.apana.org.au ([192.168.128.4] helo=gondobar)
        by deadmen.hmeau.com with esmtps (Exim 4.89 #2 (Debian))
        id 1gs4ac-0004sc-HV; Fri, 08 Feb 2019 19:45:02 +0800
Received: from herbert by gondobar with local (Exim 4.89)
        (envelope-from <herbert@gondor.apana.org.au>)
        id 1gs4aZ-0002iX-2p; Fri, 08 Feb 2019 19:44:59 +0800
Date:   Fri, 8 Feb 2019 19:44:59 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Ard Biesheuvel <ard.biesheuvel@linaro.org>
Cc:     Horia Geanta <horia.geanta@nxp.com>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "kernel@pengutronix.de" <kernel@pengutronix.de>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: Re: [PATCH] crypto: caam - Do not overwrite IV
Message-ID: <20190208114459.5nixe76xmmkhur75@gondor.apana.org.au>
References: <20190131061225.15541-1-s.hauer@pengutronix.de>
 <VI1PR0402MB3485ED41FE4B512C83271E0B986D0@VI1PR0402MB3485.eurprd04.prod.outlook.com>
 <20190208071635.5dkhabduambzzsu3@gondor.apana.org.au>
 <VI1PR0402MB3485ABA90793B50E7744A0A198690@VI1PR0402MB3485.eurprd04.prod.outlook.com>
 <CAKv+Gu9F3Uof+RfWsaB8qk_WuWxnopd_nA1kEXhbYP5ZCejvWQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAKv+Gu9F3Uof+RfWsaB8qk_WuWxnopd_nA1kEXhbYP5ZCejvWQ@mail.gmail.com>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Fri, Feb 08, 2019 at 09:55:19AM +0100, Ard Biesheuvel wrote:
>
> So I would argue that the generic GCM driver should ensure that
> whatever it passes into scatterlists is safe for non-cache coherent
> DMA. Blowing up the struct like this is probably not the right answer,
> instead, we should probably have an auth_tag pointer and a separate
> kmalloc buffer so we don't affect cache coherent architectures too
> much.

Yes I agree.  GCM needs to ensure auth_tag is aligned properly.

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt

Return-Path: <SRS0=IzQh=TY=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_NEOMUTT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 423A2C282E3
	for <linux-crypto@archiver.kernel.org>; Fri, 24 May 2019 12:55:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1886121773
	for <linux-crypto@archiver.kernel.org>; Fri, 24 May 2019 12:55:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391178AbfEXMzk (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 24 May 2019 08:55:40 -0400
Received: from helcar.hmeau.com ([216.24.177.18]:60498 "EHLO deadmen.hmeau.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390946AbfEXMzj (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 24 May 2019 08:55:39 -0400
Received: from gondobar.mordor.me.apana.org.au ([192.168.128.4] helo=gondobar)
        by deadmen.hmeau.com with esmtps (Exim 4.89 #2 (Debian))
        id 1hU9jN-0007L2-FN; Fri, 24 May 2019 20:55:29 +0800
Received: from herbert by gondobar with local (Exim 4.89)
        (envelope-from <herbert@gondor.apana.org.au>)
        id 1hU9jF-0001Pw-QS; Fri, 24 May 2019 20:55:21 +0800
Date:   Fri, 24 May 2019 20:55:21 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Neal Liu <neal.liu@mediatek.com>
Cc:     "mark.rutland@arm.com" <mark.rutland@arm.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        wsd_upstream <wsd_upstream@mediatek.com>,
        Stephan Mueller <smueller@chronox.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "robh+dt@kernel.org" <robh+dt@kernel.org>,
        "linux-mediatek@lists.infradead.org" 
        <linux-mediatek@lists.infradead.org>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "mpm@selenic.com" <mpm@selenic.com>,
        "matthias.bgg@gmail.com" <matthias.bgg@gmail.com>,
        Crystal Guo =?utf-8?B?KOmDreaZtik=?= <Crystal.Guo@mediatek.com>
Subject: Re: [PATCH 3/3] hwrng: add mt67xx-rng driver
Message-ID: <20190524125521.5nhulltihs5ivn6d@gondor.apana.org.au>
References: <1557287937-2410-1-git-send-email-neal.liu@mediatek.com>
 <1557287937-2410-4-git-send-email-neal.liu@mediatek.com>
 <12193108.aNnqf5ydOJ@tauon.chronox.de>
 <1557311737.11818.11.camel@mtkswgap22>
 <20190509052649.xfkgb3qd7rhcgktj@gondor.apana.org.au>
 <1557413686.23445.6.camel@mtkswgap22>
 <20190510063915.kwqy3e5urs6j7ity@gondor.apana.org.au>
 <1558683754.5671.4.camel@mtkswgap22>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1558683754.5671.4.camel@mtkswgap22>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Fri, May 24, 2019 at 03:42:34PM +0800, Neal Liu wrote:
> Hi Herbert,
> 	Could you kindly help to review our patches?

You need acks for patches 1 and 2.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt

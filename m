Return-Path: <SRS0=/CTJ=QB=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED,USER_AGENT_NEOMUTT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7655CC282C0
	for <linux-crypto@archiver.kernel.org>; Fri, 25 Jan 2019 13:48:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4E4CB2087E
	for <linux-crypto@archiver.kernel.org>; Fri, 25 Jan 2019 13:48:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727721AbfAYNsG (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 25 Jan 2019 08:48:06 -0500
Received: from orcrist.hmeau.com ([104.223.48.154]:44864 "EHLO
        deadmen.hmeau.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726761AbfAYNsG (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 25 Jan 2019 08:48:06 -0500
Received: from gondobar.mordor.me.apana.org.au ([192.168.128.4] helo=gondobar)
        by deadmen.hmeau.com with esmtps (Exim 4.89 #2 (Debian))
        id 1gn1q0-0003pS-CN; Fri, 25 Jan 2019 21:48:04 +0800
Received: from herbert by gondobar with local (Exim 4.89)
        (envelope-from <herbert@gondor.apana.org.au>)
        id 1gn1pt-0003Jv-1i; Fri, 25 Jan 2019 21:47:57 +0800
Date:   Fri, 25 Jan 2019 21:47:57 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Horia Geanta <horia.geanta@nxp.com>
Cc:     Roland Hieber <rhi@pengutronix.de>,
        Aymen Sghaier <aymen.sghaier@nxp.com>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        Jesper Nilsson <jesper.nilsson@axis.com>,
        Lars Persson <lars.persson@axis.com>,
        Christian Lamparter <chunkeey@gmail.com>,
        Roland Hieber <r.hieber@pengutronix.de>,
        "David S. Miller" <davem@davemloft.net>,
        "kernel@pengutronix.de" <kernel@pengutronix.de>
Subject: Re: [PATCH 2/2] crypto: caam - fix DMA mapping of stack memory
Message-ID: <20190125134756.5f5e2uxmwvtnc6bb@gondor.apana.org.au>
References: <20190122152651.1150-1-rhi@pengutronix.de>
 <VI1PR0402MB348525A6FEFD55F6896C9249989B0@VI1PR0402MB3485.eurprd04.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <VI1PR0402MB348525A6FEFD55F6896C9249989B0@VI1PR0402MB3485.eurprd04.prod.outlook.com>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Fri, Jan 25, 2019 at 12:43:21PM +0000, Horia Geanta wrote:
>
> Herbert, is there something we could do to avoid this?

Async crypto requests cannot be allocated off the stack.  So
whoever is doing this needs to stop.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt

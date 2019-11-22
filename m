Return-Path: <SRS0=W3IF=ZO=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 32CEDC432C0
	for <linux-crypto@archiver.kernel.org>; Fri, 22 Nov 2019 14:31:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1104D2071C
	for <linux-crypto@archiver.kernel.org>; Fri, 22 Nov 2019 14:31:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726046AbfKVObJ (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 22 Nov 2019 09:31:09 -0500
Received: from helcar.hmeau.com ([216.24.177.18]:39318 "EHLO deadmen.hmeau.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726546AbfKVObI (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 22 Nov 2019 09:31:08 -0500
Received: from gondobar.mordor.me.apana.org.au ([192.168.128.4] helo=gondobar)
        by deadmen.hmeau.com with esmtps (Exim 4.89 #2 (Debian))
        id 1iY9xi-0002U2-4R; Fri, 22 Nov 2019 22:31:06 +0800
Received: from herbert by gondobar with local (Exim 4.89)
        (envelope-from <herbert@gondor.apana.org.au>)
        id 1iY9xe-00033j-Pp; Fri, 22 Nov 2019 22:31:02 +0800
Date:   Fri, 22 Nov 2019 22:31:02 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Iuliana Prodan <iuliana.prodan@nxp.com>
Cc:     Horia Geanta <horia.geanta@nxp.com>,
        Aymen Sghaier <aymen.sghaier@nxp.com>,
        "David S. Miller" <davem@davemloft.net>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Gary Hook <gary.hook@amd.com>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        dl-linux-imx <linux-imx@nxp.com>
Subject: Re: [PATCH 08/12] crypto: caam - support crypto_engine framework for
 SKCIPHER algorithms
Message-ID: <20191122143102.vpsm5ryye2put2v2@gondor.apana.org.au>
References: <1574029845-22796-1-git-send-email-iuliana.prodan@nxp.com>
 <1574029845-22796-9-git-send-email-iuliana.prodan@nxp.com>
 <20191122103309.wf2hg7km45ugzzhr@gondor.apana.org.au>
 <VI1PR04MB4445DACDF6F1AF1CDABC6E7A8C490@VI1PR04MB4445.eurprd04.prod.outlook.com>
 <20191122110915.f7rsqb4hnsg4pfci@gondor.apana.org.au>
 <VI1PR04MB444537DA6774BE5E31F2C04F8C490@VI1PR04MB4445.eurprd04.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <VI1PR04MB444537DA6774BE5E31F2C04F8C490@VI1PR04MB4445.eurprd04.prod.outlook.com>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Fri, Nov 22, 2019 at 02:11:46PM +0000, Iuliana Prodan wrote:
>
> So, just to be clear, I shouldn't use crypto_async_request in driver code?
> I see that this generic crypto request is used in multiple drivers.

I understand that a number of drivers do this in order to share
common code.  However, this is definitely not the preferred way
of handling this.  Ideally such code should be abstracted into
a higher layer such as crypto_engine so that the driver itself
never references these internal types.

> I can try sending _all_ requests to crypto engine and make some 
> performance measurements to see which solution is best.

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt

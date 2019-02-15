Return-Path: <SRS0=bFfa=QW=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED,USER_AGENT_NEOMUTT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F2DF4C43381
	for <linux-crypto@archiver.kernel.org>; Fri, 15 Feb 2019 06:16:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C93DC214DA
	for <linux-crypto@archiver.kernel.org>; Fri, 15 Feb 2019 06:16:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388461AbfBOGQz (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 15 Feb 2019 01:16:55 -0500
Received: from orcrist.hmeau.com ([104.223.48.154]:41860 "EHLO
        deadmen.hmeau.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725838AbfBOGQy (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 15 Feb 2019 01:16:54 -0500
Received: from gondobar.mordor.me.apana.org.au ([192.168.128.4] helo=gondobar)
        by deadmen.hmeau.com with esmtps (Exim 4.89 #2 (Debian))
        id 1guWnq-0005Fc-E8; Fri, 15 Feb 2019 14:16:50 +0800
Received: from herbert by gondobar with local (Exim 4.89)
        (envelope-from <herbert@gondor.apana.org.au>)
        id 1guWnm-0002My-QQ; Fri, 15 Feb 2019 14:16:46 +0800
Date:   Fri, 15 Feb 2019 14:16:46 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Eric Biggers <ebiggers@kernel.org>
Cc:     Horia Geanta <horia.geanta@nxp.com>,
        Iuliana Prodan <iuliana.prodan@nxp.com>,
        Aymen Sghaier <aymen.sghaier@nxp.com>,
        "David S. Miller" <davem@davemloft.net>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        dl-linux-imx <linux-imx@nxp.com>
Subject: Re: [PATCH 0/4] crypto: caam - add ecb mode support
Message-ID: <20190215061646.7fy6ihqxrvsrngc2@gondor.apana.org.au>
References: <1549633810-10380-1-git-send-email-iuliana.prodan@nxp.com>
 <20190209215219.GA688@sol.localdomain>
 <HE1PR0402MB3484556884375681E3E81BE998660@HE1PR0402MB3484.eurprd04.prod.outlook.com>
 <20190213185135.GA140810@gmail.com>
 <20190215052442.7ti5d2ni7qh47ilv@gondor.apana.org.au>
 <20190215055430.GA638@sol.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190215055430.GA638@sol.localdomain>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Thu, Feb 14, 2019 at 09:54:47PM -0800, Eric Biggers wrote:
>
> Sure, but the bar shouldn't be so low that new implementations of insecure
> algorithms the world is moving away from are accepted without a real use case.
> We should be moving towards removing these algorithms instead.  The original DES
> is especially bad as it only has a 56-bit key.  I'd like to better understand
> if/why people claim to not only still need these algorithms in 2019, but also
> need brand new implementations of them.

If we're going to remove DES then we should remove all implementations
of it and not single out a single driver.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt

Return-Path: <SRS0=BYd+=T7=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_NEOMUTT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 81CCFC04AB6
	for <linux-crypto@archiver.kernel.org>; Fri, 31 May 2019 14:48:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 600B426B00
	for <linux-crypto@archiver.kernel.org>; Fri, 31 May 2019 14:48:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726421AbfEaOsq (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 31 May 2019 10:48:46 -0400
Received: from helcar.hmeau.com ([216.24.177.18]:49278 "EHLO deadmen.hmeau.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726547AbfEaOsq (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 31 May 2019 10:48:46 -0400
Received: from gondobar.mordor.me.apana.org.au ([192.168.128.4] helo=gondobar)
        by deadmen.hmeau.com with esmtps (Exim 4.89 #2 (Debian))
        id 1hWipo-0007Bm-UF; Fri, 31 May 2019 22:48:45 +0800
Received: from herbert by gondobar with local (Exim 4.89)
        (envelope-from <herbert@gondor.apana.org.au>)
        id 1hWipl-0007By-7X; Fri, 31 May 2019 22:48:41 +0800
Date:   Fri, 31 May 2019 22:48:41 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Horia Geanta <horia.geanta@nxp.com>
Cc:     Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "ebiggers@kernel.org" <ebiggers@kernel.org>,
        "pvanleeuwen@insidesecure.com" <pvanleeuwen@insidesecure.com>,
        dl-linux-imx <linux-imx@nxp.com>,
        Iuliana Prodan <iuliana.prodan@nxp.com>,
        Sascha Hauer <s.hauer@pengutronix.de>
Subject: Re: [PATCH] crypto: caam - limit output IV to CBC to work around CTR
 mode DMA issue
Message-ID: <20190531144841.j4ss7xyhswenfzib@gondor.apana.org.au>
References: <20190531081306.30359-1-ard.biesheuvel@linaro.org>
 <VI1PR0402MB348583A318B3AD13881745E198190@VI1PR0402MB3485.eurprd04.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <VI1PR0402MB348583A318B3AD13881745E198190@VI1PR0402MB3485.eurprd04.prod.outlook.com>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Fri, May 31, 2019 at 02:21:40PM +0000, Horia Geanta wrote:
>
> IMO this requirement developed while discussing current issue,
> it did not exist a priori.

Well this requirement has always existed because there has never
been an API requirement that says you must place the IV on a
different cache-line from the src/dst scatter list.

So this isn't really a new requirement, we simply discovered a bug
in the caam code.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt

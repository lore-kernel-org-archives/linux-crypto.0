Return-Path: <SRS0=Ncaf=5T=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 49897C43331
	for <linux-crypto@archiver.kernel.org>; Fri,  3 Apr 2020 06:19:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 265F9206E9
	for <linux-crypto@archiver.kernel.org>; Fri,  3 Apr 2020 06:19:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732411AbgDCGTn (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 3 Apr 2020 02:19:43 -0400
Received: from helcar.hmeau.com ([216.24.177.18]:52068 "EHLO fornost.hmeau.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730889AbgDCGTn (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 3 Apr 2020 02:19:43 -0400
Received: from gwarestrin.me.apana.org.au ([192.168.0.7] helo=gwarestrin.arnor.me.apana.org.au)
        by fornost.hmeau.com with smtp (Exim 4.89 #2 (Debian))
        id 1jKFfi-0008Jn-Lx; Fri, 03 Apr 2020 17:19:19 +1100
Received: by gwarestrin.arnor.me.apana.org.au (sSMTP sendmail emulation); Fri, 03 Apr 2020 17:19:18 +1100
Date:   Fri, 3 Apr 2020 17:19:18 +1100
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Iuliana Prodan <iuliana.prodan@nxp.com>
Cc:     Baolin Wang <baolin.wang@linaro.org>,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        Corentin Labbe <clabbe.montjoie@gmail.com>,
        Horia Geanta <horia.geanta@nxp.com>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        Maxime Ripard <mripard@kernel.org>,
        Aymen Sghaier <aymen.sghaier@nxp.com>,
        "David S. Miller" <davem@davemloft.net>,
        Silvano Di Ninno <silvano.dininno@nxp.com>,
        Franck Lenormand <franck.lenormand@nxp.com>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        dl-linux-imx <linux-imx@nxp.com>
Subject: Re: [PATCH v4 1/2] crypto: engine - support for parallel requests
Message-ID: <20200403061918.GA26691@gondor.apana.org.au>
References: <1583707893-23699-1-git-send-email-iuliana.prodan@nxp.com>
 <1583707893-23699-2-git-send-email-iuliana.prodan@nxp.com>
 <20200312032553.GB19920@gondor.apana.org.au>
 <AM0PR04MB71710B3535153286D9F31F8B8CFD0@AM0PR04MB7171.eurprd04.prod.outlook.com>
 <20200317032924.GB18743@gondor.apana.org.au>
 <VI1PR0402MB3712DC09FC02FBE215006C5B8CF60@VI1PR0402MB3712.eurprd04.prod.outlook.com>
 <20200327044404.GA12318@gondor.apana.org.au>
 <AM6PR0402MB370147736BEAD099AAF061558CCC0@AM6PR0402MB3701.eurprd04.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AM6PR0402MB370147736BEAD099AAF061558CCC0@AM6PR0402MB3701.eurprd04.prod.outlook.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Fri, Mar 27, 2020 at 10:44:02AM +0000, Iuliana Prodan wrote:
>
> This cannot happen right now.
> For non-crypto API requests (like split key or rng) I cannot pass them 
> through crypto-engine which only supports aead, skcipher, hash and 
> akcipher requests.

I don't see why crypto-engine can't be extended to cover that
too, right?

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt

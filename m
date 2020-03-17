Return-Path: <SRS0=I3Dt=5C=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A5246C10F29
	for <linux-crypto@archiver.kernel.org>; Tue, 17 Mar 2020 03:29:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7E9B820717
	for <linux-crypto@archiver.kernel.org>; Tue, 17 Mar 2020 03:29:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725837AbgCQD3j (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 16 Mar 2020 23:29:39 -0400
Received: from helcar.hmeau.com ([216.24.177.18]:38896 "EHLO fornost.hmeau.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725783AbgCQD3j (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 16 Mar 2020 23:29:39 -0400
Received: from gwarestrin.me.apana.org.au ([192.168.0.7] helo=gwarestrin.arnor.me.apana.org.au)
        by fornost.hmeau.com with smtp (Exim 4.89 #2 (Debian))
        id 1jE2uy-0007TK-Gt; Tue, 17 Mar 2020 14:29:25 +1100
Received: by gwarestrin.arnor.me.apana.org.au (sSMTP sendmail emulation); Tue, 17 Mar 2020 14:29:24 +1100
Date:   Tue, 17 Mar 2020 14:29:24 +1100
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
Message-ID: <20200317032924.GB18743@gondor.apana.org.au>
References: <1583707893-23699-1-git-send-email-iuliana.prodan@nxp.com>
 <1583707893-23699-2-git-send-email-iuliana.prodan@nxp.com>
 <20200312032553.GB19920@gondor.apana.org.au>
 <AM0PR04MB71710B3535153286D9F31F8B8CFD0@AM0PR04MB7171.eurprd04.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AM0PR04MB71710B3535153286D9F31F8B8CFD0@AM0PR04MB7171.eurprd04.prod.outlook.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Thu, Mar 12, 2020 at 12:45:54PM +0000, Iuliana Prodan wrote:
>
> There are two aspects here:
> - if all requests go through crypto-engine, and, in this case, if there 
> is no space in hw queue, do_one_req returns 0, and actually there will 
> be no case of do_one_request() < 0;

OK, that makes sense.  However, this way of signaling for more
requests can be racy.  Unless you can guarantee that the driver
is not taking any requests from another engine queue (or any
other source), just because it returned a positive value now does
not mean that it would be able to take a request the next time
you come around the loop.

> I've tried this, but it implies modifications in all drivers. For 
> example, a driver, in case of error, it frees the resources of the 
> request. So, will need to map again a request.

I think what we are doing here is a major overhaul to the crypto
engine API so while it's always a good idea to minimise the impact,
we should not let the existing drivers constrain us too much.

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt

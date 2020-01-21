Return-Path: <SRS0=kzJ7=3K=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E25B9C2D0CE
	for <linux-crypto@archiver.kernel.org>; Tue, 21 Jan 2020 09:11:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B629520882
	for <linux-crypto@archiver.kernel.org>; Tue, 21 Jan 2020 09:11:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728890AbgAUJLT (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 21 Jan 2020 04:11:19 -0500
Received: from helcar.hmeau.com ([216.24.177.18]:37564 "EHLO deadmen.hmeau.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728456AbgAUJLT (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 21 Jan 2020 04:11:19 -0500
Received: from gondobar.mordor.me.apana.org.au ([192.168.128.4] helo=gondobar)
        by deadmen.hmeau.com with esmtps (Exim 4.89 #2 (Debian))
        id 1itpYy-0006iC-Rf; Tue, 21 Jan 2020 17:11:08 +0800
Received: from herbert by gondobar with local (Exim 4.89)
        (envelope-from <herbert@gondor.apana.org.au>)
        id 1itpYt-0001Tc-1v; Tue, 21 Jan 2020 17:11:03 +0800
Date:   Tue, 21 Jan 2020 17:11:03 +0800
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
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-imx <linux-imx@nxp.com>
Subject: Re: [RFC PATCH] Crypto-engine support for parallel requests
Message-ID: <20200121091102.magzogr7tnj6joqm@gondor.apana.org.au>
References: <1579563149-3678-1-git-send-email-iuliana.prodan@nxp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1579563149-3678-1-git-send-email-iuliana.prodan@nxp.com>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Tue, Jan 21, 2020 at 01:32:29AM +0200, Iuliana Prodan wrote:
>
> +	if (engine->no_reqs < engine->max_no_reqs)
> +		goto retry;

We should not hard-code this number into the engine.  Instead,
we should just let the driver tell us when it is ready to accept
more requests.

Perhaps we should add a new function for drivers that wish to
support this that would accept a list of requests instead of
a single one.  It would then process as many requests as it
can from that list and only return either when the list is
exhausted or when it can't process any more requests.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt

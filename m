Return-Path: <SRS0=W4lJ=6I=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BFA57C54FD0
	for <linux-crypto@archiver.kernel.org>; Fri, 24 Apr 2020 15:11:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8F38920706
	for <linux-crypto@archiver.kernel.org>; Fri, 24 Apr 2020 15:11:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726872AbgDXPLL (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 24 Apr 2020 11:11:11 -0400
Received: from helcar.hmeau.com ([216.24.177.18]:45734 "EHLO fornost.hmeau.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726698AbgDXPLK (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 24 Apr 2020 11:11:10 -0400
Received: from gwarestrin.me.apana.org.au ([192.168.0.7] helo=gwarestrin.arnor.me.apana.org.au)
        by fornost.hmeau.com with smtp (Exim 4.89 #2 (Debian))
        id 1jRzyV-0002yF-EN; Sat, 25 Apr 2020 01:10:44 +1000
Received: by gwarestrin.arnor.me.apana.org.au (sSMTP sendmail emulation); Sat, 25 Apr 2020 01:10:51 +1000
Date:   Sat, 25 Apr 2020 01:10:51 +1000
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
Subject: Re: [PATCH v5 2/3] crypto: engine - support for parallel requests
 based on retry mechanism
Message-ID: <20200424151051.GA26494@gondor.apana.org.au>
References: <1586982375-18710-1-git-send-email-iuliana.prodan@nxp.com>
 <1586982375-18710-3-git-send-email-iuliana.prodan@nxp.com>
 <20200423114640.GA14399@gondor.apana.org.au>
 <VI1PR0402MB3712298355411E273294E5F38CD00@VI1PR0402MB3712.eurprd04.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <VI1PR0402MB3712298355411E273294E5F38CD00@VI1PR0402MB3712.eurprd04.prod.outlook.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Fri, Apr 24, 2020 at 02:34:57PM +0000, Iuliana Prodan wrote:
>
> Do you refer to the error codes returned by do_one_request (which sends 
> the req to hw for execution)?
> 
> If this returns:
> 1. 0, success;
> 2. -ENOSPC, I'll requeue it regardless of MAY_BACKLOG;
> 3. any other error (-EIO, -EINVAL, -ENOMEM, etc), I'll requeue only 
> MAY_BACKLOG requests.

Yes that sounds perfect.

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt

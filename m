Return-Path: <SRS0=7zOR=A3=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.5 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1B157C433F7
	for <linux-crypto@archiver.kernel.org>; Thu, 16 Jul 2020 13:06:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id EE805207BB
	for <linux-crypto@archiver.kernel.org>; Thu, 16 Jul 2020 13:06:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728455AbgGPNGF (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 16 Jul 2020 09:06:05 -0400
Received: from helcar.hmeau.com ([216.24.177.18]:40302 "EHLO fornost.hmeau.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728087AbgGPNGE (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 16 Jul 2020 09:06:04 -0400
Received: from gwarestrin.arnor.me.apana.org.au ([192.168.0.7])
        by fornost.hmeau.com with smtp (Exim 4.92 #5 (Debian))
        id 1jw3aF-0001xQ-AH; Thu, 16 Jul 2020 23:05:56 +1000
Received: by gwarestrin.arnor.me.apana.org.au (sSMTP sendmail emulation); Thu, 16 Jul 2020 23:05:55 +1000
Date:   Thu, 16 Jul 2020 23:05:55 +1000
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     "Van Leeuwen, Pascal" <pvanleeuwen@rambus.com>
Cc:     Horia =?utf-8?Q?Geant=C4=83?= <horia.geanta@nxp.com>,
        Iuliana Prodan <iuliana.prodan@nxp.com>,
        Aymen Sghaier <aymen.sghaier@nxp.com>,
        "David S. Miller" <davem@davemloft.net>,
        Silvano Di Ninno <silvano.dininno@nxp.com>,
        Franck Lenormand <franck.lenormand@nxp.com>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        dl-linux-imx <linux-imx@nxp.com>
Subject: Re: [PATCH 2/2] crypto: caam - support tagged keys for skcipher
 algorithms
Message-ID: <20200716130555.GA32006@gondor.apana.org.au>
References: <1594591536-531-1-git-send-email-iuliana.prodan@nxp.com>
 <1594591536-531-3-git-send-email-iuliana.prodan@nxp.com>
 <20200716073610.GA28215@gondor.apana.org.au>
 <0c818beb-05e5-a6c6-717d-782b32afff26@nxp.com>
 <20200716115253.GA25035@gondor.apana.org.au>
 <59436173-9891-b857-f36b-e97c0a3264c8@nxp.com>
 <20200716121932.GA31870@gondor.apana.org.au>
 <CY4PR0401MB36527396455B1AEE4A17CDB1C37F0@CY4PR0401MB3652.namprd04.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CY4PR0401MB36527396455B1AEE4A17CDB1C37F0@CY4PR0401MB3652.namprd04.prod.outlook.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Thu, Jul 16, 2020 at 12:24:49PM +0000, Van Leeuwen, Pascal wrote:
>
> That would make no sense though, as sha512 does not involve any keys ...
> It's the HMAC part that needs the keys. So phmac(sha512) then?

You're right, that would be phmac(...).

But the point is we don't want each driver to do its own thing
so whatever scheme we pick should be applicable to all drivers.

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt

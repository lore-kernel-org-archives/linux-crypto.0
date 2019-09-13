Return-Path: <SRS0=vORM=XI=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B31E3C49ED7
	for <linux-crypto@archiver.kernel.org>; Fri, 13 Sep 2019 11:28:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 92A88208C2
	for <linux-crypto@archiver.kernel.org>; Fri, 13 Sep 2019 11:28:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728591AbfIML26 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 13 Sep 2019 07:28:58 -0400
Received: from helcar.hmeau.com ([216.24.177.18]:33576 "EHLO fornost.hmeau.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726266AbfIML26 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 13 Sep 2019 07:28:58 -0400
Received: from gwarestrin.arnor.me.apana.org.au ([192.168.0.7])
        by fornost.hmeau.com with smtp (Exim 4.89 #2 (Debian))
        id 1i8jkq-0001JP-3A; Fri, 13 Sep 2019 21:28:45 +1000
Received: by gwarestrin.arnor.me.apana.org.au (sSMTP sendmail emulation); Fri, 13 Sep 2019 21:28:39 +1000
Date:   Fri, 13 Sep 2019 21:28:39 +1000
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Andrey Smirnov <andrew.smirnov@gmail.com>
Cc:     Shawn Guo <shawnguo@kernel.org>,
        Horia =?utf-8?Q?Geant=C4=83?= <horia.geanta@nxp.com>,
        Cory Tusar <cory.tusar@zii.aero>,
        Chris Healy <cphealy@gmail.com>,
        Lucas Stach <l.stach@pengutronix.de>,
        Iuliana Prodan <iuliana.prodan@nxp.com>,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] arm64: dts: imx8mq: Add CAAM node
Message-ID: <20190913112839.GA14972@gondor.apana.org.au>
References: <20190830210139.7028-1-andrew.smirnov@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20190830210139.7028-1-andrew.smirnov@gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Fri, Aug 30, 2019 at 02:01:39PM -0700, Andrey Smirnov wrote:
> Add node for CAAM - Cryptographic Acceleration and Assurance Module.
> 
> Signed-off-by: Horia Geantă <horia.geanta@nxp.com>
> Signed-off-by: Andrey Smirnov <andrew.smirnov@gmail.com>
> Cc: Cory Tusar <cory.tusar@zii.aero>
> Cc: Chris Healy <cphealy@gmail.com>
> Cc: Lucas Stach <l.stach@pengutronix.de>
> Cc: Herbert Xu <herbert@gondor.apana.org.au>
> Cc: Shawn Guo <shawnguo@kernel.org>
> Cc: Iuliana Prodan <iuliana.prodan@nxp.com>
> Cc: linux-crypto@vger.kernel.org
> Cc: linux-kernel@vger.kernel.org
> ---
> 
> Shawn:
> 
> Just a bit of a context: as per this thread
> https://lore.kernel.org/linux-crypto/20190830131547.GA27480@gondor.apana.org.au/
> I am hoping I can get and Ack from you for this patch, so it can go
> via cryptodev tree.
> 
> Thanks,
> Andrey Smirnov
> 
>  arch/arm64/boot/dts/freescale/imx8mq.dtsi | 30 +++++++++++++++++++++++
>  1 file changed, 30 insertions(+)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt

Return-Path: <SRS0=AlHk=ZN=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8CDEEC432C0
	for <linux-crypto@archiver.kernel.org>; Thu, 21 Nov 2019 01:24:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 65FE020855
	for <linux-crypto@archiver.kernel.org>; Thu, 21 Nov 2019 01:24:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725819AbfKUBYN (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 20 Nov 2019 20:24:13 -0500
Received: from helcar.hmeau.com ([216.24.177.18]:32846 "EHLO deadmen.hmeau.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725842AbfKUBYN (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 20 Nov 2019 20:24:13 -0500
Received: from gondobar.mordor.me.apana.org.au ([192.168.128.4] helo=gondobar)
        by deadmen.hmeau.com with esmtps (Exim 4.89 #2 (Debian))
        id 1iXbCZ-0005y7-55; Thu, 21 Nov 2019 09:24:07 +0800
Received: from herbert by gondobar with local (Exim 4.89)
        (envelope-from <herbert@gondor.apana.org.au>)
        id 1iXbCT-0002K3-L8; Thu, 21 Nov 2019 09:24:01 +0800
Date:   Thu, 21 Nov 2019 09:24:01 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Andrey Smirnov <andrew.smirnov@gmail.com>
Cc:     linux-crypto@vger.kernel.org, Chris Healy <cphealy@gmail.com>,
        Lucas Stach <l.stach@pengutronix.de>,
        Horia =?utf-8?Q?Geant=C4=83?= <horia.geanta@nxp.com>,
        Iuliana Prodan <iuliana.prodan@nxp.com>, linux-imx@nxp.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 6/6] crypto: caam - expose SEC4 DRNG via crypto RNG API
Message-ID: <20191121012401.l3x3bepsmzdp26xt@gondor.apana.org.au>
References: <20191120165341.32669-1-andrew.smirnov@gmail.com>
 <20191120165341.32669-7-andrew.smirnov@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191120165341.32669-7-andrew.smirnov@gmail.com>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Wed, Nov 20, 2019 at 08:53:41AM -0800, Andrey Smirnov wrote:
>
> +static struct rng_alg caam_drng_alg = {
> +	.generate = caam_drng_generate,
> +	.seed = caam_drng_seed,
> +	.seedsize = 0,
> +	.base = {
> +		.cra_name = "drng-caam",

This should be stdrng.

> +		.cra_driver_name = "drng-caam",
> +		.cra_priority = 300,
> +		.cra_ctxsize = sizeof(struct caam_drng_ctx),
> +		.cra_module = THIS_MODULE,
> +		.cra_init = caam_drng_init,
> +		.cra_exit = caam_drng_exit,
> +	},
> +};

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt

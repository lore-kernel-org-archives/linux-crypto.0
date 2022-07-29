Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6F355C00144
	for <linux-crypto@archiver.kernel.org>; Fri, 29 Jul 2022 10:21:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235509AbiG2KV4 (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 29 Jul 2022 06:21:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47420 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235375AbiG2KVz (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 29 Jul 2022 06:21:55 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D65AB77579
        for <linux-crypto@vger.kernel.org>; Fri, 29 Jul 2022 03:21:54 -0700 (PDT)
Received: from ptz.office.stw.pengutronix.de ([2a0a:edc0:0:900:1d::77] helo=[127.0.0.1])
        by metis.ext.pengutronix.de with esmtp (Exim 4.92)
        (envelope-from <a.fatoum@pengutronix.de>)
        id 1oHN7j-0002Ai-P4; Fri, 29 Jul 2022 12:21:39 +0200
Message-ID: <e78ff391-3141-bf0b-6fe1-4ff7204414fb@pengutronix.de>
Date:   Fri, 29 Jul 2022 12:21:31 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.0
Subject: Re: [PATCH v1] Moving init_completion before request_irq
Content-Language: en-US
To:     Kshitiz Varshney <kshitiz.varshney@nxp.com>,
        Horia Geanta <horia.geanta@nxp.com>,
        Pankaj Gupta <pankaj.gupta@nxp.com>,
        Varun Sethi <V.Sethi@nxp.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S . Miller" <davem@davemloft.net>,
        Iuliana Prodan <iuliana.prodan@nxp.com>,
        Gaurav Jain <gaurav.jain@nxp.com>,
        Rahul Kumar Yadav <rahulkumar.yadav@nxp.com>,
        Vabhav Sharma <vabhav.sharma@nxp.com>,
        Sahil Malhotra <sahil.malhotra@nxp.com>,
        Matt Mackall <mpm@selenic.com>,
        Shawn Guo <shawnguo@kernel.org>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Pengutronix Kernel Team <kernel@pengutronix.de>,
        Fabio Estevam <festevam@gmail.com>,
        Steffen Trumtrar <s.trumtrar@pengutronix.de>,
        PrasannaKumar Muralidharan <prasannatsmkumar@gmail.com>,
        Martin Kaiser <martin@kaiser.cx>
Cc:     linux-imx@nxp.com, linux-crypto@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
References: <20220729100211.2204126-1-kshitiz.varshney@nxp.com>
From:   Ahmad Fatoum <a.fatoum@pengutronix.de>
In-Reply-To: <20220729100211.2204126-1-kshitiz.varshney@nxp.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-SA-Exim-Connect-IP: 2a0a:edc0:0:900:1d::77
X-SA-Exim-Mail-From: a.fatoum@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-crypto@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Hello Kshitiz,

On 29.07.22 12:02, Kshitiz Varshney wrote:
> Issue:
> While servicing interrupt, trying to access variable rng_op_done,
> which is not yet initalized hence causing kernel to crash
> while booting.
> 
> Fix:
> Moving initialization of rng_op_done before request_irq.
> 
> Fixes: 1d5449445bd0 (hwrng: mx-rngc - add a driver for Freescale RNGC)
> Signed-off-by: Kshitiz Varshney <kshitiz.varshney@nxp.com>

Thanks for your patch.

> +	init_completion(&rngc->rng_op_done);
> +
>  	ret = devm_request_irq(&pdev->dev,
>  			irq, imx_rngc_irq, 0, pdev->name, (void *)rngc);

This should probably be moved below imx_rngc_irq_mask_clear(rngc).
init_completion can stay where it is. That way:

 - You initialize rngc fully before registering the IRQ handler
 - You don't handle pending IRQs that you want to dismiss anyway
 - If the IRQ happens to be because of a SEED_DONE due to a previous
   boot stage, you don't end up completing the completion prematurely.

Cheers,
Ahmad

>  	if (ret) {
> @@ -277,7 +279,6 @@ static int imx_rngc_probe(struct platform_device *pdev)
>  		goto err;
>  	}
>  
> -	init_completion(&rngc->rng_op_done);
>  
>  	rngc->rng.name = pdev->name;
>  	rngc->rng.init = imx_rngc_init;


-- 
Pengutronix e.K.                           |                             |
Steuerwalder Str. 21                       | http://www.pengutronix.de/  |
31137 Hildesheim, Germany                  | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |

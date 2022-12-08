Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6819AC4332F
	for <linux-crypto@archiver.kernel.org>; Thu,  8 Dec 2022 15:28:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229947AbiLHP2c (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 8 Dec 2022 10:28:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45336 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229501AbiLHP2b (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 8 Dec 2022 10:28:31 -0500
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6CD0A11A02
        for <linux-crypto@vger.kernel.org>; Thu,  8 Dec 2022 07:28:29 -0800 (PST)
Received: from ptz.office.stw.pengutronix.de ([2a0a:edc0:0:900:1d::77] helo=[127.0.0.1])
        by metis.ext.pengutronix.de with esmtp (Exim 4.92)
        (envelope-from <a.fatoum@pengutronix.de>)
        id 1p3Iov-0000UU-7x; Thu, 08 Dec 2022 16:28:21 +0100
Message-ID: <d8c38871-27a9-0501-88e4-8df07ee901cf@pengutronix.de>
Date:   Thu, 8 Dec 2022 16:27:51 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.0
Subject: Re: [PATCH] crypto: caam: blob_gen.c: fix CAAM io mem access
Content-Language: en-US
To:     Nikolaus Voss <nikolaus.voss@haag-streit.com>,
        Horia Geanta <horia.geanta@nxp.com>,
        Pankaj Gupta <pankaj.gupta@nxp.com>,
        Gaurav Jain <gaurav.jain@nxp.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        David Gstir <david@sigma-star.at>,
        Steffen Trumtrar <s.trumtrar@pengutronix.de>,
        Nikolaus Voss <nv@vosn.de>
Cc:     linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20221205075839.050FF27BD@mail.steuer-voss.de>
From:   Ahmad Fatoum <a.fatoum@pengutronix.de>
In-Reply-To: <20221205075839.050FF27BD@mail.steuer-voss.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-SA-Exim-Connect-IP: 2a0a:edc0:0:900:1d::77
X-SA-Exim-Mail-From: a.fatoum@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-crypto@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On 05.12.22 08:58, Nikolaus Voss wrote:
> IO memory access has to be done with accessors defined in caam/regs.h
> as there are little-endian architectures with a big-endian CAAM unit.
> 
> Fixes ("crypto: caam: blob_gen.c: warn if key is insecure")

@Herbert, is there a stable commit revision Nikolaus could reference here?

> Signed-off-by: Nikolaus Voss <nikolaus.voss@haag-streit.com>

LGTM.

Reviewed-by: Ahmad Fatoum <a.fatoum@pengutronix.de>

> ---
>  drivers/crypto/caam/blob_gen.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/crypto/caam/blob_gen.c b/drivers/crypto/caam/blob_gen.c
> index 1f65df489847..f46b161d2cda 100644
> --- a/drivers/crypto/caam/blob_gen.c
> +++ b/drivers/crypto/caam/blob_gen.c
> @@ -104,7 +104,7 @@ int caam_process_blob(struct caam_blob_priv *priv,
>  	}
>  
>  	ctrlpriv = dev_get_drvdata(jrdev->parent);
> -	moo = FIELD_GET(CSTA_MOO, ioread32(&ctrlpriv->ctrl->perfmon.status));
> +	moo = FIELD_GET(CSTA_MOO, rd_reg32(&ctrlpriv->ctrl->perfmon.status));
>  	if (moo != CSTA_MOO_SECURE && moo != CSTA_MOO_TRUSTED)
>  		dev_warn(jrdev,
>  			 "using insecure test key, enable HAB to use unique device key!\n");

-- 
Pengutronix e.K.                           |                             |
Steuerwalder Str. 21                       | http://www.pengutronix.de/  |
31137 Hildesheim, Germany                  | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |


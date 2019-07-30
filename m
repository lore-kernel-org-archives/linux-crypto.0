Return-Path: <SRS0=RABd=V3=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 498DCC433FF
	for <linux-crypto@archiver.kernel.org>; Tue, 30 Jul 2019 08:12:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 193A420679
	for <linux-crypto@archiver.kernel.org>; Tue, 30 Jul 2019 08:12:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727857AbfG3IMI (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 30 Jul 2019 04:12:08 -0400
Received: from relay11.mail.gandi.net ([217.70.178.231]:52181 "EHLO
        relay11.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726870AbfG3IMH (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 30 Jul 2019 04:12:07 -0400
Received: from localhost (lfbn-1-17395-211.w86-250.abo.wanadoo.fr [86.250.200.211])
        (Authenticated sender: antoine.tenart@bootlin.com)
        by relay11.mail.gandi.net (Postfix) with ESMTPSA id 4A37E10000C;
        Tue, 30 Jul 2019 08:12:04 +0000 (UTC)
Date:   Tue, 30 Jul 2019 10:12:03 +0200
From:   Antoine Tenart <antoine.tenart@bootlin.com>
To:     Pascal van Leeuwen <pascalvanl@gmail.com>
Cc:     linux-crypto@vger.kernel.org, antoine.tenart@bootlin.com,
        herbert@gondor.apana.org.au, davem@davemloft.net,
        Pascal van Leeuwen <pvanleeuwen@verimatrix.com>
Subject: Re: [PATCH] crypto: inside-secure - Fix null ptr derefence on rmmod
 for macchiatobin
Message-ID: <20190730081203.GB3108@kwain>
References: <1564155069-18491-1-git-send-email-pvanleeuwen@verimatrix.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1564155069-18491-1-git-send-email-pvanleeuwen@verimatrix.com>
User-Agent: Mutt/1.12.0 (2019-05-25)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Hi Pascal,

On Fri, Jul 26, 2019 at 05:31:09PM +0200, Pascal van Leeuwen wrote:
> This small patch fixes a null pointer derefence panic that occurred when
> unloading the driver (using rmmod) on macchiatobin due to not setting
> the platform driver data properly in the probe routine.
> 
> Signed-off-by: Pascal van Leeuwen <pvanleeuwen@verimatrix.com>

As this is a fix you should add a Fixes: tag so that the patch gets
applied to stable trees. You can have a look at what this tag looks like
at: https://www.kernel.org/doc/html/latest/process/submitting-patches.html

> ---
>  drivers/crypto/inside-secure/safexcel.c | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/drivers/crypto/inside-secure/safexcel.c b/drivers/crypto/inside-secure/safexcel.c
> index 45443bf..423ea2d 100644
> --- a/drivers/crypto/inside-secure/safexcel.c
> +++ b/drivers/crypto/inside-secure/safexcel.c
> @@ -1274,6 +1274,8 @@ static int safexcel_probe(struct platform_device *pdev)
>  	priv->dev = dev;
>  	priv->version = (enum safexcel_eip_version)of_device_get_match_data(dev);
>  
> +	platform_set_drvdata(pdev, priv);
> +

This is already done in safexcel_probe(), near the end of the function.
I think you should remove the second call, to avoid setting the platform
driver data twice.

Out of curiosity, why calling platform_set_drvdata() earlier in the
probe fixes unloading the driver with rmmod?

Thanks!
Antoine

-- 
Antoine Ténart, Bootlin
Embedded Linux and Kernel engineering
https://bootlin.com

Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1DBF6CDB474
	for <linux-crypto@archiver.kernel.org>; Fri, 20 Oct 2023 10:13:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1376715AbjJTKN0 convert rfc822-to-8bit (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 20 Oct 2023 06:13:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32938 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1376885AbjJTKNL (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 20 Oct 2023 06:13:11 -0400
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 75D91D5B
        for <linux-crypto@vger.kernel.org>; Fri, 20 Oct 2023 03:12:30 -0700 (PDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 21B742F4;
        Fri, 20 Oct 2023 03:13:11 -0700 (PDT)
Received: from donnerap.manchester.arm.com (usa-sjc-imap-foss1.foss.arm.com [10.121.207.14])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 79EFE3F5A1;
        Fri, 20 Oct 2023 03:12:28 -0700 (PDT)
Date:   Fri, 20 Oct 2023 11:12:26 +0100
From:   Andre Przywara <andre.przywara@arm.com>
To:     Uwe =?UTF-8?B?S2xlaW5lLUvDtm5pZw==?= 
        <u.kleine-koenig@pengutronix.de>
Cc:     Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Corentin Labbe <clabbe.montjoie@gmail.com>,
        Chen-Yu Tsai <wens@csie.org>,
        Jernej Skrabec <jernej.skrabec@gmail.com>,
        Samuel Holland <samuel@sholland.org>,
        Rob Herring <robh@kernel.org>,
        Jonathan Corbet <corbet@lwn.net>, linux-crypto@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-sunxi@lists.linux.dev,
        kernel@pengutronix.de
Subject: Re: [PATCH 02/42] crypto: sun8i-ce - Convert to platform remove
 callback returning void
Message-ID: <20231020111226.1c5eb00c@donnerap.manchester.arm.com>
In-Reply-To: <20231020075521.2121571-46-u.kleine-koenig@pengutronix.de>
References: <20231020075521.2121571-44-u.kleine-koenig@pengutronix.de>
        <20231020075521.2121571-46-u.kleine-koenig@pengutronix.de>
Organization: ARM
X-Mailer: Claws Mail 3.18.0 (GTK+ 2.24.32; aarch64-unknown-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Fri, 20 Oct 2023 09:55:24 +0200
Uwe Kleine-König <u.kleine-koenig@pengutronix.de> wrote:

Hi,

> The .remove() callback for a platform driver returns an int which makes
> many driver authors wrongly assume it's possible to do error handling by
> returning an error code. However the value returned is ignored (apart
> from emitting a warning) and this typically results in resource leaks.
> 
> To improve here there is a quest to make the remove callback return
> void. In the first step of this quest all drivers are converted to
> .remove_new(), which already returns void. Eventually after all drivers
> are converted, .remove_new() will be renamed to .remove().
> 
> Trivially convert this driver from always returning zero in the remove
> callback to the void returning variant.
> 
> Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>

Reviewed-by: Andre Przywara <andre.przywara@arm.com>

Cheers,
Andre

> ---
>  drivers/crypto/allwinner/sun8i-ce/sun8i-ce-core.c | 5 ++---
>  1 file changed, 2 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/crypto/allwinner/sun8i-ce/sun8i-ce-core.c b/drivers/crypto/allwinner/sun8i-ce/sun8i-ce-core.c
> index d4ccd5254280..1741758e03eb 100644
> --- a/drivers/crypto/allwinner/sun8i-ce/sun8i-ce-core.c
> +++ b/drivers/crypto/allwinner/sun8i-ce/sun8i-ce-core.c
> @@ -1071,7 +1071,7 @@ static int sun8i_ce_probe(struct platform_device *pdev)
>  	return err;
>  }
>  
> -static int sun8i_ce_remove(struct platform_device *pdev)
> +static void sun8i_ce_remove(struct platform_device *pdev)
>  {
>  	struct sun8i_ce_dev *ce = platform_get_drvdata(pdev);
>  
> @@ -1088,7 +1088,6 @@ static int sun8i_ce_remove(struct platform_device *pdev)
>  	sun8i_ce_free_chanlist(ce, MAXFLOW - 1);
>  
>  	sun8i_ce_pm_exit(ce);
> -	return 0;
>  }
>  
>  static const struct of_device_id sun8i_ce_crypto_of_match_table[] = {
> @@ -1110,7 +1109,7 @@ MODULE_DEVICE_TABLE(of, sun8i_ce_crypto_of_match_table);
>  
>  static struct platform_driver sun8i_ce_driver = {
>  	.probe		 = sun8i_ce_probe,
> -	.remove		 = sun8i_ce_remove,
> +	.remove_new	 = sun8i_ce_remove,
>  	.driver		 = {
>  		.name		= "sun8i-ce",
>  		.pm		= &sun8i_ce_pm_ops,


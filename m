Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 510C5EE4993
	for <linux-crypto@archiver.kernel.org>; Wed, 23 Aug 2023 13:44:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236143AbjHWNoV (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 23 Aug 2023 09:44:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52452 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232593AbjHWNoV (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 23 Aug 2023 09:44:21 -0400
Received: from viti.kaiser.cx (viti.kaiser.cx [IPv6:2a01:238:43fe:e600:cd0c:bd4a:7a3:8e9f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0C684E4A;
        Wed, 23 Aug 2023 06:44:19 -0700 (PDT)
Received: from martin by viti.kaiser.cx with local (Exim 4.89)
        (envelope-from <martin@viti.kaiser.cx>)
        id 1qYo9h-0007Q6-MI; Wed, 23 Aug 2023 15:44:17 +0200
Date:   Wed, 23 Aug 2023 15:44:17 +0200
From:   Martin Kaiser <lists@kaiser.cx>
To:     Andrei Coardos <aboutphysycs@gmail.com>
Cc:     linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org,
        alex@shruggie.ro, herbert@gondor.apana.org.au, olivia@selenic.com
Subject: Re: [PATCH] char: hw_random: hisi-rng: removed unneeded call to
 platform_set_drvdata()
Message-ID: <20230823134417.pe4jm3xqj6tdslav@viti.kaiser.cx>
References: <20230823112139.4012-1-aboutphysycs@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230823112139.4012-1-aboutphysycs@gmail.com>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: Martin Kaiser <martin@viti.kaiser.cx>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Andrei Coardos (aboutphysycs@gmail.com) wrote:

> This function call was found to be unnecessary as there is no equivalent
> platform_get_drvdata() call to access the private data of the driver. Also,
> the private data is defined in this driver, so there is no risk of it being
> accessed outside of this driver file.

> Signed-off-by: Andrei Coardos <aboutphysycs@gmail.com>
> ---
>  drivers/char/hw_random/hisi-rng.c | 2 --
>  1 file changed, 2 deletions(-)

> diff --git a/drivers/char/hw_random/hisi-rng.c b/drivers/char/hw_random/hisi-rng.c
> index 96438f85cafa..b6f27566e0ba 100644
> --- a/drivers/char/hw_random/hisi-rng.c
> +++ b/drivers/char/hw_random/hisi-rng.c
> @@ -79,8 +79,6 @@ static int hisi_rng_probe(struct platform_device *pdev)
>  	if (!rng)
>  		return -ENOMEM;

> -	platform_set_drvdata(pdev, rng);
> -
>  	rng->base = devm_platform_ioremap_resource(pdev, 0);
>  	if (IS_ERR(rng->base))
>  		return PTR_ERR(rng->base);
> -- 
> 2.34.1

This one can go.

Reviewed-by: Martin Kaiser <martin@kaiser.cx>

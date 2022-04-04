Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 59CCDC433F5
	for <linux-crypto@archiver.kernel.org>; Mon,  4 Apr 2022 11:38:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233165AbiDDLk3 (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 4 Apr 2022 07:40:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56188 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1359665AbiDDLk2 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 4 Apr 2022 07:40:28 -0400
Received: from metanate.com (unknown [IPv6:2001:8b0:1628:5005::111])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 427652DD0;
        Mon,  4 Apr 2022 04:38:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=metanate.com; s=stronger; h=In-Reply-To:Content-Type:References:Message-ID:
        Subject:Cc:To:From:Date:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description; bh=Zc6VIIFKcy+op7oiVyHdf8N32KwbpWfsc0NuQgZSdH0=; b=A09kS
        4qQJvDZkpFSIawTG5uMZmetjLA+RGO9CsRi4k2sbBzNeWaLiXery34BExS5su42r7muhdvrdM8WIQ
        x9KwpGUfSE2NDatySu4737MPqwRwtNiOED/1x+lPjJHTiOZC/BkXa91DXlY+JYYy5zhu8ZFYtQZ5K
        CuKq69Gq6O6Eg0yCb9motDhMhrLI9LGSQ/yF2UpHd6yHfs/wPEMzplvi2JxUHtACYQEq/XmM5dwv2
        nw+6XDizcBR3gaE7Cilb9BabPVde3A0uq81yV2W12N7qgOBzuxhZn0zo2IkZGnBKwXNCZeZV4OEtp
        +NTMpxJjbuRIvHKTmSLwHnN7KGtqw==;
Received: from [81.174.171.191] (helo=donbot)
        by email.metanate.com with esmtpsa  (TLS1.3) tls TLS_AES_256_GCM_SHA384
        (Exim 4.93)
        (envelope-from <john@metanate.com>)
        id 1nbL2S-000544-C8; Mon, 04 Apr 2022 12:38:28 +0100
Date:   Mon, 4 Apr 2022 12:38:27 +0100
From:   John Keeping <john@metanate.com>
To:     Corentin Labbe <clabbe@baylibre.com>
Cc:     heiko@sntech.de, herbert@gondor.apana.org.au, krzk+dt@kernel.org,
        robh+dt@kernel.org, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-rockchip@lists.infradead.org
Subject: Re: [PATCH v4 17/33] crypto: rockchip: use read_poll_timeout
Message-ID: <YkrYs87bgWs7+tOm@donbot>
References: <20220401201804.2867154-1-clabbe@baylibre.com>
 <20220401201804.2867154-18-clabbe@baylibre.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220401201804.2867154-18-clabbe@baylibre.com>
X-Authenticated: YES
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Fri, Apr 01, 2022 at 08:17:48PM +0000, Corentin Labbe wrote:
> Use read_poll_timeout instead of open coding it
> 
> Signed-off-by: Corentin Labbe <clabbe@baylibre.com>
> ---
>  drivers/crypto/rockchip/rk3288_crypto_ahash.c | 5 +++--
>  1 file changed, 3 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/crypto/rockchip/rk3288_crypto_ahash.c b/drivers/crypto/rockchip/rk3288_crypto_ahash.c
> index 137013bd4410..21c9a0327ddf 100644
> --- a/drivers/crypto/rockchip/rk3288_crypto_ahash.c
> +++ b/drivers/crypto/rockchip/rk3288_crypto_ahash.c
> @@ -10,6 +10,7 @@
>   */
>  #include <linux/device.h>
>  #include <asm/unaligned.h>
> +#include <linux/iopoll.h>
>  #include "rk3288_crypto.h"
>  
>  /*
> @@ -305,8 +306,8 @@ static int rk_hash_run(struct crypto_engine *engine, void *breq)
>  		 * efficiency, and make it response quickly when dma
>  		 * complete.
>  		 */
> -	while (!CRYPTO_READ(tctx->dev, RK_CRYPTO_HASH_STS))
> -		udelay(10);
> +	read_poll_timeout(readl, v, v == 0, 10, 1000, false,
> +			  tctx->dev->dev + RK_CRYPTO_HASH_STS);

This can be simplified to:

	readl_poll_timeout(tctx->dev->dev + RK_CRYPTO_HASH_STS,
			   v, v == 0, 10, 1000);

But shouldn't this be tctx->dev->reg ?!

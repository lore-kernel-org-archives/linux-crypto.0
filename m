Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0DDF9C05027
	for <linux-crypto@archiver.kernel.org>; Mon, 20 Feb 2023 04:42:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229593AbjBTEmW (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Sun, 19 Feb 2023 23:42:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59856 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229451AbjBTEmV (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sun, 19 Feb 2023 23:42:21 -0500
Received: from 167-179-156-38.a7b39c.syd.nbn.aussiebb.net (167-179-156-38.a7b39c.syd.nbn.aussiebb.net [167.179.156.38])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D6E13A5E2
        for <linux-crypto@vger.kernel.org>; Sun, 19 Feb 2023 20:42:18 -0800 (PST)
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
        by formenos.hmeau.com with smtp (Exim 4.94.2 #2 (Debian))
        id 1pTxzv-00DEh7-1u; Mon, 20 Feb 2023 12:41:56 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Mon, 20 Feb 2023 12:41:55 +0800
Date:   Mon, 20 Feb 2023 12:41:55 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Heiner Kallweit <hkallweit1@gmail.com>
Cc:     Olivia Mackall <olivia@selenic.com>,
        Neil Armstrong <neil.armstrong@linaro.org>,
        Kevin Hilman <khilman@baylibre.com>,
        Jerome Brunet <jbrunet@baylibre.com>,
        Martin Blumenstingl <martin.blumenstingl@googlemail.com>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "open list:ARM/Amlogic Meson..." <linux-amlogic@lists.infradead.org>
Subject: Re: [PATCH 4/5] hwrng: meson: use struct hw_random priv data
Message-ID: <Y/L6E+7SmLha7Bp8@gondor.apana.org.au>
References: <26216f60-d9b9-f40c-2c2a-95b3fde6c3bc@gmail.com>
 <4dafc70f-be7f-bfdc-8845-bd97b27d1c4c@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4dafc70f-be7f-bfdc-8845-bd97b27d1c4c@gmail.com>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Sat, Feb 18, 2023 at 09:58:07PM +0100, Heiner Kallweit wrote:
> Use the priv data member of struct hwrng to make the iomem base address
> available in meson_rng_read(). This allows for removing struct
> meson_rng_data completely in the next step.
> __force is used to silence sparse warnings.
> 
> Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
> ---
>  drivers/char/hw_random/meson-rng.c | 14 +++++++-------
>  1 file changed, 7 insertions(+), 7 deletions(-)
> 
> diff --git a/drivers/char/hw_random/meson-rng.c b/drivers/char/hw_random/meson-rng.c
> index a4eb8e35f..bf7a6e594 100644
> --- a/drivers/char/hw_random/meson-rng.c
> +++ b/drivers/char/hw_random/meson-rng.c
> @@ -17,16 +17,14 @@
>  #define RNG_DATA 0x00
>  
>  struct meson_rng_data {
> -	void __iomem *base;
>  	struct hwrng rng;
>  };

This is too ugly for words.  If you're trying to save memory we
should instead get rid of rng.priv and convert the drivers that
user it over to this model of embedding struct hwrng inside the
driver struct.

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt

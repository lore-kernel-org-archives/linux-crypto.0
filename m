From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] crypto: qce: Initialize core src clock @100Mhz
Date: Wed, 7 Sep 2016 20:50:06 +0800
Message-ID: <20160907125006.GA17176@gondor.apana.org.au>
References: <20160903164535.1118-1-voker57@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: davem@davemloft.net, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org, andy.gross@linaro.org,
        david.brown@linaro.org, linux-arm-msm@vger.kernel.org,
        linux-soc@vger.kernel.org
To: Iaroslav Gridin <voker57@gmail.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:60174 "EHLO
        helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754914AbcIGMuR (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 7 Sep 2016 08:50:17 -0400
Content-Disposition: inline
In-Reply-To: <20160903164535.1118-1-voker57@gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Sat, Sep 03, 2016 at 07:45:35PM +0300, Iaroslav Gridin wrote:
>
> @@ -247,6 +261,8 @@ err_clks_iface:
>  	clk_disable_unprepare(qce->iface);
>  err_clks_core:
>  	clk_disable_unprepare(qce->core);
> +err_clks_core_src:
> +	clk_disable_unprepare(qce->core_src);

What about qce_crypto_remove?

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt

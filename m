From: Bjorn Andersson <bjorn.andersson@linaro.org>
Subject: Re: [PATCH] crypto: qce: Initialize core src clock @100Mhz
Date: Mon, 12 Sep 2016 21:00:12 -0700
Message-ID: <20160913040012.GB21438@tuxbot>
References: <20160903164535.1118-1-voker57@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: herbert@gondor.apana.org.au, davem@davemloft.net,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        andy.gross@linaro.org, david.brown@linaro.org,
        linux-arm-msm@vger.kernel.org, linux-soc@vger.kernel.org
To: Iaroslav Gridin <voker57@gmail.com>
Return-path: <linux-arm-msm-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20160903164535.1118-1-voker57@gmail.com>
Sender: linux-arm-msm-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Sat 03 Sep 09:45 PDT 2016, Iaroslav Gridin wrote:

> Without that, QCE performance is about 2x less.
> 
> Signed-off-by: Iaroslav Gridin <voker57@gmail.com>
> ---
>  drivers/crypto/qce/core.c | 18 +++++++++++++++++-
>  drivers/crypto/qce/core.h |  2 +-
>  2 files changed, 18 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/crypto/qce/core.c b/drivers/crypto/qce/core.c
[..]
> @@ -205,10 +209,20 @@ static int qce_crypto_probe(struct platform_device *pdev)
>  	if (IS_ERR(qce->bus))
>  		return PTR_ERR(qce->bus);
>  
> -	ret = clk_prepare_enable(qce->core);
> +	ret = clk_prepare_enable(qce->core_src);
>  	if (ret)
>  		return ret;
>  
> +	ret = clk_set_rate(qce->core_src, 100000000);
> +	if (ret) {
> +		dev_warn(qce->dev, "Unable to set QCE core src clk @100Mhz, performance might be degraded\n");

This warning is misleading as you return a failure from probe() when it
happens.

> +		goto err_clks_core_src;
> +	}
> +
[..]
> +err_clks_core_src:
> +	clk_disable_unprepare(qce->core_src);
>  	return ret;
>  }
>  

Regards,
Bjorn

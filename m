From: Russell King - ARM Linux <linux-I+IVW8TIWO2tmTQ+vhA3Yw@public.gmane.org>
Subject: Re: [RESEND][PATCH] crypto: caam: add support for iMX6UL
Date: Mon, 31 Oct 2016 08:20:36 +0000
Message-ID: <20161031082036.GR1041@n2100.armlinux.org.uk>
References: <1476703680-22676-1-git-send-email-marcus.folkesson@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Cc: Herbert Xu <herbert-lOAM2aK0SrRLBo1qDEOMRrpzq4S04n8Q@public.gmane.org>,
        "David S . Miller" <davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org>,
        Rob Herring <robh+dt-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>,
        Mark Rutland <mark.rutland-5wv7dgnIgG8@public.gmane.org>,
        Horia Geanta <horia.geanta-3arQi8VN3Tc@public.gmane.org>,
        Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>,
        Alex Porosanu <alexandru.porosanu-3arQi8VN3Tc@public.gmane.org>,
        Srinivas Kandagatla <srinivas.kandagatla-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>,
        Baoyou Xie <baoyou.xie-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>,
        linux-crypto-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, devicetree-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
        linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Marcus Folkesson <marcus.folkesson-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <devicetree-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1476703680-22676-1-git-send-email-marcus.folkesson-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: devicetree-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-crypto.vger.kernel.org

On Mon, Oct 17, 2016 at 01:28:00PM +0200, Marcus Folkesson wrote:
> i.MX6UL does only require three clocks to enable CAAM module.
> 
> Signed-off-by: Marcus Folkesson <marcus.folkesson-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
> Acked-by: Rob Herring <robh-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
> Reviewed-by: Horia Geantă <horia.geanta-3arQi8VN3Tc@public.gmane.org>
> ---
>  .../devicetree/bindings/crypto/fsl-sec4.txt        | 20 +++++++++++++
>  drivers/crypto/caam/ctrl.c                         | 35 ++++++++++++----------
>  2 files changed, 40 insertions(+), 15 deletions(-)
> 
> diff --git a/Documentation/devicetree/bindings/crypto/fsl-sec4.txt b/Documentation/devicetree/bindings/crypto/fsl-sec4.txt
> index adeca34..10a425f 100644
> --- a/Documentation/devicetree/bindings/crypto/fsl-sec4.txt
> +++ b/Documentation/devicetree/bindings/crypto/fsl-sec4.txt
> @@ -123,6 +123,9 @@ PROPERTIES
>  
>  
>  EXAMPLE
> +
> +iMX6QDL/SX requires four clocks
> +
>  	crypto@300000 {
>  		compatible = "fsl,sec-v4.0";
>  		fsl,sec-era = <2>;
> @@ -139,6 +142,23 @@ EXAMPLE
>  		clock-names = "mem", "aclk", "ipg", "emi_slow";
>  	};
>  
> +
> +iMX6UL does only require three clocks
> +
> +	crypto: caam@2140000 {
> +		compatible = "fsl,sec-v4.0";
> +		#address-cells = <1>;
> +		#size-cells = <1>;
> +		reg = <0x2140000 0x3c000>;
> +		ranges = <0 0x2140000 0x3c000>;
> +		interrupts = <GIC_SPI 48 IRQ_TYPE_LEVEL_HIGH>;
> +
> +		clocks = <&clks IMX6UL_CLK_CAAM_MEM>,
> +			 <&clks IMX6UL_CLK_CAAM_ACLK>,
> +			 <&clks IMX6UL_CLK_CAAM_IPG>;
> +		clock-names = "mem", "aclk", "ipg";
> +	};
> +
>  =====================================================================
>  Job Ring (JR) Node
>  
> diff --git a/drivers/crypto/caam/ctrl.c b/drivers/crypto/caam/ctrl.c
> index 0ec112e..5abaf37 100644
> --- a/drivers/crypto/caam/ctrl.c
> +++ b/drivers/crypto/caam/ctrl.c
> @@ -329,8 +329,8 @@ static int caam_remove(struct platform_device *pdev)
>  	clk_disable_unprepare(ctrlpriv->caam_ipg);
>  	clk_disable_unprepare(ctrlpriv->caam_mem);
>  	clk_disable_unprepare(ctrlpriv->caam_aclk);
> -	clk_disable_unprepare(ctrlpriv->caam_emi_slow);
> -
> +	if (!of_machine_is_compatible("fsl,imx6ul"))
> +		clk_disable_unprepare(ctrlpriv->caam_emi_slow);

There is no need to re-lookup the platform here.  Can't you check the
validity of ctrlpriv->caam_emi_slow ?

>  	return 0;
>  }
>  
> @@ -481,14 +481,16 @@ static int caam_probe(struct platform_device *pdev)
>  	}
>  	ctrlpriv->caam_aclk = clk;
>  
> -	clk = caam_drv_identify_clk(&pdev->dev, "emi_slow");
> -	if (IS_ERR(clk)) {
> -		ret = PTR_ERR(clk);
> -		dev_err(&pdev->dev,
> -			"can't identify CAAM emi_slow clk: %d\n", ret);
> -		return ret;
> +	if (!of_machine_is_compatible("fsl,imx6ul")) {
> +		clk = caam_drv_identify_clk(&pdev->dev, "emi_slow");
> +		if (IS_ERR(clk)) {
> +			ret = PTR_ERR(clk);
> +			dev_err(&pdev->dev,
> +				"can't identify CAAM emi_slow clk: %d\n", ret);
> +			return ret;
> +		}
> +		ctrlpriv->caam_emi_slow = clk;
>  	}
> -	ctrlpriv->caam_emi_slow = clk;
>  
>  	ret = clk_prepare_enable(ctrlpriv->caam_ipg);
>  	if (ret < 0) {
> @@ -509,11 +511,13 @@ static int caam_probe(struct platform_device *pdev)
>  		goto disable_caam_mem;
>  	}
>  
> -	ret = clk_prepare_enable(ctrlpriv->caam_emi_slow);
> -	if (ret < 0) {
> -		dev_err(&pdev->dev, "can't enable CAAM emi slow clock: %d\n",
> -			ret);
> -		goto disable_caam_aclk;
> +	if (!of_machine_is_compatible("fsl,imx6ul")) {

Same here.

> +		ret = clk_prepare_enable(ctrlpriv->caam_emi_slow);
> +		if (ret < 0) {
> +			dev_err(&pdev->dev, "can't enable CAAM emi slow clock: %d\n",
> +				ret);
> +			goto disable_caam_aclk;
> +		}
>  	}
>  
>  	/* Get configuration properties from device tree */
> @@ -829,7 +833,8 @@ caam_remove:
>  iounmap_ctrl:
>  	iounmap(ctrl);
>  disable_caam_emi_slow:
> -	clk_disable_unprepare(ctrlpriv->caam_emi_slow);
> +	if (!of_machine_is_compatible("fsl,imx6ul"))
> +		clk_disable_unprepare(ctrlpriv->caam_emi_slow);

and here.

>  disable_caam_aclk:
>  	clk_disable_unprepare(ctrlpriv->caam_aclk);
>  disable_caam_mem:
> -- 
> 2.8.0
> 

-- 
RMK's Patch system: http://www.armlinux.org.uk/developer/patches/
FTTC broadband for 0.8mile line: currently at 9.6Mbps down 400kbps up
according to speedtest.net.
--
To unsubscribe from this list: send the line "unsubscribe devicetree" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

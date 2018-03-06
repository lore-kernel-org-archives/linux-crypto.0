From: Rob Herring <robh@kernel.org>
Subject: Re: [PATCH 1/2] Documentation: dt: rng: add bindings doc for
 Keystone SA HWRNG driver
Date: Mon, 5 Mar 2018 20:40:38 -0600
Message-ID: <20180306024038.uszf3r4nb4pw6kkf@rob-hp-laptop>
References: <1519908900-10388-1-git-send-email-vitalya@ti.com>
 <1519908900-10388-2-git-send-email-vitalya@ti.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: mpm@selenic.com, herbert@gondor.apana.org.au, arnd@arndb.de,
        gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org,
        linux-crypto@vger.kernel.org, mark.rutland@arm.com,
        devicetree@vger.kernel.org, t-kristo@ti.com, m-karicheri2@ti.com
To: Vitaly Andrianov <vitalya@ti.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1519908900-10388-2-git-send-email-vitalya@ti.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Thu, Mar 01, 2018 at 07:54:59AM -0500, Vitaly Andrianov wrote:
> The Keystone SA module has a hardware random generator module.
> This commit adds binding doc for the KS2 SA HWRNG driver.

Preferred subject prefix is "dt-bindings: rng: ..."

> 
> Signed-off-by: Vitaly Andrianov <vitalya@ti.com>
> Signed-off-by: Murali Karicheri <m-karicheri2@ti.com>
> ---
>  Documentation/devicetree/bindings/rng/ks-sa-rng.txt | 21 +++++++++++++++++++++
>  1 file changed, 21 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/rng/ks-sa-rng.txt
> 
> diff --git a/Documentation/devicetree/bindings/rng/ks-sa-rng.txt b/Documentation/devicetree/bindings/rng/ks-sa-rng.txt
> new file mode 100644
> index 0000000..cc8ee44
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/rng/ks-sa-rng.txt
> @@ -0,0 +1,21 @@
> +Keystone SoC Hardware Random Number Generator(HWRNG) Module
> +
> +On Keystone SoCs HWRNG module is a submodule of the Security Accelerator.
> +
> +- compatible: should be "ti,keystone-rng"
> +- ti,syscon-sa-cfg: phandle to syscon node of the SA configuration registers.
> +		    This registers are shared between hwrng and crypto drivers.
> +- clocks: phandle to the reference clocks for the subsystem
> +- clock-names: functional clock name. Should be set to "fck"
> +- reg: HWRNG module register space
> +
> +Example:
> +/* K2HK */
> +
> +hwrng@0x24000 {

rng@24000

With those,

Reviewed-by: Rob Herring <robh@kernel.org>                                 

> +	compatible = "ti,keystone-rng";
> +	ti,syscon-sa-cfg = <&sa_config>;
> +	clocks = <&clksa>;
> +	clock-names = "fck";
> +	reg = <0x24000 0x1000>;
> +};
> -- 
> 2.7.4
> 

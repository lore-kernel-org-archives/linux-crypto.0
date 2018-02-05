From: Rob Herring <robh-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [RFC PATCH 1/3] dt-bindings: Add bindings for Hisilicon SEC
 crypto accelerators.
Date: Mon, 5 Feb 2018 00:07:37 -0600
Message-ID: <20180205060737.4jfc2pqkykzhx42d@rob-hp-laptop>
References: <20180130152953.14068-1-jonathan.cameron@huawei.com>
 <20180130152953.14068-2-jonathan.cameron@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linuxarm-hv44wF8Li93QT0dZR+AlfA@public.gmane.org,
        xuzaibo-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, Herbert Xu <herbert-lOAM2aK0SrRLBo1qDEOMRrpzq4S04n8Q@public.gmane.org>,
        "David S . Miller" <davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org>,
        Stephan =?iso-8859-1?Q?M=FCller?= <smueller-T9tCv8IpfcWELgA04lAiVw@public.gmane.org>,
        devicetree-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Mark Brown <broonie-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>,
        Xiongfeng Wang <xiongfeng.wang-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
To: Jonathan Cameron <jonathan.cameron-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Return-path: <devicetree-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20180130152953.14068-2-jonathan.cameron-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Sender: devicetree-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-crypto.vger.kernel.org

On Tue, Jan 30, 2018 at 03:29:51PM +0000, Jonathan Cameron wrote:
> From: Jonathan Cameron <Jonathan.Cameron-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
> 
> The hip06 and hip07 SoCs contain a number of these crypto units which
> accelerate AES and DES operations.
> 
> Signed-off-by: Jonathan Cameron <Jonathan.Cameron-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
> ---
>  .../bindings/crypto/hisilicon,hip07-sec.txt        | 71 ++++++++++++++++++++++
>  1 file changed, 71 insertions(+)
> 
> diff --git a/Documentation/devicetree/bindings/crypto/hisilicon,hip07-sec.txt b/Documentation/devicetree/bindings/crypto/hisilicon,hip07-sec.txt
> new file mode 100644
> index 000000000000..bf81118e560c
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/crypto/hisilicon,hip07-sec.txt
> @@ -0,0 +1,71 @@
> +* Hisilicon hip07 Security Accelerator (SEC)
> +
> +Required properties:
> +- compatible: Must contain one of
> +  - "hisilicon,hip06-sec"
> +  - "hisilicon,hip07-sec"
> +- #address-cells: Must be <2> as 64 bit addresses in reg.
> +- #size-cells: Must be <2> as 64 bit lengths in reg.

You don't have any child nodes, so these aren't needed.

> +- reg: Memory addresses and lengths of the memory regions used by the driver.
> +  Region 0 has registers to control the backend processing engines.
> +  Region 1 has registers for functionality common to all queues.
> +  Regions 2-18 have registers for the individual queues which are isolated
> +  both in hardware and within the driver.
> +- interrupts: Interrupt specifiers.
> +  Refer to interrupt-controller/interrupts.txt for generic interrupt client node
> +  bindings.
> +  Interrupt 0 is for the SEC unit error queue.
> +  Interrupt 2N + 1 is the completion interrupt for queue N.
> +  Interrupt 2N + 2 is the error interrupt for queue N.
> +- dma-coherent:  The driver assumes coherent dma is possible.
> +
> +Optional properties:
> +- iommus: The SEC units are behind smmu-v3 iommus.
> +  Refer to iommu/arm,smmu-v3.txt for more information.
--
To unsubscribe from this list: send the line "unsubscribe devicetree" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

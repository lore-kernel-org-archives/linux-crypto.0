From: Kim Phillips <kim.phillips-5wv7dgnIgG8@public.gmane.org>
Subject: Re: [PATCH RESEND 1/4] crypto: caam: add caam-dma node to SEC4.0
 device tree binding
Date: Mon, 30 Oct 2017 09:24:24 -0500
Message-ID: <20171030092424.1279add003c96ced4233bd2d@arm.com>
References: <20171030134654.13729-1-horia.geanta@nxp.com>
        <20171030134654.13729-2-horia.geanta@nxp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Cc: Vinod Koul <vinod.koul-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>,
        Herbert Xu <herbert-lOAM2aK0SrRLBo1qDEOMRrpzq4S04n8Q@public.gmane.org>,
        "David S. Miller" <davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org>,
        Dan Douglass <dan.douglass-3arQi8VN3Tc@public.gmane.org>,
        Shawn Guo <shawnguo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>,
        Radu Alexe <radu.alexe-3arQi8VN3Tc@public.gmane.org>, <dmaengine-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
        <linux-crypto-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, <devicetree-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
To: Horia =?UTF-8?B?R2VhbnTEgw==?= <horia.geanta-3arQi8VN3Tc@public.gmane.org>
Return-path: <devicetree-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20171030134654.13729-2-horia.geanta-3arQi8VN3Tc@public.gmane.org>
Sender: devicetree-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-crypto.vger.kernel.org

On Mon, 30 Oct 2017 15:46:51 +0200
Horia Geantă <horia.geanta-3arQi8VN3Tc@public.gmane.org> wrote:

> +=====================================================================
> +CAAM DMA Node
> +
> +    Child node of the crypto node that enables the use of the DMA capabilities
> +    of the CAAM by a stand-alone driver. The only required property is the
> +    "compatible" property. All the other properties are determined from
> +    the job rings on which the CAAM DMA driver depends (ex: the number of
> +    dma-channels is equal to the number of defined job rings).
> +
> +  - compatible
> +      Usage: required
> +      Value type: <string>
> +      Definition: Must include "fsl,sec-v4.0-dma"
> +
> +EXAMPLE
> +  caam-dma {
> +    compatible = "fsl,sec-v5.4-dma",
> +                 "fsl,sec-v5.0-dma",
> +                 "fsl,sec-v4.0-dma";
> +  }

If this isn't describing an aspect of the hardware, then what is it
doing in the device tree?

Kim
--
To unsubscribe from this list: send the line "unsubscribe devicetree" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

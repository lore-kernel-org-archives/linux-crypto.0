From: Rob Herring <robh-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH v2 1/3] crypto: brcm: DT documentation for Broadcom SPU
 driver
Date: Fri, 9 Dec 2016 15:26:18 -0600
Message-ID: <20161209212618.gvjdjhmryobrmwrp@rob-hp-laptop>
References: <1480714499-1476-1-git-send-email-rob.rice@broadcom.com>
 <1480714499-1476-2-git-send-email-rob.rice@broadcom.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Herbert Xu <herbert-lOAM2aK0SrRLBo1qDEOMRrpzq4S04n8Q@public.gmane.org>,
        "David S. Miller" <davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org>,
        Mark Rutland <mark.rutland-5wv7dgnIgG8@public.gmane.org>,
        linux-crypto-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, devicetree-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
        linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Ray Jui <rjui-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>,
        Scott Branden <sbranden-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>,
        Jon Mason <jonmason-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>,
        bcm-kernel-feedback-list-dY08KVG/lbpWk0Htik3J/w@public.gmane.org,
        Catalin Marinas <catalin.marinas-5wv7dgnIgG8@public.gmane.org>,
        Will Deacon <will.deacon-5wv7dgnIgG8@public.gmane.org>,
        linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org,
        Steve Lin <steven.lin1-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>
To: Rob Rice <rob.rice-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>
Return-path: <devicetree-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1480714499-1476-2-git-send-email-rob.rice-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>
Sender: devicetree-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-crypto.vger.kernel.org

On Fri, Dec 02, 2016 at 04:34:57PM -0500, Rob Rice wrote:
> Device tree documentation for Broadcom Secure Processing Unit
> (SPU) crypto driver.
> 
> Signed-off-by: Steve Lin <steven.lin1-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>
> Signed-off-by: Rob Rice <rob.rice-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>
> ---
>  .../devicetree/bindings/crypto/brcm,spu-crypto.txt | 25 ++++++++++++++++++++++
>  1 file changed, 25 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/crypto/brcm,spu-crypto.txt
> 
> diff --git a/Documentation/devicetree/bindings/crypto/brcm,spu-crypto.txt b/Documentation/devicetree/bindings/crypto/brcm,spu-crypto.txt
> new file mode 100644
> index 0000000..e5fe942
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/crypto/brcm,spu-crypto.txt
> @@ -0,0 +1,25 @@
> +The Broadcom Secure Processing Unit (SPU) driver supports symmetric

Bindings describe h/w, not drivers.

> +cryptographic offload for Broadcom SoCs with SPU hardware. A SoC may have
> +multiple SPU hardware blocks.
> +
> +Required properties:
> +- compatible : Should be "brcm,spum-crypto" for devices with SPU-M hardware

Additionally, you should have SoC specific compatible here.

> +  (e.g., Northstar2) or "brcm,spum-nsp-crypto" for the Northstar Plus variant
> +  of the SPU-M hardware.
> +
> +- reg: Should contain SPU registers location and length.
> +- mboxes: A list of mailbox channels to be used by the kernel driver. Mailbox
> +channels correspond to DMA rings on the device.

What determines the mbox assignment?

Needs to specify how many.

> +
> +Example:
> +	spu-crypto@612d0000 {

Just crypto@...

Rob
--
To unsubscribe from this list: send the line "unsubscribe devicetree" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

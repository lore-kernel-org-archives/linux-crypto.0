From: Jon Mason <jon.mason-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH 1/1] ARM: dts: NSP: Add crypto (SPU) to dtsi
Date: Wed, 22 Feb 2017 18:32:15 -0500
Message-ID: <CAC3K-4oaFiP43wGWTqqeB-Hcr0Ov07Xu1RONCi+NAXqf9hr2-g@mail.gmail.com>
References: <1487798543-34229-1-git-send-email-steven.lin1@broadcom.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: Herbert Xu <herbert-lOAM2aK0SrRLBo1qDEOMRrpzq4S04n8Q@public.gmane.org>,
        Rob Herring <robh+dt-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>,
        Russell King <linux-I+IVW8TIWO2tmTQ+vhA3Yw@public.gmane.org>,
        Ray Jui <ray.jui-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>,
        Scott Branden <scott.branden-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>,
        Florian Fainelli <f.fainelli-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>,
        Mark Rutland <mark.rutland-5wv7dgnIgG8@public.gmane.org>,
        BCM Kernel Feedback <bcm-kernel-feedback-list-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>,
        "open list:OPEN FIRMWARE AND FLATTENED DEVICE TREE BINDINGS"
        <devicetree-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
        linux-arm-kernel <linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org>,
        open list <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
        Rob Rice <rob.rice-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>, linux-crypto-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Steve Lin <steven.lin1-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>
Return-path: <devicetree-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1487798543-34229-1-git-send-email-steven.lin1-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>
Sender: devicetree-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-crypto.vger.kernel.org

On Wed, Feb 22, 2017 at 4:22 PM, Steve Lin <steven.lin1-dY08KVG/lbpWk0Htik3J/w@public.gmane.org> wrote:
> Adds crypto hardware (SPU) to Northstar Plus device tree file.
>
> Signed-off-by: Steve Lin <steven.lin1-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>

Looks good to me!

Acked-by: Jon Mason <jon.mason-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>

>
> ---
> Code changes for this addition were submitted previously by Rob
> Rice: https://git.kernel.org/cgit/linux/kernel/git/herbert/cryptodev-2.6.git/commit/?id=9d12ba86f818aa9cfe9f01b750336aa441f2ffa2
> ---
>  arch/arm/boot/dts/bcm-nsp.dtsi | 6 ++++++
>  1 file changed, 6 insertions(+)
>
> diff --git a/arch/arm/boot/dts/bcm-nsp.dtsi b/arch/arm/boot/dts/bcm-nsp.dtsi
> index b6142bd..9bac0c8 100644
> --- a/arch/arm/boot/dts/bcm-nsp.dtsi
> +++ b/arch/arm/boot/dts/bcm-nsp.dtsi
> @@ -241,6 +241,12 @@
>                         brcm,nand-has-wp;
>                 };
>
> +               crypto@2f000 {
> +                       compatible = "brcm,spum-nsp-crypto";
> +                       reg = <0x2f000 0x900>;
> +                       mboxes = <&mailbox 0>;
> +               };
> +
>                 gpiob: gpio@30000 {
>                         compatible = "brcm,iproc-nsp-gpio", "brcm,iproc-gpio";
>                         reg = <0x30000 0x50>;
> --
> 2.1.0
>
--
To unsubscribe from this list: send the line "unsubscribe devicetree" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

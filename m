From: Heiko Stuebner <heiko-4mtYJXux2i+zQB+pC5nmwQ@public.gmane.org>
Subject: Re: [RESEND PATCH 4/4] crypto: rk_crypto - add DT bindings documentation
Date: Fri, 30 Oct 2015 15:08:35 +0100
Message-ID: <1830252.moyLTPMs2Y@phil>
References: <1446193369-4453-1-git-send-email-zain.wang@rock-chips.com> <1446193369-4453-5-git-send-email-zain.wang@rock-chips.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Cc: zhengsq-TNX95d0MmH7DzftRWevZcw@public.gmane.org, hl-TNX95d0MmH7DzftRWevZcw@public.gmane.org,
	herbert-lOAM2aK0SrRLBo1qDEOMRrpzq4S04n8Q@public.gmane.org, davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org,
	mturquette-rdvid1DuHRBWk0Htik3J/w@public.gmane.org, pawel.moll-5wv7dgnIgG8@public.gmane.org,
	ijc+devicetree-KcIKpvwj1kUDXYZnReoRVg@public.gmane.org, robh+dt-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org,
	galak-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org, linux-lFZ/pmaqli7XmaaqVzeoHQ@public.gmane.org, mark.rutland-5wv7dgnIgG8@public.gmane.org,
	linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-crypto-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	linux-rockchip-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, devicetree-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	eddie.cai-TNX95d0MmH7DzftRWevZcw@public.gmane.org
To: Zain Wang <zain.wang-TNX95d0MmH7DzftRWevZcw@public.gmane.org>
Return-path: <devicetree-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1446193369-4453-5-git-send-email-zain.wang-TNX95d0MmH7DzftRWevZcw@public.gmane.org>
Sender: devicetree-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-crypto.vger.kernel.org

Hi,

Am Freitag, 30. Oktober 2015, 16:22:49 schrieb Zain Wang:
> Add DT bindings documentation for the rk3288 crypto drivers.
> 
> Signed-off-by: Zain Wang <zain.wang-TNX95d0MmH7DzftRWevZcw@public.gmane.org>
> ---
>  .../devicetree/bindings/crypto/rk-crypto.txt       | 31 ++++++++++++++++++++++
>  1 file changed, 31 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/crypto/rk-crypto.txt
> 
> diff --git a/Documentation/devicetree/bindings/crypto/rk-crypto.txt b/Documentation/devicetree/bindings/crypto/rk-crypto.txt
> new file mode 100644
> index 0000000..1e50768
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/crypto/rk-crypto.txt
> @@ -0,0 +1,31 @@
> +Rockchip Electronics And Security Accelerator
> +
> +Required properties:
> +- compatible: should be "rockchip,crypto"
> +- reg: base physical address of the engine and length of memory mapped
> +       region.
> +- interrupts: interrupt number
> +- clocks: clock specifiers
> +- clock-names: "aclk_crypto" used to clock data
> +			   "hclk_crypto" used to clock data
> +			   "srst_crypto" used to clock crypto accelerator
> +			   "apb_pclk"    used to clock dma

The TRM area of the crypto IP block does not specifiy any special naming for
its clocks, but as a general rule clock names are in the scope of the ip block
so there is no need to add _crypto to every one of them :-) .

I'd suggest clock-names as "aclk", "hclk", "crypto" for the devicetree, with
crypto being the clock that actually drives the operation.


Secondly, why do you need to drive the clock of the peripheral dma-
controller itself (your apb_pclk)? The documentation in the TRM is
quite sparse, so this might very well be justified, but it looks odd that
you need to control the dmac1-clock when it looks like the crypto block
is doing its own dma and neither system-dma has any crypto-related
channel.

So I'd really like some explanation for this :-)


Thanks
Heiko
--
To unsubscribe from this list: send the line "unsubscribe devicetree" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

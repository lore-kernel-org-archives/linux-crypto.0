From: Corentin Labbe <clabbe.montjoie-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH v5 2/2] crypto: stm32 - Support for STM32 CRYP crypto
 module
Date: Sun, 22 Oct 2017 09:26:59 +0200
Message-ID: <20171022072659.GB8489@Red>
References: <1508425830-13565-1-git-send-email-fabien.dessenne@st.com>
 <1508425830-13565-3-git-send-email-fabien.dessenne@st.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Herbert Xu <herbert-lOAM2aK0SrRLBo1qDEOMRrpzq4S04n8Q@public.gmane.org>,
        "David S . Miller" <davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org>,
        Rob Herring <robh+dt-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>,
        Mark Rutland <mark.rutland-5wv7dgnIgG8@public.gmane.org>,
        Maxime Coquelin <mcoquelin.stm32-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>,
        Alexandre Torgue <alexandre.torgue-qxv4g6HH51o@public.gmane.org>,
        linux-crypto-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, devicetree-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
        linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
        Lionel Debieve <lionel.debieve-qxv4g6HH51o@public.gmane.org>,
        Benjamin Gaignard <benjamin.gaignard-qxv4g6HH51o@public.gmane.org>,
        Ludovic Barre <ludovic.barre-qxv4g6HH51o@public.gmane.org>
To: Fabien Dessenne <fabien.dessenne-qxv4g6HH51o@public.gmane.org>
Return-path: <devicetree-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1508425830-13565-3-git-send-email-fabien.dessenne-qxv4g6HH51o@public.gmane.org>
Sender: devicetree-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-crypto.vger.kernel.org

On Thu, Oct 19, 2017 at 05:10:30PM +0200, Fabien Dessenne wrote:
> This module registers block cipher algorithms that make use of the
> STMicroelectronics STM32 crypto "CRYP1" hardware.
> The following algorithms are supported:
> - aes: ecb, cbc, ctr
> - des: ecb, cbc
> - tdes: ecb, cbc
> 
> Signed-off-by: Fabien Dessenne <fabien.dessenne-qxv4g6HH51o@public.gmane.org>
> ---
>  drivers/crypto/stm32/Kconfig      |    9 +
>  drivers/crypto/stm32/Makefile     |    3 +-
>  drivers/crypto/stm32/stm32-cryp.c | 1172 +++++++++++++++++++++++++++++++++++++
>  3 files changed, 1183 insertions(+), 1 deletion(-)
>  create mode 100644 drivers/crypto/stm32/stm32-cryp.c
> 
> diff --git a/drivers/crypto/stm32/Kconfig b/drivers/crypto/stm32/Kconfig
> +static void stm32_cryp_irq_write_block(struct stm32_cryp *cryp)
> +{
> +	unsigned int i, j;
> +	u32 *src;
> +	u8 d8[4];
> +
> +	src = sg_virt(cryp->in_sg) + _walked_in;
> +
> +	for (i = 0; i < cryp->hw_blocksize / sizeof(u32); i++) {
> +		if (likely(cryp->total_in >= sizeof(u32))) {
> +			/* Write a full u32 */
> +			stm32_cryp_write(cryp, CRYP_DIN, *src);

Hello

Try also to test your driver with userspace via AF_ALG (libkcapi is a good start).
It should probably crash here.
I have do the same on my first sunxi-ss driver and you should use kmap().

Regards
--
To unsubscribe from this list: send the line "unsubscribe devicetree" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

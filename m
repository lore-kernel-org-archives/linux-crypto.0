From: Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>
Subject: Re: [PATCH v5 4/4] crypto: Add Allwinner Security System crypto accelerator
Date: Wed, 22 Oct 2014 11:00:45 +0200
Message-ID: <2751026.4HEPlZfN7W__29015.4548049488$1413968538$gmane$org@wuerfel>
References: <1413728182-13569-1-git-send-email-clabbe.montjoie@gmail.com> <1413728182-13569-5-git-send-email-clabbe.montjoie@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Cc: LABBE Corentin <clabbe.montjoie-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, robh+dt-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org,
	pawel.moll-5wv7dgnIgG8@public.gmane.org, mark.rutland-5wv7dgnIgG8@public.gmane.org,
	ijc+devicetree-KcIKpvwj1kUDXYZnReoRVg@public.gmane.org, galak-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org,
	maxime.ripard-wi1+55ScJUtKEb57/3fJTNBPR1lH4CV8@public.gmane.org, linux-lFZ/pmaqli7XmaaqVzeoHQ@public.gmane.org,
	herbert-lOAM2aK0SrRLBo1qDEOMRrpzq4S04n8Q@public.gmane.org, davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org,
	grant.likely-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org,
	gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org, joe-6d6DIl74uiNBDgjK7y7TUQ@public.gmane.org,
	mchehab-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org, crope-X3B1VOXEql0@public.gmane.org, devicetree-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-sunxi-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org,
	linux-crypto-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org
Return-path: <devicetree-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1413728182-13569-5-git-send-email-clabbe.montjoie-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: devicetree-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-crypto.vger.kernel.org

On Sunday 19 October 2014 16:16:22 LABBE Corentin wrote:
> Add support for the Security System included in Allwinner SoC A20.
> The Security System is a hardware cryptographic accelerator that support AES/MD5/SHA1/DES/3DES/PRNG algorithms.
> 
> Signed-off-by: LABBE Corentin <clabbe.montjoie-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>

Please wrap lines in the changelog after about 70 characters.

> --- /dev/null
> +++ b/drivers/crypto/sunxi-ss/sunxi-ss-cipher.c
> @@ -0,0 +1,489 @@

> +#include "sunxi-ss.h"
> +
> +extern struct sunxi_ss_ctx *ss;

'extern' declarations belong into header files, not .c files. It would
be even better to avoid this completely and carry the pointer to the
context in an object that gets passed around. In general we want drivers
to be written in a way that allows having multiple instances of the
device, which the global pointer prevents.

> +
> +	src32 = (u32 *)src_addr;
> +	dst32 = (u32 *)dst_addr;


You appear to be missing '__iomem' annotations for the mmio pointers.
Please always run your code through the 'sparse' checker using 'make C=1'
to catch and fix this and other erros.

> +	ileft = areq->nbytes / 4;
> +	oleft = areq->nbytes / 4;
> +	i = 0;
> +	do {
> +		if (ileft > 0 && rx_cnt > 0) {
> +			todo = min(rx_cnt, ileft);
> +			ileft -= todo;
> +			do {
> +				writel_relaxed(*src32++,
> +						ss->base +
> +						SS_RXFIFO);
> +				todo--;
> +			} while (todo > 0);
> +		}

This looks like it should be using writesl() instead of the 
writel_relaxed() loop. That should not only be faster but it will
also change the byte ordering if you are running a big-endian
kernel.

Since this is a FIFO register, the ordering that writesl uses
is likely the correct one.

	Arnd
--
To unsubscribe from this list: send the line "unsubscribe devicetree" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

From: Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH v5 4/4] crypto: Add Allwinner Security System crypto accelerator
Date: Wed, 22 Oct 2014 11:00:45 +0200
Message-ID: <2751026.4HEPlZfN7W__5440.46102227202$1413968532$gmane$org@wuerfel>
References: <1413728182-13569-1-git-send-email-clabbe.montjoie@gmail.com> <1413728182-13569-5-git-send-email-clabbe.montjoie@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Cc: LABBE Corentin <clabbe.montjoie@gmail.com>, robh+dt@kernel.org,
	pawel.moll@arm.com, mark.rutland@arm.com,
	ijc+devicetree@hellion.org.uk, galak@codeaurora.org,
	maxime.ripard@free-electrons.com, linux@arm.linux.org.uk,
	herbert@gondor.apana.org.au, davem@davemloft.net,
	grant.likely@linaro.org, akpm@linux-foundation.org,
	gregkh@linuxfoundation.org, joe@perches.com,
	mchehab@osg.samsung.com, crope@iki.fi, devicetree@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-sunxi@googlegroups.com,
	linux-crypto@vger.kernel.org
To: linux-arm-kernel@lists.infradead.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mout.kundenserver.de ([212.227.126.130]:53511 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753121AbaJVJB5 (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 22 Oct 2014 05:01:57 -0400
In-Reply-To: <1413728182-13569-5-git-send-email-clabbe.montjoie@gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Sunday 19 October 2014 16:16:22 LABBE Corentin wrote:
> Add support for the Security System included in Allwinner SoC A20.
> The Security System is a hardware cryptographic accelerator that support AES/MD5/SHA1/DES/3DES/PRNG algorithms.
> 
> Signed-off-by: LABBE Corentin <clabbe.montjoie@gmail.com>

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

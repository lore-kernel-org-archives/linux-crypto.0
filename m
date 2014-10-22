From: Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH v5 4/4] crypto: Add Allwinner Security System crypto
 accelerator
Date: Wed, 22 Oct 2014 11:00:45 +0200
Message-ID: <2751026.4HEPlZfN7W__2940.28764260492$1413968562$gmane$org@wuerfel>
References: <1413728182-13569-1-git-send-email-clabbe.montjoie@gmail.com>
 <1413728182-13569-5-git-send-email-clabbe.montjoie@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: mark.rutland@arm.com, crope@iki.fi, linux@arm.linux.org.uk,
 herbert@gondor.apana.org.au, pawel.moll@arm.com, ijc+devicetree@hellion.org.uk,
 gregkh@linuxfoundation.org, linux-sunxi@googlegroups.com,
 mchehab@osg.samsung.com, linux-kernel@vger.kernel.org,
 akpm@linux-foundation.org, joe@perches.com, devicetree@vger.kernel.org,
 robh+dt@kernel.org, LABBE Corentin <clabbe.montjoie@gmail.com>,
 linux-crypto@vger.kernel.org, galak@codeaurora.org, grant.likely@linaro.org,
 maxime.ripard@free-electrons.com, davem@davemloft.net
To: linux-arm-kernel@lists.infradead.org
Return-path: <linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org>
In-Reply-To: <1413728182-13569-5-git-send-email-clabbe.montjoie@gmail.com>
List-Unsubscribe: <http://lists.infradead.org/mailman/options/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=unsubscribe>
List-Archive: <http://lists.infradead.org/pipermail/linux-arm-kernel/>
List-Post: <mailto:linux-arm-kernel@lists.infradead.org>
List-Help: <mailto:linux-arm-kernel-request@lists.infradead.org?subject=help>
List-Subscribe: <http://lists.infradead.org/mailman/listinfo/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=subscribe>
Sender: "linux-arm-kernel" <linux-arm-kernel-bounces@lists.infradead.org>
Errors-To: linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org
List-Id: linux-crypto.vger.kernel.org

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

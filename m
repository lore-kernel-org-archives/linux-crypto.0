From: Boris Brezillon <boris.brezillon@free-electrons.com>
Subject: Re: [PATCH 2/7] crypto: marvell: Check engine is not already
 running when enabling a req
Date: Wed, 15 Jun 2016 21:37:09 +0200
Message-ID: <20160615213709.3a060ff4@bbrezillon>
References: <1466018134-10779-1-git-send-email-romain.perier@free-electrons.com>
	<1466018134-10779-3-git-send-email-romain.perier@free-electrons.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: Arnaud Ebalard <arno@natisbad.org>,
	Gregory Clement <gregory.clement@free-electrons.com>,
	Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
	"David S. Miller" <davem@davemloft.net>,
	Russell King <linux@arm.linux.org.uk>,
	linux-crypto@vger.kernel.org, linux-arm-kernel@lists.infradead.org
To: Romain Perier <romain.perier@free-electrons.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from down.free-electrons.com ([37.187.137.238]:53792 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751867AbcFOThM (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 15 Jun 2016 15:37:12 -0400
In-Reply-To: <1466018134-10779-3-git-send-email-romain.perier@free-electrons.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Wed, 15 Jun 2016 21:15:29 +0200
Romain Perier <romain.perier@free-electrons.com> wrote:

> Adding BUG_ON() macro to be sure that the step operation is not about
> to activate a request on the engine if the corresponding engine is
> already processing a crypto request. This is helpful when the support
> for chaining crypto requests will be added. Instead of hanging the
> system when the engine is in an incoherent state, we add this macro

You don't add the macro, you use it.

> which throws an understandable error.

How about rewording the commit message this way:

"
Add a BUG_ON() call when the driver tries to launch a crypto request
while the engine is still processing the previous one. This replaces
a silent system hang by a verbose kernel panic with the associated
backtrace to let the user know that something went wrong in the CESA
driver.
"

> 
> Signed-off-by: Romain Perier <romain.perier@free-electrons.com>

Apart from the coding style issue mentioned below,

Acked-by: Boris Brezillon <boris.brezillon@free-electrons.com>

> ---
>  drivers/crypto/marvell/cipher.c | 2 ++
>  drivers/crypto/marvell/hash.c   | 2 ++
>  drivers/crypto/marvell/tdma.c   | 2 ++
>  3 files changed, 6 insertions(+)
> 
> diff --git a/drivers/crypto/marvell/cipher.c b/drivers/crypto/marvell/cipher.c
> index dcf1fce..8d0fabb 100644
> --- a/drivers/crypto/marvell/cipher.c
> +++ b/drivers/crypto/marvell/cipher.c
> @@ -106,6 +106,8 @@ static void mv_cesa_ablkcipher_std_step(struct ablkcipher_request *req)
>  
>  	mv_cesa_set_int_mask(engine, CESA_SA_INT_ACCEL0_DONE);
>  	writel_relaxed(CESA_SA_CFG_PARA_DIS, engine->regs + CESA_SA_CFG);
> +	BUG_ON(readl(engine->regs + CESA_SA_CMD)
> +				  & CESA_SA_CMD_EN_CESA_SA_ACCL0);

Nit: please put the '&' operator at the end of the first line and
align CESA_SA_CMD_EN_CESA_SA_ACCL0 on the open parenthesis.

	BUG_ON(readl(engine->regs + CESA_SA_CMD) &
	       CESA_SA_CMD_EN_CESA_SA_ACCL0);

>  	writel(CESA_SA_CMD_EN_CESA_SA_ACCL0, engine->regs + CESA_SA_CMD);
>  }
>  
> diff --git a/drivers/crypto/marvell/hash.c b/drivers/crypto/marvell/hash.c
> index 7ca2e0f..0fae351 100644
> --- a/drivers/crypto/marvell/hash.c
> +++ b/drivers/crypto/marvell/hash.c
> @@ -237,6 +237,8 @@ static void mv_cesa_ahash_std_step(struct ahash_request *req)
>  
>  	mv_cesa_set_int_mask(engine, CESA_SA_INT_ACCEL0_DONE);
>  	writel_relaxed(CESA_SA_CFG_PARA_DIS, engine->regs + CESA_SA_CFG);
> +	BUG_ON(readl(engine->regs + CESA_SA_CMD)
> +				  & CESA_SA_CMD_EN_CESA_SA_ACCL0);

Ditto.

>  	writel(CESA_SA_CMD_EN_CESA_SA_ACCL0, engine->regs + CESA_SA_CMD);
>  }
>  
> diff --git a/drivers/crypto/marvell/tdma.c b/drivers/crypto/marvell/tdma.c
> index 7642798..d493714 100644
> --- a/drivers/crypto/marvell/tdma.c
> +++ b/drivers/crypto/marvell/tdma.c
> @@ -53,6 +53,8 @@ void mv_cesa_dma_step(struct mv_cesa_tdma_req *dreq)
>  		       engine->regs + CESA_SA_CFG);
>  	writel_relaxed(dreq->chain.first->cur_dma,
>  		       engine->regs + CESA_TDMA_NEXT_ADDR);
> +	BUG_ON(readl(engine->regs + CESA_SA_CMD)
> +				  & CESA_SA_CMD_EN_CESA_SA_ACCL0);

Ditto.

>  	writel(CESA_SA_CMD_EN_CESA_SA_ACCL0, engine->regs + CESA_SA_CMD);
>  }
>  



-- 
Boris Brezillon, Free Electrons
Embedded Linux and Kernel engineering
http://free-electrons.com

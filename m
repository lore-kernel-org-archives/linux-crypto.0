From: Wolfgang Denk <wd@denx.de>
Subject: Re: [PATCH 1/2] PPC4xx: Generelizing drivers/dma/ppc4xx/adma.c
Date: Sat, 18 Sep 2010 23:09:20 +0200
Message-ID: <20100918210920.E05AE157D71@gemini.denx.de>
References: <1284774145-14543-1-git-send-email-tmarri@apm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Cc: linux-raid@vger.kernel.org, neilb@suse.de, yur@emcraft.com,
	herbert@gondor.hengli.com.au, linux-crypto@vger.kernel.org,
	dan.j.williams@intel.com, linuxppc-dev@lists.ozlabs.org
To: tmarri@apm.com
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-out.m-online.net ([212.18.0.10]:42399 "EHLO
	mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756032Ab0IRVJZ (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Sat, 18 Sep 2010 17:09:25 -0400
In-reply-to: <1284774145-14543-1-git-send-email-tmarri@apm.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Dear tmarri@apm.com,

In message <1284774145-14543-1-git-send-email-tmarri@apm.com> you wrote:
> 
> This patch generalizes the existing drver/dma/ppc4xx/adma.c, so that
> common code can be shared between different similar DMA engine
> drivers in other SoCs.
...
>   * This driver supports the asynchrounous DMA copy and RAID engines available
> - * on the AMCC PPC440SPe Processors.
> + * on the AMCC PPC4XX Processors.

Will this driver ever include any 40x processors? If not, you probably
should use "44x" instead (here and everywhere in the rest of the
code).


> diff --git a/drivers/dma/ppc4xx/ppc4xx-adma.h b/drivers/dma/ppc4xx/ppc4xx-adma.h
> new file mode 100644
> index 0000000..7457237
> --- /dev/null
> +++ b/drivers/dma/ppc4xx/ppc4xx-adma.h
...
> +#include <linux/of.h>
> +#include <linux/of_platform.h>
> +#include <asm/dcr.h>
> +#include <asm/dcr-regs.h>
> +#include "adma.h"
> +#include "ppc440spe-dma.h"
> +
> +/* Default polynomial (for 440SP is only available) */
> +#define PPC4XX_DEFAULT_POLY	0x4d

Should this go into "ppc440spe-dma.h"?

> +/* The list of channels exported by ppc440spe ADMA */
> +struct list_head
> + ppc4xx_adma_chan_list = LIST_HEAD_INIT(ppc4xx_adma_chan_list);
> +
> +/* This flag is set when want to refetch the xor chain in the interrupt
> + * handler
> + */
> +static u32 do_xor_refetch;
> +
> +/* Pointer to DMA0, DMA1 CP/CS FIFO */
> +static void *ppc440spe_dma_fifo_buf;

Seems this should go into "ppc440spe-dma.h"?


> +/* This array is used in data-check operations for storing a pattern */
> +static char ppc440spe_qword[16];
> +
> +static atomic_t ppc4xx_adma_err_irq_ref;
> +static dcr_host_t ppc440spe_mq_dcr_host;
> +static unsigned int ppc440spe_mq_dcr_len;

Ditto?

> +static unsigned long ppc440spe_rxor_state;
> +
> +static struct page *ppc440spe_rxor_srcs[32];

And here again - please check globally!


> +/**
> + * ppc440spe_can_rxor - check if the operands may be processed with RXOR
> + */
> +static int ppc440spe_can_rxor(struct page **srcs, int src_cnt, size_t len)

Again, should this then not be in ppc440spe specific files?


It seems the split / generalization is highly incomplete yet.

Best regards,

Wolfgang Denk

-- 
DENX Software Engineering GmbH,     MD: Wolfgang Denk & Detlev Zundel
HRB 165235 Munich, Office: Kirchenstr.5, D-82194 Groebenzell, Germany
Phone: (+49)-8142-66989-10 Fax: (+49)-8142-66989-80 Email: wd@denx.de
What can it profit a man to gain the whole world and to come  to  his
property with a gastric ulcer, a blown prostate, and bifocals?
                                     -- John Steinbeck, _Cannery Row_

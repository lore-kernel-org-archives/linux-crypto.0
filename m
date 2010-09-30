From: Wolfgang Denk <wd@denx.de>
Subject: Re: [PATCH] PPC4xx: ADMA separating SoC specific functions
Date: Thu, 30 Sep 2010 21:08:14 +0200
Message-ID: <20100930190814.52268D2B48C@gemini.denx.de>
References: <1285865736-32074-1-git-send-email-tmarri@apm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Cc: linuxppc-dev@lists.ozlabs.org, yur@emcraft.com,
	linux-raid@vger.kernel.org, linux-crypto@vger.kernel.org,
	dan.j.williams@intel.com
To: tmarri@apm.com
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-out.m-online.net ([212.18.0.10]:58574 "EHLO
	mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752337Ab0I3TIS (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 30 Sep 2010 15:08:18 -0400
In-reply-to: <1285865736-32074-1-git-send-email-tmarri@apm.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Dear tmarri@apm.com,

In message <1285865736-32074-1-git-send-email-tmarri@apm.com> you wrote:
> From: Tirumala Marri <tmarri@apm.com>
> 
> This patch separates the SoC specific functions and moved
> to different files.
> 
> The reason for ppc440spe-adma.h is to define in-line functions which
> are called by both adma.c and ppc440spe-adma.c . 
> 
> Where as ppc440spe-adma.c is to define functions are completely
> completely dependent on 440spe, also which are too big to define
> as in-line functions.

When reposting a patch, please always indicate that this is new
version by using something like "[PATCH v2]" in the Subject line.

> Signed-off-by: Tirumala R Marri <tmarri@apm.com>
> Acked-by: Yuri Tikhonov <yur@emcraft.com>
> CC:  Dan Williams <dan.j.williams@intel.com>
> CC:  Josh Boyer <jwboyer@linux.vnet.ibm.com>
> ---

Also, please include here (i. e. below the "---" line, i. e. in the
comments section, a description of what was changed compared to the
previous version of this patch.

As is, you enforce us to rescan the whole patch again and check
manually if you have reacted to any of the comments sent before, and
how.  As is, you make reviewing your poatches harder than necessary.


> diff --git a/drivers/dma/ppc4xx/adma.c b/drivers/dma/ppc4xx/adma.c
> index 0d58a4a..a1053cb 100644
> --- a/drivers/dma/ppc4xx/adma.c
> +++ b/drivers/dma/ppc4xx/adma.c
...
> +#include "ppc440spe-adma.h"
> +
> +struct dma_async_tx_descriptor
> +*ppc440spe_adma_prep_dma_pq(struct dma_chan *chan,
> +			       dma_addr_t * dst,
> +			       dma_addr_t * src,
> +			       unsigned int src_cnt,
> +			       const unsigned char *scf,
> +			       size_t len,
> +			       unsigned long flags);
> +struct dma_async_tx_descriptor
> +*ppc440spe_adma_prep_dma_pqzero_sum(struct dma_chan *chan,

Should such 440SPe specific code not be removed here and placed into
ppc440spe-adma.c instead?

> +#if 0
>  static void prep_dma_pq_dbg(int id, dma_addr_t *dst, dma_addr_t *src,
>  			    unsigned int src_cnt)
>  {
> @@ -213,8 +104,9 @@ static void prep_dma_pq_dbg(int id, dma_addr_t *dst, dma_addr_t *src,
>  	for (i = 0; i < 2; i++)
>  		pr_debug("\t0x%016llx ", dst[i]);
>  }
> +#endif

Please do not add dead code - remove the whole "#if 0" block.


>  /******************************************************************************
>   * ADMA channel low-level routines
>   ******************************************************************************/
>  
> -static u32
...
...
> -}
>  
>  /******************************************************************************
>   * ADMA device level
>   ******************************************************************************/

It seems youremove all code, but leave the (now empty) comment
headers? This makes little sense to me.

...
>  /**
>   * ppc440spe_adma_free_slots - flags descriptor slots for reuse
>   * @slot: Slot to free
>   * Caller must hold &ppc440spe_chan->lock while calling this function
>   */

Again, all this is pretty low-level 440SPe specific code. Why do you
keep this in the common drive rfile instead of moving it into the new
440SPe specific file?


> diff --git a/drivers/dma/ppc4xx/ppc440spe-adma.c b/drivers/dma/ppc4xx/ppc440spe-adma.c
> new file mode 100644
> index 0000000..da467b4
...
> +	/*  In the current implementation of ppc440spe ADMA driver it
> +
> +
> +
> +	 * makes sense to pick out only pq case, because it may be

Formatting problems?


> diff --git a/drivers/dma/ppc4xx/ppc440spe-adma.h b/drivers/dma/ppc4xx/ppc440spe-adma.h
> new file mode 100644
> index 0000000..81a1f46
> --- /dev/null
> +++ b/drivers/dma/ppc4xx/ppc440spe-adma.h
...
> +/*
> + * ppc440spe_get_group_entry - get group entry with index idx
> + * @tdesc: is the last allocated slot in the group.
> + */
> +static struct ppc440spe_adma_desc_slot *ppc440spe_get_group_entry(struct
> +							    ppc440spe_adma_desc_slot
> +							    *tdesc,
> +							    u32 entry_idx)
> +{
> +	struct ppc440spe_adma_desc_slot *iter = tdesc->group_head;
> +	int i = 0;
> +
> +	if (entry_idx < 0 || entry_idx >= (tdesc->src_cnt + tdesc->dst_cnt)) {
> +		printk("%s: entry_idx %d, src_cnt %d, dst_cnt %d\n",
> +		       __func__, entry_idx, tdesc->src_cnt, tdesc->dst_cnt);
> +		BUG();
> +	}
> +
> +	list_for_each_entry(iter, &tdesc->group_list, chain_node) {
> +		if (i++ == entry_idx)
> +			break;
> +	}
> +	return iter;
> +}

This is a header file, yet you add here literally thousands of lines of
code.


Note that more or less similar questions have been asked for the
previous version of this patch, but I fail to find any good
justification in your replies.


Selecting the architecture at build time is bad as it prevents using a
sinlge kernel image across a wide range of boards.  You only replied
"We select the architecture at build time." without any explanation if
there is a pressing technical reason to do it this way, or if this was
just a arbitrary decision.

The same goes for putting so much source code in a header file - I
really see no technical need for this (especially not if you build for
a single architecture only).

Also I wonder why you still keep so many 440SPe specific code in the
common file, even though you just create new 440SPe specific header
and source files.


Please elucidate.


Thanks.

Wolfgang Denk

-- 
DENX Software Engineering GmbH,     MD: Wolfgang Denk & Detlev Zundel
HRB 165235 Munich, Office: Kirchenstr.5, D-82194 Groebenzell, Germany
Phone: (+49)-8142-66989-10 Fax: (+49)-8142-66989-80 Email: wd@denx.de
"Unix is simple, but it takes a genius to understand the simplicity."
					             - Dennis Ritchie

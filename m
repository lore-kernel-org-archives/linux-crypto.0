From: Tirumala Marri <tmarri@apm.com>
Subject: RE: [PATCH] PPC4xx: ADMA separating SoC specific functions
Date: Thu, 30 Sep 2010 17:03:59 -0700
Message-ID: <b1772905c0f75c21f9265d30235d829d@mail.gmail.com>
References: <1285865736-32074-1-git-send-email-tmarri@apm.com> <20100930190814.52268D2B48C@gemini.denx.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: linuxppc-dev@lists.ozlabs.org, yur@emcraft.com,
	linux-raid@vger.kernel.org, linux-crypto@vger.kernel.org,
	dan.j.williams@intel.com
To: Wolfgang Denk <wd@denx.de>
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20100930190814.52268D2B48C@gemini.denx.de>
Sender: linux-raid-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

>
> When reposting a patch, please always indicate that this is new
> version by using something like "[PATCH v2]" in the Subject line.
[Marri] I know, but this patch is not modification of previous patch.
It is complete brand new from scratch again. In that case isn't this
 will be first version ?


> > ---
>
> Also, please include here (i. e. below the "---" line, i. e. in the
> comments section, a description of what was changed compared to the
> previous version of this patch.
>
> As is, you enforce us to rescan the whole patch again and check
> manually if you have reacted to any of the comments sent before, and
> how.  As is, you make reviewing your poatches harder than necessary.

[Marri} I will include comments in the further versions of this patch.

>
>
> > diff --git a/drivers/dma/ppc4xx/adma.c b/drivers/dma/ppc4xx/adma.c
> > index 0d58a4a..a1053cb 100644
> > --- a/drivers/dma/ppc4xx/adma.c
> > +++ b/drivers/dma/ppc4xx/adma.c
> ...
> > +#include "ppc440spe-adma.h"
> > +
> > +struct dma_async_tx_descriptor
> > +*ppc440spe_adma_prep_dma_pq(struct dma_chan *chan,
> > +			       dma_addr_t * dst,
> > +			       dma_addr_t * src,
> > +			       unsigned int src_cnt,
> > +			       const unsigned char *scf,
> > +			       size_t len,
> > +			       unsigned long flags);
> > +struct dma_async_tx_descriptor
> > +*ppc440spe_adma_prep_dma_pqzero_sum(struct dma_chan *chan,
>
> Should such 440SPe specific code not be removed here and placed into
> ppc440spe-adma.c instead?
[Marri] It is 440SPe specific. Definition is moved ppc440spe-adma.c


>
> > +#if 0
> >  static void prep_dma_pq_dbg(int id, dma_addr_t *dst, dma_addr_t
> *src,
> >  			    unsigned int src_cnt)
> >  {
> > @@ -213,8 +104,9 @@ static void prep_dma_pq_dbg(int id, dma_addr_t
> *dst, dma_addr_t *src,
> >  	for (i = 0; i < 2; i++)
> >  		pr_debug("\t0x%016llx ", dst[i]);
> >  }
> > +#endif
>
> Please do not add dead code - remove the whole "#if 0" block.
[Marri] Will remove it.


> *******/
>
> It seems youremove all code, but leave the (now empty) comment
> headers? This makes little sense to me.
>
[Marri] Will clean up in the next version.
> ...
> >  /**
> >   * ppc440spe_adma_free_slots - flags descriptor slots for reuse
> >   * @slot: Slot to free
> >   * Caller must hold &ppc440spe_chan->lock while calling this
> function
> >   */
>
> Again, all this is pretty low-level 440SPe specific code. Why do you
> keep this in the common drive rfile instead of moving it into the new
> 440SPe specific file?
[Marri]. With name change it can be used With any SoC ADMA driver.


>
>
> > diff --git a/drivers/dma/ppc4xx/ppc440spe-adma.c
> b/drivers/dma/ppc4xx/ppc440spe-adma.c
> > new file mode 100644
> > index 0000000..da467b4
> ...
> > +	/*  In the current implementation of ppc440spe ADMA driver it
> > +
> > +
> > +
> > +	 * makes sense to pick out only pq case, because it may be
>
> Formatting problems?
[Marri] Will fix in next version.

>
>
> > diff --git a/drivers/dma/ppc4xx/ppc440spe-adma.h
> b/drivers/dma/ppc4xx/ppc440spe-adma.h
> > new file mode 100644
> > index 0000000..81a1f46
> > --- /dev/null
> > +++ b/drivers/dma/ppc4xx/ppc440spe-adma.h
> ...
> > +/*
> > + * ppc440spe_get_group_entry - get group entry with index idx
> > + * @tdesc: is the last allocated slot in the group.
> > + */
> > +static struct ppc440spe_adma_desc_slot
> *ppc440spe_get_group_entry(struct
> > +
ppc440spe_adma_desc_slot
> > +							    *tdesc,
> > +							    u32 entry_idx)
> > +{
> > +	struct ppc440spe_adma_desc_slot *iter = tdesc->group_head;
> > +	int i = 0;
> > +
> > +	if (entry_idx < 0 || entry_idx >= (tdesc->src_cnt + tdesc-
> >dst_cnt)) {
> > +		printk("%s: entry_idx %d, src_cnt %d, dst_cnt %d\n",
> > +		       __func__, entry_idx, tdesc->src_cnt, tdesc-
> >dst_cnt);
> > +		BUG();
> > +	}
> > +
> > +	list_for_each_entry(iter, &tdesc->group_list, chain_node) {
> > +		if (i++ == entry_idx)
> > +			break;
> > +	}
> > +	return iter;
> > +}
>
> This is a header file, yet you add here literally thousands of lines of
> code.
>
>
> Note that more or less similar questions have been asked for the
> previous version of this patch, but I fail to find any good
> justification in your replies.
[Marri] Reason for some functions in lined is 1) They are small enough
To be in lined 2) If keep them in ppc440spe-adma.c I will have to make
them
Non static to avoid "Used but not defined warnings". With too many
functions
Non static might cause name space pollution in the kernel ?

>
>
> Selecting the architecture at build time is bad as it prevents using a
> sinlge kernel image across a wide range of boards.  You only replied
> "We select the architecture at build time." without any explanation if
> there is a pressing technical reason to do it this way, or if this was
> just a arbitrary decision.
[Marri] Build time separation is only for entirely different SoC DMA
engine.
For example 440spe and 460sx has engierely different DMA architecture.
Whereas 440spe and 460ex can be determined at run time.I am planning to do
the run time selection for similar SoCs. I discussed This with Yuri as
well.

>
> The same goes for putting so much source code in a header file - I
> really see no technical need for this (especially not if you build for
> a single architecture only).
[Marri] I explained this above.

>
> Also I wonder why you still keep so many 440SPe specific code in the
> common file, even though you just create new 440SPe specific header
> and source files.
>
>
> Please elucidate.
>
>
[Marri] With Dan's suggestion first I am working on separating SoC
specific functions
To avoid too many  changes. Next step is to re-name the functions in the
Adma.c to common name line ppc4xx_xxx().

Regards,
Marri

From: Robert Jarzmik <robert.jarzmik@free.fr>
Subject: Re: [PATCH 1/4] scatterlist: Introduce some helper functions
Date: Thu, 03 Mar 2016 20:15:42 +0100
Message-ID: <87povbpe3l.fsf@belgarion.home>
References: <cover.1456981314.git.baolin.wang@linaro.org>
	<cover.1456981314.git.baolin.wang@linaro.org>
	<3bff3e286d3ee01ebb7e26d7233075054c42a7a9.1456981314.git.baolin.wang@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain
Cc: herbert@gondor.apana.org.au, davem@davemloft.net, agk@redhat.com,
	snitzer@redhat.com, axboe@fb.com, dm-devel@redhat.com,
	akpm@linux-foundation.org, david.s.gordon@intel.com,
	thomas.lendacky@amd.com, yamada.masahiro@socionext.com,
	smueller@chronox.de, tadeusz.struk@intel.com,
	standby24x7@gmail.com, shli@kernel.org, broonie@kernel.org,
	linus.walleij@linaro.org, arnd@arndb.de,
	linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org,
	linux-raid@vger.kernel.org
To: Baolin Wang <baolin.wang@linaro.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from smtp04.smtpout.orange.fr ([80.12.242.126]:52124 "EHLO
	smtp.smtpout.orange.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754373AbcCCTPx (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 3 Mar 2016 14:15:53 -0500
In-Reply-To: <3bff3e286d3ee01ebb7e26d7233075054c42a7a9.1456981314.git.baolin.wang@linaro.org>
	(Baolin Wang's message of "Thu, 3 Mar 2016 13:19:36 +0800")
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Baolin Wang <baolin.wang@linaro.org> writes:

> @@ -212,6 +212,37 @@ static inline void sg_unmark_end(struct scatterlist *sg)
>  }
>  
>  /**
> + * sg_is_contiguous - Check if the scatterlists are contiguous
> + * @sga: SG entry
> + * @sgb: SG entry
> + *
> + * Description:
> + *   If the sga scatterlist is contiguous with the sgb scatterlist,
> + *   that means they can be merged together.
> + *
> + **/
> +static inline bool sg_is_contiguous(struct scatterlist *sga,
> +				    struct scatterlist *sgb)
> +{
> +	return ((sga->page_link & ~0x3UL) + sga->offset + sga->length ==
> +		(sgb->page_link & ~0x3UL));
> +}
I don't understand that one.
sga->page_link is a pointer to a "struct page *". How can it be added to an
offset within a page ???

> @@ -370,6 +370,65 @@ int sg_alloc_table(struct sg_table *table, unsigned int
> nents, gfp_t gfp_mask)
...
>  /**
> + * sg_add_sg_to_table - Add one scatterlist into sg table
> + * @sgt:	The sg table header to use
> + * @src:	The sg need to be added into sg table
> + *
> + * Description:
> + *   The 'nents' member indicates how many scatterlists added in the sg table.
> + *   Copy the @src@ scatterlist into sg table and increase 'nents' member.
> + *
> + **/
> +int sg_add_sg_to_table(struct sg_table *sgt, struct scatterlist *src)
> +{
> +	unsigned int i = 0, orig_nents = sgt->orig_nents;
> +	struct scatterlist *sgl = sgt->sgl;
> +	struct scatterlist *sg;
> +
> +	/* Check if there are enough space for the new sg to be added */
> +	if (sgt->nents >= sgt->orig_nents)
> +		return -EINVAL;
I must admit I don't understand that one either : how do comparing the number of
"mapped" entries against the number of "allocated" entries determines if there
is enough room ?

> +/**
> + * sg_alloc_empty_table - Allocate one empty sg table
> + * @sgt:	The sg table header to use
> + * @nents:	Number of entries in sg list
> + * @gfp_mask:	GFP allocation mask
> + *
> + *  Description:
> + *    Allocate and initialize an sg table. The 'nents' member of sg_table
> + *    indicates how many scatterlists added in the sg table. It should set
> + *    0 which means there are no scatterlists added in this sg table now.
> + *
> + **/
> +int sg_alloc_empty_table(struct sg_table *sgt, unsigned int nents,
> +			 gfp_t gfp_mask)
As for this one, there has to be a purpose for it I fail to see. From far away
it looks exactly like sg_alloc_table(), excepting it "works around" the nents >
0 protection of __sg_alloc_table().
What is exactly the need for this one, and if it's usefull why not simply
changing the __sg_alloc_table() "nents > 0" test and see what the outcome of the
review will be ?

Cheers.

-- 
Robert

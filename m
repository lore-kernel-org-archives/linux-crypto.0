From: Robert Jarzmik <robert.jarzmik@free.fr>
Subject: Re: [PATCH v2 1/4] scatterlist: Introduce some helper functions
Date: Sat, 02 Apr 2016 17:00:58 +0200
Message-ID: <87r3eoukb9.fsf@belgarion.home>
References: <cover.1458023695.git.baolin.wang@linaro.org>
	<cover.1458023695.git.baolin.wang@linaro.org>
	<9442060edaca12f520bcbb76545ad33a52346e58.1458023698.git.baolin.wang@linaro.org>
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
Received: from smtp01.smtpout.orange.fr ([80.12.242.123]:60214 "EHLO
	smtp.smtpout.orange.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751183AbcDBPBJ (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Sat, 2 Apr 2016 11:01:09 -0400
In-Reply-To: <9442060edaca12f520bcbb76545ad33a52346e58.1458023698.git.baolin.wang@linaro.org>
	(Baolin Wang's message of "Tue, 15 Mar 2016 15:47:59 +0800")
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Baolin Wang <baolin.wang@linaro.org> writes:

> +/**
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
> +	return *(unsigned long *)sg_virt(sga) + sga->length ==
> +		*(unsigned long *)sg_virt(sgb);
As I already said, I don't like casts.

But let's take some height : you're needing this function to decide to merge
scatterlists. That means that you think the probability of having 2 scatterlist
mergeable is not meaningless, ie. 50% or more.

I suppose your scatterlists are allocated through kmalloc(). I'd like to know,
through your testing, what is the success rate of sg_is_contiguous(), ie. I'd
like to know how many times sg_is_contiguous() was called, and amongst these
calls how many times it returned true.

That will tell me how "worth" is this optimization.

> + * sg_add_sg_to_table - Add one scatterlist into sg table
> + * @sgt:	The sg table header to use
> + * @src:	The sg need to be added into sg table
> + *
> + * Description:
> + *   The 'nents' member indicates how many mapped scatterlists has been added
> + *   in the dynamic sg table. The 'orig_nents' member indicates the size of the
> + *   dynamic sg table.
> + *
> + *   Copy one mapped @src@ scatterlist into the dynamic sg table and increase
> + *   'nents' member.
> + *
> + **/
Okay, I still believe this one is wrong, because we don't understand each other.
So let's take an example :
sg_table = {
         .sgl = {
		{
                	.page_link = PAGE_48,
                        .offset = 0,
                        .length = 2048,
                        .dma_address = 0x30000,
                        .dma_length = 4096,
                },
		{
                	.page_link = PAGE_48 | 0x02,
                        .offset = 2048,
                        .length = 2048,
                        .dma_address = 0,
                        .dma_length = 0,
                },
	},
         .nents = 1,
         .orig_nents = 2,
};

In this example, by sheer luck the 2 scatterlist entries were physically
contiguous, and the mapping function coallesced the 2 entries into only one
(dma_address, dma_length) entry. That could also happen with an IOMMU by the
way.  Therefore, sg_table.nents = 1.

If I understand your function correctly, it will erase sg_table.sgl[1], and that
looks incorrect to me. This is why I can't understand how your code can be
correct, and why I say you add a new "meaning" to sg_table->nents, which is not
consistent with the meaning I understand.

Cheers.

-- 
Robert

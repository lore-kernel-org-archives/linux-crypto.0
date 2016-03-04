From: Baolin Wang <baolin.wang@linaro.org>
Subject: Re: [PATCH 1/4] scatterlist: Introduce some helper functions
Date: Fri, 4 Mar 2016 14:29:25 +0800
Message-ID: <CAMz4kuKtwCkgG-3GeCtfnAX5zN8MkwyVr2XVYzaV3Z6SFFcZww@mail.gmail.com>
References: <cover.1456981314.git.baolin.wang@linaro.org>
	<3bff3e286d3ee01ebb7e26d7233075054c42a7a9.1456981314.git.baolin.wang@linaro.org>
	<87povbpe3l.fsf@belgarion.home>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
	David Miller <davem@davemloft.net>,
	Alasdair G Kergon <agk@redhat.com>,
	Mike Snitzer <snitzer@redhat.com>, axboe@fb.com,
	dm-devel@redhat.com, akpm@linux-foundation.org,
	david.s.gordon@intel.com, Tom Lendacky <thomas.lendacky@amd.com>,
	yamada.masahiro@socionext.com, smueller@chronox.de,
	tadeusz.struk@intel.com, standby24x7@gmail.com, shli@kernel.org,
	Mark Brown <broonie@kernel.org>,
	Linus Walleij <linus.walleij@linaro.org>,
	Arnd Bergmann <arnd@arndb.de>,
	LKML <linux-kernel@vger.kernel.org>,
	linux-crypto@vger.kernel.org, linux-raid@vger.kernel.org
To: Robert Jarzmik <robert.jarzmik@free.fr>
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <87povbpe3l.fsf@belgarion.home>
Sender: linux-raid-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Hi Robert,

On 4 March 2016 at 03:15, Robert Jarzmik <robert.jarzmik@free.fr> wrote:
> Baolin Wang <baolin.wang@linaro.org> writes:
>
>> @@ -212,6 +212,37 @@ static inline void sg_unmark_end(struct scatterlist *sg)
>>  }
>>
>>  /**
>> + * sg_is_contiguous - Check if the scatterlists are contiguous
>> + * @sga: SG entry
>> + * @sgb: SG entry
>> + *
>> + * Description:
>> + *   If the sga scatterlist is contiguous with the sgb scatterlist,
>> + *   that means they can be merged together.
>> + *
>> + **/
>> +static inline bool sg_is_contiguous(struct scatterlist *sga,
>> +                                 struct scatterlist *sgb)
>> +{
>> +     return ((sga->page_link & ~0x3UL) + sga->offset + sga->length ==
>> +             (sgb->page_link & ~0x3UL));
>> +}
> I don't understand that one.
> sga->page_link is a pointer to a "struct page *". How can it be added to an
> offset within a page ???


Ah, sorry that's a mistake. It should check as below:
static inline bool sg_is_contiguous(struct scatterlist *sga, struct
scatterlist *sgb)
{
    return (unsigned int)sg_virt(sga) + sga->length == (unsigned
int)sg_virt(sgb);
}

>
>> @@ -370,6 +370,65 @@ int sg_alloc_table(struct sg_table *table, unsigned int
>> nents, gfp_t gfp_mask)
> ...
>>  /**
>> + * sg_add_sg_to_table - Add one scatterlist into sg table
>> + * @sgt:     The sg table header to use
>> + * @src:     The sg need to be added into sg table
>> + *
>> + * Description:
>> + *   The 'nents' member indicates how many scatterlists added in the sg table.
>> + *   Copy the @src@ scatterlist into sg table and increase 'nents' member.
>> + *
>> + **/
>> +int sg_add_sg_to_table(struct sg_table *sgt, struct scatterlist *src)
>> +{
>> +     unsigned int i = 0, orig_nents = sgt->orig_nents;
>> +     struct scatterlist *sgl = sgt->sgl;
>> +     struct scatterlist *sg;
>> +
>> +     /* Check if there are enough space for the new sg to be added */
>> +     if (sgt->nents >= sgt->orig_nents)
>> +             return -EINVAL;
> I must admit I don't understand that one either : how do comparing the number of
> "mapped" entries against the number of "allocated" entries determines if there
> is enough room ?

That's for a dynamic sg table. If there is one sg table allocated
'orig_nents' scatterlists, and we need copy another mapped scatterlist
into the sg table if there are some requirements. So we use 'nents' to
record how many scatterlists have been copied into the sg table.

>
>> +/**
>> + * sg_alloc_empty_table - Allocate one empty sg table
>> + * @sgt:     The sg table header to use
>> + * @nents:   Number of entries in sg list
>> + * @gfp_mask:        GFP allocation mask
>> + *
>> + *  Description:
>> + *    Allocate and initialize an sg table. The 'nents' member of sg_table
>> + *    indicates how many scatterlists added in the sg table. It should set
>> + *    0 which means there are no scatterlists added in this sg table now.
>> + *
>> + **/
>> +int sg_alloc_empty_table(struct sg_table *sgt, unsigned int nents,
>> +                      gfp_t gfp_mask)
> As for this one, there has to be a purpose for it I fail to see. From far away
> it looks exactly like sg_alloc_table(), excepting it "works around" the nents >
> 0 protection of __sg_alloc_table().
> What is exactly the need for this one, and if it's usefull why not simply
> changing the __sg_alloc_table() "nents > 0" test and see what the outcome of the
> review will be ?

Like I said above. If we want to copy some mapped scatterlists into
one sg table, we should set the 'nents' to 0 to indicates how many
scatterlists coppied in the sg table.
Thanks for your comments.

>
> Cheers.
>
> --
> Robert



-- 
Baolin.wang
Best Regards

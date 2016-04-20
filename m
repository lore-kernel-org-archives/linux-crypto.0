From: Baolin Wang <baolin.wang@linaro.org>
Subject: Re: [PATCH v2 1/4] scatterlist: Introduce some helper functions
Date: Wed, 20 Apr 2016 15:34:47 +0800
Message-ID: <CAMz4kuK41221jQGtDb0d4MfOXwr=7S5_1f0ThC3c+8TKHs6VgA@mail.gmail.com>
References: <cover.1458023695.git.baolin.wang@linaro.org>
	<9442060edaca12f520bcbb76545ad33a52346e58.1458023698.git.baolin.wang@linaro.org>
	<87r3eoukb9.fsf@belgarion.home>
	<CAMz4kuKcJKHKoX8JTs5zSrre5y+cVo+hcHS6BZi1M=WOAHyu-g@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
	David Miller <davem@davemloft.net>,
	Alasdair G Kergon <agk@redhat.com>,
	Mike Snitzer <snitzer@redhat.com>, Jens Axboe <axboe@fb.com>,
	dm-devel@redhat.com, Andrew Morton <akpm@linux-foundation.org>,
	david.s.gordon@intel.com, Tom Lendacky <thomas.lendacky@amd.com>,
	Masahiro Yamada <yamada.masahiro@socionext.com>,
	smueller@chronox.de, tadeusz.struk@intel.com,
	Masanari Iida <standby24x7@gmail.com>, shli@kernel.org,
	Mark Brown <broonie@kernel.org>,
	Linus Walleij <linus.walleij@linaro.org>,
	Arnd Bergmann <arnd@arndb.de>,
	LKML <linux-kernel@vger.kernel.org>,
	linux-crypto@vger.kernel.org, linux-raid@vger.kernel.org
To: Robert Jarzmik <robert.jarzmik@free.fr>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CAMz4kuKcJKHKoX8JTs5zSrre5y+cVo+hcHS6BZi1M=WOAHyu-g@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Hi Robert,

On 5 April 2016 at 15:10, Baolin Wang <baolin.wang@linaro.org> wrote:
> Hi Robert,
>
> Sorry for the late reply.
>
> On 2 April 2016 at 23:00, Robert Jarzmik <robert.jarzmik@free.fr> wrote:
>> Baolin Wang <baolin.wang@linaro.org> writes:
>>
>>> +/**
>>> + * sg_is_contiguous - Check if the scatterlists are contiguous
>>> + * @sga: SG entry
>>> + * @sgb: SG entry
>>> + *
>>> + * Description:
>>> + *   If the sga scatterlist is contiguous with the sgb scatterlist,
>>> + *   that means they can be merged together.
>>> + *
>>> + **/
>>> +static inline bool sg_is_contiguous(struct scatterlist *sga,
>>> +                                 struct scatterlist *sgb)
>>> +{
>>> +     return *(unsigned long *)sg_virt(sga) + sga->length ==
>>> +             *(unsigned long *)sg_virt(sgb);
>> As I already said, I don't like casts.
>
> OK. Could you give me a good example. Thanks.
>
>>
>> But let's take some height : you're needing this function to decide to merge
>> scatterlists. That means that you think the probability of having 2 scatterlist
>> mergeable is not meaningless, ie. 50% or more.
>>
>> I suppose your scatterlists are allocated through kmalloc(). I'd like to know,
>> through your testing, what is the success rate of sg_is_contiguous(), ie. I'd
>> like to know how many times sg_is_contiguous() was called, and amongst these
>> calls how many times it returned true.
>>
>> That will tell me how "worth" is this optimization.
>
> I think this is just one useful API for users, If the rate is only 1%,
> we also need to check if they are contiguous to decide if they can be
> coalesced.
>
>>
>>> + * sg_add_sg_to_table - Add one scatterlist into sg table
>>> + * @sgt:     The sg table header to use
>>> + * @src:     The sg need to be added into sg table
>>> + *
>>> + * Description:
>>> + *   The 'nents' member indicates how many mapped scatterlists has been added
>>> + *   in the dynamic sg table. The 'orig_nents' member indicates the size of the
>>> + *   dynamic sg table.
>>> + *
>>> + *   Copy one mapped @src@ scatterlist into the dynamic sg table and increase
>>> + *   'nents' member.
>>> + *
>>> + **/
>> Okay, I still believe this one is wrong, because we don't understand each other.
>> So let's take an example :
>> sg_table = {
>>          .sgl = {
>>                 {
>>                         .page_link = PAGE_48,
>>                         .offset = 0,
>>                         .length = 2048,
>>                         .dma_address = 0x30000,
>>                         .dma_length = 4096,
>>                 },
>>                 {
>>                         .page_link = PAGE_48 | 0x02,
>>                         .offset = 2048,
>>                         .length = 2048,
>>                         .dma_address = 0,
>>                         .dma_length = 0,
>>                 },
>>         },
>>          .nents = 1,
>>          .orig_nents = 2,
>> };
>>
>> In this example, by sheer luck the 2 scatterlist entries were physically
>> contiguous, and the mapping function coallesced the 2 entries into only one
>> (dma_address, dma_length) entry. That could also happen with an IOMMU by the
>> way.  Therefore, sg_table.nents = 1.
>>
>> If I understand your function correctly, it will erase sg_table.sgl[1], and that
>> looks incorrect to me. This is why I can't understand how your code can be
>> correct, and why I say you add a new "meaning" to sg_table->nents, which is not
>> consistent with the meaning I understand.
>
> I think you misunderstood my point. The 'sg_add_sg_to_table()'
> function is used to add one mapped scatterlist into the dynamic sg
> table. For example:
> 1. How to add one mapped sg into dynamic sg table
> (1) If we allocate one dynamic sg table with 3 (small size can be
> showed easily) empty scatterlists.:
> sg_table = {
>           .sgl = {
>                  {
>                          .page_link = 0,
>                          .offset = 0,
>                          .length = 0,
>                  },
>                  {
>                          .page_link = 0,
>                          .offset = 0,
>                          .length = 0,
>                  },
>                  {
>                          .page_link = 0 | 0x02,
>                          .offset = 0,
>                          .length = 0,
>                  },
>          },
>           .nents = 0,
>           .orig_nents = 3,
>  };
>
> (2) If some module (like dm-crypt module) always sends one mapped
> scatterlist (size is always 512bytes) to another module (crypto
> driver) to handle the mapped scatterlist at one time. But we want to
> collect the mapped scatterlist into one dynamic sg table to manage
> them together, means we can send multiple mapped scatterlists (from
> sg_table->sgl) to the crypto driver to handle them together to improve
> its efficiency. So we add one mapped scatterlists into the dynamic sg
> table.
> mapped sg = {
>           .page_link = PAGE_20,
>           .offset = 0,
>           .length = 512,
> },
>
> Add into synamic sg table ------->
> sg_table = {
>           .sgl = {
>                  {
>                          .page_link = PAGE_20 | 0x02,
>                          .offset = 0,
>                          .length = 512,
>                  },
>                  {
>                          .page_link = 0,
>                          .offset = 0,
>                          .length = 0,
>                  },
>                  {
>                          .page_link = 0,
>                          .offset = 0,
>                          .length = 0,
>                  },
>          },
>           .nents = 1,
>           .orig_nents = 3,
>  };
>
> Another two mapped scatterlists are added into synamic sg table ------->
> sg_table = {
>           .sgl = {
>                  {
>                          .page_link = PAGE_20,
>                          .offset = 0,
>                          .length = 512,
>                  },
>                  {
>                          .page_link = PAGE_25,
>                          .offset = 0,
>                          .length = 512,
>                  },
>                  {
>                          .page_link = PAGE_28 | 0x20,
>                          .offset = 0,
>                          .length = 512,
>                  },
>          },
>           .nents = 3,
>           .orig_nents = 3,
>  };
>
> Then we can send the dynamic sg table to the crypto engine driver to
> handle them together at one time. (If the dynamic sg table size is
> 512, then the crypto engine driver can handle 512 scatterlists at one
> time, which can improve much efficiency). That's the reason why we
> want to introduce the dynamic sg table.
>
> 2. How to coalesce
> (1) If one mapped scatterlsit already has been added into dynamic sg table:
> sg_table = {
>           .sgl = {
>                  {
>                          .page_link = PAGE_20 | 0x02,
>                          .offset = 0,
>                          .length = 512,
>                  },
>                  {
>                          .page_link = 0,
>                          .offset = 0,
>                          .length = 0,
>                  },
>                  {
>                          .page_link = 0,
>                          .offset = 0,
>                          .length = 0,
>                  },
>          },
>           .nents = 1,
>           .orig_nents = 3,
>  };
>
> (2) Another mapped scatterlist comes.
> mapped sg = {
>           .page_link = PAGE_20,
>           .offset = 512,
>           .length = 512,
> },
>
> So we check the new mapped scatterlist can be coalesced into previous
> one in dynamic sg table like this:
> sg_table = {
>           .sgl = {
>                  {
>                          .page_link = PAGE_20 | 0x02,
>                          .offset = 0,
>                          .length = 1024,
>                  },
>                  {
>                          .page_link = 0,
>                          .offset = 0,
>                          .length = 0,
>                  },
>                  {
>                          .page_link = 0,
>                          .offset = 0,
>                          .length = 0,
>                  },
>          },
>           .nents = 1,
>           .orig_nents = 3,
>  };
>
> It's done. We coalesced one scatterlist into antoher one to expand the
> scatterlist's length.
> Thanks for your comments.
>

It seems there are no more comments about this patchset? We really
want to these APIs to coalesce scatterlists to improve the crypto
engine efficiency. Thanks.

-- 
Baolin.wang
Best Regards

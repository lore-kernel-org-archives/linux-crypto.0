Return-Path: <SRS0=3pbX=6O=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7D275C47247
	for <linux-crypto@archiver.kernel.org>; Thu, 30 Apr 2020 21:43:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 58AA0206D9
	for <linux-crypto@archiver.kernel.org>; Thu, 30 Apr 2020 21:43:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726736AbgD3Vnk (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 30 Apr 2020 17:43:40 -0400
Received: from mga12.intel.com ([192.55.52.136]:52611 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726447AbgD3Vnk (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 30 Apr 2020 17:43:40 -0400
IronPort-SDR: Bn+a3oMt5M+v05qrBRze0BM28XytmYcLYmsJiKur43A5bm47G3HqbqUKUe7wn0P4XwH1usCOZg
 tDq4Ucg6wgpw==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Apr 2020 14:43:39 -0700
IronPort-SDR: QUbxvfwZU6vxmq8ElmBZZv70FmF6lrpuSXPhXEZqSVKHtqJ01k53HL4+FWeXbOYNm3t886Xu3W
 FDpLiHsfbnNQ==
X-IronPort-AV: E=Sophos;i="5.73,337,1583222400"; 
   d="scan'208";a="459730130"
Received: from ahduyck-mobl1.amr.corp.intel.com (HELO [10.213.186.136]) ([10.213.186.136])
  by fmsmga005-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Apr 2020 14:43:35 -0700
Subject: Re: [PATCH 5/7] mm: move zone iterator outside of
 deferred_init_maxorder()
To:     Daniel Jordan <daniel.m.jordan@oracle.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Steffen Klassert <steffen.klassert@secunet.com>
Cc:     Alex Williamson <alex.williamson@redhat.com>,
        Dan Williams <dan.j.williams@intel.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        David Hildenbrand <david@redhat.com>,
        Jason Gunthorpe <jgg@ziepe.ca>,
        Jonathan Corbet <corbet@lwn.net>,
        Josh Triplett <josh@joshtriplett.org>,
        Kirill Tkhai <ktkhai@virtuozzo.com>,
        Michal Hocko <mhocko@kernel.org>, Pavel Machek <pavel@ucw.cz>,
        Pavel Tatashin <pasha.tatashin@soleen.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Randy Dunlap <rdunlap@infradead.org>,
        Shile Zhang <shile.zhang@linux.alibaba.com>,
        Tejun Heo <tj@kernel.org>, Zi Yan <ziy@nvidia.com>,
        linux-crypto@vger.kernel.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
References: <20200430201125.532129-1-daniel.m.jordan@oracle.com>
 <20200430201125.532129-6-daniel.m.jordan@oracle.com>
From:   Alexander Duyck <alexander.h.duyck@linux.intel.com>
Message-ID: <deadac9a-fbef-6c66-207c-83d251d2ef50@linux.intel.com>
Date:   Thu, 30 Apr 2020 14:43:28 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <20200430201125.532129-6-daniel.m.jordan@oracle.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On 4/30/2020 1:11 PM, Daniel Jordan wrote:
> padata will soon divide up pfn ranges between threads when parallelizing
> deferred init, and deferred_init_maxorder() complicates that by using an
> opaque index in addition to start and end pfns.  Move the index outside
> the function to make splitting the job easier, and simplify the code
> while at it.
> 
> deferred_init_maxorder() now always iterates within a single pfn range
> instead of potentially multiple ranges, and advances start_pfn to the
> end of that range instead of the max-order block so partial pfn ranges
> in the block aren't skipped in a later iteration.  The section alignment
> check in deferred_grow_zone() is removed as well since this alignment is
> no longer guaranteed.  It's not clear what value the alignment provided
> originally.
> 
> Signed-off-by: Daniel Jordan <daniel.m.jordan@oracle.com>

So part of the reason for splitting it up along section aligned 
boundaries was because we already had an existing functionality in 
deferred_grow_zone that was going in and pulling out a section aligned 
chunk and processing it to prepare enough memory for other threads to 
keep running. I suspect that the section alignment was done because 
normally I believe that is also the alignment for memory onlining.

With this already breaking things up over multiple threads how does this 
work with deferred_grow_zone? Which thread is it trying to allocate from 
if it needs to allocate some memory for itself?

Also what is to prevent a worker from stop deferred_grow_zone from 
bailing out in the middle of a max order page block if there is a hole 
in the middle of the block?

> ---
>   mm/page_alloc.c | 88 +++++++++++++++----------------------------------
>   1 file changed, 27 insertions(+), 61 deletions(-)
> 
> diff --git a/mm/page_alloc.c b/mm/page_alloc.c
> index 68669d3a5a665..990514d8f0d94 100644
> --- a/mm/page_alloc.c
> +++ b/mm/page_alloc.c
> @@ -1708,55 +1708,23 @@ deferred_init_mem_pfn_range_in_zone(u64 *i, struct zone *zone,
>   }
>   
>   /*
> - * Initialize and free pages. We do it in two loops: first we initialize
> - * struct page, then free to buddy allocator, because while we are
> - * freeing pages we can access pages that are ahead (computing buddy
> - * page in __free_one_page()).
> - *
> - * In order to try and keep some memory in the cache we have the loop
> - * broken along max page order boundaries. This way we will not cause
> - * any issues with the buddy page computation.
> + * Initialize the struct pages and then free them to the buddy allocator at
> + * most a max order block at a time because while we are freeing pages we can
> + * access pages that are ahead (computing buddy page in __free_one_page()).
> + * It's also cache friendly.
>    */
>   static unsigned long __init
> -deferred_init_maxorder(u64 *i, struct zone *zone, unsigned long *start_pfn,
> -		       unsigned long *end_pfn)
> +deferred_init_maxorder(struct zone *zone, unsigned long *start_pfn,
> +		       unsigned long end_pfn)
>   {
> -	unsigned long mo_pfn = ALIGN(*start_pfn + 1, MAX_ORDER_NR_PAGES);
> -	unsigned long spfn = *start_pfn, epfn = *end_pfn;
> -	unsigned long nr_pages = 0;
> -	u64 j = *i;
> -
> -	/* First we loop through and initialize the page values */
> -	for_each_free_mem_pfn_range_in_zone_from(j, zone, start_pfn, end_pfn) {
> -		unsigned long t;
> -
> -		if (mo_pfn <= *start_pfn)
> -			break;
> -
> -		t = min(mo_pfn, *end_pfn);
> -		nr_pages += deferred_init_pages(zone, *start_pfn, t);
> -
> -		if (mo_pfn < *end_pfn) {
> -			*start_pfn = mo_pfn;
> -			break;
> -		}
> -	}
> -
> -	/* Reset values and now loop through freeing pages as needed */
> -	swap(j, *i);
> -
> -	for_each_free_mem_pfn_range_in_zone_from(j, zone, &spfn, &epfn) {
> -		unsigned long t;
> -
> -		if (mo_pfn <= spfn)
> -			break;
> +	unsigned long nr_pages, pfn;
>   
> -		t = min(mo_pfn, epfn);
> -		deferred_free_pages(spfn, t);
> +	pfn = ALIGN(*start_pfn + 1, MAX_ORDER_NR_PAGES);
> +	pfn = min(pfn, end_pfn);
>   
> -		if (mo_pfn <= epfn)
> -			break;
> -	}
> +	nr_pages = deferred_init_pages(zone, *start_pfn, pfn);
> +	deferred_free_pages(*start_pfn, pfn);
> +	*start_pfn = pfn;
>   
>   	return nr_pages;
>   }
> @@ -1814,9 +1782,11 @@ static int __init deferred_init_memmap(void *data)
>   	 * that we can avoid introducing any issues with the buddy
>   	 * allocator.
>   	 */
> -	while (spfn < epfn) {
> -		nr_pages += deferred_init_maxorder(&i, zone, &spfn, &epfn);
> -		cond_resched();
> +	for_each_free_mem_pfn_range_in_zone_from(i, zone, &spfn, &epfn) {
> +		while (spfn < epfn) {
> +			nr_pages += deferred_init_maxorder(zone, &spfn, epfn);
> +			cond_resched();
> +		}
>   	}
>   zone_empty:
>   	/* Sanity check that the next zone really is unpopulated */
> @@ -1883,22 +1853,18 @@ deferred_grow_zone(struct zone *zone, unsigned int order)
>   	 * that we can avoid introducing any issues with the buddy
>   	 * allocator.
>   	 */
> -	while (spfn < epfn) {
> -		/* update our first deferred PFN for this section */
> -		first_deferred_pfn = spfn;
> -
> -		nr_pages += deferred_init_maxorder(&i, zone, &spfn, &epfn);
> -		touch_nmi_watchdog();
> -
> -		/* We should only stop along section boundaries */
> -		if ((first_deferred_pfn ^ spfn) < PAGES_PER_SECTION)
> -			continue;
> -
> -		/* If our quota has been met we can stop here */
> -		if (nr_pages >= nr_pages_needed)
> -			break;
> +	for_each_free_mem_pfn_range_in_zone_from(i, zone, &spfn, &epfn) {
> +		while (spfn < epfn) {
> +			nr_pages += deferred_init_maxorder(zone, &spfn, epfn);
> +			touch_nmi_watchdog();
> +
> +			/* If our quota has been met we can stop here */
> +			if (nr_pages >= nr_pages_needed)
> +				goto out;
> +		}
>   	}
>   
> +out:
>   	pgdat->first_deferred_pfn = spfn;
>   	pgdat_resize_unlock(pgdat, &flags);
>   
> 

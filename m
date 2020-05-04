Return-Path: <SRS0=Dybx=6S=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DCD5AC3A5A9
	for <linux-crypto@archiver.kernel.org>; Mon,  4 May 2020 22:34:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9F0E220663
	for <linux-crypto@archiver.kernel.org>; Mon,  4 May 2020 22:34:12 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="aNZI+kPW"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726338AbgEDWeM (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 4 May 2020 18:34:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43360 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726291AbgEDWeL (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 4 May 2020 18:34:11 -0400
Received: from mail-io1-xd44.google.com (mail-io1-xd44.google.com [IPv6:2607:f8b0:4864:20::d44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 66BE1C061A0E;
        Mon,  4 May 2020 15:34:11 -0700 (PDT)
Received: by mail-io1-xd44.google.com with SMTP id k18so357935ion.0;
        Mon, 04 May 2020 15:34:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=d5BZN4gsRt4QI1pKOn4DXdZ5N35QDy+YQ/6Med+JJqo=;
        b=aNZI+kPW6aiwnJ0UeRhhTDJQToI93EqNL50BqlQcPjF83OqKmIh5bO3fMgCDh7NOCN
         WX6ZjN0g4O10LdBXmSI2hJJPGZ7610+W6q4W7+s+KBBZMl8CLKNwrWBt6JMmJTj7BwmX
         FbC+xNQe9Zs6JgmsN7nTXgcmeRmD4aXCnjiSmnJ3Ja1xE7ENso/IvZ8k9P4xAWT8HNm7
         d3zsFhCIbDPwK5htXeXX+WrlTuQrDYkwvkVkA83sZgFkam5MoDy8Jh251yzCREwLTb++
         HdyhPflpXGNZI1TmC5NSlM5rXbE0UNhEJ0XNOmg+0i3rBetDKAjiOCRna1ogmpr2DdZd
         r8ow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=d5BZN4gsRt4QI1pKOn4DXdZ5N35QDy+YQ/6Med+JJqo=;
        b=RicOQiFHewOPMLw3UqSLAppZwnC/TnXiZ3jHJ89xZWjWmNGztNapoW/KOkLK2RUCJi
         PBvCA5W8Ywj+2FXtHFhl5zeMmuWJgrINu1qrcUVQs09YHg4QwnHRSS2FmFlvLvEcrsGK
         /95bm0xBkEHRVwsF6hI81Rzcc8xxxzqB599IHoIRgzjSdX6wapV7updLQT3/gycnblD/
         3A8Q+LxwupiX4MRfS1fpfT8PkurlYsjAViMUt4NTi5UpuZ4oY62QSFpLonuHKllTfW3e
         qfuOq4wMhgUICkzx9nWax3gpvwADKjDDoqD4mjt/JzqwdU2t63rEeqhnrVC4Cba/0dak
         z+XA==
X-Gm-Message-State: AGi0PuaczyCtNwRA2qVVBN4sB/GIqNYB4NmUekzSxBIq80EoRCibqahG
        41E8IRxRiLIk/LEmZSI/sIjLOA3alN2itQsMJoA=
X-Google-Smtp-Source: APiQypJiYgHpmI5TrWtz0Qsju8xCdriCXD4TvQ+UhwsHMQqxat3fthuMCzQYU/3d41qVCRKsS+nI8tAtBsbehpRomWo=
X-Received: by 2002:a6b:d90f:: with SMTP id r15mr552040ioc.5.1588631649053;
 Mon, 04 May 2020 15:34:09 -0700 (PDT)
MIME-Version: 1.0
References: <20200430201125.532129-1-daniel.m.jordan@oracle.com> <20200430201125.532129-7-daniel.m.jordan@oracle.com>
In-Reply-To: <20200430201125.532129-7-daniel.m.jordan@oracle.com>
From:   Alexander Duyck <alexander.duyck@gmail.com>
Date:   Mon, 4 May 2020 15:33:58 -0700
Message-ID: <CAKgT0Uf7e5514SOi8dmkB5oXUK9bwqD_z-5KJ_F3MUn3CAQyPQ@mail.gmail.com>
Subject: Re: [PATCH 6/7] mm: parallelize deferred_init_memmap()
To:     Daniel Jordan <daniel.m.jordan@oracle.com>
Cc:     Andrew Morton <akpm@linux-foundation.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Alexander Duyck <alexander.h.duyck@linux.intel.com>,
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
        linux-crypto@vger.kernel.org, linux-mm <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Thu, Apr 30, 2020 at 1:12 PM Daniel Jordan
<daniel.m.jordan@oracle.com> wrote:
>
> Deferred struct page init uses one thread per node, which is a
> significant bottleneck at boot for big machines--often the largest.
> Parallelize to reduce system downtime.
>
> The maximum number of threads is capped at the number of CPUs on the
> node because speedups always improve with additional threads on every
> system tested, and at this phase of boot, the system is otherwise idle
> and waiting on page init to finish.
>
> Helper threads operate on MAX_ORDER_NR_PAGES-aligned ranges to avoid
> accessing uninitialized buddy pages, so set the job's alignment
> accordingly.
>
> The minimum chunk size is also MAX_ORDER_NR_PAGES because there was
> benefit to using multiple threads even on relatively small memory (1G)
> systems.
>
>     Intel(R) Xeon(R) Platinum 8167M CPU @ 2.00GHz (Skylake, bare metal)
>       2 nodes * 26 cores * 2 threads = 104 CPUs
>       384G/node = 768G memory
>
>                    kernel boot                 deferred init
>                    ------------------------    ------------------------
>                    speedup  time_ms (stdev)    speedup  time_ms (stdev)
>          base           --   4056.7 (  5.5)         --   1763.3 (  4.2)
>          test        39.9%   2436.7 (  2.1)      91.8%    144.3 (  5.9)
>
>     Intel(R) Xeon(R) CPU E5-2699C v4 @ 2.20GHz (Broadwell, bare metal)
>       1 node * 16 cores * 2 threads = 32 CPUs
>       192G/node = 192G memory
>
>                    kernel boot                 deferred init
>                    ------------------------    ------------------------
>                    speedup  time_ms (stdev)    speedup  time_ms (stdev)
>          base           --   1957.3 ( 14.0)         --   1093.7 ( 12.9)
>          test        49.1%    996.0 (  7.2)      88.4%    127.3 (  5.1)
>
>     Intel(R) Xeon(R) CPU E5-2699 v3 @ 2.30GHz (Haswell, bare metal)
>       2 nodes * 18 cores * 2 threads = 72 CPUs
>       128G/node = 256G memory
>
>                    kernel boot                 deferred init
>                    ------------------------    ------------------------
>                    speedup  time_ms (stdev)    speedup  time_ms (stdev)
>          base           --   1666.0 (  3.5)         --    618.0 (  3.5)
>          test        31.3%   1145.3 (  1.5)      85.6%     89.0 (  1.7)
>
>     AMD EPYC 7551 32-Core Processor (Zen, kvm guest)
>       1 node * 8 cores * 2 threads = 16 CPUs
>       64G/node = 64G memory
>
>                    kernel boot                 deferred init
>                    ------------------------    ------------------------
>                    speedup  time_ms (stdev)    speedup  time_ms (stdev)
>          base           --   1029.7 ( 42.3)         --    253.7 (  3.1)
>          test        23.3%    789.3 ( 15.0)      76.3%     60.0 (  5.6)
>
> Server-oriented distros that enable deferred page init sometimes run in
> small VMs, and they still benefit even though the fraction of boot time
> saved is smaller:
>
>     AMD EPYC 7551 32-Core Processor (Zen, kvm guest)
>       1 node * 2 cores * 2 threads = 4 CPUs
>       16G/node = 16G memory
>
>                    kernel boot                 deferred init
>                    ------------------------    ------------------------
>                    speedup  time_ms (stdev)    speedup  time_ms (stdev)
>          base           --    757.7 ( 17.1)         --     57.0 (  0.0)
>          test         6.2%    710.3 ( 15.0)      63.2%     21.0 (  0.0)
>
>     Intel(R) Xeon(R) CPU E5-2699 v3 @ 2.30GHz (Haswell, kvm guest)
>       1 node * 2 cores * 2 threads = 4 CPUs
>       14G/node = 14G memory
>
>                    kernel boot                 deferred init
>                    ------------------------    ------------------------
>                    speedup  time_ms (stdev)    speedup  time_ms (stdev)
>          base           --    656.3 (  7.1)         --     57.3 (  1.5)
>          test         8.6%    599.7 (  5.9)      62.8%     21.3 (  1.2)
>
> Signed-off-by: Daniel Jordan <daniel.m.jordan@oracle.com>
> ---
>  mm/Kconfig      |  6 +++---
>  mm/page_alloc.c | 46 ++++++++++++++++++++++++++++++++++++++--------
>  2 files changed, 41 insertions(+), 11 deletions(-)
>
> diff --git a/mm/Kconfig b/mm/Kconfig
> index ab80933be65ff..e5007206c7601 100644
> --- a/mm/Kconfig
> +++ b/mm/Kconfig
> @@ -622,13 +622,13 @@ config DEFERRED_STRUCT_PAGE_INIT
>         depends on SPARSEMEM
>         depends on !NEED_PER_CPU_KM
>         depends on 64BIT
> +       select PADATA
>         help
>           Ordinarily all struct pages are initialised during early boot in a
>           single thread. On very large machines this can take a considerable
>           amount of time. If this option is set, large machines will bring up
> -         a subset of memmap at boot and then initialise the rest in parallel
> -         by starting one-off "pgdatinitX" kernel thread for each node X. This
> -         has a potential performance impact on processes running early in the
> +         a subset of memmap at boot and then initialise the rest in parallel.
> +         This has a potential performance impact on tasks running early in the
>           lifetime of the system until these kthreads finish the
>           initialisation.
>
> diff --git a/mm/page_alloc.c b/mm/page_alloc.c
> index 990514d8f0d94..96d6d0d920c27 100644
> --- a/mm/page_alloc.c
> +++ b/mm/page_alloc.c
> @@ -68,6 +68,7 @@
>  #include <linux/lockdep.h>
>  #include <linux/nmi.h>
>  #include <linux/psi.h>
> +#include <linux/padata.h>
>
>  #include <asm/sections.h>
>  #include <asm/tlbflush.h>
> @@ -1729,6 +1730,25 @@ deferred_init_maxorder(struct zone *zone, unsigned long *start_pfn,
>         return nr_pages;
>  }
>
> +struct def_init_args {
> +       struct zone *zone;
> +       atomic_long_t nr_pages;
> +};
> +
> +static void __init deferred_init_memmap_chunk(unsigned long spfn,
> +                                             unsigned long epfn, void *arg)
> +{
> +       struct def_init_args *args = arg;
> +       unsigned long nr_pages = 0;
> +
> +       while (spfn < epfn) {
> +               nr_pages += deferred_init_maxorder(args->zone, &spfn, epfn);
> +               cond_resched();
> +       }
> +
> +       atomic_long_add(nr_pages, &args->nr_pages);
> +}
> +
>  /* Initialise remaining memory on a node */
>  static int __init deferred_init_memmap(void *data)
>  {
> @@ -1738,7 +1758,7 @@ static int __init deferred_init_memmap(void *data)
>         unsigned long first_init_pfn, flags;
>         unsigned long start = jiffies;
>         struct zone *zone;
> -       int zid;
> +       int zid, max_threads;
>         u64 i;
>
>         /* Bind memory initialisation thread to a local node if possible */
> @@ -1778,15 +1798,25 @@ static int __init deferred_init_memmap(void *data)
>                 goto zone_empty;
>
>         /*
> -        * Initialize and free pages in MAX_ORDER sized increments so
> -        * that we can avoid introducing any issues with the buddy
> -        * allocator.
> +        * More CPUs always led to greater speedups on tested systems, up to
> +        * all the nodes' CPUs.  Use all since the system is otherwise idle now.
>          */

I would be curious about your data. That isn't what I have seen in the
past. Typically only up to about 8 or 10 CPUs gives you any benefit,
beyond that I was usually cache/memory bandwidth bound.

> +       max_threads = max(cpumask_weight(cpumask), 1u);
> +

We will need to gather data on if having a ton of threads works for
all architectures. For x86 I think we are freeing back pages in
pageblock_order sized chunks so we only have to touch them once in
initialize and then free the two pageblock_order chunks into the buddy
allocator.

>         for_each_free_mem_pfn_range_in_zone_from(i, zone, &spfn, &epfn) {
> -               while (spfn < epfn) {
> -                       nr_pages += deferred_init_maxorder(zone, &spfn, epfn);
> -                       cond_resched();
> -               }
> +               struct def_init_args args = { zone, ATOMIC_LONG_INIT(0) };
> +               struct padata_mt_job job = {
> +                       .thread_fn   = deferred_init_memmap_chunk,
> +                       .fn_arg      = &args,
> +                       .start       = spfn,
> +                       .size        = epfn - spfn,
> +                       .align       = MAX_ORDER_NR_PAGES,
> +                       .min_chunk   = MAX_ORDER_NR_PAGES,
> +                       .max_threads = max_threads,
> +               };
> +
> +               padata_do_multithreaded(&job);
> +               nr_pages += atomic_long_read(&args.nr_pages);
>         }
>  zone_empty:
>         /* Sanity check that the next zone really is unpopulated */

Okay so looking at this I can see why you wanted to structure the
other patch the way you did. However I am not sure that is the best
way to go about doing it. It might make more sense to go through and
accumulate sections. If you hit the end of a range and the start of
the next range is in another section, then you split it as a new job,
otherwise I would just accumulate it into the current job. You then
could section align the work and be more or less guaranteed that each
worker thread should be generating finished work products, and not
incomplete max order pages.

That solution would work with the existing code as well since you
could basically just compare the start pfn coming out of the
deferred_init_maxorder versus the end of the chunk to determine if you
should exit or not.

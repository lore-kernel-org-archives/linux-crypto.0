Return-Path: <SRS0=cmAM=7D=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9AB51C433DF
	for <linux-crypto@archiver.kernel.org>; Thu, 21 May 2020 15:00:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5E9A6207F7
	for <linux-crypto@archiver.kernel.org>; Thu, 21 May 2020 15:00:45 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="fj3q6ObM"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729564AbgEUPAo (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 21 May 2020 11:00:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59822 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728162AbgEUPAo (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 21 May 2020 11:00:44 -0400
Received: from mail-io1-xd42.google.com (mail-io1-xd42.google.com [IPv6:2607:f8b0:4864:20::d42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2C617C061A0E;
        Thu, 21 May 2020 08:00:43 -0700 (PDT)
Received: by mail-io1-xd42.google.com with SMTP id o5so7732444iow.8;
        Thu, 21 May 2020 08:00:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=QS1YxMoEkgBsQ8Af6QHOEFoOjnt+sCaKgVNloYmG/yo=;
        b=fj3q6ObMZmufoW3U1++BExEe7sUbo/YrLUizJJff8sWmmlnHSs9hWXIhFwIKXjR1We
         AADSwdZ2W68EaFjTuWpWzuiPHXnHYFAvc+wJmmwW+13KVtHLppEZ31hVfsj8/DET6/87
         MRfnIzGLLm+oJEt4ab9AI8L0iuxq7uCTWfQBwEGNSyePzcdBIhvISVO8b7o1iqQdkifm
         XNEoVRQekfOt/X9PCqD+BeUy1b8kuqcL2ReaGbjwZXFJqwHs5M8G+mFEZpdXOKxBD/04
         4M5KkEid1vf2QfdtWvlZFyGwxh2vQCzfJ6CLlE0xeGZTNWCn7gc5SGM9G9FgViwD8+QW
         N5tQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=QS1YxMoEkgBsQ8Af6QHOEFoOjnt+sCaKgVNloYmG/yo=;
        b=Z5AqbejrAVM92dx04x5o3YkZqJgIkB1rDync0lgUqcYcqxbM3NI5tKoWJaWerk+Dux
         BIo+EYV7zTzMKY1e9wbUPixyApF6N3Y0MsJC+qAU+aASXQVjSlBuggy5u9X8E09p5BNs
         qZo8OOg0G7hBrbE6jzVGFHOijG10wnE7js3PWwGCBsJHtNEcwm/QCKYcjnDynqEZG1ho
         FIjuzmBn3nyxOkq9t5JZ0cenARJzM7Q/OpCS1bg+krJiMC074+XA/lGao8lH+gTjGCNU
         lZQzUWSSQfNlsDNE4ZItfuhGV3ebfideQ/NMY1Mdzi2Xf+z4PKO7N46xSlwojo+l9rap
         PEeg==
X-Gm-Message-State: AOAM530H+MI4HspGGN7UoRN/Wz2xRaYqEgo6BVBkZfBIMIA493sRuDCL
        ffhFeo2JLW8FVQUTh5g7Vzc4YzuBFa7ub6sJ5Du/8aSp2aw=
X-Google-Smtp-Source: ABdhPJyLEXKOdx+mvjgbfJorWquyXcOFC49jUtW1H1q5vXnlWrpzdATMECuLwHU3TZAcoSuKpfzNdCBA/nXPeNbWH2E=
X-Received: by 2002:a02:90cd:: with SMTP id c13mr4062198jag.83.1590073242153;
 Thu, 21 May 2020 08:00:42 -0700 (PDT)
MIME-Version: 1.0
References: <20200520182645.1658949-1-daniel.m.jordan@oracle.com>
 <20200520182645.1658949-6-daniel.m.jordan@oracle.com> <CAKgT0UfWOe-_rA+o5Uh-mTKSodsv9pFvApun=oYeAsOpMpP83Q@mail.gmail.com>
In-Reply-To: <CAKgT0UfWOe-_rA+o5Uh-mTKSodsv9pFvApun=oYeAsOpMpP83Q@mail.gmail.com>
From:   Alexander Duyck <alexander.duyck@gmail.com>
Date:   Thu, 21 May 2020 08:00:31 -0700
Message-ID: <CAKgT0UdRectcwcpMaHkot0Na7JZj8sAzr45Qh5pnR+joAQpKEg@mail.gmail.com>
Subject: Re: [PATCH v2 5/7] mm: parallelize deferred_init_memmap()
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
        Robert Elliott <elliott@hpe.com>,
        Shile Zhang <shile.zhang@linux.alibaba.com>,
        Steven Sistare <steven.sistare@oracle.com>,
        Tejun Heo <tj@kernel.org>, Zi Yan <ziy@nvidia.com>,
        linux-crypto@vger.kernel.org, linux-mm <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>, linux-s390@vger.kernel.org,
        "open list:LINUX FOR POWERPC (32-BIT AND 64-BIT)" 
        <linuxppc-dev@lists.ozlabs.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Wed, May 20, 2020 at 6:29 PM Alexander Duyck
<alexander.duyck@gmail.com> wrote:
>
> On Wed, May 20, 2020 at 11:27 AM Daniel Jordan
> <daniel.m.jordan@oracle.com> wrote:
> >
> > Deferred struct page init is a significant bottleneck in kernel boot.
> > Optimizing it maximizes availability for large-memory systems and allows
> > spinning up short-lived VMs as needed without having to leave them
> > running.  It also benefits bare metal machines hosting VMs that are
> > sensitive to downtime.  In projects such as VMM Fast Restart[1], where
> > guest state is preserved across kexec reboot, it helps prevent
> > application and network timeouts in the guests.
> >
> > Multithread to take full advantage of system memory bandwidth.
> >
> > The maximum number of threads is capped at the number of CPUs on the
> > node because speedups always improve with additional threads on every
> > system tested, and at this phase of boot, the system is otherwise idle
> > and waiting on page init to finish.
> >
> > Helper threads operate on section-aligned ranges to both avoid false
> > sharing when setting the pageblock's migrate type and to avoid accessing
> > uninitialized buddy pages, though max order alignment is enough for the
> > latter.
> >
> > The minimum chunk size is also a section.  There was benefit to using
> > multiple threads even on relatively small memory (1G) systems, and this
> > is the smallest size that the alignment allows.
> >
> > The time (milliseconds) is the slowest node to initialize since boot
> > blocks until all nodes finish.  intel_pstate is loaded in active mode
> > without hwp and with turbo enabled, and intel_idle is active as well.
> >
> >     Intel(R) Xeon(R) Platinum 8167M CPU @ 2.00GHz (Skylake, bare metal)
> >       2 nodes * 26 cores * 2 threads = 104 CPUs
> >       384G/node = 768G memory
> >
> >                    kernel boot                 deferred init
> >                    ------------------------    ------------------------
> >     node% (thr)    speedup  time_ms (stdev)    speedup  time_ms (stdev)
> >           (  0)         --   4078.0 (  9.0)         --   1779.0 (  8.7)
> >        2% (  1)       1.4%   4021.3 (  2.9)       3.4%   1717.7 (  7.8)
> >       12% (  6)      35.1%   2644.7 ( 35.3)      80.8%    341.0 ( 35.5)
> >       25% ( 13)      38.7%   2498.0 ( 34.2)      89.1%    193.3 ( 32.3)
> >       37% ( 19)      39.1%   2482.0 ( 25.2)      90.1%    175.3 ( 31.7)
> >       50% ( 26)      38.8%   2495.0 (  8.7)      89.1%    193.7 (  3.5)
> >       75% ( 39)      39.2%   2478.0 ( 21.0)      90.3%    172.7 ( 26.7)
> >      100% ( 52)      40.0%   2448.0 (  2.0)      91.9%    143.3 (  1.5)
> >
> >     Intel(R) Xeon(R) CPU E5-2699C v4 @ 2.20GHz (Broadwell, bare metal)
> >       1 node * 16 cores * 2 threads = 32 CPUs
> >       192G/node = 192G memory
> >
> >                    kernel boot                 deferred init
> >                    ------------------------    ------------------------
> >     node% (thr)    speedup  time_ms (stdev)    speedup  time_ms (stdev)
> >           (  0)         --   1996.0 ( 18.0)         --   1104.3 (  6.7)
> >        3% (  1)       1.4%   1968.0 (  3.0)       2.7%   1074.7 (  9.0)
> >       12% (  4)      40.1%   1196.0 ( 22.7)      72.4%    305.3 ( 16.8)
> >       25% (  8)      47.4%   1049.3 ( 17.2)      84.2%    174.0 ( 10.6)
> >       37% ( 12)      48.3%   1032.0 ( 14.9)      86.8%    145.3 (  2.5)
> >       50% ( 16)      48.9%   1020.3 (  2.5)      88.0%    133.0 (  1.7)
> >       75% ( 24)      49.1%   1016.3 (  8.1)      88.4%    128.0 (  1.7)
> >      100% ( 32)      49.4%   1009.0 (  8.5)      88.6%    126.3 (  0.6)
> >
> >     Intel(R) Xeon(R) CPU E5-2699 v3 @ 2.30GHz (Haswell, bare metal)
> >       2 nodes * 18 cores * 2 threads = 72 CPUs
> >       128G/node = 256G memory
> >
> >                    kernel boot                 deferred init
> >                    ------------------------    ------------------------
> >     node% (thr)    speedup  time_ms (stdev)    speedup  time_ms (stdev)
> >           (  0)         --   1682.7 (  6.7)         --    630.0 (  4.6)
> >        3% (  1)       0.4%   1676.0 (  2.0)       0.7%    625.3 (  3.2)
> >       12% (  4)      25.8%   1249.0 (  1.0)      68.2%    200.3 (  1.2)
> >       25% (  9)      30.0%   1178.0 (  5.2)      79.7%    128.0 (  3.5)
> >       37% ( 13)      30.6%   1167.7 (  3.1)      81.3%    117.7 (  1.2)
> >       50% ( 18)      30.6%   1167.3 (  2.3)      81.4%    117.0 (  1.0)
> >       75% ( 27)      31.0%   1161.3 (  4.6)      82.5%    110.0 (  6.9)
> >      100% ( 36)      32.1%   1142.0 (  3.6)      85.7%     90.0 (  1.0)
> >
> >     AMD EPYC 7551 32-Core Processor (Zen, kvm guest)
> >       1 node * 8 cores * 2 threads = 16 CPUs
> >       64G/node = 64G memory
> >
> >                    kernel boot                 deferred init
> >                    ------------------------    ------------------------
> >     node% (thr)    speedup  time_ms (stdev)    speedup  time_ms (stdev)
> >           (  0)         --   1003.7 ( 16.6)         --    243.3 (  8.1)
> >        6% (  1)       1.4%    990.0 (  4.6)       1.2%    240.3 (  1.5)
> >       12% (  2)      11.4%    889.3 ( 16.7)      44.5%    135.0 (  3.0)
> >       25% (  4)      16.8%    835.3 (  9.0)      65.8%     83.3 (  2.5)
> >       37% (  6)      18.6%    816.7 ( 17.6)      70.4%     72.0 (  1.0)
> >       50% (  8)      18.2%    821.0 (  5.0)      70.7%     71.3 (  1.2)
> >       75% ( 12)      19.0%    813.3 (  5.0)      71.8%     68.7 (  2.1)
> >      100% ( 16)      19.8%    805.3 ( 10.8)      76.4%     57.3 ( 15.9)
> >
> > Server-oriented distros that enable deferred page init sometimes run in
> > small VMs, and they still benefit even though the fraction of boot time
> > saved is smaller:
> >
> >     AMD EPYC 7551 32-Core Processor (Zen, kvm guest)
> >       1 node * 2 cores * 2 threads = 4 CPUs
> >       16G/node = 16G memory
> >
> >                    kernel boot                 deferred init
> >                    ------------------------    ------------------------
> >     node% (thr)    speedup  time_ms (stdev)    speedup  time_ms (stdev)
> >           (  0)         --    722.3 (  9.5)         --     50.7 (  0.6)
> >       25% (  1)      -3.3%    746.3 (  4.7)      -2.0%     51.7 (  1.2)
> >       50% (  2)       0.2%    721.0 ( 11.3)      29.6%     35.7 (  4.9)
> >       75% (  3)      -0.3%    724.3 ( 11.2)      48.7%     26.0 (  0.0)
> >      100% (  4)       3.0%    700.3 ( 13.6)      55.9%     22.3 (  0.6)
> >
> >     Intel(R) Xeon(R) CPU E5-2699 v3 @ 2.30GHz (Haswell, kvm guest)
> >       1 node * 2 cores * 2 threads = 4 CPUs
> >       14G/node = 14G memory
> >
> >                    kernel boot                 deferred init
> >                    ------------------------    ------------------------
> >     node% (thr)    speedup  time_ms (stdev)    speedup  time_ms (stdev)
> >           (  0)         --    673.0 (  6.9)         --     57.0 (  1.0)
> >       25% (  1)      -0.6%    677.3 ( 19.8)       1.8%     56.0 (  1.0)
> >       50% (  2)       3.4%    650.0 (  3.6)      36.8%     36.0 (  5.2)
> >       75% (  3)       4.2%    644.7 (  7.6)      56.1%     25.0 (  1.0)
> >      100% (  4)       5.3%    637.0 (  5.6)      63.2%     21.0 (  0.0)
> >
> > On Josh's 96-CPU and 192G memory system:
> >
> >     Without this patch series:
> >     [    0.487132] node 0 initialised, 23398907 pages in 292ms
> >     [    0.499132] node 1 initialised, 24189223 pages in 304ms
> >     ...
> >     [    0.629376] Run /sbin/init as init process
> >
> >     With this patch series:
> >     [    0.227868] node 0 initialised, 23398907 pages in 28ms
> >     [    0.230019] node 1 initialised, 24189223 pages in 28ms
> >     ...
> >     [    0.361069] Run /sbin/init as init process
> >
> > [1] https://static.sched.com/hosted_files/kvmforum2019/66/VMM-fast-restart_kvmforum2019.pdf
> >
> > Signed-off-by: Daniel Jordan <daniel.m.jordan@oracle.com>
> > ---
> >  mm/Kconfig      |  6 ++---
> >  mm/page_alloc.c | 60 ++++++++++++++++++++++++++++++++++++++++++++-----
> >  2 files changed, 58 insertions(+), 8 deletions(-)
> >
> > diff --git a/mm/Kconfig b/mm/Kconfig
> > index c1acc34c1c358..04c1da3f9f44c 100644
> > --- a/mm/Kconfig
> > +++ b/mm/Kconfig
> > @@ -750,13 +750,13 @@ config DEFERRED_STRUCT_PAGE_INIT
> >         depends on SPARSEMEM
> >         depends on !NEED_PER_CPU_KM
> >         depends on 64BIT
> > +       select PADATA
> >         help
> >           Ordinarily all struct pages are initialised during early boot in a
> >           single thread. On very large machines this can take a considerable
> >           amount of time. If this option is set, large machines will bring up
> > -         a subset of memmap at boot and then initialise the rest in parallel
> > -         by starting one-off "pgdatinitX" kernel thread for each node X. This
> > -         has a potential performance impact on processes running early in the
> > +         a subset of memmap at boot and then initialise the rest in parallel.
> > +         This has a potential performance impact on tasks running early in the
> >           lifetime of the system until these kthreads finish the
> >           initialisation.
> >
> > diff --git a/mm/page_alloc.c b/mm/page_alloc.c
> > index d0c0d9364aa6d..9cb780e8dec78 100644
> > --- a/mm/page_alloc.c
> > +++ b/mm/page_alloc.c
> > @@ -68,6 +68,7 @@
> >  #include <linux/lockdep.h>
> >  #include <linux/nmi.h>
> >  #include <linux/psi.h>
> > +#include <linux/padata.h>
> >
> >  #include <asm/sections.h>
> >  #include <asm/tlbflush.h>
> > @@ -1814,16 +1815,44 @@ deferred_init_maxorder(u64 *i, struct zone *zone, unsigned long *start_pfn,
> >         return nr_pages;
> >  }
> >
> > +struct definit_args {
> > +       struct zone *zone;
> > +       atomic_long_t nr_pages;
> > +};
> > +
> > +static void __init
> > +deferred_init_memmap_chunk(unsigned long start_pfn, unsigned long end_pfn,
> > +                          void *arg)
> > +{
> > +       unsigned long spfn, epfn, nr_pages = 0;
> > +       struct definit_args *args = arg;
> > +       struct zone *zone = args->zone;
> > +       u64 i;
> > +
> > +       deferred_init_mem_pfn_range_in_zone(&i, zone, &spfn, &epfn, start_pfn);
> > +
> > +       /*
> > +        * Initialize and free pages in MAX_ORDER sized increments so that we
> > +        * can avoid introducing any issues with the buddy allocator.
> > +        */
> > +       while (spfn < end_pfn) {
> > +               nr_pages += deferred_init_maxorder(&i, zone, &spfn, &epfn);
> > +               cond_resched();
> > +       }
> > +
> > +       atomic_long_add(nr_pages, &args->nr_pages);
> > +}
> > +
>
> Personally I would get rid of nr_pages entirely. It isn't worth the
> cache thrash to have this atomic variable bouncing around. You could
> probably just have this function return void since all nr_pages is
> used for is a pr_info  statement at the end of the initialization
> which will be completely useless now anyway since we really have the
> threads running in parallel anyway.
>
> We only really need the nr_pages logic in deferred_grow_zone in order
> to track if we have freed enough pages to allow us to go back to what
> we were doing.
>
> >  /* Initialise remaining memory on a node */
> >  static int __init deferred_init_memmap(void *data)
> >  {
> >         pg_data_t *pgdat = data;
> >         const struct cpumask *cpumask = cpumask_of_node(pgdat->node_id);
> >         unsigned long spfn = 0, epfn = 0, nr_pages = 0;
> > -       unsigned long first_init_pfn, flags;
> > +       unsigned long first_init_pfn, flags, epfn_align;
> >         unsigned long start = jiffies;
> >         struct zone *zone;
> > -       int zid;
> > +       int zid, max_threads;
> >         u64 i;
> >
> >         /* Bind memory initialisation thread to a local node if possible */
> > @@ -1863,11 +1892,32 @@ static int __init deferred_init_memmap(void *data)
> >                 goto zone_empty;
> >
> >         /*
> > -        * Initialize and free pages in MAX_ORDER sized increments so
> > -        * that we can avoid introducing any issues with the buddy
> > -        * allocator.
> > +        * More CPUs always led to greater speedups on tested systems, up to
> > +        * all the nodes' CPUs.  Use all since the system is otherwise idle now.
> >          */
> > +       max_threads = max(cpumask_weight(cpumask), 1u);
> > +
> >         while (spfn < epfn) {
> > +               epfn_align = ALIGN_DOWN(epfn, PAGES_PER_SECTION);
> > +
> > +               if (IS_ALIGNED(spfn, PAGES_PER_SECTION) &&
> > +                   epfn_align - spfn >= PAGES_PER_SECTION) {
> > +                       struct definit_args arg = { zone, ATOMIC_LONG_INIT(0) };
> > +                       struct padata_mt_job job = {
> > +                               .thread_fn   = deferred_init_memmap_chunk,
> > +                               .fn_arg      = &arg,
> > +                               .start       = spfn,
> > +                               .size        = epfn_align - spfn,
> > +                               .align       = PAGES_PER_SECTION,
> > +                               .min_chunk   = PAGES_PER_SECTION,
> > +                               .max_threads = max_threads,
> > +                       };
> > +
> > +                       padata_do_multithreaded(&job);
> > +                       nr_pages += atomic_long_read(&arg.nr_pages);
> > +                       spfn = epfn_align;
> > +               }
> > +
> >                 nr_pages += deferred_init_maxorder(&i, zone, &spfn, &epfn);
> >                 cond_resched();
> >         }
>
> This doesn't look right. You are basically adding threads in addition
> to calls to deferred_init_maxorder. In addition you are spawning one
> job per section instead of per range. Really you should be going for
> something more along the lines of:
>
>         while (spfn < epfn) {
>                 unsigned long epfn_align = ALIGN(epfn,
> PAGE_PER_SECTION);
>                 struct definit_args arg = { zone, ATOMIC_LONG_INIT(0)
> };
>                 struct padata_mt_job job = {
>                         .thread_fn   = deferred_init_memmap_chunk,
>                         .fn_arg      = &arg,
>                         .start       = spfn,
>                         .size        = epfn_align - spfn,
>                         .align       = PAGES_PER_SECTION,
>                         .min_chunk   = PAGES_PER_SECTION,
>                         .max_threads = max_threads,
>                 };
>
>                 padata_do_multithreaded(&job);
>
>                 for_each_free_mem_pfn_range_in_zone_from(i, zone,
> spfn, epfn) {
>                         if (epfn_align <= spfn)
>                                 break;
>                 }
>         }
>

So I was thinking about my suggestion further and the loop at the end
isn't quite correct as I believe it could lead to gaps. The loop on
the end should probably be:
                for_each_free_mem_pfn_range_in_zone_from(i, zone, spfn, epfn) {
                        if (epfn <= epfn_align)
                                continue;
                        if (spfn < epfn_align)
                                spfn = epfn_align;
                        break;
                }

That would generate a new range where epfn_align has actually ended
and there is a range of new PFNs to process.

Thanks.

- Alex

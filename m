Return-Path: <SRS0=h1Lr=7J=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4DE8CC433E0
	for <linux-crypto@archiver.kernel.org>; Wed, 27 May 2020 21:18:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 288BC20835
	for <linux-crypto@archiver.kernel.org>; Wed, 27 May 2020 21:18:46 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="iiQHWCci"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387469AbgE0VSm (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 27 May 2020 17:18:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51902 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387412AbgE0VSm (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 27 May 2020 17:18:42 -0400
Received: from mail-io1-xd44.google.com (mail-io1-xd44.google.com [IPv6:2607:f8b0:4864:20::d44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 57F59C05BD1E;
        Wed, 27 May 2020 14:18:42 -0700 (PDT)
Received: by mail-io1-xd44.google.com with SMTP id s18so13769364ioe.2;
        Wed, 27 May 2020 14:18:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=OQpIJWMudHYzeYVJAX5TAsaN7KlVrc6tTOWAA64PC+4=;
        b=iiQHWCciz2fx1p5e3Ax1s0ebQUYscbu3DHxh5vhMTs51fzQY4eRqWuZwLGrNVO7ljo
         A1gz+WbDPEL/vzgBc+W1Jp+YI86kaMBy6fQ1J8oQGAYP3jx3X/dydph7LHKsjZMcKQ7p
         GoxlqkETGVhWIfEP3XOfTHoDM1dycQWH7SGh2nDHw2hZ4d/WD1wDiygoEzVbo43AYsaX
         R044I8YtHcLpwGMc8PsH7MgGaZPi81X/3EASGPTwdlRu5NleQ+NFU/12tPOiBYFinBga
         kxZ0Ue9uHcBfBJCgvTaMdwt0PpfJIPmKggXfx0aGdbRw7uOtm+vbPyRzlVOr8GeX610E
         2P4g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=OQpIJWMudHYzeYVJAX5TAsaN7KlVrc6tTOWAA64PC+4=;
        b=Rr/9m4tJ1eeRQn0QTSNY2bDBwpoHI9N6AnjvCC+9ehxzgPgqPHX7gxPiUXvkrJEfm8
         jLmZTft9p4hLeLy8qzXrqEXgyqU+1100oP0IL+qMg7cMl2wCpvSlC+FnAhYBanz7SOmh
         szdwZcRD+MWwfTD+Jv8iCIBrzQGBsjmnet9Bw3+Nwd84FFfN7pAWVsXFqzEDNQdzX39U
         a8CM/9EEbzKJuqilEYe5JFBwaxd7sjCtWzQ7jA5EO8zDi0rnY1stRooixllSG1MpMGn7
         3zzo6uM4SELP8qHeBYqp4kKfQHCHjBRJvB2fjy84YnOAincCCXsvzCPv0qrJgRNt1fph
         4Hlw==
X-Gm-Message-State: AOAM533OafVq3aIXgiuXIHBILaLoxpLAEZfLmDxGJzc0ORB0jVCzOrOX
        Uo0LxFLXudlYEiDyzQfHelqvIQN6RaIWMj+eoeI=
X-Google-Smtp-Source: ABdhPJzsosJVaGZxsaHbzCE+qheixFWw0db5wOKUZpRvaNa1fjVHnbvE40NI+t+uWx+U/K/yN8sWBICKzejoGyiO0mY=
X-Received: by 2002:a6b:5f06:: with SMTP id t6mr12961446iob.88.1590614321551;
 Wed, 27 May 2020 14:18:41 -0700 (PDT)
MIME-Version: 1.0
References: <20200527173608.2885243-1-daniel.m.jordan@oracle.com> <20200527173608.2885243-6-daniel.m.jordan@oracle.com>
In-Reply-To: <20200527173608.2885243-6-daniel.m.jordan@oracle.com>
From:   Alexander Duyck <alexander.duyck@gmail.com>
Date:   Wed, 27 May 2020 14:18:30 -0700
Message-ID: <CAKgT0UcVRMWpaxYu9SQnTuQZm6ePBJkTStWPwekzkfRMnLvf1Q@mail.gmail.com>
Subject: Re: [PATCH v3 5/8] mm: don't track number of pages during deferred initialization
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

On Wed, May 27, 2020 at 10:37 AM Daniel Jordan
<daniel.m.jordan@oracle.com> wrote:
>
> Deferred page init used to report the number of pages initialized:
>
>   node 0 initialised, 32439114 pages in 97ms
>
> Tracking this makes the code more complicated when using multiple
> threads.  Given that the statistic probably has limited value,
> especially since a zone grows on demand so that the page count can vary,
> just remove it.
>
> The boot message now looks like
>
>   node 0 deferred pages initialised in 97ms
>
> Signed-off-by: Daniel Jordan <daniel.m.jordan@oracle.com>
> Suggested-by: Alexander Duyck <alexander.h.duyck@linux.intel.com>

This looks good to me.

Reviewed-by: Alexander Duyck <alexander.h.duyck@linux.intel.com>

> ---
>  mm/page_alloc.c | 8 ++++----
>  1 file changed, 4 insertions(+), 4 deletions(-)
>
> diff --git a/mm/page_alloc.c b/mm/page_alloc.c
> index d0c0d9364aa6d..d64f3027fdfa6 100644
> --- a/mm/page_alloc.c
> +++ b/mm/page_alloc.c
> @@ -1819,7 +1819,7 @@ static int __init deferred_init_memmap(void *data)
>  {
>         pg_data_t *pgdat = data;
>         const struct cpumask *cpumask = cpumask_of_node(pgdat->node_id);
> -       unsigned long spfn = 0, epfn = 0, nr_pages = 0;
> +       unsigned long spfn = 0, epfn = 0;
>         unsigned long first_init_pfn, flags;
>         unsigned long start = jiffies;
>         struct zone *zone;
> @@ -1868,15 +1868,15 @@ static int __init deferred_init_memmap(void *data)
>          * allocator.
>          */
>         while (spfn < epfn) {
> -               nr_pages += deferred_init_maxorder(&i, zone, &spfn, &epfn);
> +               deferred_init_maxorder(&i, zone, &spfn, &epfn);
>                 cond_resched();
>         }
>  zone_empty:
>         /* Sanity check that the next zone really is unpopulated */
>         WARN_ON(++zid < MAX_NR_ZONES && populated_zone(++zone));
>
> -       pr_info("node %d initialised, %lu pages in %ums\n",
> -               pgdat->node_id, nr_pages, jiffies_to_msecs(jiffies - start));
> +       pr_info("node %d deferred pages initialised in %ums\n",
> +               pgdat->node_id, jiffies_to_msecs(jiffies - start));
>
>         pgdat_init_report_one_done();
>         return 0;
> --
> 2.26.2
>
>

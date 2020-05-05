Return-Path: <SRS0=vF1r=6T=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1E7BDC3A5A9
	for <linux-crypto@archiver.kernel.org>; Tue,  5 May 2020 01:26:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E95BF206D7
	for <linux-crypto@archiver.kernel.org>; Tue,  5 May 2020 01:26:19 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="CMoXkt2f"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726551AbgEEB0T (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 4 May 2020 21:26:19 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:45406 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726449AbgEEB0T (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 4 May 2020 21:26:19 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0451N6ko079996;
        Tue, 5 May 2020 01:25:49 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=4+6154vKJTABEfgUtxKwWoHbT6y+LuZVgaWdQCoeaJ0=;
 b=CMoXkt2fWDkIg5JZiKjYVOxo/ricHIVKH25HA0ij33TZMT+wY45jvCYQ1I0ncaq/h1NB
 qTGq4sVubLO8srgRcnGcuaxePZrsKCdi/YRLHoAogCQU9kqPMpJhSqAnGf2eYzr33VSZ
 EZL17sihTk9pDALvtp5ha5AuhPBJO4DDIZcSa+LIFGJzQV4FZsdYIT8M8Lbv2xrXjg25
 1u/utotOj/a1j5IPSo5O9g2wgmHJgrrqWtoQoV3FvI17KAcAGtoPsN21YTr4/BUpuxsG
 HnwQGsW2kh+uKh1shg3txe0iI5CNb5AO2yfpfEzsIJ40bQLlfWNro/WjgAMU003Wphux Vg== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by aserp2120.oracle.com with ESMTP id 30s0tma20x-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 05 May 2020 01:25:48 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0451Lidr101980;
        Tue, 5 May 2020 01:25:48 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userp3030.oracle.com with ESMTP id 30t1r3revy-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 05 May 2020 01:25:47 +0000
Received: from abhmp0011.oracle.com (abhmp0011.oracle.com [141.146.116.17])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 0451PdNR022088;
        Tue, 5 May 2020 01:25:39 GMT
Received: from ca-dmjordan1.us.oracle.com (/10.211.9.48)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 04 May 2020 18:25:39 -0700
Date:   Mon, 4 May 2020 21:26:01 -0400
From:   Daniel Jordan <daniel.m.jordan@oracle.com>
To:     Alexander Duyck <alexander.duyck@gmail.com>
Cc:     Daniel Jordan <daniel.m.jordan@oracle.com>,
        Andrew Morton <akpm@linux-foundation.org>,
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
Subject: Re: [PATCH 6/7] mm: parallelize deferred_init_memmap()
Message-ID: <20200505012601.b7pdwbcc2v6gkghf@ca-dmjordan1.us.oracle.com>
References: <20200430201125.532129-1-daniel.m.jordan@oracle.com>
 <20200430201125.532129-7-daniel.m.jordan@oracle.com>
 <CAKgT0Uf7e5514SOi8dmkB5oXUK9bwqD_z-5KJ_F3MUn3CAQyPQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAKgT0Uf7e5514SOi8dmkB5oXUK9bwqD_z-5KJ_F3MUn3CAQyPQ@mail.gmail.com>
User-Agent: NeoMutt/20180716
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9611 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 adultscore=0 suspectscore=2
 spamscore=0 mlxlogscore=999 malwarescore=0 phishscore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2003020000
 definitions=main-2005050006
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9611 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 mlxscore=0
 priorityscore=1501 lowpriorityscore=0 spamscore=0 suspectscore=2
 phishscore=0 clxscore=1015 bulkscore=0 mlxlogscore=999 adultscore=0
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2005050006
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Mon, May 04, 2020 at 03:33:58PM -0700, Alexander Duyck wrote:
> On Thu, Apr 30, 2020 at 1:12 PM Daniel Jordan
> > @@ -1778,15 +1798,25 @@ static int __init deferred_init_memmap(void *data)
> >                 goto zone_empty;
> >
> >         /*
> > -        * Initialize and free pages in MAX_ORDER sized increments so
> > -        * that we can avoid introducing any issues with the buddy
> > -        * allocator.
> > +        * More CPUs always led to greater speedups on tested systems, up to
> > +        * all the nodes' CPUs.  Use all since the system is otherwise idle now.
> >          */
> 
> I would be curious about your data. That isn't what I have seen in the
> past. Typically only up to about 8 or 10 CPUs gives you any benefit,
> beyond that I was usually cache/memory bandwidth bound.

I was surprised too!  For most of its development, this set had an interface to
get the number of cores on the theory that this was about where the bandwidth
got saturated, but the data showed otherwise.

There were diminishing returns, but they were more apparent on Haswell than
Skylake for instance.  I'll post some more data later in the thread where you
guys are talking about it.

> 
> > +       max_threads = max(cpumask_weight(cpumask), 1u);
> > +
> 
> We will need to gather data on if having a ton of threads works for
> all architectures.

Agreed.  I'll rope in some of the arch lists in the next version and include
the debugging knob to vary the thread count.

> For x86 I think we are freeing back pages in
> pageblock_order sized chunks so we only have to touch them once in
> initialize and then free the two pageblock_order chunks into the buddy
> allocator.
> 
> >         for_each_free_mem_pfn_range_in_zone_from(i, zone, &spfn, &epfn) {
> > -               while (spfn < epfn) {
> > -                       nr_pages += deferred_init_maxorder(zone, &spfn, epfn);
> > -                       cond_resched();
> > -               }
> > +               struct def_init_args args = { zone, ATOMIC_LONG_INIT(0) };
> > +               struct padata_mt_job job = {
> > +                       .thread_fn   = deferred_init_memmap_chunk,
> > +                       .fn_arg      = &args,
> > +                       .start       = spfn,
> > +                       .size        = epfn - spfn,
> > +                       .align       = MAX_ORDER_NR_PAGES,
> > +                       .min_chunk   = MAX_ORDER_NR_PAGES,
> > +                       .max_threads = max_threads,
> > +               };
> > +
> > +               padata_do_multithreaded(&job);
> > +               nr_pages += atomic_long_read(&args.nr_pages);
> >         }
> >  zone_empty:
> >         /* Sanity check that the next zone really is unpopulated */
> 
> Okay so looking at this I can see why you wanted to structure the
> other patch the way you did. However I am not sure that is the best
> way to go about doing it. It might make more sense to go through and
> accumulate sections. If you hit the end of a range and the start of
> the next range is in another section, then you split it as a new job,
> otherwise I would just accumulate it into the current job. You then
> could section align the work and be more or less guaranteed that each
> worker thread should be generating finished work products, and not
> incomplete max order pages.

This guarantee holds now with the max-order alignment passed to padata, so I
don't see what more doing it on section boundaries buys us.

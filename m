Return-Path: <SRS0=G1bP=6P=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 88CF6C4724C
	for <linux-crypto@archiver.kernel.org>; Fri,  1 May 2020 00:50:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 719AC20757
	for <linux-crypto@archiver.kernel.org>; Fri,  1 May 2020 00:50:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727124AbgEAAun (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 30 Apr 2020 20:50:43 -0400
Received: from relay9-d.mail.gandi.net ([217.70.183.199]:56167 "EHLO
        relay9-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726384AbgEAAun (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 30 Apr 2020 20:50:43 -0400
X-Originating-IP: 50.39.163.217
Received: from localhost (50-39-163-217.bvtn.or.frontiernet.net [50.39.163.217])
        (Authenticated sender: josh@joshtriplett.org)
        by relay9-d.mail.gandi.net (Postfix) with ESMTPSA id 4F0B7FF805;
        Fri,  1 May 2020 00:50:28 +0000 (UTC)
Date:   Thu, 30 Apr 2020 17:50:26 -0700
From:   Josh Triplett <josh@joshtriplett.org>
To:     Andrew Morton <akpm@linux-foundation.org>
Cc:     Daniel Jordan <daniel.m.jordan@oracle.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Alexander Duyck <alexander.h.duyck@linux.intel.com>,
        Dan Williams <dan.j.williams@intel.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        David Hildenbrand <david@redhat.com>,
        Jason Gunthorpe <jgg@ziepe.ca>,
        Jonathan Corbet <corbet@lwn.net>,
        Kirill Tkhai <ktkhai@virtuozzo.com>,
        Michal Hocko <mhocko@kernel.org>, Pavel Machek <pavel@ucw.cz>,
        Pavel Tatashin <pasha.tatashin@soleen.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Randy Dunlap <rdunlap@infradead.org>,
        Shile Zhang <shile.zhang@linux.alibaba.com>,
        Tejun Heo <tj@kernel.org>, Zi Yan <ziy@nvidia.com>,
        linux-crypto@vger.kernel.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/7] padata: parallelize deferred page init
Message-ID: <20200501005026.GA104377@localhost>
References: <20200430201125.532129-1-daniel.m.jordan@oracle.com>
 <20200430143131.7b8ff07f022ed879305de82f@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200430143131.7b8ff07f022ed879305de82f@linux-foundation.org>
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Thu, Apr 30, 2020 at 02:31:31PM -0700, Andrew Morton wrote:
> On Thu, 30 Apr 2020 16:11:18 -0400 Daniel Jordan <daniel.m.jordan@oracle.com> wrote:
> > Sometimes the kernel doesn't take full advantage of system memory
> > bandwidth, leading to a single CPU spending excessive time in
> > initialization paths where the data scales with memory size.
> > 
> > Multithreading naturally addresses this problem, and this series is the
> > first step.
> > 
> > It extends padata, a framework that handles many parallel singlethreaded
> > jobs, to handle multithreaded jobs as well by adding support for
> > splitting up the work evenly, specifying a minimum amount of work that's
> > appropriate for one helper thread to do, load balancing between helpers,
> > and coordinating them.  More documentation in patches 4 and 7.
> > 
> > The first user is deferred struct page init, a large bottleneck in
> > kernel boot--actually the largest for us and likely others too.  This
> > path doesn't require concurrency limits, resource control, or priority
> > adjustments like future users will (vfio, hugetlb fallocate, munmap)
> > because it happens during boot when the system is otherwise idle and
> > waiting on page init to finish.
> > 
> > This has been tested on a variety of x86 systems and speeds up kernel
> > boot by 6% to 49% by making deferred init 63% to 91% faster.
> 
> How long is this up-to-91% in seconds?  If it's 91% of a millisecond
> then not impressed.  If it's 91% of two weeks then better :)

Some test results on a system with 96 CPUs and 192GB of memory:

Without this patch series:
[    0.487132] node 0 initialised, 23398907 pages in 292ms
[    0.499132] node 1 initialised, 24189223 pages in 304ms
...
[    0.629376] Run /sbin/init as init process

With this patch series:
[    0.227868] node 0 initialised, 23398907 pages in 28ms
[    0.230019] node 1 initialised, 24189223 pages in 28ms
...
[    0.361069] Run /sbin/init as init process

That makes a huge difference; memory initialization is the largest
remaining component of boot time.

> Relatedly, how important is boot time on these large machines anyway? 
> They presumably have lengthy uptimes so boot time is relatively
> unimportant?

Cloud systems and other virtual machines may have a huge amount of
memory but not necessarily run for a long time; on such systems, boot
time becomes critically important. Reducing boot time on cloud systems
and VMs makes the difference between "leave running to reduce latency"
and "just boot up when needed".

- Josh Triplett

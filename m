Return-Path: <SRS0=G1bP=6P=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 71714C4724C
	for <linux-crypto@archiver.kernel.org>; Fri,  1 May 2020 01:09:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4F0F12074A
	for <linux-crypto@archiver.kernel.org>; Fri,  1 May 2020 01:09:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727124AbgEABJv (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 30 Apr 2020 21:09:51 -0400
Received: from relay7-d.mail.gandi.net ([217.70.183.200]:48077 "EHLO
        relay7-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727114AbgEABJv (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 30 Apr 2020 21:09:51 -0400
X-Originating-IP: 50.39.163.217
Received: from localhost (50-39-163-217.bvtn.or.frontiernet.net [50.39.163.217])
        (Authenticated sender: josh@joshtriplett.org)
        by relay7-d.mail.gandi.net (Postfix) with ESMTPSA id DBED520005;
        Fri,  1 May 2020 01:09:37 +0000 (UTC)
Date:   Thu, 30 Apr 2020 18:09:35 -0700
From:   Josh Triplett <josh@joshtriplett.org>
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
Message-ID: <20200501010935.GB104377@localhost>
References: <20200430201125.532129-1-daniel.m.jordan@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200430201125.532129-1-daniel.m.jordan@oracle.com>
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Thu, Apr 30, 2020 at 04:11:18PM -0400, Daniel Jordan wrote:
> Sometimes the kernel doesn't take full advantage of system memory
> bandwidth, leading to a single CPU spending excessive time in
> initialization paths where the data scales with memory size.
> 
> Multithreading naturally addresses this problem, and this series is the
> first step.
> 
> It extends padata, a framework that handles many parallel singlethreaded
> jobs, to handle multithreaded jobs as well by adding support for
> splitting up the work evenly, specifying a minimum amount of work that's
> appropriate for one helper thread to do, load balancing between helpers,
> and coordinating them.  More documentation in patches 4 and 7.
> 
> The first user is deferred struct page init, a large bottleneck in
> kernel boot--actually the largest for us and likely others too.  This
> path doesn't require concurrency limits, resource control, or priority
> adjustments like future users will (vfio, hugetlb fallocate, munmap)
> because it happens during boot when the system is otherwise idle and
> waiting on page init to finish.
> 
> This has been tested on a variety of x86 systems and speeds up kernel
> boot by 6% to 49% by making deferred init 63% to 91% faster.  Patch 6
> has detailed numbers.  Test results from other systems appreciated.
> 
> This series is based on v5.6 plus these three from mmotm:
> 
>   mm-call-touch_nmi_watchdog-on-max-order-boundaries-in-deferred-init.patch
>   mm-initialize-deferred-pages-with-interrupts-enabled.patch
>   mm-call-cond_resched-from-deferred_init_memmap.patch
> 
> All of the above can be found in this branch:
> 
>   git://oss.oracle.com/git/linux-dmjordan.git padata-mt-definit-v1
>   https://oss.oracle.com/git/gitweb.cgi?p=linux-dmjordan.git;a=shortlog;h=refs/heads/padata-mt-definit-v1

For the series (and the three prerequisite patches):

Tested-by: Josh Triplett <josh@joshtriplett.org>

Thank you for writing this, and thank you for working towards
upstreaming it!

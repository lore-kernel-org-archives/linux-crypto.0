Return-Path: <SRS0=3pbX=6O=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6588BC47247
	for <linux-crypto@archiver.kernel.org>; Thu, 30 Apr 2020 21:31:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 391BB206D6
	for <linux-crypto@archiver.kernel.org>; Thu, 30 Apr 2020 21:31:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1588282294;
	bh=Bkl834xA9CcEf8hJwN2hSps66VvWfQ0obMpJUC2DhsI=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:List-ID:From;
	b=YhwwtobOtalMBOOYg8jJ+TPmF3PnQT5g63b/UU+RyeetaxIDkRZzjuIFc+xOvwZm7
	 wSAr+MYiQBF+bhB9NH++Sst05aCuFqaHYGHGt/iarSEnHZ1Cfl8LOgjdh4krbIKYrY
	 02LhSXfLf8rOI1i04iBvTE0akEwVckulYzp2w1xo=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726447AbgD3Vbd (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 30 Apr 2020 17:31:33 -0400
Received: from mail.kernel.org ([198.145.29.99]:44490 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726336AbgD3Vbd (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 30 Apr 2020 17:31:33 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 07C8820870;
        Thu, 30 Apr 2020 21:31:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588282292;
        bh=Bkl834xA9CcEf8hJwN2hSps66VvWfQ0obMpJUC2DhsI=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=n3v24GDLU0OAacwQ8azR4ZyAH5L3zSqPATNrbvEhpRTC9Q9/nuG17Q0Cck8wscapG
         Y1g5a4dTXh/93Ig5fF8vwETzF+pKorxdKNJqO2MqxYSJq/wQZy7YVk8PNlgT7rWxht
         JJU7Zj83UBZFTuWnzZGeHq02EE6uLPPSRoKVL7Qg=
Date:   Thu, 30 Apr 2020 14:31:31 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     Daniel Jordan <daniel.m.jordan@oracle.com>
Cc:     Herbert Xu <herbert@gondor.apana.org.au>,
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
        linux-crypto@vger.kernel.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/7] padata: parallelize deferred page init
Message-Id: <20200430143131.7b8ff07f022ed879305de82f@linux-foundation.org>
In-Reply-To: <20200430201125.532129-1-daniel.m.jordan@oracle.com>
References: <20200430201125.532129-1-daniel.m.jordan@oracle.com>
X-Mailer: Sylpheed 3.5.1 (GTK+ 2.24.31; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Thu, 30 Apr 2020 16:11:18 -0400 Daniel Jordan <daniel.m.jordan@oracle.com> wrote:

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
> boot by 6% to 49% by making deferred init 63% to 91% faster.

How long is this up-to-91% in seconds?  If it's 91% of a millisecond
then not impressed.  If it's 91% of two weeks then better :)

Relatedly, how important is boot time on these large machines anyway? 
They presumably have lengthy uptimes so boot time is relatively
unimportant?

IOW, can you please explain more fully why this patchset is valuable to
our users?

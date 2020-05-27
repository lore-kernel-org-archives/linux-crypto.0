Return-Path: <SRS0=h1Lr=7J=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6DBB2C433DF
	for <linux-crypto@archiver.kernel.org>; Wed, 27 May 2020 17:38:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4ABB120C56
	for <linux-crypto@archiver.kernel.org>; Wed, 27 May 2020 17:38:15 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="LN0w9liL"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391313AbgE0RiL (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 27 May 2020 13:38:11 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:56266 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2403800AbgE0Rhg (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 27 May 2020 13:37:36 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 04RHRkSK158962;
        Wed, 27 May 2020 17:36:31 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : mime-version : content-transfer-encoding;
 s=corp-2020-01-29; bh=2rd7ublOA5zFVNNeGELfk8SsbEgUgaXSpSrwmj/9ilw=;
 b=LN0w9liLTM/x3SZ4LjlkOgIZixAcOdTAJ7v+Tb7sqeOeliVL/0KmVUkSNYGnCeKfYuER
 YA8WYyuCx+ELTzD9BBlTlAEuE2mD7SPS6bHjGT71Egat32CtftVYdhot2Ka+SsI6/yAA
 ryxd5mLSPUwW+TtAskfw6R+PpfAbpnku/6Hb53xcoginafSSQcRqeM36uGbxMGCMqNVt
 oUWRQyQ710fl2tWFbbIPgAjT1icktzObRU1XN/Rys0OnvjiX5Sq+9gBQDSRX2bhDVgO5
 eWsK7yXtDfhZCWNHjxHrrIaIXGiINIp1BT7NmzfKaed4fweuEhhIXol3kWTvqnvOF3l8 Jg== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2120.oracle.com with ESMTP id 318xbk0v53-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Wed, 27 May 2020 17:36:30 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 04RHXblJ105390;
        Wed, 27 May 2020 17:36:30 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3020.oracle.com with ESMTP id 317j5sfs55-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 27 May 2020 17:36:30 +0000
Received: from abhmp0002.oracle.com (abhmp0002.oracle.com [141.146.116.8])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 04RHaGaI003875;
        Wed, 27 May 2020 17:36:16 GMT
Received: from localhost.localdomain (/98.229.125.203)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 27 May 2020 10:36:15 -0700
From:   Daniel Jordan <daniel.m.jordan@oracle.com>
To:     Andrew Morton <akpm@linux-foundation.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Steffen Klassert <steffen.klassert@secunet.com>
Cc:     Alex Williamson <alex.williamson@redhat.com>,
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
        linux-crypto@vger.kernel.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, linux-s390@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org,
        Daniel Jordan <daniel.m.jordan@oracle.com>
Subject: [PATCH v3 0/8] padata: parallelize deferred page init
Date:   Wed, 27 May 2020 13:36:00 -0400
Message-Id: <20200527173608.2885243-1-daniel.m.jordan@oracle.com>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9633 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 spamscore=0 suspectscore=0
 mlxlogscore=999 mlxscore=0 adultscore=0 phishscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2004280000
 definitions=main-2005270137
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9633 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 spamscore=0 mlxscore=0
 lowpriorityscore=0 priorityscore=1501 phishscore=0 cotscore=-2147483648
 suspectscore=0 bulkscore=0 clxscore=1015 impostorscore=0 malwarescore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2004280000 definitions=main-2005270136
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Thanks to Alex for his continued review and Josh for running v2!  Please
continue to review and test, and acks for the padata parts would be
appreciated.

Daniel

--

Deferred struct page init is a bottleneck in kernel boot--the biggest
for us and probably others.  Optimizing it maximizes availability for
large-memory systems and allows spinning up short-lived VMs as needed
without having to leave them running.  It also benefits bare metal
machines hosting VMs that are sensitive to downtime.  In projects such
as VMM Fast Restart[1], where guest state is preserved across kexec
reboot, it helps prevent application and network timeouts in the guests.

So, multithread deferred init to take full advantage of system memory
bandwidth.

Extend padata, a framework that handles many parallel singlethreaded
jobs, to handle multithreaded jobs as well by adding support for
splitting up the work evenly, specifying a minimum amount of work that's
appropriate for one helper thread to do, load balancing between helpers,
and coordinating them.  More documentation in patches 4 and 8.

This series is the first step in a project to address other memory
proportional bottlenecks in the kernel such as pmem struct page init,
vfio page pinning, hugetlb fallocate, and munmap.  Deferred page init
doesn't require concurrency limits, resource control, or priority
adjustments like these other users will because it happens during boot
when the system is otherwise idle and waiting for page init to finish.

This has been run on a variety of x86 systems and speeds up kernel boot
by 4% to 49%, saving up to 1.6 out of 4 seconds.  Patch 6 has more
numbers.

The powerpc and s390 lists are included in case they want to give this a
try, they had enabled this feature when it was configured per arch.

Series based on v5.7-rc7 plus these three from mmotm

  mm-call-touch_nmi_watchdog-on-max-order-boundaries-in-deferred-init.patch
  mm-initialize-deferred-pages-with-interrupts-enabled.patch
  mm-call-cond_resched-from-deferred_init_memmap.patch

and it's available here:

  git://oss.oracle.com/git/linux-dmjordan.git padata-mt-definit-v3
  https://oss.oracle.com/git/gitweb.cgi?p=linux-dmjordan.git;a=shortlog;h=refs/heads/padata-mt-definit-v3

and the future users and related features are available as
work-in-progress:

  git://oss.oracle.com/git/linux-dmjordan.git padata-mt-wip-v0.5
  https://oss.oracle.com/git/gitweb.cgi?p=linux-dmjordan.git;a=shortlog;h=refs/heads/padata-mt-wip-v0.5

v3:
 - Remove nr_pages accounting as suggested by Alex, adding a new patch
 - Align deferred init ranges up not down, simplify surrounding code (Alex)
 - Add Josh's T-b's from v2 (Josh's T-b's for v1 lost in rebase, apologies!)
 - Move padata.h include up in init/main.c to reduce patch collisions (Andrew)
 - Slightly reword Documentation patch
 - Rebase on v5.7-rc7 and retest

v2:
 - Improve the problem statement (Andrew, Josh, Pavel)
 - Add T-b's to unchanged patches (Josh)
 - Fully initialize max-order blocks to avoid buddy issues (Alex)
 - Parallelize on section-aligned boundaries to avoid potential
   false sharing (Alex)
 - Return the maximum thread count from a function that architectures
   can override, with the generic version returning 1 (current
   behavior).  Override for x86 since that's the only arch this series
   has been tested on so far.  Other archs can test with more threads
   by dropping patch 6.
 - Rebase to v5.7-rc6, rerun tests

RFC v4 [2] -> v1:
 - merged with padata (Peter)
 - got rid of the 'task' nomenclature (Peter, Jon)

future work branch:
 - made lockdep-aware (Jason, Peter)
 - adjust workqueue worker priority with renice_or_cancel() (Tejun)
 - fixed undo problem in VFIO (Alex)

The remaining feedback, mainly resource control awareness (cgroup etc),
is TODO for later series.

[1] https://static.sched.com/hosted_files/kvmforum2019/66/VMM-fast-restart_kvmforum2019.pdf
    https://www.youtube.com/watch?v=pBsHnf93tcQ
    https://lore.kernel.org/linux-mm/1588812129-8596-1-git-send-email-anthony.yznaga@oracle.com/

[2] https://lore.kernel.org/linux-mm/20181105165558.11698-1-daniel.m.jordan@oracle.com/

Daniel Jordan (8):
  padata: remove exit routine
  padata: initialize earlier
  padata: allocate work structures for parallel jobs from a pool
  padata: add basic support for multithreaded jobs
  mm: don't track number of pages during deferred initialization
  mm: parallelize deferred_init_memmap()
  mm: make deferred init's max threads arch-specific
  padata: document multithreaded jobs

 Documentation/core-api/padata.rst |  41 +++--
 arch/x86/mm/init_64.c             |  12 ++
 include/linux/memblock.h          |   3 +
 include/linux/padata.h            |  43 ++++-
 init/main.c                       |   2 +
 kernel/padata.c                   | 277 ++++++++++++++++++++++++------
 mm/Kconfig                        |   6 +-
 mm/page_alloc.c                   |  59 +++++--
 8 files changed, 361 insertions(+), 82 deletions(-)


base-commit: 9cb1fd0efd195590b828b9b865421ad345a4a145
prerequisite-patch-id: 4ad522141e1119a325a9799dad2bd982fbac8b7c
prerequisite-patch-id: 169273327e56f5461101a71dfbd6b4cfd4570cf0
prerequisite-patch-id: 0f34692c8a9673d4c4f6a3545cf8ec3a2abf8620
-- 
2.26.2


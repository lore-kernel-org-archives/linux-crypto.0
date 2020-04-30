Return-Path: <SRS0=3pbX=6O=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AB2E0C47247
	for <linux-crypto@archiver.kernel.org>; Thu, 30 Apr 2020 20:12:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 84A8620774
	for <linux-crypto@archiver.kernel.org>; Thu, 30 Apr 2020 20:12:25 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="J6emRK3n"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726788AbgD3UMZ (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 30 Apr 2020 16:12:25 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:41466 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726524AbgD3UMY (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 30 Apr 2020 16:12:24 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 03UK8uKo084446;
        Thu, 30 Apr 2020 20:11:40 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : mime-version : content-transfer-encoding;
 s=corp-2020-01-29; bh=Tj/Vywbax7ksJzdV9zU97xcEcZuvaW8/vJFBwr0+2HY=;
 b=J6emRK3n6GSyEW/Ez+VBqaZB2kI73fz1NgKjCoMTaNu+sd634ykdV3UamEznaT/VMELp
 JLDp4Rn44RpioaFNFHQAilUalaiCVAaP/FjTFd4hztLBmvRI1/DgiR2t37Y5TXothwrm
 xFlWD5yhjYkyocd82HEIRN/EdOu/uwrk70ZNL15UjmOok7/v1voc2/DMW7LGkx0j7aAT
 7XTjm7OcKjDKNtE+j98NWYoyEO4mOlahmE+SS9KduMyNzA6QNqP1EdAKdz/5naQHdil0
 9kSW5GZM7yI56BQDIHvIcGLu0pjQ/gl903ozdlpZY6vzOtZyyGf2BqFYCPDh82sSxt21 qw== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by aserp2120.oracle.com with ESMTP id 30nucgdkpj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 30 Apr 2020 20:11:40 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 03UK7Oma095747;
        Thu, 30 Apr 2020 20:11:39 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3030.oracle.com with ESMTP id 30qtjy23kn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 30 Apr 2020 20:11:39 +0000
Received: from abhmp0010.oracle.com (abhmp0010.oracle.com [141.146.116.16])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 03UKBV5O026651;
        Thu, 30 Apr 2020 20:11:31 GMT
Received: from localhost.localdomain (/98.229.125.203)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 30 Apr 2020 13:11:31 -0700
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
        Shile Zhang <shile.zhang@linux.alibaba.com>,
        Tejun Heo <tj@kernel.org>, Zi Yan <ziy@nvidia.com>,
        linux-crypto@vger.kernel.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org,
        Daniel Jordan <daniel.m.jordan@oracle.com>
Subject: [PATCH 0/7] padata: parallelize deferred page init
Date:   Thu, 30 Apr 2020 16:11:18 -0400
Message-Id: <20200430201125.532129-1-daniel.m.jordan@oracle.com>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9607 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 suspectscore=0
 malwarescore=0 bulkscore=0 phishscore=0 mlxlogscore=999 mlxscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2004300150
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9607 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 clxscore=1011 priorityscore=1501
 mlxlogscore=999 impostorscore=0 suspectscore=0 malwarescore=0
 lowpriorityscore=0 mlxscore=0 spamscore=0 adultscore=0 phishscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2004300150
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Sometimes the kernel doesn't take full advantage of system memory
bandwidth, leading to a single CPU spending excessive time in
initialization paths where the data scales with memory size.

Multithreading naturally addresses this problem, and this series is the
first step.

It extends padata, a framework that handles many parallel singlethreaded
jobs, to handle multithreaded jobs as well by adding support for
splitting up the work evenly, specifying a minimum amount of work that's
appropriate for one helper thread to do, load balancing between helpers,
and coordinating them.  More documentation in patches 4 and 7.

The first user is deferred struct page init, a large bottleneck in
kernel boot--actually the largest for us and likely others too.  This
path doesn't require concurrency limits, resource control, or priority
adjustments like future users will (vfio, hugetlb fallocate, munmap)
because it happens during boot when the system is otherwise idle and
waiting on page init to finish.

This has been tested on a variety of x86 systems and speeds up kernel
boot by 6% to 49% by making deferred init 63% to 91% faster.  Patch 6
has detailed numbers.  Test results from other systems appreciated.

This series is based on v5.6 plus these three from mmotm:

  mm-call-touch_nmi_watchdog-on-max-order-boundaries-in-deferred-init.patch
  mm-initialize-deferred-pages-with-interrupts-enabled.patch
  mm-call-cond_resched-from-deferred_init_memmap.patch

All of the above can be found in this branch:

  git://oss.oracle.com/git/linux-dmjordan.git padata-mt-definit-v1
  https://oss.oracle.com/git/gitweb.cgi?p=linux-dmjordan.git;a=shortlog;h=refs/heads/padata-mt-definit-v1

The future users and related features are available as work-in-progress
here:

  git://oss.oracle.com/git/linux-dmjordan.git padata-mt-wip-v0.3
  https://oss.oracle.com/git/gitweb.cgi?p=linux-dmjordan.git;a=shortlog;h=refs/heads/padata-mt-wip-v0.3

Thanks to everyone who commented on the last version of this[0],
including Alex Williamson, Jason Gunthorpe, Jonathan Corbet, Michal
Hocko, Pavel Machek, Peter Zijlstra, Randy Dunlap, Robert Elliott, Tejun
Heo, and Zi Yan.

RFC v4 -> padata v1:
 - merged with padata (Peter)
 - got rid of the 'task' nomenclature (Peter, Jon)

future work branch:
 - made lockdep-aware (Jason, Peter)
 - adjust workqueue worker priority with renice_or_cancel() (Tejun)
 - fixed undo problem in VFIO (Alex)

The remaining feedback, mainly resource control awareness (cgroup etc),
is TODO for later series.

[0] https://lore.kernel.org/linux-mm/20181105165558.11698-1-daniel.m.jordan@oracle.com/

Daniel Jordan (7):
  padata: remove exit routine
  padata: initialize earlier
  padata: allocate work structures for parallel jobs from a pool
  padata: add basic support for multithreaded jobs
  mm: move zone iterator outside of deferred_init_maxorder()
  mm: parallelize deferred_init_memmap()
  padata: document multithreaded jobs

 Documentation/core-api/padata.rst |  41 +++--
 include/linux/padata.h            |  43 ++++-
 init/main.c                       |   2 +
 kernel/padata.c                   | 277 ++++++++++++++++++++++++------
 mm/Kconfig                        |   6 +-
 mm/page_alloc.c                   | 118 ++++++-------
 6 files changed, 355 insertions(+), 132 deletions(-)


base-commit: 7111951b8d4973bda27ff663f2cf18b663d15b48
prerequisite-patch-id: 4ad522141e1119a325a9799dad2bd982fbac8b7c
prerequisite-patch-id: 169273327e56f5461101a71dfbd6b4cfd4570cf0
prerequisite-patch-id: 0f34692c8a9673d4c4f6a3545cf8ec3a2abf8620
-- 
2.26.2


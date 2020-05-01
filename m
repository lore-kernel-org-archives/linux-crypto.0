Return-Path: <SRS0=G1bP=6P=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.3 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1C7B8C28CBC
	for <linux-crypto@archiver.kernel.org>; Fri,  1 May 2020 02:53:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DEC5820643
	for <linux-crypto@archiver.kernel.org>; Fri,  1 May 2020 02:53:50 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="DW6PsvJP"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728073AbgEACxu (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 30 Apr 2020 22:53:50 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:47346 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728024AbgEACxu (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 30 Apr 2020 22:53:50 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0412lURJ022728;
        Fri, 1 May 2020 02:48:21 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=9hCESYezdDlcZa6EJ0bZ7R2X2D3XTfEQtgE9cbLshLo=;
 b=DW6PsvJPZdoLRUxLRT6UOMpxSVF6O4c9DAqPCt/SXTNcmH7o5gQ6sg2y016f1nXBGzvh
 bDpxuwQxYrsP8s4vI5IYDtjfEjRqXpA107pVEr/DQc72QXWTFIoNtPywxJjAuIytPvMC
 REobS2qkJgYklILgdm4LLd3c314XuYQdW6X4BqnS2nD8QDtXFThWzFpwUiSedyHUTHAB
 f2vp2QfMuw7qNpQU/zE0Nicagq7dSdoH2lVA4o3qwrVZfDA3zZbMY72BPiGYPDRoLi9j
 h5ejMuR/BzUaE0iFqcggngb7naEeKMavXsz+RtP6gWcmIIjlpMMpD3ufVT9A1yKXES3a DQ== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2130.oracle.com with ESMTP id 30r7f80j7r-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 01 May 2020 02:48:20 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0412kv2p129174;
        Fri, 1 May 2020 02:48:20 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserp3020.oracle.com with ESMTP id 30r7f8wusn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 01 May 2020 02:48:19 +0000
Received: from abhmp0014.oracle.com (abhmp0014.oracle.com [141.146.116.20])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 0412mIq4021967;
        Fri, 1 May 2020 02:48:18 GMT
Received: from ca-dmjordan1.us.oracle.com (/10.211.9.48)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 30 Apr 2020 19:48:18 -0700
Date:   Thu, 30 Apr 2020 22:48:40 -0400
From:   Daniel Jordan <daniel.m.jordan@oracle.com>
To:     Josh Triplett <josh@joshtriplett.org>
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
Message-ID: <20200501024840.eofsy3av5bwcdpw2@ca-dmjordan1.us.oracle.com>
References: <20200430201125.532129-1-daniel.m.jordan@oracle.com>
 <20200501010935.GB104377@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200501010935.GB104377@localhost>
User-Agent: NeoMutt/20180716
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9607 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 suspectscore=0
 phishscore=0 malwarescore=0 mlxscore=0 spamscore=0 mlxlogscore=999
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2005010019
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9607 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 impostorscore=0 mlxlogscore=999
 spamscore=0 malwarescore=0 clxscore=1015 phishscore=0 mlxscore=0
 lowpriorityscore=0 suspectscore=0 adultscore=0 priorityscore=1501
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2005010018
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Thu, Apr 30, 2020 at 06:09:35PM -0700, Josh Triplett wrote:
> On Thu, Apr 30, 2020 at 04:11:18PM -0400, Daniel Jordan wrote:
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
> > boot by 6% to 49% by making deferred init 63% to 91% faster.  Patch 6
> > has detailed numbers.  Test results from other systems appreciated.
> > 
> > This series is based on v5.6 plus these three from mmotm:
> > 
> >   mm-call-touch_nmi_watchdog-on-max-order-boundaries-in-deferred-init.patch
> >   mm-initialize-deferred-pages-with-interrupts-enabled.patch
> >   mm-call-cond_resched-from-deferred_init_memmap.patch
> > 
> > All of the above can be found in this branch:
> > 
> >   git://oss.oracle.com/git/linux-dmjordan.git padata-mt-definit-v1
> >   https://oss.oracle.com/git/gitweb.cgi?p=linux-dmjordan.git;a=shortlog;h=refs/heads/padata-mt-definit-v1
> 
> For the series (and the three prerequisite patches):
> 
> Tested-by: Josh Triplett <josh@joshtriplett.org>

Appreciate the runs, Josh, thanks.

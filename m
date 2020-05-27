Return-Path: <SRS0=h1Lr=7J=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1B02CC433DF
	for <linux-crypto@archiver.kernel.org>; Wed, 27 May 2020 17:38:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id ECF1020707
	for <linux-crypto@archiver.kernel.org>; Wed, 27 May 2020 17:38:09 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="reCN7ZDh"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2403815AbgE0Rhh (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 27 May 2020 13:37:37 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:59238 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2403803AbgE0Rhg (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 27 May 2020 13:37:36 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 04RHS8xU066133;
        Wed, 27 May 2020 17:36:32 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=corp-2020-01-29;
 bh=yPUXFWPL94bqTXYWjhf36bOZIYPC2tWDc5RPRYWRQpc=;
 b=reCN7ZDhlWpd3nB6imCa52znFT7mP1fOUN2XCQQ631F1ma2oxX577K3URLMu6DcgEmYc
 9SzOSPQUOj3SMYETsYmmw8Gl621nAz5lbRotfYPZF2vFTfB8aEpbbZvxKAwsTD2iAC4f
 uH9PUDI9zDyhtj82I2gJvjyomGX/+XFWkYJDEqdSIofBdYhajQmQtvs+KBoH05hu9m4v
 O8OX/i87vC0fKYZnKE3j6wRzs0TQlzC67GIUO0w5JQooN99R3qvXEGQhrRg/1h7/iKDO
 yl1QBJ8gcMuCPJfzXBLg2QEJF45uqhx78MNKx7H2ed7ngfom+HlWlCOWkP5x4Y1le2et 3A== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2120.oracle.com with ESMTP id 318xe1gubg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Wed, 27 May 2020 17:36:32 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 04RHXdpC142867;
        Wed, 27 May 2020 17:36:32 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userp3020.oracle.com with ESMTP id 317dkutu4g-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 27 May 2020 17:36:31 +0000
Received: from abhmp0002.oracle.com (abhmp0002.oracle.com [141.146.116.8])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 04RHaRuB012736;
        Wed, 27 May 2020 17:36:27 GMT
Received: from localhost.localdomain (/98.229.125.203)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 27 May 2020 10:36:27 -0700
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
Subject: [PATCH v3 5/8] mm: don't track number of pages during deferred initialization
Date:   Wed, 27 May 2020 13:36:05 -0400
Message-Id: <20200527173608.2885243-6-daniel.m.jordan@oracle.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200527173608.2885243-1-daniel.m.jordan@oracle.com>
References: <20200527173608.2885243-1-daniel.m.jordan@oracle.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9633 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 malwarescore=0 bulkscore=0
 spamscore=0 suspectscore=0 mlxscore=0 adultscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2004280000
 definitions=main-2005270137
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9633 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 mlxlogscore=999
 adultscore=0 cotscore=-2147483648 mlxscore=0 bulkscore=0
 priorityscore=1501 phishscore=0 lowpriorityscore=0 malwarescore=0
 clxscore=1015 impostorscore=0 suspectscore=0 classifier=spam adjust=0
 reason=mlx scancount=1 engine=8.12.0-2004280000
 definitions=main-2005270136
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Deferred page init used to report the number of pages initialized:

  node 0 initialised, 32439114 pages in 97ms

Tracking this makes the code more complicated when using multiple
threads.  Given that the statistic probably has limited value,
especially since a zone grows on demand so that the page count can vary,
just remove it.

The boot message now looks like

  node 0 deferred pages initialised in 97ms

Signed-off-by: Daniel Jordan <daniel.m.jordan@oracle.com>
Suggested-by: Alexander Duyck <alexander.h.duyck@linux.intel.com>
---
 mm/page_alloc.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index d0c0d9364aa6d..d64f3027fdfa6 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -1819,7 +1819,7 @@ static int __init deferred_init_memmap(void *data)
 {
 	pg_data_t *pgdat = data;
 	const struct cpumask *cpumask = cpumask_of_node(pgdat->node_id);
-	unsigned long spfn = 0, epfn = 0, nr_pages = 0;
+	unsigned long spfn = 0, epfn = 0;
 	unsigned long first_init_pfn, flags;
 	unsigned long start = jiffies;
 	struct zone *zone;
@@ -1868,15 +1868,15 @@ static int __init deferred_init_memmap(void *data)
 	 * allocator.
 	 */
 	while (spfn < epfn) {
-		nr_pages += deferred_init_maxorder(&i, zone, &spfn, &epfn);
+		deferred_init_maxorder(&i, zone, &spfn, &epfn);
 		cond_resched();
 	}
 zone_empty:
 	/* Sanity check that the next zone really is unpopulated */
 	WARN_ON(++zid < MAX_NR_ZONES && populated_zone(++zone));
 
-	pr_info("node %d initialised, %lu pages in %ums\n",
-		pgdat->node_id,	nr_pages, jiffies_to_msecs(jiffies - start));
+	pr_info("node %d deferred pages initialised in %ums\n",
+		pgdat->node_id, jiffies_to_msecs(jiffies - start));
 
 	pgdat_init_report_one_done();
 	return 0;
-- 
2.26.2


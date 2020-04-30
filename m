Return-Path: <SRS0=3pbX=6O=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 393FCC4724C
	for <linux-crypto@archiver.kernel.org>; Thu, 30 Apr 2020 20:14:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0CE732076D
	for <linux-crypto@archiver.kernel.org>; Thu, 30 Apr 2020 20:14:12 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="m+I2zk3N"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726738AbgD3UOL (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 30 Apr 2020 16:14:11 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:54962 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727080AbgD3UOL (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 30 Apr 2020 16:14:11 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 03UKDWOM009406;
        Thu, 30 Apr 2020 20:13:43 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=corp-2020-01-29;
 bh=m72YR/nkrMDSIXspqjuUroii0+CofYy9l2S6f8qhUFQ=;
 b=m+I2zk3NpPfpkFFc97LloLnclZOxcrApFODkdPrRxwRZoPNPkDnQHWRimbWTptFS5Vi6
 baMhKWWgvcLSnAWAzUVAWjbjA1l/CdBAVkcgYlalt+C/RY8aYJPDvduA26lkfbcJDXlk
 7IR2Xw67kKidhNPd5o8BhKVR6WCtZKnvaxw/oCcoc/ZL70tacGG5uUabV+MwQp0fDck7
 7S5O8ju/IpVrnxnHJDUpzcwe/L3tq/2ifqLvoTPCWD3aJ7sfiEW/liQgXlQsdmCtiDHY
 GdA/By95bKhNSXIHvfvECom/hwxjby6gPWtiH2JdJumN62b0H0+ABKzZUwVuevLB8t3l 6w== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2120.oracle.com with ESMTP id 30p2p0k2wx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 30 Apr 2020 20:13:43 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 03UK6XkW140606;
        Thu, 30 Apr 2020 20:11:42 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserp3030.oracle.com with ESMTP id 30qtkx5a75-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 30 Apr 2020 20:11:42 +0000
Received: from abhmp0010.oracle.com (abhmp0010.oracle.com [141.146.116.16])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 03UKBfka024124;
        Thu, 30 Apr 2020 20:11:41 GMT
Received: from localhost.localdomain (/98.229.125.203)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 30 Apr 2020 13:11:41 -0700
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
Subject: [PATCH 5/7] mm: move zone iterator outside of deferred_init_maxorder()
Date:   Thu, 30 Apr 2020 16:11:23 -0400
Message-Id: <20200430201125.532129-6-daniel.m.jordan@oracle.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200430201125.532129-1-daniel.m.jordan@oracle.com>
References: <20200430201125.532129-1-daniel.m.jordan@oracle.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9607 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 suspectscore=2 mlxscore=0
 phishscore=0 mlxlogscore=999 adultscore=0 malwarescore=0 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2003020000
 definitions=main-2004300150
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9607 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 phishscore=0 clxscore=1015
 bulkscore=0 adultscore=0 lowpriorityscore=0 impostorscore=0 malwarescore=0
 mlxscore=0 suspectscore=2 mlxlogscore=999 priorityscore=1501
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2003020000
 definitions=main-2004300151
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

padata will soon divide up pfn ranges between threads when parallelizing
deferred init, and deferred_init_maxorder() complicates that by using an
opaque index in addition to start and end pfns.  Move the index outside
the function to make splitting the job easier, and simplify the code
while at it.

deferred_init_maxorder() now always iterates within a single pfn range
instead of potentially multiple ranges, and advances start_pfn to the
end of that range instead of the max-order block so partial pfn ranges
in the block aren't skipped in a later iteration.  The section alignment
check in deferred_grow_zone() is removed as well since this alignment is
no longer guaranteed.  It's not clear what value the alignment provided
originally.

Signed-off-by: Daniel Jordan <daniel.m.jordan@oracle.com>
---
 mm/page_alloc.c | 88 +++++++++++++++----------------------------------
 1 file changed, 27 insertions(+), 61 deletions(-)

diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index 68669d3a5a665..990514d8f0d94 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -1708,55 +1708,23 @@ deferred_init_mem_pfn_range_in_zone(u64 *i, struct zone *zone,
 }
 
 /*
- * Initialize and free pages. We do it in two loops: first we initialize
- * struct page, then free to buddy allocator, because while we are
- * freeing pages we can access pages that are ahead (computing buddy
- * page in __free_one_page()).
- *
- * In order to try and keep some memory in the cache we have the loop
- * broken along max page order boundaries. This way we will not cause
- * any issues with the buddy page computation.
+ * Initialize the struct pages and then free them to the buddy allocator at
+ * most a max order block at a time because while we are freeing pages we can
+ * access pages that are ahead (computing buddy page in __free_one_page()).
+ * It's also cache friendly.
  */
 static unsigned long __init
-deferred_init_maxorder(u64 *i, struct zone *zone, unsigned long *start_pfn,
-		       unsigned long *end_pfn)
+deferred_init_maxorder(struct zone *zone, unsigned long *start_pfn,
+		       unsigned long end_pfn)
 {
-	unsigned long mo_pfn = ALIGN(*start_pfn + 1, MAX_ORDER_NR_PAGES);
-	unsigned long spfn = *start_pfn, epfn = *end_pfn;
-	unsigned long nr_pages = 0;
-	u64 j = *i;
-
-	/* First we loop through and initialize the page values */
-	for_each_free_mem_pfn_range_in_zone_from(j, zone, start_pfn, end_pfn) {
-		unsigned long t;
-
-		if (mo_pfn <= *start_pfn)
-			break;
-
-		t = min(mo_pfn, *end_pfn);
-		nr_pages += deferred_init_pages(zone, *start_pfn, t);
-
-		if (mo_pfn < *end_pfn) {
-			*start_pfn = mo_pfn;
-			break;
-		}
-	}
-
-	/* Reset values and now loop through freeing pages as needed */
-	swap(j, *i);
-
-	for_each_free_mem_pfn_range_in_zone_from(j, zone, &spfn, &epfn) {
-		unsigned long t;
-
-		if (mo_pfn <= spfn)
-			break;
+	unsigned long nr_pages, pfn;
 
-		t = min(mo_pfn, epfn);
-		deferred_free_pages(spfn, t);
+	pfn = ALIGN(*start_pfn + 1, MAX_ORDER_NR_PAGES);
+	pfn = min(pfn, end_pfn);
 
-		if (mo_pfn <= epfn)
-			break;
-	}
+	nr_pages = deferred_init_pages(zone, *start_pfn, pfn);
+	deferred_free_pages(*start_pfn, pfn);
+	*start_pfn = pfn;
 
 	return nr_pages;
 }
@@ -1814,9 +1782,11 @@ static int __init deferred_init_memmap(void *data)
 	 * that we can avoid introducing any issues with the buddy
 	 * allocator.
 	 */
-	while (spfn < epfn) {
-		nr_pages += deferred_init_maxorder(&i, zone, &spfn, &epfn);
-		cond_resched();
+	for_each_free_mem_pfn_range_in_zone_from(i, zone, &spfn, &epfn) {
+		while (spfn < epfn) {
+			nr_pages += deferred_init_maxorder(zone, &spfn, epfn);
+			cond_resched();
+		}
 	}
 zone_empty:
 	/* Sanity check that the next zone really is unpopulated */
@@ -1883,22 +1853,18 @@ deferred_grow_zone(struct zone *zone, unsigned int order)
 	 * that we can avoid introducing any issues with the buddy
 	 * allocator.
 	 */
-	while (spfn < epfn) {
-		/* update our first deferred PFN for this section */
-		first_deferred_pfn = spfn;
-
-		nr_pages += deferred_init_maxorder(&i, zone, &spfn, &epfn);
-		touch_nmi_watchdog();
-
-		/* We should only stop along section boundaries */
-		if ((first_deferred_pfn ^ spfn) < PAGES_PER_SECTION)
-			continue;
-
-		/* If our quota has been met we can stop here */
-		if (nr_pages >= nr_pages_needed)
-			break;
+	for_each_free_mem_pfn_range_in_zone_from(i, zone, &spfn, &epfn) {
+		while (spfn < epfn) {
+			nr_pages += deferred_init_maxorder(zone, &spfn, epfn);
+			touch_nmi_watchdog();
+
+			/* If our quota has been met we can stop here */
+			if (nr_pages >= nr_pages_needed)
+				goto out;
+		}
 	}
 
+out:
 	pgdat->first_deferred_pfn = spfn;
 	pgdat_resize_unlock(pgdat, &flags);
 
-- 
2.26.2


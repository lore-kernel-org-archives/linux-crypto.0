Return-Path: <SRS0=3pbX=6O=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 743C3C47247
	for <linux-crypto@archiver.kernel.org>; Thu, 30 Apr 2020 20:12:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4C1FB207DD
	for <linux-crypto@archiver.kernel.org>; Thu, 30 Apr 2020 20:12:36 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="ln2bq8S+"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726917AbgD3UMZ (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 30 Apr 2020 16:12:25 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:41468 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726486AbgD3UMY (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 30 Apr 2020 16:12:24 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 03UK9F0k084676;
        Thu, 30 Apr 2020 20:11:46 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=corp-2020-01-29;
 bh=r/CbKeQi8OFEvnMJbjndCS8xkwaSl+iaVTADntYBC8Q=;
 b=ln2bq8S+L02pSxT8jCNrNLjs4Bi3HNfuXnoKvEChwDRq8KBEr26cjs6vzBV5rAYQWQ2b
 LRgn06oLtaj7RwYrrnQE6EPPoNAm9DbqSe869iaJl0aMFk3OgeYjZcV76NQFu4Qug8z4
 evGp/vVBNqHksrwbm549blgLVXueqjTSU79PmPkbw+Wv7fBfBErGk8wUkDIUmSlJ6WzY
 UGAAyO2lbbJjQibs8qWhglQMnPVubtP7nIi7lsUmTsu70yvIfh7GR8Tje2l5gpMuWpFj
 bgw2JRBbWq8zlVX6WKKGZkG43ljRU4SGIDlNARPpuDfU7cZSYJfhVZokgZDXyJd0mxoS sA== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by aserp2120.oracle.com with ESMTP id 30nucgdkq2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 30 Apr 2020 20:11:46 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 03UK6YlR140654;
        Thu, 30 Apr 2020 20:11:46 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserp3030.oracle.com with ESMTP id 30qtkx5a93-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 30 Apr 2020 20:11:46 +0000
Received: from abhmp0010.oracle.com (abhmp0010.oracle.com [141.146.116.16])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 03UKBiuP026717;
        Thu, 30 Apr 2020 20:11:44 GMT
Received: from localhost.localdomain (/98.229.125.203)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 30 Apr 2020 13:11:43 -0700
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
Subject: [PATCH 6/7] mm: parallelize deferred_init_memmap()
Date:   Thu, 30 Apr 2020 16:11:24 -0400
Message-Id: <20200430201125.532129-7-daniel.m.jordan@oracle.com>
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
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 clxscore=1015 priorityscore=1501
 mlxlogscore=999 impostorscore=0 suspectscore=2 malwarescore=0
 lowpriorityscore=0 mlxscore=0 spamscore=0 adultscore=0 phishscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2004300150
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Deferred struct page init uses one thread per node, which is a
significant bottleneck at boot for big machines--often the largest.
Parallelize to reduce system downtime.

The maximum number of threads is capped at the number of CPUs on the
node because speedups always improve with additional threads on every
system tested, and at this phase of boot, the system is otherwise idle
and waiting on page init to finish.

Helper threads operate on MAX_ORDER_NR_PAGES-aligned ranges to avoid
accessing uninitialized buddy pages, so set the job's alignment
accordingly.

The minimum chunk size is also MAX_ORDER_NR_PAGES because there was
benefit to using multiple threads even on relatively small memory (1G)
systems.

    Intel(R) Xeon(R) Platinum 8167M CPU @ 2.00GHz (Skylake, bare metal)
      2 nodes * 26 cores * 2 threads = 104 CPUs
      384G/node = 768G memory

                   kernel boot                 deferred init
                   ------------------------    ------------------------
                   speedup  time_ms (stdev)    speedup  time_ms (stdev)
         base           --   4056.7 (  5.5)         --   1763.3 (  4.2)
         test        39.9%   2436.7 (  2.1)      91.8%    144.3 (  5.9)

    Intel(R) Xeon(R) CPU E5-2699C v4 @ 2.20GHz (Broadwell, bare metal)
      1 node * 16 cores * 2 threads = 32 CPUs
      192G/node = 192G memory

                   kernel boot                 deferred init
                   ------------------------    ------------------------
                   speedup  time_ms (stdev)    speedup  time_ms (stdev)
         base           --   1957.3 ( 14.0)         --   1093.7 ( 12.9)
         test        49.1%    996.0 (  7.2)      88.4%    127.3 (  5.1)

    Intel(R) Xeon(R) CPU E5-2699 v3 @ 2.30GHz (Haswell, bare metal)
      2 nodes * 18 cores * 2 threads = 72 CPUs
      128G/node = 256G memory

                   kernel boot                 deferred init
                   ------------------------    ------------------------
                   speedup  time_ms (stdev)    speedup  time_ms (stdev)
         base           --   1666.0 (  3.5)         --    618.0 (  3.5)
         test        31.3%   1145.3 (  1.5)      85.6%     89.0 (  1.7)

    AMD EPYC 7551 32-Core Processor (Zen, kvm guest)
      1 node * 8 cores * 2 threads = 16 CPUs
      64G/node = 64G memory

                   kernel boot                 deferred init
                   ------------------------    ------------------------
                   speedup  time_ms (stdev)    speedup  time_ms (stdev)
         base           --   1029.7 ( 42.3)         --    253.7 (  3.1)
         test        23.3%    789.3 ( 15.0)      76.3%     60.0 (  5.6)

Server-oriented distros that enable deferred page init sometimes run in
small VMs, and they still benefit even though the fraction of boot time
saved is smaller:

    AMD EPYC 7551 32-Core Processor (Zen, kvm guest)
      1 node * 2 cores * 2 threads = 4 CPUs
      16G/node = 16G memory

                   kernel boot                 deferred init
                   ------------------------    ------------------------
                   speedup  time_ms (stdev)    speedup  time_ms (stdev)
         base           --    757.7 ( 17.1)         --     57.0 (  0.0)
         test         6.2%    710.3 ( 15.0)      63.2%     21.0 (  0.0)

    Intel(R) Xeon(R) CPU E5-2699 v3 @ 2.30GHz (Haswell, kvm guest)
      1 node * 2 cores * 2 threads = 4 CPUs
      14G/node = 14G memory

                   kernel boot                 deferred init
                   ------------------------    ------------------------
                   speedup  time_ms (stdev)    speedup  time_ms (stdev)
         base           --    656.3 (  7.1)         --     57.3 (  1.5)
         test         8.6%    599.7 (  5.9)      62.8%     21.3 (  1.2)

Signed-off-by: Daniel Jordan <daniel.m.jordan@oracle.com>
---
 mm/Kconfig      |  6 +++---
 mm/page_alloc.c | 46 ++++++++++++++++++++++++++++++++++++++--------
 2 files changed, 41 insertions(+), 11 deletions(-)

diff --git a/mm/Kconfig b/mm/Kconfig
index ab80933be65ff..e5007206c7601 100644
--- a/mm/Kconfig
+++ b/mm/Kconfig
@@ -622,13 +622,13 @@ config DEFERRED_STRUCT_PAGE_INIT
 	depends on SPARSEMEM
 	depends on !NEED_PER_CPU_KM
 	depends on 64BIT
+	select PADATA
 	help
 	  Ordinarily all struct pages are initialised during early boot in a
 	  single thread. On very large machines this can take a considerable
 	  amount of time. If this option is set, large machines will bring up
-	  a subset of memmap at boot and then initialise the rest in parallel
-	  by starting one-off "pgdatinitX" kernel thread for each node X. This
-	  has a potential performance impact on processes running early in the
+	  a subset of memmap at boot and then initialise the rest in parallel.
+	  This has a potential performance impact on tasks running early in the
 	  lifetime of the system until these kthreads finish the
 	  initialisation.
 
diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index 990514d8f0d94..96d6d0d920c27 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -68,6 +68,7 @@
 #include <linux/lockdep.h>
 #include <linux/nmi.h>
 #include <linux/psi.h>
+#include <linux/padata.h>
 
 #include <asm/sections.h>
 #include <asm/tlbflush.h>
@@ -1729,6 +1730,25 @@ deferred_init_maxorder(struct zone *zone, unsigned long *start_pfn,
 	return nr_pages;
 }
 
+struct def_init_args {
+	struct zone *zone;
+	atomic_long_t nr_pages;
+};
+
+static void __init deferred_init_memmap_chunk(unsigned long spfn,
+					      unsigned long epfn, void *arg)
+{
+	struct def_init_args *args = arg;
+	unsigned long nr_pages = 0;
+
+	while (spfn < epfn) {
+		nr_pages += deferred_init_maxorder(args->zone, &spfn, epfn);
+		cond_resched();
+	}
+
+	atomic_long_add(nr_pages, &args->nr_pages);
+}
+
 /* Initialise remaining memory on a node */
 static int __init deferred_init_memmap(void *data)
 {
@@ -1738,7 +1758,7 @@ static int __init deferred_init_memmap(void *data)
 	unsigned long first_init_pfn, flags;
 	unsigned long start = jiffies;
 	struct zone *zone;
-	int zid;
+	int zid, max_threads;
 	u64 i;
 
 	/* Bind memory initialisation thread to a local node if possible */
@@ -1778,15 +1798,25 @@ static int __init deferred_init_memmap(void *data)
 		goto zone_empty;
 
 	/*
-	 * Initialize and free pages in MAX_ORDER sized increments so
-	 * that we can avoid introducing any issues with the buddy
-	 * allocator.
+	 * More CPUs always led to greater speedups on tested systems, up to
+	 * all the nodes' CPUs.  Use all since the system is otherwise idle now.
 	 */
+	max_threads = max(cpumask_weight(cpumask), 1u);
+
 	for_each_free_mem_pfn_range_in_zone_from(i, zone, &spfn, &epfn) {
-		while (spfn < epfn) {
-			nr_pages += deferred_init_maxorder(zone, &spfn, epfn);
-			cond_resched();
-		}
+		struct def_init_args args = { zone, ATOMIC_LONG_INIT(0) };
+		struct padata_mt_job job = {
+			.thread_fn   = deferred_init_memmap_chunk,
+			.fn_arg      = &args,
+			.start       = spfn,
+			.size	     = epfn - spfn,
+			.align	     = MAX_ORDER_NR_PAGES,
+			.min_chunk   = MAX_ORDER_NR_PAGES,
+			.max_threads = max_threads,
+		};
+
+		padata_do_multithreaded(&job);
+		nr_pages += atomic_long_read(&args.nr_pages);
 	}
 zone_empty:
 	/* Sanity check that the next zone really is unpopulated */
-- 
2.26.2


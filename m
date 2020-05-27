Return-Path: <SRS0=h1Lr=7J=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 444AFC433DF
	for <linux-crypto@archiver.kernel.org>; Wed, 27 May 2020 17:37:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 25D1B2089D
	for <linux-crypto@archiver.kernel.org>; Wed, 27 May 2020 17:37:46 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="aYPx7daN"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2403846AbgE0Rho (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 27 May 2020 13:37:44 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:59324 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2403842AbgE0Rhn (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 27 May 2020 13:37:43 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 04RHSRtE066275;
        Wed, 27 May 2020 17:36:36 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=corp-2020-01-29;
 bh=i/6XgwHHHOgoW5TU+a/aVclmsApnQYa1z6EDveHJZOY=;
 b=aYPx7daNvdWh1SteBGYuCo3aP0mPn56fA8eCky3L0YZ3J+CXbm344uPti2Pcb930sz/m
 aD18jOEtXBMLjiCLVBuqTch+QKSTWWX5GyG2aK6xiFFlWgwqDhC+nAG/qNOhBLbVst1C
 36bhTB/wrIuLgdLKibdqUXXEtbOHHOR5ZIfRSTA30cvhiRQSJywhRcuh3lgvpeBWgyld
 0fszqEapBamiaE+VOApwXSwqnVvl4iruf/RuJlZRHO1TLTJbKF/EPwPGimUjZl4COvnx
 XhB9u1wf72kFAwRgIMcDHlEOyCIHtSTVlo1MMaOeKmG874IqN07GmRFCBICOrj+QQJ7E nQ== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by aserp2120.oracle.com with ESMTP id 318xe1gubs-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Wed, 27 May 2020 17:36:36 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 04RHX4lq195410;
        Wed, 27 May 2020 17:36:36 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserp3030.oracle.com with ESMTP id 317ddr6jyg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 27 May 2020 17:36:36 +0000
Received: from abhmp0002.oracle.com (abhmp0002.oracle.com [141.146.116.8])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 04RHaYCm012759;
        Wed, 27 May 2020 17:36:34 GMT
Received: from localhost.localdomain (/98.229.125.203)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 27 May 2020 10:36:33 -0700
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
Subject: [PATCH v3 8/8] padata: document multithreaded jobs
Date:   Wed, 27 May 2020 13:36:08 -0400
Message-Id: <20200527173608.2885243-9-daniel.m.jordan@oracle.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200527173608.2885243-1-daniel.m.jordan@oracle.com>
References: <20200527173608.2885243-1-daniel.m.jordan@oracle.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9633 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 bulkscore=0 mlxscore=0
 phishscore=0 adultscore=0 suspectscore=0 spamscore=0 malwarescore=0
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

Add Documentation for multithreaded jobs.

Signed-off-by: Daniel Jordan <daniel.m.jordan@oracle.com>
Tested-by: Josh Triplett <josh@joshtriplett.org>
---
 Documentation/core-api/padata.rst | 41 +++++++++++++++++++++++--------
 1 file changed, 31 insertions(+), 10 deletions(-)

diff --git a/Documentation/core-api/padata.rst b/Documentation/core-api/padata.rst
index 9a24c111781d9..0830e5b0e8211 100644
--- a/Documentation/core-api/padata.rst
+++ b/Documentation/core-api/padata.rst
@@ -4,23 +4,26 @@
 The padata parallel execution mechanism
 =======================================
 
-:Date: December 2019
+:Date: May 2020
 
 Padata is a mechanism by which the kernel can farm jobs out to be done in
-parallel on multiple CPUs while retaining their ordering.  It was developed for
-use with the IPsec code, which needs to be able to perform encryption and
-decryption on large numbers of packets without reordering those packets.  The
-crypto developers made a point of writing padata in a sufficiently general
-fashion that it could be put to other uses as well.
+parallel on multiple CPUs while optionally retaining their ordering.
 
-Usage
-=====
+It was originally developed for IPsec, which needs to perform encryption and
+decryption on large numbers of packets without reordering those packets.  This
+is currently the sole consumer of padata's serialized job support.
+
+Padata also supports multithreaded jobs, splitting up the job evenly while load
+balancing and coordinating between threads.
+
+Running Serialized Jobs
+=======================
 
 Initializing
 ------------
 
-The first step in using padata is to set up a padata_instance structure for
-overall control of how jobs are to be run::
+The first step in using padata to run serialized jobs is to set up a
+padata_instance structure for overall control of how jobs are to be run::
 
     #include <linux/padata.h>
 
@@ -162,6 +165,24 @@ functions that correspond to the allocation in reverse::
 It is the user's responsibility to ensure all outstanding jobs are complete
 before any of the above are called.
 
+Running Multithreaded Jobs
+==========================
+
+A multithreaded job has a main thread and zero or more helper threads, with the
+main thread participating in the job and then waiting until all helpers have
+finished.  padata splits the job into units called chunks, where a chunk is a
+piece of the job that one thread completes in one call to the thread function.
+
+A user has to do three things to run a multithreaded job.  First, describe the
+job by defining a padata_mt_job structure, which is explained in the Interface
+section.  This includes a pointer to the thread function, which padata will
+call each time it assigns a job chunk to a thread.  Then, define the thread
+function, which accepts three arguments, ``start``, ``end``, and ``arg``, where
+the first two delimit the range that the thread operates on and the last is a
+pointer to the job's shared state, if any.  Prepare the shared state, which is
+typically allocated on the main thread's stack.  Last, call
+padata_do_multithreaded(), which will return once the job is finished.
+
 Interface
 =========
 
-- 
2.26.2


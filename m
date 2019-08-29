Return-Path: <SRS0=oY6L=WZ=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 44EF6C3A59F
	for <linux-crypto@archiver.kernel.org>; Thu, 29 Aug 2019 17:38:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1CBCC2189D
	for <linux-crypto@archiver.kernel.org>; Thu, 29 Aug 2019 17:38:45 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="ELpX3mFg"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727352AbfH2Rin (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 29 Aug 2019 13:38:43 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:54956 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727481AbfH2Rim (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 29 Aug 2019 13:38:42 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x7THXnmr134049;
        Thu, 29 Aug 2019 17:38:29 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=corp-2019-08-05;
 bh=dCNzWO/FXVDMwwImLRNfZxHktHml5H3w+6akEtHZx4s=;
 b=ELpX3mFgoUAmDW0wI07BKRQfphEC+5Iv8L9M4fQ+RSpQdUBXganuxRyOcdSts54mtdyW
 ssbyrpQrVfEyEoUi6zzcgzM8rvOUutK35EiLZCuTNU3lYf4+p94uaEhL0JfxFh0XZxeG
 2HseAIxyUrED71QdV90a0blRudFmGpEUWjm44r2UsyuJt9NRoCBxuuGCWw4LpegWBY3R
 Rbw1wb4QTkb0CATgDOQ3Gsc2+3BZv5h8g7PdJNMUsfg9i68/7oq7T4GbmeG2jXTJHPmt
 q+/FtVNHz7WMGfHKdWCDpwLDl8lStTxO6XBteYU5C6fGvg4DWcswcqVBcUEYmfZ2BxYz lg== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2120.oracle.com with ESMTP id 2upk4sr37n-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 29 Aug 2019 17:38:29 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x7THWYcL057229;
        Thu, 29 Aug 2019 17:33:28 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserp3020.oracle.com with ESMTP id 2upc8uy1ts-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 29 Aug 2019 17:33:28 +0000
Received: from abhmp0008.oracle.com (abhmp0008.oracle.com [141.146.116.14])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x7THWgJ2002163;
        Thu, 29 Aug 2019 17:32:42 GMT
Received: from zissou.us.oracle.com (/10.152.34.58)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 29 Aug 2019 10:32:42 -0700
From:   Daniel Jordan <daniel.m.jordan@oracle.com>
To:     Herbert Xu <herbert@gondor.apana.org.au>,
        Steffen Klassert <steffen.klassert@secunet.com>
Cc:     Lai Jiangshan <jiangshanlai@gmail.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Tejun Heo <tj@kernel.org>, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Daniel Jordan <daniel.m.jordan@oracle.com>
Subject: [PATCH v2 9/9] padata: remove cpu_index from the parallel_queue
Date:   Thu, 29 Aug 2019 13:30:38 -0400
Message-Id: <20190829173038.21040-10-daniel.m.jordan@oracle.com>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20190829173038.21040-1-daniel.m.jordan@oracle.com>
References: <20190829173038.21040-1-daniel.m.jordan@oracle.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9364 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1906280000 definitions=main-1908290186
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9364 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1906280000
 definitions=main-1908290186
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

With the removal of the ENODATA case from padata_get_next, the cpu_index
field is no longer useful, so it can go away.

Signed-off-by: Daniel Jordan <daniel.m.jordan@oracle.com>
Acked-by: Steffen Klassert <steffen.klassert@secunet.com>
Cc: Herbert Xu <herbert@gondor.apana.org.au>
Cc: Lai Jiangshan <jiangshanlai@gmail.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Tejun Heo <tj@kernel.org>
Cc: linux-crypto@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
---
 include/linux/padata.h |  2 --
 kernel/padata.c        | 13 ++-----------
 2 files changed, 2 insertions(+), 13 deletions(-)

diff --git a/include/linux/padata.h b/include/linux/padata.h
index 4d2ba38d99fc..edc1d63a91e7 100644
--- a/include/linux/padata.h
+++ b/include/linux/padata.h
@@ -76,14 +76,12 @@ struct padata_serial_queue {
  * @swork: work struct for serialization.
  * @work: work struct for parallelization.
  * @num_obj: Number of objects that are processed by this cpu.
- * @cpu_index: Index of the cpu.
  */
 struct padata_parallel_queue {
        struct padata_list    parallel;
        struct padata_list    reorder;
        struct work_struct    work;
        atomic_t              num_obj;
-       int                   cpu_index;
 };
 
 /**
diff --git a/kernel/padata.c b/kernel/padata.c
index 83889e0bf1c4..cbb6bb924046 100644
--- a/kernel/padata.c
+++ b/kernel/padata.c
@@ -399,21 +399,12 @@ static void padata_init_squeues(struct parallel_data *pd)
 /* Initialize all percpu queues used by parallel workers */
 static void padata_init_pqueues(struct parallel_data *pd)
 {
-	int cpu_index, cpu;
+	int cpu;
 	struct padata_parallel_queue *pqueue;
 
-	cpu_index = 0;
-	for_each_possible_cpu(cpu) {
+	for_each_cpu(cpu, pd->cpumask.pcpu) {
 		pqueue = per_cpu_ptr(pd->pqueue, cpu);
 
-		if (!cpumask_test_cpu(cpu, pd->cpumask.pcpu)) {
-			pqueue->cpu_index = -1;
-			continue;
-		}
-
-		pqueue->cpu_index = cpu_index;
-		cpu_index++;
-
 		__padata_list_init(&pqueue->reorder);
 		__padata_list_init(&pqueue->parallel);
 		INIT_WORK(&pqueue->work, padata_parallel_worker);
-- 
2.23.0


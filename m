Return-Path: <SRS0=g3pl=VW=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5F3FDC76190
	for <linux-crypto@archiver.kernel.org>; Thu, 25 Jul 2019 21:27:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 34111218F0
	for <linux-crypto@archiver.kernel.org>; Thu, 25 Jul 2019 21:27:41 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="w9M8s9By"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726692AbfGYV1k (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 25 Jul 2019 17:27:40 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:57132 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726524AbfGYV1k (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 25 Jul 2019 17:27:40 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x6PLNlSL028676;
        Thu, 25 Jul 2019 21:27:27 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=corp-2018-07-02;
 bh=Fwy/EMQNobs66xY3K+vm94ekcwWHInFiiLrIHkn1i9Q=;
 b=w9M8s9Byznyl31h9F7usbjkdTMlsEke2aaRTyNwlmgcJ5JiqaoIGr28eCCdCtrBHGC33
 JY1dScXra5KA04LtdLXC1TNNZsfdolr0SAGXyOPbS72BQy52WmQEdAVqXS1x+B97AaXy
 BZ5OCf3ughPnwPp1b3Im4Ol/MMfMGlG77fbTOJH97q4M9KNNxir8CqwUqO14nqOmvfxN
 3xZu9ynBOHKsrU76iik9HyTlh2Ph3ZXBLg0mto/IYz+45C2fJiXBoV3Mj2F2LAHwatwr
 fM8zmCFHO6dDwtvjh6NYZ/Hb3xviCjeHgKKth0T/GowvGXuLbKfaBRO6XN5AbaPYvejE lA== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2130.oracle.com with ESMTP id 2tx61c6mr3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 25 Jul 2019 21:27:27 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x6PLNCXq043416;
        Thu, 25 Jul 2019 21:25:27 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userp3020.oracle.com with ESMTP id 2tycv77v4m-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 25 Jul 2019 21:25:26 +0000
Received: from abhmp0015.oracle.com (abhmp0015.oracle.com [141.146.116.21])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x6PLPOdf030904;
        Thu, 25 Jul 2019 21:25:26 GMT
Received: from localhost.localdomain (/73.60.114.248)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 25 Jul 2019 14:25:23 -0700
From:   Daniel Jordan <daniel.m.jordan@oracle.com>
To:     Steffen Klassert <steffen.klassert@secunet.com>,
        Herbert Xu <herbert@gondor.apana.org.au>
Cc:     Tejun Heo <tj@kernel.org>, Lai Jiangshan <jiangshanlai@gmail.com>,
        Peter Zijlstra <peterz@infradead.org>,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        Daniel Jordan <daniel.m.jordan@oracle.com>
Subject: [RFC 9/9] padata: remove cpu_index from the parallel_queue
Date:   Thu, 25 Jul 2019 17:25:05 -0400
Message-Id: <20190725212505.15055-10-daniel.m.jordan@oracle.com>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190725212505.15055-1-daniel.m.jordan@oracle.com>
References: <20190725212505.15055-1-daniel.m.jordan@oracle.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9329 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1906280000 definitions=main-1907250257
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9329 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1906280000
 definitions=main-1907250257
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

With the removal of the ENODATA case from padata_get_next, the cpu_index
field is no longer useful, so it can go away.

Signed-off-by: Daniel Jordan <daniel.m.jordan@oracle.com>
---
 include/linux/padata.h |  2 --
 kernel/padata.c        | 13 ++-----------
 2 files changed, 2 insertions(+), 13 deletions(-)

diff --git a/include/linux/padata.h b/include/linux/padata.h
index cc420064186f..a39c7b9cec3c 100644
--- a/include/linux/padata.h
+++ b/include/linux/padata.h
@@ -75,14 +75,12 @@ struct padata_serial_queue {
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
index 09a7dbdd9678..b5236fd84c45 100644
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
2.22.0


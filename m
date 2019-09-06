Return-Path: <SRS0=4a8U=XB=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D9FE1C00306
	for <linux-crypto@archiver.kernel.org>; Fri,  6 Sep 2019 03:25:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id DC94B206A3
	for <linux-crypto@archiver.kernel.org>; Fri,  6 Sep 2019 03:25:58 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="cqX6p5ID"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391329AbfIFDZ5 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 5 Sep 2019 23:25:57 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:59308 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2391320AbfIFDZ5 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 5 Sep 2019 23:25:57 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x863PACX068165;
        Fri, 6 Sep 2019 03:25:39 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=corp-2019-08-05;
 bh=XW7Ojx+pUK0p5QiMONWXWBE8OOEMf80urxVFCJSXtuQ=;
 b=cqX6p5IDFND77MqTG5i+hn/gGBFt0oKpLb1RFhNaJ+VDUNN4hzKhwnRu6b8D38wdAxZ3
 DyHTCsSKp5IgJ+sNGO2IBnKx48ClR7jM08uM0XtC90mSWxGDDynb91WCufdwo2Ze2trU
 MkamE10IQy2TdCofgYF8TJADAjZT6JfEX7y3kRWD8WiSPCGM087NoQHw9LuqC4EX9WfF
 ALP10dU36EHgyI3cVQGP5M17JV1Rwmjo46t6OVhcrj+2birt7V5kstMYg3uw3VWMZUga
 wBGmbfk1jYEdmB+42D51Ns7VgeGqaaQCACpEcXc2YfCCpJIbPUQUZ4UbwofgwkxadKJb Xw== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2120.oracle.com with ESMTP id 2uuf51g2c1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 06 Sep 2019 03:25:39 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x861ciol071292;
        Fri, 6 Sep 2019 01:40:45 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userp3020.oracle.com with ESMTP id 2utvr4fve4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 06 Sep 2019 01:40:45 +0000
Received: from abhmp0009.oracle.com (abhmp0009.oracle.com [141.146.116.15])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x861ei7Q021721;
        Fri, 6 Sep 2019 01:40:44 GMT
Received: from localhost.localdomain (/98.229.125.203)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 05 Sep 2019 18:40:44 -0700
From:   Daniel Jordan <daniel.m.jordan@oracle.com>
To:     Herbert Xu <herbert@gondor.apana.org.au>,
        Steffen Klassert <steffen.klassert@secunet.com>
Cc:     Lai Jiangshan <jiangshanlai@gmail.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Tejun Heo <tj@kernel.org>, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Daniel Jordan <daniel.m.jordan@oracle.com>
Subject: [PATCH v3 9/9] padata: remove cpu_index from the parallel_queue
Date:   Thu,  5 Sep 2019 21:40:29 -0400
Message-Id: <20190906014029.3345-10-daniel.m.jordan@oracle.com>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20190906014029.3345-1-daniel.m.jordan@oracle.com>
References: <20190906014029.3345-1-daniel.m.jordan@oracle.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9371 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1906280000 definitions=main-1909060015
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9371 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1906280000
 definitions=main-1909060037
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
index 43d3fd9d17fc..23717eeaad23 100644
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
index 832224dcf2e1..c3fec1413295 100644
--- a/kernel/padata.c
+++ b/kernel/padata.c
@@ -400,21 +400,12 @@ static void padata_init_squeues(struct parallel_data *pd)
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


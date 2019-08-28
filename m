Return-Path: <SRS0=oY6L=WZ=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	UNWANTED_LANGUAGE_BODY,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4A859C3A5A1
	for <linux-crypto@archiver.kernel.org>; Thu, 29 Aug 2019 02:46:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 154742173E
	for <linux-crypto@archiver.kernel.org>; Thu, 29 Aug 2019 02:46:40 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="VXXiIf7/"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725886AbfH2CpI (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 28 Aug 2019 22:45:08 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:46730 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725844AbfH2CpI (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 28 Aug 2019 22:45:08 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x7T2ie4d110352;
        Thu, 29 Aug 2019 02:44:52 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=corp-2019-08-05;
 bh=vuXYwl4+3gT1SOY2ggdFx5WMHHwn7038nvwRZyo/0PA=;
 b=VXXiIf7/w+pYHuyjIGgXRxxNT/6DGj8fLCYs39dpD7ma9jEcbnx3komF1t/CvJWbuQSz
 ekV0RkK9Ltqm1oW18CnJLXsdblJ9b/aU39g6XZGtlSnAvLKvT7mA9cPz7uYuC1XZi4U2
 W7bRwwbE7VZ0xYXyxzm50kojF6OQr5WEKDLuUcC52eRwPt6I4NoO5p0zPWbViU0HngB5
 EH6Q9/Y4PPmRn+IOIeblKtvqobA0LtXSn7Ov9Ac9LRouel/4tw0RMVXzsbQZ/Jgv1LOU
 T1Tbm8dMMx8RqfQO9roY4l/xISn4J89z03hGXL7UGQ8BjkdRYp0etul1SpUYTqhUZa3u YQ== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2130.oracle.com with ESMTP id 2up62pg0np-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 29 Aug 2019 02:44:52 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x7SMDLif011581;
        Wed, 28 Aug 2019 22:16:32 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userp3030.oracle.com with ESMTP id 2unvtxxk9w-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 28 Aug 2019 22:16:31 +0000
Received: from abhmp0010.oracle.com (abhmp0010.oracle.com [141.146.116.16])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x7SMGVLk020533;
        Wed, 28 Aug 2019 22:16:31 GMT
Received: from zissou.us.oracle.com (/10.152.34.58)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 28 Aug 2019 15:16:30 -0700
From:   Daniel Jordan <daniel.m.jordan@oracle.com>
To:     Herbert Xu <herbert@gondor.apana.org.au>,
        Steffen Klassert <steffen.klassert@secunet.com>
Cc:     Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Thomas Gleixner <tglx@linutronix.de>,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        Daniel Jordan <daniel.m.jordan@oracle.com>
Subject: [PATCH v2 2/5] padata: remove reorder_objects
Date:   Wed, 28 Aug 2019 18:14:22 -0400
Message-Id: <20190828221425.22701-3-daniel.m.jordan@oracle.com>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20190828221425.22701-1-daniel.m.jordan@oracle.com>
References: <20190828221425.22701-1-daniel.m.jordan@oracle.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9363 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1906280000 definitions=main-1908280214
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9363 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1906280000
 definitions=main-1908290029
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

reorder_objects is unused since the rework of padata's flushing, so
remove it.

Signed-off-by: Daniel Jordan <daniel.m.jordan@oracle.com>
Cc: Herbert Xu <herbert@gondor.apana.org.au>
Cc: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc: Steffen Klassert <steffen.klassert@secunet.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: linux-crypto@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
---
 include/linux/padata.h | 2 --
 kernel/padata.c        | 3 ---
 2 files changed, 5 deletions(-)

diff --git a/include/linux/padata.h b/include/linux/padata.h
index 1c73f9cc7b72..720e970cda0a 100644
--- a/include/linux/padata.h
+++ b/include/linux/padata.h
@@ -103,7 +103,6 @@ struct padata_cpumask {
  * @pinst: padata instance.
  * @pqueue: percpu padata queues used for parallelization.
  * @squeue: percpu padata queues used for serialuzation.
- * @reorder_objects: Number of objects waiting in the reorder queues.
  * @refcnt: Number of objects holding a reference on this parallel_data.
  * @flushing_done: Wait for all objects to be sent out.
  * @max_seq_nr:  Maximal used sequence number.
@@ -116,7 +115,6 @@ struct parallel_data {
 	struct padata_instance		*pinst;
 	struct padata_parallel_queue	__percpu *pqueue;
 	struct padata_serial_queue	__percpu *squeue;
-	atomic_t			reorder_objects;
 	atomic_t			refcnt;
 	struct completion		flushing_done;
 	atomic_t			seq_nr;
diff --git a/kernel/padata.c b/kernel/padata.c
index 958166e23123..2bfce01c5b85 100644
--- a/kernel/padata.c
+++ b/kernel/padata.c
@@ -179,7 +179,6 @@ static struct padata_priv *padata_get_next(struct parallel_data *pd)
 				    struct padata_priv, list);
 
 		list_del_init(&padata->list);
-		atomic_dec(&pd->reorder_objects);
 
 		pd->cpu = cpumask_next_wrap(cpu, pd->cpumask.pcpu, -1,
 					    false);
@@ -323,7 +322,6 @@ void padata_do_serial(struct padata_priv *padata)
 
 	spin_lock(&pqueue->reorder.lock);
 	list_add_tail(&padata->list, &pqueue->reorder.list);
-	atomic_inc(&pd->reorder_objects);
 	spin_unlock(&pqueue->reorder.lock);
 
 	/*
@@ -423,7 +421,6 @@ static struct parallel_data *padata_alloc_pd(struct padata_instance *pinst,
 	padata_init_pqueues(pd);
 	padata_init_squeues(pd);
 	atomic_set(&pd->seq_nr, -1);
-	atomic_set(&pd->reorder_objects, 0);
 	/* Initial ref dropped in padata_flush_queues. */
 	atomic_set(&pd->refcnt, 1);
 	init_completion(&pd->flushing_done);
-- 
2.23.0


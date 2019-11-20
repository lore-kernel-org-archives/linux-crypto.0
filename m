Return-Path: <SRS0=IkvS=ZM=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8AF8AC432C0
	for <linux-crypto@archiver.kernel.org>; Wed, 20 Nov 2019 18:56:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 61D7B208A1
	for <linux-crypto@archiver.kernel.org>; Wed, 20 Nov 2019 18:56:51 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="IaFUjuJj"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727225AbfKTS4p (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 20 Nov 2019 13:56:45 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:53706 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726236AbfKTS4o (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 20 Nov 2019 13:56:44 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xAKIs52k015678;
        Wed, 20 Nov 2019 18:56:37 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=corp-2019-08-05;
 bh=JLd+wkFVY5PuAzK7oMlHw2S6WiuQ7xlbQfnSOVIPo0U=;
 b=IaFUjuJjEi8j9gpf1b1k1FQFXaPOl2a7O50KzCcOR6Q4/J9t4HchEqanfZkCwavpD4mP
 JUorXaxzuvrQT+QuzNvKxevjDOpXK3LzN+DbWsF9iyzxz5AMvd2hJnwa7Bx0lZDTMApH
 Dm84AXLV/6MoHgCLowjJ5GEh2deUk2ThQXp2Mk8a4fpTrOIXKk3q6fY5ajTKbfbFU/KV
 9oH7hyk0lcuPyr7Q5uOlxIveMHgdCVv7ETCt9IyReZCmL0cFvMwAhpdMLfQctGLXN38k
 91aujhdN4X8TufcJnnzMIx0VhWVHi6okCBSQk5rjDpVAgsEnNibvztXsqFvwaouQNzVJ nw== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2120.oracle.com with ESMTP id 2wa92pyh3d-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 20 Nov 2019 18:56:37 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xAKIrjES004215;
        Wed, 20 Nov 2019 18:56:36 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userp3020.oracle.com with ESMTP id 2wd46wwray-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 20 Nov 2019 18:56:36 +0000
Received: from abhmp0018.oracle.com (abhmp0018.oracle.com [141.146.116.24])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id xAKIuZOq012930;
        Wed, 20 Nov 2019 18:56:35 GMT
Received: from zissou.us.oracle.com (/10.152.34.58)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 20 Nov 2019 10:56:35 -0800
From:   Daniel Jordan <daniel.m.jordan@oracle.com>
To:     Herbert Xu <herbert@gondor.apana.org.au>,
        Steffen Klassert <steffen.klassert@secunet.com>
Cc:     Eric Biggers <ebiggers@kernel.org>, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Daniel Jordan <daniel.m.jordan@oracle.com>
Subject: [PATCH 2/4] padata: remove reorder_objects
Date:   Wed, 20 Nov 2019 13:54:10 -0500
Message-Id: <20191120185412.302-3-daniel.m.jordan@oracle.com>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191120185412.302-1-daniel.m.jordan@oracle.com>
References: <20191120185412.302-1-daniel.m.jordan@oracle.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9447 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1911140001 definitions=main-1911200156
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9447 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1911140001
 definitions=main-1911200156
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

reorder_objects is unused since the rework of padata's flushing, so
remove it.

Signed-off-by: Daniel Jordan <daniel.m.jordan@oracle.com>
Cc: Eric Biggers <ebiggers@kernel.org>
Cc: Herbert Xu <herbert@gondor.apana.org.au>
Cc: Steffen Klassert <steffen.klassert@secunet.com>
Cc: linux-crypto@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
---
 include/linux/padata.h | 2 --
 kernel/padata.c        | 3 ---
 2 files changed, 5 deletions(-)

diff --git a/include/linux/padata.h b/include/linux/padata.h
index fd38897e1b91..9e0be23bd9ff 100644
--- a/include/linux/padata.h
+++ b/include/linux/padata.h
@@ -102,7 +102,6 @@ struct padata_cpumask {
  * @sh: padata_shell object.
  * @pqueue: percpu padata queues used for parallelization.
  * @squeue: percpu padata queues used for serialuzation.
- * @reorder_objects: Number of objects waiting in the reorder queues.
  * @refcnt: Number of objects holding a reference on this parallel_data.
  * @max_seq_nr:  Maximal used sequence number.
  * @processed: Number of already processed objects.
@@ -115,7 +114,6 @@ struct parallel_data {
 	struct padata_shell		*ps;
 	struct padata_parallel_queue	__percpu *pqueue;
 	struct padata_serial_queue	__percpu *squeue;
-	atomic_t			reorder_objects;
 	atomic_t			refcnt;
 	atomic_t			seq_nr;
 	unsigned int			processed;
diff --git a/kernel/padata.c b/kernel/padata.c
index 8fd188fa017d..5c9bd8df0f0f 100644
--- a/kernel/padata.c
+++ b/kernel/padata.c
@@ -202,7 +202,6 @@ static struct padata_priv *padata_find_next(struct parallel_data *pd,
 
 	if (remove_object) {
 		list_del_init(&padata->list);
-		atomic_dec(&pd->reorder_objects);
 		++pd->processed;
 		pd->cpu = cpumask_next_wrap(cpu, pd->cpumask.pcpu, -1, false);
 	}
@@ -336,7 +335,6 @@ void padata_do_serial(struct padata_priv *padata)
 		if (cur->seq_nr < padata->seq_nr)
 			break;
 	list_add(&padata->list, &cur->list);
-	atomic_inc(&pd->reorder_objects);
 	spin_unlock(&pqueue->reorder.lock);
 
 	/*
@@ -452,7 +450,6 @@ static struct parallel_data *padata_alloc_pd(struct padata_shell *ps)
 	padata_init_pqueues(pd);
 	padata_init_squeues(pd);
 	atomic_set(&pd->seq_nr, -1);
-	atomic_set(&pd->reorder_objects, 0);
 	atomic_set(&pd->refcnt, 1);
 	spin_lock_init(&pd->lock);
 	pd->cpu = cpumask_first(pd->cpumask.pcpu);
-- 
2.23.0


Return-Path: <SRS0=f4rb=ZZ=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 875F7C432C0
	for <linux-crypto@archiver.kernel.org>; Tue,  3 Dec 2019 19:31:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 53A4D20661
	for <linux-crypto@archiver.kernel.org>; Tue,  3 Dec 2019 19:31:46 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="qHouwnCQ"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727482AbfLCTbp (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 3 Dec 2019 14:31:45 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:35984 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727385AbfLCTbp (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 3 Dec 2019 14:31:45 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xB3JO6e5164854;
        Tue, 3 Dec 2019 19:31:36 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=corp-2019-08-05;
 bh=TpsYB1kPeZxPfSWEVgHYYY463BWwsahPEe4Ls8xV8pE=;
 b=qHouwnCQ/0pWc8RCWiAqRYRTy4SpX+R1r/nT8XpvUU/jYVhFBRGoJVHRNRrv3754D/2U
 lri2625EyTZFRnGymGHeMMtqsmSlTvqcuB22yc3OIqQ5XS2UFB3SZHb96PUwUjYPNmky
 fkDk0w2wkiCHEfPIahKyydxeTC3pS8Ax8PNXrsB44yt/NASTgvvSJojZuJnI4fkeOVhP
 4sUy9MlhJNkFNZgHf9qSdVi5c+5PBHljxZVGLAQEXmBxllUhU/au4Y1jf1bY4pZh084R
 dPw1C8qeGuKmLbnwUTVF9VV46e40VzjYmdyFU2XLZMiMYG11v10YS/kIJolThDbGL1wP UA== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2120.oracle.com with ESMTP id 2wkgcq9x9h-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 03 Dec 2019 19:31:36 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xB3JEjBa116728;
        Tue, 3 Dec 2019 19:31:36 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3020.oracle.com with ESMTP id 2wnb8102jn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 03 Dec 2019 19:31:35 +0000
Received: from abhmp0008.oracle.com (abhmp0008.oracle.com [141.146.116.14])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id xB3JVYOo025480;
        Tue, 3 Dec 2019 19:31:34 GMT
Received: from localhost.localdomain (/98.229.125.203)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 03 Dec 2019 11:31:34 -0800
From:   Daniel Jordan <daniel.m.jordan@oracle.com>
To:     Herbert Xu <herbert@gondor.apana.org.au>,
        Steffen Klassert <steffen.klassert@secunet.com>
Cc:     Eric Biggers <ebiggers@kernel.org>,
        Jonathan Corbet <corbet@lwn.net>, linux-crypto@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        Daniel Jordan <daniel.m.jordan@oracle.com>
Subject: [PATCH v2 4/5] padata: remove reorder_objects
Date:   Tue,  3 Dec 2019 14:31:13 -0500
Message-Id: <20191203193114.238912-5-daniel.m.jordan@oracle.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191203193114.238912-1-daniel.m.jordan@oracle.com>
References: <20191203193114.238912-1-daniel.m.jordan@oracle.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9460 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1911140001 definitions=main-1912030143
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9460 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1911140001
 definitions=main-1912030143
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
index 178d5cc6b494..faa2e36832f8 100644
--- a/include/linux/padata.h
+++ b/include/linux/padata.h
@@ -101,7 +101,6 @@ struct padata_cpumask {
  * @sh: padata_shell object.
  * @pqueue: percpu padata queues used for parallelization.
  * @squeue: percpu padata queues used for serialuzation.
- * @reorder_objects: Number of objects waiting in the reorder queues.
  * @refcnt: Number of objects holding a reference on this parallel_data.
  * @max_seq_nr:  Maximal used sequence number.
  * @processed: Number of already processed objects.
@@ -114,7 +113,6 @@ struct parallel_data {
 	struct padata_shell		*ps;
 	struct padata_parallel_queue	__percpu *pqueue;
 	struct padata_serial_queue	__percpu *squeue;
-	atomic_t			reorder_objects;
 	atomic_t			refcnt;
 	atomic_t			seq_nr;
 	unsigned int			processed;
diff --git a/kernel/padata.c b/kernel/padata.c
index c7edc6bf2bdc..2aaf677db85c 100644
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
@@ -455,7 +453,6 @@ static struct parallel_data *padata_alloc_pd(struct padata_shell *ps)
 	padata_init_pqueues(pd);
 	padata_init_squeues(pd);
 	atomic_set(&pd->seq_nr, -1);
-	atomic_set(&pd->reorder_objects, 0);
 	atomic_set(&pd->refcnt, 1);
 	spin_lock_init(&pd->lock);
 	pd->cpu = cpumask_first(pd->cpumask.pcpu);
-- 
2.24.0


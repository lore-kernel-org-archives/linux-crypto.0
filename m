Return-Path: <SRS0=vKog=AZ=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 62F3BC433E2
	for <linux-crypto@archiver.kernel.org>; Tue, 14 Jul 2020 20:16:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 384132076C
	for <linux-crypto@archiver.kernel.org>; Tue, 14 Jul 2020 20:16:10 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="qG3Xhrwi"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730340AbgGNUQJ (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 14 Jul 2020 16:16:09 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:57976 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729617AbgGNUQJ (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 14 Jul 2020 16:16:09 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 06EKD3UE097781;
        Tue, 14 Jul 2020 20:16:03 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=corp-2020-01-29;
 bh=GKZ07ZU8LV5s043fh4pCl0IkufVmPubx2VM55YqZHGI=;
 b=qG3Xhrwi5Ynd5OuLQOn0tt/qmamPhA9LA+wMU18AaFamb5dNHKdNKRnzPs+qRZ1+PV90
 EjeQKZtfBc6SGmr3vxABUXoiCrFpTrFQiIaKDeyZUU+LkNKetHPcS1tMYAuWQ0mSY3lg
 QPh8ALGguQN8OgF5nopXBhSAidqkdJBbEkF1//uo3gSY9qfQ1OtFRz5yiQKkA3XiXrTb
 Nj/BIK2vryj3oOvvuKpjc7rFF1OvKIk5SzzV+GERckZ2txMX/Bgh+2I2wQqtHbaKuTWs
 CC2gcwTmf5rl6jlw8EnQ9SONTWKaMjBrQsG6eixvtaHD8m1MdQh55CNBT8o8SPmUaYJ/ aQ== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2130.oracle.com with ESMTP id 3274ur7q68-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Tue, 14 Jul 2020 20:16:03 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 06EKCdNY155108;
        Tue, 14 Jul 2020 20:14:03 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userp3030.oracle.com with ESMTP id 327qbyc6rm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 14 Jul 2020 20:14:03 +0000
Received: from abhmp0003.oracle.com (abhmp0003.oracle.com [141.146.116.9])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 06EKE2nE003957;
        Tue, 14 Jul 2020 20:14:02 GMT
Received: from localhost.localdomain (/98.229.125.203)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 14 Jul 2020 13:14:02 -0700
From:   Daniel Jordan <daniel.m.jordan@oracle.com>
To:     Herbert Xu <herbert@gondor.apana.org.au>,
        Steffen Klassert <steffen.klassert@secunet.com>
Cc:     linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        Daniel Jordan <daniel.m.jordan@oracle.com>
Subject: [PATCH 4/6] padata: remove effective cpumasks from the instance
Date:   Tue, 14 Jul 2020 16:13:54 -0400
Message-Id: <20200714201356.889176-5-daniel.m.jordan@oracle.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200714201356.889176-1-daniel.m.jordan@oracle.com>
References: <20200714201356.889176-1-daniel.m.jordan@oracle.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9682 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=2 spamscore=0
 mlxlogscore=999 bulkscore=0 malwarescore=0 mlxscore=0 phishscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2007140141
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9682 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 lowpriorityscore=0 impostorscore=0
 suspectscore=2 phishscore=0 spamscore=0 mlxlogscore=999 malwarescore=0
 mlxscore=0 priorityscore=1501 adultscore=0 bulkscore=0 clxscore=1015
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2007140141
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

A padata instance has effective cpumasks that store the user-supplied
masks ANDed with the online mask, but this middleman is unnecessary.
parallel_data keeps the same information around.  Removing this saves
text and code churn in future changes.

Signed-off-by: Daniel Jordan <daniel.m.jordan@oracle.com>
Cc: Herbert Xu <herbert@gondor.apana.org.au>
Cc: Steffen Klassert <steffen.klassert@secunet.com>
Cc: linux-crypto@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
---
 include/linux/padata.h |  2 --
 kernel/padata.c        | 30 +++---------------------------
 2 files changed, 3 insertions(+), 29 deletions(-)

diff --git a/include/linux/padata.h b/include/linux/padata.h
index 7d53208b43daa..a941b96b7119e 100644
--- a/include/linux/padata.h
+++ b/include/linux/padata.h
@@ -167,7 +167,6 @@ struct padata_mt_job {
  * @serial_wq: The workqueue used for serial work.
  * @pslist: List of padata_shell objects attached to this instance.
  * @cpumask: User supplied cpumasks for parallel and serial works.
- * @rcpumask: Actual cpumasks based on user cpumask and cpu_online_mask.
  * @kobj: padata instance kernel object.
  * @lock: padata instance lock.
  * @flags: padata flags.
@@ -179,7 +178,6 @@ struct padata_instance {
 	struct workqueue_struct		*serial_wq;
 	struct list_head		pslist;
 	struct padata_cpumask		cpumask;
-	struct padata_cpumask		rcpumask;
 	struct kobject                   kobj;
 	struct mutex			 lock;
 	u8				 flags;
diff --git a/kernel/padata.c b/kernel/padata.c
index 27f90a3c4dc6b..4f0a57e5738c9 100644
--- a/kernel/padata.c
+++ b/kernel/padata.c
@@ -571,13 +571,8 @@ static void padata_init_pqueues(struct parallel_data *pd)
 static struct parallel_data *padata_alloc_pd(struct padata_shell *ps)
 {
 	struct padata_instance *pinst = ps->pinst;
-	const struct cpumask *cbcpumask;
-	const struct cpumask *pcpumask;
 	struct parallel_data *pd;
 
-	cbcpumask = pinst->rcpumask.cbcpu;
-	pcpumask = pinst->rcpumask.pcpu;
-
 	pd = kzalloc(sizeof(struct parallel_data), GFP_KERNEL);
 	if (!pd)
 		goto err;
@@ -597,8 +592,8 @@ static struct parallel_data *padata_alloc_pd(struct padata_shell *ps)
 	if (!alloc_cpumask_var(&pd->cpumask.cbcpu, GFP_KERNEL))
 		goto err_free_pcpu;
 
-	cpumask_copy(pd->cpumask.pcpu, pcpumask);
-	cpumask_copy(pd->cpumask.cbcpu, cbcpumask);
+	cpumask_and(pd->cpumask.pcpu, pinst->cpumask.pcpu, cpu_online_mask);
+	cpumask_and(pd->cpumask.cbcpu, pinst->cpumask.cbcpu, cpu_online_mask);
 
 	padata_init_pqueues(pd);
 	padata_init_squeues(pd);
@@ -668,12 +663,6 @@ static int padata_replace(struct padata_instance *pinst)
 
 	pinst->flags |= PADATA_RESET;
 
-	cpumask_and(pinst->rcpumask.pcpu, pinst->cpumask.pcpu,
-		    cpu_online_mask);
-
-	cpumask_and(pinst->rcpumask.cbcpu, pinst->cpumask.cbcpu,
-		    cpu_online_mask);
-
 	list_for_each_entry(ps, &pinst->pslist, list) {
 		err = padata_replace_one(ps);
 		if (err)
@@ -856,8 +845,6 @@ static void __padata_free(struct padata_instance *pinst)
 
 	WARN_ON(!list_empty(&pinst->pslist));
 
-	free_cpumask_var(pinst->rcpumask.cbcpu);
-	free_cpumask_var(pinst->rcpumask.pcpu);
 	free_cpumask_var(pinst->cpumask.pcpu);
 	free_cpumask_var(pinst->cpumask.cbcpu);
 	destroy_workqueue(pinst->serial_wq);
@@ -1033,20 +1020,13 @@ static struct padata_instance *padata_alloc(const char *name,
 	    !padata_validate_cpumask(pinst, cbcpumask))
 		goto err_free_masks;
 
-	if (!alloc_cpumask_var(&pinst->rcpumask.pcpu, GFP_KERNEL))
-		goto err_free_masks;
-	if (!alloc_cpumask_var(&pinst->rcpumask.cbcpu, GFP_KERNEL))
-		goto err_free_rcpumask_pcpu;
-
 	INIT_LIST_HEAD(&pinst->pslist);
 
 	cpumask_copy(pinst->cpumask.pcpu, pcpumask);
 	cpumask_copy(pinst->cpumask.cbcpu, cbcpumask);
-	cpumask_and(pinst->rcpumask.pcpu, pcpumask, cpu_online_mask);
-	cpumask_and(pinst->rcpumask.cbcpu, cbcpumask, cpu_online_mask);
 
 	if (padata_setup_cpumasks(pinst))
-		goto err_free_rcpumask_cbcpu;
+		goto err_free_masks;
 
 	__padata_start(pinst);
 
@@ -1064,10 +1044,6 @@ static struct padata_instance *padata_alloc(const char *name,
 
 	return pinst;
 
-err_free_rcpumask_cbcpu:
-	free_cpumask_var(pinst->rcpumask.cbcpu);
-err_free_rcpumask_pcpu:
-	free_cpumask_var(pinst->rcpumask.pcpu);
 err_free_masks:
 	free_cpumask_var(pinst->cpumask.pcpu);
 	free_cpumask_var(pinst->cpumask.cbcpu);
-- 
2.27.0


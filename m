Return-Path: <SRS0=g3pl=VW=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 94641C76190
	for <linux-crypto@archiver.kernel.org>; Thu, 25 Jul 2019 21:26:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5A4C322BF5
	for <linux-crypto@archiver.kernel.org>; Thu, 25 Jul 2019 21:26:20 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="zP1QNB+U"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726743AbfGYVZo (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 25 Jul 2019 17:25:44 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:54506 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726661AbfGYVZo (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 25 Jul 2019 17:25:44 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x6PLNdkg028646;
        Thu, 25 Jul 2019 21:25:26 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=corp-2018-07-02;
 bh=AJiP0iTdg+rd/PVSUExxy3SceM2IZcGotnRPdBNftwQ=;
 b=zP1QNB+UQrsQ7zo43wV/QdCoHDlaH3QPKUlVevHfW1DAfmB9a4HSu9czCus/Bq76snt/
 L95YmI2CQZNa1WfyPLE9s54geVo8y/Skqda8SMw+sppouZkgMCzsmnkVPKRng364jajg
 v7epG8JJjkdgDVrm/3Py3TKAuBOjoyHNIDIMQmv5CL0SGRpLGN1F1uEDv8zxGp3tA2cm
 B51YDE9f9CbTSpqZVA+NPHm3GSHFWjE1fRl1Kfo2wVMrU2PoBdazpkGtQSoSV0Hgy3A2
 3WNS5zu/jAOxn5ztbagOGFQKdohEfbySArNxxIJtIJU54YGnReFiCTNKdPYsYWnwSQ6l SA== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2130.oracle.com with ESMTP id 2tx61c6mey-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 25 Jul 2019 21:25:26 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x6PLNCd9187750;
        Thu, 25 Jul 2019 21:25:25 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserp3030.oracle.com with ESMTP id 2tx60y2aka-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 25 Jul 2019 21:25:25 +0000
Received: from abhmp0015.oracle.com (abhmp0015.oracle.com [141.146.116.21])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x6PLPIVI030869;
        Thu, 25 Jul 2019 21:25:23 GMT
Received: from localhost.localdomain (/73.60.114.248)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 25 Jul 2019 14:25:18 -0700
From:   Daniel Jordan <daniel.m.jordan@oracle.com>
To:     Steffen Klassert <steffen.klassert@secunet.com>,
        Herbert Xu <herbert@gondor.apana.org.au>
Cc:     Tejun Heo <tj@kernel.org>, Lai Jiangshan <jiangshanlai@gmail.com>,
        Peter Zijlstra <peterz@infradead.org>,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        Daniel Jordan <daniel.m.jordan@oracle.com>
Subject: [RFC 1/9] padata: allocate workqueue internally
Date:   Thu, 25 Jul 2019 17:24:57 -0400
Message-Id: <20190725212505.15055-2-daniel.m.jordan@oracle.com>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190725212505.15055-1-daniel.m.jordan@oracle.com>
References: <20190725212505.15055-1-daniel.m.jordan@oracle.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9329 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=2 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1906280000 definitions=main-1907250257
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9329 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=2 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1906280000
 definitions=main-1907250257
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Move workqueue allocation inside of padata to prepare for further
changes to how padata uses workqueues.

Guarantees the workqueue is created with max_active=1, which padata
relies on to work correctly.  No functional change.

Signed-off-by: Daniel Jordan <daniel.m.jordan@oracle.com>
---
 Documentation/padata.txt | 12 ++++++------
 crypto/pcrypt.c          | 13 ++-----------
 include/linux/padata.h   |  3 +--
 kernel/padata.c          | 24 +++++++++++++++---------
 4 files changed, 24 insertions(+), 28 deletions(-)

diff --git a/Documentation/padata.txt b/Documentation/padata.txt
index b103d0c82000..b37ba1eaace3 100644
--- a/Documentation/padata.txt
+++ b/Documentation/padata.txt
@@ -16,10 +16,12 @@ overall control of how tasks are to be run::
 
     #include <linux/padata.h>
 
-    struct padata_instance *padata_alloc(struct workqueue_struct *wq,
+    struct padata_instance *padata_alloc(const char *name,
 					 const struct cpumask *pcpumask,
 					 const struct cpumask *cbcpumask);
 
+'name' simply identifies the instance.
+
 The pcpumask describes which processors will be used to execute work
 submitted to this instance in parallel. The cbcpumask defines which
 processors are allowed to be used as the serialization callback processor.
@@ -128,8 +130,7 @@ in that CPU mask or about a not running instance.
 
 Each task submitted to padata_do_parallel() will, in turn, be passed to
 exactly one call to the above-mentioned parallel() function, on one CPU, so
-true parallelism is achieved by submitting multiple tasks.  Despite the
-fact that the workqueue is used to make these calls, parallel() is run with
+true parallelism is achieved by submitting multiple tasks.  parallel() runs with
 software interrupts disabled and thus cannot sleep.  The parallel()
 function gets the padata_priv structure pointer as its lone parameter;
 information about the actual work to be done is probably obtained by using
@@ -148,7 +149,7 @@ fact with a call to::
 At some point in the future, padata_do_serial() will trigger a call to the
 serial() function in the padata_priv structure.  That call will happen on
 the CPU requested in the initial call to padata_do_parallel(); it, too, is
-done through the workqueue, but with local software interrupts disabled.
+run with local software interrupts disabled.
 Note that this call may be deferred for a while since the padata code takes
 pains to ensure that tasks are completed in the order in which they were
 submitted.
@@ -159,5 +160,4 @@ when a padata instance is no longer needed::
     void padata_free(struct padata_instance *pinst);
 
 This function will busy-wait while any remaining tasks are completed, so it
-might be best not to call it while there is work outstanding.  Shutting
-down the workqueue, if necessary, should be done separately.
+might be best not to call it while there is work outstanding.
diff --git a/crypto/pcrypt.c b/crypto/pcrypt.c
index 0edf5b54fc77..d67293063c7f 100644
--- a/crypto/pcrypt.c
+++ b/crypto/pcrypt.c
@@ -20,7 +20,6 @@
 
 struct padata_pcrypt {
 	struct padata_instance *pinst;
-	struct workqueue_struct *wq;
 
 	/*
 	 * Cpumask for callback CPUs. It should be
@@ -397,14 +396,9 @@ static int pcrypt_init_padata(struct padata_pcrypt *pcrypt,
 
 	get_online_cpus();
 
-	pcrypt->wq = alloc_workqueue("%s", WQ_MEM_RECLAIM | WQ_CPU_INTENSIVE,
-				     1, name);
-	if (!pcrypt->wq)
-		goto err;
-
-	pcrypt->pinst = padata_alloc_possible(pcrypt->wq);
+	pcrypt->pinst = padata_alloc_possible(name);
 	if (!pcrypt->pinst)
-		goto err_destroy_workqueue;
+		goto err;
 
 	mask = kmalloc(sizeof(*mask), GFP_KERNEL);
 	if (!mask)
@@ -437,8 +431,6 @@ static int pcrypt_init_padata(struct padata_pcrypt *pcrypt,
 	kfree(mask);
 err_free_padata:
 	padata_free(pcrypt->pinst);
-err_destroy_workqueue:
-	destroy_workqueue(pcrypt->wq);
 err:
 	put_online_cpus();
 
@@ -452,7 +444,6 @@ static void pcrypt_fini_padata(struct padata_pcrypt *pcrypt)
 
 	padata_stop(pcrypt->pinst);
 	padata_unregister_cpumask_notifier(pcrypt->pinst, &pcrypt->nblock);
-	destroy_workqueue(pcrypt->wq);
 	padata_free(pcrypt->pinst);
 }
 
diff --git a/include/linux/padata.h b/include/linux/padata.h
index 8da673861d99..839d9319920a 100644
--- a/include/linux/padata.h
+++ b/include/linux/padata.h
@@ -151,8 +151,7 @@ struct padata_instance {
 #define	PADATA_INVALID	4
 };
 
-extern struct padata_instance *padata_alloc_possible(
-					struct workqueue_struct *wq);
+extern struct padata_instance *padata_alloc_possible(const char *name);
 extern void padata_free(struct padata_instance *pinst);
 extern int padata_do_parallel(struct padata_instance *pinst,
 			      struct padata_priv *padata, int cb_cpu);
diff --git a/kernel/padata.c b/kernel/padata.c
index 7372fb45eeeb..5ae815adf0de 100644
--- a/kernel/padata.c
+++ b/kernel/padata.c
@@ -805,6 +805,7 @@ static void __padata_free(struct padata_instance *pinst)
 	padata_free_pd(pinst->pd);
 	free_cpumask_var(pinst->cpumask.pcpu);
 	free_cpumask_var(pinst->cpumask.cbcpu);
+	destroy_workqueue(pinst->wq);
 	kfree(pinst);
 }
 
@@ -938,13 +939,13 @@ static struct kobj_type padata_attr_type = {
  * padata_alloc - allocate and initialize a padata instance and specify
  *                cpumasks for serial and parallel workers.
  *
- * @wq: workqueue to use for the allocated padata instance
+ * @name: used to identify the instance
  * @pcpumask: cpumask that will be used for padata parallelization
  * @cbcpumask: cpumask that will be used for padata serialization
  *
  * Must be called from a cpus_read_lock() protected region
  */
-static struct padata_instance *padata_alloc(struct workqueue_struct *wq,
+static struct padata_instance *padata_alloc(const char *name,
 					    const struct cpumask *pcpumask,
 					    const struct cpumask *cbcpumask)
 {
@@ -955,11 +956,16 @@ static struct padata_instance *padata_alloc(struct workqueue_struct *wq,
 	if (!pinst)
 		goto err;
 
-	if (!alloc_cpumask_var(&pinst->cpumask.pcpu, GFP_KERNEL))
+	pinst->wq = alloc_workqueue("%s", WQ_MEM_RECLAIM | WQ_CPU_INTENSIVE,
+				    1, name);
+	if (!pinst->wq)
 		goto err_free_inst;
+
+	if (!alloc_cpumask_var(&pinst->cpumask.pcpu, GFP_KERNEL))
+		goto err_free_wq;
 	if (!alloc_cpumask_var(&pinst->cpumask.cbcpu, GFP_KERNEL)) {
 		free_cpumask_var(pinst->cpumask.pcpu);
-		goto err_free_inst;
+		goto err_free_wq;
 	}
 	if (!padata_validate_cpumask(pinst, pcpumask) ||
 	    !padata_validate_cpumask(pinst, cbcpumask))
@@ -971,8 +977,6 @@ static struct padata_instance *padata_alloc(struct workqueue_struct *wq,
 
 	rcu_assign_pointer(pinst->pd, pd);
 
-	pinst->wq = wq;
-
 	cpumask_copy(pinst->cpumask.pcpu, pcpumask);
 	cpumask_copy(pinst->cpumask.cbcpu, cbcpumask);
 
@@ -990,6 +994,8 @@ static struct padata_instance *padata_alloc(struct workqueue_struct *wq,
 err_free_masks:
 	free_cpumask_var(pinst->cpumask.pcpu);
 	free_cpumask_var(pinst->cpumask.cbcpu);
+err_free_wq:
+	destroy_workqueue(pinst->wq);
 err_free_inst:
 	kfree(pinst);
 err:
@@ -1001,14 +1007,14 @@ static struct padata_instance *padata_alloc(struct workqueue_struct *wq,
  *                         Use the cpu_possible_mask for serial and
  *                         parallel workers.
  *
- * @wq: workqueue to use for the allocated padata instance
+ * @name: used to identify the instance
  *
  * Must be called from a cpus_read_lock() protected region
  */
-struct padata_instance *padata_alloc_possible(struct workqueue_struct *wq)
+struct padata_instance *padata_alloc_possible(const char *name)
 {
 	lockdep_assert_cpus_held();
-	return padata_alloc(wq, cpu_possible_mask, cpu_possible_mask);
+	return padata_alloc(name, cpu_possible_mask, cpu_possible_mask);
 }
 EXPORT_SYMBOL(padata_alloc_possible);
 
-- 
2.22.0


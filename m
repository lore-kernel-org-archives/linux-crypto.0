Return-Path: <SRS0=f4rb=ZZ=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E1E48C43141
	for <linux-crypto@archiver.kernel.org>; Tue,  3 Dec 2019 19:32:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9A1D2206DF
	for <linux-crypto@archiver.kernel.org>; Tue,  3 Dec 2019 19:32:09 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="TBskjUrY"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727490AbfLCTbq (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 3 Dec 2019 14:31:46 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:35982 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726932AbfLCTbp (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 3 Dec 2019 14:31:45 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xB3JOXql165089;
        Tue, 3 Dec 2019 19:31:36 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=corp-2019-08-05;
 bh=2RcmPjALvagxWs1Ppbdn1xJGpWcRXR7pQqICREkhFKo=;
 b=TBskjUrYUkLst5ZJ8EiqqxoGf4p/uinx/wuym7PSCNFGBQkYlcO+WBDKeBiVDmXR0Fa5
 o5cJUDi6f9GlOC4mHoLIbnofnIiP/YvGMDMAA1llMjk+6kZWUClm5tUpdYOwLmRqOjAV
 FANwzlYvuq718t22kDr3e1z6Q9OUGvoOZB2ADee3uEN04nv0pxIesJpPRBn5L8h+qo15
 o733TV1CIS4DNrF6wC35EYO33OgxMm+bbQ27oQbqITuWKyv/yFKSN0Cv+lrvfAz06db+
 EItOUmkCCdFMYzfLLMksWOi3OEseKOQcK3l7kl3469ADmyyKp74QxCfMMUfzqN7zwowt Xg== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2120.oracle.com with ESMTP id 2wkgcq9x9e-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 03 Dec 2019 19:31:36 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xB3JEkmL116814;
        Tue, 3 Dec 2019 19:31:35 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserp3020.oracle.com with ESMTP id 2wnb8102ex-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 03 Dec 2019 19:31:35 +0000
Received: from abhmp0008.oracle.com (abhmp0008.oracle.com [141.146.116.14])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id xB3JVXp6010079;
        Tue, 3 Dec 2019 19:31:33 GMT
Received: from localhost.localdomain (/98.229.125.203)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 03 Dec 2019 11:31:33 -0800
From:   Daniel Jordan <daniel.m.jordan@oracle.com>
To:     Herbert Xu <herbert@gondor.apana.org.au>,
        Steffen Klassert <steffen.klassert@secunet.com>
Cc:     Eric Biggers <ebiggers@kernel.org>,
        Jonathan Corbet <corbet@lwn.net>, linux-crypto@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        Daniel Jordan <daniel.m.jordan@oracle.com>
Subject: [PATCH v2 3/5] padata: remove cpumask change notifier
Date:   Tue,  3 Dec 2019 14:31:12 -0500
Message-Id: <20191203193114.238912-4-daniel.m.jordan@oracle.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191203193114.238912-1-daniel.m.jordan@oracle.com>
References: <20191203193114.238912-1-daniel.m.jordan@oracle.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9460 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=2 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1911140001 definitions=main-1912030143
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9460 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=2 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1911140001
 definitions=main-1912030143
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Since commit 63d3578892dc ("crypto: pcrypt - remove padata cpumask
notifier") this feature is unused, so get rid of it.

Signed-off-by: Daniel Jordan <daniel.m.jordan@oracle.com>
Cc: Eric Biggers <ebiggers@kernel.org>
Cc: Herbert Xu <herbert@gondor.apana.org.au>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Steffen Klassert <steffen.klassert@secunet.com>
Cc: linux-crypto@vger.kernel.org
Cc: linux-doc@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
---
 Documentation/padata.txt | 24 -------------------
 crypto/pcrypt.c          |  1 -
 include/linux/padata.h   | 11 ---------
 kernel/padata.c          | 52 +---------------------------------------
 4 files changed, 1 insertion(+), 87 deletions(-)

diff --git a/Documentation/padata.txt b/Documentation/padata.txt
index b37ba1eaace3..b45df9c6547b 100644
--- a/Documentation/padata.txt
+++ b/Documentation/padata.txt
@@ -75,30 +75,6 @@ To simply add or remove one CPU from a certain cpumask the functions
 padata_add_cpu/padata_remove_cpu are used. cpu specifies the CPU to add or
 remove and mask is one of PADATA_CPU_SERIAL, PADATA_CPU_PARALLEL.
 
-If a user is interested in padata cpumask changes, he can register to
-the padata cpumask change notifier::
-
-    int padata_register_cpumask_notifier(struct padata_instance *pinst,
-					 struct notifier_block *nblock);
-
-To unregister from that notifier::
-
-    int padata_unregister_cpumask_notifier(struct padata_instance *pinst,
-					   struct notifier_block *nblock);
-
-The padata cpumask change notifier notifies about changes of the usable
-cpumasks, i.e. the subset of active CPUs in the user supplied cpumask.
-
-Padata calls the notifier chain with::
-
-    blocking_notifier_call_chain(&pinst->cpumask_change_notifier,
-				 notification_mask,
-				 &pd_new->cpumask);
-
-Here cpumask_change_notifier is registered notifier, notification_mask
-is one of PADATA_CPU_SERIAL, PADATA_CPU_PARALLEL and cpumask is a pointer
-to a struct padata_cpumask that contains the new cpumask information.
-
 Actually submitting work to the padata instance requires the creation of a
 padata_priv structure::
 
diff --git a/crypto/pcrypt.c b/crypto/pcrypt.c
index a4f3b3f342c8..d6696e217128 100644
--- a/crypto/pcrypt.c
+++ b/crypto/pcrypt.c
@@ -13,7 +13,6 @@
 #include <linux/init.h>
 #include <linux/module.h>
 #include <linux/slab.h>
-#include <linux/notifier.h>
 #include <linux/kobject.h>
 #include <linux/cpu.h>
 #include <crypto/pcrypt.h>
diff --git a/include/linux/padata.h b/include/linux/padata.h
index cccab7a59787..178d5cc6b494 100644
--- a/include/linux/padata.h
+++ b/include/linux/padata.h
@@ -13,7 +13,6 @@
 #include <linux/workqueue.h>
 #include <linux/spinlock.h>
 #include <linux/list.h>
-#include <linux/notifier.h>
 #include <linux/kobject.h>
 
 #define PADATA_CPU_SERIAL   0x01
@@ -151,10 +150,6 @@ struct padata_shell {
  * @pslist: List of padata_shell objects attached to this instance.
  * @cpumask: User supplied cpumasks for parallel and serial works.
  * @rcpumask: Actual cpumasks based on user cpumask and cpu_online_mask.
- * @omask: Temporary storage used to compute the notification mask.
- * @cpumask_change_notifier: Notifiers chain for user-defined notify
- *            callbacks that will be called when either @pcpu or @cbcpu
- *            or both cpumasks change.
  * @kobj: padata instance kernel object.
  * @lock: padata instance lock.
  * @flags: padata flags.
@@ -166,8 +161,6 @@ struct padata_instance {
 	struct list_head		pslist;
 	struct padata_cpumask		cpumask;
 	struct padata_cpumask		rcpumask;
-	cpumask_var_t			omask;
-	struct blocking_notifier_head	 cpumask_change_notifier;
 	struct kobject                   kobj;
 	struct mutex			 lock;
 	u8				 flags;
@@ -187,8 +180,4 @@ extern int padata_set_cpumask(struct padata_instance *pinst, int cpumask_type,
 			      cpumask_var_t cpumask);
 extern int padata_start(struct padata_instance *pinst);
 extern void padata_stop(struct padata_instance *pinst);
-extern int padata_register_cpumask_notifier(struct padata_instance *pinst,
-					    struct notifier_block *nblock);
-extern int padata_unregister_cpumask_notifier(struct padata_instance *pinst,
-					      struct notifier_block *nblock);
 #endif
diff --git a/kernel/padata.c b/kernel/padata.c
index 2f8db63aefc4..c7edc6bf2bdc 100644
--- a/kernel/padata.c
+++ b/kernel/padata.c
@@ -514,23 +514,16 @@ static int padata_replace_one(struct padata_shell *ps)
 
 static int padata_replace(struct padata_instance *pinst)
 {
-	int notification_mask = 0;
 	struct padata_shell *ps;
 	int err;
 
 	pinst->flags |= PADATA_RESET;
 
-	cpumask_copy(pinst->omask, pinst->rcpumask.pcpu);
 	cpumask_and(pinst->rcpumask.pcpu, pinst->cpumask.pcpu,
 		    cpu_online_mask);
-	if (!cpumask_equal(pinst->omask, pinst->rcpumask.pcpu))
-		notification_mask |= PADATA_CPU_PARALLEL;
 
-	cpumask_copy(pinst->omask, pinst->rcpumask.cbcpu);
 	cpumask_and(pinst->rcpumask.cbcpu, pinst->cpumask.cbcpu,
 		    cpu_online_mask);
-	if (!cpumask_equal(pinst->omask, pinst->rcpumask.cbcpu))
-		notification_mask |= PADATA_CPU_SERIAL;
 
 	list_for_each_entry(ps, &pinst->pslist, list) {
 		err = padata_replace_one(ps);
@@ -544,48 +537,11 @@ static int padata_replace(struct padata_instance *pinst)
 		if (atomic_dec_and_test(&ps->opd->refcnt))
 			padata_free_pd(ps->opd);
 
-	if (notification_mask)
-		blocking_notifier_call_chain(&pinst->cpumask_change_notifier,
-					     notification_mask,
-					     &pinst->cpumask);
-
 	pinst->flags &= ~PADATA_RESET;
 
 	return err;
 }
 
-/**
- * padata_register_cpumask_notifier - Registers a notifier that will be called
- *                             if either pcpu or cbcpu or both cpumasks change.
- *
- * @pinst: A poineter to padata instance
- * @nblock: A pointer to notifier block.
- */
-int padata_register_cpumask_notifier(struct padata_instance *pinst,
-				     struct notifier_block *nblock)
-{
-	return blocking_notifier_chain_register(&pinst->cpumask_change_notifier,
-						nblock);
-}
-EXPORT_SYMBOL(padata_register_cpumask_notifier);
-
-/**
- * padata_unregister_cpumask_notifier - Unregisters cpumask notifier
- *        registered earlier  using padata_register_cpumask_notifier
- *
- * @pinst: A pointer to data instance.
- * @nlock: A pointer to notifier block.
- */
-int padata_unregister_cpumask_notifier(struct padata_instance *pinst,
-				       struct notifier_block *nblock)
-{
-	return blocking_notifier_chain_unregister(
-		&pinst->cpumask_change_notifier,
-		nblock);
-}
-EXPORT_SYMBOL(padata_unregister_cpumask_notifier);
-
-
 /* If cpumask contains no active cpu, we mark the instance as invalid. */
 static bool padata_validate_cpumask(struct padata_instance *pinst,
 				    const struct cpumask *cpumask)
@@ -785,7 +741,6 @@ static void __padata_free(struct padata_instance *pinst)
 	WARN_ON(!list_empty(&pinst->pslist));
 
 	padata_stop(pinst);
-	free_cpumask_var(pinst->omask);
 	free_cpumask_var(pinst->rcpumask.cbcpu);
 	free_cpumask_var(pinst->rcpumask.pcpu);
 	free_cpumask_var(pinst->cpumask.pcpu);
@@ -965,8 +920,6 @@ static struct padata_instance *padata_alloc(const char *name,
 		goto err_free_masks;
 	if (!alloc_cpumask_var(&pinst->rcpumask.cbcpu, GFP_KERNEL))
 		goto err_free_rcpumask_pcpu;
-	if (!alloc_cpumask_var(&pinst->omask, GFP_KERNEL))
-		goto err_free_rcpumask_cbcpu;
 
 	INIT_LIST_HEAD(&pinst->pslist);
 
@@ -976,11 +929,10 @@ static struct padata_instance *padata_alloc(const char *name,
 	cpumask_and(pinst->rcpumask.cbcpu, cbcpumask, cpu_online_mask);
 
 	if (padata_setup_cpumasks(pinst))
-		goto err_free_omask;
+		goto err_free_rcpumask_cbcpu;
 
 	pinst->flags = 0;
 
-	BLOCKING_INIT_NOTIFIER_HEAD(&pinst->cpumask_change_notifier);
 	kobject_init(&pinst->kobj, &padata_attr_type);
 	mutex_init(&pinst->lock);
 
@@ -994,8 +946,6 @@ static struct padata_instance *padata_alloc(const char *name,
 
 	return pinst;
 
-err_free_omask:
-	free_cpumask_var(pinst->omask);
 err_free_rcpumask_cbcpu:
 	free_cpumask_var(pinst->rcpumask.cbcpu);
 err_free_rcpumask_pcpu:
-- 
2.24.0


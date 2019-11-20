Return-Path: <SRS0=IkvS=ZM=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9263FC432C3
	for <linux-crypto@archiver.kernel.org>; Wed, 20 Nov 2019 18:58:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6BBB82068E
	for <linux-crypto@archiver.kernel.org>; Wed, 20 Nov 2019 18:58:54 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="YuMXm3au"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727450AbfKTS6x (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 20 Nov 2019 13:58:53 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:55926 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726440AbfKTS6x (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 20 Nov 2019 13:58:53 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xAKIs6Y5015731;
        Wed, 20 Nov 2019 18:58:38 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=corp-2019-08-05;
 bh=Mh9tB57Nnn4lghxLTxDkHxWWjco2T6GOaUVCFch00nk=;
 b=YuMXm3auSfkO2dwqcc4qon9Ubxx75dOaDdyiKUpbXZJSia0tJz3f28Eh7RPs1M8o5zDG
 vsx69TEh0PC/a5KaP3y+xgpLcp4KawZNTrtA0M5zZp3Azsgcr9ssMNnvJoGLflKX8Yjz
 Z3aKie4n6vKFsBSyK5C1FJqcXAHwVpuA+/cRs47TFWxxf1M7rYAQwHgtZ2zYNz16Dk2o
 JUePqI91Kjc+qe8Ji1tbQsT2CiiPHpWjNxEj9MUvFxBJHkhs2T4rwyHuYcd67eVEG8Zd
 OGhgyeVs+zESedX66feGrWkTHQNlMzUijcYq0YBQjiJrLcXZ+Nb7m7srd48HG6+r1a50 TA== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by aserp2120.oracle.com with ESMTP id 2wa92pyhbk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 20 Nov 2019 18:58:38 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xAKIs4Tf165866;
        Wed, 20 Nov 2019 18:56:37 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userp3030.oracle.com with ESMTP id 2wda04knm6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 20 Nov 2019 18:56:37 +0000
Received: from abhmp0018.oracle.com (abhmp0018.oracle.com [141.146.116.24])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id xAKIuad3014913;
        Wed, 20 Nov 2019 18:56:36 GMT
Received: from zissou.us.oracle.com (/10.152.34.58)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 20 Nov 2019 10:56:36 -0800
From:   Daniel Jordan <daniel.m.jordan@oracle.com>
To:     Herbert Xu <herbert@gondor.apana.org.au>,
        Steffen Klassert <steffen.klassert@secunet.com>
Cc:     Eric Biggers <ebiggers@kernel.org>, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Daniel Jordan <daniel.m.jordan@oracle.com>,
        Jonathan Corbet <corbet@lwn.net>, linux-doc@vger.kernel.org
Subject: [PATCH 4/4] padata: remove cpumask change notifier
Date:   Wed, 20 Nov 2019 13:54:12 -0500
Message-Id: <20191120185412.302-5-daniel.m.jordan@oracle.com>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191120185412.302-1-daniel.m.jordan@oracle.com>
References: <20191120185412.302-1-daniel.m.jordan@oracle.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9447 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=2 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1911140001 definitions=main-1911200156
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9447 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=2 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1911140001
 definitions=main-1911200156
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Since commit 63d3578892dc ("crypto: pcrypt - remove padata cpumask
notifier") this feature is unused and may deliver unexpected data with
the introduction of struct padata_shell (a notification mask that
includes -ENOMEM), so get rid of it.

Signed-off-by: Daniel Jordan <daniel.m.jordan@oracle.com>
Cc: Eric Biggers <ebiggers@kernel.org>
Cc: Herbert Xu <herbert@gondor.apana.org.au>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Steffen Klassert <steffen.klassert@secunet.com>
Cc: linux-crypto@vger.kernel.org
Cc: linux-doc@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
---
 Documentation/padata.txt | 24 ------------------
 crypto/pcrypt.c          |  1 -
 include/linux/padata.h   | 10 --------
 kernel/padata.c          | 53 +++-------------------------------------
 4 files changed, 3 insertions(+), 85 deletions(-)

diff --git a/Documentation/padata.txt b/Documentation/padata.txt
index a03afb1588f9..82e42dbaab65 100644
--- a/Documentation/padata.txt
+++ b/Documentation/padata.txt
@@ -74,30 +74,6 @@ padata_set_cpumask is used to change just one of the cpumasks. Here cpumask_type
 is one of PADATA_CPU_SERIAL or PADATA_CPU_PARALLEL, and cpumask specifies the
 new cpumask to use.
 
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
index 3e026e7a7e75..af60016d25c4 100644
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
index 9e0be23bd9ff..efdd0b129c53 100644
--- a/include/linux/padata.h
+++ b/include/linux/padata.h
@@ -13,7 +13,6 @@
 #include <linux/workqueue.h>
 #include <linux/spinlock.h>
 #include <linux/list.h>
-#include <linux/notifier.h>
 #include <linux/kobject.h>
 
 #define PADATA_CPU_SERIAL   0x01
@@ -141,14 +140,10 @@ struct padata_shell {
 /**
  * struct padata_instance - The overall control structure.
  *
- * @cpu_notifier: cpu hotplug notifier.
  * @parallel_wq: The workqueue used for parallel work.
  * @serial_wq: The workqueue used for serial work.
  * @pslist: List of padata_shell objects attached to this instance.
  * @cpumask: User supplied cpumasks for parallel and serial works.
- * @cpumask_change_notifier: Notifiers chain for user-defined notify
- *            callbacks that will be called when either @pcpu or @cbcpu
- *            or both cpumasks change.
  * @kobj: padata instance kernel object.
  * @lock: padata instance lock.
  * @flags: padata flags.
@@ -159,7 +154,6 @@ struct padata_instance {
 	struct workqueue_struct		*serial_wq;
 	struct list_head		pslist;
 	struct padata_cpumask		cpumask;
-	struct blocking_notifier_head	 cpumask_change_notifier;
 	struct kobject                   kobj;
 	struct mutex			 lock;
 	u8				 flags;
@@ -179,8 +173,4 @@ extern int padata_set_cpumask(struct padata_instance *pinst, int cpumask_type,
 			      cpumask_var_t cpumask);
 extern int padata_start(struct padata_instance *pinst);
 extern void padata_stop(struct padata_instance *pinst);
-extern int padata_register_cpumask_notifier(struct padata_instance *pinst,
-					    struct notifier_block *nblock);
-extern int padata_unregister_cpumask_notifier(struct padata_instance *pinst,
-					      struct notifier_block *nblock);
 #endif
diff --git a/kernel/padata.c b/kernel/padata.c
index cd9ae6822460..7305e81b9bee 100644
--- a/kernel/padata.c
+++ b/kernel/padata.c
@@ -492,81 +492,35 @@ static void __padata_stop(struct padata_instance *pinst)
 }
 
 /* Replace the internal control structure with a new one. */
-static int padata_replace_one(struct padata_shell *ps)
+static void padata_replace_one(struct padata_shell *ps)
 {
 	struct parallel_data *pd_old = rcu_dereference_protected(ps->pd, 1);
 	struct parallel_data *pd_new;
-	int notification_mask = 0;
 
 	pd_new = padata_alloc_pd(ps);
 	if (!pd_new)
-		return -ENOMEM;
+		return;
 
 	rcu_assign_pointer(ps->pd, pd_new);
 
-	if (!cpumask_equal(pd_old->cpumask.pcpu, pd_new->cpumask.pcpu))
-		notification_mask |= PADATA_CPU_PARALLEL;
-	if (!cpumask_equal(pd_old->cpumask.cbcpu, pd_new->cpumask.cbcpu))
-		notification_mask |= PADATA_CPU_SERIAL;
-
 	if (atomic_dec_and_test(&pd_old->refcnt))
 		padata_free_pd(pd_old);
-
-	return notification_mask;
 }
 
 static void padata_replace(struct padata_instance *pinst)
 {
-	int notification_mask = 0;
 	struct padata_shell *ps;
 
 	pinst->flags |= PADATA_RESET;
 
 	list_for_each_entry(ps, &pinst->pslist, list)
-		notification_mask |= padata_replace_one(ps);
+		padata_replace_one(ps);
 
 	synchronize_rcu();
 
-	if (notification_mask)
-		blocking_notifier_call_chain(&pinst->cpumask_change_notifier,
-					     notification_mask,
-					     &pinst->cpumask);
-
 	pinst->flags &= ~PADATA_RESET;
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
@@ -944,7 +898,6 @@ static struct padata_instance *padata_alloc(const char *name,
 
 	pinst->flags = 0;
 
-	BLOCKING_INIT_NOTIFIER_HEAD(&pinst->cpumask_change_notifier);
 	kobject_init(&pinst->kobj, &padata_attr_type);
 	mutex_init(&pinst->lock);
 
-- 
2.23.0


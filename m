Return-Path: <SRS0=oY6L=WZ=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 55645C3A59F
	for <linux-crypto@archiver.kernel.org>; Thu, 29 Aug 2019 17:38:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1E64F21726
	for <linux-crypto@archiver.kernel.org>; Thu, 29 Aug 2019 17:38:04 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="Kci5hxla"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728010AbfH2RiA (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 29 Aug 2019 13:38:00 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:52878 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727352AbfH2Rh7 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 29 Aug 2019 13:37:59 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x7THXmmB125448;
        Thu, 29 Aug 2019 17:37:42 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=corp-2019-08-05;
 bh=/1Teeq9B2y5clI8N5TuTurXVkSck+7pMqX7JZWWXUMk=;
 b=Kci5hxlaXvlnWY+oGMbnC3DG6oL5xYK3xfnubTdCEUfl8xhFN7gCqkU2v7R5O/zmsgbD
 k36tlyPS0thXL9OYNmFOcnIwhoM3JqeXCj98tj3bOmHCjg12hhzqCAwc/yFu8caLedd4
 21aeDnT67Bz9wbEaWWYB6QohRMkyu4pVxM1njr3X+gK3lnWbw7Mo5vYwSySis/19+Vyt
 5ahW/btQtqTB8pJU2Xqlm4x27SVy9ia3XWTHQHeWe5HldwgSc3lrFxIuxbanDCrrr/tn
 b4b6UXzYhfmyDsflTicLZwf2EuiP/BYhcEADfeYFkQWt3kwiUAIIttGCwJk300yDxCoi bw== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2130.oracle.com with ESMTP id 2upk56r2bg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 29 Aug 2019 17:37:42 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x7THWabR008051;
        Thu, 29 Aug 2019 17:32:41 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userp3030.oracle.com with ESMTP id 2unvu0b2cs-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 29 Aug 2019 17:32:41 +0000
Received: from abhmp0008.oracle.com (abhmp0008.oracle.com [141.146.116.14])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x7THWe7p002142;
        Thu, 29 Aug 2019 17:32:40 GMT
Received: from zissou.us.oracle.com (/10.152.34.58)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 29 Aug 2019 10:32:40 -0700
From:   Daniel Jordan <daniel.m.jordan@oracle.com>
To:     Herbert Xu <herbert@gondor.apana.org.au>,
        Steffen Klassert <steffen.klassert@secunet.com>
Cc:     Lai Jiangshan <jiangshanlai@gmail.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Tejun Heo <tj@kernel.org>, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Daniel Jordan <daniel.m.jordan@oracle.com>
Subject: [PATCH v2 6/9] padata, pcrypt: take CPU hotplug lock internally in padata_alloc_possible
Date:   Thu, 29 Aug 2019 13:30:35 -0400
Message-Id: <20190829173038.21040-7-daniel.m.jordan@oracle.com>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20190829173038.21040-1-daniel.m.jordan@oracle.com>
References: <20190829173038.21040-1-daniel.m.jordan@oracle.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9364 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=2 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1906280000 definitions=main-1908290186
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9364 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=2 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1906280000
 definitions=main-1908290186
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

With pcrypt's cpumask no longer used, take the CPU hotplug lock inside
padata_alloc_possible.

Useful later in the series for avoiding nested acquisition of the CPU
hotplug lock in padata when padata_alloc_possible is allocating an
unbound workqueue.

Without this patch, this nested acquisition would happen later in the
series:

      pcrypt_init_padata
        get_online_cpus
        alloc_padata_possible
          alloc_padata
            alloc_workqueue(WQ_UNBOUND)   // later in the series
              alloc_and_link_pwqs
                apply_wqattrs_lock
                  get_online_cpus         // recursive rwsem acquisition

Signed-off-by: Daniel Jordan <daniel.m.jordan@oracle.com>
Acked-by: Steffen Klassert <steffen.klassert@secunet.com>
Cc: Herbert Xu <herbert@gondor.apana.org.au>
Cc: Lai Jiangshan <jiangshanlai@gmail.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Tejun Heo <tj@kernel.org>
Cc: linux-crypto@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
---
 crypto/pcrypt.c |  4 ----
 kernel/padata.c | 17 +++++++++--------
 2 files changed, 9 insertions(+), 12 deletions(-)

diff --git a/crypto/pcrypt.c b/crypto/pcrypt.c
index 2ec36e6a132f..543792e0ebf0 100644
--- a/crypto/pcrypt.c
+++ b/crypto/pcrypt.c
@@ -308,8 +308,6 @@ static int pcrypt_init_padata(struct padata_instance **pinst, const char *name)
 {
 	int ret = -ENOMEM;
 
-	get_online_cpus();
-
 	*pinst = padata_alloc_possible(name);
 	if (!*pinst)
 		return ret;
@@ -318,8 +316,6 @@ static int pcrypt_init_padata(struct padata_instance **pinst, const char *name)
 	if (ret)
 		padata_free(*pinst);
 
-	put_online_cpus();
-
 	return ret;
 }
 
diff --git a/kernel/padata.c b/kernel/padata.c
index 863053a1e379..29d44edd6733 100644
--- a/kernel/padata.c
+++ b/kernel/padata.c
@@ -907,8 +907,6 @@ static struct kobj_type padata_attr_type = {
  * @name: used to identify the instance
  * @pcpumask: cpumask that will be used for padata parallelization
  * @cbcpumask: cpumask that will be used for padata serialization
- *
- * Must be called from a cpus_read_lock() protected region
  */
 static struct padata_instance *padata_alloc(const char *name,
 					    const struct cpumask *pcpumask,
@@ -926,11 +924,13 @@ static struct padata_instance *padata_alloc(const char *name,
 	if (!pinst->wq)
 		goto err_free_inst;
 
+	get_online_cpus();
+
 	if (!alloc_cpumask_var(&pinst->cpumask.pcpu, GFP_KERNEL))
-		goto err_free_wq;
+		goto err_put_cpus;
 	if (!alloc_cpumask_var(&pinst->cpumask.cbcpu, GFP_KERNEL)) {
 		free_cpumask_var(pinst->cpumask.pcpu);
-		goto err_free_wq;
+		goto err_put_cpus;
 	}
 	if (!padata_validate_cpumask(pinst, pcpumask) ||
 	    !padata_validate_cpumask(pinst, cbcpumask))
@@ -956,12 +956,16 @@ static struct padata_instance *padata_alloc(const char *name,
 	cpuhp_state_add_instance_nocalls_cpuslocked(CPUHP_PADATA_DEAD,
 						    &pinst->node);
 #endif
+
+	put_online_cpus();
+
 	return pinst;
 
 err_free_masks:
 	free_cpumask_var(pinst->cpumask.pcpu);
 	free_cpumask_var(pinst->cpumask.cbcpu);
-err_free_wq:
+err_put_cpus:
+	put_online_cpus();
 	destroy_workqueue(pinst->wq);
 err_free_inst:
 	kfree(pinst);
@@ -975,12 +979,9 @@ static struct padata_instance *padata_alloc(const char *name,
  *                         parallel workers.
  *
  * @name: used to identify the instance
- *
- * Must be called from a cpus_read_lock() protected region
  */
 struct padata_instance *padata_alloc_possible(const char *name)
 {
-	lockdep_assert_cpus_held();
 	return padata_alloc(name, cpu_possible_mask, cpu_possible_mask);
 }
 EXPORT_SYMBOL(padata_alloc_possible);
-- 
2.23.0


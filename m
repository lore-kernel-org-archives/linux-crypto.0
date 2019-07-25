Return-Path: <SRS0=g3pl=VW=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5B35BC76194
	for <linux-crypto@archiver.kernel.org>; Thu, 25 Jul 2019 21:26:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 34D1422BF5
	for <linux-crypto@archiver.kernel.org>; Thu, 25 Jul 2019 21:26:08 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="Ns4MMCbS"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725819AbfGYVZr (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 25 Jul 2019 17:25:47 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:44962 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726661AbfGYVZp (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 25 Jul 2019 17:25:45 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x6PLNhCW032788;
        Thu, 25 Jul 2019 21:25:25 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=corp-2018-07-02;
 bh=O0UmOEll5P5bq+KvZPjJWKwttFJXxKJl59AMR2dnMK0=;
 b=Ns4MMCbS55UXepOeLOQaILMTY2brbxqSFrZM+ANcYDFrSlwZOozFAndEk2JWDda8SSe1
 KjG1I9XECKKb2FUi0ULxdEvRnKgdgEobv4+l//19zCnmiHpsSAWZNwlOhq9O2f1LI5bb
 gcTtWD2fAsqqhHqK+phAjq/FHfxfBevnXsjIJzqtcUTCiSZmJS9qL+vmuBYO0+ui5qgZ
 l89QhxpaN3SV7CnGK1XuC8Km0Ej8wEP4UdyBmNyyit52FKBVQ7MJLFls8qs8yjAN/mXF
 7pvkTpjUPXUOx+n0ElYb3+dcg8IXEQcc4meaPFFXlU4GC1Qx6cFeC/+yv6mlyLPpzTNs JA== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2120.oracle.com with ESMTP id 2tx61c6nac-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 25 Jul 2019 21:25:25 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x6PLNGt3066923;
        Thu, 25 Jul 2019 21:25:25 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3030.oracle.com with ESMTP id 2tx60yj90g-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 25 Jul 2019 21:25:24 +0000
Received: from abhmp0015.oracle.com (abhmp0015.oracle.com [141.146.116.21])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x6PLPMoX016472;
        Thu, 25 Jul 2019 21:25:24 GMT
Received: from localhost.localdomain (/73.60.114.248)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 25 Jul 2019 14:25:21 -0700
From:   Daniel Jordan <daniel.m.jordan@oracle.com>
To:     Steffen Klassert <steffen.klassert@secunet.com>,
        Herbert Xu <herbert@gondor.apana.org.au>
Cc:     Tejun Heo <tj@kernel.org>, Lai Jiangshan <jiangshanlai@gmail.com>,
        Peter Zijlstra <peterz@infradead.org>,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        Daniel Jordan <daniel.m.jordan@oracle.com>
Subject: [RFC 6/9] padata, pcrypt: take CPU hotplug lock internally in padata_alloc_possible
Date:   Thu, 25 Jul 2019 17:25:02 -0400
Message-Id: <20190725212505.15055-7-daniel.m.jordan@oracle.com>
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
index 9d9e7f5e89cb..82edd5f88a32 100644
--- a/kernel/padata.c
+++ b/kernel/padata.c
@@ -955,8 +955,6 @@ static struct kobj_type padata_attr_type = {
  * @name: used to identify the instance
  * @pcpumask: cpumask that will be used for padata parallelization
  * @cbcpumask: cpumask that will be used for padata serialization
- *
- * Must be called from a cpus_read_lock() protected region
  */
 static struct padata_instance *padata_alloc(const char *name,
 					    const struct cpumask *pcpumask,
@@ -974,11 +972,13 @@ static struct padata_instance *padata_alloc(const char *name,
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
@@ -1002,12 +1002,16 @@ static struct padata_instance *padata_alloc(const char *name,
 #ifdef CONFIG_HOTPLUG_CPU
 	cpuhp_state_add_instance_nocalls_cpuslocked(hp_online, &pinst->node);
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
@@ -1021,12 +1025,9 @@ static struct padata_instance *padata_alloc(const char *name,
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
2.22.0


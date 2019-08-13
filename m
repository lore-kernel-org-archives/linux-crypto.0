Return-Path: <SRS0=ZPwR=WJ=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6AD29C31E40
	for <linux-crypto@archiver.kernel.org>; Tue, 13 Aug 2019 00:53:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 33C49207E0
	for <linux-crypto@archiver.kernel.org>; Tue, 13 Aug 2019 00:53:50 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="VnPdO3b1";
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="GVPusLeq"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726610AbfHMAxp (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 12 Aug 2019 20:53:45 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:48088 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726483AbfHMAxI (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 12 Aug 2019 20:53:08 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x7D0nHp9156517;
        Tue, 13 Aug 2019 00:52:46 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=corp-2019-08-05;
 bh=FsB5rgx8jPP3aSfD6GuHMK46r/JbClokgpXf0of+22A=;
 b=VnPdO3b1A5WvctvVjUl0TbizhbjZF8omEBg8qLL+jexApoGQiXXd+9Q40Lq7TVMxG5y7
 Qi17yfEGTN4XU6aFc1kbmr/5pZF+9qaR4nkWs6x2Fhfi6N0qp4lsvVQP31y2iG3nUcIM
 sbxydvvpRKmZxaAIM6enfIChNytokwT2OdTq5eZvBXWU629kG5nNusWJz0uEAgNV+wpR
 OM4IotFpHPb9Ise3TVrmyR3Lg8NzUxfREJJaI0ULEp+TCxkoxppCh5s82mP5fo14I8yR
 Z6gw8YvA+QqNLc39qicTqH6nVlpNH85PAB/sh0lislrZtEg86kIu2kivkG5sgkLjhiQ2 OQ== 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=corp-2018-07-02;
 bh=FsB5rgx8jPP3aSfD6GuHMK46r/JbClokgpXf0of+22A=;
 b=GVPusLeqetiE9ToqmPlP4qJYhHrCvCB9atxNW4ecgZoAKRUlxjcHYpfNycOxKmCzSjYT
 vDW6PUr4w+PDT1shzST+2TU9kF/rHNmL2cVmoJvz/5M4t9RJU4cXeh4Lr/y8GZKVjal0
 D/FYrQJp+AgDWcXz5OnJ8TUDoB266NkCXg1pB3FHATLSrz8xX6AYCQCBAo6yj3ArecWu
 6qaSXeE4lRgRCt6croJ6Y4+mFvMdbRj93UR1CiVTW2s8lhMuZkxz0L3c3RRYAcGPOgEl
 p7Bxm2ucSOvEuoB4Ylu8BR6MaHhOxupwHHzMGICWzm7kHf4VHJkOfwW/bHjQdOCeBinz bw== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2130.oracle.com with ESMTP id 2u9nbtaux3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 13 Aug 2019 00:52:45 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x7D0nILM152619;
        Tue, 13 Aug 2019 00:52:45 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3030.oracle.com with ESMTP id 2u9k1vuuy5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 13 Aug 2019 00:52:45 +0000
Received: from abhmp0022.oracle.com (abhmp0022.oracle.com [141.146.116.28])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x7D0qifX018095;
        Tue, 13 Aug 2019 00:52:44 GMT
Received: from parnassus.us.oracle.com (/10.39.240.231)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 12 Aug 2019 17:52:44 -0700
From:   Daniel Jordan <daniel.m.jordan@oracle.com>
To:     Herbert Xu <herbert@gondor.apana.org.au>,
        Steffen Klassert <steffen.klassert@secunet.com>
Cc:     Lai Jiangshan <jiangshanlai@gmail.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Tejun Heo <tj@kernel.org>,
        Daniel Jordan <daniel.m.jordan@oracle.com>,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 6/9] padata, pcrypt: take CPU hotplug lock internally in padata_alloc_possible
Date:   Mon, 12 Aug 2019 20:52:21 -0400
Message-Id: <20190813005224.30779-7-daniel.m.jordan@oracle.com>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190813005224.30779-1-daniel.m.jordan@oracle.com>
References: <20190813005224.30779-1-daniel.m.jordan@oracle.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9347 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=2 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1906280000 definitions=main-1908130005
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9347 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=2 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1906280000
 definitions=main-1908130005
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
Cc: Herbert Xu <herbert@gondor.apana.org.au>
Cc: Lai Jiangshan <jiangshanlai@gmail.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Steffen Klassert <steffen.klassert@secunet.com>
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
index 469e96a91459..43a837aed04a 100644
--- a/kernel/padata.c
+++ b/kernel/padata.c
@@ -965,8 +965,6 @@ static struct kobj_type padata_attr_type = {
  * @name: used to identify the instance
  * @pcpumask: cpumask that will be used for padata parallelization
  * @cbcpumask: cpumask that will be used for padata serialization
- *
- * Must be called from a cpus_read_lock() protected region
  */
 static struct padata_instance *padata_alloc(const char *name,
 					    const struct cpumask *pcpumask,
@@ -984,11 +982,13 @@ static struct padata_instance *padata_alloc(const char *name,
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
@@ -1012,12 +1012,16 @@ static struct padata_instance *padata_alloc(const char *name,
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
@@ -1031,12 +1035,9 @@ static struct padata_instance *padata_alloc(const char *name,
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


Return-Path: <SRS0=Ue/q=WF=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 27406C41514
	for <linux-crypto@archiver.kernel.org>; Fri,  9 Aug 2019 19:29:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id F093A21743
	for <linux-crypto@archiver.kernel.org>; Fri,  9 Aug 2019 19:29:30 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="JsGevr6F";
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="Cai3YE3s"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726417AbfHIT3R (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 9 Aug 2019 15:29:17 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:50594 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726185AbfHIT3Q (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 9 Aug 2019 15:29:16 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x79JIbuB170462;
        Fri, 9 Aug 2019 19:29:07 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : mime-version : content-transfer-encoding;
 s=corp-2019-08-05; bh=qy8Hj53Xb1Dfh7O7VOv0dgBCkLnskXSxJx2txNy1KfQ=;
 b=JsGevr6FC4QjGUTTA76pyDACP1sX0fQfr1zjm+IiO4tI8cyPz4AZL9FGqG1etgGUSFTW
 9ET5b/96hdUEW93BGbHXIj4K0KVSkOQRCB504uQs5z561siCV8YFTvUuRzrqVrGaJfE9
 SjtmOpFjHx92OrOpuh3DzCgXT1uY5EqZgAFgYXd4xOJPp3XNa2ohw3MM7HbHbjldNNKn
 +Cr3e1KGqoKwwOsxPqcC2LW2nVdRt4pXg9Qz/izJTw4rpc++OJlb+KlIPDrv6AH/lDX5
 YZ+zFQJTOy5MBwdstqol5Z0UzxYnmM8xStC2cQZgWLusbf6Fw7J6ASyutkxmyswfKgLO fQ== 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : mime-version : content-transfer-encoding;
 s=corp-2018-07-02; bh=qy8Hj53Xb1Dfh7O7VOv0dgBCkLnskXSxJx2txNy1KfQ=;
 b=Cai3YE3sSvSOhoAV1ti3U/JkV2Pvc3SG1ck6OKO8MbRz03fXi7rAVuCxR0g8MclYKG4L
 46nw3TEBf84Wn42wyt9xQVP9xtkVPbvnF3O7xJVwDYY0MxQ301ZNbJUfChzmUwZ+0xOn
 mubNAnkH0rlllZB/gC70h/dDJGptlSvdoK1YTtGBa1L1ffCju5nSVMg87YuTHJPZ+YWx
 XbixtWILHT/n8pQqYJi5XCLZU8e68VoFybRwPzfmVxYb3SoJPLRou1NVJ0T+xupOaQUz
 pNsA7Gxk0hQ2Z1vQuIPLt/adlt6hfDg4h/E2jGEAoQMshpCnbQHbXTBRUhVM20F5x4wV 7Q== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2120.oracle.com with ESMTP id 2u8hgp9pwf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 09 Aug 2019 19:29:06 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x79JIwjH035307;
        Fri, 9 Aug 2019 19:29:06 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserp3030.oracle.com with ESMTP id 2u8x1h34ws-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 09 Aug 2019 19:29:05 +0000
Received: from abhmp0008.oracle.com (abhmp0008.oracle.com [141.146.116.14])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x79JT3Gr017790;
        Fri, 9 Aug 2019 19:29:04 GMT
Received: from localhost.localdomain (/73.60.114.248)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 09 Aug 2019 12:29:03 -0700
From:   Daniel Jordan <daniel.m.jordan@oracle.com>
To:     Herbert Xu <herbert@gondor.apana.org.au>,
        Steffen Klassert <steffen.klassert@secunet.com>
Cc:     Daniel Jordan <daniel.m.jordan@oracle.com>,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 1/2] padata: always acquire cpu_hotplug_lock before pinst->lock
Date:   Fri,  9 Aug 2019 15:28:56 -0400
Message-Id: <20190809192857.26585-1-daniel.m.jordan@oracle.com>
X-Mailer: git-send-email 2.22.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9344 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1906280000 definitions=main-1908090190
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9344 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1906280000
 definitions=main-1908090190
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On a 5.2 kernel, lockdep complains when offlining a CPU and writing to a
parallel_cpumask sysfs file.

  echo 0 > /sys/devices/system/cpu/cpu1/online
  echo ff > /sys/kernel/pcrypt/pencrypt/parallel_cpumask

  ======================================================
  WARNING: possible circular locking dependency detected
  5.2.0-padata-base+ #19 Not tainted
  ------------------------------------------------------
  cpuhp/1/13 is trying to acquire lock:
  ...  (&pinst->lock){+.+.}, at: padata_cpu_prep_down+0x37/0x70

  but task is already holding lock:
  ...  (cpuhp_state-down){+.+.}, at: cpuhp_thread_fun+0x34/0x240

  which lock already depends on the new lock.

padata doesn't take cpu_hotplug_lock and pinst->lock in a consistent
order.  Which should be first?  CPU hotplug calls into padata with
cpu_hotplug_lock already held, so it should have priority.

Remove the cpu_hotplug_lock acquisition from __padata_stop and hoist it
up to padata_stop, before pd->lock is taken.  That fixes a
recursive acquisition of cpu_hotplug_lock in padata_remove_cpu at the
same time:

  padata_remove_cpu
    mutex_lock(&pinst->lock)
    get_online_cpus()
    __padata_remove_cpu
      __padata_stop
        get_online_cpus()

The rest is just switching the order where the two locks are taken
together.

Fixes: 6751fb3c0e0c ("padata: Use get_online_cpus/put_online_cpus")
Fixes: 65ff577e6b6e ("padata: Rearrange set_cpumask functions")
Signed-off-by: Daniel Jordan <daniel.m.jordan@oracle.com>
Cc: Herbert Xu <herbert@gondor.apana.org.au>
Cc: Steffen Klassert <steffen.klassert@secunet.com>
Cc: linux-crypto@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
---

Hello, these two patches are based on all padata fixes now in cryptodev-2.6.

 kernel/padata.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/kernel/padata.c b/kernel/padata.c
index b60cc3dcee58..d056276a96ce 100644
--- a/kernel/padata.c
+++ b/kernel/padata.c
@@ -487,9 +487,7 @@ static void __padata_stop(struct padata_instance *pinst)
 
 	synchronize_rcu();
 
-	get_online_cpus();
 	padata_flush_queues(pinst->pd);
-	put_online_cpus();
 }
 
 /* Replace the internal control structure with a new one. */
@@ -614,8 +612,8 @@ int padata_set_cpumask(struct padata_instance *pinst, int cpumask_type,
 	struct cpumask *serial_mask, *parallel_mask;
 	int err = -EINVAL;
 
-	mutex_lock(&pinst->lock);
 	get_online_cpus();
+	mutex_lock(&pinst->lock);
 
 	switch (cpumask_type) {
 	case PADATA_CPU_PARALLEL:
@@ -633,8 +631,8 @@ int padata_set_cpumask(struct padata_instance *pinst, int cpumask_type,
 	err =  __padata_set_cpumasks(pinst, parallel_mask, serial_mask);
 
 out:
-	put_online_cpus();
 	mutex_unlock(&pinst->lock);
+	put_online_cpus();
 
 	return err;
 }
@@ -669,9 +667,11 @@ EXPORT_SYMBOL(padata_start);
  */
 void padata_stop(struct padata_instance *pinst)
 {
+	get_online_cpus();
 	mutex_lock(&pinst->lock);
 	__padata_stop(pinst);
 	mutex_unlock(&pinst->lock);
+	put_online_cpus();
 }
 EXPORT_SYMBOL(padata_stop);
 
@@ -739,18 +739,18 @@ int padata_remove_cpu(struct padata_instance *pinst, int cpu, int mask)
 	if (!(mask & (PADATA_CPU_SERIAL | PADATA_CPU_PARALLEL)))
 		return -EINVAL;
 
+	get_online_cpus();
 	mutex_lock(&pinst->lock);
 
-	get_online_cpus();
 	if (mask & PADATA_CPU_SERIAL)
 		cpumask_clear_cpu(cpu, pinst->cpumask.cbcpu);
 	if (mask & PADATA_CPU_PARALLEL)
 		cpumask_clear_cpu(cpu, pinst->cpumask.pcpu);
 
 	err = __padata_remove_cpu(pinst, cpu);
-	put_online_cpus();
 
 	mutex_unlock(&pinst->lock);
+	put_online_cpus();
 
 	return err;
 }
-- 
2.22.0


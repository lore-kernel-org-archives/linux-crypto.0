Return-Path: <SRS0=oY6L=WZ=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 37F39C3A5A1
	for <linux-crypto@archiver.kernel.org>; Thu, 29 Aug 2019 00:39:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id EEA642070B
	for <linux-crypto@archiver.kernel.org>; Thu, 29 Aug 2019 00:39:10 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="jDZII5f4"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725941AbfH2Ai7 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 28 Aug 2019 20:38:59 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:42710 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725892AbfH2Ai7 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 28 Aug 2019 20:38:59 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x7T0YCx8019592;
        Thu, 29 Aug 2019 00:38:43 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=corp-2019-08-05;
 bh=07esnCh9Q7ADyFw64RmGaCzhnJGUf5VXTz4CoNgBoY0=;
 b=jDZII5f4JWrOMpu6JAChABgsFojRLGR5zWAsUAMQyvP8Vyd2dQSwNTMhsgFy1/EpsT9a
 n8DkDwsiGZymjRczYdF+vBp0eoR7ruEzFhS2bmVDURWJOcIQAT5tAhaQJI9n9gAuX8gj
 7mEFSy3nSJ1ymXuCJ75XHD/YhQrK6HR0FKYXlzo6Sh4Zol9lmMVoMkXoAKJRdYVHrCK1
 XzU2Gbu1n3F9qWfjB5tLlnHzqYplw2gWgvB+3Z0h8jy0g+lzk5Kug7T9xNejSykX/qln
 ewvalVip+fe4jOmhSnr7YzttspTiUYpJJhQFIh9SKMspdorNDva3TD6jyHlWpp6O8/uW tA== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2120.oracle.com with ESMTP id 2up44h817e-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 29 Aug 2019 00:38:42 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x7SMEUID043190;
        Wed, 28 Aug 2019 22:16:33 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserp3020.oracle.com with ESMTP id 2undw7xt8m-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 28 Aug 2019 22:16:33 +0000
Received: from abhmp0010.oracle.com (abhmp0010.oracle.com [141.146.116.16])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x7SMGXno031903;
        Wed, 28 Aug 2019 22:16:33 GMT
Received: from zissou.us.oracle.com (/10.152.34.58)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 28 Aug 2019 15:16:32 -0700
From:   Daniel Jordan <daniel.m.jordan@oracle.com>
To:     Herbert Xu <herbert@gondor.apana.org.au>,
        Steffen Klassert <steffen.klassert@secunet.com>
Cc:     Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Thomas Gleixner <tglx@linutronix.de>,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        Daniel Jordan <daniel.m.jordan@oracle.com>
Subject: [PATCH v2 5/5] padata: validate cpumask without removed CPU during offline
Date:   Wed, 28 Aug 2019 18:14:25 -0400
Message-Id: <20190828221425.22701-6-daniel.m.jordan@oracle.com>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20190828221425.22701-1-daniel.m.jordan@oracle.com>
References: <20190828221425.22701-1-daniel.m.jordan@oracle.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9363 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=2 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1906280000 definitions=main-1908280214
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9363 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=2 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1906280000
 definitions=main-1908290003
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Configuring an instance's parallel mask without any online CPUs...

  echo 2 > /sys/kernel/pcrypt/pencrypt/parallel_cpumask
  echo 0 > /sys/devices/system/cpu/cpu1/online

...makes tcrypt mode=215 crash like this:

  divide error: 0000 [#1] SMP PTI
  CPU: 4 PID: 287 Comm: modprobe Not tainted 5.3.0-rc5-padata-base+ #7
  RIP: 0010:padata_do_parallel+0xfd/0x290
  Call Trace:
   pcrypt_do_parallel+0xed/0x1e0 [pcrypt]
   pcrypt_aead_encrypt+0xbf/0xd0 [pcrypt]
   crypto_aead_encrypt+0x1f/0x30
   do_mult_aead_op+0x4e/0xdf [tcrypt]
   test_mb_aead_speed.constprop.0.cold+0x226/0x564 [tcrypt]
   do_test+0x2280/0x4c16 [tcrypt]
   tcrypt_mod_init+0x55/0x1000 [tcrypt]
   ...

cpumask_weight() in padata_cpu_hash() returns 0 because the mask has no
CPUs.  The problem is __padata_remove_cpu() checks for valid masks too
early and so doesn't mark the instance PADATA_INVALID as expected, which
would have made padata_do_parallel() return error before doing the
division.

Fix by introducing a second padata CPU hotplug state before
CPUHP_BRINGUP_CPU so that __padata_remove_cpu() sees the online mask
without @cpu.  No need for the cpumask_clear_cpu()s since @cpu is
already missing from those masks.

Fixes: 33e54450683c ("padata: Handle empty padata cpumasks")
Signed-off-by: Daniel Jordan <daniel.m.jordan@oracle.com>
Cc: Herbert Xu <herbert@gondor.apana.org.au>
Cc: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc: Steffen Klassert <steffen.klassert@secunet.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: linux-crypto@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
---
 include/linux/cpuhotplug.h |  1 +
 kernel/padata.c            | 21 ++++++++++++++-------
 2 files changed, 15 insertions(+), 7 deletions(-)

diff --git a/include/linux/cpuhotplug.h b/include/linux/cpuhotplug.h
index 068793a619ca..2d55cee638fc 100644
--- a/include/linux/cpuhotplug.h
+++ b/include/linux/cpuhotplug.h
@@ -59,6 +59,7 @@ enum cpuhp_state {
 	CPUHP_IOMMU_INTEL_DEAD,
 	CPUHP_LUSTRE_CFS_DEAD,
 	CPUHP_AP_ARM_CACHE_B15_RAC_DEAD,
+	CPUHP_PADATA_DEAD,
 	CPUHP_WORKQUEUE_PREP,
 	CPUHP_POWER_NUMA_PREPARE,
 	CPUHP_HRTIMERS_PREPARE,
diff --git a/kernel/padata.c b/kernel/padata.c
index 75e668fedd8d..5325e5978ee4 100644
--- a/kernel/padata.c
+++ b/kernel/padata.c
@@ -690,7 +690,7 @@ static int __padata_remove_cpu(struct padata_instance *pinst, int cpu)
 {
 	struct parallel_data *pd = NULL;
 
-	if (cpumask_test_cpu(cpu, cpu_online_mask)) {
+	if (!cpumask_test_cpu(cpu, cpu_online_mask)) {
 
 		if (!padata_validate_cpumask(pinst, pinst->cpumask.pcpu) ||
 		    !padata_validate_cpumask(pinst, pinst->cpumask.cbcpu))
@@ -702,9 +702,6 @@ static int __padata_remove_cpu(struct padata_instance *pinst, int cpu)
 			return -ENOMEM;
 
 		padata_replace(pinst, pd);
-
-		cpumask_clear_cpu(cpu, pd->cpumask.cbcpu);
-		cpumask_clear_cpu(cpu, pd->cpumask.pcpu);
 	}
 
 	return 0;
@@ -731,7 +728,7 @@ static int padata_cpu_online(unsigned int cpu, struct hlist_node *node)
 	return ret;
 }
 
-static int padata_cpu_prep_down(unsigned int cpu, struct hlist_node *node)
+static int padata_cpu_dead(unsigned int cpu, struct hlist_node *node)
 {
 	struct padata_instance *pinst;
 	int ret;
@@ -752,6 +749,7 @@ static enum cpuhp_state hp_online;
 static void __padata_free(struct padata_instance *pinst)
 {
 #ifdef CONFIG_HOTPLUG_CPU
+	cpuhp_state_remove_instance_nocalls(CPUHP_PADATA_DEAD, &pinst->node);
 	cpuhp_state_remove_instance_nocalls(hp_online, &pinst->node);
 #endif
 
@@ -938,6 +936,8 @@ static struct padata_instance *padata_alloc(struct workqueue_struct *wq,
 
 #ifdef CONFIG_HOTPLUG_CPU
 	cpuhp_state_add_instance_nocalls_cpuslocked(hp_online, &pinst->node);
+	cpuhp_state_add_instance_nocalls_cpuslocked(CPUHP_PADATA_DEAD,
+						    &pinst->node);
 #endif
 	return pinst;
 
@@ -984,17 +984,24 @@ static __init int padata_driver_init(void)
 	int ret;
 
 	ret = cpuhp_setup_state_multi(CPUHP_AP_ONLINE_DYN, "padata:online",
-				      padata_cpu_online,
-				      padata_cpu_prep_down);
+				      padata_cpu_online, NULL);
 	if (ret < 0)
 		return ret;
 	hp_online = ret;
+
+	ret = cpuhp_setup_state_multi(CPUHP_PADATA_DEAD, "padata:dead",
+				      NULL, padata_cpu_dead);
+	if (ret < 0) {
+		cpuhp_remove_multi_state(hp_online);
+		return ret;
+	}
 	return 0;
 }
 module_init(padata_driver_init);
 
 static __exit void padata_driver_exit(void)
 {
+	cpuhp_remove_multi_state(CPUHP_PADATA_DEAD);
 	cpuhp_remove_multi_state(hp_online);
 }
 module_exit(padata_driver_exit);
-- 
2.23.0


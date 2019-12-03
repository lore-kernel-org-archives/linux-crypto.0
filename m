Return-Path: <SRS0=f4rb=ZZ=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 01723C432C0
	for <linux-crypto@archiver.kernel.org>; Tue,  3 Dec 2019 19:31:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id BCB4D206DF
	for <linux-crypto@archiver.kernel.org>; Tue,  3 Dec 2019 19:31:58 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="mtgRPhCG"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727525AbfLCTby (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 3 Dec 2019 14:31:54 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:36102 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726932AbfLCTbx (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 3 Dec 2019 14:31:53 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xB3JOrQb165836;
        Tue, 3 Dec 2019 19:31:36 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=corp-2019-08-05;
 bh=Sg0ZcnYuLZIWWZKNRdulqDnyvpenlzlbPcAAEpcxRMM=;
 b=mtgRPhCGUIihlGQXWgGV9aQ1Dt0VNbIFNBJix/qPIHQqs5Uehz+C29SaZFTOIpzLrt6X
 o8QzUfxzns0ZTz1/q8cC27RwkXMm4vpcaN4HL4LjMGVeVG40OfckdgLb5g27Zmh4Xar4
 cg3AIPiODek8D+VLc72splREE5AAUXa4Yfo3k2pH4qW1AsJp4V7dZUNGd4vuu0WgtskH
 c1nwy1m/GpBI+aXY8A4gE6rUNLRV1MSJ9fYT0j1dSFNx4oHQBFJr+kH4WDQSQUoSu5Nl
 2cvkCLLuYTfzr8iLQy7jejyzMhmVeAzJBa2sZmzMMdSyueZTZZYF3Hb7NN0tR5jsci/l dA== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2120.oracle.com with ESMTP id 2wkgcq9x9g-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 03 Dec 2019 19:31:36 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xB3JEiDe116693;
        Tue, 3 Dec 2019 19:31:35 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserp3020.oracle.com with ESMTP id 2wnb8102fp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 03 Dec 2019 19:31:35 +0000
Received: from abhmp0008.oracle.com (abhmp0008.oracle.com [141.146.116.14])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id xB3JVVLw009200;
        Tue, 3 Dec 2019 19:31:31 GMT
Received: from localhost.localdomain (/98.229.125.203)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 03 Dec 2019 11:31:30 -0800
From:   Daniel Jordan <daniel.m.jordan@oracle.com>
To:     Herbert Xu <herbert@gondor.apana.org.au>,
        Steffen Klassert <steffen.klassert@secunet.com>
Cc:     Eric Biggers <ebiggers@kernel.org>,
        Jonathan Corbet <corbet@lwn.net>, linux-crypto@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        Daniel Jordan <daniel.m.jordan@oracle.com>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH v2 1/5] padata: validate cpumask without removed CPU during offline
Date:   Tue,  3 Dec 2019 14:31:10 -0500
Message-Id: <20191203193114.238912-2-daniel.m.jordan@oracle.com>
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
 suspectscore=2 phishscore=0 bulkscore=0 spamscore=0 clxscore=1011
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1911140001
 definitions=main-1912030143
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Configuring an instance's parallel mask without any online CPUs...

  echo 2 > /sys/kernel/pcrypt/pencrypt/parallel_cpumask
  echo 0 > /sys/devices/system/cpu/cpu1/online

...makes tcrypt mode=215 crash like this:

  divide error: 0000 [#1] SMP PTI
  CPU: 4 PID: 283 Comm: modprobe Not tainted 5.4.0-rc8-padata-doc-v2+ #2
  Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS ?-20191013_105130-anatol 04/01/2014
  RIP: 0010:padata_do_parallel+0x114/0x300
  Call Trace:
   pcrypt_aead_encrypt+0xc0/0xd0 [pcrypt]
   crypto_aead_encrypt+0x1f/0x30
   do_mult_aead_op+0x4e/0xdf [tcrypt]
   test_mb_aead_speed.constprop.0.cold+0x226/0x564 [tcrypt]
   do_test+0x28c2/0x4d49 [tcrypt]
   tcrypt_mod_init+0x55/0x1000 [tcrypt]
   ...

cpumask_weight() in padata_cpu_hash() returns 0 because the mask has no
CPUs.  The problem is __padata_remove_cpu() checks for valid masks too
early and so doesn't mark the instance PADATA_INVALID as expected, which
would have made padata_do_parallel() return error before doing the
division.

Fix by introducing a second padata CPU hotplug state before
CPUHP_BRINGUP_CPU so that __padata_remove_cpu() sees the online mask
without @cpu.  No need for the second argument to padata_replace() since
@cpu is now already missing from the online mask.

Fixes: 33e54450683c ("padata: Handle empty padata cpumasks")
Signed-off-by: Daniel Jordan <daniel.m.jordan@oracle.com>
Cc: Eric Biggers <ebiggers@kernel.org>
Cc: Herbert Xu <herbert@gondor.apana.org.au>
Cc: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc: Steffen Klassert <steffen.klassert@secunet.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: linux-crypto@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
---
 include/linux/cpuhotplug.h |  1 +
 kernel/padata.c            | 30 ++++++++++++++++++------------
 2 files changed, 19 insertions(+), 12 deletions(-)

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
index 9e3c4df75907..a2fa6223e1a0 100644
--- a/kernel/padata.c
+++ b/kernel/padata.c
@@ -512,7 +512,7 @@ static int padata_replace_one(struct padata_shell *ps)
 	return 0;
 }
 
-static int padata_replace(struct padata_instance *pinst, int cpu)
+static int padata_replace(struct padata_instance *pinst)
 {
 	int notification_mask = 0;
 	struct padata_shell *ps;
@@ -523,16 +523,12 @@ static int padata_replace(struct padata_instance *pinst, int cpu)
 	cpumask_copy(pinst->omask, pinst->rcpumask.pcpu);
 	cpumask_and(pinst->rcpumask.pcpu, pinst->cpumask.pcpu,
 		    cpu_online_mask);
-	if (cpu >= 0)
-		cpumask_clear_cpu(cpu, pinst->rcpumask.pcpu);
 	if (!cpumask_equal(pinst->omask, pinst->rcpumask.pcpu))
 		notification_mask |= PADATA_CPU_PARALLEL;
 
 	cpumask_copy(pinst->omask, pinst->rcpumask.cbcpu);
 	cpumask_and(pinst->rcpumask.cbcpu, pinst->cpumask.cbcpu,
 		    cpu_online_mask);
-	if (cpu >= 0)
-		cpumask_clear_cpu(cpu, pinst->rcpumask.cbcpu);
 	if (!cpumask_equal(pinst->omask, pinst->rcpumask.cbcpu))
 		notification_mask |= PADATA_CPU_SERIAL;
 
@@ -624,7 +620,7 @@ static int __padata_set_cpumasks(struct padata_instance *pinst,
 	cpumask_copy(pinst->cpumask.pcpu, pcpumask);
 	cpumask_copy(pinst->cpumask.cbcpu, cbcpumask);
 
-	err = padata_setup_cpumasks(pinst) ?: padata_replace(pinst, -1);
+	err = padata_setup_cpumasks(pinst) ?: padata_replace(pinst);
 
 	if (valid)
 		__padata_start(pinst);
@@ -715,7 +711,7 @@ static int __padata_add_cpu(struct padata_instance *pinst, int cpu)
 	int err = 0;
 
 	if (cpumask_test_cpu(cpu, cpu_online_mask)) {
-		err = padata_replace(pinst, -1);
+		err = padata_replace(pinst);
 
 		if (padata_validate_cpumask(pinst, pinst->cpumask.pcpu) &&
 		    padata_validate_cpumask(pinst, pinst->cpumask.cbcpu))
@@ -729,12 +725,12 @@ static int __padata_remove_cpu(struct padata_instance *pinst, int cpu)
 {
 	int err = 0;
 
-	if (cpumask_test_cpu(cpu, cpu_online_mask)) {
+	if (!cpumask_test_cpu(cpu, cpu_online_mask)) {
 		if (!padata_validate_cpumask(pinst, pinst->cpumask.pcpu) ||
 		    !padata_validate_cpumask(pinst, pinst->cpumask.cbcpu))
 			__padata_stop(pinst);
 
-		err = padata_replace(pinst, cpu);
+		err = padata_replace(pinst);
 	}
 
 	return err;
@@ -761,7 +757,7 @@ static int padata_cpu_online(unsigned int cpu, struct hlist_node *node)
 	return ret;
 }
 
-static int padata_cpu_prep_down(unsigned int cpu, struct hlist_node *node)
+static int padata_cpu_dead(unsigned int cpu, struct hlist_node *node)
 {
 	struct padata_instance *pinst;
 	int ret;
@@ -782,6 +778,7 @@ static enum cpuhp_state hp_online;
 static void __padata_free(struct padata_instance *pinst)
 {
 #ifdef CONFIG_HOTPLUG_CPU
+	cpuhp_state_remove_instance_nocalls(CPUHP_PADATA_DEAD, &pinst->node);
 	cpuhp_state_remove_instance_nocalls(hp_online, &pinst->node);
 #endif
 
@@ -989,6 +986,8 @@ static struct padata_instance *padata_alloc(const char *name,
 
 #ifdef CONFIG_HOTPLUG_CPU
 	cpuhp_state_add_instance_nocalls_cpuslocked(hp_online, &pinst->node);
+	cpuhp_state_add_instance_nocalls_cpuslocked(CPUHP_PADATA_DEAD,
+						    &pinst->node);
 #endif
 
 	put_online_cpus();
@@ -1101,17 +1100,24 @@ static __init int padata_driver_init(void)
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
2.24.0


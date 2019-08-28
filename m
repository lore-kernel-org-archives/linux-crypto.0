Return-Path: <SRS0=KXmQ=WY=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C5144C3A5A6
	for <linux-crypto@archiver.kernel.org>; Wed, 28 Aug 2019 22:16:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 902752339E
	for <linux-crypto@archiver.kernel.org>; Wed, 28 Aug 2019 22:16:58 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="HYa37UCk"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726882AbfH1WQ5 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 28 Aug 2019 18:16:57 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:57500 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726658AbfH1WQ4 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 28 Aug 2019 18:16:56 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x7SMEM0p120994;
        Wed, 28 Aug 2019 22:16:34 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=corp-2019-08-05;
 bh=PGYZg8dmqranewG63iKkOm/uGgVLWKTGrL23VDeFueU=;
 b=HYa37UCk9eYYThbbG6tR/5SUpBgGbIyfEfWlVD4Hf73AKELX42EgZPDizhrLpS4SrdX/
 3+MtYmiGN8eD9aLLvTlauWPjy4+MWyhB+tFKnV1BQv+qkDjCBuDjad35UsgnTcmeAHre
 hnVo+WBBhwA2ieDS56cts1VLWeAyfJWSdsoT5icBrA25cak41bfesiN5bvtQilUFPS23
 9bQ0W+1OD0krKvuSyRCnfuUFhn+goGqaiTWHY7CL4/Oj+Oh5/ukvb8kW0sHFjQU2o3zj
 Snd8LT9ws84aFPyLCJN6h6JVheSEb7ENaayp4XbC6XxUmu7w+sPGcxqYOFeV1W4S7zK4 jQ== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by aserp2120.oracle.com with ESMTP id 2up25500s1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 28 Aug 2019 22:16:34 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x7SMDKrE011415;
        Wed, 28 Aug 2019 22:16:34 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userp3030.oracle.com with ESMTP id 2unvtxxkb6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 28 Aug 2019 22:16:33 +0000
Received: from abhmp0010.oracle.com (abhmp0010.oracle.com [141.146.116.16])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x7SMGVg8031895;
        Wed, 28 Aug 2019 22:16:31 GMT
Received: from zissou.us.oracle.com (/10.152.34.58)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 28 Aug 2019 15:16:31 -0700
From:   Daniel Jordan <daniel.m.jordan@oracle.com>
To:     Herbert Xu <herbert@gondor.apana.org.au>,
        Steffen Klassert <steffen.klassert@secunet.com>
Cc:     Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Thomas Gleixner <tglx@linutronix.de>,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        Daniel Jordan <daniel.m.jordan@oracle.com>,
        Jonathan Corbet <corbet@lwn.net>, linux-doc@vger.kernel.org
Subject: [PATCH v2 3/5] padata: get rid of padata_remove_cpu() for real
Date:   Wed, 28 Aug 2019 18:14:23 -0400
Message-Id: <20190828221425.22701-4-daniel.m.jordan@oracle.com>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20190828221425.22701-1-daniel.m.jordan@oracle.com>
References: <20190828221425.22701-1-daniel.m.jordan@oracle.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9363 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1906280000 definitions=main-1908280214
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9363 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1011
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1906280000
 definitions=main-1908280214
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

A later patch is going to address a lock ordering issue involving
pinst->mutex and the CPU hotplug lock.  padata_remove_cpu() needs fixing
but it has no callers, so just delete it rather than maintaining unused
code.  The Fixes commit forgot to do it anyway.

While at it remove Documentation references to other unused functions.

Fixes: 815613da6a67 ("kernel/padata.c: removed unused code")
Signed-off-by: Daniel Jordan <daniel.m.jordan@oracle.com>
Cc: Herbert Xu <herbert@gondor.apana.org.au>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc: Steffen Klassert <steffen.klassert@secunet.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: linux-crypto@vger.kernel.org
Cc: linux-doc@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
---
 Documentation/padata.txt | 18 ++++--------------
 kernel/padata.c          | 35 -----------------------------------
 2 files changed, 4 insertions(+), 49 deletions(-)

diff --git a/Documentation/padata.txt b/Documentation/padata.txt
index b103d0c82000..43ca928da713 100644
--- a/Documentation/padata.txt
+++ b/Documentation/padata.txt
@@ -51,27 +51,17 @@ padata cpumask contains no active CPU (flag not set).
 padata_stop clears the flag and blocks until the padata instance
 is unused.
 
-The list of CPUs to be used can be adjusted with these functions::
+The list of CPUs to be used can be adjusted with this function::
 
-    int padata_set_cpumasks(struct padata_instance *pinst,
-			    cpumask_var_t pcpumask,
-			    cpumask_var_t cbcpumask);
     int padata_set_cpumask(struct padata_instance *pinst, int cpumask_type,
 			   cpumask_var_t cpumask);
-    int padata_add_cpu(struct padata_instance *pinst, int cpu, int mask);
-    int padata_remove_cpu(struct padata_instance *pinst, int cpu, int mask);
 
 Changing the CPU masks are expensive operations, though, so it should not be
 done with great frequency.
 
-It's possible to change both cpumasks of a padata instance with
-padata_set_cpumasks by specifying the cpumasks for parallel execution (pcpumask)
-and for the serial callback function (cbcpumask). padata_set_cpumask is used to
-change just one of the cpumasks. Here cpumask_type is one of PADATA_CPU_SERIAL,
-PADATA_CPU_PARALLEL and cpumask specifies the new cpumask to use.
-To simply add or remove one CPU from a certain cpumask the functions
-padata_add_cpu/padata_remove_cpu are used. cpu specifies the CPU to add or
-remove and mask is one of PADATA_CPU_SERIAL, PADATA_CPU_PARALLEL.
+padata_set_cpumask is used to change just one of the cpumasks. Here cpumask_type
+is one of PADATA_CPU_SERIAL or PADATA_CPU_PARALLEL, and cpumask specifies the
+new cpumask to use.
 
 If a user is interested in padata cpumask changes, he can register to
 the padata cpumask change notifier::
diff --git a/kernel/padata.c b/kernel/padata.c
index 2bfce01c5b85..6adce3b203fe 100644
--- a/kernel/padata.c
+++ b/kernel/padata.c
@@ -710,41 +710,6 @@ static int __padata_remove_cpu(struct padata_instance *pinst, int cpu)
 	return 0;
 }
 
- /**
- * padata_remove_cpu - remove a cpu from the one or both(serial and parallel)
- *                     padata cpumasks.
- *
- * @pinst: padata instance
- * @cpu: cpu to remove
- * @mask: bitmask specifying from which cpumask @cpu should be removed
- *        The @mask may be any combination of the following flags:
- *          PADATA_CPU_SERIAL   - serial cpumask
- *          PADATA_CPU_PARALLEL - parallel cpumask
- */
-int padata_remove_cpu(struct padata_instance *pinst, int cpu, int mask)
-{
-	int err;
-
-	if (!(mask & (PADATA_CPU_SERIAL | PADATA_CPU_PARALLEL)))
-		return -EINVAL;
-
-	mutex_lock(&pinst->lock);
-
-	get_online_cpus();
-	if (mask & PADATA_CPU_SERIAL)
-		cpumask_clear_cpu(cpu, pinst->cpumask.cbcpu);
-	if (mask & PADATA_CPU_PARALLEL)
-		cpumask_clear_cpu(cpu, pinst->cpumask.pcpu);
-
-	err = __padata_remove_cpu(pinst, cpu);
-	put_online_cpus();
-
-	mutex_unlock(&pinst->lock);
-
-	return err;
-}
-EXPORT_SYMBOL(padata_remove_cpu);
-
 static inline int pinst_has_cpu(struct padata_instance *pinst, int cpu)
 {
 	return cpumask_test_cpu(cpu, pinst->cpumask.pcpu) ||
-- 
2.23.0


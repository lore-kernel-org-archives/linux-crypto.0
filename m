Return-Path: <SRS0=ZPwR=WJ=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B968FC41514
	for <linux-crypto@archiver.kernel.org>; Tue, 13 Aug 2019 00:53:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8321120665
	for <linux-crypto@archiver.kernel.org>; Tue, 13 Aug 2019 00:53:11 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="YiC7lNJs";
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="C4oOESae"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726824AbfHMAxK (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 12 Aug 2019 20:53:10 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:57694 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726488AbfHMAxJ (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 12 Aug 2019 20:53:09 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x7D0nO1L169601;
        Tue, 13 Aug 2019 00:52:45 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=corp-2019-08-05;
 bh=ZODzFsszuNLSovrJFvQVWniEYv0jZxlMRy5Sxv1y8QE=;
 b=YiC7lNJs7tYLJlimjv4NL3yUKdwXlxRkCxUNzZ3G8kJhVrZNnM3HAYuGby0Zq/U2ndjk
 Wv/sQWP5EQLpjCm1wxGVizwpmnCoFRgx3ZgmGwCRlME0wWlyPlvar4l00QY7M0HKQOhZ
 S+rCVH82zZUcleewNs+Fa64ayHFJqg64rJ8RX87adV0BrIZc16egp22Vs5LulrB///nu
 4pR5VXJ11jFpc/hKoBWjvQWK88XxpSs/YygdiSgsBnUJlKweVlWB4nT7uJbow++W4e8K
 CdxAcv2O8jKtdr8edjaNtDK5220stoGz0eihF5dKM6CS8EEEgE04cLEL4o7s4FAQynJ7 3Q== 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=corp-2018-07-02;
 bh=ZODzFsszuNLSovrJFvQVWniEYv0jZxlMRy5Sxv1y8QE=;
 b=C4oOESaeoM0G0MU8mDluK/TMVOUo7m5Pye94E0tbQJt4bU34V1iXij2sRM1tGm8u5F0c
 tvIJye341xUAHRxqYl7X17VOPXYS39b/+y+o8TSPhinUmYOZoEHG1VYEXQfDERQ5VO0R
 cW+L/OMgI3Zn9rwocXyBtlonGC3P+UeTeaMxPcLIUbQLDd3q0CDmBCJ0AGFFUBi6dsIu
 q+UtzLo9LB2Dwytl6dCjpTGyd3LcCzKKx/oJ3xL8z/90LPLVAVu8CRqzQYRjwNbNNkPu
 Kiuxvensjnn/HaWvsHWNsL7CrwF2DStsvg4H3oZ2NY5aeFqVoK+K8V2pSi5MBr5ZdTv/ Ew== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2120.oracle.com with ESMTP id 2u9pjqarhq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 13 Aug 2019 00:52:45 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x7D0nDSM113020;
        Tue, 13 Aug 2019 00:52:44 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserp3020.oracle.com with ESMTP id 2u9nrees12-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 13 Aug 2019 00:52:44 +0000
Received: from abhmp0022.oracle.com (abhmp0022.oracle.com [141.146.116.28])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x7D0qhp3021634;
        Tue, 13 Aug 2019 00:52:43 GMT
Received: from parnassus.us.oracle.com (/10.39.240.231)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 12 Aug 2019 17:52:42 -0700
From:   Daniel Jordan <daniel.m.jordan@oracle.com>
To:     Herbert Xu <herbert@gondor.apana.org.au>,
        Steffen Klassert <steffen.klassert@secunet.com>
Cc:     Lai Jiangshan <jiangshanlai@gmail.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Tejun Heo <tj@kernel.org>,
        Daniel Jordan <daniel.m.jordan@oracle.com>,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 4/9] padata: make padata_do_parallel find alternate callback CPU
Date:   Mon, 12 Aug 2019 20:52:19 -0400
Message-Id: <20190813005224.30779-5-daniel.m.jordan@oracle.com>
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

padata_do_parallel currently returns -EINVAL if the callback CPU isn't
in the callback cpumask.

pcrypt tries to prevent this situation by keeping its own callback
cpumask in sync with padata's and checks that the callback CPU it passes
to padata is valid.  Make padata handle this instead.

padata_do_parallel now takes a pointer to the callback CPU and updates
it for the caller if an alternate CPU is used.  Overall behavior in
terms of which callback CPUs are chosen stays the same.

Prepares for removal of the padata cpumask notifier in pcrypt, which
will fix a lockdep complaint about nested acquisition of the CPU hotplug
lock later in the series.

Signed-off-by: Daniel Jordan <daniel.m.jordan@oracle.com>
Cc: Herbert Xu <herbert@gondor.apana.org.au>
Cc: Lai Jiangshan <jiangshanlai@gmail.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Steffen Klassert <steffen.klassert@secunet.com>
Cc: Tejun Heo <tj@kernel.org>
Cc: linux-crypto@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
---
 crypto/pcrypt.c        | 33 ++-------------------------------
 include/linux/padata.h |  2 +-
 kernel/padata.c        | 27 ++++++++++++++++++++-------
 3 files changed, 23 insertions(+), 39 deletions(-)

diff --git a/crypto/pcrypt.c b/crypto/pcrypt.c
index d67293063c7f..efca962ab12a 100644
--- a/crypto/pcrypt.c
+++ b/crypto/pcrypt.c
@@ -57,35 +57,6 @@ struct pcrypt_aead_ctx {
 	unsigned int cb_cpu;
 };
 
-static int pcrypt_do_parallel(struct padata_priv *padata, unsigned int *cb_cpu,
-			      struct padata_pcrypt *pcrypt)
-{
-	unsigned int cpu_index, cpu, i;
-	struct pcrypt_cpumask *cpumask;
-
-	cpu = *cb_cpu;
-
-	rcu_read_lock_bh();
-	cpumask = rcu_dereference_bh(pcrypt->cb_cpumask);
-	if (cpumask_test_cpu(cpu, cpumask->mask))
-			goto out;
-
-	if (!cpumask_weight(cpumask->mask))
-			goto out;
-
-	cpu_index = cpu % cpumask_weight(cpumask->mask);
-
-	cpu = cpumask_first(cpumask->mask);
-	for (i = 0; i < cpu_index; i++)
-		cpu = cpumask_next(cpu, cpumask->mask);
-
-	*cb_cpu = cpu;
-
-out:
-	rcu_read_unlock_bh();
-	return padata_do_parallel(pcrypt->pinst, padata, cpu);
-}
-
 static int pcrypt_aead_setkey(struct crypto_aead *parent,
 			      const u8 *key, unsigned int keylen)
 {
@@ -157,7 +128,7 @@ static int pcrypt_aead_encrypt(struct aead_request *req)
 			       req->cryptlen, req->iv);
 	aead_request_set_ad(creq, req->assoclen);
 
-	err = pcrypt_do_parallel(padata, &ctx->cb_cpu, &pencrypt);
+	err = padata_do_parallel(pencrypt.pinst, padata, &ctx->cb_cpu);
 	if (!err)
 		return -EINPROGRESS;
 
@@ -199,7 +170,7 @@ static int pcrypt_aead_decrypt(struct aead_request *req)
 			       req->cryptlen, req->iv);
 	aead_request_set_ad(creq, req->assoclen);
 
-	err = pcrypt_do_parallel(padata, &ctx->cb_cpu, &pdecrypt);
+	err = padata_do_parallel(pdecrypt.pinst, padata, &ctx->cb_cpu);
 	if (!err)
 		return -EINPROGRESS;
 
diff --git a/include/linux/padata.h b/include/linux/padata.h
index 839d9319920a..f7851f8e2190 100644
--- a/include/linux/padata.h
+++ b/include/linux/padata.h
@@ -154,7 +154,7 @@ struct padata_instance {
 extern struct padata_instance *padata_alloc_possible(const char *name);
 extern void padata_free(struct padata_instance *pinst);
 extern int padata_do_parallel(struct padata_instance *pinst,
-			      struct padata_priv *padata, int cb_cpu);
+			      struct padata_priv *padata, int *cb_cpu);
 extern void padata_do_serial(struct padata_priv *padata);
 extern int padata_set_cpumask(struct padata_instance *pinst, int cpumask_type,
 			      cpumask_var_t cpumask);
diff --git a/kernel/padata.c b/kernel/padata.c
index ee0108c0265e..469e96a91459 100644
--- a/kernel/padata.c
+++ b/kernel/padata.c
@@ -94,17 +94,19 @@ static void padata_parallel_worker(struct work_struct *parallel_work)
  *
  * @pinst: padata instance
  * @padata: object to be parallelized
- * @cb_cpu: cpu the serialization callback function will run on,
- *          must be in the serial cpumask of padata(i.e. cpumask.cbcpu).
+ * @cb_cpu: pointer to the CPU that the serialization callback function should
+ *          run on.  If it's not in the serial cpumask of @pinst
+ *          (i.e. cpumask.cbcpu), this function selects a fallback CPU and if
+ *          none found, returns -EINVAL.
  *
  * The parallelization callback function will run with BHs off.
  * Note: Every object which is parallelized by padata_do_parallel
  * must be seen by padata_do_serial.
  */
 int padata_do_parallel(struct padata_instance *pinst,
-		       struct padata_priv *padata, int cb_cpu)
+		       struct padata_priv *padata, int *cb_cpu)
 {
-	int target_cpu, err;
+	int i, cpu, cpu_index, target_cpu, err;
 	struct padata_parallel_queue *queue;
 	struct parallel_data *pd;
 
@@ -116,8 +118,19 @@ int padata_do_parallel(struct padata_instance *pinst,
 	if (!(pinst->flags & PADATA_INIT) || pinst->flags & PADATA_INVALID)
 		goto out;
 
-	if (!cpumask_test_cpu(cb_cpu, pd->cpumask.cbcpu))
-		goto out;
+	if (!cpumask_test_cpu(*cb_cpu, pd->cpumask.cbcpu)) {
+		if (!cpumask_weight(pd->cpumask.cbcpu))
+			goto out;
+
+		/* Select an alternate fallback CPU and notify the caller. */
+		cpu_index = *cb_cpu % cpumask_weight(pd->cpumask.cbcpu);
+
+		cpu = cpumask_first(pd->cpumask.cbcpu);
+		for (i = 0; i < cpu_index; i++)
+			cpu = cpumask_next(cpu, pd->cpumask.cbcpu);
+
+		*cb_cpu = cpu;
+	}
 
 	err =  -EBUSY;
 	if ((pinst->flags & PADATA_RESET))
@@ -129,7 +142,7 @@ int padata_do_parallel(struct padata_instance *pinst,
 	err = 0;
 	atomic_inc(&pd->refcnt);
 	padata->pd = pd;
-	padata->cb_cpu = cb_cpu;
+	padata->cb_cpu = *cb_cpu;
 
 	target_cpu = padata_cpu_hash(pd);
 	padata->cpu = target_cpu;
-- 
2.22.0


Return-Path: <SRS0=g3pl=VW=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8EF05C76190
	for <linux-crypto@archiver.kernel.org>; Thu, 25 Jul 2019 21:26:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5EB7B22BF5
	for <linux-crypto@archiver.kernel.org>; Thu, 25 Jul 2019 21:26:09 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="cFn95Zfx"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726931AbfGYV0I (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 25 Jul 2019 17:26:08 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:54630 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726794AbfGYVZq (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 25 Jul 2019 17:25:46 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x6PLNSx8028438;
        Thu, 25 Jul 2019 21:25:24 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=corp-2018-07-02;
 bh=OMEZtuDN1Nv5muTb5R7wLE2BBIuck0co6MqF4qemmAM=;
 b=cFn95ZfxtHn5x7Zs7zHPMpZ8PChwz4kqKt7Lz3wR8N3RjTNy9jhYRxyA8OXrHS/m/I47
 1lg5bgalyRJ1Ibl4ilqHpfsOHwLysOhE1SydBXzb6ygRTe12hebLPCjY5hhZxf91BsQM
 xCr3O56yz4tfRUFuB81wv+YzE5ZMWsG2UOgmDL4hZD0/PbZkjULi+2qo64ioPUbFEXr/
 JgjoKG50/tXpchxnZ9QiM2V0X/Cur/6LE2sMqwK+Cwd/hidHoW35Gzs0UBIGgZBJdN+h
 0EXP1UM7zb2DICIC3IRq0ZQjmVuVia78U+jwFwDRij9LyIxeaeUVnY4GkPQttRJn8Q+F GQ== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2130.oracle.com with ESMTP id 2tx61c6meu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 25 Jul 2019 21:25:24 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x6PLNUwa067130;
        Thu, 25 Jul 2019 21:25:24 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userp3030.oracle.com with ESMTP id 2tx60yj90b-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 25 Jul 2019 21:25:24 +0000
Received: from abhmp0015.oracle.com (abhmp0015.oracle.com [141.146.116.21])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x6PLPKWk030880;
        Thu, 25 Jul 2019 21:25:22 GMT
Received: from localhost.localdomain (/73.60.114.248)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 25 Jul 2019 14:25:20 -0700
From:   Daniel Jordan <daniel.m.jordan@oracle.com>
To:     Steffen Klassert <steffen.klassert@secunet.com>,
        Herbert Xu <herbert@gondor.apana.org.au>
Cc:     Tejun Heo <tj@kernel.org>, Lai Jiangshan <jiangshanlai@gmail.com>,
        Peter Zijlstra <peterz@infradead.org>,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        Daniel Jordan <daniel.m.jordan@oracle.com>
Subject: [RFC 4/9] padata: make padata_do_parallel find alternate callback CPU
Date:   Thu, 25 Jul 2019 17:25:00 -0400
Message-Id: <20190725212505.15055-5-daniel.m.jordan@oracle.com>
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
index 5ae815adf0de..9d9e7f5e89cb 100644
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


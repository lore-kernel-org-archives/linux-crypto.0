Return-Path: <SRS0=g3pl=VW=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EC275C76190
	for <linux-crypto@archiver.kernel.org>; Thu, 25 Jul 2019 21:25:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B781F218F0
	for <linux-crypto@archiver.kernel.org>; Thu, 25 Jul 2019 21:25:45 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="CZloigsN"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726678AbfGYVZo (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 25 Jul 2019 17:25:44 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:44906 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726655AbfGYVZo (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 25 Jul 2019 17:25:44 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x6PLOFKL033301;
        Thu, 25 Jul 2019 21:25:25 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=corp-2018-07-02;
 bh=zUTbyYkj7tD0TYx3YEeY+NiTmPX/2UA5NhqGud4v26Y=;
 b=CZloigsNfmfieHH2Sy/rymEfyFGX+Kr2vuyYRwk1klbwAX84QPIOQP/wgmwGtddhenXH
 dx7WAtvkgarrR27TNjANsvBbYhUvoahDFJI2v392QusC3AUDfSNTercgWW8p2jJ26CYX
 SPKm/oWZpnGHzxwoLLbBZqB5yeJnp+2ipW+aNkWEZPJHz4Ed61NFbm4FMOqtlP/dBMcS
 3ctoB3xFB4WVlqEu6gLlPMqtmN786oWYO9SQqcKjNx1EPEwZOoceH3gibeEMvf64Y06o
 DeChIzle3qiOhtu92y6gsalLHfwyBllVqkemOza/XTWtrZ6SAXwEooXeAEoYnPXND4o7 SQ== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2120.oracle.com with ESMTP id 2tx61c6naa-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 25 Jul 2019 21:25:25 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x6PLNDYt066832;
        Thu, 25 Jul 2019 21:25:24 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userp3030.oracle.com with ESMTP id 2tx60yj90a-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 25 Jul 2019 21:25:24 +0000
Received: from abhmp0015.oracle.com (abhmp0015.oracle.com [141.146.116.21])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x6PLPLsR008644;
        Thu, 25 Jul 2019 21:25:23 GMT
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
Subject: [RFC 5/9] pcrypt: remove padata cpumask notifier
Date:   Thu, 25 Jul 2019 17:25:01 -0400
Message-Id: <20190725212505.15055-6-daniel.m.jordan@oracle.com>
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

Now that padata_do_parallel takes care of finding an alternate callback
CPU, there's no need for pcrypt's callback cpumask, so remove it and the
notifier callback that keeps it in sync.

Signed-off-by: Daniel Jordan <daniel.m.jordan@oracle.com>
---
 crypto/pcrypt.c | 125 +++++++-----------------------------------------
 1 file changed, 18 insertions(+), 107 deletions(-)

diff --git a/crypto/pcrypt.c b/crypto/pcrypt.c
index efca962ab12a..2ec36e6a132f 100644
--- a/crypto/pcrypt.c
+++ b/crypto/pcrypt.c
@@ -18,33 +18,8 @@
 #include <linux/cpu.h>
 #include <crypto/pcrypt.h>
 
-struct padata_pcrypt {
-	struct padata_instance *pinst;
-
-	/*
-	 * Cpumask for callback CPUs. It should be
-	 * equal to serial cpumask of corresponding padata instance,
-	 * so it is updated when padata notifies us about serial
-	 * cpumask change.
-	 *
-	 * cb_cpumask is protected by RCU. This fact prevents us from
-	 * using cpumask_var_t directly because the actual type of
-	 * cpumsak_var_t depends on kernel configuration(particularly on
-	 * CONFIG_CPUMASK_OFFSTACK macro). Depending on the configuration
-	 * cpumask_var_t may be either a pointer to the struct cpumask
-	 * or a variable allocated on the stack. Thus we can not safely use
-	 * cpumask_var_t with RCU operations such as rcu_assign_pointer or
-	 * rcu_dereference. So cpumask_var_t is wrapped with struct
-	 * pcrypt_cpumask which makes possible to use it with RCU.
-	 */
-	struct pcrypt_cpumask {
-		cpumask_var_t mask;
-	} *cb_cpumask;
-	struct notifier_block nblock;
-};
-
-static struct padata_pcrypt pencrypt;
-static struct padata_pcrypt pdecrypt;
+static struct padata_instance *pencrypt;
+static struct padata_instance *pdecrypt;
 static struct kset           *pcrypt_kset;
 
 struct pcrypt_instance_ctx {
@@ -128,7 +103,7 @@ static int pcrypt_aead_encrypt(struct aead_request *req)
 			       req->cryptlen, req->iv);
 	aead_request_set_ad(creq, req->assoclen);
 
-	err = padata_do_parallel(pencrypt.pinst, padata, &ctx->cb_cpu);
+	err = padata_do_parallel(pencrypt, padata, &ctx->cb_cpu);
 	if (!err)
 		return -EINPROGRESS;
 
@@ -170,7 +145,7 @@ static int pcrypt_aead_decrypt(struct aead_request *req)
 			       req->cryptlen, req->iv);
 	aead_request_set_ad(creq, req->assoclen);
 
-	err = padata_do_parallel(pdecrypt.pinst, padata, &ctx->cb_cpu);
+	err = padata_do_parallel(pdecrypt, padata, &ctx->cb_cpu);
 	if (!err)
 		return -EINPROGRESS;
 
@@ -317,36 +292,6 @@ static int pcrypt_create(struct crypto_template *tmpl, struct rtattr **tb)
 	return -EINVAL;
 }
 
-static int pcrypt_cpumask_change_notify(struct notifier_block *self,
-					unsigned long val, void *data)
-{
-	struct padata_pcrypt *pcrypt;
-	struct pcrypt_cpumask *new_mask, *old_mask;
-	struct padata_cpumask *cpumask = (struct padata_cpumask *)data;
-
-	if (!(val & PADATA_CPU_SERIAL))
-		return 0;
-
-	pcrypt = container_of(self, struct padata_pcrypt, nblock);
-	new_mask = kmalloc(sizeof(*new_mask), GFP_KERNEL);
-	if (!new_mask)
-		return -ENOMEM;
-	if (!alloc_cpumask_var(&new_mask->mask, GFP_KERNEL)) {
-		kfree(new_mask);
-		return -ENOMEM;
-	}
-
-	old_mask = pcrypt->cb_cpumask;
-
-	cpumask_copy(new_mask->mask, cpumask->cbcpu);
-	rcu_assign_pointer(pcrypt->cb_cpumask, new_mask);
-	synchronize_rcu();
-
-	free_cpumask_var(old_mask->mask);
-	kfree(old_mask);
-	return 0;
-}
-
 static int pcrypt_sysfs_add(struct padata_instance *pinst, const char *name)
 {
 	int ret;
@@ -359,63 +304,29 @@ static int pcrypt_sysfs_add(struct padata_instance *pinst, const char *name)
 	return ret;
 }
 
-static int pcrypt_init_padata(struct padata_pcrypt *pcrypt,
-			      const char *name)
+static int pcrypt_init_padata(struct padata_instance **pinst, const char *name)
 {
 	int ret = -ENOMEM;
-	struct pcrypt_cpumask *mask;
 
 	get_online_cpus();
 
-	pcrypt->pinst = padata_alloc_possible(name);
-	if (!pcrypt->pinst)
-		goto err;
-
-	mask = kmalloc(sizeof(*mask), GFP_KERNEL);
-	if (!mask)
-		goto err_free_padata;
-	if (!alloc_cpumask_var(&mask->mask, GFP_KERNEL)) {
-		kfree(mask);
-		goto err_free_padata;
-	}
-
-	cpumask_and(mask->mask, cpu_possible_mask, cpu_online_mask);
-	rcu_assign_pointer(pcrypt->cb_cpumask, mask);
-
-	pcrypt->nblock.notifier_call = pcrypt_cpumask_change_notify;
-	ret = padata_register_cpumask_notifier(pcrypt->pinst, &pcrypt->nblock);
-	if (ret)
-		goto err_free_cpumask;
+	*pinst = padata_alloc_possible(name);
+	if (!*pinst)
+		return ret;
 
-	ret = pcrypt_sysfs_add(pcrypt->pinst, name);
+	ret = pcrypt_sysfs_add(*pinst, name);
 	if (ret)
-		goto err_unregister_notifier;
+		padata_free(*pinst);
 
 	put_online_cpus();
 
-	return ret;
-
-err_unregister_notifier:
-	padata_unregister_cpumask_notifier(pcrypt->pinst, &pcrypt->nblock);
-err_free_cpumask:
-	free_cpumask_var(mask->mask);
-	kfree(mask);
-err_free_padata:
-	padata_free(pcrypt->pinst);
-err:
-	put_online_cpus();
-
 	return ret;
 }
 
-static void pcrypt_fini_padata(struct padata_pcrypt *pcrypt)
+static void pcrypt_fini_padata(struct padata_instance *pinst)
 {
-	free_cpumask_var(pcrypt->cb_cpumask->mask);
-	kfree(pcrypt->cb_cpumask);
-
-	padata_stop(pcrypt->pinst);
-	padata_unregister_cpumask_notifier(pcrypt->pinst, &pcrypt->nblock);
-	padata_free(pcrypt->pinst);
+	padata_stop(pinst);
+	padata_free(pinst);
 }
 
 static struct crypto_template pcrypt_tmpl = {
@@ -440,13 +351,13 @@ static int __init pcrypt_init(void)
 	if (err)
 		goto err_deinit_pencrypt;
 
-	padata_start(pencrypt.pinst);
-	padata_start(pdecrypt.pinst);
+	padata_start(pencrypt);
+	padata_start(pdecrypt);
 
 	return crypto_register_template(&pcrypt_tmpl);
 
 err_deinit_pencrypt:
-	pcrypt_fini_padata(&pencrypt);
+	pcrypt_fini_padata(pencrypt);
 err_unreg_kset:
 	kset_unregister(pcrypt_kset);
 err:
@@ -455,8 +366,8 @@ static int __init pcrypt_init(void)
 
 static void __exit pcrypt_exit(void)
 {
-	pcrypt_fini_padata(&pencrypt);
-	pcrypt_fini_padata(&pdecrypt);
+	pcrypt_fini_padata(pencrypt);
+	pcrypt_fini_padata(pdecrypt);
 
 	kset_unregister(pcrypt_kset);
 	crypto_unregister_template(&pcrypt_tmpl);
-- 
2.22.0


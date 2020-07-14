Return-Path: <SRS0=vKog=AZ=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7C39FC433E5
	for <linux-crypto@archiver.kernel.org>; Tue, 14 Jul 2020 20:14:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4A1A9212CC
	for <linux-crypto@archiver.kernel.org>; Tue, 14 Jul 2020 20:14:17 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="Zu61n4C8"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730154AbgGNUOQ (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 14 Jul 2020 16:14:16 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:35042 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725955AbgGNUOK (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 14 Jul 2020 16:14:10 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 06EKCu5p182976;
        Tue, 14 Jul 2020 20:14:03 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=corp-2020-01-29;
 bh=+0PxvJe3/Pu9XwrttHB3+5E+ug8WqKjr4M1IA6gGs8A=;
 b=Zu61n4C8tgirV4YZtyNfoEN9F/yf58i30Y/dYaA4EQ7IKlrgcd9unGUMewGekrDomH82
 EXTLoaAkP9ev2DMzmD5Yp5ZO9AjlavJvi3kt01aJ4sn912WFKA9V+rQKznDofTQ+yewX
 jHNpMiP9wSP202pdXGg4Y8k93NGsluCKtcjIJ1XKm9s/05t9vsm1X7FiKsIR6sHorQ2t
 +v/U0KfhmDvMGjBGPljI5/EH1F//8dVDAE/HoAM4ZElONSerWNVHknqmjFWxih8VEOi1
 aIuJGsMwEoeBDypCrhBfeCBH8tl3gLaOwrW7cIb4fWbBbXswl+QxxhC4YVM/tOPnFgIw +Q== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2120.oracle.com with ESMTP id 3275cm7mnw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Tue, 14 Jul 2020 20:14:02 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 06EKDbi8057423;
        Tue, 14 Jul 2020 20:14:02 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3020.oracle.com with ESMTP id 327q6syrx3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 14 Jul 2020 20:14:02 +0000
Received: from abhmp0003.oracle.com (abhmp0003.oracle.com [141.146.116.9])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 06EKE1UN015959;
        Tue, 14 Jul 2020 20:14:01 GMT
Received: from localhost.localdomain (/98.229.125.203)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 14 Jul 2020 13:14:01 -0700
From:   Daniel Jordan <daniel.m.jordan@oracle.com>
To:     Herbert Xu <herbert@gondor.apana.org.au>,
        Steffen Klassert <steffen.klassert@secunet.com>
Cc:     linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        Daniel Jordan <daniel.m.jordan@oracle.com>
Subject: [PATCH 2/6] padata: remove stop function
Date:   Tue, 14 Jul 2020 16:13:52 -0400
Message-Id: <20200714201356.889176-3-daniel.m.jordan@oracle.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200714201356.889176-1-daniel.m.jordan@oracle.com>
References: <20200714201356.889176-1-daniel.m.jordan@oracle.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9682 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 suspectscore=0
 phishscore=0 malwarescore=0 mlxlogscore=999 bulkscore=0 mlxscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2007140141
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9682 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 priorityscore=1501
 bulkscore=0 adultscore=0 lowpriorityscore=0 phishscore=0 spamscore=0
 impostorscore=0 malwarescore=0 mlxlogscore=999 clxscore=1015 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2007140141
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

padata_stop() has two callers and is unnecessary in both cases.  When
pcrypt calls it before padata_free(), it's being unloaded so there are
no outstanding padata jobs[0].  When __padata_free() calls it, it's
either along the same path or else pcrypt initialization failed, which
of course means there are also no outstanding jobs.

Removing it simplifies padata and saves text.

[0] https://lore.kernel.org/linux-crypto/20191119225017.mjrak2fwa5vccazl@gondor.apana.org.au/

Signed-off-by: Daniel Jordan <daniel.m.jordan@oracle.com>
Cc: Herbert Xu <herbert@gondor.apana.org.au>
Cc: Steffen Klassert <steffen.klassert@secunet.com>
Cc: linux-crypto@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
---
 Documentation/core-api/padata.rst | 16 ++--------------
 crypto/pcrypt.c                   | 12 +++---------
 include/linux/padata.h            |  1 -
 kernel/padata.c                   | 14 --------------
 4 files changed, 5 insertions(+), 38 deletions(-)

diff --git a/Documentation/core-api/padata.rst b/Documentation/core-api/padata.rst
index 0830e5b0e8211..771d50330e5b5 100644
--- a/Documentation/core-api/padata.rst
+++ b/Documentation/core-api/padata.rst
@@ -31,18 +31,7 @@ padata_instance structure for overall control of how jobs are to be run::
 
 'name' simply identifies the instance.
 
-There are functions for enabling and disabling the instance::
-
-    int padata_start(struct padata_instance *pinst);
-    void padata_stop(struct padata_instance *pinst);
-
-These functions are setting or clearing the "PADATA_INIT" flag; if that flag is
-not set, other functions will refuse to work.  padata_start() returns zero on
-success (flag set) or -EINVAL if the padata cpumask contains no active CPU
-(flag not set).  padata_stop() clears the flag and blocks until the padata
-instance is unused.
-
-Finally, complete padata initialization by allocating a padata_shell::
+Then, complete padata initialization by allocating a padata_shell::
 
    struct padata_shell *padata_alloc_shell(struct padata_instance *pinst);
 
@@ -155,11 +144,10 @@ submitted.
 Destroying
 ----------
 
-Cleaning up a padata instance predictably involves calling the three free
+Cleaning up a padata instance predictably involves calling the two free
 functions that correspond to the allocation in reverse::
 
     void padata_free_shell(struct padata_shell *ps);
-    void padata_stop(struct padata_instance *pinst);
     void padata_free(struct padata_instance *pinst);
 
 It is the user's responsibility to ensure all outstanding jobs are complete
diff --git a/crypto/pcrypt.c b/crypto/pcrypt.c
index 4f5707a3dd1e9..7374dfecaf70f 100644
--- a/crypto/pcrypt.c
+++ b/crypto/pcrypt.c
@@ -331,12 +331,6 @@ static int pcrypt_init_padata(struct padata_instance **pinst, const char *name)
 	return ret;
 }
 
-static void pcrypt_fini_padata(struct padata_instance *pinst)
-{
-	padata_stop(pinst);
-	padata_free(pinst);
-}
-
 static struct crypto_template pcrypt_tmpl = {
 	.name = "pcrypt",
 	.create = pcrypt_create,
@@ -362,7 +356,7 @@ static int __init pcrypt_init(void)
 	return crypto_register_template(&pcrypt_tmpl);
 
 err_deinit_pencrypt:
-	pcrypt_fini_padata(pencrypt);
+	padata_free(pencrypt);
 err_unreg_kset:
 	kset_unregister(pcrypt_kset);
 err:
@@ -373,8 +367,8 @@ static void __exit pcrypt_exit(void)
 {
 	crypto_unregister_template(&pcrypt_tmpl);
 
-	pcrypt_fini_padata(pencrypt);
-	pcrypt_fini_padata(pdecrypt);
+	padata_free(pencrypt);
+	padata_free(pdecrypt);
 
 	kset_unregister(pcrypt_kset);
 }
diff --git a/include/linux/padata.h b/include/linux/padata.h
index 20294cddc7396..7d53208b43daa 100644
--- a/include/linux/padata.h
+++ b/include/linux/padata.h
@@ -204,5 +204,4 @@ extern void padata_do_serial(struct padata_priv *padata);
 extern void __init padata_do_multithreaded(struct padata_mt_job *job);
 extern int padata_set_cpumask(struct padata_instance *pinst, int cpumask_type,
 			      cpumask_var_t cpumask);
-extern void padata_stop(struct padata_instance *pinst);
 #endif
diff --git a/kernel/padata.c b/kernel/padata.c
index 9317623166124..8f55e717ba50b 100644
--- a/kernel/padata.c
+++ b/kernel/padata.c
@@ -789,19 +789,6 @@ int padata_set_cpumask(struct padata_instance *pinst, int cpumask_type,
 }
 EXPORT_SYMBOL(padata_set_cpumask);
 
-/**
- * padata_stop - stop the parallel processing
- *
- * @pinst: padata instance to stop
- */
-void padata_stop(struct padata_instance *pinst)
-{
-	mutex_lock(&pinst->lock);
-	__padata_stop(pinst);
-	mutex_unlock(&pinst->lock);
-}
-EXPORT_SYMBOL(padata_stop);
-
 #ifdef CONFIG_HOTPLUG_CPU
 
 static int __padata_add_cpu(struct padata_instance *pinst, int cpu)
@@ -883,7 +870,6 @@ static void __padata_free(struct padata_instance *pinst)
 
 	WARN_ON(!list_empty(&pinst->pslist));
 
-	padata_stop(pinst);
 	free_cpumask_var(pinst->rcpumask.cbcpu);
 	free_cpumask_var(pinst->rcpumask.pcpu);
 	free_cpumask_var(pinst->cpumask.pcpu);
-- 
2.27.0


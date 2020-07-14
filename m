Return-Path: <SRS0=vKog=AZ=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY,URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DA050C433E8
	for <linux-crypto@archiver.kernel.org>; Tue, 14 Jul 2020 20:16:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id AF0332084C
	for <linux-crypto@archiver.kernel.org>; Tue, 14 Jul 2020 20:16:19 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="fO88FZTn"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730406AbgGNUQT (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 14 Jul 2020 16:16:19 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:57984 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730057AbgGNUQJ (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 14 Jul 2020 16:16:09 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 06EKC7lH097128;
        Tue, 14 Jul 2020 20:16:04 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=corp-2020-01-29;
 bh=VKtfSGs57quI8GvMfrjEl4/gJY9j9e0LVcZIEfEMCkY=;
 b=fO88FZTnC0d6D7+mH8OdoN+MPYDj+gRBBoXCnwZqLeG/WV9rN5rmCa51mcmqCrgvQGA4
 UDCytqrhaLMKwQUnjk/+OB3QzHv+Di9AYMDC/oCKquYAliHLeCqAcZp6/OEgR1SD9qN8
 QP+FUZPB9NLdyK7zhtg3UMkyXlSNi7ZqPebyQXryqlFHJ+fzNuzHvcyVf97seNdufCu9
 JqsS3acDIrlQA5h1sPiLB5GK9OPf1iDTdq90qSnh9VW0BxZR6yY/Nt4j3nvGWcIB4qbu
 2iXm6sg7xRV83yAu17D69m/yFCO/jCkQ0kwMJToAOz7g/GnQvoaHiHyrVaq7DvbPhuca dA== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2130.oracle.com with ESMTP id 3274ur7q69-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Tue, 14 Jul 2020 20:16:04 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 06EKDbge025130;
        Tue, 14 Jul 2020 20:14:03 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3030.oracle.com with ESMTP id 327q0pvn9q-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 14 Jul 2020 20:14:03 +0000
Received: from abhmp0003.oracle.com (abhmp0003.oracle.com [141.146.116.9])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 06EKE2Ep003960;
        Tue, 14 Jul 2020 20:14:02 GMT
Received: from localhost.localdomain (/98.229.125.203)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 14 Jul 2020 13:14:02 -0700
From:   Daniel Jordan <daniel.m.jordan@oracle.com>
To:     Herbert Xu <herbert@gondor.apana.org.au>,
        Steffen Klassert <steffen.klassert@secunet.com>
Cc:     linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        Daniel Jordan <daniel.m.jordan@oracle.com>
Subject: [PATCH 5/6] padata: fold padata_alloc_possible() into padata_alloc()
Date:   Tue, 14 Jul 2020 16:13:55 -0400
Message-Id: <20200714201356.889176-6-daniel.m.jordan@oracle.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200714201356.889176-1-daniel.m.jordan@oracle.com>
References: <20200714201356.889176-1-daniel.m.jordan@oracle.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9682 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 malwarescore=0 spamscore=0
 mlxlogscore=999 bulkscore=0 adultscore=0 phishscore=0 suspectscore=2
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2007140141
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9682 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 lowpriorityscore=0 impostorscore=0
 suspectscore=2 phishscore=0 spamscore=0 mlxlogscore=999 malwarescore=0
 mlxscore=0 priorityscore=1501 adultscore=0 bulkscore=0 clxscore=1015
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2007140141
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

There's no reason to have two interfaces when there's only one caller.
Removing _possible saves text and simplifies future changes.

Signed-off-by: Daniel Jordan <daniel.m.jordan@oracle.com>
Cc: Herbert Xu <herbert@gondor.apana.org.au>
Cc: Steffen Klassert <steffen.klassert@secunet.com>
Cc: linux-crypto@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
---
 Documentation/core-api/padata.rst |  2 +-
 crypto/pcrypt.c                   |  2 +-
 include/linux/padata.h            |  2 +-
 kernel/padata.c                   | 33 +++++--------------------------
 4 files changed, 8 insertions(+), 31 deletions(-)

diff --git a/Documentation/core-api/padata.rst b/Documentation/core-api/padata.rst
index 771d50330e5b5..35175710b43cc 100644
--- a/Documentation/core-api/padata.rst
+++ b/Documentation/core-api/padata.rst
@@ -27,7 +27,7 @@ padata_instance structure for overall control of how jobs are to be run::
 
     #include <linux/padata.h>
 
-    struct padata_instance *padata_alloc_possible(const char *name);
+    struct padata_instance *padata_alloc(const char *name);
 
 'name' simply identifies the instance.
 
diff --git a/crypto/pcrypt.c b/crypto/pcrypt.c
index 7374dfecaf70f..812892732a5e5 100644
--- a/crypto/pcrypt.c
+++ b/crypto/pcrypt.c
@@ -320,7 +320,7 @@ static int pcrypt_init_padata(struct padata_instance **pinst, const char *name)
 {
 	int ret = -ENOMEM;
 
-	*pinst = padata_alloc_possible(name);
+	*pinst = padata_alloc(name);
 	if (!*pinst)
 		return ret;
 
diff --git a/include/linux/padata.h b/include/linux/padata.h
index a941b96b7119e..070a7d43e8af8 100644
--- a/include/linux/padata.h
+++ b/include/linux/padata.h
@@ -192,7 +192,7 @@ extern void __init padata_init(void);
 static inline void __init padata_init(void) {}
 #endif
 
-extern struct padata_instance *padata_alloc_possible(const char *name);
+extern struct padata_instance *padata_alloc(const char *name);
 extern void padata_free(struct padata_instance *pinst);
 extern struct padata_shell *padata_alloc_shell(struct padata_instance *pinst);
 extern void padata_free_shell(struct padata_shell *ps);
diff --git a/kernel/padata.c b/kernel/padata.c
index 4f0a57e5738c9..1c0b97891edb8 100644
--- a/kernel/padata.c
+++ b/kernel/padata.c
@@ -979,18 +979,12 @@ static struct kobj_type padata_attr_type = {
 };
 
 /**
- * padata_alloc - allocate and initialize a padata instance and specify
- *                cpumasks for serial and parallel workers.
- *
+ * padata_alloc - allocate and initialize a padata instance
  * @name: used to identify the instance
- * @pcpumask: cpumask that will be used for padata parallelization
- * @cbcpumask: cpumask that will be used for padata serialization
  *
  * Return: new instance on success, NULL on error
  */
-static struct padata_instance *padata_alloc(const char *name,
-					    const struct cpumask *pcpumask,
-					    const struct cpumask *cbcpumask)
+struct padata_instance *padata_alloc(const char *name)
 {
 	struct padata_instance *pinst;
 
@@ -1016,14 +1010,11 @@ static struct padata_instance *padata_alloc(const char *name,
 		free_cpumask_var(pinst->cpumask.pcpu);
 		goto err_free_serial_wq;
 	}
-	if (!padata_validate_cpumask(pinst, pcpumask) ||
-	    !padata_validate_cpumask(pinst, cbcpumask))
-		goto err_free_masks;
 
 	INIT_LIST_HEAD(&pinst->pslist);
 
-	cpumask_copy(pinst->cpumask.pcpu, pcpumask);
-	cpumask_copy(pinst->cpumask.cbcpu, cbcpumask);
+	cpumask_copy(pinst->cpumask.pcpu, cpu_possible_mask);
+	cpumask_copy(pinst->cpumask.cbcpu, cpu_possible_mask);
 
 	if (padata_setup_cpumasks(pinst))
 		goto err_free_masks;
@@ -1057,21 +1048,7 @@ static struct padata_instance *padata_alloc(const char *name,
 err:
 	return NULL;
 }
-
-/**
- * padata_alloc_possible - Allocate and initialize padata instance.
- *                         Use the cpu_possible_mask for serial and
- *                         parallel workers.
- *
- * @name: used to identify the instance
- *
- * Return: new instance on success, NULL on error
- */
-struct padata_instance *padata_alloc_possible(const char *name)
-{
-	return padata_alloc(name, cpu_possible_mask, cpu_possible_mask);
-}
-EXPORT_SYMBOL(padata_alloc_possible);
+EXPORT_SYMBOL(padata_alloc);
 
 /**
  * padata_free - free a padata instance
-- 
2.27.0


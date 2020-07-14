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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 51639C433E3
	for <linux-crypto@archiver.kernel.org>; Tue, 14 Jul 2020 20:14:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 24C40212CC
	for <linux-crypto@archiver.kernel.org>; Tue, 14 Jul 2020 20:14:16 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="o0Jqaj/C"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730080AbgGNUOP (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 14 Jul 2020 16:14:15 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:56300 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729874AbgGNUOK (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 14 Jul 2020 16:14:10 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 06EKC60v097104;
        Tue, 14 Jul 2020 20:14:02 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=corp-2020-01-29;
 bh=C39xUIDZqVwDSDiOX8dFYQfFo3eAkbBQDnhefLy0TxY=;
 b=o0Jqaj/CfptsOfmDzvh8nnzVzb/KuyDbp19I/UYrUEiHIzzNqHHMyxC3A+35agwCTYmP
 qP3AvOiCQMeChk+olFXjRkTJjRskKYk++DTInmTbjvD0YWQKG6nCN/M7HWJh8oVdZ/VD
 kCcg4rWB0+lH/N13GvLJNzBOVKDLSRDBceX7x6o+/JhLFI19Tuah4gMQUu+2/mq3b+uL
 qi2fm9xuUS8/vY+k9wFgMdJFW3uBIQmA7FmFElndW5g3wivcRByPdcyqyqzeyrUI9+ag
 vhKxvXhMQoGrB0PQKEEzHpLPfBzHsqcapy3pE+eUlrrP4bZDn2fF7UTfHsr4Fr7JEQYK 5Q== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2130.oracle.com with ESMTP id 3274ur7pvd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Tue, 14 Jul 2020 20:14:02 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 06EKCkRn155364;
        Tue, 14 Jul 2020 20:14:02 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userp3030.oracle.com with ESMTP id 327qbyc6qh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 14 Jul 2020 20:14:01 +0000
Received: from abhmp0003.oracle.com (abhmp0003.oracle.com [141.146.116.9])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 06EKE0Sj003946;
        Tue, 14 Jul 2020 20:14:00 GMT
Received: from localhost.localdomain (/98.229.125.203)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 14 Jul 2020 13:14:00 -0700
From:   Daniel Jordan <daniel.m.jordan@oracle.com>
To:     Herbert Xu <herbert@gondor.apana.org.au>,
        Steffen Klassert <steffen.klassert@secunet.com>
Cc:     linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        Daniel Jordan <daniel.m.jordan@oracle.com>
Subject: [PATCH 1/6] padata: remove start function
Date:   Tue, 14 Jul 2020 16:13:51 -0400
Message-Id: <20200714201356.889176-2-daniel.m.jordan@oracle.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200714201356.889176-1-daniel.m.jordan@oracle.com>
References: <20200714201356.889176-1-daniel.m.jordan@oracle.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9682 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=2 spamscore=0
 mlxlogscore=999 bulkscore=0 malwarescore=0 mlxscore=0 phishscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2007140141
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

padata_start() is only used right after pcrypt allocates an instance
with all possible CPUs, when PADATA_INVALID can't happen, so there's no
need for a separate "start" step.  It can be done during allocation to
save text, make using padata easier, and avoid unneeded calls in the
future.

Signed-off-by: Daniel Jordan <daniel.m.jordan@oracle.com>
Cc: Herbert Xu <herbert@gondor.apana.org.au>
Cc: Steffen Klassert <steffen.klassert@secunet.com>
Cc: linux-crypto@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
---
 crypto/pcrypt.c        |  3 ---
 include/linux/padata.h |  1 -
 kernel/padata.c        | 26 +-------------------------
 3 files changed, 1 insertion(+), 29 deletions(-)

diff --git a/crypto/pcrypt.c b/crypto/pcrypt.c
index 8bddc65cd5092..4f5707a3dd1e9 100644
--- a/crypto/pcrypt.c
+++ b/crypto/pcrypt.c
@@ -359,9 +359,6 @@ static int __init pcrypt_init(void)
 	if (err)
 		goto err_deinit_pencrypt;
 
-	padata_start(pencrypt);
-	padata_start(pdecrypt);
-
 	return crypto_register_template(&pcrypt_tmpl);
 
 err_deinit_pencrypt:
diff --git a/include/linux/padata.h b/include/linux/padata.h
index 7302efff5e656..20294cddc7396 100644
--- a/include/linux/padata.h
+++ b/include/linux/padata.h
@@ -204,6 +204,5 @@ extern void padata_do_serial(struct padata_priv *padata);
 extern void __init padata_do_multithreaded(struct padata_mt_job *job);
 extern int padata_set_cpumask(struct padata_instance *pinst, int cpumask_type,
 			      cpumask_var_t cpumask);
-extern int padata_start(struct padata_instance *pinst);
 extern void padata_stop(struct padata_instance *pinst);
 #endif
diff --git a/kernel/padata.c b/kernel/padata.c
index 4373f7adaa40a..9317623166124 100644
--- a/kernel/padata.c
+++ b/kernel/padata.c
@@ -789,30 +789,6 @@ int padata_set_cpumask(struct padata_instance *pinst, int cpumask_type,
 }
 EXPORT_SYMBOL(padata_set_cpumask);
 
-/**
- * padata_start - start the parallel processing
- *
- * @pinst: padata instance to start
- *
- * Return: 0 on success or negative error code
- */
-int padata_start(struct padata_instance *pinst)
-{
-	int err = 0;
-
-	mutex_lock(&pinst->lock);
-
-	if (pinst->flags & PADATA_INVALID)
-		err = -EINVAL;
-
-	__padata_start(pinst);
-
-	mutex_unlock(&pinst->lock);
-
-	return err;
-}
-EXPORT_SYMBOL(padata_start);
-
 /**
  * padata_stop - stop the parallel processing
  *
@@ -1100,7 +1076,7 @@ static struct padata_instance *padata_alloc(const char *name,
 	if (padata_setup_cpumasks(pinst))
 		goto err_free_rcpumask_cbcpu;
 
-	pinst->flags = 0;
+	__padata_start(pinst);
 
 	kobject_init(&pinst->kobj, &padata_attr_type);
 	mutex_init(&pinst->lock);
-- 
2.27.0


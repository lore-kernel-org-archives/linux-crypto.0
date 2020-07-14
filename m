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
	by smtp.lore.kernel.org (Postfix) with ESMTP id A7BBDC433E0
	for <linux-crypto@archiver.kernel.org>; Tue, 14 Jul 2020 20:14:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7871C212CC
	for <linux-crypto@archiver.kernel.org>; Tue, 14 Jul 2020 20:14:11 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="j7kSLWyr"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729884AbgGNUOK (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 14 Jul 2020 16:14:10 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:57720 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728777AbgGNUOJ (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 14 Jul 2020 16:14:09 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 06EKCvQO124230;
        Tue, 14 Jul 2020 20:14:03 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=corp-2020-01-29;
 bh=ySUbA5rzTLj3gy7j3X7tOY1gfV7BfEaidIIJe3idLBY=;
 b=j7kSLWyrEPk1ulvnKWoAYLlwAIU63uyY9e8796K2fUQJ+KLigyboCUV1DGYYTs5r7BTj
 kY4HIhtkL2vAtxPIPRE5nj1EYd64UNpMJTft13lRDC1z1wQ4jTSYuIjOjK9gneLos1gq
 6cWXmX8qZfvQlOOz/kz2+r8I6Z/mMs8O0Mlqg3LNGW/pa0f4ephHcEF4FukeNNYDmFL5
 pC4q6XyAKx+Bhqlo+B0qL5iV5XwemHl5yYUvgCJKpQLry66VGU0FVausRP4dVw76Cize
 DF9FAtga5Q7pxaSv81FIgB3Tr8PNxATgLBPk4W5ryPAgbPLDF9ulc/o/Szct6u82CQ0w Yw== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2120.oracle.com with ESMTP id 32762nfgc2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Tue, 14 Jul 2020 20:14:03 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 06EKDZ2R129793;
        Tue, 14 Jul 2020 20:14:02 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3020.oracle.com with ESMTP id 327qb54aa4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 14 Jul 2020 20:14:02 +0000
Received: from abhmp0003.oracle.com (abhmp0003.oracle.com [141.146.116.9])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 06EKE1Hg003954;
        Tue, 14 Jul 2020 20:14:01 GMT
Received: from localhost.localdomain (/98.229.125.203)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 14 Jul 2020 13:14:01 -0700
From:   Daniel Jordan <daniel.m.jordan@oracle.com>
To:     Herbert Xu <herbert@gondor.apana.org.au>,
        Steffen Klassert <steffen.klassert@secunet.com>
Cc:     linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        Daniel Jordan <daniel.m.jordan@oracle.com>
Subject: [PATCH 3/6] padata: inline single call of pd_setup_cpumasks()
Date:   Tue, 14 Jul 2020 16:13:53 -0400
Message-Id: <20200714201356.889176-4-daniel.m.jordan@oracle.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200714201356.889176-1-daniel.m.jordan@oracle.com>
References: <20200714201356.889176-1-daniel.m.jordan@oracle.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9682 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 malwarescore=0
 mlxscore=0 spamscore=0 phishscore=0 suspectscore=2 bulkscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2007140141
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9682 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 malwarescore=0 spamscore=0
 clxscore=1015 priorityscore=1501 mlxlogscore=999 lowpriorityscore=0
 bulkscore=0 suspectscore=2 phishscore=0 adultscore=0 impostorscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2007140141
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

pd_setup_cpumasks() has only one caller.  Move its contents inline to
prepare for the next cleanup.

Signed-off-by: Daniel Jordan <daniel.m.jordan@oracle.com>
Cc: Herbert Xu <herbert@gondor.apana.org.au>
Cc: Steffen Klassert <steffen.klassert@secunet.com>
Cc: linux-crypto@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
---
 kernel/padata.c | 32 +++++++++-----------------------
 1 file changed, 9 insertions(+), 23 deletions(-)

diff --git a/kernel/padata.c b/kernel/padata.c
index 8f55e717ba50b..27f90a3c4dc6b 100644
--- a/kernel/padata.c
+++ b/kernel/padata.c
@@ -441,28 +441,6 @@ static int padata_setup_cpumasks(struct padata_instance *pinst)
 	return err;
 }
 
-static int pd_setup_cpumasks(struct parallel_data *pd,
-			     const struct cpumask *pcpumask,
-			     const struct cpumask *cbcpumask)
-{
-	int err = -ENOMEM;
-
-	if (!alloc_cpumask_var(&pd->cpumask.pcpu, GFP_KERNEL))
-		goto out;
-	if (!alloc_cpumask_var(&pd->cpumask.cbcpu, GFP_KERNEL))
-		goto free_pcpu_mask;
-
-	cpumask_copy(pd->cpumask.pcpu, pcpumask);
-	cpumask_copy(pd->cpumask.cbcpu, cbcpumask);
-
-	return 0;
-
-free_pcpu_mask:
-	free_cpumask_var(pd->cpumask.pcpu);
-out:
-	return err;
-}
-
 static void __init padata_mt_helper(struct work_struct *w)
 {
 	struct padata_work *pw = container_of(w, struct padata_work, pw_work);
@@ -613,8 +591,14 @@ static struct parallel_data *padata_alloc_pd(struct padata_shell *ps)
 		goto err_free_pqueue;
 
 	pd->ps = ps;
-	if (pd_setup_cpumasks(pd, pcpumask, cbcpumask))
+
+	if (!alloc_cpumask_var(&pd->cpumask.pcpu, GFP_KERNEL))
 		goto err_free_squeue;
+	if (!alloc_cpumask_var(&pd->cpumask.cbcpu, GFP_KERNEL))
+		goto err_free_pcpu;
+
+	cpumask_copy(pd->cpumask.pcpu, pcpumask);
+	cpumask_copy(pd->cpumask.cbcpu, cbcpumask);
 
 	padata_init_pqueues(pd);
 	padata_init_squeues(pd);
@@ -626,6 +610,8 @@ static struct parallel_data *padata_alloc_pd(struct padata_shell *ps)
 
 	return pd;
 
+err_free_pcpu:
+	free_cpumask_var(pd->cpumask.pcpu);
 err_free_squeue:
 	free_percpu(pd->squeue);
 err_free_pqueue:
-- 
2.27.0


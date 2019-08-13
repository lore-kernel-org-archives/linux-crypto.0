Return-Path: <SRS0=ZPwR=WJ=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C79D7C433FF
	for <linux-crypto@archiver.kernel.org>; Tue, 13 Aug 2019 00:53:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 979E620665
	for <linux-crypto@archiver.kernel.org>; Tue, 13 Aug 2019 00:53:09 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="ljj1/Fuq";
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="BgVBxJBH"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726506AbfHMAxI (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 12 Aug 2019 20:53:08 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:54988 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726296AbfHMAxI (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 12 Aug 2019 20:53:08 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x7D0nMoh183576;
        Tue, 13 Aug 2019 00:52:49 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=corp-2019-08-05;
 bh=mzpN7aIIjiVBw2Ca3IS9VSdJfpiIorifKKRhclI4kho=;
 b=ljj1/Fuq0hyvIN7i+4u9WhWw2wkqMeexjNOyMcmP99ZA1RLcOBNgWDXtxSByPo+wtQMi
 MUS9XqYWUPuKkSc0fBuZClQnz3MH1zE2SzebB4EWZcnmTLFU1Ul3KpDuLboiiX5EDe/a
 EeGvZdrfDcuEeki1JpmoFkeAqpu0DDmgJOfPIDwuUofYSvW6MZgkl1Mm+io3XMv5Fw3R
 69bMEcStAmN/91o1O50wwtLLy/Gav3aUPebJ03/dTOvgn+8U5Y5xezNYtrVKaDWCxWF0
 qxQ4mCiU03wFIi13yZ1XPf8a/cKijoA04kCnoFjYBCHKQqurLcZJiaVxiPRrCPVUlYHh fA== 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=corp-2018-07-02;
 bh=mzpN7aIIjiVBw2Ca3IS9VSdJfpiIorifKKRhclI4kho=;
 b=BgVBxJBHev7Zu9RTdJBcylfHMUBmsdIHd2MmvgpZ3fik7OYkb48bUsqZfx4JWGXQjjHz
 z30aVMY2vdAdtWBU+99HRd7hX6vPwy1kLKz1Lrlz7sXguatKSfDqYuNr991ScCS4uyNZ
 C0WQEo2VPSTJd/rmHRg0hHwOvaEkZbeHJ5w5+WuzPQusPHJ2TGvXQlf1ycyDQl8W8/9t
 jPb3UoKPrVvm79KulFhaWR4/z6yU2np3v7G1xwCeWcXCP/ENa32rJl1D5Qyi+OJLiPEP
 m02RClK8puoaPkPKYMvNC1hmCX6WuqYsB7MevQQzPt4gj1iaGQ0YZRmJUBFrmiTkR8G5 Pg== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by aserp2120.oracle.com with ESMTP id 2u9nvp2v4d-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 13 Aug 2019 00:52:48 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x7D0nI3q152604;
        Tue, 13 Aug 2019 00:52:48 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userp3030.oracle.com with ESMTP id 2u9k1vuuyv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 13 Aug 2019 00:52:48 +0000
Received: from abhmp0022.oracle.com (abhmp0022.oracle.com [141.146.116.28])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x7D0ql07003301;
        Tue, 13 Aug 2019 00:52:47 GMT
Received: from parnassus.us.oracle.com (/10.39.240.231)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 12 Aug 2019 17:52:46 -0700
From:   Daniel Jordan <daniel.m.jordan@oracle.com>
To:     Herbert Xu <herbert@gondor.apana.org.au>,
        Steffen Klassert <steffen.klassert@secunet.com>
Cc:     Lai Jiangshan <jiangshanlai@gmail.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Tejun Heo <tj@kernel.org>,
        Daniel Jordan <daniel.m.jordan@oracle.com>,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 9/9] padata: remove cpu_index from the parallel_queue
Date:   Mon, 12 Aug 2019 20:52:24 -0400
Message-Id: <20190813005224.30779-10-daniel.m.jordan@oracle.com>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190813005224.30779-1-daniel.m.jordan@oracle.com>
References: <20190813005224.30779-1-daniel.m.jordan@oracle.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9347 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1906280000 definitions=main-1908130005
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9347 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1906280000
 definitions=main-1908130005
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

With the removal of the ENODATA case from padata_get_next, the cpu_index
field is no longer useful, so it can go away.

Signed-off-by: Daniel Jordan <daniel.m.jordan@oracle.com>
Cc: Herbert Xu <herbert@gondor.apana.org.au>
Cc: Lai Jiangshan <jiangshanlai@gmail.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Steffen Klassert <steffen.klassert@secunet.com>
Cc: Tejun Heo <tj@kernel.org>
Cc: linux-crypto@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
---
 include/linux/padata.h |  2 --
 kernel/padata.c        | 13 ++-----------
 2 files changed, 2 insertions(+), 13 deletions(-)

diff --git a/include/linux/padata.h b/include/linux/padata.h
index cc420064186f..a39c7b9cec3c 100644
--- a/include/linux/padata.h
+++ b/include/linux/padata.h
@@ -75,14 +75,12 @@ struct padata_serial_queue {
  * @swork: work struct for serialization.
  * @work: work struct for parallelization.
  * @num_obj: Number of objects that are processed by this cpu.
- * @cpu_index: Index of the cpu.
  */
 struct padata_parallel_queue {
        struct padata_list    parallel;
        struct padata_list    reorder;
        struct work_struct    work;
        atomic_t              num_obj;
-       int                   cpu_index;
 };
 
 /**
diff --git a/kernel/padata.c b/kernel/padata.c
index 5615f6b60dab..32e810bd4c47 100644
--- a/kernel/padata.c
+++ b/kernel/padata.c
@@ -399,21 +399,12 @@ static void padata_init_squeues(struct parallel_data *pd)
 /* Initialize all percpu queues used by parallel workers */
 static void padata_init_pqueues(struct parallel_data *pd)
 {
-	int cpu_index, cpu;
+	int cpu;
 	struct padata_parallel_queue *pqueue;
 
-	cpu_index = 0;
-	for_each_possible_cpu(cpu) {
+	for_each_cpu(cpu, pd->cpumask.pcpu) {
 		pqueue = per_cpu_ptr(pd->pqueue, cpu);
 
-		if (!cpumask_test_cpu(cpu, pd->cpumask.pcpu)) {
-			pqueue->cpu_index = -1;
-			continue;
-		}
-
-		pqueue->cpu_index = cpu_index;
-		cpu_index++;
-
 		__padata_list_init(&pqueue->reorder);
 		__padata_list_init(&pqueue->parallel);
 		INIT_WORK(&pqueue->work, padata_parallel_worker);
-- 
2.22.0


Return-Path: <SRS0=ze1v=CL=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 83505C433E7
	for <linux-crypto@archiver.kernel.org>; Wed,  2 Sep 2020 17:08:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 53EA320709
	for <linux-crypto@archiver.kernel.org>; Wed,  2 Sep 2020 17:08:12 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="CV+8cHsp"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726942AbgIBRIL (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 2 Sep 2020 13:08:11 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:35844 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726285AbgIBRIL (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 2 Sep 2020 13:08:11 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 082H4FSb145311;
        Wed, 2 Sep 2020 17:08:03 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : mime-version : content-transfer-encoding;
 s=corp-2020-01-29; bh=OwoqzT+xZqntsl1tMm1voSTpLuS3ETzRtHPm7Fje0T8=;
 b=CV+8cHspsEBhVy54xWeBBvXQUICGL5x6UZMbteqzRboYCF5IIIi44F+zdnzf+Db58RjD
 tInRnlq3VnBSNgi2dR8p1jYGFH9eMWyQzp9cHu09J9nhv68iJFzxU8KGzIiOpxELPEvA
 BwHC9C7E1BKnxdRJmPCdsRh94U1Hmey1/WpJCc4qEbPYy0L7wbyQDKFQzlSlZs1FKH/i
 7R9jTyHuY4M2vS6u1caNcgraONeLQoHXOUA0ouWg4Wa5rMliBxTBJz1eZ6ic2E1yxXMo
 t5HYRItMMDvKB3smPD0lTM7sxHx1kf29vsfPVQn/bVZvLWHOZJvviYH9+eiTfVsbNIGU eQ== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2120.oracle.com with ESMTP id 337eymbwu2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Wed, 02 Sep 2020 17:08:03 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 082H55th131744;
        Wed, 2 Sep 2020 17:08:02 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3020.oracle.com with ESMTP id 3380sub3t3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 02 Sep 2020 17:08:02 +0000
Received: from abhmp0002.oracle.com (abhmp0002.oracle.com [141.146.116.8])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 082H80E8027580;
        Wed, 2 Sep 2020 17:08:01 GMT
Received: from localhost.localdomain (/98.229.125.203)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 02 Sep 2020 10:08:00 -0700
From:   Daniel Jordan <daniel.m.jordan@oracle.com>
To:     Herbert Xu <herbert@gondor.apana.org.au>,
        Steffen Klassert <steffen.klassert@secunet.com>
Cc:     linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        Daniel Jordan <daniel.m.jordan@oracle.com>
Subject: [PATCH] padata: fix possible padata_works_lock deadlock
Date:   Wed,  2 Sep 2020 13:07:56 -0400
Message-Id: <20200902170756.332491-1-daniel.m.jordan@oracle.com>
X-Mailer: git-send-email 2.28.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9732 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 adultscore=0
 phishscore=0 malwarescore=0 mlxscore=0 spamscore=0 bulkscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2009020163
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9732 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 adultscore=0
 priorityscore=1501 phishscore=0 mlxlogscore=999 mlxscore=0
 lowpriorityscore=0 clxscore=1015 spamscore=0 bulkscore=0 impostorscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2009020163
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

syzbot reports,

  WARNING: inconsistent lock state
  5.9.0-rc2-syzkaller #0 Not tainted
  --------------------------------
  inconsistent {IN-SOFTIRQ-W} -> {SOFTIRQ-ON-W} usage.
  syz-executor.0/26715 takes:
  (padata_works_lock){+.?.}-{2:2}, at: padata_do_parallel kernel/padata.c:220
  {IN-SOFTIRQ-W} state was registered at:
    spin_lock include/linux/spinlock.h:354 [inline]
    padata_do_parallel kernel/padata.c:220
    ...
    __do_softirq kernel/softirq.c:298
    ...
    sysvec_apic_timer_interrupt arch/x86/kernel/apic/apic.c:1091
    asm_sysvec_apic_timer_interrupt arch/x86/include/asm/idtentry.h:581

   Possible unsafe locking scenario:

         CPU0
         ----
    lock(padata_works_lock);
    <Interrupt>
      lock(padata_works_lock);

padata_do_parallel() takes padata_works_lock with softirqs enabled, so a
deadlock is possible if, on the same CPU, the lock is acquired in
process context and then softirq handling done in an interrupt leads to
the same path.

Fix by leaving softirqs disabled while do_parallel holds
padata_works_lock.

Reported-by: syzbot+f4b9f49e38e25eb4ef52@syzkaller.appspotmail.com
Fixes: 4611ce2246889 ("padata: allocate work structures for parallel jobs from a pool")
Signed-off-by: Daniel Jordan <daniel.m.jordan@oracle.com>
Cc: Herbert Xu <herbert@gondor.apana.org.au>
Cc: Steffen Klassert <steffen.klassert@secunet.com>
Cc: linux-crypto@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
---
 kernel/padata.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/kernel/padata.c b/kernel/padata.c
index 16cb894dc272..d4d3ba6e1728 100644
--- a/kernel/padata.c
+++ b/kernel/padata.c
@@ -215,12 +215,13 @@ int padata_do_parallel(struct padata_shell *ps,
 	padata->pd = pd;
 	padata->cb_cpu = *cb_cpu;
 
-	rcu_read_unlock_bh();
-
 	spin_lock(&padata_works_lock);
 	padata->seq_nr = ++pd->seq_nr;
 	pw = padata_work_alloc();
 	spin_unlock(&padata_works_lock);
+
+	rcu_read_unlock_bh();
+
 	if (pw) {
 		padata_work_init(pw, padata_parallel_worker, padata, 0);
 		queue_work(pinst->parallel_wq, &pw->pw_work);

base-commit: 9c7d619be5a002ea29c172df5e3c1227c22cbb41
-- 
2.28.0


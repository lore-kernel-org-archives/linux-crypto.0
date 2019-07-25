Return-Path: <SRS0=g3pl=VW=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 71A80C76190
	for <linux-crypto@archiver.kernel.org>; Thu, 25 Jul 2019 21:25:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4A6E2218F0
	for <linux-crypto@archiver.kernel.org>; Thu, 25 Jul 2019 21:25:48 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="VJDvALEb"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726803AbfGYVZq (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 25 Jul 2019 17:25:46 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:54622 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726674AbfGYVZq (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 25 Jul 2019 17:25:46 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x6PLNQux028419;
        Thu, 25 Jul 2019 21:25:24 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=corp-2018-07-02;
 bh=0FHLYwXChjiQiSvTSooHeQULBjqit8SM8K4FegGSKjQ=;
 b=VJDvALEbh2WRLgJ51/lOw+GuVaIChEtBFMVzz7/5m656+BbbSE1Pp93KOvuF/C9ekWGj
 dRTl9WLuZV5CDpXGZPAIvVQIanEfDbADCQtquO4r6a4kijH7FHN4mdsfHRNdAcmN/SyY
 iAUdHLkgTOLPp+dw7pcsoqLcqDtM8HW1m5AK0hPrktlIXx9cJb9gb+XHAvJ9XOnlNETz
 x98DDCPF+9KKnhwoM6sFxrZjjhTiQPMXXVexeW1kesJ3oiq3Y2mbg/791zkvye+8vGye
 JXMNb8mz+FngZZpNyO5x0kK4FUZuuSHC9HGxI6HJwXTpSFJ5jrj37e00K8NGyhu4T7bn dg== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2130.oracle.com with ESMTP id 2tx61c6mev-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 25 Jul 2019 21:25:24 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x6PLNIT3066990;
        Thu, 25 Jul 2019 21:25:24 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userp3030.oracle.com with ESMTP id 2tx60yj90c-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 25 Jul 2019 21:25:24 +0000
Received: from abhmp0015.oracle.com (abhmp0015.oracle.com [141.146.116.21])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x6PLPKx1030875;
        Thu, 25 Jul 2019 21:25:22 GMT
Received: from localhost.localdomain (/73.60.114.248)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 25 Jul 2019 14:25:19 -0700
From:   Daniel Jordan <daniel.m.jordan@oracle.com>
To:     Steffen Klassert <steffen.klassert@secunet.com>,
        Herbert Xu <herbert@gondor.apana.org.au>
Cc:     Tejun Heo <tj@kernel.org>, Lai Jiangshan <jiangshanlai@gmail.com>,
        Peter Zijlstra <peterz@infradead.org>,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        Daniel Jordan <daniel.m.jordan@oracle.com>
Subject: [RFC 3/9] workqueue: require CPU hotplug read exclusion for apply_workqueue_attrs
Date:   Thu, 25 Jul 2019 17:24:59 -0400
Message-Id: <20190725212505.15055-4-daniel.m.jordan@oracle.com>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190725212505.15055-1-daniel.m.jordan@oracle.com>
References: <20190725212505.15055-1-daniel.m.jordan@oracle.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9329 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=914
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1906280000 definitions=main-1907250257
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9329 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=956 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1906280000
 definitions=main-1907250257
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Change the calling convention for apply_workqueue_attrs to require CPU
hotplug read exclusion.

Avoids lockdep complaints about nested calls to get_online_cpus in a
future patch where padata calls apply_workqueue_attrs when changing
other CPU-hotplug-sensitive data structures with the CPU read lock
already held.

Signed-off-by: Daniel Jordan <daniel.m.jordan@oracle.com>
---
 kernel/workqueue.c | 19 ++++++++++++++-----
 1 file changed, 14 insertions(+), 5 deletions(-)

diff --git a/kernel/workqueue.c b/kernel/workqueue.c
index f53705ff3ff1..bc2e09a8ea61 100644
--- a/kernel/workqueue.c
+++ b/kernel/workqueue.c
@@ -4030,6 +4030,8 @@ static int apply_workqueue_attrs_locked(struct workqueue_struct *wq,
  *
  * Performs GFP_KERNEL allocations.
  *
+ * Assumes caller has CPU hotplug read exclusion, i.e. get_online_cpus().
+ *
  * Return: 0 on success and -errno on failure.
  */
 int apply_workqueue_attrs(struct workqueue_struct *wq,
@@ -4037,9 +4039,11 @@ int apply_workqueue_attrs(struct workqueue_struct *wq,
 {
 	int ret;
 
-	apply_wqattrs_lock();
+	lockdep_assert_cpus_held();
+
+	mutex_lock(&wq_pool_mutex);
 	ret = apply_workqueue_attrs_locked(wq, attrs);
-	apply_wqattrs_unlock();
+	mutex_unlock(&wq_pool_mutex);
 
 	return ret;
 }
@@ -4152,16 +4156,21 @@ static int alloc_and_link_pwqs(struct workqueue_struct *wq)
 			mutex_unlock(&wq->mutex);
 		}
 		return 0;
-	} else if (wq->flags & __WQ_ORDERED) {
+	}
+
+	get_online_cpus();
+	if (wq->flags & __WQ_ORDERED) {
 		ret = apply_workqueue_attrs(wq, ordered_wq_attrs[highpri]);
 		/* there should only be single pwq for ordering guarantee */
 		WARN(!ret && (wq->pwqs.next != &wq->dfl_pwq->pwqs_node ||
 			      wq->pwqs.prev != &wq->dfl_pwq->pwqs_node),
 		     "ordering guarantee broken for workqueue %s\n", wq->name);
-		return ret;
 	} else {
-		return apply_workqueue_attrs(wq, unbound_std_wq_attrs[highpri]);
+		ret = apply_workqueue_attrs(wq, unbound_std_wq_attrs[highpri]);
 	}
+	put_online_cpus();
+
+	return ret;
 }
 
 static int wq_clamp_max_active(int max_active, unsigned int flags,
-- 
2.22.0


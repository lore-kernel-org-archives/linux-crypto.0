Return-Path: <SRS0=4a8U=XB=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6A6DEC43331
	for <linux-crypto@archiver.kernel.org>; Fri,  6 Sep 2019 01:41:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 672C2206A3
	for <linux-crypto@archiver.kernel.org>; Fri,  6 Sep 2019 01:41:10 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="i2n8oD0u"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2403987AbfIFBlI (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 5 Sep 2019 21:41:08 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:47266 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2391150AbfIFBlG (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 5 Sep 2019 21:41:06 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x861cktU029107;
        Fri, 6 Sep 2019 01:40:44 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=corp-2019-08-05;
 bh=Ws2aR+Add5xNm/Tkp7hM9s0Hd53px/3jGUbROhNSGYI=;
 b=i2n8oD0uhjxa4stMYdgeaFTdAoGJ9+/UOt/ICJx5KlYaUyRnnIAJL1z7ltNVc9oY0NfC
 eBdu58+9N10KJxtzNFq2OQyd4XOm1nALpPMrahHnO671GvQwGVdMrw+qwJCklbfG1fVt
 W/YeMizjAFU0YTB3HFivloUZk2KWoPBlDgLzNPIcGFLGO6Rm0tQ9/vtMX0g5003ksW+2
 KJZ9yWpLbBk/0uyw4zbwaYw1xECdV1eJ90KCjylRuPRjU2/3hAfwJF+w9ZNy75x3MOaC
 5sXCI6Bc0+SBUN7kxkcZa3l5xhvJwBqqvhmzm6zzRD2vGnygY1OeC3HuJMHSTW6Rkif3 zA== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2130.oracle.com with ESMTP id 2uudjs02rh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 06 Sep 2019 01:40:44 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x861cXnN188294;
        Fri, 6 Sep 2019 01:40:43 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3030.oracle.com with ESMTP id 2utpmc44vv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 06 Sep 2019 01:40:43 +0000
Received: from abhmp0009.oracle.com (abhmp0009.oracle.com [141.146.116.15])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x861eejJ004040;
        Fri, 6 Sep 2019 01:40:40 GMT
Received: from localhost.localdomain (/98.229.125.203)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 05 Sep 2019 18:40:40 -0700
From:   Daniel Jordan <daniel.m.jordan@oracle.com>
To:     Herbert Xu <herbert@gondor.apana.org.au>,
        Steffen Klassert <steffen.klassert@secunet.com>
Cc:     Lai Jiangshan <jiangshanlai@gmail.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Tejun Heo <tj@kernel.org>, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Daniel Jordan <daniel.m.jordan@oracle.com>
Subject: [PATCH v3 3/9] workqueue: require CPU hotplug read exclusion for apply_workqueue_attrs
Date:   Thu,  5 Sep 2019 21:40:23 -0400
Message-Id: <20190906014029.3345-4-daniel.m.jordan@oracle.com>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20190906014029.3345-1-daniel.m.jordan@oracle.com>
References: <20190906014029.3345-1-daniel.m.jordan@oracle.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9371 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1906280000 definitions=main-1909060015
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9371 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1906280000
 definitions=main-1909060016
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
Acked-by: Tejun Heo <tj@kernel.org>
Acked-by: Steffen Klassert <steffen.klassert@secunet.com>
Cc: Herbert Xu <herbert@gondor.apana.org.au>
Cc: Lai Jiangshan <jiangshanlai@gmail.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: linux-crypto@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
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
2.23.0


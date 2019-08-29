Return-Path: <SRS0=oY6L=WZ=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 25F8FC3A59F
	for <linux-crypto@archiver.kernel.org>; Thu, 29 Aug 2019 17:33:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id EB87621874
	for <linux-crypto@archiver.kernel.org>; Thu, 29 Aug 2019 17:33:39 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="UMrBqw9r"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727662AbfH2Rdj (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 29 Aug 2019 13:33:39 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:45278 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727437AbfH2Rdj (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 29 Aug 2019 13:33:39 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x7THSwKi129069;
        Thu, 29 Aug 2019 17:33:26 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=corp-2019-08-05;
 bh=Ws2aR+Add5xNm/Tkp7hM9s0Hd53px/3jGUbROhNSGYI=;
 b=UMrBqw9rOcIo2TzGlprYUYIAkA4po19Oi9QCTIlczTpp+H0qlYeMgTQva1Q4UdAeGD4S
 uaL9wBpd2wgPv6+UykiPllQMRRLrfEq8DgzQsaa3jRlYgmmHdtphNvd9DU+tDORDYWnv
 9uTcyttOIr4sP/OcmhFO9v2CfSoHmgsvIDVOWnEgrbNw/DUlny2QEZvtUBw5KYH5vpdH
 IEK8NlU8UgY6LRAoKdH8o353L8befm0TUvvl5MOCokzW0VTYC4ZOXJa6yai+Ri2XJUIx
 wDZEdHkSA7ftOCrJv9o0h0Bl4X9Ec7XZmTiGLAgeP2tgVQ0At33IUnDynyVcxUkeQ3RL fw== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2120.oracle.com with ESMTP id 2upk4sr12n-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 29 Aug 2019 17:33:26 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x7THWdC0008284;
        Thu, 29 Aug 2019 17:33:26 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userp3030.oracle.com with ESMTP id 2unvu0b33f-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 29 Aug 2019 17:33:26 +0000
Received: from abhmp0008.oracle.com (abhmp0008.oracle.com [141.146.116.14])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x7THWc28017268;
        Thu, 29 Aug 2019 17:32:38 GMT
Received: from zissou.us.oracle.com (/10.152.34.58)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 29 Aug 2019 10:32:38 -0700
From:   Daniel Jordan <daniel.m.jordan@oracle.com>
To:     Herbert Xu <herbert@gondor.apana.org.au>,
        Steffen Klassert <steffen.klassert@secunet.com>
Cc:     Lai Jiangshan <jiangshanlai@gmail.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Tejun Heo <tj@kernel.org>, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Daniel Jordan <daniel.m.jordan@oracle.com>
Subject: [PATCH v2 3/9] workqueue: require CPU hotplug read exclusion for apply_workqueue_attrs
Date:   Thu, 29 Aug 2019 13:30:32 -0400
Message-Id: <20190829173038.21040-4-daniel.m.jordan@oracle.com>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20190829173038.21040-1-daniel.m.jordan@oracle.com>
References: <20190829173038.21040-1-daniel.m.jordan@oracle.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9364 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1906280000 definitions=main-1908290186
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9364 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1906280000
 definitions=main-1908290185
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


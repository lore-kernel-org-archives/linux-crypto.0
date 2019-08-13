Return-Path: <SRS0=ZPwR=WJ=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 06CBCC31E40
	for <linux-crypto@archiver.kernel.org>; Tue, 13 Aug 2019 00:53:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C903D20842
	for <linux-crypto@archiver.kernel.org>; Tue, 13 Aug 2019 00:53:43 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="kGq6Z3wM";
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="TSDDB9z7"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726812AbfHMAxK (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 12 Aug 2019 20:53:10 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:57688 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726479AbfHMAxJ (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 12 Aug 2019 20:53:09 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x7D0nLGK169568;
        Tue, 13 Aug 2019 00:52:44 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=corp-2019-08-05;
 bh=+UFpeHPZGWbRDyVWDlcfr2GRxu8zhevSNwDBLd7lC84=;
 b=kGq6Z3wMGroOOFbgvS/Xezf0bZgL5zXJMATCYqq3JnhGJuA4u2S0n2S5v6WYk/XXmLxt
 iLBzpsnZP6OSglqrm7Yr2fWKzhHo5AWF+7IFGhsbqCxx/0IAK47JtSkzNwNMnthjiC0E
 X68VlTiZUoQDfWTbj9CxWENwCIILjLvCk0iC9+Igdo0ShkTizdtkTmFsGzppFojIKFeW
 p8EwsXiptpWK6ZhhnVMaYRywy7OKx0BR7eoF4cvArhcMUw/vmNI22Gnwraqlv8AzcVma
 UgOdetArehFxK6zYPXCvT7G3kAatTEZ3LFHtO7B4NqRzFFLHkIgyp4pcaIhABGM8iqU/ dw== 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=corp-2018-07-02;
 bh=+UFpeHPZGWbRDyVWDlcfr2GRxu8zhevSNwDBLd7lC84=;
 b=TSDDB9z7vlZUdIQxmrNCMGtVy+rEFGe9u1vv/9kOFEl9fB/mxVji5UgRMD4Sl2XbBn1v
 a7a3HTsYk2hYNIz4TJNXuTRGS7ztExLT5EUkUMWGqOUzHq0FdUFKFhrKWZTyCjCR9FAq
 rIDmDXsBDWHJ28cLif6ftqcQGLRaVsZfplAB9j/ZQ63BvXBklUhR9tpbBzz1Vdm8i9gj
 3VaXiPUq3JtZBo7EPI7DSpwinpXcqL+DHR48usrTiIhIOkddP7YkEBCRbUfMGtTtmPEe
 fu96QSRJc6G6qIlYsamhkL/Q7FW+RIfYWctwmPSZPtdpABUv+SSmk4vmgieyDFmoDD5E uA== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2120.oracle.com with ESMTP id 2u9pjqarhp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 13 Aug 2019 00:52:44 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x7D0nDSL113020;
        Tue, 13 Aug 2019 00:52:43 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserp3020.oracle.com with ESMTP id 2u9nrees0r-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 13 Aug 2019 00:52:43 +0000
Received: from abhmp0022.oracle.com (abhmp0022.oracle.com [141.146.116.28])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x7D0qg0b018000;
        Tue, 13 Aug 2019 00:52:42 GMT
Received: from parnassus.us.oracle.com (/10.39.240.231)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 12 Aug 2019 17:52:41 -0700
From:   Daniel Jordan <daniel.m.jordan@oracle.com>
To:     Herbert Xu <herbert@gondor.apana.org.au>,
        Steffen Klassert <steffen.klassert@secunet.com>
Cc:     Lai Jiangshan <jiangshanlai@gmail.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Tejun Heo <tj@kernel.org>,
        Daniel Jordan <daniel.m.jordan@oracle.com>,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 3/9] workqueue: require CPU hotplug read exclusion for apply_workqueue_attrs
Date:   Mon, 12 Aug 2019 20:52:18 -0400
Message-Id: <20190813005224.30779-4-daniel.m.jordan@oracle.com>
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

Change the calling convention for apply_workqueue_attrs to require CPU
hotplug read exclusion.

Avoids lockdep complaints about nested calls to get_online_cpus in a
future patch where padata calls apply_workqueue_attrs when changing
other CPU-hotplug-sensitive data structures with the CPU read lock
already held.

Signed-off-by: Daniel Jordan <daniel.m.jordan@oracle.com>
Acked-by: Tejun Heo <tj@kernel.org>
Cc: Herbert Xu <herbert@gondor.apana.org.au>
Cc: Lai Jiangshan <jiangshanlai@gmail.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Steffen Klassert <steffen.klassert@secunet.com>
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
2.22.0


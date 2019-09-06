Return-Path: <SRS0=4a8U=XB=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AD530C00306
	for <linux-crypto@archiver.kernel.org>; Fri,  6 Sep 2019 01:41:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A1DC7207E0
	for <linux-crypto@archiver.kernel.org>; Fri,  6 Sep 2019 01:41:04 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="rqY5bWgU"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388209AbfIFBlD (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 5 Sep 2019 21:41:03 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:55442 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731742AbfIFBlC (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 5 Sep 2019 21:41:02 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x861cqQT023870;
        Fri, 6 Sep 2019 01:40:44 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=corp-2019-08-05;
 bh=iZ4QyHpnZ3dJ0ZjVi3s0EvKqwDLy7Ecmy+dhvh8PM68=;
 b=rqY5bWgUnv4GMHUgWkrsMICpB5p8+cbU04ec1vs72AhzKDWF1BNCxR0VyP2Q3TjrsHfb
 QXmQVzuzaG71c0PY9+Y2N1wjoZcR0K/JCO+INsetAYtnbtBdqlZhRgvgVMQB7zM9M96b
 GjLqDkaJ9dEaY6s5iIfFNcRwXzAF40jsB/RVptNTOCzA+fRu9kYjh/DdJF9YvvRXQg8A
 Hiew2nWmBgZVA6+CD4Ommd1hPVFyhTE0qYmNbiwbY3j1durwcpSY7QhHfvgvbWdMdYRR
 2QuQsu07tNvA7L2J6ejsWK76Qa+OutojeRae98Cvw3s7VhOIyOCGaZgB39RW1ebHus7X LQ== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2120.oracle.com with ESMTP id 2uudhy834x-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 06 Sep 2019 01:40:44 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x861cWDh188252;
        Fri, 6 Sep 2019 01:40:43 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3030.oracle.com with ESMTP id 2utpmc44vw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 06 Sep 2019 01:40:43 +0000
Received: from abhmp0009.oracle.com (abhmp0009.oracle.com [141.146.116.15])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x861edLP004018;
        Fri, 6 Sep 2019 01:40:39 GMT
Received: from localhost.localdomain (/98.229.125.203)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 05 Sep 2019 18:40:39 -0700
From:   Daniel Jordan <daniel.m.jordan@oracle.com>
To:     Herbert Xu <herbert@gondor.apana.org.au>,
        Steffen Klassert <steffen.klassert@secunet.com>
Cc:     Lai Jiangshan <jiangshanlai@gmail.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Tejun Heo <tj@kernel.org>, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Daniel Jordan <daniel.m.jordan@oracle.com>
Subject: [PATCH v3 2/9] workqueue: unconfine alloc/apply/free_workqueue_attrs()
Date:   Thu,  5 Sep 2019 21:40:22 -0400
Message-Id: <20190906014029.3345-3-daniel.m.jordan@oracle.com>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20190906014029.3345-1-daniel.m.jordan@oracle.com>
References: <20190906014029.3345-1-daniel.m.jordan@oracle.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9371 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=2 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1906280000 definitions=main-1909060015
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9371 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=2 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1906280000
 definitions=main-1909060016
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

padata will use these these interfaces in a later patch, so unconfine them.

Signed-off-by: Daniel Jordan <daniel.m.jordan@oracle.com>
Acked-by: Tejun Heo <tj@kernel.org>
Acked-by: Steffen Klassert <steffen.klassert@secunet.com>
Cc: Herbert Xu <herbert@gondor.apana.org.au>
Cc: Lai Jiangshan <jiangshanlai@gmail.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: linux-crypto@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
---
 include/linux/workqueue.h | 4 ++++
 kernel/workqueue.c        | 6 +++---
 2 files changed, 7 insertions(+), 3 deletions(-)

diff --git a/include/linux/workqueue.h b/include/linux/workqueue.h
index b7c585b5ec1c..4261d1c6e87b 100644
--- a/include/linux/workqueue.h
+++ b/include/linux/workqueue.h
@@ -435,6 +435,10 @@ struct workqueue_struct *alloc_workqueue(const char *fmt,
 
 extern void destroy_workqueue(struct workqueue_struct *wq);
 
+struct workqueue_attrs *alloc_workqueue_attrs(void);
+void free_workqueue_attrs(struct workqueue_attrs *attrs);
+int apply_workqueue_attrs(struct workqueue_struct *wq,
+			  const struct workqueue_attrs *attrs);
 int workqueue_set_unbound_cpumask(cpumask_var_t cpumask);
 
 extern bool queue_work_on(int cpu, struct workqueue_struct *wq,
diff --git a/kernel/workqueue.c b/kernel/workqueue.c
index 601d61150b65..f53705ff3ff1 100644
--- a/kernel/workqueue.c
+++ b/kernel/workqueue.c
@@ -3329,7 +3329,7 @@ EXPORT_SYMBOL_GPL(execute_in_process_context);
  *
  * Undo alloc_workqueue_attrs().
  */
-static void free_workqueue_attrs(struct workqueue_attrs *attrs)
+void free_workqueue_attrs(struct workqueue_attrs *attrs)
 {
 	if (attrs) {
 		free_cpumask_var(attrs->cpumask);
@@ -3345,7 +3345,7 @@ static void free_workqueue_attrs(struct workqueue_attrs *attrs)
  *
  * Return: The allocated new workqueue_attr on success. %NULL on failure.
  */
-static struct workqueue_attrs *alloc_workqueue_attrs(void)
+struct workqueue_attrs *alloc_workqueue_attrs(void)
 {
 	struct workqueue_attrs *attrs;
 
@@ -4032,7 +4032,7 @@ static int apply_workqueue_attrs_locked(struct workqueue_struct *wq,
  *
  * Return: 0 on success and -errno on failure.
  */
-static int apply_workqueue_attrs(struct workqueue_struct *wq,
+int apply_workqueue_attrs(struct workqueue_struct *wq,
 			  const struct workqueue_attrs *attrs)
 {
 	int ret;
-- 
2.23.0


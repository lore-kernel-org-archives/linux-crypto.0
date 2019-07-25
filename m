Return-Path: <SRS0=g3pl=VW=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E4925C76190
	for <linux-crypto@archiver.kernel.org>; Thu, 25 Jul 2019 21:26:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B9FAB22BF5
	for <linux-crypto@archiver.kernel.org>; Thu, 25 Jul 2019 21:26:07 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="cAwVKBMb"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726817AbfGYVZs (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 25 Jul 2019 17:25:48 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:54674 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726805AbfGYVZr (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 25 Jul 2019 17:25:47 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x6PLNt5p028711;
        Thu, 25 Jul 2019 21:25:25 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=corp-2018-07-02;
 bh=Rl5zKs4e7TLkh5L9k95As/3+ePV4kn0EOJ93KQGkcbo=;
 b=cAwVKBMbgxni+nV7KTunHBxxzeLRAIXfvKo5pknhrZHOPJwdxasCwo62QP/JXSVyyibF
 pMqpC258ZJSW0XJEHiVjCai0jPchcCW86QBgT/Fq6UHPe7ur0N8plYrK6o1nzJqJA22I
 I5rrq7K3KCVFLQBACs0UMF/ul6C3+RZcrrVmrcvagk8VjYZLDVn3NP0+ew+Hjm81mEO6
 VKcX3LxVb7YiW6EzbfwvfyCbUYeXc7/ARzLpApDCXLqOqrphpZhp3SvFUWHGo9wyBg//
 OZ7q5MShl1xP9pS/u4Icl1tvIrK8PAQn5GXyRyAEIN9qQT5HdWjLwdRfLwzMVjrG791W TA== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2130.oracle.com with ESMTP id 2tx61c6mew-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 25 Jul 2019 21:25:25 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x6PLNJ0K188233;
        Thu, 25 Jul 2019 21:25:24 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserp3030.oracle.com with ESMTP id 2tx60y2ak3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 25 Jul 2019 21:25:24 +0000
Received: from abhmp0015.oracle.com (abhmp0015.oracle.com [141.146.116.21])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x6PLPJcb030872;
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
Subject: [RFC 2/9] workqueue: unconfine alloc/apply/free_workqueue_attrs()
Date:   Thu, 25 Jul 2019 17:24:58 -0400
Message-Id: <20190725212505.15055-3-daniel.m.jordan@oracle.com>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190725212505.15055-1-daniel.m.jordan@oracle.com>
References: <20190725212505.15055-1-daniel.m.jordan@oracle.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9329 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=2 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1906280000 definitions=main-1907250257
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9329 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=2 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1906280000
 definitions=main-1907250257
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

padata will use these these interfaces in a later patch, so unconfine them.

Signed-off-by: Daniel Jordan <daniel.m.jordan@oracle.com>
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
2.22.0


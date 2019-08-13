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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2AC25C31E40
	for <linux-crypto@archiver.kernel.org>; Tue, 13 Aug 2019 00:53:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id F125120842
	for <linux-crypto@archiver.kernel.org>; Tue, 13 Aug 2019 00:53:41 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="SLtCcXri";
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="0kF9NH+j"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726840AbfHMAxL (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 12 Aug 2019 20:53:11 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:57702 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726500AbfHMAxJ (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 12 Aug 2019 20:53:09 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x7D0nBV6169453;
        Tue, 13 Aug 2019 00:52:44 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=corp-2019-08-05;
 bh=CT6nTlCbs+AsQGYVsukxL/kI65aqfaEpFUlje0rP+2Y=;
 b=SLtCcXriWE55+awG3VEoOjHY9pHc+mQ8YrGTjD6jIxitjSwZyu1rrFGU1SCEeGTgO8pW
 3AfRsamyUgaB+6UV0Qi2X+SHer4YgIk3UPnLV8HUTcemmMOcamIer/RJoYZ7zpCHDN5b
 M8LkgMWOz30YZEyEzziIjlKJx7ws2KLDKi3GnxbGuSlcRUyOzqXb9tIeZNF7Na9UNzu5
 D0FQoEmBmF218L5pMPYKPl611XMfvUIRIEfzRiUDHcmYWXqQCTHNpmHEH3DViE+M23+p
 SyKBv/umX+nWuZINTcXCS9/zdocD4MH23TXJVwm5e1j1yEBGVYBZelfVnNeWHLzwDIWk Dg== 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=corp-2018-07-02;
 bh=CT6nTlCbs+AsQGYVsukxL/kI65aqfaEpFUlje0rP+2Y=;
 b=0kF9NH+jR1DzqnPI6e2lg70J+tsJUicNbmHI42UwBj+JH5KuLN6W9uR9d0kX9naY/aXS
 6PiqYURf8bwYqhHCeEZ0xotRfHv9cIy9Wa+/6qvNTyEXPU215zdjCIKMTq65rB6KqqPf
 F46kaWyijr64+NtXUYH+QTIe+l7m3lk75BLpjWoLafhkJ7JxpSvgbmeTcUA6ts+23SH4
 cWhcYvkdZ/w91lpSX3NSUurPBhkpntR+4YquiZytEvCRkl5Qm9kbxmta3dyRQvpBj3KO
 3Bip/iF29ke8Q0oN72e+dWbYbS429dnA9egpkjDAIkGQgfEziyhT3rNwX+iX7OPDXBcp 4w== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2120.oracle.com with ESMTP id 2u9pjqarhn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 13 Aug 2019 00:52:43 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x7D0m807167045;
        Tue, 13 Aug 2019 00:52:43 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userp3020.oracle.com with ESMTP id 2u9n9hh86g-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 13 Aug 2019 00:52:43 +0000
Received: from abhmp0022.oracle.com (abhmp0022.oracle.com [141.146.116.28])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x7D0qfa9003237;
        Tue, 13 Aug 2019 00:52:41 GMT
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
Subject: [PATCH 2/9] workqueue: unconfine alloc/apply/free_workqueue_attrs()
Date:   Mon, 12 Aug 2019 20:52:17 -0400
Message-Id: <20190813005224.30779-3-daniel.m.jordan@oracle.com>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190813005224.30779-1-daniel.m.jordan@oracle.com>
References: <20190813005224.30779-1-daniel.m.jordan@oracle.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9347 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=2 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1906280000 definitions=main-1908130005
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9347 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=2 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1906280000
 definitions=main-1908130005
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

padata will use these these interfaces in a later patch, so unconfine them.

Signed-off-by: Daniel Jordan <daniel.m.jordan@oracle.com>
Acked-by: Tejun Heo <tj@kernel.org>
Cc: Herbert Xu <herbert@gondor.apana.org.au>
Cc: Lai Jiangshan <jiangshanlai@gmail.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Steffen Klassert <steffen.klassert@secunet.com>
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
2.22.0


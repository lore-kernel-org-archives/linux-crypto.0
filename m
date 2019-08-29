Return-Path: <SRS0=oY6L=WZ=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AC1CFC3A59F
	for <linux-crypto@archiver.kernel.org>; Thu, 29 Aug 2019 17:34:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7ED8B2189D
	for <linux-crypto@archiver.kernel.org>; Thu, 29 Aug 2019 17:34:57 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="Y44Q+1Mu"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726973AbfH2Re4 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 29 Aug 2019 13:34:56 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:47160 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727410AbfH2Re4 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 29 Aug 2019 13:34:56 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x7THTscS121544;
        Thu, 29 Aug 2019 17:32:40 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=corp-2019-08-05;
 bh=iZ4QyHpnZ3dJ0ZjVi3s0EvKqwDLy7Ecmy+dhvh8PM68=;
 b=Y44Q+1MuaTD1Ln8/DNfqVK765JLPzp5FHBxnbIgStfH6EEaQptW2achD6m0fMIrEsD3v
 iLztDlSHc2KEvesH7ZvvUzIvH5dAnwQ99r+R+BGOyrPr4mi270emlEaRixozvRLCg7Ke
 VjhNyvPr5jf4iPqA5Lj8dU6tQ2CRA1hi82CouBm2Zd1pSHDWIvL1wDbIuqWuFQ4+GO5g
 nU54u8cLEB4AGHmkI+lumlBrA5Poh6RADRJWh6GfjC6JCNJ05Vjs7heMJkuNS/GQjJj4
 zeuOyg2PCVAE2iVm/VcFwMNLcBe+0dcXMRdHaT583JTvuk1/XN3AkNTCzRfAG+HLKcd+ NQ== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2130.oracle.com with ESMTP id 2upk56r0r2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 29 Aug 2019 17:32:40 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x7THWbVR008176;
        Thu, 29 Aug 2019 17:32:40 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userp3030.oracle.com with ESMTP id 2unvu0b2bv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 29 Aug 2019 17:32:39 +0000
Received: from abhmp0008.oracle.com (abhmp0008.oracle.com [141.146.116.14])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x7THWchh015178;
        Thu, 29 Aug 2019 17:32:38 GMT
Received: from zissou.us.oracle.com (/10.152.34.58)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 29 Aug 2019 10:32:37 -0700
From:   Daniel Jordan <daniel.m.jordan@oracle.com>
To:     Herbert Xu <herbert@gondor.apana.org.au>,
        Steffen Klassert <steffen.klassert@secunet.com>
Cc:     Lai Jiangshan <jiangshanlai@gmail.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Tejun Heo <tj@kernel.org>, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Daniel Jordan <daniel.m.jordan@oracle.com>
Subject: [PATCH v2 2/9] workqueue: unconfine alloc/apply/free_workqueue_attrs()
Date:   Thu, 29 Aug 2019 13:30:31 -0400
Message-Id: <20190829173038.21040-3-daniel.m.jordan@oracle.com>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20190829173038.21040-1-daniel.m.jordan@oracle.com>
References: <20190829173038.21040-1-daniel.m.jordan@oracle.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9364 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=2 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1906280000 definitions=main-1908290186
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9364 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=2 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1906280000
 definitions=main-1908290185
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


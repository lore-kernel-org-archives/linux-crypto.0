Return-Path: <SRS0=O5Fb=WI=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E5E05C433FF
	for <linux-crypto@archiver.kernel.org>; Mon, 12 Aug 2019 21:02:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B068020842
	for <linux-crypto@archiver.kernel.org>; Mon, 12 Aug 2019 21:02:20 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="JpCMSKJx";
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="sCg5UXi7"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726144AbfHLVCT (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 12 Aug 2019 17:02:19 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:39412 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726663AbfHLVCT (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 12 Aug 2019 17:02:19 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x7CKwfo2001766;
        Mon, 12 Aug 2019 21:02:08 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=corp-2019-08-05;
 bh=8v5ewYFjrCTDzF3BX4DOpWAFLC7ncCV9cpa2YE8L4Zw=;
 b=JpCMSKJxNiBihN+XUr7Qs8Kp5uMED6z06VaIy3pKkJy9SZ7VMismJBXRbk3vtKfdVJDk
 P1PCC57c2duWzRDccouM92uOuNlwtv5oHpnQg9rjg7tRgHZiSVYP50rNgyEFCvSobNbV
 JXvjjDqTmWjqsKVxvSfznhK2c5ETbyyhaODZwQlWldYrWsNdsStE7HZNaGQmFieDNKX9
 OV7X055033lqUUlO8LKJOj3z7Vv8WciYVtg39/EzPFeH/9lHw7cxaiBF5Ii+9Yaejwj1
 jdKpK7TF8ytnQGO9rZTwf1BtrN749PZ55Y6TbZk+VnbAn5SiTNZchLfXgg7K4Eifad2Z JQ== 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=corp-2018-07-02;
 bh=8v5ewYFjrCTDzF3BX4DOpWAFLC7ncCV9cpa2YE8L4Zw=;
 b=sCg5UXi7sqXmZxU6krn/lamt8vu2xvc7hSAkH9QOX5St7WH28xkvO2mg2vrEdLuW1LRK
 +JTQrOJx2rye5RrmT83vs24IEHwtPWeG1jbWx1cmlTVhe5HGn4iD9gsOjPjg2/PgWUNm
 97gT3Ll4o8cRzC4kS1A6JycePb9xXvl8j/CFV8Jn31a627GrzIiEmPMTiZoriN/oEGOW
 TtgSq5x19c5LSGQ1+NXiaNQh/NGEr4cNNl0SgTjTmqLZqHRr2BVHK6bRpUBThm9rQ4tj
 ttU+XDYApUP/mywoX7b1hER9kSXy3O9bjVPYxfXAcNZqsTmdr3KXLXuTfs86Z8oqM3Mp 7Q== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2120.oracle.com with ESMTP id 2u9pjqa2em-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 12 Aug 2019 21:02:07 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x7CKva67017187;
        Mon, 12 Aug 2019 21:02:07 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3020.oracle.com with ESMTP id 2u9nre9hqs-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 12 Aug 2019 21:02:06 +0000
Received: from abhmp0008.oracle.com (abhmp0008.oracle.com [141.146.116.14])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x7CL25pr024438;
        Mon, 12 Aug 2019 21:02:06 GMT
Received: from parnassus.us.oracle.com (/10.39.240.231)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 12 Aug 2019 14:02:05 -0700
From:   Daniel Jordan <daniel.m.jordan@oracle.com>
To:     Herbert Xu <herbert@gondor.apana.org.au>,
        Steffen Klassert <steffen.klassert@secunet.com>
Cc:     Daniel Jordan <daniel.m.jordan@oracle.com>,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 3/2] padata: initialize usable masks to reflect offlined CPU
Date:   Mon, 12 Aug 2019 17:02:00 -0400
Message-Id: <20190812210200.13653-1-daniel.m.jordan@oracle.com>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190809210603.20900-1-daniel.m.jordan@oracle.com>
References: <20190809210603.20900-1-daniel.m.jordan@oracle.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9347 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1906280000 definitions=main-1908120204
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9347 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1906280000
 definitions=main-1908120204
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

__padata_remove_cpu clears the offlined CPU from the usable masks after
padata_alloc_pd has initialized pd->cpu, which means pd->cpu could be
initialized to this CPU, causing padata to wait indefinitely for the
next job in padata_get_next.

Make the usable masks reflect the offline CPU when they're established
in padata_setup_cpumasks so pd->cpu is initialized properly.

Fixes: 6fc4dbcf0276 ("padata: Replace delayed timer with immediate workqueue in padata_reorder")
Signed-off-by: Daniel Jordan <daniel.m.jordan@oracle.com>
Cc: Herbert Xu <herbert@gondor.apana.org.au>
Cc: Steffen Klassert <steffen.klassert@secunet.com>
Cc: linux-crypto@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
---

Hi, one more edge case.  All combinations of CPUs among
parallel_cpumask, serial_cpumask, and CPU hotplug have now been tested
in a 4-CPU VM, and an 8-CPU VM has run with random combinations of these
settings for over an hour.

 kernel/padata.c | 18 ++++++++++++++----
 1 file changed, 14 insertions(+), 4 deletions(-)

diff --git a/kernel/padata.c b/kernel/padata.c
index 01460ea1d160..c1002ac4720c 100644
--- a/kernel/padata.c
+++ b/kernel/padata.c
@@ -702,17 +702,27 @@ static int __padata_remove_cpu(struct padata_instance *pinst, int cpu)
 	struct parallel_data *pd = NULL;
 
 	if (cpumask_test_cpu(cpu, cpu_online_mask)) {
+		cpumask_var_t pcpu, cbcpu;
+
 		__padata_stop(pinst);
 
-		pd = padata_alloc_pd(pinst, pinst->cpumask.pcpu,
-				     pinst->cpumask.cbcpu);
+		/*
+		 * padata_alloc_pd uses cpu_online_mask to get the usable
+		 * masks, but @cpu hasn't been removed from it yet, so use
+		 * temporary masks that exclude @cpu so the usable masks show
+		 * @cpu as offline for pd->cpu's initialization.
+		 */
+		cpumask_copy(pcpu, pinst->cpumask.pcpu);
+		cpumask_copy(cbcpu, pinst->cpumask.cbcpu);
+		cpumask_clear_cpu(cpu, cbcpu);
+		cpumask_clear_cpu(cpu, pcpu);
+
+		pd = padata_alloc_pd(pinst, pcpu, cbcpu);
 		if (!pd)
 			return -ENOMEM;
 
 		padata_replace(pinst, pd);
 
-		cpumask_clear_cpu(cpu, pd->cpumask.cbcpu);
-		cpumask_clear_cpu(cpu, pd->cpumask.pcpu);
 		if (padata_validate_cpumask(pinst, pd->cpumask.pcpu) &&
 		    padata_validate_cpumask(pinst, pd->cpumask.cbcpu))
 			__padata_start(pinst);
-- 
2.22.0


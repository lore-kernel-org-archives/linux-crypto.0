Return-Path: <SRS0=9Lzg=36=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0D548C35254
	for <linux-crypto@archiver.kernel.org>; Mon, 10 Feb 2020 18:12:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id CDE692082F
	for <linux-crypto@archiver.kernel.org>; Mon, 10 Feb 2020 18:12:06 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="AHydNlab"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727008AbgBJSMG (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 10 Feb 2020 13:12:06 -0500
Received: from userp2120.oracle.com ([156.151.31.85]:48354 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726950AbgBJSMG (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 10 Feb 2020 13:12:06 -0500
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 01AI8uWu036290;
        Mon, 10 Feb 2020 18:11:52 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : mime-version : content-transfer-encoding;
 s=corp-2020-01-29; bh=4Dz+xdTC0pyqzvmxbR9PP6Nk9yWbFPEzmCFhMkp3zl0=;
 b=AHydNlabaUzcer8clu8J6yy7inGPR/6edLvJuXrrwlaRDdveZ9lIUFBMxwXb3JzIB1HM
 n16JLe+p8yOVuxB8KVt6Io9HO73IlyBLbE1748rsWka+F+6uNi51RSYe7INc8/kJH1t4
 aJWHqGGv5t8kBa8YtdXyap35wWYE14k8HHK7nhhQDIsjsNF66TMlvkCT4FSa30LA7qVM
 RuTJf52rfY8DAVqZTGxiRF9eyHFnLFSIRvwvOIX5Vfn5XOtTHbnKE6eMk5LMKOzgW22a
 4wWKp7AGcfq+zVybm5e1xPoCaU4whBPW//4PRxT1AVwyAJ7eO6c1OLYETog/MFV6a595 vQ== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2120.oracle.com with ESMTP id 2y2p3s66dc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Mon, 10 Feb 2020 18:11:52 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 01AI8RSX014820;
        Mon, 10 Feb 2020 18:11:51 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserp3020.oracle.com with ESMTP id 2y26sk8q85-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 10 Feb 2020 18:11:51 +0000
Received: from abhmp0008.oracle.com (abhmp0008.oracle.com [141.146.116.14])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 01AIBmC7009137;
        Mon, 10 Feb 2020 18:11:49 GMT
Received: from zissou.us.oracle.com (/10.152.34.58)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 10 Feb 2020 10:11:48 -0800
From:   Daniel Jordan <daniel.m.jordan@oracle.com>
To:     Herbert Xu <herbert@gondor.apana.org.au>,
        Steffen Klassert <steffen.klassert@secunet.com>
Cc:     Daniel Jordan <daniel.m.jordan@oracle.com>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] padata: fix uninitialized return value in padata_replace()
Date:   Mon, 10 Feb 2020 13:11:00 -0500
Message-Id: <20200210181100.1288437-1-daniel.m.jordan@oracle.com>
X-Mailer: git-send-email 2.24.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9527 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 phishscore=0 mlxscore=0
 malwarescore=0 bulkscore=0 spamscore=0 suspectscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2001150001
 definitions=main-2002100135
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9527 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 mlxscore=0 malwarescore=0
 suspectscore=0 mlxlogscore=999 priorityscore=1501 clxscore=1011
 impostorscore=0 lowpriorityscore=0 phishscore=0 adultscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2001150001
 definitions=main-2002100135
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

According to Geert's report[0],

  kernel/padata.c: warning: 'err' may be used uninitialized in this
    function [-Wuninitialized]:  => 539:2

Warning is seen only with older compilers on certain archs.  The
runtime effect is potentially returning garbage down the stack when
padata's cpumasks are modified before any pcrypt requests have run.

Simplest fix is to initialize err to the success value.

[0] http://lkml.kernel.org/r/20200210135506.11536-1-geert@linux-m68k.org

Reported-by: Geert Uytterhoeven <geert@linux-m68k.org>
Fixes: bbefa1dd6a6d ("crypto: pcrypt - Avoid deadlock by using per-instance padata queues")
Signed-off-by: Daniel Jordan <daniel.m.jordan@oracle.com>
Cc: Herbert Xu <herbert@gondor.apana.org.au>
Cc: Steffen Klassert <steffen.klassert@secunet.com>
Cc: linux-crypto@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
---
 kernel/padata.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/padata.c b/kernel/padata.c
index 72777c10bb9c..62082597d4a2 100644
--- a/kernel/padata.c
+++ b/kernel/padata.c
@@ -512,7 +512,7 @@ static int padata_replace_one(struct padata_shell *ps)
 static int padata_replace(struct padata_instance *pinst)
 {
 	struct padata_shell *ps;
-	int err;
+	int err = 0;
 
 	pinst->flags |= PADATA_RESET;
 
-- 
2.24.1


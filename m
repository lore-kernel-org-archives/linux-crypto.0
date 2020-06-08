Return-Path: <SRS0=nn+h=7V=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2E109C433E1
	for <linux-crypto@archiver.kernel.org>; Mon,  8 Jun 2020 21:27:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 062C2206D5
	for <linux-crypto@archiver.kernel.org>; Mon,  8 Jun 2020 21:27:07 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="gbwauFtk"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726734AbgFHV1G (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 8 Jun 2020 17:27:06 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:56358 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726705AbgFHV1F (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 8 Jun 2020 17:27:05 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 058LGMcw044154;
        Mon, 8 Jun 2020 21:26:58 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : mime-version : content-transfer-encoding;
 s=corp-2020-01-29; bh=gq92GnkfEK6oGnpL0v/HMBD4QG3kwY7CAH1UUE9eQwA=;
 b=gbwauFtkftQo4WPp+JpwpP6vjKXot2jldVowtqqWifA6iDQwwLfOexTajAFj/1ATtWvA
 84mvZx+7faLebbrqRazxKQ1LUJUvV+oWCeizq9KfWT5wQcvi54xbXCEquWGb/yPX4xWM
 v7YT/Qbz7vBivqVl+EgF5tFRmudEBesmLCvE9RfjHFKxCqHausVPUjlKRNt9lWAfluV6
 4FVFmmFsEOkClLin3WJFNWykY0QJ6bj8XUP/sAyLxQGB4oOZ+GMuciTfCmvS6lGu8Bh6
 eKeq9Wsd4Iyz9MvlC60KEiD3fhtlqrkuVy6ca+F8K97p6EyTjszGOy0VcixPRenGc+9H NA== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2120.oracle.com with ESMTP id 31g3sms2d7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Mon, 08 Jun 2020 21:26:57 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 058LDdW2096260;
        Mon, 8 Jun 2020 21:26:57 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userp3030.oracle.com with ESMTP id 31gn2vrdft-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 08 Jun 2020 21:26:57 +0000
Received: from abhmp0005.oracle.com (abhmp0005.oracle.com [141.146.116.11])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 058LQuli001801;
        Mon, 8 Jun 2020 21:26:56 GMT
Received: from parnassus.us.oracle.com (/10.39.236.86)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 08 Jun 2020 14:26:55 -0700
From:   Daniel Jordan <daniel.m.jordan@oracle.com>
To:     Herbert Xu <herbert@gondor.apana.org.au>,
        Steffen Klassert <steffen.klassert@secunet.com>
Cc:     linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        Daniel Jordan <daniel.m.jordan@oracle.com>
Subject: [PATCH] padata: upgrade smp_mb__after_atomic to smp_mb in padata_do_serial
Date:   Mon,  8 Jun 2020 17:26:52 -0400
Message-Id: <20200608212652.3469814-1-daniel.m.jordan@oracle.com>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9646 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 phishscore=0 malwarescore=0
 bulkscore=0 adultscore=0 mlxlogscore=999 spamscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2004280000
 definitions=main-2006080148
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9646 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 priorityscore=1501
 lowpriorityscore=0 impostorscore=0 cotscore=-2147483648 suspectscore=0
 spamscore=0 bulkscore=0 malwarescore=0 phishscore=0 mlxscore=0
 mlxlogscore=999 clxscore=1015 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2004280000 definitions=main-2006080148
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

A 5.7 kernel hangs during a tcrypt test of padata that waits for an AEAD
request to finish.  This is only seen on large machines running many
concurrent requests.

The issue is that padata never serializes the request.  The removal of
the reorder_objects atomic missed that the memory barrier in
padata_do_serial() depends on it.

Upgrade the barrier from smp_mb__after_atomic to smp_mb to get correct
ordering again.

Fixes: 3facced7aeed1 ("padata: remove reorder_objects")
Signed-off-by: Daniel Jordan <daniel.m.jordan@oracle.com>
Cc: Herbert Xu <herbert@gondor.apana.org.au>
Cc: Steffen Klassert <steffen.klassert@secunet.com>
Cc: linux-crypto@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
---
 kernel/padata.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/kernel/padata.c b/kernel/padata.c
index a6afa12fb75ee..7b701bc3e7922 100644
--- a/kernel/padata.c
+++ b/kernel/padata.c
@@ -260,7 +260,7 @@ static void padata_reorder(struct parallel_data *pd)
 	 *
 	 * Ensure reorder queue is read after pd->lock is dropped so we see
 	 * new objects from another task in padata_do_serial.  Pairs with
-	 * smp_mb__after_atomic in padata_do_serial.
+	 * smp_mb in padata_do_serial.
 	 */
 	smp_mb();
 
@@ -342,7 +342,7 @@ void padata_do_serial(struct padata_priv *padata)
 	 * with the trylock of pd->lock in padata_reorder.  Pairs with smp_mb
 	 * in padata_reorder.
 	 */
-	smp_mb__after_atomic();
+	smp_mb();
 
 	padata_reorder(pd);
 }

base-commit: 3d77e6a8804abcc0504c904bd6e5cdf3a5cf8162
-- 
2.26.2


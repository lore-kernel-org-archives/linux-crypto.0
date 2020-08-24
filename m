Return-Path: <SRS0=tkOt=CC=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 09102C433E4
	for <linux-crypto@archiver.kernel.org>; Mon, 24 Aug 2020 09:01:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DAF882072D
	for <linux-crypto@archiver.kernel.org>; Mon, 24 Aug 2020 09:01:42 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="G5L/M5/C"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728561AbgHXJBk (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 24 Aug 2020 05:01:40 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:53954 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729077AbgHXJBd (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 24 Aug 2020 05:01:33 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 07O8xpJ0108368;
        Mon, 24 Aug 2020 09:01:13 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : mime-version : content-type; s=corp-2020-01-29;
 bh=yx+Y699nyg4SrH4MGe7CqljNEQ3Kxg6tz22EjA95KOE=;
 b=G5L/M5/Ce1fj2u4bKsipuMwSxu75SujBt71sAtLo1OghT7CCQ9nECYU6KPvZLQvjraUQ
 CAN2hIBLMMP6K4bgzLQEm5pI6+/ugWrKoz65LeP2C9/Y0LwcJOnnUWwvCrrhzeMHQsj3
 NpS6A8Wvju2cO0M69nO43Y8XQP9Gjc2LhLLgstoElPG0b9yinn43MJ4rNaWNbhWHTpGy
 zwmeqWEwPHF5qnovmphNTZj5Yi9bQ69JUmiGxqCdVhFmuBQVSedt7eWR/sC1yHfPuB7F
 wSXyHHI/apk6LQN4uuHVZKbWZCdH0spTW2cdQGBDZwgqewhU2D6ev35B6x11LcfMCzsd Ig== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2120.oracle.com with ESMTP id 333w6thw7x-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Mon, 24 Aug 2020 09:01:13 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 07O8o7IV015247;
        Mon, 24 Aug 2020 08:59:12 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserp3020.oracle.com with ESMTP id 333ru4829q-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 24 Aug 2020 08:59:12 +0000
Received: from abhmp0017.oracle.com (abhmp0017.oracle.com [141.146.116.23])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 07O8xBg4032013;
        Mon, 24 Aug 2020 08:59:11 GMT
Received: from mwanda (/41.57.98.10)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 24 Aug 2020 01:59:10 -0700
Date:   Mon, 24 Aug 2020 11:59:02 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     Ayush Sawal <ayush.sawal@chelsio.com>
Cc:     Vinay Kumar Yadav <vinay.yadav@chelsio.com>,
        Rohit Maheshwari <rohitm@chelsio.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Florian Westphal <fw@strlen.de>,
        Eric Dumazet <edumazet@google.com>,
        Shahjada Abul Husain <shahjada@chelsio.com>,
        linux-crypto@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [PATCH] crypto/chtls: Fix double free in chtls_pass_accept_request()
Message-ID: <20200824085902.GC208317@mwanda>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Mailer: git-send-email haha only kidding
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9722 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 phishscore=0
 bulkscore=0 suspectscore=2 spamscore=0 mlxscore=0 adultscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2008240067
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9722 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 impostorscore=0
 mlxlogscore=999 suspectscore=2 phishscore=0 malwarescore=0 spamscore=0
 priorityscore=1501 clxscore=1011 mlxscore=0 lowpriorityscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2008240068
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

The chtls_recv_sock() function frees "oreq" so the free here is a double
free.

Fixes: 6abde0b24122 ("crypto/chtls: IPv6 support for inline TLS")
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
---
 drivers/crypto/chelsio/chtls/chtls_cm.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/crypto/chelsio/chtls/chtls_cm.c b/drivers/crypto/chelsio/chtls/chtls_cm.c
index 05520dccd906..140342024bd1 100644
--- a/drivers/crypto/chelsio/chtls/chtls_cm.c
+++ b/drivers/crypto/chelsio/chtls/chtls_cm.c
@@ -1381,7 +1381,7 @@ static void chtls_pass_accept_request(struct sock *sk,
 
 	newsk = chtls_recv_sock(sk, oreq, network_hdr, req, cdev);
 	if (!newsk)
-		goto free_oreq;
+		goto reject;
 
 	if (chtls_get_module(newsk))
 		goto reject;
@@ -1397,8 +1397,6 @@ static void chtls_pass_accept_request(struct sock *sk,
 	kfree_skb(skb);
 	return;
 
-free_oreq:
-	chtls_reqsk_free(oreq);
 reject:
 	mk_tid_release(reply_skb, 0, tid);
 	cxgb4_ofld_send(cdev->lldi->ports[0], reply_skb);
-- 
2.28.0


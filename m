Return-Path: <SRS0=GLFy=62=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2B0EBC54E4A
	for <linux-crypto@archiver.kernel.org>; Tue, 12 May 2020 08:08:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0413B206A3
	for <linux-crypto@archiver.kernel.org>; Tue, 12 May 2020 08:08:37 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="fzHZs4jN"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729119AbgELIIg (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 12 May 2020 04:08:36 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:52784 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725889AbgELIIg (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 12 May 2020 04:08:36 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 04C82FKR141578;
        Tue, 12 May 2020 08:06:47 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : mime-version : content-type : in-reply-to;
 s=corp-2020-01-29; bh=Oa8J6zinMCa7UnQSKo6wOi+seluNKXvx9yPIBfVSmuk=;
 b=fzHZs4jNmYVcDfM4CtDYCWiHiPyCuDbnq1GTsDfjIJrTTFQAWpGpu5Uh/M8VTiezlerL
 F3cU3TQCGujHVT7EycoqAiqSsuaFqHDpOfnNu0zHz8XDFVPYsyqomyTVP4qwMJMMXAzE
 QrhJjbjjAJ960nfzkQltn9S3ge1Zd8oG+jiZBXx+JpJAwBQnpd51qb5Ggg7XsPxgxDhH
 Tpaz25u/Jm8I0wqDiLQ6OjYFN+8TLg/7HnAOvbJ2+vK7vADllUH3x0Rialbzib555XHn
 vhDg7SO1KOMv9RKltWLb1X54ygCjkYCZNPNzdIs30Fy1sMz0Jbb+O7D5fQDRaJuU0c0T NQ== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2130.oracle.com with ESMTP id 30x3gmhfbb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Tue, 12 May 2020 08:06:47 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 04C83usG095425;
        Tue, 12 May 2020 08:04:47 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userp3030.oracle.com with ESMTP id 30ydspxp67-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 12 May 2020 08:04:47 +0000
Received: from abhmp0002.oracle.com (abhmp0002.oracle.com [141.146.116.8])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 04C84imh004935;
        Tue, 12 May 2020 08:04:44 GMT
Received: from mwanda (/10.175.212.140)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 12 May 2020 01:04:44 -0700
Date:   Tue, 12 May 2020 11:04:36 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     Wei Yongjun <weiyongjun1@huawei.com>,
        Rohit Maheshwari <rohitm@chelsio.com>
Cc:     Ayush Sawal <ayush.sawal@chelsio.com>,
        Vinay Kumar Yadav <vinay.yadav@chelsio.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Wei Yongjun <weiyongjun1@huawei.com>,
        linux-crypto@vger.kernel.org, kernel-janitors@vger.kernel.org,
        Hulk Robot <hulkci@huawei.com>
Subject: [PATCH] cxgb4/chcr: Fix a leak in chcr_ktls_dev_add()
Message-ID: <20200512080436.GA247819@mwanda>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200509080548.118667-1-weiyongjun1@huawei.com>
X-Mailer: git-send-email haha only kidding
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9618 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 suspectscore=2 mlxscore=0
 adultscore=0 mlxlogscore=999 malwarescore=0 bulkscore=0 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2003020000
 definitions=main-2005120068
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9618 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 mlxlogscore=999
 clxscore=1011 spamscore=0 lowpriorityscore=0 phishscore=0 bulkscore=0
 malwarescore=0 priorityscore=1501 mlxscore=0 suspectscore=2
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2005120068
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

We need to free "tx_info->l2te" if chcr_setup_connection() fails.  My
other concern was that if we free "tx_info" then "tx_ctx->chcr_info"
points to a freed variable.  I don't think this causes a problem but
it's cleaner to reset it back to NULL.  Also I renamed the labels to
say what the gotos do instead of using numbered labels.

Fixes: 34aba2c45024 ("cxgb4/chcr : Register to tls add and del callback")
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
---
Applies on top of Wei Yongjun's patch.

 drivers/crypto/chelsio/chcr_ktls.c | 18 +++++++++++-------
 1 file changed, 11 insertions(+), 7 deletions(-)

diff --git a/drivers/crypto/chelsio/chcr_ktls.c b/drivers/crypto/chelsio/chcr_ktls.c
index baaea8ce40806..3173ac3099bc6 100644
--- a/drivers/crypto/chelsio/chcr_ktls.c
+++ b/drivers/crypto/chelsio/chcr_ktls.c
@@ -478,7 +478,7 @@ static int chcr_ktls_dev_add(struct net_device *netdev, struct sock *sk,
 
 	tx_info->rx_qid = chcr_get_first_rx_qid(adap);
 	if (unlikely(tx_info->rx_qid < 0))
-		goto out2;
+		goto free_tx_info;
 
 	tx_info->prev_seq = start_offload_tcp_sn;
 	tx_info->tcp_start_seq_number = start_offload_tcp_sn;
@@ -486,7 +486,7 @@ static int chcr_ktls_dev_add(struct net_device *netdev, struct sock *sk,
 	/* save crypto keys */
 	ret = chcr_ktls_save_keys(tx_info, crypto_info, direction);
 	if (ret < 0)
-		goto out2;
+		goto free_tx_info;
 
 	/* get peer ip */
 	if (sk->sk_family == AF_INET ||
@@ -502,14 +502,14 @@ static int chcr_ktls_dev_add(struct net_device *netdev, struct sock *sk,
 	if (!dst) {
 		pr_err("DST entry not found\n");
 		ret = -ENOENT;
-		goto out2;
+		goto free_tx_info;
 	}
 	n = dst_neigh_lookup(dst, daaddr);
 	if (!n || !n->dev) {
 		pr_err("neighbour not found\n");
 		dst_release(dst);
 		ret = -ENOENT;
-		goto out2;
+		goto free_tx_info;
 	}
 	tx_info->l2te  = cxgb4_l2t_get(adap->l2t, n, n->dev, 0);
 
@@ -519,7 +519,7 @@ static int chcr_ktls_dev_add(struct net_device *netdev, struct sock *sk,
 	if (!tx_info->l2te) {
 		pr_err("l2t entry not found\n");
 		ret = -ENOENT;
-		goto out2;
+		goto free_tx_info;
 	}
 
 	tx_ctx->chcr_info = tx_info;
@@ -529,12 +529,16 @@ static int chcr_ktls_dev_add(struct net_device *netdev, struct sock *sk,
 	 */
 	ret = chcr_setup_connection(sk, tx_info);
 	if (ret)
-		goto out2;
+		goto free_l2te;
 
 	atomic64_inc(&adap->chcr_stats.ktls_tx_connection_open);
 	return 0;
-out2:
+
+free_l2te:
+	cxgb4_l2t_release(tx_info->l2te);
+free_tx_info:
 	kvfree(tx_info);
+	tx_ctx->chcr_info = NULL;
 out:
 	atomic64_inc(&adap->chcr_stats.ktls_tx_connection_fail);
 	return ret;
-- 
2.26.2


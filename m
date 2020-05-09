Return-Path: <SRS0=jzkg=6X=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E1563C28CBC
	for <linux-crypto@archiver.kernel.org>; Sat,  9 May 2020 08:02:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BF93C2184D
	for <linux-crypto@archiver.kernel.org>; Sat,  9 May 2020 08:02:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727096AbgEIICB (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Sat, 9 May 2020 04:02:01 -0400
Received: from szxga06-in.huawei.com ([45.249.212.32]:57710 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726950AbgEIICB (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Sat, 9 May 2020 04:02:01 -0400
Received: from DGGEMS406-HUB.china.huawei.com (unknown [172.30.72.60])
        by Forcepoint Email with ESMTP id 03E36742CF12882AFA33;
        Sat,  9 May 2020 16:01:59 +0800 (CST)
Received: from localhost.localdomain.localdomain (10.175.113.25) by
 DGGEMS406-HUB.china.huawei.com (10.3.19.206) with Microsoft SMTP Server id
 14.3.487.0; Sat, 9 May 2020 16:01:52 +0800
From:   Wei Yongjun <weiyongjun1@huawei.com>
To:     Ayush Sawal <ayush.sawal@chelsio.com>,
        Vinay Kumar Yadav <vinay.yadav@chelsio.com>,
        Rohit Maheshwari <rohitm@chelsio.com>,
        Herbert Xu <herbert@gondor.apana.org.au>
CC:     Wei Yongjun <weiyongjun1@huawei.com>,
        <linux-crypto@vger.kernel.org>, <kernel-janitors@vger.kernel.org>,
        Hulk Robot <hulkci@huawei.com>
Subject: [PATCH -next] cxgb4/chcr: Fix error return code in chcr_ktls_dev_add()
Date:   Sat, 9 May 2020 08:05:48 +0000
Message-ID: <20200509080548.118667-1-weiyongjun1@huawei.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Type:   text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Originating-IP: [10.175.113.25]
X-CFilter-Loop: Reflected
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Fix to return a negative error code from the error handling
case instead of 0, as done elsewhere in this function.

Fixes: 34aba2c45024 ("cxgb4/chcr : Register to tls add and del callback")
Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: Wei Yongjun <weiyongjun1@huawei.com>
---
 drivers/crypto/chelsio/chcr_ktls.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/crypto/chelsio/chcr_ktls.c b/drivers/crypto/chelsio/chcr_ktls.c
index 43d9e2420110..baaea8ce4080 100644
--- a/drivers/crypto/chelsio/chcr_ktls.c
+++ b/drivers/crypto/chelsio/chcr_ktls.c
@@ -501,12 +501,14 @@ static int chcr_ktls_dev_add(struct net_device *netdev, struct sock *sk,
 	dst = sk_dst_get(sk);
 	if (!dst) {
 		pr_err("DST entry not found\n");
+		ret = -ENOENT;
 		goto out2;
 	}
 	n = dst_neigh_lookup(dst, daaddr);
 	if (!n || !n->dev) {
 		pr_err("neighbour not found\n");
 		dst_release(dst);
+		ret = -ENOENT;
 		goto out2;
 	}
 	tx_info->l2te  = cxgb4_l2t_get(adap->l2t, n, n->dev, 0);
@@ -516,6 +518,7 @@ static int chcr_ktls_dev_add(struct net_device *netdev, struct sock *sk,
 
 	if (!tx_info->l2te) {
 		pr_err("l2t entry not found\n");
+		ret = -ENOENT;
 		goto out2;
 	}




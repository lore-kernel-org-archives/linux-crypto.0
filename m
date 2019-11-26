Return-Path: <SRS0=6oT7=ZS=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0A357C432C0
	for <linux-crypto@archiver.kernel.org>; Tue, 26 Nov 2019 12:21:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D11F420722
	for <linux-crypto@archiver.kernel.org>; Tue, 26 Nov 2019 12:21:43 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="nS9IB1Su"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727827AbfKZMVn (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 26 Nov 2019 07:21:43 -0500
Received: from userp2130.oracle.com ([156.151.31.86]:59772 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727733AbfKZMVn (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 26 Nov 2019 07:21:43 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xAQCIur5124856;
        Tue, 26 Nov 2019 12:21:29 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : mime-version : content-type; s=corp-2019-08-05;
 bh=yHWs0d6oK6yP4BkI2TKi1Xcr0/D0UZ96ZCkXeVdaLPE=;
 b=nS9IB1SuLUn7B9LfrFFRxQHsIIrBvyx1OMeyfUg5Ju4IC60w9Gmt5z1dwMm8VEjwUFky
 AZB1oH5n3z+BCvLZPcyQnJk6fUHFYHTxML65OjLOhgYKY9CINhcNL2be8UJg/AbM4Smm
 htv4qzYUDAH90WBr+VPBrv0uOKhCj3r1we3vSyaTTgKddp/SAobJVBPRzOkJWHIrLKh4
 e/IzQsFHKFO539ZXOHHQ1csG0CW429ls4NXT3vHZIVIXdi+hkyngmn0XX7oQhoK+Cqr/
 UKWC5jPZ2/0D5b+YAyMaWysxMsMsXTWNhgY0mwPUPeAUMP/2IdnF+/UiOw+G/OJtHjRH cw== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2130.oracle.com with ESMTP id 2wev6u6er5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 26 Nov 2019 12:21:29 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xAQC8Wo1050153;
        Tue, 26 Nov 2019 12:21:28 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserp3030.oracle.com with ESMTP id 2wgwush3b5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 26 Nov 2019 12:21:28 +0000
Received: from abhmp0015.oracle.com (abhmp0015.oracle.com [141.146.116.21])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id xAQCLRfe022357;
        Tue, 26 Nov 2019 12:21:28 GMT
Received: from kili.mountain (/129.205.23.165)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 26 Nov 2019 04:21:27 -0800
Date:   Tue, 26 Nov 2019 15:21:20 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     Zaibo Xu <xuzaibo@huawei.com>
Cc:     Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Longfang Liu <liulongfang@huawei.com>,
        linux-crypto@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [PATCH] crypto: hisilicon - fix a NULL vs IS_ERR() bug in
 sec_create_qp_ctx()
Message-ID: <20191126122120.vnf6mxmvf25ppyeo@kili.mountain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Mailer: git-send-email haha only kidding
User-Agent: NeoMutt/20170113 (1.7.2)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9452 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=2 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=907
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1911140001 definitions=main-1911260110
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9452 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=2 phishscore=0 bulkscore=0 spamscore=0 clxscore=1011
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=969 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1911140001
 definitions=main-1911260110
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

The hisi_acc_create_sgl_pool() function returns error pointers, it never
returns NULL pointers.

Fixes: 416d82204df4 ("crypto: hisilicon - add HiSilicon SEC V2 driver")
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
---
 drivers/crypto/hisilicon/sec2/sec_crypto.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/crypto/hisilicon/sec2/sec_crypto.c b/drivers/crypto/hisilicon/sec2/sec_crypto.c
index dc1eb97d57f7..62b04e19067c 100644
--- a/drivers/crypto/hisilicon/sec2/sec_crypto.c
+++ b/drivers/crypto/hisilicon/sec2/sec_crypto.c
@@ -179,14 +179,14 @@ static int sec_create_qp_ctx(struct hisi_qm *qm, struct sec_ctx *ctx,
 
 	qp_ctx->c_in_pool = hisi_acc_create_sgl_pool(dev, QM_Q_DEPTH,
 						     SEC_SGL_SGE_NR);
-	if (!qp_ctx->c_in_pool) {
+	if (IS_ERR(qp_ctx->c_in_pool)) {
 		dev_err(dev, "fail to create sgl pool for input!\n");
 		goto err_free_req_list;
 	}
 
 	qp_ctx->c_out_pool = hisi_acc_create_sgl_pool(dev, QM_Q_DEPTH,
 						      SEC_SGL_SGE_NR);
-	if (!qp_ctx->c_out_pool) {
+	if (IS_ERR(qp_ctx->c_out_pool)) {
 		dev_err(dev, "fail to create sgl pool for output!\n");
 		goto err_free_c_in_pool;
 	}
-- 
2.11.0


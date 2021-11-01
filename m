Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D52A5C433EF
	for <linux-crypto@archiver.kernel.org>; Mon,  1 Nov 2021 13:49:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id AC44660F36
	for <linux-crypto@archiver.kernel.org>; Mon,  1 Nov 2021 13:49:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232209AbhKANvm (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 1 Nov 2021 09:51:42 -0400
Received: from szxga02-in.huawei.com ([45.249.212.188]:15328 "EHLO
        szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231493AbhKANva (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 1 Nov 2021 09:51:30 -0400
Received: from dggeml709-chm.china.huawei.com (unknown [172.30.72.53])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4HjZBQ5M0kz90Nb;
        Mon,  1 Nov 2021 21:48:46 +0800 (CST)
Received: from localhost.localdomain (10.175.102.38) by
 dggeml709-chm.china.huawei.com (10.3.17.139) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2308.15; Mon, 1 Nov 2021 21:48:53 +0800
From:   Wei Yongjun <weiyongjun1@huawei.com>
To:     <weiyongjun1@huawei.com>,
        Daniele Alessandrelli <daniele.alessandrelli@intel.com>,
        Prabhjot Khurana <prabhjot.khurana@intel.com>,
        Mark Gross <mgross@linux.intel.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>
CC:     <linux-crypto@vger.kernel.org>, <kernel-janitors@vger.kernel.org>,
        Hulk Robot <hulkci@huawei.com>
Subject: [PATCH -next] crypto: keembay-ocs-ecc - Fix error return code in kmb_ocs_ecc_probe()
Date:   Mon, 1 Nov 2021 14:02:33 +0000
Message-ID: <20211101140233.777222-1-weiyongjun1@huawei.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Type:   text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Originating-IP: [10.175.102.38]
X-ClientProxiedBy: dggems706-chm.china.huawei.com (10.3.19.183) To
 dggeml709-chm.china.huawei.com (10.3.17.139)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Fix to return negative error code -ENOMEM from the error handling
case instead of 0, as done elsewhere in this function.

Fixes: c9f608c38009 ("crypto: keembay-ocs-ecc - Add Keem Bay OCS ECC Driver")
Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: Wei Yongjun <weiyongjun1@huawei.com>
---
 drivers/crypto/keembay/keembay-ocs-ecc.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/crypto/keembay/keembay-ocs-ecc.c b/drivers/crypto/keembay/keembay-ocs-ecc.c
index 679e6ae295e0..5d0785d3f1b5 100644
--- a/drivers/crypto/keembay/keembay-ocs-ecc.c
+++ b/drivers/crypto/keembay/keembay-ocs-ecc.c
@@ -930,6 +930,7 @@ static int kmb_ocs_ecc_probe(struct platform_device *pdev)
 	ecc_dev->engine = crypto_engine_alloc_init(dev, 1);
 	if (!ecc_dev->engine) {
 		dev_err(dev, "Could not allocate crypto engine\n");
+		rc = -ENOMEM;
 		goto list_del;
 	}
 


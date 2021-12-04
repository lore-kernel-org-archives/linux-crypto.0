Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 629ADC433EF
	for <linux-crypto@archiver.kernel.org>; Sat,  4 Dec 2021 10:47:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346348AbhLDKvJ (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Sat, 4 Dec 2021 05:51:09 -0500
Received: from szxga08-in.huawei.com ([45.249.212.255]:29088 "EHLO
        szxga08-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238470AbhLDKvI (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sat, 4 Dec 2021 05:51:08 -0500
Received: from kwepemi100010.china.huawei.com (unknown [172.30.72.53])
        by szxga08-in.huawei.com (SkyGuard) with ESMTP id 4J5mY428mKz1DJXX;
        Sat,  4 Dec 2021 18:44:56 +0800 (CST)
Received: from kwepemm600009.china.huawei.com (7.193.23.164) by
 kwepemi100010.china.huawei.com (7.221.188.54) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20; Sat, 4 Dec 2021 18:47:41 +0800
Received: from localhost.localdomain (10.67.165.24) by
 kwepemm600009.china.huawei.com (7.193.23.164) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20; Sat, 4 Dec 2021 18:47:40 +0800
From:   Weili Qian <qianweili@huawei.com>
To:     <herbert@gondor.apana.org.au>, <davem@davemloft.net>
CC:     <linux-kernel@vger.kernel.org>, <linux-crypto@vger.kernel.org>,
        <wangzhou1@hisilicon.com>, <liulongfang@huawei.com>
Subject: [PATCH] crypto: hisilicon/qm - fix incorrect return value of hisi_qm_resume()
Date:   Sat, 4 Dec 2021 18:43:01 +0800
Message-ID: <20211204104301.32666-1-qianweili@huawei.com>
X-Mailer: git-send-email 2.33.0
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.67.165.24]
X-ClientProxiedBy: dggems702-chm.china.huawei.com (10.3.19.179) To
 kwepemm600009.china.huawei.com (7.193.23.164)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

When hisi_qm_resume() returns 0, it indicates that the device has started
successfully.  If the device fails to start, hisi_qm_resume() needs to
return the actual error code to the caller instead of 0.

Fixes: d7ea53395b72 ("crypto: hisilicon - add runtime PM ops")
Signed-off-by: Weili Qian <qianweili@huawei.com>
---
 drivers/crypto/hisilicon/qm.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/crypto/hisilicon/qm.c b/drivers/crypto/hisilicon/qm.c
index ad706ccfe91a..896255aec87f 100644
--- a/drivers/crypto/hisilicon/qm.c
+++ b/drivers/crypto/hisilicon/qm.c
@@ -6071,7 +6071,7 @@ int hisi_qm_resume(struct device *dev)
 	if (ret)
 		pci_err(pdev, "failed to start qm(%d)\n", ret);
 
-	return 0;
+	return ret;
 }
 EXPORT_SYMBOL_GPL(hisi_qm_resume);
 
-- 
2.33.0


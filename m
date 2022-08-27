Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E0A9DECAAD5
	for <linux-crypto@archiver.kernel.org>; Sat, 27 Aug 2022 10:30:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238464AbiH0Kac (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Sat, 27 Aug 2022 06:30:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48598 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237532AbiH0Ka1 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sat, 27 Aug 2022 06:30:27 -0400
Received: from szxga08-in.huawei.com (szxga08-in.huawei.com [45.249.212.255])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0A07C26AE2;
        Sat, 27 Aug 2022 03:30:24 -0700 (PDT)
Received: from dggemv703-chm.china.huawei.com (unknown [172.30.72.53])
        by szxga08-in.huawei.com (SkyGuard) with ESMTP id 4MFCYN4Wjqz1N7Zp;
        Sat, 27 Aug 2022 18:26:48 +0800 (CST)
Received: from kwepemm600009.china.huawei.com (7.193.23.164) by
 dggemv703-chm.china.huawei.com (10.3.19.46) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Sat, 27 Aug 2022 18:30:22 +0800
Received: from localhost.localdomain (10.69.192.56) by
 kwepemm600009.china.huawei.com (7.193.23.164) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Sat, 27 Aug 2022 18:30:21 +0800
From:   Weili Qian <qianweili@huawei.com>
To:     <herbert@gondor.apana.org.au>
CC:     <linux-kernel@vger.kernel.org>, <linux-crypto@vger.kernel.org>,
        <wangzhou1@hisilicon.com>, <liulongfang@huawei.com>
Subject: [PATCH] crypto: hisilicon/qm - return failure if vfs_num exceeds total VFs
Date:   Sat, 27 Aug 2022 18:27:56 +0800
Message-ID: <20220827102756.8735-1-qianweili@huawei.com>
X-Mailer: git-send-email 2.33.0
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.69.192.56]
X-ClientProxiedBy: dggems701-chm.china.huawei.com (10.3.19.178) To
 kwepemm600009.china.huawei.com (7.193.23.164)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

The accelerator drivers supports users to enable VFs through the
module parameter 'vfs_num'. If the number of VFs to be enabled
exceeds the total VFs, all VFs are enabled. Change it to the same
as enabling VF through the 'sriov_numvfs' file. Returns -ERANGE
if the number of VFs to be enabled exceeds total VFs.

Signed-off-by: Weili Qian <qianweili@huawei.com>
---
 drivers/crypto/hisilicon/qm.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/drivers/crypto/hisilicon/qm.c b/drivers/crypto/hisilicon/qm.c
index fd9fb159048f..54bbd7fa57cc 100644
--- a/drivers/crypto/hisilicon/qm.c
+++ b/drivers/crypto/hisilicon/qm.c
@@ -4766,7 +4766,13 @@ int hisi_qm_sriov_enable(struct pci_dev *pdev, int max_vfs)
 		goto err_put_sync;
 	}
 
-	num_vfs = min_t(int, max_vfs, total_vfs);
+	if (max_vfs > total_vfs) {
+		pci_err(pdev, "%d VFs is more than total VFs %d!\n", max_vfs, total_vfs);
+		ret = -ERANGE;
+		goto err_put_sync;
+	}
+
+	num_vfs = max_vfs;
 	ret = qm_vf_q_assign(qm, num_vfs);
 	if (ret) {
 		pci_err(pdev, "Can't assign queues for VF!\n");
-- 
2.33.0


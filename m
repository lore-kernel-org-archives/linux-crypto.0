Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 74C11C47080
	for <linux-crypto@archiver.kernel.org>; Tue,  1 Jun 2021 09:52:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5412061008
	for <linux-crypto@archiver.kernel.org>; Tue,  1 Jun 2021 09:52:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230282AbhFAJyZ (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 1 Jun 2021 05:54:25 -0400
Received: from szxga01-in.huawei.com ([45.249.212.187]:6110 "EHLO
        szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231968AbhFAJyT (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 1 Jun 2021 05:54:19 -0400
Received: from dggemv704-chm.china.huawei.com (unknown [172.30.72.55])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4FvS7P5xmXzYpX7;
        Tue,  1 Jun 2021 17:49:53 +0800 (CST)
Received: from dggpemm000001.china.huawei.com (7.185.36.245) by
 dggemv704-chm.china.huawei.com (10.3.19.47) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Tue, 1 Jun 2021 17:52:37 +0800
Received: from localhost.localdomain.localdomain (10.175.113.25) by
 dggpemm000001.china.huawei.com (7.185.36.245) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Tue, 1 Jun 2021 17:52:37 +0800
From:   Tong Tiangen <tongtiangen@huawei.com>
To:     Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>
CC:     <linux-crypto@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        "Tong Tiangen" <tongtiangen@huawei.com>
Subject: [PATCH -next] crypto: nitrox - fix unchecked variable in nitrox_register_interrupts
Date:   Tue, 1 Jun 2021 18:01:55 +0800
Message-ID: <20210601100155.69681-1-tongtiangen@huawei.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.175.113.25]
X-ClientProxiedBy: dggems702-chm.china.huawei.com (10.3.19.179) To
 dggpemm000001.china.huawei.com (7.185.36.245)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Function nitrox_register_interrupts leaves variable 'nr_vecs' unchecked, which
would be use as kcalloc parameter later.

Fixes: 5155e118dda9 ("crypto: cavium/nitrox - use pci_alloc_irq_vectors() while enabling MSI-X.")
Signed-off-by: Tong Tiangen <tongtiangen@huawei.com>
---
 drivers/crypto/cavium/nitrox/nitrox_isr.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/crypto/cavium/nitrox/nitrox_isr.c b/drivers/crypto/cavium/nitrox/nitrox_isr.c
index c288c4b51783..f19e520da6d0 100644
--- a/drivers/crypto/cavium/nitrox/nitrox_isr.c
+++ b/drivers/crypto/cavium/nitrox/nitrox_isr.c
@@ -307,6 +307,10 @@ int nitrox_register_interrupts(struct nitrox_device *ndev)
 	 * Entry 192: NPS_CORE_INT_ACTIVE
 	 */
 	nr_vecs = pci_msix_vec_count(pdev);
+	if (nr_vecs < 0) {
+		dev_err(DEV(ndev), "Error in getting vec count %d\n", nr_vecs);
+		return nr_vecs;
+	}
 
 	/* Enable MSI-X */
 	ret = pci_alloc_irq_vectors(pdev, nr_vecs, nr_vecs, PCI_IRQ_MSIX);
-- 
2.18.0.huawei.25


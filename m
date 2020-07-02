Return-Path: <SRS0=MdlN=AN=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.0 required=3.0
	tests=HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4EEE0C433DF
	for <linux-crypto@archiver.kernel.org>; Thu,  2 Jul 2020 02:32:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3023F20885
	for <linux-crypto@archiver.kernel.org>; Thu,  2 Jul 2020 02:32:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728050AbgGBCcB (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 1 Jul 2020 22:32:01 -0400
Received: from szxga04-in.huawei.com ([45.249.212.190]:7338 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726504AbgGBCcB (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 1 Jul 2020 22:32:01 -0400
Received: from DGGEMS402-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id E380B80299D36A5EFA79;
        Thu,  2 Jul 2020 10:31:58 +0800 (CST)
Received: from localhost.localdomain (10.67.165.24) by
 DGGEMS402-HUB.china.huawei.com (10.3.19.202) with Microsoft SMTP Server id
 14.3.487.0; Thu, 2 Jul 2020 10:31:52 +0800
From:   Meng Yu <yumeng18@huawei.com>
To:     <herbert@gondor.apana.org.au>, <davem@davemloft.net>
CC:     <linux-crypto@vger.kernel.org>, <xuzaibo@huawei.com>,
        <wangzhou1@hisilicon.com>, <linux-kernel@vger.kernel.org>
Subject: [PATCH 4/6] crypto: hisilicon/hpre - Add a switch in sriov_configure
Date:   Thu, 2 Jul 2020 10:31:17 +0800
Message-ID: <1593657079-31990-5-git-send-email-yumeng18@huawei.com>
X-Mailer: git-send-email 2.8.1
In-Reply-To: <1593657079-31990-1-git-send-email-yumeng18@huawei.com>
References: <1593657079-31990-1-git-send-email-yumeng18@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.67.165.24]
X-CFilter-Loop: Reflected
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

If CONFIG_PCI_IOV is not enabled, we can not use "sriov_configure".

Fixes: 5ec302a364bf("crypto: hisilicon - add SRIOV support for HPRE")
Signed-off-by: Meng Yu <yumeng18@huawei.com>
Reviewed-by: Zaibo Xu <xuzaibo@huawei.com>
Reviewed-by: Shukun Tan <tanshukun1@huawei.com>
---
 drivers/crypto/hisilicon/hpre/hpre_main.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/crypto/hisilicon/hpre/hpre_main.c b/drivers/crypto/hisilicon/hpre/hpre_main.c
index 1216405..bfe8a91 100644
--- a/drivers/crypto/hisilicon/hpre/hpre_main.c
+++ b/drivers/crypto/hisilicon/hpre/hpre_main.c
@@ -925,7 +925,8 @@ static struct pci_driver hpre_pci_driver = {
 	.id_table		= hpre_dev_ids,
 	.probe			= hpre_probe,
 	.remove			= hpre_remove,
-	.sriov_configure	= hisi_qm_sriov_configure,
+	.sriov_configure	= IS_ENABLED(CONFIG_PCI_IOV) ?
+				  hisi_qm_sriov_configure : NULL,
 	.err_handler		= &hpre_err_handler,
 	.shutdown		= hisi_qm_dev_shutdown,
 };
-- 
2.8.1


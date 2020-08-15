Return-Path: <SRS0=CHgJ=B2=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.0 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5B4B5C433DF
	for <linux-crypto@archiver.kernel.org>; Sun, 16 Aug 2020 01:44:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4120A20708
	for <linux-crypto@archiver.kernel.org>; Sun, 16 Aug 2020 01:44:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729405AbgHPBor (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Sat, 15 Aug 2020 21:44:47 -0400
Received: from szxga07-in.huawei.com ([45.249.212.35]:33840 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729375AbgHPBoR (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Sat, 15 Aug 2020 21:44:17 -0400
Received: from DGGEMS411-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id 13B3D84A753A634FEC0D;
        Sat, 15 Aug 2020 17:58:34 +0800 (CST)
Received: from localhost.localdomain (10.69.192.56) by
 DGGEMS411-HUB.china.huawei.com (10.3.19.211) with Microsoft SMTP Server id
 14.3.487.0; Sat, 15 Aug 2020 17:58:25 +0800
From:   Yang Shen <shenyang39@huawei.com>
To:     <herbert@gondor.apana.org.au>, <davem@davemloft.net>
CC:     <linux-kernel@vger.kernel.org>, <linux-crypto@vger.kernel.org>,
        <xuzaibo@huawei.com>, <wangzhou1@hisilicon.com>
Subject: [PATCH v5 07/10] crypto: hisilicon/qm - fix VF not available after PF FLR
Date:   Sat, 15 Aug 2020 17:56:14 +0800
Message-ID: <1597485377-2678-8-git-send-email-shenyang39@huawei.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1597485377-2678-1-git-send-email-shenyang39@huawei.com>
References: <1597485377-2678-1-git-send-email-shenyang39@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.69.192.56]
X-CFilter-Loop: Reflected
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

From: Shukun Tan <tanshukun1@huawei.com>

When PF FLR, the hardware will actively trigger the VF FLR. Configuration
space of VF needs to be saved and restored to ensure that it is available
after the PF FLR.

Fixes: 7ce396fa12a9("crypto: hisilicon - add FLR support")
Signed-off-by: Shukun Tan <tanshukun1@huawei.com>
Signed-off-by: Yang Shen <shenyang39@huawei.com>
Reviewed-by: Zhou Wang <wangzhou1@hisilicon.com>
---
 drivers/crypto/hisilicon/qm.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/crypto/hisilicon/qm.c b/drivers/crypto/hisilicon/qm.c
index 6d233b4..3c37e00 100644
--- a/drivers/crypto/hisilicon/qm.c
+++ b/drivers/crypto/hisilicon/qm.c
@@ -3318,6 +3318,9 @@ static int qm_vf_reset_prepare(struct hisi_qm *qm,
 			continue;
 
 		if (pci_physfn(virtfn) == pdev) {
+			/* save VFs PCIE BAR configuration */
+			pci_save_state(virtfn);
+
 			ret = hisi_qm_stop(vf_qm, stop_reason);
 			if (ret)
 				goto stop_fail;
@@ -3481,6 +3484,9 @@ static int qm_vf_reset_done(struct hisi_qm *qm)
 			continue;
 
 		if (pci_physfn(virtfn) == pdev) {
+			/* enable VFs PCIE BAR configuration */
+			pci_restore_state(virtfn);
+
 			ret = qm_restart(vf_qm);
 			if (ret)
 				goto restart_fail;
-- 
2.7.4


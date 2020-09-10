Return-Path: <SRS0=7O7/=CT=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3A22AC433E2
	for <linux-crypto@archiver.kernel.org>; Thu, 10 Sep 2020 12:20:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0256D20809
	for <linux-crypto@archiver.kernel.org>; Thu, 10 Sep 2020 12:20:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728350AbgIJMUw (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 10 Sep 2020 08:20:52 -0400
Received: from szxga04-in.huawei.com ([45.249.212.190]:11786 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1730395AbgIJMRx (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 10 Sep 2020 08:17:53 -0400
Received: from DGGEMS413-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id C54A62D3EF1EC851C7A6;
        Thu, 10 Sep 2020 19:26:48 +0800 (CST)
Received: from localhost.localdomain (10.67.165.24) by
 DGGEMS413-HUB.china.huawei.com (10.3.19.213) with Microsoft SMTP Server id
 14.3.487.0; Thu, 10 Sep 2020 19:26:40 +0800
From:   Meng Yu <yumeng18@huawei.com>
To:     <herbert@gondor.apana.org.au>, <davem@davemloft.net>
CC:     <linux-crypto@vger.kernel.org>, <xuzaibo@huawei.com>,
        <wangzhou1@hisilicon.com>, <linux-kernel@vger.kernel.org>
Subject: [PATCH 3/3] crypto: hisilicon/hpre - fix a bug in dh algorithm
Date:   Thu, 10 Sep 2020 19:25:22 +0800
Message-ID: <1599737122-20734-4-git-send-email-yumeng18@huawei.com>
X-Mailer: git-send-email 2.8.1
In-Reply-To: <1599737122-20734-1-git-send-email-yumeng18@huawei.com>
References: <1599737122-20734-1-git-send-email-yumeng18@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.67.165.24]
X-CFilter-Loop: Reflected
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Using 'g' equals 5 in dh algorithm may cause an error like this:

arm-smmu-v3 arm-smmu-v3.1.auto: event 0x10 received:
dh: Party A: generate public key test failed. err -22
11375.065672] dh alg: dh: test failed on vector 1, err=-22
arm-smmu-v3 arm-smmu-v3.1.auto:  0x0000790000000010
arm-smmu-v3 arm-smmu-v3.1.auto:  0x0000120800000080
hpre-dh self test failed
arm-smmu-v3 arm-smmu-v3.1.auto:  0x0000000000000000
arm-smmu-v3 arm-smmu-v3.1.auto:  0x0000000000000000
arm-smmu-v3 arm-smmu-v3.1.auto: event 0x10 received:
arm-smmu-v3 arm-smmu-v3.1.auto:  0x0000790000000010
arm-smmu-v3 arm-smmu-v3.1.auto:  0x0000120800000083
arm-smmu-v3 arm-smmu-v3.1.auto:  0x00000000000000c0
arm-smmu-v3 arm-smmu-v3.1.auto:  0x0000000000000000
arm-smmu-v3 arm-smmu-v3.1.auto: event 0x10 received:
arm-smmu-v3 arm-smmu-v3.1.auto:  0x0000790000000010
arm-smmu-v3 arm-smmu-v3.1.auto:  0x0000120800000081
arm-smmu-v3 arm-smmu-v3.1.auto:  0x0000000000000040
arm-smmu-v3 arm-smmu-v3.1.auto:  0x0000000000000000
arm-smmu-v3 arm-smmu-v3.1.auto: event 0x10 received:
arm-smmu-v3 arm-smmu-v3.1.auto:  0x0000790000000010
arm-smmu-v3 arm-smmu-v3.1.auto:  0x0000120800000082
arm-smmu-v3 arm-smmu-v3.1.auto:  0x0000000000000080
arm-smmu-v3 arm-smmu-v3.1.auto:  0x0000000000000000
hisi_hpre 0000:79:00.0: dat_rd_poison_int_set [error status=0x8] found
hisi_hpre 0000:79:00.0: ooo_rdrsp_err_int_set [error status=0xfc00] found
hisi_hpre 0000:79:00.0: Controller resetting...
hisi_hpre 0000:79:00.0: Controller reset complete
{2}[Hardware Error]: Hardware error from APEI Generic Hardware Error Source: 0
{2}[Hardware Error]: event severity: recoverable
{2}[Hardware Error]: Error 0, type: recoverable
{2}[Hardware Error]: section type: unknown, c8b328a8-9917-4af6-9a13-2e08ab2e7586
{2}[Hardware Error]: section length: 0x4c

as we didn't allocate memory for msg->in.

Fixes: c8b4b477079d("crypto: hisilicon - add HiSilicon HPRE accelerator")
Signed-off-by: Meng Yu <yumeng18@huawei.com>
---
 drivers/crypto/hisilicon/hpre/hpre_crypto.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/crypto/hisilicon/hpre/hpre_crypto.c b/drivers/crypto/hisilicon/hpre/hpre_crypto.c
index 0cbe99a1..2d91593 100644
--- a/drivers/crypto/hisilicon/hpre/hpre_crypto.c
+++ b/drivers/crypto/hisilicon/hpre/hpre_crypto.c
@@ -528,6 +528,8 @@ static int hpre_dh_compute_value(struct kpp_request *req)
 		ret = hpre_hw_data_init(hpre_req, req->src, req->src_len, 1, 1);
 		if (unlikely(ret))
 			goto clear_all;
+	} else {
+		msg->in = cpu_to_le64((u64)ctx->dh.dma_g);
 	}
 
 	ret = hpre_hw_data_init(hpre_req, req->dst, req->dst_len, 0, 1);
-- 
2.8.1


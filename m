Return-Path: <SRS0=oEI+=C4=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A2D62C43466
	for <linux-crypto@archiver.kernel.org>; Sat, 19 Sep 2020 03:15:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 71C8B21897
	for <linux-crypto@archiver.kernel.org>; Sat, 19 Sep 2020 03:15:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726054AbgISDP1 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 18 Sep 2020 23:15:27 -0400
Received: from szxga04-in.huawei.com ([45.249.212.190]:13324 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726009AbgISDP0 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 18 Sep 2020 23:15:26 -0400
Received: from DGGEMS401-HUB.china.huawei.com (unknown [172.30.72.59])
        by Forcepoint Email with ESMTP id 3F6BE68532D9EF2F7C2B;
        Sat, 19 Sep 2020 11:15:24 +0800 (CST)
Received: from localhost.localdomain (10.67.165.24) by
 DGGEMS401-HUB.china.huawei.com (10.3.19.201) with Microsoft SMTP Server id
 14.3.487.0; Sat, 19 Sep 2020 11:15:18 +0800
From:   yumeng 00484669 <yumeng18@huawei.com>
To:     <herbert@gondor.apana.org.au>, <davem@davemloft.net>
CC:     <linux-crypto@vger.kernel.org>, <xuzaibo@huawei.com>,
        <wangzhou1@hisilicon.com>, <yumeng18@huawei.com>,
        <linux-kernel@vger.kernel.org>
Subject: [PATCH v2 3/3] crypto: hisilicon/hpre - fix a bug in dh algorithm
Date:   Sat, 19 Sep 2020 11:13:52 +0800
Message-ID: <1600485232-39831-4-git-send-email-yumeng18@huawei.com>
X-Mailer: git-send-email 2.8.1
In-Reply-To: <1600485232-39831-1-git-send-email-yumeng18@huawei.com>
References: <1600485232-39831-1-git-send-email-yumeng18@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.67.165.24]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

From: Meng Yu <yumeng18@huawei.com>

Using 'g' not equal to 2 in dh algorithm may cause an error like this:

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

as we missed initiating 'msg->in'.

Fixes: c8b4b477079d("crypto: hisilicon - add HiSilicon HPRE accelerator")
Signed-off-by: Meng Yu <yumeng18@huawei.com>
Reviewed-by: Zaibo Xu <xuzaibo@huawei.com>
---
 drivers/crypto/hisilicon/hpre/hpre_crypto.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/crypto/hisilicon/hpre/hpre_crypto.c b/drivers/crypto/hisilicon/hpre/hpre_crypto.c
index 8bdaca0..a87f990 100644
--- a/drivers/crypto/hisilicon/hpre/hpre_crypto.c
+++ b/drivers/crypto/hisilicon/hpre/hpre_crypto.c
@@ -528,6 +528,8 @@ static int hpre_dh_compute_value(struct kpp_request *req)
 		ret = hpre_hw_data_init(hpre_req, req->src, req->src_len, 1, 1);
 		if (unlikely(ret))
 			goto clear_all;
+	} else {
+		msg->in = cpu_to_le64(ctx->dh.dma_g);
 	}
 
 	ret = hpre_hw_data_init(hpre_req, req->dst, req->dst_len, 0, 1);
-- 
2.8.1


Return-Path: <SRS0=BuJA=DQ=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E7952C433E7
	for <linux-crypto@archiver.kernel.org>; Fri,  9 Oct 2020 08:24:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A878122251
	for <linux-crypto@archiver.kernel.org>; Fri,  9 Oct 2020 08:24:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732759AbgJIIYG (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 9 Oct 2020 04:24:06 -0400
Received: from lhrrgout.huawei.com ([185.176.76.210]:2966 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1732644AbgJIIYF (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 9 Oct 2020 04:24:05 -0400
Received: from lhreml715-chm.china.huawei.com (unknown [172.18.7.108])
        by Forcepoint Email with ESMTP id 3ED5A84B8FB842474DD8;
        Fri,  9 Oct 2020 09:24:04 +0100 (IST)
Received: from DESKTOP-6T4S3DQ.china.huawei.com (10.47.90.75) by
 lhreml715-chm.china.huawei.com (10.201.108.66) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1913.5; Fri, 9 Oct 2020 09:24:03 +0100
From:   Shiju Jose <shiju.jose@huawei.com>
To:     <herbert@gondor.apana.org.au>, <davem@davemloft.net>,
        <linux-crypto@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC:     <linuxarm@huawei.com>, <wangzhou1@hisilicon.com>,
        <shiju.jose@huawei.com>
Subject: [PATCH 1/1] crypto: hisilicon: Fix doc warnings in sgl.c and qm.c
Date:   Fri, 9 Oct 2020 09:19:38 +0100
Message-ID: <20201009081938.1526-1-shiju.jose@huawei.com>
X-Mailer: git-send-email 2.26.0.windows.1
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.47.90.75]
X-ClientProxiedBy: lhreml721-chm.china.huawei.com (10.201.108.72) To
 lhreml715-chm.china.huawei.com (10.201.108.66)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Fix following warnings caused by mismatch between
function parameters and function comments.

drivers/crypto/hisilicon/sgl.c:256: warning: Excess function parameter 'hw_sgl_dma' description in 'hisi_acc_sg_buf_unmap'
drivers/crypto/hisilicon/sgl.c:256: warning: Excess function parameter 'pool' description in 'hisi_acc_sg_buf_unmap'
drivers/crypto/hisilicon/qm.c:1849: warning: Function parameter or member 'qp' not described in 'qm_drain_qp'
drivers/crypto/hisilicon/qm.c:2420: warning: Function parameter or member 'qm' not described in 'hisi_qm_set_vft'
drivers/crypto/hisilicon/qm.c:2420: warning: Function parameter or member 'fun_num' not described in 'hisi_qm_set_vft'
drivers/crypto/hisilicon/qm.c:2420: warning: Function parameter or member 'base' not described in 'hisi_qm_set_vft'
drivers/crypto/hisilicon/qm.c:2420: warning: Function parameter or member 'number' not described in 'hisi_qm_set_vft'
drivers/crypto/hisilicon/qm.c:2620: warning: Function parameter or member 'qm' not described in 'qm_clear_queues'

Signed-off-by: Shiju Jose <shiju.jose@huawei.com>
Reviewed-by: Zhou Wang <wangzhou1@hisilicon.com>
---
 drivers/crypto/hisilicon/qm.c  | 13 +++++++++++++
 drivers/crypto/hisilicon/sgl.c |  2 --
 2 files changed, 13 insertions(+), 2 deletions(-)

diff --git a/drivers/crypto/hisilicon/qm.c b/drivers/crypto/hisilicon/qm.c
index 530f23116d7c..050fe4e74523 100644
--- a/drivers/crypto/hisilicon/qm.c
+++ b/drivers/crypto/hisilicon/qm.c
@@ -1843,6 +1843,9 @@ int hisi_qm_start_qp(struct hisi_qp *qp, unsigned long arg)
 EXPORT_SYMBOL_GPL(hisi_qm_start_qp);
 
 /**
+ * qm_drain_qp() - Drain a qp.
+ * @qp: The qp we want to drain.
+ *
  * Determine whether the queue is cleared by judging the tail pointers of
  * sq and cq.
  */
@@ -2486,6 +2489,12 @@ int hisi_qm_get_vft(struct hisi_qm *qm, u32 *base, u32 *number)
 EXPORT_SYMBOL_GPL(hisi_qm_get_vft);
 
 /**
+ * hisi_qm_set_vft() - Set vft to a qm.
+ * @qm: The qm we want to set its vft.
+ * @fun_num: The function number.
+ * @base: The base number of queue in vft.
+ * @number: The number of queues in vft.
+ *
  * This function is alway called in PF driver, it is used to assign queues
  * among PF and VFs.
  *
@@ -2690,7 +2699,11 @@ static int qm_stop_started_qp(struct hisi_qm *qm)
 	return 0;
 }
 
+
 /**
+ * qm_clear_queues() - Clear all queues memory in a qm.
+ * @qm: The qm in which the queues will be cleared.
+ *
  * This function clears all queues memory in a qm. Reset of accelerator can
  * use this to clear queues.
  */
diff --git a/drivers/crypto/hisilicon/sgl.c b/drivers/crypto/hisilicon/sgl.c
index 725a739800b0..3bff6394acaf 100644
--- a/drivers/crypto/hisilicon/sgl.c
+++ b/drivers/crypto/hisilicon/sgl.c
@@ -246,8 +246,6 @@ EXPORT_SYMBOL_GPL(hisi_acc_sg_buf_map_to_hw_sgl);
  * @dev: The device which hw sgl belongs to.
  * @sgl: Related scatterlist.
  * @hw_sgl: Virtual address of hw sgl.
- * @hw_sgl_dma: DMA address of hw sgl.
- * @pool: Pool which hw sgl is allocated in.
  *
  * This function unmaps allocated hw sgl.
  */
-- 
2.17.1



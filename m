Return-Path: <SRS0=NifF=5A=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CE56EC1975A
	for <linux-crypto@archiver.kernel.org>; Sun, 15 Mar 2020 02:07:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9A39B2051A
	for <linux-crypto@archiver.kernel.org>; Sun, 15 Mar 2020 02:07:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727360AbgCOCHr (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Sat, 14 Mar 2020 22:07:47 -0400
Received: from szxga05-in.huawei.com ([45.249.212.191]:11694 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727566AbgCOCHq (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Sat, 14 Mar 2020 22:07:46 -0400
Received: from DGGEMS409-HUB.china.huawei.com (unknown [172.30.72.60])
        by Forcepoint Email with ESMTP id 742152EC80E17046A055;
        Sat, 14 Mar 2020 18:19:44 +0800 (CST)
Received: from localhost (10.173.223.234) by DGGEMS409-HUB.china.huawei.com
 (10.3.19.209) with Microsoft SMTP Server id 14.3.487.0; Sat, 14 Mar 2020
 18:19:36 +0800
From:   YueHaibing <yuehaibing@huawei.com>
To:     <ayush.sawal@chelsio.com>, <vinay.yadav@chelsio.com>,
        <rohitm@chelsio.com>, <herbert@gondor.apana.org.au>,
        <davem@davemloft.net>
CC:     <linux-crypto@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        YueHaibing <yuehaibing@huawei.com>
Subject: [PATCH net-next] chcr: remove set but not used variable 'status'
Date:   Sat, 14 Mar 2020 18:19:15 +0800
Message-ID: <20200314101915.25008-1-yuehaibing@huawei.com>
X-Mailer: git-send-email 2.10.2.windows.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.173.223.234]
X-CFilter-Loop: Reflected
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

drivers/crypto/chelsio/chcr_ktls.c: In function chcr_ktls_cpl_set_tcb_rpl:
drivers/crypto/chelsio/chcr_ktls.c:662:11: warning:
 variable status set but not used [-Wunused-but-set-variable]

commit 8a30923e1598 ("cxgb4/chcr: Save tx keys and handle HW response")
involved this unused variable, remove it.

Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: YueHaibing <yuehaibing@huawei.com>
---
 drivers/crypto/chelsio/chcr_ktls.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/crypto/chelsio/chcr_ktls.c b/drivers/crypto/chelsio/chcr_ktls.c
index f0c3834eda4f..00099e793e63 100644
--- a/drivers/crypto/chelsio/chcr_ktls.c
+++ b/drivers/crypto/chelsio/chcr_ktls.c
@@ -659,10 +659,9 @@ int chcr_ktls_cpl_set_tcb_rpl(struct adapter *adap, unsigned char *input)
 	const struct cpl_set_tcb_rpl *p = (void *)input;
 	struct chcr_ktls_info *tx_info = NULL;
 	struct tid_info *t;
-	u32 tid, status;
+	u32 tid;
 
 	tid = GET_TID(p);
-	status = p->status;
 
 	t = &adap->tids;
 	tx_info = lookup_tid(t, tid);
-- 
2.20.1



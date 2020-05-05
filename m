Return-Path: <SRS0=vF1r=6T=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DC0E5C47254
	for <linux-crypto@archiver.kernel.org>; Tue,  5 May 2020 10:08:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B92EE206CC
	for <linux-crypto@archiver.kernel.org>; Tue,  5 May 2020 10:08:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728624AbgEEKIC (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 5 May 2020 06:08:02 -0400
Received: from szxga05-in.huawei.com ([45.249.212.191]:3796 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728600AbgEEKIB (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 5 May 2020 06:08:01 -0400
Received: from DGGEMS408-HUB.china.huawei.com (unknown [172.30.72.59])
        by Forcepoint Email with ESMTP id 00E1E9BE0A6632AAFBDE;
        Tue,  5 May 2020 18:08:00 +0800 (CST)
Received: from localhost.localdomain.localdomain (10.175.113.25) by
 DGGEMS408-HUB.china.huawei.com (10.3.19.208) with Microsoft SMTP Server id
 14.3.487.0; Tue, 5 May 2020 18:07:50 +0800
From:   YueHaibing <yuehaibing@huawei.com>
To:     Herbert Xu <herbert@gondor.apana.org.au>,
        Michal Simek <michal.simek@xilinx.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Rajan Vaja <rajan.vaja@xilinx.com>,
        Kalyani Akula <kalyani.akula@xilinx.com>,
        Jolly Shah <jolly.shah@xilinx.com>
CC:     YueHaibing <yuehaibing@huawei.com>, <linux-crypto@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <kernel-janitors@vger.kernel.org>, Hulk Robot <hulkci@huawei.com>
Subject: [PATCH -next] crypto: xilinx - Remove set but not used variable 'drv_ctx'
Date:   Tue, 5 May 2020 10:12:00 +0000
Message-ID: <20200505101200.195184-1-yuehaibing@huawei.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Type:   text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Originating-IP: [10.175.113.25]
X-CFilter-Loop: Reflected
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Fixes gcc '-Wunused-but-set-variable' warning:

drivers/crypto/xilinx/zynqmp-aes-gcm.c: In function 'zynqmp_aes_aead_cipher':
drivers/crypto/xilinx/zynqmp-aes-gcm.c:83:30: warning:
 variable 'drv_ctx' set but not used [-Wunused-but-set-variable]

commit bc86f9c54616 ("firmware: xilinx: Remove eemi ops for aes engine") left
behind this, remove it.

Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: YueHaibing <yuehaibing@huawei.com>
---
 drivers/crypto/xilinx/zynqmp-aes-gcm.c | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/drivers/crypto/xilinx/zynqmp-aes-gcm.c b/drivers/crypto/xilinx/zynqmp-aes-gcm.c
index d0a0daf3ea08..9a342932b7f3 100644
--- a/drivers/crypto/xilinx/zynqmp-aes-gcm.c
+++ b/drivers/crypto/xilinx/zynqmp-aes-gcm.c
@@ -79,8 +79,6 @@ static int zynqmp_aes_aead_cipher(struct aead_request *req)
 	struct zynqmp_aead_tfm_ctx *tfm_ctx = crypto_aead_ctx(aead);
 	struct zynqmp_aead_req_ctx *rq_ctx = aead_request_ctx(req);
 	struct device *dev = tfm_ctx->dev;
-	struct aead_alg *alg = crypto_aead_alg(aead);
-	struct zynqmp_aead_drv_ctx *drv_ctx;
 	struct zynqmp_aead_hw_req *hwreq;
 	dma_addr_t dma_addr_data, dma_addr_hw_req;
 	unsigned int data_size;
@@ -89,8 +87,6 @@ static int zynqmp_aes_aead_cipher(struct aead_request *req)
 	char *kbuf;
 	int err;
 
-	drv_ctx = container_of(alg, struct zynqmp_aead_drv_ctx, alg.aead);
-
 	if (tfm_ctx->keysrc == ZYNQMP_AES_KUP_KEY)
 		dma_size = req->cryptlen + ZYNQMP_AES_KEY_SIZE
 			   + GCM_AES_IV_SIZE;




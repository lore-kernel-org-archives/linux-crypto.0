Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D0888EE6447
	for <linux-crypto@archiver.kernel.org>; Fri, 15 Sep 2023 09:16:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233434AbjIOJQv (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 15 Sep 2023 05:16:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52340 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233351AbjIOJQu (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 15 Sep 2023 05:16:50 -0400
Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A996A9B;
        Fri, 15 Sep 2023 02:16:45 -0700 (PDT)
Received: from kwepemm600018.china.huawei.com (unknown [172.30.72.56])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4Rn7mz3K74zrSlD;
        Fri, 15 Sep 2023 17:14:43 +0800 (CST)
Received: from localhost.localdomain (10.69.192.56) by
 kwepemm600018.china.huawei.com (7.193.23.140) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.31; Fri, 15 Sep 2023 17:16:43 +0800
From:   Wenkai Lin <linwenkai6@hisilicon.com>
To:     <herbert@gondor.apana.org.au>
CC:     <linux-kernel@vger.kernel.org>, <linux-crypto@vger.kernel.org>,
        <liulongfang@huawei.com>
Subject: [PATCH] crypto: hisilicon/sec - fix for sgl unmmap problem
Date:   Fri, 15 Sep 2023 17:13:29 +0800
Message-ID: <20230915091329.31708-1-linwenkai6@hisilicon.com>
X-Mailer: git-send-email 2.33.0
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.69.192.56]
X-ClientProxiedBy: dggems704-chm.china.huawei.com (10.3.19.181) To
 kwepemm600018.china.huawei.com (7.193.23.140)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

When sec_aead_mac_init returns an error code, sec_cipher_map
will exit abnormally, the hardware sgl should be unmmaped.

Signed-off-by: Wenkai Lin <linwenkai6@hisilicon.com>
---
 drivers/crypto/hisilicon/sec2/sec_crypto.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/crypto/hisilicon/sec2/sec_crypto.c b/drivers/crypto/hisilicon/sec2/sec_crypto.c
index 074e50ef5..ed77711e8 100644
--- a/drivers/crypto/hisilicon/sec2/sec_crypto.c
+++ b/drivers/crypto/hisilicon/sec2/sec_crypto.c
@@ -1011,6 +1011,7 @@ static int sec_cipher_map(struct sec_ctx *ctx, struct sec_req *req,
 		ret = sec_aead_mac_init(a_req);
 		if (unlikely(ret)) {
 			dev_err(dev, "fail to init mac data for ICV!\n");
+			hisi_acc_sg_buf_unmap(dev, src, req->in);
 			return ret;
 		}
 	}
-- 
2.30.0


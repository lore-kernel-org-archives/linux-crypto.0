Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6017BC433DB
	for <linux-crypto@archiver.kernel.org>; Wed, 10 Feb 2021 07:38:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 21FAF64E3B
	for <linux-crypto@archiver.kernel.org>; Wed, 10 Feb 2021 07:38:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232537AbhBJHiE (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 10 Feb 2021 02:38:04 -0500
Received: from szxga06-in.huawei.com ([45.249.212.32]:12904 "EHLO
        szxga06-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232478AbhBJHiD (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 10 Feb 2021 02:38:03 -0500
Received: from DGGEMS404-HUB.china.huawei.com (unknown [172.30.72.58])
        by szxga06-in.huawei.com (SkyGuard) with ESMTP id 4DbBQ26cQCzjKgL
        for <linux-crypto@vger.kernel.org>; Wed, 10 Feb 2021 15:35:54 +0800 (CST)
Received: from localhost.localdomain (10.175.102.38) by
 DGGEMS404-HUB.china.huawei.com (10.3.19.204) with Microsoft SMTP Server id
 14.3.498.0; Wed, 10 Feb 2021 15:36:54 +0800
From:   Wei Yongjun <weiyongjun1@huawei.com>
To:     Hulk Robot <hulkci@huawei.com>,
        Daniele Alessandrelli <daniele.alessandrelli@intel.com>,
        Mike Healy <mikex.healy@intel.com>,
        Herbert Xu <herbert@gondor.apana.org.au>
CC:     Wei Yongjun <weiyongjun1@huawei.com>,
        <linux-crypto@vger.kernel.org>
Subject: [PATCH -next] crypto: keembay-ocs-aes - Fix error return code in kmb_ocs_aes_probe()
Date:   Wed, 10 Feb 2021 07:45:27 +0000
Message-ID: <20210210074527.867400-1-weiyongjun1@huawei.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Type:   text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Originating-IP: [10.175.102.38]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Fix to return negative error code -ENOMEM from the error handling
case instead of 0, as done elsewhere in this function.

Fixes: 885743324513 ("crypto: keembay - Add support for Keem Bay OCS AES/SM4")
Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: Wei Yongjun <weiyongjun1@huawei.com>
---
 drivers/crypto/keembay/keembay-ocs-aes-core.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/crypto/keembay/keembay-ocs-aes-core.c b/drivers/crypto/keembay/keembay-ocs-aes-core.c
index b6b25d994af3..2ef312866338 100644
--- a/drivers/crypto/keembay/keembay-ocs-aes-core.c
+++ b/drivers/crypto/keembay/keembay-ocs-aes-core.c
@@ -1649,8 +1649,10 @@ static int kmb_ocs_aes_probe(struct platform_device *pdev)
 
 	/* Initialize crypto engine */
 	aes_dev->engine = crypto_engine_alloc_init(dev, true);
-	if (!aes_dev->engine)
+	if (!aes_dev->engine) {
+		rc = -ENOMEM;
 		goto list_del;
+	}
 
 	rc = crypto_engine_start(aes_dev->engine);
 	if (rc) {

